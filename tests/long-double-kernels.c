#include <stdint.h>
__attribute__((noinline)) long double f80_identity(long double a){return a;}
__attribute__((noinline)) long double f80_add(long double a,long double b){return a+b;}
__attribute__((noinline)) long double f80_sub(long double a,long double b){return a-b;}
__attribute__((noinline)) long double f80_mul(long double a,long double b){return a*b;}
__attribute__((noinline)) long double f80_div(long double a,long double b){return a/b;}
__attribute__((noinline)) long double f80_sqrt(long double a){return __builtin_sqrtl(a);}
__attribute__((noinline)) unsigned f80_compare(long double a,long double b){return (a==b)|((a!=b)<<1)|((a<b)<<2)|((a<=b)<<3)|((a>b)<<4)|((a>=b)<<5)|(__builtin_isunordered(a,b)<<6);}
__attribute__((noinline)) double f80_to_f64(long double a){return (double)a;}
__attribute__((noinline)) float f80_to_f32(long double a){return (float)a;}
__attribute__((noinline)) long double f80_from_f64(double a){return (long double)a;}
__attribute__((noinline)) long double f80_from_f32(float a){return (long double)a;}
__attribute__((noinline)) int64_t f80_to_i64(long double a){return (int64_t)a;}
__attribute__((noinline)) uint64_t f80_to_u64(long double a){return (uint64_t)a;}
__attribute__((noinline)) long double f80_from_i64(int64_t a){return (long double)a;}
__attribute__((noinline)) long double f80_from_u64(uint64_t a){return (long double)a;}
__attribute__((noinline)) long double f80_select(long double a,long double b,int pick){return pick?a:b;}
struct f80_pair{long double x,y;};
__attribute__((noinline)) struct f80_pair f80_swap(struct f80_pair a){struct f80_pair b={a.y,a.x};return b;}
__attribute__((noinline)) long double f80_callback(long double a,long double(*fn)(long double)){return fn(a);}
__attribute__((noinline)) long double f80_ten(long double a,long double b,long double c,long double d,long double e,long double f,long double g,long double h,long double i,long double j){return a+b+c+d+e+f+g+h+i+j;}

#define SMALL(W) \
__attribute__((noinline)) long double f80_from_i##W(int##W##_t a){return a;} \
__attribute__((noinline)) long double f80_from_u##W(uint##W##_t a){return a;} \
__attribute__((noinline)) int##W##_t f80_to_i##W(long double a){return a;} \
__attribute__((noinline)) uint##W##_t f80_to_u##W(long double a){return a;}
SMALL(8)
SMALL(16)
SMALL(32)
