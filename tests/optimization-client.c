#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/mman.h>
#include <unistd.h>
struct value_case{uint64_t si,ui,word,f32,f64,safe,scale32,scale64,a,b,expected[10];};
#include "optimization-corpus.h"
#define DECL(P) \
void P##cast_i32_f64(double*,const int32_t*,size_t);\
void P##cast_u32_f64(double*,const uint32_t*,size_t);\
void P##cast_f64_i32(int32_t*,const double*,size_t);\
void P##cast_f32_f64(double*,const float*,size_t);\
void P##cast_f64_f32(float*,const double*,size_t);\
void P##affine_i16_f32(float*,const int16_t*,const float*,size_t);\
void P##affine_i32_f64(double*,const int32_t*,const double*,size_t);\
double P##dot_f64_ordered(const double*,const double*,size_t);\
double P##dot_f64_reassoc(const double*,const double*,size_t);\
void P##clamp_f64(double*,const double*,size_t);
#ifdef KNC_RUST_CLIENT
DECL(rust_) DECL(before_rust_)
#define F(N) (before?before_rust_##N:rust_##N)
#define CLIENT "Rust"
#define LOOPS 9
#else
DECL() DECL(before_)
#define F(N) (before?before_##N:N)
#define CLIENT "C"
#define LOOPS 10
#endif
static int enabled(unsigned op){
#ifdef KNC_RUST_CLIENT
 return op!=8;
#else
 (void)op;return 1;
#endif
}
static const char*names[]={"cast_i32_f64","cast_u32_f64","cast_f64_i32","cast_f32_f64","cast_f64_f32","affine_i16_f32","affine_i32_f64","dot_f64_ordered","dot_f64_reassoc","clamp_f64"};
static const unsigned in_size[]={4,4,8,4,8,2,4,8,8,8},out_size[]={8,8,4,8,4,4,8,8,8,8};
static unsigned char input[33024] __attribute__((aligned(64))),scale[33024] __attribute__((aligned(64))),output[33024] __attribute__((aligned(64)));
static void invoke(unsigned op,int before,void*out,const void*in,const void*s,size_t n){
 switch(op){case 0:F(cast_i32_f64)(out,in,n);break;case 1:F(cast_u32_f64)(out,in,n);break;case 2:F(cast_f64_i32)(out,in,n);break;case 3:F(cast_f32_f64)(out,in,n);break;case 4:F(cast_f64_f32)(out,in,n);break;case 5:F(affine_i16_f32)(out,in,s,n);break;case 6:F(affine_i32_f64)(out,in,s,n);break;case 7:{double r=F(dot_f64_ordered)(in,s,n);memcpy(out,&r,8);break;}
#ifndef KNC_RUST_CLIENT
 case 8:{double r=F(dot_f64_reassoc)(in,s,n);memcpy(out,&r,8);break;}
#endif
 case 9:F(clamp_f64)(out,in,n);break;}
}
static void fill(unsigned op,void*in,void*s,unsigned n,unsigned offset){
 for(unsigned i=0;i<n;i++){
  const struct value_case*v=values+(i+offset)%512;uint64_t b=0,t=0;
  switch(op){case 0:b=v->si;break;case 1:b=v->ui;break;case 2:b=v->safe;break;case 3:b=v->f32;break;case 4:case 9:b=v->f64;break;case 5:b=v->word;t=v->scale32;break;case 6:b=v->si;t=v->scale64;break;default:b=v->a;t=v->b;break;}
  memcpy((char*)in+i*in_size[op],&b,in_size[op]);memcpy((char*)s+i*out_size[op],&t,out_size[op]);
 }
}
static int equal(uint64_t got,uint64_t expected,unsigned bytes){uint64_t mask=bytes==4?UINT64_C(0x7fffffff):UINT64_C(0x7fffffffffffffff),inf=bytes==4?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000);return(expected&mask)>inf?(got&mask)>inf:got==expected;}
static unsigned checks=0,failures=0;
static void check(unsigned op,int before,const void*out,unsigned n,unsigned offset,uint64_t dot){
 unsigned count=(op==7||op==8)?1:n;
 for(unsigned i=0;i<count;i++){
  uint64_t got=0,expected=(op==7||op==8)?dot:values[(i+offset)%512].expected[op];memcpy(&got,(const char*)out+i*out_size[op],out_size[op]);checks++;
  int pass=op==2?got==expected:equal(got,expected,out_size[op]);
  if(!pass){if(failures<12)printf("FAIL optimized op=%s before=%d n=%u offset=%u lane=%u got=%llx expected=%llx\n",names[op],before,n,offset,i,(unsigned long long)got,(unsigned long long)expected);failures++;}
 }
}
static uint64_t ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return(uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
int main(void){
 for(unsigned op=0;op<10;op++)for(unsigned li=0;li<sizeof lengths/sizeof lengths[0];li++)for(unsigned offset=0;offset<16;offset++){
  if(!enabled(op))continue;
  unsigned n=lengths[li];void*in=input+offset*in_size[op],*s=scale+offset*out_size[op];fill(op,in,s,n,offset);
  unsigned bytes=(op==7||op==8)?8:n*out_size[op];
  for(int before=0;before<2;before++){
   memset(output,0xa5,sizeof output);void*out=output+offset*out_size[op];invoke(op,before,out,n?in:NULL,n?s:NULL,n);check(op,before,out,n,offset,dot_expected[li][offset]);
   for(unsigned i=0;i<offset*out_size[op];i++)if(output[i]!=0xa5)failures++;
   for(unsigned i=offset*out_size[op]+bytes;i<sizeof output;i++)if(output[i]!=0xa5)failures++;
  }
 }
 /* Exact end-of-page buffers catch speculative wide accesses and tail errors. */
 unsigned page=(unsigned)sysconf(_SC_PAGESIZE);void*maps[3];
 for(unsigned i=0;i<3;i++){maps[i]=mmap(NULL,2*page,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(maps[i]==MAP_FAILED||mprotect((char*)maps[i]+page,page,PROT_NONE))return 1;}
 const unsigned edges[]={0,1,2,7,8,9,15,16,17,31,32,33,63,64,65,127,128,129,257};
 for(unsigned op=0;op<10;op++)for(unsigned j=0;j<sizeof edges/sizeof edges[0];j++){
  if(!enabled(op))continue;
  unsigned n=edges[j];void*in=(char*)maps[0]+page-n*in_size[op],*s=(char*)maps[1]+page-n*out_size[op],*out=(char*)maps[2]+page-((op==7||op==8)?8:n*out_size[op]);fill(op,in,s,n,0);
  for(int before=0;before<2;before++){invoke(op,before,out,n?in:NULL,n?s:NULL,n);check(op,before,out,n,0,dot_expected[n][0]);}
 }
 /* The ordinary ordered loop must retain scalar summation order. */
 for(unsigned n=0;n<66;n++){
  uint64_t a[66],b[66];for(unsigned i=0;i<n;i++){const uint64_t pattern[]={UINT64_C(0x4370000000000000),UINT64_C(0x3ff0000000000000),UINT64_C(0xc370000000000000),UINT64_C(0x3ff0000000000000)};a[i]=pattern[i%4];b[i]=UINT64_C(0x3ff0000000000000);}
  for(int before=0;before<2;before++){invoke(7,before,output,a,b,n);check(7,before,output,n,0,ordered_cancellation_expected[n]);}
 }
 if(failures){printf("FAIL optimization correctness checks=%u failures=%u\n",checks,failures);return 1;}
 printf("PASS optimization correctness: %u ordinary %s loops, %u exact/classified results, 265 lengths, 16 offsets, page guards and ordered cancellation\n",LOOPS,CLIENT,checks);
 for(unsigned op=0;op<10;op++){
  if(!enabled(op))continue;
  /* Regular finite data for timing; avoid special-value slow-path bias. */
  for(unsigned i=0;i<2048;i++){
   const struct value_case*v=values+i%512;uint64_t b=v->si,t=v->scale64;
   if(op==1)b=v->ui;else if(op==2||op==4||op==9)b=v->safe;else if(op==3)b=v->scale32;else if(op==5){b=v->word;t=v->scale32;}else if(op>=7&&op<=8){b=v->a;t=v->b;}
   memcpy(input+i*in_size[op],&b,in_size[op]);memcpy(scale+i*out_size[op],&t,out_size[op]);
  }
  for(unsigned round=0;round<5;round++)for(unsigned path=0;path<2;path++){
   int before=(path+round)%2;uint64_t start=ns();for(unsigned i=0;i<128;i++)invoke(op,before,output,input,scale,2048);uint64_t elapsed=ns()-start;
   printf("TIMING optimization kernel=%s round=%u path=%s ns=%llu\n",names[op],round,before?"before":"after",(unsigned long long)elapsed);
  }
 }
 return 0;
}
