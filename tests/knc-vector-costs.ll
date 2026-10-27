; RUN: opt -mcpu=knc -passes='print<cost-model>' -disable-output < %s 2>&1 | FileCheck %s --check-prefix=NEW
; RUN: opt -mcpu=knc -knc-vector-costs=false -passes='print<cost-model>' -disable-output < %s 2>&1 | FileCheck %s --check-prefix=OLD
; RUN: opt -mcpu=knc -knc-optimize-fp-vectors=false -passes='print<cost-model>' -disable-output < %s 2>&1 | FileCheck %s --check-prefix=FALLBACK
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
define void @mixed(ptr %in, ptr %out, <16 x i16> %words, <16 x double> %wide) {
; NEW: cost of 10 for instruction: {{.*}}%a = load <8 x i32>
; OLD: Invalid cost for instruction: {{.*}}%a = load <8 x i32>
 %a = load <8 x i32>, ptr %in, align 4
; NEW: cost of 2 for instruction: {{.*}}%b = sitofp <8 x i32>
; OLD: Invalid cost for instruction: {{.*}}%b = sitofp <8 x i32>
; FALLBACK: Invalid cost for instruction: {{.*}}%b = sitofp <8 x i32>
 %b = sitofp <8 x i32> %a to <8 x double>
; NEW: cost of 2 for instruction: {{.*}}store <8 x double>
 store <8 x double> %b, ptr %out, align 8
; NEW: cost of 3 for instruction: {{.*}}%c = sitofp <16 x i16>
; OLD: Invalid cost for instruction: {{.*}}%c = sitofp <16 x i16>
 %c = sitofp <16 x i16> %words to <16 x float>
 store <16 x float> %c, ptr %out, align 4
; NEW: cost of 2 for instruction: {{.*}}%d = fmul <16 x double>
; OLD: Invalid cost for instruction: {{.*}}%d = fmul <16 x double>
 %d = fmul <16 x double> %wide, %wide
 store <16 x double> %d, ptr %out, align 8
 ret void
}
declare double @llvm.vector.reduce.fadd.v8f64(double, <8 x double>)
define double @reductions(<8 x double> %x) {
; NEW: cost of 26 for instruction: {{.*}}%a = call double @llvm.vector.reduce.fadd.v8f64
; OLD: Invalid cost for instruction: {{.*}}%a = call double @llvm.vector.reduce.fadd.v8f64
; FALLBACK: Invalid cost for instruction: {{.*}}%a = call double @llvm.vector.reduce.fadd.v8f64
 %a = call double @llvm.vector.reduce.fadd.v8f64(double 0.0, <8 x double> %x)
; NEW: cost of 11 for instruction: {{.*}}%b = call reassoc double @llvm.vector.reduce.fadd.v8f64
; OLD: Invalid cost for instruction: {{.*}}%b = call reassoc double @llvm.vector.reduce.fadd.v8f64
 %b = call reassoc double @llvm.vector.reduce.fadd.v8f64(double 0.0, <8 x double> %x)
 %sum = fadd double %a, %b
 ret double %sum
}
declare <8 x float> @llvm.masked.load.v8f32.p0(ptr, i32 immarg, <8 x i1>, <8 x float>)
declare <8 x double> @llvm.masked.load.v8f64.p0(ptr, i32 immarg, <8 x i1>, <8 x double>)
define void @masks(ptr %in, ptr %out, <8 x i1> %mask) {
; NEW: cost of 2 for instruction: {{.*}}%inverse = xor <8 x i1>
; OLD: Invalid cost for instruction: {{.*}}%inverse = xor <8 x i1>
 %inverse = xor <8 x i1> %mask, splat (i1 true)
; NEW: cost of 16 for instruction: {{.*}}%a = call <8 x float> @llvm.masked.load
; OLD: cost of 128 for instruction: {{.*}}%a = call <8 x float> @llvm.masked.load
 %a = call <8 x float> @llvm.masked.load.v8f32.p0(ptr %in, i32 4, <8 x i1> %inverse, <8 x float> zeroinitializer)
 store <8 x float> %a, ptr %out, align 4
; NEW: cost of 72 for instruction: {{.*}}%b = call <8 x double> @llvm.masked.load
; OLD: cost of 128 for instruction: {{.*}}%b = call <8 x double> @llvm.masked.load
 %b = call <8 x double> @llvm.masked.load.v8f64.p0(ptr %in, i32 8, <8 x i1> %mask, <8 x double> zeroinitializer)
 store <8 x double> %b, ptr %out, align 8
 ret void
}
define <8 x double> @expensive_i64(<8 x i64> %x) {
; NEW: Invalid cost for instruction: {{.*}}%y = sitofp <8 x i64>
; OLD: Invalid cost for instruction: {{.*}}%y = sitofp <8 x i64>
 %y = sitofp <8 x i64> %x to <8 x double>
 ret <8 x double> %y
}
