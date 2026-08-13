#!/usr/bin/env bash
# Acceptance harness — Work Loop v2 core resolver, linked-worktree identity.
#
# Fixes: plans/work-loop-v2-v0.2/core-resolver-worktree-defect-report-2026-08-09.md
# Plan:  plans/work-loop-v2-v0.2/core-resolver-worktree-fix-plan-v0.1.md (level B)
#
# The resolver under test is EXTRACTED from the deployed Claude command, not copied
# into this file. The test therefore exercises the shipped text.
#
#   check 1  linked worktree of this repo, named something other than ai-resources,
#            resolves ITS OWN core path                              [the defect]
#   check 2  canonical checkout still resolves its own core path     [positive control]
#   check 3  unrelated repo named ai-resources-eval, holding a copy of the core at the
#            same relative path, is rejected and says why            [negative control]
#   check 4  the marked resolver blocks in the Claude command and the Codex skill are
#            byte-identical                                          [mirror parity]
#
# Run it BEFORE the fix (check 1 must fail) and AFTER (all must pass). An assertion
# that has never failed is not evidence.
#
# Exit 0 only when every check passes. Exit 2 on an environment problem.

set -uo pipefail

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "not a git repo"; exit 2; }
ROOT=$(cd "$ROOT" && pwd -P) || exit 2
cd "$ROOT" || exit 2

CMD_FILE="$ROOT/.claude/commands/work-loop-v2.md"
SKILL_FILE="$ROOT/.agents/skills/work-loop-v2/SKILL.md"
SEMANTIC_REL='plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md'

[ -f "$CMD_FILE" ]   || { echo "missing $CMD_FILE"; exit 2; }
[ -f "$SKILL_FILE" ] || { echo "missing $SKILL_FILE"; exit 2; }

PASS=0
FAIL=0
ok()   { PASS=$((PASS+1)); printf 'PASS  %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf 'FAIL  %s\n' "$1"; [ $# -gt 1 ] && printf '      %s\n' "$2"; return 0; }

TMP=$(mktemp -d) || exit 2
TMP=$(cd "$TMP" && pwd -P) || exit 2
WT="$TMP/wl2-fixture-eval"
# Cleanup is PATH-SCOPED on purpose. Never call `git worktree prune` here: it deregisters every
# worktree whose directory is momentarily unavailable, including the operator's own scratchpad
# worktrees on volatile paths. `worktree remove` touches only this fixture.
cleanup() {
  git -C "$ROOT" worktree remove --force "$WT" >/dev/null 2>&1
  rm -rf "$TMP"
}
trap cleanup EXIT

# --- extract the resolver from the deployed command -------------------------

extract_block() {
  awk '/work-loop-v2-core-resolution:start/{f=1;next} /work-loop-v2-core-resolution:end/{f=0} f' "$1"
}
extract_bash() {
  extract_block "$1" | awk '/^```bash$/{f=1;next} /^```$/{f=0} f'
}

RESOLVER="$TMP/resolver.sh"
extract_bash "$CMD_FILE" > "$RESOLVER"
[ -s "$RESOLVER" ] || { echo "could not extract the resolver bash from $CMD_FILE"; exit 2; }

run_resolver() {  # $1 = directory to run in; sets RC, OUT, ERR
  OUT=$( (cd "$1" && bash "$RESOLVER") 2>"$TMP/err" )
  RC=$?
  ERR=$(cat "$TMP/err")
}

# --- check 1 — linked worktree resolves its own core ------------------------

git -C "$ROOT" worktree remove --force "$WT" >/dev/null 2>&1   # clear a stale fixture only
if ! git -C "$ROOT" worktree add --detach "$WT" HEAD >/dev/null 2>&1; then
  echo "could not create the fixture worktree at $WT"; exit 2
fi
WT_P=$(cd "$WT" && pwd -P) || exit 2
WT_EXPECT="$WT_P/$SEMANTIC_REL"
[ -f "$WT_EXPECT" ] || { echo "fixture worktree has no core file at $WT_EXPECT"; exit 2; }

run_resolver "$WT_P"
if [ "$RC" -eq 0 ] && [ "$OUT" = "$WT_EXPECT" ]; then
  ok "check 1 — linked worktree resolves its own core"
else
  bad "check 1 — linked worktree resolves its own core" "rc=$RC out=${OUT:-<none>} err=${ERR:-<none>}"
fi

# --- check 2 — canonical checkout positive control --------------------------

ROOT_EXPECT="$ROOT/$SEMANTIC_REL"
run_resolver "$ROOT"
if [ "$RC" -eq 0 ] && [ "$OUT" = "$ROOT_EXPECT" ]; then
  ok "check 2 — canonical checkout resolves its own core"
else
  bad "check 2 — canonical checkout resolves its own core" "rc=$RC out=${OUT:-<none>} err=${ERR:-<none>}"
fi

# --- check 3 — unrelated repository negative control ------------------------

FAKE="$TMP/ai-resources-eval"
mkdir -p "$FAKE/$(dirname "$SEMANTIC_REL")" || exit 2
cp "$ROOT_EXPECT" "$FAKE/$SEMANTIC_REL" || exit 2
git -C "$FAKE" init -q >/dev/null 2>&1 || { echo "could not init the fake repo"; exit 2; }

run_resolver "$FAKE"
if [ "$RC" -ne 0 ] && [ -z "$OUT" ] && printf '%s' "$ERR" | grep -q 'direct_identity=untrusted'; then
  ok "check 3 — unrelated repo rejected, identity named"
else
  bad "check 3 — unrelated repo rejected, identity named" "rc=$RC out=${OUT:-<none>} err=${ERR:-<none>}"
fi

# --- check 4 — mirror parity ------------------------------------------------

extract_block "$CMD_FILE"   > "$TMP/block-cmd.txt"
extract_block "$SKILL_FILE" > "$TMP/block-skill.txt"
if [ -s "$TMP/block-cmd.txt" ] && cmp -s "$TMP/block-cmd.txt" "$TMP/block-skill.txt"; then
  ok "check 4 — deployed resolver blocks are byte-identical"
else
  bad "check 4 — deployed resolver blocks are byte-identical" "$(diff "$TMP/block-cmd.txt" "$TMP/block-skill.txt" | head -20)"
fi

# --- verdict ----------------------------------------------------------------

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
