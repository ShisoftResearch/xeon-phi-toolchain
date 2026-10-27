#define _GNU_SOURCE
#include <pthread.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/utsname.h>
extern void scaling_fp32(float*,const float*,const float*,size_t);
extern double scaling_fp64(const double*,const double*,size_t);
extern uint32_t scaling_q8(const int8_t*,const int8_t*,size_t);
#ifndef SCALING_STREAM
#define N 1021
#define ITERATIONS 512
#define PROFILE "hot"
#else
#define N 65539
#define ITERATIONS 8
#define PROFILE "stream"
#endif
#define ROUNDS 5
#define MAX_WORKERS 240
struct cpu {int id,core,package;};
static struct cpu cpus[CPU_SETSIZE];static unsigned ncpu;
static pthread_barrier_t ready,go,done;
static unsigned active_kernel;static int failed;
struct worker {
 int cpu,fail;unsigned id;pthread_t thread;
 float *fa,*fb,*out;double *da,*db;int8_t *qa,*qb;
 double fresult;uint32_t qresult;
};
static uint64_t now(void){struct timespec t;if(clock_gettime(CLOCK_MONOTONIC,&t))abort();return (uint64_t)t.tv_sec*1000000000+t.tv_nsec;}
static void *allocate(size_t bytes){void *p=0;if(posix_memalign(&p,64,bytes))abort();memset(p,0xa5,bytes);return p;}
static int ax(unsigned id,unsigned i){return (int)((i*7+id*3)%31)-15;}
static int bx(unsigned id,unsigned i){return (int)((i*11+id*5)%17)-8;}
static int qx(unsigned id,unsigned i){return (int)((i*13+id*7)%256)-128;}
static int qy(unsigned id,unsigned i){return (int)((i*19+id*11)%256)-128;}
static void invoke(struct worker*w,unsigned k){
 if(k==0)scaling_fp32(w->out,w->fa,w->fb,N);
 else if(k==1)w->fresult=scaling_fp64(w->da,w->db,N);
 else w->qresult=scaling_q8(w->qa,w->qb,N);
}
static void *run(void *p){struct worker*w=p;cpu_set_t set;CPU_ZERO(&set);CPU_SET(w->cpu,&set);
 if(sched_setaffinity(0,sizeof(set),&set)||sched_getcpu()!=w->cpu)w->fail=1;
 for(unsigned g=0;g<ROUNDS*3;++g){
  pthread_barrier_wait(&ready);unsigned k=active_kernel;
  invoke(w,k);pthread_barrier_wait(&go);
  for(unsigned i=0;i<ITERATIONS;++i)invoke(w,k);
  if(sched_getcpu()!=w->cpu)w->fail=1;
  pthread_barrier_wait(&done);
 }
 return 0;
}
static unsigned check(struct worker*w){
 int64_t fsum=0;uint32_t qsum=0;unsigned checks=0;
 for(unsigned i=0;i<N;++i){int a=ax(w->id,i),b=bx(w->id,i),q=qx(w->id,i),r=qy(w->id,i);
  float expected=(float)(a*b+3);uint32_t x,y;memcpy(&x,&expected,4);memcpy(&y,w->out+i,4);
  if(x!=y||w->fa[i]!=a||w->fb[i]!=b||w->da[i]!=a||w->db[i]!=b||w->qa[i]!=q||w->qb[i]!=r)w->fail=1;
  fsum+=(int64_t)a*b;qsum+=(uint32_t)(q*r);checks+=7;
 }
 if(w->fresult!=(double)fsum||w->qresult!=qsum)w->fail=1;checks+=2;
 /* Each allocation includes a complete untouched 64-byte trailing guard. */
 void *p[]={w->fa,w->fb,w->out,w->da,w->db,w->qa,w->qb};size_t sizes[]={N*4,N*4,N*4,N*8,N*8,N,N};
 for(unsigned j=0;j<7;++j)for(unsigned i=0;i<64;++i){if(((unsigned char*)p[j])[sizes[j]+i]!=0xa5)w->fail=1;++checks;}
 return checks;
}
static void discover(void){
 cpu_set_t allowed;if(sched_getaffinity(0,sizeof(allowed),&allowed))abort();
 FILE*f=fopen("/proc/cpuinfo","r");if(!f)abort();char line[256];struct cpu c={-1,-1,-1};
 while(fgets(line,sizeof(line),f)){
  int v;if(sscanf(line,"processor : %d",&v)==1){c.id=v;c.core=c.package=-1;}
  else if(sscanf(line,"physical id : %d",&v)==1)c.package=v;
  else if(sscanf(line,"core id : %d",&v)==1)c.core=v;
  else if(line[0]=='\n'&&c.id>=0){if(c.id<CPU_SETSIZE&&CPU_ISSET(c.id,&allowed)){if(c.core<0||c.package<0)abort();cpus[ncpu++]=c;}c.id=-1;}
 }
 fclose(f);if(ncpu<2)abort();
 for(unsigned i=0;i<ncpu;++i)printf("CPU id=%d core=%d package=%d\n",cpus[i].id,cpus[i].core,cpus[i].package);
}
static uint64_t total_checks;
static void measure(const char*layout,unsigned cores,unsigned siblings,int ids[MAX_WORKERS],unsigned count){
 struct worker*w=calloc(count,sizeof(*w));if(!w)abort();
 if(pthread_barrier_init(&ready,0,count+1)||pthread_barrier_init(&go,0,count+1)||pthread_barrier_init(&done,0,count+1))abort();
 for(unsigned j=0;j<count;++j){struct worker*x=w+j;x->cpu=ids[j];x->id=j;
  x->fa=allocate(N*4+64);x->fb=allocate(N*4+64);x->out=allocate(N*4+64);x->da=allocate(N*8+64);x->db=allocate(N*8+64);x->qa=allocate(N+64);x->qb=allocate(N+64);
  for(unsigned i=0;i<N;++i){x->fa[i]=x->da[i]=ax(j,i);x->fb[i]=x->db[i]=bx(j,i);x->qa[i]=qx(j,i);x->qb[i]=qy(j,i);}
  printf("AFFINITY profile=%s layout=%s workers=%u worker=%u cpu=%d\n",PROFILE,layout,count,j,ids[j]);
  if(pthread_create(&x->thread,0,run,x))abort();
 }
 /* Reverse kernel order on alternate rounds; all workers perform the same
    amount of independent work. Creation, warm-up and checking are untimed. */
 for(unsigned r=0;r<ROUNDS;++r)for(unsigned k=0;k<3;++k){
  active_kernel=r&1?2-k:k;
  pthread_barrier_wait(&ready);uint64_t start=now();pthread_barrier_wait(&go);
  pthread_barrier_wait(&done);uint64_t elapsed=now()-start;
  printf("TIMING profile=%s layout=%s cores=%u siblings=%u workers=%u kernel=%u round=%u n=%u iterations=%u ns=%llu\n",PROFILE,layout,cores,siblings,count,active_kernel,r,N,ITERATIONS,(unsigned long long)elapsed);
 }
 for(unsigned j=0;j<count;++j){pthread_join(w[j].thread,0);total_checks+=check(w+j);if(w[j].fail){printf("FAIL worker=%u cpu=%d\n",j,w[j].cpu);failed=1;}
  free(w[j].fa);free(w[j].fb);free(w[j].out);free(w[j].da);free(w[j].db);free(w[j].qa);free(w[j].qb);
 }
 free(w);pthread_barrier_destroy(&ready);pthread_barrier_destroy(&go);pthread_barrier_destroy(&done);
}
int main(void){
 discover();struct utsname u;if(uname(&u))abort();
 int housekeeping=cpus[0].id,housecore=cpus[0].core,housepackage=cpus[0].package;
 cpu_set_t set;CPU_ZERO(&set);CPU_SET(housekeeping,&set);if(sched_setaffinity(0,sizeof(set),&set))abort();
 struct cpu groups[MAX_WORKERS][4];unsigned sizes[MAX_WORKERS]={0},cores=0;
 for(unsigned i=0;i<ncpu;++i){struct cpu c=cpus[i];if(c.core==housecore&&c.package==housepackage)continue;unsigned j;
  for(j=0;j<cores;++j)if(groups[j][0].core==c.core&&groups[j][0].package==c.package)break;
  if(j==cores)++cores;if(cores>MAX_WORKERS||sizes[j]>=4)abort();groups[j][sizes[j]++]=c;
 }
 if(cores!=59)abort();for(unsigned i=0;i<cores;++i)if(sizes[i]!=4)abort();
 printf("CONFIG profile=%s system=%s release=%s allowed_cpus=%u worker_cores=%u housekeeping_cpu=%d housekeeping_core=%d bytes_per_worker=%u rounds=%u scaling=weak\n",PROFILE,u.sysname,u.release,ncpu,cores,housekeeping,housecore,N*30+7*64,ROUNDS);
 int ids[MAX_WORKERS];unsigned counts[]={1,2,4,8,16,32,59};
 for(unsigned c=0;c<sizeof(counts)/sizeof(counts[0]);++c){for(unsigned i=0;i<counts[c];++i)ids[i]=groups[i][0].id;measure("spread",counts[c],1,ids,counts[c]);}
 for(unsigned s=2;s<=4;++s){for(unsigned i=0;i<cores;++i)for(unsigned j=0;j<s;++j)ids[i*s+j]=groups[i][j].id;measure("full",cores,s,ids,cores*s);}
 for(unsigned s=2;s<=4;s+=2){for(unsigned j=0;j<s;++j)ids[j]=groups[0][j].id;measure("siblings",1,s,ids,s);}
 printf("%s thread scaling: profile=%s layouts=12 kernels=3 rounds=%u exact_checks=%llu independent_buffers=yes\n",failed?"FAIL":"PASS",PROFILE,ROUNDS,(unsigned long long)total_checks);return failed;
}
