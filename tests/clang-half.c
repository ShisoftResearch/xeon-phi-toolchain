#include <stdint.h>
void scalar_half_to_float(uint32_t *out,const uint16_t *in){_Float16 h;__builtin_memcpy(&h,in,2);float f=h;__builtin_memcpy(out,&f,4);}
void scalar_float_to_half(uint16_t *out,const uint32_t *in){float f;__builtin_memcpy(&f,in,4);_Float16 h=(_Float16)f;__builtin_memcpy(out,&h,2);}
