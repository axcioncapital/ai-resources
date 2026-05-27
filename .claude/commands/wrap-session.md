---
model: sonnet
---

Wrap the current session. The operator's wrap-up context follows this prompt: $ARGUMENTS

## Instructions

**Do NOT run git commands or bash commands to discover files.** You already know what was produced from conversation context. Auto-commits track file changes separately.

0. As your first action, run `touch /tmp/claude-wrap-session-done` via Bash. This suppresses the session-end hook's "Session ended without /wrap-session" auto-append while this command runs, preventing a file-modification race on `logs/session-notes.md`. The hook deletes the lockfile after reading it, so no cleanup is needed.

**Cost budget.** A typical wrap is ~10–15 tool calls. If you're past 25 tool calls with the wrap not yet committed, stop and ask the operator whether to abort the rest. This catches investigation rabbit-holes, redundant Reads, and ceremony-without-purpose firings before they compound. Self-check your running tool-call count at each step boundary; do not run a separate counter — just notice when you've crossed the threshold.

**Preflight — operator preferences.** Before doing anything else, ask the operator in a single prompt and **wait for the answer**:

> Wrap-session preflight — run these optional passes?
> 1. Session telemetry (usage-analysis) — y/n
> 2. Coaching data capture — y/n

Accept shorthand: "yy" / "yes both" / "both" = both yes; "nn" / "skip both" = both no; "y/n" or "1y 2n" = per-item. Record the two answers and use them to gate Step 7 (coaching) and Step 12 (telemetry). Do not assume defaults — if the operator's reply is ambiguous, re-ask before proceeding. Note skipped passes in chat as "Skipped per preflight" when you reach the corresponding step.

0.5. **Save a continuity scratchpad.** Run the `skills/handoff/SKILL.md` continuity workflow (no-args mode, Steps C1–C2) inline: write a full session-state scratchpad to `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-scratchpad.md` from conversation context. This is a single `Write` call — it counts toward the cost budget above but adds only one call. `/prime` Step 1b detects this scratchpad at the next session start and offers it as a resume point, giving the next session a richer entry than the terse `### Next Steps` list alone. Skip this step only if the session was trivial (single-file edit, one-question read, aborted session) with nothing worth resuming — note "Continuity scratchpad skipped — trivial session" in chat if so. This is your judgment call, same standard as the Step 12 telemetry skip; do not ask the operator.

   **Note:** This scratchpad is the "Pre-closeout" named checkpoint in `ai-resources/docs/compaction-protocol.md` § Named checkpoints — same file, written by this step. See that section for the state-on-disk contract.

1. Run `tail -5 logs/session-notes.md` via Bash to find the append point. If the file doesn't exist, create it with `# Session Notes` as the header. **Format guard:** If the file exists but has no `# Session Notes` header, prepend it. If the last non-empty line is a partial block (unclosed heading, unterminated list), append a blank line before the new entry.
2. Run `tail -5 logs/decisions.md` via Bash to find the append point. If the file doesn't exist, create it with `# Decision Journal` as the header.
3. **Log archive check.** Run `bash logs/scripts/check-archive.sh`. The script iterates append-only logs (session-notes.md, decisions.md) and archives any file exceeding its threshold by invoking `logs/scripts/split-log.sh` internally. Behavior:
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
   -->

   Background: concurrent sessions can both write to `logs/session-notes.md` between this session's `/prime`+`/session-start` and its `/wrap-session`. If a foreign session's content is in the working tree when this session's wrap stages `logs/session-notes.md`, its content ships under this session's wrap commit (the failure mode logged 2026-05-27, commit `14d2a04`). This guard fires **before** Step 4 writes — symmetric to `/session-start` Step 0.5 mtime guard (pre-write posture).

   Detection uses two independent signals to catch both incident shapes:
   - **Today-header delta** — catches the case where the foreign session created its own `## YYYY-MM-DD` header (different header from this session's).
   - **Mandate-line delta** — catches the case where the foreign session ran `/prime` first and reused this session's already-existing today-header (per `/prime` Step 8a.3.a / 8b.1 header-reuse rule), then appended its mandate UNDER the shared header. Header count stays flat (1); mandate-line count rises.

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

   # Determine whether this session ran /prime + /session-start (and thus contributed at most 1 own today-header AND 1 own mandate-line pre-wrap).
   # Uses the `logs/.prime-mtime` marker that /prime Step 8a/8b writes after appending today's header.
   PRIME_RAN=0
   if [ -f logs/.prime-mtime ]; then
     MARKER=$(cat logs/.prime-mtime 2>/dev/null | tr -dc '0-9')
     MARKER=${MARKER:-0}
     TODAY_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TODAY} 00:00:00" "+%s" 2>/dev/null \
       || date -d "${TODAY} 00:00:00" "+%s" 2>/dev/null \
       || echo 0)
     # Marker mtime ≥ today-midnight → /prime ran this session today.
     if [ -n "${MARKER}" ] && [ "${MARKER}" -ge "${TODAY_EPOCH}" ] 2>/dev/null; then
       PRIME_RAN=1
     fi
   fi

   # Expected own contribution: up to 1 today-header (may be 0 if /prime reused an existing today-header from a parallel session) and up to 1 mandate-line.
   # FOREIGN_HEADERS allows the header-count delta to exceed PRIME_RAN; FOREIGN_MANDATES allows the mandate-count delta to exceed PRIME_RAN.
   # If EITHER signal indicates foreign content, STOP.
   FOREIGN_HEADERS=$((ADDED_HEADERS - PRIME_RAN))
   FOREIGN_MANDATES=$((ADDED_MANDATES - PRIME_RAN))
   FOREIGN=${FOREIGN_HEADERS}
   if [ "${FOREIGN_MANDATES}" -gt "${FOREIGN}" ]; then
     FOREIGN=${FOREIGN_MANDATES}
   fi
   echo "GUARD: headers WT=${WT_HEADERS} HEAD=${HEAD_HEADERS} added=${ADDED_HEADERS} | mandates WT=${WT_MANDATES} HEAD=${HEAD_MANDATES} added=${ADDED_MANDATES} | PRIME_RAN=${PRIME_RAN} FOREIGN=${FOREIGN}"
   if [ "${FOREIGN}" -ge 1 ]; then
     echo "--- Today-headers in working tree ---"
     grep -n "^## ${TODAY}" logs/session-notes.md 2>/dev/null
     echo "--- Mandate lines in working tree ---"
     grep -n "^\*\*Mandate:\*\*" logs/session-notes.md 2>/dev/null
   fi
   ```

   Interpret the output:

   - **`FOREIGN == 0`** — no foreign content detected. Proceed silently to Step 4.
   - **`FOREIGN ≥ 1`** — **STOP**. Foreign session content is in the working tree. Staging `logs/session-notes.md` now would ship that content under this session's wrap commit. Output the following to the operator, then halt the wrap (do NOT proceed to Step 4):

     > ⚠ Pre-write guard fired: detected {FOREIGN} foreign-session entries in `logs/session-notes.md` working tree (`headers added=K1, mandates added=K2, PRIME_RAN=P` — see Bash output above).
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

     Do not offer a "commit the union" override. Auto-merging session notes is a silent-conflict-resolution anti-pattern — the operator resolves manually by switching terminals.

   - **Edge case (`FOREIGN < 0`)** — this means `PRIME_RAN > ADDED` for one or both signals, i.e., `.prime-mtime` marker claims `/prime` ran but no today-header or mandate-line was added. Most likely `/prime` Step 8a/8b ran in plan-mode (no write), the operator manually pruned an entry, or `/session-start` was skipped after `/prime`. Proceed silently to Step 4 — no concurrent-session risk, but log the discrepancy in chat as `Note: prime-mtime marker present but expected own-content absent in WT — proceeding`.

4. Append a session note at the **END** of `/logs/session-notes.md` (newest entry is the LAST entry; do NOT prepend at the top — `check-archive.sh` interprets top entries as oldest and will archive them). Use conversation context and the operator's summary to populate:
   - `## {date} — {one-line title}` (e.g., "Created supplementary-query-brief-drafter skill")
   - `### Summary` — 2-4 sentences: what was accomplished, what was the focus
   - `### Files Created` — list from conversation context (path + short description)
   - `### Files Modified` — list from conversation context (include any archive file printed in Step 3)
   - `### Decisions Made` — operator-directed decisions grouped by artifact; QC fixes listed separately
   - `### Next Steps` — what command to run next, any recommended groupings or sequencing. **At stage boundaries:** verify the next command against `reference/stage-instructions.md` Stage Entry Commands table before writing — use the exact command name, do not infer from memory.
   - `### Open Questions` — blockers or unresolved items; write "None" if clean
5. If operator decisions with analytical or scoping judgment were made, append to `/logs/decisions.md` with: date, context, decision, rationale, alternatives considered. Skip this if all decisions were routine (operator-directed text edits, QC auto-fixes).
6. If the operator didn't mention decisions but significant ones occurred in the session, list them and ask: "Should I log any of these to the decision journal?"
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
- Always-staged (if modified this session): `logs/session-notes.md`, `logs/decisions.md`, `logs/coaching-data.md`, `logs/improvement-log.md`, `logs/improvement-log-archive.md`, `logs/innovation-registry.md`, `logs/usage-log.md`
- Session-specific: every path listed in Files Created / Files Modified for this session, staged by explicit name

Run as two separate commands, not chained:
- `git add <explicit paths>` (enumerate; no trailing `/` wildcards)
- `git commit -m "session: [brief description of session work]"`
