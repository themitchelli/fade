#!/bin/bash
# Test: verify sections contain questions to consider, not checklists
# AC: Each section contains questions to consider, not checklists to fill

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/standards/architecture.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: architecture.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Check that file contains question marks (indicating questions)
QUESTION_COUNT=$(echo "$CONTENT" | grep -c "?")

if [[ $QUESTION_COUNT -lt 6 ]]; then
    echo "FAIL: Not enough questions in the document"
    echo "Expected: At least 6 questions (one per section minimum)"
    echo "Actual: $QUESTION_COUNT questions found"
    exit 1
fi

# Check for "Consider:" pattern which introduces questions
if ! echo "$CONTENT" | grep -q "Consider:"; then
    echo "FAIL: Missing 'Consider:' pattern that introduces questions"
    echo "Expected: Sections to have 'Consider:' followed by questions"
    echo "Actual: Pattern not found"
    exit 1
fi

# Negative check: should NOT have checkbox patterns like [ ] or [x]
if echo "$CONTENT" | grep -qE '\[ \]|\[x\]|\[X\]'; then
    echo "FAIL: Document contains checkbox patterns (should be questions, not checklists)"
    echo "Expected: Questions to consider"
    echo "Actual: Found checkbox patterns"
    exit 1
fi

echo "PASS: Sections contain questions, not checklists"
exit 0
