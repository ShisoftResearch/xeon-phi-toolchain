; Pinned Rust nightly-2026-09-01 allocator marker, reproduced as LLVM IR.
; The compiler emits this in an extra native object without --emit=llvm-bc.
; Its implementation is an empty void() wrapper when to_name=None:
; https://github.com/rust-lang/rust/blob/0dfb098f3aeecbe38c2566ca090193280e7349e7/compiler/rustc_codegen_llvm/src/allocator.rs#L89
; This is NOT a replacement allocator. The #[global_allocator] remains required.
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"
define void @_RNvCsfQndA1Szgsd_7___rustc35___rust_no_alloc_shim_is_unstable_v2() nounwind {
entry:
  ret void
}
