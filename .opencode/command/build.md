---
description: Execute blueprints efficiently while maintaining quality
---

# Build Command

Execute a blueprint efficiently while maintaining quality and finishing features.

## Input Document

<input_document> #$ARGUMENTS </input_document>

## Execution Workflow

### Phase 1: Quick Start

1. **Read Blueprint and Clarify**
   - Read blueprint completely and review all references/links
   - Ask clarifying questions NOW if anything is unclear (better now than building wrong thing)
   - Get user approval to proceed

2. **Create Todo List**
   - Use TodoWrite to break blueprint into actionable tasks with dependencies
   - Include testing and quality checks
   - Keep tasks specific and completable

### Phase 2: Execute

For each task in priority order:

```
while (tasks remain):
  - Mark task as in_progress in TodoWrite
  - Read referenced files from blueprint
  - Find similar patterns in codebase and match them exactly
  - Implement following existing conventions (CLAUDE.md / AGENTS.md)
  - Write tests for new functionality
  - Run tests after changes (test continuously, not at end)
  - Mark task as completed
```

**Key practices embedded above:**
- The blueprint references are your guide - load and follow them
- Don't reinvent patterns - match what exists in the codebase
- Track progress in TodoWrite as you complete tasks
- Finish complete features, don't leave work 80% done

### Phase 3: Quality Check

Before marking implementation complete, verify:

- All TodoWrite tasks are completed
- Tests pass: `go test ./...` and `yarn test`
- Linting passes (per CLAUDE.md / AGENTS.md)
- Code follows existing patterns
- No console errors or warnings

### Phase 4: Complete

1. **Notify User**
   - Summarize what was completed
   - List files created or modified
   - Note any follow-up work needed

2. **Offer to Create Merge Request** (Optional)

   Ask: "Would you like me to create a GitLab Merge Request?"

   If yes and `glab` is available:
   ```bash
   git push -u origin HEAD
   glab mr create --fill --web
   ```

   If `glab` is not installed: "GitLab CLI (`glab`) is not installed. Install it with `brew install glab` and authenticate with `glab auth login`."
