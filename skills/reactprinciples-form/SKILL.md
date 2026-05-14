---
name: reactprinciples-form
description: Scaffold a React Hook Form + Zod form following React Principles form-validation recipe. Invoke when the user says "create a form", "scaffold a validation form", or mentions React Hook Form and Zod. Generates a Zod schema (or reuses an existing one with .omit/.pick/.extend), a typed form component with zodResolver, field error display, and integration with a React Query mutation. Handles both create and edit form variants.
allowed-tools: Read, Write, Glob
---

# React Principles — Form Scaffold

You scaffold a React Hook Form + Zod form following the [Form Validation with Zod](https://reactprinciples.dev/cookbook/form-validation) recipe.

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

Read existing form components and schemas:

```
src/features/examples/components/UserForm.tsx       # create form
src/features/examples/components/UserEditForm.tsx   # edit form with pre-populated values
src/shared/utils/validators.ts                       # shared Zod schemas
src/features/examples/hooks/useCreateUser.ts         # mutation hook pattern
```

Check if there's already a shared schema in `src/shared/utils/validators.ts` for this resource. If yes, **reuse it via `.omit()` / `.pick()` / `.extend()`** rather than duplicating.

## Schema strategy

The Zod schema is the **single source of truth** for validation. Error messages live in the schema, not in the JSX.

```ts
// In src/shared/utils/validators.ts — base schema
export const userSchema = z.object({
  id:        z.string().min(1, "ID is required"),
  name:      z.string().min(1, "Name is required"),
  email:     z.string().email("Enter a valid email"),
  role:      z.enum(["admin", "editor", "viewer"]),
  status:    z.enum(["active", "inactive"]),
  createdAt: z.string().datetime(),
});

// In the form file — derive create/edit variants
const createUserFormSchema = userSchema.omit({ id: true, createdAt: true });
const editUserFormSchema = createUserFormSchema.partial();
```

Use `.omit()` to remove server-generated fields, `.partial()` for edit forms where all fields are optional, `.pick()` to subset for narrower forms.

## Templates

### Create form

```tsx
"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { type z } from "zod";
import { userSchema } from "@/shared/utils/validators";
import { useCreate<Resource> } from "@/features/<feature>/hooks/useCreate<Resource>";

const create<Resource>FormSchema = userSchema.omit({ id: true, createdAt: true });
type Create<Resource>FormValues = z.infer<typeof create<Resource>FormSchema>;

export function <Resource>Form() {
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<Create<Resource>FormValues>({
    resolver: zodResolver(create<Resource>FormSchema),
    defaultValues: {
      // sensible defaults per field
    },
  });

  const create<Resource> = useCreate<Resource>();

  const onSubmit = async (data: Create<Resource>FormValues) => {
    await create<Resource>.mutateAsync(data);
    reset();
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
      <div>
        <label htmlFor="name">Name</label>
        <input id="name" type="text" {...register("name")} />
        {errors.name && <p className="text-red-600">{errors.name.message}</p>}
      </div>

      {/* ... other fields ... */}

      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? "Saving..." : "Create"}
      </button>
    </form>
  );
}
```

### Edit form (pre-populated)

```tsx
"use client";

import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { type z } from "zod";
import { userSchema } from "@/shared/utils/validators";
import { use<Resource> } from "@/features/<feature>/hooks/use<Resource>";
import { useUpdate<Resource> } from "@/features/<feature>/hooks/useUpdate<Resource>";

const edit<Resource>FormSchema = userSchema.omit({ id: true, createdAt: true });
type Edit<Resource>FormValues = z.infer<typeof edit<Resource>FormSchema>;

export function <Resource>EditForm({ id }: { id: string }) {
  const { data: <resource>, isLoading } = use<Resource>(id);
  const update<Resource> = useUpdate<Resource>(id);

  const { register, handleSubmit, reset, formState: { errors, isSubmitting } } =
    useForm<Edit<Resource>FormValues>({
      resolver: zodResolver(edit<Resource>FormSchema),
    });

  // Pre-populate when data loads
  useEffect(() => {
    if (<resource>) {
      reset({ /* map fields from <resource> */ });
    }
  }, [<resource>, reset]);

  const onSubmit = async (data: Edit<Resource>FormValues) => {
    await update<Resource>.mutateAsync(data);
  };

  if (isLoading) return <p>Loading...</p>;
  if (!<resource>) return <p>Not found</p>;

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* fields */}
    </form>
  );
}
```

## Rules embedded in the templates

1. **`'use client'` at top** — forms are interactive client components
2. **`zodResolver(schema)`** — schema drives validation
3. **Error messages from schema** — never hardcoded in JSX
4. **`reset()` after success** — clears form for create flows
5. **`useEffect` + `reset(data)` for edit pre-populate** — runs once data loads
6. **`isSubmitting` for button state** — comes from `formState`

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

## Reference

See [Form Validation with Zod recipe](https://reactprinciples.dev/cookbook/form-validation) and existing forms in `src/features/examples/components/`.
