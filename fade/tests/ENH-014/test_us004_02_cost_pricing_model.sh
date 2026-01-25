#!/bin/bash
# Test: verify cost estimation uses correct model pricing
# AC: Include estimated cost based on model pricing (opus: $15/$75, sonnet: $3/$15, haiku: $0.25/$1.25 per 1M tokens)

set -e

FADE_CLI="$(which fade)"

# Check estimate_cost function has correct pricing
# Opus: $15 input, $75 output
if ! grep -A 20 "estimate_cost()" "$FADE_CLI" | grep -q "15.*0.8.*75.*0.2\|opus"; then
    echo "FAIL: Opus pricing ($15/$75) not found in estimate_cost"
    exit 1
fi

# Sonnet: $3 input, $15 output
if ! grep -A 20 "estimate_cost()" "$FADE_CLI" | grep -q "3.*0.8.*15.*0.2\|sonnet"; then
    echo "FAIL: Sonnet pricing ($3/$15) not found in estimate_cost"
    exit 1
fi

# Haiku: $0.25 input, $1.25 output
if ! grep -A 20 "estimate_cost()" "$FADE_CLI" | grep -q "0.25.*0.8.*1.25.*0.2\|haiku"; then
    echo "FAIL: Haiku pricing ($0.25/$1.25) not found in estimate_cost"
    exit 1
fi

echo "PASS: Cost estimation uses correct model pricing"
exit 0
