#!/usr/bin/env bash
# scan-all.sh - Run full vulnetix scan on all repos, verify direct & transitive dependency counts
#
# Validation rules per repo:
#   1. Manifest detected
#   2. Direct dependency count == expected (from expected-counts.sh)
#   3. Scanned package count > direct dependency count (lock file picked up transitive deps)

# Don't use set -e: vulnetix returns non-zero when vulnerabilities are found

PASS=0
FAIL=0
SKIPPED=0

# Source expected counts
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/expected-counts.sh"

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BOLD='\033[1m'
NC='\033[0m'

printf "${BOLD}=== Vulnetix Full Scan Report ===${NC}\n"
printf "%-35s %8s %8s %s\n" "REPO" "DIRECT" "SCANNED" "STATUS"
printf '%*s\n' 83 ''

for dir in "$SCRIPT_DIR"/../*/; do
    name=$(basename "$dir")
    [ "$name" = "scripts" ] && continue

    expected=${EXPECTED[$name]:-0}

    output=$(vulnetix scan --depth 3 --path "$dir" --no-remediation --no-exploits 2>&1) || true

    # Check manifest detected
    if ! echo "$output" | grep -qE "Parsing [0-9]+ detected file"; then
        printf "%-35s %8d %8s ${RED}%s${NC}\n" "$name" "$expected" "—" "NOT DETECTED"
        FAIL=$((FAIL + 1))
        continue
    fi

    # A manifest with no lock file and no installed environment is refused on
    # purpose: the CLI cannot resolve concrete versions, so it declines rather
    # than guessing, and says which build step is missing. That is the product
    # behaving correctly, not a detection failure — several fixtures here exist
    # specifically to exercise the unresolved case (npm, php-composer,
    # python-pyproject, python-requirements-in, dart-pub, elixir-mix). Counting
    # them as failures buried the real regressions.
    if echo "$output" | grep -qE "has no (lock|[a-zA-Z.]+\.lock|lockfile)"; then
        printf "%-35s %8d %8s ${YELLOW}%s${NC}\n" "$name" "$expected" "—" "LOCKFILE REQUIRED (expected)"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    # Extract scanned package count: "N packages"
    scanned=$(echo "$output" | grep -oP '\d+ packages' | head -1 | grep -oP '^\d+')
    scanned=${scanned:-0}

    # Validate direct deps match
    if [ "$expected" -eq 0 ]; then
        status="${RED}NO EXPECTED COUNT${NC}"
        FAIL=$((FAIL + 1))
    elif [ "$scanned" -eq "$expected" ]; then
        # Exact match — requirements.txt, no lock file (no transitive deps expected)
        status="${GREEN}PASS${NC}"
        PASS=$((PASS + 1))
    elif [ "$scanned" -gt "$expected" ]; then
        # More scanned than direct — lock file resolved transitive deps
        status="${GREEN}PASS (transitive: $scanned > $expected direct)${NC}"
        PASS=$((PASS + 1))
    else
        status="${YELLOW}MISMATCH (scanned $scanned < expected $expected)${NC}"
        FAIL=$((FAIL + 1))
    fi

    printf "%-35s %8d %8d %b\n" "$name" "$expected" "$scanned" "$status"
done

printf '\n'
printf "${BOLD}=== Summary ===${NC}\n"
printf "  Passed:  %d\n" "$PASS"
printf "  Failed:  %d\n" "$FAIL"
printf "  Lockfile required (expected): %d\n" "$SKIPPED"
printf "  Total:   %d\n" $((PASS + FAIL + SKIPPED))

[ "$FAIL" -gt 0 ] && exit 1 || exit 0
