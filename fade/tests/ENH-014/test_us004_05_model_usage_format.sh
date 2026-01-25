#!/bin/bash
# Test: verify model-usage.md has correct table format
# AC: Format: '| Date | PRD | Complexity | Model | Override | Duration | Est. Cost |'

set -e

FADE_CLI="$(which fade)"

# Check that log_model_usage creates table with expected columns
if grep -A 30 "log_model_usage()" "$FADE_CLI" | grep -q "Date.*PRD.*Complexity.*Model.*Override.*Duration"; then
    echo "PASS: model-usage.md uses correct table format"
    exit 0
fi

echo "FAIL: model-usage.md should have format: | Date | PRD | Complexity | Model | Override | Duration | Est. Cost |"
exit 1
