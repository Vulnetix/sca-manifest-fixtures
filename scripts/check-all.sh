#!/usr/bin/env bash
# check-all.sh - Run vulnetix scan on all repos, report detection + scanning status

passed=0
detected_unsup=0
failed=0

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/expected-counts.sh"

echo "=== Vulnetix Manifest Detection Report ==="
echo ""

for dir in "$SCRIPT_DIR"/../*/; do
    name=$(basename "$dir")

    # Skip the scripts directory
    if [ "$name" = "scripts" ]; then continue; fi

    output=$(vulnetix scan --depth 3 --path "$dir" --no-remediation --no-exploits 2>&1)

    if echo "$output" | grep -qE "Parsing [0-9]+ detected file"; then
        pkgs="$(echo "$output" | scanned_count) packages"
        printf "  %-35s PASS (scanning: %s)\n" "$name" "$pkgs"
        passed=$((passed + 1))
    elif echo "$output" | grep -q "not supported"; then
        manifest=$(echo "$output" | grep -oP '\./\S+' | head -1)
        printf "  %-35s DETECTED (unsupported: %s)\n" "$name" "$manifest"
        detected_unsup=$((detected_unsup + 1))
    else
        printf "  %-35s FAIL (not detected)\n" "$name"
        failed=$((failed + 1))
    fi
done

echo ""
echo "=== Summary ==="
printf "  Scanning successfully:    %d\n" "$passed"
printf "  Detected but unsupported: %d\n" "$detected_unsup"
printf "  Not detected:             %d\n" "$failed"
printf "  Total repos:              %d\n" $((passed + detected_unsup + failed))

if [ "$failed" -gt 0 ]; then exit 1; fi
