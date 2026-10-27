; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; CHECK-LABEL: test_sub:
; CHECK: knc.vpsubd
; CHECK-LABEL: test_umin:
; CHECK: knc.vpminud
; CHECK-LABEL: test_eq:
; CHECK: knc.vpcmpd
; CHECK-LABEL: reduce_add:
; CHECK: knc.vpermd
; CHECK: knc.vpaddd
; CHECK-LABEL: test_gather:
; CHECK: knc.vpgatherdd
; CHECK: kmovw
; CHECK: jne
; CHECK-LABEL: test_scatter:
; CHECK: knc.vpscatterdd
; CHECK: jne
; CHECK-LABEL: convert_i32_f32:
; CHECK: knc.cvt_i32_f32
; CHECK-LABEL: fma_f32:
; CHECK: knc.vfmadd132ps
target triple = "x86_64-unknown-linux-gnu"
define void @test_sub(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=sub <16 x i32> %x,%y
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_and(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=and <16 x i32> %x,%y
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_or(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=or <16 x i32> %x,%y
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_xor(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=xor <16 x i32> %x,%y
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_shl(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=shl <16 x i32> %x,%y
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_lshr(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=lshr <16 x i32> %x,%y
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_ashr(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=ashr <16 x i32> %x,%y
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
declare <16 x i32> @llvm.umin.v16i32(<16 x i32>,<16 x i32>)
define void @test_umin(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=call <16 x i32> @llvm.umin.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
declare <16 x i32> @llvm.umax.v16i32(<16 x i32>,<16 x i32>)
define void @test_umax(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=call <16 x i32> @llvm.umax.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
declare <16 x i32> @llvm.smin.v16i32(<16 x i32>,<16 x i32>)
define void @test_smin(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=call <16 x i32> @llvm.smin.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
declare <16 x i32> @llvm.smax.v16i32(<16 x i32>,<16 x i32>)
define void @test_smax(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %z=call <16 x i32> @llvm.smax.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
declare <16 x i32> @llvm.x86.knc.permute.i32(<16 x i32>,<16 x i32>)
define void @test_permute(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %i=load <16 x i32>,ptr %b,align 64
 %z=call <16 x i32> @llvm.x86.knc.permute.i32(<16 x i32> %i,<16 x i32> %x)
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_eq(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %c=icmp eq <16 x i32> %x,%y
 %z=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_slt(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %c=icmp slt <16 x i32> %x,%y
 %z=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_ult(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %c=icmp ult <16 x i32> %x,%y
 %z=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_select(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 64
 %y=load <16 x i32>,ptr %b,align 64
 %c=icmp ult <16 x i32> %x,%y
 %z=select <16 x i1> %c,<16 x i32> %y,<16 x i32> %x
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
declare i32 @llvm.vector.reduce.add.v16i32(<16 x i32>)
define i32 @reduce_add(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.mul.v16i32(<16 x i32>)
define i32 @reduce_mul(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.mul.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.and.v16i32(<16 x i32>)
define i32 @reduce_and(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.and.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.or.v16i32(<16 x i32>)
define i32 @reduce_or(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.or.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.xor.v16i32(<16 x i32>)
define i32 @reduce_xor(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.xor.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.smin.v16i32(<16 x i32>)
define i32 @reduce_smin(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.smin.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.smax.v16i32(<16 x i32>)
define i32 @reduce_smax(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.smax.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.umin.v16i32(<16 x i32>)
define i32 @reduce_umin(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.umin.v16i32(<16 x i32> %x)
 ret i32 %z
}
declare i32 @llvm.vector.reduce.umax.v16i32(<16 x i32>)
define i32 @reduce_umax(ptr %a) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=call i32 @llvm.vector.reduce.umax.v16i32(<16 x i32> %x)
 ret i32 %z
}
define void @shuffle_i32(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 4
 %y=load <16 x i32>,ptr %b,align 4
 %z=shufflevector <16 x i32> %x,<16 x i32> %y,<16 x i32> <i32 0, i32 17, i32 2, i32 19, i32 4, i32 21, i32 6, i32 23, i32 8, i32 25, i32 10, i32 27, i32 12, i32 29, i32 14, i32 31>
 store <16 x i32> %z,ptr %o,align 4
 ret void
}
define void @shuffle_f32(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %z=shufflevector <16 x float> %x,<16 x float> %y,<16 x i32> <i32 0, i32 17, i32 2, i32 19, i32 4, i32 21, i32 6, i32 23, i32 8, i32 25, i32 10, i32 27, i32 12, i32 29, i32 14, i32 31>
 store <16 x float> %z,ptr %o,align 4
 ret void
}
define void @shuffle_f64(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 4
 %y=load <8 x double>,ptr %b,align 4
 %z=shufflevector <8 x double> %x,<8 x double> %y,<8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 4, i32 13, i32 6, i32 15>
 store <8 x double> %z,ptr %o,align 4
 ret void
}
define void @generic_fadd_f32(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %z=fadd <16 x float> %x,%y
 store <16 x float> %z,ptr %o,align 4
 ret void
}
define void @generic_fsub_f32(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %z=fsub <16 x float> %x,%y
 store <16 x float> %z,ptr %o,align 4
 ret void
}
define void @generic_fmul_f32(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %z=fmul <16 x float> %x,%y
 store <16 x float> %z,ptr %o,align 4
 ret void
}
define void @generic_fadd_f64(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 4
 %y=load <8 x double>,ptr %b,align 4
 %z=fadd <8 x double> %x,%y
 store <8 x double> %z,ptr %o,align 4
 ret void
}
define void @generic_fsub_f64(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 4
 %y=load <8 x double>,ptr %b,align 4
 %z=fsub <8 x double> %x,%y
 store <8 x double> %z,ptr %o,align 4
 ret void
}
define void @generic_fmul_f64(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 4
 %y=load <8 x double>,ptr %b,align 4
 %z=fmul <8 x double> %x,%y
 store <8 x double> %z,ptr %o,align 4
 ret void
}
define i32 @test_extract(ptr %a,i32 %i) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=extractelement <16 x i32> %x,i32 %i
 ret i32 %z
}
define void @test_insert(ptr %o,ptr %a,i32 %i,i32 %value) {
 %x=load <16 x i32>,ptr %a,align 64
 %z=insertelement <16 x i32> %x,i32 %value,i32 %i
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
declare <16 x i32> @llvm.x86.knc.gather.i32(ptr,<16 x i32>,<16 x i32>,i32)
declare void @llvm.x86.knc.scatter.i32(ptr,<16 x i32>,<16 x i32>,i32)
define void @test_gather(ptr %o,ptr %base,ptr %index,ptr %merge,i32 %mask) {
 %i=load <16 x i32>,ptr %index,align 64
 %m=load <16 x i32>,ptr %merge,align 64
 %z=call <16 x i32> @llvm.x86.knc.gather.i32(ptr %base,<16 x i32> %i,<16 x i32> %m,i32 %mask)
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @test_scatter(ptr %base,ptr %index,ptr %value,i32 %mask) {
 %i=load <16 x i32>,ptr %index,align 64
 %v=load <16 x i32>,ptr %value,align 64
 call void @llvm.x86.knc.scatter.i32(ptr %base,<16 x i32> %i,<16 x i32> %v,i32 %mask)
 ret void
}
define void @convert_i32_f32(ptr %o,ptr %a) {
 %x=load <16 x i32>,ptr %a,align 4
 %z=sitofp <16 x i32> %x to <16 x float>
 store <16 x float> %z,ptr %o,align 4
 ret void
}
define void @convert_u32_f32(ptr %o,ptr %a) {
 %x=load <16 x i32>,ptr %a,align 4
 %z=uitofp <16 x i32> %x to <16 x float>
 store <16 x float> %z,ptr %o,align 4
 ret void
}
define void @convert_f32_i32(ptr %o,ptr %a) {
 %x=load <16 x float>,ptr %a,align 4
 %z=fptosi <16 x float> %x to <16 x i32>
 store <16 x i32> %z,ptr %o,align 4
 ret void
}
define void @convert_f32_u32(ptr %o,ptr %a) {
 %x=load <16 x float>,ptr %a,align 4
 %z=fptoui <16 x float> %x to <16 x i32>
 store <16 x i32> %z,ptr %o,align 4
 ret void
}
declare <16 x float> @llvm.fma.v16f32(<16 x float>,<16 x float>,<16 x float>)
define void @fma_f32(ptr %o,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %z=load <16 x float>,ptr %c,align 4
 %r=call <16 x float> @llvm.fma.v16f32(<16 x float> %x,<16 x float> %y,<16 x float> %z)
 store <16 x float> %r,ptr %o,align 4
 ret void
}
declare <8 x double> @llvm.fma.v8f64(<8 x double>,<8 x double>,<8 x double>)
define void @fma_f64(ptr %o,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x double>,ptr %a,align 4
 %y=load <8 x double>,ptr %b,align 4
 %z=load <8 x double>,ptr %c,align 4
 %r=call <8 x double> @llvm.fma.v8f64(<8 x double> %x,<8 x double> %y,<8 x double> %z)
 store <8 x double> %r,ptr %o,align 4
 ret void
}
define void @gather_same_value(ptr %o,ptr %base,ptr %index,i32 %mask) {
 %i=load <16 x i32>,ptr %index,align 64
 %z=call <16 x i32> @llvm.x86.knc.gather.i32(ptr %base,<16 x i32> %i,<16 x i32> %i,i32 %mask)
 store <16 x i32> %z,ptr %o,align 64
 ret void
}
define void @gather_outer_loop(ptr %o,ptr %base,ptr %index,ptr %merge,i32 %mask) {
entry:
 %i=load <16 x i32>,ptr %index,align 64
 %m=load <16 x i32>,ptr %merge,align 64
 br label %loop
loop:
 %n=phi i64 [0,%entry],[%next,%loop]
 %prior=phi <16 x i32> [%m,%entry],[%z,%loop]
 %z=call <16 x i32> @llvm.x86.knc.gather.i32(ptr %base,<16 x i32> %i,<16 x i32> %prior,i32 %mask)
 %off=mul i64 %n,16
 %p=getelementptr i32,ptr %o,i64 %off
 store <16 x i32> %z,ptr %p,align 64
 %next=add i64 %n,1
 %done=icmp eq i64 %next,4
 br i1 %done,label %exit,label %loop
exit: ret void
}
