; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; CHECK-LABEL: vector_add_i32:
; CHECK: knc.vpaddd
; CHECK-LABEL: vector_mul_i32:
; CHECK: knc.vpmulld
; CHECK-LABEL: vector_add_f32:
; CHECK: knc.vaddps
; CHECK-LABEL: vector_mul_f32:
; CHECK: knc.vmulps
; CHECK-LABEL: vector_add_f64:
; CHECK: knc.vaddpd
; CHECK-LABEL: vector_mul_f64:
; CHECK: knc.vmulpd
; CHECK-LABEL: vector_unaligned:
; CHECK: knc.vloadunpackld
; CHECK: knc.vloadunpackhd
; CHECK: knc.vpackstoreld
; CHECK: knc.vpackstorehd
; CHECK-LABEL: vector_mask:
; CHECK: kmovw
; CHECK: knc.vpaddd
; CHECK-LABEL: vector_spills:
; CHECK: knc.vmovdqa32
; CHECK: clobber_vectors
; CHECK: knc.vmovdqa32
target triple = "x86_64-unknown-linux-gnu"
declare <16 x i32> @llvm.x86.knc.add.i32(<16 x i32>,<16 x i32>)
declare <16 x i32> @llvm.x86.knc.mul.i32(<16 x i32>,<16 x i32>)
declare <16 x float> @llvm.x86.knc.add.f32(<16 x float>,<16 x float>)
declare <16 x float> @llvm.x86.knc.mul.f32(<16 x float>,<16 x float>)
declare <8 x double> @llvm.x86.knc.add.f64(<8 x double>,<8 x double>)
declare <8 x double> @llvm.x86.knc.mul.f64(<8 x double>,<8 x double>)
declare <16 x i32> @llvm.x86.knc.load.i32(ptr)
declare <16 x i32> @llvm.x86.knc.loadu.i32(ptr)
declare void @llvm.x86.knc.store.i32(ptr,<16 x i32>)
declare void @llvm.x86.knc.storeu.i32(ptr,<16 x i32>)
declare <16 x i32> @llvm.x86.knc.mask.add.i32(<16 x i32>,<16 x i32>,<16 x i32>,i32)
define void @vector_add_i32(ptr %o,ptr %a,ptr %b) {
 %x=call <16 x i32> @llvm.x86.knc.load.i32(ptr %a)
 %y=call <16 x i32> @llvm.x86.knc.load.i32(ptr %b)
 %z=call <16 x i32> @llvm.x86.knc.add.i32(<16 x i32> %x,<16 x i32> %y)
 call void @llvm.x86.knc.store.i32(ptr %o,<16 x i32> %z)
 ret void
}
define void @vector_mul_i32(ptr %o,ptr %a,ptr %b) {
 %x=call <16 x i32> @llvm.x86.knc.load.i32(ptr %a)
 %y=call <16 x i32> @llvm.x86.knc.load.i32(ptr %b)
 %z=call <16 x i32> @llvm.x86.knc.mul.i32(<16 x i32> %x,<16 x i32> %y)
 call void @llvm.x86.knc.store.i32(ptr %o,<16 x i32> %z)
 ret void
}
define void @vector_add_f32(ptr %o,ptr %a,ptr %b) {
 %x=call <16 x i32> @llvm.x86.knc.load.i32(ptr %a)
 %y=call <16 x i32> @llvm.x86.knc.load.i32(ptr %b)
 %xx=bitcast <16 x i32> %x to <16 x float>
 %yy=bitcast <16 x i32> %y to <16 x float>
 %z=call <16 x float> @llvm.x86.knc.add.f32(<16 x float> %xx,<16 x float> %yy)
 %zz=bitcast <16 x float> %z to <16 x i32>
 call void @llvm.x86.knc.store.i32(ptr %o,<16 x i32> %zz)
 ret void
}
define void @vector_mul_f32(ptr %o,ptr %a,ptr %b) {
 %x=call <16 x i32> @llvm.x86.knc.load.i32(ptr %a)
 %y=call <16 x i32> @llvm.x86.knc.load.i32(ptr %b)
 %xx=bitcast <16 x i32> %x to <16 x float>
 %yy=bitcast <16 x i32> %y to <16 x float>
 %z=call <16 x float> @llvm.x86.knc.mul.f32(<16 x float> %xx,<16 x float> %yy)
 %zz=bitcast <16 x float> %z to <16 x i32>
 call void @llvm.x86.knc.store.i32(ptr %o,<16 x i32> %zz)
 ret void
}
define void @vector_add_f64(ptr %o,ptr %a,ptr %b) {
 %x=call <16 x i32> @llvm.x86.knc.load.i32(ptr %a)
 %y=call <16 x i32> @llvm.x86.knc.load.i32(ptr %b)
 %xx=bitcast <16 x i32> %x to <8 x double>
 %yy=bitcast <16 x i32> %y to <8 x double>
 %z=call <8 x double> @llvm.x86.knc.add.f64(<8 x double> %xx,<8 x double> %yy)
 %zz=bitcast <8 x double> %z to <16 x i32>
 call void @llvm.x86.knc.store.i32(ptr %o,<16 x i32> %zz)
 ret void
}
define void @vector_mul_f64(ptr %o,ptr %a,ptr %b) {
 %x=call <16 x i32> @llvm.x86.knc.load.i32(ptr %a)
 %y=call <16 x i32> @llvm.x86.knc.load.i32(ptr %b)
 %xx=bitcast <16 x i32> %x to <8 x double>
 %yy=bitcast <16 x i32> %y to <8 x double>
 %z=call <8 x double> @llvm.x86.knc.mul.f64(<8 x double> %xx,<8 x double> %yy)
 %zz=bitcast <8 x double> %z to <16 x i32>
 call void @llvm.x86.knc.store.i32(ptr %o,<16 x i32> %zz)
 ret void
}
define void @vector_unaligned(ptr %o,ptr %a) {
 %x=call <16 x i32> @llvm.x86.knc.loadu.i32(ptr %a)
 call void @llvm.x86.knc.storeu.i32(ptr %o,<16 x i32> %x)
 ret void
}
define void @vector_mask(ptr %o,ptr %m,ptr %a,ptr %b,i32 %mask) {
 %x=call <16 x i32> @llvm.x86.knc.load.i32(ptr %a)
 %y=call <16 x i32> @llvm.x86.knc.load.i32(ptr %b)
 %old=call <16 x i32> @llvm.x86.knc.load.i32(ptr %m)
 %z=call <16 x i32> @llvm.x86.knc.mask.add.i32(<16 x i32> %old,<16 x i32> %x,<16 x i32> %y,i32 %mask)
 call void @llvm.x86.knc.store.i32(ptr %o,<16 x i32> %z)
 ret void
}
declare void @clobber_vectors()
define void @vector_spills(ptr %o,ptr %a) {
 %p0=getelementptr i32,ptr %a,i64 0
 %x0=load volatile <16 x i32>,ptr %p0,align 64
 %p1=getelementptr i32,ptr %a,i64 16
 %x1=load volatile <16 x i32>,ptr %p1,align 64
 %p2=getelementptr i32,ptr %a,i64 32
 %x2=load volatile <16 x i32>,ptr %p2,align 64
 %p3=getelementptr i32,ptr %a,i64 48
 %x3=load volatile <16 x i32>,ptr %p3,align 64
 %p4=getelementptr i32,ptr %a,i64 64
 %x4=load volatile <16 x i32>,ptr %p4,align 64
 %p5=getelementptr i32,ptr %a,i64 80
 %x5=load volatile <16 x i32>,ptr %p5,align 64
 %p6=getelementptr i32,ptr %a,i64 96
 %x6=load volatile <16 x i32>,ptr %p6,align 64
 %p7=getelementptr i32,ptr %a,i64 112
 %x7=load volatile <16 x i32>,ptr %p7,align 64
 %p8=getelementptr i32,ptr %a,i64 128
 %x8=load volatile <16 x i32>,ptr %p8,align 64
 %p9=getelementptr i32,ptr %a,i64 144
 %x9=load volatile <16 x i32>,ptr %p9,align 64
 %p10=getelementptr i32,ptr %a,i64 160
 %x10=load volatile <16 x i32>,ptr %p10,align 64
 %p11=getelementptr i32,ptr %a,i64 176
 %x11=load volatile <16 x i32>,ptr %p11,align 64
 %p12=getelementptr i32,ptr %a,i64 192
 %x12=load volatile <16 x i32>,ptr %p12,align 64
 %p13=getelementptr i32,ptr %a,i64 208
 %x13=load volatile <16 x i32>,ptr %p13,align 64
 %p14=getelementptr i32,ptr %a,i64 224
 %x14=load volatile <16 x i32>,ptr %p14,align 64
 %p15=getelementptr i32,ptr %a,i64 240
 %x15=load volatile <16 x i32>,ptr %p15,align 64
 %p16=getelementptr i32,ptr %a,i64 256
 %x16=load volatile <16 x i32>,ptr %p16,align 64
 %p17=getelementptr i32,ptr %a,i64 272
 %x17=load volatile <16 x i32>,ptr %p17,align 64
 %p18=getelementptr i32,ptr %a,i64 288
 %x18=load volatile <16 x i32>,ptr %p18,align 64
 %p19=getelementptr i32,ptr %a,i64 304
 %x19=load volatile <16 x i32>,ptr %p19,align 64
 %p20=getelementptr i32,ptr %a,i64 320
 %x20=load volatile <16 x i32>,ptr %p20,align 64
 %p21=getelementptr i32,ptr %a,i64 336
 %x21=load volatile <16 x i32>,ptr %p21,align 64
 %p22=getelementptr i32,ptr %a,i64 352
 %x22=load volatile <16 x i32>,ptr %p22,align 64
 %p23=getelementptr i32,ptr %a,i64 368
 %x23=load volatile <16 x i32>,ptr %p23,align 64
 %p24=getelementptr i32,ptr %a,i64 384
 %x24=load volatile <16 x i32>,ptr %p24,align 64
 %p25=getelementptr i32,ptr %a,i64 400
 %x25=load volatile <16 x i32>,ptr %p25,align 64
 %p26=getelementptr i32,ptr %a,i64 416
 %x26=load volatile <16 x i32>,ptr %p26,align 64
 %p27=getelementptr i32,ptr %a,i64 432
 %x27=load volatile <16 x i32>,ptr %p27,align 64
 %p28=getelementptr i32,ptr %a,i64 448
 %x28=load volatile <16 x i32>,ptr %p28,align 64
 %p29=getelementptr i32,ptr %a,i64 464
 %x29=load volatile <16 x i32>,ptr %p29,align 64
 %p30=getelementptr i32,ptr %a,i64 480
 %x30=load volatile <16 x i32>,ptr %p30,align 64
 %p31=getelementptr i32,ptr %a,i64 496
 %x31=load volatile <16 x i32>,ptr %p31,align 64
 %p32=getelementptr i32,ptr %a,i64 512
 %x32=load volatile <16 x i32>,ptr %p32,align 64
 %p33=getelementptr i32,ptr %a,i64 528
 %x33=load volatile <16 x i32>,ptr %p33,align 64
 %p34=getelementptr i32,ptr %a,i64 544
 %x34=load volatile <16 x i32>,ptr %p34,align 64
 %p35=getelementptr i32,ptr %a,i64 560
 %x35=load volatile <16 x i32>,ptr %p35,align 64
 %p36=getelementptr i32,ptr %a,i64 576
 %x36=load volatile <16 x i32>,ptr %p36,align 64
 %p37=getelementptr i32,ptr %a,i64 592
 %x37=load volatile <16 x i32>,ptr %p37,align 64
 %p38=getelementptr i32,ptr %a,i64 608
 %x38=load volatile <16 x i32>,ptr %p38,align 64
 %p39=getelementptr i32,ptr %a,i64 624
 %x39=load volatile <16 x i32>,ptr %p39,align 64
 call void @clobber_vectors()
 %s1=add <16 x i32> %x0,%x1
 %s2=add <16 x i32> %s1,%x2
 %s3=add <16 x i32> %s2,%x3
 %s4=add <16 x i32> %s3,%x4
 %s5=add <16 x i32> %s4,%x5
 %s6=add <16 x i32> %s5,%x6
 %s7=add <16 x i32> %s6,%x7
 %s8=add <16 x i32> %s7,%x8
 %s9=add <16 x i32> %s8,%x9
 %s10=add <16 x i32> %s9,%x10
 %s11=add <16 x i32> %s10,%x11
 %s12=add <16 x i32> %s11,%x12
 %s13=add <16 x i32> %s12,%x13
 %s14=add <16 x i32> %s13,%x14
 %s15=add <16 x i32> %s14,%x15
 %s16=add <16 x i32> %s15,%x16
 %s17=add <16 x i32> %s16,%x17
 %s18=add <16 x i32> %s17,%x18
 %s19=add <16 x i32> %s18,%x19
 %s20=add <16 x i32> %s19,%x20
 %s21=add <16 x i32> %s20,%x21
 %s22=add <16 x i32> %s21,%x22
 %s23=add <16 x i32> %s22,%x23
 %s24=add <16 x i32> %s23,%x24
 %s25=add <16 x i32> %s24,%x25
 %s26=add <16 x i32> %s25,%x26
 %s27=add <16 x i32> %s26,%x27
 %s28=add <16 x i32> %s27,%x28
 %s29=add <16 x i32> %s28,%x29
 %s30=add <16 x i32> %s29,%x30
 %s31=add <16 x i32> %s30,%x31
 %s32=add <16 x i32> %s31,%x32
 %s33=add <16 x i32> %s32,%x33
 %s34=add <16 x i32> %s33,%x34
 %s35=add <16 x i32> %s34,%x35
 %s36=add <16 x i32> %s35,%x36
 %s37=add <16 x i32> %s36,%x37
 %s38=add <16 x i32> %s37,%x38
 %s39=add <16 x i32> %s38,%x39
 store <16 x i32> %s39,ptr %o,align 64
 ret void
}

define <16 x i32> @ten_vectors(<16 x i32> %x0,<16 x i32> %x1,<16 x i32> %x2,<16 x i32> %x3,<16 x i32> %x4,<16 x i32> %x5,<16 x i32> %x6,<16 x i32> %x7,<16 x i32> %x8,<16 x i32> %x9) noinline {
 %s1=add <16 x i32> %x0,%x1
 %s2=add <16 x i32> %s1,%x2
 %s3=add <16 x i32> %s2,%x3
 %s4=add <16 x i32> %s3,%x4
 %s5=add <16 x i32> %s4,%x5
 %s6=add <16 x i32> %s5,%x6
 %s7=add <16 x i32> %s6,%x7
 %s8=add <16 x i32> %s7,%x8
 %s9=add <16 x i32> %s8,%x9
 ret <16 x i32> %s9
}
define void @vector_call(ptr %o,ptr %a) {
 %p0=getelementptr i32,ptr %a,i64 0
 %x0=load <16 x i32>,ptr %p0,align 64
 %p1=getelementptr i32,ptr %a,i64 16
 %x1=load <16 x i32>,ptr %p1,align 64
 %p2=getelementptr i32,ptr %a,i64 32
 %x2=load <16 x i32>,ptr %p2,align 64
 %p3=getelementptr i32,ptr %a,i64 48
 %x3=load <16 x i32>,ptr %p3,align 64
 %p4=getelementptr i32,ptr %a,i64 64
 %x4=load <16 x i32>,ptr %p4,align 64
 %p5=getelementptr i32,ptr %a,i64 80
 %x5=load <16 x i32>,ptr %p5,align 64
 %p6=getelementptr i32,ptr %a,i64 96
 %x6=load <16 x i32>,ptr %p6,align 64
 %p7=getelementptr i32,ptr %a,i64 112
 %x7=load <16 x i32>,ptr %p7,align 64
 %p8=getelementptr i32,ptr %a,i64 128
 %x8=load <16 x i32>,ptr %p8,align 64
 %p9=getelementptr i32,ptr %a,i64 144
 %x9=load <16 x i32>,ptr %p9,align 64
 %r=call <16 x i32> @ten_vectors(<16 x i32> %x0,<16 x i32> %x1,<16 x i32> %x2,<16 x i32> %x3,<16 x i32> %x4,<16 x i32> %x5,<16 x i32> %x6,<16 x i32> %x7,<16 x i32> %x8,<16 x i32> %x9)
 store <16 x i32> %r,ptr %o,align 64
 ret void
}
