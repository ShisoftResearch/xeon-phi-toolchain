#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "fp-bits.h"
#include "quantized-foundation-ops.h"
#define K(fn,op,src,dst,n,ab,bb,cb,ob) extern void fn(void*,const void*,const void*,const void*);
#include "quantized-foundation-cases.h"
#undef K
struct kernel{const char*name;void(*fn)(void*,const void*,const void*,const void*);unsigned op,src,dst,n,ab,bb,cb,ob;};
#define K(fn,op,src,dst,n,ab,bb,cb,ob) {#fn,fn,op,src,dst,n,ab,bb,cb,ob},
static const struct kernel kernels[]={
#include "quantized-foundation-cases.h"
};
#undef K
static uint64_t mask(unsigned w){return UINT64_MAX>>(64-w);}
static int64_t signed_value(uint64_t v,unsigned w){uint64_t s=UINT64_C(1)<<(w-1);return (int64_t)((v^s)-s);}
static uint64_t reference(const struct kernel*f,unsigned i,const void*a,const void*b,const void*c){
 unsigned op=f->op,src=f->src,dst=f->dst;uint64_t result=0;
 if(op<=Q_TRUNCATE){uint64_t x=get(a,i,src/8);return op==Q_EXTEND_S?(uint64_t)signed_value(x,src)&mask(dst):x&mask(dst);}
 if(op<=Q_PACK_UU){
  unsigned per=128/src,block=i/(2*per),j=i%(2*per),index=block*per+j%per;
  uint64_t x=get(j<per?a:b,index,src/8);
  int64_t v=op==Q_PACK_UU?(int64_t)x:signed_value(x,src);
  int64_t lo=op==Q_PACK_SS?-(INT64_C(1)<<(dst-1)):0;
  int64_t hi=op==Q_PACK_SS?(INT64_C(1)<<(dst-1))-1:(INT64_C(1)<<dst)-1;
  if(v<lo)v=lo;if(v>hi)v=hi;return (uint64_t)v&mask(dst);
 }
 unsigned group=src==16||op==Q_MADDUBS_SAT?2:4;
 int64_t sum=0;
 for(unsigned j=0;j<group;++j){uint64_t x=get(a,i*group+j,src/8),y=get(b,i*group+j,src/8);
  int64_t ax=(op==Q_MADDUBS_SAT||op==Q_DPBUSD||op==Q_DPBUSDS)?(int64_t)x:signed_value(x,src);
  sum+=ax*signed_value(y,src);
 }
 if(op>=Q_DPBUSD)sum+=signed_value(get(c,i,4),32);
 if(op==Q_MADDUBS_SAT||op==Q_DPBUSDS||op==Q_DPWSSDS){int64_t lo=-(INT64_C(1)<<(dst-1)),hi=(INT64_C(1)<<(dst-1))-1;if(sum<lo)sum=lo;if(sum>hi)sum=hi;}
 result=(uint64_t)sum&mask(dst);return result;
}
extern void word_extend_s(void*,const void*),word_extend_u(void*,const void*),word_truncate(void*,const void*);
static int check_word_memory(size_t page,size_t*calls,size_t*checks){
 unsigned char*ma=mapping(page),*mo=mapping(page),*expected=malloc(page);if(!expected)return 1;
 for(unsigned mode=0;mode<3;++mode)for(unsigned iter=0;iter<4096;++iter){
  unsigned char*in=ma+page+(mode==0?0:mode==1?page-32:(iter%32)*2);
  unsigned char*out=mo+page+(mode==0?0:mode==1?page-64:(iter%16)*4);
  for(unsigned i=0;i<16;++i)put(in,i,2,(uint16_t)(iter*16+i));
  for(unsigned sign=0;sign<2;++sign){
   memset(mo+page,0xa5,page);memcpy(expected,mo+page,page);
   for(unsigned i=0;i<16;++i){uint64_t x=get(in,i,2);put(expected+(out-(mo+page)),i,4,sign?(uint64_t)signed_value(x,16):x);}
   (sign?word_extend_s:word_extend_u)(out,in);++*calls;*checks+=16;
   if(memcmp(expected,mo+page,page)){printf("FAIL native word extension mode=%u iter=%u signed=%u\n",mode,iter,sign);return 1;}
  }
  in=ma+page+(mode==0?0:mode==1?page-64:(iter%16)*4);
  out=mo+page+(mode==0?0:mode==1?page-32:(iter%32)*2);
  for(unsigned i=0;i<16;++i)put(in,i,4,next());
  memset(mo+page,0xa5,page);memcpy(expected,mo+page,page);
  for(unsigned i=0;i<16;++i)put(expected+(out-(mo+page)),i,2,get(in,i,4)&65535);
  word_truncate(out,in);++*calls;*checks+=16;
  if(memcmp(expected,mo+page,page)){printf("FAIL native word truncation mode=%u iter=%u\n",mode,iter);return 1;}
 }
 free(expected);munmap(ma,page*3);munmap(mo,page*3);return 0;
}
int main(void){
 size_t page=sysconf(_SC_PAGESIZE),calls=0,checks=0;
 if(check_word_memory(page,&calls,&checks))return 1;
 unsigned char*ma=mapping(page),*mb=mapping(page),*mc=mapping(page),*mo=mapping(page);
 for(unsigned k=0;k<sizeof(kernels)/sizeof(kernels[0]);++k){
  const struct kernel*f=&kernels[k];unsigned sb=f->src/8,db=f->dst/8;
  uint64_t m=mask(f->src),sign=UINT64_C(1)<<(f->src-1),edges[]={0,1,2,127,128,255,256,32767,32768,65535,65536,m,m-1,sign,sign-1,sign+1};
  for(unsigned mode=0;mode<5;++mode)for(unsigned iter=0;iter<512;++iter){
   unsigned char*a=ma+page+(mode==0?page-f->ab:mode==1?0:mode==4?iter%64:1);
   unsigned char*b=f->bb?mb+page+(mode==0?page-f->bb:mode==1?0:mode==4?(iter*3)%64:3):0;
   unsigned char*c=f->cb?mc+page+(mode==0?page-f->cb:mode==1?0:mode==4?(iter*5)%64:5):0;
   unsigned char*out=mode==3?a+1:mo+page+(mode==0?page-f->ob:mode==1?0:mode==4?(iter*7)%64:7);
   memset(ma+page,0xa5,page);memset(mb+page,0xa5,page);memset(mc+page,0xa5,page);memset(mo+page,0xa5,page);
   for(unsigned j=0;j<f->ab/sb;++j){uint64_t x=(iter<256?edges[(iter+j)%16]:next())&m;put(a,j,sb,x);}
   for(unsigned j=0;j<f->bb/sb;++j){uint64_t y=(iter<256?edges[(iter/16+j*3)%16]:next())&m;put(b,j,sb,y);}
   for(unsigned j=0;j<f->cb/4;++j)put(c,j,4,iter<256?((j+iter)&1?UINT32_C(0x80000000):UINT32_C(0x7fffffff)):next());
   /* Pair overflow must be combined with the accumulator before signed
      saturation; clipping/wrapping the pair first gives the wrong answer. */
   if((f->op==Q_MADD_I16||f->op==Q_DPWSSD||f->op==Q_DPWSSDS)&&iter<4){
    for(unsigned j=0;j<f->ab/2;++j){put(a,j,2,0x8000);put(b,j,2,0x8000);}
    if(f->cb)for(unsigned j=0;j<f->cb/4;++j)put(c,j,4,iter&1?UINT32_C(0x7fffffff):UINT32_C(0x80000000));
   }
   uint64_t expected[64];unsigned n=f->ob/db;
   for(unsigned i=0;i<n;++i)expected[i]=reference(f,i,a,b,c);
   unsigned char*outpage=mode==3?ma+page:mo+page;int before=out>outpage,after=out+f->ob<outpage+page;
   unsigned char cb=before?out[-1]:0,ca=after?out[f->ob]:0;
   f->fn(out,a,b,c);++calls;
   if((before&&out[-1]!=cb)||(after&&out[f->ob]!=ca)){printf("FAIL quantized foundation %s canary mode=%u iteration=%u\n",f->name,mode,iter);return 1;}
   for(unsigned i=0;i<n;++i){uint64_t got=get(out,i,db);++checks;if(got!=expected[i]){printf("FAIL quantized foundation %s mode=%u iteration=%u lane=%u got=%016llx expected=%016llx\n",f->name,mode,iter,i,(unsigned long long)got,(unsigned long long)expected[i]);return 1;}}
  }
 }
 munmap(ma,page*3);munmap(mb,page*3);munmap(mc,page*3);munmap(mo,page*3);
 printf("PASS quantized foundations: %zu structured kernels plus 3 native word paths, %zu calls, %zu exact results; byte/word widening, narrowing, 128-bit-lane packing, saturating/wrapping multiply-add and dot accumulation, all byte offsets, protected boundaries and overlap\n",sizeof(kernels)/sizeof(kernels[0]),calls,checks);return 0;
}
