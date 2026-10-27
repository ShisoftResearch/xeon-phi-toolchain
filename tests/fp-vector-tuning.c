#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#define K(F,K,N,W) extern void F(void*,const void*,const void*),before_##F(void*,const void*,const void*);
#include "fp-vector-tuning-cases.h"
#undef K
struct test {const char *name;unsigned kind,n,w;void(*fn[2])(void*,const void*,const void*);};
#define K(F,K,N,W) {#F,K,N,W,{before_##F,F}},
static const struct test tests[]={
#include "fp-vector-tuning-cases.h"
};
#undef K
static uint64_t now(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return(uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
#define CHECK(X) do{if(!(X)){printf("FAIL FP vector tuning line=%d case=%s\n",__LINE__,t->name);return 1;}}while(0)
int main(void){
 for(unsigned k=0;k<sizeof(tests)/sizeof(tests[0]);k++){
  const struct test*t=tests+k;
  unsigned char input[256] __attribute__((aligned(64))),out[256] __attribute__((aligned(64))),reference[256] __attribute__((aligned(64))),start[8];
  memset(input,0,sizeof(input));memset(out,0xa5,sizeof(out));memset(reference,0xa5,sizeof(reference));
  for(unsigned i=0;i<t->n;i++){
   if(t->kind==0){int32_t x=((int32_t)i-16)*32767;memcpy(input+4*i,&x,4);}
   else if(t->kind==1){uint32_t x=UINT32_C(0x80000000)+i*1234567;memcpy(input+4*i,&x,4);}
   else if(t->kind<4){double x=t->kind==2?((int)i-16)*0.25:0.5+i*0.0625;memcpy(input+8*i,&x,8);}
   else{double x=t->kind<6?(double)i*0.25-2:(i&1?2.0:0.5);if(t->w==32){float f=(float)x;memcpy(input+4*i,&f,4);}else memcpy(input+8*i,&x,8);}
  }
  if(t->w==32){float x=t->kind<6?0.25f:0.5f;memcpy(start,&x,4);}else{double x=t->kind<6?0.25:0.5;memcpy(start,&x,8);}
  t->fn[0](reference,input,start);t->fn[1](out,input,start);CHECK(!memcmp(reference,out,256));
  /* Independent mathematical checks for the simple dyadic workload. */
  if(t->kind<2)for(unsigned i=0;i<t->n;i++){
   double r,expected;memcpy(&r,out+8*i,8);
   if(t->kind==0){int32_t x;memcpy(&x,input+4*i,4);expected=(double)x;}else{uint32_t x;memcpy(&x,input+4*i,4);expected=(double)x;}
   CHECK(r==expected);
  }
  if(t->kind>=2&&t->kind<4)for(unsigned i=0;i<t->n;i++){
   double x;uint32_t r;memcpy(&x,input+8*i,8);memcpy(&r,out+4*i,4);
   CHECK(r==(t->kind==2?(uint32_t)(int32_t)x:(uint32_t)x));
  }
  if(t->kind>=4){double expected=t->kind<6?0.25:0.5;
   for(unsigned i=0;i<t->n;i++){double x=(double)i*0.25-2;if(t->kind<6)expected+=x;else expected*=i&1?2.0:0.5;}
   if(t->w==32){float r;memcpy(&r,out,4);CHECK(r==(float)expected);}else{double r;memcpy(&r,out,8);CHECK(r==expected);}
  }
  for(unsigned path=0;path<2;path++)for(unsigned i=0;i<128;i++)t->fn[path](out,input,start);
  for(unsigned round=0;round<5;round++)for(unsigned order=0;order<2;order++){
   unsigned path=(order+round)%2;uint64_t begin=now();
   for(unsigned i=0;i<20000;i++)t->fn[path](out,input,start);
   uint64_t elapsed=now()-begin;CHECK(!memcmp(reference,out,256));
   printf("TIMING fp_vector case=%s path=%s round=%u iterations=20000 ns=%llu\n",t->name,path?"after":"before",round,(unsigned long long)elapsed);
  }
 }
 puts("PASS FP vector tuning: 20 kernel pairs, independent dyadic/integer oracles, canaries, optimization-disabled baseline, alternating timing order");return 0;
}
