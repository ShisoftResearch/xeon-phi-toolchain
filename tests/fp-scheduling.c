#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sched.h>
#define K(N,W,C,D,O) extern void N(void*,const void*),before_##N(void*,const void*);
#include "fp-scheduling-cases.h"
#undef K
struct entry{const char*name;unsigned width,chains,depth,operation;void(*after)(void*,const void*),(*before)(void*,const void*);};
#define K(N,W,C,D,O) {#N,W,C,D,O,N,before_##N},
static const struct entry cases[]={
#include "fp-scheduling-cases.h"
};
#undef K
static uint64_t integer_bits(unsigned value,unsigned width){unsigned fraction=width==32?23:52,bias=width==32?127:1023;if(!value)return 0;unsigned highest=31-__builtin_clz(value);return((uint64_t)(highest+bias)<<fraction)|((uint64_t)(value-(1u<<highest))<<(fraction-highest));}
static uint64_t ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return(uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
int main(void){
 cpu_set_t cpus;CPU_ZERO(&cpus);CPU_SET(1,&cpus);if(sched_setaffinity(0,sizeof cpus,&cpus))return 1;
 unsigned char in[640] __attribute__((aligned(64))),out[640] __attribute__((aligned(64)));unsigned checks=0,failures=0;
 for(unsigned k=0;k<sizeof cases/sizeof cases[0];k++){
  const struct entry*c=cases+k;unsigned lanes=512/c->width,bytes=c->width/8;
  for(unsigned row=0;row<16;row++){
   memset(in,0,sizeof in);
   for(unsigned chain=0;chain<c->chains+2;chain++)for(unsigned lane=0;lane<lanes;lane++){
    unsigned v=chain<c->chains?row+chain*lanes+lane+1:chain==c->chains?1:2;uint64_t bits=integer_bits(v,c->width);memcpy(in+chain*64+lane*bytes,&bits,bytes);
   }
   unsigned char original[640];memcpy(original,in,sizeof in);
   for(unsigned path=0;path<2;path++){
    memset(out,0xa5,sizeof out);(path?c->before:c->after)(out,in);
    for(unsigned chain=0;chain<c->chains;chain++)for(unsigned lane=0;lane<lanes;lane++){
     unsigned result=row+chain*lanes+lane+1+(c->operation==0?c->depth:c->operation==1?0:c->operation==2?2*c->depth:c->depth/2);uint64_t expected=integer_bits(result,c->width),got=0;memcpy(&got,out+chain*64+lane*bytes,bytes);checks++;
     if(got!=expected){if(failures<8)printf("FAIL schedule workload=%s row=%u chain=%u lane=%u before=%u got=%llx expected=%llx\n",c->name,row,chain,lane,path,(unsigned long long)got,(unsigned long long)expected);failures++;}
    }
    for(unsigned i=c->chains*64;i<sizeof out;i++)if(out[i]!=0xa5)failures++;
    if(memcmp(original,in,sizeof in))failures++;
   }
  }
  for(unsigned round=0;round<5;round++)for(unsigned order=0;order<2;order++){
   unsigned before=(round+order)%2;void(*fn)(void*,const void*)=before?c->before:c->after;uint64_t start=ns();for(unsigned i=0;i<1024;i++)fn(out,in);uint64_t elapsed=ns()-start;
   printf("TIMING schedule kernel=%s round=%u path=%s ns=%llu\n",c->name,round,before?"before":"after",(unsigned long long)elapsed);
  }
 }
 printf("%s FP scheduling: %u kernels, %u exact integer-decoded results, unchanged inputs and guarded outputs, failures=%u\n",failures?"FAIL":"PASS",(unsigned)(sizeof cases/sizeof cases[0]),checks,failures);return !!failures;
}
