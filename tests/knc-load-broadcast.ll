; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --check-prefix=FOLD
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --check-prefix=FOLD
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -knc-load-broadcast=false -verify-machineinstrs < %s | FileCheck %s --check-prefix=OLD
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs -stop-after=finalize-isel < %s | FileCheck %s --check-prefix=MMO

target triple = "x86_64-unknown-linux-gnu"
; FOLD-LABEL: load_f32:
; FOLD-NOT: (%rsp)
; FOLD: knc.vbroadcastss{{.*}}(%rdi)
; FOLD-NOT: (%rsp)
; FOLD: retq
; OLD-LABEL: load_f32:
; OLD: movl{{.*}}(%rdi)
; OLD: knc.vbroadcastss
; MMO-LABEL: name: load_f32
; MMO: KNC_VBROADCASTSS{{.*}} :: (load (s32) from %ir.p)
define float @load_f32(ptr %p) {
 %v = load float, ptr %p, align 4
 ret float %v
}
; FOLD-LABEL: load_f64:
; FOLD-NOT: (%rsp)
; FOLD: knc.vbroadcastsd{{.*}}(%rdi)
; FOLD-NOT: (%rsp)
; FOLD: retq
; MMO-LABEL: name: load_f64
; MMO: KNC_VBROADCASTSD{{.*}} :: (load (s64) from %ir.p)
define double @load_f64(ptr %p) {
 %v = load double, ptr %p, align 8
 ret double %v
}
; FOLD-LABEL: splat_i32:
; FOLD-NOT: (%rsp)
; FOLD: knc.vbroadcastss{{.*}}(%rdi)
; FOLD-NOT: (%rsp)
; FOLD: retq
define <16 x i32> @splat_i32(ptr %p) {
 %v = load i32, ptr %p, align 4
 %a = insertelement <16 x i32> poison, i32 %v, i64 0
 %r = shufflevector <16 x i32> %a, <16 x i32> poison, <16 x i32> zeroinitializer
 ret <16 x i32> %r
}
; FOLD-LABEL: splat_i64:
; FOLD-NOT: (%rsp)
; FOLD: knc.vbroadcastsd{{.*}}(%rdi)
; FOLD-NOT: (%rsp)
; FOLD: retq
define <8 x i64> @splat_i64(ptr %p) {
 %v = load i64, ptr %p, align 8
 %a = insertelement <8 x i64> poison, i64 %v, i64 0
 %r = shufflevector <8 x i64> %a, <8 x i64> poison, <8 x i32> zeroinitializer
 ret <8 x i64> %r
}
; Volatile/atomic loads retain the scalar path; the optimization may not
; duplicate, widen or drop the source read.
; FOLD-LABEL: volatile_i32:
; FOLD: movl{{.*}}(%rdi)
; FOLD: knc.vbroadcastss
; FOLD: retq
define <16 x i32> @volatile_i32(ptr %p) {
 %v = load volatile i32, ptr %p, align 1
 %a = insertelement <16 x i32> poison, i32 %v, i64 0
 %r = shufflevector <16 x i32> %a, <16 x i32> poison, <16 x i32> zeroinitializer
 ret <16 x i32> %r
}
; FOLD-LABEL: atomic_i64:
; FOLD: movq{{.*}}(%rdi)
; FOLD: knc.vbroadcastsd
; FOLD: retq
define <8 x i64> @atomic_i64(ptr %p) {
 %v = load atomic i64, ptr %p acquire, align 8
 %a = insertelement <8 x i64> poison, i64 %v, i64 0
 %r = shufflevector <8 x i64> %a, <8 x i64> poison, <8 x i32> zeroinitializer
 ret <8 x i64> %r
}

; FOLD-LABEL: unaligned_f32:
; FOLD: movl{{.*}}(%rdi)
; FOLD: knc.vbroadcastss
; FOLD: retq
define float @unaligned_f32(ptr %p) {
 %v = load float, ptr %p, align 1
 ret float %v
}
; FOLD-LABEL: unaligned_f64:
; FOLD: movq{{.*}}(%rdi)
; FOLD: knc.vbroadcastsd
; FOLD: retq
define double @unaligned_f64(ptr %p) {
 %v = load double, ptr %p, align 1
 ret double %v
}

; A plain broadcast has no FS/GS memory operand. Explicit segmented-address
; loads must retain the original scalar segment-aware load.
; FOLD-LABEL: gs_f32:
; FOLD: movl{{.*}}%gs:(%rdi)
; FOLD: knc.vbroadcastss
; FOLD: retq
define float @gs_f32(ptr addrspace(256) %p) {
 %v = load float, ptr addrspace(256) %p, align 4
 ret float %v
}
; FOLD-LABEL: fs_f64:
; FOLD: movq{{.*}}%fs:(%rdi)
; FOLD: knc.vbroadcastsd
; FOLD: retq
define double @fs_f64(ptr addrspace(257) %p) {
 %v = load double, ptr addrspace(257) %p, align 8
 ret double %v
}
; Ordinary TLS in flat address space must still materialize its full address.
@tls_value = thread_local(localexec) global float 1.0, align 4
; FOLD-LABEL: flat_tls:
; FOLD: movq{{.*}}%fs:0
; FOLD: knc.vbroadcastss
; FOLD: retq
define float @flat_tls() {
 %v = load float, ptr @tls_value, align 4
 ret float %v
}
