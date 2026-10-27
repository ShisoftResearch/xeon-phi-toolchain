#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
typedef void (*kernel)(void*,const void*,const void*,const void*,const void*);
#define D(N,T,M) extern void wide_g##N##_##T##_##M(void*,const void*,const void*,const void*,const void*); extern void wide_s##N##_##T##_##M(void*,const void*,const void*,const void*,const void*);
#define K(N,T,B) D(N,T,idx) D(N,T,ptr) D(N,T,unaligned)
#include "masked-widths-cases.h"
#undef K
struct testcase{const char *name;unsigned lanes,bytes;kernel gather[3],scatter[3];};
#define K(N,T,B) {#N "x" #T,N,B,{wide_g##N##_##T##_idx,wide_g##N##_##T##_ptr,wide_g##N##_##T##_unaligned},{wide_s##N##_##T##_idx,wide_s##N##_##T##_ptr,wide_s##N##_##T##_unaligned}},
static const struct testcase cases[]={
#include "masked-widths-cases.h"
};
#undef K
static uint32_t state=0x39182ab;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
static void payload(unsigned char *p,unsigned bytes,unsigned n,unsigned lane){
 static const uint64_t f64[]={0,UINT64_C(0x8000000000000000),UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),UINT64_C(0x7ff0000000000001),UINT64_C(0x7ff8000000000001),UINT64_C(0xffffffffffffffff),UINT64_C(1),UINT64_C(0x7fefffffffffffff)};
 static const uint32_t f32[]={0,0x80000000,0x7f800000,0xff800000,0x7f800001,0x7fc00001,0xffffffff,1,0x7f7fffff};
 if(n<18&&bytes==8){uint64_t v=f64[(n+lane)%9];memcpy(p,&v,8);}
 else if(n<18&&bytes==4){uint32_t v=f32[(n+lane)%9];memcpy(p,&v,4);}
 else for(unsigned i=0;i<bytes;i++)p[i]=(unsigned char)next();
}
static unsigned char *mapping(size_t page,size_t pages){
 unsigned char *p=mmap(0,page*pages,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 if(p==MAP_FAILED||mprotect(p+page,page*(pages-2),PROT_READ|PROT_WRITE)){perror("mapping");exit(1);}return p;
}
#define CHECK(X) do{if(!(X)){printf("FAIL masked widths case=%s mode=%u iteration=%u line=%d\n",c->name,mode,n,__LINE__);return 1;}}while(0)
static void indices(void *out,unsigned mode,unsigned count,unsigned bytes,uintptr_t base,const uintptr_t *p){
 for(unsigned i=0;i<count;i++){
  if(mode==0){int32_t x=((intptr_t)p[i]-(intptr_t)base)/bytes;memcpy((char*)out+4*i,&x,4);}
  else if(mode==1)memcpy((char*)out+8*i,p+i,8);
  else{int64_t x=(intptr_t)p[i]-(intptr_t)base;memcpy((char*)out+8*i,&x,8);}
 }
}
int main(void){
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *arena=mapping(page,18),*buffers[4];
 for(unsigned i=0;i<4;i++)buffers[i]=mapping(page,3);
 size_t span=(UINT64_C(1)<<34)+3*page;
 unsigned char *sparse=mmap(0,span,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 if(sparse==MAP_FAILED)return 1;
 unsigned char *low=sparse+page,*high=low+(UINT64_C(1)<<34);
 if(mprotect(low,page,PROT_READ|PROT_WRITE)||mprotect(high,page,PROT_READ|PROT_WRITE))return 1;
 unsigned char values[128],expected[256],initial[256];uintptr_t pointers[16];uint32_t masks[16];
 uint64_t checks=0;
 for(unsigned t=0;t<sizeof(cases)/sizeof(cases[0]);t++){
  const struct testcase *c=cases+t;unsigned count=c->lanes,bytes=c->bytes,n=0,mode=0,total=count*bytes;
  for(mode=0;mode<3;mode++){
   for(n=0;n<300;n++){
    unsigned bits=n==0?0:n==1?65535:n<18?1u<<(n-2):next()&65535;
    for(unsigned i=0;i<count;i++)payload(values+i*bytes,bytes,n,i);
    uintptr_t base=(uintptr_t)(n&2?arena:arena+17*page); /* Both are protected: padding must stay inactive. */
    for(unsigned i=0;i<count;i++){
     unsigned offset=n&1?page-bytes:0;if(mode==2)offset=n&1?page-bytes-1:1;
     unsigned char *p=arena+(i+1)*page+offset;
     payload(p,bytes,n+3,i);
     masks[i]=(bits>>i&1)?(i&1?0x80000000u:next()|1):0;
     pointers[i]=(uintptr_t)(masks[i]?p:n&1?arena:arena+17*page);
     memcpy(expected+i*bytes,masks[i]?p:values+i*bytes,bytes);
    }
    /* Input and output vectors sit flush against alternating protected edges. */
    unsigned char *in=buffers[0]+page+(n&1?page-total:0);
    unsigned indexbytes=count*(mode==0?4:8);
    unsigned char *ix=buffers[1]+page+(n&1?page-indexbytes:0);
    unsigned char *mask=buffers[2]+page+(n&1?page-count*4:0);
    unsigned char *out=buffers[3]+page+(n&1?page-total:0);
    memcpy(in,values,total);memcpy(mask,masks,count*4);indices(ix,mode,count,bytes,base,pointers);
    memset(buffers[3]+page,0xa7,page);
    c->gather[mode](out,(void*)base,ix,in,mask);CHECK(!memcmp(out,expected,total));
    if(n&1){for(unsigned i=1;i<=32;i++)CHECK(out[-(int)i]==0xa7);}
    else{for(unsigned i=0;i<32;i++)CHECK(out[total+i]==0xa7);}
    /* Every source is loaded before stores begin; inactive addresses are guards. */
    c->scatter[mode](0,(void*)base,ix,in,mask);
    for(unsigned i=0;i<count;i++)if(masks[i])CHECK(!memcmp((void*)pointers[i],values+i*bytes,bytes));
    checks++;
   }
   for(n=0;n<100;n++){
    unsigned char *data=buffers[3]+page+128;uintptr_t base=(uintptr_t)data;
    memset(data,0x9b,256);memcpy(expected,data,256);
    for(unsigned i=0;i<total;i++)values[i]=(unsigned char)next();
    for(unsigned i=0;i<count;i++){
     unsigned offset=mode==2?next()%32:(next()%8)*bytes;
     pointers[i]=(uintptr_t)(data+offset);masks[i]=next()&3;
     if(masks[i])memcpy(expected+offset,values+i*bytes,bytes);
    }
    indices(buffers[1]+page,mode,count,bytes,base,pointers);
    c->scatter[mode](0,(void*)base,buffers[1]+page,values,masks);
    CHECK(!memcmp(data,expected,256));checks++;
   }
  }
  /* Full-width pointers and signed byte offsets span sixteen GiB. */
  for(mode=1;mode<=2;mode++)for(n=0;n<20;n++){
   uintptr_t base=(uintptr_t)(n&1?high:low);
   for(unsigned i=0;i<count;i++){
    masks[i]=n==0?~0u:next()&1;
    pointers[i]=(uintptr_t)((i&1?low:high)+i*bytes);
    payload((unsigned char*)pointers[i],bytes,n,i);
    payload(values+i*bytes,bytes,n+7,i);
    memcpy(expected+i*bytes,masks[i]?(void*)pointers[i]:values+i*bytes,bytes);
   }
   indices(buffers[1]+page,mode,count,bytes,base,pointers);
   c->gather[mode](buffers[3]+page,(void*)base,buffers[1]+page,values,masks);
   CHECK(!memcmp(buffers[3]+page,expected,total));
   c->scatter[mode](0,(void*)base,buffers[1]+page,values,masks);
   for(unsigned i=0;i<count;i++)if(masks[i])CHECK(!memcmp((void*)pointers[i],values+i*bytes,bytes));
   checks++;
  }
  /* Scatter destinations alias and reverse the complete source vector. */
  mode=1;
  for(n=0;n<20;n++){
   unsigned char *data=buffers[0]+page;
   for(unsigned i=0;i<total;i++)data[i]=(unsigned char)next();
   memcpy(initial,data,total);memcpy(expected,data,total);
   for(unsigned i=0;i<count;i++){
    masks[i]=next()&1;pointers[i]=(uintptr_t)(masks[i]?data+(count-1-i)*bytes:arena);
    if(masks[i])memcpy(expected+(count-1-i)*bytes,initial+i*bytes,bytes);
   }
   c->scatter[1](0,0,pointers,data,masks);CHECK(!memcmp(data,expected,total));checks++;
  }
 }
 for(unsigned i=0;i<4;i++)munmap(buffers[i],page*3);munmap(arena,page*18);munmap(sparse,span);
 printf("PASS LLVM masked width/type matrix: 28 combinations (2/4/8/16 lanes; i8/i16/i32/i64/FP32/FP64/pointers), %llu cases across signed-index, arbitrary-pointer and unaligned modes; exact payload bits including FP special values, sparse 16-GiB addresses, protected input/output edges, inactive padded lanes, zero masks, ordered overlaps and source aliasing\n",(unsigned long long)checks);
 return 0;
}
