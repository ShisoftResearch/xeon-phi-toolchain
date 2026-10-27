"""Exact rational oracle for canonical x87 extended precision (64-bit significand).

Only defined normal/subnormal/zero/infinity/NaN encodings are generated. The
explicit integer bit distinguishes this representation from IEEE binary128.
Rounding is nearest-even at 64 significand bits with gradual underflow.
"""
from fractions import Fraction as F
from math import isqrt
BIAS=16383
SIGN=1<<79
INF=0x7fff<<64|1<<63
NAN=INF|1<<62

def pow2(n):return F(1<<n) if n>=0 else F(1,1<<-n)
def decode(bits):
 sign=bits>>79;ex=(bits>>64)&0x7fff;sig=bits&((1<<64)-1)
 if ex==0x7fff:return ('inf' if sig==1<<63 else 'nan'),sign,None
 assert (ex==0 and sig<1<<63) or (ex>0 and sig>=1<<63)
 value=F(sig)*pow2((ex if ex else 1)-BIAS-63)
 return 'finite',sign,-value if sign else value

def log2(v):
 e=v.numerator.bit_length()-v.denominator.bit_length()
 return e-1 if v<pow2(e) else e

def nearest(v):
 q,r=divmod(v.numerator,v.denominator)
 return q+(2*r>v.denominator or (2*r==v.denominator and q&1))

def encode_quantized(sign,ex,sig):
 if sig==1<<64:ex+=1;sig>>=1
 if ex>16383:return sign*SIGN|INF
 if ex==-16382 and sig<1<<63:field=0
 else:field=ex+BIAS
 return sign*SIGN|(field<<64)|sig

def round_bits(v,zero_sign=0):
 if not v:return zero_sign*SIGN
 sign=int(v<0);v=abs(v);ex=max(-16382,log2(v))
 return encode_quantized(sign,ex,nearest(v/pow2(ex-63)))

def binary(op,a,b):
 at,as_,av=decode(a);bt,bs,bv=decode(b)
 if at=='nan' or bt=='nan':return NAN
 if op=='sub':bs^=1;bv=-bv if bv is not None else None;op='add'
 if op=='add':
  if at=='inf' and bt=='inf' and as_!=bs:return NAN
  if at=='inf':return as_*SIGN|INF
  if bt=='inf':return bs*SIGN|INF
  return round_bits(av+bv,int(as_ and bs))
 sign=as_^bs
 if op=='mul':
  if (at=='inf' and bt=='finite' and not bv) or (bt=='inf' and at=='finite' and not av):return NAN
  if at=='inf' or bt=='inf':return sign*SIGN|INF
  return round_bits(av*bv,sign)
 assert op=='div'
 if at==bt=='inf' or at==bt=='finite' and not av and not bv:return NAN
 if at=='inf' or bt=='finite' and not bv:return sign*SIGN|INF
 if bt=='inf':return sign*SIGN
 return round_bits(av/bv,sign)

def sqrt(a):
 tag,sign,v=decode(a)
 if tag=='nan' or sign and (tag=='inf' or v):return NAN
 if tag=='inf':return INF
 if not v:return sign*SIGN
 ex=max(-16382,log2(v)//2);scaled=v/pow2(2*(ex-63))
 sig=isqrt(scaled.numerator//scaled.denominator)
 mid=(2*sig+1)**2*scaled.denominator;cmp=4*scaled.numerator
 if cmp>mid or cmp==mid and sig&1:sig+=1
 return encode_quantized(0,ex,sig)

def comparison(a,b):
 at,as_,av=decode(a);bt,bs,bv=decode(b)
 if 'nan' in [at,bt]:return 2|64
 if at=='inf':cmp=0 if bt=='inf' and as_==bs else -1 if as_ else 1
 elif bt=='inf':cmp=1 if bs else -1
 else:cmp=(av>bv)-(av<bv)
 return int(cmp==0)|(int(cmp!=0)<<1)|(int(cmp<0)<<2)|(int(cmp<=0)<<3)|(int(cmp>0)<<4)|(int(cmp>=0)<<5)

assert round_bits(F(1))==0x3fff8000000000000000
assert round_bits(F(1)+pow2(-64))==round_bits(F(1))
assert round_bits(F(1)+pow2(-63))==0x3fff8000000000000001
assert binary('add',SIGN,SIGN)==SIGN
assert sqrt(round_bits(F(4)))==round_bits(F(2))
