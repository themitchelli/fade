#!/bin/bash
# Test: Technology labels included (Node.js, PostgreSQL, Redis, etc.)
# AC: Technology labels included (Node.js, PostgreSQL, Redis, etc.)

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with express
cat > package.json << 'EOF'
{
  "name": "test-tech-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "pg": "^8.0.0"
  }
}
EOF

# Act - run fade map with container level diagram
fade map --diagram=container > /dev/null 2>&1

# Assert - check for technology labels
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for technology labels in the diagram (Node.js, PostgreSQL, JavaScript, etc.)
if ! grep -qiE "Node\.js|JavaScript|TypeScript|PostgreSQL|Express" architecture.html; then
    echo "FAIL: Technology labels not found in diagram"
    echo "Expected: Technology labels like Node.js, PostgreSQL, or Express"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Technology labels included in diagram"
exit 0
