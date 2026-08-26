---
name: reactprinciples-recipe
description: Draft a new React Principles cookbook recipe in the standard structure. Internal maintainer skill.
disable-model-invocation: true
allowed-tools: Read, Write, Glob
---

# React Principles — Draft New Recipe (internal)

You draft a new cookbook recipe for the [React Principles](https://www.reactprinciples.dev) project. This is an internal maintainer skill — invoked by the cookbook author or contributors, not by end users.

## When to invoke

- User says "draft a new recipe" or "create a recipe for X"
- User asks to add a new cookbook topic
- User asks for a recipe template

## Inputs needed

Ask the user for:

1. **Recipe slug** — lowercase, hyphenated (e.g., `error-boundaries`, `data-visualization`)
2. **Recipe title** — full title (e.g., "Error Boundaries in React")
3. **Category** — one of:
   - `Foundations` — fundamental concepts (TypeScript, components, hooks, state)
   - `Patterns` — applied techniques (server state, forms, tables)
   - `Auth Flows`, `Data Viz`, `API Integration`, `Dashboards`, `Landing Pages` — domain-specific
4. **One-sentence description** — shown in the recipe card
5. **Principle statement** — the core opinion of the recipe (what to do and why)
6. **3-5 rules** — concrete guidelines that follow from the principle
7. **Pattern code** — a representative code example (filename + code)
8. **Implementation context** — does the recipe need separate Next.js and Vite implementations, or is the pattern framework-agnostic?

If the user doesn't have all the details ready, generate a scaffold with TODO comments where they need to fill in.

## What to read first

Read existing recipes for structural reference:

```
src/features/cookbook/data/recipes/server-state.ts
src/features/cookbook/data/recipes/client-state.ts
src/features/cookbook/data/recipes/form-validation.ts
src/features/cookbook/data/recipes/data-tables.ts
src/features/cookbook/data/recipes/api-integration.ts
src/features/cookbook/data/types.ts
```

Match the `RecipeDetail` type exactly.

## Template

File: `src/features/cookbook/data/recipes/<slug>.ts`

```ts
import type { RecipeDetail } from "@/features/cookbook/data/types";

export const <camelCaseSlug>: RecipeDetail = {
  slug: "<slug>",
  title: "<Title>",
  breadcrumbCategory: "<Category>",
  description:
    "<One-sentence description.>",
  principle: {
    text: "<The core principle. State what to do and why, in 1-3 sentences.>",
    tip: "<One actionable tip developers should remember.>",
  },
  rules: [
    { title: "<Rule 1 title>", description: "<One-sentence rule.>" },
    { title: "<Rule 2 title>", description: "<One-sentence rule.>" },
    { title: "<Rule 3 title>", description: "<One-sentence rule.>" },
  ],
  pattern: {
    filename: "<filename>.tsx",
    code: \`<pattern code as backtick-quoted string>\`,
  },
  implementation: {
    nextjs: {
      description:
        "<How this is applied in Next.js App Router context. 1-2 sentences.>",
      filename: "<path/filename>.tsx",
      code: \`<Next.js-specific implementation code>\`,
    },
    vite: {
      description:
        "<How this differs (or doesn't) in Vite context. 1-2 sentences.>",
      filename: "<path/filename>.tsx",
      code: \`<Vite-specific implementation code>\`,
    },
  },
  lastUpdated: "<Month DD, YYYY — today's date>",
  contributor: { name: "Singgih Budi Purnadi", role: "Frontend & Mobile Developer" },
  // demoKey: "<key>", // uncomment if a live demo exists
};
```

## Rules for the draft

1. **Code blocks use plain backtick-quoted strings** — not template literals (no `${}` expansions), so the code is shown literally in the cookbook UI
2. **Filenames in pattern/implementation use paths relative to project root** — e.g., `components/UserForm.tsx`, not `./UserForm.tsx`
3. **`lastUpdated` uses long-form date** — e.g., "May 14, 2026"
4. **Principle and rules are opinionated** — recipes are not neutral references, they take a stance
5. **Vite implementation is OPTIONAL** — if pattern is framework-agnostic, the vite section can mirror nextjs section or be omitted (check existing recipes for whether to include)

## After generating

Tell the user:

1. The file path created
2. Reminder to register the recipe in `src/features/cookbook/data/cookbook-data.ts`:
   - Add to `RECIPES` array with `status: "coming-soon"` initially
   - Set `order` to the next available number
   - Choose appropriate `icon`, `gradient`, `tags`, `category`
3. Reminder to export from `src/features/cookbook/data/index.ts` if there's a barrel
4. Reminder to flip status to `"published"` only after content is final and verified

## Audit / quality checklist

After drafting, the recipe should be audited via the `reactprinciples-audit-recipe` skill before publishing. Mention this to the user.

## What you should NOT do

- Don't generate the `cookbook-data.ts` entry automatically — the maintainer chooses ordering, tags, and gradient. Just tell them what fields to fill.
- Don't set `status: "published"` — new recipes start as `"coming-soon"` until reviewed
- Don't invent code examples that aren't representative of the actual codebase — read existing files first

## Reference

See existing recipes for structural and tonal reference. The cookbook lives at [reactprinciples.dev/cookbook](https://www.reactprinciples.dev/cookbook).
