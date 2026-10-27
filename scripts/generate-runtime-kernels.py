#!/usr/bin/env python3
"""Independent high-precision compositions and integer comparison intervals."""
from phi_common import RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
import hashlib,json,math,pathlib,random,struct
from fractions import Fraction
from mpfr_oracle import Number,value,version
root=pathlib.Path(__file__).resolve().parents[1];rng=random.Random(0x524d534e)
def bits(x,w):return int.from_bytes(struct.pack('<f' if w==32 else '<d',x),'little')
def reference(op,x,p,w,precision):
    def num(v):return Number(precision,v)
    def unary(op,a):return num(0).op(op,a)
    def binary(op,a,b):return num(0).op(op,a,b)
    xs=[num(v) for v in x];one=num(1);two=num(2);half=num(.5);zero=num(0)
    if op==0:
        ys=[binary('div',a,binary('add',one,unary('exp',unary('neg',a)))) for a in xs]
    elif op==1:
        scale=unary('sqrt',two)
        ys=[binary('mul',binary('mul',half,a),unary('erfc',unary('neg',binary('div',a,scale)))) for a in xs]
    elif op==2:
        maximum=num(max(x));terms=[unary('exp',binary('sub',a,maximum)) for a in xs];total=num(0)
        for a in terms:total.op('add',total,a)
        ys=[binary('div',a,total) for a in terms]
    elif op==3:
        total=num(0)
        for a in xs:total.op('add',total,binary('mul',a,a))
        scale=unary('sqrt',binary('add',binary('div',total,num(len(x))),num(p)))
        ys=[binary('div',a,scale) for a in xs]
    else:
        s=unary('sin',num(p));c=unary('cos',num(p));ys=[]
        for a,b in zip(xs[::2],xs[1::2]):
            ys += [binary('sub',binary('mul',a,c),binary('mul',b,s)),binary('add',binary('mul',a,s),binary('mul',b,c))]
    return [a.bits(w) for a in ys]
def key(b,w):
    sign=1<<(w-1);return ((~b)&((1<<w)-1)) if b&sign else b|sign
def unkey(k,w):
    sign=1<<(w-1);return k&~sign if k&sign else (~k)&((1<<w)-1)
def endpoint(q,w,upper):
    b=bits(float(q),w);k=key(b,w)
    # Outward rounding, including binary32 conversion and host double rounding.
    while (Fraction(value(unkey(k,w),w))<q if upper else Fraction(value(unkey(k,w),w))>q):k+=1 if upper else -1
    return unkey(k,w)
lines=['/* MPFR composition references; bounds computed on host with rational arithmetic. */','static const struct kernel_case kernel_cases[]={'];counts={};lanes=0
for w in [32,64]:
    for op,name in enumerate(['silu','gelu','softmax','rmsnorm','rope']):
        count=0
        for n in [2,4,8,16,32]:
            for row in range(24):
                if row==0:x=[0.0]*n
                elif row==1:x=[(-1)**i*1e-20 for i in range(n)]
                elif row==2:x=[-1000.0 if i%2 else 1000.0 for i in range(n)]
                elif row==3:x=[1.0]*n
                elif row==4:x=[(-1)**i*24.0 for i in range(n)]
                else:x=[rng.uniform(-24,24) for i in range(n)]
                x=[value(bits(v,w),w) for v in x]
                p=value(bits(1e-5,w),w) if op!=4 else [0.0,-0.0,math.pi/2,1e20,-1e20,1e30,1e100 if w==64 else 1e35][row%7]
                p=value(bits(p,w),w)
                a=reference(op,x,p,w,192);b=reference(op,x,p,w,320);assert a==b,(w,name,n,row)
                atol,rtol=(Fraction(1,10**7),Fraction(3,10**6)) if w==32 else (Fraction(1,10**15),Fraction(2,10**14))
                lows=[];highs=[]
                for lane,ref in enumerate(b):
                    v=Fraction(value(ref,w));margin=atol+rtol*abs(v)
                    # A rotation can nearly cancel two large terms. Bound its
                    # propagated trig/product error by operand magnitudes,
                    # rather than assigning a relative error to a tiny output.
                    if op==4:
                        unit_roundoff=Fraction(1,2**(24 if w==32 else 53))
                        pair=lane//2*2
                        margin+=16*unit_roundoff*(abs(Fraction(x[pair]))+abs(Fraction(x[pair+1])))
                    lows.append(endpoint(v-margin,w,False));highs.append(endpoint(v+margin,w,True))
                arr=lambda vs:'{'+','.join('UINT64_C(0x%x)'%v for v in vs)+'}'
                lines.append('{%d,%d,%d,UINT64_C(0x%x),%s,%s,%s},'%(op,w,n,bits(p,w),arr([bits(v,w) for v in x]),arr(lows),arr(highs)))
                count+=1;lanes+=n
        counts[f'{name}{w}']=count
lines.append('};');path=root/'tests/runtime-kernel-corpus.h';path.write_text('\n'.join(lines)+'\n')
(RECORDS/'runtime-kernel-oracle.json').write_text(json.dumps({'library':'MPFR '+version,'precisions_bits':[192,320],'cases':counts,'output_lanes':lanes,'widths':[2,4,8,16,32],'domains':'Finite inputs |x|<=1000; positive RMS epsilon is target-rounded 1e-5; RoPE finite angles through 1e35 (f32) and 1e100 (f64)','accuracy':'outward integer bounds about rounded high-precision result: f32 absolute 1e-7 + relative 3e-6; f64 absolute 1e-15 + relative 2e-14. RoPE adds 16*u*(|a|+|b|), u=2^-24 or 2^-53, to cover cancellation in a two-term rotation.','corpus_sha256':hashlib.sha256(path.read_bytes()).hexdigest()},indent=2)+'\n')
print('Generated',sum(counts.values()),'composed kernel cases;',lanes,'output lanes')
