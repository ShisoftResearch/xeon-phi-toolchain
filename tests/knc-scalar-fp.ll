; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --check-prefix=NATIVE
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --check-prefix=NATIVE
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi,-knc-scalar-fp -verify-machineinstrs < %s | FileCheck %s --check-prefix=SOFT
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -knc-scalar-register-reuse=false -verify-machineinstrs < %s | FileCheck %s --check-prefix=TRANSPORT
target triple = "x86_64-unknown-linux-gnu"
; NATIVE-LABEL: scalar_add_f32:
; NATIVE-NOT: __addsf3
; TRANSPORT-LABEL: scalar_add_f32:
; TRANSPORT: knc.vbroadcastss
; NATIVE: knc.vaddps
; SOFT-LABEL: scalar_add_f32:
; SOFT: __addsf3
define float @scalar_add_f32(float %a,float %b) { %r=fadd float %a,%b
 ret float %r }
; NATIVE-LABEL: scalar_sub_f32:
; NATIVE: knc.vsubps
; SOFT-LABEL: scalar_sub_f32:
; SOFT: __subsf3
define float @scalar_sub_f32(float %a,float %b) { %r=fsub float %a,%b
 ret float %r }
; NATIVE-LABEL: scalar_mul_f32:
; NATIVE: knc.vmulps
; SOFT-LABEL: scalar_mul_f32:
; SOFT: __mulsf3
define float @scalar_mul_f32(float %a,float %b) { %r=fmul float %a,%b
 ret float %r }
; NATIVE-LABEL: scalar_fma_f32:
; NATIVE: knc.vfmadd132ps
define float @scalar_fma_f32(float %a,float %b,float %c) { %r=call float @llvm.fma.f32(float %a,float %b,float %c)
 ret float %r }
; NATIVE-LABEL: scalar_add_f64:
; NATIVE-NOT: __adddf3
; TRANSPORT-LABEL: scalar_add_f64:
; TRANSPORT: knc.vbroadcastsd
; NATIVE: knc.vaddpd
; SOFT-LABEL: scalar_add_f64:
; SOFT: __adddf3
define double @scalar_add_f64(double %a,double %b) { %r=fadd double %a,%b
 ret double %r }
; NATIVE-LABEL: scalar_sub_f64:
; NATIVE: knc.vsubpd
; SOFT-LABEL: scalar_sub_f64:
; SOFT: __subdf3
define double @scalar_sub_f64(double %a,double %b) { %r=fsub double %a,%b
 ret double %r }
; NATIVE-LABEL: scalar_mul_f64:
; NATIVE: knc.vmulpd
; SOFT-LABEL: scalar_mul_f64:
; SOFT: __muldf3
define double @scalar_mul_f64(double %a,double %b) { %r=fmul double %a,%b
 ret double %r }
; NATIVE-LABEL: scalar_fma_f64:
; NATIVE: knc.vfmadd132pd
define double @scalar_fma_f64(double %a,double %b,double %c) { %r=call double @llvm.fma.f64(double %a,double %b,double %c)
 ret double %r }
; NATIVE-LABEL: scalar_div_f32:
; NATIVE: __divsf3
define float @scalar_div_f32(float %a,float %b) { %r=fdiv float %a,%b
 ret float %r }
; NATIVE-LABEL: scalar_sqrt_f64:
; NATIVE: sqrt
define double @scalar_sqrt_f64(double %a) { %r=call double @llvm.sqrt.f64(double %a)
 ret double %r }
; NATIVE-LABEL: no_implicit_fp:
; NATIVE: __addsf3
define float @no_implicit_fp(float %a,float %b) #0 { %r=fadd float %a,%b
 ret float %r }
; NATIVE-LABEL: strict_fp:
; NATIVE: __adddf3
define double @strict_fp(double %a,double %b) #1 { %r=call double @llvm.experimental.constrained.fadd.f64(double %a,double %b,metadata !"round.dynamic",metadata !"fpexcept.strict")
 ret double %r }
declare float @llvm.fma.f32(float,float,float)
declare double @llvm.fma.f64(double,double,double)
declare double @llvm.sqrt.f64(double)
declare double @llvm.experimental.constrained.fadd.f64(double,double,metadata,metadata)
attributes #0 = { noimplicitfloat }
attributes #1 = { strictfp }
