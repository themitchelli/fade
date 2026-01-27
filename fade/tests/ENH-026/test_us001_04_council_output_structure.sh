#!/bin/bash
# Test: verify council output includes required sections
# AC: Council output includes: recommended approach, alternative approaches, key risks, and 'what to watch for' during implementation.

# Setup - create a temporary test directory with required FADE structure
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

# Create minimal FADE structure
mkdir -p fade/prds
cat > FADE.md << 'EOF'
# Test Project
Test project context for council brief structure verification.
EOF

cat > fade/prds/TEST-004-structure-test.json << 'EOF'
{
  "type": "feature",
  "id": "TEST-004",
  "name": "Structure test PRD",
  "description": "Testing council brief output structure.",
  "userStories": []
}
EOF

# Act - run fade council command
fade council TEST-004 >/dev/null 2>&1

# Get the generated brief content
brief_file=$(ls fade/council/*.md 2>/dev/null | head -1)
if [[ -z "$brief_file" ]]; then
    echo "FAIL: Council brief file not created"
    echo "Expected: fade/council/*.md file exists"
    echo "Actual: no brief file found"
    rm -rf "$TEST_DIR"
    exit 1
fi

brief_content=$(cat "$brief_file")

# Assert - brief includes "Recommended Approach" section
if ! echo "$brief_content" | grep -qi "Recommended Approach"; then
    echo "FAIL: Council brief missing 'Recommended Approach' section"
    echo "Expected: brief contains 'Recommended Approach'"
    echo "Actual: section not found in brief"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - brief includes "Alternative Approaches" section
if ! echo "$brief_content" | grep -qi "Alternative Approaches"; then
    echo "FAIL: Council brief missing 'Alternative Approaches' section"
    echo "Expected: brief contains 'Alternative Approaches'"
    echo "Actual: section not found in brief"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - brief includes "Key Risks" section
if ! echo "$brief_content" | grep -qi "Key Risks"; then
    echo "FAIL: Council brief missing 'Key Risks' section"
    echo "Expected: brief contains 'Key Risks'"
    echo "Actual: section not found in brief"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - brief includes "What to Watch For" section
if ! echo "$brief_content" | grep -qi "What to Watch For"; then
    echo "FAIL: Council brief missing 'What to Watch For' section"
    echo "Expected: brief contains 'What to Watch For'"
    echo "Actual: section not found in brief"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Council brief includes all required sections (recommended approach, alternatives, risks, watch for)"
exit 0
