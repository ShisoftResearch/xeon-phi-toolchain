/* Bridge the scalar Rust ABI to MPSS libm's native ZMM argument/return ABI. */
#include <stdint.h>
#include <math.h>
typedef union {uint64_t u;double f;} fp64;
typedef union {uint32_t u;float f;} fp32;
#define KNC_MATH_UNARY(N) \
uint64_t __knc_math_##N(uint64_t a){fp64 x={.u=a},r;r.f=N(x.f);return r.u;} \
uint32_t __knc_math_##N##f(uint32_t a){fp32 x={.u=a},r;r.f=N##f(x.f);return r.u;}
#define KNC_MATH_BINARY(N) \
uint64_t __knc_math_##N(uint64_t a,uint64_t b){fp64 x={.u=a},y={.u=b},r;r.f=N(x.f,y.f);return r.u;} \
uint32_t __knc_math_##N##f(uint32_t a,uint32_t b){fp32 x={.u=a},y={.u=b},r;r.f=N##f(x.f,y.f);return r.u;}
#define KNC_MATH_TERNARY(N) \
uint64_t __knc_math_##N(uint64_t a,uint64_t b,uint64_t c){fp64 x={.u=a},y={.u=b},z={.u=c},r;r.f=N(x.f,y.f,z.f);return r.u;} \
uint32_t __knc_math_##N##f(uint32_t a,uint32_t b,uint32_t c){fp32 x={.u=a},y={.u=b},z={.u=c},r;r.f=N##f(x.f,y.f,z.f);return r.u;}
#define KNC_MATH_SOFT_UNARY(N)
#define KNC_MATH_SOFT_BINARY(N)
#define KNC_MATH_SOFT_TERNARY(N)
#include "KNCMath.def"
