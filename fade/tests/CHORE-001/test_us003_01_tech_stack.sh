#!/bin/bash
# Test: verify FADE.md contains tech stack section
# AC: Tech stack section is accurate

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_MD="$PROJECT_ROOT/FADE.md"

# Check for Tech Stack section
if ! grep -q "Tech Stack" "$FADE_MD"; then
    echo "FAIL: FADE.md missing Tech Stack section"
    echo "Expected: Tech Stack section present"
    echo "Actual: Section not found"
    exit 1
fi

# Check for key tech stack items
if ! grep -q "Bash" "$FADE_MD"; then
    echo "FAIL: FADE.md Tech Stack should mention Bash"
    echo "Expected: Bash mentioned"
    echo "Actual: Not found"
    exit 1
fi

echo "PASS: FADE.md contains tech stack section"
exit 0
