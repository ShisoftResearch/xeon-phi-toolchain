; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
define void @approx_div_2_32(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x float>,ptr %a,align 1
 %y=load <2 x float>,ptr %b,align 1
 %r=fdiv arcp afn <2 x float> %x,%y
 store <2 x float> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_2_32(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x float>,ptr %a,align 1
 %r=call afn <2 x float> @llvm.sqrt.v2f32(<2 x float> %x)
 store <2 x float> %r,ptr %out,align 1
 ret void
}
declare <2 x float> @llvm.sqrt.v2f32(<2 x float>)
define void @approx_div_4_32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x float>,ptr %a,align 1
 %y=load <4 x float>,ptr %b,align 1
 %r=fdiv arcp afn <4 x float> %x,%y
 store <4 x float> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_4_32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x float>,ptr %a,align 1
 %r=call afn <4 x float> @llvm.sqrt.v4f32(<4 x float> %x)
 store <4 x float> %r,ptr %out,align 1
 ret void
}
declare <4 x float> @llvm.sqrt.v4f32(<4 x float>)
define void @approx_div_8_32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x float>,ptr %a,align 1
 %y=load <8 x float>,ptr %b,align 1
 %r=fdiv arcp afn <8 x float> %x,%y
 store <8 x float> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_8_32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x float>,ptr %a,align 1
 %r=call afn <8 x float> @llvm.sqrt.v8f32(<8 x float> %x)
 store <8 x float> %r,ptr %out,align 1
 ret void
}
declare <8 x float> @llvm.sqrt.v8f32(<8 x float>)
define void @approx_div_16_32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 1
 %y=load <16 x float>,ptr %b,align 1
 %r=fdiv arcp afn <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_16_32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 1
 %r=call afn <16 x float> @llvm.sqrt.v16f32(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 1
 ret void
}
declare <16 x float> @llvm.sqrt.v16f32(<16 x float>)
define void @approx_div_32_32(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x float>,ptr %a,align 1
 %y=load <32 x float>,ptr %b,align 1
 %r=fdiv arcp afn <32 x float> %x,%y
 store <32 x float> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_32_32(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x float>,ptr %a,align 1
 %r=call afn <32 x float> @llvm.sqrt.v32f32(<32 x float> %x)
 store <32 x float> %r,ptr %out,align 1
 ret void
}
declare <32 x float> @llvm.sqrt.v32f32(<32 x float>)
define void @approx_div_2_64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x double>,ptr %a,align 1
 %y=load <2 x double>,ptr %b,align 1
 %r=fdiv arcp afn <2 x double> %x,%y
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_2_64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x double>,ptr %a,align 1
 %r=call afn <2 x double> @llvm.sqrt.v2f64(<2 x double> %x)
 store <2 x double> %r,ptr %out,align 1
 ret void
}
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>)
define void @approx_div_4_64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x double>,ptr %a,align 1
 %y=load <4 x double>,ptr %b,align 1
 %r=fdiv arcp afn <4 x double> %x,%y
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_4_64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x double>,ptr %a,align 1
 %r=call afn <4 x double> @llvm.sqrt.v4f64(<4 x double> %x)
 store <4 x double> %r,ptr %out,align 1
 ret void
}
declare <4 x double> @llvm.sqrt.v4f64(<4 x double>)
define void @approx_div_8_64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 1
 %y=load <8 x double>,ptr %b,align 1
 %r=fdiv arcp afn <8 x double> %x,%y
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_8_64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 1
 %r=call afn <8 x double> @llvm.sqrt.v8f64(<8 x double> %x)
 store <8 x double> %r,ptr %out,align 1
 ret void
}
declare <8 x double> @llvm.sqrt.v8f64(<8 x double>)
define void @approx_div_16_64(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x double>,ptr %a,align 1
 %y=load <16 x double>,ptr %b,align 1
 %r=fdiv arcp afn <16 x double> %x,%y
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_16_64(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x double>,ptr %a,align 1
 %r=call afn <16 x double> @llvm.sqrt.v16f64(<16 x double> %x)
 store <16 x double> %r,ptr %out,align 1
 ret void
}
declare <16 x double> @llvm.sqrt.v16f64(<16 x double>)
define void @approx_div_32_64(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x double>,ptr %a,align 1
 %y=load <32 x double>,ptr %b,align 1
 %r=fdiv arcp afn <32 x double> %x,%y
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @approx_sqrt_32_64(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x double>,ptr %a,align 1
 %r=call afn <32 x double> @llvm.sqrt.v32f64(<32 x double> %x)
 store <32 x double> %r,ptr %out,align 1
 ret void
}
declare <32 x double> @llvm.sqrt.v32f64(<32 x double>)
