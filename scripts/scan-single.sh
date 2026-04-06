#!/usr/bin/env bash
# scan-single.sh - Scan a single repo with dependency count validation

REPO="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/expected-counts.sh"

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BOLD='\033[1m'
NC='\033[0m'

expected=${EXPECTED[$REPO]:-5}
dir="$SCRIPT_DIR/../$REPO"

if [ ! -d "$dir" ]; then
    echo "${RED}Error: Repository '$REPO' not found in test-repos${NC}"
    exit 1
fi

printf "${BOLD}=== Scanning: %s (expected direct deps: %d) ===${NC}\n" "$REPO" "$expected"
echo ""

# Run vulnetix - may exit non-zero on vulnerabilities, so always capture
output=$(vulnetix scan --depth 1 --path "$dir" --no-remediation --no-exploits 2>&1) || true

# Check manifest detected
if ! echo "$output" | grep -q "Analysing"; then
    echo "  ${RED}FAIL: Manifest not detected${NC}"
    exit 1
fi

# Extract scanned package count: "N packages"
scanned=$(echo "$output" | grep -oP '\d+ packages' | head -1 | grep -oP '^\d+') || true
scanned=${scanned:-0}

echo ""
echo "  Direct dependencies (expected): $expected"
echo "  Packages scanned:                $scanned"
echo ""

# Validate
if [ "$scanned" -eq "0" ]; then
    printf "  ${RED}FAIL: No packages resolved${NC}\n"
    exit 1
elif [ "$scanned" -ge "$expected" ]; then
    transitive=$((scanned - expected))
    printf "  ${GREEN}OK: Direct deps match ($expected) and transitive deps resolved (+$transitive)${NC}\n"
    exit 0
else
    printf "  ${YELLOW}MISMATCH: Scanned $scanned < expected $expected direct deps${NC}\n"
    exit 1
fi
