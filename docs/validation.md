# Validation

## Checks available without hardware

```sh
python3 scripts/phi.py test-host
python3 scripts/phi.py fetch llvm
python3 scripts/phi.py fetch llama
python3 scripts/phi.py test-patches
python3 scripts/phi.py build-llvm
python3 scripts/phi.py test-codegen
python3 scripts/phi.py check-release
```

`test-host` tests source preparation/idempotence, refusal of modified inputs,
publication exclusions, architecture flags, deterministic matcher generation,
and C11/C++17 capability contracts. The matcher tests cover 59 explicit cases
plus the 1,180-entry inventory in each language. They do not execute KNC math.

`test-patches` replays both complete patches against pristine file contents
read from the exact locked Git commits. It writes hashes to local build records.
`test-codegen` runs the patched LLVM/Clang KNC tests with the built tools.
The retained standalone IR/MIR, C/C++, ABI and mathematical corpus sources in
`tests/` support further targeted testing; numerical generators live in `scripts/`.
MPFR-based generators require a host MPFR 4 LP64 library.

GitHub Actions runs host checks, source release checks and pristine patch replay.
A manually requested workflow can also build LLVM and run codegen tests. It has
no card access or SDK credentials. CI configuration is provided; a hosted CI
run is not claimed before this repository is published.

## Rust portable SIMD

See `rust-portable-simd.md` and `validation/portable-simd.json` for the standard
Rust API extension, local compile/instruction matrix, differential fixtures and
actual KNC runs. `python3 scripts/phi.py test-portable-simd` builds the host and
card artifacts; only the host artifacts execute locally.

## Hardware checks

Run cross-compiled examples on a card using your own connection settings.
`tests/modern-cpp.cpp`, `examples/rust-std-demo`, and the CMake application exercise
C++ library and Rust std behavior. llama.cpp's `test-backend-ops` and
`test-quantize-fns` are built with each application profile. For example, on the
target containing the test binary:

```sh
./test-backend-ops test -b CPU -o MUL_MAT \
  -p 'type_a=(q4_0|q4_1|q5_K|q6_K),type_b=f32,m=16,n=(1|2|3|4|8|16),k=256,' -j 1
./test-quantize-fns -v
```

Do not run a KNC binary on a KNL host or vice versa. Instruction availability
and target numerical contracts must be validated independently of successful
assembly/linking. The KNL four-row unit sources include protected-page,
misalignment, byte-extreme, row-tail and GGML-dispatch tests.

## Release reorganization checkpoint

The public repository preserves the exact accepted LLVM and application
patches while replacing machine-specific build orchestration. The compiler
itself is unchanged. Local release integration uses that existing patched
compiler to rebuild the runtime, target C++17 library, Rust std application,
and KNC/KNL llama.cpp applications through the new commands.

`validation/reorganization.json` records the bounded checks completed during
this reorganization. This is not a claim that LLVM and rustc were both rebuilt
from scratch during the reorganization, or that hosted CI has already run.
Historical application measurements are separate in `benchmarks/qwen35.json`.
Private hardware logs and original proof archives are not part of this release.
