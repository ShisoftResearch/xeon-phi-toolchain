"""Exact IEEE decoding and nearest-even rounding shared by independent test generators."""
from fractions import Fraction

def decode(bits,width):
 f,e={16:(10,5),32:(23,8),64:(52,11)}[width]; sign=bits>>(width-1);ex=(bits>>f)&((1<<e)-1);m=bits&((1<<f)-1)
 if ex==(1<<e)-1:return sign,'nan' if m else 'inf',None
 bias=(1<<(e-1))-1
 if ex:m|=1<<f
 k=(ex if ex else 1)-bias-f
 val=Fraction(m<<k,1) if k>=0 else Fraction(m,1<<-k)
 return sign,'finite',-val if sign else val
def round_bits(value,width,zero_sign=0):
 f,e={16:(10,5),32:(23,8),64:(52,11)}[width];bias=(1<<(e-1))-1;emin=1-bias;emax=bias
 sign=int(value<0) if value else zero_sign
 if not value:return sign<<(width-1)
 n,d=abs(value.numerator),value.denominator;k=n.bit_length()-d.bit_length()
 if (n < d<<k) if k>=0 else (n<<-k < d):k-=1
 exponent=max(k,emin);step=exponent-f
 nn,dd=(n,d<<step) if step>=0 else (n<<-step,d)
 q,r=divmod(nn,dd)
 if 2*r>dd or (2*r==dd and q&1):q+=1
 if q>=1<<(f+1):q>>=1;exponent+=1
 if exponent>emax:return (sign<<(width-1))|(((1<<e)-1)<<f)
 if q<1<<f:ex=0;frac=q
 else:ex=exponent+bias;frac=q-(1<<f)
 return (sign<<(width-1))|(ex<<f)|frac
