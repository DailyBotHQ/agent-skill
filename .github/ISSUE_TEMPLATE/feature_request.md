---
name: Feature request
about: Suggest an improvement or new capability
title: '[Feature] '
labels: enhancement
---

## What you'd like to do

<!-- 1-2 sentences describing the goal. Focus on the WHAT, not the HOW. -->

## Why it matters

<!-- The use case. Who benefits and what does it unlock? -->

## What you've tried (if anything)

<!-- Workarounds, related issues, or external tools. -->

## Scope check

- [ ] This belongs inside `skills/dailybot/` (runtime behavior shipped to users)
- [ ] This belongs at the repo root (dev infrastructure: tests, CI, scripts, docs)
- [ ] Not sure — need maintainer input

## Compatibility considerations

- [ ] Would this affect the public surface (HTTP endpoints, CLI flags,
  auto-activation markers, env vars)? If yes, this is a breaking change.
- [ ] Would this preserve the consent flows (CLI install, auto-activation
  opt-in, email pre-send checks)?
- [ ] Would this work on bash 3.2 (macOS default)?
- [ ] Would this work cross-platform (Linux, macOS, WSL, Docker, CI)?
