; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mcpu=knc < %s | FileCheck %s
; CHECK-LABEL: knc_sine:
; CHECK: __knc_math_sin
; CHECK-LABEL: knc_power:
; CHECK: __knc_math_pow
declare double @sin(double)
declare double @pow(double,double)
define double @knc_sine(double %x) {
 %r = call double @sin(double %x)
 ret double %r
}
define double @knc_power(double %x,double %y) {
 %r = call double @pow(double %x,double %y)
 ret double %r
}

; CHECK-LABEL: knc_root:
; CHECK-NOT: __knc_math_sqrt
; CHECK: __knc_soft_sqrt
declare double @sqrt(double)
define double @knc_root(double %x) {
 %r = call double @sqrt(double %x)
 ret double %r
}
