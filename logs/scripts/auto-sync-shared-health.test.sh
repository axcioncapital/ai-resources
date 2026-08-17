#!/bin/bash
# auto-sync-shared-health.test.sh — focused regression test for the generated-link
# health validation that .claude/hooks/auto-sync-shared.sh performs after it has
# generated its symlinks and written its managed local-exclude block.
#
# The thing under test reports on symlinks, Git tracking and a local exclude file,
# so every fixture is a disposable throwaway repository under mktemp. This suite
# must never read, write, delete or re-link a live generated symlink, a live local
# exclude file, a live installed hook or a live Git setting — not in this checkout,
# not at the workspace root, not in any downstream project. The generator bodies it
# needs come from the tracked file and from one pinned Git object.
#
# What it proves:
#
#   A. the gap and its closure — a managed destination pointing at a resolving but
#      WRONG target is silently preserved by the pinned pre-health generator, and
#      is preserved AND reported by the implemented one;
#   B. healthy normal checkout — command, agent, core-skill and manifest-opted
#      skill destinations are relative symlinks resolving to canonical, untracked,
#      covered by the exact managed block, and silent under the health prefix;
#      deleting them and rerunning regenerates them with no tracked-file change
#      and no `git status --porcelain` noise;
#   C. healthy nested checkout — the same proof inside a real linked worktree at a
#      different directory depth, whose links carry a different relative target and
#      resolve to the same canonical resources, and whose exclude surface covers
#      exactly its own generated destinations;
#   D. unhealthy Git state — a tracked generated destination under unusable block
#      coverage is reported by path with both reasons, stays byte-untouched, and
#      the run still exits 0; a project-owned regular file at a managed name stays
#      unignored, untouched, and is never reported as a healthy generated symlink;
#   E. negative controls — two targeted mutations of a disposable copy of the
#      generator each make a leg-A/leg-D verdict disappear, so those assertions
#      are bound to the code and not to wording this suite supplies.
#
# Usage: bash logs/scripts/auto-sync-shared-health.test.sh
# Exit 0 = all assertions pass; exit 1 = at least one failed.

set -u

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)
REPO_TOP=$(cd "$SCRIPT_DIR/../.." && pwd -P)
SYNC_HOOK="$REPO_TOP/.claude/hooks/auto-sync-shared.sh"
PRECOMMIT="$REPO_TOP/.claude/hooks/pre-commit"
[ -f "$SYNC_HOOK" ] || { echo "FATAL: $SYNC_HOOK not found"; exit 1; }
[ -f "$PRECOMMIT" ] || { echo "FATAL: $PRECOMMIT not found"; exit 1; }

# The generator body immediately BEFORE health validation existed. This is what
# makes leg A's "before" a measurement rather than a story about the past; if the
# object is unreachable (shallow or partial clone) the leg is SKIPPED, never passed.
PRE_HEALTH_REV="d0d90237"
# The Unit 6 implementation commit, before its one frozen correction: it validated
# symlink health but silently reclassified any non-symlink at a managed name as
# project-owned. Leg F's before-leg measures that gap against this body.
PRE_NONLINK_REV="be42752e"

TMP=$(mktemp -d) || exit 1
cleanup() { chmod -R u+rwX "$TMP" 2>/dev/null; rm -rf "$TMP"; }
trap cleanup EXIT

pass=0; fail=0; skip=0
ok()      { pass=$((pass+1)); printf 'ok   - %s\n' "$1"; }
bad()     { fail=$((fail+1)); printf 'FAIL - %s\n' "$1"; }
skipped() { skip=$((skip+1)); printf 'skip - %s\n' "$1"; }

check() { # <description> <command...> — passes when the command succeeds
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$desc"; else bad "$desc"; fi
}
check_not() { # <description> <command...> — passes when the command fails
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then bad "$desc"; else ok "$desc"; fi
}

realpath_of() { python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$1"; }
relpath_of()  { python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$1" "$2"; }
mtime_of()    { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null; }

# A symlink is relative AND resolves to the expected canonical source. Same shape
# as auto-sync-shared-excludes.test.sh, deliberately: both suites must agree on
# what a correct generated link is.
link_ok() { # <link> <expected-source>
  local rl
  [ -L "$1" ] || return 1
  rl=$(readlink "$1") || return 1
  case "$rl" in /*) return 1 ;; esac
  [ "$(realpath_of "$1")" = "$(realpath_of "$2")" ]
}

contains() { # <haystack> <needle>
  case "$1" in *"$2"*) return 0 ;; *) return 1 ;; esac
}

# The GENERATED-HEALTH part of the hook's report, isolated from every other
# prefix. Scoping matters: the drift prefix names paths too, so an unscoped grep
# for a filename would pass on the wrong message entirely.
health_segment() { # <hook-output>
  printf '%s' "$1" | tr '|' '\n' | grep 'GENERATED-HEALTH:' || true
}

# The block the generator wrote, read out of whatever exclude surface Git resolves
# for that checkout — the same consumption the hook and the commit guard perform.
exclude_block_of() { # <checkout-dir>
  local f b e
  f=$(git -C "$1" rev-parse --git-path info/exclude 2>/dev/null) || return 1
  case "$f" in /*) ;; *) f="$1/$f" ;; esac
  [ -f "$f" ] || return 1
  b=$(sed -n 's/^EXCL_BEGIN="\(.*\)"$/\1/p' "$SYNC_HOOK" | head -1)
  e=$(sed -n 's/^EXCL_END="\(.*\)"$/\1/p' "$SYNC_HOOK" | head -1)
  awk -v b="$b" -v e="$e" '$0==e{inb=0} inb{print} $0==b{inb=1}' "$f"
}

mutate() { # <src> <dest> <find> <replace> — exit 3 when the target text is absent
  python3 - "$1" "$2" "$3" "$4" <<'PY'
import sys
src, dst, find, repl = sys.argv[1:5]
s = open(src).read()
if find not in s:
    sys.exit(3)
open(dst, 'w').write(s.replace(find, repl, 1))
PY
}

# A disposable workspace: a canonical ai-resources tree plus a manifest-bearing
# project that is its own Git repository, with the manifest committed so
# `git status --porcelain` is a meaningful assertion later.
build_ws() { # <workspace-dir> — echoes the project directory
  local ws="$1" p
  mkdir -p "$ws/ai-resources/.claude/hooks" "$ws/ai-resources/.claude/commands" \
           "$ws/ai-resources/.claude/agents" \
           "$ws/ai-resources/.agents/skills/diagnose-and-fix" \
           "$ws/ai-resources/.agents/skills/optskill"
  cp "$SYNC_HOOK" "$ws/ai-resources/.claude/hooks/auto-sync-shared.sh"
  cp "$PRECOMMIT" "$ws/ai-resources/.claude/hooks/pre-commit"
  echo shared-command > "$ws/ai-resources/.claude/commands/sharedcmd.md"
  echo drift-source   > "$ws/ai-resources/.claude/commands/driftcmd.md"
  # Canonical, but declared commands.local in the manifest below — so the sync
  # loops drop it BEFORE note_generated runs and it never enters the traversal.
  # Leg F needs that to prove a genuinely owned resource stays silent.
  echo local-source   > "$ws/ai-resources/.claude/commands/localcmd.md"
  echo shared-agent   > "$ws/ai-resources/.claude/agents/sharedagent.md"
  echo core-skill     > "$ws/ai-resources/.agents/skills/diagnose-and-fix/SKILL.md"
  echo optin-skill    > "$ws/ai-resources/.agents/skills/optskill/SKILL.md"
  # A resolvable target that is NOT a canonical managed resource — leg A points a
  # managed name at this to get a link that resolves and is still wrong.
  echo decoy > "$ws/decoy.md"

  p="$ws/projects/proj"
  mkdir -p "$p/.claude"
  git init -q "$p"
  git -C "$p" config user.email test@test.local
  git -C "$p" config user.name  test
  cat > "$p/.claude/shared-manifest.json" <<'EOF'
{
  "commands": { "local": ["localcmd"] },
  "agents":   { "local": [] },
  "skills":   { "shared": ["optskill"], "local": [] }
}
EOF
  git -C "$p" add .claude/shared-manifest.json >/dev/null 2>&1
  git -C "$p" commit -q --no-verify -m "manifest" >/dev/null 2>&1
  printf '%s' "$p"
}

run_gen() { # <project-dir> <generator-path> — echoes the hook's stdout
  CLAUDE_PROJECT_DIR="$1" bash "$2" 2>/dev/null
}

# The four representative destinations every leg asserts over, as
# checkout-relative paths paired with their canonical source under <ws>.
GEN_RELS=".claude/commands/sharedcmd.md
.claude/agents/sharedagent.md
.agents/skills/diagnose-and-fix
.agents/skills/optskill"

# Every destination the fixture's canonical set generates. This is GEN_RELS plus
# driftcmd.md, which build_ws puts in canonical for leg D's project-owned-file
# case and which therefore generates a link like any other in every other leg.
# The exclusivity assertion needs the WHOLE set: comparing the block against the
# four representative paths alone would report a correct block as wrong.
ALL_GEN_RELS="$GEN_RELS
.claude/commands/driftcmd.md"

canonical_for() { # <ws> <checkout-relative-destination>
  case "$2" in
    .claude/commands/*) printf '%s' "$1/ai-resources/.claude/commands/${2##*/}" ;;
    .claude/agents/*)   printf '%s' "$1/ai-resources/.claude/agents/${2##*/}" ;;
    .agents/skills/*)   printf '%s' "$1/ai-resources/.agents/skills/${2##*/}" ;;
  esac
}

# ======================================================== leg A — gap and closure
echo "--- A: a resolving but WRONG target (silent before, reported after) ---"

P_A=$(build_ws "$TMP/ws-a")
WS_A="$TMP/ws-a"
mkdir -p "$P_A/.claude/commands"
wrong_rel=$(relpath_of "$WS_A/decoy.md" "$P_A/.claude/commands")
ln -s "$wrong_rel" "$P_A/.claude/commands/sharedcmd.md"
before_link=$(readlink "$P_A/.claude/commands/sharedcmd.md")

check "A the planted link resolves (so this is not merely a dangling-link test)" \
  test -e "$P_A/.claude/commands/sharedcmd.md"
check_not "A the planted link does NOT resolve to its canonical source" \
  link_ok "$P_A/.claude/commands/sharedcmd.md" "$WS_A/ai-resources/.claude/commands/sharedcmd.md"

if git -C "$REPO_TOP" cat-file -e "$PRE_HEALTH_REV:.claude/hooks/auto-sync-shared.sh" 2>/dev/null; then
  git -C "$REPO_TOP" show "$PRE_HEALTH_REV:.claude/hooks/auto-sync-shared.sh" > "$TMP/gen-before.sh"
  out_before=$(run_gen "$P_A" "$TMP/gen-before.sh"); rc_before=$?
  [ "$rc_before" -eq 0 ] \
    && ok "A before: the pinned pre-health generator exits 0" \
    || bad "A before: the pinned pre-health generator exits 0"
  [ -z "$(health_segment "$out_before")" ] \
    && ok "A before: NO generated-health verdict is produced (the gap)" \
    || bad "A before: NO generated-health verdict is produced (the gap)"
  [ "$(readlink "$P_A/.claude/commands/sharedcmd.md")" = "$before_link" ] \
    && ok "A before: the wrong link is preserved untouched" \
    || bad "A before: the wrong link is preserved untouched"
else
  skipped "A before-leg not measured: $PRE_HEALTH_REV:.claude/hooks/auto-sync-shared.sh unreachable"
fi

out_after=$(run_gen "$P_A" "$SYNC_HOOK"); rc_after=$?
seg_after=$(health_segment "$out_after")
[ "$rc_after" -eq 0 ] \
  && ok "A after: the implemented generator exits 0 (fail-open)" \
  || bad "A after: the implemented generator exits 0 (fail-open)"
check "A after: a generated-health verdict is produced" \
  bash -c 'printf %s "$1" | grep -q "GENERATED-HEALTH:"' _ "$seg_after"
check "A after: the affected path is named" \
  bash -c 'printf %s "$1" | grep -q "\.claude/commands/sharedcmd\.md"' _ "$seg_after"
check "A after: the reason is that it resolves elsewhere than canonical" \
  bash -c 'printf %s "$1" | grep -q "not to the canonical"' _ "$seg_after"
[ "$(readlink "$P_A/.claude/commands/sharedcmd.md")" = "$before_link" ] \
  && ok "A after: the unhealthy link is left byte-untouched, not repaired" \
  || bad "A after: the unhealthy link is left byte-untouched, not repaired"

# ================================================ leg B — healthy normal checkout
echo "--- B: healthy normal checkout, and idempotent regeneration ---"

P_B=$(build_ws "$TMP/ws-b")
WS_B="$TMP/ws-b"
out_b=$(run_gen "$P_B" "$SYNC_HOOK"); rc_b=$?
seg_b=$(health_segment "$out_b")
block_b=$(exclude_block_of "$P_B" || true)

[ "$rc_b" -eq 0 ] && ok "B the run exits 0" || bad "B the run exits 0"
[ -z "$seg_b" ] \
  && ok "B a fully healthy checkout is SILENT under the health prefix" \
  || bad "B a fully healthy checkout is SILENT under the health prefix"

while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  check "B $rel is a relative symlink resolving to canonical" \
    link_ok "$P_B/$rel" "$(canonical_for "$WS_B" "$rel")"
  check_not "B $rel is absent from git ls-files" \
    git -C "$P_B" ls-files --error-unmatch -- "$rel"
  check "B $rel is covered by the exact managed block" \
    bash -c 'printf %s\\n "$1" | grep -qxF "/$2"' _ "$block_b" "$rel"
done <<EOF
$GEN_RELS
EOF

while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  rm -rf "$P_B/$rel"
done <<EOF
$GEN_RELS
EOF
out_b2=$(run_gen "$P_B" "$SYNC_HOOK")
seg_b2=$(health_segment "$out_b2")
regen_ok=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  link_ok "$P_B/$rel" "$(canonical_for "$WS_B" "$rel")" || regen_ok=1
done <<EOF
$GEN_RELS
EOF
[ "$regen_ok" -eq 0 ] \
  && ok "B deleting the links and rerunning regenerates all four healthily" \
  || bad "B deleting the links and rerunning regenerates all four healthily"
[ -z "$seg_b2" ] \
  && ok "B the regenerated checkout is still silent under the health prefix" \
  || bad "B the regenerated checkout is still silent under the health prefix"
check "B regeneration leaves no git status noise" \
  bash -c '[ -z "$(git -C "$1" status --porcelain)" ]' _ "$P_B"
check "B regeneration changes no tracked file" \
  git -C "$P_B" diff --quiet HEAD

# ================================================ leg C — healthy nested checkout
echo "--- C: healthy linked worktree at a different depth ---"

P_C=$(build_ws "$TMP/ws-c")
WS_C="$TMP/ws-c"
out_c_main=$(run_gen "$P_C" "$SYNC_HOOK")
main_target=$(readlink "$P_C/.claude/commands/sharedcmd.md" 2>/dev/null || true)
[ -z "$(health_segment "$out_c_main")" ] \
  && ok "C the main checkout is healthy before the worktree exists" \
  || bad "C the main checkout is healthy before the worktree exists"

WT="$WS_C/projects/deep/nest/proj-wt"
if git -C "$P_C" worktree add -q "$WT" -b wtbranch >/dev/null 2>&1; then
  out_c=$(run_gen "$WT" "$SYNC_HOOK"); rc_c=$?
  seg_c=$(health_segment "$out_c")
  block_c=$(exclude_block_of "$WT" || true)

  [ "$rc_c" -eq 0 ] && ok "C the worktree run exits 0" || bad "C the worktree run exits 0"
  [ -z "$seg_c" ] \
    && ok "C the worktree checkout is silent under the health prefix" \
    || bad "C the worktree checkout is silent under the health prefix"

  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    check "C worktree $rel is a relative symlink resolving to canonical" \
      link_ok "$WT/$rel" "$(canonical_for "$WS_C" "$rel")"
  done <<EOF
$GEN_RELS
EOF

  wt_target=$(readlink "$WT/.claude/commands/sharedcmd.md" 2>/dev/null || true)
  if [ -n "$wt_target" ] && [ -n "$main_target" ] && [ "$wt_target" != "$main_target" ]; then
    ok "C the worktree link carries a DIFFERENT relative target for its depth"
  else
    bad "C the worktree link carries a DIFFERENT relative target for its depth"
  fi
  if [ -n "$wt_target" ] && \
     [ "$(realpath_of "$WT/.claude/commands/sharedcmd.md")" = "$(realpath_of "$P_C/.claude/commands/sharedcmd.md")" ]; then
    ok "C both depths resolve to the same canonical resource"
  else
    bad "C both depths resolve to the same canonical resource"
  fi

  expected_c=$(printf '/%s\n' $(printf '%s\n' "$ALL_GEN_RELS") | LC_ALL=C sort)
  actual_c=$(printf '%s\n' "$block_c" | grep . | LC_ALL=C sort)
  [ "$expected_c" = "$actual_c" ] \
    && ok "C the worktree exclude surface covers EXACTLY its generated destinations" \
    || bad "C the worktree exclude surface covers EXACTLY its generated destinations"
else
  skipped "C not measured: git worktree add failed in the fixture"
fi

# ================================================== leg D — unhealthy Git state
echo "--- D: tracked destination under unusable block coverage ---"

P_D=$(build_ws "$TMP/ws-d")
WS_D="$TMP/ws-d"
mkdir -p "$P_D/.claude/commands"
good_rel=$(relpath_of "$WS_D/ai-resources/.claude/commands/sharedcmd.md" "$P_D/.claude/commands")
ln -s "$good_rel" "$P_D/.claude/commands/sharedcmd.md"
git -C "$P_D" add -f .claude/commands/sharedcmd.md >/dev/null 2>&1
git -C "$P_D" commit -q --no-verify -m "track a generated destination" >/dev/null 2>&1
# A project-owned regular file at a managed name — must survive untouched and
# must never be reported as a healthy generated symlink.
echo project-owned-copy > "$P_D/.claude/commands/driftcmd.md"
# Hand-mangled exclude file: two BEGIN markers, so the generator's block
# maintenance refuses to touch it and coverage becomes unusable.
excl_d="$P_D/.git/info/exclude"
mkdir -p "$(dirname "$excl_d")"
excl_begin=$(sed -n 's/^EXCL_BEGIN="\(.*\)"$/\1/p' "$SYNC_HOOK" | head -1)
excl_end=$(sed -n 's/^EXCL_END="\(.*\)"$/\1/p' "$SYNC_HOOK" | head -1)
{ printf '%s\n' "$excl_begin"; printf '%s\n' "$excl_begin"; printf '%s\n' "$excl_end"; } > "$excl_d"

d_link_before=$(readlink "$P_D/.claude/commands/sharedcmd.md")
d_mtime_before=$(mtime_of "$P_D/.claude/commands/sharedcmd.md")
d_drift_before=$(cat "$P_D/.claude/commands/driftcmd.md")
d_excl_before=$(cat "$excl_d")

check "D the planted destination really is tracked before the run" \
  git -C "$P_D" ls-files --error-unmatch -- .claude/commands/sharedcmd.md

out_d=$(run_gen "$P_D" "$SYNC_HOOK"); rc_d=$?
seg_d=$(health_segment "$out_d")

[ "$rc_d" -eq 0 ] \
  && ok "D the run exits 0 despite unhealthy state (fail-open)" \
  || bad "D the run exits 0 despite unhealthy state (fail-open)"
check "D the tracked destination is named" \
  bash -c 'printf %s "$1" | grep -q "\.claude/commands/sharedcmd\.md"' _ "$seg_d"
check "D the tracking failure is reported" \
  bash -c 'printf %s "$1" | grep -q "tracked by Git"' _ "$seg_d"
check "D the ignore-coverage failure is reported" \
  bash -c 'printf %s "$1" | grep -q "not covered by the managed block"' _ "$seg_d"
[ "$(readlink "$P_D/.claude/commands/sharedcmd.md")" = "$d_link_before" ] \
  && ok "D the unhealthy destination keeps its exact link target" \
  || bad "D the unhealthy destination keeps its exact link target"
[ "$(mtime_of "$P_D/.claude/commands/sharedcmd.md")" = "$d_mtime_before" ] \
  && ok "D the unhealthy destination was not rewritten (mtime unchanged)" \
  || bad "D the unhealthy destination was not rewritten (mtime unchanged)"
[ "$(cat "$excl_d")" = "$d_excl_before" ] \
  && ok "D the hand-mangled exclude file is left exactly as found" \
  || bad "D the hand-mangled exclude file is left exactly as found"

check "D the regular-file collision is still a regular file, not a link" \
  bash -c '[ -f "$1" ] && [ ! -L "$1" ]' _ "$P_D/.claude/commands/driftcmd.md"
[ "$(cat "$P_D/.claude/commands/driftcmd.md")" = "$d_drift_before" ] \
  && ok "D the regular-file collision is byte-untouched" \
  || bad "D the regular-file collision is byte-untouched"
check_not "D the regular-file collision stays unignored" \
  git -C "$P_D" check-ignore -q .claude/commands/driftcmd.md
check "D the undeclared regular-file collision IS reported as not a symlink" \
  bash -c 'printf %s "$1" | grep -q "driftcmd\.md: not a symlink, a regular file"' _ "$seg_d"
# The separate drift message keeps its own ownership: this copy DIFFERS from
# canonical, so both findings fire on one file and neither replaces the other.
check "D the separate AI-RESOURCES DRIFT message still fires for the differing copy" \
  bash -c 'printf %s "$1" | tr "|" "\n" | grep "AI-RESOURCES DRIFT" | grep -q "driftcmd\.md"' _ "$out_d"

# ==================================================== leg E — negative controls
echo "--- E: negative controls (mutations must make the verdicts disappear) ---"

# E1 neuter the resolved-target comparison; leg A's fixture must fall silent.
if mutate "$SYNC_HOOK" "$TMP/gen-mut-target.sh" \
     '[ "$health_phys" != "$health_src_phys" ]' 'false'; then
  P_E1=$(build_ws "$TMP/ws-e1")
  WS_E1="$TMP/ws-e1"
  mkdir -p "$P_E1/.claude/commands"
  ln -s "$(relpath_of "$WS_E1/decoy.md" "$P_E1/.claude/commands")" \
        "$P_E1/.claude/commands/sharedcmd.md"
  seg_e1=$(health_segment "$(run_gen "$P_E1" "$TMP/gen-mut-target.sh")")
  [ -z "$seg_e1" ] \
    && ok "E1 with the target comparison neutered, the wrong-target verdict disappears" \
    || bad "E1 with the target comparison neutered, the wrong-target verdict disappears"
else
  skipped "E1 not measured: the target-comparison mutation target was not found"
fi

# E2 neuter the tracked-set lookup; a tracked destination under HEALTHY coverage
# must fall silent. The control is paired: the unmutated generator on the same
# fixture shape reports it.
if mutate "$SYNC_HOOK" "$TMP/gen-mut-tracked.sh" \
     'health_tracked=$(git -C "$repo_top" ls-files -z -- "${h_rels[@]}" 2>/dev/null | tr '"'"'\0'"'"' '"'"'\n'"'"')' \
     'health_tracked=""'; then
  build_tracked_fixture() { # <ws> — echoes the project dir, one tracked destination
    local p ws="$1" rel
    p=$(build_ws "$ws")
    mkdir -p "$p/.claude/commands"
    rel=$(relpath_of "$ws/ai-resources/.claude/commands/sharedcmd.md" "$p/.claude/commands")
    ln -s "$rel" "$p/.claude/commands/sharedcmd.md"
    git -C "$p" add -f .claude/commands/sharedcmd.md >/dev/null 2>&1
    git -C "$p" commit -q --no-verify -m "track" >/dev/null 2>&1
    printf '%s' "$p"
  }
  P_E2A=$(build_tracked_fixture "$TMP/ws-e2a")
  seg_e2a=$(health_segment "$(run_gen "$P_E2A" "$SYNC_HOOK")")
  check "E2 control: the unmutated generator reports the tracked destination" \
    bash -c 'printf %s "$1" | grep -q "tracked by Git"' _ "$seg_e2a"

  P_E2B=$(build_tracked_fixture "$TMP/ws-e2b")
  seg_e2b=$(health_segment "$(run_gen "$P_E2B" "$TMP/gen-mut-tracked.sh")")
  check_not "E2 with the tracked-set lookup neutered, the tracking verdict disappears" \
    bash -c 'printf %s "$1" | grep -q "tracked by Git"' _ "$seg_e2b"
else
  skipped "E2 not measured: the tracked-set mutation target was not found"
fi

# ============================== leg F — undeclared non-symlink collisions
echo "--- F: undeclared collisions on generated names vs declared locals ---"

# The case no other message can see. A BYTE-IDENTICAL regular copy at a managed
# command name is silent under AI-RESOURCES DRIFT (which only reports differing
# content) and skills have no drift pass at all, while neither ever enters the
# managed exclude block — so before this correction such a collision could be
# committed with no verdict anywhere.
P_F=$(build_ws "$TMP/ws-f")
WS_F="$TMP/ws-f"
mkdir -p "$P_F/.claude/commands" "$P_F/.agents/skills"
cp "$WS_F/ai-resources/.claude/commands/driftcmd.md" "$P_F/.claude/commands/driftcmd.md"
# A declared local resource at a managed name: the manifest owns it, so the sync
# loops drop it before the traversal and health must stay silent about it.
echo project-owned > "$P_F/.claude/commands/localcmd.md"
# A real directory at a CORE skill name — undeclared, and the surface with no
# drift pass whatsoever.
mkdir -p "$P_F/.agents/skills/diagnose-and-fix"
echo project-local-skill > "$P_F/.agents/skills/diagnose-and-fix/SKILL.md"

f_ident_before=$(cat "$P_F/.claude/commands/driftcmd.md")
f_local_before=$(cat "$P_F/.claude/commands/localcmd.md")
f_skill_before=$(cat "$P_F/.agents/skills/diagnose-and-fix/SKILL.md")

out_f=$(run_gen "$P_F" "$SYNC_HOOK"); rc_f=$?
seg_f=$(health_segment "$out_f")

[ "$rc_f" -eq 0 ] && ok "F the run exits 0" || bad "F the run exits 0"
check "F the byte-identical regular collision is reported as not a symlink" \
  bash -c 'printf %s "$1" | grep -q "driftcmd\.md: not a symlink, a regular file"' _ "$seg_f"
check "F the report names the manifest-local correction for a command" \
  bash -c 'printf %s "$1" | grep -q "commands\.local"' _ "$seg_f"
check_not "F no AI-RESOURCES DRIFT message fires for it (the gap health now covers)" \
  bash -c 'printf %s "$1" | grep -q "AI-RESOURCES DRIFT"' _ "$out_f"
[ "$(cat "$P_F/.claude/commands/driftcmd.md")" = "$f_ident_before" ] \
  && ok "F the byte-identical collision is left byte-untouched" \
  || bad "F the byte-identical collision is left byte-untouched"
check_not "F the byte-identical collision stays unignored" \
  git -C "$P_F" check-ignore -q .claude/commands/driftcmd.md
check "F it is still a regular file, not replaced by a link" \
  bash -c '[ -f "$1" ] && [ ! -L "$1" ]' _ "$P_F/.claude/commands/driftcmd.md"

check "F the undeclared skill DIRECTORY is reported as not a symlink" \
  bash -c 'printf %s "$1" | grep -q "\.agents/skills/diagnose-and-fix: not a symlink, a directory"' _ "$seg_f"
check "F the report names the manifest-local correction for a skill" \
  bash -c 'printf %s "$1" | grep -q "skills\.local"' _ "$seg_f"
[ "$(cat "$P_F/.agents/skills/diagnose-and-fix/SKILL.md")" = "$f_skill_before" ] \
  && ok "F the undeclared skill directory is left byte-untouched" \
  || bad "F the undeclared skill directory is left byte-untouched"
check_not "F the undeclared skill directory stays unignored" \
  git -C "$P_F" check-ignore -q .agents/skills/diagnose-and-fix
check "F the undeclared skill directory is still a real directory, not a link" \
  bash -c '[ -d "$1" ] && [ ! -L "$1" ]' _ "$P_F/.agents/skills/diagnose-and-fix"

check_not "F a manifest-DECLARED local resource is never reported" \
  bash -c 'printf %s "$1" | grep -q "localcmd\.md"' _ "$seg_f"
[ "$(cat "$P_F/.claude/commands/localcmd.md")" = "$f_local_before" ] \
  && ok "F the declared local resource is byte-untouched" \
  || bad "F the declared local resource is byte-untouched"
check_not "F the declared local resource stays unignored" \
  git -C "$P_F" check-ignore -q .claude/commands/localcmd.md

# The before-leg for this correction, measured the same way leg A measures the
# unit's own before: the pinned generator that had health validation but silently
# reclassified a non-symlink as project-owned. On the identical-copy fixture it
# emits no verdict at all — no health entry AND no drift entry — which is the gap.
if git -C "$REPO_TOP" cat-file -e "$PRE_NONLINK_REV:.claude/hooks/auto-sync-shared.sh" 2>/dev/null; then
  git -C "$REPO_TOP" show "$PRE_NONLINK_REV:.claude/hooks/auto-sync-shared.sh" > "$TMP/gen-pre-nonlink.sh"
  P_F2=$(build_ws "$TMP/ws-f2")
  mkdir -p "$P_F2/.claude/commands"
  cp "$TMP/ws-f2/ai-resources/.claude/commands/driftcmd.md" "$P_F2/.claude/commands/driftcmd.md"
  # Without this the collision would never be planted and every "before"
  # assertion below would pass vacuously — the exact evidence-that-cannot-fail
  # this suite exists to avoid.
  check "F before: the identical collision really is planted as a regular file" \
    bash -c '[ -f "$1" ] && [ ! -L "$1" ]' _ "$P_F2/.claude/commands/driftcmd.md"
  out_f2=$(run_gen "$P_F2" "$TMP/gen-pre-nonlink.sh"); rc_f2=$?
  seg_f2=$(health_segment "$out_f2")
  [ "$rc_f2" -eq 0 ] \
    && ok "F before: the pinned pre-correction generator exits 0" \
    || bad "F before: the pinned pre-correction generator exits 0"
  check_not "F before: it emits NO health verdict for the identical collision (the gap)" \
    bash -c 'printf %s "$1" | grep -q "driftcmd\.md"' _ "$seg_f2"
  check_not "F before: it emits no drift verdict either, so the collision was wholly silent" \
    bash -c 'printf %s "$1" | grep -q "AI-RESOURCES DRIFT"' _ "$out_f2"
  check_not "F before: the collision was neither ignored nor coverable by the commit guard" \
    git -C "$P_F2" check-ignore -q .claude/commands/driftcmd.md
else
  skipped "F before-leg not measured: $PRE_NONLINK_REV:.claude/hooks/auto-sync-shared.sh unreachable"
fi

echo "---"
echo "pass=$pass fail=$fail skip=$skip"
[ "$fail" -eq 0 ] || exit 1
exit 0
