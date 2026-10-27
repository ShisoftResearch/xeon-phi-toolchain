; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes=scalarize-masked-mem-intrin -S < %s | FileCheck %s --check-prefix=KEEP
; KEEP: call <16 x i32> @llvm.masked.gather
; KEEP: call void @llvm.masked.scatter
 target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: gather_i32:
; CHECK: knc.vpgatherdd
; CHECK: jne
define void @gather_i32(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i32>, ptr %indices, align 4
 %p = getelementptr i32, ptr %base, <16 x i32> %ix
 %v = load <16 x i32>, ptr %values, align 4
 %r = call <16 x i32> @llvm.masked.gather.v16i32.v16p0(<16 x ptr> align 4 %p, <16 x i1> %mask, <16 x i32> %v)
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: gather_f32:
; CHECK: knc.vpgatherdd
; CHECK: jne
define void @gather_f32(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i32>, ptr %indices, align 4
 %p = getelementptr float, ptr %base, <16 x i32> %ix
 %v = load <16 x float>, ptr %values, align 4
 %r = call <16 x float> @llvm.masked.gather.v16f32.v16p0(<16 x ptr> align 4 %p, <16 x i1> %mask, <16 x float> %v)
 store <16 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: gather_i64:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @gather_i64(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i64>, ptr %indices, align 4
 %p = getelementptr i32, ptr %base, <16 x i64> %ix
 %v = load <16 x i32>, ptr %values, align 4
 %r = call <16 x i32> @llvm.masked.gather.v16i32.v16p0(<16 x ptr> align 4 %p, <16 x i1> %mask, <16 x i32> %v)
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: gather_ptrs:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @gather_ptrs(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %p = load <16 x ptr>, ptr %indices, align 8
 %v = load <16 x i32>, ptr %values, align 4
 %r = call <16 x i32> @llvm.masked.gather.v16i32.v16p0(<16 x ptr> align 4 %p, <16 x i1> %mask, <16 x i32> %v)
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: gather_unaligned:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @gather_unaligned(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i64>, ptr %indices, align 8
 %p = getelementptr i8, ptr %base, <16 x i64> %ix
 %v = load <16 x i32>, ptr %values, align 4
 %r = call <16 x i32> @llvm.masked.gather.v16i32.v16p0(<16 x ptr> align 1 %p, <16 x i1> %mask, <16 x i32> %v)
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: gather_u32:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @gather_u32(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix32 = load <16 x i32>, ptr %indices, align 4
 %ix = zext <16 x i32> %ix32 to <16 x i64>
 %p = getelementptr i32, ptr %base, <16 x i64> %ix
 %v = load <16 x i32>, ptr %values, align 4
 %r = call <16 x i32> @llvm.masked.gather.v16i32.v16p0(<16 x ptr> align 4 %p, <16 x i1> %mask, <16 x i32> %v)
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: scatter_i32:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @scatter_i32(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i32>, ptr %indices, align 4
 %p = getelementptr i32, ptr %base, <16 x i32> %ix
 %v = load <16 x i32>, ptr %values, align 4
 call void @llvm.masked.scatter.v16i32.v16p0(<16 x i32> %v, <16 x ptr> align 4 %p, <16 x i1> %mask)
 ret void
}
; CHECK-LABEL: scatter_f32:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @scatter_f32(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i32>, ptr %indices, align 4
 %p = getelementptr float, ptr %base, <16 x i32> %ix
 %v = load <16 x float>, ptr %values, align 4
 call void @llvm.masked.scatter.v16f32.v16p0(<16 x float> %v, <16 x ptr> align 4 %p, <16 x i1> %mask)
 ret void
}
; CHECK-LABEL: scatter_i64:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @scatter_i64(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i64>, ptr %indices, align 4
 %p = getelementptr i32, ptr %base, <16 x i64> %ix
 %v = load <16 x i32>, ptr %values, align 4
 call void @llvm.masked.scatter.v16i32.v16p0(<16 x i32> %v, <16 x ptr> align 4 %p, <16 x i1> %mask)
 ret void
}
; CHECK-LABEL: scatter_ptrs:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @scatter_ptrs(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %p = load <16 x ptr>, ptr %indices, align 8
 %v = load <16 x i32>, ptr %values, align 4
 call void @llvm.masked.scatter.v16i32.v16p0(<16 x i32> %v, <16 x ptr> align 4 %p, <16 x i1> %mask)
 ret void
}
; CHECK-LABEL: scatter_unaligned:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @scatter_unaligned(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix = load <16 x i64>, ptr %indices, align 8
 %p = getelementptr i8, ptr %base, <16 x i64> %ix
 %v = load <16 x i32>, ptr %values, align 4
 call void @llvm.masked.scatter.v16i32.v16p0(<16 x i32> %v, <16 x ptr> align 1 %p, <16 x i1> %mask)
 ret void
}
; CHECK-LABEL: scatter_u32:
; CHECK-NOT: knc.vpgatherdd
; CHECK: bsfl
; CHECK: jne
define void @scatter_u32(ptr %out, ptr %base, ptr %indices, ptr %values, ptr %maskptr) {
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %ix32 = load <16 x i32>, ptr %indices, align 4
 %ix = zext <16 x i32> %ix32 to <16 x i64>
 %p = getelementptr i32, ptr %base, <16 x i64> %ix
 %v = load <16 x i32>, ptr %values, align 4
 call void @llvm.masked.scatter.v16i32.v16p0(<16 x i32> %v, <16 x ptr> align 4 %p, <16 x i1> %mask)
 ret void
}
declare <16 x i32> @llvm.masked.gather.v16i32.v16p0(<16 x ptr>, <16 x i1>, <16 x i32>)
declare void @llvm.masked.scatter.v16i32.v16p0(<16 x i32>, <16 x ptr>, <16 x i1>)
declare <16 x float> @llvm.masked.gather.v16f32.v16p0(<16 x ptr>, <16 x i1>, <16 x float>)
declare void @llvm.masked.scatter.v16f32.v16p0(<16 x float>, <16 x ptr>, <16 x i1>)

; Multiple generated access loops nested inside a caller's loop must preserve
; the caller's backedge PHIs and the chain from gather through scatter.
; CHECK-LABEL: masked_outer_loop:
; CHECK: bsfl
; CHECK: bsfl
; CHECK: jne
define void @masked_outer_loop(ptr %indices, ptr %maskptr, i32 %rounds) {
entry:
 %p = load <16 x ptr>, ptr %indices, align 8
 %mi = load <16 x i32>, ptr %maskptr, align 4
 %mask = icmp ne <16 x i32> %mi, zeroinitializer
 %run = icmp ne i32 %rounds, 0
 br i1 %run, label %loop, label %done
loop:
 %i = phi i32 [0, %entry], [%next, %loop]
 %v = call <16 x i32> @llvm.masked.gather.v16i32.v16p0(<16 x ptr> align 4 %p, <16 x i1> %mask, <16 x i32> zeroinitializer)
 %added = add <16 x i32> %v, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
 call void @llvm.masked.scatter.v16i32.v16p0(<16 x i32> %added, <16 x ptr> align 4 %p, <16 x i1> %mask)
 %next = add i32 %i, 1
 %again = icmp ult i32 %next, %rounds
 br i1 %again, label %loop, label %done
done:
 ret void
}
