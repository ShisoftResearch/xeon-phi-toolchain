"""Relocatable C/C++ and native-ABI Rust front ends for KNC."""
from __future__ import annotations
import json
import os
from pathlib import Path
import subprocess
import sys
from phi_common import *

def linking(args):
    if len(args)==1 and args[0] in ['-v','-###','--help']:return False
    return not any(a in ['-c','-S','-E','-fsyntax-only','--version'] or a.startswith('-print-') for a in args)

def ensure_runtime():
    archive=SUPPORT/'libclang_rt.builtins-knc.a'
    sources=list((ROOT/'runtime').glob('*'))+list((ROOT/'runtime/musl-math').glob('*'))
    sources += [ROOT/'scripts/build-compiler-rt.py',LLVM_BUILD/'bin/clang',LLVM_BUILD/'bin/llc']
    manifest=RECORDS/'compiler-rt-knc.json'
    compiler_changed=not manifest.exists() or json.loads(manifest.read_text()).get('compiler_sha256')!=sha(LLVM_BUILD/'bin/clang')
    if not archive.exists() or compiler_changed or any(p.is_file() and p.stat().st_mtime>archive.stat().st_mtime for p in sources):
        run([sys.executable,ROOT/'scripts/build-compiler-rt.py'])
    return archive

def compiler(mode: str, args: list[str]):
    require(LLVM_BUILD/'bin/clang','Build LLVM first')
    sysroot=target_sysroot()
    # Full Linux applications require the separately supplied SDK, including its linker.
    require(sysroot/'usr/include','Set PHI_SDK_ROOT to an installed MPSS SDK')
    flags=['--target='+HOST,'-march=knc','--sysroot='+str(sysroot),
        '--gcc-install-dir='+str(sysroot/'usr/lib64/k1om-mpss-linux/5.1.1'),
        '-B'+str(sdk_bin())+'/', '-mno-red-zone','-Wa,-mrelax-relocations=no']
    is_link=linking(args)
    cxx=mode.startswith('clang++')
    modern=mode=='clang++-knc-modern'
    if cxx:
        flags+=['--driver-mode=g++','-nostdinc++']
        include=CXX_PREFIX/'x86_64-knc-linux-gnu/include/c++/13.4.0' if modern else sysroot/'usr/include/c++'
        require(include,'Build C++17 support first with build-cxx' if modern else 'Missing SDK C++ headers')
        target='x86_64-knc-linux-gnu' if modern else 'k1om-mpss-linux'
        for p in [include,include/target,include/'backward']:flags+=['-isystem',str(p)]
        if modern and is_link:
            require(CXX_PREFIX/'x86_64-knc-linux-gnu/lib/libstdc++.a','Build C++17 support first')
            flags+=['-nostdlib++']
    if is_link:
        require(sdk_tool('ld'),'Missing K1OM linker in SDK')
        archive=ensure_runtime()
        flags+=['--ld-path='+str(sdk_tool('ld')),'-no-pie','-Wl,-m,elf_k1om','-Wl,--dynamic-linker=/lib64/ld-linux-k1om.so.2']
        command=[str(LLVM_BUILD/'bin/clang'),*flags,str(SUPPORT/'knc-sqrt.o'),*args]
        if modern:command+=[str(CXX_PREFIX/'x86_64-knc-linux-gnu/lib/libstdc++.a')]
        command += [str(archive),'-lm']
    else:command=[str(LLVM_BUILD/'bin/clang'),*flags,*args]
    os.execv(command[0],command)

def rust_link(args: list[str]):
    # rustc emits an x86-64 ELF object containing undefined roots only. Re-emit
    # that metadata with the K1OM assembler; never translate executable code.
    out=[]
    for arg in args:
        if arg=='--knc-native-abi':continue
        if arg.endswith('/symbols.o'):
            dest=str(Path(arg).with_name('symbols-k1om.o'))
            run([sys.executable,ROOT/'scripts/prepare-link-symbols.py',arg,dest])
            arg=dest
        out.append(arg)
    exe=sdk_tool('gcc');require(exe,'Set PHI_SDK_ROOT to the installed SDK')
    command=[str(exe),'-B'+str(sdk_bin())+'/', '--sysroot='+str(target_sysroot()),*out]
    os.execv(command[0],command)

def cargo(args: list[str]):
    if not args or args[0] not in ['build','check']:
        raise SystemExit('Usage: cargo-knc build|check [cargo options]')
    rustc=RUST_BUILD/HOST/'stage1/bin/rustc'
    require(rustc,'Build the pinned Rust compiler first with build-rust')
    archive=ensure_runtime()
    targets=SUPPORT/'targets';targets.mkdir(parents=True,exist_ok=True)
    spec=json.loads((ROOT/'targets/knc-native.json').read_text())
    spec['linker']=str(ROOT/'bin/knc-link')
    target=targets/'knc-native.json';text=json.dumps(spec,indent=2)+'\n'
    if not target.exists() or target.read_text()!=text:target.write_text(text)
    env=os.environ.copy();env['RUSTC']=str(rustc)
    flags=['-Cno-vectorize-loops','-Cno-vectorize-slp','-Cllvm-args=-x86-relax-relocations=false','-Clto=off']
    for path in [SUPPORT/'knc-sqrt.o',SUPPORT/'knc-minmax.o',archive]:
        if any(ch.isspace() for ch in str(path)):
            raise SystemExit('Cargo runtime paths currently require a checkout/build path without whitespace')
        flags+=['-Clink-arg='+str(path)]
    # Encoded flags preserve an existing caller's flag boundaries.
    existing=env.get('CARGO_ENCODED_RUSTFLAGS')
    if existing is None:
        import shlex
        base=shlex.split(env.pop('RUSTFLAGS',''))
    else:base=existing.split('\x1f') if existing else []
    env['CARGO_ENCODED_RUSTFLAGS']='\x1f'.join([*base,*flags])
    if env.get('PHI_AUTOVECTORIZE')=='1':
        env['RUSTC_WORKSPACE_WRAPPER']=str(ROOT/'scripts/rustc-knc-autovec')
    cmd=['cargo','+'+LOCK['rust']['bootstrap_toolchain'],*args,'-Z','json-target-spec',
         '-Z','build-std=std,panic_abort','--target',str(target),'--target-dir',str(BUILD/'cargo')]
    os.execvpe(cmd[0],cmd,env)

def main():
    mode=Path(sys.argv[0]).name;args=sys.argv[1:]
    if mode=='knc-link':rust_link(args)
    elif mode=='cargo-knc':cargo(args)
    else:compiler(mode,args)
