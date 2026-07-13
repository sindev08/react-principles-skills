---
name: reactprinciples-hook
description: Scaffold a custom React hook following React Principles custom-hooks recipe. Invoke when the user says "create a custom hook", "scaffold a hook", or asks for a hook to encapsulate logic. Generates the hook file with proper naming (use prefix), TypeScript types, a stable return shape, and a colocated test file. Places the hook in src/shared/hooks/ for cross-feature use or src/features/<x>/hooks/ for feature-specific.
allowed-tools: Read, Write, Glob, WebFetch
---

# React Principles — Custom Hook Scaffold

You scaffold a custom React hook following the [Custom Hooks](https://www.reactprinciples.dev/cookbook/custom-hooks) recipe.

## Step 0 — Load the live recipe (required)

Do this before anything else. The cookbook is the single source of truth and changes over time — never scaffold from memory or from the fallback summary below while the live recipe is reachable.

1. If the `reactprinciples` MCP server is available, call its `get_recipe` tool with slug `custom-hooks`.
2. Otherwise fetch: https://www.reactprinciples.dev/cookbook/custom-hooks/llms.txt

The fetched recipe contains the naming, return-shape, and testing rules plus canonical pattern code — treat its rules as requirements, not suggestions. If both sources are unreachable (offline), use the fallback summary at the bottom of this file and tell the user you are working from a potentially outdated summary.

## When to invoke

- User asks to "create a custom hook called X"
- User asks to "extract logic into a hook"
- User asks for `useDebounce`-style scaffolding

## Inputs needed

Ask the user for:

1. **Hook name** — camelCase, must start with `use` (e.g., `useDebounce`, `useMediaQuery`)
2. **What it does** — brief description, used for inline doc comment
3. **Inputs** (optional) — parameters the hook takes (with types)
4. **Return shape** — single value, object, or tuple? If unclear, default to an object for >1 return value
5. **Location**:
   - `src/shared/hooks/` if reusable across features (default for utility hooks like debounce, media query)
   - `src/features/<feature>/hooks/` if specific to one feature

## What to read first

Read an existing hook and its test in the user's project for reference:

```
src/shared/hooks/useDebounce.ts
src/shared/hooks/useDebounce.test.ts
```

Match the conventions you find.

## How to scaffold

Derive the hook and its colocated test from the **pattern code in the recipe you fetched in Step 0**, shaped to match the existing hook you read. The test should verify the simplest happy path — don't generate exhaustive tests; leave that to the user.

Route away when a more specific skill applies:
- React Query hooks → `reactprinciples-query`
- Zustand store hooks → `reactprinciples-store`
- Form hooks → `reactprinciples-form`

## After generating

Tell the user:
1. The file paths created (hook + test)
2. Import path: `import { use<Name> } from "@/shared/hooks"` (or feature path)
3. Whether to add the hook to a barrel `index.ts`
4. A reminder to run the test: `pnpm test use<Name>`

## What you should NOT do

- Don't generate hooks that wrap a single React API one-to-one without adding value (e.g., a hook that just calls `useState`)
- Don't put hooks in `src/features/<x>/components/` — hooks belong in a `hooks/` folder
- Don't import the hook from outside its feature using relative paths — always use `@/` alias

## Fallback summary (only if Step 0 fails)

May be outdated — the live recipe always wins.

- Name starts with `use`, camelCase; only called from components or other hooks
- Stable return shape: single value, `[value, setter] as const` tuple, or a named object for 2+ values — never more than 4
- Colocate a `*.test.ts` using `renderHook` from Testing Library
- Document with a one-line JSDoc + `@example`

## Reference

See [Custom Hooks recipe](https://www.reactprinciples.dev/cookbook/custom-hooks) and existing hooks in `src/shared/hooks/`.
