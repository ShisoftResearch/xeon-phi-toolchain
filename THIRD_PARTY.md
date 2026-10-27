# Third-party provenance

| Component | Source included here | Upstream terms / notices |
|---|---|---|
| LLVM/Clang | Complete local patch; upstream fetched at pinned commit | Apache-2.0 WITH LLVM-exception; `LICENSE`, `licenses/llvm.txt` |
| compiler-rt | Fetched with LLVM; built without source changes | LLVM license and notices |
| llama.cpp/ggml | Complete local patch; upstream fetched separately | MIT; `licenses/llama.txt` and upstream source notices |
| musl 1.2.5 math | Selected sources plus local adaptation header | Individual file notices and `runtime/musl-math/COPYRIGHT`; exact provenance in `runtime/musl-math/provenance.json` |
| Rust compiler/std | Not vendored; fetched without source patches | MIT/Apache-2.0; `licenses/rust.txt`, `licenses/rust-apache.txt`, upstream per-component notices |
| GCC 13.4.0 libstdc++ | Not vendored; source archive verified before local build | GNU GPL and applicable runtime exceptions in the fetched GCC tree |
| MPSS SDK 3.8.6 | Not included | User supplies an independently obtained installation under its existing terms |
| GGUF models | Not included | User obtains models and observes each model's terms |

`sources.lock.json` pins compiler/application revisions, patch SHA256 values and
the GCC source archive SHA512. The musl provenance file records its archive and
source checksums. `docs/source-map.json` records the original component paths
and hashes for retained development sources; adapted scripts have new public
interfaces and may differ from those originals.

The root license follows the pre-existing LLVM-based project license. It does
not replace more specific notices on upstream-derived files or imply ownership
of upstream code. Preserve those notices when redistributing modified sources.
The public source packager deliberately excludes downloaded dependencies and
locally built libraries; this release does not repackage the private SDK bundle.
