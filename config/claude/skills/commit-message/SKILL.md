---
name: commit-message
description: Use when committing code changes or asked to write commit messages.
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

- DO Explain *what* and *why*, not *how*; DO NOT repeat what the diff shows
- DO pass the message directly as a string and use second `-m` for the body
- DO NOT use HEREDOC syntax or command substitution

## Atomic Commits

- One commit = one logical change; do not bundle unrelated concerns
- Multiple files are fine if they all serve the same single purpose
- Each commit must be independently revertable

## Line Length

- Subject line ≤ 72 characters (including type, scope, colon, space)
- Shorten the description if needed — never wrap the subject line
- Body lines wrap at 72 characters
