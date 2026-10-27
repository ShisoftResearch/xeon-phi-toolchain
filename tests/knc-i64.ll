; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; CHECK-LABEL: i64_add:
; CHECK: knc.vpaddd
; CHECK-LABEL: i64_mul:
; CHECK: knc.vpmulhud
; CHECK-LABEL: i64_ashr:
; CHECK: knc.vpsravd
 target triple = "x86_64-unknown-linux-gnu"
define void @i64_add(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=add <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_mul(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=mul <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_sub(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=sub <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_and(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=and <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_or(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=or <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_xor(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=xor <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_shl(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=shl <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_lshr(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=lshr <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_ashr(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=ashr <8 x i64> %x,%y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_smin(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=call <8 x i64> @llvm.smin.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
declare <8 x i64> @llvm.smin.v8i64(<8 x i64>,<8 x i64>)
define void @i64_smax(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=call <8 x i64> @llvm.smax.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
declare <8 x i64> @llvm.smax.v8i64(<8 x i64>,<8 x i64>)
define void @i64_umin(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=call <8 x i64> @llvm.umin.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
declare <8 x i64> @llvm.umin.v8i64(<8 x i64>,<8 x i64>)
define void @i64_umax(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=call <8 x i64> @llvm.umax.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
declare <8 x i64> @llvm.umax.v8i64(<8 x i64>,<8 x i64>)
define void @i64_cmp_eq(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp eq <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_ne(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp ne <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_slt(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp slt <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_sle(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp sle <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_sgt(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp sgt <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_sge(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp sge <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_ult(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp ult <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_ule(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp ule <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_ugt(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp ugt <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_cmp_uge(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp uge <8 x i64> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_select(ptr %o,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %c=icmp slt <8 x i64> %x,%y
 %r=select <8 x i1> %c,<8 x i64> %x,<8 x i64> %y
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define i64 @i64_reduce_add(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.add.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.add.v8i64(<8 x i64>)
define i64 @i64_reduce_mul(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.mul.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.mul.v8i64(<8 x i64>)
define i64 @i64_reduce_and(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.and.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.and.v8i64(<8 x i64>)
define i64 @i64_reduce_or(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.or.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.or.v8i64(<8 x i64>)
define i64 @i64_reduce_xor(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.xor.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.xor.v8i64(<8 x i64>)
define i64 @i64_reduce_smin(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.smin.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.smin.v8i64(<8 x i64>)
define i64 @i64_reduce_smax(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.smax.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.smax.v8i64(<8 x i64>)
define i64 @i64_reduce_umin(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.umin.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.umin.v8i64(<8 x i64>)
define i64 @i64_reduce_umax(ptr %a) {
 %v=load <8 x i64>,ptr %a,align 8
 %r=call i64 @llvm.vector.reduce.umax.v8i64(<8 x i64> %v)
 ret i64 %r
}
declare i64 @llvm.vector.reduce.umax.v8i64(<8 x i64>)
define i64 @i64_extract(ptr %a,i64 %i){
 %v=load <8 x i64>,ptr %a,align 8
 %r=extractelement <8 x i64> %v,i64 %i
 ret i64 %r
}
define void @i64_insert(ptr %o,ptr %a,i64 %i,i64 %x){
 %v=load <8 x i64>,ptr %a,align 8
 %r=insertelement <8 x i64> %v,i64 %x,i64 %i
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
define void @i64_shuffle(ptr %o,ptr %a,ptr %b){
 %x=load <8 x i64>,ptr %a,align 8
 %y=load <8 x i64>,ptr %b,align 8
 %r=shufflevector <8 x i64> %x,<8 x i64> %y,<8 x i32> <i32 7,i32 9,i32 5,i32 11,i32 3,i32 13,i32 1,i32 15>
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
declare void @i64_clobber(ptr)
define void @i64_spills(ptr %o,ptr %a){
 %p0=getelementptr i8,ptr %a,i64 0
 %v0=load <8 x i64>,ptr %p0,align 8
 %p1=getelementptr i8,ptr %a,i64 64
 %v1=load <8 x i64>,ptr %p1,align 8
 %p2=getelementptr i8,ptr %a,i64 128
 %v2=load <8 x i64>,ptr %p2,align 8
 %p3=getelementptr i8,ptr %a,i64 192
 %v3=load <8 x i64>,ptr %p3,align 8
 %p4=getelementptr i8,ptr %a,i64 256
 %v4=load <8 x i64>,ptr %p4,align 8
 %p5=getelementptr i8,ptr %a,i64 320
 %v5=load <8 x i64>,ptr %p5,align 8
 %p6=getelementptr i8,ptr %a,i64 384
 %v6=load <8 x i64>,ptr %p6,align 8
 %p7=getelementptr i8,ptr %a,i64 448
 %v7=load <8 x i64>,ptr %p7,align 8
 %p8=getelementptr i8,ptr %a,i64 512
 %v8=load <8 x i64>,ptr %p8,align 8
 %p9=getelementptr i8,ptr %a,i64 576
 %v9=load <8 x i64>,ptr %p9,align 8
 %p10=getelementptr i8,ptr %a,i64 640
 %v10=load <8 x i64>,ptr %p10,align 8
 %p11=getelementptr i8,ptr %a,i64 704
 %v11=load <8 x i64>,ptr %p11,align 8
 %p12=getelementptr i8,ptr %a,i64 768
 %v12=load <8 x i64>,ptr %p12,align 8
 %p13=getelementptr i8,ptr %a,i64 832
 %v13=load <8 x i64>,ptr %p13,align 8
 %p14=getelementptr i8,ptr %a,i64 896
 %v14=load <8 x i64>,ptr %p14,align 8
 %p15=getelementptr i8,ptr %a,i64 960
 %v15=load <8 x i64>,ptr %p15,align 8
 %p16=getelementptr i8,ptr %a,i64 1024
 %v16=load <8 x i64>,ptr %p16,align 8
 %p17=getelementptr i8,ptr %a,i64 1088
 %v17=load <8 x i64>,ptr %p17,align 8
 %p18=getelementptr i8,ptr %a,i64 1152
 %v18=load <8 x i64>,ptr %p18,align 8
 %p19=getelementptr i8,ptr %a,i64 1216
 %v19=load <8 x i64>,ptr %p19,align 8
 %p20=getelementptr i8,ptr %a,i64 1280
 %v20=load <8 x i64>,ptr %p20,align 8
 %p21=getelementptr i8,ptr %a,i64 1344
 %v21=load <8 x i64>,ptr %p21,align 8
 %p22=getelementptr i8,ptr %a,i64 1408
 %v22=load <8 x i64>,ptr %p22,align 8
 %p23=getelementptr i8,ptr %a,i64 1472
 %v23=load <8 x i64>,ptr %p23,align 8
 %p24=getelementptr i8,ptr %a,i64 1536
 %v24=load <8 x i64>,ptr %p24,align 8
 %p25=getelementptr i8,ptr %a,i64 1600
 %v25=load <8 x i64>,ptr %p25,align 8
 %p26=getelementptr i8,ptr %a,i64 1664
 %v26=load <8 x i64>,ptr %p26,align 8
 %p27=getelementptr i8,ptr %a,i64 1728
 %v27=load <8 x i64>,ptr %p27,align 8
 %p28=getelementptr i8,ptr %a,i64 1792
 %v28=load <8 x i64>,ptr %p28,align 8
 %p29=getelementptr i8,ptr %a,i64 1856
 %v29=load <8 x i64>,ptr %p29,align 8
 %p30=getelementptr i8,ptr %a,i64 1920
 %v30=load <8 x i64>,ptr %p30,align 8
 %p31=getelementptr i8,ptr %a,i64 1984
 %v31=load <8 x i64>,ptr %p31,align 8
 %p32=getelementptr i8,ptr %a,i64 2048
 %v32=load <8 x i64>,ptr %p32,align 8
 %p33=getelementptr i8,ptr %a,i64 2112
 %v33=load <8 x i64>,ptr %p33,align 8
 %p34=getelementptr i8,ptr %a,i64 2176
 %v34=load <8 x i64>,ptr %p34,align 8
 %p35=getelementptr i8,ptr %a,i64 2240
 %v35=load <8 x i64>,ptr %p35,align 8
 %p36=getelementptr i8,ptr %a,i64 2304
 %v36=load <8 x i64>,ptr %p36,align 8
 %p37=getelementptr i8,ptr %a,i64 2368
 %v37=load <8 x i64>,ptr %p37,align 8
 %p38=getelementptr i8,ptr %a,i64 2432
 %v38=load <8 x i64>,ptr %p38,align 8
 %p39=getelementptr i8,ptr %a,i64 2496
 %v39=load <8 x i64>,ptr %p39,align 8
 call void @i64_clobber(ptr %o)
 %q0=getelementptr i8,ptr %o,i64 0
 store <8 x i64> %v0,ptr %q0,align 8
 %q1=getelementptr i8,ptr %o,i64 64
 store <8 x i64> %v1,ptr %q1,align 8
 %q2=getelementptr i8,ptr %o,i64 128
 store <8 x i64> %v2,ptr %q2,align 8
 %q3=getelementptr i8,ptr %o,i64 192
 store <8 x i64> %v3,ptr %q3,align 8
 %q4=getelementptr i8,ptr %o,i64 256
 store <8 x i64> %v4,ptr %q4,align 8
 %q5=getelementptr i8,ptr %o,i64 320
 store <8 x i64> %v5,ptr %q5,align 8
 %q6=getelementptr i8,ptr %o,i64 384
 store <8 x i64> %v6,ptr %q6,align 8
 %q7=getelementptr i8,ptr %o,i64 448
 store <8 x i64> %v7,ptr %q7,align 8
 %q8=getelementptr i8,ptr %o,i64 512
 store <8 x i64> %v8,ptr %q8,align 8
 %q9=getelementptr i8,ptr %o,i64 576
 store <8 x i64> %v9,ptr %q9,align 8
 %q10=getelementptr i8,ptr %o,i64 640
 store <8 x i64> %v10,ptr %q10,align 8
 %q11=getelementptr i8,ptr %o,i64 704
 store <8 x i64> %v11,ptr %q11,align 8
 %q12=getelementptr i8,ptr %o,i64 768
 store <8 x i64> %v12,ptr %q12,align 8
 %q13=getelementptr i8,ptr %o,i64 832
 store <8 x i64> %v13,ptr %q13,align 8
 %q14=getelementptr i8,ptr %o,i64 896
 store <8 x i64> %v14,ptr %q14,align 8
 %q15=getelementptr i8,ptr %o,i64 960
 store <8 x i64> %v15,ptr %q15,align 8
 %q16=getelementptr i8,ptr %o,i64 1024
 store <8 x i64> %v16,ptr %q16,align 8
 %q17=getelementptr i8,ptr %o,i64 1088
 store <8 x i64> %v17,ptr %q17,align 8
 %q18=getelementptr i8,ptr %o,i64 1152
 store <8 x i64> %v18,ptr %q18,align 8
 %q19=getelementptr i8,ptr %o,i64 1216
 store <8 x i64> %v19,ptr %q19,align 8
 %q20=getelementptr i8,ptr %o,i64 1280
 store <8 x i64> %v20,ptr %q20,align 8
 %q21=getelementptr i8,ptr %o,i64 1344
 store <8 x i64> %v21,ptr %q21,align 8
 %q22=getelementptr i8,ptr %o,i64 1408
 store <8 x i64> %v22,ptr %q22,align 8
 %q23=getelementptr i8,ptr %o,i64 1472
 store <8 x i64> %v23,ptr %q23,align 8
 %q24=getelementptr i8,ptr %o,i64 1536
 store <8 x i64> %v24,ptr %q24,align 8
 %q25=getelementptr i8,ptr %o,i64 1600
 store <8 x i64> %v25,ptr %q25,align 8
 %q26=getelementptr i8,ptr %o,i64 1664
 store <8 x i64> %v26,ptr %q26,align 8
 %q27=getelementptr i8,ptr %o,i64 1728
 store <8 x i64> %v27,ptr %q27,align 8
 %q28=getelementptr i8,ptr %o,i64 1792
 store <8 x i64> %v28,ptr %q28,align 8
 %q29=getelementptr i8,ptr %o,i64 1856
 store <8 x i64> %v29,ptr %q29,align 8
 %q30=getelementptr i8,ptr %o,i64 1920
 store <8 x i64> %v30,ptr %q30,align 8
 %q31=getelementptr i8,ptr %o,i64 1984
 store <8 x i64> %v31,ptr %q31,align 8
 %q32=getelementptr i8,ptr %o,i64 2048
 store <8 x i64> %v32,ptr %q32,align 8
 %q33=getelementptr i8,ptr %o,i64 2112
 store <8 x i64> %v33,ptr %q33,align 8
 %q34=getelementptr i8,ptr %o,i64 2176
 store <8 x i64> %v34,ptr %q34,align 8
 %q35=getelementptr i8,ptr %o,i64 2240
 store <8 x i64> %v35,ptr %q35,align 8
 %q36=getelementptr i8,ptr %o,i64 2304
 store <8 x i64> %v36,ptr %q36,align 8
 %q37=getelementptr i8,ptr %o,i64 2368
 store <8 x i64> %v37,ptr %q37,align 8
 %q38=getelementptr i8,ptr %o,i64 2432
 store <8 x i64> %v38,ptr %q38,align 8
 %q39=getelementptr i8,ptr %o,i64 2496
 store <8 x i64> %v39,ptr %q39,align 8
 ret void
}
define <8 x i64> @i64_abi_sum(<8 x i64> %x0,<8 x i64> %x1,<8 x i64> %x2,<8 x i64> %x3,<8 x i64> %x4,<8 x i64> %x5,<8 x i64> %x6,<8 x i64> %x7,<8 x i64> %x8,<8 x i64> %x9) noinline {
 %s1=add <8 x i64> %x0,%x1
 %s2=add <8 x i64> %s1,%x2
 %s3=add <8 x i64> %s2,%x3
 %s4=add <8 x i64> %s3,%x4
 %s5=add <8 x i64> %s4,%x5
 %s6=add <8 x i64> %s5,%x6
 %s7=add <8 x i64> %s6,%x7
 %s8=add <8 x i64> %s7,%x8
 %s9=add <8 x i64> %s8,%x9
 ret <8 x i64> %s9
}
define void @i64_abi_call(ptr %o,ptr %a) {
 %p0=getelementptr i8,ptr %a,i64 0
 %v0=load <8 x i64>,ptr %p0,align 8
 %p1=getelementptr i8,ptr %a,i64 64
 %v1=load <8 x i64>,ptr %p1,align 8
 %p2=getelementptr i8,ptr %a,i64 128
 %v2=load <8 x i64>,ptr %p2,align 8
 %p3=getelementptr i8,ptr %a,i64 192
 %v3=load <8 x i64>,ptr %p3,align 8
 %p4=getelementptr i8,ptr %a,i64 256
 %v4=load <8 x i64>,ptr %p4,align 8
 %p5=getelementptr i8,ptr %a,i64 320
 %v5=load <8 x i64>,ptr %p5,align 8
 %p6=getelementptr i8,ptr %a,i64 384
 %v6=load <8 x i64>,ptr %p6,align 8
 %p7=getelementptr i8,ptr %a,i64 448
 %v7=load <8 x i64>,ptr %p7,align 8
 %p8=getelementptr i8,ptr %a,i64 512
 %v8=load <8 x i64>,ptr %p8,align 8
 %p9=getelementptr i8,ptr %a,i64 576
 %v9=load <8 x i64>,ptr %p9,align 8
 %r=call <8 x i64> @i64_abi_sum(<8 x i64> %v0,<8 x i64> %v1,<8 x i64> %v2,<8 x i64> %v3,<8 x i64> %v4,<8 x i64> %v5,<8 x i64> %v6,<8 x i64> %v7,<8 x i64> %v8,<8 x i64> %v9)
 store <8 x i64> %r,ptr %o,align 8
 ret void
}
declare void @scalar_clobber(ptr)
define void @scalar_spills(ptr %out,ptr %in) {
 %p0=getelementptr i64,ptr %in,i64 0
 %v0=load i64,ptr %p0,align 8
 %p1=getelementptr i64,ptr %in,i64 1
 %v1=load i64,ptr %p1,align 8
 %p2=getelementptr i64,ptr %in,i64 2
 %v2=load i64,ptr %p2,align 8
 %p3=getelementptr i64,ptr %in,i64 3
 %v3=load i64,ptr %p3,align 8
 %p4=getelementptr i64,ptr %in,i64 4
 %v4=load i64,ptr %p4,align 8
 %p5=getelementptr i64,ptr %in,i64 5
 %v5=load i64,ptr %p5,align 8
 %p6=getelementptr i64,ptr %in,i64 6
 %v6=load i64,ptr %p6,align 8
 %p7=getelementptr i64,ptr %in,i64 7
 %v7=load i64,ptr %p7,align 8
 %p8=getelementptr i64,ptr %in,i64 8
 %v8=load i64,ptr %p8,align 8
 %p9=getelementptr i64,ptr %in,i64 9
 %v9=load i64,ptr %p9,align 8
 %p10=getelementptr i64,ptr %in,i64 10
 %v10=load i64,ptr %p10,align 8
 %p11=getelementptr i64,ptr %in,i64 11
 %v11=load i64,ptr %p11,align 8
 %p12=getelementptr i64,ptr %in,i64 12
 %v12=load i64,ptr %p12,align 8
 %p13=getelementptr i64,ptr %in,i64 13
 %v13=load i64,ptr %p13,align 8
 %p14=getelementptr i64,ptr %in,i64 14
 %v14=load i64,ptr %p14,align 8
 %p15=getelementptr i64,ptr %in,i64 15
 %v15=load i64,ptr %p15,align 8
 %p16=getelementptr i64,ptr %in,i64 16
 %v16=load i64,ptr %p16,align 8
 %p17=getelementptr i64,ptr %in,i64 17
 %v17=load i64,ptr %p17,align 8
 %p18=getelementptr i64,ptr %in,i64 18
 %v18=load i64,ptr %p18,align 8
 %p19=getelementptr i64,ptr %in,i64 19
 %v19=load i64,ptr %p19,align 8
 %p20=getelementptr i64,ptr %in,i64 20
 %v20=load i64,ptr %p20,align 8
 %p21=getelementptr i64,ptr %in,i64 21
 %v21=load i64,ptr %p21,align 8
 %p22=getelementptr i64,ptr %in,i64 22
 %v22=load i64,ptr %p22,align 8
 %p23=getelementptr i64,ptr %in,i64 23
 %v23=load i64,ptr %p23,align 8
 %p24=getelementptr i64,ptr %in,i64 24
 %v24=load i64,ptr %p24,align 8
 %p25=getelementptr i64,ptr %in,i64 25
 %v25=load i64,ptr %p25,align 8
 %p26=getelementptr i64,ptr %in,i64 26
 %v26=load i64,ptr %p26,align 8
 %p27=getelementptr i64,ptr %in,i64 27
 %v27=load i64,ptr %p27,align 8
 %p28=getelementptr i64,ptr %in,i64 28
 %v28=load i64,ptr %p28,align 8
 %p29=getelementptr i64,ptr %in,i64 29
 %v29=load i64,ptr %p29,align 8
 %p30=getelementptr i64,ptr %in,i64 30
 %v30=load i64,ptr %p30,align 8
 %p31=getelementptr i64,ptr %in,i64 31
 %v31=load i64,ptr %p31,align 8
 %p32=getelementptr i64,ptr %in,i64 32
 %v32=load i64,ptr %p32,align 8
 %p33=getelementptr i64,ptr %in,i64 33
 %v33=load i64,ptr %p33,align 8
 %p34=getelementptr i64,ptr %in,i64 34
 %v34=load i64,ptr %p34,align 8
 %p35=getelementptr i64,ptr %in,i64 35
 %v35=load i64,ptr %p35,align 8
 %p36=getelementptr i64,ptr %in,i64 36
 %v36=load i64,ptr %p36,align 8
 %p37=getelementptr i64,ptr %in,i64 37
 %v37=load i64,ptr %p37,align 8
 %p38=getelementptr i64,ptr %in,i64 38
 %v38=load i64,ptr %p38,align 8
 %p39=getelementptr i64,ptr %in,i64 39
 %v39=load i64,ptr %p39,align 8
 %p40=getelementptr i64,ptr %in,i64 40
 %v40=load i64,ptr %p40,align 8
 %p41=getelementptr i64,ptr %in,i64 41
 %v41=load i64,ptr %p41,align 8
 %p42=getelementptr i64,ptr %in,i64 42
 %v42=load i64,ptr %p42,align 8
 %p43=getelementptr i64,ptr %in,i64 43
 %v43=load i64,ptr %p43,align 8
 %p44=getelementptr i64,ptr %in,i64 44
 %v44=load i64,ptr %p44,align 8
 %p45=getelementptr i64,ptr %in,i64 45
 %v45=load i64,ptr %p45,align 8
 %p46=getelementptr i64,ptr %in,i64 46
 %v46=load i64,ptr %p46,align 8
 %p47=getelementptr i64,ptr %in,i64 47
 %v47=load i64,ptr %p47,align 8
 %p48=getelementptr i64,ptr %in,i64 48
 %v48=load i64,ptr %p48,align 8
 %p49=getelementptr i64,ptr %in,i64 49
 %v49=load i64,ptr %p49,align 8
 %p50=getelementptr i64,ptr %in,i64 50
 %v50=load i64,ptr %p50,align 8
 %p51=getelementptr i64,ptr %in,i64 51
 %v51=load i64,ptr %p51,align 8
 %p52=getelementptr i64,ptr %in,i64 52
 %v52=load i64,ptr %p52,align 8
 %p53=getelementptr i64,ptr %in,i64 53
 %v53=load i64,ptr %p53,align 8
 %p54=getelementptr i64,ptr %in,i64 54
 %v54=load i64,ptr %p54,align 8
 %p55=getelementptr i64,ptr %in,i64 55
 %v55=load i64,ptr %p55,align 8
 %p56=getelementptr i64,ptr %in,i64 56
 %v56=load i64,ptr %p56,align 8
 %p57=getelementptr i64,ptr %in,i64 57
 %v57=load i64,ptr %p57,align 8
 %p58=getelementptr i64,ptr %in,i64 58
 %v58=load i64,ptr %p58,align 8
 %p59=getelementptr i64,ptr %in,i64 59
 %v59=load i64,ptr %p59,align 8
 %p60=getelementptr i64,ptr %in,i64 60
 %v60=load i64,ptr %p60,align 8
 %p61=getelementptr i64,ptr %in,i64 61
 %v61=load i64,ptr %p61,align 8
 %p62=getelementptr i64,ptr %in,i64 62
 %v62=load i64,ptr %p62,align 8
 %p63=getelementptr i64,ptr %in,i64 63
 %v63=load i64,ptr %p63,align 8
 call void @scalar_clobber(ptr %out)
 %q0=getelementptr i64,ptr %out,i64 0
 store i64 %v0,ptr %q0,align 8
 %q1=getelementptr i64,ptr %out,i64 1
 store i64 %v1,ptr %q1,align 8
 %q2=getelementptr i64,ptr %out,i64 2
 store i64 %v2,ptr %q2,align 8
 %q3=getelementptr i64,ptr %out,i64 3
 store i64 %v3,ptr %q3,align 8
 %q4=getelementptr i64,ptr %out,i64 4
 store i64 %v4,ptr %q4,align 8
 %q5=getelementptr i64,ptr %out,i64 5
 store i64 %v5,ptr %q5,align 8
 %q6=getelementptr i64,ptr %out,i64 6
 store i64 %v6,ptr %q6,align 8
 %q7=getelementptr i64,ptr %out,i64 7
 store i64 %v7,ptr %q7,align 8
 %q8=getelementptr i64,ptr %out,i64 8
 store i64 %v8,ptr %q8,align 8
 %q9=getelementptr i64,ptr %out,i64 9
 store i64 %v9,ptr %q9,align 8
 %q10=getelementptr i64,ptr %out,i64 10
 store i64 %v10,ptr %q10,align 8
 %q11=getelementptr i64,ptr %out,i64 11
 store i64 %v11,ptr %q11,align 8
 %q12=getelementptr i64,ptr %out,i64 12
 store i64 %v12,ptr %q12,align 8
 %q13=getelementptr i64,ptr %out,i64 13
 store i64 %v13,ptr %q13,align 8
 %q14=getelementptr i64,ptr %out,i64 14
 store i64 %v14,ptr %q14,align 8
 %q15=getelementptr i64,ptr %out,i64 15
 store i64 %v15,ptr %q15,align 8
 %q16=getelementptr i64,ptr %out,i64 16
 store i64 %v16,ptr %q16,align 8
 %q17=getelementptr i64,ptr %out,i64 17
 store i64 %v17,ptr %q17,align 8
 %q18=getelementptr i64,ptr %out,i64 18
 store i64 %v18,ptr %q18,align 8
 %q19=getelementptr i64,ptr %out,i64 19
 store i64 %v19,ptr %q19,align 8
 %q20=getelementptr i64,ptr %out,i64 20
 store i64 %v20,ptr %q20,align 8
 %q21=getelementptr i64,ptr %out,i64 21
 store i64 %v21,ptr %q21,align 8
 %q22=getelementptr i64,ptr %out,i64 22
 store i64 %v22,ptr %q22,align 8
 %q23=getelementptr i64,ptr %out,i64 23
 store i64 %v23,ptr %q23,align 8
 %q24=getelementptr i64,ptr %out,i64 24
 store i64 %v24,ptr %q24,align 8
 %q25=getelementptr i64,ptr %out,i64 25
 store i64 %v25,ptr %q25,align 8
 %q26=getelementptr i64,ptr %out,i64 26
 store i64 %v26,ptr %q26,align 8
 %q27=getelementptr i64,ptr %out,i64 27
 store i64 %v27,ptr %q27,align 8
 %q28=getelementptr i64,ptr %out,i64 28
 store i64 %v28,ptr %q28,align 8
 %q29=getelementptr i64,ptr %out,i64 29
 store i64 %v29,ptr %q29,align 8
 %q30=getelementptr i64,ptr %out,i64 30
 store i64 %v30,ptr %q30,align 8
 %q31=getelementptr i64,ptr %out,i64 31
 store i64 %v31,ptr %q31,align 8
 %q32=getelementptr i64,ptr %out,i64 32
 store i64 %v32,ptr %q32,align 8
 %q33=getelementptr i64,ptr %out,i64 33
 store i64 %v33,ptr %q33,align 8
 %q34=getelementptr i64,ptr %out,i64 34
 store i64 %v34,ptr %q34,align 8
 %q35=getelementptr i64,ptr %out,i64 35
 store i64 %v35,ptr %q35,align 8
 %q36=getelementptr i64,ptr %out,i64 36
 store i64 %v36,ptr %q36,align 8
 %q37=getelementptr i64,ptr %out,i64 37
 store i64 %v37,ptr %q37,align 8
 %q38=getelementptr i64,ptr %out,i64 38
 store i64 %v38,ptr %q38,align 8
 %q39=getelementptr i64,ptr %out,i64 39
 store i64 %v39,ptr %q39,align 8
 %q40=getelementptr i64,ptr %out,i64 40
 store i64 %v40,ptr %q40,align 8
 %q41=getelementptr i64,ptr %out,i64 41
 store i64 %v41,ptr %q41,align 8
 %q42=getelementptr i64,ptr %out,i64 42
 store i64 %v42,ptr %q42,align 8
 %q43=getelementptr i64,ptr %out,i64 43
 store i64 %v43,ptr %q43,align 8
 %q44=getelementptr i64,ptr %out,i64 44
 store i64 %v44,ptr %q44,align 8
 %q45=getelementptr i64,ptr %out,i64 45
 store i64 %v45,ptr %q45,align 8
 %q46=getelementptr i64,ptr %out,i64 46
 store i64 %v46,ptr %q46,align 8
 %q47=getelementptr i64,ptr %out,i64 47
 store i64 %v47,ptr %q47,align 8
 %q48=getelementptr i64,ptr %out,i64 48
 store i64 %v48,ptr %q48,align 8
 %q49=getelementptr i64,ptr %out,i64 49
 store i64 %v49,ptr %q49,align 8
 %q50=getelementptr i64,ptr %out,i64 50
 store i64 %v50,ptr %q50,align 8
 %q51=getelementptr i64,ptr %out,i64 51
 store i64 %v51,ptr %q51,align 8
 %q52=getelementptr i64,ptr %out,i64 52
 store i64 %v52,ptr %q52,align 8
 %q53=getelementptr i64,ptr %out,i64 53
 store i64 %v53,ptr %q53,align 8
 %q54=getelementptr i64,ptr %out,i64 54
 store i64 %v54,ptr %q54,align 8
 %q55=getelementptr i64,ptr %out,i64 55
 store i64 %v55,ptr %q55,align 8
 %q56=getelementptr i64,ptr %out,i64 56
 store i64 %v56,ptr %q56,align 8
 %q57=getelementptr i64,ptr %out,i64 57
 store i64 %v57,ptr %q57,align 8
 %q58=getelementptr i64,ptr %out,i64 58
 store i64 %v58,ptr %q58,align 8
 %q59=getelementptr i64,ptr %out,i64 59
 store i64 %v59,ptr %q59,align 8
 %q60=getelementptr i64,ptr %out,i64 60
 store i64 %v60,ptr %q60,align 8
 %q61=getelementptr i64,ptr %out,i64 61
 store i64 %v61,ptr %q61,align 8
 %q62=getelementptr i64,ptr %out,i64 62
 store i64 %v62,ptr %q62,align 8
 %q63=getelementptr i64,ptr %out,i64 63
 store i64 %v63,ptr %q63,align 8
 ret void
}
