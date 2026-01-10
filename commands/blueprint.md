---
name: blueprint
description: Create implementation plans for features
argument-hint: "[feature description]"
---

ultrathink

# Create an Implementation Blueprint

## Blocking Condition

If feature description is empty: Ask **"What feature would you like to plan? Describe what you want to build."** and stop. Do not infer or invent a feature.

---

## Process

### 1. Parallel Research

Launch 3 agents in parallel:

- **Codebase Explorer (opus)**: Find similar implementations (`file:line`), naming conventions, test patterns, internal packages, CLAUDE.md/AGENTS.md presence
- **Best Practices (opus)**: Architectural patterns, pitfalls to avoid, industry standards
- **Standard Library (opus)**: Stdlib solutions, justify external packages if needed

### 2. Check CLAUDE.md/AGENTS.md

If missing: Stop and warn user to run `/init` in affected packages. Offer to proceed anyway (not recommended).

### 3. Clarifying Questions

Ask about:
- Scope: Frontend/backend/full-stack, new or modify existing, MVP vs nice-to-have
- Technical: Performance requirements, service integrations

### 4. Generate Blueprint

Use template below.

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
type FeatureService struct { /* deps */ }
func (s *FeatureService) DoSomething(ctx context.Context, input Input) (*Output, error) {
    // Implementation
    return nil, nil
}
```

**TypeScript:**
```typescript
export function useFeature(id: string) {
    const [data, setData] = useState<Feature | null>(null);
    useEffect(() => { /* fetch */ }, [id]);
    return { data };
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

## Finalize

After user approval:

1. Create `.blueprint/` directory if needed
2. Save as `.blueprint/[feature-name].md` (kebab-case)
3. Check `.gitignore` - offer to add `.blueprint/` if missing
4. Show: "Blueprint saved to `.blueprint/[feature-name].md`. Run `/sendify:build .blueprint/[feature-name].md` to execute."
