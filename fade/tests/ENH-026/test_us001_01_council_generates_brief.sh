#!/bin/bash
# Test: verify fade council <prd_id> generates a council brief
# AC: Command `fade council <prd_id>` generates a 'council brief' (context + question + constraints) from repo context, FADE.md, and the PRD.

# Setup - create a temporary test directory with required FADE structure
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

# Create minimal FADE structure
mkdir -p fade/prds
cat > FADE.md << 'EOF'
# Test Project
This is a test project for council brief generation.
EOF

cat > fade/prds/TEST-001-sample-prd.json << 'EOF'
{
  "type": "feature",
  "id": "TEST-001",
  "name": "Sample PRD for testing",
  "description": "A test PRD to verify council brief generation.",
  "userStories": []
}
EOF

# Act - run fade council command
# Capture output to check for success message
output=$(fade council TEST-001 2>&1)
exit_code=$?

# Assert - command succeeded
if [[ $exit_code -ne 0 ]]; then
    echo "FAIL: fade council command failed with exit code $exit_code"
    echo "Expected: exit code 0"
    echo "Actual: exit code $exit_code"
    echo "Output: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - output confirms brief was generated
if ! echo "$output" | grep -q "Council brief generated"; then
    echo "FAIL: Expected success message 'Council brief generated'"
    echo "Expected: output contains 'Council brief generated'"
    echo "Actual: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - a council brief file was created
if ! ls fade/council/*.md >/dev/null 2>&1; then
    echo "FAIL: Expected council brief file in fade/council/"
    echo "Expected: fade/council/*.md file exists"
    echo "Actual: no .md files found in fade/council/"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - brief contains expected sections (context + question + constraints)
brief_file=$(ls fade/council/*.md | head -1)
brief_content=$(cat "$brief_file")

if ! echo "$brief_content" | grep -q "## Project Context"; then
    echo "FAIL: Council brief missing '## Project Context' section"
    echo "Expected: brief contains '## Project Context'"
    echo "Actual: section not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

if ! echo "$brief_content" | grep -q "## Council Request"; then
    echo "FAIL: Council brief missing '## Council Request' section"
    echo "Expected: brief contains '## Council Request'"
    echo "Actual: section not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade council generates council brief with context and questions"
exit 0
