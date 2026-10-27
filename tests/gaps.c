#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#define BINARY(N) extern void test_##N(void*,const void*,const void*);
BINARY(sub) BINARY(and) BINARY(or) BINARY(xor) BINARY(shl) BINARY(lshr) BINARY(ashr)
BINARY(umin) BINARY(umax) BINARY(smin) BINARY(smax) BINARY(permute)
BINARY(eq) BINARY(slt) BINARY(ult) BINARY(select)
extern void shuffle_i32(void*,const void*,const void*),shuffle_f32(void*,const void*,const void*),shuffle_f64(void*,const void*,const void*);
#define REDUCE(N) extern uint32_t reduce_##N(const void*);
REDUCE(add) REDUCE(mul) REDUCE(and) REDUCE(or) REDUCE(xor) REDUCE(umin) REDUCE(umax) REDUCE(smin) REDUCE(smax)
#define FP(N,T) extern void generic_##N##_##T(void*,const void*,const void*);
FP(fadd,f32) FP(fsub,f32) FP(fmul,f32) FP(fadd,f64) FP(fsub,f64) FP(fmul,f64)
extern uint32_t test_extract(const void*,uint32_t);
extern void test_insert(void*,const void*,uint32_t,uint32_t);
extern void gather_same_value(void*,const void*,const void*,uint32_t),gather_outer_loop(void*,const void*,const void*,const void*,uint32_t);
extern void test_gather(void*,const void*,const void*,const void*,uint32_t);
extern void test_scatter(void*,const void*,const void*,uint32_t);
static uint32_t state=0x12345678;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
#define CHECK(C) do{if(!(C)){printf("FAIL gaps line=%d iteration=%d lane=%d\n",__LINE__,n,k);return 1;}}while(0)
#define CHECK_OP(N,E) do{test_##N(o,a,b);for(k=0;k<16;k++){uint32_t x=a[k],y=b[k];CHECK(o[k]==(uint32_t)(E));}}while(0)
int main(void){
 int n=0,k=0;
 uint32_t a[16] __attribute__((aligned(64))),b[16] __attribute__((aligned(64))),o[16] __attribute__((aligned(64))),idx[16] __attribute__((aligned(64)));
 for(n=0;n<1000;n++){
  for(k=0;k<16;k++){a[k]=next();b[k]=(k==n%16)?a[k]:next();}
  CHECK_OP(sub,x-y);CHECK_OP(and,x&y);CHECK_OP(or,x|y);CHECK_OP(xor,x^y);
  CHECK_OP(umin,x<y?x:y);CHECK_OP(umax,x>y?x:y);
  CHECK_OP(smin,(int32_t)x<(int32_t)y?x:y);CHECK_OP(smax,(int32_t)x>(int32_t)y?x:y);
  CHECK_OP(eq,x==y?UINT32_MAX:0);CHECK_OP(ult,x<y?UINT32_MAX:0);CHECK_OP(slt,(int32_t)x<(int32_t)y?UINT32_MAX:0);
  CHECK_OP(select,x<y?y:x);
  test_permute(o,a,b);for(k=0;k<16;k++)CHECK(o[k]==a[b[k]&15]);
  shuffle_i32(o,a,b);for(k=0;k<16;k++)CHECK(o[k]==((k&1)?b[k]:a[k]));
  shuffle_f32(o,a,b);for(k=0;k<16;k++)CHECK(o[k]==((k&1)?b[k]:a[k]));
  shuffle_f64(o,a,b);for(k=0;k<16;k++)CHECK(o[k]==(((k/2)&1)?b[k]:a[k]));
  uint32_t add=0,mul=1,an=UINT32_MAX,orr=0,xorr=0,umin=UINT32_MAX,umax=0,smin=0x7fffffff,smax=0x80000000;
  for(k=0;k<16;k++){uint32_t x=a[k];add+=x;mul*=x;an&=x;orr|=x;xorr^=x;if(x<umin)umin=x;if(x>umax)umax=x;if((int32_t)x<(int32_t)smin)smin=x;if((int32_t)x>(int32_t)smax)smax=x;}
  CHECK(reduce_add(a)==add);CHECK(reduce_mul(a)==mul);CHECK(reduce_and(a)==an);CHECK(reduce_or(a)==orr);CHECK(reduce_xor(a)==xorr);
  CHECK(reduce_umin(a)==umin);CHECK(reduce_umax(a)==umax);CHECK(reduce_smin(a)==smin);CHECK(reduce_smax(a)==smax);
  uint32_t lane=n%16,v=next();CHECK(test_extract(a,lane)==a[lane]);test_insert(o,a,lane,v);for(k=0;k<16;k++)CHECK(o[k]==(k==lane?v:a[k]));
  for(k=0;k<16;k++)b[k]&=31;
  CHECK_OP(shl,x<<y);CHECK_OP(lshr,x>>y);CHECK_OP(ashr,(int32_t)x>>y);
 }
 puts("PASS LLVM integer gaps: 1000 randomized cases; sub/bitwise/shifts/minmax, signed/unsigned comparisons, select, permutations, 9 reductions, lane extract/insert");
 float fa[16] __attribute__((aligned(64))),fb[16] __attribute__((aligned(64))),fo[16] __attribute__((aligned(64)));
 double da[8] __attribute__((aligned(64))),db[8] __attribute__((aligned(64))),dout[8] __attribute__((aligned(64)));
 for(n=0;n<1000;n++){
  for(k=0;k<16;k++){fa[k]=(int32_t)(next()%20000)-10000;fb[k]=((int32_t)(next()%20000)-10000)*0.25f;}
  generic_fadd_f32(fo,fa,fb);for(k=0;k<16;k++){volatile float ref=fa[k]+fb[k];CHECK(fo[k]==ref);}
  generic_fsub_f32(fo,fa,fb);for(k=0;k<16;k++){volatile float ref=fa[k]-fb[k];CHECK(fo[k]==ref);}
  generic_fmul_f32(fo,fa,fb);for(k=0;k<16;k++){volatile float ref=fa[k]*fb[k];CHECK(fo[k]==ref);}
  for(k=0;k<8;k++){da[k]=fa[k];db[k]=fb[k];}
  generic_fadd_f64(dout,da,db);for(k=0;k<8;k++){volatile double ref=da[k]+db[k];CHECK(dout[k]==ref);}
  generic_fsub_f64(dout,da,db);for(k=0;k<8;k++){volatile double ref=da[k]-db[k];CHECK(dout[k]==ref);}
  generic_fmul_f64(dout,da,db);for(k=0;k<8;k++){volatile double ref=da[k]*db[k];CHECK(dout[k]==ref);}
 }
 puts("PASS generic LLVM FP vectors: FP32/FP64 loads, stores, add, subtract and multiply");
 uint32_t data[16384] __attribute__((aligned(64))),dest[16384] __attribute__((aligned(64)));
 for(k=0;k<16384;k++)data[k]=next();
 for(n=0;n<1000;n++){
  uint32_t mask=n==0?0:n==1?65535:next()&65535;
  for(k=0;k<16;k++){idx[k]=k*1024+(next()&1023);a[k]=next();}
  test_gather(o,data,idx,a,mask);for(k=0;k<16;k++)CHECK(o[k]==((mask>>k&1)?data[idx[k]]:a[k]));
  memset(dest,0x5a,sizeof(dest));test_scatter(dest,idx,a,mask);
  for(k=0;k<16384;k++){uint32_t ref=0x5a5a5a5a;for(int j=0;j<16;j++)if((mask>>j&1)&&idx[j]==(uint32_t)k)ref=a[j];CHECK(dest[k]==ref);}
 }
 uint32_t rows[64] __attribute__((aligned(64)));
 for(n=0;n<32;n++){
  uint32_t mask=n==0?0:n==1?65535:next()&65535;
  for(k=0;k<16;k++){idx[k]=(uint32_t)(k*1024+(next()&1023)-8192);a[k]=next();}
  gather_same_value(o,data+8192,idx,mask);
  for(k=0;k<16;k++)CHECK(o[k]==((mask>>k&1)?data[8192+(int32_t)idx[k]]:idx[k]));
  gather_outer_loop(rows,data+8192,idx,a,mask);
  for(k=0;k<64;k++){int lane=k%16;CHECK(rows[k]==((mask>>lane&1)?data[8192+(int32_t)idx[lane]]:a[lane]));}
 }
 long pg=sysconf(_SC_PAGESIZE);uint32_t *guard=mmap(0,pg*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 CHECK(guard!=MAP_FAILED);CHECK(mprotect((char*)guard+pg,pg,PROT_READ|PROT_WRITE)==0);
 uint32_t *base=(uint32_t*)((char*)guard+pg);base[pg/4-1]=0xdeadbeef;
 for(k=0;k<16;k++){idx[k]=0x80000000;a[k]=next();}idx[0]=pg/4-1;
 test_gather(o,base,idx,a,1);CHECK(o[0]==0xdeadbeef);for(k=1;k<16;k++)CHECK(o[k]==a[k]);
 test_scatter(base,idx,a,1);CHECK(base[pg/4-1]==a[0]);
 test_gather(o,0,idx,a,0);for(k=0;k<16;k++)CHECK(o[k]==a[k]);test_scatter(0,idx,a,0);
 munmap(guard,pg*3);
 puts("PASS gather/scatter completion loops: 1000 masks across 16 pages, negative offsets, shared index/merge values, nested caller loops, merge values, inactive invalid indices, guard pages and zero-mask null base");return 0;
}
