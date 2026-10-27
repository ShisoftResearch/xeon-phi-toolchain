#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
typedef void(*kernel)(void*,const void*,const void*,const void*);
#define C(N,W) extern void contig_extend_s##N##_##W(void*,const void*,const void*,const void*);extern void contig_extend_u##N##_##W(void*,const void*,const void*,const void*);extern void contig_truncate_##W##_##N(void*,const void*,const void*,const void*);
C(8,32) C(8,64) C(16,32) C(16,64) C(32,64)
#define ROW(N,W) {N,W,{contig_extend_s##N##_##W,contig_extend_u##N##_##W},contig_truncate_##W##_##N}
static const struct {unsigned narrow,wide;kernel load[2],store;} cases[]={ROW(8,32),ROW(8,64),ROW(16,32),ROW(16,64),ROW(32,64)};
static uint32_t state=0x28139b;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
#define CHECK(X) do{if(!(X)){printf("FAIL masked conversion case=%u iteration=%u signed=%u lane=%u line=%d\n",t,n,sign,k,__LINE__);return 1;}}while(0)
int check_contiguous_conversions(void){
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[3];
 for(unsigned i=0;i<3;i++){maps[i]=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(maps[i]==MAP_FAILED||mprotect(maps[i]+page,page,PROT_READ|PROT_WRITE))return 1;}
 unsigned char *expected=malloc(page);if(!expected)return 1;unsigned char values[128];uint32_t mask[16];unsigned t=0,n=0,sign=0,k=0;unsigned checks=0;
 for(t=0;t<5;t++)for(n=0;n<200;n++){
  unsigned narrow=cases[t].narrow,wide=cases[t].wide,nb=narrow/8,wb=wide/8,active=n%17;
  unsigned char *base=n&1?maps[0]+2*page-active*nb:maps[0]+page-active*nb;
  memset(maps[0]+page,0xa7,page);
  for(k=0;k<16;k++){
   unsigned char *p=base+k*nb;int valid=p>=maps[0]+page&&p+nb<=maps[0]+2*page;mask[k]=valid?(next()&1):0;
   for(unsigned b=0;b<nb;b++){values[k*nb+b]=(unsigned char)next();if(valid)p[b]=(unsigned char)next();}
  }
  for(sign=0;sign<2;sign++){
   unsigned char *out=maps[1]+2*page-16*wb;cases[t].load[sign](out,base,values,mask);
   for(k=0;k<16;k++){
    uint64_t value=0,got=0;memcpy(&value,mask[k]?base+k*nb:values+k*nb,nb);memcpy(&got,out+k*wb,wb);
    if(!sign&&(value&(UINT64_C(1)<<(narrow-1))))value|=UINT64_MAX<<narrow;
    if(wide==32)value&=UINT32_MAX;CHECK(got==value);checks++;
   }
  }
  unsigned char *in=maps[2]+2*page-16*wb;for(k=0;k<16*wb;k++)in[k]=(unsigned char)next();
  memcpy(expected,maps[0]+page,page);
  for(k=0;k<16;k++)if(mask[k])memcpy(expected+(base+k*nb-(maps[0]+page)),in+k*wb,nb);
  cases[t].store(0,base,in,mask);CHECK(!memcmp(maps[0]+page,expected,page));
 }
 for(unsigned i=0;i<3;i++)munmap(maps[i],page*3);free(expected);printf("PASS contiguous masked integer compositions: %u exact sign/zero-extension results and 1000 truncating-store cases at protected boundaries\n",checks);return 0;
}
