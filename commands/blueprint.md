---
name: blueprint
description: Create implementation plans for new features
argument-hint: "[feature description]"
---

# Create an Implementation Blueprint

Transform feature descriptions into actionable implementation blueprints.

## Feature Description

<feature_description>$ARGUMENTS</feature_description>

**If empty, ask:** "What feature would you like to plan? Describe what you want to build."

Do not proceed until you have a clear feature description.

---

## Process

### 1. Parallel Research

Launch these agents in parallel to gather context:

**Agent 1: Codebase Explorer (opus)**
- Find similar implementations in the codebase
- Read CLAUDE.md for project conventions
- Identify naming patterns and file structure
- Note test locations and patterns
- Note internal packages that can be used

**Agent 2: Best Practices Researcher (opus)**
- Search online for best practices in this domain
- Find recommended patterns for this type of feature
- Look for common pitfalls to avoid
- Note industry standards and conventions

**Agent 3: Standard Library Researcher (opus)**
- Identify what can be done with standard libraries
- Prefer standard library solutions over third-party packages
- For Go: Check `net/http`, `encoding/json`, `context`, `errors`
- For TypeScript: Check native APIs, built-in types, standard DOM APIs
- Only recommend external packages if standard library is insufficient

### 2. Clarifying Questions

After research, ask targeted questions:

**Scope:**
- Is this frontend (TypeScript/React), backend (Go), or full-stack?
- New feature or modification to existing code?
- What's the MVP vs nice-to-have?

**Technical:**
- Any specific performance requirements?
- Integration with existing services/components?

### 3. Generate Blueprint

Use the template below to create an actionable blueprint.

---

## Blueprint Template

```markdown
## Blueprint: [Feature Title]

### Overview
[What this feature does and why it matters]

### Research Findings

**Codebase Patterns:**
- Similar implementation: `[file:line]`
- Naming convention: [pattern found]
- Test pattern: [how tests are structured]

**Best Practices:**
- [Key practice 1 from research]
- [Key practice 2 from research]
- [Common pitfall to avoid]

**Standard Library Usage:**
- [Standard library solution 1]
- [Standard library solution 2]
- External package needed: [only if necessary, with justification]

### Technical Approach

**Architecture:**
```
[Simple diagram of data flow]
```

**Key Decisions:**
- [Decision 1]: [Reasoning]
- [Decision 2]: [Reasoning]

### Implementation Steps

**Backend (Go):**
1. [ ] Define types: `src/models/feature.go`
2. [ ] Create service: `src/services/feature_service.go`
3. [ ] Add handler: `src/api/handlers/feature_handler.go`
4. [ ] Register route: `src/api/routes.go`
5. [ ] Add tests: `src/services/feature_service_test.go`

**Frontend (TypeScript/React):**
1. [ ] Define types: `src/types/feature.ts`
2. [ ] Create hook: `src/hooks/useFeature.ts`
3. [ ] Build component: `src/components/Feature/Feature.tsx`
4. [ ] Add to page: `src/pages/FeaturePage.tsx`
5. [ ] Add tests: `src/components/Feature/__tests__/Feature.test.tsx`

### Example Code

**Go:**
```go
// src/services/feature_service.go
package services

type FeatureService struct {
    // dependencies
}

func (s *FeatureService) DoSomething(ctx context.Context, input Input) (*Output, error) {
    // Implementation using standard library
    return nil, nil
}
```

**TypeScript:**
```typescript
// src/hooks/useFeature.ts
export function useFeature(id: string) {
    const [data, setData] = useState<Feature | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    useEffect(() => {
        // fetch logic
    }, [id]);

    return { data, loading, error };
}
```

### Files to Create/Modify

**New Files:**
- `[path]` - [purpose]

**Modified Files:**
- `[path]` - [what changes]

### Acceptance Criteria

- [ ] Feature works as described
- [ ] Error cases handled gracefully
- [ ] Tests pass with good coverage
- [ ] No linter warnings
- [ ] Uses standard library where possible
- [ ] Follows patterns found in codebase

### Risks & Mitigations

- **Risk:** [potential issue]
  **Mitigation:** [how to handle]

### References

**Internal:**
- [file:line] - [what it shows]

**External:**
- [Best practice source]
- [Standard library docs]
```

---

## Output

After generating the blueprint, end with:

```markdown
---

## Next Steps

Blueprint saved to: `.blueprint/[feature-name].md`

1. Review this blueprint and provide feedback
2. Ask questions to clarify any section
3. Request changes (simplify, add detail, adjust scope)
4. When ready, run `/sendify:build .blueprint/[feature-name].md` to execute
```

## Save Blueprint to File

After generating the blueprint and getting user approval:

1. **Create `.blueprint` directory** if it doesn't exist
2. **Save blueprint** as `.blueprint/[feature-name].md` (kebab-case filename)
3. **Check gitignore:**
   - Read `.gitignore` in project root
   - If `.blueprint` or `.blueprint/` is NOT listed, ask the user:
     > "The `.blueprint` directory is not in `.gitignore`. Would you like me to add it?"
   - If user agrees, add `.blueprint/` to `.gitignore`

**Example:**
```
.blueprint/
├── user-authentication.md
├── export-metrics.md
└── dark-mode-toggle.md
```

## Guidelines

- **Research First:** Always run the 3 research agents before planning
- **Prefer Standard Library:** Only use external packages when necessary
- **Be Specific:** Include file paths and code examples
- **Stay Actionable:** Blueprints should be immediately implementable
