# Dailybot skill pack — OpenClaw notes

## Install the pack (not only the API doc)

- **Registry:** `openclaw skills install dailybot`
- **Manual:** Clone `https://github.com/DailyBotHQ/agent-skill` into `<workspace>/skills/dailybot/` (or `~/.openclaw/skills/dailybot/`).

Do **not** treat `https://api.dailybot.com/skill.md` as the skill pack. That file is the **public API reference**. The real pack lives in the GitHub repository above.

## CLI on first use

After the pack is installed, read [`../shared/auth.md`](../shared/auth.md). If `dailybot` is missing, install it automatically:

1. Official script: `curl -sSL https://cli.dailybot.com/install.sh | bash`
2. Fallback: `pip install dailybot-cli` (or `pip3` / `python3 -m pip install --user`)
3. If the CLI cannot run: HTTP API + `DAILYBOT_API_KEY` per [`../shared/http-fallback.md`](../shared/http-fallback.md)

## Configure API key (optional)

For OpenClaw-native key wiring, see the OpenClaw block in [`../report/triggers.md`](../report/triggers.md) (example `openclaw.json` snippet).
