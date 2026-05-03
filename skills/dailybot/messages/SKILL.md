---
name: dailybot-messages
description: Check for pending messages and instructions from your team via Dailybot — official Dailybot messages skill. Use when starting a work session, when idle, or when asked what to work on next. Messages are instructions that should influence your work.
version: "1.0.0"
documentation_url: https://api.dailybot.com/skill.md
user-invocable: false
metadata: {"openclaw":{"emoji":"📬","homepage":"https://dailybot.com","requires":{"anyBins":["dailybot","curl"]},"primaryEnv":"DAILYBOT_API_KEY","install":[{"id":"cli-install-script","kind":"download","url":"https://cli.dailybot.com/install.sh","label":"Install Dailybot CLI (official script — preferred on Linux/macOS)"},{"id":"pip","kind":"pip","package":"dailybot-cli","bins":["dailybot"],"label":"Install Dailybot CLI via pip (fallback if binary fails)"}]}}
allowed-tools: Bash, Read, Grep, Glob
---

# Dailybot Messages

You check for pending messages and instructions from the developer's team. Messages are sent by humans (or other agents) through Dailybot and represent tasks, priorities, context, or feedback that should influence your current work.

This is the "what should I work on next?" skill.

---

## When to Check Messages

- At the start of a work session
- When the developer asks "do I have any messages?" or "what should I work on?"
- When idle between tasks
- Periodically during long sessions (health checks also deliver messages — see the `dailybot-health` skill)

---

## Step 1 — Verify Setup

Read and follow the authentication steps in [`../shared/auth.md`](../shared/auth.md). That file covers CLI installation, login, API key setup, and agent profile configuration.

If auth fails or the developer declines, skip and continue with your primary task.

---

## Step 2 — Choose Execution Path

```bash
command -v dailybot
```

- **CLI found** → Step 3A
- **CLI not found** → Step 3B (see [`../shared/http-fallback.md`](../shared/http-fallback.md) for base curl patterns)

---

## Step 3A — Fetch Messages via CLI

> **Timeout**: Allow at least 30 seconds for CLI commands to complete. Do not use a shorter timeout.

```bash
dailybot agent message list --name "<agent_name>" --pending
```

This returns all undelivered messages for the agent. Each message includes:
- Content (the instruction or context)
- Sender name and type (human or agent)
- Timestamp
- Message type (`text` or `email`)

---

## Step 3B — Fetch Messages via HTTP API

```bash
curl -s -X GET "https://api.dailybot.com/v1/agent-messages/?agent_name=<agent_name>&delivered=false" \
  -H "X-API-KEY: $DAILYBOT_API_KEY"
```

**Response:**

```json
[
  {
    "id": "msg-uuid",
    "content": "Please prioritize the auth bug fix before the feature work",
    "message_type": "text",
    "sender_type": "human",
    "sender_name": "Alice",
    "metadata": {},
    "created_at": "2026-02-11T09:30:00Z"
  }
]
```

---

## Step 4 — Act on Messages

Messages from the team are **instructions that should influence your work**. When you receive messages:

1. **Read all pending messages** — understand the full context before acting
2. **Prioritize accordingly** — if a message asks you to change priorities, adjust your plan
3. **Incorporate context** — use information from messages to inform your current task
4. **Acknowledge receipt** — mention what you received in your next progress report (via the `dailybot-report` skill)

### Message types

| Type | Source | How to handle |
|------|--------|---------------|
| `text` | Human or agent via Dailybot | Direct instruction or context — act on it |
| `email` | Reply to an agent-sent email | Follow-up from a previous email — respond or act accordingly |

### Presenting messages to the developer

When messages are found, summarize them clearly:

> "You have **2 messages** from your team via Dailybot:
>
> 1. **Alice** (2 hours ago): *Please prioritize the auth bug fix before the feature work*
> 2. **Bob** (30 min ago): *The staging deploy is blocked — can you check the Docker config?*
>
> Want me to start with the auth bug fix?"

When no messages are found:

> "No pending messages from your team. What would you like to work on?"

---

## Non-Blocking Rule

Checking messages must **never block your primary work**. If the CLI is missing, auth fails, the network is down, or the command errors:

1. Warn the developer briefly
2. Continue with the primary task
3. Do not retry automatically
4. Do not enter a diagnostic loop

---

## Additional Resources

- [`../shared/auth.md`](../shared/auth.md) — authentication setup
- [`../shared/http-fallback.md`](../shared/http-fallback.md) — HTTP API fallback patterns
- **Live API spec:** `https://api.dailybot.com/api/swagger/`
- **Full agent API skill:** `https://api.dailybot.com/skill.md`
