target triple = "x86_64-unknown-linux-gnu"
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
define void @probe_add_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=add <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=sub <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=mul <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=sdiv <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=udiv <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=srem <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=urem <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=and <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=or <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=xor <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=shl <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=lshr <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=ashr <16 x i8> %x,%y
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.ctpop.v16i8(<16 x i8> %x)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.ctpop.v16i8(<16 x i8>)
define void @probe_ctlz_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.ctlz.v16i8(<16 x i8> %x,i1 false)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.ctlz.v16i8(<16 x i8>,i1 immarg)
define void @probe_cttz_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.cttz.v16i8(<16 x i8> %x,i1 false)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.cttz.v16i8(<16 x i8>,i1 immarg)
define void @probe_bitreverse_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.bitreverse.v16i8(<16 x i8> %x)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.bitreverse.v16i8(<16 x i8>)
define void @probe_abs_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.abs.v16i8(<16 x i8> %x,i1 false)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.abs.v16i8(<16 x i8>,i1 immarg)
define void @probe_smin_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.smin.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.smin.v16i8(<16 x i8>,<16 x i8>)
define void @probe_smax_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.smax.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.smax.v16i8(<16 x i8>,<16 x i8>)
define void @probe_umin_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.umin.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.umin.v16i8(<16 x i8>,<16 x i8>)
define void @probe_umax_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.umax.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.umax.v16i8(<16 x i8>,<16 x i8>)
define void @probe_sadd_sat_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8>,<16 x i8>)
define void @probe_uadd_sat_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8>,<16 x i8>)
define void @probe_ssub_sat_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8>,<16 x i8>)
define void @probe_usub_sat_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.usub.sat.v16i8(<16 x i8>,<16 x i8>)
define void @probe_fshl_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.fshl.v16i8(<16 x i8> %x,<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.fshl.v16i8(<16 x i8>,<16 x i8>,<16 x i8>)
define void @probe_fshr_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %x,<16 x i8> %x,<16 x i8> %y)
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
declare <16 x i8> @llvm.fshr.v16i8(<16 x i8>,<16 x i8>,<16 x i8>)
define void @probe_reduce_add_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.add.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.add.v16i8(<16 x i8>)
define void @probe_reduce_mul_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.mul.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.mul.v16i8(<16 x i8>)
define void @probe_reduce_and_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.and.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.and.v16i8(<16 x i8>)
define void @probe_reduce_or_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.or.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.or.v16i8(<16 x i8>)
define void @probe_reduce_xor_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.xor.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.xor.v16i8(<16 x i8>)
define void @probe_reduce_smin_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.smin.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.smin.v16i8(<16 x i8>)
define void @probe_reduce_smax_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.smax.v16i8(<16 x i8>)
define void @probe_reduce_umin_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.umin.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.umin.v16i8(<16 x i8>)
define void @probe_reduce_umax_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.umax.v16i8(<16 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.umax.v16i8(<16 x i8>)
define void @probe_cmp_sext_eq_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp eq <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ne <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp slt <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp sle <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp sgt <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp sge <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ult <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ule <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ugt <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp uge <16 x i8> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp eq <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ne <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp slt <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp sle <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp sgt <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp sge <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ult <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ule <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp ugt <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v16i8(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %cmp=icmp uge <16 x i8> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i8>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=add <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=sub <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=mul <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=sdiv <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=udiv <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=srem <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=urem <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=and <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=or <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=xor <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=shl <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=lshr <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=ashr <32 x i8> %x,%y
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.ctpop.v32i8(<32 x i8> %x)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.ctpop.v32i8(<32 x i8>)
define void @probe_ctlz_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.ctlz.v32i8(<32 x i8> %x,i1 false)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.ctlz.v32i8(<32 x i8>,i1 immarg)
define void @probe_cttz_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.cttz.v32i8(<32 x i8> %x,i1 false)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.cttz.v32i8(<32 x i8>,i1 immarg)
define void @probe_bitreverse_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.bitreverse.v32i8(<32 x i8> %x)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.bitreverse.v32i8(<32 x i8>)
define void @probe_abs_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.abs.v32i8(<32 x i8> %x,i1 false)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.abs.v32i8(<32 x i8>,i1 immarg)
define void @probe_smin_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.smin.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.smin.v32i8(<32 x i8>,<32 x i8>)
define void @probe_smax_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.smax.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.smax.v32i8(<32 x i8>,<32 x i8>)
define void @probe_umin_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.umin.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.umin.v32i8(<32 x i8>,<32 x i8>)
define void @probe_umax_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.umax.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.umax.v32i8(<32 x i8>,<32 x i8>)
define void @probe_sadd_sat_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.sadd.sat.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.sadd.sat.v32i8(<32 x i8>,<32 x i8>)
define void @probe_uadd_sat_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.uadd.sat.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.uadd.sat.v32i8(<32 x i8>,<32 x i8>)
define void @probe_ssub_sat_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.ssub.sat.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.ssub.sat.v32i8(<32 x i8>,<32 x i8>)
define void @probe_usub_sat_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.usub.sat.v32i8(<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.usub.sat.v32i8(<32 x i8>,<32 x i8>)
define void @probe_fshl_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.fshl.v32i8(<32 x i8> %x,<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.fshl.v32i8(<32 x i8>,<32 x i8>,<32 x i8>)
define void @probe_fshr_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %x,<32 x i8> %x,<32 x i8> %y)
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
declare <32 x i8> @llvm.fshr.v32i8(<32 x i8>,<32 x i8>,<32 x i8>)
define void @probe_reduce_add_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.add.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.add.v32i8(<32 x i8>)
define void @probe_reduce_mul_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.mul.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.mul.v32i8(<32 x i8>)
define void @probe_reduce_and_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.and.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.and.v32i8(<32 x i8>)
define void @probe_reduce_or_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.or.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.or.v32i8(<32 x i8>)
define void @probe_reduce_xor_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.xor.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.xor.v32i8(<32 x i8>)
define void @probe_reduce_smin_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.smin.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.smin.v32i8(<32 x i8>)
define void @probe_reduce_smax_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.smax.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.smax.v32i8(<32 x i8>)
define void @probe_reduce_umin_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.umin.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.umin.v32i8(<32 x i8>)
define void @probe_reduce_umax_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.umax.v32i8(<32 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.umax.v32i8(<32 x i8>)
define void @probe_cmp_sext_eq_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp eq <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ne <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp slt <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp sle <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp sgt <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp sge <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ult <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ule <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ugt <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp uge <32 x i8> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp eq <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ne <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp slt <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp sle <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp sgt <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp sge <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ult <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ule <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp ugt <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v32i8(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %cmp=icmp uge <32 x i8> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i8>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=add <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=sub <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=mul <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=sdiv <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=udiv <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=srem <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=urem <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=and <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=or <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=xor <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=shl <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=lshr <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=ashr <64 x i8> %x,%y
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.ctpop.v64i8(<64 x i8> %x)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.ctpop.v64i8(<64 x i8>)
define void @probe_ctlz_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.ctlz.v64i8(<64 x i8> %x,i1 false)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.ctlz.v64i8(<64 x i8>,i1 immarg)
define void @probe_cttz_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.cttz.v64i8(<64 x i8> %x,i1 false)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.cttz.v64i8(<64 x i8>,i1 immarg)
define void @probe_bitreverse_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.bitreverse.v64i8(<64 x i8> %x)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.bitreverse.v64i8(<64 x i8>)
define void @probe_abs_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.abs.v64i8(<64 x i8> %x,i1 false)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.abs.v64i8(<64 x i8>,i1 immarg)
define void @probe_smin_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.smin.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.smin.v64i8(<64 x i8>,<64 x i8>)
define void @probe_smax_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.smax.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.smax.v64i8(<64 x i8>,<64 x i8>)
define void @probe_umin_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.umin.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.umin.v64i8(<64 x i8>,<64 x i8>)
define void @probe_umax_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.umax.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.umax.v64i8(<64 x i8>,<64 x i8>)
define void @probe_sadd_sat_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.sadd.sat.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.sadd.sat.v64i8(<64 x i8>,<64 x i8>)
define void @probe_uadd_sat_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.uadd.sat.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.uadd.sat.v64i8(<64 x i8>,<64 x i8>)
define void @probe_ssub_sat_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.ssub.sat.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.ssub.sat.v64i8(<64 x i8>,<64 x i8>)
define void @probe_usub_sat_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.usub.sat.v64i8(<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.usub.sat.v64i8(<64 x i8>,<64 x i8>)
define void @probe_fshl_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.fshl.v64i8(<64 x i8> %x,<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.fshl.v64i8(<64 x i8>,<64 x i8>,<64 x i8>)
define void @probe_fshr_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %x,<64 x i8> %x,<64 x i8> %y)
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
declare <64 x i8> @llvm.fshr.v64i8(<64 x i8>,<64 x i8>,<64 x i8>)
define void @probe_reduce_add_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.add.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.add.v64i8(<64 x i8>)
define void @probe_reduce_mul_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.mul.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.mul.v64i8(<64 x i8>)
define void @probe_reduce_and_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.and.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.and.v64i8(<64 x i8>)
define void @probe_reduce_or_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.or.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.or.v64i8(<64 x i8>)
define void @probe_reduce_xor_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.xor.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.xor.v64i8(<64 x i8>)
define void @probe_reduce_smin_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.smin.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.smin.v64i8(<64 x i8>)
define void @probe_reduce_smax_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.smax.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.smax.v64i8(<64 x i8>)
define void @probe_reduce_umin_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.umin.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.umin.v64i8(<64 x i8>)
define void @probe_reduce_umax_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %r=call i8 @llvm.vector.reduce.umax.v64i8(<64 x i8> %x)
 store i8 %r,ptr %out,align 1
 ret void
}
declare i8 @llvm.vector.reduce.umax.v64i8(<64 x i8>)
define void @probe_cmp_sext_eq_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp eq <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ne <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp slt <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp sle <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp sgt <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp sge <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ult <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ule <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ugt <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp uge <64 x i8> %x,%y
 %r=sext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp eq <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ne <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp slt <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp sle <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp sgt <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp sge <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ult <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ule <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp ugt <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v64i8(ptr %out,ptr %a,ptr %b) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %cmp=icmp uge <64 x i8> %x,%y
 %r=zext <64 x i1> %cmp to <64 x i8>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=add <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=sub <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=mul <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=sdiv <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=udiv <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=srem <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=urem <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=and <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=or <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=xor <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=shl <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=lshr <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=ashr <8 x i16> %x,%y
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.ctpop.v8i16(<8 x i16> %x)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.ctpop.v8i16(<8 x i16>)
define void @probe_ctlz_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.ctlz.v8i16(<8 x i16> %x,i1 false)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.ctlz.v8i16(<8 x i16>,i1 immarg)
define void @probe_cttz_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.cttz.v8i16(<8 x i16> %x,i1 false)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.cttz.v8i16(<8 x i16>,i1 immarg)
define void @probe_bitreverse_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.bitreverse.v8i16(<8 x i16> %x)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.bitreverse.v8i16(<8 x i16>)
define void @probe_bswap_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %x)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.bswap.v8i16(<8 x i16>)
define void @probe_abs_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.abs.v8i16(<8 x i16> %x,i1 false)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.abs.v8i16(<8 x i16>,i1 immarg)
define void @probe_smin_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.smin.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.smin.v8i16(<8 x i16>,<8 x i16>)
define void @probe_smax_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.smax.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.smax.v8i16(<8 x i16>,<8 x i16>)
define void @probe_umin_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.umin.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.umin.v8i16(<8 x i16>,<8 x i16>)
define void @probe_umax_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.umax.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.umax.v8i16(<8 x i16>,<8 x i16>)
define void @probe_sadd_sat_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16>,<8 x i16>)
define void @probe_uadd_sat_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16>,<8 x i16>)
define void @probe_ssub_sat_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16>,<8 x i16>)
define void @probe_usub_sat_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.usub.sat.v8i16(<8 x i16>,<8 x i16>)
define void @probe_fshl_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.fshl.v8i16(<8 x i16> %x,<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.fshl.v8i16(<8 x i16>,<8 x i16>,<8 x i16>)
define void @probe_fshr_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call <8 x i16> @llvm.fshr.v8i16(<8 x i16> %x,<8 x i16> %x,<8 x i16> %y)
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
declare <8 x i16> @llvm.fshr.v8i16(<8 x i16>,<8 x i16>,<8 x i16>)
define void @probe_reduce_add_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.add.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.add.v8i16(<8 x i16>)
define void @probe_reduce_mul_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.mul.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.mul.v8i16(<8 x i16>)
define void @probe_reduce_and_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.and.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.and.v8i16(<8 x i16>)
define void @probe_reduce_or_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.or.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.or.v8i16(<8 x i16>)
define void @probe_reduce_xor_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.xor.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.xor.v8i16(<8 x i16>)
define void @probe_reduce_smin_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.smin.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.smin.v8i16(<8 x i16>)
define void @probe_reduce_smax_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.smax.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.smax.v8i16(<8 x i16>)
define void @probe_reduce_umin_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.umin.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.umin.v8i16(<8 x i16>)
define void @probe_reduce_umax_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.umax.v8i16(<8 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.umax.v8i16(<8 x i16>)
define void @probe_cmp_sext_eq_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp eq <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ne <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp slt <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp sle <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp sgt <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp sge <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ult <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ule <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ugt <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp uge <8 x i16> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp eq <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ne <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp slt <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp sle <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp sgt <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp sge <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ult <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ule <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp ugt <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v8i16(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %cmp=icmp uge <8 x i16> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i16>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=add <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=sub <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=mul <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=sdiv <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=udiv <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=srem <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=urem <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=and <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=or <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=xor <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=shl <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=lshr <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=ashr <16 x i16> %x,%y
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.ctpop.v16i16(<16 x i16> %x)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.ctpop.v16i16(<16 x i16>)
define void @probe_ctlz_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.ctlz.v16i16(<16 x i16> %x,i1 false)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.ctlz.v16i16(<16 x i16>,i1 immarg)
define void @probe_cttz_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.cttz.v16i16(<16 x i16> %x,i1 false)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.cttz.v16i16(<16 x i16>,i1 immarg)
define void @probe_bitreverse_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.bitreverse.v16i16(<16 x i16> %x)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.bitreverse.v16i16(<16 x i16>)
define void @probe_bswap_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %x)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.bswap.v16i16(<16 x i16>)
define void @probe_abs_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.abs.v16i16(<16 x i16> %x,i1 false)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.abs.v16i16(<16 x i16>,i1 immarg)
define void @probe_smin_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.smin.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.smin.v16i16(<16 x i16>,<16 x i16>)
define void @probe_smax_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.smax.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.smax.v16i16(<16 x i16>,<16 x i16>)
define void @probe_umin_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.umin.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.umin.v16i16(<16 x i16>,<16 x i16>)
define void @probe_umax_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.umax.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.umax.v16i16(<16 x i16>,<16 x i16>)
define void @probe_sadd_sat_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16>,<16 x i16>)
define void @probe_uadd_sat_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16>,<16 x i16>)
define void @probe_ssub_sat_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16>,<16 x i16>)
define void @probe_usub_sat_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.usub.sat.v16i16(<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.usub.sat.v16i16(<16 x i16>,<16 x i16>)
define void @probe_fshl_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.fshl.v16i16(<16 x i16> %x,<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.fshl.v16i16(<16 x i16>,<16 x i16>,<16 x i16>)
define void @probe_fshr_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call <16 x i16> @llvm.fshr.v16i16(<16 x i16> %x,<16 x i16> %x,<16 x i16> %y)
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.fshr.v16i16(<16 x i16>,<16 x i16>,<16 x i16>)
define void @probe_reduce_add_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.add.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.add.v16i16(<16 x i16>)
define void @probe_reduce_mul_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.mul.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.mul.v16i16(<16 x i16>)
define void @probe_reduce_and_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.and.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.and.v16i16(<16 x i16>)
define void @probe_reduce_or_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.or.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.or.v16i16(<16 x i16>)
define void @probe_reduce_xor_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.xor.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.xor.v16i16(<16 x i16>)
define void @probe_reduce_smin_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.smin.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.smin.v16i16(<16 x i16>)
define void @probe_reduce_smax_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.smax.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.smax.v16i16(<16 x i16>)
define void @probe_reduce_umin_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.umin.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.umin.v16i16(<16 x i16>)
define void @probe_reduce_umax_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.umax.v16i16(<16 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.umax.v16i16(<16 x i16>)
define void @probe_cmp_sext_eq_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp eq <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ne <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp slt <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp sle <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp sgt <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp sge <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ult <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ule <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ugt <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp uge <16 x i16> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp eq <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ne <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp slt <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp sle <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp sgt <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp sge <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ult <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ule <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp ugt <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v16i16(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %cmp=icmp uge <16 x i16> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i16>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=add <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=sub <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=mul <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=sdiv <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=udiv <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=srem <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=urem <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=and <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=or <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=xor <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=shl <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=lshr <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=ashr <32 x i16> %x,%y
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.ctpop.v32i16(<32 x i16> %x)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.ctpop.v32i16(<32 x i16>)
define void @probe_ctlz_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.ctlz.v32i16(<32 x i16> %x,i1 false)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.ctlz.v32i16(<32 x i16>,i1 immarg)
define void @probe_cttz_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.cttz.v32i16(<32 x i16> %x,i1 false)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.cttz.v32i16(<32 x i16>,i1 immarg)
define void @probe_bitreverse_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.bitreverse.v32i16(<32 x i16> %x)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.bitreverse.v32i16(<32 x i16>)
define void @probe_bswap_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %x)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.bswap.v32i16(<32 x i16>)
define void @probe_abs_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.abs.v32i16(<32 x i16> %x,i1 false)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.abs.v32i16(<32 x i16>,i1 immarg)
define void @probe_smin_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.smin.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.smin.v32i16(<32 x i16>,<32 x i16>)
define void @probe_smax_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.smax.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.smax.v32i16(<32 x i16>,<32 x i16>)
define void @probe_umin_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.umin.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.umin.v32i16(<32 x i16>,<32 x i16>)
define void @probe_umax_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.umax.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.umax.v32i16(<32 x i16>,<32 x i16>)
define void @probe_sadd_sat_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16>,<32 x i16>)
define void @probe_uadd_sat_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16>,<32 x i16>)
define void @probe_ssub_sat_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16>,<32 x i16>)
define void @probe_usub_sat_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.usub.sat.v32i16(<32 x i16>,<32 x i16>)
define void @probe_fshl_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.fshl.v32i16(<32 x i16> %x,<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.fshl.v32i16(<32 x i16>,<32 x i16>,<32 x i16>)
define void @probe_fshr_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %x,<32 x i16> %x,<32 x i16> %y)
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
declare <32 x i16> @llvm.fshr.v32i16(<32 x i16>,<32 x i16>,<32 x i16>)
define void @probe_reduce_add_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.add.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.add.v32i16(<32 x i16>)
define void @probe_reduce_mul_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.mul.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.mul.v32i16(<32 x i16>)
define void @probe_reduce_and_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.and.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.and.v32i16(<32 x i16>)
define void @probe_reduce_or_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.or.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.or.v32i16(<32 x i16>)
define void @probe_reduce_xor_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.xor.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.xor.v32i16(<32 x i16>)
define void @probe_reduce_smin_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.smin.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.smin.v32i16(<32 x i16>)
define void @probe_reduce_smax_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.smax.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.smax.v32i16(<32 x i16>)
define void @probe_reduce_umin_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.umin.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.umin.v32i16(<32 x i16>)
define void @probe_reduce_umax_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %r=call i16 @llvm.vector.reduce.umax.v32i16(<32 x i16> %x)
 store i16 %r,ptr %out,align 1
 ret void
}
declare i16 @llvm.vector.reduce.umax.v32i16(<32 x i16>)
define void @probe_cmp_sext_eq_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp eq <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ne <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp slt <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp sle <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp sgt <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp sge <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ult <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ule <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ugt <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp uge <32 x i16> %x,%y
 %r=sext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp eq <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ne <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp slt <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp sle <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp sgt <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp sge <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ult <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ule <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp ugt <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v32i16(ptr %out,ptr %a,ptr %b) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %cmp=icmp uge <32 x i16> %x,%y
 %r=zext <32 x i1> %cmp to <32 x i16>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=add <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=sub <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=mul <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=sdiv <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=udiv <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=srem <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=urem <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=and <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=or <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=xor <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=shl <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=lshr <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=ashr <4 x i32> %x,%y
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.ctpop.v4i32(<4 x i32> %x)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.ctpop.v4i32(<4 x i32>)
define void @probe_ctlz_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.ctlz.v4i32(<4 x i32> %x,i1 false)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.ctlz.v4i32(<4 x i32>,i1 immarg)
define void @probe_cttz_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.cttz.v4i32(<4 x i32> %x,i1 false)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.cttz.v4i32(<4 x i32>,i1 immarg)
define void @probe_bitreverse_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.bitreverse.v4i32(<4 x i32> %x)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.bitreverse.v4i32(<4 x i32>)
define void @probe_bswap_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %x)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.bswap.v4i32(<4 x i32>)
define void @probe_abs_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.abs.v4i32(<4 x i32> %x,i1 false)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.abs.v4i32(<4 x i32>,i1 immarg)
define void @probe_smin_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.smin.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.smin.v4i32(<4 x i32>,<4 x i32>)
define void @probe_smax_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.smax.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.smax.v4i32(<4 x i32>,<4 x i32>)
define void @probe_umin_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.umin.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.umin.v4i32(<4 x i32>,<4 x i32>)
define void @probe_umax_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.umax.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.umax.v4i32(<4 x i32>,<4 x i32>)
define void @probe_sadd_sat_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32>,<4 x i32>)
define void @probe_uadd_sat_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32>,<4 x i32>)
define void @probe_ssub_sat_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32>,<4 x i32>)
define void @probe_usub_sat_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.usub.sat.v4i32(<4 x i32>,<4 x i32>)
define void @probe_fshl_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x,<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>,<4 x i32>,<4 x i32>)
define void @probe_fshr_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x,<4 x i32> %x,<4 x i32> %y)
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
declare <4 x i32> @llvm.fshr.v4i32(<4 x i32>,<4 x i32>,<4 x i32>)
define void @probe_reduce_add_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
define void @probe_reduce_mul_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.mul.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.mul.v4i32(<4 x i32>)
define void @probe_reduce_and_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.and.v4i32(<4 x i32>)
define void @probe_reduce_or_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.or.v4i32(<4 x i32>)
define void @probe_reduce_xor_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.xor.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.xor.v4i32(<4 x i32>)
define void @probe_reduce_smin_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.smin.v4i32(<4 x i32>)
define void @probe_reduce_smax_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.smax.v4i32(<4 x i32>)
define void @probe_reduce_umin_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.umin.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.umin.v4i32(<4 x i32>)
define void @probe_reduce_umax_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.umax.v4i32(<4 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.umax.v4i32(<4 x i32>)
define void @probe_cmp_sext_eq_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp eq <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ne <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp slt <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp sle <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp sgt <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp sge <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ult <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ule <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ugt <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp uge <4 x i32> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp eq <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ne <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp slt <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp sle <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp sgt <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp sge <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ult <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ule <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp ugt <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v4i32(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %cmp=icmp uge <4 x i32> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i32>
 store <4 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=add <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=sub <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=mul <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=sdiv <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=udiv <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=srem <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=urem <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=and <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=or <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=xor <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=shl <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=lshr <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=ashr <8 x i32> %x,%y
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.ctpop.v8i32(<8 x i32> %x)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.ctpop.v8i32(<8 x i32>)
define void @probe_ctlz_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.ctlz.v8i32(<8 x i32> %x,i1 false)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.ctlz.v8i32(<8 x i32>,i1 immarg)
define void @probe_cttz_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.cttz.v8i32(<8 x i32> %x,i1 false)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.cttz.v8i32(<8 x i32>,i1 immarg)
define void @probe_bitreverse_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.bitreverse.v8i32(<8 x i32> %x)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.bitreverse.v8i32(<8 x i32>)
define void @probe_bswap_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %x)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.bswap.v8i32(<8 x i32>)
define void @probe_abs_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.abs.v8i32(<8 x i32> %x,i1 false)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.abs.v8i32(<8 x i32>,i1 immarg)
define void @probe_smin_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.smin.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.smin.v8i32(<8 x i32>,<8 x i32>)
define void @probe_smax_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.smax.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.smax.v8i32(<8 x i32>,<8 x i32>)
define void @probe_umin_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.umin.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.umin.v8i32(<8 x i32>,<8 x i32>)
define void @probe_umax_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.umax.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.umax.v8i32(<8 x i32>,<8 x i32>)
define void @probe_sadd_sat_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32>,<8 x i32>)
define void @probe_uadd_sat_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.uadd.sat.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.uadd.sat.v8i32(<8 x i32>,<8 x i32>)
define void @probe_ssub_sat_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32>,<8 x i32>)
define void @probe_usub_sat_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.usub.sat.v8i32(<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.usub.sat.v8i32(<8 x i32>,<8 x i32>)
define void @probe_fshl_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.fshl.v8i32(<8 x i32> %x,<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.fshl.v8i32(<8 x i32>,<8 x i32>,<8 x i32>)
define void @probe_fshr_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call <8 x i32> @llvm.fshr.v8i32(<8 x i32> %x,<8 x i32> %x,<8 x i32> %y)
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
declare <8 x i32> @llvm.fshr.v8i32(<8 x i32>,<8 x i32>,<8 x i32>)
define void @probe_reduce_add_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.add.v8i32(<8 x i32>)
define void @probe_reduce_mul_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.mul.v8i32(<8 x i32>)
define void @probe_reduce_and_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.and.v8i32(<8 x i32>)
define void @probe_reduce_or_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.or.v8i32(<8 x i32>)
define void @probe_reduce_xor_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.xor.v8i32(<8 x i32>)
define void @probe_reduce_smin_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.smin.v8i32(<8 x i32>)
define void @probe_reduce_smax_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.smax.v8i32(<8 x i32>)
define void @probe_reduce_umin_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.umin.v8i32(<8 x i32>)
define void @probe_reduce_umax_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.umax.v8i32(<8 x i32>)
define void @probe_cmp_sext_eq_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp eq <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ne <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp slt <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp sle <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp sgt <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp sge <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ult <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ule <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ugt <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp uge <8 x i32> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp eq <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ne <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp slt <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp sle <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp sgt <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp sge <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ult <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ule <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp ugt <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v8i32(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %cmp=icmp uge <8 x i32> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i32>
 store <8 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=add <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=sub <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=mul <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=sdiv <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=udiv <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=srem <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=urem <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=and <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=or <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=xor <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=shl <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=lshr <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=ashr <16 x i32> %x,%y
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.ctpop.v16i32(<16 x i32> %x)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.ctpop.v16i32(<16 x i32>)
define void @probe_ctlz_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.ctlz.v16i32(<16 x i32> %x,i1 false)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.ctlz.v16i32(<16 x i32>,i1 immarg)
define void @probe_cttz_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.cttz.v16i32(<16 x i32> %x,i1 false)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.cttz.v16i32(<16 x i32>,i1 immarg)
define void @probe_bitreverse_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.bitreverse.v16i32(<16 x i32> %x)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.bitreverse.v16i32(<16 x i32>)
define void @probe_bswap_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %x)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.bswap.v16i32(<16 x i32>)
define void @probe_abs_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.abs.v16i32(<16 x i32> %x,i1 false)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.abs.v16i32(<16 x i32>,i1 immarg)
define void @probe_smin_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.smin.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.smin.v16i32(<16 x i32>,<16 x i32>)
define void @probe_smax_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.smax.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.smax.v16i32(<16 x i32>,<16 x i32>)
define void @probe_umin_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.umin.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.umin.v16i32(<16 x i32>,<16 x i32>)
define void @probe_umax_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.umax.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.umax.v16i32(<16 x i32>,<16 x i32>)
define void @probe_sadd_sat_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32>,<16 x i32>)
define void @probe_uadd_sat_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.uadd.sat.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.uadd.sat.v16i32(<16 x i32>,<16 x i32>)
define void @probe_ssub_sat_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32>,<16 x i32>)
define void @probe_usub_sat_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.usub.sat.v16i32(<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.usub.sat.v16i32(<16 x i32>,<16 x i32>)
define void @probe_fshl_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.fshl.v16i32(<16 x i32> %x,<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.fshl.v16i32(<16 x i32>,<16 x i32>,<16 x i32>)
define void @probe_fshr_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %x,<16 x i32> %x,<16 x i32> %y)
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
declare <16 x i32> @llvm.fshr.v16i32(<16 x i32>,<16 x i32>,<16 x i32>)
define void @probe_reduce_add_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.add.v16i32(<16 x i32>)
define void @probe_reduce_mul_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.mul.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.mul.v16i32(<16 x i32>)
define void @probe_reduce_and_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.and.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.and.v16i32(<16 x i32>)
define void @probe_reduce_or_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.or.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.or.v16i32(<16 x i32>)
define void @probe_reduce_xor_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.xor.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.xor.v16i32(<16 x i32>)
define void @probe_reduce_smin_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.smin.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.smin.v16i32(<16 x i32>)
define void @probe_reduce_smax_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.smax.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.smax.v16i32(<16 x i32>)
define void @probe_reduce_umin_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.umin.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.umin.v16i32(<16 x i32>)
define void @probe_reduce_umax_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %r=call i32 @llvm.vector.reduce.umax.v16i32(<16 x i32> %x)
 store i32 %r,ptr %out,align 1
 ret void
}
declare i32 @llvm.vector.reduce.umax.v16i32(<16 x i32>)
define void @probe_cmp_sext_eq_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp eq <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ne <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp slt <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp sle <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp sgt <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp sge <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ult <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ule <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ugt <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp uge <16 x i32> %x,%y
 %r=sext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp eq <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ne <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp slt <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp sle <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp sgt <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp sge <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ult <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ule <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp ugt <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v16i32(ptr %out,ptr %a,ptr %b) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %cmp=icmp uge <16 x i32> %x,%y
 %r=zext <16 x i1> %cmp to <16 x i32>
 store <16 x i32> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=add <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=sub <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=mul <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=sdiv <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=udiv <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=srem <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=urem <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=and <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=or <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=xor <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=shl <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=lshr <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=ashr <2 x i64> %x,%y
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.ctpop.v2i64(<2 x i64> %x)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.ctpop.v2i64(<2 x i64>)
define void @probe_ctlz_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.ctlz.v2i64(<2 x i64> %x,i1 false)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.ctlz.v2i64(<2 x i64>,i1 immarg)
define void @probe_cttz_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %x,i1 false)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.cttz.v2i64(<2 x i64>,i1 immarg)
define void @probe_bitreverse_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %x)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.bitreverse.v2i64(<2 x i64>)
define void @probe_bswap_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %x)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.bswap.v2i64(<2 x i64>)
define void @probe_abs_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.abs.v2i64(<2 x i64> %x,i1 false)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.abs.v2i64(<2 x i64>,i1 immarg)
define void @probe_smin_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.smin.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.smin.v2i64(<2 x i64>,<2 x i64>)
define void @probe_smax_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.smax.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.smax.v2i64(<2 x i64>,<2 x i64>)
define void @probe_umin_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.umin.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.umin.v2i64(<2 x i64>,<2 x i64>)
define void @probe_umax_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.umax.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.umax.v2i64(<2 x i64>,<2 x i64>)
define void @probe_sadd_sat_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64>,<2 x i64>)
define void @probe_uadd_sat_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64>,<2 x i64>)
define void @probe_ssub_sat_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64>,<2 x i64>)
define void @probe_usub_sat_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.usub.sat.v2i64(<2 x i64>,<2 x i64>)
define void @probe_fshl_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.fshl.v2i64(<2 x i64> %x,<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.fshl.v2i64(<2 x i64>,<2 x i64>,<2 x i64>)
define void @probe_fshr_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call <2 x i64> @llvm.fshr.v2i64(<2 x i64> %x,<2 x i64> %x,<2 x i64> %y)
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
declare <2 x i64> @llvm.fshr.v2i64(<2 x i64>,<2 x i64>,<2 x i64>)
define void @probe_reduce_add_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>)
define void @probe_reduce_mul_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.mul.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.mul.v2i64(<2 x i64>)
define void @probe_reduce_and_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.and.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.and.v2i64(<2 x i64>)
define void @probe_reduce_or_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.or.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.or.v2i64(<2 x i64>)
define void @probe_reduce_xor_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.xor.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.xor.v2i64(<2 x i64>)
define void @probe_reduce_smin_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.smin.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.smin.v2i64(<2 x i64>)
define void @probe_reduce_smax_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.smax.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.smax.v2i64(<2 x i64>)
define void @probe_reduce_umin_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.umin.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.umin.v2i64(<2 x i64>)
define void @probe_reduce_umax_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.umax.v2i64(<2 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.umax.v2i64(<2 x i64>)
define void @probe_cmp_sext_eq_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp eq <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ne <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp slt <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp sle <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp sgt <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp sge <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ult <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ule <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ugt <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp uge <2 x i64> %x,%y
 %r=sext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp eq <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ne <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp slt <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp sle <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp sgt <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp sge <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ult <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ule <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp ugt <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v2i64(ptr %out,ptr %a,ptr %b) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=load <2 x i64>,ptr %b,align 1
 %cmp=icmp uge <2 x i64> %x,%y
 %r=zext <2 x i1> %cmp to <2 x i64>
 store <2 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=add <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=sub <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=mul <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=sdiv <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=udiv <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=srem <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=urem <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=and <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=or <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=xor <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=shl <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=lshr <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=ashr <4 x i64> %x,%y
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.ctpop.v4i64(<4 x i64> %x)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.ctpop.v4i64(<4 x i64>)
define void @probe_ctlz_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.ctlz.v4i64(<4 x i64> %x,i1 false)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.ctlz.v4i64(<4 x i64>,i1 immarg)
define void @probe_cttz_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.cttz.v4i64(<4 x i64> %x,i1 false)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.cttz.v4i64(<4 x i64>,i1 immarg)
define void @probe_bitreverse_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.bitreverse.v4i64(<4 x i64> %x)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.bitreverse.v4i64(<4 x i64>)
define void @probe_bswap_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %x)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.bswap.v4i64(<4 x i64>)
define void @probe_abs_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.abs.v4i64(<4 x i64> %x,i1 false)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.abs.v4i64(<4 x i64>,i1 immarg)
define void @probe_smin_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.smin.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.smin.v4i64(<4 x i64>,<4 x i64>)
define void @probe_smax_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.smax.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.smax.v4i64(<4 x i64>,<4 x i64>)
define void @probe_umin_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.umin.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.umin.v4i64(<4 x i64>,<4 x i64>)
define void @probe_umax_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.umax.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.umax.v4i64(<4 x i64>,<4 x i64>)
define void @probe_sadd_sat_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.sadd.sat.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.sadd.sat.v4i64(<4 x i64>,<4 x i64>)
define void @probe_uadd_sat_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.uadd.sat.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.uadd.sat.v4i64(<4 x i64>,<4 x i64>)
define void @probe_ssub_sat_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.ssub.sat.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.ssub.sat.v4i64(<4 x i64>,<4 x i64>)
define void @probe_usub_sat_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.usub.sat.v4i64(<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.usub.sat.v4i64(<4 x i64>,<4 x i64>)
define void @probe_fshl_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.fshl.v4i64(<4 x i64> %x,<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.fshl.v4i64(<4 x i64>,<4 x i64>,<4 x i64>)
define void @probe_fshr_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call <4 x i64> @llvm.fshr.v4i64(<4 x i64> %x,<4 x i64> %x,<4 x i64> %y)
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
declare <4 x i64> @llvm.fshr.v4i64(<4 x i64>,<4 x i64>,<4 x i64>)
define void @probe_reduce_add_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.add.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.add.v4i64(<4 x i64>)
define void @probe_reduce_mul_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.mul.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.mul.v4i64(<4 x i64>)
define void @probe_reduce_and_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.and.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.and.v4i64(<4 x i64>)
define void @probe_reduce_or_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.or.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.or.v4i64(<4 x i64>)
define void @probe_reduce_xor_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.xor.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.xor.v4i64(<4 x i64>)
define void @probe_reduce_smin_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.smin.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.smin.v4i64(<4 x i64>)
define void @probe_reduce_smax_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.smax.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.smax.v4i64(<4 x i64>)
define void @probe_reduce_umin_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.umin.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.umin.v4i64(<4 x i64>)
define void @probe_reduce_umax_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.umax.v4i64(<4 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.umax.v4i64(<4 x i64>)
define void @probe_cmp_sext_eq_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp eq <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ne <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp slt <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp sle <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp sgt <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp sge <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ult <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ule <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ugt <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp uge <4 x i64> %x,%y
 %r=sext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp eq <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ne <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp slt <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp sle <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp sgt <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp sge <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ult <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ule <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp ugt <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v4i64(ptr %out,ptr %a,ptr %b) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=load <4 x i64>,ptr %b,align 1
 %cmp=icmp uge <4 x i64> %x,%y
 %r=zext <4 x i1> %cmp to <4 x i64>
 store <4 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_add_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=add <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_sub_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=sub <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_mul_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=mul <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_sdiv_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=sdiv <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_udiv_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=udiv <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_srem_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=srem <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_urem_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=urem <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_and_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=and <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_or_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=or <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_xor_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=xor <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_shl_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=shl <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_lshr_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=lshr <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_ashr_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=ashr <8 x i64> %x,%y
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_ctpop_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.ctpop.v8i64(<8 x i64> %x)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.ctpop.v8i64(<8 x i64>)
define void @probe_ctlz_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.ctlz.v8i64(<8 x i64> %x,i1 false)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.ctlz.v8i64(<8 x i64>,i1 immarg)
define void @probe_cttz_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.cttz.v8i64(<8 x i64> %x,i1 false)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.cttz.v8i64(<8 x i64>,i1 immarg)
define void @probe_bitreverse_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.bitreverse.v8i64(<8 x i64> %x)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.bitreverse.v8i64(<8 x i64>)
define void @probe_bswap_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %x)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.bswap.v8i64(<8 x i64>)
define void @probe_abs_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.abs.v8i64(<8 x i64> %x,i1 false)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.abs.v8i64(<8 x i64>,i1 immarg)
define void @probe_smin_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.smin.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.smin.v8i64(<8 x i64>,<8 x i64>)
define void @probe_smax_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.smax.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.smax.v8i64(<8 x i64>,<8 x i64>)
define void @probe_umin_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.umin.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.umin.v8i64(<8 x i64>,<8 x i64>)
define void @probe_umax_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.umax.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.umax.v8i64(<8 x i64>,<8 x i64>)
define void @probe_sadd_sat_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.sadd.sat.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.sadd.sat.v8i64(<8 x i64>,<8 x i64>)
define void @probe_uadd_sat_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.uadd.sat.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.uadd.sat.v8i64(<8 x i64>,<8 x i64>)
define void @probe_ssub_sat_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.ssub.sat.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.ssub.sat.v8i64(<8 x i64>,<8 x i64>)
define void @probe_usub_sat_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.usub.sat.v8i64(<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.usub.sat.v8i64(<8 x i64>,<8 x i64>)
define void @probe_fshl_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.fshl.v8i64(<8 x i64> %x,<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.fshl.v8i64(<8 x i64>,<8 x i64>,<8 x i64>)
define void @probe_fshr_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %x,<8 x i64> %x,<8 x i64> %y)
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
declare <8 x i64> @llvm.fshr.v8i64(<8 x i64>,<8 x i64>,<8 x i64>)
define void @probe_reduce_add_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.add.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.add.v8i64(<8 x i64>)
define void @probe_reduce_mul_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.mul.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.mul.v8i64(<8 x i64>)
define void @probe_reduce_and_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.and.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.and.v8i64(<8 x i64>)
define void @probe_reduce_or_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.or.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.or.v8i64(<8 x i64>)
define void @probe_reduce_xor_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.xor.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.xor.v8i64(<8 x i64>)
define void @probe_reduce_smin_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.smin.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.smin.v8i64(<8 x i64>)
define void @probe_reduce_smax_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.smax.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.smax.v8i64(<8 x i64>)
define void @probe_reduce_umin_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.umin.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.umin.v8i64(<8 x i64>)
define void @probe_reduce_umax_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %r=call i64 @llvm.vector.reduce.umax.v8i64(<8 x i64> %x)
 store i64 %r,ptr %out,align 1
 ret void
}
declare i64 @llvm.vector.reduce.umax.v8i64(<8 x i64>)
define void @probe_cmp_sext_eq_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp eq <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ne_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ne <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_slt_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp slt <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sle_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp sle <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sgt_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp sgt <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_sge_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp sge <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ult_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ult <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ule_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ule <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_ugt_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ugt <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_sext_uge_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp uge <8 x i64> %x,%y
 %r=sext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_eq_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp eq <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ne_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ne <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_slt_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp slt <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sle_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp sle <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sgt_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp sgt <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_sge_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp sge <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ult_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ult <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ule_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ule <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_ugt_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp ugt <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
define void @probe_cmp_zext_uge_v8i64(ptr %out,ptr %a,ptr %b) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=load <8 x i64>,ptr %b,align 1
 %cmp=icmp uge <8 x i64> %x,%y
 %r=zext <8 x i1> %cmp to <8 x i64>
 store <8 x i64> %r,ptr %out,align 1
 ret void
}
