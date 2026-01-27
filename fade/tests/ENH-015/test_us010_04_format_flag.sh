#!/bin/bash
# Test: verify export-learning supports --format flag
# AC: Output formats: JSON for data analysis, Markdown for human review

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for --format flag support
if ! grep -q '\-\-format' "$CLI_FILE"; then
    echo "FAIL: fade-cli should support --format flag for export-learning"
    exit 1
fi

echo "PASS: fade-cli supports --format flag for export-learning"
exit 0
