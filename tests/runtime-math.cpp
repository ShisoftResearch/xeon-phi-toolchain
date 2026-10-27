#include <cmath>
#include <cstdint>
#include <cstring>
extern "C" void sincos(double,double*,double*);
extern "C" void sincosf(float,float*,float*);
#if defined(__SSE__) || defined(__AVX__) || defined(__AVX512F__)
#error This is a native K1OM client
#endif
extern "C" void runtime_math32(unsigned op,const void *input,void *output){
 float x,r;std::memcpy(&x,input,4);
 switch(op){case 0:r=std::exp(x);break;case 1:r=std::log(x);break;case 2:r=std::tanh(x);break;case 3:r=std::erf(x);break;case 4:r=std::erfc(x);break;case 5:r=std::sin(x);break;case 6:r=std::cos(x);break;case 7:r=std::sqrt(x);break;default:{float s,c;sincosf(x,&s,&c);r=op==8?s:c;break;}}
 std::memcpy(output,&r,4);
}
extern "C" void runtime_math64(unsigned op,const void *input,void *output){
 double x,r;std::memcpy(&x,input,8);
 switch(op){case 0:r=std::exp(x);break;case 1:r=std::log(x);break;case 2:r=std::tanh(x);break;case 3:r=std::erf(x);break;case 4:r=std::erfc(x);break;case 5:r=std::sin(x);break;case 6:r=std::cos(x);break;case 7:r=std::sqrt(x);break;default:{double s,c;sincos(x,&s,&c);r=op==8?s:c;break;}}
 std::memcpy(output,&r,8);
}
