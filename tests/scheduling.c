#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <sched.h>
static uint64_t ticks(void){uint32_t a,d;__asm__ volatile("rdtsc":"=a"(a),"=d"(d)::"memory");return ((uint64_t)d<<32)|a;}
#define ONE(OP,D) OP " %%zmm1,%%zmm" #D ",%%zmm" #D "\n"
#define SERIAL(OP) ".rept 128\n" ONE(OP,0) ".endr\n"
#define INDEP(OP) ".rept 16\n" ONE(OP,0) ONE(OP,2) ONE(OP,3) ONE(OP,4) ONE(OP,5) ONE(OP,6) ONE(OP,7) ONE(OP,8) ".endr\n"
#define BENCH(N,OP) static uint64_t N(int independent){uint64_t start=ticks();if(independent){for(unsigned r=0;r<4096;r++)__asm__ volatile(INDEP(OP):: :"zmm0","zmm2","zmm3","zmm4","zmm5","zmm6","zmm7","zmm8");}else{for(unsigned r=0;r<4096;r++)__asm__ volatile(SERIAL(OP):: :"zmm0");}return ticks()-start;}
BENCH(add,"vpaddd") BENCH(mul,"vpmulld") BENCH(high,"vpmulhud") BENCH(perm,"vpermd") BENCH(shift,"vpsllvd")
static uint64_t median(uint64_t *x){for(unsigned i=1;i<7;i++)for(unsigned j=i;j&&x[j]<x[j-1];j--){uint64_t t=x[j];x[j]=x[j-1];x[j-1]=t;}return x[3];}
int main(void){cpu_set_t cpus;CPU_ZERO(&cpus);CPU_SET(1,&cpus);if(sched_setaffinity(0,sizeof(cpus),&cpus))return 1;
 /* Initialize operands deterministically; no floating-point state is involved. */
 __asm__ volatile("vpxord %%zmm0,%%zmm0,%%zmm0\n vpxord %%zmm1,%%zmm1,%%zmm1\n vpxord %%zmm2,%%zmm2,%%zmm2\n vpxord %%zmm3,%%zmm3,%%zmm3\n vpxord %%zmm4,%%zmm4,%%zmm4\n vpxord %%zmm5,%%zmm5,%%zmm5\n vpxord %%zmm6,%%zmm6,%%zmm6\n vpxord %%zmm7,%%zmm7,%%zmm7\n vpxord %%zmm8,%%zmm8,%%zmm8":::"zmm0","zmm1","zmm2","zmm3","zmm4","zmm5","zmm6","zmm7","zmm8");
 uint64_t (*fn[])(int)={add,mul,high,perm,shift};const char *name[]={"vpaddd","vpmulld","vpmulhud","vpermd","vpsllvd"};
 puts("KNC scheduling calibration: CPU1, 7 medians, 4096x128 operations; raw TSC ticks including loop overhead; independent uses eight destination registers");
 for(unsigned i=0;i<5;i++){uint64_t serial[7],independent[7];for(unsigned s=0;s<7;s++){serial[s]=fn[i](0);independent[s]=fn[i](1);}printf("%s operations=524288 dependent_ticks=%llu independent_ticks=%llu\n",name[i],(unsigned long long)median(serial),(unsigned long long)median(independent));}
 puts("PASS scheduling calibration completed");return 0;
}
