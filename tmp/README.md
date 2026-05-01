# tmp/

This directory is **git-ignored** (everything except this README) and is
available to AI agents and human contributors for scratch work,
inter-agent prompts, debug output, data exports, and any other
temporary files that should not be committed.

See [`AGENTS.md`](../AGENTS.md) — section **Temporary Files (tmp/)** —
for the full convention.

## What goes here

- `tmp/scratch/` — quick experiments, throwaway scripts
- `tmp/prompts/` — prompts you're drafting before invoking another agent
- `tmp/probes/` — captured output from probing external services
  (CDNs, APIs, etc.) while debugging
- `tmp/exports/` — query results, downloaded artifacts, snapshots
- `tmp/<your-handle>/` — personal scratch dir if you want isolation

## What does NOT go here

| Belongs in… | Not in `tmp/` |
|-------------|---------------|
| The runnable skill | `skills/dailybot/` |
| Bats tests | `tests/` |
| Repo-development scripts | `scripts/` |
| Documentation | `docs/` or repo root |

The `tmp/` folder is exclusively for things that should **never be
committed**. If something will eventually be promoted into the repo,
draft it here first, then move it to its proper home and commit it from
there — never `git add` from `tmp/`.

## Cleanup

This directory is yours to manage. Nothing else in the repo references
files under `tmp/` and CI does not look here. Periodically remove what
you no longer need so the folder stays useful.
