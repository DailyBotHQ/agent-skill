---
name: dailybot
description: Dailybot skill pack — report progress, check messages, send emails, and announce agent status. Routes to the right sub-skill based on intent. Use when the developer mentions Dailybot or wants to interact with their team.
homepage: https://api.dailybot.com/skill.md
user-invocable: true
metadata: {"openclaw":{"emoji":"📡","homepage":"https://dailybot.com","requires":{"anyBins":["dailybot","curl"],"env":["DAILYBOT_API_KEY"]},"primaryEnv":"DAILYBOT_API_KEY","install":[{"id":"pip","kind":"node","package":"dailybot-cli","bins":["dailybot"],"label":"Install Dailybot CLI (pip)"},{"id":"curl-fallback","kind":"download","url":"https://cli.dailybot.com/install.sh","label":"Install Dailybot CLI (install script)"}]}}
allowed-tools: Bash, Read, Grep, Glob
---

# Dailybot

Dailybot connects AI coding agents to their human team. This is a skill pack with four capabilities — each one lives in its own sub-skill with detailed instructions.

**Your job:** Determine which capability the developer needs, then read and follow the corresponding sub-skill.

---

## Available Skills

| Skill | Directory | What it does |
|-------|-----------|-------------|
| **Report** | [`report/SKILL.md`](report/SKILL.md) | Send progress updates after completing meaningful work |
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
| You just completed significant work (feature, bug fix, refactor, etc.) | **Report** → read [`report/SKILL.md`](report/SKILL.md) |
| Starting a long work session or idle for 15+ minutes | **Health** → read [`health/SKILL.md`](health/SKILL.md) |

If the intent is ambiguous, default to **Report** — it's the most common use case.

---

## Shared Resources

All sub-skills reference these shared files for common operations:

- [`shared/auth.md`](shared/auth.md) — authentication (CLI login, API key, agent registration, profile setup)
- [`shared/context.sh`](shared/context.sh) — automated repo/branch/agent context detection
- [`shared/http-fallback.md`](shared/http-fallback.md) — HTTP API patterns for when the CLI is unavailable

---

## Non-Blocking Rule

All Dailybot operations must **never block your primary work**. If the CLI is missing, auth fails, the network is down, or any command errors:

1. Warn the developer briefly
2. Continue with the primary task
3. Do not retry automatically
4. Do not enter a diagnostic loop
