#!/usr/bin/env python3
"""MPFR references at independent 192/320-bit precision for target libm."""
from phi_common import RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
import hashlib,json,math,pathlib,random,struct
from mpfr_oracle import Number,value,version
root=pathlib.Path(__file__).resolve().parents[1];rng=random.Random(0x4d415448)
names=['exp','log','tanh','erf','erfc','sin','cos','sqrt','sin_pair','cos_pair']
lines=['/* Generated MPFR reference values, not target libm output. */','static const struct math_case math_cases[]={']
counts={}
def bits(x,w):
    try:return int.from_bytes(struct.pack('<f' if w==32 else '<d',x),'little')
    except OverflowError:return (int(x<0)<<(w-1))|(0x7f800000 if w==32 else 0x7ff0000000000000)
for w in [32,64]:
    f,e=(23,8) if w==32 else (52,11);sign=1<<(w-1);inf=((1<<e)-1)<<f
    inputs=[0,sign,1,2,3,sign|1,sign|2,(1<<f)-1,(1<<f),(1<<f)+1,inf-1,sign|(inf-1),inf,sign|inf,inf|1,inf|(1<<(f-1))]
    centers=[-1000,-745.1332191019411,-708.3964185322641,-103.972084045410,-87.3365447505531,88.7228390520684,709.782712893384,1000,-1,1,0.5,-0.5,math.pi,math.pi/2]
    for x in centers:
        b=bits(x,w);inputs += [b+d for d in [-2,-1,0,1,2] if 0<=b+d<(1<<w)]
    inputs += [bits(i/32,w) for i in range(-768,769)]
    inputs += [rng.getrandbits(w) for _ in range(512)]
    inputs=list(dict.fromkeys(inputs))
    for op,name in enumerate(names):
        function=name.split('_')[0]
        count=0
        low_x,low_y=Number(192),Number(192);high_x,high_y=Number(320),Number(320)
        for b in inputs:
            v=value(b,w)
            a=low_y.op(function,low_x.set(v)).bits(w);ref=high_y.op(function,high_x.set(v)).bits(w)
            mask=sign-1;nan=lambda r:(r&mask)>inf
            assert (nan(a) and nan(ref)) or a==ref,(name,w,hex(b),'precision disagreement',hex(a),hex(ref))
            tol=0 if name=='sqrt' or (ref&mask) in [0,inf] or (b&mask) in [0,inf] else 4
            # Tiny sin/tanh values round exactly to the original encoding.
            if function in ['sin','tanh'] and math.isfinite(v) and abs(v)<=2.0**-(f+5):tol=0
            lines.append(f'{{{op},{w},{tol},UINT64_C(0x{b:x}),UINT64_C(0x{ref:x})}},');count+=1
        for x in [low_x,low_y,high_x,high_y]:x.close()
        counts[f'{name}{w}']=count
lines.append('};')
(root/'tests/runtime-math-corpus.h').write_text('\n'.join(lines)+'\n')
(RECORDS/'runtime-math-oracle.json').write_text(json.dumps({'library':'MPFR '+version,'manual':'https://www.mpfr.org/mpfr-current/mpfr.html','precisions_bits':[192,320],'rounding':'MPFR_RNDN; both precisions must export identical IEEE encodings','cases':counts,'tolerance':'At most 4 ULP for tested ordinary libm values; sqrt, zeros/infinities and tiny sin/tanh exact; NaNs classified without payload promises','corpus_sha256':hashlib.sha256((root/'tests/runtime-math-corpus.h').read_bytes()).hexdigest()},indent=2)+'\n')
print('Generated MPFR runtime math cases:',sum(counts.values()))
