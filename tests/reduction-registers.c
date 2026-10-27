#include <stdint.h>
#include <stdio.h>
#include <string.h>
#define DECLARE(p) \
extern float p##add_f32(const uint32_t *,const uint32_t *); \
extern double p##sub_f64(const uint32_t *,const uint32_t *); \
extern float p##mixed_f32(const uint32_t *,uint32_t,uint32_t *);
DECLARE(native_)
DECLARE(control_)
static uint32_t bits32(float f) { uint32_t u;memcpy(&u,&f,4);return u; }
static uint64_t bits64(double f) { uint64_t u;memcpy(&u,&f,8);return u; }
static uint32_t next(uint32_t *s) { *s ^= *s<<13; *s ^= *s>>17; *s ^= *s<<5; return *s; }
int main(void) {
    uint32_t state=0x79ab83ff;
    for (unsigned i=0;i<65536;i++) {
        uint32_t a[16],b[16],sum=0,out0=0,out1=1;
        for(unsigned j=0;j<16;j++) { a[j]=next(&state);b[j]=next(&state);sum+=a[j]; }
        uint32_t c=next(&state);
        if(bits32(native_add_f32(a,b))!=bits32(control_add_f32(a,b)) ||
           bits64(native_sub_f64(a,b))!=bits64(control_sub_f64(a,b)) ||
           bits32(native_mixed_f32(a,c,&out0))!=bits32(control_mixed_f32(a,c,&out1)) ||
           out0!=sum || out1!=sum) { printf("FAIL trial %u\n",i);return 1; }
    }
    puts("PASS reduction register transport: 327680 checks, wrapping add/sub, signed FP32, unsigned FP64, mixed scalar stores");
    return 0;
}
