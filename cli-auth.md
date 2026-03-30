# Dailybot CLI Authentication

Use this guide when `DAILYBOT_API_KEY` is not set and the user wants to authenticate via email OTP.

---

## Flow

### Step 1 — Ask the user for their email

> "What email address do you use for Dailybot?"

Wait for their response.

### Step 2 — Request the OTP

```bash
dailybot login --email=<their-email>
```

### Step 3 — Ask for the verification code

> "I've sent a verification code to your email. Please check your inbox — what's the code?"

Wait for their response. **Never store the code in any file.**

### Step 4 — Complete login

```bash
dailybot login --email=<their-email> --code=<their-code>
```

### Step 5 — Handle multi-org (if prompted)

If the output lists organizations, show them to the user and ask which one to use. Then:

```bash
dailybot login --email=<their-email> --code=<their-code> --org=<selected-uuid>
```

### Step 6 — Verify

```bash
dailybot status
```

Confirm the output shows authenticated state.

---

## Rules

- **Never** store or log the user's email or verification code in any file
- If any step fails, tell the user and suggest they run `dailybot login` manually
- If the user declines to authenticate, skip reporting entirely and continue with the primary task
- Authentication issues must **never** block your main work

---

## After Authentication

Once authenticated via CLI login, the CLI handles credentials automatically. No `DAILYBOT_API_KEY` is needed for CLI commands. HTTP fallback calls still require an API key — ask the user to generate one at Dailybot → Settings → API Keys.
