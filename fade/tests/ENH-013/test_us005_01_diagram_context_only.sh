#!/bin/bash
# Test: --diagram=context generates only System Context diagram
# AC: --diagram=context generates only System Context diagram

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

# Act - run fade map with context level only
output=$(fade map --diagram=context 2>&1)

# Assert - check output mentions only context level
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that output confirms Context is included
if ! echo "$output" | grep -qi "System Context.*✓\|Context:.*✓"; then
    echo "FAIL: Context diagram not confirmed in output"
    echo "Expected: System Context confirmation"
    echo "Actual: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that Container tab is NOT present in HTML (context only)
if grep -q 'id="container"' architecture.html; then
    echo "FAIL: Container diagram present when only context requested"
    echo "Expected: Only context diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: --diagram=context generates only System Context diagram"
exit 0
