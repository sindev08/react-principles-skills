---
name: reactprinciples-folder-structure
description: Scaffold a feature-sliced folder structure for a new feature — components, hooks, stores, data with barrel index.ts files.
when_to_use: "Use when creating, scaffolding, or setting up a new feature folder — e.g. 'bikin folder fitur baru', 'scaffold feature folder', 'create a new feature called users', 'setup folder checkout', 'butuh struktur folder'. Do NOT use for debugging, explaining, or reviewing existing folder structures."
allowed-tools: Read, Write, Bash, Glob, WebFetch
---

# React Principles — Feature Folder Structure

You scaffold a new feature folder following the [feature-sliced architecture](https://www.reactprinciples.dev/cookbook/folder-structure) pattern documented in the React Principles cookbook.

## Step 0 — Load the live recipe (required)

Do this before anything else. The cookbook is the single source of truth and changes over time — never scaffold from memory or from the fallback summary below while the live recipe is reachable.

1. If the `reactprinciples` MCP server is available, call its `get_recipe` tool with slug `folder-structure`.
2. Otherwise fetch: https://www.reactprinciples.dev/cookbook/folder-structure/llms.txt

The fetched recipe contains the directory layout, barrel export rules, and rationale — treat its rules as requirements, not suggestions. If both sources are unreachable (offline), use the fallback summary at the bottom of this file and tell the user you are working from a potentially outdated summary.

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

Before generating, look at an existing feature in the user's project for reference:

```
src/features/examples/    # or any existing feature
```

Match the conventions you find there — barrel export style, folder casing, file naming.

## How to scaffold

Create the directory layout exactly as described in the recipe you fetched in Step 0, limited to the parts the user asked for. Follow the recipe's barrel export rules for where `index.ts` files go and what they may re-export.

## After generating

Tell the user:
1. The folder structure that was created
2. Where to add their first component / hook / store
3. The import path other features should use: `import { ... } from '@/features/<feature>'`

## Adapt to the existing repo

Match the conventions already in this project. Where the project's folder structure differs from the cookbook pattern, follow the project and note the difference once — do not force the cookbook approach.

Non-negotiable (correctness, not taste): feature folders go in `src/features/`, shared code in `src/shared/`, UI primitives in `src/ui/`.

## What you should NOT do

- Don't generate actual components or hooks — that's a separate skill (`reactprinciples-component`, `reactprinciples-hook`)
- Don't create a `utils/` folder at the feature level — cross-cutting utilities belong in `@/shared/utils/`
- Don't put barrel exports inside subfolders if there's only one file in them

## Fallback summary (only if Step 0 fails)

⚠️ Working from offline summary — live recipe may be more current.

- Features live in `src/features/<feature>/` with optional `components/`, `hooks/`, `stores/`, `data/` subfolders, each with a barrel `index.ts`
- The root barrel re-exports the public API only — internal types, utilities, and stores stay private
- `'use client'` goes on the store/component file itself, never on `index.ts` barrels
- Shared code belongs in `src/shared/`, UI primitives in `src/ui/`

## Reference

See [Folder Structure recipe](https://www.reactprinciples.dev/cookbook/folder-structure) for the full rationale.
