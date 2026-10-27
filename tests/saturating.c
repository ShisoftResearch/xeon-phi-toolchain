#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#define DECL(S,W) extern void sat_##S##W(void*,const void*);
DECL(s,8) DECL(u,8) DECL(s,16) DECL(u,16) DECL(s,32) DECL(u,32)
extern void auto_sat_s32(void*,const void*,uint64_t),auto_sat_u32(void*,const void*,uint64_t);
typedef void (*kernel)(void*,const void*);
static uint32_t state=0x38691b;
static uint32_t next(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
/* Independent integer-only IEEE decoder: recover the truncated magnitude,
   then clamp to the destination range. No host/card floating casts involved. */
static uint32_t reference(uint32_t bits,unsigned width,int sign){
 unsigned e=(bits>>23)&255;uint32_t m=bits&0x7fffff;int negative=bits>>31;
 if(e==255&&m)return 0;
 uint32_t max=sign?(UINT32_C(1)<<(width-1))-1:UINT32_MAX>>(32-width);
 uint32_t min=sign?(UINT32_C(1)<<(width-1)):0;
 if(negative&&!sign)return 0;
 int power=(int)e-127;
 if(power<0)return 0;
 if(power>32)return negative?(uint32_t)(0-min):max;
 uint64_t value=UINT64_C(0x800000)|m;
 if(power>=23)value<<=power-23;else value>>=23-power;
 if(negative){if(value>min)value=min;return (uint32_t)(0-value);}
 return value>max?max:(uint32_t)value;
}
static uint32_t input(unsigned n,unsigned k){
 static const uint32_t edges[]={0,0x80000000,1,0x80000001,0x007fffff,0x807fffff,0x3f000000,0xbf000000,0x3f800000,0xbf800000,0x42fe0000,0xc3000000,0x437f0000,0x47000000,0xc7000000,0x47800000,0x4f000000,0xcf000000,0x4f800000,0xcf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7f800001,0xff800001,0x7fc00001,0xffc00001};
 if(n<sizeof(edges)/sizeof(edges[0]))return edges[(n+k)% (sizeof(edges)/sizeof(edges[0]))];
 if(n<4096){uint32_t center=edges[8+(n/256)%12];return center+(int32_t)((n*16+k)%513)-256;}
 return next();
}
#define CHECK(C) do{if(!(C)){printf("FAIL saturating line=%d batch=%u lane=%u mode=%u\n",__LINE__,n,k,mode);return 1;}}while(0)
int main(void){
 kernel functions[]={sat_s8,sat_u8,sat_s16,sat_u16,sat_s32,sat_u32};
 unsigned n=0,k=0,mode=0;uint32_t in[32];unsigned char out[256];uint64_t checks=0;
 for(n=0;n<10000;n++){
  for(k=0;k<16;k++)in[k]=input(n,k);
  for(mode=0;mode<6;mode++){
   unsigned bytes=1u<<(mode/2),width=bytes*8,offset=64+(n%16)*bytes;
   memset(out,0xa7,sizeof(out));functions[mode](out+offset,in);
   for(k=0;k<16;k++){
    uint32_t got=0;memcpy(&got,out+offset+k*bytes,bytes);
    uint32_t expected=reference(in[k],width,!(mode&1))&(UINT32_MAX>>(32-width));
    if(got!=expected){printf("FAIL input=%08x got=%08x expected=%08x\n",in[k],got,expected);return 1;}checks++;
   }
   for(k=0;k<sizeof(out);k++)if(k<offset||k>=offset+bytes*16)CHECK(out[k]==0xa7);
  }
 }
 uint32_t ai[320],ao[320];
 for(k=0;k<320;k++)ai[k]=next();
 for(n=0;n<=257;n++)for(mode=0;mode<2;mode++){
  unsigned offset=n%16;for(k=0;k<320;k++)ao[k]=0x87654321;
  if(mode)auto_sat_u32(ao+offset,ai+offset,n);else auto_sat_s32(ao+offset,ai+offset,n);
  for(k=0;k<320;k++)CHECK(ao[k]==(k>=offset&&k<offset+n?reference(ai[k],32,!mode):0x87654321));
 }
 auto_sat_s32(0,0,0);auto_sat_u32(0,0,0);
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *map=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 CHECK(map!=MAP_FAILED);CHECK(!mprotect(map+page,page,PROT_READ|PROT_WRITE));
 for(mode=0;mode<6;mode++){
  unsigned bytes=1u<<(mode/2),width=bytes*8;
  for(n=0;n<2;n++){
   unsigned char *p=map+page+(n?page-bytes*16:0);functions[mode](p,in);
   for(k=0;k<16;k++){uint32_t got=0;memcpy(&got,p+k*bytes,bytes);CHECK(got==(reference(in[k],width,!(mode&1))&(UINT32_MAX>>(32-width))));}
  }
 }
 munmap(map,page*3);printf("PASS native LLVM saturating FP32 casts: %llu exact i8/u8/i16/u16/i32/u32 results, NaNs/infinities/zeros, signed boundaries, random bit patterns, alignments, sentinels, guard pages and auto-vectorized loops across 258 lengths\n",(unsigned long long)checks);return 0;
}
