---
name: git-commit
description: Create a conventional-commit git commit - stage the right files, derive type/scope from the diff, and write the message. Use when the user asks to commit changes or mentions "/commit".
allowed-tools: Bash
---

# Git Commit

## Workflow

1. Read the diff: `git diff --staged` if anything is staged, otherwise `git diff`.
2. Stage what belongs in one logical change (`git add <paths>`). Never stage secrets (.env, credentials, keys).
3. Commit: `git commit -m "<type>(<scope>): <description>"`, adding `-m "<body>"` for extra paragraphs.
4. If a hook rejects the commit, fix the issue and make a new commit rather than amending.

## Message rules

Conventional commit format: `<type>(<scope>): <description>` — scope optional.

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

- Description: imperative present tense ("add", not "added"/"adds"), under 72 chars.
- Breaking change: `feat!: ...` and a `BREAKING CHANGE: <what changed>` body paragraph.
- Reference issues in the body: `Closes #123`.
