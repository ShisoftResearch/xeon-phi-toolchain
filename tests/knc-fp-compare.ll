; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
define void @cmp_f32_false(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp false <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_false(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp false <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: cmp_f32_oeq:
; CHECK: knc.vcmpps
define void @cmp_f32_oeq(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp oeq <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: select_f32_oeq:
; CHECK: knc.vcmpps
define void @select_f32_oeq(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp oeq <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_ogt(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ogt <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_ogt(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ogt <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_oge(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp oge <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_oge(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp oge <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_olt(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp olt <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_olt(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp olt <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_ole(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ole <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_ole(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ole <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_one(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp one <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_one(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp one <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_ord(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ord <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_ord(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ord <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_uno(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp uno <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_uno(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp uno <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_ueq(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ueq <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_ueq(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ueq <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_ugt(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ugt <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_ugt(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ugt <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_uge(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp uge <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_uge(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp uge <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_ult(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ult <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_ult(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ult <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_ule(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ule <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_ule(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp ule <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_une(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp une <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_une(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp une <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f32_true(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp true <16 x float> %x,%y
 %r=sext <16 x i1> %c to <16 x i32>
 store <16 x i32> %r,ptr %out,align 4
 ret void
}
define void @select_f32_true(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %c=fcmp true <16 x float> %x,%y
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @fabs_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %r=call <16 x float> @llvm.fabs.v16f32(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.fabs.v16f32(<16 x float>)
define void @fneg_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %r=fneg <16 x float> %x
 store <16 x float> %r,ptr %out,align 4
 ret void
}
; CHECK-LABEL: minnum_f32:
; CHECK: knc.vcmpps
define void @minnum_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=call <16 x float> @llvm.minnum.v16f32(<16 x float> %x,<16 x float> %y)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.minnum.v16f32(<16 x float>,<16 x float>)
define void @maxnum_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=call <16 x float> @llvm.maxnum.v16f32(<16 x float> %x,<16 x float> %y)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.maxnum.v16f32(<16 x float>,<16 x float>)
define void @minimum_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=call <16 x float> @llvm.minimum.v16f32(<16 x float> %x,<16 x float> %y)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.minimum.v16f32(<16 x float>,<16 x float>)
define void @maximum_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=call <16 x float> @llvm.maximum.v16f32(<16 x float> %x,<16 x float> %y)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.maximum.v16f32(<16 x float>,<16 x float>)
define void @minimumnum_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=call <16 x float> @llvm.minimumnum.v16f32(<16 x float> %x,<16 x float> %y)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.minimumnum.v16f32(<16 x float>,<16 x float>)
define void @maximumnum_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %r=call <16 x float> @llvm.maximumnum.v16f32(<16 x float> %x,<16 x float> %y)
 store <16 x float> %r,ptr %out,align 4
 ret void
}
declare <16 x float> @llvm.maximumnum.v16f32(<16 x float>,<16 x float>)
define void @variable_select_f32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x float>,ptr %a,align 4
 %y=load <16 x float>,ptr %b,align 4
 %mi=load <16 x i32>,ptr %out,align 4
 %c=icmp ne <16 x i32> %mi,zeroinitializer
 %r=select <16 x i1> %c,<16 x float> %x,<16 x float> %y
 store <16 x float> %r,ptr %out,align 4
 ret void
}
define void @cmp_f64_false(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp false <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_false(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp false <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: cmp_f64_oeq:
; CHECK: knc.vcmppd
define void @cmp_f64_oeq(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp oeq <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: select_f64_oeq:
; CHECK: knc.vcmppd
define void @select_f64_oeq(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp oeq <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_ogt(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ogt <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_ogt(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ogt <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_oge(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp oge <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_oge(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp oge <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_olt(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp olt <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_olt(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp olt <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_ole(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ole <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_ole(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ole <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_one(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp one <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_one(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp one <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_ord(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ord <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_ord(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ord <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_uno(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp uno <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_uno(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp uno <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_ueq(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ueq <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_ueq(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ueq <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_ugt(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ugt <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_ugt(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ugt <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_uge(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp uge <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_uge(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp uge <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_ult(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ult <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_ult(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ult <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_ule(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ule <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_ule(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp ule <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_une(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp une <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_une(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp une <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @cmp_f64_true(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp true <8 x double> %x,%y
 %r=sext <8 x i1> %c to <8 x i64>
 store <8 x i64> %r,ptr %out,align 8
 ret void
}
define void @select_f64_true(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %c=fcmp true <8 x double> %x,%y
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
define void @fabs_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %r=call <8 x double> @llvm.fabs.v8f64(<8 x double> %x)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.fabs.v8f64(<8 x double>)
define void @fneg_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %r=fneg <8 x double> %x
 store <8 x double> %r,ptr %out,align 8
 ret void
}
; CHECK-LABEL: minnum_f64:
; CHECK: knc.vcmppd
; CHECK: knc.vblendmpd
define void @minnum_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %r=call <8 x double> @llvm.minnum.v8f64(<8 x double> %x,<8 x double> %y)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.minnum.v8f64(<8 x double>,<8 x double>)
define void @maxnum_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %r=call <8 x double> @llvm.maxnum.v8f64(<8 x double> %x,<8 x double> %y)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.maxnum.v8f64(<8 x double>,<8 x double>)
define void @minimum_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %r=call <8 x double> @llvm.minimum.v8f64(<8 x double> %x,<8 x double> %y)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.minimum.v8f64(<8 x double>,<8 x double>)
define void @maximum_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %r=call <8 x double> @llvm.maximum.v8f64(<8 x double> %x,<8 x double> %y)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.maximum.v8f64(<8 x double>,<8 x double>)
define void @minimumnum_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %r=call <8 x double> @llvm.minimumnum.v8f64(<8 x double> %x,<8 x double> %y)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.minimumnum.v8f64(<8 x double>,<8 x double>)
define void @maximumnum_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %r=call <8 x double> @llvm.maximumnum.v8f64(<8 x double> %x,<8 x double> %y)
 store <8 x double> %r,ptr %out,align 8
 ret void
}
declare <8 x double> @llvm.maximumnum.v8f64(<8 x double>,<8 x double>)
define void @variable_select_f64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x double>,ptr %a,align 8
 %y=load <8 x double>,ptr %b,align 8
 %mi=load <8 x i64>,ptr %out,align 8
 %c=icmp ne <8 x i64> %mi,zeroinitializer
 %r=select <8 x i1> %c,<8 x double> %x,<8 x double> %y
 store <8 x double> %r,ptr %out,align 8
 ret void
}
