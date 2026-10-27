# Contributing

Keep compiler, runtime, capability metadata and application changes scoped and
reviewable. Explain the unsupported case or concrete behavior being changed.
Use the pinned upstream revisions, preserve upstream notices, and include
appropriate regression tests. Do not emulate missing SSE/AVX instructions in
the capability matcher or advertise unsupported feature macros.

Run `python3 scripts/phi.py test-host` and `check-release`. For backend changes,
also replay the patches, run codegen tests and validate relevant numerical/ABI
behavior on a KNC card. Changes to approximate math must state their domain,
rounding, error and exceptional-input contracts. Benchmarks must identify the
model/hash, quantization, prompt/decode lengths, batch, workers, compiler/source
revision, repetitions and limits. Distinguish generation from prompt throughput.

Do not commit dependencies, binaries, model weights, private hardware evidence,
connection settings or credentials. Do not submit code you cannot explain or
maintain. Upstream contributions must follow each upstream project's own rules.
