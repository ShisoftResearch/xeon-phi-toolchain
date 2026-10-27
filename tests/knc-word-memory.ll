; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
; CHECK-LABEL: word_extend_s:
; CHECK: knc.load_s16
; CHECK: knc.loadh_s16
define void @word_extend_s(ptr %out,ptr %in){
 %x=load <16 x i16>,ptr %in,align 2
 %y=sext <16 x i16> %x to <16 x i32>
 store <16 x i32> %y,ptr %out,align 4
 ret void
}
; CHECK-LABEL: word_extend_u:
; CHECK: knc.load_u16
; CHECK: knc.loadh_u16
define void @word_extend_u(ptr %out,ptr %in){
 %x=load <16 x i16>,ptr %in,align 2
 %y=zext <16 x i16> %x to <16 x i32>
 store <16 x i32> %y,ptr %out,align 4
 ret void
}
; CHECK-LABEL: word_truncate:
; CHECK: knc.vpandd
; CHECK: knc.store_u16
; CHECK: knc.storeh_u16
define void @word_truncate(ptr %out,ptr %in){
 %x=load <16 x i32>,ptr %in,align 4
 %y=trunc <16 x i32> %x to <16 x i16>
 store <16 x i16> %y,ptr %out,align 2
 ret void
}
