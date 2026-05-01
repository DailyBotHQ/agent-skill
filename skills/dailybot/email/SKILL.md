---
name: dailybot_email
description: Send emails to any address via Dailybot on behalf of the agent. Use for notifications, summaries, follow-ups, or any communication the developer asks you to send via email.
homepage: https://api.dailybot.com/skill.md
user-invocable: false
metadata: {"openclaw":{"emoji":"📧","homepage":"https://dailybot.com","requires":{"anyBins":["dailybot","curl"]},"primaryEnv":"DAILYBOT_API_KEY","install":[{"id":"cli-install-script","kind":"download","url":"https://cli.dailybot.com/install.sh","label":"Install Dailybot CLI (official script — preferred on Linux/macOS)"},{"id":"pip","kind":"pip","package":"dailybot-cli","bins":["dailybot"],"label":"Install Dailybot CLI via pip (fallback if binary fails)"}]}}
allowed-tools: Bash, Read, Grep, Glob
---

# Dailybot Email

You send emails on behalf of the developer's agent through Dailybot. Useful for notifications, summaries, follow-ups, weekly reports, or any communication that should be delivered as email.

---

## When to Use

- The developer asks "email this to Alice" or "send a summary to the team"
- After completing a task that warrants email notification
- For sending reports, digests, or follow-ups to specific people

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

## Step 3A — Send Email via CLI

> **Timeout**: Allow at least 30 seconds for CLI commands to complete. Do not use a shorter timeout.

```bash
dailybot agent email send \
  --to alice@company.com \
  --to bob@company.com \
  --subject "Weekly build report" \
  --body-html "<h2>Build Report</h2><p>All 142 tests passing. Deployed to staging.</p>" \
  --name "<agent_name>"
```

### CLI flags

| Flag | Description |
|------|-------------|
| `--to` | Recipient email address (repeatable for multiple recipients) |
| `--subject` | Email subject line (max 512 characters) |
| `--body-html` | HTML email body |
| `--name` | Agent name (omit if default profile configured) |

---

## Step 3B — Send Email via HTTP API

```bash
curl -s -X POST https://api.dailybot.com/v1/agent-email/send/ \
  -H "X-API-KEY: $DAILYBOT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "agent_name": "<agent_name>",
    "to": ["alice@company.com", "bob@company.com"],
    "subject": "Weekly build report",
    "body_html": "<h2>Build Report</h2><p>All 142 tests passing. Deployed to staging.</p>"
  }'
```

### Request fields

| Field | Required | Description |
|-------|----------|-------------|
| `agent_name` | Yes | Your consistent agent identifier |
| `to` | Yes | Array of recipient email addresses (max 50 per request) |
| `subject` | Yes | Email subject line (max 512 characters) |
| `body_html` | Yes | HTML email body |
| `metadata` | No | Arbitrary key-value pairs for tracking context |

### Response (201)

```json
{
  "sent_count": 2,
  "total_recipients": 2,
  "reply_to": "ag-5kkdZFjG@mail.dailybot.co"
}
```

---

## Rate Limiting

Agents are rate-limited to a number of emails per hour (default: 50, configurable per organization plan). If you exceed the limit, you'll receive a `429` response:

```json
{
  "detail": "Agent email hourly limit exceeded.",
  "limit": 50,
  "current": 50
}
```

Wait for the hourly window to reset before retrying. Do not retry in a tight loop.

---

## Reply-to Inbox

Every agent has a dedicated email inbox (the `reply_to` address in the send response, e.g. `ag-5kkdZFjG@mail.dailybot.co`). When someone replies to an email sent by the agent, the reply is automatically delivered as a message to the agent's inbox.

Fetch replies using the `dailybot-messages` skill or directly:

```bash
dailybot agent message list --name "<agent_name>" --pending
```

Email replies appear as messages with `"message_type": "email"` and include the sender's email address and subject in the message metadata.

---

## Composing Good Emails

- **Subject lines** should be clear and specific — "Weekly Build Report: March 24-28" not "Update"
- **Body** should be well-structured HTML — use headings, paragraphs, and lists
- **Keep it professional** — the email comes from the agent's address on behalf of the team
- **Never include secrets, tokens, or API keys** in email content
- **Ask the developer for recipients** if they haven't specified — never guess email addresses

---

## Step 4 — Confirm

After the command runs:

- **Success** — briefly confirm. Example: *"Email sent to alice@company.com and bob@company.com: 'Weekly build report'."*
- **Failure** — warn briefly. If rate limited, mention the limit. If auth fails, reference the auth steps.
- **429 Rate Limited** — tell the developer the hourly limit was reached and suggest waiting.

---

## Non-Blocking Rule

Sending email must **never block your primary work**. If the CLI is missing, auth fails, the network is down, or the command errors:

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
