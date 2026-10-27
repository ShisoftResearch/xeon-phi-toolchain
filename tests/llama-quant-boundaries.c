#define _GNU_SOURCE
#include "ggml-cpu.h"
#include "ggml-cpu/quants.h"
#include <fenv.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

static uint32_t state = 0x824379ab;
static uint32_t random_bits(void) {
    state ^= state << 13;
    state ^= state >> 17;
    state ^= state << 5;
    return state;
}
static uint32_t raw(float x) {
    uint32_t u;
    memcpy(&u, &x, sizeof u);
    return u;
}
static float half_power(uint16_t bits) {
    unsigned exponent = (bits >> 10) & 31, mantissa = bits & 1023;
    float value = ldexpf((float)(exponent ? mantissa + 1024 : mantissa), exponent ? (int)exponent - 25 : -24);
    return bits & 0x8000 ? -value : value;
}
static uint64_t checksum(const void *data, size_t n) {
    const uint8_t *p = data;
    uint64_t h = 1469598103934665603ULL;
    for (size_t i = 0; i < n; ++i) h = (h ^ p[i]) * 1099511628211ULL;
    return h;
}
int main(void) {
    if (fesetround(FE_TONEAREST)) return 1;
    ggml_cpu_init();
    if (!ggml_k1om_quants_supported(false) || !ggml_k1om_quants_supported(true)) {
        puts("FAIL native Q4/Q8 requirement selection");
        return 1;
    }
    size_t page = (size_t)sysconf(_SC_PAGESIZE), capacity = page * 2;
    uint8_t *memory[3];
    for (unsigned i = 0; i < 3; ++i) {
        memory[i] = mmap(NULL, page * 4, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (memory[i] == MAP_FAILED || mprotect(memory[i] + page, capacity, PROT_READ | PROT_WRITE)) return 1;
    }
    const unsigned lengths[] = {0, 1, 2, 3, 7, 16, 31, 64, 127};
    const uint16_t scales[] = {0, 0x8000, 0x3c00, 0xbc00, 1, 0x8001, 0x0400, 0x4000, 0xc000, 0x7800};
    unsigned rows = 0, checks = 0;
    for (unsigned l = 0; l < sizeof lengths / sizeof lengths[0]; ++l) {
        unsigned nb = lengths[l], trials = nb == 1 ? 256 : 64;
        size_t sx = nb * sizeof(block_q4_0), sy = nb * sizeof(block_q8_0);
        if (sx > capacity || sy > capacity) return 1;
        for (unsigned position = 0; position < 34; ++position) {
            size_t ox = position < 32 ? 128 + position * 2 : position == 32 ? 0 : capacity - sx;
            size_t oy = position < 32 ? 128 + ((position * 7) % 32) * 2 : position == 32 ? 0 : capacity - sy;
            block_q4_0 *x = (block_q4_0 *)(memory[0] + page + ox);
            block_q8_0 *y = (block_q8_0 *)(memory[1] + page + oy);
            block_q8_0 *z = (block_q8_0 *)(memory[2] + page + oy);
            for (unsigned trial = 0; trial < trials; ++trial) {
                float expected4 = 0, expected8 = 0;
                for (unsigned b = 0; b < nb; ++b) {
                    x[b].d = scales[(trial + b) % 10];
                    y[b].d = scales[(trial * 3 + b + 2) % 10];
                    z[b].d = scales[(trial * 7 + b + 4) % 10];
                    for (unsigned k = 0; k < 16; ++k) x[b].qs[k] = (uint8_t)(trial + k * 17 + b);
                    for (unsigned k = 0; k < 32; ++k) {
                        y[b].qs[k] = nb == 1 ? (int8_t)(uint8_t)(trial + k * 13) : (int8_t)(uint8_t)random_bits();
                        z[b].qs[k] = nb == 1 ? (int8_t)(uint8_t)(trial * 3 + k * 29) : (int8_t)(uint8_t)random_bits();
                    }
                    int32_t sum4 = 0, sum8 = 0;
                    for (unsigned k = 0; k < 16; ++k) {
                        sum4 += ((int)(x[b].qs[k] & 15) - 8) * y[b].qs[k];
                        sum4 += ((int)(x[b].qs[k] >> 4) - 8) * y[b].qs[k + 16];
                    }
                    for (unsigned k = 0; k < 32; ++k) sum8 += (int32_t)z[b].qs[k] * y[b].qs[k];
                    float term4 = (float)sum4 * half_power(x[b].d);
                    term4 *= half_power(y[b].d);
                    expected4 += term4;
                    float scale8 = half_power(z[b].d) * half_power(y[b].d);
                    expected8 += (float)sum8 * scale8;
                }
                uint64_t before[3] = {checksum(x, sx), checksum(y, sy), checksum(z, sy)};
                struct guarded {uint64_t before; float value; uint32_t gap; uint64_t after;} out = {0x1234567812345678ULL, -123, 0x87654321U, 0xabcdef09abcdef09ULL};
                ggml_vec_dot_q4_0_q8_0(nb * 32, &out.value, 0, x, 0, y, 0, 1);
                if (raw(out.value) != raw(expected4)) {
                    printf("FAIL Q4 oracle blocks=%u position=%u trial=%u got=%08x expected=%08x\n", nb, position, trial, raw(out.value), raw(expected4));
                    return 1;
                }
                ggml_vec_dot_q8_0_q8_0(nb * 32, &out.value, 0, z, 0, y, 0, 1);
                if (raw(out.value) != raw(expected8)) {
                    printf("FAIL Q8 oracle blocks=%u position=%u trial=%u got=%08x expected=%08x\n", nb, position, trial, raw(out.value), raw(expected8));
                    return 1;
                }
                if (out.before != 0x1234567812345678ULL || out.after != 0xabcdef09abcdef09ULL || out.gap != 0x87654321U) return 1;
                if (before[0] != checksum(x, sx) || before[1] != checksum(y, sy) || before[2] != checksum(z, sy)) return 1;
                ++rows;
                checks += 6;
            }
        }
    }
    for (unsigned i = 0; i < 3; ++i) if (munmap(memory[i], page * 4)) return 1;
    printf("PASS native GGML quant blocks: rows=%u checks=%u; matcher selected Q4/Q8, SDK integer/power-of-two-scale oracle, legal struct alignments, page boundaries, zero length, unchanged inputs and output guards\n", rows, checks);
    return 0;
}
