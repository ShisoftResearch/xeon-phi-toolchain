/* SPDX-License-Identifier: MIT
 * Check parallel arithmetic against an exactly representable reference.
 */
#define _POSIX_C_SOURCE 200809L
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define ROUNDS 8
struct work {
    const double *a, *b;
    size_t begin, end;
    double sums[ROUNDS];
};

static void *worker(void *argument)
{
    struct work *w = argument;
    int round;
    for (round = 0; round < ROUNDS; ++round) {
        double sum = 0.0;
        size_t i;
        for (i = w->begin; i < w->end; ++i) sum += w->a[i] * w->b[i];
        w->sums[round] = sum;
    }
    return NULL;
}

static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec * 1e-9;
}

int main(int argc, char **argv)
{
    const size_t n = 2 * 1024 * 1024;
    double *a, *b, reference = 0.0;
    size_t i;
    long processors = sysconf(_SC_NPROCESSORS_ONLN);
    long threads = processors;
    int round, t, created = 0;
    pthread_t *ids;
    struct work *work;
    pthread_attr_t attr;
    double started;

    if (argc == 2) {
        char *end;
        threads = strtol(argv[1], &end, 10);
        if (*end || threads < 1 || threads > 1024) {
            fputs("Invalid thread count\n", stderr);
            return 2;
        }
    } else if (argc != 1) {
        fprintf(stderr, "Usage: %s [threads]\n", argv[0]);
        return 2;
    }
    if (threads < 1 || threads > 1024) return 2;
    ids = calloc(threads, sizeof(*ids));
    work = calloc(threads, sizeof(*work));
    if (!ids || !work) return 1;
    if (posix_memalign((void **)&a, 64, n * sizeof(*a)) ||
        posix_memalign((void **)&b, 64, n * sizeof(*b))) {
        fputs("Allocation failed\n", stderr);
        return 1;
    }
    for (i = 0; i < n; ++i) {
        a[i] = (i % 17) * 0.5;
        b[i] = (i % 13) * 0.25;
        reference += a[i] * b[i];
    }
    pthread_attr_init(&attr);
    pthread_attr_setstacksize(&attr, 128 * 1024);
    started = now();
    for (t = 0; t < threads; ++t) {
        int err;
        work[t].a = a;
        work[t].b = b;
        work[t].begin = n * t / threads;
        work[t].end = n * (t + 1) / threads;
        err = pthread_create(&ids[t], &attr, worker, &work[t]);
        if (err) {
            fprintf(stderr, "pthread_create failed: %d\n", err);
            break;
        }
        ++created;
    }
    pthread_attr_destroy(&attr);
    for (t = 0; t < created; ++t) pthread_join(ids[t], NULL);
    if (created != threads) return 1;
    for (round = 0; round < ROUNDS; ++round) {
        double sum = 0.0;
        for (t = 0; t < threads; ++t) sum += work[t].sums[round];
        if (sum != reference) {
            fprintf(stderr, "FAIL round %d: %.17g != %.17g\n", round, sum, reference);
            return 1;
        }
    }
    printf("PASS: 8 parallel dot products, %zu elements, threads=%ld, processors=%ld, %.3f seconds\n",
           n, threads, processors, now() - started);
    free(a);
    free(b);
    free(ids);
    free(work);
    return 0;
}
