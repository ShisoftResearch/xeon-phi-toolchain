#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
struct half_case {uint64_t input;uint16_t expected;};
#include "half-composition-corpus.h"
#define K(fn,n,w,plain,indexed,align,store) extern void fn(void*,void*,const void*,const void*);
#include "half-composition-cases.h"
#undef K
struct kernel{const char*name;void(*fn)(void*,void*,const void*,const void*);unsigned n,w,plain,indexed,align,store;};
#define K(fn,n,w,plain,indexed,align,store) {#fn,fn,n,w,plain,indexed,align,store},
static const struct kernel kernels[]={
#include "half-composition-cases.h"
};
#undef K
static uint64_t rng=UINT64_C(0x16abc32de64f);
static uint64_t next(void){rng^=rng<<13;rng^=rng>>7;rng^=rng<<17;return rng;}
static unsigned frac(unsigned w){return w==16?10:w==32?23:52;}
static uint64_t infinity(unsigned w){return w==16?UINT64_C(0x7c00):w==32?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000);}
static int isnanbits(uint64_t x,unsigned w){return (x&~(UINT64_C(1)<<(w-1)))>infinity(w);}
static int equal(uint64_t got,uint64_t want,uint64_t input,unsigned src,unsigned dst){
 if(!isnanbits(want,dst))return got==want;
 unsigned sf=frac(src),df=frac(dst);uint64_t payload=input&((UINT64_C(1)<<sf)-1);
 payload=sf>df?payload>>(sf-df):payload<<(df-sf);
 uint64_t propagated=(input>>(src-1))<<(dst-1)|infinity(dst)|payload;
 return isnanbits(got,dst)&&((got&(UINT64_C(1)<<(df-1)))||got==propagated);
}
/* Exact format expansion by integer decoding, independent of target FP code. */
static uint64_t extend(uint16_t h,unsigned w){
 unsigned f=frac(w),e=(h>>10)&31,m=h&1023;uint64_t sign=(uint64_t)(h>>15)<<(w-1);
 if(e==31)return sign|infinity(w)|((uint64_t)m<<(f-10));
 if(!e){if(!m)return sign;int exponent=-14;while(!(m&1024)){m<<=1;--exponent;}return sign|((uint64_t)(exponent+(w==32?127:1023))<<f)|((uint64_t)(m&1023)<<(f-10));}
 return sign|((uint64_t)(e-15+(w==32?127:1023))<<f)|((uint64_t)m<<(f-10));
}
static uint64_t get(const void*p,unsigned i,unsigned b){uint64_t x=0;memcpy(&x,(const char*)p+i*b,b);return x;}
static void put(void*p,unsigned i,unsigned b,uint64_t x){memcpy((char*)p+i*b,&x,b);}
static unsigned char*mapping(size_t p){unsigned char*m=mmap(0,p*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(m==MAP_FAILED||mprotect(m+p,p,PROT_READ|PROT_WRITE))exit(2);return m;}
int main(void){
 setbuf(stdout,0);
 size_t page=sysconf(_SC_PAGESIZE),calls=0,checks=0;
 unsigned char*mem=mapping(page),*outs=mapping(page),*expected=malloc(page);if(!expected)return 2;
 for(unsigned k=0;k<sizeof(kernels)/sizeof(kernels[0]);++k){
  const struct kernel*f=&kernels[k];
#ifdef TRACE_PROGRESS
  printf("TRACE %s\n",f->name);
#endif
  const struct half_case*data=f->w==32?data32:data64;
  size_t count=f->w==32?sizeof(data32)/sizeof(*data):sizeof(data64)/sizeof(*data);
  unsigned limit=f->plain?(f->store?(count+f->n-1)/f->n:(65536+f->n-1)/f->n):2048;
  for(unsigned mode=0;mode<(f->plain?3u:1u);++mode)for(unsigned iter=0;iter<limit;++iter){
   unsigned active=f->plain?f->n:iter%(f->n+1),offset=f->plain?(mode==2):f->align==1;
   unsigned char*base=f->plain?(mode==0?mem+page:mem+2*page-f->n*2-offset):(iter&1?mem+2*page-active*2-offset:mem+page-(f->n-active)*2+offset);
   uint32_t mask[32];void*ptrs[32];uint64_t want[32],inputs[32];unsigned char values[256];
   memset(mem+page,0xa5,page);memset(outs+page,0xa5,page);
   for(unsigned i=0;i<f->n;++i){
    unsigned j=f->indexed?(i*17+3)%f->n:i;unsigned char*p=base+j*2;
    int valid=p>=mem+page&&p+2<=mem+2*page;
    mask[i]=f->plain?1:valid&&(active==f->n||(next()&1));ptrs[i]=mask[i]?p:(void*)(uintptr_t)(i&1?0:1);
    if(f->store){const struct half_case*c=&data[(f->plain?iter*f->n+i:iter*17+i*31)%count];put(values,i,f->w/8,c->input);inputs[i]=c->input;want[i]=c->expected;}
    else{
     uint16_t pass=(uint16_t)(iter*29+i*43),h=f->plain?(uint16_t)(iter*f->n+i):(uint16_t)(iter*71+i*97+11);
     put(values,i,2,pass);if(mask[i])put(p,0,2,h);inputs[i]=mask[i]?h:pass;want[i]=extend((uint16_t)inputs[i],f->w);
    }
   }
   if(!f->plain&&iter%37==0){memset(mask,0,sizeof(mask));if(!f->indexed)base=0;if(!f->store)for(unsigned i=0;i<f->n;++i){inputs[i]=get(values,i,2);want[i]=extend((uint16_t)inputs[i],f->w);}}
   memcpy(expected,mem+page,page);
   if(f->store)for(unsigned i=0;i<f->n;++i)if(mask[i]){unsigned char*p=f->indexed?ptrs[i]:base+i*2;put(expected+(p-(mem+page)),0,2,want[i]);}
   unsigned char*out=outs+2*page-f->n*(f->w/8);
   f->fn(out,f->indexed?(void*)ptrs:base,values,mask);++calls;
   if(f->store){
    for(unsigned i=0;i<f->n;++i)if(mask[i]){unsigned char*p=f->indexed?ptrs[i]:base+i*2;uint64_t got=get(p,0,2);++checks;if(!equal(got,want[i],inputs[i],f->w,16))goto fail;put(expected+(p-(mem+page)),0,2,got);}
   }else for(unsigned i=0;i<f->n;++i){++checks;if(!equal(get(out,i,f->w/8),want[i],inputs[i],16,f->w)){printf("lane=%u input=%04llx got=%016llx expected=%016llx\n",i,(unsigned long long)inputs[i],(unsigned long long)get(out,i,f->w/8),(unsigned long long)want[i]);goto fail;}}
   if(memcmp(expected,mem+page,page))goto fail;
   continue;
fail:printf("FAIL half composition %s mode=%u iter=%u\n",f->name,mode,iter);return 1;
  }
 }
 free(expected);munmap(mem,page*3);munmap(outs,page*3);
 printf("PASS half compositions: %zu kernels, %zu calls, %zu exact/classified checks; all half encodings to FP32/FP64, wide-to-half rounding, guarded/unaligned contiguous/indexed masks, zero/full masks and null bases\n",sizeof(kernels)/sizeof(kernels[0]),calls,checks);return 0;
}
