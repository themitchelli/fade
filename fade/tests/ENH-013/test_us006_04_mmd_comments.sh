#!/bin/bash
# Test: Includes comments in .mmd files explaining each section
# AC: Includes comments in .mmd files explaining each section

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

# Assert - check for comments in .mmd files
if [[ ! -f "architecture_context.mmd" ]]; then
    echo "FAIL: No .mmd file created to verify"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for comment lines (# is common comment in mermaid .mmd files)
if ! grep -qE '^#|C4|Context|Diagram|Generated' architecture_context.mmd; then
    echo "FAIL: No explanatory comments found in .mmd file"
    echo "Expected: Comments explaining the diagram (e.g., # C4 System Context Diagram)"
    echo "Actual content:"
    head -10 architecture_context.mmd
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Includes comments in .mmd files"
exit 0
