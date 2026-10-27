/* Ordinary C clients of the KNC backend; no forced vector widths. */
#include <stdint.h>
#include <stddef.h>
__attribute__((noinline)) void scaling_fp32(float *restrict out,const float *restrict a,const float *restrict b,size_t n){
 for(size_t i=0;i<n;++i)out[i]=a[i]*b[i]+3.0f;
}
__attribute__((noinline)) double scaling_fp64(const double *restrict a,const double *restrict b,size_t n){
#pragma clang fp reassociate(on)
 double sum=0;for(size_t i=0;i<n;++i)sum+=a[i]*b[i];return sum;
}
__attribute__((noinline)) uint32_t scaling_q8(const int8_t *restrict a,const int8_t *restrict b,size_t n){
 uint32_t sum=0;for(size_t i=0;i<n;++i)sum+=(int32_t)a[i]*(int32_t)b[i];return sum;
}
