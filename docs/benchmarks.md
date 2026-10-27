# Historical Qwen3.5 performance

These are saved measurements from 2026-10-27, not a benchmark rerun performed by
installing this repository. Same Q4_0 model files, 23-token nonthinking prompt,
context 256, batch/microbatch 32, up to 32 generated tokens, three runs. Each
architecture uses its measured configuration. Values are medians in tokens/s.

| Model | One KNC: generation | KNL 7210: generation | KNL / KNC |
|---|---:|---:|---:|
| Qwen3.5-0.8B | 9.87 | 32.47 | 3.29x |
| Qwen3.5-4B* | 3.08 | 9.84 | 3.19x |
| Qwen3.5-9B | 2.66 | 6.86 | 2.58x |

| Model | One KNC: prompt processing | KNL 7210: prompt processing |
|---|---:|---:|
| 0.8B | 24.50 | 90.03 |
| 4B* | 6.97 | 21.10 |
| 9B | 5.08 | 12.12 |

*The 4B KNC run predates later KNC kernel improvements. It is not a fresh
comparison against the final KNC application snapshot. Generated text/counts
can differ between architectures; this does not establish numerical equality
or general quality equivalence. These are single-stream rates on one card,
not a two-card throughput claim.

KNL used repack/64 decode workers for 0.8B and rows4/128 workers for 4B/9B,
with 128 prompt workers and mmap. All 256 hardware threads were slower for
decode in the tested plain KNL profile. The 9B rows4 gain over plain KNL was
negligible; the table does not establish a meaningful 9B kernel speedup.

A separate KNL 128-token prompt test, batch/microbatch 128, reached 164.00,
25.50 and 13.78 prompt tokens/s for 0.8B, 4B and 9B. Those values must not be
mixed with the short-prompt comparison above or presented as generation rates.

The OS exposed one NUMA node on KNL; its MCDRAM firmware mode was not confirmed.
Long contexts, vision, other quantization formats and a hardware performance
ceiling are outside these measurements. Machine connection details and raw
private lab logs are deliberately excluded. `benchmarks/qwen35.json` records
model/compiler/source hashes, workload settings and the relevant limitations.
