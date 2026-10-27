; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
define void @masked_fp_load_2_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %pass=load <2 x float>,ptr %values,align 1
 %x=call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 1 %base,<2 x i1> %mask,<2 x float> %pass)
 %r=fpext <2 x float> %x to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_2_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %x=load <2 x double>,ptr %values,align 1
 %r=fptrunc <2 x double> %x to <2 x float>
 call void @llvm.masked.store.v2f32.p0(<2 x float> %r,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
define void @masked_fp_load_2_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %pass=load <2 x float>,ptr %values,align 1
 %x=call <2 x float> @llvm.masked.load.v2f32.p0(ptr align 4 %base,<2 x i1> %mask,<2 x float> %pass)
 %r=fpext <2 x float> %x to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_2_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %x=load <2 x double>,ptr %values,align 1
 %r=fptrunc <2 x double> %x to <2 x float>
 call void @llvm.masked.store.v2f32.p0(<2 x float> %r,ptr align 4 %base,<2 x i1> %mask)
 ret void
}
define void @masked_fp_load_2_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %pass=load <2 x float>,ptr %values,align 1
 %x=call <2 x float> @llvm.masked.gather.v2f32.v2p0(<2 x ptr> %ptrs,i32 1,<2 x i1> %mask,<2 x float> %pass)
 %r=fpext <2 x float> %x to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_2_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %x=load <2 x double>,ptr %values,align 1
 %r=fptrunc <2 x double> %x to <2 x float>
 call void @llvm.masked.scatter.v2f32.v2p0(<2 x float> %r,<2 x ptr> %ptrs,i32 1,<2 x i1> %mask)
 ret void
}
define void @masked_fp_load_2_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %pass=load <2 x float>,ptr %values,align 1
 %x=call <2 x float> @llvm.masked.gather.v2f32.v2p0(<2 x ptr> %ptrs,i32 4,<2 x i1> %mask,<2 x float> %pass)
 %r=fpext <2 x float> %x to <2 x double>
 store <2 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_2_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %ptrs=load <2 x ptr>,ptr %base,align 8
 %x=load <2 x double>,ptr %values,align 1
 %r=fptrunc <2 x double> %x to <2 x float>
 call void @llvm.masked.scatter.v2f32.v2p0(<2 x float> %r,<2 x ptr> %ptrs,i32 4,<2 x i1> %mask)
 ret void
}
define void @masked_fp_load_4_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %pass=load <4 x float>,ptr %values,align 1
 %x=call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 1 %base,<4 x i1> %mask,<4 x float> %pass)
 %r=fpext <4 x float> %x to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_4_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %x=load <4 x double>,ptr %values,align 1
 %r=fptrunc <4 x double> %x to <4 x float>
 call void @llvm.masked.store.v4f32.p0(<4 x float> %r,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
define void @masked_fp_load_4_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %pass=load <4 x float>,ptr %values,align 1
 %x=call <4 x float> @llvm.masked.load.v4f32.p0(ptr align 4 %base,<4 x i1> %mask,<4 x float> %pass)
 %r=fpext <4 x float> %x to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_4_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %x=load <4 x double>,ptr %values,align 1
 %r=fptrunc <4 x double> %x to <4 x float>
 call void @llvm.masked.store.v4f32.p0(<4 x float> %r,ptr align 4 %base,<4 x i1> %mask)
 ret void
}
define void @masked_fp_load_4_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %pass=load <4 x float>,ptr %values,align 1
 %x=call <4 x float> @llvm.masked.gather.v4f32.v4p0(<4 x ptr> %ptrs,i32 1,<4 x i1> %mask,<4 x float> %pass)
 %r=fpext <4 x float> %x to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_4_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %x=load <4 x double>,ptr %values,align 1
 %r=fptrunc <4 x double> %x to <4 x float>
 call void @llvm.masked.scatter.v4f32.v4p0(<4 x float> %r,<4 x ptr> %ptrs,i32 1,<4 x i1> %mask)
 ret void
}
define void @masked_fp_load_4_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %pass=load <4 x float>,ptr %values,align 1
 %x=call <4 x float> @llvm.masked.gather.v4f32.v4p0(<4 x ptr> %ptrs,i32 4,<4 x i1> %mask,<4 x float> %pass)
 %r=fpext <4 x float> %x to <4 x double>
 store <4 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_4_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %ptrs=load <4 x ptr>,ptr %base,align 8
 %x=load <4 x double>,ptr %values,align 1
 %r=fptrunc <4 x double> %x to <4 x float>
 call void @llvm.masked.scatter.v4f32.v4p0(<4 x float> %r,<4 x ptr> %ptrs,i32 4,<4 x i1> %mask)
 ret void
}
define void @masked_fp_load_8_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %pass=load <8 x float>,ptr %values,align 1
 %x=call <8 x float> @llvm.masked.load.v8f32.p0(ptr align 1 %base,<8 x i1> %mask,<8 x float> %pass)
 %r=fpext <8 x float> %x to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_8_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %x=load <8 x double>,ptr %values,align 1
 %r=fptrunc <8 x double> %x to <8 x float>
 call void @llvm.masked.store.v8f32.p0(<8 x float> %r,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
define void @masked_fp_load_8_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %pass=load <8 x float>,ptr %values,align 1
 %x=call <8 x float> @llvm.masked.load.v8f32.p0(ptr align 4 %base,<8 x i1> %mask,<8 x float> %pass)
 %r=fpext <8 x float> %x to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_8_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %x=load <8 x double>,ptr %values,align 1
 %r=fptrunc <8 x double> %x to <8 x float>
 call void @llvm.masked.store.v8f32.p0(<8 x float> %r,ptr align 4 %base,<8 x i1> %mask)
 ret void
}
define void @masked_fp_load_8_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %pass=load <8 x float>,ptr %values,align 1
 %x=call <8 x float> @llvm.masked.gather.v8f32.v8p0(<8 x ptr> %ptrs,i32 1,<8 x i1> %mask,<8 x float> %pass)
 %r=fpext <8 x float> %x to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_8_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %x=load <8 x double>,ptr %values,align 1
 %r=fptrunc <8 x double> %x to <8 x float>
 call void @llvm.masked.scatter.v8f32.v8p0(<8 x float> %r,<8 x ptr> %ptrs,i32 1,<8 x i1> %mask)
 ret void
}
define void @masked_fp_load_8_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %pass=load <8 x float>,ptr %values,align 1
 %x=call <8 x float> @llvm.masked.gather.v8f32.v8p0(<8 x ptr> %ptrs,i32 4,<8 x i1> %mask,<8 x float> %pass)
 %r=fpext <8 x float> %x to <8 x double>
 store <8 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_8_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %ptrs=load <8 x ptr>,ptr %base,align 8
 %x=load <8 x double>,ptr %values,align 1
 %r=fptrunc <8 x double> %x to <8 x float>
 call void @llvm.masked.scatter.v8f32.v8p0(<8 x float> %r,<8 x ptr> %ptrs,i32 4,<8 x i1> %mask)
 ret void
}
define void @masked_fp_load_16_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %pass=load <16 x float>,ptr %values,align 1
 %x=call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 1 %base,<16 x i1> %mask,<16 x float> %pass)
 %r=fpext <16 x float> %x to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_16_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %x=load <16 x double>,ptr %values,align 1
 %r=fptrunc <16 x double> %x to <16 x float>
 call void @llvm.masked.store.v16f32.p0(<16 x float> %r,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
define void @masked_fp_load_16_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %pass=load <16 x float>,ptr %values,align 1
 %x=call <16 x float> @llvm.masked.load.v16f32.p0(ptr align 4 %base,<16 x i1> %mask,<16 x float> %pass)
 %r=fpext <16 x float> %x to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_16_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %x=load <16 x double>,ptr %values,align 1
 %r=fptrunc <16 x double> %x to <16 x float>
 call void @llvm.masked.store.v16f32.p0(<16 x float> %r,ptr align 4 %base,<16 x i1> %mask)
 ret void
}
define void @masked_fp_load_16_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %pass=load <16 x float>,ptr %values,align 1
 %x=call <16 x float> @llvm.masked.gather.v16f32.v16p0(<16 x ptr> %ptrs,i32 1,<16 x i1> %mask,<16 x float> %pass)
 %r=fpext <16 x float> %x to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_16_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %x=load <16 x double>,ptr %values,align 1
 %r=fptrunc <16 x double> %x to <16 x float>
 call void @llvm.masked.scatter.v16f32.v16p0(<16 x float> %r,<16 x ptr> %ptrs,i32 1,<16 x i1> %mask)
 ret void
}
define void @masked_fp_load_16_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %pass=load <16 x float>,ptr %values,align 1
 %x=call <16 x float> @llvm.masked.gather.v16f32.v16p0(<16 x ptr> %ptrs,i32 4,<16 x i1> %mask,<16 x float> %pass)
 %r=fpext <16 x float> %x to <16 x double>
 store <16 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_16_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %ptrs=load <16 x ptr>,ptr %base,align 8
 %x=load <16 x double>,ptr %values,align 1
 %r=fptrunc <16 x double> %x to <16 x float>
 call void @llvm.masked.scatter.v16f32.v16p0(<16 x float> %r,<16 x ptr> %ptrs,i32 4,<16 x i1> %mask)
 ret void
}
define void @masked_fp_load_32_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %pass=load <32 x float>,ptr %values,align 1
 %x=call <32 x float> @llvm.masked.load.v32f32.p0(ptr align 1 %base,<32 x i1> %mask,<32 x float> %pass)
 %r=fpext <32 x float> %x to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_32_0_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %x=load <32 x double>,ptr %values,align 1
 %r=fptrunc <32 x double> %x to <32 x float>
 call void @llvm.masked.store.v32f32.p0(<32 x float> %r,ptr align 1 %base,<32 x i1> %mask)
 ret void
}
define void @masked_fp_load_32_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %pass=load <32 x float>,ptr %values,align 1
 %x=call <32 x float> @llvm.masked.load.v32f32.p0(ptr align 4 %base,<32 x i1> %mask,<32 x float> %pass)
 %r=fpext <32 x float> %x to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_32_0_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %x=load <32 x double>,ptr %values,align 1
 %r=fptrunc <32 x double> %x to <32 x float>
 call void @llvm.masked.store.v32f32.p0(<32 x float> %r,ptr align 4 %base,<32 x i1> %mask)
 ret void
}
define void @masked_fp_load_32_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %pass=load <32 x float>,ptr %values,align 1
 %x=call <32 x float> @llvm.masked.gather.v32f32.v32p0(<32 x ptr> %ptrs,i32 1,<32 x i1> %mask,<32 x float> %pass)
 %r=fpext <32 x float> %x to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_32_1_1(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %x=load <32 x double>,ptr %values,align 1
 %r=fptrunc <32 x double> %x to <32 x float>
 call void @llvm.masked.scatter.v32f32.v32p0(<32 x float> %r,<32 x ptr> %ptrs,i32 1,<32 x i1> %mask)
 ret void
}
define void @masked_fp_load_32_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %pass=load <32 x float>,ptr %values,align 1
 %x=call <32 x float> @llvm.masked.gather.v32f32.v32p0(<32 x ptr> %ptrs,i32 4,<32 x i1> %mask,<32 x float> %pass)
 %r=fpext <32 x float> %x to <32 x double>
 store <32 x double> %r,ptr %out,align 1
 ret void
}
define void @masked_fp_store_32_1_4(ptr %out, ptr %base, ptr %values, ptr %maskptr) {
 %mi=load <32 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <32 x i32> %mi,zeroinitializer
 %ptrs=load <32 x ptr>,ptr %base,align 8
 %x=load <32 x double>,ptr %values,align 1
 %r=fptrunc <32 x double> %x to <32 x float>
 call void @llvm.masked.scatter.v32f32.v32p0(<32 x float> %r,<32 x ptr> %ptrs,i32 4,<32 x i1> %mask)
 ret void
}
declare <16 x float> @llvm.masked.gather.v16f32.v16p0(<16 x ptr>,i32 immarg,<16 x i1>,<16 x float>)
declare <16 x float> @llvm.masked.load.v16f32.p0(ptr,<16 x i1>,<16 x float>)
declare <2 x float> @llvm.masked.gather.v2f32.v2p0(<2 x ptr>,i32 immarg,<2 x i1>,<2 x float>)
declare <2 x float> @llvm.masked.load.v2f32.p0(ptr,<2 x i1>,<2 x float>)
declare <32 x float> @llvm.masked.gather.v32f32.v32p0(<32 x ptr>,i32 immarg,<32 x i1>,<32 x float>)
declare <32 x float> @llvm.masked.load.v32f32.p0(ptr,<32 x i1>,<32 x float>)
declare <4 x float> @llvm.masked.gather.v4f32.v4p0(<4 x ptr>,i32 immarg,<4 x i1>,<4 x float>)
declare <4 x float> @llvm.masked.load.v4f32.p0(ptr,<4 x i1>,<4 x float>)
declare <8 x float> @llvm.masked.gather.v8f32.v8p0(<8 x ptr>,i32 immarg,<8 x i1>,<8 x float>)
declare <8 x float> @llvm.masked.load.v8f32.p0(ptr,<8 x i1>,<8 x float>)
declare void @llvm.masked.scatter.v16f32.v16p0(<16 x float>,<16 x ptr>,i32 immarg,<16 x i1>)
declare void @llvm.masked.scatter.v2f32.v2p0(<2 x float>,<2 x ptr>,i32 immarg,<2 x i1>)
declare void @llvm.masked.scatter.v32f32.v32p0(<32 x float>,<32 x ptr>,i32 immarg,<32 x i1>)
declare void @llvm.masked.scatter.v4f32.v4p0(<4 x float>,<4 x ptr>,i32 immarg,<4 x i1>)
declare void @llvm.masked.scatter.v8f32.v8p0(<8 x float>,<8 x ptr>,i32 immarg,<8 x i1>)
declare void @llvm.masked.store.v16f32.p0(<16 x float>,ptr,<16 x i1>)
declare void @llvm.masked.store.v2f32.p0(<2 x float>,ptr,<2 x i1>)
declare void @llvm.masked.store.v32f32.p0(<32 x float>,ptr,<32 x i1>)
declare void @llvm.masked.store.v4f32.p0(<4 x float>,ptr,<4 x i1>)
declare void @llvm.masked.store.v8f32.p0(<8 x float>,ptr,<8 x i1>)
