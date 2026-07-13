---
name: reactprinciples-form
description: Scaffold a React Hook Form + Zod form following React Principles form-validation recipe. Invoke when the user says "create a form", "scaffold a validation form", or mentions React Hook Form and Zod. Generates a Zod schema (or reuses an existing one with .omit/.pick/.extend), a typed form component with zodResolver, field error display, and integration with a React Query mutation. Handles both create and edit form variants.
allowed-tools: Read, Write, Glob, WebFetch
---

# React Principles — Form Scaffold

You scaffold a React Hook Form + Zod form following the [Form Validation with Zod](https://www.reactprinciples.dev/cookbook/form-validation) recipe.

## Step 0 — Load the live recipe (required)

Do this before anything else. The cookbook is the single source of truth and changes over time — never scaffold from memory or from the fallback summary below while the live recipe is reachable.

1. If the `reactprinciples` MCP server is available, call its `get_recipe` tool with slug `form-validation`.
2. Otherwise fetch: https://www.reactprinciples.dev/cookbook/form-validation/llms.txt

The fetched recipe contains the principle, rules, canonical pattern code, and implementation examples — treat its rules as requirements, not suggestions. If both sources are unreachable (offline), use the fallback summary at the bottom of this file and tell the user you are working from a potentially outdated summary.

## When to invoke

- User asks to "create a form" for a specific resource
- User asks to "scaffold a validation form"
- User mentions React Hook Form, Zod, or `zodResolver`

## Inputs needed

Ask the user for:

1. **Form purpose** — create, edit, or both
2. **Resource name** — e.g., `User`, `Product`. Used for component naming
3. **Fields** — list of field names with their Zod types (e.g., `name: string min 1`, `email: string email`)
4. **Mutation hook** — which React Query mutation will the form call (e.g., `useCreateUser`, `useUpdateUser`)
5. **Location** — `src/features/<feature>/components/`

## What to read first

Read existing form components and schemas in the user's project:

```
src/features/examples/components/UserForm.tsx       # create form
src/features/examples/components/UserEditForm.tsx   # edit form with pre-populated values
src/shared/utils/validators.ts                       # shared Zod schemas
src/features/examples/hooks/useCreateUser.ts         # mutation hook pattern
```

Check if there's already a shared schema in `src/shared/utils/validators.ts` for this resource. If yes, **reuse it via `.omit()` / `.pick()` / `.extend()`** rather than duplicating.

## How to scaffold

Derive the schema and the form component from the **pattern and implementation code in the recipe you fetched in Step 0**, adapted to the user's resource and fields:

- Follow the recipe's schema strategy: base schema in `src/shared/utils/validators.ts`, create/edit variants derived from it
- Mirror the structure of the existing forms you read, renaming resource and fields
- Apply every rule listed in the fetched recipe

## After generating

Tell the user:
1. The file path created
2. Whether they need to add the schema to `src/shared/utils/validators.ts`
3. Whether the mutation hook (`useCreate<Resource>`, `useUpdate<Resource>`) exists — if not, suggest using `reactprinciples-query` skill
4. Import path: `import { <Resource>Form } from "@/features/<feature>/components/<Resource>Form"`

## What you should NOT do

- Don't put validation logic in `onSubmit` — Zod handles it
- Don't hardcode error messages in JSX — they should come from `formState.errors.<field>.message`
- Don't duplicate schemas — share via `.omit()`, `.pick()`, `.extend()`, `.partial()`
- Don't use Formik, react-final-form, or other form libraries — React Principles uses React Hook Form
- Don't generate raw `<input>` styles inline if a UI primitive exists — recommend using `@/ui/Input`, `@/ui/NativeSelect`, etc.

## Fallback summary (only if Step 0 fails)

May be outdated — the live recipe always wins.

- The Zod schema is the single source of truth; error messages live in the schema, never in JSX
- Use `zodResolver` from `@hookform/resolvers/zod`; wrap mutation calls in `handleSubmit`
- Derive create/edit variants from a shared base schema via `.omit()` / `.partial()` / `.pick()`
- `'use client'` at the top; button state from `formState.isSubmitting`
- `reset()` after a successful create; `useEffect` + `reset(data)` to pre-populate edit forms

## Reference

See [Form Validation with Zod recipe](https://www.reactprinciples.dev/cookbook/form-validation) and existing forms in `src/features/examples/components/`.
