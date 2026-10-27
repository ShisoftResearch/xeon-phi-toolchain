#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sched.h>
#include <time.h>
typedef void(*kernel)(void*,const void*,const void*,const void*);
#define K(NAME,N,B,S,A,C,V,I,D,...) extern void NAME(void*,const void*,const void*,const void*),before_##NAME(void*,const void*,const void*,const void*);
#include "scatter-cases.h"
#undef K
struct entry{const char*name;unsigned lanes,bytes,scale,align,candidate,native,iw,dynamic;int64_t indices[16];kernel after,before;};
#define K(NAME,N,B,S,A,C,V,I,D,...) {#NAME,N,B,S,A,C,V,I,D,{__VA_ARGS__},NAME,before_##NAME},
static const struct entry cases[]={
#include "scatter-cases.h"
};
#undef K
static uint32_t state=0x139a8e6;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
static uint64_t ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
static uint64_t calls,checked;
static unsigned char *region(size_t bytes,int prot){unsigned char*p=mmap(0,bytes,prot,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(p==MAP_FAILED)abort();return p;}
static int exercise(const struct entry*c,unsigned mode,unsigned iter,size_t page,unsigned char*map,unsigned char*wide){
 unsigned char *low=map+page,*base=low+512;int iswide=strstr(c->name,"wide")!=0;
 if(mode==1)base=low;else if(mode==2)base=low+page-c->bytes;else if(mode==3)base=low-64;else if(mode==5)base=low+513;
 if(c->align>1)base=(unsigned char*)((uintptr_t)base&~(uintptr_t)(c->align-1));
 if(iswide)base=wide+(UINT64_C(1)<<34)+page;
 int64_t indices[16];unsigned char encoded[128]={0},values[128]={0},saved[128]={0};uint32_t masks[16];
 for(unsigned i=0;i<c->lanes;++i){indices[i]=c->dynamic?(int64_t)(iter&1?i%5:(i*7)%31)-7:c->indices[i];
  if(c->iw==32){int32_t x=indices[i];memcpy(encoded+i*4,&x,4);}else memcpy(encoded+i*8,indices+i,8);
  for(unsigned j=0;j<c->bytes;++j)values[i*c->bytes+j]=(unsigned char)next();
  unsigned char*p=base+indices[i]*c->scale;
  int valid=iswide||((uintptr_t)p>=(uintptr_t)low&&(uintptr_t)p+c->bytes<=(uintptr_t)low+page);
  unsigned on=iter<65536&&mode==0&&c==cases+36?(iter>>i)&1:iter==0?0:iter==1?1:iter<18?i==iter-2:next()&1;
  masks[i]=valid&&on?(next()|1):0;
 }
 memcpy(saved,values,sizeof values);
 unsigned char *pages[17];unsigned npages=1;pages[0]=iswide?base:low;
 if(iswide)for(unsigned i=0;i<c->lanes;++i){unsigned char*p=(unsigned char*)((uintptr_t)(base+indices[i]*c->scale)&~(uintptr_t)(page-1));unsigned j;for(j=0;j<npages;++j)if(pages[j]==p)break;if(j==npages){pages[npages++]=p;if(mprotect(p,page,PROT_READ|PROT_WRITE))abort();}}
 unsigned char *initial=malloc(npages*page),*expected=malloc(npages*page);if(!initial||!expected)abort();
 for(unsigned j=0;j<npages;++j)for(size_t i=0;i<page;++i)initial[j*page+i]=(unsigned char)(i*7+iter*3+j);
 int alias=mode==4&&!iswide;unsigned char*input=alias?base:values;
 if(alias)memcpy(saved,initial+(base-low),c->lanes*c->bytes);
 memcpy(expected,initial,npages*page);
 for(unsigned i=0;i<c->lanes;++i)if(masks[i]){
  unsigned char*p=base+indices[i]*c->scale;unsigned j;for(j=0;j<npages;++j)if((uintptr_t)p>=(uintptr_t)pages[j]&&(uintptr_t)p+c->bytes<=(uintptr_t)pages[j]+page)break;
  if(j==npages)abort();memcpy(expected+j*page+(p-pages[j]),saved+i*c->bytes,c->bytes);
 }
 for(unsigned path=0;path<2;++path){
  for(unsigned j=0;j<npages;++j)memcpy(pages[j],initial+j*page,page);
  (path?c->before:c->after)(base,input,masks,encoded);++calls;
  for(unsigned j=0;j<npages;++j){checked+=page;if(memcmp(pages[j],expected+j*page,page)){printf("FAIL scatter kernel=%s mode=%u iter=%u path=%u page=%u\n",c->name,mode,iter,path,j);return 1;}}
  if(!alias&&memcmp(values,saved,sizeof values)){printf("FAIL input changed %s\n",c->name);return 1;}
 }
 free(initial);free(expected);return 0;
}
int main(void){
 cpu_set_t cpus;CPU_ZERO(&cpus);CPU_SET(1,&cpus);if(sched_setaffinity(0,sizeof cpus,&cpus))return 1;
 size_t page=sysconf(_SC_PAGESIZE);unsigned char*map=region(page*3,PROT_NONE);if(mprotect(map+page,page,PROT_READ|PROT_WRITE))return 1;
 size_t span=(UINT64_C(1)<<35)+page*3;unsigned char*wide=region(span,PROT_NONE);if(mprotect(wide+(UINT64_C(1)<<34)+page,page,PROT_READ|PROT_WRITE))return 1;
 for(unsigned k=0;k<sizeof cases/sizeof cases[0];++k){const struct entry*c=cases+k;
  for(unsigned mode=0;mode<6;++mode){unsigned count=k==36&&mode==0?65536:128;for(unsigned iter=0;iter<count;++iter)if(exercise(c,mode,iter,page,map,wide))return 1;}
  /* All inactive lanes permit a null base, including signed/large offsets. */
  uint32_t masks[16]={0};unsigned char values[128]={0},ix[128]={0};c->after(0,values,masks,ix);c->before(0,values,masks,ix);calls+=2;
 }
 unsigned char data[4096] __attribute__((aligned(64))),values[128] __attribute__((aligned(64)));uint32_t masks[16];memset(data,0,sizeof data);for(unsigned i=0;i<128;++i)values[i]=(unsigned char)(i*7);
 for(unsigned k=0;k<sizeof cases/sizeof cases[0];++k){const struct entry*c=cases+k;if(!c->candidate)continue;
  unsigned levels[]={1,c->lanes/2,c->lanes};
  for(unsigned density=0;density<3;++density){unsigned active=levels[density];if(density&&active==levels[density-1])continue;
   for(unsigned i=0;i<16;++i)masks[i]=i<active?0x80000000u:0;
   for(unsigned round=0;round<5;++round)for(unsigned order=0;order<2;++order){unsigned path=(round+order)&1;kernel fn=path?c->before:c->after;
    fn(data+1024,values,masks,0);uint64_t start=ns();for(unsigned i=0;i<4096;++i)fn(data+1024,values,masks,0);uint64_t elapsed=ns()-start;
    printf("TIMING scatter kernel=%s active=%u round=%u path=%s iterations=4096 ns=%llu\n",c->name,active,round,path?"before":"after",(unsigned long long)elapsed);
   }
  }
 }
 munmap(map,page*3);munmap(wide,span);
 printf("PASS disjoint scatter: %u kernels, %llu calls, %llu exact bytes; all 65536 masks, protected inactive lanes, negative and large signed offsets, padding, duplicate/partial conflicts, source alias, unaligned and zero-mask null bases\n",(unsigned)(sizeof cases/sizeof cases[0]),(unsigned long long)calls,(unsigned long long)checked);return 0;
}
