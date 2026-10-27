#!/usr/bin/env python3
"""Build the pinned target C++ library with KNC Clang in an isolated directory."""
import argparse,datetime,hashlib,json,os,pathlib,subprocess,tarfile,urllib.request
from phi_common import ROOT as root, BUILD, LLVM_BUILD, SDK_ROOT, CXX_PREFIX, RECORDS
RECORDS.mkdir(parents=True,exist_ok=True)
p=argparse.ArgumentParser();p.add_argument('--jobs',type=int,default=8);p.add_argument('--configure-only',action='store_true');args=p.parse_args();assert args.jobs>0
version='13.4.0';digest='9b4b83ecf51ef355b868608b8d257b2fa435c06d2719cb86657a7c2c2a0828ff4ce04e9bac1055bbcad8ed5b4da524cafaef654785e23a50233d95d89201e35f'
cache=BUILD/'gcc-source';cache.mkdir(exist_ok=True);archive=cache/f'gcc-{version}.tar.xz'
if not archive.exists():
 partial=archive.with_suffix('.partial')
 with urllib.request.urlopen(f'https://gcc.gnu.org/pub/gcc/releases/gcc-{version}/gcc-{version}.tar.xz',timeout=120) as response,partial.open('wb') as out:
  import shutil
  shutil.copyfileobj(response,out)
 assert hashlib.file_digest(partial.open('rb'),'sha512').hexdigest()==digest
 partial.replace(archive)
assert hashlib.file_digest(archive.open('rb'),'sha512').hexdigest()==digest
source=cache/f'gcc-{version}'
if not source.exists():
 with tarfile.open(archive) as tar:tar.extractall(cache,filter='data')
compiler=hashlib.file_digest((LLVM_BUILD/'bin/clang').open('rb'),'sha256').hexdigest()
script=hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest();key=hashlib.sha256((compiler+script+digest).encode()).hexdigest()[:12]
build=BUILD/'cxx'/key;build.mkdir(parents=True,exist_ok=True);prefix=CXX_PREFIX
# GCC's top-level build normally supplies this generated gthread selection.
# Supply its POSIX choice for the standalone target-library configure probes.
import shutil
thread_headers=build.parent/'libgcc';thread_headers.mkdir(exist_ok=True)
shutil.copyfile(source/'libgcc/gthr-posix.h',thread_headers/'gthr-default.h')
sdk=SDK_ROOT/'sysroots/x86_64-mpsssdk-linux/usr/bin/k1om-mpss-linux';env=os.environ.copy()
# Assembler acceptance is not a KNC CPU capability check.
platform_cache={'ac_cv_x86_rdrand':'no','ac_cv_x86_rdseed':'no'}
env.update(platform_cache)
# Do not let include_next in the new library find the SDK's older C++
# wrappers. Bootstrap against C headers until the new headers are generated.
import shlex
bootstrap=build/'bootstrap-cxx'
bootstrap.write_text('#!/usr/bin/env bash\nset -euo pipefail\nexec '+shlex.quote(str(root/'bin/clang-knc'))+' --driver-mode=g++ -nostdinc++ "$@"\n')
bootstrap.chmod(0o755)
env.update(CC=str(root/'bin/clang-knc'),CXX=str(bootstrap),CFLAGS='-O2 -fPIC',CXXFLAGS='-O2 -fPIC')
for name in ['AR','RANLIB','AS','LD','NM']:env[name]=str(sdk/('k1om-mpss-linux-'+name.lower()))
command=[source/'libstdc++-v3/configure','--build=x86_64-pc-linux-gnu','--host=x86_64-knc-linux-gnu','--with-cross-host=x86_64-pc-linux-gnu','--prefix='+str(prefix),'--disable-multilib','--disable-shared','--enable-static','--disable-libstdcxx-pch','--disable-libstdcxx-backtrace','--enable-libstdcxx-threads','--enable-libstdcxx-filesystem-ts','--with-default-libstdcxx-abi=new']
record={'time_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'version':version,'source_sha512':digest,'compiler_sha256':compiler,'script_sha256':script,'build_directory':str(build),'prefix':str(prefix),'configure':[str(a) for a in command],'status':'started','platform_cache':platform_cache,'scope':'Build/install evidence only; runtime correctness and llama.cpp gates must be verified separately'}
status=0
for label,cmd in [('configure',command)]+([] if args.configure_only else [('build',['make','-j'+str(args.jobs)]),('install',['make','install'])]):
 print('RUN target libstdc++',label,build,flush=True)
 log=RECORDS/f'libstdcxx-{label}.log'
 with log.open('w') as output:result=subprocess.run([str(a) for a in cmd],cwd=build,env=env,stdout=output,stderr=subprocess.STDOUT)
 record[label+'_log']=str(log)
 if result.returncode:record.update(status=label+'_failed',returncode=result.returncode);status=result.returncode;break
 if label=='configure':
  # This GCC-only switch is redundant without -g; Clang emits no .loc directives.
  # Keep both string ABIs and their ios_failure bridge instead of disabling it.
  makefile=build/'src/c++11/Makefile'
  text=makefile.read_text();assert text.count('-gno-as-loc-support')==2
  makefile.write_text(text.replace(' -gno-as-loc-support',''))
  record['build_adjustments']=['Remove the GCC-only -gno-as-loc-support from the generated ios_failure assembly rules; CXXFLAGS has no debug information; dual ABI remains enabled']
else:record['status']='configured' if args.configure_only else 'built_and_installed'
(RECORDS/'libstdcxx-build.json').write_text(json.dumps(record,indent=2)+'\n');print(record['status'],flush=True);raise SystemExit(status)
