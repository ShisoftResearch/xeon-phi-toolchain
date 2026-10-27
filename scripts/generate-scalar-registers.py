#!/usr/bin/env python3
"""Independent per-step rounding for a scalar expression chain."""
from phi_common import RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
import hashlib,json,pathlib,random
from ieee_oracle import decode,round_bits
root=pathlib.Path(__file__).resolve().parents[1];rng=random.Random(0x52454753)
rows=['/* Exact rational per-step RNE, finite inputs; no target arithmetic. */','static const struct chain_case chains[]={'];counts={}
for w in [32,64]:
    f,e=(23,8) if w==32 else (52,11);bias=(1<<(e-1))-1;sign=1<<(w-1)
    edges=[0,sign,1,sign|1,1<<f,sign|(1<<f),bias<<f,sign|(bias<<f)]
    triples=[(a,b,c) for a in edges for b in edges for c in edges]
    for _ in range(2048):
        exponent=50 if w==32 else 300
        triples.append(tuple((rng.getrandbits(1)<<(w-1))|((bias+rng.randrange(-exponent,exponent+1))<<f)|rng.getrandbits(f) for _ in range(3)))
    for a,b,c in triples:
        sa,_,va=decode(a,w);sb,_,vb=decode(b,w);sc,_,vc=decode(c,w)
        s=round_bits(va+vb,w,int(not va and not vb and sa and sb));ss,ks,vs=decode(s,w);assert ks=='finite'
        p=round_bits(vs*vc,w,ss^sc);sp,kp,vp=decode(p,w);assert kp=='finite'
        expected=round_bits(vp-vb,w,int(not vp and not vb and sp and not sb))
        rows.append('{%d,UINT64_C(0x%x),UINT64_C(0x%x),UINT64_C(0x%x),UINT64_C(0x%x)},'%(w,a,b,c,expected))
    counts[str(w)]=len(triples)
rows.append('};');path=root/'tests/scalar-register-corpus.h';path.write_text('\n'.join(rows)+'\n')
(RECORDS/'scalar-register-oracle.json').write_text(json.dumps({'method':'Exact Fraction arithmetic with per-step IEEE nearest-even rounding for (a+b)*c-b','cases':counts,'corpus_sha256':hashlib.sha256(path.read_bytes()).hexdigest()},indent=2)+'\n')
print('Generated scalar register chains:',counts)
