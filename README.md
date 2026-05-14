<div align="center">

# React Principles Skills

**Claude/Cursor/AI skills for React Principles cookbook patterns.**

Follows the open [Agent Skills specification](https://agentskills.io/). Distributed via [skills.sh](https://skills.sh) and discoverable from [reactprinciples.dev](https://reactprinciples.dev).

</div>

---

## What is this?

This repo contains a collection of [Agent Skills](https://agentskills.io/) — invocable commands that teach AI assistants (Claude Code, Cursor, Copilot, etc.) to scaffold code and review code following the principles documented in the [React Principles cookbook](https://reactprinciples.dev).

Skills are **portable**: they work across any AI tool that supports the Agent Skills spec.

## Install

### Via skills.sh CLI (recommended)

```bash
npx skills add sindev08/react-principles-skills
```

### Manual install

Copy any `SKILL.md` file from `skills/` into `~/.claude/skills/<skill-name>/SKILL.md` (or the equivalent folder for your AI tool).

## Available skills

> Skills are being authored — see the [main repo's AI corpus issues](https://github.com/sindev08/react-principles/issues?q=is%3Aissue+label%3Aai-corpus) for tracked work.

Planned:

| Skill | Description |
|---|---|
| `/reactprinciples` | Umbrella skill — routes to the right sub-skill based on intent |
| `/reactprinciples-review` | Review code against React Principles |
| `/reactprinciples-folder-structure` | Scaffold feature-sliced folder structure |
| `/reactprinciples-component` | Scaffold a UI component |
| `/reactprinciples-hook` | Scaffold a custom hook |
| `/reactprinciples-store` | Scaffold a Zustand store |
| `/reactprinciples-query` | Scaffold a React Query hook |
| `/reactprinciples-form` | Scaffold a form with RHF + Zod |
| `/reactprinciples-recipe` | Draft a new cookbook recipe (internal) |
| `/reactprinciples-audit-recipe` | Audit an existing recipe (internal) |

## How it works

Each skill is a folder under `skills/` containing a `SKILL.md` file:

```
skills/
└── reactprinciples-review/
    └── SKILL.md
```

`SKILL.md` has YAML frontmatter (name, description, allowed-tools) and a markdown body with instructions for the AI.

## Versioning

This repo follows [Semantic Versioning](https://semver.org/) via [release-please](https://github.com/googleapis/release-please).

- `feat:` commits → minor version bump
- `fix:` commits → patch version bump
- `feat!:` or `BREAKING CHANGE:` → major version bump

See [CHANGELOG.md](./CHANGELOG.md) for history.

## Updating installed skills

There is **no auto-update** on the skills.sh side. To get the latest version of skills you've installed, re-run:

```bash
npx skills add sindev08/react-principles-skills
```

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for skill authoring conventions and release process.

## License

MIT © [Singgih Budi Purnadi](https://github.com/sindev08)
