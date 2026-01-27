# Skipped: US-001 AC-03 - Provider configuration for multi-model responses

**Acceptance Criterion:** "If additional providers are configured, FADE can request and store their responses; if not, FADE stores the brief for manual paste into web tools."

**Reason:** This acceptance criterion has two parts:
1. When providers are NOT configured: The brief is stored for manual paste - this is the default behavior and is covered by tests 01 and 02.
2. When providers ARE configured: Requesting and storing responses from external LLM providers requires API keys, network access, and external service availability.

Testing external provider integrations via shell scripts is not feasible because:
- Requires valid API credentials for OpenAI, Google, etc.
- Involves network calls to external services
- Service responses vary and can't be deterministically tested
- Would incur API costs on each test run

**Alternative:**
- Manual testing when adding new providers
- Integration tests in a separate test suite with mocked API responses
- The "manual paste" fallback path is tested by verifying the brief is created with proper formatting
