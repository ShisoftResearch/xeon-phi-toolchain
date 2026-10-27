; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
define void @q_extend_s_8_16_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i8>,ptr %a,align 1
 %y=sext <2 x i8> %x to <2 x i16>
 store <2 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_16_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i8>,ptr %a,align 1
 %y=zext <2 x i8> %x to <2 x i16>
 store <2 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_16_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i8>,ptr %a,align 1
 %y=sext <4 x i8> %x to <4 x i16>
 store <4 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_16_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i8>,ptr %a,align 1
 %y=zext <4 x i8> %x to <4 x i16>
 store <4 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_16_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i8>,ptr %a,align 1
 %y=sext <8 x i8> %x to <8 x i16>
 store <8 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_16_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i8>,ptr %a,align 1
 %y=zext <8 x i8> %x to <8 x i16>
 store <8 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=sext <16 x i8> %x to <16 x i16>
 store <16 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=zext <16 x i8> %x to <16 x i16>
 store <16 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=sext <32 x i8> %x to <32 x i16>
 store <32 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=zext <32 x i8> %x to <32 x i16>
 store <32 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_32_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i8>,ptr %a,align 1
 %y=sext <2 x i8> %x to <2 x i32>
 store <2 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_32_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i8>,ptr %a,align 1
 %y=zext <2 x i8> %x to <2 x i32>
 store <2 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_32_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i8>,ptr %a,align 1
 %y=sext <4 x i8> %x to <4 x i32>
 store <4 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_32_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i8>,ptr %a,align 1
 %y=zext <4 x i8> %x to <4 x i32>
 store <4 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_32_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i8>,ptr %a,align 1
 %y=sext <8 x i8> %x to <8 x i32>
 store <8 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_32_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i8>,ptr %a,align 1
 %y=zext <8 x i8> %x to <8 x i32>
 store <8 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_32_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=sext <16 x i8> %x to <16 x i32>
 store <16 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_32_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=zext <16 x i8> %x to <16 x i32>
 store <16 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_32_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=sext <32 x i8> %x to <32 x i32>
 store <32 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_32_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=zext <32 x i8> %x to <32 x i32>
 store <32 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_64_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i8>,ptr %a,align 1
 %y=sext <2 x i8> %x to <2 x i64>
 store <2 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_64_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i8>,ptr %a,align 1
 %y=zext <2 x i8> %x to <2 x i64>
 store <2 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_64_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i8>,ptr %a,align 1
 %y=sext <4 x i8> %x to <4 x i64>
 store <4 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_64_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i8>,ptr %a,align 1
 %y=zext <4 x i8> %x to <4 x i64>
 store <4 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_64_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i8>,ptr %a,align 1
 %y=sext <8 x i8> %x to <8 x i64>
 store <8 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_64_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i8>,ptr %a,align 1
 %y=zext <8 x i8> %x to <8 x i64>
 store <8 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_64_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=sext <16 x i8> %x to <16 x i64>
 store <16 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_64_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=zext <16 x i8> %x to <16 x i64>
 store <16 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_8_64_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=sext <32 x i8> %x to <32 x i64>
 store <32 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_8_64_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=zext <32 x i8> %x to <32 x i64>
 store <32 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_32_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i16>,ptr %a,align 1
 %y=sext <2 x i16> %x to <2 x i32>
 store <2 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_32_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i16>,ptr %a,align 1
 %y=zext <2 x i16> %x to <2 x i32>
 store <2 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_32_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i16>,ptr %a,align 1
 %y=sext <4 x i16> %x to <4 x i32>
 store <4 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_32_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i16>,ptr %a,align 1
 %y=zext <4 x i16> %x to <4 x i32>
 store <4 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_32_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=sext <8 x i16> %x to <8 x i32>
 store <8 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_32_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=zext <8 x i16> %x to <8 x i32>
 store <8 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_32_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=sext <16 x i16> %x to <16 x i32>
 store <16 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_32_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=zext <16 x i16> %x to <16 x i32>
 store <16 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_32_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=sext <32 x i16> %x to <32 x i32>
 store <32 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_32_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=zext <32 x i16> %x to <32 x i32>
 store <32 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_64_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i16>,ptr %a,align 1
 %y=sext <2 x i16> %x to <2 x i64>
 store <2 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_64_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i16>,ptr %a,align 1
 %y=zext <2 x i16> %x to <2 x i64>
 store <2 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_64_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i16>,ptr %a,align 1
 %y=sext <4 x i16> %x to <4 x i64>
 store <4 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_64_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i16>,ptr %a,align 1
 %y=zext <4 x i16> %x to <4 x i64>
 store <4 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_64_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=sext <8 x i16> %x to <8 x i64>
 store <8 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_64_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=zext <8 x i16> %x to <8 x i64>
 store <8 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_64_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=sext <16 x i16> %x to <16 x i64>
 store <16 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_64_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=zext <16 x i16> %x to <16 x i64>
 store <16 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_16_64_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=sext <32 x i16> %x to <32 x i64>
 store <32 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_16_64_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=zext <32 x i16> %x to <32 x i64>
 store <32 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_32_64_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i32>,ptr %a,align 1
 %y=sext <2 x i32> %x to <2 x i64>
 store <2 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_32_64_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i32>,ptr %a,align 1
 %y=zext <2 x i32> %x to <2 x i64>
 store <2 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_32_64_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=sext <4 x i32> %x to <4 x i64>
 store <4 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_32_64_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=zext <4 x i32> %x to <4 x i64>
 store <4 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_32_64_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=sext <8 x i32> %x to <8 x i64>
 store <8 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_32_64_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=zext <8 x i32> %x to <8 x i64>
 store <8 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_32_64_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=sext <16 x i32> %x to <16 x i64>
 store <16 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_32_64_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=zext <16 x i32> %x to <16 x i64>
 store <16 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_s_32_64_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i32>,ptr %a,align 1
 %y=sext <32 x i32> %x to <32 x i64>
 store <32 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_extend_u_32_64_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i32>,ptr %a,align 1
 %y=zext <32 x i32> %x to <32 x i64>
 store <32 x i64> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_16_8_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i16>,ptr %a,align 1
 %y=trunc <2 x i16> %x to <2 x i8>
 store <2 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_16_8_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i16>,ptr %a,align 1
 %y=trunc <4 x i16> %x to <4 x i8>
 store <4 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_16_8_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=trunc <8 x i16> %x to <8 x i8>
 store <8 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_16_8_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=trunc <16 x i16> %x to <16 x i8>
 store <16 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_16_8_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=trunc <32 x i16> %x to <32 x i8>
 store <32 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_8_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i32>,ptr %a,align 1
 %y=trunc <2 x i32> %x to <2 x i8>
 store <2 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_8_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=trunc <4 x i32> %x to <4 x i8>
 store <4 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_8_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=trunc <8 x i32> %x to <8 x i8>
 store <8 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_8_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=trunc <16 x i32> %x to <16 x i8>
 store <16 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_8_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i32>,ptr %a,align 1
 %y=trunc <32 x i32> %x to <32 x i8>
 store <32 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_16_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i32>,ptr %a,align 1
 %y=trunc <2 x i32> %x to <2 x i16>
 store <2 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_16_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=trunc <4 x i32> %x to <4 x i16>
 store <4 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_16_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=trunc <8 x i32> %x to <8 x i16>
 store <8 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=trunc <16 x i32> %x to <16 x i16>
 store <16 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_32_16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i32>,ptr %a,align 1
 %y=trunc <32 x i32> %x to <32 x i16>
 store <32 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_8_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=trunc <2 x i64> %x to <2 x i8>
 store <2 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_8_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=trunc <4 x i64> %x to <4 x i8>
 store <4 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_8_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=trunc <8 x i64> %x to <8 x i8>
 store <8 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_8_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i64>,ptr %a,align 1
 %y=trunc <16 x i64> %x to <16 x i8>
 store <16 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_8_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i64>,ptr %a,align 1
 %y=trunc <32 x i64> %x to <32 x i8>
 store <32 x i8> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_16_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=trunc <2 x i64> %x to <2 x i16>
 store <2 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_16_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=trunc <4 x i64> %x to <4 x i16>
 store <4 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_16_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=trunc <8 x i64> %x to <8 x i16>
 store <8 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i64>,ptr %a,align 1
 %y=trunc <16 x i64> %x to <16 x i16>
 store <16 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i64>,ptr %a,align 1
 %y=trunc <32 x i64> %x to <32 x i16>
 store <32 x i16> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_32_2(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <2 x i64>,ptr %a,align 1
 %y=trunc <2 x i64> %x to <2 x i32>
 store <2 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_32_4(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i64>,ptr %a,align 1
 %y=trunc <4 x i64> %x to <4 x i32>
 store <4 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_32_8(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i64>,ptr %a,align 1
 %y=trunc <8 x i64> %x to <8 x i32>
 store <8 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_32_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i64>,ptr %a,align 1
 %y=trunc <16 x i64> %x to <16 x i32>
 store <16 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_truncate_64_32_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i64>,ptr %a,align 1
 %y=trunc <32 x i64> %x to <32 x i32>
 store <32 x i32> %y,ptr %out,align 1
 ret void
}
define void @q_pack_ss_16_8_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %xlo=call <8 x i16> @llvm.smax.v8i16(<8 x i16> %x,<8 x i16> splat (i16 -128))
 %xclip=call <8 x i16> @llvm.smin.v8i16(<8 x i16> %xlo,<8 x i16> splat (i16 127))
 %ylo=call <8 x i16> @llvm.smax.v8i16(<8 x i16> %y,<8 x i16> splat (i16 -128))
 %yclip=call <8 x i16> @llvm.smin.v8i16(<8 x i16> %ylo,<8 x i16> splat (i16 127))
 %xt=trunc <8 x i16> %xclip to <8 x i8>
 %yt=trunc <8 x i16> %yclip to <8 x i8>
 %r=shufflevector <8 x i8> %xt,<8 x i8> %yt,<16 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_su_16_8_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %xlo=call <8 x i16> @llvm.smax.v8i16(<8 x i16> %x,<8 x i16> splat (i16 0))
 %xclip=call <8 x i16> @llvm.smin.v8i16(<8 x i16> %xlo,<8 x i16> splat (i16 255))
 %ylo=call <8 x i16> @llvm.smax.v8i16(<8 x i16> %y,<8 x i16> splat (i16 0))
 %yclip=call <8 x i16> @llvm.smin.v8i16(<8 x i16> %ylo,<8 x i16> splat (i16 255))
 %xt=trunc <8 x i16> %xclip to <8 x i8>
 %yt=trunc <8 x i16> %yclip to <8 x i8>
 %r=shufflevector <8 x i8> %xt,<8 x i8> %yt,<16 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_uu_16_8_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %xlo=call <8 x i16> @llvm.umax.v8i16(<8 x i16> %x,<8 x i16> splat (i16 0))
 %xclip=call <8 x i16> @llvm.umin.v8i16(<8 x i16> %xlo,<8 x i16> splat (i16 255))
 %ylo=call <8 x i16> @llvm.umax.v8i16(<8 x i16> %y,<8 x i16> splat (i16 0))
 %yclip=call <8 x i16> @llvm.umin.v8i16(<8 x i16> %ylo,<8 x i16> splat (i16 255))
 %xt=trunc <8 x i16> %xclip to <8 x i8>
 %yt=trunc <8 x i16> %yclip to <8 x i8>
 %r=shufflevector <8 x i8> %xt,<8 x i8> %yt,<16 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15>
 store <16 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_ss_32_16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %xlo=call <4 x i32> @llvm.smax.v4i32(<4 x i32> %x,<4 x i32> splat (i32 -32768))
 %xclip=call <4 x i32> @llvm.smin.v4i32(<4 x i32> %xlo,<4 x i32> splat (i32 32767))
 %ylo=call <4 x i32> @llvm.smax.v4i32(<4 x i32> %y,<4 x i32> splat (i32 -32768))
 %yclip=call <4 x i32> @llvm.smin.v4i32(<4 x i32> %ylo,<4 x i32> splat (i32 32767))
 %xt=trunc <4 x i32> %xclip to <4 x i16>
 %yt=trunc <4 x i32> %yclip to <4 x i16>
 %r=shufflevector <4 x i16> %xt,<4 x i16> %yt,<8 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_pack_su_32_16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %xlo=call <4 x i32> @llvm.smax.v4i32(<4 x i32> %x,<4 x i32> splat (i32 0))
 %xclip=call <4 x i32> @llvm.smin.v4i32(<4 x i32> %xlo,<4 x i32> splat (i32 65535))
 %ylo=call <4 x i32> @llvm.smax.v4i32(<4 x i32> %y,<4 x i32> splat (i32 0))
 %yclip=call <4 x i32> @llvm.smin.v4i32(<4 x i32> %ylo,<4 x i32> splat (i32 65535))
 %xt=trunc <4 x i32> %xclip to <4 x i16>
 %yt=trunc <4 x i32> %yclip to <4 x i16>
 %r=shufflevector <4 x i16> %xt,<4 x i16> %yt,<8 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_pack_uu_32_16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <4 x i32>,ptr %a,align 1
 %y=load <4 x i32>,ptr %b,align 1
 %xlo=call <4 x i32> @llvm.umax.v4i32(<4 x i32> %x,<4 x i32> splat (i32 0))
 %xclip=call <4 x i32> @llvm.umin.v4i32(<4 x i32> %xlo,<4 x i32> splat (i32 65535))
 %ylo=call <4 x i32> @llvm.umax.v4i32(<4 x i32> %y,<4 x i32> splat (i32 0))
 %yclip=call <4 x i32> @llvm.umin.v4i32(<4 x i32> %ylo,<4 x i32> splat (i32 65535))
 %xt=trunc <4 x i32> %xclip to <4 x i16>
 %yt=trunc <4 x i32> %yclip to <4 x i16>
 %r=shufflevector <4 x i16> %xt,<4 x i16> %yt,<8 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7>
 store <8 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_madd_i16_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %xe=sext <8 x i16> %x to <8 x i32>
 %ye=sext <8 x i16> %y to <8 x i32>
 %p=mul <8 x i32> %xe,%ye
 %p0=shufflevector <8 x i32> %p,<8 x i32> poison,<4 x i32> <i32 0,i32 2,i32 4,i32 6>
 %p1=shufflevector <8 x i32> %p,<8 x i32> poison,<4 x i32> <i32 1,i32 3,i32 5,i32 7>
 %sum1=add <4 x i32> %p0,%p1
 store <4 x i32> %sum1,ptr %out,align 1
 ret void
}
define void @q_maddubs_sat_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %xe=zext <16 x i8> %x to <16 x i32>
 %ye=sext <16 x i8> %y to <16 x i32>
 %p=mul <16 x i32> %xe,%ye
 %p0=shufflevector <16 x i32> %p,<16 x i32> poison,<8 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14>
 %p1=shufflevector <16 x i32> %p,<16 x i32> poison,<8 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15>
 %sum1=add <8 x i32> %p0,%p1
 %sum1lo=call <8 x i32> @llvm.smax.v8i32(<8 x i32> %sum1,<8 x i32> splat (i32 -32768))
 %sum1clip=call <8 x i32> @llvm.smin.v8i32(<8 x i32> %sum1lo,<8 x i32> splat (i32 32767))
 %result=trunc <8 x i32> %sum1clip to <8 x i16>
 store <8 x i16> %result,ptr %out,align 1
 ret void
}
define void @q_dpbusd_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %xe=zext <16 x i8> %x to <16 x i32>
 %ye=sext <16 x i8> %y to <16 x i32>
 %p=mul <16 x i32> %xe,%ye
 %p0=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 0,i32 4,i32 8,i32 12>
 %p1=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 1,i32 5,i32 9,i32 13>
 %p2=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 2,i32 6,i32 10,i32 14>
 %p3=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 3,i32 7,i32 11,i32 15>
 %sum1=add <4 x i32> %p0,%p1
 %sum2=add <4 x i32> %sum1,%p2
 %sum3=add <4 x i32> %sum2,%p3
 %old=load <4 x i32>,ptr %c,align 1
 %acc=add <4 x i32> %sum3,%old
 store <4 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpbssd_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %xe=sext <16 x i8> %x to <16 x i32>
 %ye=sext <16 x i8> %y to <16 x i32>
 %p=mul <16 x i32> %xe,%ye
 %p0=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 0,i32 4,i32 8,i32 12>
 %p1=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 1,i32 5,i32 9,i32 13>
 %p2=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 2,i32 6,i32 10,i32 14>
 %p3=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 3,i32 7,i32 11,i32 15>
 %sum1=add <4 x i32> %p0,%p1
 %sum2=add <4 x i32> %sum1,%p2
 %sum3=add <4 x i32> %sum2,%p3
 %old=load <4 x i32>,ptr %c,align 1
 %acc=add <4 x i32> %sum3,%old
 store <4 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpbusds_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i8>,ptr %a,align 1
 %y=load <16 x i8>,ptr %b,align 1
 %xe=zext <16 x i8> %x to <16 x i32>
 %ye=sext <16 x i8> %y to <16 x i32>
 %p=mul <16 x i32> %xe,%ye
 %p0=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 0,i32 4,i32 8,i32 12>
 %p1=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 1,i32 5,i32 9,i32 13>
 %p2=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 2,i32 6,i32 10,i32 14>
 %p3=shufflevector <16 x i32> %p,<16 x i32> poison,<4 x i32> <i32 3,i32 7,i32 11,i32 15>
 %sum1=add <4 x i32> %p0,%p1
 %sum2=add <4 x i32> %sum1,%p2
 %sum3=add <4 x i32> %sum2,%p3
 %old=load <4 x i32>,ptr %c,align 1
 %acc=call <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> %sum3,<4 x i32> %old)
 store <4 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpwssd_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %xe=sext <8 x i16> %x to <8 x i32>
 %ye=sext <8 x i16> %y to <8 x i32>
 %p=mul <8 x i32> %xe,%ye
 %p0=shufflevector <8 x i32> %p,<8 x i32> poison,<4 x i32> <i32 0,i32 2,i32 4,i32 6>
 %p1=shufflevector <8 x i32> %p,<8 x i32> poison,<4 x i32> <i32 1,i32 3,i32 5,i32 7>
 %sum1=add <4 x i32> %p0,%p1
 %old=load <4 x i32>,ptr %c,align 1
 %acc=add <4 x i32> %sum1,%old
 store <4 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpwssds_16(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i16>,ptr %a,align 1
 %y=load <8 x i16>,ptr %b,align 1
 %xe=sext <8 x i16> %x to <8 x i64>
 %ye=sext <8 x i16> %y to <8 x i64>
 %p=mul <8 x i64> %xe,%ye
 %p0=shufflevector <8 x i64> %p,<8 x i64> poison,<4 x i32> <i32 0,i32 2,i32 4,i32 6>
 %p1=shufflevector <8 x i64> %p,<8 x i64> poison,<4 x i32> <i32 1,i32 3,i32 5,i32 7>
 %sum1=add <4 x i64> %p0,%p1
 %old=load <4 x i32>,ptr %c,align 1
 %oldwide=sext <4 x i32> %old to <4 x i64>
 %acc=add <4 x i64> %sum1,%oldwide
 %acclo=call <4 x i64> @llvm.smax.v4i64(<4 x i64> %acc,<4 x i64> splat (i64 -2147483648))
 %accclip=call <4 x i64> @llvm.smin.v4i64(<4 x i64> %acclo,<4 x i64> splat (i64 2147483647))
 %result=trunc <4 x i64> %accclip to <4 x i32>
 store <4 x i32> %result,ptr %out,align 1
 ret void
}
define void @q_pack_ss_16_8_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %xlo=call <16 x i16> @llvm.smax.v16i16(<16 x i16> %x,<16 x i16> splat (i16 -128))
 %xclip=call <16 x i16> @llvm.smin.v16i16(<16 x i16> %xlo,<16 x i16> splat (i16 127))
 %ylo=call <16 x i16> @llvm.smax.v16i16(<16 x i16> %y,<16 x i16> splat (i16 -128))
 %yclip=call <16 x i16> @llvm.smin.v16i16(<16 x i16> %ylo,<16 x i16> splat (i16 127))
 %xt=trunc <16 x i16> %xclip to <16 x i8>
 %yt=trunc <16 x i16> %yclip to <16 x i8>
 %r=shufflevector <16 x i8> %xt,<16 x i8> %yt,<32 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 16,i32 17,i32 18,i32 19,i32 20,i32 21,i32 22,i32 23,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15,i32 24,i32 25,i32 26,i32 27,i32 28,i32 29,i32 30,i32 31>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_su_16_8_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %xlo=call <16 x i16> @llvm.smax.v16i16(<16 x i16> %x,<16 x i16> splat (i16 0))
 %xclip=call <16 x i16> @llvm.smin.v16i16(<16 x i16> %xlo,<16 x i16> splat (i16 255))
 %ylo=call <16 x i16> @llvm.smax.v16i16(<16 x i16> %y,<16 x i16> splat (i16 0))
 %yclip=call <16 x i16> @llvm.smin.v16i16(<16 x i16> %ylo,<16 x i16> splat (i16 255))
 %xt=trunc <16 x i16> %xclip to <16 x i8>
 %yt=trunc <16 x i16> %yclip to <16 x i8>
 %r=shufflevector <16 x i8> %xt,<16 x i8> %yt,<32 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 16,i32 17,i32 18,i32 19,i32 20,i32 21,i32 22,i32 23,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15,i32 24,i32 25,i32 26,i32 27,i32 28,i32 29,i32 30,i32 31>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_uu_16_8_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %xlo=call <16 x i16> @llvm.umax.v16i16(<16 x i16> %x,<16 x i16> splat (i16 0))
 %xclip=call <16 x i16> @llvm.umin.v16i16(<16 x i16> %xlo,<16 x i16> splat (i16 255))
 %ylo=call <16 x i16> @llvm.umax.v16i16(<16 x i16> %y,<16 x i16> splat (i16 0))
 %yclip=call <16 x i16> @llvm.umin.v16i16(<16 x i16> %ylo,<16 x i16> splat (i16 255))
 %xt=trunc <16 x i16> %xclip to <16 x i8>
 %yt=trunc <16 x i16> %yclip to <16 x i8>
 %r=shufflevector <16 x i8> %xt,<16 x i8> %yt,<32 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 16,i32 17,i32 18,i32 19,i32 20,i32 21,i32 22,i32 23,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15,i32 24,i32 25,i32 26,i32 27,i32 28,i32 29,i32 30,i32 31>
 store <32 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_ss_32_16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %xlo=call <8 x i32> @llvm.smax.v8i32(<8 x i32> %x,<8 x i32> splat (i32 -32768))
 %xclip=call <8 x i32> @llvm.smin.v8i32(<8 x i32> %xlo,<8 x i32> splat (i32 32767))
 %ylo=call <8 x i32> @llvm.smax.v8i32(<8 x i32> %y,<8 x i32> splat (i32 -32768))
 %yclip=call <8 x i32> @llvm.smin.v8i32(<8 x i32> %ylo,<8 x i32> splat (i32 32767))
 %xt=trunc <8 x i32> %xclip to <8 x i16>
 %yt=trunc <8 x i32> %yclip to <8 x i16>
 %r=shufflevector <8 x i16> %xt,<8 x i16> %yt,<16 x i32> <i32 0,i32 1,i32 2,i32 3,i32 8,i32 9,i32 10,i32 11,i32 4,i32 5,i32 6,i32 7,i32 12,i32 13,i32 14,i32 15>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_pack_su_32_16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %xlo=call <8 x i32> @llvm.smax.v8i32(<8 x i32> %x,<8 x i32> splat (i32 0))
 %xclip=call <8 x i32> @llvm.smin.v8i32(<8 x i32> %xlo,<8 x i32> splat (i32 65535))
 %ylo=call <8 x i32> @llvm.smax.v8i32(<8 x i32> %y,<8 x i32> splat (i32 0))
 %yclip=call <8 x i32> @llvm.smin.v8i32(<8 x i32> %ylo,<8 x i32> splat (i32 65535))
 %xt=trunc <8 x i32> %xclip to <8 x i16>
 %yt=trunc <8 x i32> %yclip to <8 x i16>
 %r=shufflevector <8 x i16> %xt,<8 x i16> %yt,<16 x i32> <i32 0,i32 1,i32 2,i32 3,i32 8,i32 9,i32 10,i32 11,i32 4,i32 5,i32 6,i32 7,i32 12,i32 13,i32 14,i32 15>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_pack_uu_32_16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x i32>,ptr %a,align 1
 %y=load <8 x i32>,ptr %b,align 1
 %xlo=call <8 x i32> @llvm.umax.v8i32(<8 x i32> %x,<8 x i32> splat (i32 0))
 %xclip=call <8 x i32> @llvm.umin.v8i32(<8 x i32> %xlo,<8 x i32> splat (i32 65535))
 %ylo=call <8 x i32> @llvm.umax.v8i32(<8 x i32> %y,<8 x i32> splat (i32 0))
 %yclip=call <8 x i32> @llvm.umin.v8i32(<8 x i32> %ylo,<8 x i32> splat (i32 65535))
 %xt=trunc <8 x i32> %xclip to <8 x i16>
 %yt=trunc <8 x i32> %yclip to <8 x i16>
 %r=shufflevector <8 x i16> %xt,<8 x i16> %yt,<16 x i32> <i32 0,i32 1,i32 2,i32 3,i32 8,i32 9,i32 10,i32 11,i32 4,i32 5,i32 6,i32 7,i32 12,i32 13,i32 14,i32 15>
 store <16 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_madd_i16_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %xe=sext <16 x i16> %x to <16 x i32>
 %ye=sext <16 x i16> %y to <16 x i32>
 %p=mul <16 x i32> %xe,%ye
 %p0=shufflevector <16 x i32> %p,<16 x i32> poison,<8 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14>
 %p1=shufflevector <16 x i32> %p,<16 x i32> poison,<8 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15>
 %sum1=add <8 x i32> %p0,%p1
 store <8 x i32> %sum1,ptr %out,align 1
 ret void
}
define void @q_maddubs_sat_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %xe=zext <32 x i8> %x to <32 x i32>
 %ye=sext <32 x i8> %y to <32 x i32>
 %p=mul <32 x i32> %xe,%ye
 %p0=shufflevector <32 x i32> %p,<32 x i32> poison,<16 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14,i32 16,i32 18,i32 20,i32 22,i32 24,i32 26,i32 28,i32 30>
 %p1=shufflevector <32 x i32> %p,<32 x i32> poison,<16 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15,i32 17,i32 19,i32 21,i32 23,i32 25,i32 27,i32 29,i32 31>
 %sum1=add <16 x i32> %p0,%p1
 %sum1lo=call <16 x i32> @llvm.smax.v16i32(<16 x i32> %sum1,<16 x i32> splat (i32 -32768))
 %sum1clip=call <16 x i32> @llvm.smin.v16i32(<16 x i32> %sum1lo,<16 x i32> splat (i32 32767))
 %result=trunc <16 x i32> %sum1clip to <16 x i16>
 store <16 x i16> %result,ptr %out,align 1
 ret void
}
define void @q_dpbusd_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %xe=zext <32 x i8> %x to <32 x i32>
 %ye=sext <32 x i8> %y to <32 x i32>
 %p=mul <32 x i32> %xe,%ye
 %p0=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 0,i32 4,i32 8,i32 12,i32 16,i32 20,i32 24,i32 28>
 %p1=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 1,i32 5,i32 9,i32 13,i32 17,i32 21,i32 25,i32 29>
 %p2=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 2,i32 6,i32 10,i32 14,i32 18,i32 22,i32 26,i32 30>
 %p3=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 3,i32 7,i32 11,i32 15,i32 19,i32 23,i32 27,i32 31>
 %sum1=add <8 x i32> %p0,%p1
 %sum2=add <8 x i32> %sum1,%p2
 %sum3=add <8 x i32> %sum2,%p3
 %old=load <8 x i32>,ptr %c,align 1
 %acc=add <8 x i32> %sum3,%old
 store <8 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpbssd_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %xe=sext <32 x i8> %x to <32 x i32>
 %ye=sext <32 x i8> %y to <32 x i32>
 %p=mul <32 x i32> %xe,%ye
 %p0=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 0,i32 4,i32 8,i32 12,i32 16,i32 20,i32 24,i32 28>
 %p1=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 1,i32 5,i32 9,i32 13,i32 17,i32 21,i32 25,i32 29>
 %p2=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 2,i32 6,i32 10,i32 14,i32 18,i32 22,i32 26,i32 30>
 %p3=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 3,i32 7,i32 11,i32 15,i32 19,i32 23,i32 27,i32 31>
 %sum1=add <8 x i32> %p0,%p1
 %sum2=add <8 x i32> %sum1,%p2
 %sum3=add <8 x i32> %sum2,%p3
 %old=load <8 x i32>,ptr %c,align 1
 %acc=add <8 x i32> %sum3,%old
 store <8 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpbusds_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i8>,ptr %a,align 1
 %y=load <32 x i8>,ptr %b,align 1
 %xe=zext <32 x i8> %x to <32 x i32>
 %ye=sext <32 x i8> %y to <32 x i32>
 %p=mul <32 x i32> %xe,%ye
 %p0=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 0,i32 4,i32 8,i32 12,i32 16,i32 20,i32 24,i32 28>
 %p1=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 1,i32 5,i32 9,i32 13,i32 17,i32 21,i32 25,i32 29>
 %p2=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 2,i32 6,i32 10,i32 14,i32 18,i32 22,i32 26,i32 30>
 %p3=shufflevector <32 x i32> %p,<32 x i32> poison,<8 x i32> <i32 3,i32 7,i32 11,i32 15,i32 19,i32 23,i32 27,i32 31>
 %sum1=add <8 x i32> %p0,%p1
 %sum2=add <8 x i32> %sum1,%p2
 %sum3=add <8 x i32> %sum2,%p3
 %old=load <8 x i32>,ptr %c,align 1
 %acc=call <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32> %sum3,<8 x i32> %old)
 store <8 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpwssd_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %xe=sext <16 x i16> %x to <16 x i32>
 %ye=sext <16 x i16> %y to <16 x i32>
 %p=mul <16 x i32> %xe,%ye
 %p0=shufflevector <16 x i32> %p,<16 x i32> poison,<8 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14>
 %p1=shufflevector <16 x i32> %p,<16 x i32> poison,<8 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15>
 %sum1=add <8 x i32> %p0,%p1
 %old=load <8 x i32>,ptr %c,align 1
 %acc=add <8 x i32> %sum1,%old
 store <8 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpwssds_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i16>,ptr %a,align 1
 %y=load <16 x i16>,ptr %b,align 1
 %xe=sext <16 x i16> %x to <16 x i64>
 %ye=sext <16 x i16> %y to <16 x i64>
 %p=mul <16 x i64> %xe,%ye
 %p0=shufflevector <16 x i64> %p,<16 x i64> poison,<8 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14>
 %p1=shufflevector <16 x i64> %p,<16 x i64> poison,<8 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15>
 %sum1=add <8 x i64> %p0,%p1
 %old=load <8 x i32>,ptr %c,align 1
 %oldwide=sext <8 x i32> %old to <8 x i64>
 %acc=add <8 x i64> %sum1,%oldwide
 %acclo=call <8 x i64> @llvm.smax.v8i64(<8 x i64> %acc,<8 x i64> splat (i64 -2147483648))
 %accclip=call <8 x i64> @llvm.smin.v8i64(<8 x i64> %acclo,<8 x i64> splat (i64 2147483647))
 %result=trunc <8 x i64> %accclip to <8 x i32>
 store <8 x i32> %result,ptr %out,align 1
 ret void
}
define void @q_pack_ss_16_8_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %xlo=call <32 x i16> @llvm.smax.v32i16(<32 x i16> %x,<32 x i16> splat (i16 -128))
 %xclip=call <32 x i16> @llvm.smin.v32i16(<32 x i16> %xlo,<32 x i16> splat (i16 127))
 %ylo=call <32 x i16> @llvm.smax.v32i16(<32 x i16> %y,<32 x i16> splat (i16 -128))
 %yclip=call <32 x i16> @llvm.smin.v32i16(<32 x i16> %ylo,<32 x i16> splat (i16 127))
 %xt=trunc <32 x i16> %xclip to <32 x i8>
 %yt=trunc <32 x i16> %yclip to <32 x i8>
 %r=shufflevector <32 x i8> %xt,<32 x i8> %yt,<64 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 32,i32 33,i32 34,i32 35,i32 36,i32 37,i32 38,i32 39,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15,i32 40,i32 41,i32 42,i32 43,i32 44,i32 45,i32 46,i32 47,i32 16,i32 17,i32 18,i32 19,i32 20,i32 21,i32 22,i32 23,i32 48,i32 49,i32 50,i32 51,i32 52,i32 53,i32 54,i32 55,i32 24,i32 25,i32 26,i32 27,i32 28,i32 29,i32 30,i32 31,i32 56,i32 57,i32 58,i32 59,i32 60,i32 61,i32 62,i32 63>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_su_16_8_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %xlo=call <32 x i16> @llvm.smax.v32i16(<32 x i16> %x,<32 x i16> splat (i16 0))
 %xclip=call <32 x i16> @llvm.smin.v32i16(<32 x i16> %xlo,<32 x i16> splat (i16 255))
 %ylo=call <32 x i16> @llvm.smax.v32i16(<32 x i16> %y,<32 x i16> splat (i16 0))
 %yclip=call <32 x i16> @llvm.smin.v32i16(<32 x i16> %ylo,<32 x i16> splat (i16 255))
 %xt=trunc <32 x i16> %xclip to <32 x i8>
 %yt=trunc <32 x i16> %yclip to <32 x i8>
 %r=shufflevector <32 x i8> %xt,<32 x i8> %yt,<64 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 32,i32 33,i32 34,i32 35,i32 36,i32 37,i32 38,i32 39,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15,i32 40,i32 41,i32 42,i32 43,i32 44,i32 45,i32 46,i32 47,i32 16,i32 17,i32 18,i32 19,i32 20,i32 21,i32 22,i32 23,i32 48,i32 49,i32 50,i32 51,i32 52,i32 53,i32 54,i32 55,i32 24,i32 25,i32 26,i32 27,i32 28,i32 29,i32 30,i32 31,i32 56,i32 57,i32 58,i32 59,i32 60,i32 61,i32 62,i32 63>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_uu_16_8_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %xlo=call <32 x i16> @llvm.umax.v32i16(<32 x i16> %x,<32 x i16> splat (i16 0))
 %xclip=call <32 x i16> @llvm.umin.v32i16(<32 x i16> %xlo,<32 x i16> splat (i16 255))
 %ylo=call <32 x i16> @llvm.umax.v32i16(<32 x i16> %y,<32 x i16> splat (i16 0))
 %yclip=call <32 x i16> @llvm.umin.v32i16(<32 x i16> %ylo,<32 x i16> splat (i16 255))
 %xt=trunc <32 x i16> %xclip to <32 x i8>
 %yt=trunc <32 x i16> %yclip to <32 x i8>
 %r=shufflevector <32 x i8> %xt,<32 x i8> %yt,<64 x i32> <i32 0,i32 1,i32 2,i32 3,i32 4,i32 5,i32 6,i32 7,i32 32,i32 33,i32 34,i32 35,i32 36,i32 37,i32 38,i32 39,i32 8,i32 9,i32 10,i32 11,i32 12,i32 13,i32 14,i32 15,i32 40,i32 41,i32 42,i32 43,i32 44,i32 45,i32 46,i32 47,i32 16,i32 17,i32 18,i32 19,i32 20,i32 21,i32 22,i32 23,i32 48,i32 49,i32 50,i32 51,i32 52,i32 53,i32 54,i32 55,i32 24,i32 25,i32 26,i32 27,i32 28,i32 29,i32 30,i32 31,i32 56,i32 57,i32 58,i32 59,i32 60,i32 61,i32 62,i32 63>
 store <64 x i8> %r,ptr %out,align 1
 ret void
}
define void @q_pack_ss_32_16_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %xlo=call <16 x i32> @llvm.smax.v16i32(<16 x i32> %x,<16 x i32> splat (i32 -32768))
 %xclip=call <16 x i32> @llvm.smin.v16i32(<16 x i32> %xlo,<16 x i32> splat (i32 32767))
 %ylo=call <16 x i32> @llvm.smax.v16i32(<16 x i32> %y,<16 x i32> splat (i32 -32768))
 %yclip=call <16 x i32> @llvm.smin.v16i32(<16 x i32> %ylo,<16 x i32> splat (i32 32767))
 %xt=trunc <16 x i32> %xclip to <16 x i16>
 %yt=trunc <16 x i32> %yclip to <16 x i16>
 %r=shufflevector <16 x i16> %xt,<16 x i16> %yt,<32 x i32> <i32 0,i32 1,i32 2,i32 3,i32 16,i32 17,i32 18,i32 19,i32 4,i32 5,i32 6,i32 7,i32 20,i32 21,i32 22,i32 23,i32 8,i32 9,i32 10,i32 11,i32 24,i32 25,i32 26,i32 27,i32 12,i32 13,i32 14,i32 15,i32 28,i32 29,i32 30,i32 31>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_pack_su_32_16_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %xlo=call <16 x i32> @llvm.smax.v16i32(<16 x i32> %x,<16 x i32> splat (i32 0))
 %xclip=call <16 x i32> @llvm.smin.v16i32(<16 x i32> %xlo,<16 x i32> splat (i32 65535))
 %ylo=call <16 x i32> @llvm.smax.v16i32(<16 x i32> %y,<16 x i32> splat (i32 0))
 %yclip=call <16 x i32> @llvm.smin.v16i32(<16 x i32> %ylo,<16 x i32> splat (i32 65535))
 %xt=trunc <16 x i32> %xclip to <16 x i16>
 %yt=trunc <16 x i32> %yclip to <16 x i16>
 %r=shufflevector <16 x i16> %xt,<16 x i16> %yt,<32 x i32> <i32 0,i32 1,i32 2,i32 3,i32 16,i32 17,i32 18,i32 19,i32 4,i32 5,i32 6,i32 7,i32 20,i32 21,i32 22,i32 23,i32 8,i32 9,i32 10,i32 11,i32 24,i32 25,i32 26,i32 27,i32 12,i32 13,i32 14,i32 15,i32 28,i32 29,i32 30,i32 31>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_pack_uu_32_16_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x i32>,ptr %a,align 1
 %y=load <16 x i32>,ptr %b,align 1
 %xlo=call <16 x i32> @llvm.umax.v16i32(<16 x i32> %x,<16 x i32> splat (i32 0))
 %xclip=call <16 x i32> @llvm.umin.v16i32(<16 x i32> %xlo,<16 x i32> splat (i32 65535))
 %ylo=call <16 x i32> @llvm.umax.v16i32(<16 x i32> %y,<16 x i32> splat (i32 0))
 %yclip=call <16 x i32> @llvm.umin.v16i32(<16 x i32> %ylo,<16 x i32> splat (i32 65535))
 %xt=trunc <16 x i32> %xclip to <16 x i16>
 %yt=trunc <16 x i32> %yclip to <16 x i16>
 %r=shufflevector <16 x i16> %xt,<16 x i16> %yt,<32 x i32> <i32 0,i32 1,i32 2,i32 3,i32 16,i32 17,i32 18,i32 19,i32 4,i32 5,i32 6,i32 7,i32 20,i32 21,i32 22,i32 23,i32 8,i32 9,i32 10,i32 11,i32 24,i32 25,i32 26,i32 27,i32 12,i32 13,i32 14,i32 15,i32 28,i32 29,i32 30,i32 31>
 store <32 x i16> %r,ptr %out,align 1
 ret void
}
define void @q_madd_i16_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %xe=sext <32 x i16> %x to <32 x i32>
 %ye=sext <32 x i16> %y to <32 x i32>
 %p=mul <32 x i32> %xe,%ye
 %p0=shufflevector <32 x i32> %p,<32 x i32> poison,<16 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14,i32 16,i32 18,i32 20,i32 22,i32 24,i32 26,i32 28,i32 30>
 %p1=shufflevector <32 x i32> %p,<32 x i32> poison,<16 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15,i32 17,i32 19,i32 21,i32 23,i32 25,i32 27,i32 29,i32 31>
 %sum1=add <16 x i32> %p0,%p1
 store <16 x i32> %sum1,ptr %out,align 1
 ret void
}
define void @q_maddubs_sat_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %xe=zext <64 x i8> %x to <64 x i32>
 %ye=sext <64 x i8> %y to <64 x i32>
 %p=mul <64 x i32> %xe,%ye
 %p0=shufflevector <64 x i32> %p,<64 x i32> poison,<32 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14,i32 16,i32 18,i32 20,i32 22,i32 24,i32 26,i32 28,i32 30,i32 32,i32 34,i32 36,i32 38,i32 40,i32 42,i32 44,i32 46,i32 48,i32 50,i32 52,i32 54,i32 56,i32 58,i32 60,i32 62>
 %p1=shufflevector <64 x i32> %p,<64 x i32> poison,<32 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15,i32 17,i32 19,i32 21,i32 23,i32 25,i32 27,i32 29,i32 31,i32 33,i32 35,i32 37,i32 39,i32 41,i32 43,i32 45,i32 47,i32 49,i32 51,i32 53,i32 55,i32 57,i32 59,i32 61,i32 63>
 %sum1=add <32 x i32> %p0,%p1
 %sum1lo=call <32 x i32> @llvm.smax.v32i32(<32 x i32> %sum1,<32 x i32> splat (i32 -32768))
 %sum1clip=call <32 x i32> @llvm.smin.v32i32(<32 x i32> %sum1lo,<32 x i32> splat (i32 32767))
 %result=trunc <32 x i32> %sum1clip to <32 x i16>
 store <32 x i16> %result,ptr %out,align 1
 ret void
}
define void @q_dpbusd_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %xe=zext <64 x i8> %x to <64 x i32>
 %ye=sext <64 x i8> %y to <64 x i32>
 %p=mul <64 x i32> %xe,%ye
 %p0=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 0,i32 4,i32 8,i32 12,i32 16,i32 20,i32 24,i32 28,i32 32,i32 36,i32 40,i32 44,i32 48,i32 52,i32 56,i32 60>
 %p1=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 1,i32 5,i32 9,i32 13,i32 17,i32 21,i32 25,i32 29,i32 33,i32 37,i32 41,i32 45,i32 49,i32 53,i32 57,i32 61>
 %p2=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 2,i32 6,i32 10,i32 14,i32 18,i32 22,i32 26,i32 30,i32 34,i32 38,i32 42,i32 46,i32 50,i32 54,i32 58,i32 62>
 %p3=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 3,i32 7,i32 11,i32 15,i32 19,i32 23,i32 27,i32 31,i32 35,i32 39,i32 43,i32 47,i32 51,i32 55,i32 59,i32 63>
 %sum1=add <16 x i32> %p0,%p1
 %sum2=add <16 x i32> %sum1,%p2
 %sum3=add <16 x i32> %sum2,%p3
 %old=load <16 x i32>,ptr %c,align 1
 %acc=add <16 x i32> %sum3,%old
 store <16 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpbssd_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %xe=sext <64 x i8> %x to <64 x i32>
 %ye=sext <64 x i8> %y to <64 x i32>
 %p=mul <64 x i32> %xe,%ye
 %p0=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 0,i32 4,i32 8,i32 12,i32 16,i32 20,i32 24,i32 28,i32 32,i32 36,i32 40,i32 44,i32 48,i32 52,i32 56,i32 60>
 %p1=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 1,i32 5,i32 9,i32 13,i32 17,i32 21,i32 25,i32 29,i32 33,i32 37,i32 41,i32 45,i32 49,i32 53,i32 57,i32 61>
 %p2=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 2,i32 6,i32 10,i32 14,i32 18,i32 22,i32 26,i32 30,i32 34,i32 38,i32 42,i32 46,i32 50,i32 54,i32 58,i32 62>
 %p3=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 3,i32 7,i32 11,i32 15,i32 19,i32 23,i32 27,i32 31,i32 35,i32 39,i32 43,i32 47,i32 51,i32 55,i32 59,i32 63>
 %sum1=add <16 x i32> %p0,%p1
 %sum2=add <16 x i32> %sum1,%p2
 %sum3=add <16 x i32> %sum2,%p3
 %old=load <16 x i32>,ptr %c,align 1
 %acc=add <16 x i32> %sum3,%old
 store <16 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpbusds_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <64 x i8>,ptr %a,align 1
 %y=load <64 x i8>,ptr %b,align 1
 %xe=zext <64 x i8> %x to <64 x i32>
 %ye=sext <64 x i8> %y to <64 x i32>
 %p=mul <64 x i32> %xe,%ye
 %p0=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 0,i32 4,i32 8,i32 12,i32 16,i32 20,i32 24,i32 28,i32 32,i32 36,i32 40,i32 44,i32 48,i32 52,i32 56,i32 60>
 %p1=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 1,i32 5,i32 9,i32 13,i32 17,i32 21,i32 25,i32 29,i32 33,i32 37,i32 41,i32 45,i32 49,i32 53,i32 57,i32 61>
 %p2=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 2,i32 6,i32 10,i32 14,i32 18,i32 22,i32 26,i32 30,i32 34,i32 38,i32 42,i32 46,i32 50,i32 54,i32 58,i32 62>
 %p3=shufflevector <64 x i32> %p,<64 x i32> poison,<16 x i32> <i32 3,i32 7,i32 11,i32 15,i32 19,i32 23,i32 27,i32 31,i32 35,i32 39,i32 43,i32 47,i32 51,i32 55,i32 59,i32 63>
 %sum1=add <16 x i32> %p0,%p1
 %sum2=add <16 x i32> %sum1,%p2
 %sum3=add <16 x i32> %sum2,%p3
 %old=load <16 x i32>,ptr %c,align 1
 %acc=call <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32> %sum3,<16 x i32> %old)
 store <16 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpwssd_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %xe=sext <32 x i16> %x to <32 x i32>
 %ye=sext <32 x i16> %y to <32 x i32>
 %p=mul <32 x i32> %xe,%ye
 %p0=shufflevector <32 x i32> %p,<32 x i32> poison,<16 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14,i32 16,i32 18,i32 20,i32 22,i32 24,i32 26,i32 28,i32 30>
 %p1=shufflevector <32 x i32> %p,<32 x i32> poison,<16 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15,i32 17,i32 19,i32 21,i32 23,i32 25,i32 27,i32 29,i32 31>
 %sum1=add <16 x i32> %p0,%p1
 %old=load <16 x i32>,ptr %c,align 1
 %acc=add <16 x i32> %sum1,%old
 store <16 x i32> %acc,ptr %out,align 1
 ret void
}
define void @q_dpwssds_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <32 x i16>,ptr %a,align 1
 %y=load <32 x i16>,ptr %b,align 1
 %xe=sext <32 x i16> %x to <32 x i64>
 %ye=sext <32 x i16> %y to <32 x i64>
 %p=mul <32 x i64> %xe,%ye
 %p0=shufflevector <32 x i64> %p,<32 x i64> poison,<16 x i32> <i32 0,i32 2,i32 4,i32 6,i32 8,i32 10,i32 12,i32 14,i32 16,i32 18,i32 20,i32 22,i32 24,i32 26,i32 28,i32 30>
 %p1=shufflevector <32 x i64> %p,<32 x i64> poison,<16 x i32> <i32 1,i32 3,i32 5,i32 7,i32 9,i32 11,i32 13,i32 15,i32 17,i32 19,i32 21,i32 23,i32 25,i32 27,i32 29,i32 31>
 %sum1=add <16 x i64> %p0,%p1
 %old=load <16 x i32>,ptr %c,align 1
 %oldwide=sext <16 x i32> %old to <16 x i64>
 %acc=add <16 x i64> %sum1,%oldwide
 %acclo=call <16 x i64> @llvm.smax.v16i64(<16 x i64> %acc,<16 x i64> splat (i64 -2147483648))
 %accclip=call <16 x i64> @llvm.smin.v16i64(<16 x i64> %acclo,<16 x i64> splat (i64 2147483647))
 %result=trunc <16 x i64> %accclip to <16 x i32>
 store <16 x i32> %result,ptr %out,align 1
 ret void
}
declare <16 x i16> @llvm.smax.v16i16(<16 x i16>,<16 x i16>)
declare <16 x i16> @llvm.smin.v16i16(<16 x i16>,<16 x i16>)
declare <16 x i16> @llvm.umax.v16i16(<16 x i16>,<16 x i16>)
declare <16 x i16> @llvm.umin.v16i16(<16 x i16>,<16 x i16>)
declare <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32>,<16 x i32>)
declare <16 x i32> @llvm.smax.v16i32(<16 x i32>,<16 x i32>)
declare <16 x i32> @llvm.smin.v16i32(<16 x i32>,<16 x i32>)
declare <16 x i32> @llvm.umax.v16i32(<16 x i32>,<16 x i32>)
declare <16 x i32> @llvm.umin.v16i32(<16 x i32>,<16 x i32>)
declare <16 x i64> @llvm.smax.v16i64(<16 x i64>,<16 x i64>)
declare <16 x i64> @llvm.smin.v16i64(<16 x i64>,<16 x i64>)
declare <32 x i16> @llvm.smax.v32i16(<32 x i16>,<32 x i16>)
declare <32 x i16> @llvm.smin.v32i16(<32 x i16>,<32 x i16>)
declare <32 x i16> @llvm.umax.v32i16(<32 x i16>,<32 x i16>)
declare <32 x i16> @llvm.umin.v32i16(<32 x i16>,<32 x i16>)
declare <32 x i32> @llvm.smax.v32i32(<32 x i32>,<32 x i32>)
declare <32 x i32> @llvm.smin.v32i32(<32 x i32>,<32 x i32>)
declare <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32>,<4 x i32>)
declare <4 x i32> @llvm.smax.v4i32(<4 x i32>,<4 x i32>)
declare <4 x i32> @llvm.smin.v4i32(<4 x i32>,<4 x i32>)
declare <4 x i32> @llvm.umax.v4i32(<4 x i32>,<4 x i32>)
declare <4 x i32> @llvm.umin.v4i32(<4 x i32>,<4 x i32>)
declare <4 x i64> @llvm.smax.v4i64(<4 x i64>,<4 x i64>)
declare <4 x i64> @llvm.smin.v4i64(<4 x i64>,<4 x i64>)
declare <8 x i16> @llvm.smax.v8i16(<8 x i16>,<8 x i16>)
declare <8 x i16> @llvm.smin.v8i16(<8 x i16>,<8 x i16>)
declare <8 x i16> @llvm.umax.v8i16(<8 x i16>,<8 x i16>)
declare <8 x i16> @llvm.umin.v8i16(<8 x i16>,<8 x i16>)
declare <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32>,<8 x i32>)
declare <8 x i32> @llvm.smax.v8i32(<8 x i32>,<8 x i32>)
declare <8 x i32> @llvm.smin.v8i32(<8 x i32>,<8 x i32>)
declare <8 x i32> @llvm.umax.v8i32(<8 x i32>,<8 x i32>)
declare <8 x i32> @llvm.umin.v8i32(<8 x i32>,<8 x i32>)
declare <8 x i64> @llvm.smax.v8i64(<8 x i64>,<8 x i64>)
declare <8 x i64> @llvm.smin.v8i64(<8 x i64>,<8 x i64>)
