#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
struct Mixed { double f; int64_t i; };
extern double gcc_vsum(int,va_list);
double clang_named(double first,int n,...){va_list ap;va_start(ap,n);double s=first;for(int j=0;j<n;j++)s+=va_arg(ap,double);va_end(ap);return s;}
int64_t clang_integers(int n,...){va_list ap;va_start(ap,n);int64_t s=0;for(int j=0;j<n;j++)s+=va_arg(ap,int64_t);va_end(ap);return s;}
double clang_mixed(int n,...){va_list ap;va_start(ap,n);double s=0;for(int j=0;j<n;j++){int64_t i=va_arg(ap,int64_t);double d=va_arg(ap,double);struct Mixed m=va_arg(ap,struct Mixed);s+=i+d+m.i+m.f;}va_end(ap);return s;}
double clang_copies(int n,...){va_list a,b;va_start(a,n);va_copy(b,a);double x=0,y=0;for(int j=0;j<n;j++)x+=va_arg(a,double);for(int j=0;j<n;j++)y+=va_arg(b,double);va_end(a);va_end(b);return x-y;}
double clang_forward(int n,...){va_list ap;va_start(ap,n);double s=gcc_vsum(n,ap);va_end(ap);return s;}
double clang_vsum(int n,va_list source){va_list ap;va_copy(ap,source);double s=0;for(int j=0;j<n;j++)s+=va_arg(ap,double);va_end(ap);return s;}
int clang_format(char *out,unsigned long size,const char *fmt,...){va_list ap;va_start(ap,fmt);int n=vsnprintf(out,size,fmt,ap);va_end(ap);return n;}
double clang_exhaust_fp(double a,double b,double c,double d,double e,double f,double g,double h,double i,int n,...){va_list ap;va_start(ap,n);double s=a+b+c+d+e+f+g+h+i;for(int j=0;j<n;j++)s+=va_arg(ap,double);va_end(ap);return s;}
int64_t clang_exhaust_gp(int64_t a,int64_t b,int64_t c,int64_t d,int64_t e,int64_t f,int64_t g,...){va_list ap;va_start(ap,g);int64_t s=a+b+c+d+e+f+g;for(int j=0;j<3;j++)s+=va_arg(ap,int64_t);va_end(ap);return s;}
