#!/bin/bash
# Test: verify documentation includes examples of correct usage
# AC: Include examples of correct usage

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORTABILITY_DOC="$FADE_ROOT/fade/standards/shell-portability.md"

# Assert: includes code blocks with examples
if ! grep -q '```' "$PORTABILITY_DOC"; then
    echo "FAIL: Document should include code block examples"
    echo "Expected: '\`\`\`' code blocks in documentation"
    echo "Actual: not found"
    exit 1
fi

# Assert: includes bash examples
if ! grep -q '```bash' "$PORTABILITY_DOC"; then
    echo "FAIL: Document should include bash code examples"
    echo "Expected: '\`\`\`bash' code blocks"
    echo "Actual: not found"
    exit 1
fi

# Assert: has Good/Bad examples or similar pattern
if ! grep -qE "(Good|Bad|Correct|Incorrect|Portable|works)" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should show correct vs incorrect examples"
    echo "Expected: Good/Bad or similar comparison"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Examples of correct usage are included"
exit 0
