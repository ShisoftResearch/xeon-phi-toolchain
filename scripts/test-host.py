#!/usr/bin/env python3
"""Tests requiring only the host compiler and Python; no SDK or Phi is needed."""
import os
import subprocess
import sys
from phi_common import ROOT, BUILD, run, record

out=BUILD/'host-tests';out.mkdir(parents=True,exist_ok=True)
run([sys.executable,'-m','unittest','discover','-s',ROOT/'tests/python','-v'],cwd=ROOT)
header=ROOT/'include/k1om/capabilities.h';before=header.read_bytes()
run([sys.executable,ROOT/'scripts/generate-capability-catalog.py'])
if header.read_bytes()!=before:raise SystemExit('Generated capability header was stale')
records=[]
for compiler,language,standard in [(os.environ.get('HOST_CC','clang'),'c','c11'),(os.environ.get('HOST_CXX','clang++'),'c++','c++17')]:
    binary=out/('capability-contracts-'+standard)
    run([compiler,'-x',language,'-std='+standard,'-O2','-I',ROOT/'include',ROOT/'tests/capability-contracts.c','-o',binary])
    p=subprocess.run([binary],capture_output=True,text=True,check=True)
    print(p.stdout,end='');records.append({'test':standard,'stdout':p.stdout})
record('host-tests',{'status':'passed','tests':records})
