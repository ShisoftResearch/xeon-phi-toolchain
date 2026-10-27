; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc -filetype=obj %s -o %t
; RUN: llvm-readobj --hex-dump=.text %t | FileCheck %s
; CHECK: 554889e5 4883e4c0 4883ec40 62f17908
; CHECK-NEXT: {{.*}}6f0662f1 79086f0a 62f17908 fec162f1
; CHECK-NEXT: {{.*}}79087f07 4889ec5d c3
; Encodings independently assembled by MPSS binutils for the same registers.
declare void @llvm.x86.knc.vadd.i32(ptr,ptr,ptr)
define void @knc_add(ptr %out,ptr %lhs,ptr %rhs) {
 call void @llvm.x86.knc.vadd.i32(ptr %out,ptr %lhs,ptr %rhs)
 ret void
}
