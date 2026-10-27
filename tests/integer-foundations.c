#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "integer-foundation-ops.h"
#define K(fn,op,bits,n,reduce) extern void fn(void *,const void *,const void *);
#include "integer-foundation-cases.h"
#undef K
struct kernel {const char *name;void(*fn)(void*,const void*,const void*);unsigned op,bits,n,reduce;};
#define K(fn,op,bits,n,reduce) {#fn,fn,op,bits,n,reduce},
static const struct kernel kernels[]={
#include "integer-foundation-cases.h"
};
#undef K
static uint64_t rng=UINT64_C(0x4b314f4d83ab29);
static uint64_t next(void){rng^=rng<<13;rng^=rng>>7;rng^=rng<<17;return rng;}
static uint64_t mask(unsigned w){return UINT64_MAX>>(64-w);}
static int64_t signed_value(uint64_t x,unsigned w){uint64_t s=UINT64_C(1)<<(w-1);return (int64_t)((x^s)-s);}
static uint64_t get(const void*p,unsigned lane,unsigned bytes){uint64_t x=0;memcpy(&x,(const char*)p+lane*bytes,bytes);return x;}
static void put(void*p,unsigned lane,unsigned bytes,uint64_t x){memcpy((char*)p+lane*bytes,&x,bytes);}
static unsigned char *mapping(size_t p){unsigned char *m=mmap(0,p*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(m==MAP_FAILED||mprotect(m+p,p,PROT_READ|PROT_WRITE))exit(2);return m;}
static uint64_t reference(unsigned op,uint64_t x,uint64_t y,unsigned w){
 uint64_t m=mask(w),sign=UINT64_C(1)<<(w-1),r=0;unsigned s=y&(w-1);
 int64_t sx=signed_value(x,w),sy=signed_value(y,w);
 switch(op){
 case OP_ADD:return (x+y)&m;
 case OP_SUB:return (x-y)&m;
 case OP_MUL:return (x*y)&m;
 case OP_SDIV:return (uint64_t)(sx/sy)&m;
 case OP_UDIV:return x/y;
 case OP_SREM:return (uint64_t)(sx%sy)&m;
 case OP_UREM:return x%y;
 case OP_AND:return x&y;
 case OP_OR:return x|y;
 case OP_XOR:return x^y;
 case OP_SHL:return (x<<s)&m;
 case OP_LSHR:return x>>s;
 case OP_ASHR:return (x>>s)|((x&sign)?(m^(m>>s)):0);
 case OP_CTPOP:for(unsigned i=0;i<w;++i)r+=(x>>i)&1;return r;
 case OP_CTLZ:r=w;for(unsigned i=0;i<w;++i)if(x>>i)r=w-1-i;return r;
 case OP_CTTZ:if(!x)return w;while(!(x&1)){++r;x>>=1;}return r;
 case OP_BITREVERSE:for(unsigned i=0;i<w;++i)r|=((x>>i)&1)<<(w-1-i);return r;
 case OP_BSWAP:for(unsigned i=0;i<w/8;++i)r|=((x>>(8*i))&255)<<(w-8-8*i);return r;
 case OP_ABS:return sx<0?(-x)&m:x;
 case OP_SMIN:return sx<sy?x:y;
 case OP_SMAX:return sx>sy?x:y;
 case OP_UMIN:return x<y?x:y;
 case OP_UMAX:return x>y?x:y;
 case OP_SADD_SAT:r=(x+y)&m;return ((x^r)&(y^r)&sign)?(x&sign?sign:sign-1):r;
 case OP_UADD_SAT:return y>m-x?m:x+y;
 case OP_SSUB_SAT:r=(x-y)&m;return ((x^y)&(x^r)&sign)?(x&sign?sign:sign-1):r;
 case OP_USUB_SAT:return x<y?0:x-y;
 case OP_FSHL:return s?((x<<s)|(x>>(w-s)))&m:x;
 case OP_FSHR:return s?((x>>s)|(x<<(w-s)))&m:x;
 case OP_CMP_SEXT_EQ:return (x==y)?m:0;
 case OP_CMP_SEXT_NE:return (x!=y)?m:0;
 case OP_CMP_SEXT_SLT:return (sx<sy)?m:0;
 case OP_CMP_SEXT_SLE:return (sx<=sy)?m:0;
 case OP_CMP_SEXT_SGT:return (sx>sy)?m:0;
 case OP_CMP_SEXT_SGE:return (sx>=sy)?m:0;
 case OP_CMP_SEXT_ULT:return (x<y)?m:0;
 case OP_CMP_SEXT_ULE:return (x<=y)?m:0;
 case OP_CMP_SEXT_UGT:return (x>y)?m:0;
 case OP_CMP_SEXT_UGE:return (x>=y)?m:0;
 case OP_CMP_ZEXT_EQ:return (x==y)?1:0;
 case OP_CMP_ZEXT_NE:return (x!=y)?1:0;
 case OP_CMP_ZEXT_SLT:return (sx<sy)?1:0;
 case OP_CMP_ZEXT_SLE:return (sx<=sy)?1:0;
 case OP_CMP_ZEXT_SGT:return (sx>sy)?1:0;
 case OP_CMP_ZEXT_SGE:return (sx>=sy)?1:0;
 case OP_CMP_ZEXT_ULT:return (x<y)?1:0;
 case OP_CMP_ZEXT_ULE:return (x<=y)?1:0;
 case OP_CMP_ZEXT_UGT:return (x>y)?1:0;
 case OP_CMP_ZEXT_UGE:return (x>=y)?1:0;
 default:abort();
 }
}
int main(void){
 size_t page=sysconf(_SC_PAGESIZE),calls=0,checks=0;
 unsigned char *ma=mapping(page),*mb=mapping(page),*mo=mapping(page);
 for(unsigned k=0;k<sizeof(kernels)/sizeof(kernels[0]);++k){
  const struct kernel *f=&kernels[k];unsigned bytes=f->bits/8;uint64_t m=mask(f->bits),sign=UINT64_C(1)<<(f->bits-1);
  uint64_t edge[]={0,1,2,m,m-1,sign,sign-1,sign+1,m/3,(m/3)*2};
  for(unsigned mode=0;mode<4;++mode)for(unsigned iter=0;iter<256;++iter){
   unsigned length=f->n*bytes;
   unsigned char *a=ma+page+(mode==0?page-length:mode==1?0:1);
   unsigned char *b=mb+page+(mode==0?page-length:mode==1?0:3);
   unsigned outlen=f->reduce?bytes:length;
   unsigned char *out=mode==3?a:mo+page+(mode==0?page-outlen:mode==1?0:5);
   uint64_t expect[64],xs[64];
   memset(ma+page,0xa5,page);memset(mb+page,0xa5,page);memset(mo+page,0xa5,page);
   for(unsigned i=0;i<f->n;++i){
    uint64_t x=iter<100?edge[(iter+i)%10]:next()&m;
    uint64_t y=iter<100?edge[(iter/10+i*3)%10]:next()&m;
    if(f->op>=OP_SDIV&&f->op<=OP_UREM){if(!y)y=1;if(x==sign&&y==m)y=2;}
    if(f->op>=OP_SHL&&f->op<=OP_ASHR)y&=f->bits-1;
    put(a,i,bytes,x);put(b,i,bytes,y);xs[i]=x;
    if(!f->reduce)expect[i]=reference(f->op,x,y,f->bits);
   }
   if(f->reduce){
    static const unsigned map[]={OP_ADD,OP_MUL,OP_AND,OP_OR,OP_XOR,OP_SMIN,OP_SMAX,OP_UMIN,OP_UMAX};
    uint64_t r=xs[0];for(unsigned i=1;i<f->n;++i)r=reference(map[f->op-OP_REDUCE_ADD],r,xs[i],f->bits);expect[0]=r;
   }
   unsigned char *outpage=mode==3?ma+page:mo+page;
   int before=out>outpage,after=out+outlen<outpage+page;
   unsigned char cb=before?out[-1]:0,ca=after?out[outlen]:0;
   f->fn(out,a,b);++calls;
   if((before&&out[-1]!=cb)||(after&&out[outlen]!=ca)){printf("FAIL %s canary mode=%u iter=%u\n",f->name,mode,iter);return 1;}
   for(unsigned i=0;i<(f->reduce?1:f->n);++i){uint64_t got=get(out,i,bytes);++checks;if(got!=expect[i]){printf("FAIL %s mode=%u iter=%u lane=%u got=%016llx expected=%016llx\n",f->name,mode,iter,i,(unsigned long long)got,(unsigned long long)expect[i]);return 1;}}
  }
 }
 munmap(ma,page*3);munmap(mb,page*3);munmap(mo,page*3);
 printf("PASS integer foundations: %zu kernels, %zu calls, %zu lane/reduction checks; edge/random values, zero bitcounts, modulo rotations, saturation, guarded/unaligned memory and overlap\n",sizeof(kernels)/sizeof(kernels[0]),calls,checks);return 0;
}
