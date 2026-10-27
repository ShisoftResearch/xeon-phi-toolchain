#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sched.h>
#include "fp-corpus.h"
#include "vector-fp-corpus.h"
struct chain_case{unsigned width;uint64_t a,b,c,expected;};
#include "scalar-register-corpus.h"
#define DECL(P) \
float P##dag_add_value_f32(float,float);float P##dag_sub_value_f32(float,float);float P##dag_mul_value_f32(float,float);\
double P##dag_add_value_f64(double,double);double P##dag_sub_value_f64(double,double);double P##dag_mul_value_f64(double,double);\
float P##dag_fma_value_f32(float,float,float);double P##dag_fma_value_f64(double,double,double);\
float P##dag_chain_value_f32(float,float,float);double P##dag_chain_value_f64(double,double,double);
DECL() DECL(before_)
extern void scalar_vector_source_f32(void*,const void*,const void*,const void*),scalar_vector_source_f64(void*,const void*,const void*,const void*);
extern void scalar_sdk_source_f64(void*,const void*,const void*),scalar_sdk_source_f32(void*,const void*);
static float(*fp32[2][3])(float,float)={{dag_add_value_f32,dag_sub_value_f32,dag_mul_value_f32},{before_dag_add_value_f32,before_dag_sub_value_f32,before_dag_mul_value_f32}};
static double(*fp64[2][3])(double,double)={{dag_add_value_f64,dag_sub_value_f64,dag_mul_value_f64},{before_dag_add_value_f64,before_dag_sub_value_f64,before_dag_mul_value_f64}};
static float(*fma32[2])(float,float,float)={dag_fma_value_f32,before_dag_fma_value_f32},(*chain32[2])(float,float,float)={dag_chain_value_f32,before_dag_chain_value_f32};
static double(*fma64[2])(double,double,double)={dag_fma_value_f64,before_dag_fma_value_f64},(*chain64[2])(double,double,double)={dag_chain_value_f64,before_dag_chain_value_f64};
static int same(uint64_t got,uint64_t expected,unsigned w){uint64_t mask=w==32?UINT64_C(0x7fffffff):UINT64_C(0x7fffffffffffffff),inf=w==32?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000);return(expected&mask)>inf?(got&mask)>inf:got==expected;}
static uint64_t ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return(uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
int main(void){unsigned checks=0,failures=0;cpu_set_t cpus;CPU_ZERO(&cpus);CPU_SET(1,&cpus);if(sched_setaffinity(0,sizeof cpus,&cpus))return 1;
#define CHECK(G,E,W) do{checks++;if(!same(G,E,W)){if(failures<8)printf("FAIL scalar register check=%u before=%u got=%llx expected=%llx width=%u\n",checks,path,(unsigned long long)(G),(unsigned long long)(E),W);failures++;}}while(0)
 for(unsigned path=0;path<2;path++){
  for(unsigned i=0;i<sizeof fp32_cases/sizeof fp32_cases[0];i++){const struct fp32_case*c=fp32_cases+i;if(c->op>2)continue;float a,b,r;uint32_t got;memcpy(&a,&c->a,4);memcpy(&b,&c->b,4);r=fp32[path][c->op](a,b);memcpy(&got,&r,4);CHECK(got,c->expected,32);}
  for(unsigned i=0;i<sizeof fp64_cases/sizeof fp64_cases[0];i++){const struct fp64_case*c=fp64_cases+i;if(c->op>2)continue;double a,b,r;uint64_t got;memcpy(&a,&c->a,8);memcpy(&b,&c->b,8);r=fp64[path][c->op](a,b);memcpy(&got,&r,8);CHECK(got,c->expected,64);}
  for(unsigned i=0;i<sizeof fma32_cases/sizeof fma32_cases[0];i++){float a,b,c,r;uint32_t got;memcpy(&a,&fma32_cases[i].a,4);memcpy(&b,&fma32_cases[i].b,4);memcpy(&c,&fma32_cases[i].c,4);r=fma32[path](a,b,c);memcpy(&got,&r,4);CHECK(got,fma32_cases[i].expected,32);}
  for(unsigned i=0;i<sizeof fma64_cases/sizeof fma64_cases[0];i++){double a,b,c,r;uint64_t got;memcpy(&a,&fma64_cases[i].a,8);memcpy(&b,&fma64_cases[i].b,8);memcpy(&c,&fma64_cases[i].c,8);r=fma64[path](a,b,c);memcpy(&got,&r,8);CHECK(got,fma64_cases[i].expected,64);}
  for(unsigned i=0;i<sizeof chains/sizeof chains[0];i++){
   const struct chain_case*c=chains+i;uint64_t got=0;
   if(c->width==32){float a,b,d,r;memcpy(&a,&c->a,4);memcpy(&b,&c->b,4);memcpy(&d,&c->c,4);r=chain32[path](a,b,d);memcpy(&got,&r,4);}else{double a,b,d,r;memcpy(&a,&c->a,8);memcpy(&b,&c->b,8);memcpy(&d,&c->c,8);r=chain64[path](a,b,d);memcpy(&got,&r,8);}
   CHECK(got,c->expected,c->width);
  }
 }
 for(unsigned path=0,i=0;i<sizeof chains/sizeof chains[0];i++){
  const struct chain_case*c=chains+i;uint64_t a[8] __attribute__((aligned(64))),b[8] __attribute__((aligned(64))),d[8] __attribute__((aligned(64))),out[2]={UINT64_C(0xa5a5a5a5a5a5a5a5),UINT64_C(0xa5a5a5a5a5a5a5a5)};
  for(unsigned lane=0;lane<8;lane++){a[lane]=UINT64_C(0x7ff000017fc00001);b[lane]=UINT64_C(0xfff800017f800001);d[lane]=UINT64_C(0x7ff80000ff800000);}
  memcpy(a,&c->a,c->width/8);memcpy(b,&c->b,c->width/8);memcpy(d,&c->c,c->width/8);
  if(c->width==32)scalar_vector_source_f32(out,a,b,d);else scalar_vector_source_f64(out,a,b,d);
  uint64_t got=0;memcpy(&got,out,c->width/8);CHECK(got,c->expected,c->width);
  for(unsigned byte=c->width/8;byte<sizeof out;byte++)if(((unsigned char*)out)[byte]!=0xa5)failures++;
 }
 for(unsigned path=0,i=0;i<32;i++){
  uint64_t a[8] __attribute__((aligned(64))),b[8] __attribute__((aligned(64))),out[2];
  for(unsigned lane=0;lane<8;lane++){a[lane]=UINT64_C(0x7ff0000000000001)+lane;b[lane]=UINT64_C(0xfff8000000000001)+lane;}
  a[0]=i&1?UINT64_C(0xbff0000000000000):UINT64_C(0x3ff0000000000000);b[0]=i&2?(a[0]^UINT64_C(0x8000000000000000)):a[0];
  memset(out,0xa5,sizeof out);scalar_sdk_source_f64(out,a,b);CHECK(out[0],i&1?UINT64_C(0x3ff0000000000000):UINT64_C(0x4000000000000000),64);
  uint32_t eq;memcpy(&eq,(char*)out+8,4);checks++;if(eq!=!(i&2))failures++;
  for(unsigned byte=12;byte<sizeof out;byte++)if(((unsigned char*)out)[byte]!=0xa5)failures++;
  a[0]=(a[0]&UINT64_C(0xffffffff00000000))|(i&1?UINT64_C(0xbf800000):UINT64_C(0x3f800000));
  memset(out,0xa5,sizeof out);scalar_sdk_source_f32(out,a);uint32_t got;memcpy(&got,out,4);CHECK(got,i&1?0:UINT64_C(0x40000000),32);
  for(unsigned byte=4;byte<sizeof out;byte++)if(((unsigned char*)out)[byte]!=0xa5)failures++;
 }
 if(failures){printf("FAIL scalar register reuse: checks=%u failures=%u\n",checks,failures);return 1;}
 printf("PASS scalar register reuse: %u exact/classified results, binary/FMA/expression chains, independent SDK ABI caller\n",checks);
 for(unsigned round=0;round<5;round++)for(unsigned order=0;order<2;order++){
  unsigned path=(round+order)%2;uint64_t start=ns();float x=0;for(unsigned i=0;i<200000;i++)x=fp32[path][0](x,0x1p-10f);uint64_t elapsed=ns()-start;if(x!=195.3125f)return 1;
  printf("TIMING register_reuse width=32 round=%u path=%s iterations=200000 ns=%llu\n",round,path?"before":"after",(unsigned long long)elapsed);
  start=ns();double y=0;for(unsigned i=0;i<200000;i++)y=fp64[path][0](y,0x1p-10);elapsed=ns()-start;if(y!=195.3125)return 1;
  printf("TIMING register_reuse width=64 round=%u path=%s iterations=200000 ns=%llu\n",round,path?"before":"after",(unsigned long long)elapsed);
 }
 return 0;
}
