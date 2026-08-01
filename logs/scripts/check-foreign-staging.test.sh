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
#
# MODES (2026-08-01, correction 1). The footprint always lives in the PARENT —
# it is the SESSION repo, and the marker contract makes the mandate relative to
# where /prime ran, not to whatever repo a command later targets. A `nosession`
# nested repo carries no logs/ at all, which is the originating real case: a
# session rooted in the workspace, staging into a freshly-initialised nested repo.
#
#   (default)             parent footprint covers parent only; nested has own logs/
#   infootprint           parent footprint covers the NESTED file; nested dirt = owned only
#   nosession             parent footprint covers parent only; nested has NO logs/
#   nosession-infootprint parent footprint covers the NESTED file; nested has NO logs/
#   spacedir              like default, but the nested dir is named `nested dir`
make_fixture() {
  local name="$1" mode="${2:-}"
  local root="$TMPROOT/$name"
  mkdir -p "$root"

  _mkrepo() {
    local d="$1" footprint="$2" nosession="${3:-}"
    mkdir -p "$d/src"
    if [ -n "$nosession" ]; then
      # No logs/, no marker, no session-notes — the target repo knows nothing
      # about this session. Reading the footprint from HERE is the defect.
      git -C "$d" init -q
      git -C "$d" config user.email "harness@test.local"
      git -C "$d" config user.name  "harness"
      echo "seed" > "$d/seed.txt"
      git -C "$d" add seed.txt
      git -C "$d" commit -q -m "seed"
      return 0
    fi
    mkdir -p "$d/logs"
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

  local nested_name="nested"
  [ "$mode" = "spacedir" ] && nested_name="nested dir"

  # The SESSION footprint. For the *-infootprint modes it must name the NESTED
  # path, because the footprint is read from the session repo (the parent) — the
  # nested repo's own mandate is never consulted.
  local parent_fp="src/parent-owned.txt"
  case "$mode" in
    infootprint|nosession-infootprint) parent_fp="$nested_name/src/nested-owned.txt" ;;
  esac

  _mkrepo "$root/parent" "$parent_fp"
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
  echo "$nested_name/" > "$root/parent/.gitignore"
  git -C "$root/parent" add .gitignore
  git -C "$root/parent" commit -q -m "ignore nested repo"

  local nosession=""
  case "$mode" in nosession|nosession-infootprint) nosession="nosession" ;; esac

  _mkrepo "$root/parent/$nested_name" "src/nested-owned.txt" "$nosession"
  echo "dirty" > "$root/parent/$nested_name/src/nested-owned.txt"
  case "$mode" in
    infootprint|nosession-infootprint) : ;;
    *) echo "dirty" > "$root/parent/$nested_name/nested-dirt.txt" ;;
  esac

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

# ===========================================================================
echo "C9  session state ONLY in the parent, nested in-footprint -> must ALLOW"
# ===========================================================================
# Codex correction 1. The nested repo carries NO logs/, no marker, no mandate —
# the originating real case. The footprint must be read from the SESSION repo
# (the parent) and translated into the target's coordinates. Reading it from the
# target finds no marker at all, which turns the guard OFF and exits non-blocking
# for the wrong reason.
R=$(make_fixture c9 nosession-infootprint)
run_hook "$R/parent/nested" "$R/parent" "git add ."
ok=0; [ "$RC" -eq 0 ] && ok=1
assert "C9_session_scope_infootprint_allows" expect_green \
  "parent-declared footprint covers the nested file" "$ok"

# ===========================================================================
echo "C10 session state ONLY in the parent, nested out-of-footprint -> must BLOCK"
# ===========================================================================
# The paired must-block half of C9 — without it, C9's exit 0 is satisfied by a
# guard that simply gave up on finding a footprint. Also pins that unrelated
# parent dirt never enters the target's candidate set.
R=$(make_fixture c10 nosession)
run_hook "$R/parent/nested" "$R/parent" "git add ."
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "nested-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C10_session_scope_outfootprint_blocks" expect_green \
  "blocks on nested dirt using the PARENT's footprint, never parent dirt" "$ok"

# ===========================================================================
echo "C11 a QUOTED leading cd resolves to the right repo (not the base)"
# ===========================================================================
# Codex correction 2. _command_text_only() blanks quoted spans, so
# `cd "nested dir" && git add .` reached the target parser as `cd "" && …` and
# resolved to the BASE repo silently. Quoted paths are the normal case in this
# workspace — every checkout path contains spaces — so this must resolve, not
# fail closed. A regression here reads as "blocks on parent-dirt.txt".
R=$(make_fixture c11 spacedir)
run_hook "$R/parent" "$R/parent" 'cd "nested dir" && git add .'
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "nested-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C11_quoted_cd_resolves_target" expect_green \
  "quoted path with a space resolves to the nested repo" "$ok"

# ===========================================================================
echo "C12 a VARIABLE leading cd still fails closed"
# ===========================================================================
# The other half of correction 2: resolving quoted literals must not open the
# door to shell evaluation. `$VAR` is unresolvable without running the shell, so
# a wide add carrying one must still exit 2.
R=$(make_fixture c12)
run_hook "$R/parent" "$R/parent" 'cd "$TARGET_DIR" && git add .'
ok=0; [ "$RC" -eq 2 ] && ok=1
assert "C12_variable_cd_fails_closed" expect_green \
  "exit 2 — a \$VAR path is never evaluated" "$ok"

# ---------------------------------------------------------------------------
# Plain-subdirectory-project fixture (Codex correction 2, 2026-08-01).
#
# `docs/session-marker.md:97` — a project may be a plain SUBDIRECTORY of a repo
# and still keep its own logs/session-notes.md and marker namespace. Here the
# session state exists ONLY at <parent>/proj/logs; the parent repo has NO logs/
# at all. Resolving the session root by `git rev-parse --show-toplevel` lands on
# <parent>, finds no session state, and disables the guard.
#
#   parent/            git repo, NO logs/
#     parent-dirt.txt  dirty, outside the project entirely
#     proj/            plain subdirectory — NOT a git repo
#       logs/          marker + mandate live HERE and nowhere else
#       src/proj-owned.txt  dirty, IN footprint
#       proj-dirt.txt       dirty, OUT of footprint  (unless $2 = infootprint)
# ---------------------------------------------------------------------------
make_subproject_fixture() {
  local name="$1" mode="${2:-}"
  local root="$TMPROOT/$name"
  mkdir -p "$root/parent/proj/logs" "$root/parent/proj/src"
  git -C "$root/parent" init -q
  git -C "$root/parent" config user.email "harness@test.local"
  git -C "$root/parent" config user.name  "harness"
  echo "seed" > "$root/parent/seed.txt"
  git -C "$root/parent" add seed.txt
  git -C "$root/parent" commit -q -m "seed"

  # Session state ONLY here. Footprint is project-relative, per the cwd-relative
  # marker contract — NOT relative to the enclosing git repo.
  printf '%s %s\n' "$TODAY" "$MARKER" > "$root/parent/proj/logs/.session-marker-$FAKE_SESSION_ID"
  cat > "$root/parent/proj/logs/session-notes.md" <<NOTES
# Session Notes

## $TODAY — Session $MARKER

**Mandate:** subdirectory-project fixture — done when: the harness says so.
- Out of scope: (none stated)
- Files in scope: src/proj-owned.txt
- Stop if: (none stated)
NOTES

  # Commit the session-state files so they are not themselves candidates.
  #
  # NOT cosmetic, and NOT hiding anything: the exempt-list for a session's own
  # byproducts tests `path.startswith("logs/")`, which is REPO-root-relative, so in
  # a subdirectory project the marker at `proj/logs/.session-marker-*` is not
  # recognised as exempt and reads as a foreign file. That is a SEPARATE coordinate
  # gap from the footprint-root question these two cases exist to test, and it is
  # outside this correction's stated scope — so it is reported to Codex rather than
  # fixed here, and the fixture is kept from conflating the two. Committing them is
  # also the realistic shape: a project's marker is normally already tracked.
  git -C "$root/parent" add proj/logs
  git -C "$root/parent" commit -q -m "project session state"

  echo "dirty" > "$root/parent/parent-dirt.txt"
  echo "dirty" > "$root/parent/proj/src/proj-owned.txt"
  [ "$mode" = "infootprint" ] || echo "dirty" > "$root/parent/proj/proj-dirt.txt"
  echo "$root"
}

# ===========================================================================
echo "C13 subdirectory project, in-footprint -> must ALLOW"
# ===========================================================================
R=$(make_subproject_fixture c13 infootprint)
run_hook "$R/parent/proj" "$R/parent/proj" "git add ."
ok=0; [ "$RC" -eq 0 ] && ok=1
assert "C13_subproject_infootprint_allows" expect_green \
  "project-relative footprint read from proj/logs, not the repo root" "$ok"

# ===========================================================================
echo "C14 subdirectory project, out-of-footprint -> must BLOCK"
# ===========================================================================
# The discriminating half. Under git-toplevel resolution the session root is the
# PARENT, which has no logs/ — so no footprint is found, the guard switches off,
# and this case allows instead of blocking. C13 alone cannot see that, for the
# same reason C9 alone could not see the previous defect: "allowed" is also what
# a guard that gave up returns.
R=$(make_subproject_fixture c14)
run_hook "$R/parent/proj" "$R/parent/proj" "git add ."
ok=0
if [ "$RC" -eq 2 ] && echo "$OUT" | grep -q "proj-dirt.txt" && ! echo "$OUT" | grep -q "parent-dirt.txt"; then ok=1; fi
assert "C14_subproject_outfootprint_blocks" expect_green \
  "blocks on proj dirt; parent dirt never enters the candidate set" "$ok"

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
