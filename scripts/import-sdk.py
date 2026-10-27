#!/usr/bin/env python3
"""Copy a user-installed SDK locally and relocate only its x86-64 host tools."""
import argparse
from pathlib import Path
import shutil
import struct
import subprocess
from phi_common import SDK_ROOT

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--from',dest='source',type=Path,required=True)
p.add_argument('--patchelf',default=shutil.which('patchelf'))
a=p.parse_args();source=a.source.expanduser().resolve()
if not a.patchelf:raise SystemExit('Install patchelf on the host or pass --patchelf')
if not (source/'sysroots/k1om-mpss-linux').is_dir():raise SystemExit('Not an MPSS SDK root')
if SDK_ROOT.exists():raise SystemExit('Refusing to overwrite an existing local SDK: '+str(SDK_ROOT))
if SDK_ROOT.is_relative_to(source):raise SystemExit('Destination must be outside the source SDK')
SDK_ROOT.parent.mkdir(parents=True,exist_ok=True)
shutil.copytree(source,SDK_ROOT,symlinks=True)
host=(SDK_ROOT/'sysroots/x86_64-mpsssdk-linux').resolve()
loader=host/'lib/ld-linux-x86-64.so.2'
if not loader.is_file():raise SystemExit('Copied SDK is missing its host loader')
rpath=str(host/'lib')+':'+str(host/'usr/lib');seen=set();count=0
for entry in host.rglob('*'):
    path=entry.resolve()
    if not path.is_relative_to(host) or path in seen or not path.is_file():continue
    seen.add(path)
    with path.open('rb') as f:
        h=f.read(64)
        if len(h)<64 or h[:6]!=b'\x7fELF\x02\x01' or int.from_bytes(h[18:20],'little')!=62:continue
        off=struct.unpack_from('<Q',h,32)[0];size,num=struct.unpack_from('<HH',h,54)
        if size<56 or size*num>1024*1024:raise SystemExit('Invalid ELF program-header table')
        f.seek(off);headers=f.read(size*num)
        if len(headers)!=size*num:raise SystemExit('Truncated ELF program-header table')
        if not any(struct.unpack_from('<I',headers,i*size)[0]==3 for i in range(num)):continue
    subprocess.run([a.patchelf,'--set-interpreter',str(loader),'--force-rpath','--set-rpath',rpath,str(path)],check=True)
    count+=1
print('Copied SDK and relocated',count,'host executables; source SDK unchanged')
