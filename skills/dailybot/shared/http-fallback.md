# Dailybot HTTP API Fallback

Use this path when the Dailybot CLI is unavailable (sandboxed environments, CI containers, or when the developer can't install it). Requires `curl`.

**Base URL:** `https://api.dailybot.com`
**Auth header:** `X-API-KEY: $DAILYBOT_API_KEY`

The `DAILYBOT_API_KEY` environment variable must be set. If it's not, ask the developer to generate a key at **Dailybot → Settings → API Keys** and set it:

```bash
export DAILYBOT_API_KEY="<their-key>"
```

---

## Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `POST` | `/v1/agent-reports/` | Submit an activity report |
| `POST` | `/v1/agent-health/` | Health check + receive pending messages |
| `GET` | `/v1/agent-health/?agent_name=<n>` | Retrieve last health status |
| `GET` | `/v1/agent-messages/?agent_name=<n>&delivered=false` | Poll for undelivered messages |
| `POST` | `/v1/agent-email/send/` | Send an email on behalf of your agent |

---

## Common Patterns

### POST request template

```bash
curl -s -X POST https://api.dailybot.com/v1/<endpoint>/ \
  -H "X-API-KEY: $DAILYBOT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '<json_payload>'
```

### GET request template

```bash
curl -s -X GET "https://api.dailybot.com/v1/<endpoint>/?<query_params>" \
  -H "X-API-KEY: $DAILYBOT_API_KEY"
```

---

## Error Handling

- **401 Unauthorized** — API key is invalid or expired. Ask the developer for a new key.
- **403 Forbidden** — API key doesn't have the required scope. Check key permissions.
- **429 Too Many Requests** — Rate limited. Slow down. Do not retry in a tight loop.
- **Network failure** — Warn briefly and continue with primary work. Do not enter a diagnostic loop.

All HTTP calls should be non-blocking. If a call fails, warn the developer and move on.

---

## API Reference

Full API documentation: `https://api.dailybot.com/api/swagger/`
Full agent API skill: `https://api.dailybot.com/skill.md`
