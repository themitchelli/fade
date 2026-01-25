# Skipped: US-004 AC-01 - npm update -g fade-cli updates to latest version

**Acceptance Criterion:** "npm update -g fade-cli updates to latest version"

**Reason:** Testing npm update requires the package to be published to npm registry, and would require multiple versions to be published to verify update behavior. This is integration testing that cannot be done with shell scripts alone.

**Alternative:** Manual verification after publishing a new version:
```bash
npm install -g fade-dev@0.3.0  # Install older version
npm update -g fade-dev          # Update to latest
fade version                    # Should show new version
```
