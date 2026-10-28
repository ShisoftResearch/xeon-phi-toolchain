# Xeon Phi toolchain

An experimental LLVM/Clang toolchain for **Knights Corner (KNC / K1OM)**, with
native C, C++, and Rust support, runtime math helpers, regression tests, and
llama.cpp kernels for KNC and Knights Landing (KNL).

The LLVM patch adds KNC support to LLVM's X86 backend. Rust uses a pinned,
unmodified compiler built against that LLVM. KNL uses LLVM's existing native
x86-64 backend with KNL-specific build and runtime settings.

This project does **not** emulate SSE/AVX instructions or expose them as KNC
features. Its capability matcher describes native K1OM operations and their
requirements; applications supply their own kernels.

## Quick start

Use an x86-64 Linux build host with Python **3.12+**, Git, CMake, Ninja, Clang,
Make, and an independently installed **MPSS SDK** for Linux/KNC applications.
LLVM-only code generation and host contract tests do not require the SDK.
Allow substantial disk space and RAM for LLVM/Rust builds; `PHI_JOBS` controls
parallelism and defaults to at most eight jobs.

```sh
cd xeon-phi-toolchain
python3 scripts/phi.py doctor
python3 scripts/phi.py test-host
python3 scripts/phi.py fetch llvm
python3 scripts/phi.py build-llvm
python3 scripts/phi.py test-codegen

export PHI_SDK_ROOT=/path/to/your/mpss-sdk
python3 scripts/phi.py build-runtime
bin/clang-knc -O2 examples/hello.c -o build/hello-knc
```

The SDK root must contain `sysroots/k1om-mpss-linux` and
`sysroots/x86_64-mpsssdk-linux`. No SDK binaries, headers, firmware, device
drivers, model files, credentials, or private connection settings are included.
The C compiler produces K1OM executables to run on a KNC card, not the build host.

For modern C++:

```sh
python3 scripts/phi.py build-cxx
bin/clang++-knc-modern -std=c++17 -O2 examples/hello.cpp -o build/hello-cxx
```

For native Rust:

```sh
rustup toolchain install nightly-2026-09-01 --profile minimal --component rust-src
python3 scripts/phi.py fetch rust
python3 scripts/phi.py build-rust
bin/cargo-knc build --manifest-path examples/rust-std-demo/Cargo.toml --release
```

Standard Rust portable SIMD is supported through `core::simd` / `std::simd`
on the pinned nightly, without custom vector wrappers. The tested matrix spans
13 numeric element types and ten lane counts, including odd-sized vectors.
See [portable SIMD](docs/rust-portable-simd.md) for the example and reproducible
local/card validation commands.

See [building](docs/building.md) for prerequisites, SDK relocation, CMake,
external build paths, Rust's experimental vectorizer, and troubleshooting.

## llama.cpp

```sh
python3 scripts/phi.py fetch llama
# KNC: requires the SDK and the target C++ library built above.
python3 scripts/phi.py build-llama --arch knc --profile default
# KNL: native Linux x86-64; does not require the MPSS SDK.
python3 scripts/phi.py build-llama --arch knl --profile repack
```

The executables land in `build/llama/<architecture>/<profile>/bin/`.
Supply your own GGUF model. See [llama.cpp usage](docs/llama.md) and
[measured performance](docs/benchmarks.md).

## Repository layout

| Path | Contents |
|---|---|
| `patches/` | Complete patches against pinned LLVM and llama.cpp commits |
| `sources.lock.json` | Upstream revisions, patch checksums, GCC source checksum |
| `bin/`, `scripts/`, `cmake/`, `targets/` | Portable compiler wrappers and build tools |
| `runtime/` | Native math/ABI helpers and attributed musl-derived sources |
| `include/k1om/`, `capabilities/` | Metadata-only capability matcher and snapshot |
| `tests/` | Compiler, ABI, numerical, operator, and release-tool regressions |
| `examples/` | C/C++ examples and Rust crates |
| `docs/`, `benchmarks/` | Contracts, release guidance, and historical measurements |

Downloaded sources, generated records, builds, and local SDK copies are ignored
under `sources/` and `build/`. Build scripts do not read private lab evidence.

## Status and release scope

This is a **source release**, with bounded hardware validation, not an Intel
product or a drop-in replacement for Intel's complete compiler/offload stack.
Unsupported instructions remain unsupported. Floating-point contracts and
known limits are described in [architecture](docs/architecture.md),
[validation](docs/validation.md), and the runtime documentation.

The historical KNC 0.8B/4B output divergence from a host reference has not been
established as a general model-quality equivalence result. Short inference
benchmarks do not establish long-context behavior or a hardware speed ceiling.

Release steps are in [docs/releasing.md](docs/releasing.md). The source archive
excludes Git history and all private SDK/build artifacts. No release is uploaded
by the build or packaging commands.

## License

Toolchain work uses **Apache-2.0 WITH LLVM-exception**, as in [LICENSE](LICENSE).
Other upstream licenses and notices remain applicable to their components;
see [NOTICE](NOTICE) and [THIRD_PARTY.md](THIRD_PARTY.md).
