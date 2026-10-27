#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
extern void vector_add_i32(void*,const void*,const void*),vector_mul_i32(void*,const void*,const void*);
extern void vector_add_f32(void*,const void*,const void*),vector_mul_f32(void*,const void*,const void*);
extern void vector_add_f64(void*,const void*,const void*),vector_mul_f64(void*,const void*,const void*);
extern void vector_call(void*,const void*);
extern void vector_mask(void*,const void*,const void*,const void*,uint32_t),vector_unaligned(void*,const void*),vector_spills(void*,const void*);
/* Every vector register is caller-clobbered by the native K1OM ABI. */
void clobber_vectors(void) { __asm__ volatile("vpxord %%zmm0,%%zmm0,%%zmm0" ::: "zmm0"); }
static uint32_t rng=123456789;
static uint32_t next(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
#define CHECK(c) do{if(!(c)){printf("FAIL vector line %d iteration %d lane %d\n",__LINE__,n,k);return 1;}}while(0)
int main(void){
 int n=0,k=0;
 uint32_t a[16] __attribute__((aligned(64))),b[16] __attribute__((aligned(64))),o[16] __attribute__((aligned(64))),m[16] __attribute__((aligned(64)));
 float fa[16] __attribute__((aligned(64))),fb[16] __attribute__((aligned(64))),fo[16] __attribute__((aligned(64)));
 double da[8] __attribute__((aligned(64))),db[8] __attribute__((aligned(64))),dout[8] __attribute__((aligned(64)));
 for(n=0;n<1000;n++){
  for(k=0;k<16;k++){a[k]=next();b[k]=next();m[k]=next();fa[k]=(int)(a[k]%20000)-10000;fb[k]=((int)(b[k]%20000)-10000)*0.25f;}
  vector_add_i32(o,a,b);for(k=0;k<16;k++)CHECK(o[k]==a[k]+b[k]);
  vector_mul_i32(o,a,b);for(k=0;k<16;k++)CHECK(o[k]==a[k]*b[k]);
  uint32_t mask=n==0?0:n==1?65535:next()&65535;
  vector_mask(o,m,a,b,mask);for(k=0;k<16;k++)CHECK(o[k]==((mask>>k&1)?a[k]+b[k]:m[k]));
  vector_add_f32(fo,fa,fb);for(k=0;k<16;k++)CHECK(fo[k]==fa[k]+fb[k]);
  vector_mul_f32(fo,fa,fb);for(k=0;k<16;k++){volatile float rounded=fa[k]*fb[k];CHECK(fo[k]==rounded);}
  for(k=0;k<8;k++){da[k]=fa[k];db[k]=fb[k];}
  vector_add_f64(dout,da,db);for(k=0;k<8;k++)CHECK(dout[k]==da[k]+db[k]);
  vector_mul_f64(dout,da,db);for(k=0;k<8;k++)CHECK(dout[k]==da[k]*db[k]);
 }
 uint32_t many[40*16] __attribute__((aligned(64)));
 for(k=0;k<40*16;k++)many[k]=next();
 vector_spills(o,many);
 for(k=0;k<16;k++){uint32_t sum=0;for(n=0;n<40;n++)sum+=many[n*16+k];CHECK(o[k]==sum);}
 vector_call(o,many);
 for(k=0;k<16;k++){uint32_t sum=0;for(n=0;n<10;n++)sum+=many[n*16+k];CHECK(o[k]==sum);}
 unsigned char src[256] __attribute__((aligned(64))),dst[256] __attribute__((aligned(64)));
 for(k=0;k<256;k++)src[k]=(unsigned char)next();
 for(n=0;n<64;n+=4){memset(dst,0x5a,sizeof(dst));vector_unaligned(dst+64+n,src+64+n);for(k=0;k<256;k++)CHECK(dst[k]==((k>=64+n && k<128+n)?src[k]:0x5a));}
 long pg=sysconf(_SC_PAGESIZE);unsigned char *guard=mmap(0,3*pg,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 CHECK(guard!=MAP_FAILED);CHECK(mprotect(guard+pg,pg,PROT_READ|PROT_WRITE)==0);
 for(n=0;n<2;n++){unsigned char *p=guard+pg+(n?pg-64:0);memcpy(p,src,64);vector_unaligned(dst,p);CHECK(memcmp(dst,src,64)==0);vector_unaligned(p,src);CHECK(memcmp(p,src,64)==0);}
 munmap(guard,3*pg);
 puts("PASS IMCI values: integer add/mul/masks, FP32/FP64 add/mul, 40 live vectors across a call, ten vector arguments/return, 16 naturally aligned offsets, guard-page boundaries");return 0;
}
