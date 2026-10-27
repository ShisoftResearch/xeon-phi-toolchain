#define _GNU_SOURCE
#include "ggml-cpu.h"
#include "ggml-cpu/quants.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/mman.h>
#include <unistd.h>

typedef void (*dot_fn)(int, float *, size_t, const void *, size_t, const void *, size_t, int);
#define DECLARE_ORACLE(name) extern void oracle_##name(int, float *, size_t, const void *, size_t, const void *, size_t, int)
DECLARE_ORACLE(ggml_vec_dot_q4_1_q8_1_generic);
DECLARE_ORACLE(ggml_vec_dot_q5_K_q8_K_generic);
DECLARE_ORACLE(ggml_vec_dot_q6_K_q8_K_generic);

extern void llvm_oracle_ggml_vec_dot_q4_0_q8_0(int, float *, size_t, const void *, size_t, const void *, size_t, int);
extern void llvm_oracle_ggml_vec_dot_q4_1_q8_1(int, float *, size_t, const void *, size_t, const void *, size_t, int);
extern void llvm_oracle_ggml_vec_dot_q5_K_q8_K(int, float *, size_t, const void *, size_t, const void *, size_t, int);
extern void llvm_oracle_ggml_vec_dot_q6_K_q8_K(int, float *, size_t, const void *, size_t, const void *, size_t, int);
static float half_value(uint16_t h) {
    const int e = (h >> 10) & 31, m = h & 1023;
    float v = ldexpf((float)(e ? m + 1024 : m), e ? e - 25 : -24);
    return h & 0x8000 ? -v : v;
}
static uint32_t seed = 0x6718abcd;
static uint32_t next(void) { seed ^= seed << 13; seed ^= seed >> 17; seed ^= seed << 5; return seed; }
static uint32_t bits(float f) { uint32_t u; memcpy(&u, &f, 4); return u; }
static uint64_t checksum(const void * p, size_t n) {
    uint64_t h = 1469598103934665603ULL;
    for (size_t i = 0; i < n; ++i) h = (h ^ ((const uint8_t *)p)[i]) * 1099511628211ULL;
    return h;
}

int main(void) {
    ggml_cpu_init();
    if (!ggml_k1om_quants_supported(true) || !ggml_k1om_kquants_supported()) return 2;
    const size_t page = sysconf(_SC_PAGESIZE), capacity = page * 2;
    uint8_t * buffers[2];
    for (int i = 0; i < 2; ++i) {
        buffers[i] = mmap(0, page * 4, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (buffers[i] == MAP_FAILED || mprotect(buffers[i] + page, capacity, PROT_READ | PROT_WRITE)) return 3;
    }
    const unsigned lengths[] = {0, 1, 2, 3, 7, 16};
    const uint16_t half[] = {0, 0x8000, 1, 0x8001, 0x0400, 0x2400, 0x3c00, 0xbc00, 0x4000};
    const size_t sizes_x[] = {sizeof(block_q4_1), sizeof(block_q5_K), sizeof(block_q6_K)};
    const size_t sizes_y[] = {sizeof(block_q8_1), sizeof(block_q8_K), sizeof(block_q8_K)};
    const dot_fn native[] = {ggml_vec_dot_q4_1_q8_1, ggml_vec_dot_q5_K_q8_K, ggml_vec_dot_q6_K_q8_K};
    const dot_fn oracle[] = {oracle_ggml_vec_dot_q4_1_q8_1_generic, oracle_ggml_vec_dot_q5_K_q8_K_generic, oracle_ggml_vec_dot_q6_K_q8_K_generic};
    const dot_fn baseline[] = {llvm_oracle_ggml_vec_dot_q4_1_q8_1, llvm_oracle_ggml_vec_dot_q5_K_q8_K, llvm_oracle_ggml_vec_dot_q6_K_q8_K};
    unsigned rows = 0, sdk_rounding_differences = 0;
    for (unsigned kind = 0; kind < 3; ++kind) {
        for (unsigned l = 0; l < sizeof(lengths)/sizeof(lengths[0]); ++l) {
            const unsigned nb = lengths[l];
            const size_t sx = nb * sizes_x[kind], sy = nb * sizes_y[kind];
            if (sx > capacity || sy > capacity) return 4;
            for (unsigned pos = 0; pos < 34; ++pos) {
                uint8_t * x = buffers[0] + page + (pos < 32 ? 128 + pos * 4 : pos == 32 ? 0 : capacity - sx);
                uint8_t * y = buffers[1] + page + (pos < 32 ? 128 + ((pos * 7) % 32) * 4 : pos == 32 ? 0 : capacity - sy);
                for (unsigned trial = 0; trial < 64; ++trial) {
                    for (size_t i = 0; i < sx; ++i) x[i] = trial < 4 ? (uint8_t[]){0,255,128,127}[trial] : next();
                    for (size_t i = 0; i < sy; ++i) y[i] = trial < 4 ? (uint8_t[]){0,255,128,127}[trial] : next();
                    for (unsigned b = 0; b < nb; ++b) {
                        if (kind == 0) {
                            block_q4_1 * a = (block_q4_1 *)x; block_q8_1 * v = (block_q8_1 *)y;
                            a[b].d = half[(trial + b) % 9]; a[b].m = half[(trial + b + 3) % 9];
                            v[b].d = half[(trial + b + 5) % 9]; v[b].s = half[(trial + b + 7) % 9];
                        } else {
                            block_q8_K * v = (block_q8_K *)y;
                            v[b].d = ldexpf(1.0f, (int)((trial + b) % 8) - 6);
                            for (int j = 0; j < 16; ++j) {
                                int sum = 0;
                                for (int k = 0; k < 16; ++k) sum += v[b].qs[j * 16 + k];
                                v[b].bsums[j] = sum;
                            }
                            if (kind == 1) {
                                block_q5_K * a = (block_q5_K *)x;
                                a[b].d = half[(trial + b) % 9]; a[b].dmin = half[(trial + b + 3) % 9];
                            } else ((block_q6_K *)x)[b].d = half[(trial + b) % 9];
                        }
                    }
                    // Bound independent SDK-vs-LLVM rounding by a conservative
                    // forward-error bound, rather than relative error near cancellation.
                    double magnitude = 0;
                    for (unsigned b = 0; b < nb; ++b) {
                        if (kind == 0) {
                            block_q4_1 * a = (block_q4_1 *)x; block_q8_1 * v = (block_q8_1 *)y;
                            magnitude += fabs((double)half_value(a[b].d) * half_value(v[b].d)) * 15 * 128 * 32
                                + fabs((double)half_value(a[b].m) * half_value(v[b].s));
                        } else if (kind == 1) {
                            block_q5_K * a = (block_q5_K *)x; block_q8_K * v = (block_q8_K *)y;
                            magnitude += fabs((double)half_value(a[b].d) * v[b].d) * 31 * 128 * 63 * 256
                                + fabs((double)half_value(a[b].dmin) * v[b].d) * 2048 * 63 * 16;
                        } else {
                            block_q6_K * a = (block_q6_K *)x; block_q8_K * v = (block_q8_K *)y;
                            magnitude += fabs((double)half_value(a[b].d) * v[b].d) * 32 * 128 * 128 * 256;
                        }
                    }
                    uint64_t hx = checksum(x, sx), hy = checksum(y, sy);
                    struct { uint32_t before; float value; uint32_t after; } out = {0x12345678, -999, 0x87654321};
                    float expected = -888, sdk = -777;
                    baseline[kind](nb * (kind ? 256 : 32), &expected, 0, x, 0, y, 0, 1);
                    oracle[kind](nb * (kind ? 256 : 32), &sdk, 0, x, 0, y, 0, 1);
                    native[kind](nb * (kind ? 256 : 32), &out.value, 0, x, 0, y, 0, 1);
                    if (bits(out.value) != bits(sdk)) ++sdk_rounding_differences;
                    if (fabs((double)out.value - sdk) > (nb * 16 + 32) * 0x1p-24 * magnitude) {
                        printf("FAIL SDK numerical comparison kind=%u blocks=%u got=%g SDK=%g\n", kind, nb, out.value, sdk);
                        return 6;
                    }
                    if (bits(out.value) != bits(expected)) {
                        printf("FAIL kind=%u blocks=%u position=%u trial=%u got=%08x expected=%08x\n", kind, nb, pos, trial, bits(out.value), bits(expected));
                        return 1;
                    }
                    if (hx != checksum(x, sx) || hy != checksum(y, sy) || out.before != 0x12345678 || out.after != 0x87654321) return 5;
                    ++rows;
                }
            }
        }
    }
    unsigned four_rows = 0;
    for (unsigned l = 0; l < sizeof(lengths)/sizeof(lengths[0]); ++l) {
        const unsigned nb = lengths[l];
        for (unsigned pos = 0; pos < 34; ++pos) {
            for (unsigned trial = 0; trial < 32; ++trial) {
                const size_t stride = nb * sizeof(block_q4_0) + 2 * (trial % 5);
                const size_t sx = stride * 3 + nb * sizeof(block_q4_0), sy = nb * sizeof(block_q8_0);
                uint8_t * x = buffers[0] + page + (pos < 32 ? 128 + pos * 2 : pos == 32 ? 0 : capacity - sx);
                block_q8_0 * y = (block_q8_0 *)(buffers[1] + page + (pos < 32 ? 128 + pos * 2 : pos == 32 ? 0 : capacity - sy));
                for (size_t i = 0; i < sx; ++i) x[i] = next();
                for (size_t i = 0; i < sy; ++i) ((uint8_t *)y)[i] = next();
                for (unsigned b = 0; b < nb; ++b) {
                    y[b].d = half[(trial + b) % 9];
                    for (unsigned r = 0; r < 4; ++r) ((block_q4_0 *)(x + r * stride))[b].d = half[(trial + b + r) % 9];
                }
                uint64_t hx = checksum(x, sx), hy = checksum(y, sy);
                struct { uint32_t before; float value[4]; uint32_t after; } out = {0x12345678, {0}, 0x87654321};
                ggml_k1om_q4_0_rows4(nb * 32, out.value, x, stride, y);
                for (unsigned r = 0; r < 4; ++r) {
                    float expected;
                    llvm_oracle_ggml_vec_dot_q4_0_q8_0(nb * 32, &expected, 0, x + r * stride, 0, y, 0, 1);
                    if (bits(out.value[r]) != bits(expected)) {
                        printf("FAIL Q4 rows4 blocks=%u position=%u trial=%u row=%u got=%08x expected=%08x\n", nb, pos, trial, r, bits(out.value[r]), bits(expected));
                        return 7;
                    }
                }
                if (hx != checksum(x, sx) || hy != checksum(y, sy) || out.before != 0x12345678 || out.after != 0x87654321) return 8;
                ++four_rows;
            }
        }
    }
    printf("PASS Q4_0 four-row reuse: %u strided groups, %u bit-exact output comparisons\n", four_rows, four_rows * 4);
#ifdef GGML_K1OM_MM_TILES
    unsigned tiles = 0;
    for (unsigned l = 0; l < sizeof(lengths)/sizeof(lengths[0]); ++l) {
        const unsigned nb = lengths[l];
        for (unsigned pos = 0; pos < 34; ++pos) {
            for (unsigned trial = 0; trial < 32; ++trial) {
                const size_t stride = nb * sizeof(block_q4_0) + 2 * (trial % 5);
                const size_t column_stride = nb * sizeof(block_q8_0) + 2 * (trial % 3);
                const size_t sx = stride * 3 + nb * sizeof(block_q4_0);
                const size_t sy = column_stride + nb * sizeof(block_q8_0);
                uint8_t * x = buffers[0] + page + (pos < 32 ? 128 + pos * 2 : pos == 32 ? 0 : capacity - sx);
                uint8_t * y = buffers[1] + page + (pos < 32 ? 128 + pos * 2 : pos == 32 ? 0 : capacity - sy);
                for (size_t i = 0; i < sx; ++i) x[i] = next();
                for (size_t i = 0; i < sy; ++i) y[i] = next();
                for (unsigned b = 0; b < nb; ++b) {
                    for (unsigned c = 0; c < 2; ++c) ((block_q8_0 *)(y + c * column_stride))[b].d = half[(trial + b + c) % 9];
                    for (unsigned rr = 0; rr < 4; ++rr) ((block_q4_0 *)(x + rr * stride))[b].d = half[(trial + b + rr) % 9];
                }
                uint64_t hx = checksum(x, sx), hy = checksum(y, sy);
                struct { uint32_t before; float value[8]; uint32_t after; } out = {0x12345678, {0}, 0x87654321};
                ggml_k1om_q4_0_rows4_cols2(nb * 32, out.value, x, stride, y, column_stride);
                for (unsigned c = 0; c < 2; ++c) {
                    for (unsigned rr = 0; rr < 4; ++rr) {
                        float expected;
                        llvm_oracle_ggml_vec_dot_q4_0_q8_0(nb * 32, &expected, 0, x + rr * stride, 0, y + c * column_stride, 0, 1);
                        if (bits(out.value[c * 4 + rr]) != bits(expected)) {
                            printf("FAIL Q4 tile blocks=%u position=%u trial=%u column=%u row=%u\n", nb, pos, trial, c, rr);
                            return 9;
                        }
                    }
                }
                if (hx != checksum(x, sx) || hy != checksum(y, sy) || out.before != 0x12345678 || out.after != 0x87654321) return 10;
                ++tiles;
            }
        }
    }
    printf("PASS Q4_0 two-column reuse: %u strided tiles, %u bit-exact output comparisons\n", tiles, tiles * 8);
#endif
    printf("PASS Q4_1/Q5_K/Q6_K native selectors and LLVM baseline bit equality + SDK scalar numerical oracle: %u rows (%u SDK rounding differences), guard pages, raw byte extremes, zero length, input/output guards\n", rows, sdk_rounding_differences);
    return 0;
}
