#include <stdint.h>
#include <stddef.h>
#ifdef KNC_NARROW_KERNELS
#define CAST(N,S,D) __attribute__((noinline)) void extra_##N(D*restrict out,const S*restrict in,size_t n){for(size_t i=0;i<n;i++)out[i]=(D)in[i];}
#else
#define CAST(N,S,D) void extra_##N(D*,const S*,size_t);
#endif
CAST(i8_f32,int8_t,float) CAST(u8_f32,uint8_t,float)
CAST(i16_f32,int16_t,float) CAST(u16_f32,uint16_t,float)
CAST(i8_f64,int8_t,double) CAST(u8_f64,uint8_t,double)
CAST(i16_f64,int16_t,double) CAST(u16_f64,uint16_t,double)
#ifndef KNC_NARROW_KERNELS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
static uint64_t reference(unsigned raw,unsigned bits,unsigned width,int is_signed){
 unsigned negative=is_signed&&(raw>>(bits-1)),magnitude=negative?(1u<<bits)-raw:raw;
 if(!magnitude)return 0;
 unsigned highest=31-__builtin_clz(magnitude),fraction=width==32?23:52,bias=width==32?127:1023;
 return((uint64_t)negative<<(width-1))|((uint64_t)(highest+bias)<<fraction)|((uint64_t)(magnitude-(1u<<highest))<<(fraction-highest));
}
static void invoke(unsigned op,void*out,const void*in,size_t n){switch(op){
 case 0:extra_i8_f32(out,in,n);break;case 1:extra_u8_f32(out,in,n);break;case 2:extra_i16_f32(out,in,n);break;case 3:extra_u16_f32(out,in,n);break;
 case 4:extra_i8_f64(out,in,n);break;case 5:extra_u8_f64(out,in,n);break;case 6:extra_i16_f64(out,in,n);break;case 7:extra_u16_f64(out,in,n);break;}}
static unsigned checks,failures;
static void exercise(unsigned op,void*in,void*out,unsigned n,unsigned offset){
 unsigned bytes_in=(op%4<2)?1:2,bytes_out=op<4?4:8;
 for(unsigned i=0;i<n;i++){uint16_t raw=(i+offset)&(bytes_in==1?255:65535);memcpy((char*)in+i*bytes_in,&raw,bytes_in);}
 invoke(op,n?out:NULL,n?in:NULL,n);
 for(unsigned i=0;i<n;i++){
  uint64_t got=0;memcpy(&got,(char*)out+i*bytes_out,bytes_out);
  uint64_t expected=reference((i+offset)&(bytes_in==1?255:65535),8*bytes_in,8*bytes_out,!(op&1));
  if(got!=expected){if(failures<8)printf("FAIL narrow cost cast op=%u n=%u offset=%u lane=%u got=%llx expected=%llx\n",op,n,offset,i,(unsigned long long)got,(unsigned long long)expected);failures++;}checks++;
 }
}
int main(void){
 unsigned char *input,*output;if(posix_memalign((void**)&input,64,131200)||posix_memalign((void**)&output,64,524544))return 1;
 for(unsigned op=0;op<8;op++){
  unsigned bi=(op%4<2)?1:2,bo=op<4?4:8;
  for(unsigned n=0;n<=257;n++)for(unsigned offset=0;offset<16;offset++){
   memset(output,0xa5,offset*bo+n*bo+64);exercise(op,input+offset*bi,output+offset*bo,n,offset);
   for(unsigned i=0;i<offset*bo;i++)if(output[i]!=0xa5)failures++;
   for(unsigned i=(offset+n)*bo;i<(offset+n)*bo+64;i++)if(output[i]!=0xa5)failures++;
  }
  exercise(op,input,output,65536,0);
 }
 unsigned page=sysconf(_SC_PAGESIZE);void*in=mmap(NULL,2*page,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0),*out=mmap(NULL,2*page,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 if(in==MAP_FAILED||out==MAP_FAILED||mprotect((char*)in+page,page,PROT_NONE)||mprotect((char*)out+page,page,PROT_NONE))return 1;
 const unsigned edges[]={0,1,2,7,8,9,15,16,17,31,32,33,63,64,65,127,128,129,257};
 for(unsigned op=0;op<8;op++)for(unsigned j=0;j<sizeof edges/sizeof edges[0];j++){
  unsigned n=edges[j],bi=(op%4<2)?1:2,bo=op<4?4:8;
  exercise(op,(char*)in+page-n*bi,(char*)out+page-n*bo,n,0);
 }
 printf("%s narrow vector-cost casts: 8 ordinary loops, %u exact integer-decoded results, all 65536 word encodings, offsets/tails/page guards, failures=%u\n",failures?"FAIL":"PASS",checks,failures);return !!failures;
}
#endif
