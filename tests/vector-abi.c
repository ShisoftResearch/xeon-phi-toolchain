#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "fp-bits.h"
#define K(fn,kind,bytes,inbytes,outbytes) extern void fn(void*,void*);
#include "vector-abi-cases.h"
#undef K
struct kernel{const char*name;void(*fn)(void*,void*);unsigned kind,bytes,inbytes,outbytes;};
#define K(fn,kind,bytes,inbytes,outbytes) {#fn,fn,kind,bytes,inbytes,outbytes},
static const struct kernel kernels[]={
#include "vector-abi-cases.h"
};
#undef K
/* The callee really destroys all vector register contents and both buffers.
 * An empty asm clobber list alone would not detect incorrectly retained values. */
__attribute__((noinline)) void abi_clobber(void*out,void*in,uint64_t bytes){
 memset(in,0x5a,bytes);memset(out,0xa7,bytes);
 __asm__ volatile(
 "vpxord %%zmm0,%%zmm0,%%zmm0\n\t"
 "vpxord %%zmm1,%%zmm1,%%zmm1\n\t"
 "vpxord %%zmm2,%%zmm2,%%zmm2\n\t"
 "vpxord %%zmm3,%%zmm3,%%zmm3\n\t"
 "vpxord %%zmm4,%%zmm4,%%zmm4\n\t"
 "vpxord %%zmm5,%%zmm5,%%zmm5\n\t"
 "vpxord %%zmm6,%%zmm6,%%zmm6\n\t"
 "vpxord %%zmm7,%%zmm7,%%zmm7\n\t"
 "vpxord %%zmm8,%%zmm8,%%zmm8\n\t"
 "vpxord %%zmm9,%%zmm9,%%zmm9\n\t"
 "vpxord %%zmm10,%%zmm10,%%zmm10\n\t"
 "vpxord %%zmm11,%%zmm11,%%zmm11\n\t"
 "vpxord %%zmm12,%%zmm12,%%zmm12\n\t"
 "vpxord %%zmm13,%%zmm13,%%zmm13\n\t"
 "vpxord %%zmm14,%%zmm14,%%zmm14\n\t"
 "vpxord %%zmm15,%%zmm15,%%zmm15\n\t"
 "vpxord %%zmm16,%%zmm16,%%zmm16\n\t"
 "vpxord %%zmm17,%%zmm17,%%zmm17\n\t"
 "vpxord %%zmm18,%%zmm18,%%zmm18\n\t"
 "vpxord %%zmm19,%%zmm19,%%zmm19\n\t"
 "vpxord %%zmm20,%%zmm20,%%zmm20\n\t"
 "vpxord %%zmm21,%%zmm21,%%zmm21\n\t"
 "vpxord %%zmm22,%%zmm22,%%zmm22\n\t"
 "vpxord %%zmm23,%%zmm23,%%zmm23\n\t"
 "vpxord %%zmm24,%%zmm24,%%zmm24\n\t"
 "vpxord %%zmm25,%%zmm25,%%zmm25\n\t"
 "vpxord %%zmm26,%%zmm26,%%zmm26\n\t"
 "vpxord %%zmm27,%%zmm27,%%zmm27\n\t"
 "vpxord %%zmm28,%%zmm28,%%zmm28\n\t"
 "vpxord %%zmm29,%%zmm29,%%zmm29\n\t"
 "vpxord %%zmm30,%%zmm30,%%zmm30\n\t"
 "vpxord %%zmm31,%%zmm31,%%zmm31\n\t"
 :::"zmm0","zmm1","zmm2","zmm3","zmm4","zmm5","zmm6","zmm7","zmm8","zmm9","zmm10","zmm11","zmm12","zmm13","zmm14","zmm15","zmm16","zmm17","zmm18","zmm19","zmm20","zmm21","zmm22","zmm23","zmm24","zmm25","zmm26","zmm27","zmm28","zmm29","zmm30","zmm31","memory");
}
int main(void){
 size_t page=sysconf(_SC_PAGESIZE),calls=0,checks=0;
 unsigned char*mi=mapping(page),*mo=mapping(page);unsigned char expected[2560];
 for(unsigned k=0;k<sizeof(kernels)/sizeof(kernels[0]);++k){const struct kernel*f=&kernels[k];
  for(unsigned mode=0;mode<4;++mode)for(unsigned iter=0;iter<128;++iter){
   unsigned char*in=mi+page+(mode==0?page-f->inbytes:mode==1?0:1);
   unsigned char*out=mode==3?in:mo+page+(mode==0?page-f->outbytes:mode==1?0:3);
   memset(mi+page,0xa5,page);memset(mo+page,0xa5,page);
   for(unsigned i=0;i<f->inbytes;++i)in[i]=(unsigned char)next();
   if(f->kind==0){
    memset(expected,0,f->outbytes);
    for(unsigned i=0;i<12;++i)for(unsigned b=0;b<f->bytes;++b)expected[b]^=in[i*f->bytes+b];
    uint64_t sum=0,xor=0;
    for(unsigned i=0;i<12;++i){sum+=get(in+12*f->bytes,i,8);xor^=get(in+12*f->bytes+96,i,8);}
    put(expected+f->bytes,0,8,sum);put(expected+f->bytes+8,0,8,xor);
   }else if(f->kind==1){memcpy(expected,in+2*f->bytes,f->bytes);memcpy(expected+f->bytes,in,f->bytes);memcpy(expected+2*f->bytes,in+f->bytes,f->bytes);memcpy(expected+3*f->bytes,in+3*f->bytes,16);}
   else memcpy(expected,in,f->inbytes);
   unsigned char*outpage=mode==3?mi+page:mo+page;int before=out>outpage,after=out+f->outbytes<outpage+page;
   unsigned char cb=before?out[-1]:0,ca=after?out[f->outbytes]:0;
   f->fn(out,in);++calls;
   if((before&&out[-1]!=cb)||(after&&out[f->outbytes]!=ca)){printf("FAIL vector ABI %s canary mode=%u iteration=%u\n",f->name,mode,iter);return 1;}
   for(unsigned i=0;i<f->outbytes;++i){++checks;if(out[i]!=expected[i]){printf("FAIL vector ABI %s mode=%u iteration=%u byte=%u got=%02x expected=%02x\n",f->name,mode,iter,i,out[i],expected[i]);return 1;}}
  }
 }
 munmap(mi,page*3);munmap(mo,page*3);
 printf("PASS vector ABI: %zu kernels, %zu calls, %zu exact byte checks; i8/i16/i32/i64/FP32/FP64 vectors at 128/256/512 bits, twelve mixed vector/integer/FP arguments, three-vector aggregate returns, forty live vectors across real register/buffer clobbering, protected/unaligned memory and overlap\n",sizeof(kernels)/sizeof(kernels[0]),calls,checks);return 0;
}
