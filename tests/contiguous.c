#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
typedef void (*kernel)(void*,const void*,const void*,const void*);
#define D(N,T,M) extern void contig_load##N##_##T##_##M(void*,const void*,const void*,const void*); extern void contig_store##N##_##T##_##M(void*,const void*,const void*,const void*);
#define K(N,T,B) D(N,T,aligned) D(N,T,unaligned)
#include "contiguous-cases.h"
#undef K
struct testcase{const char *name;unsigned count,bytes;kernel load[2],store[2];};
#define K(N,T,B) {#N "x" #T,N,B,{contig_load##N##_##T##_aligned,contig_load##N##_##T##_unaligned},{contig_store##N##_##T##_aligned,contig_store##N##_##T##_unaligned}},
static const struct testcase cases[]={
#include "contiguous-cases.h"
};
#undef K
static uint32_t state=0x78139ac;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
static unsigned char *mapping(size_t page){unsigned char *p=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(p==MAP_FAILED||mprotect(p+page,page,PROT_READ|PROT_WRITE))exit(1);return p;}
static void payload(unsigned char *p,unsigned bytes,unsigned n,unsigned lane){
 static const uint64_t wide[]={0,UINT64_C(0x8000000000000000),UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),UINT64_C(0x7ff0000000000001),UINT64_C(0x7ff8000000000001),UINT64_MAX,1,UINT64_C(0x7fefffffffffffff)};
 static const uint32_t narrow[]={0,0x80000000,0x7f800000,0xff800000,0x7f800001,0x7fc00001,UINT32_MAX,1,0x7f7fffff};
 if(n<18&&bytes==8){uint64_t x=wide[(n+lane)%9];memcpy(p,&x,8);}
 else if(n<18&&bytes==4){uint32_t x=narrow[(n+lane)%9];memcpy(p,&x,4);}
 else for(unsigned j=0;j<bytes;j++)p[j]=(unsigned char)next();
}
#define CHECK(X) do{if(!(X)){printf("FAIL contiguous type=%s mode=%u iteration=%u line=%d\n",c->name,mode,n,__LINE__);return 1;}}while(0)
extern int check_contiguous_conversions(void);
int main(void){
 if(check_contiguous_conversions())return 1;
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[4];for(unsigned i=0;i<4;i++)maps[i]=mapping(page);
 unsigned char *expected_page=malloc(page);if(!expected_page)return 1;
 unsigned char values[128],expected[128],snapshot[256];uint32_t masks[16];uint64_t checks=0;
 size_t span=(UINT64_C(1)<<34)+3*page;unsigned char *sparse=mmap(0,span,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 if(sparse==MAP_FAILED)return 1;unsigned char *high=sparse+page+(UINT64_C(1)<<34);if(mprotect(high,page,PROT_READ|PROT_WRITE))return 1;
 for(unsigned t=0;t<sizeof(cases)/sizeof(cases[0]);t++){
  const struct testcase *c=cases+t;unsigned count=c->count,bytes=c->bytes,total=count*bytes,mode=0,n=0;
  for(mode=0;mode<2;mode++){
   for(n=0;n<500;n++){
    unsigned active=n%(count+1);unsigned char *base;
    if(n%3==0)base=maps[0]+page-active*bytes+(mode?1:0); /* Protected prefix. */
    else if(n%3==1)base=maps[0]+2*page-active*bytes-(mode?1:0); /* Protected suffix. */
    else base=maps[0]+page+64+(n%32)*bytes+(mode?1:0);
    memset(maps[0]+page,0x9b,page);
    for(unsigned i=0;i<count;i++){
     unsigned char *p=base+i*bytes;int valid=p>=maps[0]+page&&p+bytes<=maps[0]+2*page;
     masks[i]=valid&&(n<18?((n>> (i%4))&1):(next()&1))?(next()|1):0;
     payload(values+i*bytes,bytes,n,i);
     if(valid)payload(p,bytes,n+3,i);
     memcpy(expected+i*bytes,masks[i]?p:values+i*bytes,bytes);
    }
    unsigned char *in=maps[1]+page+(n&1?page-total:0),*mask=maps[2]+page+(n&1?page-count*4:0),*out=maps[3]+page+(n&1?page-total:0);
    memcpy(in,values,total);memcpy(mask,masks,count*4);memset(maps[3]+page,0xa7,page);
    c->load[mode](out,base,in,mask);CHECK(!memcmp(out,expected,total));
    if(n&1){for(unsigned i=1;i<=32;i++)CHECK(out[-(int)i]==0xa7);}else{for(unsigned i=0;i<32;i++)CHECK(out[total+i]==0xa7);}
    memcpy(expected_page,maps[0]+page,page);
    for(unsigned i=0;i<count;i++)if(masks[i])memcpy(expected_page+(base+i*bytes-(maps[0]+page)),values+i*bytes,bytes);
    c->store[mode](0,base,in,mask);CHECK(!memcmp(maps[0]+page,expected_page,page));checks++;
   }
   for(n=0;n<20;n++){
    for(unsigned i=0;i<count;i++){masks[i]=n?next()&1:~0u;payload(high+i*bytes,bytes,n,i);payload(values+i*bytes,bytes,n+7,i);memcpy(expected+i*bytes,masks[i]?high+i*bytes:values+i*bytes,bytes);}
    c->load[mode](maps[3]+page,high,values,masks);CHECK(!memcmp(maps[3]+page,expected,total));
    c->store[mode](0,high,values,masks);for(unsigned i=0;i<count;i++)if(masks[i])CHECK(!memcmp(high+i*bytes,values+i*bytes,bytes));checks++;
   }
   /* All-zero masks permit null data addresses; padding must remain inactive. */
   memset(masks,0,sizeof(masks));c->load[mode](maps[3]+page,0,values,masks);CHECK(!memcmp(maps[3]+page,values,total));c->store[mode](0,0,values,masks);
   /* Source/destination overlaps require a complete source snapshot. */
   for(n=0;n<20;n++){
    unsigned char *p=maps[0]+page;
    for(unsigned i=0;i<count;i++)masks[i]=next()&1;
    for(unsigned i=0;i<total+bytes;i++)p[i]=(unsigned char)next();memcpy(snapshot,p,total+bytes);memcpy(expected_page,p,total+bytes);
    for(unsigned i=0;i<count;i++)if(masks[i])memcpy(expected_page+(i+1)*bytes,snapshot+i*bytes,bytes);
    c->store[mode](0,p+bytes,p,masks);CHECK(!memcmp(p,expected_page,total+bytes));checks++;
   }
  }
 }
 for(unsigned i=0;i<4;i++)munmap(maps[i],page*3);munmap(sparse,span);free(expected_page);
 printf("PASS contiguous LLVM masked memory: 28 type/width combinations, %llu cases, aligned/native and unaligned/scalar paths, protected inactive prefixes/suffixes, exact FP/pointer payloads, guarded inputs/outputs, 16-GiB base addresses, zero-mask null pointers and source aliasing\n",(unsigned long long)checks);return 0;
}
