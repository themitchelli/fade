#!/bin/bash
# Test: Export to PNG button using Mermaid's built-in export
# AC: Export to PNG button using Mermaid's built-in export

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

# Act - run fade map --diagram
fade map --diagram > /dev/null 2>&1

# Assert - check for PNG export button
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for export PNG button or function
if ! grep -qi 'exportPNG\|Export PNG\|export.*png\|PNG' architecture.html; then
    echo "FAIL: PNG export button/function not found"
    echo "Expected: exportPNG() function or 'Export PNG' button text"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for button element that exports
if ! grep -qiE 'onclick.*export\|button.*Export' architecture.html; then
    echo "FAIL: Export button element not found"
    echo "Expected: Button with onclick handler for export"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Export to PNG button"
exit 0
