#include <stdint.h>
#include <stdio.h>
#include <limits.h>
#include <pthread.h>
extern uint64_t knc_mix(uint64_t, uint32_t);
extern uint64_t knc_sum(const uint32_t *, unsigned long);
extern uint64_t knc_atomic(uint64_t *, uint64_t);
extern int64_t knc_choose(int64_t, int64_t);
static uint64_t ref(uint64_t x, uint32_t n) {
    while (n--) { x ^= x >> 12; x ^= x << 25; x ^= x >> 27; x *= UINT64_C(0x2545f4914f6cdd1d); }
    return x;
}
static uint64_t counter;
static void *worker(void *p) {
    unsigned i; (void)p;
    for(i=0;i<10000;i++) knc_atomic(&counter,1);
    return 0;
}
int main(void) {
    uint32_t data[1024]; uint64_t sum=0; unsigned i,j;
    const int64_t values[] = {INT64_MIN,-100,-1,0,1,100,INT64_MAX};
    pthread_t t[4];
    for(i=0;i<1024;i++) {data[i]=i*1234567U;sum+=data[i];}
    if(knc_sum(data,1024)!=sum || knc_sum(data,0)!=0) return 1;
    for(i=0;i<100;i++) if(knc_mix(i,33)!=ref(i,33) || knc_mix(i,0)!=i) return 2;
    for(i=0;i<7;i++) for(j=0;j<7;j++) if(knc_choose(values[i],values[j])!=(values[i]<values[j]?values[i]:values[j])) return 3;
    for(i=0;i<4;i++) if(pthread_create(&t[i],0,worker,0)) return 4;
    for(i=0;i<4;i++) if(pthread_join(t[i],0)) return 5;
    if(counter!=40000) return 6;
    printf("PASS Rust KNC: slices, integer arithmetic, control flow, C ABI, atomics across 4 threads; sum=%llu counter=%llu\n", (unsigned long long)sum,(unsigned long long)counter);
    return 0;
}
