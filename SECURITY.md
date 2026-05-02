# Security Policy

## Reporting a Vulnerability

If you believe you have found a security vulnerability in the Dailybot agent
skill pack, please report it privately rather than opening a public issue.

**Email:** security@dailybot.com

Include in your report:

- A description of the issue and the impact you observed
- Steps to reproduce (a minimal proof of concept is ideal)
- The version of the skill pack (`version` field in `skills/dailybot/SKILL.md`)
- Your name or handle if you would like credit in the release notes

We acknowledge reports within **3 business days** and aim to issue a fix or a
mitigation within **30 days** for valid findings, depending on severity.

## In Scope

The following are in scope for security reports:

- Code in this repository under `skills/`, `setup.sh`, and `docs/`
- The recommended install path documented in `skills/dailybot/shared/auth.md`
- Default behaviors of the bundled `context.sh`
- The auto-activation trigger templates in `skills/dailybot/report/triggers.md`
- Any silent network call, file write, or persistent change made by the skill

## Out of Scope

The following are tracked separately and not handled here:

- The `dailybot` CLI itself (report at <https://github.com/DailybotHQ/dailybot-cli>)
- The Dailybot API (`api.dailybot.com`) — report via the email above
- Third-party agent harnesses (Claude Code, Cursor, etc.) — report upstream
- Issues caused by user-modified copies of the skill that drift from this repo

## What This Skill Does To Your Environment

For full transparency, every behavior with security relevance is enumerated in
[`README.md`](README.md) under the section **"What this skill does to your
environment"**. Review that section before installation if you are auditing
the skill for an enterprise rollout.

## Hardening Defaults

This skill is designed to fail closed when a security control is uncertain:

- Outbound calls respect a `.dailybot/disabled` marker in the working repo.
- Email sends require explicit per-recipient confirmation on first use and
  scan bodies for credential-like patterns before sending.
- CLI installation requires explicit confirmation the first time it runs in a
  session.
- Auto-activation triggers in agent config files are opt-in with a visible
  uninstall marker.

If any of these controls fail, the skill warns and continues with the
developer's primary task — it never blocks work to satisfy a control.

## Coordinated Disclosure

We follow standard coordinated disclosure: please give us a reasonable window
to ship a fix before publishing details. We will credit reporters in the
[CHANGELOG](CHANGELOG.md) and the GitHub release notes once a fix is shipped,
unless you ask to remain anonymous.
