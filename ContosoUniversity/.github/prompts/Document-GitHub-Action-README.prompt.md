```prompt
---
mode: actions-readme-specialist
description: 'Generate or update README documentation for a GitHub Action (action.yml)'
---
Generate or update README documentation for a GitHub Action in this repository.

## Step 1: Identify the action
- If the user provides an `action.yml` path, use it.
- Otherwise, search the repo for `action.yml`/`action.yaml`.
- If multiple actions exist, ask which one to document.

## Step 2: Produce README
Create/update a README that includes:
- What it does / when to use it / when not to
- Quickstart (minimal working YAML)
- Inputs table (name, required, default, type, description, example)
- Outputs table (name, description, example, when set)
- Required permissions (table + `permissions:` snippet)
- Secrets and variables (`secrets`, `vars`, and `env` expectations)
- Runner requirements (OS/tools)
- Event/payload expectations (which `github.*` context fields are used)
- Examples (basic + advanced)
- Troubleshooting (likely failures)
- Security considerations (fork PRs, least privilege, OIDC if relevant)
- Versioning & releases
- Maintainer notes (where logic lives, how to build/test, how to add inputs/outputs)

## File placement
- Prefer `README.md` in the same folder as the `action.yml`.
- If an existing README already documents the action, update it in place.

## Quality bar
- Do not invent inputs/outputs/behavior; verify via action metadata and implementation.
- Use copy/paste-safe snippets.
```
