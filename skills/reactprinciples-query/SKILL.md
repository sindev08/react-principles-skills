---
name: reactprinciples-query
description: Scaffold a TanStack Query (React Query) hook following React Principles server-state recipe. Invoke when the user says "create a React Query hook", "fetch data with useQuery", or asks for server state management. Generates the query hook with staleTime, placeholderData, enabled flag where appropriate, plus pairs with a service method and the queryKeys factory. Use for server data only — client state belongs in Zustand.
allowed-tools: Read, Write, Glob
---

# React Principles — React Query Hook Scaffold

You scaffold a TanStack Query (React Query) hook following the [Server State with React Query](https://reactprinciples.dev/cookbook/server-state) recipe.

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
2. **Query type**:
   - **List** — paginated/filtered list (typically uses `staleTime` + `placeholderData`)
   - **Detail** — single resource by id (typically uses `enabled: !!id`)
   - **Search** — debounced search (typically uses `enabled: query.length > 0`)
   - **Mutation** — POST/PUT/PATCH/DELETE (uses `useMutation` + cache invalidation)
3. **Service method** — which method on which service (e.g., `usersService.getAll`, `usersService.getById`)
4. **Query key** — which key from `queryKeys` factory (e.g., `queryKeys.users.list(params)`)
5. **Location** — `src/features/<feature>/hooks/`

## What to read first

Read existing hooks for reference:

```
src/features/examples/hooks/useUsers.ts       # list with staleTime + placeholderData
src/features/examples/hooks/useUser.ts        # detail with enabled
src/features/examples/hooks/useSearchUsers.ts # debounced search
src/features/examples/hooks/useCreateUser.ts  # mutation with invalidation
src/lib/query-keys.ts                          # query keys factory
src/lib/services/users.ts                      # service layer
```

Confirm `queryKeys` has the needed entry — if not, instruct the user to add it.

## Templates

### List query

```ts
import { useQuery } from "@tanstack/react-query";
import { queryKeys } from "@/lib/query-keys";
import { <service>, type Get<Resource>Params } from "@/lib/services/<service-file>";

export function use<Resources>(params: Get<Resource>Params = {}) {
  return useQuery({
    queryKey: queryKeys.<resource>.list(params),
    queryFn: () => <service>.getAll(params),
    staleTime: 1000 * 60 * 5,        // 5 minutes
    placeholderData: (prev) => prev, // smooth pagination
  });
}
```

### Detail query

```ts
import { useQuery } from "@tanstack/react-query";
import { queryKeys } from "@/lib/query-keys";
import { <service> } from "@/lib/services/<service-file>";

export function use<Resource>(id: string) {
  return useQuery({
    queryKey: queryKeys.<resource>.detail(id),
    queryFn: () => <service>.getById(id),
    enabled: !!id,
    staleTime: 1000 * 60 * 10,       // 10 minutes for stable details
  });
}
```

### Debounced search

```ts
import { useQuery } from "@tanstack/react-query";
import { useDebounce } from "@/shared/hooks";
import { queryKeys } from "@/lib/query-keys";
import { <service> } from "@/lib/services/<service-file>";

export function useSearch<Resources>(query: string) {
  const debouncedQuery = useDebounce(query, 300);

  return useQuery({
    queryKey: queryKeys.<resource>.search(debouncedQuery),
    queryFn: () => <service>.search({ q: debouncedQuery }),
    enabled: debouncedQuery.length > 0,
    staleTime: 1000 * 60 * 5,
  });
}
```

### Mutation

```ts
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { queryKeys } from "@/lib/query-keys";
import { <service> } from "@/lib/services/<service-file>";
import type { Create<Resource>Input } from "@/shared/types/<resource>";

export function useCreate<Resource>() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: Create<Resource>Input) => <service>.create(data),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: queryKeys.<resource>.all });
    },
  });
}
```

## Rules embedded in the templates

1. **Always set `staleTime` explicitly** — defaults are too aggressive for most apps. 5 min for lists, 10 min for details is a sensible baseline.
2. **`placeholderData: (prev) => prev`** for paginated lists — prevents layout shift.
3. **`enabled` flag** for dependent queries — never run a query before its input exists.
4. **Mutations invalidate the relevant list cache** via `queryClient.invalidateQueries`.
5. **Void the invalidate** — `void queryClient.invalidateQueries(...)` because we don't await it.

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

## Reference

See [Server State with React Query recipe](https://reactprinciples.dev/cookbook/server-state) and existing hooks in `src/features/examples/hooks/`.
