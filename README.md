<div align="center">

# React Principles Skills

**Claude/Cursor/AI skills for React Principles cookbook patterns.**

Follows the open [Agent Skills specification](https://agentskills.io/). Distributed via [skills.sh](https://skills.sh) and discoverable from [reactprinciples.dev](https://www.reactprinciples.dev).

</div>

---

## What is this?

This repo contains a collection of [Agent Skills](https://agentskills.io/) — invocable commands that teach AI assistants (Claude Code, Cursor, Copilot, etc.) to scaffold code and review code following the principles documented in the [React Principles cookbook](https://www.reactprinciples.dev).

Skills are **portable**: they work across any AI tool that supports the Agent Skills spec.

## Install

### Via Claude Code plugin (recommended for Claude Code users)

```bash
/plugin marketplace add sindev08/react-principles-skills
/plugin install reactprinciples@react-principles
/reload-plugins
```

This also registers the [React Principles MCP server](https://www.reactprinciples.dev/ai) automatically — skills can fetch live recipes without manual MCP setup.

### Via skills.sh (recommended for Cursor, Copilot, OpenCode, and other tools)

```bash
npx skills add sindev08/react-principles-skills
```

Works across 75+ AI tools. Does **not** register the MCP server — skills fall back to HTTP fetch or offline summaries.

### Manual install

Copy any `SKILL.md` file from `skills/` into `~/.claude/skills/<skill-name>/SKILL.md` (or the equivalent folder for your AI tool).

### Duplicate install warning

Installing both the plugin and skills.sh puts every skill in the listing twice, which degrades auto-trigger. Pick one method. If you installed both, remove the skills.sh copy:

```bash
rm -rf ~/.claude/skills/reactprinciples*
```

## Available skills

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

## Live content — skills never go stale

Skills do **not** embed copies of the cookbook. Instead, every skill starts with a required step that loads the current recipe from the source of truth:

1. Via the [React Principles MCP server](https://www.reactprinciples.dev/ai) (`get_recipe` tool), if connected (auto-registered when installed as a plugin)
2. Otherwise via per-recipe markdown: `https://www.reactprinciples.dev/cookbook/<slug>/llms.txt`

This means recipe updates on [reactprinciples.dev](https://www.reactprinciples.dev) reach your installed skills **automatically** — no re-install needed. Each skill keeps a short offline fallback summary, clearly labeled, for when the network is unavailable.

## Privacy

Installing the plugin registers the `reactprinciples` MCP server, which means your editor makes outbound calls to `www.reactprinciples.dev` during normal work. Only recipe content is fetched — no code, no prompts, no personal data. If you prefer to decline the MCP server, skills fall back to HTTP fetch, then to embedded offline summaries.

## Versioning

This repo follows [Semantic Versioning](https://semver.org/) via [release-please](https://github.com/googleapis/release-please).

- `feat:` commits → minor version bump
- `fix:` commits → patch version bump
- `feat!:` or `BREAKING CHANGE:` → major version bump

See [CHANGELOG.md](./CHANGELOG.md) for history.

## Updating installed skills

Recipe content updates automatically (see **Live content** above). Re-installing is only needed when the *workflow instructions* in the skills themselves change:

```bash
npx skills add sindev08/react-principles-skills
```

> **Installed before the live-content change?** Older versions embedded recipe snapshots that go stale. Re-run the install command once to switch to the live-fetch versions — after that, content updates reach you automatically.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for skill authoring conventions and release process.

## License

MIT © [Singgih Budi Purnadi](https://github.com/sindev08)
