# SKIP: US-006 AC-05 - Update architecture.md with model routing decision tree

## Acceptance Criteria
Update fade/docs/architecture.md with model routing decision tree

## Reason for Skipping
This is a documentation requirement. The presence of a "decision tree" in documentation is subjective - it could be text, ASCII art, a diagram reference, or a code snippet. Automated tests cannot verify documentation quality.

## Manual Verification
1. Open fade/docs/architecture.md
2. Verify there is a section about model routing
3. Verify the routing logic is clearly explained (complexity -> model mapping, override precedence)
