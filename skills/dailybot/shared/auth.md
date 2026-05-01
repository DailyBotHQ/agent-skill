# Dailybot Authentication

This file is shared across all Dailybot skills. Every skill references it for
auth setup before performing its primary action.

Run these checks in order. Stop at the first failure. Present **one clear
action** to the developer at a time during interactive login — never ask
multiple questions at once.

---

## 1. Check Dailybot CLI is installed

```bash
command -v dailybot
```

If `dailybot` is found, verify it runs:

```bash
dailybot --version 2>&1 || dailybot status --auth 2>&1
```

### If the CLI is not installed — confirm before installing

Installing software on the developer's machine is a security-relevant action.
The first time you need to install the CLI in a session, **show the proposed
command and proceed only after explicit confirmation**. Do not re-prompt for
later invocations in the same session — once the developer has confirmed,
treat that as session-wide consent.

Pick **one** install path from the table below based on what is available on
the developer's system, then surface this prompt:

> "I'd like to install the Dailybot CLI so I can report progress. The
> command I'll run is:
>
> ```
> <selected command>
> ```
>
> This installs `dailybot` into your user directory. To uninstall later, run
> the matching uninstall command listed in the README. **Should I proceed?**
> (yes / no / show me another method)"

If the developer declines, switch to the **HTTP fallback** path below — do
not loop through alternatives without permission.

#### Preferred install methods (in order)

| Order | Platform | Install command | Why preferred |
|-------|----------|-----------------|---------------|
| 1 | macOS / Linuxbrew | `brew install dailybot/tap/dailybot` | Signed formula, easy uninstall (`brew uninstall dailybot`) |
| 2 | Cross-platform Python | `pip install --user dailybot-cli` | No root, easy uninstall (`pip uninstall dailybot-cli`), works in containers |
| 3 | Debian/Ubuntu (with sudo approval) | `sudo apt install dailybot` *(when published)* | System package manager — only with explicit approval |
| 4 | Fedora/RHEL (with sudo approval) | `sudo dnf install dailybot` *(when published)* | Same — explicit approval required |

Try `pip3`, `python3 -m pip install --user dailybot-cli`, or
`python3 -m pip install dailybot-cli` as needed when the plain `pip` form
fails.

#### Fallback: official install script with SHA-256 verification

Only use this when none of the methods above is available. **Verify the
script's SHA-256 against the published value before executing.**

```bash
# 1. Download the script and the published checksum.
curl -sSL https://cli.dailybot.com/install.sh -o /tmp/dailybot-install.sh
curl -sSL https://cli.dailybot.com/install.sh.sha256 -o /tmp/dailybot-install.sh.sha256

# 2. Verify the checksum matches.
( cd /tmp && shasum -a 256 -c dailybot-install.sh.sha256 ) || {
  echo "SHA-256 verification failed — refusing to run install.sh." >&2
  exit 1
}

# 3. Inspect the script if you'd like, then run it.
bash /tmp/dailybot-install.sh
```

If `https://cli.dailybot.com/install.sh.sha256` is unreachable, **do not run
the install script** — fall through to the HTTP API path below and let the
developer install the CLI manually when they are ready.

After any install attempt, re-check:

```bash
command -v dailybot
```

### If the CLI still cannot be installed

Stop trying installers. Briefly explain the limitation, then use the **HTTP
API** path with `DAILYBOT_API_KEY` per
[`http-fallback.md`](http-fallback.md). Ask the developer to create an API
key at Dailybot → Settings → API Keys and export it:

```bash
export DAILYBOT_API_KEY="<their-key>"
```

Sandboxed environments, CI, or minimal containers may never get a working
CLI — HTTP fallback is expected there.

---

## 2. Check authentication

```bash
dailybot status --auth 2>&1
```

If already authenticated — skip to "3. Check agent profile."

If not authenticated, guide the developer through login **one step at a
time**. Most developers already belong to a Dailybot organization through
their team — always start with login, not registration.

The CLI checks credentials in this order: agent profile → `DAILYBOT_API_KEY`
env var → stored key (`dailybot config key=...`) → login session.

### OTP login flow

**Start with only this question:**

> "To connect Dailybot, I need to log in with your account.
>
> **What email address do you use for Dailybot?**
>
> (If you'd rather do it yourself, run `dailybot login` in your terminal and
> let me know when you're done.)"

If they prefer to handle it themselves — wait for confirmation, verify with
`dailybot status --auth`, continue.

If they provide their email, proceed one step at a time:

1. `dailybot login --email=<their-email>`
2. Ask: "Check your email for a verification code from Dailybot. What's the code?"
3. `dailybot login --email=<their-email> --code=<their-code>`
4. If output lists multiple organizations, show the list and ask them to pick one
5. If needed: `dailybot login --email=<their-email> --code=<their-code> --org=<selected-uuid>`
6. Verify: `dailybot status --auth`

### API key alternative

If the developer already has an API key, they can store it instead:

```bash
dailybot config key=<their-api-key>
```

This persists the key on disk — no env var or login session needed afterward.

### Self-registration (only when explicitly requested)

**Only if login fails and they explicitly say they don't have an account** —
offer standalone registration:

> "No problem — I can register a new Dailybot organization right from here.
> What's a name for your organization?"

1. Ask for an org name and optionally a contact email
2. `dailybot agent register --org-name "<org_name>" --agent-name "<agent_tool>"`
   Or with email: `dailybot agent register --org-name "<org_name>" --agent-name "<agent_tool>" --email <their-email>`
3. The command creates an org, generates an API key, and saves an agent profile automatically
4. Output includes a **claim URL** — tell the developer: *"Share this with your team admin to connect Dailybot to Slack, Teams, Discord, or Google Chat. It expires in 30 days."*
5. Verify: `dailybot status --auth`

**Never proactively suggest `dailybot agent register`.** Only offer it if the
developer clearly states they have no existing account.

### Auth rules

- Never store the developer's email, verification code, or API key in any file you create
- If login fails, suggest they run `dailybot login` manually in their terminal
- If auth seems corrupted, suggest `dailybot logout` then re-login
- If they decline to authenticate now, skip the current skill entirely
- Auth issues must **never** block your primary work

---

## 3. Check agent profile

```bash
dailybot agent profiles 2>&1
```

If a default profile exists — note the name. You can omit `--name` on
subsequent CLI commands.

If no profile exists and authentication succeeded, create one automatically.
This is metadata only (no install, no network call beyond the CLI command),
so no separate confirmation is needed:

```bash
dailybot agent configure --name "<agent_tool>"
```

Briefly confirm:

> "Dailybot is ready. Your agent profile is set as **<agent_tool>**."

---

## After Authentication

Once authenticated via CLI login, the CLI handles credentials automatically.
No `DAILYBOT_API_KEY` is needed for CLI commands. HTTP fallback calls still
require an API key — ask the user to generate one at
Dailybot → Settings → API Keys.
