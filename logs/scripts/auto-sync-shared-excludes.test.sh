#!/bin/bash
# auto-sync-shared-excludes.test.sh — focused regression test for the managed
# local-exclude block that .claude/hooks/auto-sync-shared.sh maintains for its
# generated symlink destinations.
#
# Proves, in one disposable fixture family:
#   1. generated command/agent/skill destinations are ignored via the marked
#      block in the checkout's local Git exclude file;
#   2. project-owned destinations (manifest *.local entries, regular files at
#      a managed name) are NOT ignored;
#   3. unrelated pre-existing exclude content survives byte-for-byte;
#   4. a second run is idempotent — exclude file byte-identical, one block;
#   5. the same holds at a different nesting depth, where the Git repository
#      root sits above the project directory, and emitted symlinks stay
#      relative and resolve to the canonical source.
#
# Usage: bash logs/scripts/auto-sync-shared-excludes.test.sh
# Exit 0 = all assertions pass; exit 1 = at least one failed.

set -u

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)
REPO_TOP=$(cd "$SCRIPT_DIR/../.." && pwd -P)
HOOK="$REPO_TOP/.claude/hooks/auto-sync-shared.sh"
[ -f "$HOOK" ] || { echo "FATAL: hook not found at $HOOK"; exit 1; }

TMP=$(mktemp -d) || exit 1
trap 'rm -rf "$TMP"' EXIT

pass=0; fail=0
ok()  { pass=$((pass+1)); printf 'ok   - %s\n' "$1"; }
bad() { fail=$((fail+1)); printf 'FAIL - %s\n' "$1"; }
assert() { # <description> <command...> — passes when the command succeeds
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$desc"; else bad "$desc"; fi
}
assert_not() { # <description> <command...> — passes when the command fails
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then bad "$desc"; else ok "$desc"; fi
}

# A symlink is relative AND resolves to the expected canonical source.
link_ok() { # <link> <expected-source>
  local rl phys
  [ -L "$1" ] || return 1
  rl=$(readlink "$1") || return 1
  case "$rl" in /*) return 1 ;; esac
  phys=$(python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$1") || return 1
  [ "$phys" = "$(python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$2")" ]
}

build_canonical() { # <workspace-dir>
  mkdir -p "$1/ai-resources/.claude/commands" "$1/ai-resources/.claude/agents" \
           "$1/ai-resources/.agents/skills/diagnose-and-fix" \
           "$1/ai-resources/.agents/skills/optskill"
  echo shared-command  > "$1/ai-resources/.claude/commands/sharedcmd.md"
  echo local-owned-src > "$1/ai-resources/.claude/commands/localcmd.md"
  echo drift-source    > "$1/ai-resources/.claude/commands/driftcmd.md"
  echo meta-command    > "$1/ai-resources/.claude/commands/new-project.md"
  echo shared-agent    > "$1/ai-resources/.claude/agents/sharedagent.md"
  echo core-skill      > "$1/ai-resources/.agents/skills/diagnose-and-fix/SKILL.md"
  echo optin-skill     > "$1/ai-resources/.agents/skills/optskill/SKILL.md"
}

write_manifest() { # <project-dir>
  mkdir -p "$1/.claude"
  cat > "$1/.claude/shared-manifest.json" <<'EOF'
{
  "commands": { "local": ["localcmd"] },
  "agents":   { "local": [] },
  "skills":   { "shared": ["optskill"], "local": [] }
}
EOF
}

run_hook() { CLAUDE_PROJECT_DIR="$1" bash "$HOOK" >/dev/null 2>&1; }

# --------------------------------------------------------------- variant A —
# the project is its own Git repository directly under projects/.
WS_A="$TMP/ws-a"
build_canonical "$WS_A"
P="$WS_A/projects/proj"
mkdir -p "$P/.claude/commands"
git init -q "$P"
write_manifest "$P"
echo project-owned         > "$P/.claude/commands/localcmd.md"
echo project-drifted-copy  > "$P/.claude/commands/driftcmd.md"
mkdir -p "$P/.git/info"
printf 'scratch/\n' >> "$P/.git/info/exclude"
cp "$P/.git/info/exclude" "$TMP/exclude-a.orig"

run_hook "$P"

echo "--- variant A: standard depth, project is its own repo ---"
assert     "generated command symlink is relative and resolves" \
  link_ok "$P/.claude/commands/sharedcmd.md" "$WS_A/ai-resources/.claude/commands/sharedcmd.md"
assert     "generated command destination is git-ignored" \
  git -C "$P" check-ignore -q .claude/commands/sharedcmd.md
assert     "generated agent destination is git-ignored" \
  git -C "$P" check-ignore -q .claude/agents/sharedagent.md
assert     "core skill destination is git-ignored" \
  git -C "$P" check-ignore -q .agents/skills/diagnose-and-fix
assert     "opted-in skill destination is git-ignored" \
  git -C "$P" check-ignore -q .agents/skills/optskill
assert_not "manifest-local command stays unignored" \
  git -C "$P" check-ignore -q .claude/commands/localcmd.md
assert_not "regular file at a managed name stays unignored" \
  git -C "$P" check-ignore -q .claude/commands/driftcmd.md
assert_not "shared-manifest.json stays unignored" \
  git -C "$P" check-ignore -q .claude/shared-manifest.json
orig_bytes=$(wc -c < "$TMP/exclude-a.orig")
assert     "pre-existing exclude content survives byte-for-byte" \
  bash -c 'head -c "$1" "$2" | cmp -s - "$3"' _ "$orig_bytes" "$P/.git/info/exclude" "$TMP/exclude-a.orig"
assert     "exactly one managed block after first run" \
  bash -c '[ "$(grep -c "auto-sync-shared generated symlinks" "$1")" -eq 2 ]' _ "$P/.git/info/exclude"

cp "$P/.git/info/exclude" "$TMP/exclude-a.run1"
run_hook "$P"
assert     "second run is idempotent (exclude file byte-identical)" \
  cmp -s "$P/.git/info/exclude" "$TMP/exclude-a.run1"

# --------------------------------------------------------------- variant B —
# different depth: the Git repository root is ABOVE the project directory, and
# the project is nested two levels below it. Same fixture family.
WS_B="$TMP/ws-b"
build_canonical "$WS_B"
G="$WS_B/projects/group"
P2="$G/nested/proj2"
mkdir -p "$P2"
git init -q "$G"
write_manifest "$P2"

run_hook "$P2"

echo "--- variant B: nested depth, repo root above the project ---"
assert     "nested generated command symlink is relative and resolves" \
  link_ok "$P2/.claude/commands/sharedcmd.md" "$WS_B/ai-resources/.claude/commands/sharedcmd.md"
assert     "nested generated command is git-ignored from the repo root" \
  git -C "$G" check-ignore -q nested/proj2/.claude/commands/sharedcmd.md
assert     "nested generated skill is git-ignored from the repo root" \
  git -C "$G" check-ignore -q nested/proj2/.agents/skills/optskill
assert     "exclude entries are root-anchored full paths" \
  grep -qxF '/nested/proj2/.claude/commands/sharedcmd.md' "$G/.git/info/exclude"
assert_not "nested shared-manifest.json stays unignored" \
  git -C "$G" check-ignore -q nested/proj2/.claude/shared-manifest.json

echo "---"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
exit 0
