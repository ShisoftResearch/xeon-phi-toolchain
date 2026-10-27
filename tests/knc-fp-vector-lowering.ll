; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -knc-optimize-fp-vectors=false -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --check-prefix=BEFORE
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi < %s | FileCheck %s --check-prefix=PERM
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -knc-scalar-register-reuse=false < %s | FileCheck %s --check-prefix=PERMOLD
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: native_signed_to_double:
; CHECK-NOT: callq
; CHECK: knc.vcvtdq2pd
; BEFORE-LABEL: native_signed_to_double:
; BEFORE: __floatsidf
define void @native_signed_to_double(ptr %out,ptr %in){
 %x=load <8 x i32>,ptr %in,align 4
 %r=sitofp <8 x i32> %x to <8 x double>
 store <8 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: native_unsigned_to_double:
; CHECK-NOT: callq
; CHECK: knc.vcvtudq2pd
define void @native_unsigned_to_double(ptr %out,ptr %in){
 %x=load <8 x i32>,ptr %in,align 4
 %r=uitofp <8 x i32> %x to <8 x double>
 store <8 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: native_double_to_signed:
; CHECK-NOT: callq
; CHECK: knc.vcvtfxpntpd2dq
define void @native_double_to_signed(ptr %out,ptr %in){
 %x=load <8 x double>,ptr %in,align 8
 %r=fptosi <8 x double> %x to <8 x i32>
 store <8 x i32> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: native_double_to_unsigned:
; CHECK-NOT: callq
; CHECK: knc.vcvtfxpntpd2udq
define void @native_double_to_unsigned(ptr %out,ptr %in){
 %x=load <8 x double>,ptr %in,align 8
 %r=fptoui <8 x double> %x to <8 x i32>
 store <8 x i32> %r,ptr %out,align 4
 ret void
}
; Ordered and relaxed reductions use different native operation counts.
; CHECK-LABEL: ordered_sum:
; CHECK-COUNT-16: knc.vaddps
; PERM-LABEL: ordered_sum:
; PERM-COUNT-15: knc.vpermd
; PERM-NOT: knc.vpermd
; PERMOLD-LABEL: ordered_sum:
; PERMOLD-COUNT-16: knc.vpermd
; CHECK-LABEL: relaxed_sum:
; CHECK-COUNT-5: knc.vaddps
; PERM-LABEL: relaxed_sum:
; PERM-COUNT-4: knc.vpermd
define void @ordered_sum(ptr %out,ptr %in,ptr %start){
 %x=load <16 x float>,ptr %in,align 4
 %init=load float,ptr %start,align 4
 %r=call float @llvm.vector.reduce.fadd.v16f32(float %init,<16 x float> %x)
 store float %r,ptr %out,align 4
 ret void
}
define void @relaxed_sum(ptr %out,ptr %in,ptr %start){
 %x=load <16 x float>,ptr %in,align 4
 %init=load float,ptr %start,align 4
 %r=call reassoc float @llvm.vector.reduce.fadd.v16f32(float %init,<16 x float> %x)
 store float %r,ptr %out,align 4
 ret void
}
declare float @llvm.vector.reduce.fadd.v16f32(float,<16 x float>)
