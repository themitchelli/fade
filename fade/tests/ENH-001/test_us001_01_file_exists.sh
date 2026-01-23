#!/bin/bash
# Test: verify fade/standards/architecture.md exists
# AC: fade/standards/architecture.md exists

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/standards/architecture.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: architecture.md does not exist"
    echo "Expected: $FILE to exist"
    echo "Actual: file not found"
    exit 1
fi

echo "PASS: fade/standards/architecture.md exists"
exit 0
