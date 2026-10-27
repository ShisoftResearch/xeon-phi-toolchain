#include <stdint.h>
#include <string.h>
#ifndef PREFIX
#define PREFIX native_
#endif
#define CAT_(a,b) a##b
#define CAT(a,b) CAT_(a,b)
#define NAME(n) CAT(PREFIX,n)
typedef uint32_t v16u __attribute__((ext_vector_type(16)));
float NAME(add_f32)(const uint32_t *a, const uint32_t *b) {
    v16u x,y; memcpy(&x,a,64); memcpy(&y,b,64);
    return (float)(int32_t)(__builtin_reduce_add(x)+__builtin_reduce_add(y));
}
double NAME(sub_f64)(const uint32_t *a, const uint32_t *b) {
    v16u x,y; memcpy(&x,a,64); memcpy(&y,b,64);
    return (double)(__builtin_reduce_add(x)-__builtin_reduce_add(y));
}
float NAME(mixed_f32)(const uint32_t *a, uint32_t c, uint32_t *out) {
    v16u x; memcpy(&x,a,64);
    uint32_t s=__builtin_reduce_add(x); *out=s;
    return (float)(s-c);
}
