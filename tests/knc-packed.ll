; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes=scalarize-masked-mem-intrin -S < %s | FileCheck %s --check-prefix=KEEP
; KEEP: call <2 x i8> @llvm.masked.expandload
; KEEP: call void @llvm.masked.compressstore.v16p0
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: packed_expand2_i8_aligned:
; CHECK: bsfl
define void @packed_expand2_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i8>,ptr %values,align 1
 %r=call <2 x i8> @llvm.masked.expandload.v2i8(ptr align 1 %base,<2 x i1> %mask,<2 x i8> %v)
 store <2 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i8_aligned:
; CHECK: bsfl
define void @packed_compress2_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i8(<2 x i8> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand2_i8_unaligned:
; CHECK: bsfl
define void @packed_expand2_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i8>,ptr %values,align 1
 %r=call <2 x i8> @llvm.masked.expandload.v2i8(ptr align 1 %base,<2 x i1> %mask,<2 x i8> %v)
 store <2 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i8_unaligned:
; CHECK: bsfl
define void @packed_compress2_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i8(<2 x i8> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
declare <2 x i8> @llvm.masked.expandload.v2i8(ptr,<2 x i1>,<2 x i8>)
declare void @llvm.masked.compressstore.v2i8(<2 x i8>,ptr,<2 x i1>)
; CHECK-LABEL: packed_expand2_i16_aligned:
; CHECK: bsfl
define void @packed_expand2_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i16>,ptr %values,align 1
 %r=call <2 x i16> @llvm.masked.expandload.v2i16(ptr align 2 %base,<2 x i1> %mask,<2 x i16> %v)
 store <2 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i16_aligned:
; CHECK: bsfl
define void @packed_compress2_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i16(<2 x i16> %v,ptr align 2 %base,<2 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand2_i16_unaligned:
; CHECK: bsfl
define void @packed_expand2_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i16>,ptr %values,align 1
 %r=call <2 x i16> @llvm.masked.expandload.v2i16(ptr align 1 %base,<2 x i1> %mask,<2 x i16> %v)
 store <2 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i16_unaligned:
; CHECK: bsfl
define void @packed_compress2_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i16(<2 x i16> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
declare <2 x i16> @llvm.masked.expandload.v2i16(ptr,<2 x i1>,<2 x i16>)
declare void @llvm.masked.compressstore.v2i16(<2 x i16>,ptr,<2 x i1>)
; CHECK-LABEL: packed_expand2_i32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand2_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i32>,ptr %values,align 1
 %r=call <2 x i32> @llvm.masked.expandload.v2i32(ptr align 4 %base,<2 x i1> %mask,<2 x i32> %v)
 store <2 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress2_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i32(<2 x i32> %v,ptr align 4 %base,<2 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand2_i32_unaligned:
; CHECK: bsfl
define void @packed_expand2_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i32>,ptr %values,align 1
 %r=call <2 x i32> @llvm.masked.expandload.v2i32(ptr align 1 %base,<2 x i1> %mask,<2 x i32> %v)
 store <2 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i32_unaligned:
; CHECK: bsfl
define void @packed_compress2_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i32(<2 x i32> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
declare <2 x i32> @llvm.masked.expandload.v2i32(ptr,<2 x i1>,<2 x i32>)
declare void @llvm.masked.compressstore.v2i32(<2 x i32>,ptr,<2 x i1>)
; CHECK-LABEL: packed_expand2_i64_aligned:
; CHECK: bsfl
define void @packed_expand2_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i64>,ptr %values,align 1
 %r=call <2 x i64> @llvm.masked.expandload.v2i64(ptr align 8 %base,<2 x i1> %mask,<2 x i64> %v)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i64_aligned:
; CHECK: bsfl
define void @packed_compress2_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i64(<2 x i64> %v,ptr align 8 %base,<2 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand2_i64_unaligned:
; CHECK: bsfl
define void @packed_expand2_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i64>,ptr %values,align 1
 %r=call <2 x i64> @llvm.masked.expandload.v2i64(ptr align 1 %base,<2 x i1> %mask,<2 x i64> %v)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_i64_unaligned:
; CHECK: bsfl
define void @packed_compress2_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2i64(<2 x i64> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
declare <2 x i64> @llvm.masked.expandload.v2i64(ptr,<2 x i1>,<2 x i64>)
declare void @llvm.masked.compressstore.v2i64(<2 x i64>,ptr,<2 x i1>)
; CHECK-LABEL: packed_expand2_f32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand2_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x float>,ptr %values,align 1
 %r=call <2 x float> @llvm.masked.expandload.v2f32(ptr align 4 %base,<2 x i1> %mask,<2 x float> %v)
 store <2 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_f32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress2_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2f32(<2 x float> %v,ptr align 4 %base,<2 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand2_f32_unaligned:
; CHECK: bsfl
define void @packed_expand2_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x float>,ptr %values,align 1
 %r=call <2 x float> @llvm.masked.expandload.v2f32(ptr align 1 %base,<2 x i1> %mask,<2 x float> %v)
 store <2 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_f32_unaligned:
; CHECK: bsfl
define void @packed_compress2_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2f32(<2 x float> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
declare <2 x float> @llvm.masked.expandload.v2f32(ptr,<2 x i1>,<2 x float>)
declare void @llvm.masked.compressstore.v2f32(<2 x float>,ptr,<2 x i1>)
; CHECK-LABEL: packed_expand2_f64_aligned:
; CHECK: bsfl
define void @packed_expand2_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x double>,ptr %values,align 1
 %r=call <2 x double> @llvm.masked.expandload.v2f64(ptr align 8 %base,<2 x i1> %mask,<2 x double> %v)
 store <2 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_f64_aligned:
; CHECK: bsfl
define void @packed_compress2_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2f64(<2 x double> %v,ptr align 8 %base,<2 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand2_f64_unaligned:
; CHECK: bsfl
define void @packed_expand2_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x double>,ptr %values,align 1
 %r=call <2 x double> @llvm.masked.expandload.v2f64(ptr align 1 %base,<2 x i1> %mask,<2 x double> %v)
 store <2 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_f64_unaligned:
; CHECK: bsfl
define void @packed_compress2_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2f64(<2 x double> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
declare <2 x double> @llvm.masked.expandload.v2f64(ptr,<2 x i1>,<2 x double>)
declare void @llvm.masked.compressstore.v2f64(<2 x double>,ptr,<2 x i1>)
; CHECK-LABEL: packed_expand2_p0_aligned:
; CHECK: bsfl
define void @packed_expand2_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x ptr>,ptr %values,align 1
 %r=call <2 x ptr> @llvm.masked.expandload.v2p0(ptr align 8 %base,<2 x i1> %mask,<2 x ptr> %v)
 store <2 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_p0_aligned:
; CHECK: bsfl
define void @packed_compress2_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2p0(<2 x ptr> %v,ptr align 8 %base,<2 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand2_p0_unaligned:
; CHECK: bsfl
define void @packed_expand2_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x ptr>,ptr %values,align 1
 %r=call <2 x ptr> @llvm.masked.expandload.v2p0(ptr align 1 %base,<2 x i1> %mask,<2 x ptr> %v)
 store <2 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress2_p0_unaligned:
; CHECK: bsfl
define void @packed_compress2_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <2 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <2 x i32> %mi,zeroinitializer
 %v=load <2 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v2p0(<2 x ptr> %v,ptr align 1 %base,<2 x i1> %mask)
 ret void
}
declare <2 x ptr> @llvm.masked.expandload.v2p0(ptr,<2 x i1>,<2 x ptr>)
declare void @llvm.masked.compressstore.v2p0(<2 x ptr>,ptr,<2 x i1>)
; CHECK-LABEL: packed_expand4_i8_aligned:
; CHECK: bsfl
define void @packed_expand4_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i8>,ptr %values,align 1
 %r=call <4 x i8> @llvm.masked.expandload.v4i8(ptr align 1 %base,<4 x i1> %mask,<4 x i8> %v)
 store <4 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i8_aligned:
; CHECK: bsfl
define void @packed_compress4_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i8(<4 x i8> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand4_i8_unaligned:
; CHECK: bsfl
define void @packed_expand4_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i8>,ptr %values,align 1
 %r=call <4 x i8> @llvm.masked.expandload.v4i8(ptr align 1 %base,<4 x i1> %mask,<4 x i8> %v)
 store <4 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i8_unaligned:
; CHECK: bsfl
define void @packed_compress4_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i8(<4 x i8> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
declare <4 x i8> @llvm.masked.expandload.v4i8(ptr,<4 x i1>,<4 x i8>)
declare void @llvm.masked.compressstore.v4i8(<4 x i8>,ptr,<4 x i1>)
; CHECK-LABEL: packed_expand4_i16_aligned:
; CHECK: bsfl
define void @packed_expand4_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i16>,ptr %values,align 1
 %r=call <4 x i16> @llvm.masked.expandload.v4i16(ptr align 2 %base,<4 x i1> %mask,<4 x i16> %v)
 store <4 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i16_aligned:
; CHECK: bsfl
define void @packed_compress4_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i16(<4 x i16> %v,ptr align 2 %base,<4 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand4_i16_unaligned:
; CHECK: bsfl
define void @packed_expand4_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i16>,ptr %values,align 1
 %r=call <4 x i16> @llvm.masked.expandload.v4i16(ptr align 1 %base,<4 x i1> %mask,<4 x i16> %v)
 store <4 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i16_unaligned:
; CHECK: bsfl
define void @packed_compress4_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i16(<4 x i16> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
declare <4 x i16> @llvm.masked.expandload.v4i16(ptr,<4 x i1>,<4 x i16>)
declare void @llvm.masked.compressstore.v4i16(<4 x i16>,ptr,<4 x i1>)
; CHECK-LABEL: packed_expand4_i32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand4_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i32>,ptr %values,align 1
 %r=call <4 x i32> @llvm.masked.expandload.v4i32(ptr align 4 %base,<4 x i1> %mask,<4 x i32> %v)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress4_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i32(<4 x i32> %v,ptr align 4 %base,<4 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand4_i32_unaligned:
; CHECK: bsfl
define void @packed_expand4_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i32>,ptr %values,align 1
 %r=call <4 x i32> @llvm.masked.expandload.v4i32(ptr align 1 %base,<4 x i1> %mask,<4 x i32> %v)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i32_unaligned:
; CHECK: bsfl
define void @packed_compress4_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i32(<4 x i32> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
declare <4 x i32> @llvm.masked.expandload.v4i32(ptr,<4 x i1>,<4 x i32>)
declare void @llvm.masked.compressstore.v4i32(<4 x i32>,ptr,<4 x i1>)
; CHECK-LABEL: packed_expand4_i64_aligned:
; CHECK: bsfl
define void @packed_expand4_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i64>,ptr %values,align 1
 %r=call <4 x i64> @llvm.masked.expandload.v4i64(ptr align 8 %base,<4 x i1> %mask,<4 x i64> %v)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i64_aligned:
; CHECK: bsfl
define void @packed_compress4_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i64(<4 x i64> %v,ptr align 8 %base,<4 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand4_i64_unaligned:
; CHECK: bsfl
define void @packed_expand4_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i64>,ptr %values,align 1
 %r=call <4 x i64> @llvm.masked.expandload.v4i64(ptr align 1 %base,<4 x i1> %mask,<4 x i64> %v)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_i64_unaligned:
; CHECK: bsfl
define void @packed_compress4_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4i64(<4 x i64> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
declare <4 x i64> @llvm.masked.expandload.v4i64(ptr,<4 x i1>,<4 x i64>)
declare void @llvm.masked.compressstore.v4i64(<4 x i64>,ptr,<4 x i1>)
; CHECK-LABEL: packed_expand4_f32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand4_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x float>,ptr %values,align 1
 %r=call <4 x float> @llvm.masked.expandload.v4f32(ptr align 4 %base,<4 x i1> %mask,<4 x float> %v)
 store <4 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_f32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress4_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4f32(<4 x float> %v,ptr align 4 %base,<4 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand4_f32_unaligned:
; CHECK: bsfl
define void @packed_expand4_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x float>,ptr %values,align 1
 %r=call <4 x float> @llvm.masked.expandload.v4f32(ptr align 1 %base,<4 x i1> %mask,<4 x float> %v)
 store <4 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_f32_unaligned:
; CHECK: bsfl
define void @packed_compress4_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4f32(<4 x float> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
declare <4 x float> @llvm.masked.expandload.v4f32(ptr,<4 x i1>,<4 x float>)
declare void @llvm.masked.compressstore.v4f32(<4 x float>,ptr,<4 x i1>)
; CHECK-LABEL: packed_expand4_f64_aligned:
; CHECK: bsfl
define void @packed_expand4_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x double>,ptr %values,align 1
 %r=call <4 x double> @llvm.masked.expandload.v4f64(ptr align 8 %base,<4 x i1> %mask,<4 x double> %v)
 store <4 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_f64_aligned:
; CHECK: bsfl
define void @packed_compress4_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4f64(<4 x double> %v,ptr align 8 %base,<4 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand4_f64_unaligned:
; CHECK: bsfl
define void @packed_expand4_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x double>,ptr %values,align 1
 %r=call <4 x double> @llvm.masked.expandload.v4f64(ptr align 1 %base,<4 x i1> %mask,<4 x double> %v)
 store <4 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_f64_unaligned:
; CHECK: bsfl
define void @packed_compress4_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4f64(<4 x double> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
declare <4 x double> @llvm.masked.expandload.v4f64(ptr,<4 x i1>,<4 x double>)
declare void @llvm.masked.compressstore.v4f64(<4 x double>,ptr,<4 x i1>)
; CHECK-LABEL: packed_expand4_p0_aligned:
; CHECK: bsfl
define void @packed_expand4_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x ptr>,ptr %values,align 1
 %r=call <4 x ptr> @llvm.masked.expandload.v4p0(ptr align 8 %base,<4 x i1> %mask,<4 x ptr> %v)
 store <4 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_p0_aligned:
; CHECK: bsfl
define void @packed_compress4_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4p0(<4 x ptr> %v,ptr align 8 %base,<4 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand4_p0_unaligned:
; CHECK: bsfl
define void @packed_expand4_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x ptr>,ptr %values,align 1
 %r=call <4 x ptr> @llvm.masked.expandload.v4p0(ptr align 1 %base,<4 x i1> %mask,<4 x ptr> %v)
 store <4 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress4_p0_unaligned:
; CHECK: bsfl
define void @packed_compress4_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <4 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <4 x i32> %mi,zeroinitializer
 %v=load <4 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v4p0(<4 x ptr> %v,ptr align 1 %base,<4 x i1> %mask)
 ret void
}
declare <4 x ptr> @llvm.masked.expandload.v4p0(ptr,<4 x i1>,<4 x ptr>)
declare void @llvm.masked.compressstore.v4p0(<4 x ptr>,ptr,<4 x i1>)
; CHECK-LABEL: packed_expand8_i8_aligned:
; CHECK: bsfl
define void @packed_expand8_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i8>,ptr %values,align 1
 %r=call <8 x i8> @llvm.masked.expandload.v8i8(ptr align 1 %base,<8 x i1> %mask,<8 x i8> %v)
 store <8 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i8_aligned:
; CHECK: bsfl
define void @packed_compress8_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i8(<8 x i8> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand8_i8_unaligned:
; CHECK: bsfl
define void @packed_expand8_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i8>,ptr %values,align 1
 %r=call <8 x i8> @llvm.masked.expandload.v8i8(ptr align 1 %base,<8 x i1> %mask,<8 x i8> %v)
 store <8 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i8_unaligned:
; CHECK: bsfl
define void @packed_compress8_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i8(<8 x i8> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
declare <8 x i8> @llvm.masked.expandload.v8i8(ptr,<8 x i1>,<8 x i8>)
declare void @llvm.masked.compressstore.v8i8(<8 x i8>,ptr,<8 x i1>)
; CHECK-LABEL: packed_expand8_i16_aligned:
; CHECK: bsfl
define void @packed_expand8_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i16>,ptr %values,align 1
 %r=call <8 x i16> @llvm.masked.expandload.v8i16(ptr align 2 %base,<8 x i1> %mask,<8 x i16> %v)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i16_aligned:
; CHECK: bsfl
define void @packed_compress8_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i16(<8 x i16> %v,ptr align 2 %base,<8 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand8_i16_unaligned:
; CHECK: bsfl
define void @packed_expand8_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i16>,ptr %values,align 1
 %r=call <8 x i16> @llvm.masked.expandload.v8i16(ptr align 1 %base,<8 x i1> %mask,<8 x i16> %v)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i16_unaligned:
; CHECK: bsfl
define void @packed_compress8_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i16(<8 x i16> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
declare <8 x i16> @llvm.masked.expandload.v8i16(ptr,<8 x i1>,<8 x i16>)
declare void @llvm.masked.compressstore.v8i16(<8 x i16>,ptr,<8 x i1>)
; CHECK-LABEL: packed_expand8_i32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand8_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i32>,ptr %values,align 1
 %r=call <8 x i32> @llvm.masked.expandload.v8i32(ptr align 4 %base,<8 x i1> %mask,<8 x i32> %v)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress8_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i32(<8 x i32> %v,ptr align 4 %base,<8 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand8_i32_unaligned:
; CHECK: bsfl
define void @packed_expand8_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i32>,ptr %values,align 1
 %r=call <8 x i32> @llvm.masked.expandload.v8i32(ptr align 1 %base,<8 x i1> %mask,<8 x i32> %v)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i32_unaligned:
; CHECK: bsfl
define void @packed_compress8_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i32(<8 x i32> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
declare <8 x i32> @llvm.masked.expandload.v8i32(ptr,<8 x i1>,<8 x i32>)
declare void @llvm.masked.compressstore.v8i32(<8 x i32>,ptr,<8 x i1>)
; CHECK-LABEL: packed_expand8_i64_aligned:
; CHECK: bsfl
define void @packed_expand8_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i64>,ptr %values,align 1
 %r=call <8 x i64> @llvm.masked.expandload.v8i64(ptr align 8 %base,<8 x i1> %mask,<8 x i64> %v)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i64_aligned:
; CHECK: bsfl
define void @packed_compress8_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i64(<8 x i64> %v,ptr align 8 %base,<8 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand8_i64_unaligned:
; CHECK: bsfl
define void @packed_expand8_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i64>,ptr %values,align 1
 %r=call <8 x i64> @llvm.masked.expandload.v8i64(ptr align 1 %base,<8 x i1> %mask,<8 x i64> %v)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_i64_unaligned:
; CHECK: bsfl
define void @packed_compress8_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8i64(<8 x i64> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
declare <8 x i64> @llvm.masked.expandload.v8i64(ptr,<8 x i1>,<8 x i64>)
declare void @llvm.masked.compressstore.v8i64(<8 x i64>,ptr,<8 x i1>)
; CHECK-LABEL: packed_expand8_f32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand8_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x float>,ptr %values,align 1
 %r=call <8 x float> @llvm.masked.expandload.v8f32(ptr align 4 %base,<8 x i1> %mask,<8 x float> %v)
 store <8 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_f32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress8_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8f32(<8 x float> %v,ptr align 4 %base,<8 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand8_f32_unaligned:
; CHECK: bsfl
define void @packed_expand8_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x float>,ptr %values,align 1
 %r=call <8 x float> @llvm.masked.expandload.v8f32(ptr align 1 %base,<8 x i1> %mask,<8 x float> %v)
 store <8 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_f32_unaligned:
; CHECK: bsfl
define void @packed_compress8_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8f32(<8 x float> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
declare <8 x float> @llvm.masked.expandload.v8f32(ptr,<8 x i1>,<8 x float>)
declare void @llvm.masked.compressstore.v8f32(<8 x float>,ptr,<8 x i1>)
; CHECK-LABEL: packed_expand8_f64_aligned:
; CHECK: bsfl
define void @packed_expand8_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x double>,ptr %values,align 1
 %r=call <8 x double> @llvm.masked.expandload.v8f64(ptr align 8 %base,<8 x i1> %mask,<8 x double> %v)
 store <8 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_f64_aligned:
; CHECK: bsfl
define void @packed_compress8_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8f64(<8 x double> %v,ptr align 8 %base,<8 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand8_f64_unaligned:
; CHECK: bsfl
define void @packed_expand8_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x double>,ptr %values,align 1
 %r=call <8 x double> @llvm.masked.expandload.v8f64(ptr align 1 %base,<8 x i1> %mask,<8 x double> %v)
 store <8 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_f64_unaligned:
; CHECK: bsfl
define void @packed_compress8_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8f64(<8 x double> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
declare <8 x double> @llvm.masked.expandload.v8f64(ptr,<8 x i1>,<8 x double>)
declare void @llvm.masked.compressstore.v8f64(<8 x double>,ptr,<8 x i1>)
; CHECK-LABEL: packed_expand8_p0_aligned:
; CHECK: bsfl
define void @packed_expand8_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x ptr>,ptr %values,align 1
 %r=call <8 x ptr> @llvm.masked.expandload.v8p0(ptr align 8 %base,<8 x i1> %mask,<8 x ptr> %v)
 store <8 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_p0_aligned:
; CHECK: bsfl
define void @packed_compress8_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8p0(<8 x ptr> %v,ptr align 8 %base,<8 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand8_p0_unaligned:
; CHECK: bsfl
define void @packed_expand8_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x ptr>,ptr %values,align 1
 %r=call <8 x ptr> @llvm.masked.expandload.v8p0(ptr align 1 %base,<8 x i1> %mask,<8 x ptr> %v)
 store <8 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress8_p0_unaligned:
; CHECK: bsfl
define void @packed_compress8_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <8 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <8 x i32> %mi,zeroinitializer
 %v=load <8 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v8p0(<8 x ptr> %v,ptr align 1 %base,<8 x i1> %mask)
 ret void
}
declare <8 x ptr> @llvm.masked.expandload.v8p0(ptr,<8 x i1>,<8 x ptr>)
declare void @llvm.masked.compressstore.v8p0(<8 x ptr>,ptr,<8 x i1>)
; CHECK-LABEL: packed_expand16_i8_aligned:
; CHECK: bsfl
define void @packed_expand16_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i8>,ptr %values,align 1
 %r=call <16 x i8> @llvm.masked.expandload.v16i8(ptr align 1 %base,<16 x i1> %mask,<16 x i8> %v)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i8_aligned:
; CHECK: bsfl
define void @packed_compress16_i8_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i8(<16 x i8> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand16_i8_unaligned:
; CHECK: bsfl
define void @packed_expand16_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i8>,ptr %values,align 1
 %r=call <16 x i8> @llvm.masked.expandload.v16i8(ptr align 1 %base,<16 x i1> %mask,<16 x i8> %v)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i8_unaligned:
; CHECK: bsfl
define void @packed_compress16_i8_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i8>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i8(<16 x i8> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
declare <16 x i8> @llvm.masked.expandload.v16i8(ptr,<16 x i1>,<16 x i8>)
declare void @llvm.masked.compressstore.v16i8(<16 x i8>,ptr,<16 x i1>)
; CHECK-LABEL: packed_expand16_i16_aligned:
; CHECK: bsfl
define void @packed_expand16_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i16>,ptr %values,align 1
 %r=call <16 x i16> @llvm.masked.expandload.v16i16(ptr align 2 %base,<16 x i1> %mask,<16 x i16> %v)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i16_aligned:
; CHECK: bsfl
define void @packed_compress16_i16_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i16(<16 x i16> %v,ptr align 2 %base,<16 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand16_i16_unaligned:
; CHECK: bsfl
define void @packed_expand16_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i16>,ptr %values,align 1
 %r=call <16 x i16> @llvm.masked.expandload.v16i16(ptr align 1 %base,<16 x i1> %mask,<16 x i16> %v)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i16_unaligned:
; CHECK: bsfl
define void @packed_compress16_i16_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i16>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i16(<16 x i16> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
declare <16 x i16> @llvm.masked.expandload.v16i16(ptr,<16 x i1>,<16 x i16>)
declare void @llvm.masked.compressstore.v16i16(<16 x i16>,ptr,<16 x i1>)
; CHECK-LABEL: packed_expand16_i32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand16_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i32>,ptr %values,align 1
 %r=call <16 x i32> @llvm.masked.expandload.v16i32(ptr align 4 %base,<16 x i1> %mask,<16 x i32> %v)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress16_i32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i32(<16 x i32> %v,ptr align 4 %base,<16 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand16_i32_unaligned:
; CHECK: bsfl
define void @packed_expand16_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i32>,ptr %values,align 1
 %r=call <16 x i32> @llvm.masked.expandload.v16i32(ptr align 1 %base,<16 x i1> %mask,<16 x i32> %v)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i32_unaligned:
; CHECK: bsfl
define void @packed_compress16_i32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i32>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i32(<16 x i32> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
declare <16 x i32> @llvm.masked.expandload.v16i32(ptr,<16 x i1>,<16 x i32>)
declare void @llvm.masked.compressstore.v16i32(<16 x i32>,ptr,<16 x i1>)
; CHECK-LABEL: packed_expand16_i64_aligned:
; CHECK: bsfl
define void @packed_expand16_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i64>,ptr %values,align 1
 %r=call <16 x i64> @llvm.masked.expandload.v16i64(ptr align 8 %base,<16 x i1> %mask,<16 x i64> %v)
 store <16 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i64_aligned:
; CHECK: bsfl
define void @packed_compress16_i64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i64(<16 x i64> %v,ptr align 8 %base,<16 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand16_i64_unaligned:
; CHECK: bsfl
define void @packed_expand16_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i64>,ptr %values,align 1
 %r=call <16 x i64> @llvm.masked.expandload.v16i64(ptr align 1 %base,<16 x i1> %mask,<16 x i64> %v)
 store <16 x i64> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_i64_unaligned:
; CHECK: bsfl
define void @packed_compress16_i64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x i64>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16i64(<16 x i64> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
declare <16 x i64> @llvm.masked.expandload.v16i64(ptr,<16 x i1>,<16 x i64>)
declare void @llvm.masked.compressstore.v16i64(<16 x i64>,ptr,<16 x i1>)
; CHECK-LABEL: packed_expand16_f32_aligned:
; CHECK: knc.vpgatherdd
define void @packed_expand16_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x float>,ptr %values,align 1
 %r=call <16 x float> @llvm.masked.expandload.v16f32(ptr align 4 %base,<16 x i1> %mask,<16 x float> %v)
 store <16 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_f32_aligned:
; CHECK: knc.vpscatterdd
define void @packed_compress16_f32_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16f32(<16 x float> %v,ptr align 4 %base,<16 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand16_f32_unaligned:
; CHECK: bsfl
define void @packed_expand16_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x float>,ptr %values,align 1
 %r=call <16 x float> @llvm.masked.expandload.v16f32(ptr align 1 %base,<16 x i1> %mask,<16 x float> %v)
 store <16 x float> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_f32_unaligned:
; CHECK: bsfl
define void @packed_compress16_f32_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x float>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16f32(<16 x float> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
declare <16 x float> @llvm.masked.expandload.v16f32(ptr,<16 x i1>,<16 x float>)
declare void @llvm.masked.compressstore.v16f32(<16 x float>,ptr,<16 x i1>)
; CHECK-LABEL: packed_expand16_f64_aligned:
; CHECK: bsfl
define void @packed_expand16_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x double>,ptr %values,align 1
 %r=call <16 x double> @llvm.masked.expandload.v16f64(ptr align 8 %base,<16 x i1> %mask,<16 x double> %v)
 store <16 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_f64_aligned:
; CHECK: bsfl
define void @packed_compress16_f64_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16f64(<16 x double> %v,ptr align 8 %base,<16 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand16_f64_unaligned:
; CHECK: bsfl
define void @packed_expand16_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x double>,ptr %values,align 1
 %r=call <16 x double> @llvm.masked.expandload.v16f64(ptr align 1 %base,<16 x i1> %mask,<16 x double> %v)
 store <16 x double> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_f64_unaligned:
; CHECK: bsfl
define void @packed_compress16_f64_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x double>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16f64(<16 x double> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
declare <16 x double> @llvm.masked.expandload.v16f64(ptr,<16 x i1>,<16 x double>)
declare void @llvm.masked.compressstore.v16f64(<16 x double>,ptr,<16 x i1>)
; CHECK-LABEL: packed_expand16_p0_aligned:
; CHECK: bsfl
define void @packed_expand16_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x ptr>,ptr %values,align 1
 %r=call <16 x ptr> @llvm.masked.expandload.v16p0(ptr align 8 %base,<16 x i1> %mask,<16 x ptr> %v)
 store <16 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_p0_aligned:
; CHECK: bsfl
define void @packed_compress16_p0_aligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16p0(<16 x ptr> %v,ptr align 8 %base,<16 x i1> %mask)
 ret void
}
; CHECK-LABEL: packed_expand16_p0_unaligned:
; CHECK: bsfl
define void @packed_expand16_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x ptr>,ptr %values,align 1
 %r=call <16 x ptr> @llvm.masked.expandload.v16p0(ptr align 1 %base,<16 x i1> %mask,<16 x ptr> %v)
 store <16 x ptr> %r,ptr %out,align 1
 ret void
}
; CHECK-LABEL: packed_compress16_p0_unaligned:
; CHECK: bsfl
define void @packed_compress16_p0_unaligned(ptr %out,ptr %base,ptr %values,ptr %maskptr) {
 %mi=load <16 x i32>,ptr %maskptr,align 4
 %mask=icmp ne <16 x i32> %mi,zeroinitializer
 %v=load <16 x ptr>,ptr %values,align 1
 call void @llvm.masked.compressstore.v16p0(<16 x ptr> %v,ptr align 1 %base,<16 x i1> %mask)
 ret void
}
declare <16 x ptr> @llvm.masked.expandload.v16p0(ptr,<16 x i1>,<16 x ptr>)
declare void @llvm.masked.compressstore.v16p0(<16 x ptr>,ptr,<16 x i1>)
