# Dailybot Skill Pack

Give your AI coding agent the ability to report progress, check for messages, send emails, and announce status — all through [Dailybot](https://www.dailybot.com). Your team sees what the agent accomplished, sends instructions, and stays coordinated across humans and agents.

## Skills

| Skill | What it does |
|-------|-------------|
| **dailybot-report** | Send progress updates after completing meaningful work. Reports read like standup updates — no one can tell they came from an agent. |
| **dailybot-messages** | Check for pending messages and instructions from the team. The "what should I work on next?" skill. |
| **dailybot-email** | Send emails to any address via Dailybot. Notifications, summaries, follow-ups. |
| **dailybot-health** | Announce agent online/offline status. For long-running or scheduled agents to stay visible and pick up instructions. |

A root **dailybot** meta-skill acts as a router — it describes all capabilities and routes to the right sub-skill based on the developer's intent.

Each skill can be used independently or together. They share authentication and context detection through a common `shared/` directory.

## Supported Agents

| Agent | Global skill path |
|-------|------------------|
| **Claude Code** | `~/.claude/skills/dailybot/` |
| **OpenClaw** | `<workspace>/skills/dailybot/` or `~/.openclaw/skills/` |
| **Cursor** | `~/.cursor/skills/dailybot/` |
| **OpenAI Codex** | `~/.codex/skills/dailybot/` |
| **Windsurf** | `~/.codeium/windsurf/skills/dailybot/` |
| **GitHub Copilot** | `~/.copilot/skills/dailybot/` |
| **Cline** | `~/.cline/skills/dailybot/` |
| **Gemini CLI** | `~/.gemini/skills/dailybot/` |

## Install

### 1. Clone the skill pack

Pick the path for your agent from the table above:

```bash
# Claude Code
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.claude/skills/dailybot

# Cursor
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.cursor/skills/dailybot

# OpenAI Codex
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.codex/skills/dailybot

# Windsurf
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.codeium/windsurf/skills/dailybot

# GitHub Copilot
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.copilot/skills/dailybot

# Cline
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.cline/skills/dailybot

# Gemini CLI
git clone https://github.com/DailyBotHQ/agent-skill.git ~/.gemini/skills/dailybot
```

### 2. Run setup

The setup script creates symlinks so each sub-skill is independently discoverable:

```bash
cd ~/.cursor/skills/dailybot  # or whichever path you used
./setup
```

This auto-detects installed agents and creates symlinks like `dailybot-report`, `dailybot-messages`, `dailybot-email`, and `dailybot-health` alongside the main `dailybot` directory.

To target a specific agent:

```bash
./setup --host claude
./setup --host codex
./setup --host auto    # detect all installed agents
```

### 3. Invoke a skill

Open your IDE and mention Dailybot. The agent will route to the right skill:

- "Report this to Dailybot" → **dailybot-report**
- "Do I have messages?" → **dailybot-messages**
- "Email this to Alice" → **dailybot-email**

Or invoke directly: `/dailybot_report`, `/dailybot_messages`, `/dailybot_email`, `/dailybot_health`.

On first use, the agent walks you through authentication (CLI login or API key).

### OpenClaw

OpenClaw has a native skill registry. Install directly without cloning:

```bash
openclaw skills install dailybot
```

No trigger setup needed — OpenClaw loads skills natively on every eligible session.

### Update

```bash
cd <skill-path> && git pull && ./setup
# OpenClaw: openclaw skills update dailybot
```

### Uninstall

```bash
rm -rf <skill-path>
# Also remove symlinks:
rm -f ~/.cursor/skills/dailybot-report ~/.cursor/skills/dailybot-messages \
      ~/.cursor/skills/dailybot-email ~/.cursor/skills/dailybot-health
# OpenClaw: openclaw skills remove dailybot
```

## How It Works

1. You work with your agent as usual
2. The agent uses the appropriate Dailybot skill based on context:
   - **Report**: after completing significant work, the agent composes a standup-style update
   - **Messages**: at the start of a session or when idle, the agent checks for team instructions
   - **Email**: when you ask the agent to send an email, it uses Dailybot's email API
   - **Health**: during long sessions, the agent sends periodic heartbeats
3. Your team sees everything in Dailybot — updates, agent status, and can send messages back

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

## What's Inside

```
dailybot/
├── SKILL.md                 Root meta-skill — routes to the right sub-skill
├── README.md                This file
├── setup                    Creates symlinks for agent platform discovery
├── shared/
│   ├── auth.md              Shared auth logic (CLI login, API key, registration)
│   ├── context.sh           Automated repo/branch/agent context detection
│   └── http-fallback.md     HTTP API patterns for when CLI is unavailable
├── report/
│   ├── SKILL.md             Progress reporting skill
│   ├── triggers.md          Auto-activation trigger templates per agent
│   ├── significance.md      When to report vs stay silent
│   ├── writing-guide.md     Writing templates and forbidden patterns
│   └── examples.md          15 side-by-side good vs bad report comparisons
├── messages/
│   └── SKILL.md             Message checking skill
├── email/
│   └── SKILL.md             Email sending skill
└── health/
    └── SKILL.md             Health check / status skill
```

## Execution Paths

Every skill supports two execution paths:

- **CLI** (`dailybot agent ...`) — preferred, handles auth and retries automatically
- **HTTP API** (`curl` to `https://api.dailybot.com/v1/...`) — fallback for sandboxed environments, CI, or containers

Both produce identical results.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Agent doesn't know about Dailybot | Verify the skill pack is in the correct path and run `./setup` |
| Skill found but not auto-activating | Invoke the report skill once — it sets up an always-on trigger |
| "Dailybot CLI not found" | Install with `pip install dailybot-cli` or `curl -sSL https://cli.dailybot.com/install.sh \| bash` |
| "Not authenticated" | Run `dailybot login`, `dailybot config key=<key>`, or set `DAILYBOT_API_KEY` |
| Session seems stale | Run `dailybot logout` then `dailybot login` |
| Reports not appearing | Run `dailybot status --auth` to check authentication and organization |
| Symlinks not created | Run `./setup` from the skill pack directory |

## Links

- [Dailybot](https://www.dailybot.com)
- [Dailybot CLI on PyPI](https://pypi.org/project/dailybot-cli/)
- [Dailybot Agents feature](https://www.dailybot.com/features/agents)
- [Dailybot API skill reference](https://api.dailybot.com/skill.md)
- [API documentation (Swagger)](https://api.dailybot.com/api/swagger/)
