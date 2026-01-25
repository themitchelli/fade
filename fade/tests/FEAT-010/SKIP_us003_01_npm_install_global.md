# Skipped: US-003 AC-01 - npm install -g fade-cli works

**Acceptance Criterion:** "npm install -g fade-cli works"

**Reason:** This test requires npm registry access and would modify the global npm installation. Running `npm install -g` in a test would pollute the system and require cleanup.

**Alternative:** Manual verification after npm publish:
```bash
npm install -g fade-dev
fade version
```
