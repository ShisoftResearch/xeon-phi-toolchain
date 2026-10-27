#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <fenv.h>
struct kernel_case{unsigned op,w,n;uint64_t parameter,input[32],lower[32],upper[32];};
#include "runtime-kernel-corpus.h"
extern void runtime_kernel32(unsigned,unsigned,const void*,const void*,void*),runtime_kernel64(unsigned,unsigned,const void*,const void*,void*);
static uint64_t key(uint64_t b,unsigned w){uint64_t sign=UINT64_C(1)<<(w-1),mask=UINT64_MAX>>(64-w);return b&sign?(~b)&mask:b|sign;}
int main(void){
 unsigned failures=0,lanes=0;uint64_t sentinel=UINT64_C(0xa55af00d69c3b817);
 if(fesetround(FE_TONEAREST))return 1;
 for(unsigned i=0;i<sizeof(kernel_cases)/sizeof(kernel_cases[0]);i++){
  const struct kernel_case*c=kernel_cases+i;uint64_t input[34],output[34];memset(input,0xcc,sizeof input);for(unsigned j=0;j<34;j++)output[j]=sentinel;
  for(unsigned j=0;j<c->n;j++)memcpy((char*)(input+1)+j*(c->w/8),&c->input[j],c->w/8);
  uint64_t original[34];memcpy(original,input,sizeof input);
  if(c->w==32)runtime_kernel32(c->op,c->n,input+1,&c->parameter,output+1);else runtime_kernel64(c->op,c->n,input+1,&c->parameter,output+1);
  unsigned bytes=c->n*(c->w/8);int guard=output[0]!=sentinel||memcmp(original,input,sizeof input);
  for(unsigned j=8+bytes;j<sizeof output;j++)if(((unsigned char*)output)[j]!=((unsigned char*)&sentinel)[j%8])guard=1;
  if(guard){puts("FAIL composed math memory boundary");failures++;}
  for(unsigned j=0;j<c->n;j++){
   uint64_t got=0;memcpy(&got,(char*)(output+1)+j*(c->w/8),c->w/8);uint64_t k=key(got,c->w);
   if(k<key(c->lower[j],c->w)||k>key(c->upper[j],c->w)){if(failures<20)printf("FAIL composed math case=%u op=%u w=%u lane=%u got=%llx range=[%llx,%llx]\n",i,c->op,c->w,j,(unsigned long long)got,(unsigned long long)c->lower[j],(unsigned long long)c->upper[j]);failures++;}lanes++;
  }
 }
 printf("%s composed math: SiLU GELU softmax RMSNorm RoPE, %u cases %u lanes, guarded memory, failures=%u\n",failures?"FAIL":"PASS",(unsigned)(sizeof(kernel_cases)/sizeof(kernel_cases[0])),lanes,failures);return !!failures;
}
