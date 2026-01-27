# SKIP: US-008 AC-08 - Click on model accuracy shows breakdown

## Acceptance Criteria
Click on model accuracy → see breakdown: 'Haiku: 12 succeeded, 0 escalated, 0 wasted, accuracy 100%'

## Why Not Testable via Shell
This AC describes interactive UI behavior in the web dashboard:
1. Requires a running dashboard server
2. Requires a web browser or HTTP client to interact with UI
3. Tests click behavior and dynamic content loading
4. JavaScript/frontend functionality cannot be tested with shell scripts

This is a UI/UX feature that should be tested with browser automation tools (e.g., Cypress, Playwright) or manual testing.
