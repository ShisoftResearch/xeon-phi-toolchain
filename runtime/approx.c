/* Guarded approximate KNC vector math. Default RNE environment, <=4 ULP value
 * contract. Called only with LLVM afn permission (and arcp for division).
 * These kernels are separate from the metadata-only capability matcher.
 *
 * Seed instructions flush denormal inputs/results. Only normal inputs with
 * unbiased exponents in [-60,60] enter refinement; all other lanes use the
 * existing scalar runtime. Bad lanes are replaced with one before seed/FMA
 * evaluation. FP exception state and NaN payload identity are not promised.
 */
#include <stdint.h>
typedef float v16f32 __attribute__((ext_vector_type(16)));
typedef float v8f32 __attribute__((ext_vector_type(8)));
typedef double v8f64 __attribute__((ext_vector_type(8)));
typedef union {v16f32 v;float f[16];uint32_t u[16];} lanes32;
typedef union {v8f64 v;double f[8];uint64_t u[8];} lanes64;
extern void __knc_rcp23_f32(float*,const float*),__knc_rsqrt23_f32(float*,const float*);
extern float __divsf3(float,float),sqrtf(float);
extern double __divdf3(double,double),sqrt(double);
#define FMA(A,B,C) __builtin_elementwise_fma((A),(B),(C))
static int domain32(uint32_t x){unsigned e=(x>>23)&255;return e>=67&&e<=187;}
static int domain64(uint64_t x){unsigned e=(unsigned)(x>>52)&2047;return e>=963&&e<=1083;}
/* The lowering allocates all interface buffers with 64-byte alignment. */
#define LOAD(D,P) __builtin_memcpy(&(D),__builtin_assume_aligned((P),64),64)
#define STORE(P,D) __builtin_memcpy(__builtin_assume_aligned((P),64),&(D),64)
void __knc_div_v16f32_approx(float *result,const float *x,const float *y){
 lanes32 a,b;LOAD(a,x);LOAD(b,y);lanes32 safe_a=a,safe_b=b,seed;unsigned bad=0;
 for(unsigned i=0;i<16;i++)if(!domain32(a.u[i])||!domain32(b.u[i])){
  bad|=1u<<i;safe_a.u[i]=safe_b.u[i]=0x3f800000;
 }
 __knc_rcp23_f32(seed.f,safe_b.f);v16f32 r=seed.v;
 r=FMA(FMA(-safe_b.v,r,(v16f32)1.0f),r,r);
 v16f32 q=safe_a.v*r;
 lanes32 out={.v=FMA(FMA(-safe_b.v,q,safe_a.v),r,q)};
 if(bad)for(unsigned i=0;i<16;i++)if(bad&(1u<<i))out.f[i]=__divsf3(a.f[i],b.f[i]);
 STORE(result,out);
}
void __knc_sqrt_v16f32_approx(float *result,const float *x){
 lanes32 a;LOAD(a,x);lanes32 safe=a,seed;unsigned bad=0;
 for(unsigned i=0;i<16;i++)if(!domain32(a.u[i])||(a.u[i]>>31)){
  bad|=1u<<i;safe.u[i]=0x3f800000;
 }
 __knc_rsqrt23_f32(seed.f,safe.f);v16f32 r=seed.v,q=safe.v*r;
 r=FMA(0.5f*r,FMA(-q,r,(v16f32)1.0f),r);
 q=safe.v*r;
 lanes32 out={.v=FMA(0.5f*r,FMA(-q,q,safe.v),q)};
 if(bad)for(unsigned i=0;i<16;i++)if(bad&(1u<<i))out.f[i]=sqrtf(a.f[i]);
 STORE(result,out);
}
/* Eight doubles use low FP32 seed lanes, then refine against the original
 * double input twice. Narrowing the seed argument is not the final result. */
static v8f64 seed64(const lanes64 *x,int reciprocal){
 v8f32 narrow=__builtin_convertvector(x->v,v8f32);
 lanes32 input;
 for(unsigned i=0;i<8;i++)input.f[i]=narrow[i];
 for(unsigned i=8;i<16;i++)input.f[i]=1;
 lanes32 seed;
 if(reciprocal)__knc_rcp23_f32(seed.f,input.f);else __knc_rsqrt23_f32(seed.f,input.f);
 return __builtin_convertvector(seed.v.lo,v8f64);
}
void __knc_div_v8f64_approx(double *result,const double *x,const double *y){
 lanes64 a,b;LOAD(a,x);LOAD(b,y);lanes64 safe_a=a,safe_b=b;unsigned bad=0;
 for(unsigned i=0;i<8;i++)if(!domain64(a.u[i])||!domain64(b.u[i])){
  bad|=1u<<i;safe_a.u[i]=safe_b.u[i]=UINT64_C(0x3ff0000000000000);
 }
 v8f64 r=seed64(&safe_b,1);
 for(unsigned i=0;i<2;i++)r=FMA(FMA(-safe_b.v,r,(v8f64)1.0),r,r);
 v8f64 q=safe_a.v*r;
 lanes64 out={.v=FMA(FMA(-safe_b.v,q,safe_a.v),r,q)};
 if(bad)for(unsigned i=0;i<8;i++)if(bad&(1u<<i))out.f[i]=__divdf3(a.f[i],b.f[i]);
 STORE(result,out);
}
void __knc_sqrt_v8f64_approx(double *result,const double *x){
 lanes64 a;LOAD(a,x);lanes64 safe=a;unsigned bad=0;
 for(unsigned i=0;i<8;i++)if(!domain64(a.u[i])||(a.u[i]>>63)){
  bad|=1u<<i;safe.u[i]=UINT64_C(0x3ff0000000000000);
 }
 v8f64 r=seed64(&safe,0);
 for(unsigned i=0;i<2;i++){
  v8f64 q=safe.v*r;
  r=FMA(0.5*r,FMA(-q,r,(v8f64)1.0),r);
 }
 v8f64 q=safe.v*r;
 lanes64 out={.v=FMA(0.5*r,FMA(-q,q,safe.v),q)};
 if(bad)for(unsigned i=0;i<8;i++)if(bad&(1u<<i))out.f[i]=sqrt(a.f[i]);
 STORE(result,out);
}
