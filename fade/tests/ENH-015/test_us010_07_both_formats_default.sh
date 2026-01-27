#!/bin/bash
# Test: verify export-learning defaults to both formats
# AC: Output formats: JSON for data analysis, Markdown for human review (both by default)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check that default format is "both"
if ! grep -q 'format="both"\|format=.*both' "$CLI_FILE"; then
    echo "FAIL: export-learning should default to both formats"
    exit 1
fi

echo "PASS: export-learning defaults to both formats"
exit 0
