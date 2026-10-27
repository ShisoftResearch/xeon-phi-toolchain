#!/usr/bin/env python3
"""Exact fused-rounding and vector conversion cases, independent of MPSS libm."""
from phi_common import RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
from fractions import Fraction
import pathlib,random,json
from ieee_oracle import decode,round_bits
root=pathlib.Path(__file__).resolve().parents[1]
rng=random.Random(73511)
lines=['/* Generated exact-rational vector FP corpus. */']
counts={}
for width in (32,64):
    f,e=(23,8) if width==32 else (52,11)
    bias=(1<<(e-1))-1
    one=bias<<f;sign=1<<(width-1)
    triples=[(one+1,one-2,sign|one),((one+1)|sign,one-2,one),(0,sign|one,sign),(sign,one,sign)]
    # Bounded exponents isolate fused rounding without underflow/overflow or DAZ.
    for _ in range(1024):
        vals=[(rng.getrandbits(1)<<(width-1))|((bias+rng.randrange(-20,21))<<f)|rng.getrandbits(f) for _ in range(3)]
        triples.append(tuple(vals))
    lines.append(f'static const struct fma{width}_case {{uint{width}_t a,b,c,expected;}} fma{width}_cases[]={{')
    for a,b,c in triples:
        sa,_,va=decode(a,width);sb,_,vb=decode(b,width);sc,_,vc=decode(c,width)
        zero=int(not va*vb and not vc and (sa^sb) and sc)
        result=round_bits(va*vb+vc,width,zero)
        suffix='U' if width==32 else 'ULL'
        lines.append('{'+','.join(f'0x{x:x}{suffix}' for x in (a,b,c,result))+'},')
    lines.append('};');counts[f'fma{width}']=len(triples)
lines.append('static const struct cvt_case {uint32_t input,signed_expected,unsigned_expected;} cvt_cases[]={')
values=[0,1,0xffffffff,0x80000000,0x7fffffff,0xffffff,0x1000001,0x1000003]+[rng.getrandbits(32) for _ in range(1024)]
for x in values:
    signed=x if x<0x80000000 else x-(1<<32)
    lines.append(f'{{0x{x:x}U,0x{round_bits(Fraction(signed),32):x}U,0x{round_bits(Fraction(x),32):x}U}},')
lines.append('};');counts['i32_to_f32']=len(values)
(root/'tests/vector-fp-corpus.h').write_text('\n'.join(lines)+'\n')
(RECORDS/'vector-fp-oracle.json').write_text(json.dumps({'method':'exact rational fused operation with a single nearest-even rounding','coverage':'bounded normal exponents plus signed zeros and fused cancellation; arbitrary int32/uint32 conversion','cases':counts},indent=2)+'\n')
print(counts)
