#!/usr/bin/env bash
# list-scannable.sh - List repos where vulnetix successfully scans

for dir in /home/chris/GitHub/test-repos/*/; do
    name=$(basename "$dir")
    if [ "$name" = "scripts" ]; then continue; fi

    output=$(vulnetix scan --depth 1 --path "$dir" --no-remediation --no-exploits 2>&1)

    if echo "$output" | grep -q "Analysing"; then
        manifest=$(echo "$output" | grep -oP '\./\S+' | head -1)
        echo "$name -> $manifest"
    fi
done
