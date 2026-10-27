# llama.cpp on Xeon Phi

Fetch the pinned source and apply the complete patch:

```sh
python3 scripts/phi.py fetch llama
python3 scripts/phi.py build-llama --arch knc --profile default
```

KNC `default` enables native quantized blocks, parallel activation/gather work,
vector Q4/Q6 partial sums, matrix tiles and native prefetch distance eight.
`scalar` disables those optional K1OM quantized optimizations. Both are CPU-only
builds with SSE/AVX switches disabled. A user-installed SDK and a target C++17
library are required. Copy executables and a separately obtained model to a
card using your own SSH configuration, then run them there.

For KNL:

```sh
python3 scripts/phi.py build-llama --arch knl --profile repack
build/llama/knl/repack/bin/llama-completion \
  -m /path/to/model.gguf -ngl 0 -t 64 -tb 128 -c 256 -n 32 \
  --no-conversation --temp 0 -p 'Explain why the sky is blue.'
```

Run this executable on a KNL machine. Profiles are `default` (native KNL),
`avx2` (no AVX512F), `repack`, and `rows4` (the opt-in four-row Q4 kernel).
A KNL SDK is not needed. Use `--print-options` to inspect the exact CMake
configuration before building.

The saved short Qwen3.5 measurements favor repack/64 decode workers for 0.8B
and rows4/128 workers for 4B/9B, with 128 prompt workers. These are candidates
for that specific Xeon Phi 7210 and workload, not universal defaults. Pin
threads according to the machine's actual core/SMT topology. All 256 hardware
threads were slower for decode in the tested baseline. Mmap avoids extra
copy/loading cost without a material measured decode penalty. Batch 128 helps
larger prompt processing; generation speed is a different metric.

For a local fixed-work benchmark:

```sh
build/llama/knl/repack/bin/llama-bench -m /path/to/model.gguf \
  -ngl 0 -p 32 -n 32 -b 32 -ub 32 -t 64 -r 3 -fa off -o json
```

Models, model licenses, chat templates and downloads are the user's
responsibility. The repository does not redistribute weights. The historical
measurements used the same pinned Q4_0 files; hashes and limits are in
`benchmarks/qwen35.json`. Vision and long-context performance were not validated.

The patch retains bounded KNC RPC work from development, but public builds
leave RPC disabled. Two independent card processes can serve separate requests;
that increases aggregate throughput, not a single stream's generation rate.
