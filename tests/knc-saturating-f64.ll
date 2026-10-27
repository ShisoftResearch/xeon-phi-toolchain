; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: sat64_s8:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_s8(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i8> @llvm.fptosi.sat.v8i8.v8f64(<8 x double> %v)
 store <8 x i8> %r,ptr %out,align 1
 ret void
}
declare <8 x i8> @llvm.fptosi.sat.v8i8.v8f64(<8 x double>)
; CHECK-LABEL: sat64_u8:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_u8(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i8> @llvm.fptoui.sat.v8i8.v8f64(<8 x double> %v)
 store <8 x i8> %r,ptr %out,align 1
 ret void
}
declare <8 x i8> @llvm.fptoui.sat.v8i8.v8f64(<8 x double>)
; CHECK-LABEL: sat64_s16:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_s16(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i16> @llvm.fptosi.sat.v8i16.v8f64(<8 x double> %v)
 store <8 x i16> %r,ptr %out,align 2
 ret void
}
declare <8 x i16> @llvm.fptosi.sat.v8i16.v8f64(<8 x double>)
; CHECK-LABEL: sat64_u16:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_u16(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i16> @llvm.fptoui.sat.v8i16.v8f64(<8 x double> %v)
 store <8 x i16> %r,ptr %out,align 2
 ret void
}
declare <8 x i16> @llvm.fptoui.sat.v8i16.v8f64(<8 x double>)
; CHECK-LABEL: sat64_s32:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_s32(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i32> @llvm.fptosi.sat.v8i32.v8f64(<8 x double> %v)
 store <8 x i32> %r,ptr %out,align 4
 ret void
}
declare <8 x i32> @llvm.fptosi.sat.v8i32.v8f64(<8 x double>)
; CHECK-LABEL: sat64_u32:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_u32(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i32> @llvm.fptoui.sat.v8i32.v8f64(<8 x double> %v)
 store <8 x i32> %r,ptr %out,align 4
 ret void
}
declare <8 x i32> @llvm.fptoui.sat.v8i32.v8f64(<8 x double>)
; CHECK-LABEL: sat64_s64:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_s64(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i64> @llvm.fptosi.sat.v8i64.v8f64(<8 x double> %v)
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
declare <8 x i64> @llvm.fptosi.sat.v8i64.v8f64(<8 x double>)
; CHECK-LABEL: sat64_u64:
; CHECK: knc.vpermd
; CHECK: knc.vpsrlvd
define void @sat64_u64(ptr %out,ptr %in) {
 %v=load <8 x double>,ptr %in,align 8
 %r=call <8 x i64> @llvm.fptoui.sat.v8i64.v8f64(<8 x double> %v)
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
declare <8 x i64> @llvm.fptoui.sat.v8i64.v8f64(<8 x double>)
