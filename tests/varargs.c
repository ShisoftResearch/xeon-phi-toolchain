#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
struct Mixed{double f;int64_t i;};
extern double clang_named(double,int,...),clang_mixed(int,...),clang_copies(int,...),clang_forward(int,...),clang_vsum(int,va_list),clang_exhaust_fp(double,double,double,double,double,double,double,double,double,int,...),ir_va_double(int,...);
extern int64_t clang_integers(int,...),clang_exhaust_gp(int64_t,int64_t,int64_t,int64_t,int64_t,int64_t,int64_t,...),ir_va_integer(int,...);
extern int clang_format(char*,unsigned long,const char*,...);
double gcc_vsum(int n,va_list ap){double s=0;for(int j=0;j<n;j++)s+=va_arg(ap,double);return s;}
static double gcc_to_clang(int n,...){va_list a;va_start(a,n);double s=clang_vsum(n,a);va_end(a);return s;}
#define CHECK(C) do{if(!(C)){printf("FAIL varargs line=%d iteration=%d\n",__LINE__,i);return 1;}}while(0)
int main(void){
 for(int i=0;i<1000;i++){
  double x=i*0.125;struct Mixed a={x,2},b={3.5,4},c={5.5,6},d={7.5,8};
  CHECK(clang_named(x,0)==x);CHECK(clang_named(x,10,1.,2.,3.,4.,5.,6.,7.,8.,9.,10.)==x+55);
  CHECK(clang_integers(0)==0);CHECK(clang_integers(10,(int64_t)i,2LL,3LL,4LL,5LL,6LL,7LL,8LL,9LL,10LL)==i+54);
  CHECK(clang_mixed(4,1LL,2.,a,3LL,4.,b,5LL,6.,c,7LL,8.,d)==x+72.5);
  CHECK(clang_copies(10,x,2.,3.,4.,5.,6.,7.,8.,9.,10.)==0);
  CHECK(clang_forward(10,x,2.,3.,4.,5.,6.,7.,8.,9.,10.)==x+54);
  CHECK(gcc_to_clang(10,x,2.,3.,4.,5.,6.,7.,8.,9.,10.)==x+54);
  CHECK(clang_exhaust_fp(1.,2.,3.,4.,5.,6.,7.,8.,9.,2,10.,11.)==66);
  CHECK(clang_exhaust_gp(1,2,3,4,5,6,7,8LL,9LL,10LL)==55);
  CHECK(ir_va_double(10,x,2.,3.,4.,5.,6.,7.,8.,9.,10.)==x+54);
  CHECK(ir_va_integer(10,(int64_t)i,2LL,3LL,4LL,5LL,6LL,7LL,8LL,9LL,10LL)==i+54);
  char out[128];int n=clang_format(out,sizeof(out),"n=%d f=%.3f s=%s",17,1.25,"KNC");CHECK(n==18&&strcmp(out,"n=17 f=1.250 s=KNC")==0);
 }
 puts("PASS native variadic definitions: 1000 cases; LLVM va_arg and Clang va_start/va_copy, mixed aggregates, exhausted GP/FP banks, AL=0, bidirectional GCC va_list and vsnprintf");return 0;
}
