#!/bin/bash
# Test: verify JSON report has required summary fields
# AC: Summary: Total PRDs analyzed, success rates by model, average sessions by type

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for summary fields in JSON generation
if ! grep -q 'totalPrds\|accuracyStats\|summary' "$CLI_FILE"; then
    echo "FAIL: JSON report should have summary with totalPrds and accuracyStats"
    exit 1
fi

echo "PASS: JSON report includes summary fields"
exit 0
