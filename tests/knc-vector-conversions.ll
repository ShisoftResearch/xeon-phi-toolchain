; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,-knc-native-abi -verify-machineinstrs < %s -o /dev/null
; Exercises folded extending loads, scalar fallback, native i32/f32 conversions,
; and split/widen legalization. Pointer ABI permits independent SDK harnesses.
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: convert_fpext_f32_f64_2:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtps2pd
; CHECK-NOT: callq
define void @convert_fpext_f32_f64_2(ptr %out, ptr %in) {
 %x = load <2 x float>, ptr %in, align 4
 %r = fpext <2 x float> %x to <2 x double>
 store <2 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fpext_f32_f64_4:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtps2pd
; CHECK-NOT: callq
define void @convert_fpext_f32_f64_4(ptr %out, ptr %in) {
 %x = load <4 x float>, ptr %in, align 4
 %r = fpext <4 x float> %x to <4 x double>
 store <4 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fpext_f32_f64_8:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtps2pd
; CHECK-NOT: callq
define void @convert_fpext_f32_f64_8(ptr %out, ptr %in) {
 %x = load <8 x float>, ptr %in, align 4
 %r = fpext <8 x float> %x to <8 x double>
 store <8 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fpext_f32_f64_16:
; CHECK-NOT: callq
; CHECK-COUNT-2: knc.vcvtps2pd
; CHECK-NOT: callq
define void @convert_fpext_f32_f64_16(ptr %out, ptr %in) {
 %x = load <16 x float>, ptr %in, align 4
 %r = fpext <16 x float> %x to <16 x double>
 store <16 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fpext_f32_f64_32:
; CHECK-NOT: callq
; CHECK-COUNT-4: knc.vcvtps2pd
; CHECK-NOT: callq
define void @convert_fpext_f32_f64_32(ptr %out, ptr %in) {
 %x = load <32 x float>, ptr %in, align 4
 %r = fpext <32 x float> %x to <32 x double>
 store <32 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptrunc_f64_f32_2:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtpd2ps
; CHECK-NOT: callq
define void @convert_fptrunc_f64_f32_2(ptr %out, ptr %in) {
 %x = load <2 x double>, ptr %in, align 8
 %r = fptrunc <2 x double> %x to <2 x float>
 store <2 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptrunc_f64_f32_4:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtpd2ps
; CHECK-NOT: callq
define void @convert_fptrunc_f64_f32_4(ptr %out, ptr %in) {
 %x = load <4 x double>, ptr %in, align 8
 %r = fptrunc <4 x double> %x to <4 x float>
 store <4 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptrunc_f64_f32_8:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtpd2ps
; CHECK-NOT: callq
define void @convert_fptrunc_f64_f32_8(ptr %out, ptr %in) {
 %x = load <8 x double>, ptr %in, align 8
 %r = fptrunc <8 x double> %x to <8 x float>
 store <8 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptrunc_f64_f32_16:
; CHECK-NOT: callq
; CHECK-COUNT-2: knc.vcvtpd2ps
; CHECK-NOT: callq
define void @convert_fptrunc_f64_f32_16(ptr %out, ptr %in) {
 %x = load <16 x double>, ptr %in, align 8
 %r = fptrunc <16 x double> %x to <16 x float>
 store <16 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptrunc_f64_f32_32:
; CHECK-NOT: callq
; CHECK-COUNT-4: knc.vcvtpd2ps
; CHECK-NOT: callq
define void @convert_fptrunc_f64_f32_32(ptr %out, ptr %in) {
 %x = load <32 x double>, ptr %in, align 8
 %r = fptrunc <32 x double> %x to <32 x float>
 store <32 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f32_2:
define void @convert_sitofp_i32_f32_2(ptr %out, ptr %in) {
 %x = load <2 x i32>, ptr %in, align 4
 %r = sitofp <2 x i32> %x to <2 x float>
 store <2 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f32_4:
define void @convert_sitofp_i32_f32_4(ptr %out, ptr %in) {
 %x = load <4 x i32>, ptr %in, align 4
 %r = sitofp <4 x i32> %x to <4 x float>
 store <4 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f32_8:
define void @convert_sitofp_i32_f32_8(ptr %out, ptr %in) {
 %x = load <8 x i32>, ptr %in, align 4
 %r = sitofp <8 x i32> %x to <8 x float>
 store <8 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f32_16:
define void @convert_sitofp_i32_f32_16(ptr %out, ptr %in) {
 %x = load <16 x i32>, ptr %in, align 4
 %r = sitofp <16 x i32> %x to <16 x float>
 store <16 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f32_32:
define void @convert_sitofp_i32_f32_32(ptr %out, ptr %in) {
 %x = load <32 x i32>, ptr %in, align 4
 %r = sitofp <32 x i32> %x to <32 x float>
 store <32 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f64_2:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtdq2pd
; CHECK-NOT: callq
define void @convert_sitofp_i32_f64_2(ptr %out, ptr %in) {
 %x = load <2 x i32>, ptr %in, align 4
 %r = sitofp <2 x i32> %x to <2 x double>
 store <2 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f64_4:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtdq2pd
; CHECK-NOT: callq
define void @convert_sitofp_i32_f64_4(ptr %out, ptr %in) {
 %x = load <4 x i32>, ptr %in, align 4
 %r = sitofp <4 x i32> %x to <4 x double>
 store <4 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f64_8:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtdq2pd
; CHECK-NOT: callq
define void @convert_sitofp_i32_f64_8(ptr %out, ptr %in) {
 %x = load <8 x i32>, ptr %in, align 4
 %r = sitofp <8 x i32> %x to <8 x double>
 store <8 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f64_16:
; CHECK-NOT: callq
; CHECK-COUNT-2: knc.vcvtdq2pd
; CHECK-NOT: callq
define void @convert_sitofp_i32_f64_16(ptr %out, ptr %in) {
 %x = load <16 x i32>, ptr %in, align 4
 %r = sitofp <16 x i32> %x to <16 x double>
 store <16 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i32_f64_32:
; CHECK-NOT: callq
; CHECK-COUNT-4: knc.vcvtdq2pd
; CHECK-NOT: callq
define void @convert_sitofp_i32_f64_32(ptr %out, ptr %in) {
 %x = load <32 x i32>, ptr %in, align 4
 %r = sitofp <32 x i32> %x to <32 x double>
 store <32 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f32_2:
define void @convert_sitofp_i64_f32_2(ptr %out, ptr %in) {
 %x = load <2 x i64>, ptr %in, align 8
 %r = sitofp <2 x i64> %x to <2 x float>
 store <2 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f32_4:
define void @convert_sitofp_i64_f32_4(ptr %out, ptr %in) {
 %x = load <4 x i64>, ptr %in, align 8
 %r = sitofp <4 x i64> %x to <4 x float>
 store <4 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f32_8:
define void @convert_sitofp_i64_f32_8(ptr %out, ptr %in) {
 %x = load <8 x i64>, ptr %in, align 8
 %r = sitofp <8 x i64> %x to <8 x float>
 store <8 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f32_16:
define void @convert_sitofp_i64_f32_16(ptr %out, ptr %in) {
 %x = load <16 x i64>, ptr %in, align 8
 %r = sitofp <16 x i64> %x to <16 x float>
 store <16 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f32_32:
define void @convert_sitofp_i64_f32_32(ptr %out, ptr %in) {
 %x = load <32 x i64>, ptr %in, align 8
 %r = sitofp <32 x i64> %x to <32 x float>
 store <32 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f64_2:
define void @convert_sitofp_i64_f64_2(ptr %out, ptr %in) {
 %x = load <2 x i64>, ptr %in, align 8
 %r = sitofp <2 x i64> %x to <2 x double>
 store <2 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f64_4:
define void @convert_sitofp_i64_f64_4(ptr %out, ptr %in) {
 %x = load <4 x i64>, ptr %in, align 8
 %r = sitofp <4 x i64> %x to <4 x double>
 store <4 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f64_8:
define void @convert_sitofp_i64_f64_8(ptr %out, ptr %in) {
 %x = load <8 x i64>, ptr %in, align 8
 %r = sitofp <8 x i64> %x to <8 x double>
 store <8 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f64_16:
define void @convert_sitofp_i64_f64_16(ptr %out, ptr %in) {
 %x = load <16 x i64>, ptr %in, align 8
 %r = sitofp <16 x i64> %x to <16 x double>
 store <16 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_sitofp_i64_f64_32:
define void @convert_sitofp_i64_f64_32(ptr %out, ptr %in) {
 %x = load <32 x i64>, ptr %in, align 8
 %r = sitofp <32 x i64> %x to <32 x double>
 store <32 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f32_2:
define void @convert_uitofp_i32_f32_2(ptr %out, ptr %in) {
 %x = load <2 x i32>, ptr %in, align 4
 %r = uitofp <2 x i32> %x to <2 x float>
 store <2 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f32_4:
define void @convert_uitofp_i32_f32_4(ptr %out, ptr %in) {
 %x = load <4 x i32>, ptr %in, align 4
 %r = uitofp <4 x i32> %x to <4 x float>
 store <4 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f32_8:
define void @convert_uitofp_i32_f32_8(ptr %out, ptr %in) {
 %x = load <8 x i32>, ptr %in, align 4
 %r = uitofp <8 x i32> %x to <8 x float>
 store <8 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f32_16:
define void @convert_uitofp_i32_f32_16(ptr %out, ptr %in) {
 %x = load <16 x i32>, ptr %in, align 4
 %r = uitofp <16 x i32> %x to <16 x float>
 store <16 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f32_32:
define void @convert_uitofp_i32_f32_32(ptr %out, ptr %in) {
 %x = load <32 x i32>, ptr %in, align 4
 %r = uitofp <32 x i32> %x to <32 x float>
 store <32 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f64_2:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtudq2pd
; CHECK-NOT: callq
define void @convert_uitofp_i32_f64_2(ptr %out, ptr %in) {
 %x = load <2 x i32>, ptr %in, align 4
 %r = uitofp <2 x i32> %x to <2 x double>
 store <2 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f64_4:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtudq2pd
; CHECK-NOT: callq
define void @convert_uitofp_i32_f64_4(ptr %out, ptr %in) {
 %x = load <4 x i32>, ptr %in, align 4
 %r = uitofp <4 x i32> %x to <4 x double>
 store <4 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f64_8:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtudq2pd
; CHECK-NOT: callq
define void @convert_uitofp_i32_f64_8(ptr %out, ptr %in) {
 %x = load <8 x i32>, ptr %in, align 4
 %r = uitofp <8 x i32> %x to <8 x double>
 store <8 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f64_16:
; CHECK-NOT: callq
; CHECK-COUNT-2: knc.vcvtudq2pd
; CHECK-NOT: callq
define void @convert_uitofp_i32_f64_16(ptr %out, ptr %in) {
 %x = load <16 x i32>, ptr %in, align 4
 %r = uitofp <16 x i32> %x to <16 x double>
 store <16 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i32_f64_32:
; CHECK-NOT: callq
; CHECK-COUNT-4: knc.vcvtudq2pd
; CHECK-NOT: callq
define void @convert_uitofp_i32_f64_32(ptr %out, ptr %in) {
 %x = load <32 x i32>, ptr %in, align 4
 %r = uitofp <32 x i32> %x to <32 x double>
 store <32 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f32_2:
define void @convert_uitofp_i64_f32_2(ptr %out, ptr %in) {
 %x = load <2 x i64>, ptr %in, align 8
 %r = uitofp <2 x i64> %x to <2 x float>
 store <2 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f32_4:
define void @convert_uitofp_i64_f32_4(ptr %out, ptr %in) {
 %x = load <4 x i64>, ptr %in, align 8
 %r = uitofp <4 x i64> %x to <4 x float>
 store <4 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f32_8:
define void @convert_uitofp_i64_f32_8(ptr %out, ptr %in) {
 %x = load <8 x i64>, ptr %in, align 8
 %r = uitofp <8 x i64> %x to <8 x float>
 store <8 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f32_16:
define void @convert_uitofp_i64_f32_16(ptr %out, ptr %in) {
 %x = load <16 x i64>, ptr %in, align 8
 %r = uitofp <16 x i64> %x to <16 x float>
 store <16 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f32_32:
define void @convert_uitofp_i64_f32_32(ptr %out, ptr %in) {
 %x = load <32 x i64>, ptr %in, align 8
 %r = uitofp <32 x i64> %x to <32 x float>
 store <32 x float> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f64_2:
define void @convert_uitofp_i64_f64_2(ptr %out, ptr %in) {
 %x = load <2 x i64>, ptr %in, align 8
 %r = uitofp <2 x i64> %x to <2 x double>
 store <2 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f64_4:
define void @convert_uitofp_i64_f64_4(ptr %out, ptr %in) {
 %x = load <4 x i64>, ptr %in, align 8
 %r = uitofp <4 x i64> %x to <4 x double>
 store <4 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f64_8:
define void @convert_uitofp_i64_f64_8(ptr %out, ptr %in) {
 %x = load <8 x i64>, ptr %in, align 8
 %r = uitofp <8 x i64> %x to <8 x double>
 store <8 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f64_16:
define void @convert_uitofp_i64_f64_16(ptr %out, ptr %in) {
 %x = load <16 x i64>, ptr %in, align 8
 %r = uitofp <16 x i64> %x to <16 x double>
 store <16 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_uitofp_i64_f64_32:
define void @convert_uitofp_i64_f64_32(ptr %out, ptr %in) {
 %x = load <32 x i64>, ptr %in, align 8
 %r = uitofp <32 x i64> %x to <32 x double>
 store <32 x double> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i32_2:
define void @convert_fptosi_f32_i32_2(ptr %out, ptr %in) {
 %x = load <2 x float>, ptr %in, align 4
 %r = fptosi <2 x float> %x to <2 x i32>
 store <2 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i32_4:
define void @convert_fptosi_f32_i32_4(ptr %out, ptr %in) {
 %x = load <4 x float>, ptr %in, align 4
 %r = fptosi <4 x float> %x to <4 x i32>
 store <4 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i32_8:
define void @convert_fptosi_f32_i32_8(ptr %out, ptr %in) {
 %x = load <8 x float>, ptr %in, align 4
 %r = fptosi <8 x float> %x to <8 x i32>
 store <8 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i32_16:
define void @convert_fptosi_f32_i32_16(ptr %out, ptr %in) {
 %x = load <16 x float>, ptr %in, align 4
 %r = fptosi <16 x float> %x to <16 x i32>
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i32_32:
define void @convert_fptosi_f32_i32_32(ptr %out, ptr %in) {
 %x = load <32 x float>, ptr %in, align 4
 %r = fptosi <32 x float> %x to <32 x i32>
 store <32 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i64_2:
define void @convert_fptosi_f32_i64_2(ptr %out, ptr %in) {
 %x = load <2 x float>, ptr %in, align 4
 %r = fptosi <2 x float> %x to <2 x i64>
 store <2 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i64_4:
define void @convert_fptosi_f32_i64_4(ptr %out, ptr %in) {
 %x = load <4 x float>, ptr %in, align 4
 %r = fptosi <4 x float> %x to <4 x i64>
 store <4 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i64_8:
define void @convert_fptosi_f32_i64_8(ptr %out, ptr %in) {
 %x = load <8 x float>, ptr %in, align 4
 %r = fptosi <8 x float> %x to <8 x i64>
 store <8 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i64_16:
define void @convert_fptosi_f32_i64_16(ptr %out, ptr %in) {
 %x = load <16 x float>, ptr %in, align 4
 %r = fptosi <16 x float> %x to <16 x i64>
 store <16 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f32_i64_32:
define void @convert_fptosi_f32_i64_32(ptr %out, ptr %in) {
 %x = load <32 x float>, ptr %in, align 4
 %r = fptosi <32 x float> %x to <32 x i64>
 store <32 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i32_2:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtfxpntpd2dq
; CHECK-NOT: callq
define void @convert_fptosi_f64_i32_2(ptr %out, ptr %in) {
 %x = load <2 x double>, ptr %in, align 8
 %r = fptosi <2 x double> %x to <2 x i32>
 store <2 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i32_4:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtfxpntpd2dq
; CHECK-NOT: callq
define void @convert_fptosi_f64_i32_4(ptr %out, ptr %in) {
 %x = load <4 x double>, ptr %in, align 8
 %r = fptosi <4 x double> %x to <4 x i32>
 store <4 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i32_8:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtfxpntpd2dq
; CHECK-NOT: callq
define void @convert_fptosi_f64_i32_8(ptr %out, ptr %in) {
 %x = load <8 x double>, ptr %in, align 8
 %r = fptosi <8 x double> %x to <8 x i32>
 store <8 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i32_16:
; CHECK-NOT: callq
; CHECK-COUNT-2: knc.vcvtfxpntpd2dq
; CHECK-NOT: callq
define void @convert_fptosi_f64_i32_16(ptr %out, ptr %in) {
 %x = load <16 x double>, ptr %in, align 8
 %r = fptosi <16 x double> %x to <16 x i32>
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i32_32:
; CHECK-NOT: callq
; CHECK-COUNT-4: knc.vcvtfxpntpd2dq
; CHECK-NOT: callq
define void @convert_fptosi_f64_i32_32(ptr %out, ptr %in) {
 %x = load <32 x double>, ptr %in, align 8
 %r = fptosi <32 x double> %x to <32 x i32>
 store <32 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i64_2:
define void @convert_fptosi_f64_i64_2(ptr %out, ptr %in) {
 %x = load <2 x double>, ptr %in, align 8
 %r = fptosi <2 x double> %x to <2 x i64>
 store <2 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i64_4:
define void @convert_fptosi_f64_i64_4(ptr %out, ptr %in) {
 %x = load <4 x double>, ptr %in, align 8
 %r = fptosi <4 x double> %x to <4 x i64>
 store <4 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i64_8:
define void @convert_fptosi_f64_i64_8(ptr %out, ptr %in) {
 %x = load <8 x double>, ptr %in, align 8
 %r = fptosi <8 x double> %x to <8 x i64>
 store <8 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i64_16:
define void @convert_fptosi_f64_i64_16(ptr %out, ptr %in) {
 %x = load <16 x double>, ptr %in, align 8
 %r = fptosi <16 x double> %x to <16 x i64>
 store <16 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptosi_f64_i64_32:
define void @convert_fptosi_f64_i64_32(ptr %out, ptr %in) {
 %x = load <32 x double>, ptr %in, align 8
 %r = fptosi <32 x double> %x to <32 x i64>
 store <32 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i32_2:
define void @convert_fptoui_f32_i32_2(ptr %out, ptr %in) {
 %x = load <2 x float>, ptr %in, align 4
 %r = fptoui <2 x float> %x to <2 x i32>
 store <2 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i32_4:
define void @convert_fptoui_f32_i32_4(ptr %out, ptr %in) {
 %x = load <4 x float>, ptr %in, align 4
 %r = fptoui <4 x float> %x to <4 x i32>
 store <4 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i32_8:
define void @convert_fptoui_f32_i32_8(ptr %out, ptr %in) {
 %x = load <8 x float>, ptr %in, align 4
 %r = fptoui <8 x float> %x to <8 x i32>
 store <8 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i32_16:
define void @convert_fptoui_f32_i32_16(ptr %out, ptr %in) {
 %x = load <16 x float>, ptr %in, align 4
 %r = fptoui <16 x float> %x to <16 x i32>
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i32_32:
define void @convert_fptoui_f32_i32_32(ptr %out, ptr %in) {
 %x = load <32 x float>, ptr %in, align 4
 %r = fptoui <32 x float> %x to <32 x i32>
 store <32 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i64_2:
define void @convert_fptoui_f32_i64_2(ptr %out, ptr %in) {
 %x = load <2 x float>, ptr %in, align 4
 %r = fptoui <2 x float> %x to <2 x i64>
 store <2 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i64_4:
define void @convert_fptoui_f32_i64_4(ptr %out, ptr %in) {
 %x = load <4 x float>, ptr %in, align 4
 %r = fptoui <4 x float> %x to <4 x i64>
 store <4 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i64_8:
define void @convert_fptoui_f32_i64_8(ptr %out, ptr %in) {
 %x = load <8 x float>, ptr %in, align 4
 %r = fptoui <8 x float> %x to <8 x i64>
 store <8 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i64_16:
define void @convert_fptoui_f32_i64_16(ptr %out, ptr %in) {
 %x = load <16 x float>, ptr %in, align 4
 %r = fptoui <16 x float> %x to <16 x i64>
 store <16 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f32_i64_32:
define void @convert_fptoui_f32_i64_32(ptr %out, ptr %in) {
 %x = load <32 x float>, ptr %in, align 4
 %r = fptoui <32 x float> %x to <32 x i64>
 store <32 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i32_2:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtfxpntpd2udq
; CHECK-NOT: callq
define void @convert_fptoui_f64_i32_2(ptr %out, ptr %in) {
 %x = load <2 x double>, ptr %in, align 8
 %r = fptoui <2 x double> %x to <2 x i32>
 store <2 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i32_4:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtfxpntpd2udq
; CHECK-NOT: callq
define void @convert_fptoui_f64_i32_4(ptr %out, ptr %in) {
 %x = load <4 x double>, ptr %in, align 8
 %r = fptoui <4 x double> %x to <4 x i32>
 store <4 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i32_8:
; CHECK-NOT: callq
; CHECK-COUNT-1: knc.vcvtfxpntpd2udq
; CHECK-NOT: callq
define void @convert_fptoui_f64_i32_8(ptr %out, ptr %in) {
 %x = load <8 x double>, ptr %in, align 8
 %r = fptoui <8 x double> %x to <8 x i32>
 store <8 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i32_16:
; CHECK-NOT: callq
; CHECK-COUNT-2: knc.vcvtfxpntpd2udq
; CHECK-NOT: callq
define void @convert_fptoui_f64_i32_16(ptr %out, ptr %in) {
 %x = load <16 x double>, ptr %in, align 8
 %r = fptoui <16 x double> %x to <16 x i32>
 store <16 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i32_32:
; CHECK-NOT: callq
; CHECK-COUNT-4: knc.vcvtfxpntpd2udq
; CHECK-NOT: callq
define void @convert_fptoui_f64_i32_32(ptr %out, ptr %in) {
 %x = load <32 x double>, ptr %in, align 8
 %r = fptoui <32 x double> %x to <32 x i32>
 store <32 x i32> %r, ptr %out, align 4
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i64_2:
define void @convert_fptoui_f64_i64_2(ptr %out, ptr %in) {
 %x = load <2 x double>, ptr %in, align 8
 %r = fptoui <2 x double> %x to <2 x i64>
 store <2 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i64_4:
define void @convert_fptoui_f64_i64_4(ptr %out, ptr %in) {
 %x = load <4 x double>, ptr %in, align 8
 %r = fptoui <4 x double> %x to <4 x i64>
 store <4 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i64_8:
define void @convert_fptoui_f64_i64_8(ptr %out, ptr %in) {
 %x = load <8 x double>, ptr %in, align 8
 %r = fptoui <8 x double> %x to <8 x i64>
 store <8 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i64_16:
define void @convert_fptoui_f64_i64_16(ptr %out, ptr %in) {
 %x = load <16 x double>, ptr %in, align 8
 %r = fptoui <16 x double> %x to <16 x i64>
 store <16 x i64> %r, ptr %out, align 8
 ret void
}
; CHECK-LABEL: convert_fptoui_f64_i64_32:
define void @convert_fptoui_f64_i64_32(ptr %out, ptr %in) {
 %x = load <32 x double>, ptr %in, align 8
 %r = fptoui <32 x double> %x to <32 x i64>
 store <32 x i64> %r, ptr %out, align 8
 ret void
}
