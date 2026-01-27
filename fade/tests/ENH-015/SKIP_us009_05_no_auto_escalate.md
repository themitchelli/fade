# SKIP: US-009 AC-05 - No automatic escalation without user approval

## Acceptance Criteria
Do NOT automatically escalate without user approval (avoid infinite retries)

## Why Not Testable via Shell
This AC describes a behavioral constraint during runtime:
1. Requires monitoring fade-cli behavior during actual execution
2. Must verify that escalation is only suggested, not automatically applied
3. Cannot be verified without running actual sessions and monitoring user interactions

This is a UX/behavioral constraint best verified through manual testing or integration tests with user interaction simulation.
