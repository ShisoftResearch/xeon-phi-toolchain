; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc < %s | FileCheck %s --implicit-check-not=cmov --implicit-check-not=pause --implicit-check-not=xmm --implicit-check-not=ymm --implicit-check-not=zmm --implicit-check-not=mfence
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc -filetype=obj < %s -o %t
; RUN: llvm-readobj --file-headers %t | FileCheck %s --check-prefix=ELF
; RUN: not llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc -mattr=+sse2 < %s 2>&1 | FileCheck %s --check-prefix=BAD
; ELF: Machine: {{.*}}(0xB5)
; BAD: KNC scalar target requires 64-bit ELF

declare void @llvm.x86.sse2.pause()
; CHECK-LABEL: choose64:
; CHECK: j
; CHECK: retq
define i64 @choose64(i64 %a, i64 %b, i1 %c) {
  %r = select i1 %c, i64 %a, i64 %b
  ret i64 %r
}
; CHECK-LABEL: choose32:
; CHECK: j
; CHECK: retq
define i32 @choose32(i32 %a, i32 %b, i1 %c) {
  %r = select i1 %c, i32 %a, i32 %b
  ret i32 %r
}
; CHECK-LABEL: atomic_add:
; CHECK: lock
; CHECK: xaddq
; CHECK: retq
define i64 @atomic_add(ptr %p, i64 %n) {
  %r = atomicrmw add ptr %p, i64 %n seq_cst
  ret i64 %r
}
; CHECK-LABEL: spin:
; CHECK: nop
; CHECK: retq
define void @spin() {
  call void @llvm.x86.sse2.pause()
  ret void
}
; CHECK-LABEL: external:
; CHECK: callq
; CHECK: retq
declare i64 @foreign(i64)
define i64 @external(i64 %n) {
  %r = call i64 @foreign(i64 %n)
  %s = add i64 %r, 1
  ret i64 %s
}
; CHECK-LABEL: full_fence:
; CHECK: lock
; CHECK: retq
define void @full_fence() {
  fence seq_cst
  ret void
}

; Regression: function-level Rust CPU attributes override llc's CPU flag.
; The KNC feature must remain active even on a function tagged x86-64.
; CHECK-LABEL: rust_cpu_select:
; CHECK: j
; CHECK: retq
define i64 @rust_cpu_select(i64 %a, i64 %b, i1 %c) #0 {
  %r = select i1 %c, i64 %a, i64 %b
  ret i64 %r
}
attributes #0 = { "target-cpu"="x86-64" "target-features"="+knc,-sse,-sse2,-mmx,-cmov,-cx16,+soft-float" }
