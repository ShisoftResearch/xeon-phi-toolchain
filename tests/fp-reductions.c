#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "fp-bits.h"
struct fp_case {uint64_t start,x[32],low,high;unsigned nan;};
#include "fp-reduction-corpus.h"
#define K(fn,n,w,data) extern void fn(void*,const void*,const void*);
#include "fp-reduction-cases.h"
#undef K
struct kernel {const char*name;void(*fn)(void*,const void*,const void*);unsigned n,w;const struct fp_case*data;size_t count;};
#define K(fn,n,w,data) {#fn,fn,n,w,data,sizeof(data)/sizeof(data[0])},
static const struct kernel kernels[]={
#include "fp-reduction-cases.h"
};
#undef K
static uint64_t key(uint64_t x,unsigned w){uint64_t sign=UINT64_C(1)<<(w-1),mask=UINT64_MAX>>(64-w);return x&sign?(~x)&mask:x|sign;}
int main(void){
 size_t page=sysconf(_SC_PAGESIZE),calls=0;
 unsigned char*mi=mapping(page),*mo=mapping(page);
 for(unsigned k=0;k<sizeof(kernels)/sizeof(kernels[0]);++k){
  const struct kernel*f=&kernels[k];unsigned bytes=f->w/8;
  for(unsigned mode=0;mode<4;++mode)for(size_t c=0;c<f->count;++c){
   const struct fp_case*t=&f->data[c];unsigned char init[8];
   unsigned char*in=mi+page+(mode==0?page-f->n*bytes:mode==1?0:1);
   unsigned char*out=mode==3?in:mo+page+(mode==0?page-bytes:mode==1?0:3);
   memset(mi+page,0xa5,page);memset(mo+page,0xa5,page);
   for(unsigned i=0;i<f->n;++i)put(in,i,bytes,t->x[i]);put(init,0,bytes,t->start);
   unsigned char*outpage=mode==3?mi+page:mo+page;
   int before=out>outpage,after=out+bytes<outpage+page;
   unsigned char cb=before?out[-1]:0,ca=after?out[bytes]:0;
   f->fn(out,in,init);++calls;uint64_t got=get(out,0,bytes),ordered=key(got,f->w);
   if((before&&out[-1]!=cb)||(after&&out[bytes]!=ca)){printf("FAIL FP reduction %s canary mode=%u case=%zu\n",f->name,mode,c);return 1;}
   if(t->nan?!isnanbits(got,f->w):(isnanbits(got,f->w)||ordered<t->low||ordered>t->high)){
    printf("FAIL FP reduction %s mode=%u case=%zu bits=%016llx ordered=%016llx allowed=[%016llx,%016llx] nan=%u\n",f->name,mode,c,(unsigned long long)got,(unsigned long long)ordered,(unsigned long long)t->low,(unsigned long long)t->high,t->nan);return 1;
   }
  }
 }
 munmap(mi,page*3);munmap(mo,page*3);
 printf("PASS FP reductions: %zu kernels, %zu checks; exact sequential sums/products, error-bounded reassociated arithmetic, numeric/propagating minmax, IEEE edge values and guarded/unaligned overlapping memory\n",sizeof(kernels)/sizeof(kernels[0]),calls);return 0;
}
