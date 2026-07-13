---
name: reactprinciples-query
description: Scaffold a TanStack Query (React Query) hook following React Principles server-state recipe. Invoke when the user says "create a React Query hook", "fetch data with useQuery", or asks for server state management. Generates the query hook with staleTime, placeholderData, enabled flag where appropriate, plus pairs with a service method and the queryKeys factory. Use for server data only — client state belongs in Zustand.
allowed-tools: Read, Write, Glob, WebFetch
---

# React Principles — React Query Hook Scaffold

You scaffold a TanStack Query (React Query) hook following the [Server State with React Query](https://www.reactprinciples.dev/cookbook/server-state) recipe.

## Step 0 — Load the live recipe (required)

Do this before anything else. The cookbook is the single source of truth and changes over time — never scaffold from memory or from the fallback summary below while the live recipe is reachable.

1. If the `reactprinciples` MCP server is available, call its `get_recipe` tool with slug `server-state`. When the task touches the service/API-client layer, also fetch `api-integration`.
2. Otherwise fetch: https://www.reactprinciples.dev/cookbook/server-state/llms.txt (and https://www.reactprinciples.dev/cookbook/api-integration/llms.txt when relevant)

The fetched recipe contains the query rules (staleTime, placeholderData, enabled, invalidation) and canonical pattern code for every query type — treat its rules as requirements, not suggestions. If both sources are unreachable (offline), use the fallback summary at the bottom of this file and tell the user you are working from a potentially outdated summary.

## When to invoke

- User asks to "create a query hook" or "fetch data from an API"
- User asks for `useQuery` / `useMutation` scaffolding
- User mentions TanStack Query, React Query, or server state

## Critical check first

**Before generating, confirm with the user that this is server state, not client state.**

- ✅ Use React Query for: API responses, paginated lists, user data fetched from server, search results
- ❌ Do NOT use React Query for: UI toggles, filter state, theme — use Zustand instead (`reactprinciples-store` skill)

## Inputs needed

Ask the user for:

1. **Hook name** — camelCase starting with `use` (e.g., `useUsers`, `useUser`, `useSearchUsers`)
2. **Query type** — list, detail, debounced search, or mutation
3. **Service method** — which method on which service (e.g., `usersService.getAll`, `usersService.getById`)
4. **Query key** — which key from `queryKeys` factory (e.g., `queryKeys.users.list(params)`)
5. **Location** — `src/features/<feature>/hooks/`

## What to read first

Read existing hooks in the user's project for reference:

```
src/features/examples/hooks/useUsers.ts       # list with staleTime + placeholderData
src/features/examples/hooks/useUser.ts        # detail with enabled
src/features/examples/hooks/useSearchUsers.ts # debounced search
src/features/examples/hooks/useCreateUser.ts  # mutation with invalidation
src/lib/query-keys.ts                          # query keys factory
src/lib/services/users.ts                      # service layer
```

Confirm `queryKeys` has the needed entry — if not, instruct the user to add it.

## How to scaffold

Derive the hook from the **pattern code for the matching query type in the recipe you fetched in Step 0**, wired to the user's service method and query key, and shaped to match the existing hooks you read.

## After generating

Tell the user:
1. The file path created
2. Import path: `import { use<Resources> } from "@/features/<feature>/hooks/use<Resources>"`
3. If `queryKeys.<resource>` doesn't exist yet, instruct them to add it to `src/lib/query-keys.ts`
4. If the service method doesn't exist yet, instruct them to add it to the appropriate service file
5. Suggest pairing with `HydrationBoundary` + `dehydrate` for SSR prefetch in Next.js page components

## What you should NOT do

- Don't use `fetch()` or `axios` directly in the hook — call a service method that uses `createApiClient`
- Don't omit `staleTime` — explicit is better than relying on defaults
- Don't put the query hook in `src/components/` — hooks go in `src/features/<x>/hooks/`
- Don't mix server state (React Query) and client state (Zustand) in the same hook

## Fallback summary (only if Step 0 fails)

May be outdated — the live recipe always wins.

- Always set `staleTime` explicitly (minutes, not zero); `placeholderData: (prev) => prev` for paginated lists
- `enabled` flag for dependent queries (`enabled: !!id`, `enabled: query.length > 0` for search)
- Mutations invalidate the relevant cache: `void queryClient.invalidateQueries({ queryKey: ... })`
- The chain is service → hook → component; hooks call typed service methods, never `fetch` directly

## Reference

See [Server State with React Query recipe](https://www.reactprinciples.dev/cookbook/server-state) and existing hooks in `src/features/examples/hooks/`.
