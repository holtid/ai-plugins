---
name: power-of-ten-go
description: NASA/JPL Power of Ten rules adapted for Go. Use when reviewing Go code.
---

# Power of Ten - Go

Adapted from Gerard J. Holzmann's NASA/JPL rules for safety-critical code.

## 1. Simple Control Flow

**Rule**: No `goto`. No direct or indirect recursion.

**Rationale**: Simple control flow enables verification and improves clarity. Without recursion, the call graph is acyclic - tools can prove all executions are bounded. Early returns for errors are fine.

**Go**: Avoid recursive functions. Convert to iteration with explicit bounds. If recursion is unavoidable, add depth limits.

## 2. Bounded Loops

**Rule**: All loops must have a fixed, provable upper bound.

**Rationale**: Combined with no recursion, this prevents runaway code. When traversing dynamic data, add explicit upper bounds that trigger errors when exceeded.

**Go**:
```go
// Bad: unbounded
for item := range channel { }

// Good: bounded with timeout
ctx, cancel := context.WithTimeout(ctx, 30*time.Second)
for { select { case item := <-channel: ... case <-ctx.Done(): return } }

// Bad: unbounded iteration
for node != nil { node = node.Next }

// Good: explicit bound
for i := 0; node != nil && i < maxNodes; i++ { node = node.Next }
```

## 3. No Dynamic Allocation After Init

**Rule**: Do not allocate memory after initialization.

**Rationale**: Memory allocators have unpredictable behavior. Allocation bugs (leaks, use-after-free, overruns) are eliminated by pre-allocating. Stack usage becomes statically provable.

**Go**: Go has GC, but the principle applies to hot paths:
- Pre-allocate slices: `make([]T, 0, expectedSize)`
- Use `sync.Pool` for frequently allocated objects
- Avoid allocations in tight loops
- Watch hidden allocations: string concat, interface boxing, closures

## 4. Function Length

**Rule**: No function longer than 60 lines (one printed page).

**Rationale**: Each function must be understandable and verifiable as a unit. Long functions indicate poor structure.

**Go**: If a function needs section comments, split it. Each function should do one thing.

## 5. Assertion Density

**Rule**: Minimum two assertions per function. Assertions must be side-effect free. On failure, return an error. Trivial assertions that always pass/fail don't count.

**Rationale**: Defects occur every 10-100 lines. Assertions intercept them. Use for pre/post-conditions, parameter validation, return values, loop invariants.

**Go**: Go doesn't have assert, but the pattern applies:
```go
func Process(data []byte, limit int) error {
    // Precondition checks (assertions)
    if data == nil {
        return errors.New("data cannot be nil")
    }
    if limit <= 0 || limit > MaxLimit {
        return fmt.Errorf("limit %d out of range [1, %d]", limit, MaxLimit)
    }

    // ... logic ...

    // Postcondition / invariant check
    if result < 0 {
        return errors.New("invariant violated: result cannot be negative")
    }
    return nil
}
```

## 6. Minimal Scope

**Rule**: Declare data at the smallest possible scope.

**Rationale**: Data hiding - if not in scope, it can't be corrupted. Fewer places a value can be assigned means easier fault diagnosis. Prevents variable reuse for incompatible purposes.

**Go**:
- Declare variables at point of first use
- Use short-lived variables in tight scopes
- Avoid package-level variables (except true constants)
- Don't reuse variables for different purposes

## 7. Check All Returns

**Rule**: Check return value of every non-void function. Validate parameters inside each function.

**Rationale**: The most frequently violated rule. Ignoring returns causes silent failures. Error values must propagate up the call chain.

**Go**:
```go
// Bad
result, _ := SomeFunc()
io.Copy(dst, src)

// Good
result, err := SomeFunc()
if err != nil {
    return fmt.Errorf("SomeFunc: %w", err)
}

n, err := io.Copy(dst, src)
if err != nil {
    return fmt.Errorf("copy failed: %w", err)
}
```

## 8. Limited Code Generation

**Rule**: (Original: limit preprocessor) Limit `go generate` and build tags.

**Rationale**: Code generation obscures what's actually running. Each build tag doubles the test matrix.

**Go**:
- Minimize `//go:build` tags
- Keep generated code simple and auditable
- Avoid complex `go generate` pipelines

## 9. Pointer Discipline

**Rule**: Restrict pointer use. No more than one level of dereferencing. No hidden dereferences. Function pointers (interfaces) require justification.

**Rationale**: Pointers complicate data flow analysis. Function pointers prevent proving absence of recursion.

**Go**:
- Avoid `**T` (pointer to pointer)
- Be explicit about nil - check at trust boundaries
- Prefer value receivers unless mutation needed
- Use interfaces deliberately, not by default
- Document why interface{}/any is necessary

