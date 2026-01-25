#!/bin/bash
# Test: verify spike output documents typical context size after N stories
# AC: Document typical context size after N stories (measure with real PRDs)

SPIKE_OUTPUT="docs/spike-context-isolation.md"

# Assert spike output file exists
if [[ ! -f "$SPIKE_OUTPUT" ]]; then
    echo "FAIL: Spike output file not found"
    echo "Expected: $SPIKE_OUTPUT exists"
    echo "Actual: file not found"
    exit 1
fi

# Assert document contains context size measurements
if ! grep -q "Context size" "$SPIKE_OUTPUT" && ! grep -q "context.*tokens" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output does not document context sizes"
    echo "Expected: document to contain context size measurements"
    echo "Actual: no context size data found"
    exit 1
fi

# Assert document contains baseline context breakdown
if ! grep -q "Baseline Context" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output does not document baseline context"
    echo "Expected: baseline context breakdown section"
    echo "Actual: section not found"
    exit 1
fi

# Assert document contains context growth during execution
if ! grep -q "Context Growth" "$SPIKE_OUTPUT" || ! grep -q "Context Accumulation" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output does not document context growth patterns"
    echo "Expected: context growth/accumulation analysis"
    echo "Actual: section not found"
    exit 1
fi

echo "PASS: Typical context size documented with measurements"
exit 0
