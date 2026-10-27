#include <stddef.h>
#define LOOPS(T,S) \
void auto_relu##S(T *restrict out,const T *restrict a,size_t n){for(size_t i=0;i<n;i++)out[i]=a[i]>(T)0?a[i]:(T)0;} \
void auto_clamp##S(T *restrict out,const T *restrict a,size_t n){for(size_t i=0;i<n;i++){T x=a[i];x=x<(T)-1?(T)-1:x;out[i]=x>(T)1?(T)1:x;}} \
void auto_choose##S(T *restrict out,const T *restrict a,const T *restrict b,size_t n){for(size_t i=0;i<n;i++)out[i]=a[i]<b[i]?a[i]:b[i];}
LOOPS(float,32)
LOOPS(double,64)
