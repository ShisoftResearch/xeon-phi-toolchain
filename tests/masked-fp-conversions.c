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
#define K(fn,n,indexed,align,store) extern void fn(void *,void *,const void *,const void *);
#include "masked-fp-conversion-cases.h"
#undef K
struct test {const char *name; void (*fn)(void *,void *,const void *,const void *); unsigned n,indexed,align,store;};
#define K(fn,n,indexed,align,store) {#fn,fn,n,indexed,align,store},
static const struct test tests[]={
#include "masked-fp-conversion-cases.h"
};
#undef K
static int equal(uint64_t got,uint64_t want,uint64_t input,unsigned src,unsigned dst) {
  if(!isnanbits(want,dst)) return got==want;
  uint64_t propagated=src==32 ? ((input&UINT64_C(0x80000000))<<32)|UINT64_C(0x7ff0000000000000)|((input&UINT64_C(0x7fffff))<<29) :
    ((input>>32)&UINT64_C(0x80000000))|UINT64_C(0x7f800000)|((input&UINT64_C(0xfffffffffffff))>>29);
  return isnanbits(got,dst)&&(!signaling(got,dst)||got==propagated);
}
int main(void) {
 size_t page=sysconf(_SC_PAGESIZE),calls=0,lanes=0;
 unsigned char *mem=mapping(page),*outs=mapping(page),*expected=malloc(page);
 if(!expected)return 1;
 for(unsigned t=0;t<sizeof(tests)/sizeof(tests[0]);++t) {
  const struct test *k=&tests[t];
  const struct sample *data=k->store?data_fptrunc_f64_f32:data_fpext_f32_f64;
  size_t count=k->store?sizeof(data_fptrunc_f64_f32)/sizeof(*data):sizeof(data_fpext_f32_f64)/sizeof(*data);
  for(unsigned iter=0;iter<2048;++iter) {
   uint32_t mask[32]; void *ptrs[32]; uint64_t want[32],inputs[32]; unsigned char values[256];
   unsigned active=iter%(k->n+1), offset=k->align==1?1:0;
   /* Alternate low/high protected boundaries, then exercise the zero-mask
      null-base case. Indexed inactive pointers are deliberately invalid. */
   unsigned char *base=iter&1?mem+2*page-active*4-offset:mem+page-(k->n-active)*4+offset;
   memset(mem+page,0xa5,page);memset(outs+page,0xa5,page);
   for(unsigned i=0;i<k->n;++i) {
    unsigned j=k->indexed?(i*17+3)%k->n:i;
    unsigned char *p=base+j*4;
    int valid=p>=mem+page&&p+4<=mem+2*page;
    mask[i]=valid&&(active==k->n||(next()&1)); ptrs[i]=mask[i]?p:(void *)(uintptr_t)(i&1?0:1);
    const struct sample *sample=&data[(iter*17+i*31)%count];
    inputs[i]=sample->input;want[i]=sample->expected;
    put(values,i,k->store?8:4,sample->input);
    if(!k->store&&mask[i]) {
     const struct sample *loaded=&data[(iter*29+i*43+11)%count];
     put(p,0,4,loaded->input);inputs[i]=loaded->input;want[i]=loaded->expected;
    }
   }
   if(iter%37==0) {
    memset(mask,0,sizeof(mask));if(!k->indexed)base=0;
    if(!k->store)for(unsigned i=0;i<k->n;++i) {
     const struct sample *pass=&data[(iter*17+i*31)%count];
     inputs[i]=pass->input;want[i]=pass->expected;
    }
   }
   memcpy(expected,mem+page,page);
   if(k->store)for(unsigned i=0;i<k->n;++i)if(mask[i]) {
    unsigned char *p=k->indexed?ptrs[i]:base+i*4;
    put(expected+(p-(mem+page)),0,4,want[i]);
   }
   unsigned char *out=outs+2*page-k->n*8;
   k->fn(out,k->indexed?(void *)ptrs:base,values,mask);++calls;
   if(k->store) {
    /* Classify allowed NaN payloads, then compare the entire destination page
       to catch any write to inactive elements or neighboring bytes. */
    for(unsigned i=0;i<k->n;++i)if(mask[i]) {
     unsigned char *p=k->indexed?ptrs[i]:base+i*4;
     uint64_t actual=get(p,0,4);++lanes;
     if(!equal(actual,want[i],inputs[i],64,32))goto fail;
     put(expected+(p-(mem+page)),0,4,actual);
    }
    if(memcmp(expected,mem+page,page))goto fail;
   } else {
    for(unsigned i=0;i<k->n;++i){++lanes;if(!equal(get(out,i,8),want[i],inputs[i],32,64))goto fail;}
    if(memcmp(expected,mem+page,page))goto fail;
   }
   continue;
fail:
   printf("FAIL masked FP conversions %s iteration=%u\n",k->name,iter);return 1;
  }
 }
 free(expected);munmap(mem,page*3);munmap(outs,page*3);
 printf("PASS masked FP conversions: %zu functions, %zu calls, %zu exact/classified lanes; guarded inactive memory, zero/full masks, null bases, aligned/unaligned indexed and contiguous memory\n",sizeof(tests)/sizeof(tests[0]),calls,lanes);return 0;
}
