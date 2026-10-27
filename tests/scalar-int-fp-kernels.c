#include <stdint.h>
#include <string.h>
#ifndef CAST_PREFIX
#define CAST_PREFIX native_
#endif
#define JOIN_(a,b) a##b
#define JOIN(a,b) JOIN_(a,b)
#define NAME(n) JOIN(CAST_PREFIX,n)
#define CASTS(tag,type) \
    float NAME(tag##_f32)(type x) { return (float)x; } \
    double NAME(tag##_f64)(type x) { return (double)x; }
CASTS(s8,int8_t)
CASTS(u8,uint8_t)
CASTS(s16,int16_t)
CASTS(u16,uint16_t)
CASTS(s32,int32_t)
CASTS(u32,uint32_t)
typedef int32_t i32x16 __attribute__((ext_vector_type(16)));
typedef uint32_t u32x16 __attribute__((ext_vector_type(16)));
float NAME(reduce_f32)(const int32_t * x) {
    i32x16 v;
    memcpy(&v, x, sizeof(v));
    return (float)__builtin_reduce_add(v);
}
float NAME(lane7_f32)(const uint32_t * x) {
    u32x16 v;
    memcpy(&v, x, sizeof(v));
    return (float)v[7];
}
