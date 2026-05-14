---
name: reactprinciples-component
description: Scaffold a React UI component following React Principles anatomy patterns. Invoke when the user says "create a component", "make a Button-style component", or asks for a new UI primitive. Generates a self-contained component file with props extending native HTML element attributes, variants/sizes as Record constants, cn() for class merging, and a colocated Storybook story file. Matches the patterns in src/ui/.
allowed-tools: Read, Write, Glob
---

# React Principles — Component Scaffold

You scaffold a UI component following the [Component Anatomy](https://reactprinciples.dev/cookbook/component-anatomy) recipe. The result is a single, self-contained component file matching the conventions in `src/ui/`.

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

Always read at least one existing component for reference. `Button.tsx` is the canonical example:

```
src/ui/Button.tsx
```

Match the structure exactly:
- File-level section comments (`// ─── Types ──`)
- Interface extending native HTMLAttributes
- `Record<VariantType, string>` constants for variants and sizes
- `cn()` for combining classes
- `forwardRef` if the component needs ref forwarding

## Template

For a component named `<Name>` wrapping `<element>`:

```tsx
import { forwardRef, type <Element>HTMLAttributes } from "react";
import { cn } from "@/shared/utils/cn";

// ─── Types ────────────────────────────────────────────────────────────────────

export type <Name>Variant = "primary" | "secondary";  // adjust to user input
export type <Name>Size = "sm" | "md" | "lg";          // adjust to user input

export interface <Name>Props
  extends <Element>HTMLAttributes<HTML<Element>Element> {
  variant?: <Name>Variant;
  size?: <Name>Size;
}

// ─── Constants ────────────────────────────────────────────────────────────────

const VARIANT_CLASSES: Record<<Name>Variant, string> = {
  primary: "bg-primary text-white hover:bg-primary/90",
  secondary: "bg-slate-100 text-slate-900 hover:bg-slate-200",
};

const SIZE_CLASSES: Record<<Name>Size, string> = {
  sm: "h-8 px-3 text-sm",
  md: "h-10 px-4 text-base",
  lg: "h-12 px-5 text-lg",
};

// ─── Component ────────────────────────────────────────────────────────────────

export const <Name> = forwardRef<HTML<Element>Element, <Name>Props>(
  ({ variant = "primary", size = "md", className, ...props }, ref) => {
    return (
      <<element>
        ref={ref}
        className={cn(VARIANT_CLASSES[variant], SIZE_CLASSES[size], className)}
        {...props}
      />
    );
  },
);

<Name>.displayName = "<Name>";
```

Adjust the template:
- If user said no variants → drop the `Variant` type and `VARIANT_CLASSES` constant
- If user said no sizes → drop the `Size` type and `SIZE_CLASSES` constant
- If component does not need ref forwarding → use a plain function component without `forwardRef`

## Storybook story

Also create `<Name>.stories.tsx` alongside the component if the project uses Storybook (check for `src/ui/*.stories.tsx`):

```tsx
import type { Meta, StoryObj } from "@storybook/react";
import { <Name> } from "./<Name>";

const meta: Meta<typeof <Name>> = {
  title: "UI/<Name>",
  component: <Name>,
  tags: ["autodocs"],
};

export default meta;
type Story = StoryObj<typeof <Name>>;

export const Default: Story = {
  args: {},
};
```

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

## Reference

See [Component Anatomy recipe](https://reactprinciples.dev/cookbook/component-anatomy) and existing components in `src/ui/`.
