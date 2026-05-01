# Changelog

All notable changes to the DailyBot agent skill pack are documented in this
file. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-05-01

### Added (repository-development infrastructure — does not affect installed skill)

- `AGENTS.md` at the repo root with the canonical contributor guide for AI
  agents working on this repository, plus a `CLAUDE.md` symlink pointing at
  it. Documents what ships at runtime vs. what stays as dev infrastructure,
  the public surface that must not be broken, and the consent-flow
  philosophy behind every behavior change.
- `CONTRIBUTING.md` with a friendlier human counterpart to AGENTS.md.
- GitHub Actions CI in `.github/workflows/ci.yml` covering: shellcheck on
  every shipped shell script, JSON-validity smoke tests on `context.sh`
  including the `.dailybot/disabled` opt-out and `DAILYBOT_AGENT_TOOL`
  override paths, bats-core tests, frontmatter validation, bash 3.2
  compatibility on macOS runners, and markdown link checking.
- `tests/` directory with bats-core tests for `context.sh` (10 cases) and
  `setup.sh` (7 cases). Tests use isolated temp dirs and a fake `HOME` so
  they don't touch the contributor's real agent installations.
- `scripts/verify-cdn.sh` — probes `cli.dailybot.com` to confirm both
  `install.sh` and `install.sh.sha256` are reachable and that the
  checksum matches the script. Optionally checks `install.ps1` and its
  checksum if Windows native support has been published.
- `scripts/validate-frontmatter.py` — schema check that fails CI if any
  `SKILL.md` introduces `name: dailybot_*` (snake_case), the legacy
  `homepage:` field, an unquoted version, or any of the other deviations
  from the conventions in AGENTS.md.
- `.github/ISSUE_TEMPLATE/` with bug-report and feature-request templates
  that prompt for the agent + OS + install method context we need to
  triage reports.
- `.github/PULL_REQUEST_TEMPLATE.md` with the same pre-merge checklist
  the AGENTS.md documents inline, so contributors can verify before
  requesting review.

None of these files ship to end users. Only `skills/dailybot/` is included
when the skill is installed via `npx skills add`, `openclaw skills install`,
or `git clone + setup.sh`.

## [1.0.1] — 2026-05-01

### Changed

- **CLI install ordering corrected.** The `cli.dailybot.com/install.sh`
  script auto-detects the OS internally (Homebrew on macOS, prebuilt binary
  on Linux x86_64, pipx/uv/pip elsewhere), so the SHA-256-verified
  `curl … install.sh` flow is now documented as the **primary**
  cross-platform path instead of being demoted to a fallback. Brew and pip
  are listed only as manual-control alternatives. This restores universal
  coverage (macOS, Linux, WSL, Docker, CI) without compromising the
  verification + consent guarantees added in 1.0.0.
- Added a Native Windows install path using PowerShell (`Invoke-RestMethod`
  + `Get-FileHash` checksum verification). Prefers WSL/Git Bash when the
  developer has either available.

### Added

- `DAILYBOT_AUTO_YES=1` environment variable. When set, the skill skips the
  interactive consent prompt for CLI install and for the auto-activation
  trigger write — the SHA-256 verification still runs. Intended for CI,
  Docker, and developers who have already audited the skill internally.
  **Email pre-send checks (recipient confirmation + secret-pattern scan)
  are NOT bypassed by this variable** — they remain mandatory regardless of
  environment.

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
