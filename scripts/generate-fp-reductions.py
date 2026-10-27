#!/usr/bin/env python3
"""Independent exact sequential and error-bounded reassociated reduction oracles.

Semantics: pinned llvm/docs/LangRef.md, vector.reduce.{fadd,fmul,fmin,fmax,
fminimum,fmaximum}. Signaling NaNs are excluded from numeric min/max cases
because their reduction order permits multiple results.
"""
from pathlib import Path
from fractions import Fraction
import random
from ieee_oracle import decode,round_bits
root=Path(__file__).resolve().parents[1];rng=random.Random(0xfeed32f64)
ops=['ordered_add','reassoc_add','ordered_mul','reassoc_mul','fmin','fmax','fminimum','fmaximum']
ir='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
'''
decls=set();header='/* Generated FP reduction matrix. */\n';corpus='/* Exact rational sequential results and conservative reassociation bounds. */\n'
def key(x,w):return (~x)&((1<<w)-1) if x>>(w-1) else x|(1<<(w-1))
def arith(a,b,w,mul):
 sa,ta,va=decode(a,w);sb,tb,vb=decode(b,w);f,e=(23,8) if w==32 else (52,11);inf=((1<<e)-1)<<f;nan=inf|(1<<(f-1))
 if ta=='nan' or tb=='nan':return nan
 if mul:
  sign=sa^sb
  if (ta=='inf' and tb=='finite' and vb==0) or (tb=='inf' and ta=='finite' and va==0):return nan
  if ta=='inf' or tb=='inf':return (sign<<(w-1))|inf
  return round_bits(va*vb,w,sign)
 if ta=='inf' and tb=='inf' and sa!=sb:return nan
 if ta=='inf':return a
 if tb=='inf':return b
 return round_bits(va+vb,w,int(va==0 and vb==0 and sa and sb))
for w,ty in [(32,'float'),(64,'double')]:
 f,e=(23,8) if w==32 else (52,11);inf=((1<<e)-1)<<f;nan=inf|(1<<(f-1));sign=1<<(w-1)
 edge=[0,sign,1,sign|1,(1<<f)-1,1<<f,inf-1,sign|inf,inf,nan,nan|sign,inf+1,round_bits(Fraction(1),w),round_bits(Fraction(-1),w)]
 for n in [2,4,8,16,32]:
  for op in ops:
   name=f'reduce_{op}_{n}_f{w}';vt=f'<{n} x {ty}>';suf=f'v{n}f{w}'
   ir+=f'define void @{name}(ptr %out,ptr %in,ptr %init) {{\n %x=load {vt},ptr %in,align 1\n'
   if op.startswith(('ordered','reassoc')):
    intrinsic='fadd' if op.endswith('add') else 'fmul';flag='reassoc ' if op.startswith('reassoc') else ''
    ir+=f' %start=load {ty},ptr %init,align 1\n %r=call {flag}{ty} @llvm.vector.reduce.{intrinsic}.{suf}({ty} %start,{vt} %x)\n'
    decls.add(f'declare {ty} @llvm.vector.reduce.{intrinsic}.{suf}({ty},{vt})\n')
   else:
    ir+=f' %r=call {ty} @llvm.vector.reduce.{op}.{suf}({vt} %x)\n';decls.add(f'declare {ty} @llvm.vector.reduce.{op}.{suf}({vt})\n')
   ir+=f' store {ty} %r,ptr %out,align 1\n ret void\n}}\n'
   header+=f'K({name},{n},{w},data_{name})\n';rows=[]
   for case in range(128):
    start=round_bits(Fraction(1 if op.endswith('mul') else 0),w)
    if op.startswith('reassoc'):
     if op.endswith('mul'):values=[round_bits(Fraction(rng.choice([-1,1])*rng.randint(512,2048),1024),w) for _ in range(n)]
     else:values=[round_bits(Fraction(rng.randint(-2048,2048),1024)*(Fraction(2)**rng.randint(-30,30)),w) for _ in range(n)]
     vals=[decode(x,w)[2] for x in [start,*values]]
     if op.endswith('mul'):
      exact=Fraction(1)
      for v in vals:exact*=v
      scale=abs(exact)
     else:exact=sum(vals);scale=sum(abs(v) for v in vals)
     u=Fraction(1,1<<(f+1));gamma=n*u/(1-n*u);bound=gamma*scale
     low,high=exact-bound,exact+bound
     lbits,hbits=round_bits(low,w),round_bits(high,w)
     lo=key(lbits,w)-(decode(lbits,w)[2]>low);hi=key(hbits,w)+(decode(hbits,w)[2]<high);isnan=0
    else:
     values=[edge[(case+i*3)%len(edge)] if case<32 else rng.getrandbits(w) for i in range(n)]
     if op in ('fmin','fmax'):
      values=[x|(1<<(f-1)) if decode(x,w)[1]=='nan' else x for x in values]
     if op.startswith('ordered'):
      if case<32:start=edge[(case*3)%len(edge)]
      # Deliberately distinguish sequential evaluation from reassociation.
      # Random encodings alone frequently collapse to NaN/overflow and can
      # conceal an accidentally balanced tree in an ordered reduction.
      if case==0:
       if op.endswith('add'):
        big=Fraction(2)**(f+3);start=round_bits(big,w)
        values=[round_bits(-big,w),round_bits(Fraction(1),w)]+[0]*(n-2)
       else:
        power=80 if w==32 else 600
        start=round_bits(Fraction(2)**-power,w)
        values=[round_bits(Fraction(2)**power,w)]*2+[round_bits(Fraction(1),w)]*(n-2)
      elif case==1:
       start=sign
       values=[sign]*n if op.endswith('add') else [round_bits(Fraction(1),w)]*n
      elif case==2 and op.endswith('add'):
       start=round_bits(Fraction(1),w)
       values=[round_bits(Fraction(1,1<<(f+1)),w)]*n
      result=start
      for v in values:result=arith(result,v,w,op.endswith('mul'))
     else:
      nums=[v for v in values if decode(v,w)[1]!='nan']
      propagate=op in ('fminimum','fmaximum') and len(nums)!=len(values)
      result=nan if propagate or not nums else (min if op in ('fmin','fminimum') else max)(nums,key=lambda x:key(x,w))
     isnan=int(decode(result,w)[1]=='nan');lo=hi=key(result,w)
    rows.append((start,values,lo,hi,isnan))
   corpus+=f'static const struct fp_case data_{name}[]={{\n'
   for start,values,lo,hi,isnan in rows:
    corpus+='{UINT64_C(0x%x),{%s},UINT64_C(0x%x),UINT64_C(0x%x),%d},\n'%(start,','.join(f'UINT64_C(0x{x:x})' for x in values),lo,hi,isnan)
   corpus+='};\n'
ir+=''.join(sorted(decls))
(root/'tests/knc-fp-reductions.ll').write_text(ir)
(root/'tests/fp-reduction-cases.h').write_text(header)
(root/'tests/fp-reduction-corpus.h').write_text(corpus)
