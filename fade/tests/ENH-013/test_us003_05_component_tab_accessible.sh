#!/bin/bash
# Test: Component diagram accessible via tab/toggle in HTML output
# AC: Component diagram accessible via tab/toggle in HTML output

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Create minimal structure for component detection
mkdir -p src
echo "// App code" > src/index.js

# Act - run fade map with full component level diagram (default)
fade map --diagram=component > /dev/null 2>&1

# Assert - check for Component tab in HTML
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Component tab/button element
if ! grep -qiE 'class="tab".*Component|onclick.*component|showTab.*component' architecture.html; then
    echo "FAIL: Component tab/toggle not found in HTML"
    echo "Expected: Tab or button for Component diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for component diagram container element
if ! grep -qi 'id="component"' architecture.html; then
    echo "FAIL: Component diagram section not found"
    echo "Expected: Element with id='component' for component diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Component diagram accessible via tab/toggle in HTML output"
exit 0
