#!/usr/bin/env python3
"""Internal LLVM ABI matrix: mixed register banks, hidden returns and spills."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
declare void @abi_clobber(ptr,ptr,i64)
'''
h='/* Generated internal vector ABI matrix. */\n'
for width in [16,32,64]:
 for tag,bits,ty in [('i8',8,'i8'),('i16',16,'i16'),('i32',32,'i32'),('i64',64,'i64'),('f32',32,'float'),('f64',64,'double')]:
  n=width*8//bits;vt=f'<{n} x {ty}>';it=f'<{n} x i{bits}>';base=f'{tag}_{width}'
  # Twelve vectors interleave integer and FP scalar arguments. This exceeds
  # both register banks and checks stack arguments after 64-byte alignment.
  args=['ptr %audit'];callargs=['ptr %audit']
  for i in range(12):args += [f'{vt} %v{i}',f'i64 %i{i}',f'double %f{i}'];callargs += [f'{vt} %v{i}',f'i64 %i{i}',f'double %f{i}']
  s+=f'define internal {vt} @mix_callee_{base}('+','.join(args)+') #0 {\n'
  for i in range(12):s+=f' %b{i}=bitcast {vt} %v{i} to {it}\n %fb{i}=bitcast double %f{i} to i64\n'
  vec='b0';integ='i0';fp='fb0'
  for i in range(1,12):
   s+=f' %vx{i}=xor {it} %{vec},%b{i}\n %is{i}=add i64 %{integ},%i{i}\n %fx{i}=xor i64 %{fp},%fb{i}\n';vec=f'vx{i}';integ=f'is{i}';fp=f'fx{i}'
  s+=f' store i64 %{integ},ptr %audit,align 1\n %ap=getelementptr i8,ptr %audit,i64 8\n store i64 %{fp},ptr %ap,align 1\n %result=bitcast {it} %{vec} to {vt}\n ret {vt} %result\n}}\n'
  name=f'abi_mix_{base}';s+=f'define void @{name}(ptr %out,ptr %in) {{\n'
  for i in range(12):
   s+=f' %vp{i}=getelementptr i8,ptr %in,i64 {i*width}\n %v{i}=load {vt},ptr %vp{i},align 1\n %ip{i}=getelementptr i8,ptr %in,i64 {12*width+i*8}\n %i{i}=load i64,ptr %ip{i},align 1\n %fp{i}=getelementptr i8,ptr %in,i64 {12*width+96+i*8}\n %f{i}=load double,ptr %fp{i},align 1\n'
  s+=f' %audit=getelementptr i8,ptr %out,i64 {width}\n %result=call {vt} @mix_callee_{base}('+','.join(callargs)+f')\n store {vt} %result,ptr %out,align 1\n ret void\n}}\n'
  h+=f'K({name},0,{width},{12*width+192},{width+16})\n'
  # Three vectors plus scalar fields force an aggregate return beyond the
  # native two-vector return bank. Return vectors in a non-identity order.
  ret='{'+','.join([vt,vt,vt,'i64','double'])+'}'
  s+=f'define internal {ret} @aggregate_callee_{base}({vt} %a,{vt} %b,{vt} %c,i64 %i,double %f) #0 {{\n'
  s+=f' %r0=insertvalue {ret} poison,{vt} %c,0\n %r1=insertvalue {ret} %r0,{vt} %a,1\n %r2=insertvalue {ret} %r1,{vt} %b,2\n %r3=insertvalue {ret} %r2,i64 %i,3\n %r4=insertvalue {ret} %r3,double %f,4\n ret {ret} %r4\n}}\n'
  name=f'abi_aggregate_{base}';s+=f'define void @{name}(ptr %out,ptr %in) {{\n'
  for i in range(3):s+=f' %p{i}=getelementptr i8,ptr %in,i64 {i*width}\n %v{i}=load {vt},ptr %p{i},align 1\n'
  s+=f' %ip=getelementptr i8,ptr %in,i64 {3*width}\n %i=load i64,ptr %ip,align 1\n %fp=getelementptr i8,ptr %in,i64 {3*width+8}\n %f=load double,ptr %fp,align 1\n %result=call {ret} @aggregate_callee_{base}({vt} %v0,{vt} %v1,{vt} %v2,i64 %i,double %f)\n'
  for i in range(3):s+=f' %o{i}=getelementptr i8,ptr %out,i64 {i*width}\n %r{i}=extractvalue {ret} %result,{i}\n store {vt} %r{i},ptr %o{i},align 1\n'
  s+=f' %oi=getelementptr i8,ptr %out,i64 {3*width}\n %ri=extractvalue {ret} %result,3\n store i64 %ri,ptr %oi,align 1\n %of=getelementptr i8,ptr %out,i64 {3*width+8}\n %rf=extractvalue {ret} %result,4\n store double %rf,ptr %of,align 1\n ret void\n}}\n'
  h+=f'K({name},1,{width},{3*width+16},{3*width+16})\n'
  name=f'abi_spills_{base}';s+=f'define void @{name}(ptr %out,ptr %in) {{\n'
  for i in range(40):s+=f' %p{i}=getelementptr i8,ptr %in,i64 {i*width}\n %v{i}=load {vt},ptr %p{i},align 1\n'
  s+=f' call void @abi_clobber(ptr %out,ptr %in,i64 {40*width})\n'
  for i in range(40):s+=f' %o{i}=getelementptr i8,ptr %out,i64 {i*width}\n store {vt} %v{i},ptr %o{i},align 1\n'
  s+=' ret void\n}\n';h+=f'K({name},2,{width},{40*width},{40*width})\n'
s+='attributes #0 = { noinline optnone }\n'
(r/'tests/knc-vector-abi-matrix.ll').write_text(s)
(r/'tests/vector-abi-cases.h').write_text(h)
print('Generated',h.count('K('),'vector ABI kernels')
