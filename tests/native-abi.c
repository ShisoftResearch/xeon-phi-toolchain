#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include "fp-corpus.h"
struct Mixed { double value; int64_t count; };
struct Pair { double first,second; };
struct FloatPair { float first,second; };
extern double rust_identity(double),rust_add(double,double),rust_callback(double,double(*)(double));
extern float rust_addf(float,float);
extern double rust_sub(double,double),rust_mul(double,double);
extern float rust_subf(float,float),rust_mulf(float,float);
extern struct Mixed rust_mixed(struct Mixed);
extern struct Pair rust_pair(struct Pair);
extern struct FloatPair rust_float_pair(struct FloatPair);
extern double rust_ten(double,double,double,double,double,double,double,double,double,double);
extern double rust_calls_c(double),rust_calls_varargs(double);
struct Pair c_pair(struct Pair p) { struct Pair r={p.second,p.first};return r; }
struct Mixed c_mixed(struct Mixed p) { p.value+=p.count;p.count++;return p; }
double c_ten(double a,double b,double c,double d,double e,double f,double g,double h,double i,double j) {
 return a+2*b+3*c+4*d+5*e+6*f+7*g+8*h+9*i+10*j;
}
double c_varargs(int n,...) { va_list ap;va_start(ap,n);double s=0;for(int i=0;i<n;i++)s+=(i+1)*va_arg(ap,double);va_end(ap);return s; }
static double callback(double x) { return x*2+1; }
#define CHECK(c) do {if(!(c)){printf("FAIL line %d\n",__LINE__);return 1;}}while(0)
int main(void) {
 unsigned scalar_results=0;
 double (*ops64[3])(double,double)={rust_add,rust_sub,rust_mul};
 float (*ops32[3])(float,float)={rust_addf,rust_subf,rust_mulf};
 for(unsigned i=0;i<sizeof(fp32_cases)/sizeof(fp32_cases[0]);i++){
  const struct fp32_case *c=fp32_cases+i;if(c->op>2)continue;
  float a,b,r;uint32_t out;memcpy(&a,&c->a,4);memcpy(&b,&c->b,4);
  r=ops32[c->op](a,b);memcpy(&out,&r,4);
  CHECK(c->nan?(out&0x7fffffffU)>0x7f800000U:out==c->expected);scalar_results++;
 }
 for(unsigned i=0;i<sizeof(fp64_cases)/sizeof(fp64_cases[0]);i++){
  const struct fp64_case *c=fp64_cases+i;if(c->op>2)continue;
  double a,b,r;uint64_t out;memcpy(&a,&c->a,8);memcpy(&b,&c->b,8);
  r=ops64[c->op](a,b);memcpy(&out,&r,8);
  CHECK(c->nan?(out&UINT64_C(0x7fffffffffffffff))>UINT64_C(0x7ff0000000000000):out==c->expected);scalar_results++;
 }
 printf("PASS Rust native scalar DAG arithmetic: %u exact/classified FP32/FP64 add/sub/mul results\n",scalar_results);
 uint64_t bits[]={0,1,0x8000000000000000ULL,0x7ff0000000000000ULL,0xfff0000000000000ULL,0x7ff8000000001234ULL,0x0010000000000000ULL,0x7fefffffffffffffULL};
 for(unsigned i=0;i<sizeof(bits)/sizeof(bits[0]);i++){double x,y;uint64_t b;memcpy(&x,bits+i,8);y=rust_identity(x);memcpy(&b,&y,8);CHECK(b==bits[i]);}
 for(int i=-500;i<500;i++) {
  double x=i*0.125,y=(i+13)*0.25;
  CHECK(rust_add(x,y)==x+y);CHECK(rust_addf((float)x,(float)y)==(float)(x+y));
  struct Mixed m={x,i};m=rust_mixed(m);CHECK(m.value==x+i && m.count==i+1);
  struct Pair p={x,y};p=rust_pair(p);CHECK(p.first==y && p.second==x);
  struct FloatPair f={(float)x,(float)y};f=rust_float_pair(f);CHECK(f.first==y && f.second==x);
  CHECK(rust_callback(x,callback)==callback(x));
  CHECK(rust_ten(x,2,3,4,5,6,7,8,9,10)==x+384);
  CHECK(rust_calls_varargs(x)==x+384);
  CHECK(rust_calls_c(x)==c_ten(2,x,5,4,5,6,7,8,9,10));
 }
 puts("PASS native K1OM float ABI: 1000 cases, C/Rust calls, aggregates, indirect callbacks, stack arguments, variadic calls, special-value bit preservation");return 0;
}
