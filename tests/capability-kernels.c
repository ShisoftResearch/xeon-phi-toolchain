/* Application kernels built from generic vector arithmetic. No ISA aliases.
   The matching layer checks prerequisites in the separate test client. */
#include <stdint.h>
#include <string.h>
typedef int8_t s8x16 __attribute__((ext_vector_type(16)));
typedef uint8_t u8x16 __attribute__((ext_vector_type(16)));
typedef int32_t s32x16 __attribute__((ext_vector_type(16)));
typedef float f32x16 __attribute__((ext_vector_type(16)));
void capability_dot_i8(int32_t *out,const int8_t *a,const int8_t *b){
 s8x16 x,y;memcpy(&x,a,16);memcpy(&y,b,16);
 s32x16 p=__builtin_convertvector(x,s32x16)*__builtin_convertvector(y,s32x16);
 *out=__builtin_reduce_add(p);
}
void capability_affine_f32(void *out,const void *a,const void *b,const void *c){
 f32x16 x,y,z;memcpy(&x,a,64);memcpy(&y,b,64);memcpy(&z,c,64);
 f32x16 v=__builtin_elementwise_fma(x,y,z);memcpy(out,&v,64);
}
/* One nibble-pair statistic, exact multiples of 1/8. Its signed center and
   layout are application choices, not the semantics of an AVX instruction. */
void capability_dequant_pairs(float *out,const uint8_t *a){
 u8x16 x;memcpy(&x,a,16);s32x16 u=__builtin_convertvector(x,s32x16);
 s32x16 centered=(u&15)+(u>>4)-15;
 f32x16 v=__builtin_convertvector(centered,f32x16)*0.125f;memcpy(out,&v,64);
}
