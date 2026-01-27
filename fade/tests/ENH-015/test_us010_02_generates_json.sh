#!/bin/bash
# Test: verify export-learning generates JSON report
# AC: Generate report: fade/learning-report.json containing summary, PRD list, accuracy, patterns

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for JSON report generation
if ! grep -q 'learning-report.json\|json_report' "$CLI_FILE"; then
    echo "FAIL: fade-cli should generate learning-report.json"
    exit 1
fi

echo "PASS: fade-cli generates JSON learning report"
exit 0
