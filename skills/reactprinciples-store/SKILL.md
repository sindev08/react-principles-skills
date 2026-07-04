---
name: reactprinciples-store
description: Scaffold a Zustand store following React Principles client-state recipe. Invoke when the user says "create a Zustand store", "scaffold a state store", or asks about React Principles state management. Generates a typed store with colocated actions, selector pattern, useShallow guidance, reset action, and 'use client' directive. Includes a colocated test file. Use for UI/client state only — server state belongs in React Query.
allowed-tools: Read, Write, Glob, WebFetch
---

# React Principles — Zustand Store Scaffold

You scaffold a Zustand store following the [Client State with Zustand](https://reactprinciples.dev/cookbook/client-state) recipe.

## Step 0 — Load the live recipe (required)

Do this before anything else. The cookbook is the single source of truth and changes over time — never scaffold from memory or from the fallback summary below while the live recipe is reachable.

1. If the `reactprinciples` MCP server is available, call its `get_recipe` tool with slug `client-state`.
2. Otherwise fetch: https://reactprinciples.dev/cookbook/client-state/llms.txt

The fetched recipe contains the store rules, selector guidance, and canonical pattern code — treat its rules as requirements, not suggestions. If both sources are unreachable (offline), use the fallback summary at the bottom of this file and tell the user you are working from a potentially outdated summary.

## When to invoke

- User asks to "create a Zustand store" or "scaffold a state store"
- User asks for state management for UI toggles, filters, preferences, etc.
- User explicitly mentions Zustand

## Critical check first

**Before generating, confirm with the user that this is client state, not server state.**

- ✅ Use Zustand for: UI toggles, theme, sidebar open/closed, filter state, search dialog state, user preferences
- ❌ Do NOT use Zustand for: data from API, paginated lists, anything that comes from a server — use React Query instead (`reactprinciples-query` skill)

If the user wants to store API data in Zustand, push back and explain why React Query is the right tool.

## Inputs needed

Ask the user for:

1. **Store name** — camelCase starting with `use` (e.g., `useFilterStore`, `useThemeStore`)
2. **State shape** — list of state values with types
3. **Actions** — list of mutations (setters, toggles, reset)
4. **Computed selectors** (optional) — derived values exported as separate hooks
5. **Location**:
   - `src/shared/stores/` if used across multiple features (e.g., `useAppStore`, `useSearchStore`)
   - `src/features/<feature>/stores/` if specific to one feature

## What to read first

Read existing stores in the user's project for reference:

```
src/shared/stores/useAppStore.ts
src/shared/stores/useFilterStore.ts
```

Match the conventions exactly.

## How to scaffold

Derive the store and its colocated test from the **pattern code in the recipe you fetched in Step 0**, shaped to match the existing stores you read. When you hand the result over, show the user the consumption pattern from the recipe (selectors, `useShallow` for multi-value reads) so they don't subscribe to the full store.

## After generating

Tell the user:
1. The file paths created (store + test)
2. Import path: `import { use<Name>Store } from "@/shared/stores/use<Name>Store"`
3. Reminder: when consuming, use selectors (not full-state subscriptions) and `useShallow` for multi-value reads
4. **DO NOT** add `'use client'` to barrel `index.ts` — only the store file itself

## What you should NOT do

- Don't use Redux Toolkit, Jotai, or other state libraries — React Principles uses Zustand
- Don't put `'use client'` on the barrel `index.ts` — only on the store file
- Don't make actions accept the full state — they should accept only what they need
- Don't store derived/computed values in state — compute them via selectors

## Fallback summary (only if Step 0 fails)

May be outdated — the live recipe always wins.

- `'use client'` at the top of the store file (Zustand uses React internals)
- Initial state as a `const` so `reset: () => set(initialState)` stays clean
- Actions live inside the store definition, typed via an explicit state interface
- Consume via selectors (`useStore(s => s.x)`); `useShallow` for multiple values — never destructure the full store
- One store per domain; colocate a `*.test.ts` that exercises actions via `getState()`

## Reference

See [Client State with Zustand recipe](https://reactprinciples.dev/cookbook/client-state) and existing stores in `src/shared/stores/`.
