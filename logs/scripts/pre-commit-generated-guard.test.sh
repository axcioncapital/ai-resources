#!/bin/bash
# pre-commit-generated-guard.test.sh — focused regression test for Guard 3 of
# the tracked pre-commit body: a commit whose staged index contains a generated
# symlink destination listed in the managed local-exclude block maintained by
# auto-sync-shared.sh must fail with a path-naming message and must not advance
# HEAD. Ordinary commits are unaffected, and a repository with no managed block
# commits normally (fail-open).
#
# The fixture reuses the Unit 1 family: a disposable workspace with the REAL
# auto-sync-shared.sh copied in as canonical, a manifest-managed project that
# the real generator populates (links + managed block), and the REAL tracked
# pre-commit body installed as the project's .git/hooks/pre-commit — so the
# guard is proven against the generator's actual output, not a hand-built
# imitation of it.
#
# Usage: bash logs/scripts/pre-commit-generated-guard.test.sh
# Exit 0 = all assertions pass; exit 1 = at least one failed.

set -u

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)
REPO_TOP=$(cd "$SCRIPT_DIR/../.." && pwd -P)
SYNC_HOOK="$REPO_TOP/.claude/hooks/auto-sync-shared.sh"
PRECOMMIT="$REPO_TOP/.claude/hooks/pre-commit"
[ -f "$SYNC_HOOK" ] || { echo "FATAL: $SYNC_HOOK not found"; exit 1; }
[ -f "$PRECOMMIT" ] || { echo "FATAL: $PRECOMMIT not found"; exit 1; }

TMP=$(mktemp -d) || exit 1
trap 'rm -rf "$TMP"' EXIT

pass=0; fail=0
ok()  { pass=$((pass+1)); printf 'ok   - %s\n' "$1"; }
bad() { fail=$((fail+1)); printf 'FAIL - %s\n' "$1"; }

WS="$TMP/ws"
mkdir -p "$WS/ai-resources/.claude/hooks" "$WS/ai-resources/.claude/commands" \
         "$WS/ai-resources/.claude/agents" "$WS/ai-resources/.agents/skills/diagnose-and-fix"
cp "$SYNC_HOOK" "$WS/ai-resources/.claude/hooks/auto-sync-shared.sh"
echo shared-command > "$WS/ai-resources/.claude/commands/sharedcmd.md"
echo shared-agent   > "$WS/ai-resources/.claude/agents/sharedagent.md"
echo core-skill     > "$WS/ai-resources/.agents/skills/diagnose-and-fix/SKILL.md"

P="$WS/projects/proj"
mkdir -p "$P/.claude"
git init -q "$P"
git -C "$P" config user.email test@test.local
git -C "$P" config user.name  test
cat > "$P/.claude/shared-manifest.json" <<'EOF'
{ "commands": { "local": [] }, "agents": { "local": [] }, "skills": { "shared": [], "local": [] } }
EOF

# Real generator run: creates the links AND the managed block.
CLAUDE_PROJECT_DIR="$P" bash "$WS/ai-resources/.claude/hooks/auto-sync-shared.sh" >/dev/null 2>&1

grep -q 'auto-sync-shared generated symlinks' "$P/.git/info/exclude" 2>/dev/null \
  && ok "fixture sanity: generator produced the managed block" \
  || bad "fixture sanity: generator produced the managed block"

# Install the tracked pre-commit body — the candidate under test.
cp "$PRECOMMIT" "$P/.git/hooks/pre-commit"
chmod +x "$P/.git/hooks/pre-commit"

# --- green first: an ordinary staged file commits through the installed hook.
echo "ordinary content" > "$P/notes.md"
git -C "$P" add notes.md
if git -C "$P" commit -qm "ordinary commit" >/dev/null 2>&1; then
  ok "ordinary non-generated commit succeeds through the installed hook"
else
  bad "ordinary non-generated commit succeeds through the installed hook"
fi

# --- red: force-add one block-covered generated symlink; the commit must fail,
# name the path, and leave HEAD where it was.
git -C "$P" add -f .claude/commands/sharedcmd.md 2>/dev/null
head_before=$(git -C "$P" rev-parse HEAD 2>/dev/null || echo none)
commit_err="$TMP/commit-err"
if git -C "$P" commit -qm "force-committed generated symlink" >/dev/null 2>"$commit_err"; then
  bad "commit of a force-added generated destination is blocked"
else
  ok "commit of a force-added generated destination is blocked"
fi
head_after=$(git -C "$P" rev-parse HEAD 2>/dev/null || echo none)
[ "$head_before" = "$head_after" ] \
  && ok "HEAD did not advance on the blocked commit" \
  || bad "HEAD did not advance on the blocked commit"
grep -q '\.claude/commands/sharedcmd\.md' "$commit_err" \
  && ok "block message names the staged generated path" \
  || bad "block message names the staged generated path"
grep -q 'restore --staged' "$commit_err" \
  && ok "block message says how to unstage" \
  || bad "block message says how to unstage"

# After unstaging the generated path, the same repository commits normally again.
git -C "$P" restore --staged .claude/commands/sharedcmd.md 2>/dev/null
echo "more content" >> "$P/notes.md"
git -C "$P" add notes.md
if git -C "$P" commit -qm "normal again after unstage" >/dev/null 2>&1; then
  ok "normal commit succeeds again after unstaging the generated path"
else
  bad "normal commit succeeds again after unstaging the generated path"
fi

# --- fail-open: a repository with NO managed block (and no reachable generator)
# commits normally with the same hook installed.
Q="$TMP/plain-repo"
git init -q "$Q"
git -C "$Q" config user.email test@test.local
git -C "$Q" config user.name  test
cp "$PRECOMMIT" "$Q/.git/hooks/pre-commit"
chmod +x "$Q/.git/hooks/pre-commit"
echo hello > "$Q/file.md"
git -C "$Q" add file.md
if git -C "$Q" commit -qm "plain repo commit" >/dev/null 2>&1; then
  ok "repo without a managed block commits normally (fail-open)"
else
  bad "repo without a managed block commits normally (fail-open)"
fi

echo "---"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
exit 0
