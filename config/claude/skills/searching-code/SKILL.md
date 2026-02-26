---
name: searching-code
description: Use when searching files or content in codebases. Always invoke before using any search tool (Glob, Grep, Bash find/grep/fd/rg).
model: haiku
---

## Search for Content — `rg` (ripgrep) instead of `grep`

```bash
rg "pattern"                  # Search for pattern in files
rg "pattern" --type elixir    # Filter by file type
rg "pattern" -C 3             # Include context lines
rg -w "word"                  # Whole words only
rg -i "pattern"               # Case insensitive
rg -l "pattern"               # List matching files only
```

## Finding Files — `fd` instead of `find`

```bash
fd filename                   # Find by name
fd -e ex                      # Find by extension
fd ".*_live\.ex$"             # Find by pattern
fd -e ex -x wc -l             # Find and execute command
fd pattern --exclude test     # Exclude directories
```
