#!/bin/bash
# Test: Components detected from directory structure (routes/, controllers/, services/, models/)
# AC: Components detected from directory structure (routes/, controllers/, services/, models/)

# Setup - create a test project with typical directory structure
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-component-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Create typical directory structure
mkdir -p routes controllers services models
echo "// User routes" > routes/users.js
echo "// Auth controller" > controllers/auth.js
echo "// User service" > services/userService.js
echo "// User model" > models/User.js

# Act - run fade map with component level diagram
fade map --diagram=component > /dev/null 2>&1

# Assert - check for component definitions
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Component() definitions in C4 Mermaid syntax
if ! grep -qiE "Component\(" architecture.html; then
    echo "FAIL: No component definitions found in diagram"
    echo "Expected: Component() in Mermaid C4"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Components detected from directory structure"
exit 0
