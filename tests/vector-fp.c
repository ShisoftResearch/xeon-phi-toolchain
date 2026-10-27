#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "vector-fp-corpus.h"
extern void fma_f32(void*,const void*,const void*,const void*),fma_f64(void*,const void*,const void*,const void*);
extern void convert_i32_f32(void*,const void*),convert_u32_f32(void*,const void*),convert_f32_i32(void*,const void*),convert_f32_u32(void*,const void*);
#define CHECK(C) do{if(!(C)){printf("FAIL vector FP line=%d case=%u lane=%u\n",__LINE__,n,k);return 1;}}while(0)
int main(void){
 unsigned n=0,k=0;
 uint32_t a[16] __attribute__((aligned(64))),b[16] __attribute__((aligned(64))),c[16] __attribute__((aligned(64))),o[16] __attribute__((aligned(64)));
 uint64_t da[8] __attribute__((aligned(64))),db[8] __attribute__((aligned(64))),dc[8] __attribute__((aligned(64))),dout[8] __attribute__((aligned(64)));
 unsigned count=sizeof(fma32_cases)/sizeof(fma32_cases[0]);
 for(n=0;n<count;n+=16){for(k=0;k<16;k++){unsigned i=(n+k)%count;a[k]=fma32_cases[i].a;b[k]=fma32_cases[i].b;c[k]=fma32_cases[i].c;}fma_f32(o,a,b,c);for(k=0;k<16;k++)CHECK(o[k]==fma32_cases[(n+k)%count].expected);}
 count=sizeof(fma64_cases)/sizeof(fma64_cases[0]);
 for(n=0;n<count;n+=8){for(k=0;k<8;k++){unsigned i=(n+k)%count;da[k]=fma64_cases[i].a;db[k]=fma64_cases[i].b;dc[k]=fma64_cases[i].c;}fma_f64(dout,da,db,dc);for(k=0;k<8;k++)CHECK(dout[k]==fma64_cases[(n+k)%count].expected);}
 count=sizeof(cvt_cases)/sizeof(cvt_cases[0]);
 for(n=0;n<count;n+=16){
  for(k=0;k<16;k++)a[k]=cvt_cases[(n+k)%count].input;
  convert_i32_f32(o,a);for(k=0;k<16;k++)CHECK(o[k]==cvt_cases[(n+k)%count].signed_expected);
  convert_u32_f32(o,a);for(k=0;k<16;k++)CHECK(o[k]==cvt_cases[(n+k)%count].unsigned_expected);
 }
 float fa[16] __attribute__((aligned(64)));
 for(n=0;n<1000;n++){
  for(k=0;k<16;k++)fa[k]=((int32_t)(n*71923+k*27067)%1000000000-500000000)*0.25f;
  convert_f32_i32(o,fa);for(k=0;k<16;k++)CHECK(o[k]==(uint32_t)(int32_t)fa[k]);
  for(k=0;k<16;k++)fa[k]=((uint32_t)(n*7192307+k*27067)%4000000000U)+0.75f;
  convert_f32_u32(o,fa);for(k=0;k<16;k++)CHECK(o[k]==(uint32_t)fa[k]);
 }
 puts("PASS LLVM vector FP: 2056 exact fused-rounding FMA cases, 2064 exact int32/uint32-to-FP32 cases, 32000 valid FP32-to-integer lane conversions");return 0;
}
