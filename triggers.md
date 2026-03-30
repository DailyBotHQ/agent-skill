# Auto-Activation Triggers

This file contains the exact trigger templates for each supported agent. A trigger is a small always-on instruction that tells the agent to invoke the `dailybot-report` skill after completing significant work.

Step 0 in [SKILL.md](SKILL.md) uses these templates to configure auto-activation on first run. You do not need to create these manually — the agent handles it when you first invoke `/dailybot-report`.

---

## Cursor

Cursor uses `.mdc` rule files with YAML frontmatter.

**Path**: `~/.cursor/rules/dailybot.mdc`

**Create this file** with the following content:

```
---
description: Invoke the dailybot-report skill after completing significant coding work
alwaysApply: true
---
After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the `dailybot-report` skill to evaluate whether a progress update should be sent to the team via Dailybot.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `test -f ~/.cursor/rules/dailybot.mdc`

---

## Claude Code

Claude Code reads `CLAUDE.md` files for persistent instructions.

**Path**: `~/.claude/CLAUDE.md`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot Progress Reporting

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `grep -q "dailybot-report" ~/.claude/CLAUDE.md 2>/dev/null`

---

## OpenAI Codex

Codex reads `AGENTS.md` files for persistent instructions.

**Path**: `~/.codex/AGENTS.md`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot Progress Reporting

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `grep -q "dailybot-report" ~/.codex/AGENTS.md 2>/dev/null`

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

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: Ask the developer if Dailybot appears in their Windsurf rules, or check `test -f .windsurf/rules/dailybot.md`

---

## GitHub Copilot

Copilot reads `AGENTS.md` files for agent instructions.

**Path**: `~/.agents/AGENTS.md`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot Progress Reporting

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `grep -q "dailybot-report" ~/.agents/AGENTS.md 2>/dev/null`

---

## Cline

Cline reads `.clinerules` files for persistent instructions.

**Path**: `~/.cline/.clinerules`

**Append** the following block to the end of the file (create the file if it doesn't exist):

```
## Dailybot Progress Reporting

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `grep -q "dailybot-report" ~/.cline/.clinerules 2>/dev/null`

---

## OpenClaw

OpenClaw uses the AgentSkills-compatible `SKILL.md` format natively. **No trigger file is needed** — OpenClaw loads the skill automatically on every eligible session based on gating rules in the frontmatter `metadata` field.

**Install via ClawHub (recommended):**

```bash
openclaw skills install dailybot-report
# or
npm i -g clawhub && clawhub install dailybot-report
```

**Install manually:**

```bash
mkdir -p <workspace>/skills/dailybot_report
cp -r /path/to/dailybot-skill/* <workspace>/skills/dailybot_report/
```

**Configure API key** in `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "dailybot_report": {
        "enabled": true,
        "apiKey": { "source": "env", "provider": "default", "id": "DAILYBOT_API_KEY" }
      }
    }
  }
}
```

The skill registers as `/dailybot_report` slash command automatically. No trigger setup required.

---

## Gemini CLI

Gemini CLI reads `GEMINI.md` for persistent instructions.

**Path**: `~/.gemini/GEMINI.md`

**Append** the following block to the end of the file (create if it doesn't exist):

```
## Dailybot Progress Reporting

After completing significant coding work — implementing features, fixing bugs, refactoring code, adding tests, deploying, writing documentation, or finishing multi-step tasks — invoke the dailybot-report skill to evaluate whether a progress update should be sent to the team via Dailybot.

Do not invoke for trivial changes, answering questions, reading code, or Q&A conversations.
```

**Verify**: `grep -q "dailybot" ~/.gemini/GEMINI.md 2>/dev/null`

---

## Skill installation paths

For reference, global skill directory paths for each agent:

| Agent | Global skill path |
|-------|------------------|
| Cursor | `~/.cursor/skills/dailybot-report/` |
| Claude Code | `~/.claude/skills/dailybot-report/` |
| OpenAI Codex | `~/.agents/skills/dailybot-report/` |
| Windsurf | `~/.codeium/windsurf/skills/dailybot-report/` |
| GitHub Copilot | `~/.copilot/skills/dailybot-report/` |
| Cline | `~/.cline/skills/dailybot-report/` |
| Gemini CLI | `~/.gemini/skills/dailybot-report/` |
| OpenClaw | `<workspace>/skills/dailybot_report/` or `~/.openclaw/skills/dailybot_report/` |

Cursor also reads from `~/.claude/skills/` and `~/.codex/skills/` for compatibility.
Windsurf also reads from `~/.agents/skills/` for compatibility.
Copilot also reads from `~/.claude/skills/` and `~/.agents/skills/` for compatibility.
