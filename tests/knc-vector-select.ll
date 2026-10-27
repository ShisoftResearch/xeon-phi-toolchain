; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --implicit-check-not=xmm --implicit-check-not=ymm --implicit-check-not=cmov --implicit-check-not=mulss --implicit-check-not=mulsd
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --implicit-check-not=xmm --implicit-check-not=ymm --implicit-check-not=cmov --implicit-check-not=mulss --implicit-check-not=mulsd
; A scalar condition selects every word, including both halves of 64-bit lanes.
target triple = "x86_64-unknown-linux-gnu"

; CHECK-LABEL: select_i32:
; CHECK: vpblendmd
; CHECK: retq
define void @select_i32(ptr %out, ptr %a, ptr %b, i32 %cond) {
 %x = load volatile <16 x i32>, ptr %a, align 64
 %y = load volatile <16 x i32>, ptr %b, align 64
 %c = icmp ne i32 %cond, 0
 %r = select i1 %c, <16 x i32> %x, <16 x i32> %y
 store <16 x i32> %r, ptr %out, align 64
 ret void
}

; CHECK-LABEL: select_f32:
; CHECK: vpblendmd
; CHECK: retq
define void @select_f32(ptr %out, ptr %a, ptr %b, i32 %cond) {
 %x = load volatile <16 x float>, ptr %a, align 64
 %y = load volatile <16 x float>, ptr %b, align 64
 %c = icmp ne i32 %cond, 0
 %r = select i1 %c, <16 x float> %x, <16 x float> %y
 store <16 x float> %r, ptr %out, align 64
 ret void
}

; CHECK-LABEL: select_i64:
; CHECK: vpblendmd
; CHECK: retq
define void @select_i64(ptr %out, ptr %a, ptr %b, i32 %cond) {
 %x = load volatile <8 x i64>, ptr %a, align 64
 %y = load volatile <8 x i64>, ptr %b, align 64
 %c = icmp ne i32 %cond, 0
 %r = select i1 %c, <8 x i64> %x, <8 x i64> %y
 store <8 x i64> %r, ptr %out, align 64
 ret void
}

; CHECK-LABEL: select_f64:
; CHECK: vpblendmd
; CHECK: retq
define void @select_f64(ptr %out, ptr %a, ptr %b, i32 %cond) {
 %x = load volatile <8 x double>, ptr %a, align 64
 %y = load volatile <8 x double>, ptr %b, align 64
 %c = icmp ne i32 %cond, 0
 %r = select i1 %c, <8 x double> %x, <8 x double> %y
 store <8 x double> %r, ptr %out, align 64
 ret void
}

; Type legalization must not reintroduce illegal scalar FP in late splat combines.
; CHECK-LABEL: splat_product_f32:
; CHECK: vmulps
; CHECK: retq
define void @splat_product_f32(ptr %out, ptr %a, ptr %b) {
 %x = load volatile <16 x float>, ptr %a, align 64
 %y = load volatile <16 x float>, ptr %b, align 64
 %p = fmul <16 x float> %x, %y
 %s = shufflevector <16 x float> %p, <16 x float> poison, <16 x i32> zeroinitializer
 store <16 x float> %s, ptr %out, align 64
 ret void
}

; Type legalization must not reintroduce illegal scalar FP in late splat combines.
; CHECK-LABEL: splat_product_f64:
; CHECK: vmulpd
; CHECK: retq
define void @splat_product_f64(ptr %out, ptr %a, ptr %b) {
 %x = load volatile <8 x double>, ptr %a, align 64
 %y = load volatile <8 x double>, ptr %b, align 64
 %p = fmul <8 x double> %x, %y
 %s = shufflevector <8 x double> %p, <8 x double> poison, <8 x i32> zeroinitializer
 store <8 x double> %s, ptr %out, align 64
 ret void
}
