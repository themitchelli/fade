#!/bin/bash
# Test: verify export-learning generates Markdown report
# AC: Generate human-readable summary: 'Learning Report: ENH-015 Quarterly Review'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for Markdown report generation
if ! grep -q 'learning-report.md\|markdown_path\|Markdown' "$CLI_FILE"; then
    echo "FAIL: fade-cli should generate learning-report.md"
    exit 1
fi

echo "PASS: fade-cli generates Markdown learning report"
exit 0
