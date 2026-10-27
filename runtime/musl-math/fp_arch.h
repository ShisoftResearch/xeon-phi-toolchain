/* K1OM integration only; vendored musl source files stay unmodified. */
#ifndef KNC_MUSL_MATH_ADAPT_H
#define KNC_MUSL_MATH_ADAPT_H
#define hidden __attribute__((visibility("hidden")))
#define __sin __knc_musl_sin
#define __cos __knc_musl_cos
#define __sindf __knc_musl_sindf
#define __cosdf __knc_musl_cosdf
#define __rem_pio2 __knc_musl_rem_pio2
#define __rem_pio2f __knc_musl_rem_pio2f
#define __rem_pio2_large __knc_musl_rem_pio2_large
#define __tan __knc_musl_tan
#define __sinl __knc_musl_sinl
#define __cosl __knc_musl_cosl
#define __tanl __knc_musl_tanl
#endif
