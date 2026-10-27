; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; CHECK-LABEL: quant_dot:
; CHECK: knc.load_s8
; CHECK: knc.loadh_s8
; CHECK: knc.vpmulld
; CHECK-LABEL: expand_unsigned:
; CHECK: andq
; CHECK: knc.load_u8
; CHECK: knc.loadh_u8
; CHECK-LABEL: narrow_bytes:
; CHECK: knc.vpandd
; CHECK: knc.store_u8
; CHECK: knc.storeh_u8
; CHECK-LABEL: dequant_nibbles:
; CHECK: knc.vpsrlvd
; CHECK: knc.cvt_i32_f32
; CHECK: knc.vmulps
target triple = "x86_64-unknown-linux-gnu"
declare float @llvm.vector.reduce.fadd.v16f32(float,<16 x float>)
define void @quant_dot(ptr %o,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %xi=sext <16 x i8> %x to <16 x i32>
 %yi=sext <16 x i8> %y to <16 x i32>
 %p=mul <16 x i32> %xi,%yi
 %f=sitofp <16 x i32> %p to <16 x float>
 %sum=call fast float @llvm.vector.reduce.fadd.v16f32(float 0.0,<16 x float> %f)
 store float %sum,ptr %o,align 4
 ret void
}
define void @expand_signed(ptr %o,ptr %a) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=sext <16 x i8> %x to <16 x i32>
 store <16 x i32> %y,ptr %o,align 4
 ret void
}
define void @expand_unsigned(ptr %o,ptr %a) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=zext <16 x i8> %x to <16 x i32>
 store <16 x i32> %y,ptr %o,align 4
 ret void
}
define void @narrow_bytes(ptr %o,ptr %a) {
 %x=load <16 x i32>,ptr %a,align 4
 %y=trunc <16 x i32> %x to <16 x i8>
 store <16 x i8> %y,ptr %o,align 1
 ret void
}
define void @dequant_nibbles(ptr %o,ptr %a) {
 %x=load <16 x i8>,ptr %a,align 1
 %u=zext <16 x i8> %x to <16 x i32>
 %hi=lshr <16 x i32> %u,splat (i32 4)
 %lo=and <16 x i32> %u,splat (i32 15)
 %both=add <16 x i32> %hi,%lo
 %center=sub <16 x i32> %both,splat (i32 15)
 %f=sitofp <16 x i32> %center to <16 x float>
 %scaled=fmul <16 x float> %f,splat (float 0.125)
 store <16 x float> %scaled,ptr %o,align 4
 ret void
}
define void @ordered_sum(ptr %o,ptr %a) {
 %x=load <16 x float>,ptr %a,align 4
 %sum=call float @llvm.vector.reduce.fadd.v16f32(float 1.0,<16 x float> %x)
 store float %sum,ptr %o,align 4
 ret void
}
