#define _GNU_SOURCE
#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sched.h>
extern void auto_predicated(uint32_t*,const uint32_t*,const uint32_t*,const uint32_t*,size_t);
extern void auto_predicated_before_tuning(uint32_t*,const uint32_t*,const uint32_t*,const uint32_t*,size_t);
typedef void (*kernel)(uint32_t*,const uint32_t*,const uint32_t*,const uint32_t*,size_t);
static uint64_t ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
static uint64_t measure(kernel fn,uint32_t *o,uint32_t*a,uint32_t*b,uint32_t*m,size_t n){uint64_t start=ns();for(unsigned r=0;r<128;r++)fn(o,a,b,m,n);return ns()-start;}
static uint64_t median(uint64_t *x){for(unsigned i=1;i<7;i++)for(unsigned j=i;j&&x[j]<x[j-1];j--){uint64_t t=x[j];x[j]=x[j-1];x[j-1]=t;}return x[3];}
int main(void){
 enum{N=16384};uint32_t *a,*b,*m,*o,*old; if(posix_memalign((void**)&a,64,N*4)||posix_memalign((void**)&b,64,N*4)||posix_memalign((void**)&m,64,N*4)||posix_memalign((void**)&o,64,N*4)||posix_memalign((void**)&old,64,N*4))return 1;
 cpu_set_t cpus;CPU_ZERO(&cpus);CPU_SET(1,&cpus);int pinned=sched_setaffinity(0,sizeof(cpus),&cpus)==0;
 printf("KNC predicated affine benchmark: n=%u repeats=128 samples=7 pinned=%d; median wall time ns, alternating old/new order\n",N,pinned);
 for(unsigned density=0;density<=16;density+=4){
  for(unsigned i=0;i<N;i++){a[i]=i*0x319abcdu;b[i]=i^0xa7b38cd;m[i]=(i%16)<density?0x80000000:0;o[i]=old[i]=0xa7a7a7a7;}
  auto_predicated(o,a,b,m,N);auto_predicated_before_tuning(old,a,b,m,N);
  for(unsigned i=0;i<N;i++)if(o[i]!=old[i]||o[i]!=(m[i]?a[i]*3u+b[i]:0xa7a7a7a7)){printf("FAIL tuning density=%u lane=%u\n",density,i);return 1;}
  uint64_t before[7],after[7];for(unsigned s=0;s<7;s++){if(s&1){after[s]=measure(auto_predicated,o,a,b,m,N);before[s]=measure(auto_predicated_before_tuning,old,a,b,m,N);}else{before[s]=measure(auto_predicated_before_tuning,old,a,b,m,N);after[s]=measure(auto_predicated,o,a,b,m,N);}}
  printf("density=%u/16 before_ns=%llu after_ns=%llu\n",density,(unsigned long long)median(before),(unsigned long long)median(after));
 }
 puts("PASS measured tuning: old/new results agree at all five mask densities");return 0;
}
