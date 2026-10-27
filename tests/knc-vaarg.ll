; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; CHECK-LABEL: ir_va_double:
; CHECK: knc.vpackstorelq
; CHECK: addl $16
; CHECK-LABEL: ir_va_integer:
; CHECK: addl $8
target triple = "x86_64-unknown-linux-gnu"
declare void @llvm.va_start.p0(ptr)
declare void @llvm.va_end.p0(ptr)
define double @ir_va_double(i32 %n,...) {
entry:
 %ap=alloca [24 x i8],align 8
 call void @llvm.va_start.p0(ptr %ap)
 %empty=icmp eq i32 %n,0
 br i1 %empty,label %exit,label %loop
loop:
 %i=phi i32 [0,%entry],[%next,%loop]
 %sum=phi double [0.0,%entry],[%s,%loop]
 %x=va_arg ptr %ap,double
 %s=fadd double %sum,%x
 %next=add i32 %i,1
 %done=icmp eq i32 %next,%n
 br i1 %done,label %exit,label %loop
exit:
 %r=phi double [0.0,%entry],[%s,%loop]
 call void @llvm.va_end.p0(ptr %ap)
 ret double %r
}
define i64 @ir_va_integer(i32 %n,...) {
entry:
 %ap=alloca [24 x i8],align 8
 call void @llvm.va_start.p0(ptr %ap)
 %empty=icmp eq i32 %n,0
 br i1 %empty,label %exit,label %loop
loop:
 %i=phi i32 [0,%entry],[%next,%loop]
 %sum=phi i64 [0,%entry],[%s,%loop]
 %x=va_arg ptr %ap,i64
 %s=add i64 %sum,%x
 %next=add i32 %i,1
 %done=icmp eq i32 %next,%n
 br i1 %done,label %exit,label %loop
exit:
 %r=phi i64 [0,%entry],[%s,%loop]
 call void @llvm.va_end.p0(ptr %ap)
 ret i64 %r
}
