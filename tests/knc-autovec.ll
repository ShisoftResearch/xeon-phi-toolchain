; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes='default<O3>' -S < %s | llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs | FileCheck %s
; CHECK-LABEL: affine:
; CHECK: knc.vloadunpackld
; CHECK: knc.vloadunpackhd
; CHECK: knc.vpmulld
; CHECK: knc.vpaddd
; CHECK: knc.vpackstoreld
; CHECK: knc.vpackstorehd
target triple = "x86_64-unknown-linux-gnu"
define void @affine(ptr noalias %o,ptr noalias %a,ptr noalias %b,i64 %n) {
entry:
 %empty=icmp eq i64 %n,0
 br i1 %empty,label %exit,label %loop
loop:
 %i=phi i64 [0,%entry],[%next,%loop]
 %ap=getelementptr i32,ptr %a,i64 %i
 %bp=getelementptr i32,ptr %b,i64 %i
 %op=getelementptr i32,ptr %o,i64 %i
 %x=load i32,ptr %ap,align 4
 %y=load i32,ptr %bp,align 4
 %m=mul i32 %x,13
 %z=add i32 %m,%y
 store i32 %z,ptr %op,align 4
 %next=add nuw i64 %i,1
 %done=icmp eq i64 %next,%n
 br i1 %done,label %exit,label %loop
exit: ret void
}
