; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
define void @reduce_ordered_add_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fadd.v2f32(float %start,<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fadd.v2f32(float %start,<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fmul.v2f32(float %start,<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fmul.v2f32(float %start,<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmin.v2f32(<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmax.v2f32(<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fminimum.v2f32(<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_2_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmaximum.v2f32(<2 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fadd.v4f32(float %start,<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fadd.v4f32(float %start,<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fmul.v4f32(float %start,<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fmul.v4f32(float %start,<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmin.v4f32(<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmax.v4f32(<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fminimum.v4f32(<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_4_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmaximum.v4f32(<4 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fadd.v8f32(float %start,<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fadd.v8f32(float %start,<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fmul.v8f32(float %start,<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fmul.v8f32(float %start,<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmin.v8f32(<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmax.v8f32(<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fminimum.v8f32(<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_8_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmaximum.v8f32(<8 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fadd.v16f32(float %start,<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fadd.v16f32(float %start,<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fmul.v16f32(float %start,<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fmul.v16f32(float %start,<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmin.v16f32(<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmax.v16f32(<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fminimum.v16f32(<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_16_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmaximum.v16f32(<16 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fadd.v32f32(float %start,<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fadd.v32f32(float %start,<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call float @llvm.vector.reduce.fmul.v32f32(float %start,<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %start=load float,ptr %init,align 1
 %r=call reassoc float @llvm.vector.reduce.fmul.v32f32(float %start,<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmin.v32f32(<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmax.v32f32(<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fminimum.v32f32(<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_32_f32(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x float>,ptr %in,align 1
 %r=call float @llvm.vector.reduce.fmaximum.v32f32(<32 x float> %x)
 store float %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fadd.v2f64(double %start,<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fadd.v2f64(double %start,<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fmul.v2f64(double %start,<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fmul.v2f64(double %start,<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmin.v2f64(<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmax.v2f64(<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fminimum.v2f64(<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_2_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <2 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmaximum.v2f64(<2 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fadd.v4f64(double %start,<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fadd.v4f64(double %start,<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fmul.v4f64(double %start,<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fmul.v4f64(double %start,<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmin.v4f64(<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmax.v4f64(<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fminimum.v4f64(<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_4_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <4 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmaximum.v4f64(<4 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fadd.v8f64(double %start,<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fadd.v8f64(double %start,<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fmul.v8f64(double %start,<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fmul.v8f64(double %start,<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmin.v8f64(<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmax.v8f64(<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fminimum.v8f64(<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_8_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <8 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmaximum.v8f64(<8 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fadd.v16f64(double %start,<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fadd.v16f64(double %start,<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fmul.v16f64(double %start,<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fmul.v16f64(double %start,<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmin.v16f64(<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmax.v16f64(<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fminimum.v16f64(<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_16_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <16 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmaximum.v16f64(<16 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_add_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fadd.v32f64(double %start,<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_add_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fadd.v32f64(double %start,<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_ordered_mul_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call double @llvm.vector.reduce.fmul.v32f64(double %start,<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_reassoc_mul_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %start=load double,ptr %init,align 1
 %r=call reassoc double @llvm.vector.reduce.fmul.v32f64(double %start,<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmin_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmin.v32f64(<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmax_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmax.v32f64(<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fminimum_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fminimum.v32f64(<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
define void @reduce_fmaximum_32_f64(ptr %out,ptr %in,ptr %init) {
 %x=load <32 x double>,ptr %in,align 1
 %r=call double @llvm.vector.reduce.fmaximum.v32f64(<32 x double> %x)
 store double %r,ptr %out,align 1
 ret void
}
declare double @llvm.vector.reduce.fadd.v16f64(double,<16 x double>)
declare double @llvm.vector.reduce.fadd.v2f64(double,<2 x double>)
declare double @llvm.vector.reduce.fadd.v32f64(double,<32 x double>)
declare double @llvm.vector.reduce.fadd.v4f64(double,<4 x double>)
declare double @llvm.vector.reduce.fadd.v8f64(double,<8 x double>)
declare double @llvm.vector.reduce.fmax.v16f64(<16 x double>)
declare double @llvm.vector.reduce.fmax.v2f64(<2 x double>)
declare double @llvm.vector.reduce.fmax.v32f64(<32 x double>)
declare double @llvm.vector.reduce.fmax.v4f64(<4 x double>)
declare double @llvm.vector.reduce.fmax.v8f64(<8 x double>)
declare double @llvm.vector.reduce.fmaximum.v16f64(<16 x double>)
declare double @llvm.vector.reduce.fmaximum.v2f64(<2 x double>)
declare double @llvm.vector.reduce.fmaximum.v32f64(<32 x double>)
declare double @llvm.vector.reduce.fmaximum.v4f64(<4 x double>)
declare double @llvm.vector.reduce.fmaximum.v8f64(<8 x double>)
declare double @llvm.vector.reduce.fmin.v16f64(<16 x double>)
declare double @llvm.vector.reduce.fmin.v2f64(<2 x double>)
declare double @llvm.vector.reduce.fmin.v32f64(<32 x double>)
declare double @llvm.vector.reduce.fmin.v4f64(<4 x double>)
declare double @llvm.vector.reduce.fmin.v8f64(<8 x double>)
declare double @llvm.vector.reduce.fminimum.v16f64(<16 x double>)
declare double @llvm.vector.reduce.fminimum.v2f64(<2 x double>)
declare double @llvm.vector.reduce.fminimum.v32f64(<32 x double>)
declare double @llvm.vector.reduce.fminimum.v4f64(<4 x double>)
declare double @llvm.vector.reduce.fminimum.v8f64(<8 x double>)
declare double @llvm.vector.reduce.fmul.v16f64(double,<16 x double>)
declare double @llvm.vector.reduce.fmul.v2f64(double,<2 x double>)
declare double @llvm.vector.reduce.fmul.v32f64(double,<32 x double>)
declare double @llvm.vector.reduce.fmul.v4f64(double,<4 x double>)
declare double @llvm.vector.reduce.fmul.v8f64(double,<8 x double>)
declare float @llvm.vector.reduce.fadd.v16f32(float,<16 x float>)
declare float @llvm.vector.reduce.fadd.v2f32(float,<2 x float>)
declare float @llvm.vector.reduce.fadd.v32f32(float,<32 x float>)
declare float @llvm.vector.reduce.fadd.v4f32(float,<4 x float>)
declare float @llvm.vector.reduce.fadd.v8f32(float,<8 x float>)
declare float @llvm.vector.reduce.fmax.v16f32(<16 x float>)
declare float @llvm.vector.reduce.fmax.v2f32(<2 x float>)
declare float @llvm.vector.reduce.fmax.v32f32(<32 x float>)
declare float @llvm.vector.reduce.fmax.v4f32(<4 x float>)
declare float @llvm.vector.reduce.fmax.v8f32(<8 x float>)
declare float @llvm.vector.reduce.fmaximum.v16f32(<16 x float>)
declare float @llvm.vector.reduce.fmaximum.v2f32(<2 x float>)
declare float @llvm.vector.reduce.fmaximum.v32f32(<32 x float>)
declare float @llvm.vector.reduce.fmaximum.v4f32(<4 x float>)
declare float @llvm.vector.reduce.fmaximum.v8f32(<8 x float>)
declare float @llvm.vector.reduce.fmin.v16f32(<16 x float>)
declare float @llvm.vector.reduce.fmin.v2f32(<2 x float>)
declare float @llvm.vector.reduce.fmin.v32f32(<32 x float>)
declare float @llvm.vector.reduce.fmin.v4f32(<4 x float>)
declare float @llvm.vector.reduce.fmin.v8f32(<8 x float>)
declare float @llvm.vector.reduce.fminimum.v16f32(<16 x float>)
declare float @llvm.vector.reduce.fminimum.v2f32(<2 x float>)
declare float @llvm.vector.reduce.fminimum.v32f32(<32 x float>)
declare float @llvm.vector.reduce.fminimum.v4f32(<4 x float>)
declare float @llvm.vector.reduce.fminimum.v8f32(<8 x float>)
declare float @llvm.vector.reduce.fmul.v16f32(float,<16 x float>)
declare float @llvm.vector.reduce.fmul.v2f32(float,<2 x float>)
declare float @llvm.vector.reduce.fmul.v32f32(float,<32 x float>)
declare float @llvm.vector.reduce.fmul.v4f32(float,<4 x float>)
declare float @llvm.vector.reduce.fmul.v8f32(float,<8 x float>)
