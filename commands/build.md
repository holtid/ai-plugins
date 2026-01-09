---
name: build
description: Execute blueprints efficiently while maintaining quality and finishing features
argument-hint: "[blueprint file, specification, or todo file path]"
---

# Build Command

Execute a blueprint efficiently while maintaining quality and finishing features.

## Introduction

This command takes a blueprint (or specification/todo file) and executes it systematically. The focus is on **shipping complete features** by understanding requirements quickly, following existing patterns, and maintaining quality throughout.

## Input Document

<input_document> #$ARGUMENTS </input_document>

## Execution Workflow

### Phase 1: Quick Start

1. **Read Blueprint and Clarify**

   - Read the blueprint completely
   - Review any references or links provided in the blueprint
   - If anything is unclear or ambiguous, ask clarifying questions now
   - Get user approval to proceed
   - **Do not skip this** - better to ask questions now than build the wrong thing

2. **Create Todo List**
   - Use TodoWrite to break blueprint into actionable tasks
   - Include dependencies between tasks
   - Prioritize based on what needs to be done first
   - Include testing and quality check tasks
   - Keep tasks specific and completable

### Phase 2: Execute

1. **Task Execution Loop**

   For each task in priority order:

   ```
   while (tasks remain):
     - Mark task as in_progress in TodoWrite
     - Read any referenced files from the blueprint
     - Look for similar patterns in codebase
     - Implement following existing conventions
     - Write tests for new functionality
     - Run tests after changes
     - Mark task as completed
   ```

2. **Follow Existing Patterns**

   - The blueprint should reference similar code - read those files first
   - Match naming conventions exactly
   - Reuse existing components where possible
   - Follow project coding standards (see CLAUDE.md / AGENTS.md)
   - When in doubt, grep for similar implementations

3. **Test Continuously**

   - Run relevant tests after each significant change
   - Don't wait until the end to test
   - Fix failures immediately
   - Add new tests for new functionality

5. **Track Progress**
   - Keep TodoWrite updated as you complete tasks
   - Note any blockers or unexpected discoveries
   - Create new tasks if scope expands
   - Keep user informed of major milestones

### Phase 3: Quality Check

1. **Run Core Quality Checks**

   Always run before completing:

   ```bash
   # Go backend
   go test ./...

   # TypeScript frontend
   yarn test

   # Linting (per CLAUDE.md / AGENTS.md) 
   ```

2. **Consider Reviewer Agent** (Optional)

   Use for complex, risky, or large changes:

   - **code-simplicity-reviewer**: Check for unnecessary complexity
   - **power-of-ten-reviewer**: Verify safety-critical coding rules

   Run reviewers in parallel with Task tool:

   ```
   Task(code-simplicity-reviewer): "Review changes for simplicity"
   Task(power-of-ten-reviewer): "Check power of ten conventions"
   ```

   Present findings to user and address critical issues.

3. **Final Validation**
   - All TodoWrite tasks marked completed
   - All tests pass
   - Linting passes
   - Code follows existing patterns
   - No console errors or warnings

### Phase 4: Complete

1. **Commit Changes**
   - Stage all relevant changes
   - Create a commit with a clear message summarizing what was built
   - Follow the repository's commit message conventions

2. **Notify User**
   - Summarize what was completed
   - List any files created or modified
   - Note any follow-up work needed

3. **Offer to Create Merge Request** (Optional)

   Ask the user: "Would you like me to create a GitLab Merge Request?"

   If yes and `glab` is available:
   ```bash
   # Push branch to remote
   git push -u origin HEAD

   # Create MR using GitLab CLI
   glab mr create --fill --web
   ```

   The `--fill` flag auto-fills title and description from commit messages.
   The `--web` flag opens the MR in the browser for final review.

   If `glab` is not installed, inform the user:
   > "GitLab CLI (`glab`) is not installed. Install it with `brew install glab` and authenticate with `glab auth login`."

---

## Key Principles

### Start Fast, Execute Faster

- Get clarification once at the start, then execute
- Don't wait for perfect understanding - ask questions and move
- The goal is to **finish the feature**, not create perfect process

### The Blueprint is Your Guide

- Blueprints should reference similar code and patterns
- Load those references and follow them
- Don't reinvent - match what exists

### Test As You Go

- Run tests after each change, not at the end
- Fix failures immediately
- Continuous testing prevents big surprises

### Quality is Built In

- Follow existing patterns
- Write tests for new code
- Run linting before completing
- Use reviewer agents for complex/risky changes only

### Ship Complete Features

- Mark all tasks completed before moving on
- Don't leave features 80% done
- A finished feature that ships beats a perfect feature that doesn't

## Quality Checklist

Before marking implementation complete:

- [ ] All clarifying questions asked and answered
- [ ] All TodoWrite tasks marked completed
- [ ] Tests pass (`go test ./...` and/or `yarn test`)
- [ ] Linting passes (per CLAUDE.md / AGENTS.md)
- [ ] Code follows existing patterns

## When to Use Reviewer Agents

**Don't use by default.** Use reviewer agents only when:

- Large refactor affecting many files (10+)
- Security-sensitive changes (authentication, permissions, data access)
- Performance-critical code paths
- Complex algorithms or business logic
- User explicitly requests thorough review

For most features: tests + linting + following patterns is sufficient.

## Common Pitfalls to Avoid

- **Analysis paralysis** - Don't overthink, read the blueprint and execute
- **Skipping clarifying questions** - Ask now, not after building wrong thing
- **Ignoring blueprint references** - The blueprint has links for a reason
- **Testing at the end** - Test continuously or suffer later
- **Forgetting TodoWrite** - Track progress or lose track of what's done
- **80% done syndrome** - Finish the feature, don't move on early
- **Over-reviewing simple changes** - Save reviewer agents for complex work
