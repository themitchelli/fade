#!/bin/bash
# Test: verify quick mode includes relevant standards when standards/ folder exists
# AC: If standards/ folder exists, relevant standards are included

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_helper.sh"

# Setup
FADE_CLI_PATH=$(find_fade_cli)
if [[ -z "$FADE_CLI_PATH" ]]; then
    echo "FAIL: Could not locate fade-cli script"
    exit 1
fi

# Act - extract the cmd_quick function
cmd_quick_content=$(extract_cmd_quick "$FADE_CLI_PATH")
if [[ -z "$cmd_quick_content" ]]; then
    echo "FAIL: Could not extract cmd_quick function"
    exit 1
fi

# Assert 1 - check for standards directory detection (both contained and legacy paths)
if ! echo "$cmd_quick_content" | grep -q 'fade/standards'; then
    echo "FAIL: cmd_quick doesn't check for fade/standards directory"
    exit 1
fi

if ! echo "$cmd_quick_content" | grep -qE '\-d.*standards'; then
    echo "FAIL: cmd_quick doesn't check if standards directory exists"
    exit 1
fi

# Assert 2 - check for keyword-based standard inclusion
keywords=("api" "endpoint" "git" "commit" "test" "doc")
found_keywords=0
for keyword in "${keywords[@]}"; do
    if echo "$cmd_quick_content" | grep -qi "$keyword"; then
        ((found_keywords++))
    fi
done

if [[ $found_keywords -lt 3 ]]; then
    echo "FAIL: cmd_quick doesn't include keyword-based standard selection"
    echo "Expected: keyword matching for relevant standards"
    exit 1
fi

# Assert 3 - check that standards content is included in context
if ! echo "$cmd_quick_content" | grep -q 'Relevant Standards'; then
    echo "FAIL: Standards not labeled appropriately in context"
    echo "Expected: 'Relevant Standards' section"
    exit 1
fi

# Assert 4 - verify specific standards files are checked
standards_files=("api-security.md" "git.md" "testing.md" "coding.md" "documentation.md")
found_files=0
for std_file in "${standards_files[@]}"; do
    if echo "$cmd_quick_content" | grep -q "$std_file"; then
        ((found_files++))
    fi
done

if [[ $found_files -lt 3 ]]; then
    echo "FAIL: cmd_quick doesn't check for common standard files"
    echo "Expected: checks for api-security.md, git.md, testing.md, etc."
    echo "Found: $found_files standard file references"
    exit 1
fi

echo "PASS: relevant standards are included in quick mode context"
exit 0
