#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#define D(S,W) extern void sat64_##S##W(void*,const void*);
D(s,8) D(u,8) D(s,16) D(u,16) D(s,32) D(u,32) D(s,64) D(u,64)
typedef void(*kernel)(void*,const void*);
static uint64_t state=UINT64_C(0x2891a762fed);
static uint64_t next(void){state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static uint64_t reference(uint64_t bits,unsigned width,int sign){
 unsigned e=(unsigned)(bits>>52)&2047;uint64_t m=bits&UINT64_C(0xfffffffffffff);int negative=bits>>63;
 if(e==2047&&m)return 0;uint64_t max=sign?(UINT64_C(1)<<(width-1))-1:UINT64_MAX>>(64-width),min=sign?UINT64_C(1)<<(width-1):0;
 if(negative&&!sign)return 0;int power=(int)e-1023;if(power<0)return 0;if(power>64)return negative?0-min:max;
 __uint128_t value=UINT64_C(0x10000000000000)|m;if(power>=52)value<<=power-52;else value>>=52-power;
 if(negative){if(value>min)value=min;return 0-(uint64_t)value;}return value>max?max:(uint64_t)value;
}
static uint64_t input(unsigned n,unsigned k){
 static const uint64_t edges[]={0,0x8000000000000000ULL,1,0x8000000000000001ULL,0xfffffffffffffULL,0x800fffffffffffffULL,0x3ff0000000000000ULL,0xbff0000000000000ULL,0x4060000000000000ULL,0xc060000000000000ULL,0x4070000000000000ULL,0x40e0000000000000ULL,0xc0e0000000000000ULL,0x40f0000000000000ULL,0x41e0000000000000ULL,0xc1e0000000000000ULL,0x41f0000000000000ULL,0x43e0000000000000ULL,0xc3e0000000000000ULL,0x43f0000000000000ULL,0x7ff0000000000000ULL,0xfff0000000000000ULL,0x7ff0000000000001ULL,0xfff0000000000001ULL,0x7ff8000000000001ULL,0x7fefffffffffffffULL,UINT64_MAX};
 if(n<27)return edges[(n+k)%27];if(n<4096)return edges[6+(n/256)%14]+(int64_t)((n*8+k)%513)-256;return next();
}
int main(void){kernel f[]={sat64_s8,sat64_u8,sat64_s16,sat64_u16,sat64_s32,sat64_u32,sat64_s64,sat64_u64};uint64_t in[8],checks=0;unsigned char out[256];
 for(unsigned n=0;n<10000;n++){
  for(unsigned k=0;k<8;k++)in[k]=input(n,k);
  for(unsigned mode=0;mode<8;mode++){
   unsigned bytes=1u<<(mode/2),width=bytes*8,offset=64+(n%8)*bytes;memset(out,0xa7,sizeof(out));f[mode](out+offset,in);
   for(unsigned k=0;k<8;k++){
    uint64_t got=0;memcpy(&got,out+offset+k*bytes,bytes);uint64_t expected=reference(in[k],width,!(mode&1))&(UINT64_MAX>>(64-width));
    if(got!=expected){printf("FAIL FP64 saturation batch=%u lane=%u width=%u unsigned=%u input=%016llx got=%016llx expected=%016llx\n",n,k,width,mode&1,(unsigned long long)in[k],(unsigned long long)got,(unsigned long long)expected);return 1;}checks++;
   }
   for(unsigned k=0;k<sizeof(out);k++)if((k<offset||k>=offset+bytes*8)&&out[k]!=0xa7){puts("FAIL FP64 saturation sentinel");return 1;}
  }
 }
 size_t page=sysconf(_SC_PAGESIZE);unsigned char *p=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(p==MAP_FAILED||mprotect(p+page,page,PROT_READ|PROT_WRITE))return 1;
 for(unsigned mode=0;mode<8;mode++)for(unsigned end=0;end<2;end++){
  unsigned bytes=1u<<(mode/2);unsigned char *o=p+page+(end?page-bytes*8:0);f[mode](o,in);
  for(unsigned k=0;k<8;k++){uint64_t got=0;memcpy(&got,o+k*bytes,bytes);if(got!=(reference(in[k],bytes*8,!(mode&1))&(UINT64_MAX>>(64-bytes*8))))return 1;}
 }
 munmap(p,page*3);printf("PASS FP64 integer-decoded SIMD saturation: %llu exact signed/unsigned i8/i16/i32/i64 results, NaNs/infinities/signed zero/subnormals, boundary ULPs, random bits, alignments, sentinels and guard pages; no FP rounding dependence\n",(unsigned long long)checks);return 0;
}
