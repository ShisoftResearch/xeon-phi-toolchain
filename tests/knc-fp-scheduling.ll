; REQUIRES: asserts
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -debug-only=machine-scheduler < %s -o /dev/null 2>&1 | FileCheck %s --check-prefix=ON
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -knc-fp-scheduling=false -debug-only=machine-scheduler < %s -o /dev/null 2>&1 | FileCheck %s --check-prefix=OFF
target triple = "x86_64-unknown-linux-gnu"
; ON: SU({{[0-9]+}}): {{.*}}KNC_VADDPSrr
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VADDPSrr
; OFF: Latency            : 0
define void @latency_add_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x float>,ptr %a,align 64
 %y=load <16 x float>,ptr %b,align 64
 %z=load <16 x float>,ptr %c,align 64
 %r=fadd <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 64
 ret void
}
; ON: SU({{[0-9]+}}): {{.*}}KNC_VSUBPSrr
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VSUBPSrr
; OFF: Latency            : 0
define void @latency_sub_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x float>,ptr %a,align 64
 %y=load <16 x float>,ptr %b,align 64
 %z=load <16 x float>,ptr %c,align 64
 %r=fsub <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 64
 ret void
}
; ON: SU({{[0-9]+}}): {{.*}}KNC_VMULPSrr
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VMULPSrr
; OFF: Latency            : 0
define void @latency_mul_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x float>,ptr %a,align 64
 %y=load <16 x float>,ptr %b,align 64
 %z=load <16 x float>,ptr %c,align 64
 %r=fmul <16 x float> %x,%y
 store <16 x float> %r,ptr %out,align 64
 ret void
}
; ON: SU({{[0-9]+}}): {{.*}}KNC_VFMADD132PS
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VFMADD132PS
; OFF: Latency            : 0
define void @latency_fma_32(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <16 x float>,ptr %a,align 64
 %y=load <16 x float>,ptr %b,align 64
 %z=load <16 x float>,ptr %c,align 64
 %r=call <16 x float> @llvm.fma.v16f32(<16 x float> %x,<16 x float> %y,<16 x float> %z)
 store <16 x float> %r,ptr %out,align 64
 ret void
}
declare <16 x float> @llvm.fma.v16f32(<16 x float>,<16 x float>,<16 x float>)
; ON: SU({{[0-9]+}}): {{.*}}KNC_VADDPDrr
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VADDPDrr
; OFF: Latency            : 0
define void @latency_add_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x double>,ptr %a,align 64
 %y=load <8 x double>,ptr %b,align 64
 %z=load <8 x double>,ptr %c,align 64
 %r=fadd <8 x double> %x,%y
 store <8 x double> %r,ptr %out,align 64
 ret void
}
; ON: SU({{[0-9]+}}): {{.*}}KNC_VSUBPDrr
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VSUBPDrr
; OFF: Latency            : 0
define void @latency_sub_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x double>,ptr %a,align 64
 %y=load <8 x double>,ptr %b,align 64
 %z=load <8 x double>,ptr %c,align 64
 %r=fsub <8 x double> %x,%y
 store <8 x double> %r,ptr %out,align 64
 ret void
}
; ON: SU({{[0-9]+}}): {{.*}}KNC_VMULPDrr
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VMULPDrr
; OFF: Latency            : 0
define void @latency_mul_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x double>,ptr %a,align 64
 %y=load <8 x double>,ptr %b,align 64
 %z=load <8 x double>,ptr %c,align 64
 %r=fmul <8 x double> %x,%y
 store <8 x double> %r,ptr %out,align 64
 ret void
}
; ON: SU({{[0-9]+}}): {{.*}}KNC_VFMADD132PD
; ON: Latency            : 4
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VFMADD132PD
; OFF: Latency            : 0
define void @latency_fma_64(ptr %out,ptr %a,ptr %b,ptr %c) {
 %x=load <8 x double>,ptr %a,align 64
 %y=load <8 x double>,ptr %b,align 64
 %z=load <8 x double>,ptr %c,align 64
 %r=call <8 x double> @llvm.fma.v8f64(<8 x double> %x,<8 x double> %y,<8 x double> %z)
 store <8 x double> %r,ptr %out,align 64
 ret void
}
declare <8 x double> @llvm.fma.v8f64(<8 x double>,<8 x double>,<8 x double>)
; ON: SU({{[0-9]+}}): {{.*}}KNC_VRCP23PS
; ON: Latency            : 6
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VRCP23PS
; OFF: Latency            : 0
define void @latency_rcp23(ptr %out,ptr %a) {
 %x=load <16 x float>,ptr %a,align 64
 %r=call <16 x float> @llvm.x86.knc.rcp23.ps(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 64
 ret void
}
declare <16 x float> @llvm.x86.knc.rcp23.ps(<16 x float>)
; ON: SU({{[0-9]+}}): {{.*}}KNC_VRSQRT23PS
; ON: Latency            : 6
; OFF: SU({{[0-9]+}}): {{.*}}KNC_VRSQRT23PS
; OFF: Latency            : 0
define void @latency_rsqrt23(ptr %out,ptr %a) {
 %x=load <16 x float>,ptr %a,align 64
 %r=call <16 x float> @llvm.x86.knc.rsqrt23.ps(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 64
 ret void
}
declare <16 x float> @llvm.x86.knc.rsqrt23.ps(<16 x float>)
