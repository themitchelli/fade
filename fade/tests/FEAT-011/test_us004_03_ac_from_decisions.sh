#!/bin/bash
# Test: acceptance criteria derived from decisions
# AC: Acceptance criteria derived from decisions made in discovery

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for AC derivation guidance
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Search within PRD generation context for acceptanceCriteria
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -q 'acceptanceCriteria'; then
    echo "FAIL: PRD template missing acceptanceCriteria field"
    echo "Expected: PRD template includes 'acceptanceCriteria' array"
    echo "Actual: 'acceptanceCriteria' not found"
    exit 1
fi

# Check for guidance connecting decisions to AC
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -qi "derive.*decision\|decision"; then
    echo "FAIL: No guidance to derive AC from decisions"
    echo "Expected: instruction to derive acceptance criteria from Decisions section"
    echo "Actual: decision-to-AC guidance not found"
    exit 1
fi

# Check for specificity guidance
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -qi "specific\|testable"; then
    echo "FAIL: No guidance for specific/testable criteria"
    echo "Expected: guidance that AC should be specific and testable"
    echo "Actual: specificity guidance not found"
    exit 1
fi

echo "PASS: acceptance criteria derived from decisions made in discovery"
exit 0
