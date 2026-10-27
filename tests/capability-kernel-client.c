#define _GNU_SOURCE
#include <k1om/capabilities.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "vector-fp-corpus.h"
extern void capability_dot_i8(int32_t*,const int8_t*,const int8_t*);
extern void capability_affine_f32(void*,const void*,const void*,const void*);
extern void capability_dequant_pairs(float*,const uint8_t*);
#define CHECK(X) do {if(!(X)){printf("FAIL native capability client line=%d\n",__LINE__);return 1;}}while(0)
static uint32_t state=0x19283745;
static uint32_t random_word(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
static k1om_requirement req(unsigned op,unsigned in,unsigned out,unsigned n,unsigned count,unsigned layout,unsigned align,unsigned props,unsigned pre){
 k1om_requirement r={op,in,out,n,count,align,layout,props,pre};return r;
}
static int supported(const k1om_requirement *p,size_t n){
#if defined(__k1om__)
 k1om_plan_match m=k1om_target_match_requirements(p,n,K1OM_ALLOW_DEFAULT);
#else
 /* The host is a mathematical reference client, not a K1OM execution target. */
 k1om_plan_match m=k1om_catalog_match_requirements(p,n,K1OM_ALLOW_DEFAULT);
#endif
 if(m.status!=K1OM_MATCH_OK){printf("FAIL kernel requirement %lu: %s\n",(unsigned long)m.failed_requirement,k1om_match_diagnostic(m.status));return 0;}
 return 1;
}
static int nan32(uint32_t v){return (v&0x7fffffffU)>0x7f800000U;}
int main(void){
 const unsigned valid=K1OM_ASSUME_ACTIVE_MEMORY_VALID,fp=K1OM_ASSUME_DEFAULT_FP_ENV,exact=K1OM_PROP_EXACT_INTEGER;
 /* The application supplies and selects these complete kernels. The matcher
    never builds a replacement for native_byte_dot or any other instruction. */
 k1om_requirement dot[]={
  req(K1OM_OP_LOAD_EXTEND_S,K1OM_TYPE_I8,K1OM_TYPE_I32,16,16,K1OM_LAYOUT_CONTIGUOUS,1,exact,valid),
  req(K1OM_OP_MUL,K1OM_TYPE_I32,K1OM_TYPE_I32,16,16,K1OM_LAYOUT_NONE,0,exact,0),
  req(K1OM_OP_REDUCE_ADD,K1OM_TYPE_I32,K1OM_TYPE_I32,16,1,K1OM_LAYOUT_NONE,0,exact,0)};
 k1om_requirement affine[]={
  req(K1OM_OP_LOAD_BITS,K1OM_TYPE_F32,K1OM_TYPE_F32,16,16,K1OM_LAYOUT_CONTIGUOUS,1,K1OM_PROP_COPY_BITS,valid),
  req(K1OM_OP_FP_FMA,K1OM_TYPE_F32,K1OM_TYPE_F32,16,16,K1OM_LAYOUT_NONE,0,K1OM_PROP_FP_FUSED_VALUE|K1OM_PROP_FP_RNE_VALUE,fp),
  req(K1OM_OP_STORE_BITS,K1OM_TYPE_F32,K1OM_TYPE_F32,16,16,K1OM_LAYOUT_CONTIGUOUS,1,K1OM_PROP_COPY_BITS,valid)};
 k1om_requirement dequant[]={
  req(K1OM_OP_LOAD_EXTEND_U,K1OM_TYPE_I8,K1OM_TYPE_I32,16,16,K1OM_LAYOUT_CONTIGUOUS,1,exact,valid),
  req(K1OM_OP_AND,K1OM_TYPE_I32,K1OM_TYPE_I32,16,16,K1OM_LAYOUT_NONE,0,exact,0),
  req(K1OM_OP_ASHR,K1OM_TYPE_I32,K1OM_TYPE_I32,16,16,K1OM_LAYOUT_NONE,0,exact,K1OM_ASSUME_SHIFT_IN_RANGE),
  req(K1OM_OP_ADD,K1OM_TYPE_I32,K1OM_TYPE_I32,16,16,K1OM_LAYOUT_NONE,0,exact,0),
  req(K1OM_OP_SUB,K1OM_TYPE_I32,K1OM_TYPE_I32,16,16,K1OM_LAYOUT_NONE,0,exact,0),
  req(K1OM_OP_INT_TO_FP_S,K1OM_TYPE_I32,K1OM_TYPE_F32,16,16,K1OM_LAYOUT_NONE,0,K1OM_PROP_FP_RNE_VALUE,fp),
  req(K1OM_OP_FP_MUL,K1OM_TYPE_F32,K1OM_TYPE_F32,16,16,K1OM_LAYOUT_NONE,0,K1OM_PROP_FP_RNE_VALUE,fp),
  req(K1OM_OP_STORE_BITS,K1OM_TYPE_F32,K1OM_TYPE_F32,16,16,K1OM_LAYOUT_CONTIGUOUS,1,K1OM_PROP_COPY_BITS,valid)};
 CHECK(supported(dot,sizeof(dot)/sizeof(dot[0])));
 CHECK(supported(affine,sizeof(affine)/sizeof(affine[0])));
 CHECK(supported(dequant,sizeof(dequant)/sizeof(dequant[0])));
 CHECK(k1om_catalog_query(k1om_require(K1OM_OP_NATIVE_BYTE_DOT,K1OM_TYPE_I8,K1OM_TYPE_I32,64,16),K1OM_ALLOW_ANY).status==K1OM_MATCH_NATIVE_ABSENT);
 size_t page=(size_t)sysconf(_SC_PAGESIZE);
 uint8_t *mem=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 CHECK(mem!=MAP_FAILED);CHECK(!mprotect(mem+page,page,PROT_READ|PROT_WRITE));
 int8_t b[16];int32_t out;unsigned dot_cases=0,dequant_lanes=0,fma_lanes=0;
 /* Includes every offset mod 64, exact page endpoints, and all byte values.
    Neighbouring guard pages detect accidental overreads of narrow inputs. */
 for(unsigned where=0;where<66;where++){
  uint8_t *a=where==64?mem+page:where==65?mem+page*2-16:mem+page+128+where;
  for(unsigned trial=0;trial<256;trial++){
   int32_t expected=0;
   for(unsigned k=0;k<16;k++){a[k]=(uint8_t)(trial+k*17);b[k]=(int8_t)(random_word()&255);expected+=(int32_t)(int8_t)a[k]*(int32_t)b[k];}
   capability_dot_i8(&out,(const int8_t*)a,b);CHECK(out==expected);dot_cases++;
   float f[16];capability_dequant_pairs(f,a);
   for(unsigned k=0;k<16;k++){float e=(float)((int)(a[k]&15)+(int)(a[k]>>4)-15)*0.125f;CHECK(!memcmp(&f[k],&e,4));dequant_lanes++;}
  }
 }
 /* Independent exact-rational FMA corpus, including a case where two rounding
    steps produce zero and fused rounding produces a nonzero result. */
 uint32_t x[16],y[16],z[16],r[16];
 size_t count=sizeof(fma32_cases)/sizeof(fma32_cases[0]);
 for(size_t base=0;base<count;base+=16){
  for(unsigned k=0;k<16;k++){size_t i=(base+k)%count;x[k]=fma32_cases[i].a;y[k]=fma32_cases[i].b;z[k]=fma32_cases[i].c;}
  capability_affine_f32(r,x,y,z);
  for(unsigned k=0;k<16;k++){CHECK(r[k]==fma32_cases[(base+k)%count].expected);fma_lanes++;}
 }
 static const uint32_t special[][4]={
  {0x7f800000,0,0,0x7fc00000},{0x7f800000,0x3f800000,0xff800000,0x7fc00000},
  {0x7f800000,0x3f800000,0,0x7f800000},{1,0x3f800000,0,1},
  {1,0x3f000000,0,0},{0x80000001,0x3f000000,0x80000000,0x80000000},
  {0x7f7fffff,0x40000000,0xff7fffff,0x7f7fffff},{0x3f800000,0x3f800000,0xbf800000,0},
  {0x80000000,0x3f800000,0x80000000,0x80000000}};
 for(unsigned base=0;base<sizeof(special)/sizeof(special[0]);base++){
  for(unsigned k=0;k<16;k++){unsigned i=(base+k)%(sizeof(special)/sizeof(special[0]));x[k]=special[i][0];y[k]=special[i][1];z[k]=special[i][2];}
  capability_affine_f32(r,x,y,z);
  for(unsigned k=0;k<16;k++){unsigned i=(base+k)%(sizeof(special)/sizeof(special[0]));CHECK(nan32(special[i][3])?nan32(r[k]):r[k]==special[i][3]);fma_lanes++;}
 }
 CHECK(!munmap(mem,page*3));
 printf("PASS native capability clients: dot_cases=%u dequant_lanes=%u fma_lanes=%u target=%d catalog=%s\n",dot_cases,dequant_lanes,fma_lanes,k1om_compiler_target(),K1OM_CATALOG_SHA256);
 return 0;
}
