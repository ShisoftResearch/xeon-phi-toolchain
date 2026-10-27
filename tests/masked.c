#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdlib.h>

typedef void (*kernel)(void*,const void*,const void*,const void*,const void*);
#define DECL(N) extern void gather_##N(void*,const void*,const void*,const void*,const void*); extern void scatter_##N(void*,const void*,const void*,const void*,const void*);
DECL(i32) DECL(f32) DECL(i64) DECL(ptrs) DECL(unaligned) DECL(u32)
extern void masked_outer_loop(const void*,const void*,unsigned);
static uint32_t rng=0x2198ab7;
static uint32_t next(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
#define CHECK(X) do{if(!(X)){printf("FAIL masked line=%d case=%u lane=%u\n",__LINE__,n,k);return 1;}}while(0)
static int ordinary(void){
 unsigned n=0,k=0;size_t page=sysconf(_SC_PAGESIZE);
 unsigned char *map=mmap(0,page*18,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 CHECK(map!=MAP_FAILED);CHECK(!mprotect(map,page,PROT_NONE));CHECK(!mprotect(map+17*page,page,PROT_NONE));
 unsigned char *base=map+8*page;
 uint32_t values[16],mask[16],out[16],expected[16],indices[16];int64_t wide[16];uintptr_t pointers[16];
 for(n=0;n<1000;n++){
  unsigned bits=n==0?0:n==1?65535:n<18?1u<<(n-2):next()&65535;
  for(k=0;k<16;k++){
   values[k]=next();mask[k]=(bits>>k&1)?(k&1?0x80000000:next()|1):0;
   unsigned char *address=map+(k+1)*page+((n&1)?page-4:0);
   uint32_t value=next();memcpy(address,&value,4);
   if(!(bits>>k&1))address=(k&1)?map:map+17*page;
   /* Signed division must precede narrowing for negative element offsets. */
   indices[k]=(uint32_t)(((intptr_t)address-(intptr_t)base)/4);
   wide[k]=((intptr_t)address-(intptr_t)base)/4;pointers[k]=(uintptr_t)address;
   expected[k]=(bits>>k&1)?value:values[k];
  }
  kernel gathers[]={gather_i32,gather_f32,gather_i64,gather_ptrs};
  for(unsigned mode=0;mode<4;mode++){
   gathers[mode](out,base,mode==2?(void*)wide:mode==3?(void*)pointers:(void*)indices,values,mask);
   for(k=0;k<16;k++)CHECK(out[k]==expected[k]);
  }
  kernel scatters[]={scatter_i32,scatter_f32,scatter_i64,scatter_ptrs};
  for(unsigned mode=0;mode<4;mode++){
   for(k=0;k<16;k++)if(bits>>k&1){uint32_t zero=0;memcpy((void*)pointers[k],&zero,4);}
   scatters[mode](0,base,mode==2?(void*)wide:mode==3?(void*)pointers:(void*)indices,values,mask);
   for(k=0;k<16;k++)if(bits>>k&1){uint32_t got;memcpy(&got,(void*)pointers[k],4);CHECK(got==values[k]);}
  }
 }
 /* Duplicate and partially overlapping scatter stores must follow lane order. */
 for(n=0;n<1000;n++){
  unsigned char data[160],expected_bytes[160];memset(data,0xa7,sizeof(data));memcpy(expected_bytes,data,sizeof(data));
  for(k=0;k<16;k++){
   values[k]=next();mask[k]=(next()&3)?next()|1:0;wide[k]=n&1?(int64_t)(next()%48):(int64_t)(next()%8)*4;
   pointers[k]=(uintptr_t)(data+wide[k]);indices[k]=(uint32_t)(wide[k]/4);
   if(mask[k])memcpy(expected_bytes+wide[k],&values[k],4);
  }
  scatter_unaligned(0,data,wide,values,mask);CHECK(!memcmp(data,expected_bytes,sizeof(data)));
  memset(data,0xa7,sizeof(data));scatter_ptrs(0,0,pointers,values,mask);CHECK(!memcmp(data,expected_bytes,sizeof(data)));
  for(k=0;k<16;k++){memcpy(expected+k,data+wide[k],4);if(!mask[k])expected[k]=values[k];}
  gather_unaligned(out,data,wide,values,mask);for(k=0;k<16;k++)CHECK(out[k]==expected[k]);
  if(!(n&1)){
   memset(data,0xa7,sizeof(data));scatter_i32(0,data,indices,values,mask);CHECK(!memcmp(data,expected_bytes,sizeof(data)));
   memset(data,0xa7,sizeof(data));scatter_f32(0,data,indices,values,mask);CHECK(!memcmp(data,expected_bytes,sizeof(data)));
  }
 }
 /* The complete source vector is read before any scatter store, even when
    destinations alias the source buffer. Gather also permits in-place output. */
 for(n=0;n<100;n++){
  for(k=0;k<16;k++){values[k]=next();mask[k]=~0u;pointers[k]=(uintptr_t)(values+15-k);indices[k]=15-k;expected[15-k]=values[k];}
  scatter_ptrs(0,0,pointers,values,mask);for(k=0;k<16;k++)CHECK(values[k]==expected[k]);
  for(k=0;k<16;k++)expected[k]=values[15-k];
  gather_i32(values,values,indices,values,mask);for(k=0;k<16;k++)CHECK(values[k]==expected[k]);
 }
 /* Access-loop expansion must preserve the outer loop's PHIs and memory chain. */
 for(n=0;n<100;n++){
  for(k=0;k<16;k++){values[k]=next();expected[k]=values[k];mask[k]=next()&1;pointers[k]=mask[k]?(uintptr_t)(values+k):(uintptr_t)map;}
  masked_outer_loop(pointers,mask,n%19);
  for(k=0;k<16;k++)CHECK(values[k]==expected[k]+(mask[k]?n%19:0));
 }
 /* No active lanes: arbitrary invalid pointers must not be dereferenced. */
 memset(mask,0,sizeof(mask));memset(indices,0,sizeof(indices));memset(wide,0,sizeof(wide));
 for(k=0;k<16;k++)pointers[k]=(uintptr_t)1;
 kernel gathers[]={gather_i32,gather_f32,gather_i64,gather_ptrs,gather_unaligned,gather_u32};
 kernel scatters[]={scatter_i32,scatter_f32,scatter_i64,scatter_ptrs,scatter_unaligned,scatter_u32};
 for(n=0;n<6;n++){
  void *index=n==2||n==4?(void*)wide:n==3?(void*)pointers:(void*)indices;
  gathers[n](out,0,index,values,mask);for(k=0;k<16;k++)CHECK(out[k]==values[k]);
  scatters[n](0,0,index,values,mask);
 }
 munmap(map,page*18);return 0;
}
static int full_width_addresses(void){
 unsigned n=0,k=0;size_t page=sysconf(_SC_PAGESIZE),span=(UINT64_C(1)<<34)+3*page;
 unsigned char *map=mmap(0,span,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);CHECK(map!=MAP_FAILED);
 unsigned char *low=map+page,*mid=low+(UINT64_C(1)<<33),*high=low+(UINT64_C(1)<<34);
 CHECK(!mprotect(low,page,PROT_READ|PROT_WRITE));CHECK(!mprotect(mid,page,PROT_READ|PROT_WRITE));CHECK(!mprotect(high,page,PROT_READ|PROT_WRITE));
 uint32_t values[16],expected[16],mask[16],out[16],index32[16];int64_t index64[16];uintptr_t pointers[16];
 for(n=0;n<100;n++){
  for(k=0;k<16;k++){
   values[k]=next();mask[k]=(n>>k%7&1)?0xffffffff:0;index32[k]=0x80000000u+k;index64[k]=(INT64_C(1)<<32)+k;
   expected[k]=next();memcpy(mid+k*4,expected+k,4);memcpy(high+k*4,expected+k,4);pointers[k]=(uintptr_t)(k&1?low+k*4:high+k*4);memcpy((void*)pointers[k],expected+k,4);
  }
  gather_u32(out,low,index32,values,mask);for(k=0;k<16;k++)CHECK(out[k]==(mask[k]?expected[k]:values[k]));
  gather_i64(out,low,index64,values,mask);for(k=0;k<16;k++)CHECK(out[k]==(mask[k]?expected[k]:values[k]));
  gather_ptrs(out,0,pointers,values,mask);for(k=0;k<16;k++)CHECK(out[k]==(mask[k]?expected[k]:values[k]));
  for(k=0;k<16;k++)values[k]=next();
  scatter_u32(0,low,index32,values,mask);for(k=0;k<16;k++)if(mask[k]){uint32_t got;memcpy(&got,mid+4*k,4);CHECK(got==values[k]);}
  scatter_i64(0,low,index64,values,mask);for(k=0;k<16;k++)if(mask[k]){uint32_t got;memcpy(&got,high+4*k,4);CHECK(got==values[k]);}
  for(k=0;k<16;k++)index64[k]=-(INT64_C(1)<<32)+k;
  scatter_i64(0,high,index64,values,mask);gather_i64(out,high,index64,values,mask);for(k=0;k<16;k++)CHECK(out[k]==values[k]);
 }
 munmap(map,span);return 0;
}
int main(void){
 if(ordinary()||full_width_addresses())return 1;
 puts("PASS generic LLVM masked gather/scatter: i32/FP32 native gather; ordered scatter and 64-bit pointer fallback; 1000 randomized page/mask cases, 1000 overlapping-store cases, 100 sparse 16-GiB address cases, inactive invalid pointers, zero masks and nested caller loops");return 0;
}
