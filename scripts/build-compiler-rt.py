#!/usr/bin/env python3
"""Build released compiler-rt soft-FP builtins with the native KNC ABI."""
import concurrent.futures,json,pathlib,subprocess,hashlib
from phi_common import ROOT as root, LLVM_SOURCE, LLVM_BUILD, SDK_ROOT, SUPPORT, RECORDS
SUPPORT.mkdir(parents=True,exist_ok=True); RECORDS.mkdir(parents=True,exist_ok=True)
src=LLVM_SOURCE/'compiler-rt/lib/builtins';out=SUPPORT/'compiler-rt-knc';out.mkdir(parents=True,exist_ok=True)
names=['fp_mode','addsf3','adddf3','subsf3','subdf3','mulsf3','muldf3','divsf3','divdf3','comparesf2','comparedf2','negsf2','negdf2','extendsfdf2','truncdfsf2','extendhfsf2','extendhfdf2','truncsfhf2','truncdfhf2','powisf2','powidf2']
for ty in ['sf','df']:
 for size in ['si','di','ti']:
  names.extend([f'fix{ty}{size}',f'fixuns{ty}{size}',f'float{size}{ty}'])
 for size in ['si','di','ti']:
  names.append(f'floatun{size}{ty}')
# Compiler-rt spells unsigned si as unsi, not uns-si.
for name in names:assert (src/(name+'.c')).is_file(),name
flags=['--target=x86_64-unknown-linux-gnu','-march=knc','-O2','-ffreestanding','-fno-builtin','-fno-vectorize','-fno-slp-vectorize','-fno-stack-protector','-mno-red-zone','-Wa,-mrelax-relocations=no']
def compile_one(name):
    obj=out/(name+'.o')
    result=subprocess.run([str(LLVM_BUILD/'bin/clang'),*flags,'-c',str(src/(name+'.c')),'-o',str(obj)],capture_output=True,text=True)
    if result.returncode:raise RuntimeError(name+': '+result.stderr)
    return obj
with concurrent.futures.ThreadPoolExecutor(max_workers=8) as pool:
 objs=list(pool.map(compile_one,names))
sqrt_obj=SUPPORT/'knc-sqrt.o'
subprocess.run([str(LLVM_BUILD/'bin/clang'),*flags,'--sysroot='+str(SDK_ROOT/'sysroots/k1om-mpss-linux'),'-c',str(root/'runtime/sqrt.c'),'-o',str(sqrt_obj)],check=True)
objs.append(sqrt_obj)
minmax_obj=SUPPORT/'knc-minmax.o'
subprocess.run([str(LLVM_BUILD/'bin/clang'),*flags,'-c',str(root/'runtime/minmax.c'),'-o',str(minmax_obj)],check=True)
objs.append(minmax_obj)
approx_obj=SUPPORT/'knc-approx.o'
subprocess.run([str(LLVM_BUILD/'bin/clang'),*flags,'-c',str(root/'runtime/approx.c'),'-o',str(approx_obj)],check=True)
seed_obj=SUPPORT/'knc-approx-primitives.o'
subprocess.run([str(LLVM_BUILD/'bin/llc'),'-mcpu=knc','-mattr=-sse,-sse2,+soft-float,+knc-native-abi','-verify-machineinstrs','-filetype=obj',str(root/'runtime/approx-primitives.ll'),'-o',str(seed_obj)],check=True)
objs.extend([approx_obj,seed_obj])
trig_sources=sorted((root/'runtime/musl-math').glob('*.c'))+[root/'runtime/trig.c']
for source in trig_sources:
    obj=out/('trig-'+source.stem+'.o')
    subprocess.run([str(LLVM_BUILD/'bin/clang'),*flags,'-ffp-contract=off','--sysroot='+str(SDK_ROOT/'sysroots/k1om-mpss-linux'),'-c',str(source),'-o',str(obj)],check=True)
    objs.append(obj)
archive=SUPPORT/'libclang_rt.builtins-knc.a'
subprocess.run([str(LLVM_BUILD/'bin/llvm-ar'),'rcs',str(archive),*map(str,objs)],check=True)
(RECORDS/'compiler-rt-knc.json').write_text(json.dumps({'compiler_sha256':hashlib.sha256((LLVM_BUILD/'bin/clang').read_bytes()).hexdigest(),'source':'unmodified llvm-project/compiler-rt/lib/builtins','objects':names,'sqrt_shim':'runtime/sqrt.c','minmax_shim':'runtime/minmax.c','approx_kernels':['runtime/approx.c','runtime/approx-primitives.ll'],'approx_contract':'Default RNE, <=4 ULP guarded approximation, exact scalar fallback; afn and arcp permission required for division, afn for sqrt','flags':flags,'archive':str(archive),'sha256':hashlib.sha256(archive.read_bytes()).hexdigest()},indent=2)+'\n')
print(f'Built {len(names)} native compiler-rt objects plus sqrt/minmax shims: {archive}')
manifest=RECORDS/'compiler-rt-knc.json'
data=json.loads(manifest.read_text());data['trig_sources']=[str(p.relative_to(root)) for p in trig_sources];data['trig_provenance']='runtime/musl-math/provenance.json';data['trig_flags']=['-ffp-contract=off','-fno-builtin'];manifest.write_text(json.dumps(data,indent=2)+'\n')
