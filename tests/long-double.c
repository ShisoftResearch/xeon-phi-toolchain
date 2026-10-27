#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sched.h>
#include "long-double-corpus.h"
extern long double f80_add(long double,long double),f80_sub(long double,long double),f80_mul(long double,long double),f80_div(long double,long double),f80_sqrt(long double),f80_identity(long double);
extern unsigned f80_compare(long double,long double);
extern double f80_to_f64(long double);extern float f80_to_f32(long double);
extern long double f80_from_f64(double),f80_from_f32(float),f80_from_i64(int64_t),f80_from_u64(uint64_t);
extern int64_t f80_to_i64(long double);extern uint64_t f80_to_u64(long double);
extern long double f80_select(long double,long double,int),f80_callback(long double,long double(*)(long double));
#define SMALL(W) extern long double f80_from_i##W(int##W##_t),f80_from_u##W(uint##W##_t);extern int##W##_t f80_to_i##W(long double);extern uint##W##_t f80_to_u##W(long double);
SMALL(8)
SMALL(16)
SMALL(32)
#undef SMALL
struct f80_pair{long double x,y;};extern struct f80_pair f80_swap(struct f80_pair);
extern long double f80_ten(long double,long double,long double,long double,long double,long double,long double,long double,long double,long double);
static unsigned checks,failures;
static long double value(struct fp80_bits b){long double x;memset(&x,0,sizeof x);memcpy(&x,&b.sig,8);memcpy((unsigned char*)&x+8,&b.se,2);return x;}
static struct fp80_bits raw(long double x){struct fp80_bits b;memcpy(&b.sig,&x,8);memcpy(&b.se,(unsigned char*)&x+8,2);return b;}
static int nan80(struct fp80_bits x){return (x.se&0x7fff)==0x7fff&&(x.sig&UINT64_C(0x7fffffffffffffff));}
static int equal(struct fp80_bits a,struct fp80_bits b){return nan80(b)?nan80(a):a.se==b.se&&a.sig==b.sig;}
static void check80(const char*name,unsigned row,long double got,struct fp80_bits expected){
 struct fp80_bits b=raw(got);++checks;if(!equal(b,expected)){if(failures<12)printf("FAIL f80 %s row=%u got=%04x:%016llx expected=%04x:%016llx\n",name,row,b.se,(unsigned long long)b.sig,expected.se,(unsigned long long)expected.sig);++failures;}}
static void check(int ok,const char*what,unsigned row){++checks;if(!ok){if(failures<12)printf("FAIL f80 %s row=%u\n",what,row);++failures;}}
__attribute__((noinline)) static long double sdk_callback(long double x){return x+1.0L;}
static uint16_t cw(void){uint16_t x;__asm__ volatile("fnstcw %0":"=m"(x));return x;}
int main(void){
 cpu_set_t cpus;CPU_ZERO(&cpus);CPU_SET(1,&cpus);if(sched_setaffinity(0,sizeof cpus,&cpus))return 1;
 uint16_t original=cw(),working=(original|0x3f)&~0xf00;working|=0x300;__asm__ volatile("fldcw %0"::"m"(working));
 printf("ENV f80 original_cw=%04x test_cw=%04x sizeof=%zu\n",original,cw(),sizeof(long double));
 if(sizeof(long double)!=16)return 1;
 long double(*binary[4])(long double,long double)={f80_add,f80_sub,f80_mul,f80_div};
 const char*names[]={"add","sub","mul","div","sqrt"};
 for(unsigned i=0;i<sizeof fp80_cases/sizeof fp80_cases[0];++i){const struct fp80_case*c=fp80_cases+i;long double a=value(c->a),b=value(c->b);
  for(unsigned op=0;op<4;++op)check80(names[op],i,binary[op](a,b),c->out[op]);
  check80(names[4],i,f80_sqrt(a),c->out[4]);check(f80_compare(a,b)==c->comparison,"compare",i);
  double d=f80_to_f64(a);float f=f80_to_f32(a);uint64_t db;uint32_t fb;memcpy(&db,&d,8);memcpy(&fb,&f,4);
  int dn=(c->f64&UINT64_C(0x7fffffffffffffff))>UINT64_C(0x7ff0000000000000),fn=(c->f32&0x7fffffff)>0x7f800000;
  check(dn?(db&UINT64_C(0x7fffffffffffffff))>UINT64_C(0x7ff0000000000000):db==c->f64,"to_f64",i);
  check(fn?(fb&0x7fffffff)>0x7f800000:fb==c->f32,"to_f32",i);
 }
 for(unsigned i=0;i<sizeof fp80_cast_cases/sizeof fp80_cast_cases[0];++i){const struct fp80_cast_case*c=fp80_cast_cases+i;double d;float f;memcpy(&d,&c->f64,8);memcpy(&f,&c->f32,4);check80("from_f64",i,f80_from_f64(d),c->wide64);check80("from_f32",i,f80_from_f32(f),c->wide32);}
 for(unsigned i=0;i<sizeof fp80_int_cases/sizeof fp80_int_cases[0];++i){const struct fp80_int_case*c=fp80_int_cases+i;int64_t s;memcpy(&s,&c->input,8);
  check80("from_i64",i,f80_from_i64(s),c->from_signed);check80("from_u64",i,f80_from_u64(c->input),c->from_unsigned);
  check((uint64_t)f80_to_i64(value(c->signed_arg))==c->signed_result,"to_i64",i);check(f80_to_u64(value(c->unsigned_arg))==c->unsigned_result,"to_u64",i);
  check(cw()==working,"integer_cast_control_word",i);
 }
 for(unsigned i=0;i<sizeof fp80_small_cases/sizeof fp80_small_cases[0];++i){const struct fp80_small_case*c=fp80_small_cases+i;long double se,ue;int64_t si;uint64_t ui;
#define CONVERT(W) do{uint##W##_t u=c->input;int##W##_t v;memcpy(&v,&u,sizeof v);se=f80_from_i##W(v);ue=f80_from_u##W(u);si=f80_to_i##W(value(c->signed_arg));ui=f80_to_u##W(value(c->unsigned_arg));}while(0)
  if(c->width==8)CONVERT(8);else if(c->width==16)CONVERT(16);else CONVERT(32);
#undef CONVERT
  check80("small_from_signed",i,se,c->from_signed);check80("small_from_unsigned",i,ue,c->from_unsigned);check(si==c->signed_result,"small_to_signed",i);check(ui==c->unsigned_result,"small_to_unsigned",i);
 }
 for(unsigned i=0;i<sizeof fp80_abi_cases/sizeof fp80_abi_cases[0];++i){const struct fp80_abi_case*c=fp80_abi_cases+i;long double a=value(c->value),b=-a;
  check80("identity",i,f80_identity(a),c->value);check80("callback",i,f80_callback(a,sdk_callback),c->callback);
  check80("select_a",i,f80_select(a,b,1),c->value);check80("select_b",i,f80_select(a,b,0),raw(b));
  struct guarded {uint64_t before;struct f80_pair pair;uint64_t after;} out;out.before=UINT64_C(0x3456789012345678);out.after=~out.before;
  struct f80_pair in={a,b};out.pair=f80_swap(in);check80("sret_x",i,out.pair.x,raw(b));check80("sret_y",i,out.pair.y,c->value);check(out.before==UINT64_C(0x3456789012345678)&&out.after==~out.before,"aggregate_guards",i);
  struct fp80_bits zero={0,0},minus_one={UINT64_C(0x8000000000000000),0xbfff};
  /* The exact cancellation result is i*2^-63. Form its independent raw bits. */
  uint64_t v=i;struct fp80_bits expected={0,0};if(v){unsigned high=63-__builtin_clzll(v);expected.sig=v<<(63-high);expected.se=16383+high-63;}
  check80("ten_stack_arguments",i,f80_ten(a,value(minus_one),value(zero),value(zero),value(zero),value(zero),value(zero),value(zero),value(zero),value(zero)),expected);
 }
 check(cw()==working,"final_control_word",0);__asm__ volatile("fldcw %0"::"m"(original));
 printf("%s native f80: %u checks, failures=%u; exact rational arithmetic/sqrt, FP32/64 and integer casts, SDK caller/callback, stack arguments and aggregate sret; RNE/64-bit precision\n",failures?"FAIL":"PASS",checks,failures);return !!failures;
}
