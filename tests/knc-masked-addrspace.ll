; RUN: not --crash llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi < %s 2>&1 | FileCheck %s
; CHECK: KNC masked gather/scatter requires address space zero
; Non-flat pointer address spaces must not lose their FS/GS segment semantics.
target triple = "x86_64-unknown-linux-gnu"
define void @fs_gather(ptr %out, ptr addrspace(257) %base, ptr %indices) {
 %ix = load <16 x i32>, ptr %indices, align 4
 %p = getelementptr i32, ptr addrspace(257) %base, <16 x i32> %ix
 %r = call <16 x i32> @llvm.masked.gather.v16i32.v16p257(<16 x ptr addrspace(257)> align 4 %p, <16 x i1> <i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false>, <16 x i32> zeroinitializer)
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
declare <16 x i32> @llvm.masked.gather.v16i32.v16p257(<16 x ptr addrspace(257)>, <16 x i1>, <16 x i32>)
