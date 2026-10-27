#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <limits.h>
#include <math.h>
#include "fp-corpus.h"
struct pair {uint64_t a;int64_t b;};
struct large {uint64_t a[5];};
struct __attribute__((packed)) packed {uint8_t tag;uint64_t value;};
extern struct pair knc_pair(struct pair,uint64_t);
extern struct large knc_large(struct large);
extern struct packed knc_packed(struct packed);
extern uint64_t knc_callback(uint64_t(*)(uint64_t,uint64_t),uint64_t,uint64_t);
extern uint64_t knc_many(uint64_t,uint64_t,uint64_t,uint64_t,uint64_t,uint64_t,uint64_t,uint64_t,uint64_t,uint64_t);
extern uint64_t knc_bits(uint64_t,unsigned);
extern int64_t knc_div(int64_t,int64_t);
extern void knc_u128(uint64_t,uint64_t,uint64_t,uint64_t*);
extern void knc_memory(unsigned char*,const unsigned char*,unsigned long,unsigned);
extern uint64_t knc_cas(uint64_t*);
extern void knc_fp64(const uint64_t*,const uint64_t*,uint64_t*,unsigned);
extern void knc_fp32(const uint32_t*,const uint32_t*,uint32_t*,unsigned);
static uint64_t seed=1,counter;
static uint64_t next(void){seed^=seed<<13;seed^=seed>>7;seed^=seed<<17;return seed;}
static uint64_t cb(uint64_t a,uint64_t b){return (a^b)+123;}
static uint64_t rol(uint64_t x,unsigned n){n&=63;return n?((x<<n)|(x>>(64-n))):x;}
static uint64_t bits(uint64_t x,unsigned n){unsigned l=0,t=0,p=0,k;for(k=0;k<64;k++)p+=(x>>k)&1;while(l<64 && !((x>>(63-l))&1))l++;while(t<64 && !((x>>t)&1))t++;return rol(x,n)^rol(x,64-(n&63))^((uint64_t)l<<40)^((uint64_t)t<<32)^p;}
static void *worker(void*p){unsigned i;(void)p;for(i=0;i<2000;i++)knc_cas(&counter);return 0;}
#define CHECK(c,id) do{if(!(c)){printf("FAIL case=%d line=%d\n",id,__LINE__);return id;}}while(0)
int main(void){unsigned i,j,n;uint64_t a,b,out[3];pthread_t threads[8];
for(i=0;i<2000;i++){
 a=next();b=next();struct pair p={a,(int64_t)b/4},q=knc_pair(p,b);CHECK(q.a==a+b && q.b==p.b*-3,1);
 struct large l={{a,b,a^b,0,UINT64_MAX}},r=knc_large(l);for(j=0;j<5;j++)CHECK(r.a[j]==l.a[j]+j*17,2);
 struct packed pk={i,a},pr=knc_packed(pk);CHECK(pr.tag==(uint8_t)(pk.tag+1)&&pr.value==rol(a,13),3);
 CHECK(knc_callback(cb,a,b)==cb(a,b)+7,4);CHECK(knc_many(1,2,3,4,5,6,7,8,9,10)==385,5);
 CHECK(knc_bits(a,i)==bits(a,i),6);
 int64_t x=(int64_t)a,y=(int64_t)(b|1);CHECK(knc_div(x,y)==x/y,7);
 unsigned __int128 z=((unsigned __int128)a<<64)|b;uint64_t d=next()|1;knc_u128(a,b,d,out);CHECK(out[0]==(uint64_t)(z/d)&&out[1]==(uint64_t)((z/d)>>64)&&out[2]==(uint64_t)(z%d),8);
}
CHECK(knc_bits(0,0)==bits(0,0),9);CHECK(knc_div(INT64_MIN,-1)==INT64_MIN,10);
for(n=0;n<=128;n++){unsigned char a1[512],a2[512];for(i=0;i<512;i++)a1[i]=a2[i]=i;
 knc_memory(a1+17,a1+200,n,0);memcpy(a2+17,a2+200,n);CHECK(!memcmp(a1,a2,512),11);
 knc_memory(a1+19,a1+17,n,1);memmove(a2+19,a2+17,n);CHECK(!memcmp(a1,a2,512),12);
 knc_memory(a1+3,0,n,2);memset(a2+3,0xa5,n);CHECK(!memcmp(a1,a2,512),13);
}
for(i=0;i<8;i++)CHECK(!pthread_create(&threads[i],0,worker,0),14);for(i=0;i<8;i++)CHECK(!pthread_join(threads[i],0),15);CHECK(counter==16000,16);
puts("PASS expanded scalar: 2000 randomized ABI/arithmetic cases, packed/large structs, callbacks, 128-bit division, memory operations, 8-thread CAS contention");
for(i=0;i<sizeof(fp64_cases)/sizeof(fp64_cases[0]);i++){
 const struct fp64_case *c=&fp64_cases[i];uint64_t got;knc_fp64(&c->a,&c->b,&got,c->op);
 int ok=c->nan?((got&0x7ff0000000000000ULL)==0x7ff0000000000000ULL && (got&0xfffffffffffffULL)):got==c->expected;
 if(!ok)printf("FP64 case=%u op=%u a=%016llx b=%016llx got=%016llx expected=%016llx\n",i,c->op,(unsigned long long)c->a,(unsigned long long)c->b,(unsigned long long)got,(unsigned long long)c->expected);CHECK(ok,17);
}
for(i=0;i<sizeof(fp32_cases)/sizeof(fp32_cases[0]);i++){
 const struct fp32_case *c=&fp32_cases[i];uint32_t got;knc_fp32(&c->a,&c->b,&got,c->op);
 int ok=c->nan?((got&0x7f800000U)==0x7f800000U && (got&0x7fffffU)):got==c->expected;
 if(!ok)printf("FP32 case=%u op=%u a=%08x b=%08x got=%08x expected=%08x\n",i,c->op,c->a,c->b,got,c->expected);CHECK(ok,18);
}
puts("PASS Rust software f32/f64: 9072 exact-rational oracle cases including NaN, infinities, signed zero, subnormals and rounding boundaries");return 0;}
