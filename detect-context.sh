#!/usr/bin/env bash
# detect-context.sh
# Detects the current coding environment and outputs JSON for Dailybot metadata.
# Compatible with: Claude Code, Codex CLI, Cursor, Gemini CLI, OpenClaw, bare shell.
# Usage: bash detect-context.sh
# Output: {"repo":"...","branch":"...","agent_tool":"...","agent_name":"..."}

set -euo pipefail

# ── Repo name ────────────────────────────────────────────────────────────────
REPO=""
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
  if [[ -n "$REMOTE" ]]; then
    REPO=$(echo "$REMOTE" | sed 's|.*/||;s|\.git$||')
  fi
fi
if [[ -z "$REPO" ]]; then
  REPO=$(basename "$PWD")
fi

# ── Branch ───────────────────────────────────────────────────────────────────
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
if [[ -z "$BRANCH" ]]; then
  BRANCH="unknown"
fi

# ── Agent detection ──────────────────────────────────────────────────────────
# Priority: explicit env var > process detection > heuristic file detection

AGENT_TOOL="unknown"
AGENT_NAME="unknown"

# Explicit override (any agent can set this)
if [[ -n "${DAILYBOT_AGENT_TOOL:-}" ]]; then
  AGENT_TOOL="$DAILYBOT_AGENT_TOOL"
  AGENT_NAME="${DAILYBOT_AGENT_NAME:-$AGENT_TOOL}"
fi

# Claude Code — sets CLAUDE_PLUGIN_ROOT or detectable by process
if [[ "$AGENT_TOOL" == "unknown" ]]; then
  if [[ -n "${CLAUDE_PLUGIN_ROOT:-}" ]] || ps aux 2>/dev/null | grep -q "claude-code\|claude_code"; then
    AGENT_TOOL="claude-code"
    AGENT_NAME="claude-code"
  fi
fi

# OpenAI Codex CLI
if [[ "$AGENT_TOOL" == "unknown" ]]; then
  if [[ -n "${CODEX_SESSION_ID:-}" ]] || ps aux 2>/dev/null | grep -q "codex"; then
    AGENT_TOOL="codex-cli"
    AGENT_NAME="codex-cli"
  fi
fi

# Cursor
if [[ "$AGENT_TOOL" == "unknown" ]]; then
  if [[ -n "${CURSOR_SESSION_ID:-}" ]] || [[ -f ".cursor/rules" ]] || [[ -f "cursorrules" ]]; then
    AGENT_TOOL="cursor"
    AGENT_NAME="cursor"
  fi
fi

# OpenClaw
if [[ "$AGENT_TOOL" == "unknown" ]]; then
  if [[ -n "${OPENCLAW_SESSION:-}" ]] || [[ -d ".openclaw" ]]; then
    AGENT_TOOL="openclaw"
    AGENT_NAME="openclaw"
  fi
fi

# Gemini CLI
if [[ "$AGENT_TOOL" == "unknown" ]]; then
  if [[ -n "${GEMINI_SESSION_ID:-}" ]] || [[ -f "GEMINI.md" ]]; then
    AGENT_TOOL="gemini-cli"
    AGENT_NAME="gemini-cli"
  fi
fi

# CI/CD fallback
if [[ "$AGENT_TOOL" == "unknown" ]]; then
  if [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]] || [[ -n "${CIRCLECI:-}" ]]; then
    AGENT_TOOL="ci"
    AGENT_NAME="ci-agent"
  fi
fi

# ── Output ────────────────────────────────────────────────────────────────────
# Escape any special characters in values for safe JSON output
escape_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  echo "$s"
}

REPO=$(escape_json "$REPO")
BRANCH=$(escape_json "$BRANCH")
AGENT_TOOL=$(escape_json "$AGENT_TOOL")
AGENT_NAME=$(escape_json "$AGENT_NAME")

echo "{\"repo\":\"$REPO\",\"branch\":\"$BRANCH\",\"agent_tool\":\"$AGENT_TOOL\",\"agent_name\":\"$AGENT_NAME\"}"
