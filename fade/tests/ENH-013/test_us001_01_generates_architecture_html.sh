#!/bin/bash
# Test: fade map --diagram generates architecture.html in project root
# AC: fade map --diagram generates architecture.html in project root

# Setup - create a minimal test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a minimal package.json so fade map can detect it as a project
cat > package.json << 'EOF'
{
  "name": "test-project",
  "version": "1.0.0"
}
EOF

# Act - run fade map --diagram
output=$(fade map --diagram 2>&1)
exit_code=$?

# Assert - check if architecture.html was created
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created in project root"
    echo "Expected: architecture.html file exists"
    echo "Actual: file not found"
    echo "Command output: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade map --diagram generates architecture.html in project root"
exit 0
