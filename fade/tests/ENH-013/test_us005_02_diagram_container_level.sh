#!/bin/bash
# Test: --diagram=container generates Context + Container diagrams
# AC: --diagram=container generates Context + Container diagrams

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

# Act - run fade map with container level
output=$(fade map --diagram=container 2>&1)

# Assert
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that Context is included
if ! echo "$output" | grep -qi "System Context.*✓\|Context:.*✓"; then
    echo "FAIL: Context diagram not confirmed in output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that Container is included
if ! echo "$output" | grep -qi "Container.*✓"; then
    echo "FAIL: Container diagram not confirmed in output"
    echo "Expected: Container confirmation with checkmark"
    echo "Actual: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that Container section is in HTML
if ! grep -q 'id="container"' architecture.html; then
    echo "FAIL: Container diagram section not found in HTML"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that Component is NOT fully included (should show as optional)
if grep -q 'id="component"' architecture.html; then
    echo "FAIL: Component diagram present when only container level requested"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: --diagram=container generates Context + Container diagrams"
exit 0
