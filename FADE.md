# Project Name

<!-- FADE.md - Project context for AI coding agents. This file is READ-ONLY for agents. -->

---

## Project Overview

<!--
Describe what this project does and its purpose. Include:
- What problem does it solve?
- Who are the users?
- What's the current state (MVP, production, legacy)?
-->

Brief description of this project.

**Tech Stack:**
- Language:
- Framework:
- Database:

**Repository:** [link]

---

## Coding Standards

<!--
Define how code should be written in this project. Link to external style guides
rather than duplicating them. Include project-specific conventions that differ
from or extend the standard guides.
-->

### Style Guides

- **TypeScript:** [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
- **Python:** [PEP 8](https://peps.python.org/pep-0008/)
- **API Design:** [JSON:API Specification](https://jsonapi.org/)

### Project Conventions

- Naming: `camelCase` for variables, `PascalCase` for components
- Tests: Co-locate with source files as `*.test.ts`
- Commits: Conventional commits format (`feat:`, `fix:`, `docs:`)

---

## Architecture References

<!--
Document the high-level architecture and link to detailed design docs.
Include diagrams, ADRs (Architecture Decision Records), or external references.
This helps agents understand where new code should go and how components interact.
-->

### System Overview

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client    │────▶│   API       │────▶│  Database   │
│   (React)   │     │  (Express)  │     │  (Postgres) │
└─────────────┘     └─────────────┘     └─────────────┘
```

### Key Documents

| Document | Location | Description |
|----------|----------|-------------|
| API Design | `docs/api.md` | REST endpoint specifications |
| Data Model | `docs/schema.md` | Database schema and relationships |
| Auth Flow | `docs/auth.md` | Authentication and authorization |

---

## Off-Limits Modules

<!--
List modules, files, or directories that agents should NOT modify.
Common reasons: legacy code pending rewrite, external vendor code,
security-sensitive modules requiring human review, or code with
complex implicit dependencies.
-->

| Path | Reason | Contact |
|------|--------|---------|
| `src/legacy/` | Legacy code scheduled for rewrite in Q2 | @backend-team |
| `src/auth/crypto.ts` | Security-critical, requires human review | @security |
| `vendor/` | Third-party code, do not modify | n/a |

**If you need to modify an off-limits module:** Stop and ask the human for guidance.

---

## Session Boundaries

<!--
Define constraints for AI coding sessions. This helps agents understand
what they can and cannot do, and when to ask for human input.
-->

### Allowed Actions

- Create, modify, delete files in `src/`, `tests/`, `docs/`
- Run tests and linters
- Install dev dependencies
- Create feature branches

### Requires Human Approval

- Changes to CI/CD configuration (`.github/`, `Dockerfile`)
- Database migrations
- Changes to authentication or authorization logic
- Dependency upgrades (major versions)
- Deleting more than 5 files in one session

### Never Do

- Push directly to `main` or `master`
- Modify `.env` files or commit secrets
- Run destructive database commands in production
- Disable security features or linters

---

## Additional Context

<!--
Add any other information that helps agents work effectively:
- Known gotchas or quirks
- Recent major changes
- Upcoming planned changes that affect current work
-->
