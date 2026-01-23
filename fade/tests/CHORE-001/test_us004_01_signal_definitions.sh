#!/bin/bash
# Test: verify prompt.md contains signal definitions
# AC: Signal definitions match current implementation

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROMPT_MD="$PROJECT_ROOT/fade/prompt.md"

# Check for key signal definitions
SIGNALS=("STORY_DONE" "ALL_COMPLETE" "BLOCKED")

missing=()

for signal in "${SIGNALS[@]}"; do
    if ! grep -q "$signal" "$PROMPT_MD"; then
        missing+=("$signal")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "FAIL: prompt.md missing signal definitions: ${missing[*]}"
    echo "Expected: All signals documented"
    echo "Actual: Missing: ${missing[*]}"
    exit 1
fi

echo "PASS: prompt.md contains all signal definitions"
exit 0
