# SKIP: US-002 AC-07 - fade new suggests complexity

## Acceptance Criteria
fade new suggests complexity: 'Suggested complexity: complex (15 ACs, contains "architecture")'

## Reason for Skipping
This acceptance criterion requires interactive user input. The `fade new` command without --complexity flag prompts the user for input, which cannot be reliably automated in shell tests.

The implementation displays "Suggested complexity: [value]" at bin/fade-cli:4902-4906, but the subsequent read prompt blocks automated testing.

## Manual Test Steps
1. Run `fade new feature "Architecture refactor"`
2. Verify output shows "Suggested complexity: complex" with reasoning
3. Verify you can accept or override the suggestion
