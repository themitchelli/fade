#!/bin/bash
# Test: Container diagram accessible via tab/toggle in HTML output
# AC: Container diagram accessible via tab/toggle in HTML output

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a minimal package.json
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Act - run fade map with container level diagram
fade map --diagram=container > /dev/null 2>&1

# Assert - check for Container tab in HTML
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Container tab/button element
if ! grep -qiE 'class="tab".*Container|onclick.*container|showTab.*container' architecture.html; then
    echo "FAIL: Container tab/toggle not found in HTML"
    echo "Expected: Tab or button for Container diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for container diagram container element
if ! grep -qi 'id="container"' architecture.html; then
    echo "FAIL: Container diagram section not found"
    echo "Expected: Element with id='container' for container diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Container diagram accessible via tab/toggle in HTML output"
exit 0
