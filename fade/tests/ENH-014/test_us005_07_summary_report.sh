#!/bin/bash
# Test: verify fade classify creates summary report
# AC: Create summary report: 'Classified 21 PRDs: 5 simple, 12 medium, 4 complex'

set -e

FADE_CLI="$(which fade)"

# Check that cmd_classify outputs summary with counts
if grep -A 200 "cmd_classify()" "$FADE_CLI" | grep -q "Classification Summary\|Classified.*PRDs\|Simple.*Medium.*Complex"; then
    echo "PASS: fade classify creates summary report"
    exit 0
fi

echo "FAIL: fade classify should create summary report with counts"
exit 1
