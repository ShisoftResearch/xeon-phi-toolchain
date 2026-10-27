#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "fp-bits.h"
#define DECL(N) extern float N##f(float,float);extern double N(double,double);
DECL(fmin) DECL(fmax) DECL(fminimum) DECL(fmaximum) DECL(fminimum_num) DECL(fmaximum_num)
static float(*fns32[])(float,float)={fminf,fmaxf,fminimumf,fmaximumf,fminimum_numf,fmaximum_numf};
static double(*fns64[])(double,double)={fmin,fmax,fminimum,fmaximum,fminimum_num,fmaximum_num};
int main(void){
 size_t checks=0;
 for(unsigned w=32;w<=64;w+=32){
  uint64_t sign=UINT64_C(1)<<(w-1),inf=w==32?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000),quiet=UINT64_C(1)<<(w==32?22:51),mask=UINT64_MAX>>(64-w);
  uint64_t edges[]={0,sign,1,sign|1,inf-1,sign|(inf-1),inf,sign|inf,inf+1,sign|(inf+1),inf|quiet,sign|inf|quiet,(inf|quiet)+1};
  unsigned count=sizeof(edges)/sizeof(edges[0]);
  for(unsigned i=0;i<12000;++i){
   uint64_t x=i<count*count?edges[i%count]:next()&mask,y=i<count*count?edges[i/count]:next()&mask;
   for(unsigned op=0;op<6;++op){
    uint64_t actual;
    if(w==32){union{float f;uint32_t u;}a,b,r;a.u=x;b.u=y;r.f=fns32[op](a.f,b.f);actual=r.u;}
    else {union{double f;uint64_t u;}a,b,r;a.u=x;b.u=y;r.f=fns64[op](a.f,b.f);actual=r.u;}
    uint64_t want=minimum(op,x,y,w);++checks;
    int ok=isnanbits(want,w)?isnanbits(actual,w)&&!signaling(actual,w):actual==want;
    if(!ok){printf("FAIL minmax runtime w=%u op=%u input=%016llx/%016llx got=%016llx expected=%016llx\n",w,op,(unsigned long long)x,(unsigned long long)y,(unsigned long long)actual,(unsigned long long)want);return 1;}
   }
  }
 }
 printf("PASS minmax runtime: %zu exact/classified results across twelve native-ABI helpers; signed zeros, quiet/signaling NaNs, infinities, subnormals and random encodings\n",checks);return 0;
}
