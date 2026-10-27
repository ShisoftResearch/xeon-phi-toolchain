; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
define void @half_comp_2_32_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <2 x half>,ptr %base,align 1
 %r=fpext <2 x half> %h to <2 x float>
 store <2 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_32_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <2 x float>,ptr %values,align 1
 %h=fptrunc <2 x float> %x to <2 x half>
 store <2 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_2_32_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.load.v2f16.p0(ptr align 1 %base,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x float>
 store <2 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_32_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %x=load <2 x float>,ptr %values,align 1
 %h=fptrunc <2 x float> %x to <2 x half>
 call void @llvm.masked.store.v2f16.p0(<2 x half> %h,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
define void @half_comp_2_32_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.load.v2f16.p0(ptr align 2 %base,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x float>
 store <2 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_32_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %x=load <2 x float>,ptr %values,align 1
 %h=fptrunc <2 x float> %x to <2 x half>
 call void @llvm.masked.store.v2f16.p0(<2 x half> %h,ptr align 2 %base,<2 x i1> %mask)
 ret void
}
define void @half_comp_2_32_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.gather.v2f16.v2p0(<2 x ptr> %ptrs,i32 1,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x float>
 store <2 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_32_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %x=load <2 x float>,ptr %values,align 1
 %h=fptrunc <2 x float> %x to <2 x half>
 call void @llvm.masked.scatter.v2f16.v2p0(<2 x half> %h,<2 x ptr> %ptrs,i32 1,<2 x i1> %mask)
 ret void
}
define void @half_comp_2_32_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.gather.v2f16.v2p0(<2 x ptr> %ptrs,i32 2,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x float>
 store <2 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_32_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %x=load <2 x float>,ptr %values,align 1
 %h=fptrunc <2 x float> %x to <2 x half>
 call void @llvm.masked.scatter.v2f16.v2p0(<2 x half> %h,<2 x ptr> %ptrs,i32 2,<2 x i1> %mask)
 ret void
}
define void @half_comp_2_64_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <2 x half>,ptr %base,align 1
 %r=fpext <2 x half> %h to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_64_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <2 x double>,ptr %values,align 1
 %h=fptrunc <2 x double> %x to <2 x half>
 store <2 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_2_64_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.load.v2f16.p0(ptr align 1 %base,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_64_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %x=load <2 x double>,ptr %values,align 1
 %h=fptrunc <2 x double> %x to <2 x half>
 call void @llvm.masked.store.v2f16.p0(<2 x half> %h,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
define void @half_comp_2_64_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.load.v2f16.p0(ptr align 2 %base,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_64_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %x=load <2 x double>,ptr %values,align 1
 %h=fptrunc <2 x double> %x to <2 x half>
 call void @llvm.masked.store.v2f16.p0(<2 x half> %h,ptr align 2 %base,<2 x i1> %mask)
 ret void
}
define void @half_comp_2_64_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.gather.v2f16.v2p0(<2 x ptr> %ptrs,i32 1,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_64_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %x=load <2 x double>,ptr %values,align 1
 %h=fptrunc <2 x double> %x to <2 x half>
 call void @llvm.masked.scatter.v2f16.v2p0(<2 x half> %h,<2 x ptr> %ptrs,i32 1,<2 x i1> %mask)
 ret void
}
define void @half_comp_2_64_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %pass=load <2 x half>,ptr %values,align 1
 %h=call <2 x half> @llvm.masked.gather.v2f16.v2p0(<2 x ptr> %ptrs,i32 2,<2 x i1> %mask,<2 x half> %pass)
 %r=fpext <2 x half> %h to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_2_64_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <2 x i32>,ptr %mp,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %x=load <2 x double>,ptr %values,align 1
 %h=fptrunc <2 x double> %x to <2 x half>
 call void @llvm.masked.scatter.v2f16.v2p0(<2 x half> %h,<2 x ptr> %ptrs,i32 2,<2 x i1> %mask)
 ret void
}
define void @half_comp_4_32_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <4 x half>,ptr %base,align 1
 %r=fpext <4 x half> %h to <4 x float>
 store <4 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_32_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <4 x float>,ptr %values,align 1
 %h=fptrunc <4 x float> %x to <4 x half>
 store <4 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_4_32_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.load.v4f16.p0(ptr align 1 %base,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x float>
 store <4 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_32_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %x=load <4 x float>,ptr %values,align 1
 %h=fptrunc <4 x float> %x to <4 x half>
 call void @llvm.masked.store.v4f16.p0(<4 x half> %h,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
define void @half_comp_4_32_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.load.v4f16.p0(ptr align 2 %base,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x float>
 store <4 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_32_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %x=load <4 x float>,ptr %values,align 1
 %h=fptrunc <4 x float> %x to <4 x half>
 call void @llvm.masked.store.v4f16.p0(<4 x half> %h,ptr align 2 %base,<4 x i1> %mask)
 ret void
}
define void @half_comp_4_32_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.gather.v4f16.v4p0(<4 x ptr> %ptrs,i32 1,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x float>
 store <4 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_32_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %x=load <4 x float>,ptr %values,align 1
 %h=fptrunc <4 x float> %x to <4 x half>
 call void @llvm.masked.scatter.v4f16.v4p0(<4 x half> %h,<4 x ptr> %ptrs,i32 1,<4 x i1> %mask)
 ret void
}
define void @half_comp_4_32_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.gather.v4f16.v4p0(<4 x ptr> %ptrs,i32 2,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x float>
 store <4 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_32_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %x=load <4 x float>,ptr %values,align 1
 %h=fptrunc <4 x float> %x to <4 x half>
 call void @llvm.masked.scatter.v4f16.v4p0(<4 x half> %h,<4 x ptr> %ptrs,i32 2,<4 x i1> %mask)
 ret void
}
define void @half_comp_4_64_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <4 x half>,ptr %base,align 1
 %r=fpext <4 x half> %h to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_64_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <4 x double>,ptr %values,align 1
 %h=fptrunc <4 x double> %x to <4 x half>
 store <4 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_4_64_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.load.v4f16.p0(ptr align 1 %base,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_64_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %x=load <4 x double>,ptr %values,align 1
 %h=fptrunc <4 x double> %x to <4 x half>
 call void @llvm.masked.store.v4f16.p0(<4 x half> %h,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
define void @half_comp_4_64_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.load.v4f16.p0(ptr align 2 %base,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_64_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %x=load <4 x double>,ptr %values,align 1
 %h=fptrunc <4 x double> %x to <4 x half>
 call void @llvm.masked.store.v4f16.p0(<4 x half> %h,ptr align 2 %base,<4 x i1> %mask)
 ret void
}
define void @half_comp_4_64_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.gather.v4f16.v4p0(<4 x ptr> %ptrs,i32 1,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_64_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %x=load <4 x double>,ptr %values,align 1
 %h=fptrunc <4 x double> %x to <4 x half>
 call void @llvm.masked.scatter.v4f16.v4p0(<4 x half> %h,<4 x ptr> %ptrs,i32 1,<4 x i1> %mask)
 ret void
}
define void @half_comp_4_64_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %pass=load <4 x half>,ptr %values,align 1
 %h=call <4 x half> @llvm.masked.gather.v4f16.v4p0(<4 x ptr> %ptrs,i32 2,<4 x i1> %mask,<4 x half> %pass)
 %r=fpext <4 x half> %h to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_4_64_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <4 x i32>,ptr %mp,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %x=load <4 x double>,ptr %values,align 1
 %h=fptrunc <4 x double> %x to <4 x half>
 call void @llvm.masked.scatter.v4f16.v4p0(<4 x half> %h,<4 x ptr> %ptrs,i32 2,<4 x i1> %mask)
 ret void
}
define void @half_comp_8_32_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <8 x half>,ptr %base,align 1
 %r=fpext <8 x half> %h to <8 x float>
 store <8 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_32_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <8 x float>,ptr %values,align 1
 %h=fptrunc <8 x float> %x to <8 x half>
 store <8 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_8_32_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.load.v8f16.p0(ptr align 1 %base,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x float>
 store <8 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_32_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %x=load <8 x float>,ptr %values,align 1
 %h=fptrunc <8 x float> %x to <8 x half>
 call void @llvm.masked.store.v8f16.p0(<8 x half> %h,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
define void @half_comp_8_32_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.load.v8f16.p0(ptr align 2 %base,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x float>
 store <8 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_32_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %x=load <8 x float>,ptr %values,align 1
 %h=fptrunc <8 x float> %x to <8 x half>
 call void @llvm.masked.store.v8f16.p0(<8 x half> %h,ptr align 2 %base,<8 x i1> %mask)
 ret void
}
define void @half_comp_8_32_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.gather.v8f16.v8p0(<8 x ptr> %ptrs,i32 1,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x float>
 store <8 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_32_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %x=load <8 x float>,ptr %values,align 1
 %h=fptrunc <8 x float> %x to <8 x half>
 call void @llvm.masked.scatter.v8f16.v8p0(<8 x half> %h,<8 x ptr> %ptrs,i32 1,<8 x i1> %mask)
 ret void
}
define void @half_comp_8_32_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.gather.v8f16.v8p0(<8 x ptr> %ptrs,i32 2,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x float>
 store <8 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_32_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %x=load <8 x float>,ptr %values,align 1
 %h=fptrunc <8 x float> %x to <8 x half>
 call void @llvm.masked.scatter.v8f16.v8p0(<8 x half> %h,<8 x ptr> %ptrs,i32 2,<8 x i1> %mask)
 ret void
}
define void @half_comp_8_64_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <8 x half>,ptr %base,align 1
 %r=fpext <8 x half> %h to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_64_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <8 x double>,ptr %values,align 1
 %h=fptrunc <8 x double> %x to <8 x half>
 store <8 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_8_64_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.load.v8f16.p0(ptr align 1 %base,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_64_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %x=load <8 x double>,ptr %values,align 1
 %h=fptrunc <8 x double> %x to <8 x half>
 call void @llvm.masked.store.v8f16.p0(<8 x half> %h,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
define void @half_comp_8_64_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.load.v8f16.p0(ptr align 2 %base,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_64_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %x=load <8 x double>,ptr %values,align 1
 %h=fptrunc <8 x double> %x to <8 x half>
 call void @llvm.masked.store.v8f16.p0(<8 x half> %h,ptr align 2 %base,<8 x i1> %mask)
 ret void
}
define void @half_comp_8_64_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.gather.v8f16.v8p0(<8 x ptr> %ptrs,i32 1,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_64_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %x=load <8 x double>,ptr %values,align 1
 %h=fptrunc <8 x double> %x to <8 x half>
 call void @llvm.masked.scatter.v8f16.v8p0(<8 x half> %h,<8 x ptr> %ptrs,i32 1,<8 x i1> %mask)
 ret void
}
define void @half_comp_8_64_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %pass=load <8 x half>,ptr %values,align 1
 %h=call <8 x half> @llvm.masked.gather.v8f16.v8p0(<8 x ptr> %ptrs,i32 2,<8 x i1> %mask,<8 x half> %pass)
 %r=fpext <8 x half> %h to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_8_64_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <8 x i32>,ptr %mp,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %x=load <8 x double>,ptr %values,align 1
 %h=fptrunc <8 x double> %x to <8 x half>
 call void @llvm.masked.scatter.v8f16.v8p0(<8 x half> %h,<8 x ptr> %ptrs,i32 2,<8 x i1> %mask)
 ret void
}
define void @half_comp_16_32_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <16 x half>,ptr %base,align 1
 %r=fpext <16 x half> %h to <16 x float>
 store <16 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_32_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <16 x float>,ptr %values,align 1
 %h=fptrunc <16 x float> %x to <16 x half>
 store <16 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_16_32_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.load.v16f16.p0(ptr align 1 %base,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x float>
 store <16 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_32_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %x=load <16 x float>,ptr %values,align 1
 %h=fptrunc <16 x float> %x to <16 x half>
 call void @llvm.masked.store.v16f16.p0(<16 x half> %h,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
define void @half_comp_16_32_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.load.v16f16.p0(ptr align 2 %base,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x float>
 store <16 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_32_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %x=load <16 x float>,ptr %values,align 1
 %h=fptrunc <16 x float> %x to <16 x half>
 call void @llvm.masked.store.v16f16.p0(<16 x half> %h,ptr align 2 %base,<16 x i1> %mask)
 ret void
}
define void @half_comp_16_32_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.gather.v16f16.v16p0(<16 x ptr> %ptrs,i32 1,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x float>
 store <16 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_32_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %x=load <16 x float>,ptr %values,align 1
 %h=fptrunc <16 x float> %x to <16 x half>
 call void @llvm.masked.scatter.v16f16.v16p0(<16 x half> %h,<16 x ptr> %ptrs,i32 1,<16 x i1> %mask)
 ret void
}
define void @half_comp_16_32_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.gather.v16f16.v16p0(<16 x ptr> %ptrs,i32 2,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x float>
 store <16 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_32_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %x=load <16 x float>,ptr %values,align 1
 %h=fptrunc <16 x float> %x to <16 x half>
 call void @llvm.masked.scatter.v16f16.v16p0(<16 x half> %h,<16 x ptr> %ptrs,i32 2,<16 x i1> %mask)
 ret void
}
define void @half_comp_16_64_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <16 x half>,ptr %base,align 1
 %r=fpext <16 x half> %h to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_64_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <16 x double>,ptr %values,align 1
 %h=fptrunc <16 x double> %x to <16 x half>
 store <16 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_16_64_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.load.v16f16.p0(ptr align 1 %base,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_64_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %x=load <16 x double>,ptr %values,align 1
 %h=fptrunc <16 x double> %x to <16 x half>
 call void @llvm.masked.store.v16f16.p0(<16 x half> %h,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
define void @half_comp_16_64_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.load.v16f16.p0(ptr align 2 %base,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_64_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %x=load <16 x double>,ptr %values,align 1
 %h=fptrunc <16 x double> %x to <16 x half>
 call void @llvm.masked.store.v16f16.p0(<16 x half> %h,ptr align 2 %base,<16 x i1> %mask)
 ret void
}
define void @half_comp_16_64_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.gather.v16f16.v16p0(<16 x ptr> %ptrs,i32 1,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_64_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %x=load <16 x double>,ptr %values,align 1
 %h=fptrunc <16 x double> %x to <16 x half>
 call void @llvm.masked.scatter.v16f16.v16p0(<16 x half> %h,<16 x ptr> %ptrs,i32 1,<16 x i1> %mask)
 ret void
}
define void @half_comp_16_64_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %pass=load <16 x half>,ptr %values,align 1
 %h=call <16 x half> @llvm.masked.gather.v16f16.v16p0(<16 x ptr> %ptrs,i32 2,<16 x i1> %mask,<16 x half> %pass)
 %r=fpext <16 x half> %h to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_16_64_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <16 x i32>,ptr %mp,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %x=load <16 x double>,ptr %values,align 1
 %h=fptrunc <16 x double> %x to <16 x half>
 call void @llvm.masked.scatter.v16f16.v16p0(<16 x half> %h,<16 x ptr> %ptrs,i32 2,<16 x i1> %mask)
 ret void
}
define void @half_comp_32_32_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <32 x half>,ptr %base,align 1
 %r=fpext <32 x half> %h to <32 x float>
 store <32 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_32_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <32 x float>,ptr %values,align 1
 %h=fptrunc <32 x float> %x to <32 x half>
 store <32 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_32_32_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.load.v32f16.p0(ptr align 1 %base,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x float>
 store <32 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_32_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %x=load <32 x float>,ptr %values,align 1
 %h=fptrunc <32 x float> %x to <32 x half>
 call void @llvm.masked.store.v32f16.p0(<32 x half> %h,ptr align 1 %base,<32 x i1> %mask)
 ret void
}
define void @half_comp_32_32_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.load.v32f16.p0(ptr align 2 %base,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x float>
 store <32 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_32_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %x=load <32 x float>,ptr %values,align 1
 %h=fptrunc <32 x float> %x to <32 x half>
 call void @llvm.masked.store.v32f16.p0(<32 x half> %h,ptr align 2 %base,<32 x i1> %mask)
 ret void
}
define void @half_comp_32_32_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.gather.v32f16.v32p0(<32 x ptr> %ptrs,i32 1,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x float>
 store <32 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_32_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %x=load <32 x float>,ptr %values,align 1
 %h=fptrunc <32 x float> %x to <32 x half>
 call void @llvm.masked.scatter.v32f16.v32p0(<32 x half> %h,<32 x ptr> %ptrs,i32 1,<32 x i1> %mask)
 ret void
}
define void @half_comp_32_32_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.gather.v32f16.v32p0(<32 x ptr> %ptrs,i32 2,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x float>
 store <32 x float> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_32_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %x=load <32 x float>,ptr %values,align 1
 %h=fptrunc <32 x float> %x to <32 x half>
 call void @llvm.masked.scatter.v32f16.v32p0(<32 x half> %h,<32 x ptr> %ptrs,i32 2,<32 x i1> %mask)
 ret void
}
define void @half_comp_32_64_plain_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %h=load <32 x half>,ptr %base,align 1
 %r=fpext <32 x half> %h to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_64_plain_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %x=load <32 x double>,ptr %values,align 1
 %h=fptrunc <32 x double> %x to <32 x half>
 store <32 x half> %h,ptr %base,align 1
 ret void
}
define void @half_comp_32_64_contig_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.load.v32f16.p0(ptr align 1 %base,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_64_contig_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %x=load <32 x double>,ptr %values,align 1
 %h=fptrunc <32 x double> %x to <32 x half>
 call void @llvm.masked.store.v32f16.p0(<32 x half> %h,ptr align 1 %base,<32 x i1> %mask)
 ret void
}
define void @half_comp_32_64_contig_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.load.v32f16.p0(ptr align 2 %base,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_64_contig_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %x=load <32 x double>,ptr %values,align 1
 %h=fptrunc <32 x double> %x to <32 x half>
 call void @llvm.masked.store.v32f16.p0(<32 x half> %h,ptr align 2 %base,<32 x i1> %mask)
 ret void
}
define void @half_comp_32_64_indexed_1_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.gather.v32f16.v32p0(<32 x ptr> %ptrs,i32 1,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_64_indexed_1_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %x=load <32 x double>,ptr %values,align 1
 %h=fptrunc <32 x double> %x to <32 x half>
 call void @llvm.masked.scatter.v32f16.v32p0(<32 x half> %h,<32 x ptr> %ptrs,i32 1,<32 x i1> %mask)
 ret void
}
define void @half_comp_32_64_indexed_2_0(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %pass=load <32 x half>,ptr %values,align 1
 %h=call <32 x half> @llvm.masked.gather.v32f16.v32p0(<32 x ptr> %ptrs,i32 2,<32 x i1> %mask,<32 x half> %pass)
 %r=fpext <32 x half> %h to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @half_comp_32_64_indexed_2_1(ptr %out,ptr %base,ptr %values,ptr %mp) {
 %mi=load <32 x i32>,ptr %mp,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %x=load <32 x double>,ptr %values,align 1
 %h=fptrunc <32 x double> %x to <32 x half>
 call void @llvm.masked.scatter.v32f16.v32p0(<32 x half> %h,<32 x ptr> %ptrs,i32 2,<32 x i1> %mask)
 ret void
}
declare <16 x half> @llvm.masked.gather.v16f16.v16p0(<16 x ptr>,i32 immarg,<16 x i1>,<16 x half>)
declare <16 x half> @llvm.masked.load.v16f16.p0(ptr,<16 x i1>,<16 x half>)
declare <2 x half> @llvm.masked.gather.v2f16.v2p0(<2 x ptr>,i32 immarg,<2 x i1>,<2 x half>)
declare <2 x half> @llvm.masked.load.v2f16.p0(ptr,<2 x i1>,<2 x half>)
declare <32 x half> @llvm.masked.gather.v32f16.v32p0(<32 x ptr>,i32 immarg,<32 x i1>,<32 x half>)
declare <32 x half> @llvm.masked.load.v32f16.p0(ptr,<32 x i1>,<32 x half>)
declare <4 x half> @llvm.masked.gather.v4f16.v4p0(<4 x ptr>,i32 immarg,<4 x i1>,<4 x half>)
declare <4 x half> @llvm.masked.load.v4f16.p0(ptr,<4 x i1>,<4 x half>)
declare <8 x half> @llvm.masked.gather.v8f16.v8p0(<8 x ptr>,i32 immarg,<8 x i1>,<8 x half>)
declare <8 x half> @llvm.masked.load.v8f16.p0(ptr,<8 x i1>,<8 x half>)
declare void @llvm.masked.scatter.v16f16.v16p0(<16 x half>,<16 x ptr>,i32 immarg,<16 x i1>)
declare void @llvm.masked.scatter.v2f16.v2p0(<2 x half>,<2 x ptr>,i32 immarg,<2 x i1>)
declare void @llvm.masked.scatter.v32f16.v32p0(<32 x half>,<32 x ptr>,i32 immarg,<32 x i1>)
declare void @llvm.masked.scatter.v4f16.v4p0(<4 x half>,<4 x ptr>,i32 immarg,<4 x i1>)
declare void @llvm.masked.scatter.v8f16.v8p0(<8 x half>,<8 x ptr>,i32 immarg,<8 x i1>)
declare void @llvm.masked.store.v16f16.p0(<16 x half>,ptr,<16 x i1>)
declare void @llvm.masked.store.v2f16.p0(<2 x half>,ptr,<2 x i1>)
declare void @llvm.masked.store.v32f16.p0(<32 x half>,ptr,<32 x i1>)
declare void @llvm.masked.store.v4f16.p0(<4 x half>,ptr,<4 x i1>)
declare void @llvm.masked.store.v8f16.p0(<8 x half>,ptr,<8 x i1>)
