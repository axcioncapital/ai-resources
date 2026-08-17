#!/bin/bash
# auto-sync-shared-guard-install.test.sh — focused regression test for the
# generated-guard installation and refresh that .claude/hooks/auto-sync-shared.sh
# performs beside its managed local-exclude write.
#
# The thing under test is a hook INSTALLER, so every fixture is a disposable
# throwaway repository under mktemp. This suite must never read, write, chmod or
# even stat a live installed hook — not in this checkout, not at the workspace
# root, not in any downstream project. The canonical bodies it needs are taken
# from the tracked files and from pinned Git objects, never from an installed
# `.git/hooks/pre-commit` anywhere on the machine.
#
# What it proves:
#
#   A. the gap and its closure — a manifest-bearing repository the real
#      generator has populated could commit a force-added generated destination
#      before this change, and is blocked after it;
#   B. the collision boundary — absent installs executable; identical is a
#      byte-AND-mtime no-op; a marker-bearing stale body refreshes; the one
#      pre-marker ancestor body refreshes; any other marker-less body (including
#      this repository's own older canonical body, which a header-similarity test
#      would have eaten) stays byte-identical and is reported; a symlink to a
#      project-owned hook is left alone, target included;
#   C. path and failure behaviour — a linked worktree installs to the SHARED
#      common hook surface; a non-repository directory and an unwritable hook
#      directory both exit successfully without corrupting anything; two runs
#      are idempotent.
#
# Usage: bash logs/scripts/auto-sync-shared-guard-install.test.sh
# Exit 0 = all assertions pass; exit 1 = at least one failed.

set -u

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)
REPO_TOP=$(cd "$SCRIPT_DIR/../.." && pwd -P)
SYNC_HOOK="$REPO_TOP/.claude/hooks/auto-sync-shared.sh"
PRECOMMIT="$REPO_TOP/.claude/hooks/pre-commit"
[ -f "$SYNC_HOOK" ] || { echo "FATAL: $SYNC_HOOK not found"; exit 1; }
[ -f "$PRECOMMIT" ] || { echo "FATAL: $PRECOMMIT not found"; exit 1; }

# Pinned Git objects. Both are load-bearing fixture inputs, not conveniences:
#   PRE_INSTALLER_REV — the generator body before this unit added the installer,
#                       which is what makes leg A's "before" a real measurement
#                       rather than a story about the past.
#   ANCESTOR_REV      — the last canonical pre-commit body before the provenance
#                       marker existed; the ONE body the installer may refresh
#                       without a marker.
#   OTHER_CANON_REV   — an OLDER canonical pre-commit body from this same
#                       repository's history. Marker-less and not the ancestor,
#                       so it must be left alone. This is the body measured on
#                       the workspace root, and the reason the ancestor set is a
#                       single exact digest rather than a family resemblance.
PRE_INSTALLER_REV="638ab8cc"
ANCESTOR_REV="638ab8cc"
OTHER_CANON_REV="3878b4de"

MARKER="# managed-by: auto-sync-shared.sh — canonical .claude/hooks/pre-commit"

TMP=$(mktemp -d) || exit 1
# chmod back anything the unwritable-directory case locked, or rm -rf cannot
# clear the fixture and the next run inherits it.
cleanup() { chmod -R u+rwX "$TMP" 2>/dev/null; rm -rf "$TMP"; }
trap cleanup EXIT

pass=0; fail=0; skip=0
ok()   { pass=$((pass+1)); printf 'ok   - %s\n' "$1"; }
bad()  { fail=$((fail+1)); printf 'FAIL - %s\n' "$1"; }
# A skip counts as neither. It must never be reported as a pass: an unreachable
# pinned object means the leg was not measured, and saying otherwise would be
# exactly the evidence-that-cannot-fail this suite exists to avoid.
skipped() { skip=$((skip+1)); printf 'skip - %s\n' "$1"; }

check() { # <description> <command...> — passes when the command succeeds
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$desc"; else bad "$desc"; fi
}
check_not() { # <description> <command...> — passes when the command fails
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then bad "$desc"; else ok "$desc"; fi
}

mtime_of() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null; }
sha_of()   { shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1; }

# The executing hook path, resolved the way the installer resolves it, so an
# assertion cannot silently check a different path from the one under test.
hook_path_of() { # <project-dir>
  local p top hp
  p="$1"
  top=$(git -C "$p" rev-parse --show-toplevel 2>/dev/null) || return 1
  hp=$(git -C "$p" rev-parse --git-path hooks/pre-commit 2>/dev/null) || return 1
  case "$hp" in /*) printf '%s' "$hp" ;; *) printf '%s' "$p/$hp" ;; esac
}

# A disposable workspace: real canonical ai-resources tree + a manifest-bearing
# project that is its own Git repository. Echoes the project directory.
build_ws() { # <workspace-dir> [generator-source]
  local ws="$1" gen="${2:-$SYNC_HOOK}" p
  mkdir -p "$ws/ai-resources/.claude/hooks" "$ws/ai-resources/.claude/commands" \
           "$ws/ai-resources/.claude/agents" "$ws/ai-resources/.agents/skills/diagnose-and-fix"
  cp "$gen" "$ws/ai-resources/.claude/hooks/auto-sync-shared.sh"
  cp "$PRECOMMIT" "$ws/ai-resources/.claude/hooks/pre-commit"
  echo shared-command > "$ws/ai-resources/.claude/commands/sharedcmd.md"
  echo shared-agent   > "$ws/ai-resources/.claude/agents/sharedagent.md"
  echo core-skill     > "$ws/ai-resources/.agents/skills/diagnose-and-fix/SKILL.md"
  p="$ws/projects/proj"
  mkdir -p "$p/.claude"
  git init -q "$p"
  git -C "$p" config user.email test@test.local
  git -C "$p" config user.name  test
  cat > "$p/.claude/shared-manifest.json" <<'EOF'
{ "commands": { "local": [] }, "agents": { "local": [] }, "skills": { "shared": [], "local": [] } }
EOF
  printf '%s' "$p"
}

run_gen() { # <project-dir> — echoes the hook's stdout (its JSON report, if any)
  CLAUDE_PROJECT_DIR="$1" bash "$1/../../ai-resources/.claude/hooks/auto-sync-shared.sh" 2>/dev/null
}

# ============================================================== leg A — the gap
echo "--- A: the gap and its closure (failing before, blocked after) ---"

# A1 "before": the pinned pre-installer generator installs no hook, so a
# force-added generated destination commits. Skipped, never passed, if the
# pinned object is unreachable (shallow or partial clone).
if git -C "$REPO_TOP" cat-file -e "$PRE_INSTALLER_REV:.claude/hooks/auto-sync-shared.sh" 2>/dev/null; then
  git -C "$REPO_TOP" show "$PRE_INSTALLER_REV:.claude/hooks/auto-sync-shared.sh" > "$TMP/gen-before.sh"
  P_BEFORE=$(build_ws "$TMP/ws-before" "$TMP/gen-before.sh")
  run_gen "$P_BEFORE" >/dev/null
  hp_before=$(hook_path_of "$P_BEFORE")
  check_not "before the change: no pre-commit is installed at the executing path" \
    test -e "$hp_before"
  git -C "$P_BEFORE" add -f .claude/commands/sharedcmd.md 2>/dev/null
  if git -C "$P_BEFORE" commit -qm "force-add generated destination" >/dev/null 2>&1; then
    ok "before the change: a force-added generated destination COMMITS (the gap)"
  else
    bad "before the change: a force-added generated destination COMMITS (the gap)"
  fi
else
  skipped "before-leg not measured: $PRE_INSTALLER_REV:.claude/hooks/auto-sync-shared.sh unreachable"
fi

# A2 "after": the current generator installs the guard, and the same force-add
# is refused with the path named and HEAD unmoved.
P_AFTER=$(build_ws "$TMP/ws-after")
out_after=$(run_gen "$P_AFTER")
hp_after=$(hook_path_of "$P_AFTER")
check "after the change: the guard is installed at the executing path" test -f "$hp_after"
check "after the change: the installed guard is executable"            test -x "$hp_after"
check "after the change: the installed body is canonical byte-for-byte" \
  cmp -s "$PRECOMMIT" "$hp_after"
check "after the change: the success report is scoped to this checkout" \
  bash -c 'printf %s "$1" | grep -q "this checkout only"' _ "$out_after"
check_not "after the change: the report claims no workspace-wide coverage" \
  bash -c 'printf %s "$1" | grep -qiE "30/30|workspace-wide|all projects"' _ "$out_after"

echo "ordinary" > "$P_AFTER/notes.md"
git -C "$P_AFTER" add notes.md
check "after the change: an ordinary commit still succeeds" \
  git -C "$P_AFTER" commit -qm "ordinary commit"

git -C "$P_AFTER" add -f .claude/commands/sharedcmd.md 2>/dev/null
head_before=$(git -C "$P_AFTER" rev-parse HEAD 2>/dev/null || echo none)
err="$TMP/commit-err"
if git -C "$P_AFTER" commit -qm "force-add generated destination" >/dev/null 2>"$err"; then
  bad "after the change: the force-added generated destination is BLOCKED"
else
  ok "after the change: the force-added generated destination is BLOCKED"
fi
head_after=$(git -C "$P_AFTER" rev-parse HEAD 2>/dev/null || echo none)
[ "$head_before" = "$head_after" ] \
  && ok "after the change: HEAD did not advance on the blocked commit" \
  || bad "after the change: HEAD did not advance on the blocked commit"
check "after the change: the block message names the staged generated path" \
  grep -q '\.claude/commands/sharedcmd\.md' "$err"

# ================================================ leg B — collision boundary
echo "--- B: the collision boundary ---"

# B1 absent → installed executable (covered above at A2); assert the marker is
# what an installed copy carries, since every later refresh depends on it.
check "B1 installed copy carries the provenance marker" \
  grep -Fxq "$MARKER" "$hp_after"

# B2 identical → byte-and-mtime no-op. The mtime is backdated first so a rewrite
# would be visible; without that, a same-second rewrite would look like a no-op.
touch -t 202001010000 "$hp_after"
b2_sha=$(sha_of "$hp_after"); b2_mtime=$(mtime_of "$hp_after")
run_gen "$P_AFTER" >/dev/null
[ "$(sha_of "$hp_after")" = "$b2_sha" ] \
  && ok "B2 identical body: bytes unchanged" || bad "B2 identical body: bytes unchanged"
[ "$(mtime_of "$hp_after")" = "$b2_mtime" ] \
  && ok "B2 identical body: mtime unchanged (no write at all)" \
  || bad "B2 identical body: mtime unchanged (no write at all)"

# B3 marker-bearing stale → refreshed.
P_B3=$(build_ws "$TMP/ws-b3")
hp_b3=$(hook_path_of "$P_B3")
mkdir -p "$(dirname "$hp_b3")"
{ printf '#!/bin/bash\n'; printf '%s\n' "$MARKER"; printf '# stale managed body\nexit 0\n'; } > "$hp_b3"
chmod +x "$hp_b3"
run_gen "$P_B3" >/dev/null
check "B3 marker-bearing stale body is refreshed to canonical" cmp -s "$PRECOMMIT" "$hp_b3"
check "B3 refreshed body is executable" test -x "$hp_b3"

# B4 the ONE pre-marker ancestor → refreshed to the marker-bearing body.
if git -C "$REPO_TOP" cat-file -e "$ANCESTOR_REV:.claude/hooks/pre-commit" 2>/dev/null; then
  P_B4=$(build_ws "$TMP/ws-b4")
  hp_b4=$(hook_path_of "$P_B4")
  mkdir -p "$(dirname "$hp_b4")"
  git -C "$REPO_TOP" show "$ANCESTOR_REV:.claude/hooks/pre-commit" > "$hp_b4"
  chmod +x "$hp_b4"
  anc_sha=$(sha_of "$hp_b4")
  check "B4 fixture sanity: the ancestor body is marker-LESS" \
    bash -c '! grep -Fxq "$1" "$2"' _ "$MARKER" "$hp_b4"
  check "B4 fixture sanity: the installer pins this exact digest as its ancestor" \
    grep -Fq "GUARD_ANCESTOR_SHA256=\"$anc_sha\"" "$SYNC_HOOK"
  run_gen "$P_B4" >/dev/null
  check "B4 exact pre-marker ancestor refreshes to canonical" cmp -s "$PRECOMMIT" "$hp_b4"
  check "B4 refreshed ancestor now carries the marker" grep -Fxq "$MARKER" "$hp_b4"
  check "B4 ancestor allowlist stays bounded to exactly one entry" \
    bash -c '[ "$(grep -c "^GUARD_ANCESTOR_SHA256=" "$1")" -eq 1 ]' _ "$SYNC_HOOK"
else
  skipped "B4 not measured: $ANCESTOR_REV:.claude/hooks/pre-commit unreachable"
fi

# B5 a DIFFERENT older canonical body — marker-less, not the ancestor. This is
# the body measured on the workspace root. It must survive untouched.
if git -C "$REPO_TOP" cat-file -e "$OTHER_CANON_REV:.claude/hooks/pre-commit" 2>/dev/null; then
  P_B5=$(build_ws "$TMP/ws-b5")
  hp_b5=$(hook_path_of "$P_B5")
  mkdir -p "$(dirname "$hp_b5")"
  git -C "$REPO_TOP" show "$OTHER_CANON_REV:.claude/hooks/pre-commit" > "$hp_b5"
  chmod +x "$hp_b5"
  touch -t 202001010000 "$hp_b5"
  b5_sha=$(sha_of "$hp_b5"); b5_mtime=$(mtime_of "$hp_b5")
  check "B5 fixture sanity: it is NOT the pinned ancestor digest" \
    bash -c '! grep -Fq "GUARD_ANCESTOR_SHA256=\"$1\"" "$2"' _ "$b5_sha" "$SYNC_HOOK"
  out_b5=$(run_gen "$P_B5")
  [ "$(sha_of "$hp_b5")" = "$b5_sha" ] \
    && ok "B5 project-owned marker-less body: bytes unchanged" \
    || bad "B5 project-owned marker-less body: bytes unchanged"
  [ "$(mtime_of "$hp_b5")" = "$b5_mtime" ] \
    && ok "B5 project-owned marker-less body: mtime unchanged" \
    || bad "B5 project-owned marker-less body: mtime unchanged"
  check "B5 the preserved body is reported, not silently skipped" \
    bash -c 'printf %s "$1" | grep -q "GENERATED-GUARD:.*project-owned"' _ "$out_b5"
else
  skipped "B5 not measured: $OTHER_CANON_REV:.claude/hooks/pre-commit unreachable"
fi

# B6 a symlink to a working project-owned guard: link, and the TARGET it points
# at, both survive. Following the link is the failure this case exists to catch.
P_B6=$(build_ws "$TMP/ws-b6")
hp_b6=$(hook_path_of "$P_B6")
mkdir -p "$(dirname "$hp_b6")" "$P_B6/.claude/hooks"
printf '#!/bin/bash\n# project-owned guard\nexit 0\n' > "$P_B6/.claude/hooks/own-guard.sh"
chmod +x "$P_B6/.claude/hooks/own-guard.sh"
target_sha=$(sha_of "$P_B6/.claude/hooks/own-guard.sh")
# Relative link shape, mirroring the two real projects that do this.
ln -s "../../.claude/hooks/own-guard.sh" "$hp_b6"
out_b6=$(run_gen "$P_B6")
check "B6 the hook path is still a symlink"        test -L "$hp_b6"
check "B6 the symlink still points at the project guard" \
  bash -c '[ "$(readlink "$1")" = "../../.claude/hooks/own-guard.sh" ]' _ "$hp_b6"
[ "$(sha_of "$P_B6/.claude/hooks/own-guard.sh")" = "$target_sha" ] \
  && ok "B6 the symlink TARGET was not overwritten" \
  || bad "B6 the symlink TARGET was not overwritten"
check "B6 the target guard is still executable" test -x "$P_B6/.claude/hooks/own-guard.sh"
# Match the distinctive collision wording, not the bare word "symlink": the
# other guard messages all contain "generated-symlink commit guard", so a loose
# grep here passed even with the symlink branch disabled.
check "B6 the preserved symlink is reported as a symlink collision" \
  bash -c 'printf %s "$1" | grep -q "is a symlink to a project-owned hook"' _ "$out_b6"

# B7 the ordering trap: a symlink whose TARGET is a marker-bearing body. Only the
# symlink-first test saves this one. Classify on `-f` first and the marker is
# found through the link, the body is judged refreshable, and the rename replaces
# the LINK with a regular file — silently detaching the project from its own
# hook. B6 alone cannot catch that, because its unrelated target happens to fall
# through to the safe project-owned branch.
P_B7=$(build_ws "$TMP/ws-b7")
hp_b7=$(hook_path_of "$P_B7")
mkdir -p "$(dirname "$hp_b7")" "$P_B7/.claude/hooks"
{ printf '#!/bin/bash\n'; printf '%s\n' "$MARKER"; printf '# project copy, reached only through the link\nexit 0\n'; } \
  > "$P_B7/.claude/hooks/linked-guard.sh"
chmod +x "$P_B7/.claude/hooks/linked-guard.sh"
b7_target_sha=$(sha_of "$P_B7/.claude/hooks/linked-guard.sh")
ln -s "../../.claude/hooks/linked-guard.sh" "$hp_b7"
out_b7=$(run_gen "$P_B7")
check "B7 a symlink over a marker-bearing target is STILL a symlink" test -L "$hp_b7"
check "B7 the symlink still points where it did" \
  bash -c '[ "$(readlink "$1")" = "../../.claude/hooks/linked-guard.sh" ]' _ "$hp_b7"
[ "$(sha_of "$P_B7/.claude/hooks/linked-guard.sh")" = "$b7_target_sha" ] \
  && ok "B7 the marker-bearing target was not refreshed through the link" \
  || bad "B7 the marker-bearing target was not refreshed through the link"
check "B7 the collision is reported rather than resolved" \
  bash -c 'printf %s "$1" | grep -q "is a symlink to a project-owned hook"' _ "$out_b7"

# B8 a canonical body that has LOST the marker must install nothing. An
# unrecognisable copy is worse than no copy: it could never be refreshed again,
# and it would be indistinguishable from a project-owned hook forever after.
P_B8=$(build_ws "$TMP/ws-b8")
grep -vxF "$MARKER" "$PRECOMMIT" > "$TMP/ws-b8/ai-resources/.claude/hooks/pre-commit"
hp_b8=$(hook_path_of "$P_B8")
out_b8=$(run_gen "$P_B8")
check_not "B8 a marker-less canonical body installs nothing" test -e "$hp_b8"
check "B8 the refusal is reported" \
  bash -c 'printf %s "$1" | grep -q "carries no provenance marker"' _ "$out_b8"

# ========================================== leg C — path and failure behaviour
echo "--- C: path resolution and failure behaviour ---"

# C1 a linked worktree must install to the SHARED common hook surface, not to
# its own private gitdir. Building `.git/hooks` from directory nesting fails
# here, because a worktree has no .git directory to nest into.
P_C1=$(build_ws "$TMP/ws-c1")
echo seed > "$P_C1/seed.md"; git -C "$P_C1" add seed.md
git -C "$P_C1" commit -qm seed >/dev/null 2>&1
WT="$TMP/ws-c1/wt"
if git -C "$P_C1" worktree add -q "$WT" -b wtbranch >/dev/null 2>&1; then
  cp -R "$P_C1/.claude" "$WT/.claude" 2>/dev/null
  common=$(git -C "$WT" rev-parse --git-common-dir)
  case "$common" in /*) ;; *) common="$WT/$common" ;; esac
  private=$(git -C "$WT" rev-parse --git-dir)
  case "$private" in /*) ;; *) private="$WT/$private" ;; esac
  CLAUDE_PROJECT_DIR="$WT" bash "$TMP/ws-c1/ai-resources/.claude/hooks/auto-sync-shared.sh" >/dev/null 2>&1
  check "C1 worktree installs to the shared common hook surface" \
    cmp -s "$PRECOMMIT" "$common/hooks/pre-commit"
  check_not "C1 worktree did NOT install into its private gitdir" \
    test -e "$private/hooks/pre-commit"
  git -C "$WT" add -f .claude/commands/sharedcmd.md 2>/dev/null
  wt_head=$(git -C "$WT" rev-parse HEAD)
  check_not "C1 the worktree's own commit is blocked by the shared guard" \
    git -C "$WT" commit -qm "force-add from worktree"
  [ "$(git -C "$WT" rev-parse HEAD)" = "$wt_head" ] \
    && ok "C1 worktree HEAD did not advance" || bad "C1 worktree HEAD did not advance"
else
  skipped "C1 not measured: git worktree add failed in the fixture"
fi

# C2 a manifest-bearing directory that is not a Git repository at all.
WS_C2="$TMP/ws-c2"
P_C2="$WS_C2/projects/proj"
mkdir -p "$WS_C2/ai-resources/.claude/hooks" "$WS_C2/ai-resources/.claude/commands" \
         "$WS_C2/ai-resources/.claude/agents" "$WS_C2/ai-resources/.agents/skills/diagnose-and-fix" \
         "$P_C2/.claude"
cp "$SYNC_HOOK" "$WS_C2/ai-resources/.claude/hooks/auto-sync-shared.sh"
cp "$PRECOMMIT" "$WS_C2/ai-resources/.claude/hooks/pre-commit"
echo shared-command > "$WS_C2/ai-resources/.claude/commands/sharedcmd.md"
echo core-skill     > "$WS_C2/ai-resources/.agents/skills/diagnose-and-fix/SKILL.md"
printf '{ "commands": { "local": [] }, "skills": { "shared": [], "local": [] } }\n' \
  > "$P_C2/.claude/shared-manifest.json"
if CLAUDE_PROJECT_DIR="$P_C2" bash "$WS_C2/ai-resources/.claude/hooks/auto-sync-shared.sh" >/dev/null 2>&1; then
  ok "C2 a non-repository project exits successfully"
else
  bad "C2 a non-repository project exits successfully"
fi
check_not "C2 no hook was fabricated outside a repository" test -e "$P_C2/.git/hooks/pre-commit"

# C3 an unwritable hook directory holding an existing hook: the run must succeed
# and the existing body must survive byte-for-byte. This is the forced
# write-failure case — real permissions, not a test-only switch inside the hook.
P_C3=$(build_ws "$TMP/ws-c3")
hp_c3=$(hook_path_of "$P_C3")
mkdir -p "$(dirname "$hp_c3")"
{ printf '#!/bin/bash\n'; printf '%s\n' "$MARKER"; printf '# stale but refreshable\nexit 0\n'; } > "$hp_c3"
chmod +x "$hp_c3"
c3_sha=$(sha_of "$hp_c3")
chmod 555 "$(dirname "$hp_c3")"
if CLAUDE_PROJECT_DIR="$P_C3" bash "$TMP/ws-c3/ai-resources/.claude/hooks/auto-sync-shared.sh" >"$TMP/c3.out" 2>/dev/null; then
  ok "C3 an unwritable hook directory still exits successfully (fail-open)"
else
  bad "C3 an unwritable hook directory still exits successfully (fail-open)"
fi
[ "$(sha_of "$hp_c3")" = "$c3_sha" ] \
  && ok "C3 the existing hook body survived the failed write" \
  || bad "C3 the existing hook body survived the failed write"
check_not "C3 no temp file was left beside the hook" \
  bash -c 'ls "$1"/.pre-commit.* >/dev/null 2>&1' _ "$(dirname "$hp_c3")"
check "C3 the write failure is reported" grep -q 'GENERATED-GUARD:' "$TMP/c3.out"
chmod 755 "$(dirname "$hp_c3")"

# C4 idempotence across two successful runs.
P_C4=$(build_ws "$TMP/ws-c4")
run_gen "$P_C4" >/dev/null
hp_c4=$(hook_path_of "$P_C4")
touch -t 202001010000 "$hp_c4"
c4_sha=$(sha_of "$hp_c4"); c4_mtime=$(mtime_of "$hp_c4")
run_gen "$P_C4" >/dev/null
[ "$(sha_of "$hp_c4")" = "$c4_sha" ] \
  && ok "C4 second run leaves the hook byte-identical" \
  || bad "C4 second run leaves the hook byte-identical"
[ "$(mtime_of "$hp_c4")" = "$c4_mtime" ] \
  && ok "C4 second run performs no write" || bad "C4 second run performs no write"
check "C4 the hook is still executable after two runs" test -x "$hp_c4"

echo "---"
echo "pass=$pass fail=$fail skip=$skip"
[ "$fail" -eq 0 ] || exit 1
exit 0
