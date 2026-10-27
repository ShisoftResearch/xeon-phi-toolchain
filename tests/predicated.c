#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
extern void auto_predicated(uint32_t*,const uint32_t*,const uint32_t*,const uint32_t*,size_t);
static uint32_t state=0x65832b;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
int main(void){
 uint32_t a[1200],b[1200],mask[1200],out[1200],expected[1200];uint64_t cases=0;
 for(unsigned offset=0;offset<16;offset++)for(size_t n=0;n<=257;n++){
  for(unsigned i=0;i<1200;i++){a[i]=next();b[i]=next();mask[i]=(next()&3)?next()|1:0;out[i]=expected[i]=next();}
  for(size_t i=0;i<n;i++)if(mask[i+offset])expected[i+offset]=a[i+offset]*3u+b[i+offset];
  auto_predicated(out+offset,a+offset,b+offset,mask+offset,n);
  if(memcmp(out,expected,sizeof(out))){printf("FAIL predicated n=%lu offset=%u\n",(unsigned long)n,offset);return 1;}cases++;
 }
 for(size_t n=511;n<=1025;n++){
  for(unsigned i=0;i<1200;i++){mask[i]=next()&1;out[i]=expected[i]=next();}
  for(size_t i=0;i<n;i++)if(mask[i])expected[i]=a[i]*3u+b[i];
  auto_predicated(out,a,b,mask,n);if(memcmp(out,expected,sizeof(out)))return 1;cases++;
 }
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *maps[4],*ep=malloc(page);if(!ep)return 1;
 for(unsigned i=0;i<4;i++){maps[i]=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(maps[i]==MAP_FAILED||mprotect(maps[i]+page,page,PROT_READ|PROT_WRITE))return 1;}
 for(size_t n=1;n<=257;n++)for(unsigned side=0;side<2;side++){
  unsigned active=n/2;unsigned char *p[3];
  for(unsigned j=0;j<3;j++){memset(maps[j]+page,0xa7,page);p[j]=side?maps[j]+2*page-active*4:maps[j]+page-active*4;}
  uint32_t *m=(uint32_t*)(maps[3]+2*page-n*4);memcpy(ep,maps[0]+page,page);
  for(size_t i=0;i<n;i++){
   int valid=p[0]+i*4>=maps[0]+page&&p[0]+i*4+4<=maps[0]+2*page;m[i]=valid?(next()|1):0;
   if(valid){uint32_t x=next(),y=next(),z=x*3u+y;memcpy(p[1]+i*4,&x,4);memcpy(p[2]+i*4,&y,4);memcpy(ep+(p[0]+i*4-(maps[0]+page)),&z,4);}
  }
  auto_predicated((uint32_t*)p[0],(uint32_t*)p[1],(uint32_t*)p[2],m,n);
  if(memcmp(maps[0]+page,ep,page)){printf("FAIL predicated guarded n=%lu side=%u\n",(unsigned long)n,side);return 1;}cases++;
 }
 memset(mask,0,sizeof(mask));auto_predicated(0,0,0,mask,257);auto_predicated(0,0,0,0,0);
 for(unsigned i=0;i<4;i++)munmap(maps[i],page*3);free(ep);
 printf("PASS ordinary C predicated auto-vectorization: %llu length/offset/guard cases; exact wrapping affine results, false-lane preservation, protected source/destination prefixes/suffixes, zero masks and zero-length null pointers\n",(unsigned long long)cases);return 0;
}
