#define _POSIX_C_SOURCE 200809L
#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <sys/mman.h>
#include <unistd.h>
extern uint32_t auto_q8_dot(const int8_t*,const int8_t*,size_t);
extern void auto_q8_affine(uint32_t*,const int8_t*,size_t,uint32_t,uint32_t);
extern void auto_q4_low(float*,const uint8_t*,size_t,float),auto_q4_high(float*,const uint8_t*,size_t,float);
static uint32_t rng=0x63982;
static uint32_t next(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
__attribute__((noinline,optimize("no-tree-vectorize")))
static uint32_t reference_dot(const int8_t *a,const int8_t *b,size_t n){uint32_t sum=0;for(size_t i=0;i<n;i++)sum+=(int32_t)a[i]*(int32_t)b[i];return sum;}
static int check(const int8_t *a,const int8_t *b,uint32_t *out,size_t n,uint32_t scale,uint32_t bias,float fscale){
 if(auto_q8_dot(a,b,n)!=reference_dot(a,b,n)){printf("FAIL q8 dot length=%lu\n",(unsigned long)n);return 1;}
 auto_q8_affine(out,a,n,scale,bias);
 for(size_t i=0;i<n;i++)if(out[i]!=(uint32_t)(int32_t)a[i]*scale+bias){printf("FAIL affine length=%lu lane=%lu\n",(unsigned long)n,(unsigned long)i);return 1;}
 for(unsigned high=0;high<2;high++){
  if(high)auto_q4_high((float*)out,(const uint8_t*)a,n,fscale);else auto_q4_low((float*)out,(const uint8_t*)a,n,fscale);
  for(size_t i=0;i<n;i++){
   uint8_t x=(uint8_t)a[i];int q=(high?x>>4:x&15)-8;float expected=q*fscale;uint32_t bits;memcpy(&bits,&expected,4);
   uint32_t got;memcpy(&got,(const unsigned char*)out+i*4,4);
   if(got!=bits){printf("FAIL q4 high=%u length=%lu lane=%lu got=%08x expected=%08x\n",high,(unsigned long)n,(unsigned long)i,got,bits);return 1;}
  }
 }
 return 0;
}
static uint64_t now_ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
static volatile uint32_t sink;
int main(void){
 int8_t a[1200],b[1200];uint32_t *out=malloc(1200*sizeof(*out));if(!out)return 1;
 for(unsigned i=0;i<1200;i++){a[i]=(int8_t)i;b[i]=(int8_t)next();}
 uint64_t cases=0;
 for(unsigned offset=0;offset<64;offset++)for(size_t n=0;n<=257;n++){
  unsigned o=16+offset%16;for(unsigned i=0;i<1200;i++)out[i]=0x8c7e3521;
  static const uint32_t fbits[]={0x3f800000,0xbe800000,0x40500000,0x00800001,0x00000001,0x00000000};
  uint32_t fb=fbits[(offset+n)%6];float fscale;memcpy(&fscale,&fb,4);
  if(check(a+offset,b+(63-offset),out+o,n,next(),next(),fscale))return 1;
  for(unsigned i=0;i<1200;i++)if((i<o||i>=o+n)&&out[i]!=0x8c7e3521){puts("FAIL output sentinel");return 1;}
  cases++;
 }
 for(size_t n=511;n<=1025;n++)if(check(a,b,out,n,next(),next(),0.25f))return 1;
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[3];
 for(unsigned i=0;i<3;i++){maps[i]=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(maps[i]==MAP_FAILED||mprotect(maps[i]+page,page,PROT_READ|PROT_WRITE))return 1;}
 for(size_t n=1;n<=257;n++)for(unsigned end=0;end<2;end++){
  int8_t *ga=(int8_t*)maps[0]+page+(end?page-n:0),*gb=(int8_t*)maps[1]+page+(end?page-n:0);
  uint32_t *go=(uint32_t*)(maps[2]+page+(end?page-n*4:0));
  for(size_t i=0;i<n;i++){ga[i]=(int8_t)next();gb[i]=(int8_t)next();}
  if(check(ga,gb,go,n,next(),next(),-0.5f))return 1;cases++;
 }
 if(auto_q8_dot(0,0,0))return 1;auto_q8_affine(0,0,0,1,2);auto_q4_low(0,0,0,1);auto_q4_high(0,0,0,1);
 for(unsigned i=0;i<3;i++)munmap(maps[i],page*3);
 size_t count=131071;int8_t *ba=malloc(count),*bb=malloc(count);if(!ba||!bb)return 1;
 for(size_t i=0;i<count;i++){ba[i]=(int8_t)next();bb[i]=(int8_t)next();}
 uint32_t expected=reference_dot(ba,bb,count);if(auto_q8_dot(ba,bb,count)!=expected)return 1;
 uint64_t start=now_ns();for(unsigned r=0;r<3;r++){__asm__ volatile("":::"memory");sink=reference_dot(ba,bb,count);}uint64_t scalar=now_ns()-start;
 start=now_ns();for(unsigned r=0;r<3;r++){__asm__ volatile("":::"memory");sink=auto_q8_dot(ba,bb,count);}uint64_t vector=now_ns()-start;
 printf("PASS ordinary C quantized auto-vectorization: q8 dot/affine and q4 low/high dequantization; %llu length/alignment/guard cases plus 515 longer lengths, unsigned wrapping, exact FP bits, tails, sentinels and zero-length null pointers\n",(unsigned long long)cases);
 printf("TIMING q8_mpss_gcc_scalar ns=%llu rounds=3\nTIMING q8_llvm_autovec ns=%llu rounds=3\n",(unsigned long long)scalar,(unsigned long long)vector);
 free(ba);free(bb);free(out);return 0;
}
