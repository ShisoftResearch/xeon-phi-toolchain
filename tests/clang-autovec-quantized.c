#include <stdint.h>
#include <stddef.h>
uint32_t auto_q8_dot(const int8_t *restrict a,const int8_t *restrict b,size_t n){
 uint32_t sum=0;for(size_t i=0;i<n;i++)sum+=(int32_t)a[i]*(int32_t)b[i];return sum;
}
void auto_q8_affine(uint32_t *restrict out,const int8_t *restrict a,size_t n,uint32_t scale,uint32_t bias){
 for(size_t i=0;i<n;i++)out[i]=(uint32_t)(int32_t)a[i]*scale+bias;
}
void auto_q4_low(float *restrict out,const uint8_t *restrict a,size_t n,float scale){
 for(size_t i=0;i<n;i++)out[i]=((int)(a[i]&15)-8)*scale;
}
void auto_q4_high(float *restrict out,const uint8_t *restrict a,size_t n,float scale){
 for(size_t i=0;i<n;i++)out[i]=((int)(a[i]>>4)-8)*scale;
}
