# Changelog

All notable changes to the Dailybot agent skill pack are documented in this
file. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-05-01

First public release on the open
[Agent Skills](https://agentskills.io) standard. Distributable via
[skills.sh](https://skills.sh) (`npx skills add DailyBotHQ/agent-skill`),
[OpenClaw](https://www.openclaw.dev) (`openclaw skills install dailybot`),
and direct git clone with `setup.sh`.

The skill ships four capabilities (progress reports, message polling,
email, health checks) coordinated by a router meta-skill, with
authentication and context detection shared across all of them. Anything
outside `skills/dailybot/` is repo-development infrastructure and is not
distributed at runtime.

### Highlights

- **Cross-agent compatible** — works with Claude Code, Cursor, OpenAI
  Codex, Gemini CLI, GitHub Copilot, Cline, Windsurf, and OpenClaw out of
  the box. `setup.sh` auto-detects installed agents and creates the
  per-agent symlinks.
- **Universal install path** — the bundled
  `https://cli.dailybot.com/install.sh` auto-detects the OS internally
  (Homebrew on macOS, prebuilt binary on Linux x86_64, pipx/uv/pip
  elsewhere). Native Windows users get a verified PowerShell variant.
- **Consent-first by default** — CLI install asks for confirmation the
  first time in a session and runs only after SHA-256 verification of
  the install script. Auto-activation in agent config files
  (`CLAUDE.md`, `AGENTS.md`, etc.) is opt-in with a visible
  `<!-- dailybot-auto-activation: BEGIN/END -->` marker so users can
  uninstall deterministically. Email sends require per-recipient
  confirmation, cache approvals in `~/.dailybot/email-approvals.json`,
  and abort on credential-pattern matches in the body or subject.
- **Per-repo opt-out** — drop `.dailybot/disabled` in any repo root and
  every outbound call from this skill stops silently for that repo.
- **CI escape hatch** — `DAILYBOT_AUTO_YES=1` skips the interactive
  consent prompts for install and auto-activation. SHA-256 verification
  still runs. Email pre-send checks are not bypassed.
- **Hardened by default** — all shell scripts use `set -euo pipefail`,
  pass `shellcheck` clean, work on bash 3.2 (macOS default), prefer
  vendor environment variables over process-name pattern matching for
  agent detection, and serialize JSON via `jq` (with `python3` and
  hardened-bash fallbacks) so control characters never break the
  payload.
- **Auditable** — `README.md` enumerates every binary the skill may
  install, every file it may create or modify, every network endpoint
  it may reach with the data sent, and the full uninstall recipe.
  `SECURITY.md` documents the disclosure channel
  (`security@dailybot.com`) and response SLA.

### Repository conventions

- All SKILL.md files use kebab-case `name`, quoted SemVer `version`,
  and `documentation_url` (the legacy `homepage` field is rejected by
  CI).
- Public surface that downstream systems depend on: HTTP endpoints
  under `api.dailybot.com/v1/agent-*/`, CLI flag names documented in
  any SKILL.md, the `dailybot-auto-activation` markers, the
  `.dailybot/disabled` opt-out, and the `DAILYBOT_AUTO_YES` and
  `DAILYBOT_API_KEY` environment variables.
- Contributor guide lives in [`AGENTS.md`](AGENTS.md) (with a
  `CLAUDE.md` symlink for Claude Code), with a friendlier human
  counterpart in [`CONTRIBUTING.md`](CONTRIBUTING.md).
- CI runs shellcheck, bats-core tests for `context.sh` and `setup.sh`,
  frontmatter validation, bash 3.2 compatibility checks on macOS
  runners, and markdown link checking on every PR.
