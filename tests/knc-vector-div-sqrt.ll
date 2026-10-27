; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,-knc-native-abi -verify-machineinstrs < %s -o /dev/null
; KNC has no exact native vector divide/sqrt: expand before scalar FP softening.
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: vector_div2_f32:
; CHECK: callq __divsf3
define void @vector_div2_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x float>,ptr %a,align 4
 %y=load <2 x float>,ptr %b,align 4
 %r=fdiv <2 x float> %x,%y
 store <2 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: vector_sqrt2_f32:
; CHECK: callq sqrtf
define void @vector_sqrt2_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x float>,ptr %a,align 4
 %r=call <2 x float> @llvm.sqrt.v2f32(<2 x float> %x)
 store <2 x float> %r,ptr %out,align 4
 ret void
}
declare <2 x float> @llvm.sqrt.v2f32(<2 x float>)
; CHECK-LABEL: vector_div4_f32:
; CHECK: callq __divsf3
define void @vector_div4_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x float>,ptr %a,align 4
 %y=load <4 x float>,ptr %b,align 4
 %r=fdiv <4 x float> %x,%y
 store <4 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: vector_sqrt4_f32:
; CHECK: callq sqrtf
define void @vector_sqrt4_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x float>,ptr %a,align 4
 %r=call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x)
 store <4 x float> %r,ptr %out,align 4
 ret void
}
declare <4 x float> @llvm.sqrt.v4f32(<4 x float>)
; CHECK-LABEL: vector_div8_f32:
; CHECK: callq __divsf3
define void @vector_div8_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x float>,ptr %a,align 4
 %y=load <8 x float>,ptr %b,align 4
 %r=fdiv <8 x float> %x,%y
 store <8 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: vector_sqrt8_f32:
; CHECK: callq sqrtf
define void @vector_sqrt8_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x float>,ptr %a,align 4
 %r=call <8 x float> @llvm.sqrt.v8f32(<8 x float> %x)
 store <8 x float> %r,ptr %out,align 4
 ret void
}
declare <8 x float> @llvm.sqrt.v8f32(<8 x float>)
; CHECK-LABEL: vector_div16_f32:
; CHECK: callq __divsf3
define void @vector_div16_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=fdiv <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: vector_sqrt16_f32:
; CHECK: callq sqrtf
define void @vector_sqrt16_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %r=call <16 x float> @llvm.sqrt.v16f32(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.sqrt.v16f32(<16 x float>)
; CHECK-LABEL: vector_div32_f32:
; CHECK: callq __divsf3
define void @vector_div32_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x float>,ptr %a,align 4
 %y=load <32 x float>,ptr %b,align 4
 %r=fdiv <32 x float> %x,%y
 store <32 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: vector_sqrt32_f32:
; CHECK: callq sqrtf
define void @vector_sqrt32_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x float>,ptr %a,align 4
 %r=call <32 x float> @llvm.sqrt.v32f32(<32 x float> %x)
 store <32 x float> %r,ptr %out,align 4
 ret void
}
declare <32 x float> @llvm.sqrt.v32f32(<32 x float>)
; CHECK-LABEL: vector_div2_f64:
; CHECK: callq __divdf3
define void @vector_div2_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x double>,ptr %a,align 8
 %y=load <2 x double>,ptr %b,align 8
 %r=fdiv <2 x double> %x,%y
 store <2 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: vector_sqrt2_f64:
; CHECK: callq sqrt
define void @vector_sqrt2_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x double>,ptr %a,align 8
 %r=call <2 x double> @llvm.sqrt.v2f64(<2 x double> %x)
 store <2 x double> %r,ptr %out,align 8
 ret void
}
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>)
; CHECK-LABEL: vector_div4_f64:
; CHECK: callq __divdf3
define void @vector_div4_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x double>,ptr %a,align 8
 %y=load <4 x double>,ptr %b,align 8
 %r=fdiv <4 x double> %x,%y
 store <4 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: vector_sqrt4_f64:
; CHECK: callq sqrt
define void @vector_sqrt4_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x double>,ptr %a,align 8
 %r=call <4 x double> @llvm.sqrt.v4f64(<4 x double> %x)
 store <4 x double> %r,ptr %out,align 8
 ret void
}
declare <4 x double> @llvm.sqrt.v4f64(<4 x double>)
; CHECK-LABEL: vector_div8_f64:
; CHECK: callq __divdf3
define void @vector_div8_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %r=fdiv <8 x double> %x,%y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: vector_sqrt8_f64:
; CHECK: callq sqrt
define void @vector_sqrt8_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %r=call <8 x double> @llvm.sqrt.v8f64(<8 x double> %x)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.sqrt.v8f64(<8 x double>)
; CHECK-LABEL: vector_div16_f64:
; CHECK: callq __divdf3
define void @vector_div16_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x double>,ptr %a,align 8
 %y=load <16 x double>,ptr %b,align 8
 %r=fdiv <16 x double> %x,%y
 store <16 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: vector_sqrt16_f64:
; CHECK: callq sqrt
define void @vector_sqrt16_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x double>,ptr %a,align 8
 %r=call <16 x double> @llvm.sqrt.v16f64(<16 x double> %x)
 store <16 x double> %r,ptr %out,align 8
 ret void
}
declare <16 x double> @llvm.sqrt.v16f64(<16 x double>)
; CHECK-LABEL: vector_div32_f64:
; CHECK: callq __divdf3
define void @vector_div32_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x double>,ptr %a,align 8
 %y=load <32 x double>,ptr %b,align 8
 %r=fdiv <32 x double> %x,%y
 store <32 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: vector_sqrt32_f64:
; CHECK: callq sqrt
define void @vector_sqrt32_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x double>,ptr %a,align 8
 %r=call <32 x double> @llvm.sqrt.v32f64(<32 x double> %x)
 store <32 x double> %r,ptr %out,align 8
 ret void
}
declare <32 x double> @llvm.sqrt.v32f64(<32 x double>)
