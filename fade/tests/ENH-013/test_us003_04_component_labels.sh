#!/bin/bash
# Test: Each component labeled with its responsibility based on directory/file naming
# AC: Each component labeled with its responsibility based on directory/file naming

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-labeled-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Create directory structure with meaningful names
mkdir -p routes services
echo "// User routes" > routes/users.js
echo "// Auth service" > services/auth.js

# Act - run fade map with component level diagram
fade map --diagram=component > /dev/null 2>&1

# Assert - check for meaningful component labels
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that component labels contain directory/responsibility names
# Should find references to "route" "service" or similar responsibility labels
if ! grep -qiE "Route|Service|Controller|Model|Handler|API|Endpoint" architecture.html; then
    echo "FAIL: Component responsibility labels not found in diagram"
    echo "Expected: Labels based on directory naming (routes, services, etc.)"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Components labeled with responsibility based on directory naming"
exit 0
