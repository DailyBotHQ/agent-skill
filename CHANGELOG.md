# Changelog

All notable changes to the DailyBot agent skill pack are documented in this
file. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-04-30

First public release on the open Agent Skills standard. Distributable via
[skills.sh](https://skills.sh) (`npx skills add DailyBotHQ/agent-skill`),
direct git clone, or the per-agent paths documented in `README.md`.

### Added

- Repository structured under `skills/dailybot/` to match the skills.sh
  discovery convention.
- `LICENSE` (MIT) and `SECURITY.md` with a coordinated-disclosure process.
- `version` field in every `SKILL.md` frontmatter.
- README section **"What this skill does to your environment"** enumerating
  every binary installed, file modified, network call made, and persistent
  trigger added by the skill.
- `.dailybot/disabled` marker — when present in the repo root, the bundled
  `context.sh` exits silently and no telemetry is collected.
- Email guards: per-recipient first-use confirmation cached in
  `~/.dailybot/email-approvals.json`, and a credential-pattern scan that
  blocks `body_html` containing values that look like API keys, secrets,
  AWS access keys, Stripe keys, or Slack tokens.
- Auto-activation marker `<!-- dailybot-auto-activation -->` wrapping every
  trigger block written into `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, etc., so
  users can locate and remove the block deterministically.

### Changed

- `homepage` field in skill frontmatter renamed to `documentation_url` so
  agent harnesses do not treat it as a re-fetch source.
- CLI install no longer auto-runs without consent. The install command is
  shown to the developer with a one-time confirmation prompt; subsequent
  invocations in the same session do not re-prompt. The `curl | bash` path
  is documented as a fallback after SHA-256 verification, with Homebrew and
  pip listed as preferred alternatives.
- Auto-activation in agent config files (`CLAUDE.md`, `AGENTS.md`, etc.) is
  now opt-in. The skill shows the exact file path, the exact content to be
  appended, and an uninstall instruction before writing.
- `setup.sh` now uses `set -euo pipefail` and resolves agent paths under the
  new `skills/dailybot/` layout.
- `shared/context.sh` prefers explicit environment variables over `ps aux`
  pattern matching for agent detection, falls back to `ps -o comm= -p $PPID`
  by basename, and uses `jq` (then `python3`, then a hardened bash
  fallback) to serialize JSON safely with control characters.

### Security

- Initial public security review applied. See `SECURITY.md` for the
  disclosure channel and `README.md` for the full inventory of behaviors
  that touch the user's environment.
