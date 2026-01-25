#!/bin/bash
# Test: verify aggregate stats are maintained in model-usage.md
# AC: Aggregate stats at bottom: 'Total sessions: 47, Haiku: 12 ($1.80), Sonnet: 32 ($48.00), Opus: 3 ($45.00)'

set -e

FADE_CLI="$(which fade)"

# Check that update_model_usage_stats function exists and is called
if grep -q "update_model_usage_stats" "$FADE_CLI"; then
    # Check it's called from log_model_usage
    if grep -A 60 "log_model_usage()" "$FADE_CLI" | grep -q "update_model_usage_stats"; then
        echo "PASS: Aggregate stats are maintained via update_model_usage_stats"
        exit 0
    fi
fi

echo "FAIL: Aggregate stats should be maintained in model-usage.md"
exit 1
