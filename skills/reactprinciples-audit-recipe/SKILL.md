---
name: reactprinciples-audit-recipe
description: Audit an existing React Principles cookbook recipe for accuracy against the actual codebase. Invoke when the user (as a cookbook maintainer) says "audit recipe X", "check recipe accuracy", or "verify recipe is up to date". Reads the recipe file, checks every import path and pattern claim against the real codebase, flags discrepancies, and reports findings with fix suggestions. This is an internal maintainer skill — not promoted to end users.
allowed-tools: Read, Grep, Glob
---

# React Principles — Audit Cookbook Recipe (internal)

You audit an existing cookbook recipe against the real codebase to ensure accuracy. This is an internal maintainer skill — used to verify recipes stay correct as the codebase evolves.

## When to invoke

- User says "audit recipe <slug>" or "check recipe X"
- User asks whether a recipe is still accurate
- User mentions Issue #53 (living issue tracking applied recipe audits)

## Inputs needed

Ask the user for:

1. **Recipe slug** — e.g., `server-state`, `client-state`, `form-validation`
2. **Audit scope** (optional):
   - **Quick** — only verify import paths and obvious breakages
   - **Full** — verify principles, rules, pattern code, and implementation match actual codebase patterns (default)

## What to read first

Read the recipe and the type definition:

```
src/features/cookbook/data/recipes/<slug>.ts
src/features/cookbook/data/types.ts
```

Then enumerate referenced files for verification:

```
src/features/cookbook/data/cookbook-data.ts   # check status, slug match, order
```

## Audit checklist

Walk through every item systematically. Use `Grep` and `Glob` for cross-codebase verification.

### 1. Recipe registration

- [ ] Slug in `cookbook-data.ts` matches the file's `slug`
- [ ] Title matches
- [ ] Category matches
- [ ] `status` is `"published"` if the recipe should be live (or `"coming-soon"` intentionally)

### 2. Import paths in pattern code

For every `import ... from "@/..."` mentioned in `pattern.code`:

- [ ] The file at that path exists
- [ ] The named export from that path exists
- [ ] No outdated paths (e.g., `@/types` when actual is `@/shared/types/common`)
- [ ] No fictional packages or modules

### 3. Import paths in implementation code

Same checks for `implementation.nextjs.code` and `implementation.vite.code`:

- [ ] All `@/`-aliased imports point to real files
- [ ] All imported symbols are actually exported

### 4. Pattern accuracy

- [ ] Pattern code reflects the actual patterns used in the codebase (not aspirational or outdated)
- [ ] If the recipe says "use X factory", check that X actually exists and is used
- [ ] If the recipe references a specific hook/component name, check it exists with that exact name

### 5. Implementation accuracy

- [ ] Next.js implementation reflects current Next.js conventions (App Router, route handlers, etc.)
- [ ] Vite implementation reflects current Vite conventions (or matches Next.js if framework-agnostic)
- [ ] No references to removed APIs (e.g., `keepPreviousData` in React Query v5 — should be `placeholderData`)

### 6. Rules consistency

- [ ] Each rule is enforced or recommended by the actual codebase
- [ ] Rules don't contradict newer recipes (e.g., a rule against `useShallow` would contradict updated client-state recipe)

### 7. Metadata

- [ ] `lastUpdated` is reasonably current (flag if > 3 months old AND any code changes were found)
- [ ] `demoKey` (if present) maps to a working demo
- [ ] `contributor` info is correct

## Severity classification

- **Critical** — broken imports, fictional exports, fundamentally wrong patterns. Recipe is misleading to readers.
- **Major** — outdated patterns that still work but don't reflect current best practice. Should be updated.
- **Minor** — stale dates, slight wording inconsistencies, missing optional fields.

## Output format

```markdown
# Recipe audit: <slug>

**Recipe file:** \`src/features/cookbook/data/recipes/<slug>.ts\`
**Status:** <published | coming-soon>
**Last updated:** <date>

## Findings

### Critical

1. **<file>:<line> — <one-line summary>**
   - Where in recipe: \`pattern.code\` / \`implementation.nextjs.code\` / etc.
   - Problem: <one-sentence explanation>
   - Actual codebase state: <what's really there>
   - Suggested fix: <concrete suggestion>

### Major / Minor

(same format)

## Summary

- Critical: <count>
- Major: <count>
- Minor: <count>
- Overall: <ready to ship | needs major fixes | minor polish>
```

## What you should NOT do

- Don't modify the recipe file directly (`allowed-tools` does not include Write or Edit)
- Don't update `cookbook-data.ts` — only flag discrepancies
- Don't make subjective stylistic suggestions ("I think this could be worded better") — focus on factual accuracy
- Don't audit recipes that don't exist — if the slug doesn't match a file, ask the user to confirm

## Related

- Issue #53 in the main repo tracks the audit status of applied recipes — refer to it for context

## Reference

See [Cookbook recipe types](https://github.com/sindev08/react-principles/blob/main/src/features/cookbook/data/types.ts) for the `RecipeDetail` structure that every recipe must conform to.
