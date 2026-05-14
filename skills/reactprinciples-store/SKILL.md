---
name: reactprinciples-store
description: Scaffold a Zustand store following React Principles client-state recipe. Invoke when the user says "create a Zustand store", "scaffold a state store", or asks about React Principles state management. Generates a typed store with colocated actions, selector pattern, useShallow guidance, reset action, and 'use client' directive. Includes a colocated test file. Use for UI/client state only — server state belongs in React Query.
allowed-tools: Read, Write, Glob
---

# React Principles — Zustand Store Scaffold

You scaffold a Zustand store following the [Client State with Zustand](https://reactprinciples.dev/cookbook/client-state) recipe.

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

Read existing stores for reference:

```
src/shared/stores/useAppStore.ts
src/shared/stores/useFilterStore.ts
```

Match the conventions exactly.

## Template

```ts
"use client";

import { create } from "zustand";

// ─── Types ────────────────────────────────────────────────────────────────────

interface <Name>State {
  // state fields
  count: number;
  // actions
  increment: () => void;
  reset: () => void;
}

// ─── Initial State ────────────────────────────────────────────────────────────

const initialState = {
  count: 0,
};

// ─── Store ────────────────────────────────────────────────────────────────────

export const use<Name>Store = create<<Name>State>((set) => ({
  ...initialState,
  increment: () => set((state) => ({ count: state.count + 1 })),
  reset: () => set(initialState),
}));

// ─── Computed selectors (optional) ────────────────────────────────────────────

export const useIs<Computed> = () =>
  use<Name>Store((s) => /* derive from state */);
```

### Critical rules in the template

1. **`'use client'` at top of file** — required because Zustand uses React internals
2. **Initial state as a `const`** — enables clean `reset: () => set(initialState)`
3. **Actions inside the store** — never as separate functions outside
4. **Type the state interface explicitly** — don't rely on inference

## Test file

```ts
// use<Name>Store.test.ts
import { describe, it, expect, beforeEach } from "vitest";
import { use<Name>Store } from "./use<Name>Store";

describe("use<Name>Store", () => {
  beforeEach(() => {
    use<Name>Store.getState().reset();
  });

  it("has the correct initial state", () => {
    expect(use<Name>Store.getState().count).toBe(0);
  });

  it("increments correctly", () => {
    use<Name>Store.getState().increment();
    expect(use<Name>Store.getState().count).toBe(1);
  });

  it("resets to initial state", () => {
    use<Name>Store.getState().increment();
    use<Name>Store.getState().reset();
    expect(use<Name>Store.getState().count).toBe(0);
  });
});
```

## Consumer code reminder

When teaching the user how to consume the store, emphasize the selector pattern:

```tsx
// GOOD — single selector
const count = use<Name>Store((s) => s.count);

// GOOD — multiple values with useShallow
import { useShallow } from "zustand/shallow";
const { count, increment } = use<Name>Store(
  useShallow((s) => ({ count: s.count, increment: s.increment }))
);

// BAD — re-renders on any state change
const { count, increment } = use<Name>Store();
```

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

## Reference

See [Client State with Zustand recipe](https://reactprinciples.dev/cookbook/client-state) and existing stores in `src/shared/stores/`.
