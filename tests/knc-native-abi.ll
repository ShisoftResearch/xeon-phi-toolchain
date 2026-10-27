; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -knc-scalar-register-reuse=false -verify-machineinstrs < %s | FileCheck %s --check-prefix=LEGACY
; CHECK-LABEL: identity:
; CHECK-NOT: knc.vmovdqa32
; CHECK-NOT: knc.vbroadcast
; CHECK: retq
; LEGACY-LABEL: identity:
; LEGACY: knc.vmovdqa32
; LEGACY: knc.vbroadcastsd
; CHECK-LABEL: add:
; CHECK: knc.vaddpd
; CHECK-LABEL: addf:
; CHECK: knc.vaddps
; CHECK-LABEL: ten:
; CHECK: knc.vmovdqa32{{.*}}%zmm0, %zmm1
; CHECK: ext
; CHECK-LABEL: aggregate:
; CHECK: pair
; CHECK-NOT: knc.vbroadcast
; CHECK: retq
target triple = "x86_64-unknown-linux-gnu"
define double @identity(double %x) { ret double %x }
define double @add(double %x,double %y) { %z = fadd double %x,%y
 ret double %z }
define float @addf(float %x,float %y) { %z = fadd float %x,%y
 ret float %z }
declare double @ext(double,double,double,double,double,double,double,double,double,double)
define double @ten(double %x) { %z=call double @ext(double %x,double %x,double %x,double %x,double %x,double %x,double %x,double %x,double %x,double %x)
 ret double %z }

declare { double, i64 } @pair(double)
define { double, i64 } @aggregate(double %x) {
 %p = call { double, i64 } @pair(double %x)
 ret { double, i64 } %p
}
