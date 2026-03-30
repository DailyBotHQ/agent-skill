# Auto-Activation Triggers

This file contains the exact trigger templates for each supported agent. A trigger is a small always-on instruction that tells the agent to invoke Dailybot skills after completing significant work — primarily the `dailybot-report` skill, but also to check messages at session start and send periodic health checks.

Step 0 in [SKILL.md](SKILL.md) uses these templates to configure auto-activation on first run. You do not need to create these manually — the agent handles it when you first invoke the report skill.

---

## Cursor

Cursor uses `.mdc` rule files with YAML frontmatter.

**Path**: `~/.cursor/rules/dailybot.mdc`

**Create this file** with the following content:

```
---
description: Invoke Dailybot skills for progress reporting, message checking, and team coordination
alwaysApply: true
---
After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the `dailybot-report` skill to evaluate whether a progress update should be sent to the team via Dailybot.

At the start of a work session, check for pending messages from the team using the `dailybot-messages` skill.

During long sessions (15+ minutes), send periodic health checks using the `dailybot-health` skill.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `test -f ~/.cursor/rules/dailybot.mdc`

---

## Claude Code

Claude Code reads `CLAUDE.md` files for persistent instructions.

**Path**: `~/.claude/CLAUDE.md`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

At the start of a work session, check for pending messages using the dailybot-messages skill. During long sessions, send periodic health checks using the dailybot-health skill.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.

Available skills: /dailybot_report, /dailybot_messages, /dailybot_email, /dailybot_health
```

**Verify**: `grep -q "dailybot" ~/.claude/CLAUDE.md 2>/dev/null`

---

## OpenAI Codex

Codex reads `AGENTS.md` files for persistent instructions.

**Path**: `~/.codex/AGENTS.md`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

At the start of a work session, check for pending messages using the dailybot-messages skill. During long sessions, send periodic health checks using the dailybot-health skill.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.

Available skills: dailybot-report, dailybot-messages, dailybot-email, dailybot-health
```

**Verify**: `grep -q "dailybot" ~/.codex/AGENTS.md 2>/dev/null`

---

## Windsurf

Windsurf uses global rules managed through Settings, or files in `.windsurf/rules/`.

**Preferred**: Ask the developer to add a global rule through **Settings > Cascade > Rules** with activation mode **Always On** and the content below.

**Alternative** — if the developer prefers a file, create a workspace rule:

**Path**: `.windsurf/rules/dailybot.md`

```
---
trigger: always_on
---
After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the `dailybot-report` skill to evaluate whether a progress update should be sent to the team via Dailybot.

At the start of a work session, check for pending messages using the `dailybot-messages` skill. During long sessions, send periodic health checks using the `dailybot-health` skill.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: Ask the developer if Dailybot appears in their Windsurf rules, or check `test -f .windsurf/rules/dailybot.md`

---

## GitHub Copilot

Copilot reads `AGENTS.md` files for agent instructions.

**Path**: `~/.agents/AGENTS.md`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

At the start of a work session, check for pending messages using the dailybot-messages skill. During long sessions, send periodic health checks using the dailybot-health skill.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.

Available skills: dailybot-report, dailybot-messages, dailybot-email, dailybot-health
```

**Verify**: `grep -q "dailybot" ~/.agents/AGENTS.md 2>/dev/null`

---

## Cline

Cline reads `.clinerules` files for persistent instructions.

**Path**: `~/.cline/.clinerules`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

At the start of a work session, check for pending messages using the dailybot-messages skill. During long sessions, send periodic health checks using the dailybot-health skill.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `grep -q "dailybot" ~/.cline/.clinerules 2>/dev/null`

---

## OpenClaw

OpenClaw uses the AgentSkills-compatible `SKILL.md` format natively. **No trigger file is needed** — OpenClaw loads skills automatically on every eligible session based on gating rules in the frontmatter `metadata` field.

**Install via ClawHub (recommended):**

```bash
openclaw skills install dailybot
```

**Install manually:**

```bash
git clone https://github.com/DailyBotHQ/agent-skill.git <workspace>/skills/dailybot
```

**Configure API key** in `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "dailybot": {
        "enabled": true,
        "apiKey": { "source": "env", "provider": "default", "id": "DAILYBOT_API_KEY" }
      }
    }
  }
}
```

Skills register as `/dailybot_report`, `/dailybot_messages`, `/dailybot_email`, `/dailybot_health` slash commands automatically. No trigger setup required.

---

## Gemini CLI

Gemini CLI reads `GEMINI.md` for persistent instructions.

**Path**: `~/.gemini/GEMINI.md`

**Append** the following block to the end of the file (create if it doesn't exist):

```
## Dailybot

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

At the start of a work session, check for pending messages using the dailybot-messages skill. During long sessions, send periodic health checks using the dailybot-health skill.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.

Available skills: dailybot-report, dailybot-messages, dailybot-email, dailybot-health
```

**Verify**: `grep -q "dailybot" ~/.gemini/GEMINI.md 2>/dev/null`

---

## Skill installation paths

After running `./setup`, symlinks are created for each sub-skill:

| Agent | Pack path | Symlinked sub-skills |
|-------|-----------|---------------------|
| Cursor | `~/.cursor/skills/dailybot/` | `~/.cursor/skills/dailybot-report/`, `-messages/`, `-email/`, `-health/` |
| Claude Code | `~/.claude/skills/dailybot/` | `~/.claude/skills/dailybot-report/`, `-messages/`, `-email/`, `-health/` |
| OpenAI Codex | `~/.codex/skills/dailybot/` | `~/.codex/skills/dailybot-report/`, `-messages/`, `-email/`, `-health/` |
| Windsurf | `~/.codeium/windsurf/skills/dailybot/` | same pattern |
| GitHub Copilot | `~/.copilot/skills/dailybot/` | same pattern |
| Cline | `~/.cline/skills/dailybot/` | same pattern |
| Gemini CLI | `~/.gemini/skills/dailybot/` | same pattern |
| OpenClaw | `<workspace>/skills/dailybot/` | native discovery, no symlinks needed |

Cursor also reads from `~/.claude/skills/` and `~/.codex/skills/` for compatibility.
Windsurf also reads from `~/.agents/skills/` for compatibility.
Copilot also reads from `~/.claude/skills/` and `~/.agents/skills/` for compatibility.
