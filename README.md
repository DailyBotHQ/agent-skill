# Dailybot Agent Skill

Give your AI coding agent the ability to report progress to [Dailybot](https://www.dailybot.com). Your team sees what was accomplished — written as standup-style updates, not robotic agent logs.

## What it does

When you work with an AI coding agent and complete meaningful work — shipping a feature, fixing a bug, finishing a task — the agent sends a progress update to Dailybot. Your teammates see it in their feed alongside everyone else's updates.

Reports are human-first: they describe what was accomplished and why it matters. The reader can't tell whether a human or an agent did the work.

Agents can also register their own Dailybot accounts. When an agent self-registers, humans can claim the workspace to see all agent activity, coordinate cross-agent work, and send messages back to agents.

## Supported agents

| Agent | Global skill path |
|-------|------------------|
| **Claude Code** | `~/.claude/skills/dailybot-report/` |
| **OpenClaw** | `<workspace>/skills/dailybot_report/` or `~/.openclaw/skills/` |
| **Cursor** | `~/.cursor/skills/dailybot-report/` |
| **OpenAI Codex** | `~/.agents/skills/dailybot-report/` |
| **Windsurf** | `~/.codeium/windsurf/skills/dailybot-report/` |
| **GitHub Copilot** | `~/.copilot/skills/dailybot-report/` |
| **Cline** | `~/.cline/skills/dailybot-report/` |
| **Gemini CLI** | `~/.gemini/skills/dailybot-report/` |

Some agents read from multiple paths for compatibility. See [triggers.md](triggers.md) for the full path reference.

## Install

### 1. Clone the skill into your agent's skill directory

Pick the path for your agent from the table above:

```bash
# Claude Code
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.claude/skills/dailybot-report

# Cursor
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.cursor/skills/dailybot-report

# OpenAI Codex
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.agents/skills/dailybot-report

# Windsurf
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.codeium/windsurf/skills/dailybot-report

# GitHub Copilot
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.copilot/skills/dailybot-report

# Cline
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.cline/skills/dailybot-report

# Gemini CLI
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.gemini/skills/dailybot-report
```

### OpenClaw — install via ClawHub

OpenClaw has a native skill registry. Install directly without cloning:

```bash
openclaw skills install dailybot-report
# or
npm i -g clawhub && clawhub install dailybot-report
```

No trigger setup needed — OpenClaw loads the skill natively on every eligible session.

### 2. Invoke the skill once

Open your IDE and type `/dailybot-report` (or `@dailybot-report` depending on your agent). The agent will:

1. **Set up auto-activation** — creates a small always-on trigger so the skill runs automatically after significant work in future sessions
2. **Install the Dailybot CLI** if not already present (`pip install dailybot-cli`)
3. **Guide you through login** to connect the CLI to your Dailybot organization

After this first run, everything is automatic.

### Update

```bash
cd <skill-path> && git pull
# OpenClaw: openclaw skills update dailybot-report
```

### Uninstall

```bash
rm -rf <skill-path>
# OpenClaw: openclaw skills remove dailybot-report
```

## How it works

1. You work with your agent as usual
2. When you complete significant work, the agent automatically evaluates whether it's worth reporting
3. If it is, the agent composes a standup-style update and sends it via `dailybot agent update` (CLI) or the HTTP API (fallback for sandboxed environments)
4. Your team sees the update in Dailybot

Significant work: features implemented, bugs fixed, major refactors, deployments, test suites, documentation, completed analysis.

Trivial changes are skipped: typo fixes, lockfile updates, formatting, code exploration, Q&A conversations.

## Authentication

Your agent guides you through authentication on first use. You can also set it up manually:

```bash
# Interactive login (email OTP) — recommended
dailybot login

# Store an API key on disk
dailybot config key=your-key

# Or set an environment variable
export DAILYBOT_API_KEY=your-key
```

> **Don't have a Dailybot account?** You can register directly from the CLI:
> ```bash
> dailybot agent register --org-name "My Team" --agent-name "Cursor"
> ```
> This creates an organization and API key. Share the claim URL from the output with your team admin to connect Slack, Teams, Discord, or Google Chat.

Configure a named agent profile so the agent doesn't need to pass `--name` on every report:

```bash
dailybot agent configure --name "Cursor"
```

## Execution paths

The skill uses two paths depending on your environment:

- **CLI** (`dailybot agent update`) — preferred, handles auth and retries automatically
- **HTTP API** (`curl` to `https://api.dailybot.com/v1/agent-reports/`) — fallback for sandboxed environments, CI, or containers where the CLI can't be installed

Both produce identical results in Dailybot.

## Report examples

**Simple bug fix:**
> "Fixed a bug where users without a timezone set would see errors on their profile page."

**Feature with structured data:**
> "Built the notification preferences system — users can now configure which alerts they receive and through which channels."
> + completed: ["Preferences model", "REST API", "Email integration", "Test suite (32 cases)"]

**Milestone:**
> "Shipped the new billing dashboard — managers can now view usage, invoices, and plan details in one place."

## What's inside

| File | Purpose |
|------|---------|
| `SKILL.md` | Core instructions the agent reads — setup, auth, evaluation, reporting, commands |
| `triggers.md` | Auto-activation trigger templates for each supported agent |
| `significance.md` | When to report and when to stay silent, with edge cases |
| `writing-guide.md` | Writing templates by work type, action verbs, rate limiting |
| `examples.md` | 15 side-by-side comparisons of weak vs strong reports |
| `scripts/detect-context.sh` | Automated repo/branch/agent context detection |
| `docs/cli-auth.md` | CLI OTP login flow detail |
| `docs/install-openclaw.md` | OpenClaw-specific setup guide |

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Agent doesn't know about Dailybot | Verify the skill is in the correct path for your agent and restart your IDE |
| Skill found but not auto-activating | Invoke `/dailybot-report` once — the agent will set up the always-on trigger |
| "Dailybot CLI not found" | Install with `pip install dailybot-cli` or `curl -sSL https://cli.dailybot.com/install.sh \| bash` |
| "Not authenticated" | Run `dailybot login`, `dailybot config key=<key>`, or set `DAILYBOT_API_KEY` |
| Session seems stale or token errors | Run `dailybot logout` then `dailybot login` to get a fresh session |
| Reports not appearing | Run `dailybot status --auth` to check authentication and organization |
| Skill not loading in OpenClaw | Check `DAILYBOT_API_KEY` is set and run `openclaw skills list` to verify |
| Agent reports too often | The skill includes significance criteria — ask it to apply the standup test more strictly |

## Links

- [Dailybot](https://www.dailybot.com)
- [Dailybot CLI on PyPI](https://pypi.org/project/dailybot-cli/)
- [Dailybot Agents feature](https://www.dailybot.com/features/agents)
- [Dailybot API skill reference](https://api.dailybot.com/skill.md)
- [ClawHub — OpenClaw skill registry](https://clawhub.ai)
