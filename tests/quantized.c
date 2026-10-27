#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
extern void quant_dot(void*,const void*,const void*),expand_signed(void*,const void*),expand_unsigned(void*,const void*),narrow_bytes(void*,const void*),dequant_nibbles(void*,const void*),ordered_sum(void*,const void*);
#define CHECK(C) do{if(!(C)){printf("FAIL quantized line=%d iteration=%d lane=%d\n",__LINE__,n,k);return 1;}}while(0)
int main(void){
 int n=0,k=0;uint32_t state=147356;
 uint8_t a[256] __attribute__((aligned(64))),b[256] __attribute__((aligned(64))),packed[256] __attribute__((aligned(64)));
 int32_t out[16] __attribute__((aligned(64))),values[16] __attribute__((aligned(64)));
 float floats[16] __attribute__((aligned(64))),sum;
 for(n=0;n<1000;n++){
  for(k=0;k<256;k++){state^=state<<13;state^=state>>17;state^=state<<5;a[k]=state;b[k]=state>>8;}
  int offset=n%64;int32_t expected=0;
  quant_dot(&sum,a+offset,b+offset);
  for(k=0;k<16;k++)expected+=(int8_t)a[offset+k]*(int8_t)b[offset+k];CHECK(sum==(float)expected);
  expand_signed(out,a+offset);for(k=0;k<16;k++)CHECK(out[k]==(int8_t)a[offset+k]);
  expand_unsigned(out,a+offset);for(k=0;k<16;k++)CHECK((uint32_t)out[k]==a[offset+k]);
  for(k=0;k<16;k++)values[k]=(int32_t)((state+k)*71236767u);
  memset(packed,0x5a,sizeof(packed));narrow_bytes(packed+offset,values);
  for(k=0;k<256;k++)CHECK(packed[k]==((k>=offset && k<offset+16)?(uint8_t)values[k-offset]:0x5a));
  dequant_nibbles(floats,a+offset);for(k=0;k<16;k++)CHECK(floats[k]==((int)(a[offset+k]>>4)+(int)(a[offset+k]&15)-15)*0.125f);
  float ordered=1.0f;for(k=0;k<16;k++){floats[k]=(int8_t)a[k]*0.125f;volatile float r=ordered+floats[k];ordered=r;}
  ordered_sum(&sum,floats);CHECK(sum==ordered);
 }
 long pg=sysconf(_SC_PAGESIZE);unsigned char *guard=mmap(0,pg*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 CHECK(guard!=MAP_FAILED);CHECK(mprotect(guard+pg,pg,PROT_READ|PROT_WRITE)==0);
 for(n=0;n<2;n++){
  unsigned char *p=guard+pg+(n?pg-16:0);memcpy(p,a,16);
  expand_signed(out,p);for(k=0;k<16;k++)CHECK(out[k]==(int8_t)a[k]);
  expand_unsigned(out,p);for(k=0;k<16;k++)CHECK((uint32_t)out[k]==a[k]);
  narrow_bytes(p,values);for(k=0;k<16;k++)CHECK(p[k]==(uint8_t)values[k]);
 }
 munmap(guard,pg*3);
 puts("PASS LLVM quantized kernels: 1000 q8 dot products, byte expansion/truncation, q4 nibble dequantization, ordered FP32 sums, all 64 byte offsets and guard boundaries");return 0;
}
