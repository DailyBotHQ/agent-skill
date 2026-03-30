# When to Report — The Significance Guide

This guide helps you decide whether the work you just completed deserves a Dailybot report. The core principle is simple:

> **The Standup Test**: Would this be worth mentioning in a real daily standup with the team? If you wouldn't say it out loud to your colleagues, don't send it as a report.

## Significant Work (Send a Report)

These are outcomes that matter to the team. They represent tangible progress.

### Feature implemented

You built something new that didn't exist before. A new endpoint, a new UI component, a new integration, a new workflow. The key is that it delivers new capability.

Examples:
- Built a user preferences API with CRUD endpoints
- Added Slack notification support for standup reminders
- Implemented the password reset flow end-to-end

### Bug fixed

You resolved a problem that was affecting users or could affect them. The fix is deployed or committed, not just identified.

Examples:
- Fixed a crash when users without a timezone open their profile
- Resolved a race condition in the payment processing queue
- Corrected currency formatting for non-USD locales

### Major refactor completed

You improved the internal structure of the code in a way that has meaningful impact — better performance, better maintainability, eliminated duplication, improved architecture.

Examples:
- Refactored authentication to use JWT tokens across all services
- Migrated the notification system from polling to webhooks
- Consolidated 4 duplicate user lookup functions into one shared service

### Multi-step task fully finished

You completed a complex task that involved multiple distinct steps, and all of them are done. Not "I did 3 of 5 steps" — the full task is wrapped up.

Examples:
- Set up the CI/CD pipeline: build, test, lint, and deploy stages all working
- Completed the data migration: schema update, backfill script, validation, and rollback plan

### Test suite added

You created meaningful test coverage that didn't exist before. Not a single trivial test, but a suite that covers real scenarios.

Examples:
- Added 24 test cases for the payment webhook handler covering timeouts, retries, and edge cases
- Built integration tests for the user registration flow

### Deployment or migration executed

You shipped something to an environment or ran a significant data migration.

Examples:
- Deployed the new billing system to production
- Ran the timezone backfill migration for 50K user records

### Meaningful documentation written

You created documentation that has lasting value — API docs, architecture guides, onboarding instructions. Not a one-line code comment.

Examples:
- Documented the cross-service authentication flow with diagrams
- Wrote the API reference for the new notification endpoints

### Analysis or research completed

You finished an investigation and produced concrete findings or deliverables. Not "I looked at some things" — you have a clear output.

Examples:
- Completed performance audit — identified 3 N+1 queries causing 80% of latency
- Analyzed competitor pricing models and documented positioning recommendations

## Not Significant (Stay Silent)

These are activities that happen as part of working but don't represent meaningful progress to the team. Reporting them creates noise.

### Answering questions

The developer asked you something and you answered. No code was changed, no deliverable was produced. This is a conversation, not an accomplishment.

### Reading or exploring code

You navigated the codebase, read files, understood the architecture. This is preparation for work, not work itself. No output was produced.

### Making plans

You created a plan, outlined an approach, discussed strategy. Planning is valuable but it's not done work. Report when the plan is executed, not when it's created.

### Single trivial changes

A typo fix, a variable rename, a comment update, a formatting change. These are maintenance, not progress. No one mentions fixing a typo at standup.

### Lockfile or dependency updates

Package-lock.json changed, poetry.lock updated, dependencies bumped. This is automated maintenance.

### Formatting or linting fixes

You ran a formatter or fixed lint errors. The code looks different but behaves identically. No functional change.

### Failed attempts that were rolled back

You tried something and it didn't work, so you undid it. The net change is zero. Nothing to report.

### Uncommitted work in progress

You're in the middle of something. It's not done yet. Wait until it's finished. Reporting WIP creates false signals.

### Ongoing work that isn't finished

The developer asked you to do 5 things and you've done 2. Don't report the 2 — wait until the task is complete, then report the whole thing.

### Vague or unspecific work

If you find yourself writing "completed some work" or "made changes" or "updated code" — stop. If you can't describe specifically what was accomplished, the work either isn't significant or isn't finished.

## Aggregation Rule

If you completed multiple related changes, combine them into one report. Don't send 3 reports for parts of one feature.

**Instead of:**
- "Updated the user model"
- "Added the preferences endpoint"  
- "Wrote tests for preferences"

**Send one:**
- "Built the user preferences system — new data model, API endpoint, and full test coverage."

## Edge Cases

### "I fixed a bug AND answered some questions"

Report the bug fix. Ignore the Q&A. Only the significant part matters.

### "I did a lot of small things"

If the small things add up to something meaningful (like "cleaned up 12 deprecated API calls across the codebase"), report the aggregate. If they don't add up to anything coherent, skip it.

### "The developer asked me to report"

If the developer explicitly says "report this to Dailybot" or "send an update", send it regardless of your significance assessment. They know better than you whether their team needs to hear about it.

### "I already reported recently"

If you sent a report less than 30 minutes ago, consider whether the new work should be a separate report or if you should wait and aggregate. Back-to-back reports about the same feature should be combined.
