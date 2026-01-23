#!/bin/bash
# Test: verify prompt.md header version is 0.3.1
# AC: Version in prompt.md header updated to 0.3.1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROMPT_MD="$PROJECT_ROOT/fade/prompt.md"

# Check for version in the first line header comment
if ! head -1 "$PROMPT_MD" | grep -q "v0.3.1"; then
    actual=$(head -1 "$PROMPT_MD")
    echo "FAIL: prompt.md header version is not 0.3.1"
    echo "Expected: Contains v0.3.1"
    echo "Actual: $actual"
    exit 1
fi

echo "PASS: prompt.md header version is 0.3.1"
exit 0
