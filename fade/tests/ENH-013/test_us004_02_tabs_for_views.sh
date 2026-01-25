#!/bin/bash
# Test: Tabs or buttons to switch between Context, Container, and Component views
# AC: Tabs or buttons to switch between Context, Container, and Component views

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

mkdir -p src
echo "// Code" > src/index.js

# Act - run fade map with all diagram levels
fade map --diagram=component > /dev/null 2>&1

# Assert - check for tab structure
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for tabs class (tab buttons)
if ! grep -q 'class="tabs"' architecture.html; then
    echo "FAIL: Tabs container not found"
    echo "Expected: Element with class='tabs'"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Context tab
if ! grep -qi 'System Context\|context' architecture.html; then
    echo "FAIL: System Context tab/view not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Container tab
if ! grep -qi 'Container' architecture.html; then
    echo "FAIL: Container tab/view not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Component tab
if ! grep -qi 'Component' architecture.html; then
    echo "FAIL: Component tab/view not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for showTab function (tab switching logic)
if ! grep -q 'showTab' architecture.html; then
    echo "FAIL: Tab switching function not found"
    echo "Expected: showTab() function for view switching"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Tabs or buttons to switch between views"
exit 0
