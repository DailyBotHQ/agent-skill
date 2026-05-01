<!--
Thanks for contributing! Read AGENTS.md once if you haven't — it lists every
convention and the reasoning behind each.
-->

## Summary

<!-- 1-3 sentences: what changed and why it matters. -->

## Type

- [ ] feat — new behavior
- [ ] fix — bug fix
- [ ] docs — documentation only
- [ ] chore — repo maintenance
- [ ] test — adding tests
- [ ] ci — CI configuration
- [ ] refactor — no user-visible change

## Scope

- [ ] Modified runtime skill (anything under `skills/dailybot/`)
- [ ] Modified dev infrastructure (anything outside `skills/dailybot/`)

## Pre-merge checklist

- [ ] `shellcheck setup.sh skills/dailybot/shared/context.sh` passes
- [ ] `bats tests/` passes
- [ ] `python3 scripts/validate-frontmatter.py` passes
- [ ] No `name: dailybot_*` (snake_case) introduced — kebab-case only
- [ ] No `homepage:` field introduced — use `documentation_url:`
- [ ] No `curl ... | bash` recommended without SHA-256 verification
- [ ] No bash 4+ idioms (`mapfile`, `declare -A`, `${var^^}`) introduced
- [ ] CHANGELOG.md updated if user-visible behavior changed
- [ ] Version bumped in `skills/dailybot/SKILL.md` if releasing
- [ ] Public surface preserved (CLI flags, HTTP endpoints, markers, env vars) — or major version bumped with migration note
- [ ] Consent flows preserved (install consent, auto-activation opt-in, email pre-send checks)
- [ ] User-facing strings use "Dailybot" (lowercase 'b'), not "Dailybot"
- [ ] Commit messages follow `<type>(<scope>): description` format

## Test plan

<!--
Bulleted markdown checklist. Mention which environments you tested manually
(macOS, Linux, WSL2, Docker, CI). At minimum:
- ./setup.sh --host claude
- bash skills/dailybot/shared/context.sh in a regular dir
- bash skills/dailybot/shared/context.sh with .dailybot/disabled present
-->

- [ ]
- [ ]

## Risks

<!-- Anything reviewers should pay extra attention to. Migration paths,
behavior changes, performance considerations, security implications. -->

## Breaking changes (only if applicable)

<!-- If you bumped major version, describe:
- What broke and why
- Migration path for existing users
- Deprecation timeline if any
-->
