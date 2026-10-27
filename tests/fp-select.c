#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "fp-bits.h"
#define D(S) extern void auto_relu##S(void*,const void*,size_t),auto_clamp##S(void*,const void*,size_t),auto_choose##S(void*,const void*,const void*,size_t);
D(32) D(64)
static void run(unsigned bits,unsigned op,void *out,const void *a,const void *b,size_t n){
 if(bits==32){if(op==0)auto_relu32(out,a,n);else if(op==1)auto_clamp32(out,a,n);else auto_choose32(out,a,b,n);}
 else{if(op==0)auto_relu64(out,a,n);else if(op==1)auto_clamp64(out,a,n);else auto_choose64(out,a,b,n);}
}
static uint64_t oracle(unsigned bits,unsigned op,uint64_t x,uint64_t y){
 uint64_t lo=bits==32?UINT64_C(0xbf800000):UINT64_C(0xbff0000000000000),hi=bits==32?UINT64_C(0x3f800000):UINT64_C(0x3ff0000000000000);
 if(op==0)return predicate(2,x,0,bits)?x:0;
 if(op==1){if(predicate(4,x,lo,bits))x=lo;return predicate(2,x,hi,bits)?hi:x;}
 return predicate(4,x,y,bits)?x:y;
}
static int check(unsigned bits,unsigned n,unsigned offset,unsigned guarded,unsigned char *a,unsigned char *b,unsigned char *out,uint64_t *checks){
 unsigned bytes=bits/8;uint64_t all=UINT64_MAX>>(64-bits);
 static const uint64_t edge32[]={0,0x80000000,1,0x80000001,0x7fffff,0x807fffff,0x3f800000,0xbf800000,0x7f800000,0xff800000,0x7f800001,0xff800001,0x7fc00000,0xffc00000};
 static const uint64_t edge64[]={0,UINT64_C(0x8000000000000000),1,UINT64_C(0x8000000000000001),UINT64_C(0x000fffffffffffff),UINT64_C(0x800fffffffffffff),UINT64_C(0x3ff0000000000000),UINT64_C(0xbff0000000000000),UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),UINT64_C(0x7ff0000000000001),UINT64_C(0xfff0000000000001),UINT64_C(0x7ff8000000000000),UINT64_C(0xfff8000000000000)};
 for(unsigned i=0;i<n;i++){put(a,i,bytes,i%3?next()&all:(bits==32?edge32:edge64)[(i+n+offset)%14]);put(b,i,bytes,i%3?next()&all:(bits==32?edge32:edge64)[(i+n+offset+7)%14]);}
 for(unsigned op=0;op<3;op++){
  memset(out-16,0xa7,n*bytes+16+(guarded?0:16));run(bits,op,n?out:0,n?a:0,n?b:0,n);
  for(unsigned i=0;i<n;i++){uint64_t actual=get(out,i,bytes),expected=oracle(bits,op,get(a,i,bytes),get(b,i,bytes));if(actual!=expected){printf("FAIL C FP select bits=%u op=%u n=%u offset=%u guarded=%u lane=%u actual=%llx expected=%llx\n",bits,op,n,offset,guarded,i,(unsigned long long)actual,(unsigned long long)expected);return 1;}}
  for(unsigned i=1;i<=16;i++)if(out[-(int)i]!=0xa7){puts("FAIL C FP select prefix sentinel");return 1;}
  if(!guarded)for(unsigned i=0;i<16;i++)if(out[n*bytes+i]!=0xa7){puts("FAIL C FP select suffix sentinel");return 1;}
  (*checks)++;
 }
 return 0;
}
int main(void){size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[3];for(unsigned i=0;i<3;i++)maps[i]=mapping(page);unsigned char *storage[3];for(unsigned i=0;i<3;i++){storage[i]=malloc((4096+64)*8);if(!storage[i])return 1;}uint64_t checks=0;
 for(unsigned bits=32;bits<=64;bits+=32){unsigned bytes=bits/8;
  for(unsigned n=0;n<=257;n++){
   for(unsigned offset=0;offset<64/bytes;offset++)if(check(bits,n,offset,0,storage[0]+32+offset*bytes,storage[1]+32+(64/bytes-1-offset)*bytes,storage[2]+32+offset*bytes,&checks))return 1;
   if(check(bits,n,0,1,maps[0]+2*page-n*bytes,maps[1]+2*page-n*bytes,maps[2]+2*page-n*bytes,&checks))return 1;
  }
  for(unsigned n=511;n<=2053;n+=3)if(check(bits,n,n%(64/bytes),0,storage[0]+32,storage[1]+32,storage[2]+32,&checks))return 1;
 }
 for(unsigned i=0;i<3;i++){munmap(maps[i],page*3);free(storage[i]);}
 printf("PASS ordinary C FP32/FP64 auto-vectorization: ReLU/clamp/ordered selection, %llu length/offset/guard cases, NaN payloads/signaling values, signed zeros, subnormals, exact selections, scalar tails, sentinels and zero-length null pointers\n",(unsigned long long)checks);return 0;
}
