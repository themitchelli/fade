#!/bin/bash
# Test: Verify generate_tests_for_completed_prds uses stderr redirect block
# AC: Redirect ALL display output to stderr in the test generation flow

FADE_CLI="bin/fade-cli"

# Check that the function has } >&2 pattern (closing brace with stderr redirect)
if ! grep -q '} >&2' "$FADE_CLI"; then
    echo "FAIL: Missing } >&2 pattern in fade-cli"
    exit 1
fi

# Check it's in the generate_tests_for_completed_prds function
func_content=$(sed -n '/^generate_tests_for_completed_prds()/,/^[a-z_]*() {/p' "$FADE_CLI")
if ! echo "$func_content" | grep -q '} >&2'; then
    echo "FAIL: } >&2 pattern is not in generate_tests_for_completed_prds function"
    exit 1
fi

echo "PASS: generate_tests_for_completed_prds wraps body in stderr redirect block"
exit 0
