---
name: git-pr
description: 'Create a focused, why-first pull request via the GitHub CLI: conventional-commit title, repo-template-aware description, draft/ready detection, and push + gh pr create. Use when the user asks to open a PR or create a pull request'
allowed-tools: Bash
---

# Create Pull Request

## Overview

Create a focused, reviewable pull request, scoped like a commit: one logical change, explained so a reviewer understands **why** before they read **what**.

## Rules

- Single logical change; split unrelated changes into separate PRs
- Title in conventional commit format (same types as commits, see below)
- Description leads with **why**, not a restatement of the diff
- Document decisions made and problems encountered, so reviewers don't re-litigate them
- Include benchmarks when the PR is a performance improvement
- Mark as draft if the work is incomplete or not yet ready for review

## PR Title Format

Same types as Conventional Commits:

| Type       | Purpose                        |
| ---------- | ------------------------------ |
| `feat`     | New feature                    |
| `fix`      | Bug fix                        |
| `docs`     | Documentation only             |
| `style`    | Formatting/style (no logic)    |
| `refactor` | Code refactor (no feature/fix) |
| `perf`     | Performance improvement        |
| `test`     | Add/update tests               |
| `build`    | Build system/dependencies      |
| `ci`       | CI/config changes              |
| `chore`    | Maintenance/misc               |
| `revert`   | Revert commit                  |

```
<type>[optional scope]: <description>
```

## PR Description

### 1. Look for an existing template

Check, in order, for a repo-defined template:

```bash
ls .github/PULL_REQUEST_TEMPLATE.md \
   .github/pull_request_template.md \
   docs/PULL_REQUEST_TEMPLATE.md \
   .github/PULL_REQUEST_TEMPLATE/*.md 2>/dev/null
```

If one exists, fill it in, still leading with why/motivation wherever the template structure allows.

### 2. Fallback template

If no template is found, use:

```markdown
## Why

The problem or goal driving this change.

## Decisions Made

Key choices and tradeoffs made while implementing this.

## Problems Encountered

Obstacles hit along the way and how they were resolved.

## Benchmarks

(Only include this section for `perf` PRs.) Before/after numbers showing the improvement.
```

Omit a section entirely if it has nothing meaningful to say (e.g. no notable decisions or problems) rather than leaving it empty.

## Workflow

### 1. Gather context

```bash
git branch --show-current
git log <base-branch>..HEAD --oneline
git diff <base-branch>...HEAD
```

Use the commit log and diff to understand the change, not just the latest commit.

### 2. Check template and draft content

Look for a template (see above). Draft the title and body from the branch's commits/diff.

### 3. Determine draft vs ready

Default to **draft**. Only propose ready-for-review if the branch's commits and diff clearly show finished, tested work. If it's ambiguous, ask the user.

### 4. Confirm before submitting

Show the user the drafted title, body, and draft/ready status. Get confirmation before pushing or creating the PR.

### 5. Push and create

Ask the user before pushing (never push without explicit confirmation):

```bash
git push -u origin <branch-name>
```

Then create the PR:

```bash
gh pr create --title "<type>[scope]: <description>" --body "<body>" --base <base-branch> --draft
# omit --draft if ready for review
```

## Best Practices

- One logical change per PR, same as one logical change per commit
- Why before what — the diff already shows what changed
- Don't restate the diff in prose; explain reasoning instead
- Keep the description focused; trim sections with nothing meaningful to add

## Git/GitHub Safety Protocol

- NEVER push without asking first
- NEVER force-push
- NEVER merge or approve the PR automatically
- NEVER skip CI checks or hooks
- If `gh pr create` fails, fix the issue and retry — don't fall back to force flags without asking
