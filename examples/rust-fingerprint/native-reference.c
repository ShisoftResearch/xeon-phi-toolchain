#include <stdint.h>
#include <stddef.h>
/* Independent MPSS GCC implementation of 16-token polynomial fingerprints. */
void gcc_fingerprints(const uint32_t *tokens,uint32_t *out,size_t count){
 for(size_t i=0;i<count;i++){
  uint32_t h=0;
  for(unsigned j=0;j<16;j++)h=h*16777619u+tokens[i+j];
  out[i]=h;
 }
}
