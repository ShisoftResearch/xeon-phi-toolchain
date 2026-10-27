#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include "fp-corpus.h"
#include "vector-fp-corpus.h"
#define DECLARE(OP,W,T) extern T soft_##OP##_value_f##W(T,T),native_##OP##_value_f##W(T,T),dag_##OP##_value_f##W(T,T)
DECLARE(add,32,float);DECLARE(sub,32,float);DECLARE(mul,32,float);
DECLARE(add,64,double);DECLARE(sub,64,double);DECLARE(mul,64,double);
extern float dag_fma_value_f32(float,float,float);
extern double dag_fma_value_f64(double,double,double);
static float (*f32[3][3])(float,float)={{soft_add_value_f32,soft_sub_value_f32,soft_mul_value_f32},{native_add_value_f32,native_sub_value_f32,native_mul_value_f32},{dag_add_value_f32,dag_sub_value_f32,dag_mul_value_f32}};
static double (*f64[3][3])(double,double)={{soft_add_value_f64,soft_sub_value_f64,soft_mul_value_f64},{native_add_value_f64,native_sub_value_f64,native_mul_value_f64},{dag_add_value_f64,dag_sub_value_f64,dag_mul_value_f64}};
static const char *paths[]={"runtime","vector_recipe","dag"};
static uint64_t now(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (uint64_t)t.tv_sec*1000000000+(uint64_t)t.tv_nsec;}
#define CHECK(X) do{if(!(X)){printf("FAIL scalar FP evaluation line=%d\n",__LINE__);return 1;}}while(0)
int main(void){
 unsigned cases32=0,cases64=0;
 for(unsigned path=0;path<3;path++){
  for(unsigned i=0;i<sizeof(fp32_cases)/sizeof(fp32_cases[0]);i++){
   const struct fp32_case *c=fp32_cases+i;if(c->op>2)continue;
   float a,b,out;uint32_t bits;memcpy(&a,&c->a,4);memcpy(&b,&c->b,4);
   out=f32[path][c->op](a,b);memcpy(&bits,&out,4);
   if(!(c->nan?(bits&0x7fffffffU)>0x7f800000U:bits==c->expected)){
    printf("FAIL scalar FP32 path=%u case=%u op=%u a=%x b=%x got=%x expected=%x\n",path,i,c->op,c->a,c->b,bits,c->expected);return 1;}
   cases32++;
  }
  for(unsigned i=0;i<sizeof(fp64_cases)/sizeof(fp64_cases[0]);i++){
   const struct fp64_case *c=fp64_cases+i;if(c->op>2)continue;
   double a,b,out;uint64_t bits;memcpy(&a,&c->a,8);memcpy(&b,&c->b,8);
   out=f64[path][c->op](a,b);memcpy(&bits,&out,8);
   if(!(c->nan?(bits&UINT64_C(0x7fffffffffffffff))>UINT64_C(0x7ff0000000000000):bits==c->expected)){
    printf("FAIL scalar FP64 path=%u case=%u op=%u a=%llx b=%llx got=%llx expected=%llx\n",path,i,c->op,(unsigned long long)c->a,(unsigned long long)c->b,(unsigned long long)bits,(unsigned long long)c->expected);return 1;}
   cases64++;
  }
 }
 for(unsigned i=0;i<sizeof(fma32_cases)/sizeof(fma32_cases[0]);i++){
  float a,b,c,r;uint32_t bits;memcpy(&a,&fma32_cases[i].a,4);memcpy(&b,&fma32_cases[i].b,4);memcpy(&c,&fma32_cases[i].c,4);
  r=dag_fma_value_f32(a,b,c);memcpy(&bits,&r,4);CHECK(bits==fma32_cases[i].expected);
 }
 for(unsigned i=0;i<sizeof(fma64_cases)/sizeof(fma64_cases[0]);i++){
  double a,b,c,r;uint64_t bits;memcpy(&a,&fma64_cases[i].a,8);memcpy(&b,&fma64_cases[i].b,8);memcpy(&c,&fma64_cases[i].c,8);
  r=dag_fma_value_f64(a,b,c);memcpy(&bits,&r,8);CHECK(bits==fma64_cases[i].expected);
 }
 printf("PASS scalar FP evaluation: fp32=%u fp64=%u fma=2056 results; runtime, vector recipe and ordinary C DAG lowering, exact-rational oracle\n",cases32,cases64);
 /* Same ABI and dependency chain for each path. The sequence is exactly
    representable: 200000 increments of 2^-10 equals 195.3125. */
 const unsigned iterations=200000;
 for(unsigned round=0;round<5;round++)for(unsigned order=0;order<3;order++){
  unsigned path=(order+round)%3;uint64_t start=now();float x=0;
  for(unsigned i=0;i<iterations;i++)x=f32[path][0](x,0.0009765625f);
  uint64_t elapsed=now()-start;CHECK(x==195.3125f);
  printf("TIMING scalar_fp width=32 path=%s round=%u iterations=%u ns=%llu\n",paths[path],round,iterations,(unsigned long long)elapsed);
  start=now();double y=0;
  for(unsigned i=0;i<iterations;i++)y=f64[path][0](y,0.0009765625);
  elapsed=now()-start;CHECK(y==195.3125);
  printf("TIMING scalar_fp width=64 path=%s round=%u iterations=%u ns=%llu\n",paths[path],round,iterations,(unsigned long long)elapsed);
 }
 return 0;
}
