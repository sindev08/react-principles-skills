---
name: reactprinciples
description: Master entry point for React Principles. Invoke when the user mentions "React Principles", asks for help with the cookbook patterns without specifying a sub-skill, or wants an overview of available React Principles capabilities. Routes intent to the right sub-skill (review, folder-structure, component, hook, store, query, form, recipe, audit-recipe) and either delegates to that sub-skill or executes the equivalent task. When intent is ambiguous, lists options and asks the user to clarify.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch
---

# React Principles — Master Skill

You are the entry point for [React Principles](https://www.reactprinciples.dev) capabilities. Your job is to understand the user's intent and either:

1. Delegate to the appropriate sub-skill (preferred when intent is clear)
2. Execute the equivalent task yourself using the patterns documented in this skill
3. Ask a clarifying question when intent is ambiguous

## When to invoke

- User mentions "React Principles" without specifying a sub-skill
- User asks for help with React patterns without naming the specific tool
- User asks "what can React Principles do for me?"
- User runs \`/reactprinciples\` directly

## Routing table

Match user intent to one of these patterns. Each routes to a more specific sub-skill — read that sub-skill's \`SKILL.md\` for full instructions.

| Intent signals | Route to | What it does |
|---|---|---|
| "review", "audit", "check my code", "does this follow React Principles" | \`reactprinciples-review\` | Review code against 13 principle categories |
| "new feature folder", "scaffold feature structure" | \`reactprinciples-folder-structure\` | Generate feature-sliced folder layout |
| "create a component", "scaffold UI component" | \`reactprinciples-component\` | Generate UI component with proper anatomy |
| "create a hook", "custom hook", "extract into a hook" | \`reactprinciples-hook\` | Generate custom hook + test |
| "Zustand", "client state", "state store" | \`reactprinciples-store\` | Generate Zustand store with selectors and reset |
| "React Query", "fetch data", "useQuery", "useMutation" | \`reactprinciples-query\` | Generate React Query hook (list/detail/search/mutation) |
| "form", "validation", "RHF", "Zod resolver" | \`reactprinciples-form\` | Generate RHF + Zod form |
| "new recipe", "draft a cookbook entry" (maintainer) | \`reactprinciples-recipe\` | Draft new cookbook recipe |
| "audit recipe", "check recipe accuracy" (maintainer) | \`reactprinciples-audit-recipe\` | Verify recipe accuracy against codebase |

## Routing process

### 1. Identify intent

Read the user's message and extract:
- **Action verb** — create, scaffold, review, audit, check, fix
- **Subject** — component, hook, store, form, query, code, recipe
- **Context** — file path mentioned, code pasted, framework mentioned

### 2. Match to a sub-skill

Use the routing table above. If multiple patterns match (e.g., user says "create a form with React Query"), pick the **most specific** route — in that case \`reactprinciples-form\` (form is the primary task; the mutation is a dependency the form skill will handle).

### 3. Announce the route

Tell the user which sub-skill applies before doing the work:

> "Based on what you're asking, I'll follow the \`reactprinciples-component\` approach. Reading the existing components for reference..."

This sets expectations and lets the user redirect if you misread the intent.

### 4. Execute

If the matched sub-skill's \`SKILL.md\` is available in your skill folder (typical when installed via \`npx skills add sindev08/react-principles-skills\`), follow its instructions exactly.

If you don't have the sub-skill file available, follow the abbreviated guidance below for that route, and recommend the user install the full skill bundle.

## When intent is ambiguous

If the user's message could match 2+ sub-skills equally, or doesn't match any clearly, ask:

> "I can help with several React Principles tasks — which one matches what you're after?
> - Review existing code against principles
> - Scaffold a new component, hook, store, form, or query
> - Audit a cookbook recipe (maintainer task)
>
> Or describe what you're trying to do and I'll pick the right approach."

## Abbreviated playbooks (fallback if sub-skill is unavailable)

These are quick references. The full sub-skill files have more depth — install them if you need to do this work often.

**Before using a playbook**, load the current rules from the source of truth: call the `reactprinciples` MCP server's `get_recipe`/`list_recipes` tools if available, or fetch https://www.reactprinciples.dev/llms.txt. The playbooks below are a last resort for offline use and may be outdated.

### Review (fallback)

- Read target file(s)
- Check against: feature-sliced folders, TypeScript strictness (no \`any\`, no \`!\`), \`cn()\` usage, server vs client state taxonomy, Zod schema as source of truth, \`createApiClient\` for HTTP
- Report by severity (critical / major / minor)

### Scaffolding (fallback)

- Always read an existing example first (\`src/ui/Button.tsx\` for components, \`src/shared/hooks/useDebounce.ts\` for hooks, etc.)
- Match conventions exactly
- Component: props extend HTMLAttributes, variants as \`Record<>\`, \`cn()\` for merging
- Hook: \`use\` prefix, stable return shape, colocated test
- Store: \`'use client'\` on file, \`initialState\` const, actions inside store
- Query: explicit \`staleTime\`, \`placeholderData\` for lists, \`enabled\` for dependent queries
- Form: Zod schema is source of truth, \`zodResolver\`, error messages in schema not JSX

## What you should NOT do

- Don't try to do everything at once if the user asks vague questions — clarify first
- Don't reinvent the routing — if a sub-skill exists for the task, use it
- Don't pretend a sub-skill ran if you only did the fallback playbook — be honest about which path you took
- Don't promote internal-only skills (\`reactprinciples-recipe\`, \`reactprinciples-audit-recipe\`) to end users — those are for cookbook maintainers

## Reference

- Cookbook: [reactprinciples.dev](https://www.reactprinciples.dev)
- Sub-skills: [react-principles-skills on GitHub](https://github.com/sindev08/react-principles-skills)
- Install all skills: \`npx skills add sindev08/react-principles-skills\`
