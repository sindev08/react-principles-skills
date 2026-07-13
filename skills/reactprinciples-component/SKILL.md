---
name: reactprinciples-component
description: Scaffold a React UI component following React Principles anatomy patterns. Invoke when the user says "create a component", "make a Button-style component", or asks for a new UI primitive. Generates a self-contained component file with props extending native HTML element attributes, variants/sizes as Record constants, cn() for class merging, and a colocated Storybook story file. Matches the patterns in src/ui/.
allowed-tools: Read, Write, Glob, WebFetch
---

# React Principles — Component Scaffold

You scaffold a UI component following the [Component Anatomy](https://www.reactprinciples.dev/cookbook/component-anatomy) recipe. The result is a single, self-contained component file matching the conventions in `src/ui/`.

## Step 0 — Load the live recipe (required)

Do this before anything else. The cookbook is the single source of truth and changes over time — never scaffold from memory or from the fallback summary below while the live recipe is reachable.

1. If the `reactprinciples` MCP server is available, call its `get_recipe` tool with slug `component-anatomy`. When the task involves composition decisions (children, slots, render props), also fetch `component-composition`.
2. Otherwise fetch: https://www.reactprinciples.dev/cookbook/component-anatomy/llms.txt (and https://www.reactprinciples.dev/cookbook/component-composition/llms.txt when relevant)

The fetched recipe contains the anatomy rules and canonical pattern code — treat its rules as requirements, not suggestions. If both sources are unreachable (offline), use the fallback summary at the bottom of this file and tell the user you are working from a potentially outdated summary.

## When to invoke

- User asks to "create a component called X"
- User asks to scaffold a UI primitive (Button-, Card-, Input-style)
- User asks for a new component matching React Principles patterns

## Inputs needed

Ask the user for:

1. **Component name** — PascalCase (e.g., `Toolbar`, `EmptyState`)
2. **HTML element it wraps** — e.g., `button`, `div`, `input`, `span`. Determines which HTMLAttributes interface to extend.
3. **Variants** (optional) — list of variant names (e.g., `primary`, `secondary`, `ghost`). Skip if no variants needed.
4. **Sizes** (optional) — list of size names (e.g., `sm`, `md`, `lg`). Skip if no sizes needed.
5. **Location** — `src/ui/` for shared primitives, or `src/features/<feature>/components/` for feature-specific. Default to `src/ui/`.

## What to read first

Always read at least one existing component in the user's project for reference. `Button.tsx` is the canonical example:

```
src/ui/Button.tsx
```

## How to scaffold

Derive the component from the **pattern code in the recipe you fetched in Step 0**, shaped to match the existing component you read:

- Extend the correct HTMLAttributes interface for the wrapped element
- Only include variant/size machinery the user asked for
- Match the local file conventions exactly (section comments, export style, ref forwarding)

If the project uses Storybook (check for `src/ui/*.stories.tsx`), create a matching `<Name>.stories.tsx` alongside, mirroring an existing story file.

## After generating

Tell the user:
1. The file path(s) created
2. How to import: `import { <Name> } from "@/ui/<Name>"` (or feature path)
3. Whether they need to add the component to a barrel `index.ts`
4. A reminder to add the docs page at `src/app/docs/<kebab-name>/page.tsx` if it's a shared UI primitive

## What you should NOT do

- Don't use `cva` or `class-variance-authority` — React Principles uses `Record<>` constants instead
- Don't write Tailwind classes with template literals — use `cn()` for dynamic classes
- Don't put the component in `src/components/` — that folder doesn't exist in this convention. Use `src/ui/` or `src/features/<x>/components/`
- Don't generate tests by default — only if the user explicitly asks

## Fallback summary (only if Step 0 fails)

May be outdated — the live recipe always wins.

- Props extend the native element's HTMLAttributes (e.g., `interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement>`)
- Variants and sizes are `Record<VariantType, string>` constants, not cva
- All dynamic class merging goes through `cn()` from `@/shared/utils/cn`
- Prefer composition (children, slot components) over boolean configuration props

## Reference

See [Component Anatomy recipe](https://www.reactprinciples.dev/cookbook/component-anatomy) and existing components in `src/ui/`.
