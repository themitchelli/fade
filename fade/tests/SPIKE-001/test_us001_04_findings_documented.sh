#!/bin/bash
# Test: verify findings are documented in spike output
# AC: Document findings in learned.md or spike output

SPIKE_OUTPUT="docs/spike-context-isolation.md"

# Assert spike output file exists
if [[ ! -f "$SPIKE_OUTPUT" ]]; then
    echo "FAIL: Spike output file not found"
    echo "Expected: $SPIKE_OUTPUT exists"
    echo "Actual: file not found"
    exit 1
fi

# Assert document contains findings section
if ! grep -q "Finding" "$SPIKE_OUTPUT" && ! grep -q "Findings" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output does not contain findings"
    echo "Expected: documented findings section"
    echo "Actual: no findings found"
    exit 1
fi

# Assert document contains key finding about context rot
if ! grep -q "context rot" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output does not address context rot finding"
    echo "Expected: finding about context rot"
    echo "Actual: context rot not mentioned"
    exit 1
fi

# Assert document contains a recommendation
if ! grep -q "Recommendation" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output missing recommendation"
    echo "Expected: recommendation based on findings"
    echo "Actual: no recommendation found"
    exit 1
fi

# Assert document contains a conclusion
if ! grep -q "Conclusion" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output missing conclusion"
    echo "Expected: conclusion section"
    echo "Actual: no conclusion found"
    exit 1
fi

echo "PASS: Findings documented in spike output"
exit 0
