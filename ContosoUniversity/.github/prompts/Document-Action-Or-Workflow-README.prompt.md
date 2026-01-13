```prompt
---
mode: actions-readme-specialist
description: 'Generate or update a README for a GitHub Action or reusable workflow (beginner-friendly + maintainer notes)'
---
Write (or update) README documentation for the GitHub Action or reusable workflow in this repository.

## What to document
- If the user provides a path, use that.
- Otherwise, auto-discover:
  - `action.yml` / `action.yaml` (GitHub Action)
  - `.github/workflows/*.yml` with `on: workflow_call` (reusable workflow)

If you find more than one candidate, ask which one to document.

## Output requirements
- The README must be beginner-friendly (copy/paste Quickstart) and also helpful for maintainers returning months later.
- Ground everything in the repository’s implementation (don’t guess inputs/outputs/behavior).
- Cover:
  - inputs/outputs (tables)
  - permissions (least-privilege guidance + snippet)
  - secrets/vars/env
  - runner/environment requirements
  - triggers & payload expectations (workflow triggers OR action’s `github.*` context expectations)
  - examples (at least 2)
  - troubleshooting (at least 3 likely failures)
  - versioning/release notes
  - maintainer/development notes

## Where to write
- Prefer creating/updating a `README.md` in the same directory as the `action.yml` (or next to the reusable workflow) unless the repo already has a clear convention.

## Clarifying questions (only if needed)
Ask only what you cannot determine from the repo, such as:
- the intended “primary use case” and any non-obvious constraints
- whether the action/workflow is meant for public use or internal use
- versioning/release tagging expectations (if not obvious)
```
