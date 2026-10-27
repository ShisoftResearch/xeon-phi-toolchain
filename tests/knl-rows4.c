#define _GNU_SOURCE
#include "ggml-cpu.h"
#include "ggml-cpu/quants.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

static uint32_t seed = 0x61af47;
static uint32_t next(void) { seed ^= seed << 13; seed ^= seed >> 17; seed ^= seed << 5; return seed; }
int main(void) {
    ggml_cpu_init();
    const size_t page = sysconf(_SC_PAGESIZE), capacity = page * 8;
    uint8_t * mem[2];
    for (int i = 0; i < 2; ++i) {
        mem[i] = mmap(0, capacity + 2 * page, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (mem[i] == MAP_FAILED || mprotect(mem[i] + page, capacity, PROT_READ | PROT_WRITE)) return 2;
    }
    const unsigned lengths[] = {0,1,2,3,7,16,32,128};
    const uint16_t halves[] = {0,0x8000,1,0x8001,0x0400,0x2400,0x3c00,0xbc00,0x4000};
    unsigned checks = 0;
    for (unsigned len = 0; len < sizeof(lengths)/sizeof(lengths[0]); ++len) {
        unsigned nb = lengths[len];
        for (unsigned pos = 0; pos < 34; ++pos) {
            for (unsigned trial = 0; trial < 32; ++trial) {
                size_t stride = nb * sizeof(block_q4_0) + 2 * (trial % 5);
                size_t sx = stride * 3 + nb * sizeof(block_q4_0), sy = nb * sizeof(block_q8_0);
                uint8_t * x = mem[0] + page + (pos < 32 ? 128 + pos * 2 : pos == 32 ? 0 : capacity - sx);
                block_q8_0 * y = (block_q8_0 *)(mem[1] + page + (pos < 32 ? 128 + pos * 2 : pos == 32 ? 0 : capacity - sy));
                for (size_t i = 0; i < sx; ++i) x[i] = trial < 4 ? (uint8_t[]){0,255,128,127}[trial] : next();
                for (size_t i = 0; i < sy; ++i) ((uint8_t *)y)[i] = trial < 4 ? (uint8_t[]){0,255,128,127}[trial] : next();
                for (unsigned b = 0; b < nb; ++b) {
                    y[b].d = halves[(trial + b) % 9];
                    for (unsigned rr = 0; rr < 4; ++rr) ((block_q4_0 *)(x + rr * stride))[b].d = halves[(trial + b + rr) % 9];
                }
                struct { uint32_t before; float values[4]; uint32_t after; } out = {0x12345678, {0}, 0x87654321};
                ggml_knl_q4_0_rows4(nb * 32, out.values, x, stride, y);
                for (unsigned rr = 0; rr < 4; ++rr) {
                    float expected;
                    ggml_vec_dot_q4_0_q8_0(nb * 32, &expected, 0, x + rr * stride, 0, y, 0, 1);
                    if (memcmp(&expected, &out.values[rr], sizeof(float))) {
                        printf("FAIL blocks=%u offset=%u trial=%u row=%u\n",nb,pos,trial,rr); return 1;
                    }
                    ++checks;
                }
                if (out.before != 0x12345678 || out.after != 0x87654321) return 3;
            }
        }
    }
    printf("PASS KNL rows4: %u bit-exact AVX2 output comparisons; guard pages, offsets, strides, byte extremes and zero length\n", checks);
}
