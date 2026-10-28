#!/usr/bin/env python3
"""Build the standard Rust portable-SIMD matrix, fixtures and target checks.

Local tests run on the host. Target binaries are built but are never executed
on the host; run them explicitly on a KNC card as documented.
"""
import argparse
import concurrent.futures
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from phi_common import *

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--offline',action='store_true',help='Require an already populated Cargo registry cache')
p.add_argument('--jobs',type=int,default=min(jobs(),4))
a=p.parse_args()
if a.jobs<1:p.error('--jobs must be positive')
rustc=RUST_BUILD/HOST/'stage1/bin/rustc'
require(rustc,'Build the pinned Rust compiler first with build-rust')
run([sys.executable,ROOT/'scripts/generate-portable-simd.py'])
w=BUILD/'portable-simd';crate=ROOT/'examples/rust-portable-simd/Cargo.toml'
env=os.environ.copy();env['PHI_SIMD_CORPUS']=str(w/'corpus-generated.rs');env['PHI_AUTOVECTORIZE']='0'
args=['build','--manifest-path',str(crate),'--features','corpus','--bins','--release']
if a.offline:args+=['--offline']
run([ROOT/'bin/cargo-knc',*args],env=env)
# Host reference uses the same pinned Rust source/compiler, with its ordinary
# host ABI and host std. No KNC code is executed on the host.
hostenv=env.copy();hostenv['RUSTC']=str(rustc)
for key in ['RUSTFLAGS','CARGO_ENCODED_RUSTFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER']:
    hostenv.pop(key,None)
run(['cargo','+'+LOCK['rust']['bootstrap_toolchain'],*args,'--target-dir',w/'host'],env=hostenv)
run([w/'host/release/knc-portable-simd'])
fixture=w/'expected.bin'
run([w/'host/release/portable-simd-corpus','--record',fixture])
run([w/'host/release/portable-simd-corpus','--check',fixture])

manifest=json.loads((w/'manifest.json').read_text())
# Recent Cargo versions place full metadata in adjacent .rmeta files rather
# than in rlib stubs. Discover output directories instead of assuming deps/.
metas=list((BUILD/'cargo/knc-native/release').rglob('*.rmeta'))
if not metas:raise SystemExit('No target std metadata produced by Cargo')
flags=[]
for directory in sorted({p.parent for p in metas}):flags+=['-L','dependency='+str(directory)]
for name in ['core','std','compiler_builtins']:
    matching=[p for p in metas if p.name.startswith('lib'+name+'-')]
    if not matching:raise SystemExit('Missing target metadata: '+name)
    path=max(matching,key=lambda p:p.stat().st_mtime_ns)
    flags+=['--extern',name+'='+str(path)]
base=[rustc,'-Zunstable-options','--edition=2024','--crate-type=lib',
      '-Copt-level=2','-Cpanic=abort','-Cno-vectorize-loops','-Cno-vectorize-slp',
      '--target',SUPPORT/'targets/knc-native.json',*flags]
decoder=sdk_tool('objdump');require(decoder,'SDK objdump is required for the K1OM instruction audit')
# Binutils spells the low-half sources of these native IMCI conversions with
# YMM register names. That spelling alone is not evidence of an AVX instruction.
conversion_aliases={'vcvtps2pd','vcvtdq2pd','vcvtudq2pd'}

def group(g):
    name=g['element']+'-'+str(g['lanes']);ir=w/(name+'.ll');obj=w/(name+'.o')
    with (w/(name+'-compile.log')).open('w') as log:
        for cmd in [[*base,'--emit=llvm-ir',g['source'],'-o',ir], [LLVM_BUILD/'bin/llc','-mcpu=knc','-verify-machineinstrs','-filetype=obj','-O2',ir,'-o',obj]]:
            subprocess.run([str(x) for x in cmd],check=True,stdout=log,stderr=subprocess.STDOUT)
    data=obj.read_bytes()
    if data[:6]!=b'\x7fELF\x02\x01' or int.from_bytes(data[18:20],'little')!=181:
        raise RuntimeError('Expected native ELF64 K1OM object: '+name)
    text=subprocess.check_output([decoder,'-d','--no-show-raw-insn',str(obj)],text=True)
    instructions=0
    for line in text.splitlines():
        m=re.match(r'\s*[0-9a-f]+:\s+(\S+)',line)
        if not m:continue
        instructions+=1;op=m[1]
        if '(bad)' in line or re.fullmatch(r'cmov\w+|pause',op) or (re.search(r'%[xy]mm\d+',line) and op not in conversion_aliases):
            raise RuntimeError('Invalid/unapproved KNC instruction in '+name+': '+line)
    examples=[]
    native={('u32',16):('psimd_u32_16_add','vpaddd'),('f32',16):('psimd_f32_16_mul','vmulps'),('f64',8):('psimd_f64_8_add','vaddpd')}
    if (g['element'],g['lanes']) in native:
        symbol,instruction=native[(g['element'],g['lanes'])]
        body=re.search(r'^[0-9a-f]+ <'+symbol+r'>:\n(.*?)(?=^[0-9a-f]+ <|\Z)',text,re.M|re.S)
        if not body or not re.search(r'\b'+instruction+r'\b',body[1]):
            raise RuntimeError('Expected native SIMD instruction missing: '+symbol)
        examples.append({'function':symbol,'instruction':instruction})
    return {'native_examples':examples,'element':g['element'],'lanes':g['lanes'],'cases':len(g['cases']),
            'object_sha256':sha(obj),'instructions':instructions}
with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as pool:
    groups=list(pool.map(group,manifest['groups']))
record('portable-simd-local',{'status':'passed','api_cases':manifest['cases'],
    'groups':groups,'fixture_sha256':sha(fixture),'differential_trials':manifest['cases']*8,
    'target_hardware_run':'not_run_by_this_command',
    'compiler_sha256':sha(LLVM_BUILD/'bin/clang'),
    'llvm_patch_sha256':LOCK['llvm']['patch_sha256'],
    'target_binaries_sha256':{name:sha(BUILD/'cargo/knc-native/release'/name) for name in ['knc-portable-simd','portable-simd-corpus']}})
print('PASS portable SIMD local checks:',manifest['cases'],'API cases;',len(groups),'K1OM groups; target hardware run still required')
