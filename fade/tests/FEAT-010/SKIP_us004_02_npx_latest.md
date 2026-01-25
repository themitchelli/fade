# Skipped: US-004 AC-02 - npx fade-cli@latest always runs latest version

**Acceptance Criterion:** "npx fade-cli@latest always runs latest version"

**Reason:** Verifying @latest tag behavior requires npm registry access and network connectivity. The behavior is guaranteed by npm/npx semantics when using the @latest tag.

**Alternative:** Manual verification:
```bash
npx fade-dev@latest version
```
The @latest tag is a standard npm feature that always fetches the most recent published version.
