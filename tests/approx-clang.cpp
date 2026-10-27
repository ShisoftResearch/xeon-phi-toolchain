// Ordinary mathematical vector expressions; no SSE/AVX feature impersonation.
#if defined(__SSE__) || defined(__AVX__) || defined(__AVX512F__)
#error K1OM must not advertise a different ISA to select this kernel
#endif
typedef float f32x16 __attribute__((ext_vector_type(16)));
typedef double f64x8 __attribute__((ext_vector_type(8)));
#define KERNELS(W,T) \
extern "C" void clang_approx_div_##W(void*out,const void*a,const void*b){ \
 T x,y;__builtin_memcpy(&x,a,64);__builtin_memcpy(&y,b,64);T z=x/y;__builtin_memcpy(out,&z,64); } \
extern "C" void clang_approx_sqrt_##W(void*out,const void*a,const void*){ \
 T x;__builtin_memcpy(&x,a,64);T z=__builtin_elementwise_sqrt(x);__builtin_memcpy(out,&z,64); }
KERNELS(32,f32x16)
KERNELS(64,f64x8)
