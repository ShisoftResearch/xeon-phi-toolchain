#!/usr/bin/env python3
"""Exact half rounding boundaries, independently cross-checked with host binary16."""
from phi_common import RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
from fractions import Fraction
from ieee_oracle import decode,round_bits
import pathlib,random,struct,json
root=pathlib.Path(__file__).resolve().parents[1]
values={0,0x80000000,0x7f800000,0xff800000,0x7fc00001,0x7f800001,0xffc01234}
for h in range(0x7bff):
    x=decode(h,16)[2];y=decode(h+1,16)[2]
    mid=round_bits((x+y)/2,32)
    for delta in (-1,0,1):
        values.add(mid+delta);values.add((mid+delta)|0x80000000)
for x in (65520,65504):
    bits=round_bits(Fraction(x),32)
    for d in (-1,0,1):values.add(bits+d);values.add((bits+d)|0x80000000)
rng=random.Random(6013);crosschecks=0
for _ in range(5000):
    bits=rng.getrandbits(32);values.add(bits);sign,kind,value=decode(bits,32)
    if kind!='finite':continue
    try:host=struct.unpack('<H',struct.pack('<e',struct.unpack('<f',struct.pack('<I',bits))[0]))[0]
    except OverflowError:host=(sign<<15)|0x7c00
    assert round_bits(value,16,sign)==host;crosschecks+=1
lines=['/* Exact-rational binary16 rounding corpus. */','static const struct half_case {uint32_t input;uint16_t expected,nan;} half_cases[]={']
for bits in sorted(values):
    sign,kind,value=decode(bits,32)
    expected=(0x7e00 if kind=='nan' else (sign<<15)|0x7c00 if kind=='inf' else round_bits(value,16,sign))
    lines.append(f'{{0x{bits:08x}U,0x{expected:04x},{int(kind=="nan")}}},')
lines.append('};');(root/'tests/half-corpus.h').write_text('\n'.join(lines)+'\n')
(RECORDS/'half-oracle.json').write_text(json.dumps({'method':'exact rational nearest-even half rounding','encode_cases':len(values),'decode_cases':65536,'independent_host_binary16_crosschecks':crosschecks},indent=2)+'\n');print(len(values),'half encoding cases;',crosschecks,'independent host checks')
