"""Paths and process helpers shared by the public toolchain commands."""
from __future__ import annotations
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess

ROOT = Path(__file__).resolve().parents[1]
def setting(name: str, default: Path) -> Path:
    return Path(os.environ.get(name, str(default))).expanduser().resolve()
BUILD = setting('PHI_BUILD_ROOT', ROOT / 'build')
SOURCES = setting('PHI_SOURCE_ROOT', ROOT / 'sources')
LLVM_SOURCE = setting('PHI_LLVM_SOURCE', SOURCES / 'llvm')
LLVM_BUILD = setting('PHI_LLVM_BUILD', BUILD / 'llvm')
RUST_SOURCE = setting('PHI_RUST_SOURCE', SOURCES / 'rust')
RUST_BUILD = setting('PHI_RUST_BUILD', BUILD / 'rust')
LLAMA_SOURCE = setting('PHI_LLAMA_SOURCE', SOURCES / 'llama')
SDK_ROOT = setting('PHI_SDK_ROOT', BUILD / 'sdk')
SUPPORT = BUILD / 'support'
RECORDS = BUILD / 'records'
CXX_PREFIX = setting('PHI_CXX_PREFIX', BUILD / 'cxx' / 'install')
HOST = 'x86_64-unknown-linux-gnu'
LOCK = json.loads((ROOT / 'sources.lock.json').read_text())
def sha(path: Path) -> str:
    with path.open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()
def run(argv, **kwargs):
    cmd = [str(x) for x in argv]
    print('+ ' + shlex.join(cmd), flush=True)
    return subprocess.run(cmd, check=True, **kwargs)
def record(name: str, data: dict):
    RECORDS.mkdir(parents=True, exist_ok=True)
    path = RECORDS / (name + '.json')
    temp = path.with_suffix('.tmp-'+str(os.getpid()))
    temp.write_text(json.dumps(data, indent=2) + '\n')
    temp.replace(path)
def sdk_tool(name: str) -> Path:
    return SDK_ROOT / 'sysroots/x86_64-mpsssdk-linux/usr/bin/k1om-mpss-linux' / ('k1om-mpss-linux-' + name)
def target_sysroot() -> Path:
    return SDK_ROOT / 'sysroots/k1om-mpss-linux'
def require(path: Path, message: str):
    if not path.exists():
        raise SystemExit(f'{message}: {path}')
def jobs() -> int:
    value = int(os.environ.get('PHI_JOBS', min(os.cpu_count() or 1, 8)))
    if value < 1:
        raise SystemExit('PHI_JOBS must be positive')
    return value

def sdk_bin() -> Path:
    """Create generic tool names in our build tree; never alter the user's SDK."""
    directory=SUPPORT/'sdk-bin';directory.mkdir(parents=True,exist_ok=True)
    for name in ['ld','as','ar','ranlib','nm','objcopy','objdump']:
        target=sdk_tool(name);link=directory/name
        require(target,'Missing SDK host tool')
        if link.is_symlink() and link.readlink()!=target:link.unlink()
        if not link.exists():link.symlink_to(target)
    return directory
