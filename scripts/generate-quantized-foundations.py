#!/usr/bin/env python3
"""Generic LLVM widening/packing/dot operations with explicit wrap/saturation."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
'''
h='/* Generated quantized structured-operation matrix. */\n';decls=set()
ops=['extend_s','extend_u','truncate','pack_ss','pack_su','pack_uu','madd_i16','maddubs_sat','dpbusd','dpbssd','dpbusds','dpwssd','dpwssds']
def emit(name,op,src,dst,n,ab,bb,cb,ob,body):
 global s,h
 s+=f'define void @{name}(ptr %out,ptr %a,ptr %b,ptr %c) {{\n'+body+' ret void\n}\n'
 h+=f'K({name},{ops.index(op)},{src},{dst},{n},{ab},{bb},{cb},{ob})\n'
def clamp(var,n,w,lo,hi,signed):
 global decls
 v=f'<{n} x i{w}>';a='smax' if signed else 'umax';b='smin' if signed else 'umin'
 decls|={f'declare {v} @llvm.{a}.v{n}i{w}({v},{v})\n',f'declare {v} @llvm.{b}.v{n}i{w}({v},{v})\n'}
 return f' %{var}lo=call {v} @llvm.{a}.v{n}i{w}({v} %{var},{v} splat (i{w} {lo}))\n %{var}clip=call {v} @llvm.{b}.v{n}i{w}({v} %{var}lo,{v} splat (i{w} {hi}))\n'
for src,dst in [(8,16),(8,32),(8,64),(16,32),(16,64),(32,64)]:
 for n in [2,4,8,16,32]:
  for sign in ['s','u']:
   name=f'q_extend_{sign}_{src}_{dst}_{n}';body=f' %x=load <{n} x i{src}>,ptr %a,align 1\n %y={"sext" if sign=="s" else "zext"} <{n} x i{src}> %x to <{n} x i{dst}>\n store <{n} x i{dst}> %y,ptr %out,align 1\n'
   emit(name,'extend_'+sign,src,dst,n,n*src//8,0,0,n*dst//8,body)
for src,dst in [(16,8),(32,8),(32,16),(64,8),(64,16),(64,32)]:
 for n in [2,4,8,16,32]:
  name=f'q_truncate_{src}_{dst}_{n}';body=f' %x=load <{n} x i{src}>,ptr %a,align 1\n %y=trunc <{n} x i{src}> %x to <{n} x i{dst}>\n store <{n} x i{dst}> %y,ptr %out,align 1\n'
  emit(name,'truncate',src,dst,n,n*src//8,0,0,n*dst//8,body)
for width in [16,32,64]:
 for src,dst in [(16,8),(32,16)]:
  n=width*8//src;v=f'<{n} x i{src}>';out=f'<{2*n} x i{dst}>'
  for kind in ['ss','su','uu']:
   name=f'q_pack_{kind}_{src}_{dst}_{width}'
   lo=-(1<<(dst-1)) if kind=='ss' else 0;hi=(1<<(dst-1))-1 if kind=='ss' else (1<<dst)-1
   body=f' %x=load {v},ptr %a,align 1\n %y=load {v},ptr %b,align 1\n'
   body+=clamp('x',n,src,lo,hi,kind!='uu')+clamp('y',n,src,lo,hi,kind!='uu')
   body+=f' %xt=trunc {v} %xclip to <{n} x i{dst}>\n %yt=trunc {v} %yclip to <{n} x i{dst}>\n'
   lanes=128//src;indices=[]
   for block in range(width//16):indices += [block*lanes+i for i in range(lanes)]+[n+block*lanes+i for i in range(lanes)]
   body+=f' %r=shufflevector <{n} x i{dst}> %xt,<{n} x i{dst}> %yt,<{2*n} x i32> <'+','.join('i32 '+str(i) for i in indices)+f'>\n store {out} %r,ptr %out,align 1\n'
   emit(name,'pack_'+kind,src,dst,n,width,width,0,width,body)
 for op in ops[6:]:
  src=16 if op in ['madd_i16','dpwssd','dpwssds'] else 8
  n=width*8//src;groups=2 if src==16 or op=='maddubs_sat' else 4;count=n//groups
  calc=64 if op=='dpwssds' else 32;sv=f'<{n} x i{src}>';cv=f'<{n} x i{calc}>';rv=f'<{count} x i{calc}>'
  body=f' %x=load {sv},ptr %a,align 1\n %y=load {sv},ptr %b,align 1\n'
  body+=f' %xe={"zext" if op in ["maddubs_sat","dpbusd","dpbusds"] else "sext"} {sv} %x to {cv}\n %ye=sext {sv} %y to {cv}\n %p=mul {cv} %xe,%ye\n'
  for j in range(groups):
   body+=f' %p{j}=shufflevector {cv} %p,{cv} poison,<{count} x i32> <'+','.join('i32 '+str(i*groups+j) for i in range(count))+'>\n'
  body+=f' %sum1=add {rv} %p0,%p1\n';acc='sum1'
  for j in range(2,groups):body+=f' %sum{j}=add {rv} %{acc},%p{j}\n';acc=f'sum{j}'
  if op.startswith('dp'):
   body+=f' %old=load <{count} x i32>,ptr %c,align 1\n'
   if calc==64:body+=f' %oldwide=sext <{count} x i32> %old to {rv}\n'
   old='oldwide' if calc==64 else 'old'
   if op=='dpbusds':
    decls.add(f'declare {rv} @llvm.sadd.sat.v{count}i32({rv},{rv})\n');body+=f' %acc=call {rv} @llvm.sadd.sat.v{count}i32({rv} %{acc},{rv} %{old})\n'
   else:body+=f' %acc=add {rv} %{acc},%{old}\n'
   acc='acc'
  dst=16 if op=='maddubs_sat' else 32
  if op in ['maddubs_sat','dpwssds']:
   body+=clamp(acc,count,calc,-(1<<(dst-1)),(1<<(dst-1))-1,True);acc+='clip'
  if calc!=dst:body+=f' %result=trunc {rv} %{acc} to <{count} x i{dst}>\n';acc='result'
  body+=f' store <{count} x i{dst}> %{acc},ptr %out,align 1\n'
  emit(f'q_{op}_{width}',op,src,dst,count,width,width,width if op.startswith('dp') else 0,width,body)
s+=''.join(sorted(decls))
(r/'tests/knc-quantized-foundations.ll').write_text(s)
(r/'tests/quantized-foundation-cases.h').write_text(h)
(r/'tests/quantized-foundation-ops.h').write_text('/* Generated operation IDs. */\n'+''.join(f'#define Q_{op.upper()} {i}\n' for i,op in enumerate(ops)))
print('Generated',h.count('K('),'quantized foundation kernels')
