# sca-manifest-fixtures

> Minimal, multi-ecosystem project fixtures for testing [Vulnetix](https://vulnetix.com) CLI Software Composition Analysis (SCA) — manifest detection, dependency resolution, and transitive dependency enumeration across every supported package manager and build system.

---

## Overview

Each sub-directory is a self-contained "hello world" project for a specific language, package manager, or build system. Every project declares a small, known set of direct dependencies so the Vulnetix CLI's SCA output can be automatically validated:

- **Manifest detected** — the CLI finds and parses the correct file(s).
- **Direct dependency count** — matches the ground-truth count in [`scripts/expected-counts.sh`](scripts/expected-counts.sh).
- **Transitive dependency count** — for lock-file repos, the total scanned package count exceeds the direct count.

---

## Fixture Directories

| Directory | Ecosystem | Manifest file(s) |
|---|---|---|
| `bazel` | C++ | `MODULE.bazel`, `BUILD` |
| `buck` | Java | `BUCK` |
| `carthage` | iOS / Swift | `Cartfile`, `Cartfile.resolved` |
| `cpp-conan` | C++ | `conanfile.txt` |
| `cpp-conan-lock` | C++ | `conanfile.txt`, `conan.lock` |
| `cpp-cpm` | C++ | `CMakeLists.txt` (CPM) |
| `cpp-vcpkg` | C++ | `vcpkg.json` |
| `crystal-shards` | Crystal | `shard.yml` |
| `crystal-shard-lock` | Crystal | `shard.yml`, `shard.lock` |
| `dart-pub` | Dart | `pubspec.yaml` |
| `deno` | TypeScript | `deno.json` |
| `dotnet-csproj` | .NET | `App.csproj` |
| `dotnet-packages-lock` | .NET | `App.csproj`, `packages.lock.json` |
| `dotnet-paket` | .NET / F# | `paket.dependencies`, `paket.lock` |
| `elixir-mix` | Elixir | `mix.exs` |
| `elixir-mix-lock` | Elixir | `mix.exs`, `mix.lock` |
| `erlang-rebar` | Erlang | `rebar.config` |
| `haskell-cabal` | Haskell | `myapp.cabal` |
| `haskell-cabal-freeze` | Haskell | `myapp.cabal`, `cabal.project.freeze` |
| `ios-cocoapods` | iOS | `Podfile`, `Podfile.lock` |
| `ios-cocoapods-lock` | iOS | `Podfile`, `Podfile.lock` |
| `java-gradle-groovy` | Java | `build.gradle` (Groovy DSL) |
| `java-gradle-kotlin` | Java | `build.gradle.kts` (Kotlin DSL) |
| `java-gradle-lock` | Java | `build.gradle`, `gradle.lockfile` |
| `julia-project` | Julia | `Project.toml` |
| `julia-manifest` | Julia | `Project.toml`, `Manifest.toml` |
| `meson` | C++ | `meson.build` |
| `nix-flake` | Nix | `flake.nix` |
| `nix-flake-lock` | Nix | `flake.nix`, `flake.lock` |
| `php-composer` | PHP | `composer.json` |
| `python-requirements` | Python | `requirements.txt` |
| `python-pipfile` | Python | `Pipfile` |
| `python-pipenv-lock` | Python | `Pipfile`, `Pipfile.lock` |
| `python-poetry-lock` | Python | `pyproject.toml`, `poetry.lock` |
| `python-uv-lock` | Python | `pyproject.toml`, `uv.lock` |
| `r` | R | `DESCRIPTION` |
| `ruby-gemfile` | Ruby | `Gemfile`, `Gemfile.lock` |
| `ruby-gemfile-lock` | Ruby | `Gemfile`, `Gemfile.lock` |
| `rust-cargo` | Rust | `Cargo.toml` |
| `scala-sbt` | Scala | `build.sbt` |
| `scala-sbt-lock` | Scala | `build.sbt`, `build.lock` |
| `swift-package` | Swift | `Package.swift` |
| `swift-package-resolved` | Swift | `Package.swift`, `Package.resolved` |
| `zig` | Zig | `build.zig.zon` |

Each project declares **5 direct dependencies** (4 for Swift, 6 for Scala). Lock-file variants resolve additional transitive dependencies on top.

---

## Running the Tests

All commands are driven by [`just`](https://just.systems/). Install it with your system package manager or `cargo install just`, then run from the repo root.

### Prerequisites

- [`vulnetix`](https://vulnetix.com) CLI — installed and on `$PATH`
- [`just`](https://just.systems/) — task runner
- `bash` 4+

### Commands

| Command | What it does |
|---|---|
| `just detect-all` | Quick check — verifies every repo's manifest is **detected** by Vulnetix (no full resolution). |
| `just check-all` | Full scan on every repo; reports detection + scanning success with a pass/fail summary. |
| `just scan-all` | Full scan + validation: ① manifest detected ② direct dep count matches expected ③ transitive count > direct count. |
| `just scan-supported` | Like `scan-all` but skips repos Vulnetix cannot yet resolve — faster for CI. |
| `just list-scannable` | Prints repos where Vulnetix successfully reaches the "Analysing" phase. |
| `just scan-repo <name>` | Scan and validate a single repo, e.g. `just scan-repo python-pipenv-lock`. |

### How validation works

Each script calls:

```bash
vulnetix scan --depth 1 --path <repo-dir> --no-remediation --no-exploits
```

A repo **passes** when:
1. CLI output contains `"Analysing"` (manifest found and resolution started).
2. Reported direct dependency count equals the value in `scripts/expected-counts.sh`.
3. *(Lock-file repos only)* Total scanned package count is greater than the direct dependency count.

---

## Adding a New Fixture

1. Create a sub-directory named `<ecosystem>-<manifest-type>` (e.g. `go-mod`).
2. Add a minimal project with exactly **5 direct dependencies**.
3. Add the expected count to `scripts/expected-counts.sh`.
4. Add a `.gitignore` appropriate for the language and package manager (remember to include `.vulnetix/`).
5. Smoke-test locally: `just scan-repo <new-dir>`.
6. Document the new row in this README's fixture table.

---

## License

Copyright 2024 Vulnetix

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the full text.
