; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes="default<O3>" -S < %s | llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs | FileCheck %s --check-prefix=AUTO
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: sat_s8:
; CHECK: knc.vpcmpud
; CHECK: knc.cvt_f32_i32
define void @sat_s8(ptr %out,ptr %in) {
 %f=load <16 x float>,ptr %in,align 4
 %v=call <16 x i8> @llvm.fptosi.sat.v16i8.v16f32(<16 x float> %f)
 store <16 x i8> %v,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.fptosi.sat.v16i8.v16f32(<16 x float>)
; CHECK-LABEL: sat_u8:
; CHECK: knc.vpcmpud
; CHECK: knc.cvt_f32_u32
define void @sat_u8(ptr %out,ptr %in) {
 %f=load <16 x float>,ptr %in,align 4
 %v=call <16 x i8> @llvm.fptoui.sat.v16i8.v16f32(<16 x float> %f)
 store <16 x i8> %v,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.fptoui.sat.v16i8.v16f32(<16 x float>)
; CHECK-LABEL: sat_s16:
; CHECK: knc.vpcmpud
; CHECK: knc.cvt_f32_i32
define void @sat_s16(ptr %out,ptr %in) {
 %f=load <16 x float>,ptr %in,align 4
 %v=call <16 x i16> @llvm.fptosi.sat.v16i16.v16f32(<16 x float> %f)
 store <16 x i16> %v,ptr %out,align 2
 ret void
}
declare <16 x i16> @llvm.fptosi.sat.v16i16.v16f32(<16 x float>)
; CHECK-LABEL: sat_u16:
; CHECK: knc.vpcmpud
; CHECK: knc.cvt_f32_u32
define void @sat_u16(ptr %out,ptr %in) {
 %f=load <16 x float>,ptr %in,align 4
 %v=call <16 x i16> @llvm.fptoui.sat.v16i16.v16f32(<16 x float> %f)
 store <16 x i16> %v,ptr %out,align 2
 ret void
}
declare <16 x i16> @llvm.fptoui.sat.v16i16.v16f32(<16 x float>)
; CHECK-LABEL: sat_s32:
; CHECK: knc.vpcmpud
; CHECK: knc.cvt_f32_i32
define void @sat_s32(ptr %out,ptr %in) {
 %f=load <16 x float>,ptr %in,align 4
 %v=call <16 x i32> @llvm.fptosi.sat.v16i32.v16f32(<16 x float> %f)
 store <16 x i32> %v,ptr %out,align 4
 ret void
}
declare <16 x i32> @llvm.fptosi.sat.v16i32.v16f32(<16 x float>)
; CHECK-LABEL: sat_u32:
; CHECK: knc.vpcmpud
; CHECK: knc.cvt_f32_u32
define void @sat_u32(ptr %out,ptr %in) {
 %f=load <16 x float>,ptr %in,align 4
 %v=call <16 x i32> @llvm.fptoui.sat.v16i32.v16f32(<16 x float> %f)
 store <16 x i32> %v,ptr %out,align 4
 ret void
}
declare <16 x i32> @llvm.fptoui.sat.v16i32.v16f32(<16 x float>)

; AUTO-LABEL: auto_sat_s32:
; AUTO: knc.cvt_f32_i32
define void @auto_sat_s32(ptr noalias %out,ptr noalias %in,i64 %n) {
entry:
 %empty=icmp eq i64 %n,0
 br i1 %empty,label %exit,label %loop
loop:
 %i=phi i64 [0,%entry],[%next,%loop]
 %p=getelementptr float,ptr %in,i64 %i
 %o=getelementptr i32,ptr %out,i64 %i
 %v=load float,ptr %p,align 4
 %r=call i32 @llvm.fptosi.sat.i32.f32(float %v)
 store i32 %r,ptr %o,align 4
 %next=add nuw i64 %i,1
 %done=icmp eq i64 %next,%n
 br i1 %done,label %exit,label %loop
exit: ret void
}
declare i32 @llvm.fptosi.sat.i32.f32(float)

; AUTO-LABEL: auto_sat_u32:
; AUTO: knc.cvt_f32_u32
define void @auto_sat_u32(ptr noalias %out,ptr noalias %in,i64 %n) {
entry:
 %empty=icmp eq i64 %n,0
 br i1 %empty,label %exit,label %loop
loop:
 %i=phi i64 [0,%entry],[%next,%loop]
 %p=getelementptr float,ptr %in,i64 %i
 %o=getelementptr i32,ptr %out,i64 %i
 %v=load float,ptr %p,align 4
 %r=call i32 @llvm.fptoui.sat.i32.f32(float %v)
 store i32 %r,ptr %o,align 4
 %next=add nuw i64 %i,1
 %done=icmp eq i64 %next,%n
 br i1 %done,label %exit,label %loop
exit: ret void
}
declare i32 @llvm.fptoui.sat.i32.f32(float)
