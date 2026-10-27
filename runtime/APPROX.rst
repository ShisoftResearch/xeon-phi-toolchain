Guarded approximate KNC vector math
==================================

Ordinary LLVM division and square root retain the existing scalar-runtime paths.
Approximate division requires both ``arcp`` and ``afn``. Approximate sqrt requires
``afn``. Strict/constrained operations and noimplicitfloat functions retain their
previous lowering. Clang clients can request the two permissions with
``-freciprocal-math -fapprox-func``; no SSE/AVX feature flags are involved.

The accelerated path has a value-error contract of at most four ULP relative to
the exact nearest-even result in the tested default FP environment. It does not
promise correctly rounded results, NaN payload identity or FP exception-state
effects. Alternate FP environments are not validated. The default exact path
does not acquire this approximation contract implicitly.

Native primitives and domain guards
-----------------------------------

LLVM exposes actual KNC VRCP23PS and VRSQRT23PS seed instructions. Their machine
bytes are checked independently against the MPSS assembler, including high vector
registers. These seeds treat denormal inputs as signed zero; VRCP23PS flushes tiny
results. They are not aliases for exact LLVM reciprocal or square root. Hardware
tests explicitly cover signed zero, denormals, infinities, NaNs and exact powers.

The refined kernels accept all input encodings. Internally, a lane enters the
fast path only when every needed input is normal with unbiased exponent in
[-60,60], and sqrt's input is positive. Other lanes are replaced with one before
seed/refinement evaluation, then computed with the established scalar division
runtime or integer sqrt shim. This guards the seeds' DAZ/FTZ behavior and keeps
division results away from overflow and underflow. These are internal guards,
not extra preconditions on application inputs.

FP32 reciprocal refinement uses one fused Newton correction. FP64 obtains an
FP32 seed and applies two corrections against the original FP64 operand.
Division then corrects its quotient with a fused residual. Sqrt similarly refines
reciprocal sqrt and corrects the result with a fused square residual. Guarded
input ranges prevent catastrophic overflow in these steps. Squared seed error,
fused residuals and conservative rounding allowance motivate the four-ULP
contract; the test corpus is bounded validation, not exhaustive IEEE enumeration.

The backend passes private 64-byte-aligned buffers across the runtime boundary.
This pointer ABI avoids Clang's current frontend byval classification of wide
vectors and matches the existing SDK interoperability strategy. External C/C++
vector ABI work remains in Stage 6.

Evidence and matching
---------------------

``scripts/test-approx-hardware.sh`` tests 20 LLVM operation/type/width cases and
four ordinary C++ vector expressions. All default/O0/O3 cases use independent
exact-rational division and integer-root sqrt oracles, mixed fast/fallback lanes,
guard boundaries and page-end buffers. Fallback lanes require exact value bits
except unspecified NaN payloads; fast lanes allow four ULP. Timings compare
in-domain full-width calls with the existing exact scalar-runtime implementation.
They do not predict llama.cpp performance or gains for out-of-domain inputs.

``evidence/approx-gate.json`` records the compiler and source fingerprints, native
encoding check, permission exclusions, observed error and measured timing.
The capability catalog keeps FP_RNE_VALUE separate from FP_APPROX_4ULP and
requires explicit ALLOW_APPROXIMATE_MATH / ALLOW_RECIPROCAL assumptions. These
metadata permissions do not set compiler flags, execute kernels or translate
instructions; the application author must select and compile the intended path.
