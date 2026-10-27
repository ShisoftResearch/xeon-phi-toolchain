#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#define DECL(p) \
extern float p##load32(const void *);extern double p##load64(const void *); \
extern void p##splat32(const void *,void *);extern void p##splat64(const void *,void *); \
extern float p##alias32(float *,float);extern double p##alias64(double *,double); \
extern float p##multi32(float *,float *,float);extern double p##multi64(double *,double *,double);
#define DECL_ALIGNED(p) \
extern float p##aligned32(const void *);extern double p##aligned64(const void *); \
extern void p##aligned_splat32(const void *,void *);extern void p##aligned_splat64(const void *,void *);
DECL_ALIGNED(native_)
DECL_ALIGNED(control_)
#define DECL_TLS(p) \
extern void p##tls_set(uint32_t,uint64_t);extern float p##tls32(void);extern double p##tls64(void);
DECL_TLS(native_)
DECL_TLS(control_)
DECL(native_)
DECL(control_)
static size_t checks;
static uint32_t bits32(float x) { uint32_t u;memcpy(&u,&x,4);return u; }
static uint64_t bits64(double x) { uint64_t u;memcpy(&u,&x,8);return u; }
static int check(uint64_t a,uint64_t b) { ++checks;if(a==b)return 0;printf("FAIL got=%016llx expected=%016llx\n",(unsigned long long)a,(unsigned long long)b);return 1; }
int main(void) {
 const size_t page=sysconf(_SC_PAGESIZE);
 char *map=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(map==MAP_FAILED)return 2;
 char *base=map+page;if(mprotect(base,page,PROT_READ|PROT_WRITE))return 2;
 uint32_t random=0x79ab2183;
 const uint64_t special[]={0,0x80000000,0x7f800000,0xff800000,0x7fc12345,0x7fa12345,1,0x80000001,0x7ff0000000000000ULL,0xfff0000000000000ULL,0x7ff8123456789abcULL,0x7ff0123456789abcULL,0x8000000000000000ULL,1};
 for(int trial=0;trial<8192;trial++) {
  random^=random<<13;random^=random>>17;random^=random<<5;uint64_t value=(uint64_t)random<<32;
  random^=random<<13;random^=random>>17;random^=random<<5;value|=random;
  if(trial<(int)(sizeof(special)/sizeof(special[0])))value=special[trial];
  for(int off=0;off<17;off++)for(int end=0;end<2;end++)for(int width=4;width<=8;width+=4) {
   char *p=end?base+page-width-off:base+off;memcpy(p,&value,width);
#ifdef LOAD_TRACE
   if(trial==0) { printf("TRACE trial=%d offset=%d end=%d width=%d\n",trial,off,end,width);fflush(stdout); }
#endif
   union { uint64_t u64[10];uint32_t u32[20]; } a,b;
   memset(&a,0xa5,sizeof(a));memset(&b,0xa5,sizeof(b));
   if(width==4) {
    if(check(bits32(native_load32(p)),(uint32_t)value)||check(bits32(control_load32(p)),(uint32_t)value))return 1;
    native_splat32(p,a.u32+2);control_splat32(p,b.u32+2);
    for(int lane=0;lane<16;lane++)if(check(a.u32[lane+2],(uint32_t)value)||check(b.u32[lane+2],(uint32_t)value))return 1;
    if(!((uintptr_t)p&3)) {
     if(check(bits32(native_aligned32(p)),(uint32_t)value)||check(bits32(control_aligned32(p)),(uint32_t)value))return 1;
     native_aligned_splat32(p,a.u32+2);control_aligned_splat32(p,b.u32+2);
     for(int lane=0;lane<16;lane++)if(check(a.u32[lane+2],(uint32_t)value)||check(b.u32[lane+2],(uint32_t)value))return 1;
    }
   } else {
    if(check(bits64(native_load64(p)),value)||check(bits64(control_load64(p)),value))return 1;
    native_splat64(p,a.u64+1);control_splat64(p,b.u64+1);
    for(int lane=0;lane<8;lane++)if(check(a.u64[lane+1],value)||check(b.u64[lane+1],value))return 1;
    if(!((uintptr_t)p&7)) {
     if(check(bits64(native_aligned64(p)),value)||check(bits64(control_aligned64(p)),value))return 1;
     native_aligned_splat64(p,a.u64+1);control_aligned_splat64(p,b.u64+1);
     for(int lane=0;lane<8;lane++)if(check(a.u64[lane+1],value)||check(b.u64[lane+1],value))return 1;
    }
   }
   if(check(a.u64[0],0xa5a5a5a5a5a5a5a5ULL)||check(a.u64[9],0xa5a5a5a5a5a5a5a5ULL)||check(b.u64[0],0xa5a5a5a5a5a5a5a5ULL)||check(b.u64[9],0xa5a5a5a5a5a5a5a5ULL))return 1;
  }
  native_tls_set((uint32_t)value,value);control_tls_set((uint32_t)value,value);
  if(check(bits32(native_tls32()),(uint32_t)value)||check(bits32(control_tls32()),(uint32_t)value)||check(bits64(native_tls64()),value)||check(bits64(control_tls64()),value))return 1;
  float f=(trial%4096-2048)*0.125f,fa=f,fb=f,oa=0,ob=0;
  double d=(trial%4096-2048)*0.125,da=d,db=d,pa=0,pb=0;
  if(check(bits32(native_alias32(&fa,1.5f)),bits32(control_alias32(&fb,1.5f)))||check(bits32(fa),bits32(fb))||check(bits64(native_alias64(&da,1.5)),bits64(control_alias64(&db,1.5)))||check(bits64(da),bits64(db)))return 1;
  fa=f;fb=f;da=d;db=d;
  if(check(bits32(native_multi32(&fa,&oa,1.5f)),bits32(control_multi32(&fb,&ob,1.5f)))||check(bits32(oa),bits32(f))||check(bits32(ob),bits32(f))||check(bits64(native_multi64(&da,&pa,1.5)),bits64(control_multi64(&db,&pb,1.5)))||check(bits64(pa),bits64(d))||check(bits64(pb),bits64(d)))return 1;
 }
 munmap(map,page*3);
 printf("PASS scalar-load broadcasts: %zu exact checks; 4/8-byte guarded edges, offsets 0..16, raw NaN/Inf/subnormal bits, alias/store ordering, flat TLS and multiple users\n",checks);
 return 0;
}
