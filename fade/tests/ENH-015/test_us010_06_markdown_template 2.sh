#!/bin/bash
# Test: verify Markdown report has proper template
# AC: Generate human-readable summary with model performance, recommendations for tuning, next steps

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for Markdown template sections
if ! grep -q 'Model Performance\|Recommendations for Tuning\|Next Steps\|Quarterly' "$CLI_FILE"; then
    echo "FAIL: Markdown report should have structured template"
    exit 1
fi

echo "PASS: Markdown report has structured template"
exit 0
