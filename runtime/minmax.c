/* Unconstrained LLVM min/max runtime for the native KNC ABI.
 * Integer bit ordering preserves signed zeros and avoids host FP assumptions.
 * These helpers do not emulate floating-point exception flags. */
#include <stdint.h>
static uint64_t choose(uint64_t a,uint64_t b,unsigned bits,int maximum,int policy){
 uint64_t sign=UINT64_C(1)<<(bits-1);
 uint64_t inf=bits==32?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000);
 uint64_t quiet=UINT64_C(1)<<(bits==32?22:51);
 int na=(a&~sign)>inf,nb=(b&~sign)>inf;
 if(na||nb){
  int signaling=(na&&!(a&quiet))||(nb&&!(b&quiet));
  /* policy 0: minnum; 1: propagating minimum; 2: minimumNumber. */
  if(policy==1||(na&&nb)||(policy==0&&signaling))return inf|quiet;
  return na?b:a;
 }
 if(((a|b)&~sign)==0)return maximum?a&b:a|b;
 int less=(a&sign)!=(b&sign)?!!(a&sign):(a&sign?a>b:a<b);
 return maximum?(less?b:a):(less?a:b);
}
#define DEFINE_FLOAT(NAME,MAXIMUM,POLICY) \
float NAME##f(float a,float b){union{float f;uint32_t u;}x={.f=a},y={.f=b},r; \
 r.u=(uint32_t)choose(x.u,y.u,32,MAXIMUM,POLICY);return r.f;} \
double NAME(double a,double b){union{double f;uint64_t u;}x={.f=a},y={.f=b},r; \
 r.u=choose(x.u,y.u,64,MAXIMUM,POLICY);return r.f;}
DEFINE_FLOAT(fmin,0,0)
DEFINE_FLOAT(fmax,1,0)
DEFINE_FLOAT(fminimum,0,1)
DEFINE_FLOAT(fmaximum,1,1)
DEFINE_FLOAT(fminimum_num,0,2)
DEFINE_FLOAT(fmaximum_num,1,2)
