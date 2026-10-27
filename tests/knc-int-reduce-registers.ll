; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --check-prefix=REGS
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --check-prefix=REGS
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -knc-int-reduce-registers=false -verify-machineinstrs < %s | FileCheck %s --check-prefix=SPILL

target triple = "x86_64-unknown-linux-gnu"
; REGS-LABEL: add_to_float:
; REGS-NOT: (%rsp)
; REGS: knc.cvt_i32_f32
; REGS-NOT: (%rsp)
; REGS: retq
; SPILL-LABEL: add_to_float:
; SPILL: knc.vbroadcastss
; SPILL: knc.cvt_i32_f32
 define float @add_to_float(<16 x i32> %x) {
  %s = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %x)
  %r = sitofp i32 %s to float
  ret float %r
}
; REGS-LABEL: pair_add_to_double:
; REGS-NOT: (%rsp)
; REGS: knc.vcvtdq2pd
; REGS-NOT: (%rsp)
; REGS: retq
 define double @pair_add_to_double(<16 x i32> %x, <16 x i32> %y) {
  %a = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %x)
  %b = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %y)
  %s = add i32 %a, %b
  %r = sitofp i32 %s to double
  ret double %r
}
; REGS-LABEL: pair_sub_to_unsigned_float:
; REGS-NOT: (%rsp)
; REGS: knc.cvt_u32_f32
; REGS-NOT: (%rsp)
; REGS: retq
 define float @pair_sub_to_unsigned_float(<16 x i32> %x, <16 x i32> %y) {
  %a = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %x)
  %b = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %y)
  %s = sub i32 %a, %b
  %r = uitofp i32 %s to float
  ret float %r
}
; REGS-LABEL: mixed_users:
; REGS-NOT: knc.vbroadcastss
; REGS: knc.cvt_i32_f32
; REGS-NOT: knc.vbroadcastss
; REGS: retq
 define float @mixed_users(<16 x i32> %x, ptr %out) {
  %s = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %x)
  store i32 %s, ptr %out
  %r = sitofp i32 %s to float
  ret float %r
}
declare i32 @llvm.vector.reduce.add.v16i32(<16 x i32>)
