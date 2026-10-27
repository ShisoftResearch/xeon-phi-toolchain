#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#define B(N) extern void i64_##N(void*,const void*,const void*);
B(add) B(sub) B(mul) B(and) B(or) B(xor) B(shl) B(lshr) B(ashr) B(smin) B(smax) B(umin) B(umax) B(select) B(shuffle)
#define C(N) extern void i64_cmp_##N(void*,const void*,const void*);
C(eq) C(ne) C(slt) C(sle) C(sgt) C(sge) C(ult) C(ule) C(ugt) C(uge)
#define R(N) extern uint64_t i64_reduce_##N(const void*);
R(add) R(mul) R(and) R(or) R(xor) R(smin) R(smax) R(umin) R(umax)
extern uint64_t i64_extract(const void*,uint64_t);extern void i64_insert(void*,const void*,uint64_t,uint64_t),i64_spills(void*,const void*);
static uint64_t state=UINT64_C(0x25319abc7654f1);
static uint64_t next(void){state^=state<<13;state^=state>>7;state^=state<<17;return state;}
void i64_clobber(void *p){memset(p,0xa7,40*64);__asm__ volatile("":::"zmm0","zmm1","zmm2","zmm3","zmm4","zmm5","zmm6","zmm7","zmm8","zmm9","zmm10","zmm11","zmm12","zmm13","zmm14","zmm15","zmm16","zmm17","zmm18","zmm19","zmm20","zmm21","zmm22","zmm23","zmm24","zmm25","zmm26","zmm27","zmm28","zmm29","zmm30","zmm31");}
#define CHECK(X) do{if(!(X)){printf("FAIL i64 line=%d case=%u lane=%u\n",__LINE__,n,k);return 1;}}while(0)
#define OP(N,E) do{i64_##N(o,a,b);for(k=0;k<8;k++){uint64_t x=a[k],y=b[k];CHECK(o[k]==(uint64_t)(E));}}while(0)
#define CMP(N,E) do{i64_cmp_##N(o,a,b);for(k=0;k<8;k++){uint64_t x=a[k],y=b[k];CHECK(o[k]==((E)?UINT64_MAX:0));}}while(0)
void scalar_clobber(void *p){i64_clobber(p);}
extern void scalar_spills(void*,const void*);
extern void i64_abi_call(void*,const void*);
static int check_abi(void){uint64_t inputs[80],sum[8]={0},output[8];
 for(unsigned i=0;i<10;i++)for(unsigned k=0;k<8;k++){inputs[i*8+k]=next();sum[k]+=inputs[i*8+k];}
 i64_abi_call(output,inputs);if(memcmp(output,sum,64)){puts("FAIL native LLVM i64 ABI");return 1;}return 0;
}
int main(void){if(check_abi())return 1;unsigned n=0,k=0;uint64_t aa[24],bb[24],oo[24],*a,*b,*o;static const uint64_t edges[]={0,1,UINT64_MAX,0xffffffff,0x100000000ULL,0xffffffff00000000ULL,0x7fffffffffffffffULL,0x8000000000000000ULL,0x80000000ULL,0x7fffffffULL};
 for(n=0;n<5000;n++){
  a=aa+n%8;b=bb+(7-n%8);o=oo+n%8;
  for(k=0;k<8;k++){a[k]=n<100?edges[(n+k)%10]:next();b[k]=n<100?edges[(n/10+k)%10]:next();if(k==n%8)b[k]=a[k];}
  OP(add,x+y);OP(sub,x-y);OP(mul,x*y);OP(and,x&y);OP(or,x|y);OP(xor,x^y);
  OP(umin,x<y?x:y);OP(umax,x>y?x:y);OP(smin,(int64_t)x<(int64_t)y?x:y);OP(smax,(int64_t)x>(int64_t)y?x:y);OP(select,(int64_t)x<(int64_t)y?x:y);
  CMP(eq,x==y);CMP(ne,x!=y);CMP(slt,(int64_t)x<(int64_t)y);CMP(sle,(int64_t)x<=(int64_t)y);CMP(sgt,(int64_t)x>(int64_t)y);CMP(sge,(int64_t)x>=(int64_t)y);CMP(ult,x<y);CMP(ule,x<=y);CMP(ugt,x>y);CMP(uge,x>=y);
  uint64_t add=0,mul=1,and=UINT64_MAX,or=0,xor=0,smin=0x7fffffffffffffffULL,smax=0x8000000000000000ULL,umin=UINT64_MAX,umax=0;
  for(k=0;k<8;k++){uint64_t x=a[k];add+=x;mul*=x;and&=x;or|=x;xor^=x;if((int64_t)x<(int64_t)smin)smin=x;if((int64_t)x>(int64_t)smax)smax=x;if(x<umin)umin=x;if(x>umax)umax=x;}
  CHECK(i64_reduce_add(a)==add);CHECK(i64_reduce_mul(a)==mul);CHECK(i64_reduce_and(a)==and);CHECK(i64_reduce_or(a)==or);CHECK(i64_reduce_xor(a)==xor);CHECK(i64_reduce_smin(a)==smin);CHECK(i64_reduce_smax(a)==smax);CHECK(i64_reduce_umin(a)==umin);CHECK(i64_reduce_umax(a)==umax);
  i64_shuffle(o,a,b);for(k=0;k<8;k++)CHECK(o[k]==(k&1?b[k]:a[7-k]));
  k=n%8;CHECK(i64_extract(a,k)==a[k]);uint64_t value=next();i64_insert(o,a,k,value);for(k=0;k<8;k++)CHECK(o[k]==(k==n%8?value:a[k]));
  for(k=0;k<8;k++)b[k]=(n+k)%64;
  OP(shl,x<<y);OP(lshr,x>>y);OP(ashr,(int64_t)x>>y);
 }
 uint64_t input[320],output[320];for(k=0;k<320;k++)input[k]=next();i64_spills(output,input);CHECK(!memcmp(input,output,sizeof(input)));scalar_spills(output,input);CHECK(!memcmp(input,output,64*8));
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *m=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);CHECK(m!=MAP_FAILED);CHECK(!mprotect(m+page,page,PROT_READ|PROT_WRITE));
 a=(uint64_t*)(m+2*page-64);b=bb;o=oo;for(k=0;k<8;k++){a[k]=next();b[k]=next();}OP(add,x+y);OP(mul,x*y);munmap(m,page*3);
 puts("PASS emulated LLVM i64 SIMD: 5000 randomized/edge cases; carry/borrow, 64-bit multiply, logic, all shifts 0..63, signed/unsigned compare/minmax, select, 9 reductions, shuffle/extract/insert, 40 vectors live across clobbering call, native vector ABI (ten arguments), natural alignments and guard boundary");return 0;
}
