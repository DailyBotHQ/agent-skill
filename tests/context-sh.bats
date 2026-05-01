#!/usr/bin/env bats
# Tests for skills/dailybot/shared/context.sh
#
# Run with:  bats tests/
# Requires:  bats-core (brew install bats-core / apt install bats)

setup() {
    REPO_ROOT="$( cd "$BATS_TEST_DIRNAME/.." && pwd )"
    CONTEXT_SH="$REPO_ROOT/skills/dailybot/shared/context.sh"
    # Each test runs in a fresh tempdir so opt-out markers don't leak between cases.
    TMPDIR_TEST="$(mktemp -d)"
    cd "$TMPDIR_TEST"
}

teardown() {
    cd "$BATS_TEST_DIRNAME"
    rm -rf "$TMPDIR_TEST"
}

@test "emits valid JSON in a regular directory" {
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [ -n "$output" ]
    # Confirm it parses as JSON
    echo "$output" | python3 -c 'import json,sys; json.loads(sys.stdin.read())'
}

@test "JSON has all four required fields" {
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \"repo\":\" ]]
    [[ "$output" =~ \"branch\":\" ]]
    [[ "$output" =~ \"agent_tool\":\" ]]
    [[ "$output" =~ \"agent_name\":\" ]]
}

@test "respects .dailybot/disabled in current directory" {
    mkdir -p .dailybot && touch .dailybot/disabled
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "respects .dailybot/disabled in parent directory" {
    mkdir -p .dailybot && touch .dailybot/disabled
    mkdir -p subdir/nested && cd subdir/nested
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "DAILYBOT_AGENT_TOOL env var overrides detection" {
    export DAILYBOT_AGENT_TOOL="my-custom-agent"
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \"agent_tool\":\"my-custom-agent\" ]]
}

@test "DAILYBOT_AGENT_NAME env var sets agent_name when provided" {
    export DAILYBOT_AGENT_TOOL="custom-tool"
    export DAILYBOT_AGENT_NAME="custom-display-name"
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \"agent_name\":\"custom-display-name\" ]]
}

@test "uses CLAUDECODE env var to detect Claude Code" {
    export CLAUDECODE="1"
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \"agent_tool\":\"claude-code\" ]]
}

@test "falls back to current directory name when not in a git repo" {
    # tempdir is not a git repo
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    # tmp dir name should appear as repo
    expected_repo=$(basename "$PWD")
    [[ "$output" =~ \"repo\":\"$expected_repo\" ]]
}

@test "branch is 'unknown' when not in a git repo" {
    run bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \"branch\":\"unknown\" ]]
}

@test "agent_tool is 'unknown' when no detection signal is present" {
    # Clear all known env vars that would pin the agent.
    unset DAILYBOT_AGENT_TOOL DAILYBOT_AGENT_NAME
    unset CLAUDE_PLUGIN_ROOT CLAUDECODE
    unset CODEX_SESSION_ID CODEX_HOME
    unset CURSOR_SESSION_ID CURSOR_TRACE_ID
    unset OPENCLAW_SESSION GEMINI_SESSION_ID WINDSURF_SESSION_ID
    unset CI GITHUB_ACTIONS CIRCLECI

    # Run via env -i to also drop inherited PPID detection — this exercises the
    # "no signal at all" branch and confirms it doesn't spuriously claim an
    # agent identity.
    run env -i HOME="$HOME" PATH="$PATH" PWD="$PWD" bash "$CONTEXT_SH"
    [ "$status" -eq 0 ]
    [[ "$output" =~ \"agent_tool\":\"unknown\" ]]
}
