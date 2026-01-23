#!/bin/bash
# Test: verify architecture.md mapped to correct work types in prompt.md
# AC: Mapped to work types: system design, new services, infrastructure decisions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/prompt.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: prompt.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Find the line containing architecture.md and check work types
ARCH_LINE=$(echo "$CONTENT" | grep -i "architecture.md")

if [[ -z "$ARCH_LINE" ]]; then
    echo "FAIL: No line containing architecture.md found"
    exit 1
fi

# Check for expected work type keywords (case insensitive)
FOUND_KEYWORDS=0

if echo "$ARCH_LINE" | grep -qi "system design\|design"; then
    ((FOUND_KEYWORDS++))
fi

if echo "$ARCH_LINE" | grep -qi "service\|infrastructure"; then
    ((FOUND_KEYWORDS++))
fi

if [[ $FOUND_KEYWORDS -lt 1 ]]; then
    echo "FAIL: architecture.md not mapped to expected work types"
    echo "Expected: Mapped to system design, new services, infrastructure decisions"
    echo "Actual line: $ARCH_LINE"
    exit 1
fi

echo "PASS: architecture.md mapped to appropriate work types"
exit 0
