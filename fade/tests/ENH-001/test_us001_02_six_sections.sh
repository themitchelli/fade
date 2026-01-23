#!/bin/bash
# Test: verify architecture.md contains 6 required sections
# AC: Contains 6 sections: Operational Excellence, Security, Reliability, Performance, Cost, Sustainability

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/standards/architecture.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: architecture.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")
MISSING=()

# Check for each required section
if ! echo "$CONTENT" | grep -q "Operational Excellence"; then
    MISSING+=("Operational Excellence")
fi

if ! echo "$CONTENT" | grep -q "Security"; then
    MISSING+=("Security")
fi

if ! echo "$CONTENT" | grep -q "Reliability"; then
    MISSING+=("Reliability")
fi

if ! echo "$CONTENT" | grep -q "Performance"; then
    MISSING+=("Performance")
fi

if ! echo "$CONTENT" | grep -q "Cost"; then
    MISSING+=("Cost")
fi

if ! echo "$CONTENT" | grep -q "Sustainability"; then
    MISSING+=("Sustainability")
fi

if [[ ${#MISSING[@]} -gt 0 ]]; then
    echo "FAIL: Missing required sections"
    echo "Expected: All 6 sections (Operational Excellence, Security, Reliability, Performance, Cost, Sustainability)"
    echo "Missing: ${MISSING[*]}"
    exit 1
fi

echo "PASS: All 6 required sections present"
exit 0
