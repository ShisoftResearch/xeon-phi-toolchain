; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc -filetype=obj %s -o %t
; RUN: llvm-objdump -d --triple=x86_64-unknown-linux-gnu %t | FileCheck %s --implicit-check-not=tzcnt
; CHECK-LABEL: <count_trailing>:
; CHECK: bsf
; CHECK: ret
declare i64 @llvm.cttz.i64(i64, i1 immarg)
define i64 @count_trailing(i64 %x) {
 %r = call i64 @llvm.cttz.i64(i64 %x, i1 false)
 ret i64 %r
}
