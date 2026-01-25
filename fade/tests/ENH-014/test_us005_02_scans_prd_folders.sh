#!/bin/bash
# Test: verify fade classify scans fade/prds/ and fade/prd-archive/
# AC: Scan fade/prds/ and fade/prd-archive/ for PRDs missing complexity field

set -e

FADE_CLI="$(which fade)"

# Check that cmd_classify scans both folders
if grep -A 100 "cmd_classify()" "$FADE_CLI" | grep -q "fade/prds"; then
    if grep -A 100 "cmd_classify()" "$FADE_CLI" | grep -q "fade/prd-archive\|prd-archive"; then
        echo "PASS: fade classify scans fade/prds/ and fade/prd-archive/"
        exit 0
    fi
fi

echo "FAIL: fade classify should scan fade/prds/ and fade/prd-archive/"
exit 1
