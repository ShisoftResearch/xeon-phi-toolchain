#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
typedef void (*kernel)(void*,const void*,const void*);
#define P(N) extern void cmp_f32_##N(void*,const void*,const void*),cmp_f64_##N(void*,const void*,const void*),select_f32_##N(void*,const void*,const void*),select_f64_##N(void*,const void*,const void*);
#define M(N) extern void N##_f32(void*,const void*,const void*),N##_f64(void*,const void*,const void*);
#include "fp-compare-cases.h"
#undef P
#undef M
extern void fabs_f32(void*,const void*,const void*),fabs_f64(void*,const void*,const void*),fneg_f32(void*,const void*,const void*),fneg_f64(void*,const void*,const void*),variable_select_f32(void*,const void*,const void*),variable_select_f64(void*,const void*,const void*);
#define P(N) {#N,{cmp_f32_##N,cmp_f64_##N},{select_f32_##N,select_f64_##N}},
#define M(N)
static const struct {const char *name;kernel cmp[2],select[2];} preds[]={
#include "fp-compare-cases.h"
};
#undef P
#undef M
#define P(N)
#define M(N) {#N,{N##_f32,N##_f64}},
static const struct {const char *name;kernel fn[2];} mins[]={
#include "fp-compare-cases.h"
};
#undef P
#undef M
#include "fp-bits.h"
#define CHECK(X) do{if(!(X)){printf("FAIL FP compare bits=%u case=%u lane=%u operation=%s line=%d actual=%llx expected=%llx\n",bits,n,k,name,__LINE__,(unsigned long long)actual,(unsigned long long)expected);return 1;}}while(0)
int main(void){
 static const uint64_t edges32[]={0,0x80000000,1,0x80000001,0x007fffff,0x807fffff,0x00800000,0x80800000,0x3f800000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7f800001,0xff800001,0x7fc00000,0xffc00000,0x7fffffff,0xffffffff};
 static const uint64_t edges64[]={0,UINT64_C(0x8000000000000000),1,UINT64_C(0x8000000000000001),UINT64_C(0x000fffffffffffff),UINT64_C(0x800fffffffffffff),UINT64_C(0x0010000000000000),UINT64_C(0x8010000000000000),UINT64_C(0x3ff0000000000000),UINT64_C(0xbff0000000000000),UINT64_C(0x7fefffffffffffff),UINT64_C(0xffefffffffffffff),UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),UINT64_C(0x7ff0000000000001),UINT64_C(0xfff0000000000001),UINT64_C(0x7ff8000000000000),UINT64_C(0xfff8000000000000),UINT64_MAX>>1,UINT64_MAX};
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[3];for(unsigned i=0;i<3;i++)maps[i]=mapping(page);uint64_t checks=0;
 for(unsigned type=0;type<2;type++){
  unsigned bits=type?64:32,bytes=bits/8,lanes=64/bytes,k,n;uint64_t sign=UINT64_C(1)<<(bits-1),all=UINT64_MAX>>(64-bits),actual=0,expected=0;const char *name="init";unsigned char aa[256],bb[256],oo[256];const uint64_t *edges=type?edges64:edges32;
  for(n=0;n<5000;n++){
   unsigned char *a=n%31?aa+32+(n%16)*bytes:maps[0]+2*page-64,*b=n%31?bb+32+((15-n%16)*bytes):maps[1]+2*page-64,*out=n%31?oo+32+(n%16)*bytes:maps[2]+2*page-64;
   memset(out-16,0xa7,80);
   for(k=0;k<lanes;k++){uint64_t x=n<400?edges[(n/20+k)%20]:next()&all,y=n<400?edges[(n+k)%20]:next()&all;if(n%19==0)y=x;put(a,k,bytes,x);put(b,k,bytes,y);}
   for(unsigned pred=0;pred<16;pred++){
    name=preds[pred].name;preds[pred].cmp[type](out,a,b);
    for(k=0;k<lanes;k++){expected=predicate(pred,get(a,k,bytes),get(b,k,bytes),bits)?all:0;actual=get(out,k,bytes);CHECK(actual==expected);checks++;}
    preds[pred].select[type](out,a,b);
    for(k=0;k<lanes;k++){uint64_t x=get(a,k,bytes),y=get(b,k,bytes);expected=predicate(pred,x,y,bits)?x:y;actual=get(out,k,bytes);CHECK(actual==expected);checks++;}
   }
   for(unsigned op=0;op<6;op++){
    name=mins[op].name;mins[op].fn[type](out,a,b);
    for(k=0;k<lanes;k++){expected=minimum(op,get(a,k,bytes),get(b,k,bytes),bits);actual=get(out,k,bytes);CHECK(isnanbits(expected,bits)?isnanbits(actual,bits)&&!signaling(actual,bits):actual==expected);checks++;}
   }
   for(unsigned neg=0;neg<2;neg++){
    name=neg?"fneg":"fabs";kernel fn=neg?(type?fneg_f64:fneg_f32):(type?fabs_f64:fabs_f32);fn(out,a,b);
    for(k=0;k<lanes;k++){expected=neg?get(a,k,bytes)^sign:get(a,k,bytes)&~sign;actual=get(out,k,bytes);CHECK(actual==expected);checks++;}
   }
   name="variable select";uint64_t choices[16];for(k=0;k<lanes;k++){choices[k]=next()&1?next()&all:0;put(out,k,bytes,choices[k]);}
   (type?variable_select_f64:variable_select_f32)(out,a,b);
   for(k=0;k<lanes;k++){expected=get(choices[k]?a:b,k,bytes);actual=get(out,k,bytes);CHECK(actual==expected);checks++;}
   for(k=1;k<=16;k++)CHECK(out[-(int)k]==0xa7);
  }
 }
 for(unsigned i=0;i<3;i++)munmap(maps[i],page*3);
 printf("PASS native FP32/FP64 compare/select/minmax: %llu exact/classified lane results; all 16 predicates, six minmax variants, signed zeros, NaNs including signaling payloads, infinities/subnormals/random encodings, bit-exact abs/neg/select, natural offsets and protected boundaries\n",(unsigned long long)checks);return 0;
}
