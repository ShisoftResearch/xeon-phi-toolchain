; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; CHECK-LABEL: vector_half_to_float:
; CHECK: knc.load_f16
; CHECK: knc.loadh_f16
; CHECK-LABEL: vector_float_to_half:
; CHECK: knc.store_f16
; CHECK: knc.storeh_f16
target triple = "x86_64-unknown-linux-gnu"
define void @vector_half_to_float(ptr %out,ptr %in) {
 %h=load <16 x half>,ptr %in,align 2
 %f=fpext <16 x half> %h to <16 x float>
 store <16 x float> %f,ptr %out,align 4
 ret void
}
define void @vector_float_to_half(ptr %out,ptr %in) {
 %f=load <16 x float>,ptr %in,align 4
 %h=fptrunc <16 x float> %f to <16 x half>
 store <16 x half> %h,ptr %out,align 2
 ret void
}
