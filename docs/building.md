# Building and using the toolchain

## Host and dependency requirements

The tested build host is x86-64 Linux. Python 3.12+ is required for safe tar
extraction. Install Git, CMake, Ninja, Clang/Clang++, Make, and standard host C/C++
development headers. A host MPFR 4 LP64 library is optional and needed only for
MPFR-based numerical corpus generators. Network access is used to fetch pinned
upstream sources and Rust/GCC dependencies; model downloads are not automated.

LLVM and especially Rust builds need tens of GiB of working space. Set
`PHI_JOBS=4` on a memory-constrained machine. No compiler, runtime or package
command requires root or changes the running kernel.

`sources.lock.json` is the dependency authority. Source preparation checks the
exact upstream commit and patch SHA256, is repeatable, and refuses unrelated
local changes. It does not reset or clean an existing source tree. `fetch`
accepts `--local /path/to/git/repository` to use a local cache while enforcing
the same pinned commit.

## Paths

All paths default relative to this checkout:

| Variable | Default | Purpose |
|---|---|---|
| `PHI_SOURCE_ROOT` | `sources/` | Downloaded upstream checkouts |
| `PHI_BUILD_ROOT` | `build/` | Generated products and records |
| `PHI_LLVM_SOURCE` | `sources/llvm` | LLVM source override |
| `PHI_LLVM_BUILD` | `build/llvm` | Patched LLVM build override |
| `PHI_LLAMA_SOURCE` | `sources/llama` | Patched llama.cpp source override |
| `PHI_RUST_SOURCE` | `sources/rust` | Pinned Rust source override |
| `PHI_RUST_BUILD` | `build/rust` | Rust bootstrap output override |
| `PHI_SDK_ROOT` | `build/sdk` | User-supplied MPSS SDK |
| `PHI_CXX_PREFIX` | `build/cxx/install` | Target C++ library installation |
| `PHI_JOBS` | min(host CPUs, 8) | Build parallelism |

Build-time path records are local and ignored. Do not commit them. Cargo's KNC
runtime paths currently require a checkout/build path without whitespace.

## SDK and linker

The tested SDK is MPSS 3.8.6, with GCC 5.1.1 target installation directories.
Obtain and install it independently. The `bin/clang-knc` wrapper uses its Linux
headers/startup libraries and explicitly selects its **K1OM linker**. LLVM's
normal host linker cannot link ELF machine 181. Generic SDK tool names are
created as symlinks under our build directory, leaving the SDK unchanged.

If SDK host tools cannot start because their ELF interpreter names a missing
old installation path, make a private writable SDK copy and use
`scripts/import-sdk.py --from /your/installed/sdk`. That command copies to
`build/sdk` and relocates only x86-64 host executables with the host `patchelf`.
It does not modify your installed SDK or K1OM executables. Keep the SDK out of
source and release archives.

## C and C++

`bin/clang-knc` and `bin/clang++-knc` use the SDK C/legacy C++ environment.
`bin/clang++-knc-modern` explicitly uses the separately built static GCC
13.4.0 libstdc++ and its headers. `build-cxx` verifies the upstream GCC archive
SHA512 and builds only the target library with our Clang. GNU runtime licensing
continues to apply to that separately generated library.

For CMake applications:

```sh
cmake -S tests/application-readiness -B build/application -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="$PWD/cmake/k1om-toolchain.cmake" \
  -DK1OM_MODERN_CXX=ON
cmake --build build/application
```

Native KNC runtime math is built from pinned compiler-rt plus local helpers.
The wrappers build the runtime when needed; explicit `build-runtime` is useful
for diagnostics. See `runtime/FP-ENVIRONMENT.rst` and `runtime/APPROX.rst`.

## Rust

`build-rust` requires the pinned nightly Cargo/rustc bootstrap, verifies its
commit, generates a path-specific bootstrap configuration under `build/`, and
builds stage1 against the patched LLVM. Rust sources are not patched. Standard
library dependencies may be fetched on the first Cargo build; add `--offline`
only after the relevant registry cache is populated.

`bin/cargo-knc` supports `build` and `check`, builds std/panic_abort for the
native KNC target, disables automatic vectorization by default, and includes
the target math runtime. Explicit supported vectors remain usable. Set
`PHI_AUTOVECTORIZE=1` to enable the experimental supported vectorizer for
workspace crates; standard-library compilation retains the conservative flags.

Rust emits a small host-ELF object for undefined-symbol roots. `knc-link`
validates that it contains metadata only and re-emits its symbol declarations
with the SDK assembler. This is not executable-instruction translation.

## Source and binary compatibility

The target specification selects `cpu=knc`, native K1OM FP/ABI features and
ELF K1OM output. Do not replace its target features with SSE/AVX feature macros.
KNL is a different target and runs ordinary native Linux x86-64 executables.
The application/FP contracts are finite; unsupported inline assembly and Intel
proprietary offload APIs are not supplied by this project.
