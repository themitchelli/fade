# SKIP: US-004 AC-05 - All tests should use shell scripting only

## Acceptance Criterion
"All tests should use shell scripting only (no external dependencies)"

## Why Not Testable as Automated Test
This is a constraint/requirement about how tests are written, not a testable behavior.
It would be self-referential to write a test that verifies it uses only shell scripting.

## Manual Verification
Review all test files in fade/tests/BUG-007/ to verify they:
- Use only bash/sh built-in commands
- Do not require external tools beyond standard Unix utilities (grep, etc.)
- Can run without installing any dependencies
- Start with #!/bin/bash shebang
