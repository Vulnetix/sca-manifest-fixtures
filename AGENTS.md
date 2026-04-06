# AGENTS.md

## Purpose

This repository is a **test harness for the [Vulnetix](https://vulnetix.com) CLI's Software Composition Analysis (SCA) capabilities**.

Each sub-directory contains a minimal, self-contained project that uses a specific package manager or build system manifest format. The goal is to verify that the `vulnetix scan` command can:

1. **Detect** the correct manifest file(s) in a project directory.
2. **Analyse** the project and resolve its dependencies.
3. **Report** the correct number of direct dependencies (validated against known expected counts).
4. **Resolve transitive dependencies** — for lock-file repos the total scanned package count must exceed the declared direct dependency count.

---

## Repository Structure

```
test-repos/
├── justfile                  # Task runner — entry point for all test commands
├── scripts/                  # Shell scripts backing each just target
│   ├── check-all.sh
│   ├── detect-all.sh
│   ├── expected-counts.sh    # Ground-truth direct dep counts per repo
│   ├── list-scannable.sh
│   ├── scan-all.sh
│   ├── scan-single.sh
│   └── scan-supported.sh
│
├── python-requirements/      # requirements.txt
├── python-pipfile/           # Pipfile (no lock)
├── python-pipenv-lock/       # Pipfile + Pipfile.lock
├── python-poetry-lock/       # pyproject.toml + poetry.lock
├── python-uv-lock/           # pyproject.toml + uv.lock
├── ruby-gemfile/             # Gemfile + Gemfile.lock
├── ruby-gemfile-lock/        # Gemfile + Gemfile.lock (lock-focused)
├── rust-cargo/               # Cargo.toml
├── elixir-mix/               # mix.exs
├── elixir-mix-lock/          # mix.exs + mix.lock
├── erlang-rebar/             # rebar.config
├── java-gradle-groovy/       # build.gradle (Groovy DSL)
├── java-gradle-kotlin/       # build.gradle.kts (Kotlin DSL)
├── java-gradle-lock/         # build.gradle + gradle.lockfile
├── scala-sbt/                # build.sbt
├── scala-sbt-lock/           # build.sbt + build.lock
├── dotnet-csproj/            # .csproj
├── dotnet-packages-lock/     # .csproj + packages.lock.json
├── dotnet-paket/             # paket.dependencies + paket.lock
├── php-composer/             # composer.json
├── swift-package/            # Package.swift
├── swift-package-resolved/   # Package.swift + Package.resolved
├── ios-cocoapods/            # Podfile + Podfile.lock
├── ios-cocoapods-lock/       # Podfile + Podfile.lock (lock-focused)
├── dart-pub/                 # pubspec.yaml
├── deno/                     # deno.json
├── haskell-cabal/            # .cabal
├── haskell-cabal-freeze/     # .cabal + cabal.project.freeze
├── crystal-shards/           # shard.yml
├── crystal-shard-lock/       # shard.yml + shard.lock
├── julia-project/            # Project.toml
├── julia-manifest/           # Project.toml + Manifest.toml
├── cpp-conan/                # conanfile.txt
├── cpp-conan-lock/           # conanfile.txt + conan.lock
├── cpp-cpm/                  # CMakeLists.txt (CPM)
├── cpp-vcpkg/                # vcpkg.json
├── nix-flake/                # flake.nix
├── nix-flake-lock/           # flake.nix + flake.lock
├── r/                        # DESCRIPTION
├── carthage/                 # Cartfile + Cartfile.resolved
├── meson/                    # meson.build
├── bazel/                    # MODULE.bazel / BUILD
├── buck/                     # BUCK
└── zig/                      # build.zig.zon
```

Each repo declares exactly **5 direct dependencies** (4 for Swift, 6 for Scala) as recorded in `scripts/expected-counts.sh`. Lock-file variants are expected to resolve additional transitive dependencies on top of that count.

---

## Running the Tests

All commands are driven by [`just`](https://just.systems/). Install it with `cargo install just` or your system package manager, then run from the repo root.

### Quick-reference

| Command | What it does |
|---|---|
| `just detect-all` | Fast check — verifies every repo's manifest is **detected** by Vulnetix (no full resolution). |
| `just check-all` | Runs a full scan on every repo and reports detection + scanning success with a summary. |
| `just scan-all` | Full scan on all repos; validates ① manifest detected ② direct dep count matches expected ③ transitive deps > direct count. |
| `just scan-supported` | Like `scan-all` but skips repos Vulnetix cannot yet resolve — much faster for CI. |
| `just list-scannable` | Prints repos where Vulnetix successfully reaches the "Analysing" phase. |
| `just scan-repo <name>` | Scan a single repo with dep-count validation, e.g. `just scan-repo python-pipenv-lock`. |

### How scanning works

Each script invokes:

```bash
vulnetix scan --depth 1 --path <repo-dir> --no-remediation --no-exploits
```

- **`--depth 1`** — limits filesystem traversal to the top level of the repo directory.
- **`--no-remediation --no-exploits`** — skips enrichment steps so tests run quickly and deterministically.

A repo is considered **passing** when the CLI output:
- Contains `"Analysing"` (manifest detected and resolution started), **and**
- Reports a direct dependency count matching the value in `scripts/expected-counts.sh`, **and**
- (for lock-file repos) reports a total scanned package count greater than the direct dependency count.

---

## Adding a New Repo

1. Create a new sub-directory named `<ecosystem>-<manifest-type>` (e.g. `go-mod`).
2. Add a minimal project with **exactly 5 direct dependencies** (or another agreed count).
3. Add the expected direct-dep count to `scripts/expected-counts.sh`.
4. Run `just scan-repo <new-repo>` to confirm it passes before committing.

---

## Prerequisites

- [`vulnetix`](https://vulnetix.com) CLI must be installed and on `$PATH`.
- [`just`](https://just.systems/) task runner.
- `bash` 4+.
