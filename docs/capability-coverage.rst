K1OM capability and evidence matrix
===================================

This inventory separates implementation strategy, compiler acceptance and actual
hardware validation. It is bounded by the named type/width matrices. A passing
code-generation probe alone does not establish correctness or speed.

Integer foundations
--------------------

scripts/audit-capabilities.py probes 693 combinations of 8/16/32/64-bit integer
lanes and total vector widths of 128, 256 and 512 bits. It records compiler
acceptance, runtime calls and emitted KNC mnemonics in
evidence/capabilities-codegen.json.

The matrix includes add/subtract/multiply, signed/unsigned division/remainder,
logic, shifts, population/leading/trailing-zero counts, bit reversal, byte swap,
absolute value, signed/unsigned min/max and saturating add/subtract, rotations,
all ten integer predicates as signed/zero-extended masks,
and nine reductions. i8 byte swap is omitted because LLVM does not define that
intrinsic. Division and shifts use defined LLVM inputs; zero bitcounts are
explicitly defined and integer absolute value permits the minimum integer.

Hardware evidence is recorded separately in evidence/hardware-integer-foundations*.json.
The harness tests every generated function using independent integer references,
edge/random values, protected boundaries, byte-unaligned pointers and overlapping
input/output buffers. Inspect the reports for which optimization variants have
actually passed; an absent report means unvalidated.

Implementation strategy
------------------------

* Native full-width i32 arithmetic, logic, shifts and comparisons use IMCI.
* Full-width i64 arithmetic and shifts use sequences of 32-bit IMCI operations.
* Narrow-lane operations, bit manipulation, saturation and reductions use LLVM
  expansion and/or supported scalar instructions where no native selector exists.
* Integer division/remainder use scalar expansion. Rotate operations expand into
  shifts and logic. No accelerated vector divide claim is made.
* Generated vector code may contain native memory moves even when its arithmetic
  is scalar. The presence of a KNC mnemonic does not classify the whole operation
  as native. Instruction strategies above follow the lowering rules and tests.

Quantized structured operations and ABI
---------------------------------------

The Stage 2 matrix adds 129 kernels in tests/knc-quantized-foundations.ll:
60 signed/unsigned widening shapes, 30 truncations, 18 saturating pack shapes
and 21 multiply-add/dot-accumulation shapes. Packing preserves each logical
128-bit lane. Byte pair multiply-add saturates to i16; word pairs and dot
accumulation distinguish modulo-i32 and final signed saturation. Saturating word
dot accumulation uses a wide intermediate so pair overflow cannot lose bits
before adding the accumulator.

Native word memory conversion is selected for full sixteen-lane i16-to-i32
loads and i32-to-i16 stores. Truncation masks to 16 bits before unsigned hardware
down-conversion. Byte-unaligned word accesses use exact-width aligned staging;
other widths use generic expansion. Three direct word paths separately test
cache-line crossings and all 65,536 word inputs. Look for
hardware-quantized-foundations reports for the final compiler's results.

The internal ABI matrix has 54 cases: six lane types, three logical vector widths
and three call patterns. Calls exercise twelve interleaved vector/i64/double
arguments, three-vector/scalar aggregate returns and forty live vectors across
real register and buffer clobbering. LLVM callers and callees are tested together;
external C/C++ aggregate and exception interoperability remains Stage 6.

scripts/verify-foundation-gate.py checks generated kernel inventories, fresh
hardware reports for default/O0/O3, matching LLVM test copies, the final compiler
hash and the release regression summary. It records the bounded gate in
evidence/foundation-gate.json only after all those checks pass.

Floating point and memory
--------------------------

* Native 16-lane FP32 and eight-lane FP64 add/subtract/multiply/FMA:
  tests/knc-gaps.ll and tests/vector-fp.c.
* Comparisons, selection, six min/max variants and bitwise abs/neg:
  tests/knc-fp-compare.ll and tests/fp-compare.c.
* FP32/FP64 format conversions, integer casts and saturation:
  tests/knc-vector-conversions.ll, tests/vector-conversions.c,
  tests/knc-saturating.ll and tests/knc-saturating-f64.ll.
* Default exact vector division/sqrt: scalar runtime fallback, tested by
  tests/vector-div-sqrt.c and rust-vector-math.
* Generic masked gather/scatter, contiguous masked memory and packed
  expand/compress: tests/knc-masked-widths.ll, tests/knc-contiguous.ll and
  tests/knc-packed.ll. Arbitrary scatter retains ordered exact-width fallback;
  native scatter is restricted to disjoint contiguous cases or eligible
  eight/sixteen-lane constant-disjoint i32/FP32 stores (tests/SCATTER.rst).
* FP32 extending masked loads/gathers and FP64 truncating masked stores/scatters:
  tests/knc-masked-fp-conversions.ll and tests/masked-fp-conversions.c.
* Existing FP16 storage/scalar tests: tests/half.c. Additional FP16/FP32/FP64
  compositions: tests/knc-half-compositions.ll and tests/half-compositions.c.
  Inspect hardware-half-compositions reports before treating the new matrix as
  validated. It covers 100 plain/masked contiguous/indexed conversion kernels.

* Ordered and reassociated FP reductions: tests/knc-fp-reductions.ll and
  tests/fp-reductions.c. Exact sequential oracles and bounded finite
  reassociation-error envelopes have different contracts. Numeric min/max
  tests exclude signaling NaNs; propagating reductions include NaN inputs.
* Native min/max runtime: runtime/minmax.c, tests/minmax-runtime.c and
  evidence/hardware-minmax-runtime.json. Twelve functions are tested with
  144,000 exact/classified results. Floating exception flags are outside scope.

Existing evidence is bounded: default nearest-even arithmetic is not full strict
FP or alternate-environment emulation, and passing tested FMA inputs is not
exhaustive coverage of every IEEE corner case.

Scalar FP lowering
------------------

Default KNC FP32/FP64 scalar add, subtract, multiply and fused FMA now use legal
512-bit DAG operations. Integer bit transport preserves native scalar ABI
arguments/results; explicit broadcasts avoid uninitialized upper-lane
arithmetic and expensive vector zero-fill initialization. Ordinary C O0/O2 and
the Rust C-ABI client have independent IEEE value-oracle checks. The scalar
software baseline remains selectable with ``-knc-scalar-fp`` as a disabled
target feature; no calling convention changes. Strict/constrained operations,
noimplicitfloat functions, division and sqrt retain their existing paths.

evidence/scalar-fp-evaluation.json separates correctness, emitted-instruction
audits and the bounded dependent-add timing comparison. It does not promise
exception-state effects, alternate rounding modes, NaN payload identity or
application speedups. ABI stack traffic remains an optimization target.

Native conversion and register reduction lowering
-------------------------------------------------

Signed/unsigned i32 vectors now convert directly to FP64 with VCVTDQ2PD and
VCVTUDQ2PD. Defined FP64-to-i32/uint32 casts use VCVTFXPNTPD2DQ/UDQ with explicit
toward-zero rounding and no fixed-point scaling. Eight-lane chunks are split or
padded for the validated 2/4/8/16/32-lane shapes. Integer-to-double values are
exact; float-to-integer callers must establish LLVM's defined input domain.
This is not a promise of another ISA's invalid-conversion or saturation rules.

FP sum/product reductions remain intact through the IR expansion pass so KNC's
DAG lowering can preserve a vector accumulator. Ordered reductions broadcast
each source lane and apply operations in original sequence. Relaxed reductions
use a permutation tree only when reassociation is permitted. Initial scalar
accumulators and sequential RNE semantics are preserved. Other reduction kinds
and strict/noimplicitfloat functions retain their previous lowering.

evidence/fp-vector-gate.json verifies all 4,096 new conversion register encodings
against SDK binutils, 90 conversion functions and 80 reduction kernels at
default/O0/O3, Rust SIMD casts, and 20 timing pairs in three modes. Numerical
tests include cancellation, sequential overflow avoidance, signed zero and
repeated half-ULP additions that distinguish ordered evaluation from a tree.
The same-compiler baseline disables these transformations with the diagnostic
option ``-knc-optimize-fp-vectors=false``. All 60 measured comparisons improved;
the bounded default-mode gains were 8.6-65x for casts, 2.4-3.3x for ordered
reductions and 9-12% for relaxed reductions. These hot-data measurements do not
predict application throughput.

Compatibility and runtime
--------------------------

C/C++ and Rust use the native KNC scalar FP ABI, with pointer wrappers across
SDK/compiler vector boundaries. C/C++ variadics, bounded C++ exceptions and
Rust std clients have hardware reports. Rust panic still aborts. Long-double,
exhaustive aggregate ABI and general unwinding are not established by those tests.

The metadata-only K1OM capability matcher is verified in
evidence/capability-gate.json. Its 1,180 bounded contracts distinguish 44 native,
1,043 composed and 93 runtime paths, with explicit shapes, layouts, alignment,
semantics and domain preconditions. It never translates missing instructions
or defines SSE/AVX feature macros. C11/C++17 host/card contract tests and three
separate native application kernels at O0/O3 pass. See capabilities/README.rst.

Guarded FP32/FP64 division/sqrt acceleration is verified in
evidence/approx-gate.json. Division requires LLVM arcp+afn, sqrt afn; default exact
operations keep their previous paths. The runtime refines native reciprocal and
rsqrt seeds for guarded normal lanes and uses scalar fallback elsewhere. The
four-ULP value contract and unpromised FP exception state are explicit in
runtime/APPROX.rst. The matcher never turns these metadata permissions into flags
or performs the kernel's computations.

Broad C++ runtime readiness, runtime activation math validation, remaining FP
environment documentation and broader scheduling calibration remain handoff requirements.
No end-to-end llama.cpp run has been established. See HANDOFF.rst for the complete
scope and gates, and evidence/readiness.json for requirement status.
