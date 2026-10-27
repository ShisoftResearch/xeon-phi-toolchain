#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern void select_i32(void *, const void *, const void *, int);
extern void select_f32(void *, const void *, const void *, int);
extern void select_i64(void *, const void *, const void *, int);
extern void select_f64(void *, const void *, const void *, int);
extern void splat_product_f32(void *, const void *, const void *);
extern void splat_product_f64(void *, const void *, const void *);

static uint64_t state = UINT64_C(0x83ab490de1617c05);
static uint64_t random_bits(void) {
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return state;
}

int main(void) {
    uint64_t a[8] __attribute__((aligned(64)));
    uint64_t b[8] __attribute__((aligned(64)));
    uint64_t out[8] __attribute__((aligned(64)));
    const int conditions[] = {0, 1, -1, 2, 65536, -2147483647 - 1, 2147483647};
    void (*selects[])(void *, const void *, const void *, int) = {
        select_i32, select_f32, select_i64, select_f64
    };
    uint64_t checks = 0;
    unsigned round, i, c, f;
    for (round = 0; round < 4096; ++round) {
        for (i = 0; i < 8; ++i) {
            a[i] = random_bits();
            b[i] = random_bits();
        }
        /* Include signed zero, infinities and NaN payloads as raw bits. */
        if (round == 0) {
            const uint64_t special[] = {0, UINT64_C(0x8000000000000000),
                UINT64_C(0x7ff0000000000000), UINT64_C(0xfff0000000000000),
                UINT64_C(0x7ff0000000000001), UINT64_C(0x7fc123457f800001),
                UINT64_C(0xff80000080000000), UINT64_MAX};
            memcpy(a, special, sizeof a);
        }
        for (f = 0; f < 4; ++f) {
            for (c = 0; c < sizeof conditions / sizeof conditions[0]; ++c) {
                memset(out, 0x5a, sizeof out);
                selects[f](out, a, b, conditions[c]);
                const uint64_t *expected = conditions[c] ? a : b;
                for (i = 0; i < 8; ++i) {
                    ++checks;
                    if (out[i] != expected[i]) {
                        printf("FAIL vector select round=%u type=%u condition=%d word=%u\n",
                               round, f, conditions[c], i);
                        return 1;
                    }
                }
            }
        }
        float af[16] __attribute__((aligned(64)));
        float bf[16] __attribute__((aligned(64)));
        float rf[16] __attribute__((aligned(64)));
        double ad[8] __attribute__((aligned(64)));
        double bd[8] __attribute__((aligned(64)));
        double rd[8] __attribute__((aligned(64)));
        for (i = 0; i < 16; ++i) {
            af[i] = (int)(random_bits() % 2049) - 1024;
            bf[i] = (int)(random_bits() % 2049) - 1024;
        }
        for (i = 0; i < 8; ++i) {
            ad[i] = (int)(random_bits() % 65537) - 32768;
            bd[i] = (int)(random_bits() % 65537) - 32768;
        }
        splat_product_f32(rf, af, bf);
        splat_product_f64(rd, ad, bd);
        for (i = 0; i < 16; ++i) {
            ++checks;
            if (rf[i] != af[0] * bf[0]) {
                printf("FAIL f32 product splat round=%u lane=%u\n", round, i);
                return 1;
            }
        }
        for (i = 0; i < 8; ++i) {
            ++checks;
            if (rd[i] != ad[0] * bd[0]) {
                printf("FAIL f64 product splat round=%u lane=%u\n", round, i);
                return 1;
            }
        }
    }
    printf("PASS vector select and legal FP product splats: %llu checks\n",
           (unsigned long long)checks);
    return 0;
}
