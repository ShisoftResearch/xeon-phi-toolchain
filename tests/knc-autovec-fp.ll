; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes='default<O3>' -S < %s | llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs | FileCheck %s
; CHECK-LABEL: float_affine:
; CHECK: knc.vmulps
; CHECK: knc.vaddps
; CHECK-LABEL: float_dot:
; CHECK: knc.vmulps
; CHECK: knc.vaddps
target triple = "x86_64-unknown-linux-gnu"
define void @float_affine(ptr noalias %o,ptr noalias %a,ptr noalias %b,i64 %n,float %scale) {
entry:
 %empty=icmp eq i64 %n,0
 br i1 %empty,label %exit,label %loop
loop:
 %i=phi i64 [0,%entry],[%next,%loop]
 %ap=getelementptr float,ptr %a,i64 %i
 %bp=getelementptr float,ptr %b,i64 %i
 %op=getelementptr float,ptr %o,i64 %i
 %x=load float,ptr %ap,align 4
 %y=load float,ptr %bp,align 4
 %m=fmul float %x,%scale
 %z=fadd float %m,%y
 store float %z,ptr %op,align 4
 %next=add nuw i64 %i,1
 %done=icmp eq i64 %next,%n
 br i1 %done,label %exit,label %loop
exit: ret void
}
define void @float_dot(ptr %o,ptr noalias %a,ptr noalias %b,i64 %n) {
entry:
 %empty=icmp eq i64 %n,0
 br i1 %empty,label %exit,label %loop
loop:
 %i=phi i64 [0,%entry],[%next,%loop]
 %acc=phi float [0.0,%entry],[%sum,%loop]
 %ap=getelementptr float,ptr %a,i64 %i
 %bp=getelementptr float,ptr %b,i64 %i
 %x=load float,ptr %ap,align 4
 %y=load float,ptr %bp,align 4
 %m=fmul fast float %x,%y
 %sum=fadd fast float %acc,%m
 %next=add nuw i64 %i,1
 %done=icmp eq i64 %next,%n
 br i1 %done,label %exit,label %loop
exit:
 %result=phi float [0.0,%entry],[%sum,%loop]
 store float %result,ptr %o,align 4
 ret void
}
