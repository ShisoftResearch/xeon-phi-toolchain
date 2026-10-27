/* Stage 5.2 measurement input. No scheduler latencies are inferred here. */
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <sched.h>
static const uint32_t ones32[16] __attribute__((aligned(64)))={[0 ... 15]=0x3f800000};
static const uint64_t ones64[8] __attribute__((aligned(64)))={[0 ... 7]=UINT64_C(0x3ff0000000000000)};
static unsigned char memory[512] __attribute__((aligned(64)));
static uint64_t ticks(void){uint32_t a,d;__asm__ volatile("cpuid\nrdtsc":"=a"(a),"=d"(d):"a"(0):"rbx","rcx","memory");return((uint64_t)d<<32)|a;}
#define CLOBBERS "zmm0","zmm1","zmm2","zmm3","zmm4","zmm5","zmm6","zmm7","zmm8","zmm9","memory"
static void prepare(const void*p){__asm__ volatile(
 "vmovdqa32 (%0),%%zmm1\nvmovdqa32 %%zmm1,%%zmm0\nvmovdqa32 %%zmm1,%%zmm2\nvmovdqa32 %%zmm1,%%zmm3\nvmovdqa32 %%zmm1,%%zmm4\nvmovdqa32 %%zmm1,%%zmm5\nvmovdqa32 %%zmm1,%%zmm6\nvmovdqa32 %%zmm1,%%zmm7\nvmovdqa32 %%zmm1,%%zmm8\nvmovdqa32 %%zmm1,%%zmm9"::"r"(p):CLOBBERS);}
#define TRI(OP,D) OP " %%zmm1,%%zmm" #D ",%%zmm" #D "\n"
#define FMA(OP,D) OP " %%zmm1,%%zmm2,%%zmm" #D "\n"
#define UNARY(OP,D) OP " %%zmm" #D ",%%zmm" #D "\n"
#define EIGHT(M,OP) M(OP,0) M(OP,3) M(OP,4) M(OP,5) M(OP,6) M(OP,7) M(OP,8) M(OP,9)
#define BENCH(N,OP,M,DATA) static uint64_t N(int independent){prepare(DATA);uint64_t start=ticks();if(independent){for(unsigned r=0;r<4096;r++)__asm__ volatile(".rept 16\n" EIGHT(M,OP) ".endr\n":::CLOBBERS);}else{for(unsigned r=0;r<4096;r++)__asm__ volatile(".rept 128\n" M(OP,0) ".endr\n":::CLOBBERS);}return ticks()-start;}
BENCH(integer,"vpaddd",TRI,ones32)
BENCH(add32,"vaddps",TRI,ones32) BENCH(mul32,"vmulps",TRI,ones32)
BENCH(add64,"vaddpd",TRI,ones64) BENCH(mul64,"vmulpd",TRI,ones64)
BENCH(sub32,"vsubps",TRI,ones32) BENCH(sub64,"vsubpd",TRI,ones64)
BENCH(fma32,"vfmadd132ps",FMA,ones32) BENCH(fma64,"vfmadd132pd",FMA,ones64)
BENCH(rcp32,"vrcp23ps",UNARY,ones32) BENCH(rsqrt32,"vrsqrt23ps",UNARY,ones32)
#define LOAD(D,OFF) "vmovdqa32 " #OFF "(%0),%%zmm" #D "\n"
#define STORE(D,OFF) "vmovdqa32 %%zmm" #D "," #OFF "(%0)\n"
#define MEM_EIGHT(M) M(0,0) M(3,64) M(4,128) M(5,192) M(6,256) M(7,320) M(8,384) M(9,448)
static uint64_t load_hot(int ignored){(void)ignored;prepare(ones32);uint64_t start=ticks();for(unsigned r=0;r<4096;r++)__asm__ volatile(".rept 16\n" MEM_EIGHT(LOAD) ".endr\n"::"r"(memory):CLOBBERS);return ticks()-start;}
static uint64_t store_hot(int ignored){(void)ignored;prepare(ones32);uint64_t start=ticks();for(unsigned r=0;r<4096;r++)__asm__ volatile(".rept 16\n" MEM_EIGHT(STORE) ".endr\n"::"r"(memory):CLOBBERS);return ticks()-start;}
static uint64_t median(uint64_t*x){for(unsigned i=1;i<7;i++)for(unsigned j=i;j&&x[j]<x[j-1];j--){uint64_t t=x[j];x[j]=x[j-1];x[j-1]=t;}return x[3];}
int main(void){
 cpu_set_t cpus;CPU_ZERO(&cpus);CPU_SET(1,&cpus);if(sched_setaffinity(0,sizeof cpus,&cpus))return 1;
 uint64_t(*functions[])(int)={integer,add32,mul32,add64,mul64,sub32,sub64,fma32,fma64,rcp32,rsqrt32,load_hot,store_hot};
 const char*names[]={"vpaddd","vaddps","vmulps","vaddpd","vmulpd","vsubps","vsubpd","vfmadd132ps","vfmadd132pd","vrcp23ps","vrsqrt23ps","vmovdqa32_load_hot","vmovdqa32_store_hot"};
 puts("FP scheduling measurements: CPU1, one active process, 7 samples, 524288 operations, serialized raw TSC ticks including loop/boundary overhead; arithmetic uses eight independent chains or one dependent chain; memory is aligned hot 512-byte throughput only");
 for(unsigned k=0;k<13;k++){
  uint64_t dependent[7],independent[7];
  for(unsigned s=0;s<7;s++){dependent[s]=functions[k](0);independent[s]=functions[k](1);printf("SCHED_SAMPLE name=%s sample=%u operations=524288 dependent_ticks=%llu independent_ticks=%llu\n",names[k],s,(unsigned long long)dependent[s],(unsigned long long)independent[s]);}
  printf("SCHED_MEDIAN name=%s operations=524288 dependent_ticks=%llu independent_ticks=%llu kind=%s\n",names[k],(unsigned long long)median(dependent),(unsigned long long)median(independent),k<11?"arithmetic":"memory_throughput_only");
 }
 puts("PASS FP/memory scheduling measurement input completed; compiler model validation is separate");return 0;
}
