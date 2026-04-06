#!/usr/bin/env bash
# scan-supported.sh - Run real vulnetix scan only on repos it can actually detect + resolve
# Validates: manifest detected, direct dep count matches expected, transitive deps >= direct

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/expected-counts.sh"

PASS=0
FAIL=0

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BOLD='\033[1m'
NC='\033[0m'

# Repo directories that vulnetix actually supports (reached "Analysing" phase)
SUPPORTED_REPOS=(
    python-requirements
    python-pipenv-lock
    ruby-gemfile
    ruby-gemfile-lock
)

printf "${BOLD}=== Vulnetix Supported Repo Scan ===${NC}\n"
printf "%-35s %8s %8s %s\n" "REPO" "DIRECT" "SCANNED" "STATUS"
printf '%*s\n' 83 ''

for repo in "${SUPPORTED_REPOS[@]}"; do
    dir="$SCRIPT_DIR/../$repo"
    expected=${EXPECTED[$repo]:-5}

    output=$(vulnetix scan --depth 1 --path "$dir" --no-remediation --no-exploits 2>&1) || true

    if ! echo "$output" | grep -q "Analysing"; then
        printf "%-35s %8d %8s ${RED}%s${NC}\n" "$repo" "$expected" "—" "NOT DETECTED"
        FAIL=$((FAIL + 1))
        continue
    fi

    scanned=$(echo "$output" | grep -oP '\d+ packages' | head -1 | grep -oP '^\d+')
    scanned=${scanned:-0}

    if [ "$scanned" -eq "$expected" ]; then
        status="${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    elif [ "$scanned" -gt "$expected" ]; then
        transitive=$((scanned - expected))
        status="${GREEN}PASS (+${transitive} transitive)${NC}"
        PASS=$((PASS + 1))
    else
        status="${YELLOW}MISMATCH (scanned $scanned < expected $expected)${NC}"
        FAIL=$((FAIL + 1))
    fi

    printf "%-35s %8d %8d %b\n" "$repo" "$expected" "$scanned" "$status"
done

printf '\n'
printf "${BOLD}=== Summary ===${NC}\n"
printf "  Passed:  %d\n" "$PASS"
printf "  Failed:  %d\n" "$FAIL"
printf "  Total:   %d\n" $((PASS + FAIL))

[ "$FAIL" -gt 0 ] && exit 1 || exit 0
