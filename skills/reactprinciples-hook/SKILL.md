---
name: reactprinciples-hook
description: Scaffold a custom React hook following React Principles custom-hooks recipe. Invoke when the user says "create a custom hook", "scaffold a hook", or asks for a hook to encapsulate logic. Generates the hook file with proper naming (use prefix), TypeScript types, a stable return shape, and a colocated test file. Places the hook in src/shared/hooks/ for cross-feature use or src/features/<x>/hooks/ for feature-specific.
allowed-tools: Read, Write, Glob
---

# React Principles — Custom Hook Scaffold

You scaffold a custom React hook following the [Custom Hooks](https://reactprinciples.dev/cookbook/custom-hooks) recipe.

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

Read an existing hook for reference:

```
src/shared/hooks/useDebounce.ts
src/shared/hooks/useDebounce.test.ts
```

Match the conventions you find.

## Template

For a hook `use<Name>` with arguments `(arg: ArgType)`:

```ts
import { useState, useEffect } from "react";

/**
 * <One-line description of what the hook does and when to use it.>
 *
 * @example
 *   const result = use<Name>(input);
 */
export function use<Name>(arg: ArgType): ReturnType {
  // hook body
}
```

Adjust:
- Replace `useState, useEffect` with whatever React APIs are needed
- For React Query hooks → use `reactprinciples-query` skill instead
- For Zustand store hooks → use `reactprinciples-store` skill instead
- For form hooks → use `reactprinciples-form` skill instead

## Test file

Always generate a colocated test:

```ts
// use<Name>.test.ts
import { describe, it, expect } from "vitest";
import { renderHook } from "@testing-library/react";
import { use<Name> } from "./use<Name>";

describe("use<Name>", () => {
  it("returns the expected value for the basic case", () => {
    const { result } = renderHook(() => use<Name>(/* args */));
    expect(result.current).toBe(/* expected */);
  });
});
```

The test should at least verify the simplest happy path. Don't generate exhaustive tests — leave that to the user.

## Return shape rules

- **Single value** — `return result;` (e.g., debounced value)
- **Tuple** — `return [value, setter] as const;` (only when there's a clear ordering, like state hooks)
- **Object** — `return { data, isLoading, error };` (when there are 2+ named return values)
- **Never** return more than 4 values — split the hook if it grows that big

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

## Reference

See [Custom Hooks recipe](https://reactprinciples.dev/cookbook/custom-hooks) and existing hooks in `src/shared/hooks/`.
