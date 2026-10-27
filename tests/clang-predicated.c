#include <stdint.h>
#include <stddef.h>
void auto_predicated(uint32_t *restrict out,const uint32_t *restrict a,const uint32_t *restrict b,const uint32_t *restrict mask,size_t n){
 for(size_t i=0;i<n;i++)if(mask[i])out[i]=a[i]*3u+b[i];
}
