#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
typedef void (*kernel)(void*,const void*,const void*,const void*);
#define D(N,T,M) extern void packed_expand##N##_##T##_##M(void*,const void*,const void*,const void*); extern void packed_compress##N##_##T##_##M(void*,const void*,const void*,const void*);
#define K(N,T,B) D(N,T,aligned) D(N,T,unaligned)
#include "packed-cases.h"
#undef K
struct testcase{const char *name;unsigned count,bytes;kernel expand[2],compress[2];};
#define K(N,T,B) {#N "x" #T,N,B,{packed_expand##N##_##T##_aligned,packed_expand##N##_##T##_unaligned},{packed_compress##N##_##T##_aligned,packed_compress##N##_##T##_unaligned}},
static const struct testcase cases[]={
#include "packed-cases.h"
};
#undef K
static uint32_t state=0x78139ac;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
static unsigned char *mapping(size_t page){unsigned char *p=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(p==MAP_FAILED||mprotect(p+page,page,PROT_READ|PROT_WRITE))exit(1);return p;}
#define CHECK(X) do{if(!(X)){printf("FAIL packed type=%s mode=%u iteration=%u bits=%x line=%d\n",c->name,mode,n,bits,__LINE__);return 1;}}while(0)
int main(void){
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[4];for(unsigned i=0;i<4;i++)maps[i]=mapping(page);
 unsigned char values[128],packed[128],expected[256],snapshot[256];uint32_t masks[16];uint64_t checks=0;
 for(unsigned t=0;t<sizeof(cases)/sizeof(cases[0]);t++){
  const struct testcase *c=cases+t;unsigned count=c->count,bytes=c->bytes,total=count*bytes,mode,n,bits=0;
  unsigned limit=count<16?(1u<<count):(bytes==4?65536:2048);
  for(mode=0;mode<2;mode++){
   for(n=0;n<limit;n++){
    bits=count<16||bytes==4?n:(n<18?(n?1u<<(n-1):0):next()&65535);
    if(n==17&&count==16)bits=65535;
    unsigned active=0;for(unsigned i=0;i<count;i++){masks[i]=(bits>>i)&1?next()|1:0;active+=!!masks[i];}
    unsigned size=active*bytes,offset=mode&&bytes>1;
    unsigned char *base=maps[0]+2*page-size-offset,*in=maps[1]+2*page-total,*mask=maps[2]+2*page-count*4,*out=maps[3]+2*page-total;
    for(unsigned i=0;i<total;i++){values[i]=(unsigned char)next();packed[i]=(unsigned char)next();}
    memcpy(base,packed,size);memcpy(in,values,total);memcpy(mask,masks,count*4);memset(out-16,0xa7,total+16);
    unsigned rank=0;for(unsigned i=0;i<count;i++){memcpy(expected+i*bytes,masks[i]?packed+rank*bytes:values+i*bytes,bytes);rank+=!!masks[i];}
    c->expand[mode](out,active?base:0,in,mask);CHECK(!memcmp(out,expected,total));for(unsigned i=1;i<=16;i++)CHECK(out[-(int)i]==0xa7);
    memset(base-16,0x9b,size+16+offset);rank=0;
    for(unsigned i=0;i<count;i++)if(masks[i])memcpy(expected+rank++*bytes,values+i*bytes,bytes);
    c->compress[mode](0,active?base:0,in,mask);CHECK(!memcmp(base,expected,size));for(unsigned i=1;i<=16;i++)CHECK(base[-(int)i]==0x9b);if(offset)CHECK(base[size]==0x9b);checks++;
   }
   /* Loads must snapshot all source lanes before any overlapping stores. */
   for(n=0;n<100;n++){
    bits=next();for(unsigned i=0;i<count;i++)masks[i]=(bits>>i)&1;
    unsigned char *p=maps[0]+page+128;for(unsigned i=0;i<total+bytes;i++)p[i]=(unsigned char)next();memcpy(snapshot,p,total+bytes);memcpy(expected,p,total+bytes);
    unsigned rank=0;for(unsigned i=0;i<count;i++)if(masks[i])memcpy(expected+bytes+rank++*bytes,snapshot+i*bytes,bytes);
    c->compress[mode](0,p+bytes,p,masks);CHECK(!memcmp(p,expected,total+bytes));checks++;
   }
  }
 }
 for(unsigned i=0;i<4;i++)munmap(maps[i],page*3);
 printf("PASS LLVM packed compress/expand: 28 type/width combinations, %llu cases, all 65536 native 16x32 masks, aligned/unaligned paths, guarded packed buffers/inputs/outputs, exact payloads, zero-mask null pointers and source aliasing\n",(unsigned long long)checks);return 0;
}
