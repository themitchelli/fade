#!/bin/bash
# Test: --diagram=component generates all three levels (default)
# AC: --diagram=component generates all three levels (default)

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

mkdir -p src routes
echo "// Code" > src/index.js
echo "// Routes" > routes/api.js

# Act - run fade map with component level (or default --diagram)
output=$(fade map --diagram=component 2>&1)

# Assert
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check all three levels are confirmed
if ! echo "$output" | grep -qi "System Context.*✓"; then
    echo "FAIL: Context diagram not confirmed"
    rm -rf "$TEST_DIR"
    exit 1
fi

if ! echo "$output" | grep -qi "Container.*✓"; then
    echo "FAIL: Container diagram not confirmed"
    rm -rf "$TEST_DIR"
    exit 1
fi

if ! echo "$output" | grep -qi "Component.*✓"; then
    echo "FAIL: Component diagram not confirmed"
    echo "Expected: Component confirmation with checkmark"
    echo "Actual: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check all three sections are in HTML
if ! grep -q 'id="context"' architecture.html; then
    echo "FAIL: Context diagram section not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

if ! grep -q 'id="container"' architecture.html; then
    echo "FAIL: Container diagram section not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

if ! grep -q 'id="component"' architecture.html; then
    echo "FAIL: Component diagram section not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: --diagram=component generates all three levels"
exit 0
