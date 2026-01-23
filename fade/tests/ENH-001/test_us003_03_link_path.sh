#!/bin/bash
# Test: verify FADE.md Architecture link points to fade/standards/architecture.md
# AC: Link points to fade/standards/architecture.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/FADE.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: FADE.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Check for correct link path: fade/standards/architecture.md
if ! echo "$CONTENT" | grep -q "fade/standards/architecture.md"; then
    echo "FAIL: Link to fade/standards/architecture.md not found"
    echo "Expected: Link containing 'fade/standards/architecture.md'"

    # Check if there's an incorrect path
    ALT_LINK=$(echo "$CONTENT" | grep -o "architecture.md" | head -1)
    if [[ -n "$ALT_LINK" ]]; then
        echo "Actual: Found 'architecture.md' but not with correct path"
    else
        echo "Actual: No architecture.md link found"
    fi
    exit 1
fi

echo "PASS: FADE.md links to correct path fade/standards/architecture.md"
exit 0
