#!/bin/bash
# Test: verify 'fade export-learning' command exists
# AC: Create 'fade export-learning' command

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for export-learning command
if ! grep -q 'export-learning\|cmd_export_learning' "$CLI_FILE"; then
    echo "FAIL: fade-cli should have export-learning command"
    exit 1
fi

echo "PASS: fade-cli has export-learning command"
exit 0
