#!/usr/bin/env bash
# detect-all.sh - Quick detection-only check for all repos

passed=0
detected_unsup=0
failed=0

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Vulnetix Manifest Detection Check ==="
echo ""

for dir in "$SCRIPT_DIR"/../*/; do
    name=$(basename "$dir")
    if [ "$name" = "scripts" ]; then continue; fi

    output=$(vulnetix scan --depth 3 --path "$dir" --no-remediation --no-exploits 2>&1)

    if echo "$output" | grep -qE "Parsing [0-9]+ detected file"; then
        printf "  %-35s OK\n" "$name"
        passed=$((passed + 1))
    elif echo "$output" | grep -q "Detected files"; then
        printf "  %-35s DETECTED (unsupported)\n" "$name"
        detected_unsup=$((detected_unsup + 1))
    else
        printf "  %-35s NOT FOUND\n" "$name"
        failed=$((failed + 1))
    fi
done

echo ""
printf "  OK: %-3d Detected (unsupported): %-3d NOT FOUND: %d\n" "$passed" "$detected_unsup" "$failed"
