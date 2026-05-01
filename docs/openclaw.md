# Dailybot skill pack — OpenClaw notes

## Install the pack (not only the API doc)

- **Registry:** `openclaw skills install dailybot`
- **Manual:** Clone `https://github.com/DailyBotHQ/agent-skill` into `<workspace>/skills/dailybot/` (or `~/.openclaw/skills/dailybot/`).

Do **not** treat `https://api.dailybot.com/skill.md` as the skill pack. That file is the **public API reference**. The real pack lives in the GitHub repository above.

## CLI on first use

After the pack is installed, read
[`../skills/dailybot/shared/auth.md`](../skills/dailybot/shared/auth.md). If
`dailybot` is missing, present the install command to the developer and
proceed only after their first-time confirmation. Preferred order:

1. Homebrew: `brew install dailybot/tap/dailybot`
2. Pip: `pip install --user dailybot-cli`
3. Official install script with SHA-256 verification (see `auth.md` for the
   exact verification commands)
4. If the CLI cannot run: HTTP API + `DAILYBOT_API_KEY` per
   [`../skills/dailybot/shared/http-fallback.md`](../skills/dailybot/shared/http-fallback.md)

## Configure API key (optional)

For OpenClaw-native key wiring, see the OpenClaw block in
[`../skills/dailybot/report/triggers.md`](../skills/dailybot/report/triggers.md)
(example `openclaw.json` snippet).
