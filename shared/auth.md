# Dailybot Authentication

This file is shared across all Dailybot skills. Every skill references it for auth setup before performing its primary action.

Run these checks in order. Stop at the first failure. Present **one clear action** to the developer at a time during interactive login — never ask multiple questions at once.

---

## 1. Check Dailybot CLI is installed

```bash
command -v dailybot
```

If `dailybot` is found, verify it runs:

```bash
dailybot --version 2>&1 || dailybot status --auth 2>&1
```

### If the CLI is not installed — install automatically

Using this skill means you should **install the Dailybot CLI yourself** when it is missing. Do **not** ask the developer for permission to run a normal (non-root) install. Do **not** tell them to install manually and wait unless the environment truly blocks you (e.g. no network, read-only filesystem).

**Preferred order:**

1. **Official install script** (prebuilt binary on many systems — usually fastest on Linux/macOS):

   ```bash
   curl -sSL https://cli.dailybot.com/install.sh | bash
   ```

   If piping to `bash` is disallowed, download the script, inspect if required, then run it.

2. **Pip fallback** (use when the binary from the script fails at runtime — e.g. GLIBC mismatch — or the script is unavailable):

   ```bash
   pip install dailybot-cli
   ```

   Try `pip3`, `python3 -m pip install --user dailybot-cli`, or `python3 -m pip install dailybot-cli` as needed.

3. **Escalation (only with user approval):** If pip is missing, you may suggest **one** of `sudo dnf install python3-pip`, `sudo yum install python3-pip`, or `sudo apt install python3-pip` — **only if** the developer can approve elevated installs. Do not loop through many system package managers.

After each install attempt, re-check:

```bash
command -v dailybot
```

### If the CLI still cannot be installed

Stop trying endless installers. Briefly explain the limitation, then use the **HTTP API** path with `DAILYBOT_API_KEY` per [`http-fallback.md`](http-fallback.md). Ask the developer to create an API key at Dailybot → Settings → API Keys and export it:

```bash
export DAILYBOT_API_KEY="<their-key>"
```

Sandboxed environments, CI, or minimal containers may never get a working CLI — HTTP fallback is expected there.

---

## 2. Check authentication

```bash
dailybot status --auth 2>&1
```

If already authenticated — skip to "3. Check agent profile."

If not authenticated, guide the developer through login **one step at a time**. Most developers already belong to a Dailybot organization through their team — always start with login, not registration.

The CLI checks credentials in this order: agent profile → `DAILYBOT_API_KEY` env var → stored key (`dailybot config key=...`) → login session.

### OTP login flow

**Start with only this question:**

> "To connect Dailybot, I need to log in with your account.
>
> **What email address do you use for Dailybot?**
>
> (If you'd rather do it yourself, run `dailybot login` in your terminal and let me know when you're done.)"

If they prefer to handle it themselves — wait for confirmation, verify with `dailybot status --auth`, continue.

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

**Only if login fails and they explicitly say they don't have an account** — offer standalone registration:

> "No problem — I can register a new Dailybot organization right from here. What's a name for your organization?"

1. Ask for an org name and optionally a contact email
2. `dailybot agent register --org-name "<org_name>" --agent-name "<agent_tool>"`
   Or with email: `dailybot agent register --org-name "<org_name>" --agent-name "<agent_tool>" --email <their-email>`
3. The command creates an org, generates an API key, and saves an agent profile automatically
4. Output includes a **claim URL** — tell the developer: *"Share this with your team admin to connect Dailybot to Slack, Teams, Discord, or Google Chat. It expires in 30 days."*
5. Verify: `dailybot status --auth`

**Never proactively suggest `dailybot agent register`.** Only offer it if the developer clearly states they have no existing account.

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

If a default profile exists — note the name. You can omit `--name` on subsequent CLI commands.

If no profile exists and authentication succeeded, create one automatically:

```bash
dailybot agent configure --name "<agent_tool>"
```

Do not ask the developer. Briefly confirm:

> "Dailybot is ready. Your agent profile is set as **<agent_tool>**."

---

## After Authentication

Once authenticated via CLI login, the CLI handles credentials automatically. No `DAILYBOT_API_KEY` is needed for CLI commands. HTTP fallback calls still require an API key — ask the user to generate one at Dailybot → Settings → API Keys.
