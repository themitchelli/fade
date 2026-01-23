#!/bin/bash
# Test: Display banners still visible to user during test generation
# AC: Display banners still visible to user during test generation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract run_test_generation function body
func_body=$(sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that display banners exist (the decorative lines)
if ! echo "$func_body" | grep -q '═══'; then
    echo "FAIL: run_test_generation has no decorative banner lines"
    echo "Expected: Banner lines with ═══"
    exit 1
fi

# Check that banners go to stderr (so they're visible to user)
if ! echo "$func_body" | grep '═══' | grep -q '>&2'; then
    echo "FAIL: Banner lines not redirected to stderr"
    echo "Expected: Banners use >&2 so they're visible to user"
    exit 1
fi

# Check for "Generating Regression Tests" message
if ! echo "$func_body" | grep -q 'Generating.*Tests'; then
    echo "FAIL: Missing 'Generating Tests' banner message"
    exit 1
fi

# Check that tee outputs to stderr for real-time visibility
if ! echo "$func_body" | grep -q 'tee.*>&2'; then
    echo "FAIL: Claude output not teed to stderr"
    echo "Expected: tee ... >&2 for real-time visibility"
    exit 1
fi

echo "PASS: Display banners are visible to user via stderr"
exit 0
