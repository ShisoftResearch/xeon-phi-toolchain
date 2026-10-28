# Rust portable SIMD on K1OM

Use the nightly standard API directly:

```rust
#![feature(portable_simd)]
use core::simd::{Simd, prelude::*};

fn affine(a: &[u32], b: &[u32], out: &mut [u32]) {
    let x = Simd::<u32, 16>::from_slice(a);
    let y = Simd::<u32, 16>::from_slice(b);
    (x * Simd::splat(13) + y).copy_to_slice(out);
}
```

Build with this project's `bin/cargo-knc` and pinned Rust compiler. No custom
`knc-runtime` vector type, internal `repr(simd)` declaration, SSE/AVX feature
macro, or instruction-translation layer is required for these APIs. The
existing KNC LLVM backend lowers supported generic vector IR to K1OM operations,
composed word operations or scalar/runtime paths. This extension adds a usable
standard-API example and regression/validation integration; it does not pretend
to add a second backend or patch Rust sources that already work with ours.

`portable_simd` remains a nightly Rust feature. `f16` cases additionally require
`#![feature(f16)]`. This validation uses the revisions in `sources.lock.json`,
not an assertion about arbitrary future nightlies. The conservative automatic
vectorizer setting in `cargo-knc` does not disable explicit `Simd` operations.

## Example and local checks

After building the compiler, Rust and target runtime as in `building.md`:

```sh
bin/cargo-knc build --manifest-path examples/rust-portable-simd/Cargo.toml \
  --bin knc-portable-simd --release
python3 scripts/phi.py test-portable-simd
```

Use `test-portable-simd --offline` after populating the Cargo registry cache.
The test command builds both host and KNC versions, runs the host checks,
generates a reference fixture, compiles 130 K1OM probe groups, and checks their
ELF type and SDK disassembly. It does **not** execute KNC code on the host or
connect to a card. It leaves these artifacts under the selected build root:

* `cargo/knc-native/release/knc-portable-simd`: scalar/bit/offset and guard-page tests.
* `cargo/knc-native/release/portable-simd-corpus`: standard-API differential test.
* `portable-simd/expected.bin`: host reference fixture, with a schema signature.
* `records/portable-simd-local.json`: local result and artifact hashes.

Copy the two target executables and fixture to a KNC card using your own
connection settings, then run there:

```sh
./knc-portable-simd
./portable-simd-corpus --check expected.bin
```

The regular example checks integer arithmetic and swizzles at multiple element
offsets, float-to-integer casts including NaN/infinities, signaling-NaN min/max,
signed zero and float bit representations. Its protected-page tests exercise
masked pointer loads, stores, gathers and scatters with **all** active-lane
counts, including zero. Disabled addresses point into a page with no access;
incorrect accesses fault instead of silently reading spare allocation space.

## Validated matrix

The finite matrix contains **9,380 API cases**, eight input/mask/index trials
each: **75,040 differential trials** on one healthy KNC card.

* Elements: `i8/u8`, `i16/u16`, `i32/u32`, `i64/u64`, `isize/usize`, `f16/f32/f64`.
* Lane counts: 1, 2, 3, 4, 7, 8, 16, 17, 32 and 64.
* Arithmetic, shifts, bit operations/counts, saturation, comparisons, masks,
  selection, all pairwise numeric casts, reductions, static/dynamic swizzles,
  rotations, interleave/deinterleave, selected memory operations, gathers/scatters,
  and the tested `StdFloat` methods.

The independent regular test adds **1,616 scalar/bit/offset checks** and
**232,518 protected-page lane checks**, plus **4,004 vector-value/callback ABI
lane checks**, passing on KNC. The ABI cases force non-inlined vector arguments
and tuple returns through function pointers, across the same types and widths.
These are Rust-to-Rust calls on the pinned compiler; a cross-language vector ABI
is not promised. The differential probes use explicit pointer arguments. The compile matrix uses
LLVM's machine verifier; SDK disassembly checks native ELF K1OM output. Binutils
uses YMM spelling for low-half operands of three native IMCI widening conversions;
those specific conversion aliases are allowed, not arbitrary AVX instructions.

## Numerical and performance limits

The differential fixture is produced by ordinary host Rust portable SIMD, not
by an independent mathematical proof engine. Integer/bit/memory results and
ordinary float results are compared exactly. Floating NaNs are compared by
classification, not payload. The min/max operations permit either signed zero
where the API/IR leaves that choice open. The tested transcendental/reciprocal
paths allow up to four ULP; inputs are bounded finite values. The separate bit
checks cover selected NaNs, infinities and zeros. This does not prove every
IEEE input, FP exception flag, nondefault rounding mode or scatter permutation.

The masked memory checks cover raw-pointer operations and disabled guard-page
addresses. The differential cases also include bounds filtering, duplicate
scatter indices and last-enabled-lane behavior for their specific inputs.

Portable SIMD is a semantic API, not a promise of native packed hardware for
every element type. KNC has useful 32-bit integer and FP32/FP64 vector primitives;
byte/halfword, 64-bit integer, half-precision arithmetic and other unsupported
operations may widen, split, scalarize or use native-ABI runtime helpers.
No performance benchmark or compiler speedup is claimed by these correctness
checks. Consult `runtime/FP-ENVIRONMENT.rst` for the remaining FP contracts.
