# Architecture and numerical contracts

## KNC / K1OM

The patch extends LLVM's X86 backend with KNC instruction selection, encoding,
register/ABI handling, legalization, and target feature checks. It includes
Clang target identification and regression tests in the patched upstream trees.
It supports scalar integer code, the documented native floating-point ABI,
IMCI vector operations, mask/memory operations, conversions and bounded runtime
fallbacks. It does not imply support for every instruction physically present
in every Xeon Phi SKU.

The native scalar FP ABI defines lane zero; upper lanes may contain unrelated
data. Native x87 is used for explicit f80, not as the ordinary FP32/64 ABI.
Runtime math has documented rounding/environment assumptions; preserve the
exact contracts in `runtime/FP-ENVIRONMENT.rst` and `runtime/APPROX.rst`.

## Capability matching

`include/k1om/capabilities.h` is a C11/C++17 catalog and requirement matcher.
`capabilities/k1om.json` is its 1,180-entry historical contract snapshot. Its
proof IDs/hashes identify original development records, which are intentionally
not shipped as private machine logs. Regenerating the header from this snapshot
does not constitute fresh hardware proof.

A match describes operation, shape, layout, alignment, semantics and caller
preconditions. It does not generate arithmetic, touch application buffers,
translate missing instructions, substitute a kernel, or alias SSE/AVX
intrinsics. The application implements and selects its native algorithms.
Requests for absent native byte-dot features fail explicitly. See
`tests/capability-contracts.c` and `tests/capability-kernels.c` for examples.

`docs/capability-coverage.rst` retains the detailed development contract; old
`evidence/...` identifiers there and in runtime documentation are historical
references, not paths required by the public build.

## KNL

KNL uses LLVM's existing x86-64 target with `-march=knl -mtune=knl`. The tested
Xeon Phi 7210 implements AVX2/FMA/F16C and AVX512F/CD/ER/PF, but not
AVX512BW/DQ/VL/VNNI. The broad llama.cpp `GGML_AVX512` switch adds unsupported
features, so it stays off. Supported AVX512F code remains available through
the CPU target flags; integer quantization paths use supported instructions.

The KNL Q4 four-row kernel reuses Q8 activation blocks while retaining the
original AVX2 accumulation order, with ordinary single-row tails. Weight
repacking is a separately selectable upstream layout/kernel path. Neither
changes the KNC ABI or advertises a missing ISA feature.
