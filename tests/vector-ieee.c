#include <stdint.h>
#include <stdio.h>
#include "fp-corpus.h"
extern void generic_fadd_f32(void*,const void*,const void*),generic_fsub_f32(void*,const void*,const void*),generic_fmul_f32(void*,const void*,const void*);
extern void generic_fadd_f64(void*,const void*,const void*),generic_fsub_f64(void*,const void*,const void*),generic_fmul_f64(void*,const void*,const void*);
int main(void){
 unsigned checked=0,mismatch=0,mxcsr;
 __asm__ volatile("stmxcsr %0":"=m"(mxcsr));printf("initial_mxcsr=0x%x\n",mxcsr);
 void (*ops32[3])(void*,const void*,const void*)={generic_fadd_f32,generic_fsub_f32,generic_fmul_f32};
 void (*ops64[3])(void*,const void*,const void*)={generic_fadd_f64,generic_fsub_f64,generic_fmul_f64};
 uint32_t a[16] __attribute__((aligned(64))),b[16] __attribute__((aligned(64))),o[16] __attribute__((aligned(64)));
 uint64_t da[8] __attribute__((aligned(64))),db[8] __attribute__((aligned(64))),dout[8] __attribute__((aligned(64)));
 for(unsigned i=0;i<sizeof(fp32_cases)/sizeof(fp32_cases[0]);i++){
  const struct fp32_case *c=fp32_cases+i;if(c->op>2)continue;
  for(unsigned j=0;j<16;j++){a[j]=c->a;b[j]=c->b;}ops32[c->op](o,a,b);checked++;
  if(c->nan?((o[0]&0x7fffffff)<=0x7f800000):o[0]!=c->expected){if(mismatch++<5)printf("mismatch f32 op=%u a=%x b=%x got=%x expected=%x\n",c->op,c->a,c->b,o[0],c->expected);}
 }
 for(unsigned i=0;i<sizeof(fp64_cases)/sizeof(fp64_cases[0]);i++){
  const struct fp64_case *c=fp64_cases+i;if(c->op>2)continue;
  for(unsigned j=0;j<8;j++){da[j]=c->a;db[j]=c->b;}ops64[c->op](dout,da,db);checked++;
  if(c->nan?((dout[0]&0x7fffffffffffffffULL)<=0x7ff0000000000000ULL):dout[0]!=c->expected){if(mismatch++<5)printf("mismatch f64 op=%u a=%llx b=%llx got=%llx expected=%llx\n",c->op,(unsigned long long)c->a,(unsigned long long)c->b,(unsigned long long)dout[0],(unsigned long long)c->expected);}
 }
 printf("vector IEEE checks=%u mismatches=%u\n",checked,mismatch);return mismatch?1:0;
}
