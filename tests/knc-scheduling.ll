; REQUIRES: asserts
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -debug-only=machine-scheduler < %s -o /dev/null 2>&1 | FileCheck %s
; Verify that the measured latencies reach the machine scheduler.
; CHECK: SU({{[0-9]+}}): {{.*}}KNC_VPERMDrr
; CHECK: Latency            : 6
; CHECK: SU({{[0-9]+}}): {{.*}}KNC_VPADDDrr
; CHECK: Latency            : 4
; CHECK: SU({{[0-9]+}}): {{.*}}KNC_VPMULLDrr
; CHECK: Latency            : 4
; CHECK: SU({{[0-9]+}}): {{.*}}KNC_VPSLLVDrr
; CHECK: Latency            : 4
target triple = "x86_64-unknown-linux-gnu"
define void @schedule_i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %p=shufflevector <16 x i32> %x,<16 x i32> poison,<16 x i32> <i32 15,i32 14,i32 13,i32 12,i32 11,i32 10,i32 9,i32 8,i32 7,i32 6,i32 5,i32 4,i32 3,i32 2,i32 1,i32 0>
 %s=add <16 x i32> %p,%y
 %m=mul <16 x i32> %s,%y
 %counts=and <16 x i32> %x,splat(i32 31)
 %r=shl <16 x i32> %m,%counts
 store <16 x i32> %r,ptr %out,align 64
 ret void
}
; CHECK: SU({{[0-9]+}}): {{.*}}KNC_VPMULHUDrr
; CHECK: Latency            : 4
define void @schedule_i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 64
 %y=load <8 x i64>,ptr %b,align 64
 %r=mul <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 64
 ret void
}
