# Contributing to the Dailybot Agent Skill Pack

Thanks for your interest in improving this skill. This guide is the human
counterpart to [`AGENTS.md`](AGENTS.md) — it covers the same conventions
but in a friendlier format. If you're an AI agent reading this, prefer
`AGENTS.md` — it has the full set of rules.

## Quick start

```bash
git clone https://github.com/DailyBotHQ/agent-skill.git
cd agent-skill

# Install the skill into your local agent (Claude Code in this example) so
# you can test changes live:
./setup.sh --host claude

# Edit anything inside skills/dailybot/, your agent will see it on next
# session because we use symlinks by default.

# Lint + test:
shellcheck setup.sh skills/dailybot/shared/context.sh
bats tests/
python3 scripts/validate-frontmatter.py
```

## What lives where

This repo has two layers — please respect the boundary:

- `skills/dailybot/` — **the runtime artifact**. This is what gets
  installed on the user's machine. Every byte here ships.
- Everything else (this file, `AGENTS.md`, `.github/`, `tests/`,
  `scripts/`, `docs/`) — **dev infrastructure**. Lives only on GitHub and
  on contributors' machines. Never relied on at runtime.

If you're adding a new file, ask whether the user needs it for the skill
to work. If yes, put it under `skills/dailybot/`. If no, put it at the
repo root.

## Before opening a PR

1. Read [`AGENTS.md`](AGENTS.md) once if you haven't — it lists every
   convention and the reasoning behind each.
2. Run the local checks:
   ```bash
   shellcheck setup.sh skills/dailybot/shared/context.sh
   bats tests/
   python3 scripts/validate-frontmatter.py
   ```
3. If you changed anything user-visible, update `CHANGELOG.md` and bump
   the `version` in `skills/dailybot/SKILL.md`.
4. If you changed the public surface (HTTP endpoints, CLI flags,
   auto-activation markers, env vars), bump major version and call it
   out clearly in the PR.

## What we will and won't merge

**We'll merge:**

- Bug fixes with a regression test
- New sub-skills following the same SKILL.md frontmatter conventions
- Documentation improvements (especially clarifications to the consent
  flows and install path)
- Cross-platform fixes (bash 3.2 compat, Windows PowerShell, Docker)
- New tests under `tests/` covering existing behavior

**We probably won't merge** without a strong rationale:

- Removing or weakening a consent flow (CLI install, auto-activation,
  email pre-send checks) — these are load-bearing for our security
  posture
- Re-introducing the `homepage:` field — agents misinterpret it as a
  re-fetch source
- Snake_case `name:` values
- Bash 4+ idioms in any shell script
- Hardcoding SHA-256 hashes anywhere in the repo

## Reporting bugs

Please open an issue using the bug report template. Include the agent
you're using (Claude Code, Cursor, etc.), the OS, and the exact command
or message that triggered the problem.

## Reporting security issues

Do **not** open a public issue. Email `security@dailybot.com` per
[`SECURITY.md`](SECURITY.md).

## Code of conduct

Be kind. Assume good faith. We're a small repo trying to make agents
useful for human teams — that goal is incompatible with bad-faith
contributions.
