#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <fenv.h>
#define DECLARE(tag,type) \
    extern float native_##tag##_f32(type); extern double native_##tag##_f64(type); \
    extern float before_##tag##_f32(type); extern double before_##tag##_f64(type);
DECLARE(s8,int8_t)
DECLARE(u8,uint8_t)
DECLARE(s16,int16_t)
DECLARE(u16,uint16_t)
DECLARE(s32,int32_t)
DECLARE(u32,uint32_t)
extern float native_reduce_f32(const int32_t *), before_reduce_f32(const int32_t *);
extern float native_lane7_f32(const uint32_t *), before_lane7_f32(const uint32_t *);
static uint64_t checks;
static uint32_t bits32(float f) { uint32_t u; memcpy(&u,&f,4); return u; }
static uint64_t bits64(double f) { uint64_t u; memcpy(&u,&f,8); return u; }
// Independent integer-only IEEE RNE oracle; no FP conversions in the oracle.
static uint32_t ref32(uint32_t raw, int sign) {
    uint32_t negative = sign && (raw >> 31), mag = negative ? 0u - raw : raw;
    if (!mag) return 0;
    unsigned e = 31 - __builtin_clz(mag);
    uint32_t sig;
    if (e <= 23) sig = mag << (23 - e);
    else {
        unsigned shift = e - 23;
        sig = mag >> shift;
        uint32_t tail = mag & ((1u << shift) - 1), half = 1u << (shift - 1);
        if (tail > half || (tail == half && (sig & 1))) ++sig;
        if (sig == 0x1000000) { sig >>= 1; ++e; }
    }
    return (negative << 31) | ((e + 127) << 23) | (sig & 0x7fffff);
}
static uint64_t ref64(uint32_t raw, int sign) {
    uint32_t negative = sign && (raw >> 31), mag = negative ? 0u - raw : raw;
    if (!mag) return 0;
    unsigned e = 31 - __builtin_clz(mag);
    return ((uint64_t)negative << 63) | ((uint64_t)(e + 1023) << 52) |
        (((uint64_t)mag << (52 - e)) & 0xfffffffffffffULL);
}
static int check(const char * label, uint64_t got, uint64_t expected) {
    ++checks;
    if (got == expected) return 0;
    printf("FAIL %s got=%016llx expected=%016llx\n",label,(unsigned long long)got,(unsigned long long)expected);
    return 1;
}
#define CHECK(tag,type,value,raw,sign) do { \
    type v = (type)(value); \
    if (check("native_" #tag "_f32",bits32(native_##tag##_f32(v)),ref32(raw,sign)) || \
        check("before_" #tag "_f32",bits32(before_##tag##_f32(v)),ref32(raw,sign)) || \
        check("native_" #tag "_f64",bits64(native_##tag##_f64(v)),ref64(raw,sign)) || \
        check("before_" #tag "_f64",bits64(before_##tag##_f64(v)),ref64(raw,sign))) return 1; \
} while (0)
static int check32(uint32_t raw) {
    CHECK(s32,int32_t,raw,raw,1);
    CHECK(u32,uint32_t,raw,raw,0);
    return 0;
}
int main(void) {
    if (fesetround(FE_TONEAREST)) return 2;
    for (uint32_t u = 0; u < 256; ++u) {
        CHECK(s8,int8_t,u,(uint32_t)(int32_t)(int8_t)u,1);
        CHECK(u8,uint8_t,u,u,0);
    }
    for (uint32_t u = 0; u < 65536; ++u) {
        CHECK(s16,int16_t,u,(uint32_t)(int32_t)(int16_t)u,1);
        CHECK(u16,uint16_t,u,u,0);
    }
    for (unsigned e = 0; e < 32; ++e) for (int d = -64; d <= 64; ++d) {
        uint32_t raw = (uint32_t)((1ULL << e) + d);
        if (check32(raw) || check32(0u - raw)) return 1;
    }
    uint32_t state = 0x7438ab21;
    for (unsigned i = 0; i < 131072; ++i) {
        state ^= state << 13; state ^= state >> 17; state ^= state << 5;
        if (check32(state)) return 1;
    }
    for (unsigned trial = 0; trial < 4096; ++trial) {
        uint32_t v[16], sum = 0;
        for (unsigned j = 0; j < 16; ++j) {
            state ^= state << 13; state ^= state >> 17; state ^= state << 5;
            v[j] = state; sum += v[j];
        }
        if (check("native reduction",bits32(native_reduce_f32((int32_t *)v)),ref32(sum,1)) ||
            check("before reduction",bits32(before_reduce_f32((int32_t *)v)),ref32(sum,1)) ||
            check("native lane7",bits32(native_lane7_f32(v)),ref32(v[7],0)) ||
            check("before lane7",bits32(before_lane7_f32(v)),ref32(v[7],0))) return 1;
    }
    printf("PASS scalar integer-to-FP: %llu bit-exact checks; exhaustive 8/16-bit inputs, 32-bit powers/ties/extremes/random, native versus software plus integer-only RNE oracle, reduction/lane ABI\n",(unsigned long long)checks);
    return 0;
}
