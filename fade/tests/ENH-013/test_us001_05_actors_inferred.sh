#!/bin/bash
# Test: Users/actors inferred from framework type (web app, CLI, API server)
# AC: Users/actors inferred from framework type (web app, CLI, API server)

# Setup - create a test project with a web framework
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with Express (web framework)
cat > package.json << 'EOF'
{
  "name": "test-web-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Act - run fade map --diagram
output=$(fade map --diagram 2>&1)

# Assert - check that actors are detected
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that actors are detected and mentioned in output
if ! echo "$output" | grep -qi "Actors detected"; then
    echo "FAIL: Actor detection not reported in output"
    echo "Expected: Output should mention actors detected"
    echo "Actual: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Person() in the Mermaid C4 diagram (actors are represented as Person in C4)
if ! grep -qi "Person\|User\|Actor" architecture.html; then
    echo "FAIL: No actors/users found in generated diagram"
    echo "Expected: Person/User/Actor element in diagram for web app"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Users/actors inferred from framework type"
exit 0
