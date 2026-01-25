# Skipped: US-002 AC-01 - npx fade-cli runs the CLI without global install

**Acceptance Criterion:** "npx fade-cli runs the CLI without global install"

**Reason:** This test requires the package to be published to npm registry and network access to download it. Shell-based tests cannot verify npm registry availability or npx download behavior.

**Alternative:** Manual testing by running `npx fade-dev help` after publishing to npm. CI/CD integration tests can verify this after npm publish.
