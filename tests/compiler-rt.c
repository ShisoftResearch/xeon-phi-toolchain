#include <stdint.h>
#include <stdio.h>
#include <fenv.h>
#include <errno.h>
#include "fp-corpus.h"
extern void clang_fp32(const uint32_t*,const uint32_t*,uint32_t*,unsigned),clang_fp64(const uint64_t*,const uint64_t*,uint64_t*,unsigned);
static int check_sqrt_environment(void){
 const int modes[]={FE_TONEAREST,FE_DOWNWARD,FE_UPWARD,FE_TOWARDZERO};
 const uint32_t expected32[]={0x3fb504f3,0x3fb504f3,0x3fb504f4,0x3fb504f3};
 const uint64_t expected64[]={0x3ff6a09e667f3bcdULL,0x3ff6a09e667f3bccULL,0x3ff6a09e667f3bcdULL,0x3ff6a09e667f3bccULL};
 uint32_t a32=0x40000000,b32=0,out32;uint64_t a64=0x4000000000000000ULL,b64=0,out64;
 for(unsigned i=0;i<4;i++){
  if(fesetround(modes[i]))return 1;
  feclearexcept(FE_ALL_EXCEPT);clang_fp32(&a32,&b32,&out32,5);
  if(out32!=expected32[i]||fetestexcept(FE_ALL_EXCEPT)!=FE_INEXACT){printf("FAIL sqrt32 mode=%u result=%08x flags=%x\n",i,out32,fetestexcept(FE_ALL_EXCEPT));return 1;}
  feclearexcept(FE_ALL_EXCEPT);clang_fp64(&a64,&b64,&out64,5);
  if(out64!=expected64[i]||fetestexcept(FE_ALL_EXCEPT)!=FE_INEXACT){printf("FAIL sqrt64 mode=%u result=%016llx flags=%x\n",i,(unsigned long long)out64,fetestexcept(FE_ALL_EXCEPT));return 1;}
 }
 fesetround(FE_TONEAREST);a64=0x4010000000000000ULL;
 feclearexcept(FE_ALL_EXCEPT);clang_fp64(&a64,&b64,&out64,5);
 if(out64!=0x4000000000000000ULL||fetestexcept(FE_ALL_EXCEPT))return 1;
 a64=0xbff0000000000000ULL;errno=0;
 clang_fp64(&a64,&b64,&out64,5);
 if((out64&0x7fffffffffffffffULL)<=0x7ff0000000000000ULL||errno!=EDOM||fetestexcept(FE_ALL_EXCEPT)!=FE_INVALID)return 1;
 a64=0x7ff0000000000001ULL;feclearexcept(FE_ALL_EXCEPT);
 clang_fp64(&a64,&b64,&out64,5);
 if(out64!=0x7ff8000000000001ULL||fetestexcept(FE_ALL_EXCEPT)!=FE_INVALID)return 1;
 feclearexcept(FE_ALL_EXCEPT);return 0;
}
int main(void){
 if(check_sqrt_environment()){puts("FAIL sqrt environment");return 1;}
 unsigned n=0;
 for(unsigned i=0;i<sizeof(fp32_cases)/sizeof(fp32_cases[0]);i++){
  const struct fp32_case *c=fp32_cases+i;uint32_t out;clang_fp32(&c->a,&c->b,&out,c->op);
  if(c->nan?((out&0x7fffffff)<=0x7f800000):out!=c->expected){printf("FAIL clang FP32 case=%u op=%u got=%08x expected=%08x\n",i,c->op,out,c->expected);return 1;}n++;
 }
 for(unsigned i=0;i<sizeof(fp64_cases)/sizeof(fp64_cases[0]);i++){
  const struct fp64_case *c=fp64_cases+i;uint64_t out;clang_fp64(&c->a,&c->b,&out,c->op);
  if(c->nan?((out&0x7fffffffffffffffULL)<=0x7ff0000000000000ULL):out!=c->expected){printf("FAIL clang FP64 case=%u op=%u got=%016llx expected=%016llx\n",i,c->op,(unsigned long long)out,(unsigned long long)c->expected);return 1;}n++;
 }
 printf("PASS standalone KNC Clang/compiler-rt: %u exact IEEE scalar arithmetic, comparison/select and sqrt cases; sqrt directed rounding/exception checks; no Rust runtime\n",n);return 0;
}
