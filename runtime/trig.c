/* Combined entry points prevent SDK sincos range reduction from being selected
 * when the compiler combines a sine/cosine pair. Built with -fno-builtin so
 * these calls cannot be combined recursively. Scalar native KNC ABI. */
#include <math.h>
void sincos(double x,double *s,double *c){*s=sin(x);*c=cos(x);}
void sincosf(float x,float *s,float *c){*s=sinf(x);*c=cosf(x);}
