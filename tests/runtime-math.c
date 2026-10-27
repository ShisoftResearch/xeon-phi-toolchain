#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <fenv.h>
#include <errno.h>
struct math_case {unsigned op,w,tolerance;uint64_t input,expected;};
#include "runtime-math-corpus.h"
extern void runtime_math32(unsigned,const void*,void*),runtime_math64(unsigned,const void*,void*);
static const char*names[]={"exp","log","tanh","erf","erfc","sin","cos","sqrt","sin_pair","cos_pair"};
static int isnanbits(uint64_t b,unsigned w){uint64_t mask=w==32?UINT64_C(0x7fffffff):UINT64_C(0x7fffffffffffffff),inf=w==32?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000);return(b&mask)>inf;}
static uint64_t key(uint64_t b,unsigned w){uint64_t sign=UINT64_C(1)<<(w-1),mask=UINT64_MAX>>(64-w);return b&sign?(~b)&mask:b|sign;}
int main(void){
 uint64_t max_error[2][10]={{0}},counts[2][10]={{0}};unsigned failures=0;
 if(fesetround(FE_TONEAREST))return 1;
 for(unsigned i=0;i<sizeof(math_cases)/sizeof(math_cases[0]);i++){
  const struct math_case*c=math_cases+i;uint64_t output=0;
  if(c->w==32)runtime_math32(c->op,&c->input,&output);else runtime_math64(c->op,&c->input,&output);
  uint64_t a=key(output,c->w),b=key(c->expected,c->w),error=a>b?a-b:b-a;
  int pass=isnanbits(c->expected,c->w)?isnanbits(output,c->w):!isnanbits(output,c->w)&&error<=c->tolerance;
  if(!pass){if(failures<20)printf("FAIL runtime math name=%s w=%u input=%llx got=%llx expected=%llx ulp=%llu limit=%u\n",names[c->op],c->w,(unsigned long long)c->input,(unsigned long long)output,(unsigned long long)c->expected,(unsigned long long)error,c->tolerance);failures++;}
  if(!isnanbits(c->expected,c->w)&&error>max_error[c->w==64][c->op])max_error[c->w==64][c->op]=error;
  counts[c->w==64][c->op]++;
 }
 for(unsigned w=0;w<2;w++)for(unsigned op=0;op<10;op++)printf("MATH function=%s width=%u cases=%llu max_ulp=%llu\n",names[op],w?64:32,(unsigned long long)counts[w][op],(unsigned long long)max_error[w][op]);
 /* Observations only: the default value contract does not promise a complete
  * floating-point exception/errno model across software and IMCI arithmetic. */
 const unsigned probe_ops[]={0,0,1,1,7,5};
 const uint64_t probe_inputs[]={UINT64_C(0x408f400000000000),UINT64_C(0xc08f400000000000),UINT64_C(0xbff0000000000000),0,UINT64_C(0xbff0000000000000),UINT64_C(0x7ff0000000000000)};
 for(unsigned i=0;i<6;i++){
  uint64_t output=0;feclearexcept(FE_ALL_EXCEPT);errno=0;
  runtime_math64(probe_ops[i],probe_inputs+i,&output);int error_number=errno,flags=fetestexcept(FE_ALL_EXCEPT);
  printf("FENV function=%s input=%llx output=%llx errno=%d invalid=%d divzero=%d overflow=%d underflow=%d inexact=%d\n",names[probe_ops[i]],(unsigned long long)probe_inputs[i],(unsigned long long)output,error_number,!!(flags&FE_INVALID),!!(flags&FE_DIVBYZERO),!!(flags&FE_OVERFLOW),!!(flags&FE_UNDERFLOW),!!(flags&FE_INEXACT));
 }
 feclearexcept(FE_ALL_EXCEPT);errno=0;
 printf("%s runtime math: %u cases, MPFR RNE oracle; failures=%u\n",failures?"FAIL":"PASS",(unsigned)(sizeof(math_cases)/sizeof(math_cases[0])),failures);return !!failures;
}
