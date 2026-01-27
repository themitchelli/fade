#!/bin/bash
# Test: verify fade-cli has escalation messaging
# AC: When escalation detected, output: 'ESCALATE: Initial model (Sonnet) seems insufficient. Try with --model opus'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for escalation messaging in CLI
if ! grep -q 'ESCALATE\|escalat\|insufficient' "$CLI_FILE"; then
    echo "FAIL: fade-cli should have escalation messaging"
    exit 1
fi

echo "PASS: fade-cli has escalation messaging"
exit 0
