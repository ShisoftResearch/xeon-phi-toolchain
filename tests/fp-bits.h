/* Independent integer-only IEEE encoding oracles for hardware tests. */
#ifndef KNC_FP_BITS_H
#define KNC_FP_BITS_H
static uint64_t state=UINT64_C(0x25319abc7654f1);
static uint64_t next(void){state^=state<<13;state^=state>>7;state^=state<<17;return state;}
static uint64_t get(const void *p,unsigned i,unsigned bytes){uint64_t x=0;memcpy(&x,(const char*)p+i*bytes,bytes);return x;}
static void put(void *p,unsigned i,unsigned bytes,uint64_t x){memcpy((char*)p+i*bytes,&x,bytes);}
static int isnanbits(uint64_t x,unsigned bits){uint64_t sign=UINT64_C(1)<<(bits-1),inf=bits==32?UINT64_C(0x7f800000):UINT64_C(0x7ff0000000000000);return (x&~sign)>inf;}
static int signaling(uint64_t x,unsigned bits){return isnanbits(x,bits)&&!(x&(UINT64_C(1)<<(bits==32?22:51)));}
/* Compare exact encodings without host FP instructions or compiler FP helpers. */
static int relation(uint64_t x,uint64_t y,unsigned bits){uint64_t sign=UINT64_C(1)<<(bits-1);if(x==y||((x|y)&~sign)==0)return 0;int less=(x&sign)!=(y&sign)?!!(x&sign):(x&sign?x>y:x<y);return less?-1:1;}
static int predicate(unsigned pred,uint64_t x,uint64_t y,unsigned bits){int u=isnanbits(x,bits)||isnanbits(y,bits),r=u?0:relation(x,y,bits);int v[]={0,!u&&r==0,!u&&r>0,!u&&r>=0,!u&&r<0,!u&&r<=0,!u&&r!=0,!u,u,u||r==0,u||r>0,u||r>=0,u||r<0,u||r<=0,u||r!=0,1};return v[pred];}
static uint64_t minimum(unsigned op,uint64_t x,uint64_t y,unsigned bits){int nx=isnanbits(x,bits),ny=isnanbits(y,bits);uint64_t sign=UINT64_C(1)<<(bits-1),qnan=bits==32?UINT64_C(0x7fc00000):UINT64_C(0x7ff8000000000000);if(nx||ny){if((op>=2&&op<4)||(nx&&ny)||(op<2&&(signaling(x,bits)||signaling(y,bits))))return qnan;return nx?y:x;}if(((x|y)&~sign)==0)return op&1?x&y:x|y;int r=relation(x,y,bits);return op&1?(r>0?x:y):(r<0?x:y);}
static unsigned char *mapping(size_t page){unsigned char *p=mmap(0,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);if(p==MAP_FAILED||mprotect(p+page,page,PROT_READ|PROT_WRITE))exit(1);return p;}
#endif
