---
name: dailybot
description: Dailybot skill pack — report progress, check messages, send emails, and announce agent status. Routes to the right sub-skill based on intent. Use when the developer mentions Dailybot or wants to interact with their team.
version: "1.0.0"
documentation_url: https://api.dailybot.com/skill.md
user-invocable: true
metadata: {"openclaw":{"emoji":"📡","homepage":"https://dailybot.com","requires":{"anyBins":["dailybot","curl"]},"primaryEnv":"DAILYBOT_API_KEY","install":[{"id":"cli-install-script","kind":"download","url":"https://cli.dailybot.com/install.sh","label":"Install Dailybot CLI (official script — preferred on Linux/macOS)"},{"id":"pip","kind":"pip","package":"dailybot-cli","bins":["dailybot"],"label":"Install Dailybot CLI via pip (fallback if binary fails)"}]}}
allowed-tools: Bash, Read, Grep, Glob
---

# Dailybot

Dailybot connects AI coding agents to their human team. This is a skill pack with four capabilities — each one lives in its own sub-skill with detailed instructions.

**Your job:** Determine which capability the developer needs, then read and follow the corresponding sub-skill.

---

## `documentation_url` vs. the skill pack

The `documentation_url` in frontmatter points to `https://api.dailybot.com/skill.md`. That URL is the **public API reference** (HTTP endpoints and curl examples). It is **not** the GitHub skill pack (router, `shared/`, sub-skills, `setup.sh`).

- **OpenClaw:** Install the pack with `openclaw skills install dailybot`, or clone `https://github.com/DailybotHQ/agent-skill` into `<workspace>/skills/dailybot/`.
- **skills.sh / npx:** `npx skills add DailybotHQ/agent-skill` from any supported agent.
- **Do not** treat downloading only `api.dailybot.com/skill.md` as a full install — agents need the complete repository or registry install.

**Dailybot CLI:** Before any API call, ensure the CLI exists (`command -v dailybot`). If missing, follow the consent flow in [`shared/auth.md`](shared/auth.md) — the universal install script (`curl … install.sh` with SHA-256 verification) handles macOS / Linux / WSL / Docker / CI by auto-detecting the OS internally. Native Windows users get a PowerShell variant. `DAILYBOT_AUTO_YES=1` skips the interactive prompt for CI and power users. HTTP API with `DAILYBOT_API_KEY` is the last-resort fallback when no CLI can run.

---

## Available Skills

| Skill | Directory | What it does |
|-------|-----------|-------------|
| **Report** | [`report/SKILL.md`](report/SKILL.md) | Send progress updates after completing a task/subtask or editing 3+ files |
| **Messages** | [`messages/SKILL.md`](messages/SKILL.md) | Check for pending messages and instructions from the team |
| **Email** | [`email/SKILL.md`](email/SKILL.md) | Send emails to any address via Dailybot |
| **Health** | [`health/SKILL.md`](health/SKILL.md) | Announce agent online/offline status and receive messages |

---

## Routing Rules

Match the developer's intent to the right skill and **read that skill's SKILL.md to execute it**. Do not answer directly — the sub-skill has the full workflow.

| Developer says... | Route to |
|-------------------|----------|
| "report this to Dailybot", "send a Dailybot update", "let my team know what we built" | **Report** → read [`report/SKILL.md`](report/SKILL.md) |
| "check messages", "do I have messages?", "what should I work on?", "any instructions?" | **Messages** → read [`messages/SKILL.md`](messages/SKILL.md) |
| "email this to Alice", "send an email", "send a summary to the team" | **Email** → read [`email/SKILL.md`](email/SKILL.md) |
| "go online", "announce status", "health check", "check in with the team" | **Health** → read [`health/SKILL.md`](health/SKILL.md) |

### Auto-activation (no explicit request)

| Situation | Route to |
|-----------|----------|
| You completed a task/subtask, or edited 3+ files | **Report** → read [`report/SKILL.md`](report/SKILL.md) |
| Starting a long work session or idle for 15+ minutes | **Health** → read [`health/SKILL.md`](health/SKILL.md) |

If the intent is ambiguous, default to **Report** — it's the most common use case.

---

## Shared Resources

All sub-skills reference these shared files for common operations:

- [`shared/auth.md`](shared/auth.md) — authentication (CLI login, API key, agent registration, profile setup)
- [`shared/context.sh`](shared/context.sh) — automated repo/branch/agent context detection
- [`shared/http-fallback.md`](shared/http-fallback.md) — HTTP API patterns for when the CLI is unavailable

---

## Per-Repo Opt-Out

Before any outbound call, sub-skills check for a `.dailybot/disabled` file in
the working repository root. If present, the skill exits silently and no data
leaves the machine. See `shared/context.sh` for the implementation and
`README.md` for how developers turn this on.

---

## Non-Blocking Rule

All Dailybot operations must **never block your primary work**. If the CLI is missing, auth fails, the network is down, or any command errors:

1. Warn the developer briefly
2. Continue with the primary task
3. Do not retry automatically
4. Do not enter a diagnostic loop
