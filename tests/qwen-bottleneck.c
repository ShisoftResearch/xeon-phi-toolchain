#define _GNU_SOURCE
#include "ggml-cpu.h"
#include "ggml-cpu/quants.h"
#include <pthread.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

typedef uint32_t v16u32 __attribute__((ext_vector_type(16)));
enum { N = 4096, GROUP_BYTES = 4 * (N/32) * sizeof(block_q4_0), MAX_THREADS = 240 };
static pthread_barrier_t ready, start, done;
static uint8_t * memory;
static block_q8_0 * activations;
static size_t size_bytes, groups_per_thread;
static int nthreads, cpus[MAX_THREADS], mode, passes;
static volatile uint32_t checksums[MAX_THREADS];
static int affinity_errors[MAX_THREADS];

static uint64_t ns(void) {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000ULL + t.tv_nsec;
}
static void * worker(void * arg) {
    const int id = (int)(intptr_t)arg;
    cpu_set_t set;
    CPU_ZERO(&set); CPU_SET(cpus[id], &set);
    affinity_errors[id] = pthread_setaffinity_np(pthread_self(), sizeof(set), &set);
    pthread_barrier_wait(&ready);
    pthread_barrier_wait(&start);
    uint32_t result = 0;
    if (mode == 0) {
        const size_t lines = size_bytes / 64;
        const size_t begin = lines * id / nthreads, end = lines * (id + 1) / nthreads;
        const volatile v16u32 * p = (const volatile v16u32 *)memory;
        v16u32 a = {0}, b = {0}, c = {0}, d = {0};
        for (int pass = 0; pass < passes; ++pass) {
            size_t i = begin;
            for (; i + 4 <= end; i += 4) { a ^= p[i]; b ^= p[i+1]; c ^= p[i+2]; d ^= p[i+3]; }
            for (; i < end; ++i) a ^= p[i];
        }
        result = __builtin_reduce_xor(a ^ b ^ c ^ d);
    } else {
        const block_q8_0 * y = activations + id * (N/32);
        const uint8_t * x = memory + id * groups_per_thread * GROUP_BYTES;
        for (int pass = 0; pass < passes; ++pass) {
            float out[4];
            const size_t group = mode == 1 ? 0 : (size_t)pass % groups_per_thread;
            ggml_k1om_q4_0_rows4(N, out, x + group * GROUP_BYTES, (N/32)*sizeof(block_q4_0), y);
            uint32_t bits;
            memcpy(&bits, &out[pass & 3], 4);
            result ^= bits;
        }
    }
    checksums[id] = result;
    pthread_barrier_wait(&done);
    return NULL;
}
int main(int argc, char ** argv) {
    if (argc != 2) return 2;
    char * token = strtok(argv[1], ",");
    while (token) {
        if (nthreads == MAX_THREADS) return 2;
        cpus[nthreads++] = atoi(token); token = strtok(NULL, ",");
    }
    if (!nthreads) return 2;
    ggml_cpu_init();
    if (!ggml_k1om_quants_supported(true)) return 3;
    groups_per_thread = (256ULL * 1024 * 1024) / GROUP_BYTES / nthreads;
    size_bytes = groups_per_thread * nthreads * GROUP_BYTES;
    if (posix_memalign((void **)&memory, 64, size_bytes) ||
        posix_memalign((void **)&activations, 64, nthreads * (N/32) * sizeof(block_q8_0))) return 4;
    uint32_t random = 0x71624bad;
    for (size_t i = 0; i < size_bytes / sizeof(block_q4_0); ++i) {
        block_q4_0 * x = (block_q4_0 *)memory + i;
        random = random * 1664525 + 1013904223;
        x->d = 0x1800 + (random % 0x2800);
        for (int j = 0; j < 16; ++j) { random = random * 1664525 + 1013904223; x->qs[j] = random >> 24; }
    }
    for (int i = 0; i < nthreads * (N/32); ++i) {
        activations[i].d = 0x2000 + (i % 0x1000);
        for (int j = 0; j < 32; ++j) { random = random * 1664525 + 1013904223; activations[i].qs[j] = random >> 24; }
    }
    for (mode = 0; mode < 3; ++mode) {
        passes = mode == 0 ? 128 : 6000;
        pthread_barrier_init(&ready, NULL, nthreads + 1);
        pthread_barrier_init(&start, NULL, nthreads + 1);
        pthread_barrier_init(&done, NULL, nthreads + 1);
        pthread_t threads[MAX_THREADS];
        pthread_attr_t attr; pthread_attr_init(&attr); pthread_attr_setstacksize(&attr, 256 * 1024);
        for (int i = 0; i < nthreads; ++i) if (pthread_create(&threads[i], &attr, worker, (void *)(intptr_t)i)) return 5;
        pthread_barrier_wait(&ready);
        const uint64_t begin = ns();
        pthread_barrier_wait(&start); pthread_barrier_wait(&done);
        const double seconds = (ns() - begin) / 1e9;
        uint32_t sum = 0;
        for (int i = 0; i < nthreads; ++i) {
            pthread_join(threads[i], NULL); if (affinity_errors[i]) return 6;
            sum ^= checksums[i];

        }
        const double payload = mode == 0 ? (double)size_bytes * passes : (double)GROUP_BYTES * passes * nthreads;
        printf("BOTTLENECK mode=%s threads=%d bytes=%zu seconds=%.6f payload_GBs=%.6f checksum=%u\n",
               (const char *[]){"stream_read", "q4_cache_resident", "q4_streaming"}[mode], nthreads, size_bytes, seconds,
               payload / seconds / 1e9, sum);
        fflush(stdout);
        pthread_barrier_destroy(&ready); pthread_barrier_destroy(&start); pthread_barrier_destroy(&done); pthread_attr_destroy(&attr);
    }
    free(memory); free(activations);
    return 0;
}
