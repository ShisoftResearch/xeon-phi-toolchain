#include <cmath>
#include <cstring>
#if defined(__SSE__) || defined(__AVX__) || defined(__AVX512F__)
#error Native K1OM kernels must not advertise other SIMD ISAs
#endif
template<class T> static void kernel(unsigned op,unsigned n,const void *in,const void *parameter,void *out){
 T x[32],y[32],p;std::memcpy(x,in,n*sizeof(T));std::memcpy(&p,parameter,sizeof(T));
 if(op==0){ // Stable SiLU, including logits whose exponential would overflow.
  for(unsigned i=0;i<n;i++){T e=std::exp(-std::fabs(x[i]));y[i]=x[i]>=0?x[i]/(T(1)+e):x[i]*e/(T(1)+e);}
 }else if(op==1){
  T scale=T(1)/std::sqrt(T(2));
  for(unsigned i=0;i<n;i++)y[i]=T(.5)*x[i]*std::erfc(-x[i]*scale);
 }else if(op==2){
  T maximum=x[0],sum=0;for(unsigned i=1;i<n;i++)if(x[i]>maximum)maximum=x[i];
  for(unsigned i=0;i<n;i++){y[i]=std::exp(x[i]-maximum);sum+=y[i];}
  for(unsigned i=0;i<n;i++)y[i]/=sum;
 }else if(op==3){
  T sum=0;for(unsigned i=0;i<n;i++)sum+=x[i]*x[i];
  T inv=T(1)/std::sqrt(sum/T(n)+p);for(unsigned i=0;i<n;i++)y[i]=x[i]*inv;
 }else{
  T s=std::sin(p),c=std::cos(p);
  for(unsigned i=0;i<n;i+=2){y[i]=x[i]*c-x[i+1]*s;y[i+1]=x[i]*s+x[i+1]*c;}
 }
 std::memcpy(out,y,n*sizeof(T));
}
extern "C" void runtime_kernel32(unsigned op,unsigned n,const void *in,const void *parameter,void *out){kernel<float>(op,n,in,parameter,out);}
extern "C" void runtime_kernel64(unsigned op,unsigned n,const void *in,const void *parameter,void *out){kernel<double>(op,n,in,parameter,out);}
