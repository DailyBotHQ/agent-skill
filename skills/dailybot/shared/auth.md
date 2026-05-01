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

### If the CLI is not installed — confirm, then run the universal installer

Installing software on the developer's machine is a security-relevant action.
The first time you need to install the CLI in a session, **show the proposed
command and proceed only after explicit confirmation**. Do not re-prompt for
later invocations in the same session — once the developer has confirmed,
treat that as session-wide consent.

> [!NOTE]
> The Dailybot CLI ships **one universal install script** that auto-detects
> the OS and chooses the right strategy internally:
> - **macOS** → `brew install dailybothq/tap/dailybot`
> - **Linux x86_64** → prebuilt binary released on GitHub
> - **Linux ARM / others** → `pipx` → `uv` → `pip` → `pip --user`
>
> You don't pick a method. The script does. Your job is to verify integrity
> before executing it.

#### Primary path: SHA-256-verified script (Linux, macOS, WSL, Docker, CI)

Show the developer this prompt the first time:

> "I'd like to install the Dailybot CLI. The command I'll run is:
>
> ```bash
> curl -sSL https://cli.dailybot.com/install.sh        -o /tmp/dailybot-install.sh
> curl -sSL https://cli.dailybot.com/install.sh.sha256 -o /tmp/dailybot-install.sh.sha256
> ( cd /tmp && shasum -a 256 -c dailybot-install.sh.sha256 ) && bash /tmp/dailybot-install.sh
> ```
>
> The script auto-detects your OS and uses Homebrew on macOS, the prebuilt
> binary on Linux, or pip elsewhere. To uninstall later, follow the matching
> uninstall command in the README. **Should I proceed?** (yes / no)"

On confirmation, run the three commands. If the SHA-256 check fails, **abort**
and warn the developer — do not run the script.

If `https://cli.dailybot.com/install.sh.sha256` returns a non-200 (the CDN
hasn't published the checksum yet), warn the developer and offer two
choices: (a) run the unverified script anyway with their explicit additional
consent, or (b) skip CLI install and use the HTTP API path below.

#### Native Windows (PowerShell)

For developers on native Windows without WSL or Git Bash:

```powershell
$expected = (Invoke-RestMethod https://cli.dailybot.com/install.ps1.sha256).Trim()
$script   = Invoke-RestMethod https://cli.dailybot.com/install.ps1
$bytes    = [System.Text.Encoding]::UTF8.GetBytes($script)
$actual   = (Get-FileHash -Algorithm SHA256 -InputStream ([System.IO.MemoryStream]::new($bytes))).Hash
if ($actual -ne $expected) { throw "SHA-256 mismatch — refusing to run install.ps1" }
Invoke-Expression $script
```

If the developer is on WSL or Git Bash, prefer the bash path above — it has
broader testing coverage.

#### Manual control (developer prefers their own package manager)

If the developer would rather install via their own toolchain instead of the
script, both produce the same `dailybot` binary:

- macOS: `brew install dailybothq/tap/dailybot`
- Cross-platform Python: `pipx install dailybot-cli` or `pip install --user dailybot-cli`

Use these when the developer says "I'd rather use brew/pipx" or when running
in an environment that already has one of them set up. Don't surface them as
the default — the universal script covers more cases and gets the same
result.

#### Skipping consent prompts (CI / Docker / power users)

If `DAILYBOT_AUTO_YES=1` is set in the environment, treat install consent as
already given — run the verified install command directly without the
interactive prompt. The SHA-256 check still runs and still aborts on
mismatch. **`DAILYBOT_AUTO_YES` does NOT skip email confirmations** — those
are mandatory regardless.

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
