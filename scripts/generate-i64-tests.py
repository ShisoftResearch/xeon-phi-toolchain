#!/usr/bin/env python3
from pathlib import Path
root=Path(__file__).resolve().parents[1]
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; CHECK-LABEL: i64_add:
; CHECK: knc.vpaddd
; CHECK-LABEL: i64_mul:
; CHECK: knc.vpmulhud
; CHECK-LABEL: i64_ashr:
; CHECK: knc.vpsravd
 target triple = "x86_64-unknown-linux-gnu"
'''
ops=['add','mul','sub','and','or','xor','shl','lshr','ashr','smin','smax','umin','umax']
for op in ops:
 s+=f'define void @i64_{op}(ptr %o,ptr %a,ptr %b) {{\n %x=load <8 x i64>,ptr %a,align 8\n %y=load <8 x i64>,ptr %b,align 8\n'
 if op in ['smin','smax','umin','umax']:
  s+=f' %r=call <8 x i64> @llvm.{op}.v8i64(<8 x i64> %x,<8 x i64> %y)\n'
 else:s+=f' %r={op} <8 x i64> %x,%y\n'
 s+=' store <8 x i64> %r,ptr %o,align 8\n ret void\n}\n'
 if op in ['smin','smax','umin','umax']:s+=f'declare <8 x i64> @llvm.{op}.v8i64(<8 x i64>,<8 x i64>)\n'
for cc in ['eq','ne','slt','sle','sgt','sge','ult','ule','ugt','uge']:
 s+=f'define void @i64_cmp_{cc}(ptr %o,ptr %a,ptr %b) {{\n %x=load <8 x i64>,ptr %a,align 8\n %y=load <8 x i64>,ptr %b,align 8\n %c=icmp {cc} <8 x i64> %x,%y\n %r=sext <8 x i1> %c to <8 x i64>\n store <8 x i64> %r,ptr %o,align 8\n ret void\n}}\n'
s+='''define void @i64_select(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp slt <8 x i64> %x,%y
 %r=select <8 x i1> %c,<8 x i64> %x,<8 x i64> %y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
'''
for op in ['add','mul','and','or','xor','smin','smax','umin','umax']:
 s+=f'define i64 @i64_reduce_{op}(ptr %a) {{\n %v=load <8 x i64>,ptr %a,align 8\n %r=call i64 @llvm.vector.reduce.{op}.v8i64(<8 x i64> %v)\n ret i64 %r\n}}\ndeclare i64 @llvm.vector.reduce.{op}.v8i64(<8 x i64>)\n'
s+='''define i64 @i64_extract(ptr %a,i64 %i){
 %v=load <8 x i64>,ptr %a,align 8
 %r=extractelement <8 x i64> %v,i64 %i
 ret i64 %r
}
define void @i64_insert(ptr %o,ptr %a,i64 %i,i64 %x){
 %v=load <8 x i64>,ptr %a,align 8
 %r=insertelement <8 x i64> %v,i64 %x,i64 %i
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_shuffle(ptr %o,ptr %a,ptr %b){
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=shufflevector <8 x i64> %x,<8 x i64> %y,<8 x i32> <i32 7,i32 9,i32 5,i32 11,i32 3,i32 13,i32 1,i32 15>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
declare void @i64_clobber(ptr)
define void @i64_spills(ptr %o,ptr %a){
'''
for i in range(40):s+=f' %p{i}=getelementptr i8,ptr %a,i64 {i*64}\n %v{i}=load <8 x i64>,ptr %p{i},align 8\n'
s+=' call void @i64_clobber(ptr %o)\n'
for i in range(40):s+=f' %q{i}=getelementptr i8,ptr %o,i64 {i*64}\n store <8 x i64> %v{i},ptr %q{i},align 8\n'
s+=' ret void\n}\n'
# Native LLVM vector calls include two stack-passed vectors.
args=','.join(f'<8 x i64> %x{i}' for i in range(10))
s+=f'define <8 x i64> @i64_abi_sum({args}) noinline {{\n'
for i in range(1,10):s+=f' %s{i}=add <8 x i64> '+('%x0' if i==1 else f'%s{i-1}')+f',%x{i}\n'
s+=' ret <8 x i64> %s9\n}\n'
s+='define void @i64_abi_call(ptr %o,ptr %a) {\n'
for i in range(10):s+=f' %p{i}=getelementptr i8,ptr %a,i64 {i*64}\n %v{i}=load <8 x i64>,ptr %p{i},align 8\n'
s+=' %r=call <8 x i64> @i64_abi_sum('+','.join(f'<8 x i64> %v{i}' for i in range(10))+')\n store <8 x i64> %r,ptr %o,align 8\n ret void\n}\n'
s+='declare void @scalar_clobber'+(root/'tests/knc-scalar-spills.ll').read_text().split('declare void @scalar_clobber',1)[1]
(root/'tests/knc-i64.ll').write_text(s)
