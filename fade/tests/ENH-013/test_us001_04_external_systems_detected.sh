#!/bin/bash
# Test: External systems detected from dependencies (databases, APIs, auth providers) shown as external actors
# AC: External systems detected from dependencies (databases, APIs, auth providers) shown as external actors

# Setup - create a test project with database dependencies
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with database dependencies
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0",
  "dependencies": {
    "pg": "^8.0.0",
    "redis": "^4.0.0"
  }
}
EOF

# Act - run fade map --diagram
output=$(fade map --diagram 2>&1)

# Assert - check that external systems are detected
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check the output mentions external systems were detected
if ! echo "$output" | grep -qi "External systems detected"; then
    echo "FAIL: External systems detection not reported in output"
    echo "Expected: Output should mention external systems detected"
    echo "Actual: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that the HTML contains external system references (SystemDb, SystemQueue, System_Ext)
if ! grep -qiE "SystemDb|SystemQueue|System_Ext|Database|Redis|PostgreSQL" architecture.html; then
    echo "FAIL: No external systems found in generated diagram"
    echo "Expected: External database systems in diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: External systems detected from dependencies shown as external actors"
exit 0
