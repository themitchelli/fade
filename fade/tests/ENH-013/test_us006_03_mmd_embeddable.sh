#!/bin/bash
# Test: Files can be embedded in README.md or other markdown docs
# AC: Files can be embedded in README.md or other markdown docs

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0"
}
EOF

# Act - run fade map with mermaid format
fade map --diagram --diagram-format=mermaid > /dev/null 2>&1

# Assert - check .mmd file contains markdown-embeddable mermaid block
if [[ ! -f "architecture_context.mmd" ]]; then
    echo "FAIL: No .mmd file created to verify"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for mermaid code block markers (```mermaid)
if ! grep -q '```mermaid' architecture_context.mmd; then
    echo "FAIL: Mermaid code fence not found in .mmd file"
    echo "Expected: \`\`\`mermaid block for markdown embedding"
    echo "Actual content:"
    head -10 architecture_context.mmd
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for closing fence
if ! grep -q '```$' architecture_context.mmd; then
    echo "FAIL: Closing code fence not found in .mmd file"
    echo "Expected: Closing \`\`\` for markdown embedding"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Files can be embedded in markdown docs"
exit 0
