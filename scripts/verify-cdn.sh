#!/usr/bin/env bash
# verify-cdn.sh — sanity-check that cli.dailybot.com publishes the install
# script and its SHA-256 checksum, and that the checksum matches the script.
#
# Run this after every release of DailyBotHQ/cli to confirm the CDN is in
# sync. The skill's auth.md flow refuses to install if the .sha256 is
# unreachable, so this script is also useful as an early-warning check.
#
# Usage:  bash scripts/verify-cdn.sh

set -euo pipefail

INSTALL_URL="https://cli.dailybot.com/install.sh"
SHA_URL="https://cli.dailybot.com/install.sh.sha256"
PS1_URL="https://cli.dailybot.com/install.ps1"
PS1_SHA_URL="https://cli.dailybot.com/install.ps1.sha256"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

ok()    { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m⚠\033[0m %s\n' "$*" >&2; }
fail()  { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; }

# ── install.sh ──────────────────────────────────────────────────────────────

printf 'Probing install.sh...\n'
if ! curl -fsSL "$INSTALL_URL" -o "$WORK_DIR/install.sh"; then
    fail "install.sh is not reachable at $INSTALL_URL"
    exit 1
fi
ok "install.sh: $(wc -c < "$WORK_DIR/install.sh" | tr -d ' ') bytes"

printf '\nProbing install.sh.sha256...\n'
if ! curl -fsSL "$SHA_URL" -o "$WORK_DIR/install.sh.sha256" 2>/dev/null; then
    fail "install.sh.sha256 is NOT published at $SHA_URL"
    cat <<EOF >&2

  This blocks the verified install path documented in
  skills/dailybot/shared/auth.md. The skill will refuse to run install.sh
  when the checksum is unreachable.

  Publish the checksum from the DailyBotHQ/cli repo:

      cd /path/to/DailyBotHQ/cli
      shasum -a 256 install.sh > install.sh.sha256
      # then upload install.sh.sha256 to the CDN serving cli.dailybot.com
      # (e.g. aws s3 cp install.sh.sha256 s3://<your-bucket>/install.sh.sha256)

  Once published, re-run this script to verify the match.

EOF
    exit 1
fi
ok "install.sh.sha256: $(wc -c < "$WORK_DIR/install.sh.sha256" | tr -d ' ') bytes"

printf '\nVerifying install.sh against published checksum...\n'
if ( cd "$WORK_DIR" && shasum -a 256 -c install.sh.sha256 >/dev/null 2>&1 ); then
    ok "install.sh matches the published SHA-256"
else
    fail "install.sh CONTENT does NOT match install.sh.sha256"
    expected=$(awk '{print $1}' "$WORK_DIR/install.sh.sha256")
    actual=$(shasum -a 256 "$WORK_DIR/install.sh" | awk '{print $1}')
    printf '  Published: %s\n' "$expected" >&2
    printf '  Actual:    %s\n' "$actual" >&2
    cat <<EOF >&2

  Likely cause: install.sh was updated on the CDN but the matching .sha256
  was not. Regenerate and re-upload the checksum:

      cd /path/to/DailyBotHQ/cli
      shasum -a 256 install.sh > install.sh.sha256
      # re-upload to CDN

EOF
    exit 1
fi

# ── install.ps1 (optional, for native Windows) ─────────────────────────────

printf '\nProbing install.ps1 (optional, for native Windows users)...\n'
if curl -fsSL "$PS1_URL" -o "$WORK_DIR/install.ps1" 2>/dev/null; then
    ok "install.ps1: $(wc -c < "$WORK_DIR/install.ps1" | tr -d ' ') bytes"

    if curl -fsSL "$PS1_SHA_URL" -o "$WORK_DIR/install.ps1.sha256" 2>/dev/null; then
        ok "install.ps1.sha256: $(wc -c < "$WORK_DIR/install.ps1.sha256" | tr -d ' ') bytes"
        # Compare the published hash (first field of the .sha256 file)
        # against the actual hash of the downloaded install.ps1. We don't use
        # `shasum -c` because the path stored inside the .sha256 file may be
        # `install.ps1` while our downloaded copy is at a different path; we
        # only care that the hash matches.
        expected=$(awk '{print tolower($1)}' "$WORK_DIR/install.ps1.sha256")
        actual=$(shasum -a 256 "$WORK_DIR/install.ps1" | awk '{print tolower($1)}')
        if [ "$expected" = "$actual" ]; then
            ok "install.ps1 matches the published SHA-256"
        else
            fail "install.ps1 does NOT match install.ps1.sha256"
            printf '  Published: %s\n' "$expected" >&2
            printf '  Actual:    %s\n' "$actual" >&2
            exit 1
        fi
    else
        warn "install.ps1.sha256 is not published — Windows native users will hit the 'checksum unreachable' path"
    fi
else
    warn "install.ps1 is not published — Windows native users will fall back to WSL or the HTTP API path (this is OK if Windows native is not yet supported)"
fi

printf '\nAll checks passed.\n'
