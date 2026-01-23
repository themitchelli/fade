#!/bin/bash
# Test: verify architecture.md is under 1500 tokens
# AC: Under 1,500 tokens to fit standards budget

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/standards/architecture.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: architecture.md does not exist"
    exit 1
fi

# Approximate token count: ~4 characters per token is a reasonable estimate
# 1500 tokens * 4 chars = 6000 characters max
# Being conservative, use word count as proxy (roughly 0.75 tokens per word)
# 1500 tokens / 0.75 = ~2000 words max

CHAR_COUNT=$(wc -c < "$FILE" | tr -d ' ')
WORD_COUNT=$(wc -w < "$FILE" | tr -d ' ')

# Use character count as primary check (6000 chars ~ 1500 tokens)
MAX_CHARS=6000

if [[ $CHAR_COUNT -gt $MAX_CHARS ]]; then
    echo "FAIL: architecture.md exceeds token budget"
    echo "Expected: Under ~1500 tokens (~6000 characters)"
    echo "Actual: $CHAR_COUNT characters ($WORD_COUNT words)"
    exit 1
fi

echo "PASS: architecture.md within token budget ($CHAR_COUNT chars, ~$((CHAR_COUNT / 4)) tokens estimated)"
exit 0
