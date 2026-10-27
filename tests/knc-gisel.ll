; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc -global-isel -global-isel-abort=1 < %s | FileCheck %s --implicit-check-not=cmov
; CHECK-LABEL: select64:
; CHECK: j
; CHECK: retq
define i64 @select64(i64 %a, i64 %b, i1 %c) {
  %r = select i1 %c, i64 %a, i64 %b
  ret i64 %r
}
