#!/bin/bash
# Test: verify prompt.md version stamp is 0.3.1
# AC: Version stamp updated to 0.3.1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROMPT_MD="$PROJECT_ROOT/fade/prompt.md"

# Check for version stamp in header
if ! head -1 "$PROMPT_MD" | grep -q "v0.3.1"; then
    actual_version=$(head -1 "$PROMPT_MD")
    echo "FAIL: prompt.md version stamp not 0.3.1"
    echo "Expected: v0.3.1 in header"
    echo "Actual: $actual_version"
    exit 1
fi

echo "PASS: prompt.md version stamp is 0.3.1"
exit 0
