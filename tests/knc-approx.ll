; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,-knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: native_rcp23:
; CHECK: knc.vrcp23ps
define <16 x float> @native_rcp23(<16 x float> %x){
 %r=call <16 x float> @llvm.x86.knc.rcp23.ps(<16 x float> %x)
 ret <16 x float> %r
}
; CHECK-LABEL: native_rsqrt23:
; CHECK: knc.vrsqrt23ps
define <16 x float> @native_rsqrt23(<16 x float> %x){
 %r=call <16 x float> @llvm.x86.knc.rsqrt23.ps(<16 x float> %x)
 ret <16 x float> %r
}
; CHECK-LABEL: approx_div32:
; CHECK: callq __knc_div_v16f32_approx
define void @approx_div32(ptr %out,ptr %a,ptr %b){
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=fdiv arcp afn <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: approx_sqrt64:
; CHECK: callq __knc_sqrt_v8f64_approx
define void @approx_sqrt64(ptr %out,ptr %a){
 %x=load <8 x double>,ptr %a,align 8
 %r=call afn <8 x double> @llvm.sqrt.v8f64(<8 x double> %x)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
; arcp alone does not grant the approximate-function contract.
; CHECK-LABEL: reciprocal_permission_only:
; CHECK-NOT: __knc_div
; CHECK: __divsf3
define void @reciprocal_permission_only(ptr %out,ptr %a,ptr %b){
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=fdiv arcp <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
; afn alone does not grant reciprocal transformations for division.
; CHECK-LABEL: approximate_permission_only:
; CHECK-NOT: __knc_div
; CHECK: __divsf3
define void @approximate_permission_only(ptr %out,ptr %a,ptr %b){
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=fdiv afn <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: strict_approx_div:
; CHECK-NOT: __knc_div
; CHECK: __divsf3
define void @strict_approx_div(ptr %out,ptr %a,ptr %b) #0 {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=fdiv arcp afn <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: no_implicit_approx_sqrt:
; CHECK-NOT: __knc_sqrt
; CHECK: sqrtf
define void @no_implicit_approx_sqrt(ptr %out,ptr %a) #1 {
 %x=load <16 x float>,ptr %a,align 4
 %r=call afn <16 x float> @llvm.sqrt.v16f32(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.sqrt.v16f32(<16 x float>)
declare <16 x float> @llvm.x86.knc.rcp23.ps(<16 x float>)
declare <16 x float> @llvm.x86.knc.rsqrt23.ps(<16 x float>)
declare <8 x double> @llvm.sqrt.v8f64(<8 x double>)
attributes #0 = { strictfp }
attributes #1 = { noimplicitfloat }
