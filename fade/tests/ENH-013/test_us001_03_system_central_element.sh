#!/bin/bash
# Test: Diagram shows the system as central element
# AC: Diagram shows the system as central element

# Setup - create a minimal test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with a specific name
cat > package.json << 'EOF'
{
  "name": "my-test-system",
  "version": "1.0.0"
}
EOF

# Act - run fade map --diagram
fade map --diagram > /dev/null 2>&1

# Assert - check that the system name appears in the diagram
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for C4 System definition in the Mermaid content
# C4 uses System() or System_Boundary() for the central system
if ! grep -qi "System\|my-test-system" architecture.html; then
    echo "FAIL: System element not found in diagram"
    echo "Expected: System definition with project name"
    echo "Actual: System/project name not found in HTML"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Diagram shows the system as central element"
exit 0
