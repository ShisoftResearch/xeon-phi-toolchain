/* Correctly rounded binary32/binary64 square root for the native KNC runtime.
 * Integer restoring square root avoids the SDK libm's x87 double rounding.
 */
#include <stdint.h>
#include <string.h>
#include <errno.h>
#include <fenv.h>

static uint64_t sqrt_bits(uint64_t bits,unsigned fraction,unsigned exponent){
 const uint64_t sign=UINT64_C(1)<<(fraction+exponent);
 const uint64_t mantissa_mask=(UINT64_C(1)<<fraction)-1;
 const uint64_t exponent_mask=(UINT64_C(1)<<exponent)-1;
 const uint64_t quiet=UINT64_C(1)<<(fraction-1);
 uint64_t m=bits&mantissa_mask,raw=(bits>>fraction)&exponent_mask;
 if(raw==exponent_mask&&m){if(!(m&quiet))feraiseexcept(FE_INVALID);return bits|quiet;}
 if(!(bits&~sign))return bits;
 if(bits&sign){errno=EDOM;feraiseexcept(FE_INVALID);return (exponent_mask<<fraction)|quiet;}
 if(raw==exponent_mask)return bits;
 int bias=(1<<(exponent-1))-1;
 int e=raw?(int)raw-bias:1-bias;
 if(raw)m|=UINT64_C(1)<<fraction;
 else while(m<(UINT64_C(1)<<fraction)){m<<=1;--e;}
 if(e&1){m<<=1;--e;}
 __uint128_t radicand=(__uint128_t)m<<fraction;
 uint64_t root=0,remainder=0;
 for(int i=(int)fraction;i>=0;--i){
  remainder=(remainder<<2)|(uint64_t)((radicand>>(2*i))&3);
  root<<=1;uint64_t trial=(root<<1)|1;
  if(remainder>=trial){remainder-=trial;++root;}
 }
 int rounding=fegetround();
 if(remainder){
  if(rounding==FE_UPWARD||(rounding==FE_TONEAREST&&remainder>root))++root;
  feraiseexcept(FE_INEXACT);
 }
 int result_exponent=e/2;
 if(root==(UINT64_C(1)<<(fraction+1))){root>>=1;++result_exponent;}
 return ((uint64_t)(result_exponent+bias)<<fraction)|(root&mantissa_mask);
}
__attribute__((weak)) float sqrtf(float x){uint32_t b;memcpy(&b,&x,4);b=(uint32_t)sqrt_bits(b,23,8);memcpy(&x,&b,4);return x;}
__attribute__((weak)) double sqrt(double x){uint64_t b;memcpy(&b,&x,8);b=sqrt_bits(b,52,11);memcpy(&x,&b,8);return x;}
