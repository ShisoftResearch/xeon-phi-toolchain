K1OM floating-point value and environment contracts
===================================================

Default value model
-------------------

The native KNC compiler uses source-width binary32/binary64 scalar operations
through IMCI registers, or source-width software helpers. It does not evaluate
ordinary float/double arithmetic in x87 extended precision. Clang therefore
reports ``__FLT_EVAL_METHOD__ == 0``, including when native scalar arithmetic is
disabled. The old NoSSE-derived value 2 selected an incorrect range-reduction
constant in portable math code. The preprocessor regression test covers both
profiles and explicit ``-ffp-eval-method=source``.

The ordinary arithmetic, conversion, reduction and elementary-function value
contracts are verified under the card process's default environment with
``FE_TONEAREST`` selected. They are not a promise that all operations respond
identically to every floating-point control-register setting. NaNs are usually
classified by encoding; payload/sign preservation and signaling behavior are
promised only where an individual test explicitly checks them.

Scalar ABI values occupy lane zero of their ZMM register. Optimized argument,
result and expression transport can reuse an existing register directly;
other lanes remain unspecified, including when they contain unrelated NaNs.
Unconstrained packed arithmetic can evaluate those lanes as well. Consequently
the numerical low-lane contract does not imply identical exception flags to an
implementation that broadcasts the scalar into every lane. Strict/constrained
arithmetic retains its previous lowering. The transport opt-out is
``-knc-scalar-register-reuse=false``; it is a debugging/comparison option, not a
promise of complete strict-FP environment emulation.

``evidence/scalar-fp-evaluation.json`` and ``evidence/foundation-gate.json``
cover normal/subnormal inputs, signed zeros, infinities, NaNs and rounding
boundaries for their bounded matrices. Gradual-underflow values are checked in
those matrices. Do not infer support for arbitrary user-enabled flush-to-zero
or denormals-are-zero settings from these results. Half precision is a storage
and conversion format; arithmetic is promoted/composed as documented in the
capability catalog.

Exact operations and reductions
-------------------------------

Default division uses the source-width software runtime. The own integer
restoring square-root shim avoids the SDK's observed double-rounding bug.
``tests/compiler-rt.c`` checks sqrt(2) under nearest/down/up/toward-zero rounding
for both widths, exact sqrt(4) without exceptions, negative sqrt with EDOM and
FE_INVALID, and a signaling NaN quieted with FE_INVALID. These checks do not
extend a directed-rounding guarantee to every other arithmetic operation.

FP64-to-FP32 conversion uses explicit nearest rounding; FP-to-integer conversion
uses truncation toward zero over LLVM's defined input domain. Out-of-range
integer conversion is not silently assigned a saturating contract. Separate
saturating operations have their own range tests.

Sequential reductions apply each operation in lane order, starting from the
provided scalar accumulator, with per-step source-width rounding. They are not
one exact accumulation followed by one rounding. Reassociated reductions
require explicit permission and may differ because of cancellation, overflow
and signed zeros. No universal ULP bound is assigned to reassociated sums.
The reduction fixtures distinguish these cases rather than only testing inputs
for which every ordering agrees.

Approximate division and square root
------------------------------------

``runtime/APPROX.rst`` defines the guarded default-RNE <=4-ULP contract and
permissions. The native reciprocal/reciprocal-square-root seeds treat denormal
inputs as zero; reciprocal seeds also flush tiny results. Guards sanitize lanes
before seed execution, refine within a bounded normal domain, and route other
inputs through exact scalar helpers. Observed seed behavior is not the contract
of the guarded whole operation. Approximate division requires both arcp and
afn; approximate sqrt requires afn. Strict/constrained/noimplicitfloat paths
do not silently select these helpers. FP exception-state equivalence is not
promised for the approximation path.

Elementary functions and application compositions
--------------------------------------------------

``scripts/test-runtime-math-hardware.sh`` uses a host MPFR 4 library (LP64 ABI,
libmpfr.so.6; verified with 4.2.2). The generator independently evaluates at
192 and 320 bits and requires agreement after export to the target format.
MPFR is never linked into card executables. This is an external host
prerequisite, in addition to the preserved compiler SDK prerequisites.

Each O0/O3 C++17 client checks 42,600 results: exp, log, tanh, erf, erfc,
sin, cos, sqrt and both outputs of sincos, in binary32 and binary64. Inputs
include normal/subnormal values, signed zeros, maximum finite magnitudes,
infinities, NaNs, range-boundary neighbors, dense finite ranges and random
encodings. Ordinary elementary values allow at most four ULP; sqrt and selected
zero/infinity/tiny-input cases require exact encodings. This bounded corpus is
not an exhaustive correctness proof for libm. The maximum observed error is
recorded per function and width in ``evidence/runtime-math-gate.json``.

The legacy SDK sine/cosine path failed 793 of the original 34,080 primitive
checks, chiefly at large arguments. Portable musl 1.2.5 trigonometric sources
now supply sin/cos/sinf/cosf, including full large-argument reduction. Combined
sincos/sincosf entry points also use this implementation, so compiler combination
cannot select the legacy path. Vendored files remain byte-identical to the
official release; provenance, hashes and licenses are in runtime/musl-math.
Only the local integration header namespaces internal functions. Compilation
disables FP contraction and builtin substitution to preserve the algorithms.
This is ordinary scalar runtime support, separate from the capability matcher.

There are also 1,200 composed-kernel cases and 14,880 output lanes per mode:
stable SiLU, erfc-based GELU, maximum-subtracted softmax, RMSNorm with positive
target-rounded epsilon 1e-5, and pairwise RoPE rotations. Widths are 2/4/8/16/32;
finite inputs include zeros, tiny magnitudes and +/-1000; rotation angles reach
1e35 for float and 1e100 for double. Independent MPFR compositions supply
outward-rounded integer comparison intervals. Bounds are absolute 1e-7 plus
relative 3e-6 for float, absolute 1e-15 plus relative 2e-14 for double. Rotations
add 16*u*(|a|+|b|), with u=2^-24/2^-53, to account for cancellation of two
products. An output-relative bound alone is unsuitable near cancellation.
These are correctness fixtures, not final llama.cpp kernels or benchmarks.

Exception and errno observations
--------------------------------

The runtime-math reports record six default-environment probes at both compiler
optimization levels. Observed exp(+1000) returns +infinity with ERANGE,
FE_OVERFLOW/FE_INEXACT; exp(-1000) returns zero with ERANGE,
FE_UNDERFLOW/FE_INEXACT. log(-1) returns NaN with EDOM/FE_INVALID; log(0) returns
-infinity with ERANGE/FE_DIVBYZERO. The sqrt shim returns NaN with
EDOM/FE_INVALID for -1. Portable sin(infinity) returns NaN with FE_INVALID and
leaves errno zero in this probe. These are observations of this runtime, not
a complete exception/errno contract; in particular, do not assume all domain
errors set errno or that native and software operations expose identical flags.

Full strict-FP environment emulation, general alternate-rounding elementary
functions, trap handling and exhaustive NaN payload propagation remain outside
the initial application-readiness gate. Callers needing them must request a
separately verified contract. The matcher does not advertise exception-state
equivalence and does not execute numerical work.
