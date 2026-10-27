#include <stdint.h>
#include <string.h>
#ifndef PREFIX
#define PREFIX native_
#endif
#define CAT_(a,b) a##b
#define CAT(a,b) CAT_(a,b)
#define FN(n) CAT(PREFIX,n)
typedef uint32_t u32x16 __attribute__((ext_vector_type(16)));
typedef uint64_t u64x8 __attribute__((ext_vector_type(8)));
float FN(load32)(const void *p) { float x;memcpy(&x,p,4);return x; }
double FN(load64)(const void *p) { double x;memcpy(&x,p,8);return x; }
void FN(splat32)(const void *p,void *out) {
 uint32_t x;memcpy(&x,p,4);u32x16 v={x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x};memcpy(out,&v,64);
}
void FN(splat64)(const void *p,void *out) {
 uint64_t x;memcpy(&x,p,8);u64x8 v={x,x,x,x,x,x,x,x};memcpy(out,&v,64);
}
float FN(alias32)(float *p,float x) { float old=*p;*p=x;return old*x; }
double FN(alias64)(double *p,double x) { double old=*p;*p=x;return old*x; }
float FN(multi32)(float *p,float *out,float x) { float old=*p;*out=old;*p=x;return old*x; }
double FN(multi64)(double *p,double *out,double x) { double old=*p;*out=old;*p=x;return old*x; }
float FN(aligned32)(const void *p) { return *(const float *)p; }
double FN(aligned64)(const void *p) { return *(const double *)p; }
void FN(aligned_splat32)(const void *p,void *out) {
 uint32_t x=*(const uint32_t *)p;u32x16 v={x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x};memcpy(out,&v,64);
}
void FN(aligned_splat64)(const void *p,void *out) {
 uint64_t x=*(const uint64_t *)p;u64x8 v={x,x,x,x,x,x,x,x};memcpy(out,&v,64);
}
static __thread uint32_t tls_bits32;
static __thread uint64_t tls_bits64;
void FN(tls_set)(uint32_t a,uint64_t b) { tls_bits32=a;tls_bits64=b; }
float FN(tls32)(void) { float x;memcpy(&x,&tls_bits32,4);return x; }
double FN(tls64)(void) { double x;memcpy(&x,&tls_bits64,8);return x; }
