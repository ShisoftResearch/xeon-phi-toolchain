#!/usr/bin/env python3
"""Fetch, build and test the pinned Xeon Phi toolchain."""
from __future__ import annotations
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
from phi_common import *

LLVM_TOOLS = ['clang','llc','opt','llvm-link','llvm-as','llvm-dis','llvm-mc',
              'llvm-readobj','llvm-config','llvm-objdump','llvm-ar','FileCheck','count','not']
RUST_LLVM_TOOLS = ['LLVMLTO','LLVMCoverage','LLVMInstrumentation','LLVMMCA','LLVMX86TargetMCA',
                   'llvm-cov','llvm-nm','llvm-objcopy','llvm-profdata','llvm-size','llvm-strip']

def git(path, *args):
    return subprocess.check_output(['git','-C',str(path),*args],text=True,stderr=subprocess.DEVNULL).strip()

def prepare(component: str, local: str | None = None):
    item=LOCK[component]
    source={'llvm':LLVM_SOURCE,'rust':RUST_SOURCE,'llama':LLAMA_SOURCE}[component]
    patch=ROOT/item['patch'] if 'patch' in item else None
    if patch and sha(patch)!=item['patch_sha256']:
        raise SystemExit('Patch hash differs from sources.lock.json: '+str(patch))
    if not (source/'.git').exists():
        if source.exists() and any(source.iterdir()):
            raise SystemExit('Refusing to initialize a nonempty source directory: '+str(source))
        source.mkdir(parents=True,exist_ok=True)
        run(['git','init','-q',source])
        run(['git','-C',source,'remote','add','origin',item['url']])
    try:
        head=git(source,'rev-parse','HEAD')
    except subprocess.CalledProcessError:
        run(['git','-C',source,'fetch','--depth','1',local or item['url'],item['revision']])
        run(['git','-C',source,'checkout','--detach','FETCH_HEAD'])
        head=git(source,'rev-parse','HEAD')
    if head!=item['revision']:
        raise SystemExit('Source revision differs from the lock; existing checkout left intact: '+str(source))
    if patch:
        difference=subprocess.check_output(['git','-C',str(source),'diff','--binary','HEAD'])
        if difference:
            if difference!=patch.read_bytes():
                raise SystemExit('Source has changes other than the locked patch: '+str(source))
            print('Locked patch already applied:',component)
        else:
            if git(source,'status','--porcelain','--untracked-files=normal'):
                raise SystemExit('Refusing to patch a dirty source tree: '+str(source))
            run(['git','-C',source,'apply','--check',patch])
            run(['git','-C',source,'apply','--index',patch])
        if subprocess.check_output(['git','-C',str(source),'diff','--binary','HEAD'])!=patch.read_bytes():
            raise SystemExit('Applied source differs from the locked patch')
    elif git(source,'status','--porcelain','--untracked-files=normal'):
        raise SystemExit('Expected unmodified source: '+str(source))
    if git(source,'ls-files','--others','--exclude-standard'):
        raise SystemExit('Unexpected untracked source files; existing checkout left intact: '+str(source))
    record('source-'+component,{'revision':head,'patch_sha256':sha(patch) if patch else None})
    return source

def build_llvm():
    require(LLVM_SOURCE/'llvm/CMakeLists.txt','Run fetch llvm first')
    run(['cmake','-S',LLVM_SOURCE/'llvm','-B',LLVM_BUILD,'-G','Ninja',
         '-DCMAKE_BUILD_TYPE=Release','-DLLVM_TARGETS_TO_BUILD=X86',
         '-DLLVM_ENABLE_PROJECTS=clang','-DLLVM_INCLUDE_TESTS=ON',
         '-DLLVM_BUILD_TOOLS=ON','-DLLVM_ENABLE_ASSERTIONS=ON',
         '-DLLVM_ENABLE_ZSTD=OFF','-DLLVM_ENABLE_ZLIB=OFF',
         '-DCMAKE_C_COMPILER='+os.environ.get('CC','clang'),
         '-DCMAKE_CXX_COMPILER='+os.environ.get('CXX','clang++'),'-DLLVM_PARALLEL_LINK_JOBS=2'])
    run(['cmake','--build',LLVM_BUILD,'--parallel',jobs(),'--target',*LLVM_TOOLS])
    record('llvm',{'revision':LOCK['llvm']['revision'],'patch_sha256':sha(ROOT/LOCK['llvm']['patch']),
                   'compiler_sha256':sha(LLVM_BUILD/'bin/clang')})

def build_rust():
    require(RUST_SOURCE/'x','Run fetch rust first')
    toolchain=LOCK['rust']['bootstrap_toolchain']
    rustc=subprocess.check_output(['rustup','which','--toolchain',toolchain,'rustc'],text=True).strip()
    cargo=subprocess.check_output(['rustup','which','--toolchain',toolchain,'cargo'],text=True).strip()
    version=subprocess.check_output([rustc,'-vV'],text=True)
    if 'commit-hash: '+LOCK['rust']['revision'] not in version:
        raise SystemExit('Bootstrap rustc revision does not match the lock')
    run(['git','-C',RUST_SOURCE,'submodule','update','--init','--depth','1','library/backtrace'])
    run(['cmake','--build',LLVM_BUILD,'--parallel',jobs(),'--target',*RUST_LLVM_TOOLS])
    BUILD.mkdir(parents=True,exist_ok=True)
    q=lambda p:json.dumps(str(p))
    config=BUILD/'rust-bootstrap.toml'
    config.write_text('change-id = 999999\n[llvm]\ndownload-ci-llvm = false\nlink-shared = false\n'
        '[build]\nbuild-dir = '+q(RUST_BUILD)+'\nrustc = '+q(rustc)+'\ncargo = '+q(cargo)+
        '\ndocs = false\nextended = false\nsubmodules = false\njobs = '+str(jobs())+
        '\noptimized-compiler-builtins = false\n[rust]\ndownload-rustc = false\nchannel = "nightly"\n'
        'deny-warnings = false\ndebuginfo-level = 0\ncodegen-units = 16\nlto = "off"\n'
        '[target.x86_64-unknown-linux-gnu]\nllvm-config = '+q(LLVM_BUILD/'bin/llvm-config')+
        '\nllvm-has-rust-patches = false\n')
    run([RUST_SOURCE/'x','build','--config',config,'--stage','1','compiler/rustc','library/std'],cwd=ROOT)
    record('rust',{'revision':LOCK['rust']['revision'],'llvm_patch_sha256':sha(ROOT/LOCK['llvm']['patch'])})

def llama_options(arch: str, profile: str):
    options=['-G','Ninja','-DCMAKE_BUILD_TYPE=Release','-DBUILD_SHARED_LIBS=OFF',
        '-DGGML_NATIVE=OFF','-DGGML_CPU_ALL_VARIANTS=OFF','-DGGML_OPENMP=OFF',
        '-DGGML_LLAMAFILE=OFF','-DGGML_AVX512=OFF','-DGGML_AVX512_VBMI=OFF',
        '-DGGML_AVX512_VNNI=OFF','-DGGML_AVX512_BF16=OFF','-DGGML_AVX_VNNI=OFF',
        '-DGGML_AMX_TILE=OFF','-DGGML_AMX_INT8=OFF','-DGGML_AMX_BF16=OFF',
        '-DLLAMA_OPENSSL=OFF','-DLLAMA_BUILD_SERVER=OFF','-DLLAMA_BUILD_TESTS=ON',
        '-DLLAMA_BUILD_TOOLS=ON','-DLLAMA_BUILD_EXAMPLES=ON','-DGGML_RPC=OFF']
    if arch=='knc':
        if profile not in ['default','scalar']:
            raise SystemExit('KNC profiles: default, scalar')
        options+=['-DCMAKE_TOOLCHAIN_FILE='+str(ROOT/'cmake/k1om-toolchain.cmake'),'-DK1OM_MODERN_CXX=ON',
            '-DGGML_CPU_REPACK=OFF','-DGGML_SSE42=OFF','-DGGML_AVX=OFF','-DGGML_AVX2=OFF',
            '-DGGML_BMI2=OFF','-DGGML_FMA=OFF','-DGGML_F16C=OFF',
            '-DGGML_K1OM_NATIVE_QUANTS='+('OFF' if profile=='scalar' else 'ON'),
            '-DK1OM_CAPABILITY_INCLUDE_DIR='+str(ROOT/'include')]
        for option in ['PARALLEL_ACTIVATIONS','VECTOR_KSUMS','PARALLEL_GATHER','Q4_VECTOR_ACCUM','Q6_VECTOR_SCALES','MM_TILES']:
            options+=['-DGGML_K1OM_'+option+'='+('ON' if profile=='default' else 'OFF')]
        options+=['-DGGML_K1OM_Q4_PREFETCH='+('8' if profile=='default' else '0')]
    else:
        if profile not in ['default','avx2','repack','rows4']:
            raise SystemExit('KNL profiles: default, avx2, repack, rows4')
        flags='-march=knl -mtune=knl'+(' -mno-avx512f' if profile=='avx2' else '')
        options+=['-DCMAKE_C_COMPILER='+str(LLVM_BUILD/'bin/clang'),
            '-DCMAKE_CXX_COMPILER='+str(LLVM_BUILD/'bin/clang++'),
            '-DCMAKE_C_FLAGS='+flags,'-DCMAKE_CXX_FLAGS='+flags,
            '-DGGML_CPU_REPACK='+('ON' if profile=='repack' else 'OFF'),
            '-DGGML_KNL_ROWS4='+('ON' if profile=='rows4' else 'OFF')]
    return options

def build_llama(arch: str, profile: str):
    require(LLAMA_SOURCE/'CMakeLists.txt','Run fetch llama first')
    # Verify the exact source snapshot before compiling.
    prepare('llama')
    path=BUILD/'llama'/arch/profile
    options=llama_options(arch,profile)
    run(['cmake','-S',LLAMA_SOURCE,'-B',path,*options])
    names=['llama-completion','llama-bench','test-backend-ops','test-quantize-fns']
    run(['cmake','--build',path,'--parallel',jobs(),'--target',*names])
    record('llama-'+arch+'-'+profile,{'arch':arch,'profile':profile,'source_revision':LOCK['llama']['revision'],
        'source_patch_sha256':LOCK['llama']['patch_sha256'],'compiler_sha256':sha(LLVM_BUILD/'bin/clang'),
        'options':options,'binaries_sha256':{n:sha(path/'bin'/n) for n in names}})

def test_codegen():
    paths=sorted((LLVM_SOURCE/'llvm/test/CodeGen/X86').glob('knc-*'))
    paths += [LLVM_SOURCE/'clang/test'/p for p in ['CodeGen/X86/knc.c','Preprocessor/knc.c','Frontend/x86-target-cpu.c']]
    if len(paths)<3 or not all(p.exists() for p in paths):
        raise SystemExit('Patched LLVM test sources are required')
    run([LLVM_BUILD/'bin/llvm-lit','-v',*paths])

def doctor():
    checks={name:shutil.which(name) for name in ['git','cmake','ninja','clang','clang++','python3','make','rustup','patchelf']}
    print(json.dumps({'host':sys.platform,'python':sys.version.split()[0],
        'tools':checks,'llvm_source':str(LLVM_SOURCE),'llvm_build':str(LLVM_BUILD),
        'sdk':str(SDK_ROOT),'sdk_linker_exists':sdk_tool('ld').exists(),
        'sdk_target_headers':(target_sysroot()/'usr/include').is_dir()},indent=2))
    return 0 if all(checks[k] for k in ['git','cmake','ninja','clang','clang++','python3']) else 1

def main():
    p=argparse.ArgumentParser(description=__doc__);sub=p.add_subparsers(dest='command',required=True)
    sub.add_parser('doctor')
    f=sub.add_parser('fetch');f.add_argument('component',choices=['llvm','rust','llama']);f.add_argument('--local',help='Existing local Git repository as a fetch source; pinned commit is still enforced')
    for name in ['build-llvm','build-runtime','build-cxx','build-rust','test-codegen','test-host','test-patches','check-release']:
        sub.add_parser(name)
    simd=sub.add_parser('test-portable-simd');simd.add_argument('--offline',action='store_true')
    ll=sub.add_parser('build-llama');ll.add_argument('--arch',choices=['knc','knl'],required=True);ll.add_argument('--profile',default='default')
    ll.add_argument('--print-options',action='store_true')
    pack=sub.add_parser('package');pack.add_argument('--output',type=Path,required=True)
    a=p.parse_args()
    if a.command=='doctor':return doctor()
    if a.command=='fetch':prepare(a.component,a.local)
    elif a.command=='build-llvm':prepare('llvm');build_llvm()
    elif a.command=='build-runtime':run([sys.executable,ROOT/'scripts/build-compiler-rt.py'])
    elif a.command=='build-cxx':run([sys.executable,ROOT/'scripts/build-libstdcxx.py','--jobs',jobs()])
    elif a.command=='build-rust':prepare('rust');build_rust()
    elif a.command=='build-llama':
        if a.print_options:print(json.dumps(llama_options(a.arch,a.profile),indent=2))
        else:build_llama(a.arch,a.profile)
    elif a.command=='test-codegen':test_codegen()
    elif a.command=='test-patches':run([sys.executable,ROOT/'scripts/check-patches.py'])
    elif a.command=='test-portable-simd':run([sys.executable,ROOT/'scripts/test-portable-simd.py',*(['--offline'] if a.offline else [])])
    elif a.command=='test-host':run([sys.executable,ROOT/'scripts/test-host.py'])
    elif a.command=='check-release':run([sys.executable,ROOT/'scripts/release.py','check'])
    elif a.command=='package':run([sys.executable,ROOT/'scripts/release.py','package','--output',a.output])
    return 0

if __name__=='__main__':
    try:raise SystemExit(main())
    except subprocess.CalledProcessError as exc:raise SystemExit(exc.returncode)
