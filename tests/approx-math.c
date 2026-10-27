#define _POSIX_C_SOURCE 200809L
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/mman.h>
#include <unistd.h>
#include "approx-corpus.h"
#define K(N,W) extern void approx_div_##N##_##W(void*,const void*,const void*),approx_sqrt_##N##_##W(void*,const void*,const void*);
#include "approx-cases.h"
#undef K
struct kernel {unsigned n,w;void(*div)(void*,const void*,const void*),(*sqrt)(void*,const void*,const void*);};
extern void clang_approx_div_32(void*,const void*,const void*),clang_approx_sqrt_32(void*,const void*,const void*);
extern void clang_approx_div_64(void*,const void*,const void*),clang_approx_sqrt_64(void*,const void*,const void*);
#define K(N,W) {N,W,approx_div_##N##_##W,approx_sqrt_##N##_##W},
static const struct kernel kernels[]={
#include "approx-cases.h"
 {16,32,clang_approx_div_32,clang_approx_sqrt_32},
 {8,64,clang_approx_div_64,clang_approx_sqrt_64},
};
#undef K
extern void __knc_rcp23_f32(void*,const void*),__knc_rsqrt23_f32(void*,const void*);
extern void vector_div16_f32(void*,const void*,const void*),vector_sqrt16_f32(void*,const void*,const void*);
extern void vector_div8_f64(void*,const void*,const void*),vector_sqrt8_f64(void*,const void*,const void*);
static void(*reference[2][2])(void*,const void*,const void*)={{vector_div16_f32,vector_sqrt16_f32},{vector_div8_f64,vector_sqrt8_f64}};
static uint64_t get(const void*p,unsigned i,unsigned bytes){uint64_t x=0;memcpy(&x,(const char*)p+i*bytes,bytes);return x;}
static void put(void*p,unsigned i,unsigned bytes,uint64_t x){memcpy((char*)p+i*bytes,&x,bytes);}
static int isnanbits(uint64_t x,unsigned w){uint64_t mask=w==32?UINT64_C(0x7fffffff):UINT64_C(0x7fffffffffffffff),inf=w==32?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000);return(x&mask)>inf;}
static int domain(uint64_t x,unsigned w){unsigned f=w==32?23:52,bias=w==32?127:1023,e=(unsigned)(x>>f)&(w==32?255:2047);return e>=bias-60&&e<=bias+60;}
static uint64_t now(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return(uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
#define CHECK(X) do{if(!(X)){printf("FAIL approximate math line=%d\n",__LINE__);return 1;}}while(0)
int main(void){
 uint64_t checks=0,fast_checks=0,fallback_checks=0,max_ulp[2][2]={{0,0},{0,0}};
 size_t page=(size_t)sysconf(_SC_PAGESIZE);
 unsigned char *map=mmap(0,12*page,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);CHECK(map!=MAP_FAILED);
 for(unsigned i=0;i<4;i++)CHECK(!mprotect(map+(i*3+1)*page,page,PROT_READ|PROT_WRITE));
 for(unsigned ki=0;ki<sizeof(kernels)/sizeof(kernels[0]);ki++){
  const struct kernel*k=kernels+ki;unsigned bytes=k->w/8;
  const struct approx_case*cases=k->w==32?approx_cases32:approx_cases64;
  size_t count=k->w==32?sizeof(approx_cases32)/sizeof(approx_cases32[0]):sizeof(approx_cases64)/sizeof(approx_cases64[0]);
  /* Put exactly the live vector at a page endpoint. Narrow vectors must not
     acquire a full-register memory overread while widening for the call. */
  void *a=map+2*page-k->n*bytes,*b=map+5*page-k->n*bytes,*out=map+8*page-k->n*bytes;
  for(size_t base=0;base<count;base+=k->n){
   for(unsigned lane=0;lane<k->n;lane++){const struct approx_case*c=cases+(base+lane)%count;put(a,lane,bytes,c->a);put(b,lane,bytes,c->b);}
   for(unsigned op=0;op<2;op++){
    (op?k->sqrt:k->div)(out,a,b);
    for(unsigned lane=0;lane<k->n;lane++){
     const struct approx_case*c=cases+(base+lane)%count;uint64_t ref=op?c->sqrt:c->div,r=get(out,lane,bytes);
     int fast=domain(c->a,k->w)&&(op?!(c->a>>(k->w-1)):domain(c->b,k->w));
     uint64_t err=r>ref?r-ref:ref-r,limit=fast?4:0;
     if(isnanbits(ref,k->w)){CHECK(isnanbits(r,k->w));err=0;}
     else if(err>limit){printf("FAIL approx w=%u n=%u op=%u case=%lu lane=%u fast=%d a=%llx b=%llx got=%llx ref=%llx ulp=%llu\n",k->w,k->n,op,(unsigned long)base,lane,fast,(unsigned long long)c->a,(unsigned long long)c->b,(unsigned long long)r,(unsigned long long)ref,(unsigned long long)err);return 1;}
     if(fast){fast_checks++;if(err>max_ulp[k->w==64][op])max_ulp[k->w==64][op]=err;}else fallback_checks++;
     checks++;
    }
   }
  }
 }
 CHECK(!munmap(map,12*page));
 /* Exact powers and documented seed exceptional-value handling, including
    signed denormals being treated as signed zero by the seed instruction. */
 uint32_t input[16] __attribute__((aligned(64)))={0,0x80000000,1,0x80000001,0x7f800000,0xff800000,0x3f800000,0x40800000,0xbf800000,0x7fc00000,0x7f800001,0x00800000,0x7f7fffff,0x40000000,0x3e800000,0x3f000000};
 uint32_t result[16] __attribute__((aligned(64)));
 __knc_rcp23_f32(result,input);
 CHECK(result[0]==0x7f800000&&result[1]==0xff800000&&result[2]==0x7f800000&&result[3]==0xff800000);
 CHECK(result[4]==0&&result[5]==0x80000000&&result[6]==0x3f800000&&result[7]==0x3e800000&&result[8]==0xbf800000);
 CHECK(isnanbits(result[9],32)&&isnanbits(result[10],32)&&result[11]==0x7e800000&&result[12]==0);
 __knc_rsqrt23_f32(result,input);
 CHECK(result[0]==0x7f800000&&result[1]==0xff800000&&result[2]==0x7f800000&&result[3]==0xff800000);
 CHECK(result[4]==0&&isnanbits(result[5],32)&&result[6]==0x3f800000&&result[7]==0x3f000000&&isnanbits(result[8],32));
 printf("PASS approximate vector math: shapes=24 checks=%llu fast=%llu fallback=%llu guarded pages and native seed edges; max_ulp f32_div=%llu f32_sqrt=%llu f64_div=%llu f64_sqrt=%llu\n",(unsigned long long)checks,(unsigned long long)fast_checks,(unsigned long long)fallback_checks,(unsigned long long)max_ulp[0][0],(unsigned long long)max_ulp[0][1],(unsigned long long)max_ulp[1][0],(unsigned long long)max_ulp[1][1]);
 /* Full-width in-domain data, without other card workloads. A checksum is
    observed after every timed loop; static instruction counts are not timing. */
 unsigned char a[64] __attribute__((aligned(64))),b[64] __attribute__((aligned(64))),out[64] __attribute__((aligned(64)));
 for(unsigned bits=32;bits<=64;bits+=32){
  const struct kernel*k=0;for(unsigned i=0;i<sizeof(kernels)/sizeof(kernels[0]);i++)if(!k&&kernels[i].w==bits&&kernels[i].n==512/bits)k=kernels+i;CHECK(k);
  for(unsigned i=0;i<k->n;i++){if(bits==32){float x=0.25f+i*0.125f,y=1.25f+i*0.0625f;memcpy(a+4*i,&x,4);memcpy(b+4*i,&y,4);}else{double x=0.25+i*0.125,y=1.25+i*0.0625;memcpy(a+8*i,&x,8);memcpy(b+8*i,&y,8);}}
  for(unsigned op=0;op<2;op++)for(unsigned round=0;round<3;round++)for(unsigned order=0;order<2;order++){
   unsigned path=(order+round)%2;void(*fn)(void*,const void*,const void*)=path?(op?k->sqrt:k->div):reference[bits==64][op];
   uint64_t start=now();for(unsigned it=0;it<20000;it++)fn(out,a,b);uint64_t elapsed=now()-start;
   CHECK(get(out,0,bits/8)!=0);printf("TIMING approximate width=%u op=%s path=%s round=%u iterations=20000 ns=%llu\n",bits,op?"sqrt":"div",path?"refined":"scalar_runtime",round,(unsigned long long)elapsed);
  }
 }
 return 0;
}
