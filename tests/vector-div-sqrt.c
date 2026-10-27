#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "fp-corpus.h"
#include "fp-bits.h"
typedef void (*kernel)(void*,const void*,const void*);
#ifdef RUST_FRONTEND
extern void rust_vector_div16_f32(void*,const void*,const void*),rust_vector_sqrt16_f32(void*,const void*,const void*),rust_vector_div8_f64(void*,const void*,const void*),rust_vector_sqrt8_f64(void*,const void*,const void*);
#else
#define K(N,B) extern void vector_div##N##_f##B(void*,const void*,const void*),vector_sqrt##N##_f##B(void*,const void*,const void*);
#include "vector-div-sqrt-cases.h"
#undef K
#endif
struct testcase{unsigned lanes,bits;kernel div,sqrt;};
static const struct testcase cases[]={
#ifdef RUST_FRONTEND
 {16,32,rust_vector_div16_f32,rust_vector_sqrt16_f32},{8,64,rust_vector_div8_f64,rust_vector_sqrt8_f64}
#else
#define K(N,B) {N,B,vector_div##N##_f##B,vector_sqrt##N##_f##B},
#include "vector-div-sqrt-cases.h"
#undef K
#endif
};
#define CHECK(X) do{if(!(X)){printf("FAIL vector math bits=%u lanes=%u op=%u offset=%u batch=%u lane=%u line=%d got=%llx expected=%llx\n",bits,lanes,op,offset,batch,k,__LINE__,(unsigned long long)actual,(unsigned long long)expected);return 1;}}while(0)
int main(void){size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[3];for(unsigned i=0;i<3;i++)maps[i]=mapping(page);uint64_t checked=0,calls=0;
 for(unsigned t=0;t<sizeof(cases)/sizeof(cases[0]);t++){
  const struct testcase *c=cases+t;unsigned bits=c->bits,bytes=bits/8,lanes=c->lanes,total=lanes*bytes,op,offset,batch,k=0;uint64_t actual=0,expected=0;unsigned char aa[512],bb[512],oo[512],snapshot[512];
  for(op=0;op<2;op++){
   unsigned indices[8192],count=0,code=op?5:3,n=bits==32?sizeof(fp32_cases)/sizeof(fp32_cases[0]):sizeof(fp64_cases)/sizeof(fp64_cases[0]);
   for(unsigned i=0;i<n;i++)if((bits==32?fp32_cases[i].op:fp64_cases[i].op)==code)indices[count++]=i;
   for(offset=0;offset<17;offset++)for(batch=0;batch<count;batch+=lanes){
    unsigned char *a=offset==16?maps[0]+2*page-total:aa+32+offset*bytes,*b=offset==16?maps[1]+2*page-total:bb+32+(15-offset)*bytes,*out=offset==16?maps[2]+2*page-total:oo+32+offset*bytes;
    uint64_t expected_lanes[32];unsigned nan_lanes[32];
    for(k=0;k<lanes;k++){unsigned i=indices[(batch+k)%count];uint64_t x,y;
     if(bits==32){x=fp32_cases[i].a;y=fp32_cases[i].b;expected_lanes[k]=fp32_cases[i].expected;nan_lanes[k]=fp32_cases[i].nan;}
     else{x=fp64_cases[i].a;y=fp64_cases[i].b;expected_lanes[k]=fp64_cases[i].expected;nan_lanes[k]=fp64_cases[i].nan;}
     put(a,k,bytes,x);put(b,k,bytes,y);
    }
    memset(out-16,0xa7,total+16+(offset==16?0:16));kernel fn=op?c->sqrt:c->div;fn(out,a,b);calls++;
    for(k=0;k<lanes;k++){actual=get(out,k,bytes);expected=expected_lanes[k];CHECK(nan_lanes[k]?isnanbits(actual,bits)&&!signaling(actual,bits):actual==expected);checked++;}
    for(k=1;k<=16;k++)CHECK(out[-(int)k]==0xa7);
    if(offset!=16)for(k=0;k<16;k++)CHECK(out[total+k]==0xa7);
    /* Overlapping output must not alter inputs before the operation snapshots them. */
    memcpy(snapshot,a,total);memcpy(aa+32,snapshot,total);fn(aa+32+bytes,aa+32,b);calls++;
    for(k=0;k<lanes;k++){actual=get(aa+32+bytes,k,bytes);expected=expected_lanes[k];CHECK(nan_lanes[k]?isnanbits(actual,bits)&&!signaling(actual,bits):actual==expected);checked++;}
   }
  }
 }
 for(unsigned i=0;i<3;i++)munmap(maps[i],page*3);
 printf("PASS vector divide/sqrt scalar-runtime fallback: %llu IEEE lane results across %llu calls; exact rational/isqrt oracle, signed zeros, NaNs, infinities, subnormals, rounding boundaries, mixed lanes, natural offsets, overlapping output and protected buffers\n",(unsigned long long)checked,(unsigned long long)calls);return 0;
}
