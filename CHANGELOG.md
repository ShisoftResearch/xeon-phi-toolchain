# Changelog

## 0.2.0 — 2026-10-28

- Standard Rust portable-SIMD example and local/card regression workflow:
  9,380 API cases, masked guard-page checks, FP edges and Rust vector-value ABI.
- Suppress SDK-incompatible `-no-pie` and metadata-link chatter in the native
  Rust linker wrapper.

## 0.1.0

Initial public source organization of the experimental KNC/K1OM LLVM toolchain.
Includes pinned LLVM/Clang and llama.cpp patches, native runtime math, Rust
integration, optional C++17 library build, capability matching, KNC/KNL application
profiles, tests, portable build/release tools, and bounded historical benchmarks.
Private development history, SDK bundles, model weights and machine logs are
excluded. This is an experimental source release.
