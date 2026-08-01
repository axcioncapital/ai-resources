#!/bin/bash
# Regression harness for check-foreign-staging.sh — TARGET-REPOSITORY RESOLUTION.
#
# Work Loop v2 pilot unit 3, task `foreign-staging-target-repo`.
# Opened by Codex; state file: logs/work-loop/foreign-staging-target-repo.md
#
# WHAT THIS PROVES — that the tripwire judges a gated command against the git
#   repository the command will actually affect, and fails CLOSED when that
#   target cannot be parsed safely.
#
# WHY IT EXISTS — the hook resolves its repo from CLAUDE_PROJECT_DIR (or the hook
#   process cwd) and never from the command's target (check-foreign-staging.sh:223).
#   Around a nested repo that produces BOTH kinds of dangerous error:
#     • a false BLOCK on parent-repo paths the command cannot stage, and
#     • a SILENT PASS that inspects none of the paths the command will stage.
#   An unparseable subshell form bypasses gating entirely.
#
# ISOLATION — every case builds throwaway git repos under a mktemp -d root. This
#   harness NEVER reads or writes the live working tree, and never runs a real
#   `git add`; it feeds the hook a synthetic PreToolUse payload and reads the
#   verdict. Codex's opening brief requires this explicitly (premise 3).
#
# ASSERTION BAR — a case checks exit status AND candidate identity. Exit code
#   alone is not enough: a hook that checks the WRONG repository, or that merely
#   stops emitting the old message, must still fail here. Cases therefore assert
#   both "names the path it should" and "does NOT name the path it shouldn't".
#
# EXPECTED STATE AS OF THIS COMMIT: 4 RED, 2 GREEN. The four reds are the defect.
#   Do not "fix" this harness to make them pass — fix the hook.
#
# Usage:  bash logs/scripts/check-foreign-staging.test.sh
#         bash logs/scripts/check-foreign-staging.test.sh -v    (show hook output)

set -uo pipefail

HOOK="${HOOK_OVERRIDE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.claude/hooks/check-foreign-staging.sh}"
VERBOSE=0
[ "${1:-}" = "-v" ] && VERBOSE=1

if [ ! -f "$HOOK" ]; then
  echo "FATAL: hook not found at $HOOK" >&2
  exit 1
fi

PASS=0; FAIL=0; RED_EXPECTED=0
FAILED_NAMES=()

TMPROOT=$(mktemp -d)
trap 'rm -rf "$TMPROOT"' EXIT

FAKE_SESSION_ID="testharness-0000-1111-2222-333344445555"
MARKER="S99-tst"
TODAY=$(date '+%Y-%m-%d')

# ---------------------------------------------------------------------------
# fixture: parent repo containing a nested independent repo.
#
#   parent/                     git repo  ("workspace root" analogue)
#     logs/.session-marker-<id> "YYYY-MM-DD S99-tst"
#     logs/session-notes.md     footprint: src/parent-owned.txt
#     src/parent-owned.txt      dirty, IN parent footprint
#     parent-dirt.txt           dirty, OUT of parent footprint
#     nested/                   git repo  (project analogue)
#       logs/.session-marker-<id> + logs/session-notes.md
#       src/nested-owned.txt    dirty, IN nested footprint
#       nested-dirt.txt         dirty, OUT of nested footprint   (unless $2 = infootprint)
#
# $1 = fixture dir name. $2 = "infootprint" to put ALL nested dirt inside the
# nested footprint (used by the allow-case).
# ---------------------------------------------------------------------------
make_fixture() {
  local name="$1" mode="${2:-}"
  local root="$TMPROOT/$name"
  mkdir -p "$root"

  _mkrepo() {
    local d="$1" footprint="$2"
    mkdir -p "$d/logs" "$d/src"
    git -C "$d" init -q
    git -C "$d" config user.email "harness@test.local"
    git -C "$d" config user.name  "harness"
    # one committed file so the repo has a HEAD and `git status` is meaningful
    echo "seed" > "$d/seed.txt"
    git -C "$d" add seed.txt
    git -C "$d" commit -q -m "seed"
    printf '%s %s\n' "$TODAY" "$MARKER" > "$d/logs/.session-marker-$FAKE_SESSION_ID"
    # em-dash in the header is required by the hook's header_re — keep it literal.
    cat > "$d/logs/session-notes.md" <<NOTES
# Session Notes

## $TODAY — Session $MARKER

**Mandate:** harness fixture — done when: the harness says so.
- Out of scope: (none stated)
- Files in scope: $footprint
- Stop if: (none stated)
NOTES
  }

  _mkrepo "$root/parent" "src/parent-owned.txt"
  echo "dirty" > "$root/parent/src/parent-owned.txt"
  echo "dirty" > "$root/parent/parent-dirt.txt"

  # The parent must not see the nested repo at all. This mirrors the live
  # workspace, where `git -C <root> status -- projects/<nested>` returns ZERO
  # entries — and it is what makes the silent-pass symptom reproducible.
  #
  # ⚠ Without this line the parent lists `nested/` as an untracked directory,
  # C3 blocks on `nested/`, and the case goes red for the WRONG mechanism —
  # detecting "judged the wrong repo" but never reproducing the silent pass
  # the defect record describes. Caught by running it, 2026-08-01.
  echo "nested/" > "$root/parent/.gitignore"
  git -C "$root/parent" add .gitignore
  git -C "$root/parent" commit -q -m "ignore nested repo"

  _mkrepo "$root/parent/nested" "src/nested-owned.txt"
  echo "dirty" > "$root/parent/nested/src/nested-owned.txt"
  if [ "$mode" != "infootprint" ]; then
    echo "dirty" > "$root/parent/nested/nested-dirt.txt"
  fi

  echo "$root"
}

# run_hook <cwd> <claude_project_dir> <command> [payload_cwd]  -> sets RC and OUT
#
# payload_cwd defaults to <cwd>, which is the PRODUCTION shape: a real PreToolUse
# payload carries a `cwd` key equal to the Bash tool's cwd (verified by execution
# 2026-08-01 — the live payload keys are cwd, effort, hook_event_name,
# permission_mode, prompt_id, session_id, tool_input, tool_name, tool_use_id,
# transcript_path). Pass the literal __OMIT__ to drop the key and exercise the
# os.getcwd() fallback instead. Until this parameter existed the harness sent NO
# cwd key at all, so every case tested the fallback and none tested production —
# the hook could have ignored the payload field entirely and still gone green.
run_hook() {
  local cwd="$1" cpd="$2" cmd="$3" payload_cwd="${4-$1}"
  local payload
  payload=$(python3 -c '
import json,sys
d = {"tool_name": "Bash", "tool_input": {"command": sys.argv[1]}}
if sys.argv[2] != "__OMIT__":
    d["cwd"] = sys.argv[2]
print(json.dumps(d))' "$cmd" "$payload_cwd")
  OUT=$(cd "$cwd" && printf '%s' "$payload" | \
        CLAUDE_PROJECT_DIR="$cpd" CLAUDE_CODE_SESSION_ID="$FAKE_SESSION_ID" \
        bash "$HOOK" 2>&1)
  RC=$?
}

# assert <name> <expect_red|expect_green> <condition-description> <0-or-1 result>
assert() {
  local name="$1" band="$2" desc="$3" ok="$4"
  if [ "$ok" -eq 1 ]; then
    PASS=$((PASS+1)); printf '  PASS  %-38s %s\n' "$name" "$desc"
  else
    FAIL=$((FAIL+1)); FAILED_NAMES+=("$name")
    if [ "$band" = "expect_red" ]; then
      RED_EXPECTED=$((RED_EXPECTED+1))
      printf '  RED   %-38s %s\n' "$name" "$desc"
    else
      printf '  FAIL  %-38s %s\n' "$name" "$desc"
    fi
  fi
  [ "$VERBOSE" -eq 1 ] && { echo "        rc=$RC"; echo "$OUT" | sed 's/^/        | /'; }
  return 0
}

echo "check-foreign-staging.sh — target-repository resolution harness"
echo "hook: $HOOK"
echo

# ===========================================================================
echo "C1  nested cwd must judge the NESTED repo (currently judges the parent)"
# ===========================================================================
R=$(make_fixture c1)
run_hook "$R/parent/nested" "$R/parent" "git add ."
# Correct behaviour: blocks, naming nested-dirt.txt, and never mentions parent dirt.
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "nested-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C1_nested_cwd_uses_nested_dirt" expect_red \
  "blocks on nested-dirt.txt only, never parent-dirt.txt" "$ok"

# ===========================================================================
echo "C2  nested cwd, all nested dirt IN footprint -> must ALLOW"
# ===========================================================================
R=$(make_fixture c2 infootprint)
run_hook "$R/parent/nested" "$R/parent" "git add ."
ok=0; [ "$RC" -eq 0 ] && ok=1
assert "C2_nested_cwd_infootprint_allows" expect_red \
  "exit 0 — parent dirt is unreachable from this cwd" "$ok"

# --- C2b: positive identity for C2 (FP-9 remedy) ----------------------------
# C2 asserts ONLY `exit 0`, which a dead hook satisfies for free — proven by
# running the whole harness against a no-op stub, where C2 stayed green. An
# assertion that cannot fail is not evidence, so C2's green counts only when
# paired with this companion: the SAME fixture and the SAME command, differing
# by one file that the nested footprint does not cover. A live hook must block
# and name it; a dead hook exits 0 and fails here. Do not delete one without
# the other.
echo "$(printf 'dirty')" > "$R/parent/nested/late-dirt.txt"
run_hook "$R/parent/nested" "$R/parent" "git add ."
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "late-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C2b_same_fixture_still_blocks_foreign" expect_green \
  "proves C2's exit 0 came from a LIVE hook, not a dead one" "$ok"

# ===========================================================================
echo "C3  'cd nested && git add .' must match the C1 decision (currently silent pass)"
# ===========================================================================
R=$(make_fixture c3)
run_hook "$R/parent" "$R/parent" "cd nested && git add ."
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "nested-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C3_cd_compound_matches_nested" expect_red \
  "blocks on nested-dirt.txt — not a silent pass" "$ok"

# ===========================================================================
echo "C4  '(cd nested; git add .)' must FAIL CLOSED (currently ungated)"
# ===========================================================================
R=$(make_fixture c4)
run_hook "$R/parent" "$R/parent" "(cd nested; git add .)"
ok=0; [ "$RC" -eq 2 ] && ok=1
assert "C4_subshell_fails_closed" expect_red \
  "exit 2 — unresolvable target must block, never warn-and-allow" "$ok"

# ===========================================================================
echo "C5  ordinary same-repo wide add — behaviour must be UNCHANGED (control)"
# ===========================================================================
R=$(make_fixture c5)
run_hook "$R/parent" "$R/parent" "git add ."
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C5_same_repo_wide_add_unchanged" expect_green \
  "still blocks on parent-dirt.txt" "$ok"

# ===========================================================================
echo "C6  explicit-pathspec add stays UNGATED (control)"
# ===========================================================================
R=$(make_fixture c6)
run_hook "$R/parent" "$R/parent" "git add src/parent-owned.txt"
ok=0; [ "$RC" -eq 0 ] && [ -z "$OUT" ] && ok=1
assert "C6_explicit_pathspec_ungated" expect_green \
  "exit 0, no output — explicit adds are not gated" "$ok"

# ===========================================================================
echo "C7  the payload's cwd governs, not the hook process's cwd"
# ===========================================================================
# The two diverge in production the moment the operator's Bash cwd differs from
# where the hook process happens to start, and the whole repair rests on reading
# the payload. Here the hook PROCESS runs in the parent while the PAYLOAD says
# nested: a hook honouring the payload blocks on nested dirt, one falling back to
# its own cwd blocks on parent dirt. Without this case the hook could ignore the
# payload key entirely and every other case would still pass.
R=$(make_fixture c7)
run_hook "$R/parent" "$R/parent" "git add ." "$R/parent/nested"
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "nested-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C7_payload_cwd_beats_process_cwd" expect_green \
  "judges the payload's repo, not the process's" "$ok"

# ===========================================================================
echo "C8  no payload cwd -> falls back to the process cwd (compatibility)"
# ===========================================================================
# The fallback must keep working: a caller that sends no cwd key (an older or
# non-Claude-Code invoker) must still be judged against the process cwd rather
# than crashing or degrading open.
R=$(make_fixture c8)
run_hook "$R/parent/nested" "$R/parent" "git add ." "__OMIT__"
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "nested-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C8_absent_payload_cwd_falls_back" expect_green \
  "process cwd still judged when the payload omits cwd" "$ok"

echo
echo "-------------------------------------------------------------"
echo "passed: $PASS    failed: $FAIL    (of which expected-red: $RED_EXPECTED)"
if [ "$FAIL" -gt 0 ]; then
  echo "failed cases: ${FAILED_NAMES[*]}"
fi
echo
if [ "$FAIL" -eq "$RED_EXPECTED" ] && [ "$RED_EXPECTED" -gt 0 ]; then
  echo "STATE: RED as designed — the $RED_EXPECTED defect cases fail, both controls pass."
  echo "       This is the pre-fix baseline. Exit 1 is CORRECT here."
  exit 1
elif [ "$FAIL" -eq 0 ]; then
  echo "STATE: GREEN — target-repository resolution is repaired."
  exit 0
else
  echo "STATE: UNEXPECTED — a control case failed, or a red case passed."
  echo "       Investigate before trusting either result."
  exit 1
fi
