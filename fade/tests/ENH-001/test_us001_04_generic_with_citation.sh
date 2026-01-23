#!/bin/bash
# Test: verify generic framing with AWS Well-Architected citation
# AC: Generic framing (not AWS-branded) but cites AWS Well-Architected as source

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/standards/architecture.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: architecture.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Check for AWS Well-Architected citation
if ! echo "$CONTENT" | grep -q "AWS Well-Architected"; then
    echo "FAIL: Missing AWS Well-Architected citation"
    echo "Expected: Reference to AWS Well-Architected Framework"
    echo "Actual: Citation not found"
    exit 1
fi

# Check that it's presented generically (mentions "any project type" or similar)
if ! echo "$CONTENT" | grep -qi "generic\|any project"; then
    echo "FAIL: Missing generic framing language"
    echo "Expected: Language indicating principles apply to any project type"
    echo "Actual: Generic framing not found"
    exit 1
fi

# Negative check: Should not be branded as "AWS Standard" or similar
if echo "$CONTENT" | grep -qi "^# AWS\|AWS Standard"; then
    echo "FAIL: Document appears AWS-branded (should be generic)"
    echo "Expected: Generic architecture standard"
    echo "Actual: Found AWS branding in title"
    exit 1
fi

echo "PASS: Generic framing with AWS Well-Architected citation"
exit 0
