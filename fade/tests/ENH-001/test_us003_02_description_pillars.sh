#!/bin/bash
# Test: verify FADE.md Architecture description summarizes the 6 pillars
# AC: Description summarizes the 6 pillars

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/FADE.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: FADE.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Find the Architecture row and check for pillar keywords
# The description should mention several pillars (not necessarily all by name)
ARCH_LINE=$(echo "$CONTENT" | grep -i "Architecture.*architecture.md")

if [[ -z "$ARCH_LINE" ]]; then
    ARCH_LINE=$(echo "$CONTENT" | grep "architecture.md")
fi

if [[ -z "$ARCH_LINE" ]]; then
    echo "FAIL: Architecture row not found in FADE.md"
    exit 1
fi

# Check for pillar-related keywords in the description
# Pillars: operational excellence, security, reliability, performance, cost, sustainability
PILLAR_KEYWORDS=0

if echo "$ARCH_LINE" | grep -qi "operational"; then
    ((PILLAR_KEYWORDS++))
fi

if echo "$ARCH_LINE" | grep -qi "security"; then
    ((PILLAR_KEYWORDS++))
fi

if echo "$ARCH_LINE" | grep -qi "reliab"; then
    ((PILLAR_KEYWORDS++))
fi

if echo "$ARCH_LINE" | grep -qi "performance"; then
    ((PILLAR_KEYWORDS++))
fi

if echo "$ARCH_LINE" | grep -qi "cost"; then
    ((PILLAR_KEYWORDS++))
fi

if echo "$ARCH_LINE" | grep -qi "sustain"; then
    ((PILLAR_KEYWORDS++))
fi

# Should mention at least 3 pillars to be considered a summary
if [[ $PILLAR_KEYWORDS -lt 3 ]]; then
    echo "FAIL: Architecture description doesn't summarize the 6 pillars"
    echo "Expected: Description mentioning multiple pillars (operational, security, reliability, performance, cost, sustainability)"
    echo "Actual: Only $PILLAR_KEYWORDS pillar keywords found"
    echo "Line: $ARCH_LINE"
    exit 1
fi

echo "PASS: Architecture description summarizes pillars ($PILLAR_KEYWORDS keywords found)"
exit 0
