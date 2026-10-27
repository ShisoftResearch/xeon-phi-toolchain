"""Small MPFR 4 LP64 binding for independent host-side numerical oracles.

Public ABI checked against MPFR 4.2.2 src/mpfr.h from the GNU source archive:
https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz
Archive SHA256: b67ba0383ef7e8a8563734e2e889ef5ec3c3b898a01d00fa0a6869ad81c6ce01
Manual: https://www.mpfr.org/mpfr-current/mpfr.html
The library is an external host prerequisite, never linked into K1OM programs.
"""
import ctypes as c
import ctypes.util
import struct

class Raw(c.Structure):
    _fields_=[('precision',c.c_long),('sign',c.c_int),('exponent',c.c_long),('limbs',c.c_void_p)]

assert c.sizeof(c.c_long)==8 and c.sizeof(c.c_void_p)==8 and c.sizeof(Raw)==32,'MPFR oracle requires the verified LP64 ABI'
name=ctypes.util.find_library('mpfr')
if not name:raise RuntimeError('Host libmpfr is required to generate runtime math oracles')
lib=c.CDLL(name)
P=c.POINTER(Raw)
def bind(name,result,args):
    f=getattr(lib,'mpfr_'+name);f.restype=result;f.argtypes=args;return f
version=bind('get_version',c.c_char_p,[])().decode()
assert version.startswith('4.'),'Validate a new MPFR ABI before using it'
init=bind('init2',None,[P,c.c_long]);clear=bind('clear',None,[P]);set_d=bind('set_d',c.c_int,[P,c.c_double,c.c_int])
get_d=bind('get_d',c.c_double,[P,c.c_int]);get_flt=bind('get_flt',c.c_float,[P,c.c_int])
get_prec=bind('get_prec',c.c_long,[P])
unary={n:bind(n,c.c_int,[P,P,c.c_int]) for n in ['exp','log','tanh','erf','erfc','sin','cos','sqrt','neg']}
binary={n:bind(n,c.c_int,[P,P,P,c.c_int]) for n in ['add','sub','mul','div']}

class Number:
    def __init__(self,precision=256,value=0.0):
        self.raw=Raw();init(c.byref(self.raw),precision)
        assert get_prec(c.byref(self.raw))==precision and self.raw.precision==precision and self.raw.limbs
        set_d(c.byref(self.raw),value,0)
    def close(self):
        if self.raw.limbs:clear(c.byref(self.raw));self.raw.limbs=None
    def __del__(self):self.close()
    def set(self,value):set_d(c.byref(self.raw),value,0);return self
    def op(self,name,a,b=None):
        if b is None:unary[name](c.byref(self.raw),c.byref(a.raw),0)
        else:binary[name](c.byref(self.raw),c.byref(a.raw),c.byref(b.raw),0)
        return self
    def bits(self,width):
        x=get_flt(c.byref(self.raw),0) if width==32 else get_d(c.byref(self.raw),0)
        return int.from_bytes(struct.pack('<f' if width==32 else '<d',x),'little')

def value(bits,width):return struct.unpack('<f' if width==32 else '<d',bits.to_bytes(width//8,'little'))[0]

def self_test():
    for precision in [192,320]:
        x=Number(precision);y=Number(precision)
        assert y.op('exp',x.set(0.0)).bits(64)==0x3ff0000000000000
        assert y.op('log',x.set(1.0)).bits(64)==0
        assert y.op('sqrt',x.set(2.0)).bits(64)==0x3ff6a09e667f3bcd
        assert y.op('sin',x.set(-0.0)).bits(64)==0x8000000000000000
        assert y.op('tanh',x.set(0.0)).bits(32)==0
        x.close();y.close()
self_test()
