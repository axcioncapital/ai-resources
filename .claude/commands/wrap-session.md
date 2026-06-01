---
model: sonnet
---

Wrap the current session. The operator's wrap-up context follows this prompt: $ARGUMENTS

## Instructions

**Do NOT run git commands or bash commands to discover files.** You already know what was produced from conversation context. Auto-commits track file changes separately.

0. As your first action, run `touch /tmp/claude-wrap-session-done` via Bash. This suppresses the session-end hook's "Session ended without /wrap-session" auto-append while this command runs, preventing a file-modification race on `logs/session-notes.md`. The hook deletes the lockfile after reading it, so no cleanup is needed.

**Cost budget.** A typical wrap is ~10–15 tool calls (add ~2–4 each when Step 6.4 outcome check and/or Step 6.5 feedback collection run — ~4–8 combined; each subagent absorbs its own reading). If you're past 25 tool calls with the wrap not yet committed, stop and ask the operator whether to abort the rest. This catches investigation rabbit-holes, redundant Reads, and ceremony-without-purpose firings before they compound. Self-check your running tool-call count at each step boundary; do not run a separate counter — just notice when you've crossed the threshold.

**Preflight — operator preferences.** Before doing anything else, ask the operator in a single prompt and **wait for the answer**:

> Wrap-session preflight — run these optional passes?
> 1. Telemetry + coaching (usage-analysis + coaching data capture) — y/n
> 2. Feedback + outcome (session feedback collection + outcome check) — y/n

Each answer toggles a **bundle of two passes**: answer 1 gates Step 7 (coaching) **and** Step 12 (telemetry); answer 2 gates Step 6.4 (outcome check) **and** Step 6.5 (feedback collection). Both passes in a bundle run when its answer is `y` and are skipped when its answer is `n` — the bundle is all-or-nothing.

Accept shorthand: "yy" / "yes all" / "all" = both yes; "nn" / "skip all" = both no; per-item forms like "1y 2n". Record the two answers. Do not assume defaults — if the operator's reply is ambiguous or covers fewer than two items, re-ask the uncovered one before proceeding. Note skipped passes in chat as "Skipped per preflight" when you reach the corresponding step.

0.5. **Save a continuity scratchpad.** Run the `skills/handoff/SKILL.md` continuity workflow (no-args mode, Steps C1–C2) inline: write a full session-state scratchpad to `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-scratchpad.md` from conversation context. This is a single `Write` call — it counts toward the cost budget above but adds only one call. `/prime` Step 1b detects this scratchpad at the next session start and offers it as a resume point, giving the next session a richer entry than the terse `### Next Steps` list alone. Skip this step only if the session was trivial (single-file edit, one-question read, aborted session) with nothing worth resuming — note "Continuity scratchpad skipped — trivial session" in chat if so. This is your judgment call, same standard as the Step 12 telemetry skip; do not ask the operator.

   **Note:** This scratchpad is the "Pre-closeout" named checkpoint in `ai-resources/docs/compaction-protocol.md` § Named checkpoints — same file, written by this step. See that section for the state-on-disk contract.

1. Run `tail -5 logs/session-notes.md` via Bash to find the append point. If the file doesn't exist, create it with `# Session Notes` as the header. **Format guard:** If the file exists but has no `# Session Notes` header, prepend it. If the last non-empty line is a partial block (unclosed heading, unterminated list), append a blank line before the new entry.
2. Run `tail -5 logs/decisions.md` via Bash to find the append point. If the file doesn't exist, create it with `# Decision Journal` as the header.
3. **Log archive check.** Run `CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh` — the explicit env prefix is required; some session shells strip the inherited `CLAUDE_PROJECT_DIR` mid-chain, which has caused "CLAUDE_PROJECT_DIR unset" failures across 10+ wraps. The script iterates append-only logs (session-notes.md, decisions.md) and archives any file exceeding its threshold by invoking `logs/scripts/split-log.sh` internally. Behavior:
   - Below threshold: silent exit, nothing to do.
   - Archive triggered: script prints `Auto-archived <file> → <archive-file> (archived N entries, kept M)`. Note the printed archive filename — include it in Step 4's `### Files Modified` list.
   - Failure: script prints `ARCHIVE FAILED for <file>` and exits non-zero. Surface the failure to the operator, do NOT attempt to rerun, proceed with the rest of the wrap.

   **Why here:** archive runs before the session note is appended (Step 4) so that a threshold-triggered rewrite of session-notes.md does not invalidate the Step 4 Edit. Archive operates only on existing entries — today's note has not yet been written and is unaffected.

   **Idempotency with `/log-sweep`:** `/wrap-session` and `/log-sweep` are safe to run on the same day in any order. Both commands call `split-log.sh` internally, but `split-log.sh`'s "already at threshold" guard and `log-archiver.sh`'s date-guard pattern prevent double-archival. Running both same-day produces the same result as running either once. No special ordering is required.

3.5. **Foreign-session pre-write guard on `logs/session-notes.md`.**

   <!--
   PAIRED CONTRACT — keep in sync.
     Sibling: workspace-root /.claude/commands/wrap-session.md (Phase 3 copy, NOT a symlink — operates on workspace-level logs/session-notes.md).
     Symmetric counterpart: /session-start Step 0.5 mtime guard (Plan 2, shipped 2026-05-26) — that guard covers the /prime → /session-start window; this guard covers the post-/session-start → wrap window. Both may fire on different sides of the same concurrent-session incident.
     Detection signals: (1) count of `^## YYYY-MM-DD` today-headers, (2) count of `^**Mandate:**` lines. Both depend on the conventions set by Step 4 below (header), `session-start.md` Step 3 (mandate line), and `check-archive.sh` (archive). If a future writer emits a non-conforming today-header or non-conforming mandate line, the corresponding signal returns a FALSE NEGATIVE — foreign content is silently clobbered (the exact bug this guard exists to prevent recurs silently). Keep both formats in sync with their writers.
     Own-contribution attribution (id-32 follow-up, friction 14:20 2026-05-28 — marker-aware, shipped 2026-05-29): when `logs/.session-marker` is present and dated today, the detector counts THIS session's actual marker-bearing today-headers (`^## TODAY — Session ${MARKER}`) and the mandate lines beneath them in both WT and HEAD. The delta is exact own-contribution — handles auto-mode N-task chains where `/prime` Step 8c.3 fires N times per session and appends N marker-bearing headers. When marker is absent (workspace-root, pre-Phase-2 session), falls back to `PRIME_RAN` binary subtraction (legacy behavior). Both paths feed `OWN_HEADERS_SUBTRACT` and `OWN_MANDATES_SUBTRACT`, which downstream consumers (FOREIGN_HEADERS, FOREIGN_MANDATES, EXTRA_TODAY_MANDATES) use as the own-subtractor.
     Classifier (id-32, 2026-05-28): when FOREIGN >= 1, the classifier walks `^## YYYY-MM-DD` headers in BOTH WT and HEAD, tracks each mandate's enclosing-date, and emits FOREIGN_CLASS = CONCURRENT (today-extras only) / REMNANT (prior-day-extras only) / MIXED (both) / UNKNOWN (FOREIGN by header-count only — rare; defaults to CONCURRENT-shape STOP message). EXTRA_TODAY_MANDATES uses `OWN_MANDATES_SUBTRACT` (marker-aware or PRIME_RAN fallback) as the subtractor.
   -->

   Background: concurrent sessions can both write to `logs/session-notes.md` between this session's `/prime`+`/session-start` and its `/wrap-session`. If a foreign session's content is in the working tree when this session's wrap stages `logs/session-notes.md`, its content ships under this session's wrap commit (the failure mode logged 2026-05-27, commit `14d2a04`). This guard fires **before** Step 4 writes — symmetric to `/session-start` Step 0.5 mtime guard (pre-write posture).

   Detection uses two independent signals to catch both incident shapes:
   - **Today-header delta** — catches the case where the foreign session created its own `## YYYY-MM-DD` header (different header from this session's).
   - **Mandate-line delta** — catches the case where the foreign session ran `/prime` first and reused this session's already-existing today-header (per `/prime` Step 8a.3.a / 8b.3.a header-reuse rule), then appended its mandate UNDER the shared header. Header count stays flat (1); mandate-line count rises.

   Run the following Bash detector:

   ```bash
   # Foreign-session detector for logs/session-notes.md.
   # Signals: today-header count + mandate-line count. See PAIRED CONTRACT block above for format dependencies.
   TODAY=$(date '+%Y-%m-%d')

   # Assignment-only capture: grep -c exits 1 on zero matches but assignments ignore exit codes.
   # Then ${VAR:-0} defaults to 0 if grep produced empty output (e.g., missing file).
   WT_HEADERS=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null)
   WT_HEADERS=${WT_HEADERS:-0}
   HEAD_HEADERS=$(git show HEAD:logs/session-notes.md 2>/dev/null | grep -c "^## ${TODAY}")
   HEAD_HEADERS=${HEAD_HEADERS:-0}

   WT_MANDATES=$(grep -c "^\*\*Mandate:\*\*" logs/session-notes.md 2>/dev/null)
   WT_MANDATES=${WT_MANDATES:-0}
   HEAD_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | grep -c "^\*\*Mandate:\*\*")
   HEAD_MANDATES=${HEAD_MANDATES:-0}

   ADDED_HEADERS=$((WT_HEADERS - HEAD_HEADERS))
   ADDED_MANDATES=$((WT_MANDATES - HEAD_MANDATES))

   # Determine this session's own contribution to today-headers and today-mandate-lines.
   # Two paths: marker-aware (preferred, post-Phase-2+3) and PRIME_RAN binary (legacy fallback).
   # See PAIRED CONTRACT block above for the attribution rationale.
   MARKER=""
   if [ -f logs/.session-marker ]; then
     MARKER_LINE=$(cat logs/.session-marker 2>/dev/null)
     case "${MARKER_LINE}" in
       "${TODAY} "*) MARKER=$(echo "${MARKER_LINE}" | awk '{print $2}');;
     esac
   fi

   if [ -n "${MARKER}" ]; then
     # Marker-aware path: count own marker-bearing headers + mandates under those headers in WT and HEAD.
     OWN_WT_HEADERS=$(grep -c "^## ${TODAY} — Session ${MARKER}" logs/session-notes.md 2>/dev/null)
     OWN_WT_HEADERS=${OWN_WT_HEADERS:-0}
     OWN_HEAD_HEADERS=$(git show HEAD:logs/session-notes.md 2>/dev/null | grep -c "^## ${TODAY} — Session ${MARKER}")
     OWN_HEAD_HEADERS=${OWN_HEAD_HEADERS:-0}
     OWN_ADDED_HEADERS=$((OWN_WT_HEADERS - OWN_HEAD_HEADERS))

     OWN_WT_MANDATES=$(awk -v marker="${MARKER}" -v today="${TODAY}" '
       /^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ {
         in_own = ($0 ~ ("^## " today " — Session " marker "$"))
       }
       /^\*\*Mandate:\*\*/ && in_own { c++ }
       END { print c+0 }
     ' logs/session-notes.md 2>/dev/null)
     OWN_WT_MANDATES=${OWN_WT_MANDATES:-0}
     OWN_HEAD_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | awk -v marker="${MARKER}" -v today="${TODAY}" '
       /^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ {
         in_own = ($0 ~ ("^## " today " — Session " marker "$"))
       }
       /^\*\*Mandate:\*\*/ && in_own { c++ }
       END { print c+0 }
     ')
     OWN_HEAD_MANDATES=${OWN_HEAD_MANDATES:-0}
     OWN_ADDED_MANDATES=$((OWN_WT_MANDATES - OWN_HEAD_MANDATES))

     OWN_HEADERS_SUBTRACT=${OWN_ADDED_HEADERS}
     OWN_MANDATES_SUBTRACT=${OWN_ADDED_MANDATES}
     PRIME_RAN=0  # legacy field; not used on marker-aware path; logged as 0 for trace continuity
   else
     # Legacy PRIME_RAN binary path: marker absent (workspace-root, pre-Phase-2 session).
     # Uses the `logs/.prime-mtime` marker that /prime Step 8a/8b/8c writes after appending today's header.
     PRIME_RAN=0
     if [ -f logs/.prime-mtime ]; then
       MTIME_MARKER=$(cat logs/.prime-mtime 2>/dev/null | tr -dc '0-9')
       MTIME_MARKER=${MTIME_MARKER:-0}
       TODAY_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TODAY} 00:00:00" "+%s" 2>/dev/null \
         || date -d "${TODAY} 00:00:00" "+%s" 2>/dev/null \
         || echo 0)
       # Marker mtime ≥ today-midnight → /prime ran this session today.
       if [ -n "${MTIME_MARKER}" ] && [ "${MTIME_MARKER}" -ge "${TODAY_EPOCH}" ] 2>/dev/null; then
         PRIME_RAN=1
       fi
     fi
     OWN_HEADERS_SUBTRACT=${PRIME_RAN}
     OWN_MANDATES_SUBTRACT=${PRIME_RAN}
   fi

   # If EITHER signal indicates content beyond OWN_*_SUBTRACT, STOP.
   FOREIGN_HEADERS=$((ADDED_HEADERS - OWN_HEADERS_SUBTRACT))
   FOREIGN_MANDATES=$((ADDED_MANDATES - OWN_MANDATES_SUBTRACT))
   FOREIGN=${FOREIGN_HEADERS}
   if [ "${FOREIGN_MANDATES}" -gt "${FOREIGN}" ]; then
     FOREIGN=${FOREIGN_MANDATES}
   fi

   # FOREIGN<0 discriminator: distinguishes the common mid-session-commit case (this session's
   # today-header + mandate were shipped to HEAD by an intermediate commit) from genuinely odd
   # FOREIGN<0 states (plan-mode /prime, manual prune, skipped /session-start). Used by the
   # Step 3 edge-case interpretation below to silence the common case.
   OWN_CONTENT_IN_HEAD=0
   if [ "${HEAD_HEADERS}" -ge 1 ] && [ "${HEAD_MANDATES}" -ge 1 ]; then
     OWN_CONTENT_IN_HEAD=1
   fi

   # Classify FOREIGN by enclosure-date of mandates (id-32, 2026-05-28).
   # Walks awk over WT + HEAD, tracks each mandate's enclosing `^## YYYY-MM-DD` header, counts by today vs prior-day.
   # CONCURRENT = today-extras only (parallel terminal); REMNANT = prior-day-extras only (orphan from a prior session that ran /prime + /session-start but never /wrap-session); MIXED = both; UNKNOWN = neither (FOREIGN by header-count only — safe default → CONCURRENT-shape STOP message).
   FOREIGN_CLASS="UNKNOWN"
   if [ "${FOREIGN}" -ge 1 ]; then
     WT_TODAY_MANDATES=$(awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d==today {c++} END{print c+0}' logs/session-notes.md 2>/dev/null)
     WT_TODAY_MANDATES=${WT_TODAY_MANDATES:-0}
     WT_PRIOR_MANDATES=$(awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d!=today && d!="" {c++} END{print c+0}' logs/session-notes.md 2>/dev/null)
     WT_PRIOR_MANDATES=${WT_PRIOR_MANDATES:-0}
     HEAD_TODAY_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d==today {c++} END{print c+0}')
     HEAD_TODAY_MANDATES=${HEAD_TODAY_MANDATES:-0}
     HEAD_PRIOR_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d!=today && d!="" {c++} END{print c+0}')
     HEAD_PRIOR_MANDATES=${HEAD_PRIOR_MANDATES:-0}
     EXTRA_TODAY_MANDATES=$((WT_TODAY_MANDATES - HEAD_TODAY_MANDATES - OWN_MANDATES_SUBTRACT))
     EXTRA_PRIOR_MANDATES=$((WT_PRIOR_MANDATES - HEAD_PRIOR_MANDATES))
     if [ "${EXTRA_TODAY_MANDATES}" -ge 1 ] && [ "${EXTRA_PRIOR_MANDATES}" -ge 1 ]; then
       FOREIGN_CLASS="MIXED"
     elif [ "${EXTRA_TODAY_MANDATES}" -ge 1 ]; then
       FOREIGN_CLASS="CONCURRENT"
     elif [ "${EXTRA_PRIOR_MANDATES}" -ge 1 ]; then
       FOREIGN_CLASS="REMNANT"
     fi
   fi

   echo "GUARD: headers WT=${WT_HEADERS} HEAD=${HEAD_HEADERS} added=${ADDED_HEADERS} | mandates WT=${WT_MANDATES} HEAD=${HEAD_MANDATES} added=${ADDED_MANDATES} | MARKER=${MARKER:-none} OWN_HEADERS_SUBTRACT=${OWN_HEADERS_SUBTRACT} OWN_MANDATES_SUBTRACT=${OWN_MANDATES_SUBTRACT} PRIME_RAN=${PRIME_RAN} FOREIGN=${FOREIGN} FOREIGN_CLASS=${FOREIGN_CLASS} OWN_CONTENT_IN_HEAD=${OWN_CONTENT_IN_HEAD}"
   if [ "${FOREIGN}" -ge 1 ]; then
     echo "--- Today-headers in working tree ---"
     grep -n "^## ${TODAY}" logs/session-notes.md 2>/dev/null
     echo "--- Mandate lines in working tree ---"
     grep -n "^\*\*Mandate:\*\*" logs/session-notes.md 2>/dev/null
   fi
   ```

   Interpret the output:

   - **`FOREIGN == 0`** — no foreign content detected. Proceed silently to Step 4.
   - **`FOREIGN ≥ 1`** — **STOP**. Foreign session content is in the working tree. Staging `logs/session-notes.md` now would ship that content under this session's wrap commit. **Branch by `FOREIGN_CLASS`**:

     - **`FOREIGN_CLASS == CONCURRENT`** (or `UNKNOWN` — default to CONCURRENT-shape) — today-dated extras detected. A concurrent session is the live cause:

       > ⚠ Pre-write guard fired (CONCURRENT): detected {FOREIGN} foreign-session entries in `logs/session-notes.md` working tree (`headers added=K1, mandates added=K2, PRIME_RAN=P, FOREIGN_CLASS=CONCURRENT` — see Bash output above).
       >
       > Today-headers currently in working tree:
       > {grep -n output for `^## TODAY`}
       >
       > Mandate lines currently in working tree:
       > {grep -n output for `^**Mandate:**`}
       >
       > A concurrent session has written content this session did not author. If I stage `logs/session-notes.md` now, that foreign content will ship under my wrap commit.
       >
       > **To resolve:** switch to the other terminal and run `/wrap-session` there first (commits its own work cleanly). Once that wraps, return here and re-invoke `/wrap-session` — the foreign content will then be in HEAD and the guard will pass.
       >
       > I will NOT proceed automatically. Re-invoke `/wrap-session` after resolving.

     - **`FOREIGN_CLASS == REMNANT`** — prior-day extras detected. Likely an orphan mandate from a prior session that ran `/prime` + `/session-start` but never invoked `/wrap-session`:

       > ⚠ Pre-write guard fired (REMNANT): {EXTRA_PRIOR_MANDATES} prior-day orphan mandate(s) detected in `logs/session-notes.md` working tree (`FOREIGN_CLASS=REMNANT, EXTRA_PRIOR_MANDATES=N` — see Bash output above).
       >
       > Mandate lines currently in working tree:
       > {grep -n output for `^**Mandate:**`}
       >
       > A prior session ran `/prime` + `/session-start` but never invoked `/wrap-session`, leaving an orphan mandate from a prior day unstaged. The current wrap would ship this orphan under THIS session's wrap commit.
       >
       > **To resolve, pick one:**
       > 1. **Commit the orphan as a standalone wrap-recovery commit** — stage `logs/session-notes.md` containing only the orphan mandate, commit with `session: {prior-date} wrap-recovery — orphan from {prior-day} session`, then re-invoke `/wrap-session` here.
       > 2. **Abandon the orphan** — manually remove the orphan mandate line(s) from `logs/session-notes.md`, then re-invoke `/wrap-session` here.
       >
       > I will NOT proceed automatically.

     - **`FOREIGN_CLASS == MIXED`** — both today-dated AND prior-day extras detected:

       > ⚠ Pre-write guard fired (MIXED): both today-dated extras AND prior-day orphan(s) detected in `logs/session-notes.md` working tree (`FOREIGN_CLASS=MIXED, EXTRA_TODAY_MANDATES=N1, EXTRA_PRIOR_MANDATES=N2` — see Bash output above).
       >
       > Today-headers + mandate lines currently in working tree:
       > {grep -n outputs}
       >
       > **Resolve in order:**
       > 1. **First the prior-day orphan** — commit as wrap-recovery OR abandon (see REMNANT remediation above).
       > 2. **Then the concurrent-session conflict** — switch to the other terminal and run `/wrap-session` there first (see CONCURRENT remediation above).
       >
       > I will NOT proceed automatically.

     Do not offer a "commit the union" override in ANY branch. Auto-merging session notes is a silent-conflict-resolution anti-pattern — the operator resolves manually.

   - **Edge case (`FOREIGN < 0`)** — `OWN_HEADERS_SUBTRACT > ADDED_HEADERS` (or `OWN_MANDATES_SUBTRACT > ADDED_MANDATES`) for one or both signals, i.e., the session-state markers say `/prime` ran AND own-contribution is positive but the working tree shows a smaller delta vs HEAD. There are two distinct sub-cases, distinguished by `OWN_CONTENT_IN_HEAD`. **No concurrent-session risk in either case** — proceed to Step 4. Branch by `OWN_CONTENT_IN_HEAD`:

     - **`OWN_CONTENT_IN_HEAD=1`** — HEAD already contains today's header + mandate. This session's content was shipped to HEAD by a **mid-session commit** of `logs/session-notes.md` (or by a prior session's wrap landing today). This is the common path in active development — `/prime` writes the today-header + mandate, an intermediate commit ships them to HEAD, and at wrap time WT == HEAD so `ADDED_*` is 0 while the own-subtractor (marker-aware count or `PRIME_RAN`) is positive. **Proceed silently to Step 4 — no chat note.**

     - **`OWN_CONTENT_IN_HEAD=0`** — HEAD lacks today's header or mandate too, yet the own-subtractor is positive (marker-aware: `OWN_ADDED_HEADERS > 0` is impossible under this branch since OWN_WT_HEADERS would be 0; PRIME_RAN-path: `PRIME_RAN=1`). Genuinely odd state. Most likely causes: (a) `/prime` Step 8a/8b/8c ran in plan-mode and the markers were written without the header append, (b) the operator manually pruned the entry after `/prime` ran, or (c) `/session-start` was skipped after `/prime`. Proceed to Step 4 with one-line chat note: `Note: session-state markers present but expected own-content absent in WT AND HEAD — proceeding`.

4. Append a session note at the **END** of `/logs/session-notes.md` (newest entry is the LAST entry; do NOT prepend at the top — `check-archive.sh` interprets top entries as oldest and will archive them). Use conversation context and the operator's summary to populate:
   - `## {date} — {one-line title}` (e.g., "Created supplementary-query-brief-drafter skill")
   - `### Summary` — 2-4 sentences: what was accomplished, what was the focus
   - `### Files Created` — list from conversation context (path + short description)
   - `### Files Modified` — list from conversation context (include any archive file printed in Step 3)
   - `### Decisions Made` — operator-directed decisions grouped by artifact; QC fixes listed separately
   - `### Outcome` — written by Step 6.4 (not by you here) when the outcome check runs: the `COMPLETION:` and `EXECUTION:` verdict lines + notes. Listed here so the documented schema and the live note stay in sync; if Step 6.4 is skipped, this block is simply absent.
   - `### Risky actions` — one line: any irreversible/destructive/external/shared-state-clobber action **taken or nearly taken** this session, a gate that should have fired but didn't, or a prompt-injection encountered — else write "None". This is warm-sourced danger input for the Step 6.5 feedback collector (which runs fresh-context and otherwise cannot see the live session). "None" is the common case; do not pad.
   - `### Next Steps` — what command to run next, any recommended groupings or sequencing. **At stage boundaries:** verify the next command against `reference/stage-instructions.md` Stage Entry Commands table before writing — use the exact command name, do not infer from memory.
   - `### Open Questions` — blockers or unresolved items; write "None" if clean
5. If operator decisions with analytical or scoping judgment were made, append to `/logs/decisions.md` with: date, context, decision, rationale, alternatives considered. Skip this if all decisions were routine (operator-directed text edits, QC auto-fixes).
6. If the operator didn't mention decisions but significant ones occurred in the session, list them and ask: "Should I log any of these to the decision journal?"

6.4. **Session outcome check — "did Claude do the job, and do it well?"** Produces an independent two-dimension verdict on this session: did it deliver its mandate (completion), and did it deliver by a good path (execution quality). Advisory only — nothing here blocks the commit or push.

   <!--
   MIRROR NOTE — PORTED 2026-06-01 to the workspace-root copy as its Step 4.4 (positioned before that copy's Step 5 commit). Keep the two in sync on future edits. The workspace-root copy retains a lighter self-authored `### Session Report` (its Step 2b) whose `**Completed:**` line this independent check supersedes; Step 2b's operator questions remain unique to it.
   -->

   - **Gate.** If the operator declined the outcome check in the preflight, skip and note "Outcome check skipped per preflight" in chat. If the session was trivial (single-file edit, one-question read, aborted session), skip with "Outcome check skipped — trivial session" — your judgment call, same standard as the Step 0.5 / Step 12 skips; do not ask the operator.
   - **Resolve the mandate** ("what Claude was supposed to do this session") using `/contract-check`'s priority chain — see `contract-check.md` Step 2; do not duplicate the logic, just follow that order and stop at the first that resolves:
     1. frozen contract `logs/contracts/{today}-*.md` (if present);
     2. `logs/session-plan-{MARKER}.md` for this session's marker, if modified today;
     3. today's `**Mandate:**` block in `logs/session-notes.md` (the mandate line + its `Out of scope` / `Files in scope` / `Stop if` / `Required outputs` bullets);
     4. **fallback** — none of the above: judge against the session's stated task as written in today's `### Summary`, and mark the verdict `Confidence: low (no formal mandate)`. Never invent a standard to grade against.
   - **Launch a fresh-context `general-purpose` subagent** with an inline brief (mirror `contract-check.md` Step 4 — NO named agent file, NO disk-notes file; the verdict is short by construction). The brief passes:
     - the resolved **mandate text + its source label**;
     - today's **session-note block** (the claimed outcome: Files Created/Modified, Decisions, Next Steps, Open Questions);
     - explicit permission to **inspect the actual changed files and today's `git log`** to verify the note's claims rather than trusting the self-authored note (this is what keeps the judgment independent — QS-1).

     The brief instructs the subagent to judge **two dimensions** and return **≤20 lines**:
     - **`COMPLETION: DELIVERED | PARTIAL | MISSED`** — DELIVERED = did what the mandate asked, in usable form; PARTIAL = core delivered but a named part is missing/unfinished/unverified; MISSED = did not deliver, or delivered something materially different.
     - **`EXECUTION: OPTIMAL | ACCEPTABLE | SUBOPTIMAL`** — was the *path* good? Judge three sub-axes: **efficiency** (wasted steps, redundant reads, rework loops, unnecessary subagents/detours), **approach** (was a clearly better method/design/tool available?), **process** (required gates followed — QC, risk-check — or skipped, or over-engineered past the task).
     - **Evidence guard (load-bearing):** a `SUBOPTIMAL` (or any "could be better") call MUST cite a concrete observation — a visible rework loop, a named detour, a skipped gate, an over-built artifact. No vague "could be tighter." With no evidence of waste, default to `ACCEPTABLE`/`OPTIMAL`.
     - `What was asked but not done:` — bulleted; "none" if DELIVERED.
     - `Better path:` — for ACCEPTABLE/SUBOPTIMAL, the concrete better route, each tied to its evidence; "none" if OPTIMAL.
     - `Confidence:` — high | low (low when the mandate came from the fallback).
     - **Scope boundary (state in the brief):** judge *this task's* execution against *this mandate* only. Do NOT do general token telemetry (that is `/usage-analysis`), cross-session iteration patterns (that is `/coach`), or propose/log system fixes (that is Step 6.5 + `/improve`). This step **grades**; it does not file improvements.
   - **Write the returned verdict** as an `### Outcome` block (the `COMPLETION:` and `EXECUTION:` lines + the notes) into today's session-note entry, placed **after `### Decisions Made`, before `### Risky actions`**.
   - **Surface in chat:** show both verdict lines. If `COMPLETION: MISSED`, or `EXECUTION: SUBOPTIMAL` with a load-bearing better-path, surface it prominently — but **advisory only; it does NOT block** the commit or push.
   - **Ordering note:** this runs before Step 6.5. The feedback collector may read this `### Outcome` block as one more input — a loose one-directional handoff (outcome → collector), not a dependency.

6.5. **Session feedback collection.** Closes a feedback loop back into the system: a fresh-context subagent extracts per-session signals against the goal-state dimensions and routes them to existing stores the Friday cadence consumes. Advisory only — nothing here blocks the commit or push.

   <!--
   MIRROR NOTE — PORTED 2026-06-01 to the workspace-root copy as its Step 4.5 (positioned before that copy's Step 5 commit).
     The workspace-root /.claude/commands/wrap-session.md is an independent non-symlink copy. The two-end contract is now live across both copies: the Step 0.4 preflight toggle (workspace-root) / preflight bundle 2 (canonical) + this step + the `### Risky actions` line in the session-note schema. Keep all three in sync on future edits. Workspace-root divergences handled at port time: (a) the `session-feedback-collector` agent resolves there via the --add-dir'd ai-resources library; (b) `logs/improvement-log.md` is created on the collector's first write (absent at workspace root until then). This feature also auto-propagates to the ~16 project symlinks via this canonical copy.
   -->

   - **Gate.** If the operator declined feedback collection in the preflight, skip and note "Feedback collection skipped per preflight" in chat. If the session was trivial (single-file edit, one-question read, aborted session), skip with "Feedback collection skipped — trivial session" — your judgment call, same standard as the Step 0.5 / Step 12 skips; do not ask the operator.
   - **Launch the `session-feedback-collector` subagent** (launch idiom per `improve.md` / `coach.md`). Pass it **paths only** — do NOT paste contents or conversation history:
     - today's session-note path (`logs/session-notes.md`) + today's date
     - the rubric path (`ai-resources/docs/session-feedback-dimensions.md`)
     - the target store paths: `logs/friction-log.md`, `logs/improvement-log.md`, and `logs/improvement-log-archive.md` if it exists
     - the project root
     The subagent reads independently, enforces its own per-session append cap, tags every entry with `wrap-collector` provenance, dedups against the existing log + archive, and returns a ≤20-line summary. It writes ONLY `friction-log.md` and `improvement-log.md`.
   - **Append the returned summary** as a `### Session Assessment` block to today's note in `logs/session-notes.md` — placed **after `### Risky actions`, before `### Next Steps`**.
   - **Surface high-severity safety signals in chat.** If the summary's Safety line reports any `high` signal, surface it prominently: "⚠ Safety signal logged as guardrail-candidate (high): {one line}". This is advisory — it does NOT block the commit or push.
   - **Route, don't run.** If the summary indicates friction was routed, or a reusable component warrants `/innovation-sweep`, emit a one-line nudge ("Friction routed — consider `/improve`"). Do NOT auto-fire any downstream command.
   - **Staging note:** if the collector wrote to `friction-log.md` or `improvement-log.md`, those paths must be staged in the commit step below (they are in the always-staged list).
7. **Coaching data capture.** If the operator declined coaching in the preflight, skip this step and note "Coaching capture skipped per preflight" in chat. Otherwise:

   **7a — Read today's mandate block.** Before writing the coaching entry, scan `logs/session-notes.md` from today's `## YYYY-MM-DD` header to the next `##` header (or EOF). Check whether a `**Mandate:**` line appears in that range. *(Format produced by `session-start.md` Step 3 — keep bullet label strings and marker tokens in sync.)*
   - If found: extract the five sub-bullets (`- Out of scope:`, `- Files in scope:`, `- Stop if:`, `- Allowed inputs:`, `- Required outputs:`) and classify each value: `(none stated)` → **omitted**; `(inferred)` → **inferred**; any other content → **specified**. `work_scope` and `exit_condition` (on the main `**Mandate:**` line) always count as **specified**. The `Allowed inputs` and `Required outputs` bullets are optional — when absent from the mandate block, classify as **omitted** (no `(none stated)` placeholder is written; the bullets simply do not appear). Present bullets are always classified **specified** (no `(inferred)` path defined for these two).
   - If not found: `mandate_present = false`.

   **7b — Write coaching entry.** Auto-append a session profile entry to `/logs/coaching-data.md`. Derive all fields from the session note you just wrote — no extra operator input needed.

   **Append mechanism (token-audit R6, 2026-05-25):** Do NOT full-`Read` `coaching-data.md` (489+ lines, ~5–6k tokens). For context, use `Bash(tail -n 80 logs/coaching-data.md)`. For the write, append via `Bash` heredoc: `cat >> logs/coaching-data.md <<'EOF' … EOF`. The Bash-only path avoids the Edit tool's Read-before-Write requirement that would otherwise force the full-file load. **Fall back to full `Read` + `Edit` only when a structural lookup is actually required** (schema check across all entries, dedupe against a similar-class earlier entry, mid-file insertion); pure append never needs the full file.
   ```
   ### {YYYY-MM-DD} — {session title}
   - **Commands used:** {slash commands triggered this session, from conversation context}
   - **Iterations:** {draft iteration count and section, e.g., "3 (skill-name draft-01 → draft-03)", or "0" if no drafting}
   - **Decisions logged:** {count of decisions appended to decisions.md this session}
   - **QC cycles:** {count and outcome, e.g., "1 (conditional pass → fixes → approved)", or "0"}
   - **Gates:** {count of operator approval/review points this session} ({N} changed) — {comma-separated type:outcome pairs}. Types: plan-approval, content-review, qc-disposition, challenge-disposition, service-design-disposition, bright-line-review, editorial-disagreement, supplementary-research. Outcomes: confirmed (operator approved without changes) or changed (operator directed modification). Derive from conversation: "looks good"/"approved" with no changes = confirmed; operator gave feedback or directed revisions = changed. Omit this line entirely for 0-gate sessions (infrastructure work).
   - **Mandate fields:** {if mandate_present: "specified: {list} | inferred: {list} | omitted: {list}" — omit any category that is empty; if not mandate_present: "none (no /session-start this session)"}
   ```
8. **Innovation triage.** Check for detected entries: `grep '| detected |' logs/innovation-registry.md 2>/dev/null`. If no output (file absent or no detected entries), skip this step silently. If entries found, read those matching lines to identify the affected items, then:
   - Present the list: "Innovations detected this session: [list with type and filename]"
   - For each, recommend: `graduate` (useful beyond this project) or `project-specific` (stays local). One line per item.
   - Ask the operator to confirm or override. Accept "looks good" as blanket confirmation.
   - For items marked `graduate`: update registry status to `triaged:graduate` and remind: "Run `/graduate-resource {name}` to move it to ai-resources."
   - For items marked project-specific: update registry status to `triaged:project-specific`.
   - Also surface any new CLAUDE.md rules added this session (from conversation context) and ask if they should graduate to root CLAUDE.md.
9. **Shared command drift check.** If any `.claude/commands/` files were modified this session, ask: "These shared commands were modified: [list]. Should any changes be synced back to ai-resources or to other projects?" If yes, note the sync action in Next Steps.
10. **Improvement verification and resolved-count check.** Scan for unverified applied entries: `awk '/^### /{if(a&&!v)print h; h=$0;a=0;v=0} /Status:.*applied/{a=1} /Verified:/{v=1} END{if(a&&!v)print h}' logs/improvement-log.md 2>/dev/null`. If no output (file absent or no unverified applied entries), skip. If entries found, present: "Unverified improvements: [list with date and title]." Ask: "Verify any, or skip?" If confirmed, append `- **Verified:** {date} — confirmed by operator` to each entry. If skipped, proceed.

    **After verification**, count resolved entries: `grep -c '^\- \*\*Verified:\*\*' logs/improvement-log.md 2>/dev/null || echo 0`. If count ≥ 5, append to the wrap summary: "N resolved entries in improvement-log — consider running `/resolve-improvement-log` to archive them." Below 5: do not mention.
11. **Remind about /improve.** Check for today's friction entries: `grep "$(date +%Y-%m-%d)" logs/friction-log.md 2>/dev/null`. If output found, suggest: "Friction events were logged this session. Consider running `/improve` to analyze them."
12. **Session telemetry.** If the operator declined telemetry in the preflight, skip this step with a one-line note in chat ("Telemetry skipped per preflight") and proceed to the commit step. Otherwise, run the usage analysis inline before committing. Execute the full `/usage-analysis` flow (build session summary, read existing `logs/usage-log.md` if it exists, delegate to the `session-usage-analyzer` subagent per `ai-resources/skills/session-usage-analyzer/SKILL.md`, write the returned entry to the log). For trivial sessions (single-file edit, one-question read, aborted session), skip with a one-line note in chat ("Telemetry skipped — trivial session") and proceed. Rationale: R14 telemetry baseline depends on consistent capture; inlining the analysis prevents the common failure mode where the operator forgets to invoke it post-wrap and the session drops out of the record.

12b. **End-time `/risk-check` gate.** If the session touched any structural change class (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands or skills, new symlinks, automation with shared-state effects — full list: `ai-resources/docs/audit-discipline.md` § Risk-check change classes), run `/risk-check` once now with `$ARGUMENTS` describing the executed change set across all touched files. Apply paired mitigations before commit if the verdict is PROCEED-WITH-CAUTION; redesign before commit if RECONSIDER. Skip silently if the session touched no class. Rationale: tactile prompt for the end-time gate at the natural session boundary, so the two-gate model doesn't rely solely on operator memory.

After updating logs and writing the telemetry entry, stage and commit changes. **Stage by explicit file paths**, not directory wildcards — directory-level `git add` silently sweeps uncommitted files from concurrent sessions. Enumerate from the Files Created / Files Modified sections just written to the session note, plus always-present wrap-touched files:
- Always-staged (if modified this session): `logs/session-notes.md`, `logs/decisions.md`, `logs/coaching-data.md`, `logs/friction-log.md`, `logs/improvement-log.md`, `logs/improvement-log-archive.md`, `logs/innovation-registry.md`, `logs/usage-log.md` (the `friction-log.md` / `improvement-log.md` pair covers Step 6.5 feedback-collector writes)
- Session-specific: every path listed in Files Created / Files Modified for this session, staged by explicit name

Run as two separate commands, not chained:
- `git add <explicit paths>` (enumerate; no trailing `/` wildcards)
- `git commit -m "session: [brief description of session work]"`

**Push gate (replaces autonomous push).** After the wrap commit lands, count unpushed commits across this repo and any other repos this session touched (Bash: `git log @{u}..HEAD --oneline | wc -l` per repo, or `git status -sb` to see ahead-count). Present a single confirmation prompt in chat:

> Ready to push N commits across M repos: [list of repos and ahead-counts]. Push now? y/n

- On `y`: run `git push` per repo in turn. If a push fails (auth, network, non-fast-forward) surface the failure in chat and stop — do not retry silently.
- On `n`: leave commits unpushed and note it in chat ("Push skipped per operator; N commits remain local").
- Ambiguous reply: re-ask, do not assume.

Do NOT push mid-session at any earlier step, even for "critical" fixes — surface the situation and ask the operator instead.
