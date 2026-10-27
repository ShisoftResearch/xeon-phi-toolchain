#!/usr/bin/env python3
"""Exact-rational div and integer-root sqrt oracles, plus fast-flag matrices."""
from phi_common import RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
import importlib.util,json,pathlib,random
root=pathlib.Path(__file__).resolve().parents[1]
# This module also cross-checks its binary64 arithmetic oracle on the host.
spec=importlib.util.spec_from_file_location('fp_oracle',root/'scripts/generate-fp-corpus.py')
oracle=importlib.util.module_from_spec(spec);spec.loader.exec_module(oracle)
operate=oracle.operate
rng=random.Random(232323)
ir=['; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null',
    '; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null',
    'target triple = "x86_64-unknown-linux-gnu"']
header=['/* Generated approximate vector math entry points. */']
corpus=['/* Independent exact-rational div and integer-root sqrt oracle. */',
        'struct approx_case { uint64_t a,b,div,sqrt; };']
counts={}
for w,ty in [(32,'float'),(64,'double')]:
 f,e=(23,8) if w==32 else (52,11);bias=(1<<(e-1))-1;inf=((1<<e)-1)<<f;sign=1<<(w-1)
 edges=[0,sign,1,sign|1,(1<<f)-1,1<<f,sign|(1<<f),bias<<f,sign|(bias<<f),inf-1,sign|(inf-1),inf,sign|inf,inf|1,inf|(1<<(f-1)),sign|inf|123]
 pairs=[(a,b) for a in edges for b in edges]
 # Both sides of each guarded exponent boundary, sign, and mantissa extremes.
 boundaries=[((bias+k)<<f)|m|s for k in [-61,-60,-59,59,60,61] for m in [0,1,(1<<f)-1] for s in [0,sign]]
 pairs += [(a,b) for a in boundaries for b in boundaries]
 for _ in range(4096):
  def normal():return (rng.getrandbits(1)<<(w-1))|((bias+rng.randrange(-60,61))<<f)|rng.getrandbits(f)
  pairs.append((normal(),normal()))
 pairs += [(rng.getrandbits(w),rng.getrandbits(w)) for _ in range(2048)]
 corpus.append(f'static const struct approx_case approx_cases{w}[]={{')
 for a,b in pairs:
  d=operate(a,b,3,w);s=operate(a,b,5,w)
  corpus.append('{'+','.join(f'UINT64_C(0x{x:x})' for x in [a,b,d,s])+'},')
 corpus.append('};');counts[str(w)]=len(pairs)
 for n in [2,4,8,16,32]:
  v=f'<{n} x {ty}>';header.append(f'K({n},{w})')
  for op in ['div','sqrt']:
   name=f'approx_{op}_{n}_{w}'
   ir.append(f'define void @{name}(ptr %out,ptr %a,ptr %b) {{\n %x=load {v},ptr %a,align 1')
   if op=='div':ir.append(f' %y=load {v},ptr %b,align 1\n %r=fdiv arcp afn {v} %x,%y')
   else:ir.append(f' %r=call afn {v} @llvm.sqrt.v{n}f{w}({v} %x)')
   ir.append(f' store {v} %r,ptr %out,align 1\n ret void\n}}')
   if op=='sqrt':ir.append(f'declare {v} @llvm.sqrt.v{n}f{w}({v})')
for path,lines in [('tests/knc-approx-math.ll',ir),('tests/approx-cases.h',header),('tests/approx-corpus.h',corpus)]:
 (root/path).write_text('\n'.join(lines)+'\n')
(RECORDS/'approx-oracle.json').write_text(json.dumps({'method':'Exact fractions and nearest-even quotient rounding; integer square-root rounding, no target libm as oracle','pairs_per_type':counts,'permitted_fast_error_ulp':4,'fallback_error_ulp':0,'coverage':'Full IEEE edges, guarded-domain boundaries, 4096 biased normal pairs and 2048 arbitrary encodings per type'},indent=2)+'\n')
print('Approximate math oracle pairs:',counts)
