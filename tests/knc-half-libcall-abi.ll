; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -stop-after=finalize-isel < %s | FileCheck %s --check-prefix=REG
; The second stage of half-to-double expansion consumes f32, so it must use
; the native FP argument register bank rather than the integer half-bit ABI.
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: half_extend_double:
; CHECK: callq __extendhfsf2
; CHECK: callq __extendsfdf2
; CHECK: retq
; REG: CALL64pcrel32{{.*}}__extendhfsf2{{.*}}implicit $edi{{.*}}implicit-def $zmm0
; REG: CALL64pcrel32{{.*}}__extendsfdf2{{.*}}implicit $zmm0{{.*}}implicit-def $zmm0
define void @half_extend_double(ptr %out,ptr %in) {
 %h=load half,ptr %in,align 2
 %d=fpext half %h to double
 store double %d,ptr %out,align 8
 ret void
}
; CHECK-LABEL: half_bits_extend_double:
; CHECK: callq __extendhfsf2
; CHECK: callq __extendsfdf2
; CHECK: retq
; REG: CALL64pcrel32{{.*}}__extendhfsf2{{.*}}implicit $edi{{.*}}implicit-def $zmm0
; REG: CALL64pcrel32{{.*}}__extendsfdf2{{.*}}implicit $zmm0{{.*}}implicit-def $zmm0
define void @half_bits_extend_double(ptr %out,ptr %in) {
 %h=load i16,ptr %in,align 2
 %d=call double @llvm.convert.from.fp16.f64(i16 %h)
 store double %d,ptr %out,align 8
 ret void
}
declare double @llvm.convert.from.fp16.f64(i16)
