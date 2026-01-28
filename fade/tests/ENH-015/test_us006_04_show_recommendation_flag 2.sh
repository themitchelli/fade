#!/bin/bash
# Test: verify --show-recommendation flag exists
# AC: Support --show-recommendation flag to display without executing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for --show-recommendation flag
if ! grep -q '\-\-show-recommendation' "$CLI_FILE"; then
    echo "FAIL: fade-cli should support --show-recommendation flag"
    exit 1
fi

echo "PASS: fade-cli supports --show-recommendation flag"
exit 0
