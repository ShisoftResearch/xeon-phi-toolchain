#!/usr/bin/env python3
"""Use the verified matrices for same-compiler, optimization-disabled timing."""
import pathlib,re
root=pathlib.Path(__file__).resolve().parents[1]
conversions=(root/'tests/knc-vector-conversions.ll').read_text();reductions=(root/'tests/knc-fp-reductions.ll').read_text()
ir=['; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null',
    'target triple = "x86_64-unknown-linux-gnu"'];header=[];names=[]
def add(source,name,kind,n,w):
 m=re.search(r'^define void @'+name+r'\(.*?^}',source,re.M|re.S);assert m,name
 new='bench_'+name;body=m[0].replace('@'+name+'(','@'+new+'(')
 if kind<4:body=body.replace('ptr %in)', 'ptr %in,ptr %init)')
 ir.append(body);header.append(f'K({new},{kind},{n},{w})');names.append(new)
for kind,(op,src,dst) in enumerate([('sitofp','i32','f64'),('uitofp','i32','f64'),('fptosi','f64','i32'),('fptoui','f64','i32')]):
 for n in [8,16,32]:add(conversions,f'convert_{op}_{src}_{dst}_{n}',kind,n,64)
for kind,op in enumerate(['ordered_add','reassoc_add','ordered_mul','reassoc_mul'],4):
 for w,n in [(32,16),(64,8)]:add(reductions,f'reduce_{op}_{n}_f{w}',kind,n,w)
ir+=sorted(set(re.findall(r'^declare .*$',reductions,re.M)))
(root/'tests/knc-fp-vector-tuning.ll').write_text('\n'.join(ir)+'\n')
(root/'tests/fp-vector-tuning-cases.h').write_text('/* Generated timing matrix. */\n'+'\n'.join(header)+'\n')
build=root/'build-fp-vector';build.mkdir(exist_ok=True)
(build/'before-symbols.txt').write_text(''.join(f'{n} before_{n}\n' for n in names))
print('Generated',len(names),'conversion/reduction comparisons')
