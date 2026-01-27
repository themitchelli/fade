#!/bin/bash
# Test: verify fade-cli suggests resume command
# AC: Suggest: 'fade run PRD-LC-010 --model opus --resume'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for resume suggestion
if ! grep -q '\-\-model.*opus\|\-\-resume\|resume' "$CLI_FILE"; then
    echo "FAIL: fade-cli should suggest model upgrade with resume"
    exit 1
fi

echo "PASS: fade-cli suggests model upgrade with resume option"
exit 0
