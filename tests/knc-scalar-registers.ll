; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: registers_f32:
; CHECK-NOT: knc.vmovdqa32{{.*}}(
; CHECK-NOT: knc.vbroadcast
; CHECK: knc.vaddps
; CHECK-NOT: knc.vmovdqa32{{.*}}(
; CHECK-NOT: knc.vbroadcast
; CHECK: knc.vmulps
; CHECK-NOT: knc.vmovdqa32{{.*}}(
; CHECK-NOT: knc.vbroadcast
; CHECK: retq
define float @registers_f32(float %a,float %b) {
 %s=fadd float %a,%b
 %r=fmul float %s,%b
 ret float %r
}
; CHECK-LABEL: registers_f64:
; CHECK-NOT: knc.vmovdqa32{{.*}}(
; CHECK-NOT: knc.vbroadcast
; CHECK: knc.vaddpd
; CHECK-NOT: knc.vmovdqa32{{.*}}(
; CHECK-NOT: knc.vbroadcast
; CHECK: knc.vmulpd
; CHECK-NOT: knc.vmovdqa32{{.*}}(
; CHECK-NOT: knc.vbroadcast
; CHECK: retq
define double @registers_f64(double %a,double %b) {
 %s=fadd double %a,%b
 %r=fmul double %s,%b
 ret double %r
}
; Exercise scalar call arguments extracted from vectors with unrelated upper
; lanes. The scalar ABI observes only lane zero of each ZMM argument/result.
define void @scalar_vector_source_f32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %va=load <16 x float>,ptr %a,align 64
 %vb=load <16 x float>,ptr %b,align 64
 %vc=load <16 x float>,ptr %c,align 64
 %x=extractelement <16 x float> %va,i32 0
 %y=extractelement <16 x float> %vb,i32 0
 %z=extractelement <16 x float> %vc,i32 0
 %r=call float @dag_chain_value_f32(float %x,float %y,float %z)
 store float %r,ptr %out,align 1
 ret void
}
define void @scalar_vector_source_f64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %va=load <8 x double>,ptr %a,align 64
 %vb=load <8 x double>,ptr %b,align 64
 %vc=load <8 x double>,ptr %c,align 64
 %x=extractelement <8 x double> %va,i32 0
 %y=extractelement <8 x double> %vb,i32 0
 %z=extractelement <8 x double> %vc,i32 0
 %r=call double @dag_chain_value_f64(double %x,double %y,double %z)
 store double %r,ptr %out,align 1
 ret void
}
declare float @dag_chain_value_f32(float,float,float)
declare double @dag_chain_value_f64(double,double,double)
define void @scalar_sdk_source_f64(ptr %out,ptr %a,ptr %b) {
 %va=load <8 x double>,ptr %a,align 64
 %vb=load <8 x double>,ptr %b,align 64
 %x=extractelement <8 x double> %va,i32 0
 %y=extractelement <8 x double> %vb,i32 0
 %r=call double @sdk_branch(double %x)
 store double %r,ptr %out,align 1
 %eq=call i32 @sdk_equal(double %x,double %y)
 %p=getelementptr i8,ptr %out,i64 8
 store i32 %eq,ptr %p,align 1
 ret void
}
define void @scalar_sdk_source_f32(ptr %out,ptr %a) {
 %va=load <16 x float>,ptr %a,align 64
 %x=extractelement <16 x float> %va,i32 0
 %r=call float @sdk_add_constant(float %x)
 store float %r,ptr %out,align 1
 ret void
}
declare double @sdk_branch(double)
declare i32 @sdk_equal(double,double)
declare float @sdk_add_constant(float)
