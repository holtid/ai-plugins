---
name: power-of-ten-ts
description: NASA/JPL Power of Ten rules adapted for TypeScript/React. Use when reviewing TypeScript code.
---

# Power of Ten - TypeScript

Adapted from Gerard J. Holzmann's NASA/JPL rules for safety-critical code.

## 1. Simple Control Flow

**Rule**: No `eval()` or dynamic code execution. No direct or indirect recursion without depth limits.

**Rationale**: Simple control flow enables verification and improves clarity. Without recursion, the call graph is acyclic - all executions can be proven bounded.

**TypeScript**:
```typescript
// Bad: unbounded recursion
function traverse(node: Node): void {
  node.children.forEach(traverse);
}

// Good: bounded with depth limit
function traverse(node: Node, depth = 0, maxDepth = 100): void {
  if (depth >= maxDepth) {
    throw new Error(`Max depth ${maxDepth} exceeded`);
  }
  node.children.forEach(child => traverse(child, depth + 1, maxDepth));
}
```

Avoid deeply nested callbacks - use async/await. Keep promise chains flat.

## 2. Bounded Loops

**Rule**: All loops must have a fixed, provable upper bound.

**Rationale**: Combined with no recursion, this prevents runaway code. When traversing dynamic data, add explicit upper bounds that trigger errors when exceeded.

**TypeScript**:
```typescript
// Bad: unbounded
while (await hasMore()) {
  items.push(await fetchNext());
}

// Good: bounded with limit
const MAX_ITEMS = 10000;
while (await hasMore() && items.length < MAX_ITEMS) {
  items.push(await fetchNext());
}
if (items.length >= MAX_ITEMS) {
  throw new Error(`Exceeded maximum items: ${MAX_ITEMS}`);
}

// Bad: unbounded fetch
await fetch(url);

// Good: bounded with timeout
const controller = new AbortController();
const timeout = setTimeout(() => controller.abort(), 30000);
try {
  await fetch(url, { signal: controller.signal });
} finally {
  clearTimeout(timeout);
}
```

## 3. No Dynamic Allocation After Init

**Rule**: Do not allocate memory in hot paths after initialization.

**Rationale**: Memory allocators have unpredictable behavior. Allocation bugs cause performance issues and memory leaks.

**TypeScript**:
```typescript
// Bad: allocation in render loop
function Component({ items }) {
  return items.map(item => ({ ...item, selected: false })); // new object each render
}

// Good: memoized
function Component({ items }) {
  const processed = useMemo(
    () => items.map(item => ({ ...item, selected: false })),
    [items]
  );
  return processed;
}

// Bad: allocation in event handler called frequently
onScroll={() => {
  const rect = { x: 0, y: scrollY }; // new object each scroll
}}

// Good: reuse or pool objects
const rect = useRef({ x: 0, y: 0 });
onScroll={() => {
  rect.current.y = scrollY; // mutate existing
}}
```

Watch for memory leaks in closures and event listeners - always clean up in useEffect.

## 4. Function Length

**Rule**: No function longer than 60 lines (one printed page).

**Rationale**: Each function must be understandable and verifiable as a unit. Long functions indicate poor structure.

**TypeScript**:
- Keep components under 500 lines
- Extract custom hooks for reusable logic
- If a function needs section comments, split it
- Each function/component should do one thing

## 5. Assertion Density

**Rule**: Minimum two assertions per function. Assertions must be side-effect free. On failure, throw or return error. Trivial assertions that always pass/fail don't count.

**Rationale**: Defects occur every 10-100 lines. Assertions intercept them. Use for pre/post-conditions, parameter validation, return values, invariants.

**TypeScript**:
```typescript
// Validate at trust boundaries with Zod
const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  age: z.number().int().positive().max(150),
});

async function processUser(input: unknown): Promise<Result> {
  // Precondition: validate external data
  const user = UserSchema.parse(input);

  // Precondition: business rule
  if (user.age < 18) {
    throw new Error('User must be 18 or older');
  }

  const result = await doSomething(user);

  // Postcondition: invariant check
  if (result.processedAt > Date.now()) {
    throw new Error('Invariant violated: processedAt cannot be in future');
  }

  return result;
}
```

## 6. Minimal Scope

**Rule**: Declare data at the smallest possible scope.

**Rationale**: Data hiding - if not in scope, it can't be corrupted. Fewer places a value can be assigned means easier fault diagnosis. Prevents variable reuse for incompatible purposes.

**TypeScript**:
```typescript
// Bad: broad scope
let result: string;
if (condition) {
  result = 'a';
} else {
  result = 'b';
}

// Good: minimal scope
const result = condition ? 'a' : 'b';

// Bad: module-level mutable state
let cache: Map<string, Data> = new Map();

// Good: encapsulated
function createCache() {
  const cache = new Map<string, Data>();
  return { get: (k) => cache.get(k), set: (k, v) => cache.set(k, v) };
}
```

- Prefer `const` over `let`
- Keep React state minimal - compute derived values
- Avoid module-level mutable state

## 7. Check All Returns

**Rule**: Check return value of every function. Validate parameters inside each function.

**Rationale**: The most frequently violated rule. Ignoring returns causes silent failures. Error values must propagate up the call chain.

**TypeScript**:
```typescript
// Bad: ignoring promise rejection
fetch('/api/data');

// Bad: ignoring possible undefined
const user = users.find(u => u.id === id);
console.log(user.name); // might crash

// Good: handle all cases
try {
  const response = await fetch('/api/data');
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`);
  }
  const data = await response.json();
} catch (error) {
  logger.error('Fetch failed', error);
  throw error;
}

// Good: handle undefined
const user = users.find(u => u.id === id);
if (!user) {
  throw new Error(`User ${id} not found`);
}
console.log(user.name);
```

## 8. Type Discipline

**Rule**: (Original: limit preprocessor) No `any`. No type assertions without validation. Use strict mode.

**Rationale**: Type erasure obscures what's actually running. Each `any` or unsafe assertion is a hole in verification.

**TypeScript**:
```typescript
// Bad
const data: any = await response.json();
const user = data as User;

// Good
const data: unknown = await response.json();
const user = UserSchema.parse(data); // runtime validation

// Bad: optional fields hide states
interface User {
  name?: string;
  email?: string;
}

// Good: discriminated union makes states explicit
type User =
  | { status: 'guest' }
  | { status: 'registered'; name: string; email: string };
```

Use `strict: true` in tsconfig. Zero `@ts-ignore`.

## 9. Reference Discipline

**Rule**: Restrict indirection. No more than one level of optional chaining. No hidden nullability.

**Rationale**: Deep references complicate data flow analysis. Each `?.` is a potential null that should be handled explicitly.

**TypeScript**:
```typescript
// Bad: deep optional chain hides nulls
const city = user?.address?.city?.name;

// Good: explicit handling at boundary
if (!user?.address?.city) {
  throw new Error('User address incomplete');
}
const city = user.address.city.name;

// Bad: mutation
function process(user: User) {
  user.processed = true; // side effect
}

// Good: immutable
function process(user: User): User {
  return { ...user, processed: true };
}
```

Destructure with defaults at trust boundaries. Prefer immutable patterns.

## 10. Zero Warnings

**Rule**: Enable all strict checks. Use static analyzers. Zero warnings - rewrite confusing code rather than ignore.

**Rationale**: Modern static analyzers are accurate. If the tool is confused, the code should be clearer.

**TypeScript**:
```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

```bash
tsc --noEmit
eslint --max-warnings 0 .
```

Zero tolerance. If ESLint complains, fix the code - don't add `// eslint-disable`.
