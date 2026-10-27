; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
declare void @abi_clobber(ptr,ptr,i64)
define internal <16 x i8> @mix_callee_i8_16(ptr %audit,<16 x i8> %v0,i64 %i0,double %f0,<16 x i8> %v1,i64 %i1,double %f1,<16 x i8> %v2,i64 %i2,double %f2,<16 x i8> %v3,i64 %i3,double %f3,<16 x i8> %v4,i64 %i4,double %f4,<16 x i8> %v5,i64 %i5,double %f5,<16 x i8> %v6,i64 %i6,double %f6,<16 x i8> %v7,i64 %i7,double %f7,<16 x i8> %v8,i64 %i8,double %f8,<16 x i8> %v9,i64 %i9,double %f9,<16 x i8> %v10,i64 %i10,double %f10,<16 x i8> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <16 x i8> %v0 to <16 x i8>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <16 x i8> %v1 to <16 x i8>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <16 x i8> %v2 to <16 x i8>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <16 x i8> %v3 to <16 x i8>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <16 x i8> %v4 to <16 x i8>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <16 x i8> %v5 to <16 x i8>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <16 x i8> %v6 to <16 x i8>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <16 x i8> %v7 to <16 x i8>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <16 x i8> %v8 to <16 x i8>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <16 x i8> %v9 to <16 x i8>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <16 x i8> %v10 to <16 x i8>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <16 x i8> %v11 to <16 x i8>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <16 x i8> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <16 x i8> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <16 x i8> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <16 x i8> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <16 x i8> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <16 x i8> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <16 x i8> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <16 x i8> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <16 x i8> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <16 x i8> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <16 x i8> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <16 x i8> %vx11 to <16 x i8>
 ret <16 x i8> %result
}
define void @abi_mix_i8_16(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i8>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 192
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 288
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 16
 %v1=load <16 x i8>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 200
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 296
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 32
 %v2=load <16 x i8>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 208
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 304
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 48
 %v3=load <16 x i8>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 216
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 312
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 64
 %v4=load <16 x i8>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 224
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 320
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 80
 %v5=load <16 x i8>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 232
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 328
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 96
 %v6=load <16 x i8>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 240
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 336
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 112
 %v7=load <16 x i8>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 248
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 344
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 128
 %v8=load <16 x i8>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 256
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 352
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 144
 %v9=load <16 x i8>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 264
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 360
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 160
 %v10=load <16 x i8>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 272
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 368
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 176
 %v11=load <16 x i8>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 280
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 376
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 16
 %result=call <16 x i8> @mix_callee_i8_16(ptr %audit,<16 x i8> %v0,i64 %i0,double %f0,<16 x i8> %v1,i64 %i1,double %f1,<16 x i8> %v2,i64 %i2,double %f2,<16 x i8> %v3,i64 %i3,double %f3,<16 x i8> %v4,i64 %i4,double %f4,<16 x i8> %v5,i64 %i5,double %f5,<16 x i8> %v6,i64 %i6,double %f6,<16 x i8> %v7,i64 %i7,double %f7,<16 x i8> %v8,i64 %i8,double %f8,<16 x i8> %v9,i64 %i9,double %f9,<16 x i8> %v10,i64 %i10,double %f10,<16 x i8> %v11,i64 %i11,double %f11)
 store <16 x i8> %result,ptr %out,align 1
 ret void
}
define internal {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} @aggregate_callee_i8_16(<16 x i8> %a,<16 x i8> %b,<16 x i8> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} poison,<16 x i8> %c,0
 %r1=insertvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %r0,<16 x i8> %a,1
 %r2=insertvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %r1,<16 x i8> %b,2
 %r3=insertvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %r3,double %f,4
 ret {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %r4
}
define void @abi_aggregate_i8_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i8>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <16 x i8>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <16 x i8>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 48
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 56
 %f=load double,ptr %fp,align 1
 %result=call {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} @aggregate_callee_i8_16(<16 x i8> %v0,<16 x i8> %v1,<16 x i8> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %result,0
 store <16 x i8> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 %r1=extractvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %result,1
 store <16 x i8> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 %r2=extractvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %result,2
 store <16 x i8> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 48
 %ri=extractvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 56
 %rf=extractvalue {<16 x i8>,<16 x i8>,<16 x i8>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i8_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i8>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <16 x i8>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <16 x i8>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 48
 %v3=load <16 x i8>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 64
 %v4=load <16 x i8>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 80
 %v5=load <16 x i8>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 96
 %v6=load <16 x i8>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 112
 %v7=load <16 x i8>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 128
 %v8=load <16 x i8>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 144
 %v9=load <16 x i8>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 160
 %v10=load <16 x i8>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 176
 %v11=load <16 x i8>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 192
 %v12=load <16 x i8>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 208
 %v13=load <16 x i8>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 224
 %v14=load <16 x i8>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 240
 %v15=load <16 x i8>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 256
 %v16=load <16 x i8>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 272
 %v17=load <16 x i8>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 288
 %v18=load <16 x i8>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 304
 %v19=load <16 x i8>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 320
 %v20=load <16 x i8>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 336
 %v21=load <16 x i8>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 352
 %v22=load <16 x i8>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 368
 %v23=load <16 x i8>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 384
 %v24=load <16 x i8>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 400
 %v25=load <16 x i8>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 416
 %v26=load <16 x i8>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 432
 %v27=load <16 x i8>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 448
 %v28=load <16 x i8>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 464
 %v29=load <16 x i8>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 480
 %v30=load <16 x i8>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 496
 %v31=load <16 x i8>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 512
 %v32=load <16 x i8>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 528
 %v33=load <16 x i8>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 544
 %v34=load <16 x i8>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 560
 %v35=load <16 x i8>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 576
 %v36=load <16 x i8>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 592
 %v37=load <16 x i8>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 608
 %v38=load <16 x i8>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 624
 %v39=load <16 x i8>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 640)
 %o0=getelementptr i8,ptr %out,i64 0
 store <16 x i8> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 store <16 x i8> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 store <16 x i8> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 48
 store <16 x i8> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 64
 store <16 x i8> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 80
 store <16 x i8> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 96
 store <16 x i8> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 112
 store <16 x i8> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 128
 store <16 x i8> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 144
 store <16 x i8> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 160
 store <16 x i8> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 176
 store <16 x i8> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 192
 store <16 x i8> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 208
 store <16 x i8> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 224
 store <16 x i8> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 240
 store <16 x i8> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 256
 store <16 x i8> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 272
 store <16 x i8> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 288
 store <16 x i8> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 304
 store <16 x i8> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 320
 store <16 x i8> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 336
 store <16 x i8> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 352
 store <16 x i8> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 368
 store <16 x i8> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 384
 store <16 x i8> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 400
 store <16 x i8> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 416
 store <16 x i8> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 432
 store <16 x i8> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 448
 store <16 x i8> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 464
 store <16 x i8> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 480
 store <16 x i8> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 496
 store <16 x i8> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 512
 store <16 x i8> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 528
 store <16 x i8> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 544
 store <16 x i8> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 560
 store <16 x i8> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 576
 store <16 x i8> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 592
 store <16 x i8> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 608
 store <16 x i8> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 624
 store <16 x i8> %v39,ptr %o39,align 1
 ret void
}
define internal <8 x i16> @mix_callee_i16_16(ptr %audit,<8 x i16> %v0,i64 %i0,double %f0,<8 x i16> %v1,i64 %i1,double %f1,<8 x i16> %v2,i64 %i2,double %f2,<8 x i16> %v3,i64 %i3,double %f3,<8 x i16> %v4,i64 %i4,double %f4,<8 x i16> %v5,i64 %i5,double %f5,<8 x i16> %v6,i64 %i6,double %f6,<8 x i16> %v7,i64 %i7,double %f7,<8 x i16> %v8,i64 %i8,double %f8,<8 x i16> %v9,i64 %i9,double %f9,<8 x i16> %v10,i64 %i10,double %f10,<8 x i16> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <8 x i16> %v0 to <8 x i16>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <8 x i16> %v1 to <8 x i16>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <8 x i16> %v2 to <8 x i16>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <8 x i16> %v3 to <8 x i16>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <8 x i16> %v4 to <8 x i16>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <8 x i16> %v5 to <8 x i16>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <8 x i16> %v6 to <8 x i16>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <8 x i16> %v7 to <8 x i16>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <8 x i16> %v8 to <8 x i16>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <8 x i16> %v9 to <8 x i16>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <8 x i16> %v10 to <8 x i16>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <8 x i16> %v11 to <8 x i16>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <8 x i16> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <8 x i16> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <8 x i16> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <8 x i16> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <8 x i16> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <8 x i16> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <8 x i16> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <8 x i16> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <8 x i16> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <8 x i16> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <8 x i16> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <8 x i16> %vx11 to <8 x i16>
 ret <8 x i16> %result
}
define void @abi_mix_i16_16(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i16>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 192
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 288
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 16
 %v1=load <8 x i16>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 200
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 296
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 32
 %v2=load <8 x i16>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 208
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 304
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 48
 %v3=load <8 x i16>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 216
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 312
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 64
 %v4=load <8 x i16>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 224
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 320
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 80
 %v5=load <8 x i16>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 232
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 328
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 96
 %v6=load <8 x i16>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 240
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 336
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 112
 %v7=load <8 x i16>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 248
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 344
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 128
 %v8=load <8 x i16>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 256
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 352
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 144
 %v9=load <8 x i16>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 264
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 360
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 160
 %v10=load <8 x i16>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 272
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 368
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 176
 %v11=load <8 x i16>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 280
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 376
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 16
 %result=call <8 x i16> @mix_callee_i16_16(ptr %audit,<8 x i16> %v0,i64 %i0,double %f0,<8 x i16> %v1,i64 %i1,double %f1,<8 x i16> %v2,i64 %i2,double %f2,<8 x i16> %v3,i64 %i3,double %f3,<8 x i16> %v4,i64 %i4,double %f4,<8 x i16> %v5,i64 %i5,double %f5,<8 x i16> %v6,i64 %i6,double %f6,<8 x i16> %v7,i64 %i7,double %f7,<8 x i16> %v8,i64 %i8,double %f8,<8 x i16> %v9,i64 %i9,double %f9,<8 x i16> %v10,i64 %i10,double %f10,<8 x i16> %v11,i64 %i11,double %f11)
 store <8 x i16> %result,ptr %out,align 1
 ret void
}
define internal {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} @aggregate_callee_i16_16(<8 x i16> %a,<8 x i16> %b,<8 x i16> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} poison,<8 x i16> %c,0
 %r1=insertvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %r0,<8 x i16> %a,1
 %r2=insertvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %r1,<8 x i16> %b,2
 %r3=insertvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %r3,double %f,4
 ret {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %r4
}
define void @abi_aggregate_i16_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i16>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <8 x i16>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <8 x i16>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 48
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 56
 %f=load double,ptr %fp,align 1
 %result=call {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} @aggregate_callee_i16_16(<8 x i16> %v0,<8 x i16> %v1,<8 x i16> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %result,0
 store <8 x i16> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 %r1=extractvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %result,1
 store <8 x i16> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 %r2=extractvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %result,2
 store <8 x i16> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 48
 %ri=extractvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 56
 %rf=extractvalue {<8 x i16>,<8 x i16>,<8 x i16>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i16_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i16>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <8 x i16>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <8 x i16>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 48
 %v3=load <8 x i16>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 64
 %v4=load <8 x i16>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 80
 %v5=load <8 x i16>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 96
 %v6=load <8 x i16>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 112
 %v7=load <8 x i16>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 128
 %v8=load <8 x i16>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 144
 %v9=load <8 x i16>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 160
 %v10=load <8 x i16>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 176
 %v11=load <8 x i16>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 192
 %v12=load <8 x i16>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 208
 %v13=load <8 x i16>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 224
 %v14=load <8 x i16>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 240
 %v15=load <8 x i16>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 256
 %v16=load <8 x i16>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 272
 %v17=load <8 x i16>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 288
 %v18=load <8 x i16>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 304
 %v19=load <8 x i16>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 320
 %v20=load <8 x i16>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 336
 %v21=load <8 x i16>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 352
 %v22=load <8 x i16>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 368
 %v23=load <8 x i16>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 384
 %v24=load <8 x i16>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 400
 %v25=load <8 x i16>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 416
 %v26=load <8 x i16>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 432
 %v27=load <8 x i16>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 448
 %v28=load <8 x i16>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 464
 %v29=load <8 x i16>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 480
 %v30=load <8 x i16>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 496
 %v31=load <8 x i16>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 512
 %v32=load <8 x i16>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 528
 %v33=load <8 x i16>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 544
 %v34=load <8 x i16>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 560
 %v35=load <8 x i16>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 576
 %v36=load <8 x i16>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 592
 %v37=load <8 x i16>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 608
 %v38=load <8 x i16>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 624
 %v39=load <8 x i16>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 640)
 %o0=getelementptr i8,ptr %out,i64 0
 store <8 x i16> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 store <8 x i16> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 store <8 x i16> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 48
 store <8 x i16> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 64
 store <8 x i16> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 80
 store <8 x i16> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 96
 store <8 x i16> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 112
 store <8 x i16> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 128
 store <8 x i16> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 144
 store <8 x i16> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 160
 store <8 x i16> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 176
 store <8 x i16> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 192
 store <8 x i16> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 208
 store <8 x i16> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 224
 store <8 x i16> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 240
 store <8 x i16> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 256
 store <8 x i16> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 272
 store <8 x i16> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 288
 store <8 x i16> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 304
 store <8 x i16> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 320
 store <8 x i16> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 336
 store <8 x i16> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 352
 store <8 x i16> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 368
 store <8 x i16> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 384
 store <8 x i16> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 400
 store <8 x i16> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 416
 store <8 x i16> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 432
 store <8 x i16> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 448
 store <8 x i16> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 464
 store <8 x i16> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 480
 store <8 x i16> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 496
 store <8 x i16> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 512
 store <8 x i16> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 528
 store <8 x i16> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 544
 store <8 x i16> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 560
 store <8 x i16> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 576
 store <8 x i16> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 592
 store <8 x i16> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 608
 store <8 x i16> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 624
 store <8 x i16> %v39,ptr %o39,align 1
 ret void
}
define internal <4 x i32> @mix_callee_i32_16(ptr %audit,<4 x i32> %v0,i64 %i0,double %f0,<4 x i32> %v1,i64 %i1,double %f1,<4 x i32> %v2,i64 %i2,double %f2,<4 x i32> %v3,i64 %i3,double %f3,<4 x i32> %v4,i64 %i4,double %f4,<4 x i32> %v5,i64 %i5,double %f5,<4 x i32> %v6,i64 %i6,double %f6,<4 x i32> %v7,i64 %i7,double %f7,<4 x i32> %v8,i64 %i8,double %f8,<4 x i32> %v9,i64 %i9,double %f9,<4 x i32> %v10,i64 %i10,double %f10,<4 x i32> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <4 x i32> %v0 to <4 x i32>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <4 x i32> %v1 to <4 x i32>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <4 x i32> %v2 to <4 x i32>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <4 x i32> %v3 to <4 x i32>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <4 x i32> %v4 to <4 x i32>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <4 x i32> %v5 to <4 x i32>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <4 x i32> %v6 to <4 x i32>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <4 x i32> %v7 to <4 x i32>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <4 x i32> %v8 to <4 x i32>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <4 x i32> %v9 to <4 x i32>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <4 x i32> %v10 to <4 x i32>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <4 x i32> %v11 to <4 x i32>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <4 x i32> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <4 x i32> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <4 x i32> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <4 x i32> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <4 x i32> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <4 x i32> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <4 x i32> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <4 x i32> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <4 x i32> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <4 x i32> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <4 x i32> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <4 x i32> %vx11 to <4 x i32>
 ret <4 x i32> %result
}
define void @abi_mix_i32_16(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x i32>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 192
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 288
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 16
 %v1=load <4 x i32>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 200
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 296
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 32
 %v2=load <4 x i32>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 208
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 304
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 48
 %v3=load <4 x i32>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 216
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 312
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 64
 %v4=load <4 x i32>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 224
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 320
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 80
 %v5=load <4 x i32>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 232
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 328
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 96
 %v6=load <4 x i32>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 240
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 336
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 112
 %v7=load <4 x i32>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 248
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 344
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 128
 %v8=load <4 x i32>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 256
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 352
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 144
 %v9=load <4 x i32>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 264
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 360
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 160
 %v10=load <4 x i32>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 272
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 368
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 176
 %v11=load <4 x i32>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 280
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 376
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 16
 %result=call <4 x i32> @mix_callee_i32_16(ptr %audit,<4 x i32> %v0,i64 %i0,double %f0,<4 x i32> %v1,i64 %i1,double %f1,<4 x i32> %v2,i64 %i2,double %f2,<4 x i32> %v3,i64 %i3,double %f3,<4 x i32> %v4,i64 %i4,double %f4,<4 x i32> %v5,i64 %i5,double %f5,<4 x i32> %v6,i64 %i6,double %f6,<4 x i32> %v7,i64 %i7,double %f7,<4 x i32> %v8,i64 %i8,double %f8,<4 x i32> %v9,i64 %i9,double %f9,<4 x i32> %v10,i64 %i10,double %f10,<4 x i32> %v11,i64 %i11,double %f11)
 store <4 x i32> %result,ptr %out,align 1
 ret void
}
define internal {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} @aggregate_callee_i32_16(<4 x i32> %a,<4 x i32> %b,<4 x i32> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} poison,<4 x i32> %c,0
 %r1=insertvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %r0,<4 x i32> %a,1
 %r2=insertvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %r1,<4 x i32> %b,2
 %r3=insertvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %r3,double %f,4
 ret {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %r4
}
define void @abi_aggregate_i32_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x i32>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <4 x i32>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <4 x i32>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 48
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 56
 %f=load double,ptr %fp,align 1
 %result=call {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} @aggregate_callee_i32_16(<4 x i32> %v0,<4 x i32> %v1,<4 x i32> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %result,0
 store <4 x i32> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 %r1=extractvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %result,1
 store <4 x i32> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 %r2=extractvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %result,2
 store <4 x i32> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 48
 %ri=extractvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 56
 %rf=extractvalue {<4 x i32>,<4 x i32>,<4 x i32>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i32_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x i32>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <4 x i32>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <4 x i32>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 48
 %v3=load <4 x i32>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 64
 %v4=load <4 x i32>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 80
 %v5=load <4 x i32>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 96
 %v6=load <4 x i32>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 112
 %v7=load <4 x i32>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 128
 %v8=load <4 x i32>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 144
 %v9=load <4 x i32>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 160
 %v10=load <4 x i32>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 176
 %v11=load <4 x i32>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 192
 %v12=load <4 x i32>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 208
 %v13=load <4 x i32>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 224
 %v14=load <4 x i32>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 240
 %v15=load <4 x i32>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 256
 %v16=load <4 x i32>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 272
 %v17=load <4 x i32>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 288
 %v18=load <4 x i32>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 304
 %v19=load <4 x i32>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 320
 %v20=load <4 x i32>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 336
 %v21=load <4 x i32>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 352
 %v22=load <4 x i32>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 368
 %v23=load <4 x i32>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 384
 %v24=load <4 x i32>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 400
 %v25=load <4 x i32>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 416
 %v26=load <4 x i32>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 432
 %v27=load <4 x i32>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 448
 %v28=load <4 x i32>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 464
 %v29=load <4 x i32>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 480
 %v30=load <4 x i32>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 496
 %v31=load <4 x i32>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 512
 %v32=load <4 x i32>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 528
 %v33=load <4 x i32>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 544
 %v34=load <4 x i32>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 560
 %v35=load <4 x i32>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 576
 %v36=load <4 x i32>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 592
 %v37=load <4 x i32>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 608
 %v38=load <4 x i32>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 624
 %v39=load <4 x i32>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 640)
 %o0=getelementptr i8,ptr %out,i64 0
 store <4 x i32> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 store <4 x i32> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 store <4 x i32> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 48
 store <4 x i32> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 64
 store <4 x i32> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 80
 store <4 x i32> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 96
 store <4 x i32> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 112
 store <4 x i32> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 128
 store <4 x i32> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 144
 store <4 x i32> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 160
 store <4 x i32> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 176
 store <4 x i32> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 192
 store <4 x i32> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 208
 store <4 x i32> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 224
 store <4 x i32> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 240
 store <4 x i32> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 256
 store <4 x i32> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 272
 store <4 x i32> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 288
 store <4 x i32> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 304
 store <4 x i32> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 320
 store <4 x i32> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 336
 store <4 x i32> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 352
 store <4 x i32> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 368
 store <4 x i32> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 384
 store <4 x i32> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 400
 store <4 x i32> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 416
 store <4 x i32> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 432
 store <4 x i32> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 448
 store <4 x i32> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 464
 store <4 x i32> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 480
 store <4 x i32> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 496
 store <4 x i32> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 512
 store <4 x i32> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 528
 store <4 x i32> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 544
 store <4 x i32> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 560
 store <4 x i32> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 576
 store <4 x i32> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 592
 store <4 x i32> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 608
 store <4 x i32> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 624
 store <4 x i32> %v39,ptr %o39,align 1
 ret void
}
define internal <2 x i64> @mix_callee_i64_16(ptr %audit,<2 x i64> %v0,i64 %i0,double %f0,<2 x i64> %v1,i64 %i1,double %f1,<2 x i64> %v2,i64 %i2,double %f2,<2 x i64> %v3,i64 %i3,double %f3,<2 x i64> %v4,i64 %i4,double %f4,<2 x i64> %v5,i64 %i5,double %f5,<2 x i64> %v6,i64 %i6,double %f6,<2 x i64> %v7,i64 %i7,double %f7,<2 x i64> %v8,i64 %i8,double %f8,<2 x i64> %v9,i64 %i9,double %f9,<2 x i64> %v10,i64 %i10,double %f10,<2 x i64> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <2 x i64> %v0 to <2 x i64>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <2 x i64> %v1 to <2 x i64>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <2 x i64> %v2 to <2 x i64>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <2 x i64> %v3 to <2 x i64>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <2 x i64> %v4 to <2 x i64>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <2 x i64> %v5 to <2 x i64>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <2 x i64> %v6 to <2 x i64>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <2 x i64> %v7 to <2 x i64>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <2 x i64> %v8 to <2 x i64>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <2 x i64> %v9 to <2 x i64>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <2 x i64> %v10 to <2 x i64>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <2 x i64> %v11 to <2 x i64>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <2 x i64> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <2 x i64> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <2 x i64> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <2 x i64> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <2 x i64> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <2 x i64> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <2 x i64> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <2 x i64> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <2 x i64> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <2 x i64> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <2 x i64> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <2 x i64> %vx11 to <2 x i64>
 ret <2 x i64> %result
}
define void @abi_mix_i64_16(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <2 x i64>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 192
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 288
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 16
 %v1=load <2 x i64>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 200
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 296
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 32
 %v2=load <2 x i64>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 208
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 304
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 48
 %v3=load <2 x i64>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 216
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 312
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 64
 %v4=load <2 x i64>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 224
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 320
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 80
 %v5=load <2 x i64>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 232
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 328
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 96
 %v6=load <2 x i64>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 240
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 336
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 112
 %v7=load <2 x i64>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 248
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 344
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 128
 %v8=load <2 x i64>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 256
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 352
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 144
 %v9=load <2 x i64>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 264
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 360
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 160
 %v10=load <2 x i64>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 272
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 368
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 176
 %v11=load <2 x i64>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 280
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 376
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 16
 %result=call <2 x i64> @mix_callee_i64_16(ptr %audit,<2 x i64> %v0,i64 %i0,double %f0,<2 x i64> %v1,i64 %i1,double %f1,<2 x i64> %v2,i64 %i2,double %f2,<2 x i64> %v3,i64 %i3,double %f3,<2 x i64> %v4,i64 %i4,double %f4,<2 x i64> %v5,i64 %i5,double %f5,<2 x i64> %v6,i64 %i6,double %f6,<2 x i64> %v7,i64 %i7,double %f7,<2 x i64> %v8,i64 %i8,double %f8,<2 x i64> %v9,i64 %i9,double %f9,<2 x i64> %v10,i64 %i10,double %f10,<2 x i64> %v11,i64 %i11,double %f11)
 store <2 x i64> %result,ptr %out,align 1
 ret void
}
define internal {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} @aggregate_callee_i64_16(<2 x i64> %a,<2 x i64> %b,<2 x i64> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} poison,<2 x i64> %c,0
 %r1=insertvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %r0,<2 x i64> %a,1
 %r2=insertvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %r1,<2 x i64> %b,2
 %r3=insertvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %r3,double %f,4
 ret {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %r4
}
define void @abi_aggregate_i64_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <2 x i64>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <2 x i64>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <2 x i64>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 48
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 56
 %f=load double,ptr %fp,align 1
 %result=call {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} @aggregate_callee_i64_16(<2 x i64> %v0,<2 x i64> %v1,<2 x i64> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %result,0
 store <2 x i64> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 %r1=extractvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %result,1
 store <2 x i64> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 %r2=extractvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %result,2
 store <2 x i64> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 48
 %ri=extractvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 56
 %rf=extractvalue {<2 x i64>,<2 x i64>,<2 x i64>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i64_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <2 x i64>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <2 x i64>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <2 x i64>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 48
 %v3=load <2 x i64>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 64
 %v4=load <2 x i64>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 80
 %v5=load <2 x i64>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 96
 %v6=load <2 x i64>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 112
 %v7=load <2 x i64>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 128
 %v8=load <2 x i64>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 144
 %v9=load <2 x i64>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 160
 %v10=load <2 x i64>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 176
 %v11=load <2 x i64>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 192
 %v12=load <2 x i64>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 208
 %v13=load <2 x i64>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 224
 %v14=load <2 x i64>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 240
 %v15=load <2 x i64>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 256
 %v16=load <2 x i64>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 272
 %v17=load <2 x i64>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 288
 %v18=load <2 x i64>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 304
 %v19=load <2 x i64>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 320
 %v20=load <2 x i64>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 336
 %v21=load <2 x i64>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 352
 %v22=load <2 x i64>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 368
 %v23=load <2 x i64>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 384
 %v24=load <2 x i64>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 400
 %v25=load <2 x i64>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 416
 %v26=load <2 x i64>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 432
 %v27=load <2 x i64>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 448
 %v28=load <2 x i64>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 464
 %v29=load <2 x i64>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 480
 %v30=load <2 x i64>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 496
 %v31=load <2 x i64>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 512
 %v32=load <2 x i64>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 528
 %v33=load <2 x i64>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 544
 %v34=load <2 x i64>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 560
 %v35=load <2 x i64>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 576
 %v36=load <2 x i64>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 592
 %v37=load <2 x i64>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 608
 %v38=load <2 x i64>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 624
 %v39=load <2 x i64>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 640)
 %o0=getelementptr i8,ptr %out,i64 0
 store <2 x i64> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 store <2 x i64> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 store <2 x i64> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 48
 store <2 x i64> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 64
 store <2 x i64> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 80
 store <2 x i64> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 96
 store <2 x i64> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 112
 store <2 x i64> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 128
 store <2 x i64> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 144
 store <2 x i64> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 160
 store <2 x i64> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 176
 store <2 x i64> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 192
 store <2 x i64> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 208
 store <2 x i64> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 224
 store <2 x i64> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 240
 store <2 x i64> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 256
 store <2 x i64> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 272
 store <2 x i64> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 288
 store <2 x i64> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 304
 store <2 x i64> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 320
 store <2 x i64> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 336
 store <2 x i64> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 352
 store <2 x i64> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 368
 store <2 x i64> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 384
 store <2 x i64> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 400
 store <2 x i64> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 416
 store <2 x i64> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 432
 store <2 x i64> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 448
 store <2 x i64> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 464
 store <2 x i64> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 480
 store <2 x i64> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 496
 store <2 x i64> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 512
 store <2 x i64> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 528
 store <2 x i64> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 544
 store <2 x i64> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 560
 store <2 x i64> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 576
 store <2 x i64> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 592
 store <2 x i64> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 608
 store <2 x i64> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 624
 store <2 x i64> %v39,ptr %o39,align 1
 ret void
}
define internal <4 x float> @mix_callee_f32_16(ptr %audit,<4 x float> %v0,i64 %i0,double %f0,<4 x float> %v1,i64 %i1,double %f1,<4 x float> %v2,i64 %i2,double %f2,<4 x float> %v3,i64 %i3,double %f3,<4 x float> %v4,i64 %i4,double %f4,<4 x float> %v5,i64 %i5,double %f5,<4 x float> %v6,i64 %i6,double %f6,<4 x float> %v7,i64 %i7,double %f7,<4 x float> %v8,i64 %i8,double %f8,<4 x float> %v9,i64 %i9,double %f9,<4 x float> %v10,i64 %i10,double %f10,<4 x float> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <4 x float> %v0 to <4 x i32>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <4 x float> %v1 to <4 x i32>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <4 x float> %v2 to <4 x i32>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <4 x float> %v3 to <4 x i32>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <4 x float> %v4 to <4 x i32>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <4 x float> %v5 to <4 x i32>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <4 x float> %v6 to <4 x i32>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <4 x float> %v7 to <4 x i32>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <4 x float> %v8 to <4 x i32>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <4 x float> %v9 to <4 x i32>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <4 x float> %v10 to <4 x i32>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <4 x float> %v11 to <4 x i32>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <4 x i32> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <4 x i32> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <4 x i32> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <4 x i32> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <4 x i32> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <4 x i32> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <4 x i32> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <4 x i32> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <4 x i32> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <4 x i32> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <4 x i32> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <4 x i32> %vx11 to <4 x float>
 ret <4 x float> %result
}
define void @abi_mix_f32_16(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x float>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 192
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 288
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 16
 %v1=load <4 x float>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 200
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 296
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 32
 %v2=load <4 x float>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 208
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 304
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 48
 %v3=load <4 x float>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 216
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 312
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 64
 %v4=load <4 x float>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 224
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 320
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 80
 %v5=load <4 x float>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 232
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 328
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 96
 %v6=load <4 x float>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 240
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 336
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 112
 %v7=load <4 x float>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 248
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 344
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 128
 %v8=load <4 x float>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 256
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 352
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 144
 %v9=load <4 x float>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 264
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 360
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 160
 %v10=load <4 x float>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 272
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 368
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 176
 %v11=load <4 x float>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 280
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 376
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 16
 %result=call <4 x float> @mix_callee_f32_16(ptr %audit,<4 x float> %v0,i64 %i0,double %f0,<4 x float> %v1,i64 %i1,double %f1,<4 x float> %v2,i64 %i2,double %f2,<4 x float> %v3,i64 %i3,double %f3,<4 x float> %v4,i64 %i4,double %f4,<4 x float> %v5,i64 %i5,double %f5,<4 x float> %v6,i64 %i6,double %f6,<4 x float> %v7,i64 %i7,double %f7,<4 x float> %v8,i64 %i8,double %f8,<4 x float> %v9,i64 %i9,double %f9,<4 x float> %v10,i64 %i10,double %f10,<4 x float> %v11,i64 %i11,double %f11)
 store <4 x float> %result,ptr %out,align 1
 ret void
}
define internal {<4 x float>,<4 x float>,<4 x float>,i64,double} @aggregate_callee_f32_16(<4 x float> %a,<4 x float> %b,<4 x float> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} poison,<4 x float> %c,0
 %r1=insertvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %r0,<4 x float> %a,1
 %r2=insertvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %r1,<4 x float> %b,2
 %r3=insertvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %r3,double %f,4
 ret {<4 x float>,<4 x float>,<4 x float>,i64,double} %r4
}
define void @abi_aggregate_f32_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x float>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <4 x float>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <4 x float>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 48
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 56
 %f=load double,ptr %fp,align 1
 %result=call {<4 x float>,<4 x float>,<4 x float>,i64,double} @aggregate_callee_f32_16(<4 x float> %v0,<4 x float> %v1,<4 x float> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %result,0
 store <4 x float> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 %r1=extractvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %result,1
 store <4 x float> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 %r2=extractvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %result,2
 store <4 x float> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 48
 %ri=extractvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 56
 %rf=extractvalue {<4 x float>,<4 x float>,<4 x float>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_f32_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x float>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <4 x float>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <4 x float>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 48
 %v3=load <4 x float>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 64
 %v4=load <4 x float>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 80
 %v5=load <4 x float>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 96
 %v6=load <4 x float>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 112
 %v7=load <4 x float>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 128
 %v8=load <4 x float>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 144
 %v9=load <4 x float>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 160
 %v10=load <4 x float>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 176
 %v11=load <4 x float>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 192
 %v12=load <4 x float>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 208
 %v13=load <4 x float>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 224
 %v14=load <4 x float>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 240
 %v15=load <4 x float>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 256
 %v16=load <4 x float>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 272
 %v17=load <4 x float>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 288
 %v18=load <4 x float>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 304
 %v19=load <4 x float>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 320
 %v20=load <4 x float>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 336
 %v21=load <4 x float>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 352
 %v22=load <4 x float>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 368
 %v23=load <4 x float>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 384
 %v24=load <4 x float>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 400
 %v25=load <4 x float>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 416
 %v26=load <4 x float>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 432
 %v27=load <4 x float>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 448
 %v28=load <4 x float>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 464
 %v29=load <4 x float>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 480
 %v30=load <4 x float>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 496
 %v31=load <4 x float>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 512
 %v32=load <4 x float>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 528
 %v33=load <4 x float>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 544
 %v34=load <4 x float>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 560
 %v35=load <4 x float>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 576
 %v36=load <4 x float>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 592
 %v37=load <4 x float>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 608
 %v38=load <4 x float>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 624
 %v39=load <4 x float>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 640)
 %o0=getelementptr i8,ptr %out,i64 0
 store <4 x float> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 store <4 x float> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 store <4 x float> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 48
 store <4 x float> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 64
 store <4 x float> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 80
 store <4 x float> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 96
 store <4 x float> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 112
 store <4 x float> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 128
 store <4 x float> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 144
 store <4 x float> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 160
 store <4 x float> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 176
 store <4 x float> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 192
 store <4 x float> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 208
 store <4 x float> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 224
 store <4 x float> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 240
 store <4 x float> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 256
 store <4 x float> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 272
 store <4 x float> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 288
 store <4 x float> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 304
 store <4 x float> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 320
 store <4 x float> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 336
 store <4 x float> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 352
 store <4 x float> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 368
 store <4 x float> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 384
 store <4 x float> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 400
 store <4 x float> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 416
 store <4 x float> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 432
 store <4 x float> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 448
 store <4 x float> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 464
 store <4 x float> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 480
 store <4 x float> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 496
 store <4 x float> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 512
 store <4 x float> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 528
 store <4 x float> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 544
 store <4 x float> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 560
 store <4 x float> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 576
 store <4 x float> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 592
 store <4 x float> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 608
 store <4 x float> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 624
 store <4 x float> %v39,ptr %o39,align 1
 ret void
}
define internal <2 x double> @mix_callee_f64_16(ptr %audit,<2 x double> %v0,i64 %i0,double %f0,<2 x double> %v1,i64 %i1,double %f1,<2 x double> %v2,i64 %i2,double %f2,<2 x double> %v3,i64 %i3,double %f3,<2 x double> %v4,i64 %i4,double %f4,<2 x double> %v5,i64 %i5,double %f5,<2 x double> %v6,i64 %i6,double %f6,<2 x double> %v7,i64 %i7,double %f7,<2 x double> %v8,i64 %i8,double %f8,<2 x double> %v9,i64 %i9,double %f9,<2 x double> %v10,i64 %i10,double %f10,<2 x double> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <2 x double> %v0 to <2 x i64>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <2 x double> %v1 to <2 x i64>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <2 x double> %v2 to <2 x i64>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <2 x double> %v3 to <2 x i64>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <2 x double> %v4 to <2 x i64>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <2 x double> %v5 to <2 x i64>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <2 x double> %v6 to <2 x i64>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <2 x double> %v7 to <2 x i64>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <2 x double> %v8 to <2 x i64>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <2 x double> %v9 to <2 x i64>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <2 x double> %v10 to <2 x i64>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <2 x double> %v11 to <2 x i64>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <2 x i64> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <2 x i64> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <2 x i64> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <2 x i64> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <2 x i64> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <2 x i64> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <2 x i64> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <2 x i64> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <2 x i64> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <2 x i64> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <2 x i64> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <2 x i64> %vx11 to <2 x double>
 ret <2 x double> %result
}
define void @abi_mix_f64_16(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <2 x double>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 192
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 288
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 16
 %v1=load <2 x double>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 200
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 296
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 32
 %v2=load <2 x double>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 208
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 304
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 48
 %v3=load <2 x double>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 216
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 312
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 64
 %v4=load <2 x double>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 224
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 320
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 80
 %v5=load <2 x double>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 232
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 328
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 96
 %v6=load <2 x double>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 240
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 336
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 112
 %v7=load <2 x double>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 248
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 344
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 128
 %v8=load <2 x double>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 256
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 352
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 144
 %v9=load <2 x double>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 264
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 360
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 160
 %v10=load <2 x double>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 272
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 368
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 176
 %v11=load <2 x double>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 280
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 376
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 16
 %result=call <2 x double> @mix_callee_f64_16(ptr %audit,<2 x double> %v0,i64 %i0,double %f0,<2 x double> %v1,i64 %i1,double %f1,<2 x double> %v2,i64 %i2,double %f2,<2 x double> %v3,i64 %i3,double %f3,<2 x double> %v4,i64 %i4,double %f4,<2 x double> %v5,i64 %i5,double %f5,<2 x double> %v6,i64 %i6,double %f6,<2 x double> %v7,i64 %i7,double %f7,<2 x double> %v8,i64 %i8,double %f8,<2 x double> %v9,i64 %i9,double %f9,<2 x double> %v10,i64 %i10,double %f10,<2 x double> %v11,i64 %i11,double %f11)
 store <2 x double> %result,ptr %out,align 1
 ret void
}
define internal {<2 x double>,<2 x double>,<2 x double>,i64,double} @aggregate_callee_f64_16(<2 x double> %a,<2 x double> %b,<2 x double> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} poison,<2 x double> %c,0
 %r1=insertvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %r0,<2 x double> %a,1
 %r2=insertvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %r1,<2 x double> %b,2
 %r3=insertvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %r3,double %f,4
 ret {<2 x double>,<2 x double>,<2 x double>,i64,double} %r4
}
define void @abi_aggregate_f64_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <2 x double>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <2 x double>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <2 x double>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 48
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 56
 %f=load double,ptr %fp,align 1
 %result=call {<2 x double>,<2 x double>,<2 x double>,i64,double} @aggregate_callee_f64_16(<2 x double> %v0,<2 x double> %v1,<2 x double> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %result,0
 store <2 x double> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 %r1=extractvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %result,1
 store <2 x double> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 %r2=extractvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %result,2
 store <2 x double> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 48
 %ri=extractvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 56
 %rf=extractvalue {<2 x double>,<2 x double>,<2 x double>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_f64_16(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <2 x double>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 16
 %v1=load <2 x double>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 32
 %v2=load <2 x double>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 48
 %v3=load <2 x double>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 64
 %v4=load <2 x double>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 80
 %v5=load <2 x double>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 96
 %v6=load <2 x double>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 112
 %v7=load <2 x double>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 128
 %v8=load <2 x double>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 144
 %v9=load <2 x double>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 160
 %v10=load <2 x double>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 176
 %v11=load <2 x double>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 192
 %v12=load <2 x double>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 208
 %v13=load <2 x double>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 224
 %v14=load <2 x double>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 240
 %v15=load <2 x double>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 256
 %v16=load <2 x double>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 272
 %v17=load <2 x double>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 288
 %v18=load <2 x double>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 304
 %v19=load <2 x double>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 320
 %v20=load <2 x double>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 336
 %v21=load <2 x double>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 352
 %v22=load <2 x double>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 368
 %v23=load <2 x double>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 384
 %v24=load <2 x double>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 400
 %v25=load <2 x double>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 416
 %v26=load <2 x double>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 432
 %v27=load <2 x double>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 448
 %v28=load <2 x double>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 464
 %v29=load <2 x double>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 480
 %v30=load <2 x double>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 496
 %v31=load <2 x double>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 512
 %v32=load <2 x double>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 528
 %v33=load <2 x double>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 544
 %v34=load <2 x double>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 560
 %v35=load <2 x double>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 576
 %v36=load <2 x double>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 592
 %v37=load <2 x double>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 608
 %v38=load <2 x double>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 624
 %v39=load <2 x double>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 640)
 %o0=getelementptr i8,ptr %out,i64 0
 store <2 x double> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 16
 store <2 x double> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 32
 store <2 x double> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 48
 store <2 x double> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 64
 store <2 x double> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 80
 store <2 x double> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 96
 store <2 x double> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 112
 store <2 x double> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 128
 store <2 x double> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 144
 store <2 x double> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 160
 store <2 x double> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 176
 store <2 x double> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 192
 store <2 x double> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 208
 store <2 x double> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 224
 store <2 x double> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 240
 store <2 x double> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 256
 store <2 x double> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 272
 store <2 x double> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 288
 store <2 x double> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 304
 store <2 x double> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 320
 store <2 x double> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 336
 store <2 x double> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 352
 store <2 x double> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 368
 store <2 x double> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 384
 store <2 x double> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 400
 store <2 x double> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 416
 store <2 x double> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 432
 store <2 x double> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 448
 store <2 x double> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 464
 store <2 x double> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 480
 store <2 x double> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 496
 store <2 x double> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 512
 store <2 x double> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 528
 store <2 x double> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 544
 store <2 x double> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 560
 store <2 x double> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 576
 store <2 x double> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 592
 store <2 x double> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 608
 store <2 x double> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 624
 store <2 x double> %v39,ptr %o39,align 1
 ret void
}
define internal <32 x i8> @mix_callee_i8_32(ptr %audit,<32 x i8> %v0,i64 %i0,double %f0,<32 x i8> %v1,i64 %i1,double %f1,<32 x i8> %v2,i64 %i2,double %f2,<32 x i8> %v3,i64 %i3,double %f3,<32 x i8> %v4,i64 %i4,double %f4,<32 x i8> %v5,i64 %i5,double %f5,<32 x i8> %v6,i64 %i6,double %f6,<32 x i8> %v7,i64 %i7,double %f7,<32 x i8> %v8,i64 %i8,double %f8,<32 x i8> %v9,i64 %i9,double %f9,<32 x i8> %v10,i64 %i10,double %f10,<32 x i8> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <32 x i8> %v0 to <32 x i8>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <32 x i8> %v1 to <32 x i8>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <32 x i8> %v2 to <32 x i8>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <32 x i8> %v3 to <32 x i8>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <32 x i8> %v4 to <32 x i8>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <32 x i8> %v5 to <32 x i8>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <32 x i8> %v6 to <32 x i8>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <32 x i8> %v7 to <32 x i8>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <32 x i8> %v8 to <32 x i8>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <32 x i8> %v9 to <32 x i8>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <32 x i8> %v10 to <32 x i8>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <32 x i8> %v11 to <32 x i8>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <32 x i8> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <32 x i8> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <32 x i8> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <32 x i8> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <32 x i8> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <32 x i8> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <32 x i8> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <32 x i8> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <32 x i8> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <32 x i8> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <32 x i8> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <32 x i8> %vx11 to <32 x i8>
 ret <32 x i8> %result
}
define void @abi_mix_i8_32(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <32 x i8>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 384
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 480
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 32
 %v1=load <32 x i8>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 392
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 488
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 64
 %v2=load <32 x i8>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 400
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 496
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 96
 %v3=load <32 x i8>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 408
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 504
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 128
 %v4=load <32 x i8>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 416
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 512
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 160
 %v5=load <32 x i8>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 424
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 520
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 192
 %v6=load <32 x i8>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 432
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 528
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 224
 %v7=load <32 x i8>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 440
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 536
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 256
 %v8=load <32 x i8>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 448
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 544
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 288
 %v9=load <32 x i8>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 456
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 552
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 320
 %v10=load <32 x i8>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 464
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 560
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 352
 %v11=load <32 x i8>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 472
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 568
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 32
 %result=call <32 x i8> @mix_callee_i8_32(ptr %audit,<32 x i8> %v0,i64 %i0,double %f0,<32 x i8> %v1,i64 %i1,double %f1,<32 x i8> %v2,i64 %i2,double %f2,<32 x i8> %v3,i64 %i3,double %f3,<32 x i8> %v4,i64 %i4,double %f4,<32 x i8> %v5,i64 %i5,double %f5,<32 x i8> %v6,i64 %i6,double %f6,<32 x i8> %v7,i64 %i7,double %f7,<32 x i8> %v8,i64 %i8,double %f8,<32 x i8> %v9,i64 %i9,double %f9,<32 x i8> %v10,i64 %i10,double %f10,<32 x i8> %v11,i64 %i11,double %f11)
 store <32 x i8> %result,ptr %out,align 1
 ret void
}
define internal {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} @aggregate_callee_i8_32(<32 x i8> %a,<32 x i8> %b,<32 x i8> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} poison,<32 x i8> %c,0
 %r1=insertvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %r0,<32 x i8> %a,1
 %r2=insertvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %r1,<32 x i8> %b,2
 %r3=insertvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %r3,double %f,4
 ret {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %r4
}
define void @abi_aggregate_i8_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <32 x i8>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <32 x i8>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <32 x i8>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 96
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 104
 %f=load double,ptr %fp,align 1
 %result=call {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} @aggregate_callee_i8_32(<32 x i8> %v0,<32 x i8> %v1,<32 x i8> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %result,0
 store <32 x i8> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 %r1=extractvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %result,1
 store <32 x i8> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 %r2=extractvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %result,2
 store <32 x i8> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 96
 %ri=extractvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 104
 %rf=extractvalue {<32 x i8>,<32 x i8>,<32 x i8>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i8_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <32 x i8>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <32 x i8>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <32 x i8>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 96
 %v3=load <32 x i8>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 128
 %v4=load <32 x i8>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 160
 %v5=load <32 x i8>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 192
 %v6=load <32 x i8>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 224
 %v7=load <32 x i8>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 256
 %v8=load <32 x i8>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 288
 %v9=load <32 x i8>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 320
 %v10=load <32 x i8>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 352
 %v11=load <32 x i8>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 384
 %v12=load <32 x i8>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 416
 %v13=load <32 x i8>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 448
 %v14=load <32 x i8>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 480
 %v15=load <32 x i8>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 512
 %v16=load <32 x i8>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 544
 %v17=load <32 x i8>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 576
 %v18=load <32 x i8>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 608
 %v19=load <32 x i8>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 640
 %v20=load <32 x i8>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 672
 %v21=load <32 x i8>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 704
 %v22=load <32 x i8>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 736
 %v23=load <32 x i8>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 768
 %v24=load <32 x i8>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 800
 %v25=load <32 x i8>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 832
 %v26=load <32 x i8>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 864
 %v27=load <32 x i8>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 896
 %v28=load <32 x i8>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 928
 %v29=load <32 x i8>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 960
 %v30=load <32 x i8>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 992
 %v31=load <32 x i8>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 1024
 %v32=load <32 x i8>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 1056
 %v33=load <32 x i8>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 1088
 %v34=load <32 x i8>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 1120
 %v35=load <32 x i8>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 1152
 %v36=load <32 x i8>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 1184
 %v37=load <32 x i8>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 1216
 %v38=load <32 x i8>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 1248
 %v39=load <32 x i8>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 1280)
 %o0=getelementptr i8,ptr %out,i64 0
 store <32 x i8> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 store <32 x i8> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 store <32 x i8> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 96
 store <32 x i8> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 128
 store <32 x i8> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 160
 store <32 x i8> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 192
 store <32 x i8> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 224
 store <32 x i8> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 256
 store <32 x i8> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 288
 store <32 x i8> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 320
 store <32 x i8> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 352
 store <32 x i8> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 384
 store <32 x i8> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 416
 store <32 x i8> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 448
 store <32 x i8> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 480
 store <32 x i8> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 512
 store <32 x i8> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 544
 store <32 x i8> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 576
 store <32 x i8> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 608
 store <32 x i8> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 640
 store <32 x i8> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 672
 store <32 x i8> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 704
 store <32 x i8> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 736
 store <32 x i8> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 768
 store <32 x i8> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 800
 store <32 x i8> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 832
 store <32 x i8> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 864
 store <32 x i8> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 896
 store <32 x i8> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 928
 store <32 x i8> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 960
 store <32 x i8> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 992
 store <32 x i8> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 1024
 store <32 x i8> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 1056
 store <32 x i8> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 1088
 store <32 x i8> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 1120
 store <32 x i8> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 1152
 store <32 x i8> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 1184
 store <32 x i8> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 1216
 store <32 x i8> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 1248
 store <32 x i8> %v39,ptr %o39,align 1
 ret void
}
define internal <16 x i16> @mix_callee_i16_32(ptr %audit,<16 x i16> %v0,i64 %i0,double %f0,<16 x i16> %v1,i64 %i1,double %f1,<16 x i16> %v2,i64 %i2,double %f2,<16 x i16> %v3,i64 %i3,double %f3,<16 x i16> %v4,i64 %i4,double %f4,<16 x i16> %v5,i64 %i5,double %f5,<16 x i16> %v6,i64 %i6,double %f6,<16 x i16> %v7,i64 %i7,double %f7,<16 x i16> %v8,i64 %i8,double %f8,<16 x i16> %v9,i64 %i9,double %f9,<16 x i16> %v10,i64 %i10,double %f10,<16 x i16> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <16 x i16> %v0 to <16 x i16>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <16 x i16> %v1 to <16 x i16>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <16 x i16> %v2 to <16 x i16>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <16 x i16> %v3 to <16 x i16>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <16 x i16> %v4 to <16 x i16>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <16 x i16> %v5 to <16 x i16>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <16 x i16> %v6 to <16 x i16>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <16 x i16> %v7 to <16 x i16>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <16 x i16> %v8 to <16 x i16>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <16 x i16> %v9 to <16 x i16>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <16 x i16> %v10 to <16 x i16>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <16 x i16> %v11 to <16 x i16>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <16 x i16> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <16 x i16> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <16 x i16> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <16 x i16> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <16 x i16> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <16 x i16> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <16 x i16> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <16 x i16> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <16 x i16> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <16 x i16> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <16 x i16> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <16 x i16> %vx11 to <16 x i16>
 ret <16 x i16> %result
}
define void @abi_mix_i16_32(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i16>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 384
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 480
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 32
 %v1=load <16 x i16>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 392
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 488
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 64
 %v2=load <16 x i16>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 400
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 496
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 96
 %v3=load <16 x i16>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 408
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 504
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 128
 %v4=load <16 x i16>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 416
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 512
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 160
 %v5=load <16 x i16>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 424
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 520
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 192
 %v6=load <16 x i16>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 432
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 528
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 224
 %v7=load <16 x i16>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 440
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 536
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 256
 %v8=load <16 x i16>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 448
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 544
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 288
 %v9=load <16 x i16>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 456
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 552
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 320
 %v10=load <16 x i16>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 464
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 560
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 352
 %v11=load <16 x i16>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 472
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 568
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 32
 %result=call <16 x i16> @mix_callee_i16_32(ptr %audit,<16 x i16> %v0,i64 %i0,double %f0,<16 x i16> %v1,i64 %i1,double %f1,<16 x i16> %v2,i64 %i2,double %f2,<16 x i16> %v3,i64 %i3,double %f3,<16 x i16> %v4,i64 %i4,double %f4,<16 x i16> %v5,i64 %i5,double %f5,<16 x i16> %v6,i64 %i6,double %f6,<16 x i16> %v7,i64 %i7,double %f7,<16 x i16> %v8,i64 %i8,double %f8,<16 x i16> %v9,i64 %i9,double %f9,<16 x i16> %v10,i64 %i10,double %f10,<16 x i16> %v11,i64 %i11,double %f11)
 store <16 x i16> %result,ptr %out,align 1
 ret void
}
define internal {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} @aggregate_callee_i16_32(<16 x i16> %a,<16 x i16> %b,<16 x i16> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} poison,<16 x i16> %c,0
 %r1=insertvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %r0,<16 x i16> %a,1
 %r2=insertvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %r1,<16 x i16> %b,2
 %r3=insertvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %r3,double %f,4
 ret {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %r4
}
define void @abi_aggregate_i16_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i16>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <16 x i16>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <16 x i16>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 96
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 104
 %f=load double,ptr %fp,align 1
 %result=call {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} @aggregate_callee_i16_32(<16 x i16> %v0,<16 x i16> %v1,<16 x i16> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %result,0
 store <16 x i16> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 %r1=extractvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %result,1
 store <16 x i16> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 %r2=extractvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %result,2
 store <16 x i16> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 96
 %ri=extractvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 104
 %rf=extractvalue {<16 x i16>,<16 x i16>,<16 x i16>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i16_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i16>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <16 x i16>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <16 x i16>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 96
 %v3=load <16 x i16>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 128
 %v4=load <16 x i16>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 160
 %v5=load <16 x i16>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 192
 %v6=load <16 x i16>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 224
 %v7=load <16 x i16>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 256
 %v8=load <16 x i16>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 288
 %v9=load <16 x i16>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 320
 %v10=load <16 x i16>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 352
 %v11=load <16 x i16>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 384
 %v12=load <16 x i16>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 416
 %v13=load <16 x i16>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 448
 %v14=load <16 x i16>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 480
 %v15=load <16 x i16>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 512
 %v16=load <16 x i16>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 544
 %v17=load <16 x i16>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 576
 %v18=load <16 x i16>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 608
 %v19=load <16 x i16>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 640
 %v20=load <16 x i16>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 672
 %v21=load <16 x i16>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 704
 %v22=load <16 x i16>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 736
 %v23=load <16 x i16>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 768
 %v24=load <16 x i16>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 800
 %v25=load <16 x i16>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 832
 %v26=load <16 x i16>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 864
 %v27=load <16 x i16>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 896
 %v28=load <16 x i16>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 928
 %v29=load <16 x i16>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 960
 %v30=load <16 x i16>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 992
 %v31=load <16 x i16>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 1024
 %v32=load <16 x i16>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 1056
 %v33=load <16 x i16>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 1088
 %v34=load <16 x i16>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 1120
 %v35=load <16 x i16>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 1152
 %v36=load <16 x i16>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 1184
 %v37=load <16 x i16>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 1216
 %v38=load <16 x i16>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 1248
 %v39=load <16 x i16>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 1280)
 %o0=getelementptr i8,ptr %out,i64 0
 store <16 x i16> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 store <16 x i16> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 store <16 x i16> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 96
 store <16 x i16> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 128
 store <16 x i16> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 160
 store <16 x i16> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 192
 store <16 x i16> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 224
 store <16 x i16> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 256
 store <16 x i16> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 288
 store <16 x i16> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 320
 store <16 x i16> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 352
 store <16 x i16> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 384
 store <16 x i16> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 416
 store <16 x i16> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 448
 store <16 x i16> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 480
 store <16 x i16> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 512
 store <16 x i16> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 544
 store <16 x i16> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 576
 store <16 x i16> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 608
 store <16 x i16> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 640
 store <16 x i16> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 672
 store <16 x i16> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 704
 store <16 x i16> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 736
 store <16 x i16> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 768
 store <16 x i16> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 800
 store <16 x i16> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 832
 store <16 x i16> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 864
 store <16 x i16> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 896
 store <16 x i16> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 928
 store <16 x i16> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 960
 store <16 x i16> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 992
 store <16 x i16> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 1024
 store <16 x i16> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 1056
 store <16 x i16> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 1088
 store <16 x i16> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 1120
 store <16 x i16> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 1152
 store <16 x i16> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 1184
 store <16 x i16> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 1216
 store <16 x i16> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 1248
 store <16 x i16> %v39,ptr %o39,align 1
 ret void
}
define internal <8 x i32> @mix_callee_i32_32(ptr %audit,<8 x i32> %v0,i64 %i0,double %f0,<8 x i32> %v1,i64 %i1,double %f1,<8 x i32> %v2,i64 %i2,double %f2,<8 x i32> %v3,i64 %i3,double %f3,<8 x i32> %v4,i64 %i4,double %f4,<8 x i32> %v5,i64 %i5,double %f5,<8 x i32> %v6,i64 %i6,double %f6,<8 x i32> %v7,i64 %i7,double %f7,<8 x i32> %v8,i64 %i8,double %f8,<8 x i32> %v9,i64 %i9,double %f9,<8 x i32> %v10,i64 %i10,double %f10,<8 x i32> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <8 x i32> %v0 to <8 x i32>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <8 x i32> %v1 to <8 x i32>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <8 x i32> %v2 to <8 x i32>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <8 x i32> %v3 to <8 x i32>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <8 x i32> %v4 to <8 x i32>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <8 x i32> %v5 to <8 x i32>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <8 x i32> %v6 to <8 x i32>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <8 x i32> %v7 to <8 x i32>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <8 x i32> %v8 to <8 x i32>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <8 x i32> %v9 to <8 x i32>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <8 x i32> %v10 to <8 x i32>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <8 x i32> %v11 to <8 x i32>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <8 x i32> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <8 x i32> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <8 x i32> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <8 x i32> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <8 x i32> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <8 x i32> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <8 x i32> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <8 x i32> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <8 x i32> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <8 x i32> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <8 x i32> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <8 x i32> %vx11 to <8 x i32>
 ret <8 x i32> %result
}
define void @abi_mix_i32_32(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i32>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 384
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 480
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 32
 %v1=load <8 x i32>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 392
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 488
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 64
 %v2=load <8 x i32>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 400
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 496
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 96
 %v3=load <8 x i32>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 408
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 504
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 128
 %v4=load <8 x i32>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 416
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 512
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 160
 %v5=load <8 x i32>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 424
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 520
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 192
 %v6=load <8 x i32>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 432
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 528
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 224
 %v7=load <8 x i32>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 440
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 536
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 256
 %v8=load <8 x i32>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 448
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 544
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 288
 %v9=load <8 x i32>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 456
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 552
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 320
 %v10=load <8 x i32>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 464
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 560
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 352
 %v11=load <8 x i32>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 472
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 568
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 32
 %result=call <8 x i32> @mix_callee_i32_32(ptr %audit,<8 x i32> %v0,i64 %i0,double %f0,<8 x i32> %v1,i64 %i1,double %f1,<8 x i32> %v2,i64 %i2,double %f2,<8 x i32> %v3,i64 %i3,double %f3,<8 x i32> %v4,i64 %i4,double %f4,<8 x i32> %v5,i64 %i5,double %f5,<8 x i32> %v6,i64 %i6,double %f6,<8 x i32> %v7,i64 %i7,double %f7,<8 x i32> %v8,i64 %i8,double %f8,<8 x i32> %v9,i64 %i9,double %f9,<8 x i32> %v10,i64 %i10,double %f10,<8 x i32> %v11,i64 %i11,double %f11)
 store <8 x i32> %result,ptr %out,align 1
 ret void
}
define internal {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} @aggregate_callee_i32_32(<8 x i32> %a,<8 x i32> %b,<8 x i32> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} poison,<8 x i32> %c,0
 %r1=insertvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %r0,<8 x i32> %a,1
 %r2=insertvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %r1,<8 x i32> %b,2
 %r3=insertvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %r3,double %f,4
 ret {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %r4
}
define void @abi_aggregate_i32_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i32>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <8 x i32>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <8 x i32>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 96
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 104
 %f=load double,ptr %fp,align 1
 %result=call {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} @aggregate_callee_i32_32(<8 x i32> %v0,<8 x i32> %v1,<8 x i32> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %result,0
 store <8 x i32> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 %r1=extractvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %result,1
 store <8 x i32> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 %r2=extractvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %result,2
 store <8 x i32> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 96
 %ri=extractvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 104
 %rf=extractvalue {<8 x i32>,<8 x i32>,<8 x i32>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i32_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i32>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <8 x i32>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <8 x i32>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 96
 %v3=load <8 x i32>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 128
 %v4=load <8 x i32>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 160
 %v5=load <8 x i32>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 192
 %v6=load <8 x i32>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 224
 %v7=load <8 x i32>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 256
 %v8=load <8 x i32>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 288
 %v9=load <8 x i32>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 320
 %v10=load <8 x i32>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 352
 %v11=load <8 x i32>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 384
 %v12=load <8 x i32>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 416
 %v13=load <8 x i32>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 448
 %v14=load <8 x i32>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 480
 %v15=load <8 x i32>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 512
 %v16=load <8 x i32>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 544
 %v17=load <8 x i32>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 576
 %v18=load <8 x i32>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 608
 %v19=load <8 x i32>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 640
 %v20=load <8 x i32>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 672
 %v21=load <8 x i32>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 704
 %v22=load <8 x i32>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 736
 %v23=load <8 x i32>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 768
 %v24=load <8 x i32>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 800
 %v25=load <8 x i32>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 832
 %v26=load <8 x i32>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 864
 %v27=load <8 x i32>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 896
 %v28=load <8 x i32>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 928
 %v29=load <8 x i32>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 960
 %v30=load <8 x i32>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 992
 %v31=load <8 x i32>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 1024
 %v32=load <8 x i32>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 1056
 %v33=load <8 x i32>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 1088
 %v34=load <8 x i32>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 1120
 %v35=load <8 x i32>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 1152
 %v36=load <8 x i32>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 1184
 %v37=load <8 x i32>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 1216
 %v38=load <8 x i32>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 1248
 %v39=load <8 x i32>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 1280)
 %o0=getelementptr i8,ptr %out,i64 0
 store <8 x i32> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 store <8 x i32> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 store <8 x i32> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 96
 store <8 x i32> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 128
 store <8 x i32> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 160
 store <8 x i32> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 192
 store <8 x i32> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 224
 store <8 x i32> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 256
 store <8 x i32> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 288
 store <8 x i32> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 320
 store <8 x i32> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 352
 store <8 x i32> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 384
 store <8 x i32> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 416
 store <8 x i32> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 448
 store <8 x i32> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 480
 store <8 x i32> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 512
 store <8 x i32> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 544
 store <8 x i32> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 576
 store <8 x i32> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 608
 store <8 x i32> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 640
 store <8 x i32> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 672
 store <8 x i32> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 704
 store <8 x i32> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 736
 store <8 x i32> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 768
 store <8 x i32> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 800
 store <8 x i32> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 832
 store <8 x i32> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 864
 store <8 x i32> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 896
 store <8 x i32> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 928
 store <8 x i32> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 960
 store <8 x i32> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 992
 store <8 x i32> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 1024
 store <8 x i32> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 1056
 store <8 x i32> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 1088
 store <8 x i32> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 1120
 store <8 x i32> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 1152
 store <8 x i32> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 1184
 store <8 x i32> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 1216
 store <8 x i32> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 1248
 store <8 x i32> %v39,ptr %o39,align 1
 ret void
}
define internal <4 x i64> @mix_callee_i64_32(ptr %audit,<4 x i64> %v0,i64 %i0,double %f0,<4 x i64> %v1,i64 %i1,double %f1,<4 x i64> %v2,i64 %i2,double %f2,<4 x i64> %v3,i64 %i3,double %f3,<4 x i64> %v4,i64 %i4,double %f4,<4 x i64> %v5,i64 %i5,double %f5,<4 x i64> %v6,i64 %i6,double %f6,<4 x i64> %v7,i64 %i7,double %f7,<4 x i64> %v8,i64 %i8,double %f8,<4 x i64> %v9,i64 %i9,double %f9,<4 x i64> %v10,i64 %i10,double %f10,<4 x i64> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <4 x i64> %v0 to <4 x i64>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <4 x i64> %v1 to <4 x i64>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <4 x i64> %v2 to <4 x i64>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <4 x i64> %v3 to <4 x i64>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <4 x i64> %v4 to <4 x i64>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <4 x i64> %v5 to <4 x i64>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <4 x i64> %v6 to <4 x i64>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <4 x i64> %v7 to <4 x i64>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <4 x i64> %v8 to <4 x i64>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <4 x i64> %v9 to <4 x i64>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <4 x i64> %v10 to <4 x i64>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <4 x i64> %v11 to <4 x i64>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <4 x i64> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <4 x i64> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <4 x i64> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <4 x i64> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <4 x i64> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <4 x i64> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <4 x i64> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <4 x i64> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <4 x i64> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <4 x i64> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <4 x i64> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <4 x i64> %vx11 to <4 x i64>
 ret <4 x i64> %result
}
define void @abi_mix_i64_32(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x i64>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 384
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 480
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 32
 %v1=load <4 x i64>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 392
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 488
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 64
 %v2=load <4 x i64>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 400
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 496
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 96
 %v3=load <4 x i64>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 408
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 504
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 128
 %v4=load <4 x i64>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 416
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 512
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 160
 %v5=load <4 x i64>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 424
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 520
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 192
 %v6=load <4 x i64>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 432
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 528
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 224
 %v7=load <4 x i64>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 440
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 536
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 256
 %v8=load <4 x i64>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 448
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 544
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 288
 %v9=load <4 x i64>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 456
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 552
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 320
 %v10=load <4 x i64>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 464
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 560
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 352
 %v11=load <4 x i64>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 472
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 568
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 32
 %result=call <4 x i64> @mix_callee_i64_32(ptr %audit,<4 x i64> %v0,i64 %i0,double %f0,<4 x i64> %v1,i64 %i1,double %f1,<4 x i64> %v2,i64 %i2,double %f2,<4 x i64> %v3,i64 %i3,double %f3,<4 x i64> %v4,i64 %i4,double %f4,<4 x i64> %v5,i64 %i5,double %f5,<4 x i64> %v6,i64 %i6,double %f6,<4 x i64> %v7,i64 %i7,double %f7,<4 x i64> %v8,i64 %i8,double %f8,<4 x i64> %v9,i64 %i9,double %f9,<4 x i64> %v10,i64 %i10,double %f10,<4 x i64> %v11,i64 %i11,double %f11)
 store <4 x i64> %result,ptr %out,align 1
 ret void
}
define internal {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} @aggregate_callee_i64_32(<4 x i64> %a,<4 x i64> %b,<4 x i64> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} poison,<4 x i64> %c,0
 %r1=insertvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %r0,<4 x i64> %a,1
 %r2=insertvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %r1,<4 x i64> %b,2
 %r3=insertvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %r3,double %f,4
 ret {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %r4
}
define void @abi_aggregate_i64_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x i64>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <4 x i64>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <4 x i64>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 96
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 104
 %f=load double,ptr %fp,align 1
 %result=call {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} @aggregate_callee_i64_32(<4 x i64> %v0,<4 x i64> %v1,<4 x i64> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %result,0
 store <4 x i64> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 %r1=extractvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %result,1
 store <4 x i64> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 %r2=extractvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %result,2
 store <4 x i64> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 96
 %ri=extractvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 104
 %rf=extractvalue {<4 x i64>,<4 x i64>,<4 x i64>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i64_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x i64>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <4 x i64>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <4 x i64>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 96
 %v3=load <4 x i64>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 128
 %v4=load <4 x i64>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 160
 %v5=load <4 x i64>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 192
 %v6=load <4 x i64>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 224
 %v7=load <4 x i64>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 256
 %v8=load <4 x i64>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 288
 %v9=load <4 x i64>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 320
 %v10=load <4 x i64>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 352
 %v11=load <4 x i64>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 384
 %v12=load <4 x i64>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 416
 %v13=load <4 x i64>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 448
 %v14=load <4 x i64>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 480
 %v15=load <4 x i64>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 512
 %v16=load <4 x i64>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 544
 %v17=load <4 x i64>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 576
 %v18=load <4 x i64>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 608
 %v19=load <4 x i64>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 640
 %v20=load <4 x i64>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 672
 %v21=load <4 x i64>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 704
 %v22=load <4 x i64>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 736
 %v23=load <4 x i64>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 768
 %v24=load <4 x i64>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 800
 %v25=load <4 x i64>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 832
 %v26=load <4 x i64>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 864
 %v27=load <4 x i64>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 896
 %v28=load <4 x i64>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 928
 %v29=load <4 x i64>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 960
 %v30=load <4 x i64>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 992
 %v31=load <4 x i64>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 1024
 %v32=load <4 x i64>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 1056
 %v33=load <4 x i64>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 1088
 %v34=load <4 x i64>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 1120
 %v35=load <4 x i64>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 1152
 %v36=load <4 x i64>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 1184
 %v37=load <4 x i64>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 1216
 %v38=load <4 x i64>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 1248
 %v39=load <4 x i64>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 1280)
 %o0=getelementptr i8,ptr %out,i64 0
 store <4 x i64> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 store <4 x i64> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 store <4 x i64> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 96
 store <4 x i64> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 128
 store <4 x i64> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 160
 store <4 x i64> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 192
 store <4 x i64> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 224
 store <4 x i64> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 256
 store <4 x i64> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 288
 store <4 x i64> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 320
 store <4 x i64> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 352
 store <4 x i64> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 384
 store <4 x i64> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 416
 store <4 x i64> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 448
 store <4 x i64> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 480
 store <4 x i64> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 512
 store <4 x i64> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 544
 store <4 x i64> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 576
 store <4 x i64> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 608
 store <4 x i64> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 640
 store <4 x i64> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 672
 store <4 x i64> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 704
 store <4 x i64> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 736
 store <4 x i64> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 768
 store <4 x i64> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 800
 store <4 x i64> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 832
 store <4 x i64> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 864
 store <4 x i64> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 896
 store <4 x i64> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 928
 store <4 x i64> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 960
 store <4 x i64> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 992
 store <4 x i64> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 1024
 store <4 x i64> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 1056
 store <4 x i64> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 1088
 store <4 x i64> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 1120
 store <4 x i64> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 1152
 store <4 x i64> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 1184
 store <4 x i64> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 1216
 store <4 x i64> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 1248
 store <4 x i64> %v39,ptr %o39,align 1
 ret void
}
define internal <8 x float> @mix_callee_f32_32(ptr %audit,<8 x float> %v0,i64 %i0,double %f0,<8 x float> %v1,i64 %i1,double %f1,<8 x float> %v2,i64 %i2,double %f2,<8 x float> %v3,i64 %i3,double %f3,<8 x float> %v4,i64 %i4,double %f4,<8 x float> %v5,i64 %i5,double %f5,<8 x float> %v6,i64 %i6,double %f6,<8 x float> %v7,i64 %i7,double %f7,<8 x float> %v8,i64 %i8,double %f8,<8 x float> %v9,i64 %i9,double %f9,<8 x float> %v10,i64 %i10,double %f10,<8 x float> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <8 x float> %v0 to <8 x i32>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <8 x float> %v1 to <8 x i32>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <8 x float> %v2 to <8 x i32>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <8 x float> %v3 to <8 x i32>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <8 x float> %v4 to <8 x i32>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <8 x float> %v5 to <8 x i32>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <8 x float> %v6 to <8 x i32>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <8 x float> %v7 to <8 x i32>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <8 x float> %v8 to <8 x i32>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <8 x float> %v9 to <8 x i32>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <8 x float> %v10 to <8 x i32>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <8 x float> %v11 to <8 x i32>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <8 x i32> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <8 x i32> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <8 x i32> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <8 x i32> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <8 x i32> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <8 x i32> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <8 x i32> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <8 x i32> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <8 x i32> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <8 x i32> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <8 x i32> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <8 x i32> %vx11 to <8 x float>
 ret <8 x float> %result
}
define void @abi_mix_f32_32(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x float>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 384
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 480
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 32
 %v1=load <8 x float>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 392
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 488
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 64
 %v2=load <8 x float>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 400
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 496
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 96
 %v3=load <8 x float>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 408
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 504
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 128
 %v4=load <8 x float>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 416
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 512
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 160
 %v5=load <8 x float>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 424
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 520
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 192
 %v6=load <8 x float>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 432
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 528
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 224
 %v7=load <8 x float>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 440
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 536
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 256
 %v8=load <8 x float>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 448
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 544
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 288
 %v9=load <8 x float>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 456
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 552
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 320
 %v10=load <8 x float>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 464
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 560
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 352
 %v11=load <8 x float>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 472
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 568
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 32
 %result=call <8 x float> @mix_callee_f32_32(ptr %audit,<8 x float> %v0,i64 %i0,double %f0,<8 x float> %v1,i64 %i1,double %f1,<8 x float> %v2,i64 %i2,double %f2,<8 x float> %v3,i64 %i3,double %f3,<8 x float> %v4,i64 %i4,double %f4,<8 x float> %v5,i64 %i5,double %f5,<8 x float> %v6,i64 %i6,double %f6,<8 x float> %v7,i64 %i7,double %f7,<8 x float> %v8,i64 %i8,double %f8,<8 x float> %v9,i64 %i9,double %f9,<8 x float> %v10,i64 %i10,double %f10,<8 x float> %v11,i64 %i11,double %f11)
 store <8 x float> %result,ptr %out,align 1
 ret void
}
define internal {<8 x float>,<8 x float>,<8 x float>,i64,double} @aggregate_callee_f32_32(<8 x float> %a,<8 x float> %b,<8 x float> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} poison,<8 x float> %c,0
 %r1=insertvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %r0,<8 x float> %a,1
 %r2=insertvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %r1,<8 x float> %b,2
 %r3=insertvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %r3,double %f,4
 ret {<8 x float>,<8 x float>,<8 x float>,i64,double} %r4
}
define void @abi_aggregate_f32_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x float>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <8 x float>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <8 x float>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 96
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 104
 %f=load double,ptr %fp,align 1
 %result=call {<8 x float>,<8 x float>,<8 x float>,i64,double} @aggregate_callee_f32_32(<8 x float> %v0,<8 x float> %v1,<8 x float> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %result,0
 store <8 x float> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 %r1=extractvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %result,1
 store <8 x float> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 %r2=extractvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %result,2
 store <8 x float> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 96
 %ri=extractvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 104
 %rf=extractvalue {<8 x float>,<8 x float>,<8 x float>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_f32_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x float>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <8 x float>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <8 x float>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 96
 %v3=load <8 x float>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 128
 %v4=load <8 x float>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 160
 %v5=load <8 x float>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 192
 %v6=load <8 x float>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 224
 %v7=load <8 x float>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 256
 %v8=load <8 x float>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 288
 %v9=load <8 x float>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 320
 %v10=load <8 x float>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 352
 %v11=load <8 x float>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 384
 %v12=load <8 x float>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 416
 %v13=load <8 x float>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 448
 %v14=load <8 x float>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 480
 %v15=load <8 x float>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 512
 %v16=load <8 x float>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 544
 %v17=load <8 x float>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 576
 %v18=load <8 x float>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 608
 %v19=load <8 x float>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 640
 %v20=load <8 x float>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 672
 %v21=load <8 x float>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 704
 %v22=load <8 x float>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 736
 %v23=load <8 x float>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 768
 %v24=load <8 x float>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 800
 %v25=load <8 x float>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 832
 %v26=load <8 x float>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 864
 %v27=load <8 x float>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 896
 %v28=load <8 x float>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 928
 %v29=load <8 x float>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 960
 %v30=load <8 x float>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 992
 %v31=load <8 x float>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 1024
 %v32=load <8 x float>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 1056
 %v33=load <8 x float>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 1088
 %v34=load <8 x float>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 1120
 %v35=load <8 x float>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 1152
 %v36=load <8 x float>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 1184
 %v37=load <8 x float>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 1216
 %v38=load <8 x float>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 1248
 %v39=load <8 x float>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 1280)
 %o0=getelementptr i8,ptr %out,i64 0
 store <8 x float> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 store <8 x float> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 store <8 x float> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 96
 store <8 x float> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 128
 store <8 x float> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 160
 store <8 x float> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 192
 store <8 x float> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 224
 store <8 x float> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 256
 store <8 x float> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 288
 store <8 x float> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 320
 store <8 x float> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 352
 store <8 x float> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 384
 store <8 x float> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 416
 store <8 x float> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 448
 store <8 x float> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 480
 store <8 x float> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 512
 store <8 x float> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 544
 store <8 x float> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 576
 store <8 x float> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 608
 store <8 x float> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 640
 store <8 x float> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 672
 store <8 x float> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 704
 store <8 x float> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 736
 store <8 x float> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 768
 store <8 x float> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 800
 store <8 x float> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 832
 store <8 x float> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 864
 store <8 x float> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 896
 store <8 x float> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 928
 store <8 x float> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 960
 store <8 x float> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 992
 store <8 x float> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 1024
 store <8 x float> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 1056
 store <8 x float> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 1088
 store <8 x float> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 1120
 store <8 x float> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 1152
 store <8 x float> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 1184
 store <8 x float> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 1216
 store <8 x float> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 1248
 store <8 x float> %v39,ptr %o39,align 1
 ret void
}
define internal <4 x double> @mix_callee_f64_32(ptr %audit,<4 x double> %v0,i64 %i0,double %f0,<4 x double> %v1,i64 %i1,double %f1,<4 x double> %v2,i64 %i2,double %f2,<4 x double> %v3,i64 %i3,double %f3,<4 x double> %v4,i64 %i4,double %f4,<4 x double> %v5,i64 %i5,double %f5,<4 x double> %v6,i64 %i6,double %f6,<4 x double> %v7,i64 %i7,double %f7,<4 x double> %v8,i64 %i8,double %f8,<4 x double> %v9,i64 %i9,double %f9,<4 x double> %v10,i64 %i10,double %f10,<4 x double> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <4 x double> %v0 to <4 x i64>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <4 x double> %v1 to <4 x i64>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <4 x double> %v2 to <4 x i64>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <4 x double> %v3 to <4 x i64>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <4 x double> %v4 to <4 x i64>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <4 x double> %v5 to <4 x i64>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <4 x double> %v6 to <4 x i64>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <4 x double> %v7 to <4 x i64>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <4 x double> %v8 to <4 x i64>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <4 x double> %v9 to <4 x i64>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <4 x double> %v10 to <4 x i64>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <4 x double> %v11 to <4 x i64>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <4 x i64> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <4 x i64> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <4 x i64> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <4 x i64> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <4 x i64> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <4 x i64> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <4 x i64> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <4 x i64> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <4 x i64> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <4 x i64> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <4 x i64> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <4 x i64> %vx11 to <4 x double>
 ret <4 x double> %result
}
define void @abi_mix_f64_32(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x double>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 384
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 480
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 32
 %v1=load <4 x double>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 392
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 488
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 64
 %v2=load <4 x double>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 400
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 496
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 96
 %v3=load <4 x double>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 408
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 504
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 128
 %v4=load <4 x double>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 416
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 512
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 160
 %v5=load <4 x double>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 424
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 520
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 192
 %v6=load <4 x double>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 432
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 528
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 224
 %v7=load <4 x double>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 440
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 536
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 256
 %v8=load <4 x double>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 448
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 544
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 288
 %v9=load <4 x double>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 456
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 552
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 320
 %v10=load <4 x double>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 464
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 560
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 352
 %v11=load <4 x double>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 472
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 568
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 32
 %result=call <4 x double> @mix_callee_f64_32(ptr %audit,<4 x double> %v0,i64 %i0,double %f0,<4 x double> %v1,i64 %i1,double %f1,<4 x double> %v2,i64 %i2,double %f2,<4 x double> %v3,i64 %i3,double %f3,<4 x double> %v4,i64 %i4,double %f4,<4 x double> %v5,i64 %i5,double %f5,<4 x double> %v6,i64 %i6,double %f6,<4 x double> %v7,i64 %i7,double %f7,<4 x double> %v8,i64 %i8,double %f8,<4 x double> %v9,i64 %i9,double %f9,<4 x double> %v10,i64 %i10,double %f10,<4 x double> %v11,i64 %i11,double %f11)
 store <4 x double> %result,ptr %out,align 1
 ret void
}
define internal {<4 x double>,<4 x double>,<4 x double>,i64,double} @aggregate_callee_f64_32(<4 x double> %a,<4 x double> %b,<4 x double> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} poison,<4 x double> %c,0
 %r1=insertvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %r0,<4 x double> %a,1
 %r2=insertvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %r1,<4 x double> %b,2
 %r3=insertvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %r3,double %f,4
 ret {<4 x double>,<4 x double>,<4 x double>,i64,double} %r4
}
define void @abi_aggregate_f64_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x double>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <4 x double>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <4 x double>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 96
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 104
 %f=load double,ptr %fp,align 1
 %result=call {<4 x double>,<4 x double>,<4 x double>,i64,double} @aggregate_callee_f64_32(<4 x double> %v0,<4 x double> %v1,<4 x double> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %result,0
 store <4 x double> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 %r1=extractvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %result,1
 store <4 x double> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 %r2=extractvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %result,2
 store <4 x double> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 96
 %ri=extractvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 104
 %rf=extractvalue {<4 x double>,<4 x double>,<4 x double>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_f64_32(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <4 x double>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 32
 %v1=load <4 x double>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 64
 %v2=load <4 x double>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 96
 %v3=load <4 x double>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 128
 %v4=load <4 x double>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 160
 %v5=load <4 x double>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 192
 %v6=load <4 x double>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 224
 %v7=load <4 x double>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 256
 %v8=load <4 x double>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 288
 %v9=load <4 x double>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 320
 %v10=load <4 x double>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 352
 %v11=load <4 x double>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 384
 %v12=load <4 x double>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 416
 %v13=load <4 x double>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 448
 %v14=load <4 x double>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 480
 %v15=load <4 x double>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 512
 %v16=load <4 x double>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 544
 %v17=load <4 x double>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 576
 %v18=load <4 x double>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 608
 %v19=load <4 x double>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 640
 %v20=load <4 x double>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 672
 %v21=load <4 x double>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 704
 %v22=load <4 x double>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 736
 %v23=load <4 x double>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 768
 %v24=load <4 x double>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 800
 %v25=load <4 x double>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 832
 %v26=load <4 x double>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 864
 %v27=load <4 x double>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 896
 %v28=load <4 x double>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 928
 %v29=load <4 x double>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 960
 %v30=load <4 x double>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 992
 %v31=load <4 x double>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 1024
 %v32=load <4 x double>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 1056
 %v33=load <4 x double>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 1088
 %v34=load <4 x double>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 1120
 %v35=load <4 x double>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 1152
 %v36=load <4 x double>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 1184
 %v37=load <4 x double>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 1216
 %v38=load <4 x double>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 1248
 %v39=load <4 x double>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 1280)
 %o0=getelementptr i8,ptr %out,i64 0
 store <4 x double> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 32
 store <4 x double> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 64
 store <4 x double> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 96
 store <4 x double> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 128
 store <4 x double> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 160
 store <4 x double> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 192
 store <4 x double> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 224
 store <4 x double> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 256
 store <4 x double> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 288
 store <4 x double> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 320
 store <4 x double> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 352
 store <4 x double> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 384
 store <4 x double> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 416
 store <4 x double> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 448
 store <4 x double> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 480
 store <4 x double> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 512
 store <4 x double> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 544
 store <4 x double> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 576
 store <4 x double> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 608
 store <4 x double> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 640
 store <4 x double> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 672
 store <4 x double> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 704
 store <4 x double> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 736
 store <4 x double> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 768
 store <4 x double> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 800
 store <4 x double> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 832
 store <4 x double> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 864
 store <4 x double> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 896
 store <4 x double> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 928
 store <4 x double> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 960
 store <4 x double> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 992
 store <4 x double> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 1024
 store <4 x double> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 1056
 store <4 x double> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 1088
 store <4 x double> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 1120
 store <4 x double> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 1152
 store <4 x double> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 1184
 store <4 x double> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 1216
 store <4 x double> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 1248
 store <4 x double> %v39,ptr %o39,align 1
 ret void
}
define internal <64 x i8> @mix_callee_i8_64(ptr %audit,<64 x i8> %v0,i64 %i0,double %f0,<64 x i8> %v1,i64 %i1,double %f1,<64 x i8> %v2,i64 %i2,double %f2,<64 x i8> %v3,i64 %i3,double %f3,<64 x i8> %v4,i64 %i4,double %f4,<64 x i8> %v5,i64 %i5,double %f5,<64 x i8> %v6,i64 %i6,double %f6,<64 x i8> %v7,i64 %i7,double %f7,<64 x i8> %v8,i64 %i8,double %f8,<64 x i8> %v9,i64 %i9,double %f9,<64 x i8> %v10,i64 %i10,double %f10,<64 x i8> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <64 x i8> %v0 to <64 x i8>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <64 x i8> %v1 to <64 x i8>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <64 x i8> %v2 to <64 x i8>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <64 x i8> %v3 to <64 x i8>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <64 x i8> %v4 to <64 x i8>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <64 x i8> %v5 to <64 x i8>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <64 x i8> %v6 to <64 x i8>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <64 x i8> %v7 to <64 x i8>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <64 x i8> %v8 to <64 x i8>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <64 x i8> %v9 to <64 x i8>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <64 x i8> %v10 to <64 x i8>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <64 x i8> %v11 to <64 x i8>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <64 x i8> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <64 x i8> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <64 x i8> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <64 x i8> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <64 x i8> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <64 x i8> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <64 x i8> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <64 x i8> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <64 x i8> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <64 x i8> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <64 x i8> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <64 x i8> %vx11 to <64 x i8>
 ret <64 x i8> %result
}
define void @abi_mix_i8_64(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <64 x i8>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 768
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 864
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 64
 %v1=load <64 x i8>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 776
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 872
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 128
 %v2=load <64 x i8>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 784
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 880
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 192
 %v3=load <64 x i8>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 792
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 888
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 256
 %v4=load <64 x i8>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 800
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 896
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 320
 %v5=load <64 x i8>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 808
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 904
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 384
 %v6=load <64 x i8>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 816
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 912
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 448
 %v7=load <64 x i8>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 824
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 920
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 512
 %v8=load <64 x i8>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 832
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 928
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 576
 %v9=load <64 x i8>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 840
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 936
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 640
 %v10=load <64 x i8>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 848
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 944
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 704
 %v11=load <64 x i8>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 856
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 952
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 64
 %result=call <64 x i8> @mix_callee_i8_64(ptr %audit,<64 x i8> %v0,i64 %i0,double %f0,<64 x i8> %v1,i64 %i1,double %f1,<64 x i8> %v2,i64 %i2,double %f2,<64 x i8> %v3,i64 %i3,double %f3,<64 x i8> %v4,i64 %i4,double %f4,<64 x i8> %v5,i64 %i5,double %f5,<64 x i8> %v6,i64 %i6,double %f6,<64 x i8> %v7,i64 %i7,double %f7,<64 x i8> %v8,i64 %i8,double %f8,<64 x i8> %v9,i64 %i9,double %f9,<64 x i8> %v10,i64 %i10,double %f10,<64 x i8> %v11,i64 %i11,double %f11)
 store <64 x i8> %result,ptr %out,align 1
 ret void
}
define internal {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} @aggregate_callee_i8_64(<64 x i8> %a,<64 x i8> %b,<64 x i8> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} poison,<64 x i8> %c,0
 %r1=insertvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %r0,<64 x i8> %a,1
 %r2=insertvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %r1,<64 x i8> %b,2
 %r3=insertvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %r3,double %f,4
 ret {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %r4
}
define void @abi_aggregate_i8_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <64 x i8>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <64 x i8>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <64 x i8>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 192
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 200
 %f=load double,ptr %fp,align 1
 %result=call {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} @aggregate_callee_i8_64(<64 x i8> %v0,<64 x i8> %v1,<64 x i8> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %result,0
 store <64 x i8> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 %r1=extractvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %result,1
 store <64 x i8> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 %r2=extractvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %result,2
 store <64 x i8> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 192
 %ri=extractvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 200
 %rf=extractvalue {<64 x i8>,<64 x i8>,<64 x i8>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i8_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <64 x i8>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <64 x i8>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <64 x i8>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 192
 %v3=load <64 x i8>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 256
 %v4=load <64 x i8>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 320
 %v5=load <64 x i8>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 384
 %v6=load <64 x i8>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 448
 %v7=load <64 x i8>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 512
 %v8=load <64 x i8>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 576
 %v9=load <64 x i8>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 640
 %v10=load <64 x i8>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 704
 %v11=load <64 x i8>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 768
 %v12=load <64 x i8>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 832
 %v13=load <64 x i8>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 896
 %v14=load <64 x i8>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 960
 %v15=load <64 x i8>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 1024
 %v16=load <64 x i8>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 1088
 %v17=load <64 x i8>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 1152
 %v18=load <64 x i8>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 1216
 %v19=load <64 x i8>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 1280
 %v20=load <64 x i8>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 1344
 %v21=load <64 x i8>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 1408
 %v22=load <64 x i8>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 1472
 %v23=load <64 x i8>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 1536
 %v24=load <64 x i8>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 1600
 %v25=load <64 x i8>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 1664
 %v26=load <64 x i8>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 1728
 %v27=load <64 x i8>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 1792
 %v28=load <64 x i8>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 1856
 %v29=load <64 x i8>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 1920
 %v30=load <64 x i8>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 1984
 %v31=load <64 x i8>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 2048
 %v32=load <64 x i8>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 2112
 %v33=load <64 x i8>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 2176
 %v34=load <64 x i8>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 2240
 %v35=load <64 x i8>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 2304
 %v36=load <64 x i8>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 2368
 %v37=load <64 x i8>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 2432
 %v38=load <64 x i8>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 2496
 %v39=load <64 x i8>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 2560)
 %o0=getelementptr i8,ptr %out,i64 0
 store <64 x i8> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 store <64 x i8> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 store <64 x i8> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 192
 store <64 x i8> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 256
 store <64 x i8> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 320
 store <64 x i8> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 384
 store <64 x i8> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 448
 store <64 x i8> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 512
 store <64 x i8> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 576
 store <64 x i8> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 640
 store <64 x i8> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 704
 store <64 x i8> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 768
 store <64 x i8> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 832
 store <64 x i8> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 896
 store <64 x i8> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 960
 store <64 x i8> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 1024
 store <64 x i8> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 1088
 store <64 x i8> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 1152
 store <64 x i8> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 1216
 store <64 x i8> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 1280
 store <64 x i8> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 1344
 store <64 x i8> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 1408
 store <64 x i8> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 1472
 store <64 x i8> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 1536
 store <64 x i8> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 1600
 store <64 x i8> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 1664
 store <64 x i8> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 1728
 store <64 x i8> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 1792
 store <64 x i8> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 1856
 store <64 x i8> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 1920
 store <64 x i8> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 1984
 store <64 x i8> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 2048
 store <64 x i8> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 2112
 store <64 x i8> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 2176
 store <64 x i8> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 2240
 store <64 x i8> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 2304
 store <64 x i8> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 2368
 store <64 x i8> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 2432
 store <64 x i8> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 2496
 store <64 x i8> %v39,ptr %o39,align 1
 ret void
}
define internal <32 x i16> @mix_callee_i16_64(ptr %audit,<32 x i16> %v0,i64 %i0,double %f0,<32 x i16> %v1,i64 %i1,double %f1,<32 x i16> %v2,i64 %i2,double %f2,<32 x i16> %v3,i64 %i3,double %f3,<32 x i16> %v4,i64 %i4,double %f4,<32 x i16> %v5,i64 %i5,double %f5,<32 x i16> %v6,i64 %i6,double %f6,<32 x i16> %v7,i64 %i7,double %f7,<32 x i16> %v8,i64 %i8,double %f8,<32 x i16> %v9,i64 %i9,double %f9,<32 x i16> %v10,i64 %i10,double %f10,<32 x i16> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <32 x i16> %v0 to <32 x i16>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <32 x i16> %v1 to <32 x i16>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <32 x i16> %v2 to <32 x i16>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <32 x i16> %v3 to <32 x i16>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <32 x i16> %v4 to <32 x i16>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <32 x i16> %v5 to <32 x i16>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <32 x i16> %v6 to <32 x i16>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <32 x i16> %v7 to <32 x i16>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <32 x i16> %v8 to <32 x i16>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <32 x i16> %v9 to <32 x i16>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <32 x i16> %v10 to <32 x i16>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <32 x i16> %v11 to <32 x i16>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <32 x i16> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <32 x i16> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <32 x i16> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <32 x i16> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <32 x i16> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <32 x i16> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <32 x i16> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <32 x i16> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <32 x i16> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <32 x i16> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <32 x i16> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <32 x i16> %vx11 to <32 x i16>
 ret <32 x i16> %result
}
define void @abi_mix_i16_64(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <32 x i16>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 768
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 864
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 64
 %v1=load <32 x i16>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 776
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 872
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 128
 %v2=load <32 x i16>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 784
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 880
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 192
 %v3=load <32 x i16>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 792
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 888
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 256
 %v4=load <32 x i16>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 800
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 896
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 320
 %v5=load <32 x i16>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 808
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 904
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 384
 %v6=load <32 x i16>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 816
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 912
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 448
 %v7=load <32 x i16>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 824
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 920
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 512
 %v8=load <32 x i16>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 832
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 928
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 576
 %v9=load <32 x i16>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 840
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 936
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 640
 %v10=load <32 x i16>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 848
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 944
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 704
 %v11=load <32 x i16>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 856
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 952
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 64
 %result=call <32 x i16> @mix_callee_i16_64(ptr %audit,<32 x i16> %v0,i64 %i0,double %f0,<32 x i16> %v1,i64 %i1,double %f1,<32 x i16> %v2,i64 %i2,double %f2,<32 x i16> %v3,i64 %i3,double %f3,<32 x i16> %v4,i64 %i4,double %f4,<32 x i16> %v5,i64 %i5,double %f5,<32 x i16> %v6,i64 %i6,double %f6,<32 x i16> %v7,i64 %i7,double %f7,<32 x i16> %v8,i64 %i8,double %f8,<32 x i16> %v9,i64 %i9,double %f9,<32 x i16> %v10,i64 %i10,double %f10,<32 x i16> %v11,i64 %i11,double %f11)
 store <32 x i16> %result,ptr %out,align 1
 ret void
}
define internal {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} @aggregate_callee_i16_64(<32 x i16> %a,<32 x i16> %b,<32 x i16> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} poison,<32 x i16> %c,0
 %r1=insertvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %r0,<32 x i16> %a,1
 %r2=insertvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %r1,<32 x i16> %b,2
 %r3=insertvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %r3,double %f,4
 ret {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %r4
}
define void @abi_aggregate_i16_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <32 x i16>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <32 x i16>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <32 x i16>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 192
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 200
 %f=load double,ptr %fp,align 1
 %result=call {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} @aggregate_callee_i16_64(<32 x i16> %v0,<32 x i16> %v1,<32 x i16> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %result,0
 store <32 x i16> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 %r1=extractvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %result,1
 store <32 x i16> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 %r2=extractvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %result,2
 store <32 x i16> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 192
 %ri=extractvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 200
 %rf=extractvalue {<32 x i16>,<32 x i16>,<32 x i16>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i16_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <32 x i16>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <32 x i16>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <32 x i16>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 192
 %v3=load <32 x i16>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 256
 %v4=load <32 x i16>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 320
 %v5=load <32 x i16>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 384
 %v6=load <32 x i16>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 448
 %v7=load <32 x i16>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 512
 %v8=load <32 x i16>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 576
 %v9=load <32 x i16>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 640
 %v10=load <32 x i16>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 704
 %v11=load <32 x i16>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 768
 %v12=load <32 x i16>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 832
 %v13=load <32 x i16>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 896
 %v14=load <32 x i16>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 960
 %v15=load <32 x i16>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 1024
 %v16=load <32 x i16>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 1088
 %v17=load <32 x i16>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 1152
 %v18=load <32 x i16>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 1216
 %v19=load <32 x i16>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 1280
 %v20=load <32 x i16>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 1344
 %v21=load <32 x i16>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 1408
 %v22=load <32 x i16>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 1472
 %v23=load <32 x i16>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 1536
 %v24=load <32 x i16>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 1600
 %v25=load <32 x i16>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 1664
 %v26=load <32 x i16>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 1728
 %v27=load <32 x i16>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 1792
 %v28=load <32 x i16>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 1856
 %v29=load <32 x i16>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 1920
 %v30=load <32 x i16>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 1984
 %v31=load <32 x i16>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 2048
 %v32=load <32 x i16>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 2112
 %v33=load <32 x i16>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 2176
 %v34=load <32 x i16>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 2240
 %v35=load <32 x i16>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 2304
 %v36=load <32 x i16>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 2368
 %v37=load <32 x i16>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 2432
 %v38=load <32 x i16>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 2496
 %v39=load <32 x i16>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 2560)
 %o0=getelementptr i8,ptr %out,i64 0
 store <32 x i16> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 store <32 x i16> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 store <32 x i16> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 192
 store <32 x i16> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 256
 store <32 x i16> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 320
 store <32 x i16> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 384
 store <32 x i16> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 448
 store <32 x i16> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 512
 store <32 x i16> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 576
 store <32 x i16> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 640
 store <32 x i16> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 704
 store <32 x i16> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 768
 store <32 x i16> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 832
 store <32 x i16> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 896
 store <32 x i16> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 960
 store <32 x i16> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 1024
 store <32 x i16> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 1088
 store <32 x i16> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 1152
 store <32 x i16> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 1216
 store <32 x i16> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 1280
 store <32 x i16> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 1344
 store <32 x i16> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 1408
 store <32 x i16> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 1472
 store <32 x i16> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 1536
 store <32 x i16> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 1600
 store <32 x i16> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 1664
 store <32 x i16> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 1728
 store <32 x i16> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 1792
 store <32 x i16> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 1856
 store <32 x i16> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 1920
 store <32 x i16> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 1984
 store <32 x i16> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 2048
 store <32 x i16> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 2112
 store <32 x i16> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 2176
 store <32 x i16> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 2240
 store <32 x i16> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 2304
 store <32 x i16> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 2368
 store <32 x i16> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 2432
 store <32 x i16> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 2496
 store <32 x i16> %v39,ptr %o39,align 1
 ret void
}
define internal <16 x i32> @mix_callee_i32_64(ptr %audit,<16 x i32> %v0,i64 %i0,double %f0,<16 x i32> %v1,i64 %i1,double %f1,<16 x i32> %v2,i64 %i2,double %f2,<16 x i32> %v3,i64 %i3,double %f3,<16 x i32> %v4,i64 %i4,double %f4,<16 x i32> %v5,i64 %i5,double %f5,<16 x i32> %v6,i64 %i6,double %f6,<16 x i32> %v7,i64 %i7,double %f7,<16 x i32> %v8,i64 %i8,double %f8,<16 x i32> %v9,i64 %i9,double %f9,<16 x i32> %v10,i64 %i10,double %f10,<16 x i32> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <16 x i32> %v0 to <16 x i32>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <16 x i32> %v1 to <16 x i32>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <16 x i32> %v2 to <16 x i32>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <16 x i32> %v3 to <16 x i32>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <16 x i32> %v4 to <16 x i32>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <16 x i32> %v5 to <16 x i32>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <16 x i32> %v6 to <16 x i32>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <16 x i32> %v7 to <16 x i32>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <16 x i32> %v8 to <16 x i32>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <16 x i32> %v9 to <16 x i32>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <16 x i32> %v10 to <16 x i32>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <16 x i32> %v11 to <16 x i32>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <16 x i32> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <16 x i32> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <16 x i32> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <16 x i32> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <16 x i32> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <16 x i32> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <16 x i32> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <16 x i32> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <16 x i32> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <16 x i32> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <16 x i32> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <16 x i32> %vx11 to <16 x i32>
 ret <16 x i32> %result
}
define void @abi_mix_i32_64(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i32>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 768
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 864
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 64
 %v1=load <16 x i32>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 776
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 872
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 128
 %v2=load <16 x i32>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 784
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 880
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 192
 %v3=load <16 x i32>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 792
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 888
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 256
 %v4=load <16 x i32>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 800
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 896
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 320
 %v5=load <16 x i32>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 808
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 904
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 384
 %v6=load <16 x i32>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 816
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 912
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 448
 %v7=load <16 x i32>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 824
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 920
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 512
 %v8=load <16 x i32>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 832
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 928
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 576
 %v9=load <16 x i32>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 840
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 936
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 640
 %v10=load <16 x i32>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 848
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 944
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 704
 %v11=load <16 x i32>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 856
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 952
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 64
 %result=call <16 x i32> @mix_callee_i32_64(ptr %audit,<16 x i32> %v0,i64 %i0,double %f0,<16 x i32> %v1,i64 %i1,double %f1,<16 x i32> %v2,i64 %i2,double %f2,<16 x i32> %v3,i64 %i3,double %f3,<16 x i32> %v4,i64 %i4,double %f4,<16 x i32> %v5,i64 %i5,double %f5,<16 x i32> %v6,i64 %i6,double %f6,<16 x i32> %v7,i64 %i7,double %f7,<16 x i32> %v8,i64 %i8,double %f8,<16 x i32> %v9,i64 %i9,double %f9,<16 x i32> %v10,i64 %i10,double %f10,<16 x i32> %v11,i64 %i11,double %f11)
 store <16 x i32> %result,ptr %out,align 1
 ret void
}
define internal {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} @aggregate_callee_i32_64(<16 x i32> %a,<16 x i32> %b,<16 x i32> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} poison,<16 x i32> %c,0
 %r1=insertvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %r0,<16 x i32> %a,1
 %r2=insertvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %r1,<16 x i32> %b,2
 %r3=insertvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %r3,double %f,4
 ret {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %r4
}
define void @abi_aggregate_i32_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i32>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <16 x i32>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <16 x i32>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 192
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 200
 %f=load double,ptr %fp,align 1
 %result=call {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} @aggregate_callee_i32_64(<16 x i32> %v0,<16 x i32> %v1,<16 x i32> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %result,0
 store <16 x i32> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 %r1=extractvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %result,1
 store <16 x i32> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 %r2=extractvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %result,2
 store <16 x i32> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 192
 %ri=extractvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 200
 %rf=extractvalue {<16 x i32>,<16 x i32>,<16 x i32>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i32_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x i32>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <16 x i32>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <16 x i32>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 192
 %v3=load <16 x i32>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 256
 %v4=load <16 x i32>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 320
 %v5=load <16 x i32>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 384
 %v6=load <16 x i32>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 448
 %v7=load <16 x i32>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 512
 %v8=load <16 x i32>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 576
 %v9=load <16 x i32>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 640
 %v10=load <16 x i32>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 704
 %v11=load <16 x i32>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 768
 %v12=load <16 x i32>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 832
 %v13=load <16 x i32>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 896
 %v14=load <16 x i32>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 960
 %v15=load <16 x i32>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 1024
 %v16=load <16 x i32>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 1088
 %v17=load <16 x i32>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 1152
 %v18=load <16 x i32>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 1216
 %v19=load <16 x i32>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 1280
 %v20=load <16 x i32>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 1344
 %v21=load <16 x i32>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 1408
 %v22=load <16 x i32>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 1472
 %v23=load <16 x i32>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 1536
 %v24=load <16 x i32>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 1600
 %v25=load <16 x i32>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 1664
 %v26=load <16 x i32>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 1728
 %v27=load <16 x i32>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 1792
 %v28=load <16 x i32>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 1856
 %v29=load <16 x i32>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 1920
 %v30=load <16 x i32>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 1984
 %v31=load <16 x i32>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 2048
 %v32=load <16 x i32>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 2112
 %v33=load <16 x i32>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 2176
 %v34=load <16 x i32>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 2240
 %v35=load <16 x i32>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 2304
 %v36=load <16 x i32>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 2368
 %v37=load <16 x i32>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 2432
 %v38=load <16 x i32>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 2496
 %v39=load <16 x i32>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 2560)
 %o0=getelementptr i8,ptr %out,i64 0
 store <16 x i32> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 store <16 x i32> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 store <16 x i32> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 192
 store <16 x i32> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 256
 store <16 x i32> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 320
 store <16 x i32> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 384
 store <16 x i32> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 448
 store <16 x i32> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 512
 store <16 x i32> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 576
 store <16 x i32> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 640
 store <16 x i32> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 704
 store <16 x i32> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 768
 store <16 x i32> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 832
 store <16 x i32> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 896
 store <16 x i32> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 960
 store <16 x i32> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 1024
 store <16 x i32> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 1088
 store <16 x i32> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 1152
 store <16 x i32> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 1216
 store <16 x i32> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 1280
 store <16 x i32> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 1344
 store <16 x i32> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 1408
 store <16 x i32> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 1472
 store <16 x i32> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 1536
 store <16 x i32> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 1600
 store <16 x i32> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 1664
 store <16 x i32> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 1728
 store <16 x i32> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 1792
 store <16 x i32> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 1856
 store <16 x i32> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 1920
 store <16 x i32> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 1984
 store <16 x i32> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 2048
 store <16 x i32> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 2112
 store <16 x i32> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 2176
 store <16 x i32> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 2240
 store <16 x i32> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 2304
 store <16 x i32> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 2368
 store <16 x i32> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 2432
 store <16 x i32> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 2496
 store <16 x i32> %v39,ptr %o39,align 1
 ret void
}
define internal <8 x i64> @mix_callee_i64_64(ptr %audit,<8 x i64> %v0,i64 %i0,double %f0,<8 x i64> %v1,i64 %i1,double %f1,<8 x i64> %v2,i64 %i2,double %f2,<8 x i64> %v3,i64 %i3,double %f3,<8 x i64> %v4,i64 %i4,double %f4,<8 x i64> %v5,i64 %i5,double %f5,<8 x i64> %v6,i64 %i6,double %f6,<8 x i64> %v7,i64 %i7,double %f7,<8 x i64> %v8,i64 %i8,double %f8,<8 x i64> %v9,i64 %i9,double %f9,<8 x i64> %v10,i64 %i10,double %f10,<8 x i64> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <8 x i64> %v0 to <8 x i64>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <8 x i64> %v1 to <8 x i64>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <8 x i64> %v2 to <8 x i64>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <8 x i64> %v3 to <8 x i64>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <8 x i64> %v4 to <8 x i64>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <8 x i64> %v5 to <8 x i64>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <8 x i64> %v6 to <8 x i64>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <8 x i64> %v7 to <8 x i64>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <8 x i64> %v8 to <8 x i64>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <8 x i64> %v9 to <8 x i64>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <8 x i64> %v10 to <8 x i64>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <8 x i64> %v11 to <8 x i64>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <8 x i64> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <8 x i64> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <8 x i64> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <8 x i64> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <8 x i64> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <8 x i64> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <8 x i64> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <8 x i64> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <8 x i64> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <8 x i64> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <8 x i64> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <8 x i64> %vx11 to <8 x i64>
 ret <8 x i64> %result
}
define void @abi_mix_i64_64(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i64>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 768
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 864
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 64
 %v1=load <8 x i64>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 776
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 872
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 128
 %v2=load <8 x i64>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 784
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 880
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 192
 %v3=load <8 x i64>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 792
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 888
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 256
 %v4=load <8 x i64>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 800
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 896
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 320
 %v5=load <8 x i64>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 808
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 904
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 384
 %v6=load <8 x i64>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 816
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 912
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 448
 %v7=load <8 x i64>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 824
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 920
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 512
 %v8=load <8 x i64>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 832
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 928
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 576
 %v9=load <8 x i64>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 840
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 936
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 640
 %v10=load <8 x i64>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 848
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 944
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 704
 %v11=load <8 x i64>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 856
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 952
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 64
 %result=call <8 x i64> @mix_callee_i64_64(ptr %audit,<8 x i64> %v0,i64 %i0,double %f0,<8 x i64> %v1,i64 %i1,double %f1,<8 x i64> %v2,i64 %i2,double %f2,<8 x i64> %v3,i64 %i3,double %f3,<8 x i64> %v4,i64 %i4,double %f4,<8 x i64> %v5,i64 %i5,double %f5,<8 x i64> %v6,i64 %i6,double %f6,<8 x i64> %v7,i64 %i7,double %f7,<8 x i64> %v8,i64 %i8,double %f8,<8 x i64> %v9,i64 %i9,double %f9,<8 x i64> %v10,i64 %i10,double %f10,<8 x i64> %v11,i64 %i11,double %f11)
 store <8 x i64> %result,ptr %out,align 1
 ret void
}
define internal {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} @aggregate_callee_i64_64(<8 x i64> %a,<8 x i64> %b,<8 x i64> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} poison,<8 x i64> %c,0
 %r1=insertvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %r0,<8 x i64> %a,1
 %r2=insertvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %r1,<8 x i64> %b,2
 %r3=insertvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %r3,double %f,4
 ret {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %r4
}
define void @abi_aggregate_i64_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i64>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <8 x i64>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <8 x i64>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 192
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 200
 %f=load double,ptr %fp,align 1
 %result=call {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} @aggregate_callee_i64_64(<8 x i64> %v0,<8 x i64> %v1,<8 x i64> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %result,0
 store <8 x i64> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 %r1=extractvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %result,1
 store <8 x i64> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 %r2=extractvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %result,2
 store <8 x i64> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 192
 %ri=extractvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 200
 %rf=extractvalue {<8 x i64>,<8 x i64>,<8 x i64>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_i64_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x i64>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <8 x i64>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <8 x i64>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 192
 %v3=load <8 x i64>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 256
 %v4=load <8 x i64>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 320
 %v5=load <8 x i64>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 384
 %v6=load <8 x i64>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 448
 %v7=load <8 x i64>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 512
 %v8=load <8 x i64>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 576
 %v9=load <8 x i64>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 640
 %v10=load <8 x i64>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 704
 %v11=load <8 x i64>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 768
 %v12=load <8 x i64>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 832
 %v13=load <8 x i64>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 896
 %v14=load <8 x i64>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 960
 %v15=load <8 x i64>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 1024
 %v16=load <8 x i64>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 1088
 %v17=load <8 x i64>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 1152
 %v18=load <8 x i64>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 1216
 %v19=load <8 x i64>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 1280
 %v20=load <8 x i64>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 1344
 %v21=load <8 x i64>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 1408
 %v22=load <8 x i64>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 1472
 %v23=load <8 x i64>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 1536
 %v24=load <8 x i64>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 1600
 %v25=load <8 x i64>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 1664
 %v26=load <8 x i64>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 1728
 %v27=load <8 x i64>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 1792
 %v28=load <8 x i64>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 1856
 %v29=load <8 x i64>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 1920
 %v30=load <8 x i64>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 1984
 %v31=load <8 x i64>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 2048
 %v32=load <8 x i64>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 2112
 %v33=load <8 x i64>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 2176
 %v34=load <8 x i64>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 2240
 %v35=load <8 x i64>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 2304
 %v36=load <8 x i64>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 2368
 %v37=load <8 x i64>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 2432
 %v38=load <8 x i64>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 2496
 %v39=load <8 x i64>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 2560)
 %o0=getelementptr i8,ptr %out,i64 0
 store <8 x i64> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 store <8 x i64> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 store <8 x i64> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 192
 store <8 x i64> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 256
 store <8 x i64> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 320
 store <8 x i64> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 384
 store <8 x i64> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 448
 store <8 x i64> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 512
 store <8 x i64> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 576
 store <8 x i64> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 640
 store <8 x i64> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 704
 store <8 x i64> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 768
 store <8 x i64> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 832
 store <8 x i64> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 896
 store <8 x i64> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 960
 store <8 x i64> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 1024
 store <8 x i64> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 1088
 store <8 x i64> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 1152
 store <8 x i64> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 1216
 store <8 x i64> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 1280
 store <8 x i64> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 1344
 store <8 x i64> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 1408
 store <8 x i64> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 1472
 store <8 x i64> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 1536
 store <8 x i64> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 1600
 store <8 x i64> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 1664
 store <8 x i64> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 1728
 store <8 x i64> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 1792
 store <8 x i64> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 1856
 store <8 x i64> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 1920
 store <8 x i64> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 1984
 store <8 x i64> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 2048
 store <8 x i64> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 2112
 store <8 x i64> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 2176
 store <8 x i64> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 2240
 store <8 x i64> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 2304
 store <8 x i64> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 2368
 store <8 x i64> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 2432
 store <8 x i64> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 2496
 store <8 x i64> %v39,ptr %o39,align 1
 ret void
}
define internal <16 x float> @mix_callee_f32_64(ptr %audit,<16 x float> %v0,i64 %i0,double %f0,<16 x float> %v1,i64 %i1,double %f1,<16 x float> %v2,i64 %i2,double %f2,<16 x float> %v3,i64 %i3,double %f3,<16 x float> %v4,i64 %i4,double %f4,<16 x float> %v5,i64 %i5,double %f5,<16 x float> %v6,i64 %i6,double %f6,<16 x float> %v7,i64 %i7,double %f7,<16 x float> %v8,i64 %i8,double %f8,<16 x float> %v9,i64 %i9,double %f9,<16 x float> %v10,i64 %i10,double %f10,<16 x float> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <16 x float> %v0 to <16 x i32>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <16 x float> %v1 to <16 x i32>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <16 x float> %v2 to <16 x i32>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <16 x float> %v3 to <16 x i32>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <16 x float> %v4 to <16 x i32>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <16 x float> %v5 to <16 x i32>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <16 x float> %v6 to <16 x i32>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <16 x float> %v7 to <16 x i32>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <16 x float> %v8 to <16 x i32>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <16 x float> %v9 to <16 x i32>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <16 x float> %v10 to <16 x i32>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <16 x float> %v11 to <16 x i32>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <16 x i32> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <16 x i32> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <16 x i32> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <16 x i32> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <16 x i32> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <16 x i32> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <16 x i32> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <16 x i32> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <16 x i32> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <16 x i32> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <16 x i32> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <16 x i32> %vx11 to <16 x float>
 ret <16 x float> %result
}
define void @abi_mix_f32_64(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x float>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 768
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 864
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 64
 %v1=load <16 x float>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 776
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 872
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 128
 %v2=load <16 x float>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 784
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 880
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 192
 %v3=load <16 x float>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 792
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 888
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 256
 %v4=load <16 x float>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 800
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 896
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 320
 %v5=load <16 x float>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 808
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 904
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 384
 %v6=load <16 x float>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 816
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 912
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 448
 %v7=load <16 x float>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 824
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 920
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 512
 %v8=load <16 x float>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 832
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 928
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 576
 %v9=load <16 x float>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 840
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 936
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 640
 %v10=load <16 x float>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 848
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 944
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 704
 %v11=load <16 x float>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 856
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 952
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 64
 %result=call <16 x float> @mix_callee_f32_64(ptr %audit,<16 x float> %v0,i64 %i0,double %f0,<16 x float> %v1,i64 %i1,double %f1,<16 x float> %v2,i64 %i2,double %f2,<16 x float> %v3,i64 %i3,double %f3,<16 x float> %v4,i64 %i4,double %f4,<16 x float> %v5,i64 %i5,double %f5,<16 x float> %v6,i64 %i6,double %f6,<16 x float> %v7,i64 %i7,double %f7,<16 x float> %v8,i64 %i8,double %f8,<16 x float> %v9,i64 %i9,double %f9,<16 x float> %v10,i64 %i10,double %f10,<16 x float> %v11,i64 %i11,double %f11)
 store <16 x float> %result,ptr %out,align 1
 ret void
}
define internal {<16 x float>,<16 x float>,<16 x float>,i64,double} @aggregate_callee_f32_64(<16 x float> %a,<16 x float> %b,<16 x float> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} poison,<16 x float> %c,0
 %r1=insertvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %r0,<16 x float> %a,1
 %r2=insertvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %r1,<16 x float> %b,2
 %r3=insertvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %r3,double %f,4
 ret {<16 x float>,<16 x float>,<16 x float>,i64,double} %r4
}
define void @abi_aggregate_f32_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x float>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <16 x float>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <16 x float>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 192
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 200
 %f=load double,ptr %fp,align 1
 %result=call {<16 x float>,<16 x float>,<16 x float>,i64,double} @aggregate_callee_f32_64(<16 x float> %v0,<16 x float> %v1,<16 x float> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %result,0
 store <16 x float> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 %r1=extractvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %result,1
 store <16 x float> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 %r2=extractvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %result,2
 store <16 x float> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 192
 %ri=extractvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 200
 %rf=extractvalue {<16 x float>,<16 x float>,<16 x float>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_f32_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <16 x float>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <16 x float>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <16 x float>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 192
 %v3=load <16 x float>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 256
 %v4=load <16 x float>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 320
 %v5=load <16 x float>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 384
 %v6=load <16 x float>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 448
 %v7=load <16 x float>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 512
 %v8=load <16 x float>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 576
 %v9=load <16 x float>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 640
 %v10=load <16 x float>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 704
 %v11=load <16 x float>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 768
 %v12=load <16 x float>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 832
 %v13=load <16 x float>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 896
 %v14=load <16 x float>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 960
 %v15=load <16 x float>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 1024
 %v16=load <16 x float>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 1088
 %v17=load <16 x float>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 1152
 %v18=load <16 x float>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 1216
 %v19=load <16 x float>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 1280
 %v20=load <16 x float>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 1344
 %v21=load <16 x float>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 1408
 %v22=load <16 x float>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 1472
 %v23=load <16 x float>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 1536
 %v24=load <16 x float>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 1600
 %v25=load <16 x float>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 1664
 %v26=load <16 x float>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 1728
 %v27=load <16 x float>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 1792
 %v28=load <16 x float>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 1856
 %v29=load <16 x float>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 1920
 %v30=load <16 x float>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 1984
 %v31=load <16 x float>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 2048
 %v32=load <16 x float>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 2112
 %v33=load <16 x float>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 2176
 %v34=load <16 x float>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 2240
 %v35=load <16 x float>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 2304
 %v36=load <16 x float>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 2368
 %v37=load <16 x float>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 2432
 %v38=load <16 x float>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 2496
 %v39=load <16 x float>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 2560)
 %o0=getelementptr i8,ptr %out,i64 0
 store <16 x float> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 store <16 x float> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 store <16 x float> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 192
 store <16 x float> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 256
 store <16 x float> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 320
 store <16 x float> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 384
 store <16 x float> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 448
 store <16 x float> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 512
 store <16 x float> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 576
 store <16 x float> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 640
 store <16 x float> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 704
 store <16 x float> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 768
 store <16 x float> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 832
 store <16 x float> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 896
 store <16 x float> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 960
 store <16 x float> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 1024
 store <16 x float> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 1088
 store <16 x float> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 1152
 store <16 x float> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 1216
 store <16 x float> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 1280
 store <16 x float> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 1344
 store <16 x float> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 1408
 store <16 x float> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 1472
 store <16 x float> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 1536
 store <16 x float> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 1600
 store <16 x float> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 1664
 store <16 x float> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 1728
 store <16 x float> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 1792
 store <16 x float> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 1856
 store <16 x float> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 1920
 store <16 x float> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 1984
 store <16 x float> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 2048
 store <16 x float> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 2112
 store <16 x float> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 2176
 store <16 x float> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 2240
 store <16 x float> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 2304
 store <16 x float> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 2368
 store <16 x float> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 2432
 store <16 x float> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 2496
 store <16 x float> %v39,ptr %o39,align 1
 ret void
}
define internal <8 x double> @mix_callee_f64_64(ptr %audit,<8 x double> %v0,i64 %i0,double %f0,<8 x double> %v1,i64 %i1,double %f1,<8 x double> %v2,i64 %i2,double %f2,<8 x double> %v3,i64 %i3,double %f3,<8 x double> %v4,i64 %i4,double %f4,<8 x double> %v5,i64 %i5,double %f5,<8 x double> %v6,i64 %i6,double %f6,<8 x double> %v7,i64 %i7,double %f7,<8 x double> %v8,i64 %i8,double %f8,<8 x double> %v9,i64 %i9,double %f9,<8 x double> %v10,i64 %i10,double %f10,<8 x double> %v11,i64 %i11,double %f11) #0 {
 %b0=bitcast <8 x double> %v0 to <8 x i64>
 %fb0=bitcast double %f0 to i64
 %b1=bitcast <8 x double> %v1 to <8 x i64>
 %fb1=bitcast double %f1 to i64
 %b2=bitcast <8 x double> %v2 to <8 x i64>
 %fb2=bitcast double %f2 to i64
 %b3=bitcast <8 x double> %v3 to <8 x i64>
 %fb3=bitcast double %f3 to i64
 %b4=bitcast <8 x double> %v4 to <8 x i64>
 %fb4=bitcast double %f4 to i64
 %b5=bitcast <8 x double> %v5 to <8 x i64>
 %fb5=bitcast double %f5 to i64
 %b6=bitcast <8 x double> %v6 to <8 x i64>
 %fb6=bitcast double %f6 to i64
 %b7=bitcast <8 x double> %v7 to <8 x i64>
 %fb7=bitcast double %f7 to i64
 %b8=bitcast <8 x double> %v8 to <8 x i64>
 %fb8=bitcast double %f8 to i64
 %b9=bitcast <8 x double> %v9 to <8 x i64>
 %fb9=bitcast double %f9 to i64
 %b10=bitcast <8 x double> %v10 to <8 x i64>
 %fb10=bitcast double %f10 to i64
 %b11=bitcast <8 x double> %v11 to <8 x i64>
 %fb11=bitcast double %f11 to i64
 %vx1=xor <8 x i64> %b0,%b1
 %is1=add i64 %i0,%i1
 %fx1=xor i64 %fb0,%fb1
 %vx2=xor <8 x i64> %vx1,%b2
 %is2=add i64 %is1,%i2
 %fx2=xor i64 %fx1,%fb2
 %vx3=xor <8 x i64> %vx2,%b3
 %is3=add i64 %is2,%i3
 %fx3=xor i64 %fx2,%fb3
 %vx4=xor <8 x i64> %vx3,%b4
 %is4=add i64 %is3,%i4
 %fx4=xor i64 %fx3,%fb4
 %vx5=xor <8 x i64> %vx4,%b5
 %is5=add i64 %is4,%i5
 %fx5=xor i64 %fx4,%fb5
 %vx6=xor <8 x i64> %vx5,%b6
 %is6=add i64 %is5,%i6
 %fx6=xor i64 %fx5,%fb6
 %vx7=xor <8 x i64> %vx6,%b7
 %is7=add i64 %is6,%i7
 %fx7=xor i64 %fx6,%fb7
 %vx8=xor <8 x i64> %vx7,%b8
 %is8=add i64 %is7,%i8
 %fx8=xor i64 %fx7,%fb8
 %vx9=xor <8 x i64> %vx8,%b9
 %is9=add i64 %is8,%i9
 %fx9=xor i64 %fx8,%fb9
 %vx10=xor <8 x i64> %vx9,%b10
 %is10=add i64 %is9,%i10
 %fx10=xor i64 %fx9,%fb10
 %vx11=xor <8 x i64> %vx10,%b11
 %is11=add i64 %is10,%i11
 %fx11=xor i64 %fx10,%fb11
 store i64 %is11,ptr %audit,align 1
 %ap=getelementptr i8,ptr %audit,i64 8
 store i64 %fx11,ptr %ap,align 1
 %result=bitcast <8 x i64> %vx11 to <8 x double>
 ret <8 x double> %result
}
define void @abi_mix_f64_64(ptr %out,ptr %in) {
 %vp0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x double>,ptr %vp0,align 1
 %ip0=getelementptr i8,ptr %in,i64 768
 %i0=load i64,ptr %ip0,align 1
 %fp0=getelementptr i8,ptr %in,i64 864
 %f0=load double,ptr %fp0,align 1
 %vp1=getelementptr i8,ptr %in,i64 64
 %v1=load <8 x double>,ptr %vp1,align 1
 %ip1=getelementptr i8,ptr %in,i64 776
 %i1=load i64,ptr %ip1,align 1
 %fp1=getelementptr i8,ptr %in,i64 872
 %f1=load double,ptr %fp1,align 1
 %vp2=getelementptr i8,ptr %in,i64 128
 %v2=load <8 x double>,ptr %vp2,align 1
 %ip2=getelementptr i8,ptr %in,i64 784
 %i2=load i64,ptr %ip2,align 1
 %fp2=getelementptr i8,ptr %in,i64 880
 %f2=load double,ptr %fp2,align 1
 %vp3=getelementptr i8,ptr %in,i64 192
 %v3=load <8 x double>,ptr %vp3,align 1
 %ip3=getelementptr i8,ptr %in,i64 792
 %i3=load i64,ptr %ip3,align 1
 %fp3=getelementptr i8,ptr %in,i64 888
 %f3=load double,ptr %fp3,align 1
 %vp4=getelementptr i8,ptr %in,i64 256
 %v4=load <8 x double>,ptr %vp4,align 1
 %ip4=getelementptr i8,ptr %in,i64 800
 %i4=load i64,ptr %ip4,align 1
 %fp4=getelementptr i8,ptr %in,i64 896
 %f4=load double,ptr %fp4,align 1
 %vp5=getelementptr i8,ptr %in,i64 320
 %v5=load <8 x double>,ptr %vp5,align 1
 %ip5=getelementptr i8,ptr %in,i64 808
 %i5=load i64,ptr %ip5,align 1
 %fp5=getelementptr i8,ptr %in,i64 904
 %f5=load double,ptr %fp5,align 1
 %vp6=getelementptr i8,ptr %in,i64 384
 %v6=load <8 x double>,ptr %vp6,align 1
 %ip6=getelementptr i8,ptr %in,i64 816
 %i6=load i64,ptr %ip6,align 1
 %fp6=getelementptr i8,ptr %in,i64 912
 %f6=load double,ptr %fp6,align 1
 %vp7=getelementptr i8,ptr %in,i64 448
 %v7=load <8 x double>,ptr %vp7,align 1
 %ip7=getelementptr i8,ptr %in,i64 824
 %i7=load i64,ptr %ip7,align 1
 %fp7=getelementptr i8,ptr %in,i64 920
 %f7=load double,ptr %fp7,align 1
 %vp8=getelementptr i8,ptr %in,i64 512
 %v8=load <8 x double>,ptr %vp8,align 1
 %ip8=getelementptr i8,ptr %in,i64 832
 %i8=load i64,ptr %ip8,align 1
 %fp8=getelementptr i8,ptr %in,i64 928
 %f8=load double,ptr %fp8,align 1
 %vp9=getelementptr i8,ptr %in,i64 576
 %v9=load <8 x double>,ptr %vp9,align 1
 %ip9=getelementptr i8,ptr %in,i64 840
 %i9=load i64,ptr %ip9,align 1
 %fp9=getelementptr i8,ptr %in,i64 936
 %f9=load double,ptr %fp9,align 1
 %vp10=getelementptr i8,ptr %in,i64 640
 %v10=load <8 x double>,ptr %vp10,align 1
 %ip10=getelementptr i8,ptr %in,i64 848
 %i10=load i64,ptr %ip10,align 1
 %fp10=getelementptr i8,ptr %in,i64 944
 %f10=load double,ptr %fp10,align 1
 %vp11=getelementptr i8,ptr %in,i64 704
 %v11=load <8 x double>,ptr %vp11,align 1
 %ip11=getelementptr i8,ptr %in,i64 856
 %i11=load i64,ptr %ip11,align 1
 %fp11=getelementptr i8,ptr %in,i64 952
 %f11=load double,ptr %fp11,align 1
 %audit=getelementptr i8,ptr %out,i64 64
 %result=call <8 x double> @mix_callee_f64_64(ptr %audit,<8 x double> %v0,i64 %i0,double %f0,<8 x double> %v1,i64 %i1,double %f1,<8 x double> %v2,i64 %i2,double %f2,<8 x double> %v3,i64 %i3,double %f3,<8 x double> %v4,i64 %i4,double %f4,<8 x double> %v5,i64 %i5,double %f5,<8 x double> %v6,i64 %i6,double %f6,<8 x double> %v7,i64 %i7,double %f7,<8 x double> %v8,i64 %i8,double %f8,<8 x double> %v9,i64 %i9,double %f9,<8 x double> %v10,i64 %i10,double %f10,<8 x double> %v11,i64 %i11,double %f11)
 store <8 x double> %result,ptr %out,align 1
 ret void
}
define internal {<8 x double>,<8 x double>,<8 x double>,i64,double} @aggregate_callee_f64_64(<8 x double> %a,<8 x double> %b,<8 x double> %c,i64 %i,double %f) #0 {
 %r0=insertvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} poison,<8 x double> %c,0
 %r1=insertvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %r0,<8 x double> %a,1
 %r2=insertvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %r1,<8 x double> %b,2
 %r3=insertvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %r2,i64 %i,3
 %r4=insertvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %r3,double %f,4
 ret {<8 x double>,<8 x double>,<8 x double>,i64,double} %r4
}
define void @abi_aggregate_f64_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x double>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <8 x double>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <8 x double>,ptr %p2,align 1
 %ip=getelementptr i8,ptr %in,i64 192
 %i=load i64,ptr %ip,align 1
 %fp=getelementptr i8,ptr %in,i64 200
 %f=load double,ptr %fp,align 1
 %result=call {<8 x double>,<8 x double>,<8 x double>,i64,double} @aggregate_callee_f64_64(<8 x double> %v0,<8 x double> %v1,<8 x double> %v2,i64 %i,double %f)
 %o0=getelementptr i8,ptr %out,i64 0
 %r0=extractvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %result,0
 store <8 x double> %r0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 %r1=extractvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %result,1
 store <8 x double> %r1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 %r2=extractvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %result,2
 store <8 x double> %r2,ptr %o2,align 1
 %oi=getelementptr i8,ptr %out,i64 192
 %ri=extractvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %result,3
 store i64 %ri,ptr %oi,align 1
 %of=getelementptr i8,ptr %out,i64 200
 %rf=extractvalue {<8 x double>,<8 x double>,<8 x double>,i64,double} %result,4
 store double %rf,ptr %of,align 1
 ret void
}
define void @abi_spills_f64_64(ptr %out,ptr %in) {
 %p0=getelementptr i8,ptr %in,i64 0
 %v0=load <8 x double>,ptr %p0,align 1
 %p1=getelementptr i8,ptr %in,i64 64
 %v1=load <8 x double>,ptr %p1,align 1
 %p2=getelementptr i8,ptr %in,i64 128
 %v2=load <8 x double>,ptr %p2,align 1
 %p3=getelementptr i8,ptr %in,i64 192
 %v3=load <8 x double>,ptr %p3,align 1
 %p4=getelementptr i8,ptr %in,i64 256
 %v4=load <8 x double>,ptr %p4,align 1
 %p5=getelementptr i8,ptr %in,i64 320
 %v5=load <8 x double>,ptr %p5,align 1
 %p6=getelementptr i8,ptr %in,i64 384
 %v6=load <8 x double>,ptr %p6,align 1
 %p7=getelementptr i8,ptr %in,i64 448
 %v7=load <8 x double>,ptr %p7,align 1
 %p8=getelementptr i8,ptr %in,i64 512
 %v8=load <8 x double>,ptr %p8,align 1
 %p9=getelementptr i8,ptr %in,i64 576
 %v9=load <8 x double>,ptr %p9,align 1
 %p10=getelementptr i8,ptr %in,i64 640
 %v10=load <8 x double>,ptr %p10,align 1
 %p11=getelementptr i8,ptr %in,i64 704
 %v11=load <8 x double>,ptr %p11,align 1
 %p12=getelementptr i8,ptr %in,i64 768
 %v12=load <8 x double>,ptr %p12,align 1
 %p13=getelementptr i8,ptr %in,i64 832
 %v13=load <8 x double>,ptr %p13,align 1
 %p14=getelementptr i8,ptr %in,i64 896
 %v14=load <8 x double>,ptr %p14,align 1
 %p15=getelementptr i8,ptr %in,i64 960
 %v15=load <8 x double>,ptr %p15,align 1
 %p16=getelementptr i8,ptr %in,i64 1024
 %v16=load <8 x double>,ptr %p16,align 1
 %p17=getelementptr i8,ptr %in,i64 1088
 %v17=load <8 x double>,ptr %p17,align 1
 %p18=getelementptr i8,ptr %in,i64 1152
 %v18=load <8 x double>,ptr %p18,align 1
 %p19=getelementptr i8,ptr %in,i64 1216
 %v19=load <8 x double>,ptr %p19,align 1
 %p20=getelementptr i8,ptr %in,i64 1280
 %v20=load <8 x double>,ptr %p20,align 1
 %p21=getelementptr i8,ptr %in,i64 1344
 %v21=load <8 x double>,ptr %p21,align 1
 %p22=getelementptr i8,ptr %in,i64 1408
 %v22=load <8 x double>,ptr %p22,align 1
 %p23=getelementptr i8,ptr %in,i64 1472
 %v23=load <8 x double>,ptr %p23,align 1
 %p24=getelementptr i8,ptr %in,i64 1536
 %v24=load <8 x double>,ptr %p24,align 1
 %p25=getelementptr i8,ptr %in,i64 1600
 %v25=load <8 x double>,ptr %p25,align 1
 %p26=getelementptr i8,ptr %in,i64 1664
 %v26=load <8 x double>,ptr %p26,align 1
 %p27=getelementptr i8,ptr %in,i64 1728
 %v27=load <8 x double>,ptr %p27,align 1
 %p28=getelementptr i8,ptr %in,i64 1792
 %v28=load <8 x double>,ptr %p28,align 1
 %p29=getelementptr i8,ptr %in,i64 1856
 %v29=load <8 x double>,ptr %p29,align 1
 %p30=getelementptr i8,ptr %in,i64 1920
 %v30=load <8 x double>,ptr %p30,align 1
 %p31=getelementptr i8,ptr %in,i64 1984
 %v31=load <8 x double>,ptr %p31,align 1
 %p32=getelementptr i8,ptr %in,i64 2048
 %v32=load <8 x double>,ptr %p32,align 1
 %p33=getelementptr i8,ptr %in,i64 2112
 %v33=load <8 x double>,ptr %p33,align 1
 %p34=getelementptr i8,ptr %in,i64 2176
 %v34=load <8 x double>,ptr %p34,align 1
 %p35=getelementptr i8,ptr %in,i64 2240
 %v35=load <8 x double>,ptr %p35,align 1
 %p36=getelementptr i8,ptr %in,i64 2304
 %v36=load <8 x double>,ptr %p36,align 1
 %p37=getelementptr i8,ptr %in,i64 2368
 %v37=load <8 x double>,ptr %p37,align 1
 %p38=getelementptr i8,ptr %in,i64 2432
 %v38=load <8 x double>,ptr %p38,align 1
 %p39=getelementptr i8,ptr %in,i64 2496
 %v39=load <8 x double>,ptr %p39,align 1
 call void @abi_clobber(ptr %out,ptr %in,i64 2560)
 %o0=getelementptr i8,ptr %out,i64 0
 store <8 x double> %v0,ptr %o0,align 1
 %o1=getelementptr i8,ptr %out,i64 64
 store <8 x double> %v1,ptr %o1,align 1
 %o2=getelementptr i8,ptr %out,i64 128
 store <8 x double> %v2,ptr %o2,align 1
 %o3=getelementptr i8,ptr %out,i64 192
 store <8 x double> %v3,ptr %o3,align 1
 %o4=getelementptr i8,ptr %out,i64 256
 store <8 x double> %v4,ptr %o4,align 1
 %o5=getelementptr i8,ptr %out,i64 320
 store <8 x double> %v5,ptr %o5,align 1
 %o6=getelementptr i8,ptr %out,i64 384
 store <8 x double> %v6,ptr %o6,align 1
 %o7=getelementptr i8,ptr %out,i64 448
 store <8 x double> %v7,ptr %o7,align 1
 %o8=getelementptr i8,ptr %out,i64 512
 store <8 x double> %v8,ptr %o8,align 1
 %o9=getelementptr i8,ptr %out,i64 576
 store <8 x double> %v9,ptr %o9,align 1
 %o10=getelementptr i8,ptr %out,i64 640
 store <8 x double> %v10,ptr %o10,align 1
 %o11=getelementptr i8,ptr %out,i64 704
 store <8 x double> %v11,ptr %o11,align 1
 %o12=getelementptr i8,ptr %out,i64 768
 store <8 x double> %v12,ptr %o12,align 1
 %o13=getelementptr i8,ptr %out,i64 832
 store <8 x double> %v13,ptr %o13,align 1
 %o14=getelementptr i8,ptr %out,i64 896
 store <8 x double> %v14,ptr %o14,align 1
 %o15=getelementptr i8,ptr %out,i64 960
 store <8 x double> %v15,ptr %o15,align 1
 %o16=getelementptr i8,ptr %out,i64 1024
 store <8 x double> %v16,ptr %o16,align 1
 %o17=getelementptr i8,ptr %out,i64 1088
 store <8 x double> %v17,ptr %o17,align 1
 %o18=getelementptr i8,ptr %out,i64 1152
 store <8 x double> %v18,ptr %o18,align 1
 %o19=getelementptr i8,ptr %out,i64 1216
 store <8 x double> %v19,ptr %o19,align 1
 %o20=getelementptr i8,ptr %out,i64 1280
 store <8 x double> %v20,ptr %o20,align 1
 %o21=getelementptr i8,ptr %out,i64 1344
 store <8 x double> %v21,ptr %o21,align 1
 %o22=getelementptr i8,ptr %out,i64 1408
 store <8 x double> %v22,ptr %o22,align 1
 %o23=getelementptr i8,ptr %out,i64 1472
 store <8 x double> %v23,ptr %o23,align 1
 %o24=getelementptr i8,ptr %out,i64 1536
 store <8 x double> %v24,ptr %o24,align 1
 %o25=getelementptr i8,ptr %out,i64 1600
 store <8 x double> %v25,ptr %o25,align 1
 %o26=getelementptr i8,ptr %out,i64 1664
 store <8 x double> %v26,ptr %o26,align 1
 %o27=getelementptr i8,ptr %out,i64 1728
 store <8 x double> %v27,ptr %o27,align 1
 %o28=getelementptr i8,ptr %out,i64 1792
 store <8 x double> %v28,ptr %o28,align 1
 %o29=getelementptr i8,ptr %out,i64 1856
 store <8 x double> %v29,ptr %o29,align 1
 %o30=getelementptr i8,ptr %out,i64 1920
 store <8 x double> %v30,ptr %o30,align 1
 %o31=getelementptr i8,ptr %out,i64 1984
 store <8 x double> %v31,ptr %o31,align 1
 %o32=getelementptr i8,ptr %out,i64 2048
 store <8 x double> %v32,ptr %o32,align 1
 %o33=getelementptr i8,ptr %out,i64 2112
 store <8 x double> %v33,ptr %o33,align 1
 %o34=getelementptr i8,ptr %out,i64 2176
 store <8 x double> %v34,ptr %o34,align 1
 %o35=getelementptr i8,ptr %out,i64 2240
 store <8 x double> %v35,ptr %o35,align 1
 %o36=getelementptr i8,ptr %out,i64 2304
 store <8 x double> %v36,ptr %o36,align 1
 %o37=getelementptr i8,ptr %out,i64 2368
 store <8 x double> %v37,ptr %o37,align 1
 %o38=getelementptr i8,ptr %out,i64 2432
 store <8 x double> %v38,ptr %o38,align 1
 %o39=getelementptr i8,ptr %out,i64 2496
 store <8 x double> %v39,ptr %o39,align 1
 ret void
}
attributes #0 = { noinline optnone }
