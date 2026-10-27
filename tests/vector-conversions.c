#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "fp-bits.h"
struct sample { uint64_t input, expected; };
#include "vector-conversion-corpus.h"
#define K(fn,n,a,b,fp,data) extern void fn(void *, const void *);
#include "vector-conversion-cases.h"
#undef K
struct test { const char *name; void (*fn)(void *, const void *); unsigned n,a,b,fp; const struct sample *data; size_t count; };
#define K(fn,n,a,b,fp,data) {#fn,fn,n,a,b,fp,data,sizeof(data)/sizeof(data[0])},
static const struct test tests[]={
#include "vector-conversion-cases.h"
};
#undef K
int main(void) {
  size_t page=sysconf(_SC_PAGESIZE), calls=0, lanes=0;
  unsigned char *mi=mapping(page), *mo=mapping(page);
  for(unsigned t=0;t<sizeof(tests)/sizeof(tests[0]);++t) {
    const struct test *k=&tests[t];
    for(unsigned mode=0;mode<5;++mode) {
      unsigned char *in=mi+page+(mode==0?page-k->n*k->a:mode==1?0:k->a);
      unsigned char *out=mo+page+(mode==0?page-k->n*k->b:mode==1?0:k->b);
      if(mode==3) out=in;
      if(mode==4) out=in+8;
      for(size_t base=0;base<k->count;base+=k->n) {
        uint64_t expected[32], inputs[32];
        memset(mi+page,0xa5,page); memset(mo+page,0xa5,page);
        for(unsigned i=0;i<k->n;++i) {
          const struct sample *s=&k->data[(base+i)%k->count];
          put(in,i,k->a,s->input); inputs[i]=s->input; expected[i]=s->expected;
        }
        unsigned char *outpage=mode>=3?mi+page:mo+page;
        int has_before=out>outpage, has_after=out+k->n*k->b<outpage+page;
        unsigned char before=has_before?out[-1]:0, after=has_after?out[k->n*k->b]:0;
        k->fn(out,in); ++calls;
        if((has_before&&out[-1]!=before)||(has_after&&out[k->n*k->b]!=after)) {
          printf("FAIL %s output canary mode=%u case=%zu\n",k->name,mode,base); return 1;
        }
        for(unsigned i=0;i<k->n;++i) {
          uint64_t actual=get(out,i,k->b), want=expected[i]; ++lanes;
          int ok=actual==want;
          if(k->fp&&isnanbits(want,k->b*8)) {
            /* Unconstrained LLVM conversions permit unchanged NaN propagation.
               See https://llvm.org/docs/LangRef.html#nan-behavior. A signaling
               result must preserve the input payload with the format shift. */
            uint64_t propagated=k->a==4 ?
              ((inputs[i]&UINT64_C(0x80000000))<<32)|UINT64_C(0x7ff0000000000000)|((inputs[i]&UINT64_C(0x7fffff))<<29) :
              ((inputs[i]>>32)&UINT64_C(0x80000000))|UINT64_C(0x7f800000)|((inputs[i]&UINT64_C(0xfffffffffffff))>>29);
            ok=isnanbits(actual,k->b*8)&&(!signaling(actual,k->b*8)||actual==propagated);
          }
          if(!ok) { printf("FAIL %s mode=%u case=%zu lane=%u got=%016llx expected=%016llx\n",k->name,mode,base,i,(unsigned long long)actual,(unsigned long long)want); return 1; }
        }
      }
    }
  }
  munmap(mi,page*3); munmap(mo,page*3);
  printf("PASS vector conversions: %zu functions, %zu calls, %zu exact/classified lanes; guarded boundaries, natural offsets and overlapping buffers\n",sizeof(tests)/sizeof(tests[0]),calls,lanes);
  return 0;
}
