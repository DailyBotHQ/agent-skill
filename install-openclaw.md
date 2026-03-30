# Dailybot — OpenClaw Integration

OpenClaw uses the **AgentSkills-compatible** `SKILL.md` format. The Dailybot skill drops in natively with no modifications. It also publishes to **ClawHub** — the public skill registry at [clawhub.ai](https://clawhub.ai).

---

## Key OpenClaw-specific facts

### Frontmatter requirements

OpenClaw's parser requires **single-line frontmatter keys only**. The Dailybot SKILL.md uses:

```yaml
---
name: dailybot_report          # snake_case — OpenClaw sanitizes to a-z0-9_ for slash commands
description: ...               # single line — shown to the agent in the system prompt
homepage: https://...          # shown as "Website" in the macOS Skills UI
user-invocable: true           # exposes as /dailybot_report slash command (default: true)
metadata: {"openclaw":{...}}   # single-line JSON — gating, emoji, install specs
---
```

The `metadata` key is **single-line JSON** — OpenClaw will not parse multi-line YAML here.

### Gating behavior

The skill's `metadata.openclaw.requires` block tells OpenClaw when to load it:

```json
"requires": {
  "anyBins": ["dailybot", "curl"],
  "env": ["DAILYBOT_API_KEY"]
}
```

- `anyBins` — skill loads if `dailybot` OR `curl` is on PATH (at least one must exist)
- `env` — `DAILYBOT_API_KEY` must be set in environment or configured via `openclaw.json`

If neither binary exists, the skill is silently excluded at load time.

---

## Install options

### Option 1 — ClawHub (recommended)

```bash
# Install from public registry into your workspace
openclaw skills install dailybot-report

# Or via the clawhub CLI
npm i -g clawhub
clawhub install dailybot-report
```

After install, start a new session: `/new`

Verify: `openclaw skills list`

### Option 2 — Manual (workspace-level, highest precedence)

```bash
mkdir -p skills/dailybot_report
cp /path/to/dailybot-skill/SKILL.md skills/dailybot_report/
cp -r /path/to/dailybot-skill/scripts skills/dailybot_report/
cp -r /path/to/dailybot-skill/docs skills/dailybot_report/
```

### Option 3 — Shared across all agents on this machine

```bash
mkdir -p ~/.openclaw/skills/dailybot_report
cp -r /path/to/dailybot-skill/* ~/.openclaw/skills/dailybot_report/
```

### Option 4 — Extra skill directory (multi-agent setups)

```json
// ~/.openclaw/openclaw.json
{
  "skills": {
    "load": {
      "extraDirs": ["/path/to/shared-skills"]
    }
  }
}
```

---

## Skill directory precedence

| Location | Precedence | Scope |
|----------|-----------|-------|
| `<workspace>/skills/` | Highest | Per-agent |
| `<workspace>/.agents/skills/` | High | Project-wide |
| `~/.agents/skills/` | Medium | Personal, all agents |
| `~/.openclaw/skills/` | Lower | Managed/local |
| `skills.load.extraDirs` | Lowest | Custom shared |

---

## Configure the API key

### Via environment variable

```bash
export DAILYBOT_API_KEY=your-key-here
```

### Via openclaw.json (persists across sessions)

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

**Sandboxed agents:** `apiKey` applies to host runs only. For Docker sandboxes, inject via `agents.defaults.sandbox.docker.env`.

---

## Slash command

Once eligible, the skill registers as `/dailybot_report` (OpenClaw sanitizes `name` to `a-z0-9_`, max 32 chars).

You can also invoke by name: `/skill dailybot_report`

Or trigger via natural language — the description is injected into the system prompt and the agent matches phrases like "report to Dailybot", "send a team update", "let my team know what we built".

---

## Publishing to ClawHub

```bash
npm i -g clawhub
clawhub login
clawhub publish ./skills/dailybot_report \
  --slug dailybot-report \
  --name "Dailybot Progress Report" \
  --version 1.0.0 \
  --tags latest
```

Sync all local skills at once:
```bash
clawhub sync --all
```
