---
name: commit
description: 'Create git commits using Conventional Commits. Use when the user asks to commit changes or mentions "/commit". Analyze the diff, stage the right files, and generate a clear commit message.'
license: MIT
allowed-tools: Bash
---

# Commit Changes

Create a git commit using the Conventional Commits format.

## Format

```text
<type>[optional scope]: <description>
```

Add a body or footer only when needed.

## Types

- `feat` — new feature
- `fix` — bug fix
- `docs` — documentation only
- `style` — formatting only
- `refactor` — internal code change without feature or fix
- `perf` — performance improvement
- `test` — tests added or updated
- `build` — build tooling or dependencies
- `ci` — CI or automation changes
- `chore` — maintenance work
- `revert` — revert a previous commit

## Breaking changes

Use `!` for breaking changes:

```text
feat!: remove deprecated endpoint
```

Or add a footer:

```text
BREAKING CHANGE: explain what changed
```

## Workflow

### 1. Inspect changes

```bash
git status --porcelain
git diff --staged
git diff
```

Prefer the staged diff if files are already staged.

### 2. Stage files if needed

```bash
git add path/to/file
git add -p
```

Stage only the files that belong in the commit.

Never commit secrets such as `.env` files, credentials, or private keys.

### 3. Choose the message

Pick:
- **type** from the diff
- **scope** if one clear area/module is affected
- **description** in imperative mood, under 72 characters

Examples:
- `fix(auth): handle expired session token`
- `docs: clarify extension setup`
- `refactor(parser): simplify config loading`

### 4. Commit

```bash
git commit -m "<type>[scope]: <description>"
```

Use a multi-line commit only when extra context is useful.

## Rules

- One logical change per commit
- Use present-tense imperative wording: `add`, `fix`, `update`
- Do not change git config
- Do not use destructive git commands unless the user explicitly asks
- Do not use `--no-verify` unless the user explicitly asks
- Do not force-push to `main` or `master`
- If hooks fail, fix the issue and make a new commit instead of amending
