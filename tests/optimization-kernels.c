/* Ordinary loops for Stage 5 cost-model tuning; no forced vector widths or
 * KNC intrinsics. Each path needs hardware oracles before gate completion. */
#include <stddef.h>
#include <stdint.h>
#define NOINLINE __attribute__((noinline))
NOINLINE void cast_i32_f64(double *restrict y,const int32_t *restrict x,size_t n){for(size_t i=0;i<n;i++)y[i]=(double)x[i];}
NOINLINE void cast_u32_f64(double *restrict y,const uint32_t *restrict x,size_t n){for(size_t i=0;i<n;i++)y[i]=(double)x[i];}
NOINLINE void cast_f64_i32(int32_t *restrict y,const double *restrict x,size_t n){for(size_t i=0;i<n;i++)y[i]=(int32_t)x[i];}
NOINLINE void cast_f32_f64(double *restrict y,const float *restrict x,size_t n){for(size_t i=0;i<n;i++)y[i]=(double)x[i];}
NOINLINE void cast_f64_f32(float *restrict y,const double *restrict x,size_t n){for(size_t i=0;i<n;i++)y[i]=(float)x[i];}
NOINLINE void affine_i16_f32(float *restrict y,const int16_t *restrict x,const float *restrict scale,size_t n){for(size_t i=0;i<n;i++)y[i]=(float)x[i]*scale[i];}
NOINLINE void affine_i32_f64(double *restrict y,const int32_t *restrict x,const double *restrict scale,size_t n){for(size_t i=0;i<n;i++)y[i]=(double)x[i]*scale[i];}
NOINLINE double dot_f64_ordered(const double *restrict a,const double *restrict b,size_t n){double sum=0;for(size_t i=0;i<n;i++)sum+=a[i]*b[i];return sum;}
NOINLINE double dot_f64_reassoc(const double *restrict a,const double *restrict b,size_t n){
#pragma clang fp reassociate(on)
 double sum=0;for(size_t i=0;i<n;i++)sum+=a[i]*b[i];return sum;
}
NOINLINE void clamp_f64(double *restrict y,const double *restrict x,size_t n){for(size_t i=0;i<n;i++){double v=x[i];y[i]=v<0?0:v>6?6:v;}}
