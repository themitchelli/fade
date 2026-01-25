#!/bin/bash
# Test: External service integrations shown as external containers
# AC: External service integrations shown as external containers

# Setup - create a test project with external service dependencies
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with AWS SDK (external service)
cat > package.json << 'EOF'
{
  "name": "test-external-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "@aws-sdk/client-s3": "^3.0.0"
  }
}
EOF

# Act - run fade map with container level diagram
fade map --diagram=container > /dev/null 2>&1

# Assert - check for external service container
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for external system/container references (System_Ext, Container_Ext, or AWS/S3)
if ! grep -qiE "System_Ext|Container_Ext|AWS|S3|Storage|External" architecture.html; then
    echo "FAIL: No external service detected from AWS SDK dependency"
    echo "Expected: External service container in diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: External service integrations shown as external containers"
exit 0
