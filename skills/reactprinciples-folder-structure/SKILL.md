---
name: reactprinciples-folder-structure
description: Scaffold a feature-sliced folder structure for a new feature in a React project following the React Principles cookbook. Invoke when the user says "create a new feature", "scaffold feature folder", or asks about React Principles folder structure. Creates the directory layout (components, hooks, stores, data) with barrel index.ts files at appropriate levels. Does not generate component bodies — only the structure.
allowed-tools: Read, Write, Bash, Glob
---

# React Principles — Feature Folder Structure

You scaffold a new feature folder following the [feature-sliced architecture](https://reactprinciples.dev/cookbook/folder-structure) pattern documented in the React Principles cookbook.

## When to invoke

- User asks to "create a new feature called X"
- User asks for "feature folder structure" or "feature scaffolding"
- User asks where files should go for a new feature

## Inputs needed

Ask the user for:

1. **Feature name** — lowercase, hyphenated if multi-word (e.g., `users`, `team-settings`)
2. **What the feature contains** — which of the following the feature needs:
   - Components (almost always yes)
   - Hooks (common)
   - Stores (only if feature has client state)
   - Data / API services (only if feature has its own server data)

If the user gives only the name, default to creating `components/` and `hooks/`. Confirm before scaffolding if more is needed.

## What to read first

Before generating, look at an existing feature for reference:

```
src/features/examples/    # or any existing feature
```

Match the conventions you find there — barrel export style, folder casing, file naming.

## Structure to generate

For a feature named `<feature>`, create:

```
src/features/<feature>/
├── index.ts                          # barrel — re-exports public API
├── components/
│   └── index.ts                      # barrel for components
├── hooks/                            # optional
│   └── index.ts
├── stores/                           # optional
│   └── index.ts
└── data/                             # optional
    └── index.ts
```

Each `index.ts` starts empty (or with a comment placeholder), to be filled as the feature grows.

## Barrel export rules

- `index.ts` at feature root re-exports the **public API only** — components and hooks that other features may consume
- Internal types, utilities, and stores are NOT re-exported from the root barrel
- Stores require `'use client'` — but the directive goes on the store file itself, NEVER on `index.ts` barrels

## After generating

Tell the user:
1. The folder structure that was created
2. Where to add their first component / hook / store
3. The import path other features should use: `import { ... } from '@/features/<feature>'`

## What you should NOT do

- Don't generate actual components or hooks — that's a separate skill (`reactprinciples-component`, `reactprinciples-hook`)
- Don't create a `utils/` folder at the feature level — cross-cutting utilities belong in `@/shared/utils/`
- Don't put barrel exports inside subfolders if there's only one file in them

## Reference

See [Folder Structure recipe](https://reactprinciples.dev/cookbook/folder-structure) for the full rationale.
