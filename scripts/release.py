#!/usr/bin/env python3
"""Audit and package only the tracked public source tree."""
from __future__ import annotations
import argparse
import gzip
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import tarfile
from phi_common import ROOT, LOCK, sha

PATTERNS = [
    ('private key', rb'-----BEGIN (?:(?:OPENSSH|RSA|EC|DSA|ENCRYPTED) )?PRIVATE KEY-----'),
    ('SSH public key', rb'(?:ssh-ed25519|ssh-rsa) [A-Za-z0-9+/]{40,}'),
    ('private IPv4 address', rb'\b(?:192\.168|172\.(?:1[6-9]|2[0-9]|3[01]))\.\d{1,3}\.\d{1,3}\b|\b10\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'),
    ('workstation home path', rb'/home/[A-Za-z0-9_-]+/'),
    ('credential assignment', rb'(?im)^\s*(?:password|passwd|api_key|access_token|secret_key)\s*[:=]\s*[\x22\x27]?[A-Za-z0-9+/=_-]{6,}'),
]
FORBIDDEN_PARTS = {'sources','build','dist','evidence','.local','.ssh','mpss-sdk','models','__pycache__'}
FORBIDDEN_NAMES = {'ssh-cards.conf','authorized_keys','known_hosts','id_ed25519','id_rsa','.env'}

def inspect_file(name: str, data: bytes) -> list[str]:
    p=Path(name);problems=[]
    if set(p.parts)&FORBIDDEN_PARTS or p.name in FORBIDDEN_NAMES:
        problems.append('excluded local/generated file')
    if p.suffix in {'.gguf','.o','.a','.so','.rpm','.deb','.pyc','.pem','.key'}:
        problems.append('binary/model/credential file')
    if b'\x00' in data or data.startswith(b'\x7fELF'):
        problems.append('binary payload')
    for label,pattern in PATTERNS:
        if re.search(pattern,data):problems.append(label)
    return problems

def tracked_files() -> list[str]:
    files=subprocess.check_output(['git','-C',str(ROOT),'ls-files','-z']).decode().split('\0')
    result=sorted(filter(None,files))
    if not result:raise SystemExit('No tracked source files; stage the reviewed public source tree first')
    return result

def audit() -> list[str]:
    files=tracked_files();errors=[]
    for name in files:
        p=ROOT/name
        if p.is_symlink():errors.append(name+': symlinks are not allowed in the source release');continue
        if not p.is_file():errors.append(name+': missing tracked file');continue
        for reason in inspect_file(name,p.read_bytes()):errors.append(name+': '+reason)
    for c in ['llvm','llama']:
        if sha(ROOT/LOCK[c]['patch'])!=LOCK[c]['patch_sha256']:errors.append(c+': patch hash differs from lock')
    if errors:raise SystemExit('Source release audit failed:\n'+'\n'.join(errors))
    print(f'PASS source release audit: {len(files)} tracked files; no excluded artifacts or detected credentials')
    return files

def package(output: Path):
    files=audit()
    if subprocess.check_output(['git','-C',str(ROOT),'status','--porcelain']).strip():
        raise SystemExit('Commit the reviewed source tree before producing a release archive')
    output=output.expanduser().resolve()
    if output.exists():raise SystemExit('Refusing to overwrite an existing release artifact: '+str(output))
    commit=subprocess.check_output(['git','-C',str(ROOT),'rev-parse','HEAD'],text=True).strip()
    epoch=int(subprocess.check_output(['git','-C',str(ROOT),'show','-s','--format=%ct','HEAD'],text=True))
    version=(ROOT/'VERSION').read_text().strip();prefix='xeon-phi-toolchain-'+version
    manifest={'schema_version':1,'version':version,'commit':commit,'kind':'source',
              'files_sha256':{n:sha(ROOT/n) for n in files},'excluded':['Intel SDK','models','build outputs','private hardware evidence','Git history']}
    output.parent.mkdir(parents=True,exist_ok=True)
    partial=output.with_name(output.name+'.partial')
    if partial.exists():raise SystemExit('A partial artifact already exists: '+str(partial))
    with partial.open('xb') as raw,gzip.GzipFile(filename='',mode='wb',fileobj=raw,mtime=epoch) as gz,tarfile.open(fileobj=gz,mode='w') as tar:
        for n in files+['SOURCE-MANIFEST.json']:
            data=(json.dumps(manifest,indent=2)+'\n').encode() if n=='SOURCE-MANIFEST.json' else (ROOT/n).read_bytes()
            info=tarfile.TarInfo(prefix+'/'+n);info.size=len(data);info.mtime=epoch
            info.mode=0o755 if n.startswith('bin/') or (n!='SOURCE-MANIFEST.json' and (ROOT/n).stat().st_mode&0o111) else 0o644
            tar.addfile(info,io.BytesIO(data))
    # Read back every payload before making the completed archive visible.
    with tarfile.open(partial,'r:gz') as tar:
        for n,h in manifest['files_sha256'].items():
            f=tar.extractfile(prefix+'/'+n)
            if f is None or hashlib.sha256(f.read()).hexdigest()!=h:raise SystemExit('Archive readback mismatch: '+n)
    partial.replace(output)
    checksum=output.with_name(output.name+'.sha256')
    checksum.write_text(sha(output)+'  '+output.name+'\n')
    print('PASS verified source archive:',output.name)
    print(checksum.read_text(),end='')

def main():
    p=argparse.ArgumentParser(description=__doc__);sub=p.add_subparsers(dest='command',required=True)
    sub.add_parser('check');pack=sub.add_parser('package');pack.add_argument('--output',type=Path,required=True)
    a=p.parse_args()
    if a.command=='check':audit()
    else:package(a.output)
if __name__=='__main__':main()
