#!/usr/bin/env python3
"""Exact rational oracles for ordinary mixed-width loops and ordered sums."""
from phi_common import RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
import hashlib,json,pathlib,random
from fractions import Fraction
from ieee_oracle import decode,round_bits
root=pathlib.Path(__file__).resolve().parents[1];rng=random.Random(0x434f5354)
def convert(b,src,dst):
    sign,kind,v=decode(b,src);f,e={32:(23,8),64:(52,11)}[dst]
    if kind!='finite':return (sign<<(dst-1))|(((1<<e)-1)<<f)|(1<<(f-1) if kind=='nan' else 0)
    return round_bits(v,dst,sign)
edge32=[0,0x80000000,1,0x80000001,0x007fffff,0x00800000,0x7f7fffff,0x7f800000,0xff800000,0x7fc00001,0x7f800001]
edge64=[0,1<<63,1,(1<<63)|1,0xfffffffffffff,0x10000000000000,0x7fefffffffffffff,0x7ff0000000000000,0xfff0000000000000,0x7ff8000000000001,0x7ff0000000000001]
lines=['/* Exact rational host oracles, independent of target arithmetic. */','static const struct value_case values[]={'];dots=[]
for i in range(512):
    signed=[0,-1,1,-(1<<31),(1<<31)-1][i] if i<5 else rng.randrange(-(1<<31),1<<31)
    unsigned=[0,1,(1<<32)-1,1<<31][i] if i<4 else rng.getrandbits(32)
    word=rng.randrange(-(1<<15),1<<15);s=(i%30)-15;s+=s>=0;scale=Fraction(s,16)
    f32=edge32[i] if i<len(edge32) else rng.getrandbits(32)
    f64=edge64[i] if i<len(edge64) else rng.getrandbits(64)
    safe=Fraction(signed,16);_,kind,x=decode(f64,64)
    clamped=f64 if kind=='nan' else (0 if x is not None and x<0 or kind=='inf' and f64>>63 else round_bits(Fraction(6),64) if kind=='inf' or x>6 else f64)
    a=Fraction(i%31-15,8);b=Fraction(i%23-11,16);dots.append(a*b)
    expected=[round_bits(Fraction(signed),64),round_bits(Fraction(unsigned),64),int(safe)&0xffffffff,convert(f32,32,64),convert(f64,64,32),round_bits(word*scale,32,(word<0)^(s<0)),round_bits(signed*scale,64,(signed<0)^(s<0)),0,0,clamped]
    fields=[signed&0xffffffff,unsigned,word&0xffff,f32,f64,round_bits(safe,64),round_bits(scale,32),round_bits(scale,64),round_bits(a,64),round_bits(b,64)]
    arr=lambda xs:'{'+','.join('UINT64_C(0x%x)'%v for v in xs)+'}'
    lines.append('{'+','.join('UINT64_C(0x%x)'%v for v in fields)+','+arr(expected)+'},')
lines.append('};')
lengths=list(range(258))+[511,512,513,1023,1024,1025,4096]
lines+=['static const unsigned lengths[]={'+','.join(map(str,lengths))+'};','static const uint64_t dot_expected[][16]={']
for n in lengths:
    results=[]
    for offset in range(16):results.append(round_bits(sum((dots[(i+offset)%512] for i in range(n)),Fraction()),64))
    lines.append('{'+','.join('UINT64_C(0x%x)'%v for v in results)+'},')
lines+=['};','static const uint64_t ordered_cancellation_expected[66]={']
acc=0
for i in range(66):
    lines.append('UINT64_C(0x%x),' % round_bits(Fraction(acc),64))
    if i<65:
        term=[1<<56,1,-(1<<56),1][i%4]
        acc=decode(round_bits(Fraction(acc)+term,64),64)[2]
lines.append('};');path=root/'tests/optimization-corpus.h';path.write_text('\n'.join(lines)+'\n')
(RECORDS/'optimization-oracle.json').write_text(json.dumps({'source':'independent Fraction-based IEEE decoding/rounding; integer truncation for defined inputs','values':512,'lengths':lengths,'offsets':16,'ordered_cancellation_lengths':66,'corpus_sha256':hashlib.sha256(path.read_bytes()).hexdigest()},indent=2)+'\n')
print('Generated optimization corpus:',len(lengths),'lengths, 16 offsets, 512 IEEE/rational inputs')
