---
description: Create a git commit
permission:
  bash:
    "git add*": allow
    "git status*": allow
    "git commit*": allow
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit.
Follow the commit style that is already in use for this repo.
Dont sign commit messages with claude code!
