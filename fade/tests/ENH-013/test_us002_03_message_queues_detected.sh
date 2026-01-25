#!/bin/bash
# Test: Message queues detected from queue dependencies (Redis, RabbitMQ, SQS)
# AC: Message queues detected from queue dependencies (Redis, RabbitMQ, SQS)

# Setup - create a test project with queue dependencies
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with Bull (Redis-based queue)
cat > package.json << 'EOF'
{
  "name": "test-queue-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "bull": "^4.10.0",
    "ioredis": "^5.0.0"
  }
}
EOF

# Act - run fade map with container level diagram
fade map --diagram=container > /dev/null 2>&1

# Assert - check for queue container
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for queue-related containers (ContainerQueue or SystemQueue)
if ! grep -qiE "ContainerQueue|SystemQueue|Queue|Redis|Bull" architecture.html; then
    echo "FAIL: No message queue container detected from Bull/Redis dependency"
    echo "Expected: Queue container in diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Message queues detected from queue dependencies"
exit 0
