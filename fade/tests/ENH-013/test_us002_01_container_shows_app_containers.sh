#!/bin/bash
# Test: Container diagram shows application containers (web app, API, workers, etc.)
# AC: Container diagram shows application containers (web app, API, workers, etc.)

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with express (web/API)
cat > package.json << 'EOF'
{
  "name": "test-api-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Act - run fade map with container level diagram
fade map --diagram=container > /dev/null 2>&1

# Assert - check for container definitions
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Container() definitions in C4 Mermaid syntax
if ! grep -qiE "Container\(|Container_Boundary" architecture.html; then
    echo "FAIL: No container definitions found in diagram"
    echo "Expected: Container() or Container_Boundary() in Mermaid C4"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Container diagram shows application containers"
exit 0
