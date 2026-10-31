#!/usr/bin/env bash
# expected-counts.sh - Expected direct dependency counts per repo
# For repos that scan successfully, the direct dependency count (what's declared).
# Lock files will report MORE total packages than direct deps (transitive included).

declare -A EXPECTED=(
    [python-requirements]=5
    [python-pipenv-lock]=5
    [python-poetry-lock]=5
    [python-uv-lock]=5
    [python-pipfile]=5
    [ruby-gemfile]=5
    [ruby-gemfile-lock]=5
    [elixir-mix]=5
    [elixir-mix-lock]=5
    [java-gradle-groovy]=5
    [java-gradle-kotlin]=5
    [java-gradle-lock]=5
    [java-gradle-pom]=5
    [dotnet-packages-lock]=5
    [dotnet-csproj]=5
    [dotnet-paket]=5
    [php-composer]=5
    [swift-package]=4
    [swift-package-resolved]=4
    [scala-sbt]=6
    [scala-sbt-lock]=6
    [cpp-vcpkg]=5
    [cpp-conan]=5
    [cpp-conan-lock]=5
    [cpp-cpm]=5
    [ios-cocoapods]=5
    [ios-cocoapods-lock]=5
    [julia-project]=5
    [julia-manifest]=5
    [crystal-shards]=5
    [crystal-shard-lock]=5
    [haskell-cabal]=5
    [haskell-cabal-freeze]=5
    [dart-pub]=5
    [deno]=5
    [carthage]=5
    [erlang-rebar]=5
    [r]=5
    [nix-flake]=5
    [nix-flake-lock]=5
    [zig]=5
    [meson]=5
    [bazel]=5
    [buck]=5
    [rust-cargo]=5
    [rust-cargo-lock]=5
    [npm]=5
    [npm-lock]=5
    [yarn]=5
    [pnpm]=5
    [bun]=5
    # Monorepos: one lockfile at the root, none beside each member. The five
    # direct dependencies are split across the root and two members.
    [npm-workspace]=5
    [yarn-workspace]=5
    [pnpm-workspace]=5
    [bun-workspace]=5
    [go-mod]=5
    [go-sum]=5
    [java-maven]=5
    [php-composer-lock]=5
    [python-pyproject]=5
    [python-requirements-in]=5
    [erlang-rebar-lock]=5
    [deno-lock]=5
    [r-renv]=5
    [docker]=5
    [docker-containerfile]=5
    [terraform]=5
    [github-actions]=5
    [ocaml-opam]=5
    [haskell-stack]=5
    [bazel-workspace]=5
    [buck2]=5
    [cpp-conan-py]=5
    [sbom-spdx]=5
    [sbom-cyclonedx]=5
)

# scanned_count reads the number of packages the scan parsed from its output on
# stdin: the "Parsed N package(s)" progress line. Matching the first "N packages"
# instead read the findings summary ("2 packages" with advisories), so every
# fixture with a clean dependency scored a mismatch.
scanned_count() {
    grep -oP 'Parsed \K\d+(?= package)' | tail -1
}

# is_workspace_repo NAME: true for a monorepo fixture. Its members have no
# lockfile beside them by design, so a "has no lockfile" note for one is a
# regression (Vulnetix/cli#177), never the expected unresolved case.
is_workspace_repo() {
    [[ "$1" == *-workspace ]]
}
