#!/bin/bash
# Test: verify spike output identifies at what context size quality degrades
# AC: Identify at what context size quality noticeably degrades

SPIKE_OUTPUT="docs/spike-context-isolation.md"

# Assert spike output file exists
if [[ ! -f "$SPIKE_OUTPUT" ]]; then
    echo "FAIL: Spike output file not found"
    echo "Expected: $SPIKE_OUTPUT exists"
    echo "Actual: file not found"
    exit 1
fi

# Assert document addresses quality degradation
if ! grep -q -i "degradation" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output does not address quality degradation"
    echo "Expected: document to discuss degradation threshold"
    echo "Actual: no degradation analysis found"
    exit 1
fi

# Assert document contains quality analysis section
if ! grep -q "Quality Degradation Analysis" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output missing quality degradation analysis section"
    echo "Expected: Quality Degradation Analysis section"
    echo "Actual: section not found"
    exit 1
fi

# Assert document contains a finding about degradation threshold
# (either a specific threshold or conclusion that it wasn't reached)
if ! grep -q -i "threshold" "$SPIKE_OUTPUT" && ! grep -q "no.*degradation" "$SPIKE_OUTPUT" && ! grep -q "No observable" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output does not identify degradation threshold"
    echo "Expected: either a degradation threshold or finding that none was observed"
    echo "Actual: no threshold finding documented"
    exit 1
fi

echo "PASS: Quality degradation threshold analysis documented"
exit 0
