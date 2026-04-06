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
)
