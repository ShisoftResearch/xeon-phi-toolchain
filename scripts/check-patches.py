#!/usr/bin/env python3
"""Replay locked patches against pristine files from their pinned Git commits."""
import hashlib
from pathlib import Path
import re
import subprocess
import tempfile
from phi_common import ROOT, LOCK, LLVM_SOURCE, LLAMA_SOURCE, record

results={}
for name,source in [('llvm',LLVM_SOURCE),('llama',LLAMA_SOURCE)]:
    item=LOCK[name];patch=ROOT/item['patch'];data=patch.read_bytes()
    if hashlib.sha256(data).hexdigest()!=item['patch_sha256']:raise SystemExit('Locked patch hash mismatch: '+name)
    resolved=subprocess.check_output(['git','-C',str(source),'rev-parse',item['revision']+'^{commit}'],text=True).strip()
    if resolved!=item['revision']:raise SystemExit('Pinned commit unavailable: '+name)
    paths=re.findall(rb'^diff --git a/(\S+) b/(\S+)$',data,re.M)
    if not paths or any(a!=b for a,b in paths):raise SystemExit('Expected same-path text changes')
    with tempfile.TemporaryDirectory(prefix='phi-patch-') as temp:
        work=Path(temp);subprocess.run(['git','init','-q',temp],check=True)
        for raw,_ in paths:
            path=Path(raw.decode())
            if path.is_absolute() or '..' in path.parts:raise SystemExit('Unsafe patch path')
            p=subprocess.run(['git','-C',str(source),'show',item['revision']+':'+path.as_posix()],capture_output=True)
            if p.returncode==0:
                dest=work/path;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(p.stdout)
            elif subprocess.run(['git','-C',str(source),'cat-file','-e',item['revision']+':'+path.as_posix()],capture_output=True).returncode==0:
                raise SystemExit('Cannot read pinned source: '+str(path))
        subprocess.run(['git','-C',temp,'apply','--check',str(patch)],check=True)
        subprocess.run(['git','-C',temp,'apply',str(patch)],check=True)
        digests={p.decode():hashlib.sha256((work/p.decode()).read_bytes()).hexdigest() for p,_ in paths if (work/p.decode()).exists()}
    results[name]={'revision':item['revision'],'patch_sha256':item['patch_sha256'],'files_sha256':digests}
    print('PASS pristine patch replay:',name,len(paths),'changed files')
record('patch-replay',{'status':'passed','components':results})
