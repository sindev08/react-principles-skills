# Contributing

## Skill format

Every skill lives in its own folder under `skills/` with at minimum a `SKILL.md` file:

```
skills/
└── reactprinciples-<name>/
    └── SKILL.md
```

### SKILL.md structure

YAML frontmatter (required) followed by markdown body:

```markdown
---
name: reactprinciples-<name>
description: One-line description that tells the AI when to invoke this skill.
allowed-tools: Read, Write, Edit, Bash
---

# Heading

Instructions for the AI on how to perform the task.

## Section

Sub-instructions, examples, code patterns, etc.
```

### Frontmatter rules

| Field | Required | Notes |
|---|---|---|
| `name` | Yes | Lowercase + hyphens. Max 64 chars. Must match the folder name. |
| `description` | Yes | Tells the AI when to invoke. Should mention triggers and intent. |
| `allowed-tools` | No | Restricts which tools the skill can use. Omit for unrestricted. |

### Naming convention

All skills in this repo use the `reactprinciples-` prefix to namespace them:

- `reactprinciples` — umbrella skill (no suffix)
- `reactprinciples-<topic>` — focused skill

## Commit convention

This repo follows [Conventional Commits](https://www.conventionalcommits.org/).

```
<type>(<scope>): <subject>
```

### Types that trigger a version bump

| Type | Effect |
|---|---|
| `feat:` | Minor version bump (new skill or new capability) |
| `fix:` | Patch version bump (fix to existing skill) |
| `feat!:` or `BREAKING CHANGE:` in body | Major version bump |

### Types that do not bump

- `docs:` — README, CHANGELOG updates
- `chore:` — config, tooling, CI
- `refactor:` — restructure without behavior change
- `style:` — formatting
- `test:` — tests only

### Subject rules

- Lowercase, imperative mood
- No period at end
- Max 72 characters

## Release process

This repo uses [release-please](https://github.com/googleapis/release-please) for automated versioning.

### How it works

1. You commit using conventional commits (see above) and push to `main`
2. release-please bot inspects new commits and opens (or updates) a "release PR"
3. The release PR contains:
   - Version bump in `.release-please-manifest.json`
   - Auto-generated CHANGELOG.md entries
4. Review the release PR and merge when ready
5. On merge, release-please automatically:
   - Creates a git tag (e.g. `v0.2.0`)
   - Creates a GitHub Release with release notes

### What you do

- Author skills with `feat:` commits
- Fix bugs with `fix:` commits
- Merge release PRs when you want to ship a version

You **do not** need to manually edit version files or CHANGELOG.md.

## Updates and breaking changes

Skills.sh does not auto-update installed skills. Users must re-run `npx skills add sindev08/react-principles-skills` to get the latest version.

This means **breaking changes should be avoided when possible**. If a breaking change is necessary (e.g., changing a skill's interface), prefer:

1. Adding a new skill with a different name (e.g., `reactprinciples-component-v2`)
2. Deprecating the old one in the README and CHANGELOG
3. Removing the old one only in a future major release after sufficient notice
