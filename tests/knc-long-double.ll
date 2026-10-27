; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --implicit-check-not=fcomi --implicit-check-not=fucomi --implicit-check-not=fcmov --implicit-check-not=xmm --implicit-check-not=pause
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s --implicit-check-not=fcomi --implicit-check-not=fucomi --implicit-check-not=fcmov --implicit-check-not=xmm --implicit-check-not=pause
; CHECK-LABEL: long_double_iszero:
; CHECK: fldt
; CHECK: fucom
; CHECK: fnstsw
; CHECK: sahf
; CHECK: retq
; CHECK-LABEL: long_double_literal:
; CHECK: fld1
; CHECK: retq
; ModuleID = 'build-libstdcxx/reproducers/long-double.c'
source_filename = "build-libstdcxx/reproducers/long-double.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: mustprogress nofree norecurse noredzone nosync nounwind willreturn memory(none) uwtable
define dso_local range(i32 0, 2) i32 @long_double_iszero(x86_fp80 noundef %x) local_unnamed_addr #0 {
entry:
  %cmp = fcmp oeq x86_fp80 %x, 0.000000e+00
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; Function Attrs: mustprogress nofree norecurse noredzone nosync nounwind willreturn memory(none) uwtable
define dso_local noundef x86_fp80 @long_double_literal() local_unnamed_addr #0 {
entry:
  ret x86_fp80 1.000000e+00
}

attributes #0 = { mustprogress nofree norecurse noredzone nosync nounwind willreturn memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="knc" "target-features"="+cx8,+fxsr,+knc,+knc-native-abi,+knc-scalar-fp,+soft-float,+x87" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}
!llvm.errno.tbaa = !{!4}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"clang version 23.1.5 (https://github.com/llvm/llvm-project.git 395ba2c4d274e0d81bea69a49aba372e3743d113)"}
!4 = !{!5, !6, i64 0}
!5 = !{!"__libc_errno", !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}

; CHECK-LABEL: extend64:
; CHECK: fldl
; CHECK-NOT: call
; CHECK: retq
define x86_fp80 @extend64(double %a) {
 %r = fpext double %a to x86_fp80
 ret x86_fp80 %r
}
; CHECK-LABEL: extend32:
; CHECK: flds
; CHECK-NOT: call
; CHECK: retq
define x86_fp80 @extend32(float %a) {
 %r = fpext float %a to x86_fp80
 ret x86_fp80 %r
}
; CHECK-LABEL: round64:
; CHECK: fstpl
; CHECK-NOT: call
; CHECK: retq
define double @round64(x86_fp80 %a) {
 %r = fptrunc x86_fp80 %a to double
 ret double %r
}
; CHECK-LABEL: round32:
; CHECK: fstps
; CHECK-NOT: call
; CHECK: retq
define float @round32(x86_fp80 %a) {
 %r = fptrunc x86_fp80 %a to float
 ret float %r
}
; CHECK-LABEL: integer_to_extended:
; CHECK: fildll
; CHECK: retq
define x86_fp80 @integer_to_extended(i64 %a) {
 %r = sitofp i64 %a to x86_fp80
 ret x86_fp80 %r
}
; CHECK-LABEL: extended_to_unsigned:
; CHECK: fnstcw
; CHECK: fldcw
; CHECK: fistpll
; CHECK: fldcw
; CHECK: retq
define i64 @extended_to_unsigned(x86_fp80 %a) {
 %r = fptoui x86_fp80 %a to i64
 ret i64 %r
}
; CHECK-LABEL: strict_extend:
; CHECK: fldl
; CHECK: retq
define x86_fp80 @strict_extend(double %a) strictfp {
 %r = call x86_fp80 @llvm.experimental.constrained.fpext.f80.f64(double %a, metadata !"fpexcept.strict")
 ret x86_fp80 %r
}
; CHECK-LABEL: strict_round:
; CHECK: fstpl
; CHECK: retq
define double @strict_round(x86_fp80 %a) strictfp {
 %r = call double @llvm.experimental.constrained.fptrunc.f64.f80(x86_fp80 %a, metadata !"round.dynamic", metadata !"fpexcept.strict")
 ret double %r
}
; CHECK-LABEL: strict_integer:
; CHECK: fistpll
; CHECK: retq
define i64 @strict_integer(x86_fp80 %a) strictfp {
 %r = call i64 @llvm.experimental.constrained.fptosi.i64.f80(x86_fp80 %a, metadata !"fpexcept.strict")
 ret i64 %r
}
; CHECK-LABEL: strict_small_integer:
; CHECK: fistpl
; CHECK: retq
define i8 @strict_small_integer(x86_fp80 %a) strictfp {
 %r = call i8 @llvm.experimental.constrained.fptosi.i8.f80(x86_fp80 %a, metadata !"fpexcept.strict")
 ret i8 %r
}
declare x86_fp80 @llvm.experimental.constrained.fpext.f80.f64(double,metadata)
declare double @llvm.experimental.constrained.fptrunc.f64.f80(x86_fp80,metadata,metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.f80(x86_fp80,metadata)
declare i8 @llvm.experimental.constrained.fptosi.i8.f80(x86_fp80,metadata)
