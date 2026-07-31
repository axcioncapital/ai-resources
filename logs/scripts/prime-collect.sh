#!/usr/bin/env bash
# prime-collect.sh — THE executing owner of /prime's mechanical state collection.
#
# Owns every bounded read orientation needs: the last session-notes entry, its Next Steps bullets,
# the merged multi-repo commit set since that entry's date, the newest continuity scratchpad, the
# plan-position cascade, the active-mission scan, the next-up queue, the shared-file concurrency
# advisory and the telemetry-gap test. Extracted from prime.md Steps 1 / 1a / 1b / 1c / 1d on
# 2026-07-30 (stream 2026-07-30-prime-session-entry-ownership, slice S5).
#
# THIS SCRIPT COLLECTS; IT DOES NOT JUDGE. Every classification /prime performs on this output —
# which Next Step is likely-DONE, whether a scratchpad is worth resuming, what the readiness verdict
# is, which mission is actionable — stays in the command. Adding a verdict here would move judgement
# out of the layer the operator reads and into a layer they never see.
#
# Rationale for the read SHAPES below is not restated here — docs/heavy-read-discipline.md
# § Bounded-read recipes is the authority for Steps 1 and 1c; docs/backlog-reconciliation.md is the
# authority for the merged multi-repo scan (this script is that primitive's reference implementation).
#
# CONTRACT
#   Usage:  prime-collect.sh [AI_RESOURCES]
#           AI_RESOURCES is the shared repo merged into the commit and mission scans. Defaults to the
#           path below, which is what /prime relies on. It is an ARGUMENT rather than a bare constant
#           for the same reason prime-sync.sh takes one: without it, logs/scripts/prime-collect.test.sh
#           could not run a single case without scanning the operator's live checkout, and a suite
#           whose results depend on production state is not a falsification harness.
#   cwd:    the repository being oriented. The CALLER locates this script by ABSOLUTE path and leaves
#           cwd alone, so one copy serves every consumer checkout.
#   stdout: scalar labels (`LABEL: value`) and fenced multi-line blocks:
#             ===BEGIN {LABEL}===
#             …
#             ===END {LABEL}===
#           Fence chosen because no markdown source read here can produce that line. Blocks appear in
#           this order and an ABSENT BLOCK MEANS THAT SOURCE DOES NOT EXIST HERE — never an error:
#             CWD_REPO         scalar, always present
#             TELEMETRY_GAP    scalar, always present (`yes` | `no`)
#             LAST_ENTRY       last session-notes entry, header to EOF
#             NEXT_STEPS       that entry's `### Next Steps` bullets
#             COMMITS          merged `%h %s` across cwd + ai-resources + sibling project repos
#             SCRATCHPAD       newest continuity scratchpad's path + its `## Resume With` line
#             POSITION         plan position: source file, evidence slice, optional corroboration
#             MISSIONS         active missions as `{id} | {name} | {repo}` + unchecked open threads
#             NEXT_UP          unchecked `- [ ]` lines from logs/next-up.md
#             FOREIGN_SHARED   foreign-dirty shared files, only when a sibling session is same-day
#   exit:   0 ALWAYS. Orientation must not stop because a source is missing, unreadable or malformed.
#
#   CWD_REPO IS RE-EMITTED HERE ON PURPOSE. prime-sync.sh already emits it and the two never disagree —
#   both resolve it through `rev-parse --show-toplevel`. It is repeated so this script is runnable and
#   testable standalone, and so a future caller that skips the sync still gets a self-describing block.
#
# NO MARKER-FILE SCAN LIVES HERE, AND ONE MUST NOT BE ADDED.
#   Concurrent-session LIVENESS is the SessionStart hook's (.claude/hooks/detect-concurrent-session.sh).
#   The hook derives it from the process table plus the marker set and emits a systemMessage — it
#   persists nothing, so a later shell process cannot read its answer, and a rescan from here would be
#   a second, weaker implementation of the same question (marker-only: cannot tell a live session from
#   a crashed one). /prime consumes the hook's message from session context instead.
#   FOREIGN_SHARED below is NOT that check: it reads the git working tree, never a marker file.
#
# BOUNDS ARE THE POINT — every read here is capped. A future edit that "simplifies" a bounded read
# into a plain full read is a regression, not a simplification (heavy-read-discipline.md § Step 1c).

set -u

AI_RESOURCES="${1:-/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources}"

TODAY=$(date '+%Y-%m-%d')

# ---- roots ------------------------------------------------------------------------------------
# CWD_REPO is the git toplevel; ROOT is what file reads are scoped to. They differ in exactly one
# case — cwd is not a checkout — where reporting `(none)` (matching prime-sync.sh) must not also
# disable the file-based collection, which works fine without git.
CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null || true)
if [ -n "$CWD_REPO" ]; then
  ROOT="$CWD_REPO"
  printf 'CWD_REPO: %s\n' "$CWD_REPO"
else
  ROOT="$(pwd)"
  printf 'CWD_REPO: (none)\n'
fi

NOTES="$ROOT/logs/session-notes.md"

open_block  () { printf '===BEGIN %s===\n' "$1"; }
close_block () { printf '===END %s===\n' "$1"; }

# ---- the repo set the multi-repo scans share --------------------------------------------------
# Built once and reused by COMMITS and MISSIONS. Both scans answered the same "which repos" question
# separately in prime.md, and the mission half was observed being skipped because it was written as
# an instruction to remember rather than as a mechanism (usage-log 2026-07-17). One list, one answer.
REPOS=""
add_repo () {
  _top=$(git -C "$1" rev-parse --show-toplevel 2>/dev/null) || return 0
  case "
$REPOS" in
    *"
$_top
"*) return 0 ;;                      # already in the set — physical paths, canonicalised by git
  esac
  REPOS="$REPOS$_top
"
}
[ -n "$CWD_REPO" ] && add_repo "$CWD_REPO"
add_repo "$AI_RESOURCES"
AI_TOP=$(git -C "$AI_RESOURCES" rev-parse --show-toplevel 2>/dev/null || true)
if [ -n "$AI_TOP" ]; then
  WORKSPACE_ROOT="$(dirname "$AI_TOP")"
  for d in "$WORKSPACE_ROOT"/projects/*/; do
    [ -d "$d" ] || continue
    add_repo "$d"
  done
fi

# ---- LAST_ENTRY + its date --------------------------------------------------------------------
# Located by grepping for the last `^## [0-9]` header and reading header-to-EOF. NEVER a fixed
# last-N-lines window: same-day sibling entries make any fixed window straddle two sessions
# (heavy-read-discipline.md § Step 1).
ENTRY_DATE=""
ENTRY_TEXT=""
if [ -f "$NOTES" ] && [ -s "$NOTES" ]; then
  START=$(grep -n "^## [0-9]" "$NOTES" 2>/dev/null | tail -n 1 | cut -d: -f1)
  if [ -n "${START:-}" ]; then
    ENTRY_TEXT=$(sed -n "${START},\$p" "$NOTES")
    # `## 2026-07-30 — title` → the second field. Anchored to the header we just located, so a date
    # appearing inside the body cannot be picked up instead.
    ENTRY_DATE=$(printf '%s\n' "$ENTRY_TEXT" | head -n 1 | awk '{print $2}')
    open_block LAST_ENTRY
    printf '%s\n' "$ENTRY_TEXT"
    close_block LAST_ENTRY
  fi
fi

# ---- NEXT_STEPS -------------------------------------------------------------------------------
# The bullets under the entry's `### Next Steps`, stopping at the next `###`. Emitted separately from
# LAST_ENTRY so the caller adjudicates a list, not a prose section it has to re-find.
if [ -n "$ENTRY_TEXT" ]; then
  NEXT_STEPS=$(printf '%s\n' "$ENTRY_TEXT" \
    | awk '/^### Next Steps/{f=1;next} f&&/^### /{exit} f&&/^[-*] /{print}')
  if [ -n "$NEXT_STEPS" ]; then
    open_block NEXT_STEPS
    printf '%s\n' "$NEXT_STEPS"
    close_block NEXT_STEPS
  fi
fi

# ---- COMMITS ----------------------------------------------------------------------------------
# THE MERGED SET IS THE POINT — DO NOT NARROW IT TO THE CWD REPO. A Next Step is frequently resolved
# by a commit that landed in ai-resources or in a sibling project repo; a cwd-only scan reports that
# work as still-open and spends a menu slot on it. `--all` because the resolving commit may sit on a
# branch that is not checked out. Rationale: docs/backlog-reconciliation.md.
#
# TWO BOUNDS, BOTH DISCLOSED IN THE OUTPUT — and the reason they exist is measured, not theoretical.
#   The window used to be the entry date with no floor. Run from a consumer repo whose last wrapped
#   session was months back, that window × ~20 sibling repos × `--all` emitted 2,816 commit lines into
#   orientation (observed 2026-07-30, projects/axcion-ai-system-owner). As an instruction in prime.md
#   this cost was occasional — a model reading the step might scope it narrower. Mechanised, it became
#   reliable, which is why the bound belongs here and not in the caller.
#   1. FLOOR the window at 30 days. Older commits cannot usefully adjudicate last session's Next
#      Steps, and the fall-through posture on a miss is "still-open" — the safe direction.
#   2. CAP the emitted lines. Truncation is ANNOUNCED, never silent: a caller that cannot see it was
#      truncated will read absence as "no commit resolved this" and demote nothing.
COMMITS_CAP=400
if [ -n "$ENTRY_DATE" ] && [ -n "$REPOS" ]; then
  # `date -v` is BSD/macOS, `date -d` is GNU. Try both, and fall back to the unfloored entry date
  # rather than to a broken window if neither works.
  FLOOR=$(date -v-30d '+%Y-%m-%d' 2>/dev/null || date -d '30 days ago' '+%Y-%m-%d' 2>/dev/null || true)
  WINDOW="$ENTRY_DATE"
  if [ -n "${FLOOR:-}" ] && [[ "$ENTRY_DATE" < "$FLOOR" ]]; then WINDOW="$FLOOR"; fi
  COMMITS=$(printf '%s' "$REPOS" | while IFS= read -r r; do
    [ -n "$r" ] || continue
    git -C "$r" log --since="${WINDOW}T00:00:00" --pretty="%h %s" --all 2>/dev/null
  done)
  if [ -n "$COMMITS" ]; then
    TOTAL=$(printf '%s\n' "$COMMITS" | wc -l | tr -d ' ')
    open_block COMMITS
    printf 'window: since %s (entry date %s%s)\n' "$WINDOW" "$ENTRY_DATE" \
      "$( [ "$WINDOW" != "$ENTRY_DATE" ] && printf ', floored at 30 days' )"
    printf '%s\n' "$COMMITS" | head -n "$COMMITS_CAP"
    if [ "$TOTAL" -gt "$COMMITS_CAP" ]; then
      printf 'truncated: %s of %s commits shown — treat unmatched Next Steps as still-open\n' \
        "$COMMITS_CAP" "$TOTAL"
    fi
    close_block COMMITS
  fi
fi

# ---- SCRATCHPAD -------------------------------------------------------------------------------
# Newest by FILESYSTEM MTIME, never by the timestamp in the filename: that timestamp is typed by the
# session that wrote the file and skews hours, so lexical filename order does not track chronological
# order. logs/scratchpads/ is gitignored, so mtime is always the real local write time.
SP=$(ls -t "$ROOT"/logs/scratchpads/*-scratchpad.md 2>/dev/null | head -n 1)
if [ -n "${SP:-}" ] && [ -f "$SP" ]; then
  SP_DATE=$(date -r "$SP" '+%Y-%m-%d' 2>/dev/null || true)
  # Older than the last wrap → a later wrap superseded it, skip silently. Lexical compare is exact on
  # ISO dates. No entry date (first session) → surface it: there is no wrap that could have superseded.
  if [ -z "${ENTRY_DATE:-}" ] || [ -z "${SP_DATE:-}" ] || ! [[ "$SP_DATE" < "$ENTRY_DATE" ]]; then
    RESUME=$(awk '/^## Resume With/{f=1;next} f&&/^## /{exit} f&&NF{print;exit}' "$SP")
    open_block SCRATCHPAD
    printf 'path: %s\n' "$SP"
    printf 'mtime: %s\n' "${SP_DATE:-unknown}"
    [ -n "${RESUME:-}" ] && printf 'resume_with: %s\n' "$RESUME"
    close_block SCRATCHPAD
  fi
fi

# ---- POSITION ---------------------------------------------------------------------------------
# The cascade from project-next-steps.md Step 2, with ONE DELIBERATE DIVERGENCE THAT IS NOT A BUG:
# position is checked BEFORE the plan spine. Do not "correct" it back — a maintained state file is a
# stronger signal than an inferred one, and checking it first is what makes this a no-op in the
# common case. Zero cost in any repo without a plan (ai-resources itself is one).
POS_SOURCE=""
PLAN_FILE=""
if [ -f "$ROOT/pipeline/pipeline-state.md" ]; then
  POS_SOURCE="$ROOT/pipeline/pipeline-state.md"
  open_block POSITION
  printf 'source: %s\n' "$POS_SOURCE"
  printf 'kind: state-file\n'
  printf -- '---\n'
  # The stage table states position directly. Capped: a state file that has grown past 80 lines is
  # carrying something other than a stage table, and orientation is not the place to read it.
  head -n 80 "$POS_SOURCE"
  close_block POSITION
else
  # Spine resolution — RESOLVE TO EXACTLY ONE FILE BEFORE READING. Two of the four candidates are not
  # files, and the bounded-read recipe below is undefined for a directory or a glob.
  if [ -f "$ROOT/pipeline/project-plan.md" ]; then
    PLAN_FILE="$ROOT/pipeline/project-plan.md"
  elif [ -d "$ROOT/plan" ]; then
    # Lexically first *.md still carrying an incomplete marker — not every file in the directory.
    for p in "$ROOT"/plan/*.md; do
      [ -f "$p" ] || continue
      if grep -qE '^- \[ \]' "$p" 2>/dev/null; then PLAN_FILE="$p"; break; fi
    done
  fi
  if [ -z "$PLAN_FILE" ]; then
    SP_PLAN=$(ls -t "$ROOT"/logs/session-plan*.md 2>/dev/null | head -n 1)
    [ -n "${SP_PLAN:-}" ] && [ -f "$SP_PLAN" ] && PLAN_FILE="$SP_PLAN"
  fi

  if [ -n "$PLAN_FILE" ]; then
    MARKERS=$(grep -nE '^#{2,3} +(Stage|Phase|W[0-9])|^- \[[ x]\]|✅|\*\*(complete|done)\*\*' "$PLAN_FILE" 2>/dev/null | head -n 40)
    if [ -n "$MARKERS" ]; then
      # First INCOMPLETE marker. When the grep returns stage/phase headers but no completion markers
      # at all — a real and common shape — anchor on the LAST header as the furthest-along section and
      # say so, rather than reporting a position no marker supports.
      ANCHOR=$(printf '%s\n' "$MARKERS" | grep -E '^[0-9]+:- \[ \]' | head -n 1 | cut -d: -f1)
      ANCHOR_KIND="first-incomplete-marker"
      if [ -z "${ANCHOR:-}" ]; then
        ANCHOR=$(printf '%s\n' "$MARKERS" | tail -n 1 | cut -d: -f1)
        ANCHOR_KIND="inferred-from-plan-structure (no completion markers present)"
      fi
      open_block POSITION
      printf 'source: %s\n' "$PLAN_FILE"
      printf 'kind: plan-marker\n'
      printf 'anchor: %s\n' "$ANCHOR_KIND"
      printf -- '---\n'
      sed -n "${ANCHOR},$((ANCHOR + 39))p" "$PLAN_FILE"
      # Corroboration — EXACTLY ONE git call, scoped to this repo. Do NOT fan out across siblings the
      # way COMMITS does: another project's commit would read as movement on this project's stage.
      # The window is the plan file's own mtime (a stat, not a git call), because the merged set above
      # is anchored to the last session-notes date and is far too narrow for plan position — a step
      # completed weeks ago falls outside it and would read as still-pending.
      if [ -n "$CWD_REPO" ]; then
        PLAN_MTIME=$(date -r "$PLAN_FILE" '+%Y-%m-%d' 2>/dev/null || true)
        if [ -n "${PLAN_MTIME:-}" ]; then
          CORROB=$(git -C "$CWD_REPO" log --since="$PLAN_MTIME" --pretty="%h %s" 2>/dev/null | head -n 20)
          if [ -n "$CORROB" ]; then
            printf -- '--- commits since plan mtime (%s), this repo only ---\n' "$PLAN_MTIME"
            printf '%s\n' "$CORROB"
          fi
        fi
      fi
      close_block POSITION
    fi
  fi
fi

# ---- MISSIONS ---------------------------------------------------------------------------------
# Active only, and NEVER logs/missions/archive/ — a closed mission must not be able to reappear, and
# excluding the archive is what keeps this bounded as missions accumulate. Emitted as a mechanism
# rather than left to the command, because as an instruction it was written, explicit, and skipped.
MISSIONS=$(printf '%s' "$REPOS" | while IFS= read -r r; do
  [ -n "$r" ] || continue
  [ -d "$r/logs/missions" ] || continue
  for m in "$r"/logs/missions/*.md; do
    [ -f "$m" ] || continue
    grep -q '^status: active' "$m" 2>/dev/null || continue
    MID=$(grep -m1 '^mission_id:' "$m" | cut -d: -f2- | sed 's/^ *//')
    MNAME=$(grep -m1 '^mission_name:' "$m" | cut -d: -f2- | sed 's/^ *//')
    printf '%s | %s | %s\n' "${MID:-unknown}" "${MNAME:-unnamed}" "$r"
    awk '/^## Open threads/{f=1;next} f&&/^## /{exit} f&&/^- \[ \]/{print "  " $0}' "$m"
  done
done)
if [ -n "$MISSIONS" ]; then
  open_block MISSIONS
  printf '%s\n' "$MISSIONS"
  close_block MISSIONS
fi

# ---- NEXT_UP ----------------------------------------------------------------------------------
# The only channel by which a severity-tagged finding reaches the menu, now that the orientation-time
# backlog scan is retired. The `<!-- promote:… -->` id is CARRIED THROUGH VERBATIM: it is what lets
# /prime tell a promoted finding from an ordinary queue item once one queue feeds both tiers.
if [ -f "$ROOT/logs/next-up.md" ]; then
  NEXT_UP=$(grep -E '^- \[ \]' "$ROOT/logs/next-up.md" 2>/dev/null)
  if [ -n "$NEXT_UP" ]; then
    open_block NEXT_UP
    printf '%s\n' "$NEXT_UP"
    close_block NEXT_UP
  fi
fi

# ---- FOREIGN_SHARED ---------------------------------------------------------------------------
# NOT the liveness check (see the header). Same-day sibling headers are the EXPECTED shape and are
# never themselves an advisory — the count is consumed only as a gate on this working-tree read.
# logs/session-notes.md is deliberately ABSENT from the pathspec: it is append-only, so a concurrent
# session's dirty copy of it is normal and would fire this advisory on every second session.
if [ -n "$CWD_REPO" ] && [ -f "$NOTES" ]; then
  # `grep -c` PRINTS 0 AND EXITS 1 on no match, so the usual `|| echo 0` fallback appends a SECOND
  # zero and the count becomes the two-line string "0\n0" — which then fails `[ -gt ]` with an
  # "integer expression expected" error on every run in a single-session repo. Caught by TEST 9.
  SIBLING_COUNT=$(grep -c "^## ${TODAY}" "$NOTES" 2>/dev/null | head -n 1)
  if [ "${SIBLING_COUNT:-0}" -gt 1 ]; then
    # -uall so the advisory names the actual FILE. Without it git collapses an untracked directory to
    # `?? .claude/commands/`, and an advisory that says "something under commands/" gives the operator
    # nothing to check before editing.
    FOREIGN_SHARED=$(git -C "$CWD_REPO" status --short -uall -- \
      .claude/commands docs logs/improvement-log.md logs/improvement-log-archive.md logs/decisions.md 2>/dev/null)
    if [ -n "$FOREIGN_SHARED" ]; then
      open_block FOREIGN_SHARED
      printf '%s\n' "$FOREIGN_SHARED"
      close_block FOREIGN_SHARED
    fi
  fi
fi

# ---- TELEMETRY_GAP ----------------------------------------------------------------------------
# The nudge that protects the token-audit baseline against a forgotten `+telemetry` flag. THIS TEST IS
# WHY THE OLD LOG-TRIO PREFETCH CAN GO: the obligation was always to nudge, never to have /prime read
# the log — so the read moves here and the command keeps the nudge (ai-resources/CLAUDE.md
# § Session Telemetry). Trivial sessions are excluded by requiring a real `### Summary`: a one-line or
# aborted entry legitimately has no telemetry and must not raise a warning.
#
# AN ABSENT usage-log.md IS THE STRONGEST GAP, NOT AN EXEMPTION. The file's existence was previously a
# precondition of the whole test, so a consumer that had never captured telemetry at all — the exact
# state the nudge exists to catch — reported `TELEMETRY_GAP: no` and stayed silent forever. Observed in
# a real consumer (`axcion-website`: substantive last entry, no usage log, no nudge). Existence is now
# folded into the staleness test instead of gating it: no file ⇒ no entry for this date ⇒ gap.
TELEMETRY_GAP="no"
USAGE_LOG="$ROOT/logs/usage-log.md"
if [ -n "$ENTRY_DATE" ] && [ -n "$ENTRY_TEXT" ]; then
  if printf '%s\n' "$ENTRY_TEXT" | grep -q '^### Summary' \
     && [ "$(printf '%s\n' "$ENTRY_TEXT" | wc -l | tr -d ' ')" -gt 6 ]; then
    if [ ! -f "$USAGE_LOG" ] || ! tail -n 30 "$USAGE_LOG" 2>/dev/null | grep -q "$ENTRY_DATE"; then
      TELEMETRY_GAP="yes"
    fi
  fi
fi
printf 'TELEMETRY_GAP: %s\n' "$TELEMETRY_GAP"

exit 0
