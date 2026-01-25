#!/bin/bash
# Test: Relationships labeled with interaction type (uses, reads, writes)
# AC: Relationships labeled with interaction type (uses, reads, writes)

# Setup - create a test project with dependencies
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with database dependency
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "pg": "^8.0.0"
  }
}
EOF

# Act - run fade map --diagram
fade map --diagram > /dev/null 2>&1

# Assert - check for relationship labels in the diagram
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Rel() function calls in Mermaid (C4 relationship syntax)
# Rel(source, target, "label")
if ! grep -qiE "Rel\(|Rel_\(" architecture.html; then
    echo "FAIL: No relationship definitions found in diagram"
    echo "Expected: Rel() or Rel_*() function calls for relationships"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that relationship labels exist (uses, reads, writes, etc.)
if ! grep -qiE "uses|reads|writes|sends|receives|calls" architecture.html; then
    echo "FAIL: Relationship labels not found"
    echo "Expected: Relationship labels like 'uses', 'reads', 'writes'"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Relationships labeled with interaction type"
exit 0
