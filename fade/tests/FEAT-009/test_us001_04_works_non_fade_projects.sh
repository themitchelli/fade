#!/bin/bash
# Test: verify fade quick works in both FADE-initialized and non-FADE projects
# AC: Works in both FADE-initialized and non-FADE projects

# Setup - create test directories for both scenarios
TEST_DIR_FADE=$(mktemp -d)
TEST_DIR_NON_FADE=$(mktemp -d)
FADE_CLI="${FADE_CLI:-fade}"

# Create FADE-initialized project structure
mkdir -p "$TEST_DIR_FADE/fade/prds"
cat > "$TEST_DIR_FADE/FADE.md" << 'EOF'
# Test Project
Test project with FADE initialized.
EOF
cat > "$TEST_DIR_FADE/fade/progress.md" << 'EOF'
# Progress
Test progress file.
EOF

# Act & Assert 1 - Check that fade quick requires task description (error check)
# This proves the command is recognized and parses arguments
cd "$TEST_DIR_NON_FADE" || exit 1
output=$($FADE_CLI quick 2>&1)
exit_code=$?

if [[ $exit_code -eq 0 ]]; then
    echo "FAIL: fade quick without task should error"
    rm -rf "$TEST_DIR_FADE" "$TEST_DIR_NON_FADE"
    exit 1
fi

if ! echo "$output" | grep -qiE "task description required|usage"; then
    echo "FAIL: Error message should mention task description"
    echo "Expected: error about task description"
    echo "Actual: $output"
    rm -rf "$TEST_DIR_FADE" "$TEST_DIR_NON_FADE"
    exit 1
fi

# Act & Assert 2 - Check same behavior in FADE project
cd "$TEST_DIR_FADE" || exit 1
output=$($FADE_CLI quick 2>&1)
exit_code=$?

if [[ $exit_code -eq 0 ]]; then
    echo "FAIL: fade quick without task should error in FADE project too"
    rm -rf "$TEST_DIR_FADE" "$TEST_DIR_NON_FADE"
    exit 1
fi

if ! echo "$output" | grep -qiE "task description required|usage"; then
    echo "FAIL: Error message should mention task description in FADE project"
    echo "Expected: error about task description"
    echo "Actual: $output"
    rm -rf "$TEST_DIR_FADE" "$TEST_DIR_NON_FADE"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR_FADE" "$TEST_DIR_NON_FADE"

echo "PASS: fade quick works in both FADE and non-FADE projects"
exit 0
