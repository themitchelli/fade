#!/bin/bash
# Test: verify Autonomous Execution Contract section is near the top of prompt.md
# AC: Ensure wording is unambiguous and placed near the top of prompt.md so it is always in context.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for Autonomous Execution Contract section
if ! grep -q "## Autonomous Execution Contract" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not have 'Autonomous Execution Contract' section"
    echo "Expected: Section titled '## Autonomous Execution Contract'"
    echo "Actual: Section not found"
    exit 1
fi

# Check the section appears within the first 50 lines (near top)
line_num=$(grep -n "## Autonomous Execution Contract" "$PROMPT_FILE" | head -1 | cut -d: -f1)

if [[ -z "$line_num" ]]; then
    echo "FAIL: Could not determine line number of Autonomous Execution Contract"
    exit 1
fi

if [[ "$line_num" -gt 50 ]]; then
    echo "FAIL: Autonomous Execution Contract section is not near the top"
    echo "Expected: Within first 50 lines"
    echo "Actual: Found at line $line_num"
    exit 1
fi

echo "PASS: Autonomous Execution Contract section exists and is near the top (line $line_num)"
exit 0
