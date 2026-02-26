---
name: commit-message
description: Use when commit code to follow conventions.
model: sonnet
---

## Format

Follows [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

```
<type>(<scope>): <description>

[optional body]
```

**Types:** `feat` | `fix` | `docs` | `style` | `refactor` | `perf` | `test` | `build` | `chore` | `ci` | `revert`

- **Scope**: optional short noun for the area changed (`auth`, `nvim`, `fish`)
- **Description**: imperative mood, lowercase, no trailing period

## Body

- Separate from subject with a blank line
- Explain *what* and *why*, not *how*; do not repeat what the diff shows
- Example: "Previously X caused Y. Now it does Z instead."

## Atomic Commits

- One commit = one logical change; do not bundle unrelated concerns
- Multiple files are fine if they all serve the same single purpose
- Each commit must be independently revertable

## Line Length

- Subject line ≤ 72 characters (including type, scope, colon, space)
- Shorten the description if needed — never wrap the subject line
- Body lines wrap at 72 characters
