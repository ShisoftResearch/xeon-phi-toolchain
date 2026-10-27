; Scalar IR emitted from tests/clang-autovec-quantized.c with Clang -O1,
; -fno-vectorize -fno-slp-vectorize. No KNC intrinsic or forced VF is used.
; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes='default<O3>' -S < %s | llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs | FileCheck %s
; CHECK-LABEL: auto_q8_dot:
; CHECK: knc.load_s8
; CHECK: knc.vpmulld
; CHECK: knc.vpaddd
; CHECK-LABEL: auto_q8_affine:
; CHECK: knc.load_s8
; CHECK: knc.vpmulld
; CHECK-LABEL: auto_q4_low:
; CHECK: knc.load_u8
; CHECK: knc.vpandd
; CHECK: knc.cvt_i32_f32
; CHECK-LABEL: auto_q4_high:
; CHECK: knc.load_u8
; CHECK: knc.vpsrlvd
; CHECK: knc.cvt_i32_f32
; ModuleID = 'tests/clang-autovec-quantized.c'
source_filename = "tests/clang-autovec-quantized.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @auto_q8_dot(ptr noalias nofree noundef readonly captures(none) %a, ptr noalias nofree noundef readonly captures(none) %b, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp7.not = icmp eq i64 %n, 0
  br i1 %cmp7.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %sum.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.09 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %sum.08 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %a, i64 %i.09
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !9
  %conv = sext i8 %0 to i32
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %b, i64 %i.09
  %1 = load i8, ptr %arrayidx1, align 1, !tbaa !9
  %conv2 = sext i8 %1 to i32
  %mul = mul nsw i32 %conv2, %conv
  %add = add i32 %mul, %sum.08
  %inc = add nuw i64 %i.09, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !10
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_q8_affine(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, i64 noundef %n, i32 noundef %scale, i32 noundef %bias) local_unnamed_addr #1 {
entry:
  %cmp5.not = icmp eq i64 %n, 0
  br i1 %cmp5.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %a, i64 %i.06
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !9
  %conv = sext i8 %0 to i32
  %mul = mul i32 %scale, %conv
  %add = add i32 %mul, %bias
  %arrayidx1 = getelementptr inbounds nuw [4 x i8], ptr %out, i64 %i.06
  store i32 %add, ptr %arrayidx1, align 4, !tbaa !13
  %inc = add nuw i64 %i.06, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !14
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_q4_low(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, i64 noundef %n, float noundef %scale) local_unnamed_addr #1 {
entry:
  %cmp6.not = icmp eq i64 %n, 0
  br i1 %cmp6.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %a, i64 %i.07
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !9
  %1 = and i8 %0, 15
  %and = zext nneg i8 %1 to i32
  %sub = add nsw i32 %and, -8
  %conv1 = sitofp i32 %sub to float
  %mul = fmul float %scale, %conv1
  %arrayidx2 = getelementptr inbounds nuw [4 x i8], ptr %out, i64 %i.07
  store float %mul, ptr %arrayidx2, align 4, !tbaa !15
  %inc = add nuw i64 %i.07, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !17
}

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_q4_high(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, i64 noundef %n, float noundef %scale) local_unnamed_addr #1 {
entry:
  %cmp6.not = icmp eq i64 %n, 0
  br i1 %cmp6.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %a, i64 %i.07
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !9
  %1 = lshr i8 %0, 4
  %shr = zext nneg i8 %1 to i32
  %sub = add nsw i32 %shr, -8
  %conv1 = sitofp i32 %sub to float
  %mul = fmul float %scale, %conv1
  %arrayidx2 = getelementptr inbounds nuw [4 x i8], ptr %out, i64 %i.07
  store float %mul, ptr %arrayidx2, align 4, !tbaa !15
  %inc = add nuw i64 %i.07, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !18
}

attributes #0 = { nofree norecurse noredzone nosync nounwind memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="knc" "target-features"="+cx8,+fxsr,+knc,+knc-native-abi,+soft-float,+x87" }
attributes #1 = { nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="knc" "target-features"="+cx8,+fxsr,+knc,+knc-native-abi,+soft-float,+x87" }

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
!9 = !{!7, !7, i64 0}
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = !{!6, !6, i64 0}
!14 = distinct !{!14, !11, !12}
!15 = !{!16, !16, i64 0}
!16 = !{!"float", !7, i64 0}
!17 = distinct !{!17, !11, !12}
!18 = distinct !{!18, !11, !12}
