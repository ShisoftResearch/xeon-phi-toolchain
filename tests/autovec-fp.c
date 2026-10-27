#include <stdint.h>
#include <stdio.h>
extern void float_affine(float*,const float*,const float*,uint64_t,float),float_dot(float*,const float*,const float*,uint64_t);
extern void insert_f64(double*,const double*,double,uint32_t),broadcast_f64(double*,double);
extern void constant_f32(float*),constant_f64(double*),insert_f32(float*,const float*,float,uint32_t),broadcast_f32(float*,float);
#define CHECK(C) do{if(!(C)){printf("FAIL FP autovec line=%d length=%u offset=%u index=%u\n",__LINE__,n,offset,k);return 1;}}while(0)
int main(void){
 unsigned n=0,offset=0,k=0;
 float a[300],b[300],out[300],sum;double d[8];
 for(k=0;k<300;k++){a[k]=(int)(k%51)-25;b[k]=((int)(k%37)-18)*0.25f;}
 for(n=0;n<257;n++)for(offset=0;offset<16;offset++){
  for(k=0;k<300;k++)out[k]=123.5f;
  float_affine(out+offset,a+offset,b+offset,n,0.125f);
  for(k=0;k<300;k++)CHECK(out[k]==((k>=offset&&k<offset+n)?a[k]*0.125f+b[k]:123.5f));
  float ref=0;for(k=0;k<n;k++)ref+=a[offset+k]*b[offset+k];
  float_dot(&sum,a+offset,b+offset,n);CHECK(sum==ref);
 }
 constant_f32(out);for(k=0;k<16;k++)CHECK(out[k]==1.125f);
 constant_f64(d);for(k=0;k<8;k++)CHECK(d[k]==1.125);
 for(n=0;n<16;n++){insert_f32(out,a,3.25f,n);for(k=0;k<16;k++)CHECK(out[k]==(k==n?3.25f:a[k]));}
 broadcast_f32(out,-0.125f);for(k=0;k<16;k++)CHECK(out[k]==-0.125f);
 double din[8];for(k=0;k<8;k++)din[k]=k*0.5;
 for(n=0;n<8;n++){insert_f64(d,din,2.125,n);for(k=0;k<8;k++)CHECK(d[k]==(k==n?2.125:din[k]));}
 broadcast_f64(d,-0.125);for(k=0;k<8;k++)CHECK(d[k]==-0.125);
 puts("PASS LLVM FP32 auto-vectorized affine/dot loops: 257 lengths, 16 offsets, tails; FP32/FP64 constants, scalar broadcasts and lane insertions");return 0;
}
