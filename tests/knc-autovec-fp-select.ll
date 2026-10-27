; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes='default<O3>' -S < %s | FileCheck %s --check-prefix=VEC
; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes='default<O3>' < %s | llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs | FileCheck %s
; Scalar Clang IR for ordinary ReLU, clamp and ordered selection loops.
; No forced vector width, fast math or target intrinsics.
; VEC-LABEL: define {{.*}}@auto_relu32(
; VEC: fcmp {{[a-z]+}} <16 x float>
; VEC: select <16 x i1>
; CHECK-LABEL: auto_relu32:
; CHECK: knc.vcmpps
; VEC-LABEL: define {{.*}}@auto_clamp32(
; VEC: fcmp {{[a-z]+}} <16 x float>
; VEC: select <16 x i1>
; CHECK-LABEL: auto_clamp32:
; CHECK: knc.vcmpps
; VEC-LABEL: define {{.*}}@auto_choose32(
; VEC: fcmp {{[a-z]+}} <16 x float>
; VEC: select <16 x i1>
; CHECK-LABEL: auto_choose32:
; CHECK: knc.vcmpps
; VEC-LABEL: define {{.*}}@auto_relu64(
; VEC: fcmp {{[a-z]+}} <8 x double>
; VEC: select <8 x i1>
; CHECK-LABEL: auto_relu64:
; CHECK: knc.vcmppd
; VEC-LABEL: define {{.*}}@auto_clamp64(
; VEC: fcmp {{[a-z]+}} <8 x double>
; VEC: select <8 x i1>
; CHECK-LABEL: auto_clamp64:
; CHECK: knc.vcmppd
; VEC-LABEL: define {{.*}}@auto_choose64(
; VEC: fcmp {{[a-z]+}} <8 x double>
; VEC: select <8 x i1>
; CHECK-LABEL: auto_choose64:
; CHECK: knc.vcmppd
; ModuleID = 'tests/clang-fp-select.c'
source_filename = "tests/clang-fp-select.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_relu32(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp9.not = icmp eq i64 %n, 0
  br i1 %cmp9.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.010 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw [4 x i8], ptr %a, i64 %i.010
  %0 = load float, ptr %arrayidx, align 4, !tbaa !9
  %cmp1 = fcmp ogt float %0, 0.000000e+00
  %cond = select i1 %cmp1, float %0, float 0.000000e+00
  %arrayidx3 = getelementptr inbounds nuw [4 x i8], ptr %out, i64 %i.010
  store float %cond, ptr %arrayidx3, align 4, !tbaa !9
  %inc = add nuw i64 %i.010, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !11
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_clamp32(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp14.not = icmp eq i64 %n, 0
  br i1 %cmp14.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.015 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw [4 x i8], ptr %a, i64 %i.015
  %0 = load float, ptr %arrayidx, align 4, !tbaa !9
  %cmp1 = fcmp olt float %0, -1.000000e+00
  %cond = select i1 %cmp1, float -1.000000e+00, float %0
  %cmp2 = fcmp ogt float %cond, 1.000000e+00
  %cond6 = select i1 %cmp2, float 1.000000e+00, float %cond
  %arrayidx7 = getelementptr inbounds nuw [4 x i8], ptr %out, i64 %i.015
  store float %cond6, ptr %arrayidx7, align 4, !tbaa !9
  %inc = add nuw i64 %i.015, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !14
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_choose32(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, ptr noalias nofree noundef readonly captures(none) %b, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp15.not = icmp eq i64 %n, 0
  br i1 %cmp15.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.016 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw [4 x i8], ptr %a, i64 %i.016
  %0 = load float, ptr %arrayidx, align 4, !tbaa !9
  %arrayidx1 = getelementptr inbounds nuw [4 x i8], ptr %b, i64 %i.016
  %1 = load float, ptr %arrayidx1, align 4, !tbaa !9
  %cmp2 = fcmp olt float %0, %1
  %. = select i1 %cmp2, float %0, float %1
  %arrayidx5 = getelementptr inbounds nuw [4 x i8], ptr %out, i64 %i.016
  store float %., ptr %arrayidx5, align 4, !tbaa !9
  %inc = add nuw i64 %i.016, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !15
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_relu64(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp9.not = icmp eq i64 %n, 0
  br i1 %cmp9.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.010 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw [8 x i8], ptr %a, i64 %i.010
  %0 = load double, ptr %arrayidx, align 8, !tbaa !16
  %cmp1 = fcmp ogt double %0, 0.000000e+00
  %cond = select i1 %cmp1, double %0, double 0.000000e+00
  %arrayidx3 = getelementptr inbounds nuw [8 x i8], ptr %out, i64 %i.010
  store double %cond, ptr %arrayidx3, align 8, !tbaa !16
  %inc = add nuw i64 %i.010, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !18
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_clamp64(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp14.not = icmp eq i64 %n, 0
  br i1 %cmp14.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.015 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw [8 x i8], ptr %a, i64 %i.015
  %0 = load double, ptr %arrayidx, align 8, !tbaa !16
  %cmp1 = fcmp olt double %0, -1.000000e+00
  %cond = select i1 %cmp1, double -1.000000e+00, double %0
  %cmp2 = fcmp ogt double %cond, 1.000000e+00
  %cond6 = select i1 %cmp2, double 1.000000e+00, double %cond
  %arrayidx7 = getelementptr inbounds nuw [8 x i8], ptr %out, i64 %i.015
  store double %cond6, ptr %arrayidx7, align 8, !tbaa !16
  %inc = add nuw i64 %i.015, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !19
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_choose64(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, ptr noalias nofree noundef readonly captures(none) %b, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp15.not = icmp eq i64 %n, 0
  br i1 %cmp15.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.016 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw [8 x i8], ptr %a, i64 %i.016
  %0 = load double, ptr %arrayidx, align 8, !tbaa !16
  %arrayidx1 = getelementptr inbounds nuw [8 x i8], ptr %b, i64 %i.016
  %1 = load double, ptr %arrayidx1, align 8, !tbaa !16
  %cmp2 = fcmp olt double %0, %1
  %. = select i1 %cmp2, double %0, double %1
  %arrayidx5 = getelementptr inbounds nuw [8 x i8], ptr %out, i64 %i.016
  store double %., ptr %arrayidx5, align 8, !tbaa !16
  %inc = add nuw i64 %i.016, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !20
}

attributes #0 = { nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="knc" "target-features"="+cx8,+fxsr,+knc,+knc-native-abi,+soft-float,+x87" }

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
!9 = !{!10, !10, i64 0}
!10 = !{!"float", !7, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
!14 = distinct !{!14, !12, !13}
!15 = distinct !{!15, !12, !13}
!16 = !{!17, !17, i64 0}
!17 = !{!"double", !7, i64 0}
!18 = distinct !{!18, !12, !13}
!19 = distinct !{!19, !12, !13}
!20 = distinct !{!20, !12, !13}
