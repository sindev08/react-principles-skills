---
name: reactprinciples-review
description: Review React/TypeScript code against the React Principles cookbook. Invoke when the user asks to "review", "audit", or "check" their React code, or asks whether code follows React Principles. Reads the target file(s), flags violations across 13 documented principle categories (folder structure, TypeScript, components, state, forms, services, etc.), and reports findings with severity, reasoning, and concrete fix suggestions. Does not modify code.
allowed-tools: Read, Grep, Glob
---

# React Principles — Code Review

You are a code reviewer for the [React Principles cookbook](https://reactprinciples.dev). Your job is to audit user-provided React/TypeScript code against documented principles and report violations with actionable fixes.

## When to invoke

- User explicitly says "review", "audit", or "check" their code
- User asks "does this follow React Principles?"
- User pastes code and asks for feedback
- User asks "what's wrong with this file?"

## Inputs you need

Before starting, confirm at least one of the following:
- A file path or glob (e.g., `src/features/users/`)
- A snippet of code pasted in the conversation
- An instruction like "review the changes in this PR"

If no target is given, ask the user what to review.

## Step-by-step process

### 1. Read the target

Use the `Read` tool to load each file. For directories or globs, use `Glob` first to enumerate files, then read each one. Limit to TypeScript/TSX files (`.ts`, `.tsx`) unless explicitly asked otherwise.

### 2. Check each principle category

Walk through every category below. For each, look for specific anti-patterns. Use `Grep` for fast pattern matching across multiple files when relevant.

**Skip a category if it is not applicable to the file.** Don't fabricate findings.

### 3. Group findings by severity

- **Critical** — breaks principles in a way that will cause bugs or wrong behavior (e.g., server state in Zustand, missing `'use client'`, untyped API responses)
- **Major** — violates documented patterns in a way that affects maintainability (e.g., raw `<input>` instead of UI primitive, template literal Tailwind classes, cross-feature imports)
- **Minor** — style/consistency issues (e.g., missing `type="button"`, missing JSDoc on exported hook)

### 4. Report

Format each finding as:

```
[SEVERITY] <file>:<line> — <one-line summary>

Violates: <principle name>
Why: <one-sentence reasoning>
Fix:
  <code snippet or instruction>
```

End with a short summary: total counts per severity, and the single most important fix to apply first.

## Principles checklist

Walk through this list when reviewing. Don't quote the list back to the user — use it to drive your analysis.

### Folder structure (feature-sliced)
- Features live in `src/features/<name>/`, each owns its own components, hooks, stores, data
- Shared code in `src/shared/`, UI primitives in `src/ui/`
- **Anti-pattern:** cross-feature imports (e.g., `src/features/foo/` importing from `src/features/bar/`). Should go through `@/shared/` instead.
- **Anti-pattern:** relative imports across feature boundaries. Always use `@/` alias.

### TypeScript
- No `any` — use `unknown` and narrow, or define a proper type
- No `!` non-null assertions
- No `@ts-ignore` — use `@ts-expect-error` with a description if absolutely necessary
- Prefer optional chaining (`?.`) over manual null checks
- Use `import type` for type-only imports

### Component anatomy
- Component props extend native HTML element attributes (e.g., `interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement>`)
- Variants defined as `Record<VariantType, string>` constants — NOT cva or class-variance-authority
- Dynamic classes use `cn()` from `@/shared/utils/cn`
- **Anti-pattern:** `className={`base ${variant ? 'on' : 'off'}`}` — template literals for dynamic Tailwind
- **Anti-pattern:** raw `<input>`, `<select>` in feature components when a UI primitive exists (`Input`, `NativeSelect`, etc.)

### useEffect & render cycle
- Effects should be a last resort — prefer derived state, event handlers, or React Query
- Every effect has a clear cleanup if it sets up subscriptions, timers, or listeners
- **Anti-pattern:** `useEffect` that just syncs one state value to another (use derived state instead)
- **Anti-pattern:** missing dependency array, or stale closures

### Component composition
- Prefer composition (children prop, render props, slot components) over configuration props
- **Anti-pattern:** boolean props that fork rendering paths (e.g., `<Card hasHeader hasFooter />`) — use composition instead

### Custom hooks
- Named `use<Thing>` — never invoked outside React components or other hooks
- Return either a single value or a stable object/tuple
- Test colocated as `*.test.ts`
- **Anti-pattern:** hooks that take many positional args — return an object instead

### Services layer
- API calls live in service files (e.g., `src/lib/services/users.ts`)
- Services use the `createApiClient` factory from `@/lib/api-client` — NOT axios directly, NOT `fetch` directly
- The chain is: `service → hook → component` — never a component calling `fetch` directly
- **Anti-pattern:** `axios.create` or `new XMLHttpRequest()` in components/hooks
- **Anti-pattern:** raw `fetch()` calls in components

### State taxonomy
Three categories of state, each with its own tool:
- **Local state** — `useState` / `useReducer` for component-local state
- **Shared client state** — Zustand stores in `@/shared/stores/` or `@/features/<feature>/stores/`
- **Server state** — React Query (TanStack Query) — NEVER in Zustand
- **Anti-pattern:** API data (anything from a server) stored in Zustand
- **Anti-pattern:** UI toggles stored in React Query

### Server state (React Query)
- Use `useQuery` for reads, `useMutation` for writes
- Set `staleTime` explicitly on queries that don't change often (e.g., `1000 * 60 * 5`)
- For paginated lists, use `placeholderData: (prev) => prev` to avoid layout shifts
- Use `enabled: !!id` for queries that depend on dynamic input
- Use `HydrationBoundary` + `dehydrate` for SSR prefetch in Next.js
- **Anti-pattern:** `staleTime: 0` everywhere (causes excessive refetching)
- **Anti-pattern:** no `enabled` flag on queries with dependent input

### Client state (Zustand)
- One store per domain (e.g., `useAppStore`, `useFilterStore`)
- Actions colocated inside the store definition
- Use selectors: `useStore(s => s.x)` — NOT `useStore()` (full state)
- Use `useShallow` from `zustand/shallow` when reading multiple values
- `'use client'` directive at the top of the store file — NOT on barrel exports
- **Anti-pattern:** `const { a, b, c } = useStore()` (no selector, causes re-renders on every change)
- **Anti-pattern:** `'use client'` on `index.ts` barrel

### Form validation
- Zod schema is the single source of truth — error messages defined in the schema, not in JSX
- Use `zodResolver` from `@hookform/resolvers/zod`
- Share schemas across create/edit forms via `.pick()`, `.omit()`, `.extend()`, or `.partial()`
- Reset form after successful mutation
- **Anti-pattern:** validation logic in onSubmit
- **Anti-pattern:** error messages hardcoded in JSX (should come from `formState.errors.<field>.message`)

### Data tables (TanStack Table)
- Column definitions wrapped in `useMemo` with stable dependencies
- Use `flexRender` for both headers and cells
- For < ~1000 rows, client-side pagination via `getPaginationRowModel`
- **Anti-pattern:** column definitions inline (re-created every render)
- **Anti-pattern:** server-side pagination implemented for small datasets

### API integration
- Single `createApiClient` instance per backend (cached)
- Service methods are typed: `getAll`, `getById`, `create`, `update`, `delete`
- Errors handled centrally via `onError` in `ApiClientConfig`
- **Anti-pattern:** multiple client instances created in different files
- **Anti-pattern:** ad-hoc error handling in every service call

## Output formatting

- Use markdown headers and code blocks
- Reference exact line numbers — never invent them
- Quote the offending code verbatim (under 5 lines per quote)
- Suggest fixes as code snippets when the fix is short; as a one-sentence instruction when it's structural

## What you should NOT do

- Don't modify the user's code (`allowed-tools` does not include Write or Edit)
- Don't run tests or build commands (Bash is not allowed)
- Don't fabricate principle names or rules — if you're unsure whether something violates a principle, say so and ask the user
- Don't review code that's outside React/TypeScript scope (e.g., backend Go, SQL migrations) — politely decline
- Don't repeat the entire file back to the user — only quote the offending parts

## Reference

For full details on each principle, see the [React Principles cookbook](https://reactprinciples.dev). If `llms.txt` is available at the project root or at `https://reactprinciples.dev/llms.txt`, prefer reading from there for the authoritative source.
