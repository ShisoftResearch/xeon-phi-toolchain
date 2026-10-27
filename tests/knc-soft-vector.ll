; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; CHECK-LABEL: constant_f32:
; CHECK: knc.vmovdqa32
; CHECK-LABEL: constant_f64:
; CHECK: knc.vmovdqa32
; CHECK-LABEL: insert_f32:
; CHECK: knc.vmovdqa32
; CHECK-LABEL: broadcast_f32:
; CHECK: knc.vpackstoreld
target triple = "x86_64-unknown-linux-gnu"
define void @constant_f32(ptr %out) {
 store <16 x float> splat (float 1.125),ptr %out,align 4
 ret void
}
define void @constant_f64(ptr %out) {
 store <8 x double> splat (double 1.125),ptr %out,align 4
 ret void
}
define void @insert_f32(ptr %out,ptr %in,float %value,i32 %index) {
 %v=load <16 x float>,ptr %in,align 4
 %r=insertelement <16 x float> %v,float %value,i32 %index
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @broadcast_f32(ptr %out,float %value) {
 %v=insertelement <16 x float> poison,float %value,i32 0
 %r=shufflevector <16 x float> %v,<16 x float> poison,<16 x i32> zeroinitializer
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @insert_f64(ptr %out,ptr %in,double %value,i32 %index) {
 %v=load <8 x double>,ptr %in,align 4
 %r=insertelement <8 x double> %v,double %value,i32 %index
 store <8 x double> %r,ptr %out,align 4
 ret void
}
define void @broadcast_f64(ptr %out,double %value) {
 %v=insertelement <8 x double> poison,double %value,i32 0
 %r=shufflevector <8 x double> %v,<8 x double> poison,<8 x i32> zeroinitializer
 store <8 x double> %r,ptr %out,align 4
 ret void
}
