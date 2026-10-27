#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "half-corpus.h"
extern void vector_half_to_float(void*,const void*),vector_float_to_half(void*,const void*),scalar_half_to_float(uint32_t*,const uint16_t*),scalar_float_to_half(uint16_t*,const uint32_t*);
static uint32_t decode(uint16_t h){
 uint32_t sign=(uint32_t)(h&0x8000)<<16,e=(h>>10)&31,m=h&1023;
 if(e==31)return sign|0x7f800000|(m<<13);
 if(!e){if(!m)return sign;int exponent=-14;while(!(m&1024)){m<<=1;exponent--;}return sign|((uint32_t)(exponent+127)<<23)|((m&1023)<<13);}
 return sign|((e+112)<<23)|(m<<13);
}
#define CHECK(C) do{if(!(C)){printf("FAIL half line=%d case=%u lane=%u\n",__LINE__,n,k);return 1;}}while(0)
int main(void){
 uint16_t h[64] __attribute__((aligned(64))),out[64] __attribute__((aligned(64)));
 uint32_t f[16] __attribute__((aligned(64))),input[16] __attribute__((aligned(64)));unsigned n=0,k=0;
 for(n=0;n<65536;n+=16){
  for(k=0;k<16;k++)h[k]=(uint16_t)(n+k);
  vector_half_to_float(f,h);
  for(k=0;k<16;k++){
   uint32_t expected=decode(h[k]),scalar;scalar_half_to_float(&scalar,h+k);
   if((h[k]&0x7fff)>0x7c00){CHECK((f[k]&0x7fffffff)>0x7f800000);CHECK((scalar&0x7fffffff)>0x7f800000);}else{CHECK(f[k]==expected);CHECK(scalar==expected);}
  }
  vector_float_to_half(out,f);
  for(k=0;k<16;k++)if((h[k]&0x7fff)>0x7c00)CHECK((out[k]&0x7fff)>0x7c00);else CHECK(out[k]==h[k]);
 }
 const unsigned count=sizeof(half_cases)/sizeof(half_cases[0]);
 for(n=0;n<count;n+=16){
  for(k=0;k<16;k++)input[k]=half_cases[(n+k)%count].input;
  vector_float_to_half(out,input);
  for(k=0;k<16;k++){
   const struct half_case *c=&half_cases[(n+k)%count];uint16_t scalar;scalar_float_to_half(&scalar,input+k);
   if(c->nan){CHECK((out[k]&0x7fff)>0x7c00);CHECK((scalar&0x7fff)>0x7c00);}else{if(out[k]!=c->expected)printf("input=%08x vector=%04x expected=%04x\n",input[k],out[k],c->expected);CHECK(out[k]==c->expected);CHECK(scalar==c->expected);}
  }
 }
 for(n=0;n<32;n++){
  for(k=0;k<64;k++)h[k]=(uint16_t)(k*571+n);unsigned offset=n;
  vector_half_to_float(f,h+offset);for(k=0;k<16;k++)CHECK(f[k]==decode(h[offset+k]));
  memset(out,0x5a,sizeof(out));vector_float_to_half(out+offset,f);
  for(k=0;k<64;k++)CHECK(out[k]==((k>=offset&&k<offset+16)?h[k]:0x5a5a));
 }
 long pg=sysconf(_SC_PAGESIZE);unsigned char *guard=mmap(0,pg*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 CHECK(guard!=MAP_FAILED);CHECK(mprotect(guard+pg,pg,PROT_READ|PROT_WRITE)==0);
 for(n=0;n<2;n++){
  uint16_t *p=(uint16_t*)(guard+pg+(n?pg-32:0));for(k=0;k<16;k++)p[k]=(uint16_t)(0x3000+k);
  vector_half_to_float(f,p);for(k=0;k<16;k++)CHECK(f[k]==decode((uint16_t)(0x3000+k)));
  vector_float_to_half(p,f);for(k=0;k<16;k++)CHECK(p[k]==0x3000+k);
 }
 munmap(guard,pg*3);
 printf("PASS FP16: all 65536 half encodings decoded/round-tripped; %u exact float-to-half boundary cases; scalar compiler-rt and native vector paths; alignments and guard pages\n",count);return 0;
}
