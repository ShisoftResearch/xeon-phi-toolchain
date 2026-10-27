; Ordinary scalar loop emitted from tests/clang-predicated.c at -O1.
; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes='default<O3>' -S < %s | llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs | FileCheck %s
; CHECK-LABEL: auto_predicated:
; CHECK: knc.vpgatherdd
; CHECK: knc.vpgatherdd
; CHECK: knc.vpscatterdd
; ModuleID = 'tests/clang-predicated.c'
source_filename = "tests/clang-predicated.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nofree norecurse noredzone nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @auto_predicated(ptr noalias nofree noundef writeonly captures(none) %out, ptr noalias nofree noundef readonly captures(none) %a, ptr noalias nofree noundef readonly captures(none) %b, ptr noalias nofree noundef readonly captures(none) %mask, i64 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp9.not = icmp eq i64 %n, 0
  br i1 %cmp9.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.inc, %entry
  ret void

for.body:                                         ; preds = %entry, %for.inc
  %i.010 = phi i64 [ %inc, %for.inc ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw [4 x i8], ptr %mask, i64 %i.010
  %0 = load i32, ptr %arrayidx, align 4, !tbaa !9
  %tobool.not = icmp eq i32 %0, 0
  br i1 %tobool.not, label %for.inc, label %if.then

if.then:                                          ; preds = %for.body
  %arrayidx1 = getelementptr inbounds nuw [4 x i8], ptr %a, i64 %i.010
  %1 = load i32, ptr %arrayidx1, align 4, !tbaa !9
  %mul = mul i32 %1, 3
  %arrayidx2 = getelementptr inbounds nuw [4 x i8], ptr %b, i64 %i.010
  %2 = load i32, ptr %arrayidx2, align 4, !tbaa !9
  %add = add i32 %mul, %2
  %arrayidx3 = getelementptr inbounds nuw [4 x i8], ptr %out, i64 %i.010
  store i32 %add, ptr %arrayidx3, align 4, !tbaa !9
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %inc = add nuw i64 %i.010, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !10
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
!9 = !{!6, !6, i64 0}
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
