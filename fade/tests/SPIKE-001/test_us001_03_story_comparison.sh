#!/bin/bash
# Test: verify spike output compares quality across story progression
# AC: Compare output quality: story 1 vs story 5 vs story 10 in same session

SPIKE_OUTPUT="docs/spike-context-isolation.md"

# Assert spike output file exists
if [[ ! -f "$SPIKE_OUTPUT" ]]; then
    echo "FAIL: Spike output file not found"
    echo "Expected: $SPIKE_OUTPUT exists"
    echo "Actual: file not found"
    exit 1
fi

# Assert document contains story comparison section
if ! grep -q "Story 1 vs Story 5 vs Story 10" "$SPIKE_OUTPUT" && ! grep -q "Comparison of Story" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output missing story comparison section"
    echo "Expected: section comparing story 1 vs 5 vs 10"
    echo "Actual: comparison section not found"
    exit 1
fi

# Assert document contains case study or specific story analysis
if ! grep -q "Case Study" "$SPIKE_OUTPUT" && ! grep -q "Story 1.*Story 5" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output missing specific story comparisons"
    echo "Expected: case study or specific story quality comparisons"
    echo "Actual: no specific comparisons found"
    exit 1
fi

# Assert document contains assessment or conclusion about story progression
if ! grep -q "Assessment" "$SPIKE_OUTPUT" && ! grep -q "quality.*story" "$SPIKE_OUTPUT"; then
    echo "FAIL: Spike output missing quality assessment across stories"
    echo "Expected: assessment of quality across story progression"
    echo "Actual: no assessment found"
    exit 1
fi

echo "PASS: Story quality comparison documented"
exit 0
