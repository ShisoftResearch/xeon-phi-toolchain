# Preparing a source release

The repository is a public source release. The old development history and
private binary bundles are deliberately excluded. The package contains pinned
patches and portable build/test commands, not an MPSS SDK or model weights.

1. Update `VERSION`, relevant documentation and `CHANGELOG.md`.
2. Review `sources.lock.json`; changing a patch requires updating its checksum
   and rerunning pristine patch replay and affected compiler/hardware tests.
3. Run host, patch, codegen and relevant target checks from `validation.md`.
4. Stage and inspect only intended source files, then run:

   ```sh
   python3 scripts/phi.py check-release
   git diff --cached --check
   ```

5. Commit the reviewed source tree, then package:

   ```sh
   python3 scripts/phi.py package \
     --output dist/xeon-phi-toolchain-0.1.0-source.tar.gz
   ```

The packager requires a clean Git worktree, audits every tracked file, rejects
local/build/SDK/model files and common credential patterns, writes an embedded
`SOURCE-MANIFEST.json`, and verifies every archived file by SHA256 readback.
It emits a separate archive checksum. Archive timestamps come from the commit,
so packaging the same clean commit again is deterministic. Existing output files
are not overwritten. The source archive does not include Git history.

Pattern scanning is a guard, not a substitute for reviewing the staged source.
Keep `build/records`, SSH settings, keys, passwords, private host inventories,
SDK copies and downloaded models outside the tracked source tree.

Publishing a repository, creating a remote, pushing commits, signing/tagging a
release, and uploading artifacts are separate maintainer actions. None of the
commands here publishes automatically. Choose the hosting namespace and
release policy before taking those actions.

Binary releases need their own dependency/relocation and license review. Do
not publish the historical private bundle: it contains externally licensed SDK
material. This source release includes only the licenses and upstream-derived
source portions described in `THIRD_PARTY.md`.
