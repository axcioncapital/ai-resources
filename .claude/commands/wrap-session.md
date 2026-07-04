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

3.5. **Foreign-session pre-write guard on `logs/session-notes.md`.** Detects a concurrent or orphan session's uncommitted today-header or mandate in the working tree **before** Step 4 stages the file, so foreign content is never shipped under this session's wrap commit (failure mode logged 2026-05-27, commit `14d2a04`). Symmetric to `/session-start` Step 0.5 (that guard covers the `/prime`→`/session-start` window; this covers post-`/session-start`→wrap).

   The detector — two-signal detection (today-header delta + mandate-line delta), marker-aware own-contribution attribution, the CONCURRENT/REMNANT/MIXED/UNKNOWN classifier, and the id-14 date-rollover grace window — plus its two-end format contract with `prime.md` / `session-start.md` / `check-archive.sh` now lives in **`logs/scripts/foreign-session-guard.sh`**, a single source both wrap copies call (extracted from the former ~230-line inline block, 2026-07-04). The script's header carries the full PAIRED CONTRACT; marker lifecycle + attribution rationale: `docs/session-marker.md`. It writes no files — it only reads and echoes the `GUARD:` diagnostic line (plus the grep output when `FOREIGN ≥ 1`) for this step to interpret.

   Resolve and run the guard. The walk-up finds `ai-resources/` from any checkout (the same ancestor-walk `auto-sync-shared.sh` uses); the script reads **this** checkout's `logs/session-notes.md` via the caller's cwd:

   ```bash
   d="$(pwd)"; GUARD=""
   while [ "$d" != "/" ]; do
     for cand in "$d/ai-resources/logs/scripts/foreign-session-guard.sh" "$d/logs/scripts/foreign-session-guard.sh"; do
       [ -f "$cand" ] && { GUARD="$cand"; break 2; }
     done
     d=$(dirname "$d")
   done
   if [ -z "$GUARD" ]; then
     echo "GUARD: script not found via walk-up — proceeding WITHOUT foreign-session detection (degraded wrap)."
   else
     bash "$GUARD"
   fi
   ```

   Interpret the output:

   - **Guard not found** (the script emitted the `script not found via walk-up` degrade line, not a `GUARD:` line) — walk-up could not locate `ai-resources/`; foreign-session detection is unavailable this wrap. Surface "⚠ Foreign-session guard unavailable — degraded wrap (proceeding without concurrent-session detection)" in chat and proceed to Step 4. This should not happen in normal topology; if it recurs, the walk-up or the script is broken.
   - **`FOREIGN == 0`** — no foreign content detected. Proceed silently to Step 4.
   - **`FOREIGN ≥ 1`** — **STOP**. Foreign session content is in the working tree. Staging `logs/session-notes.md` now would ship that content under this session's wrap commit. **Branch by `FOREIGN_CLASS`**:

     - **`FOREIGN_CLASS == UNKNOWN`** — foreign content detected by header-count only; the mechanical classifier could not shape it (known gap: e.g., a same-day already-committed abandoned-orphan entry). Do NOT assume a live concurrent terminal — emit a neutral STOP and classify manually *(branch split from CONCURRENT 2026-07-03; improvement-log "Foreign-session guard's mechanical classifier returns UNKNOWN")*:

       > ⚠ Pre-write guard fired (UNKNOWN): {FOREIGN} foreign entries detected in `logs/session-notes.md`, but the mechanical classifier could not determine their shape. Classify manually before proceeding: (1) inspect the extra headers/mandates (grep output above); (2) check `git log` — already-committed same-day entries with no live owner are an abandoned orphan → REMNANT-shaped recovery; (3) check for a live parallel terminal → CONCURRENT-shaped recovery (wrap it first). Not proceeding automatically; no remediation is prescribed until classified.

     - **`FOREIGN_CLASS == CONCURRENT`** — today-dated extras detected. A concurrent session is the live cause:

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
   - `### Session Value Audit — 80/20 Review` — also written by Step 6.4 (not by you here) when the outcome check runs: the `TYPE:` / `VALUE:` / `SCORE:` / `GATE:` / `OPPORTUNITY:` / `DECISION:` / `LESSON:` / `RULE:` labeled lines. Consumed by `/friday-checkup`'s Weekly Session Value Review roll-up (which greps this heading). Absent when Step 6.4 is skipped.
   - `### Risky actions` — one line: any irreversible/destructive/external/shared-state-clobber action **taken or nearly taken** this session, a gate that should have fired but didn't, or a prompt-injection encountered — else write "None". This is warm-sourced danger input for the Step 6.5 feedback collector (which runs fresh-context and otherwise cannot see the live session). "None" is the common case; do not pad.
   - `### Next Steps` — what command to run next, any recommended groupings or sequencing. **At stage boundaries:** verify the next command against `reference/stage-instructions.md` Stage Entry Commands table before writing — use the exact command name, do not infer from memory.
   - `### Open Questions` — blockers or unresolved items; write "None" if clean
5. **Decisions.** If operator decisions with analytical or scoping judgment were made, append to `/logs/decisions.md` with: date, context, decision, rationale, alternatives considered. Skip if all decisions were routine (operator-directed text edits, QC auto-fixes). If the operator didn't flag decisions but significant ones occurred this session, list them and ask: "Should I log any of these to the decision journal?"

6.4. **Session outcome check + value audit — "did Claude do the job well, and was the session worth having?"** Produces an independent verdict on this session along two axes: the mandate verdict (completion + execution quality) and a **Session Value Audit** (80/20 review — session-type worth, opportunity cost, repeat/stop). Advisory only — nothing here blocks the commit or push; a low value SCORE never gates the commit or push. **Commit-verb verification (added 2026-07-03):** before the wrap note is finalized, verify every completed-tense commit claim in it ("committed", "executed", "shipped", "landed") against `git log --oneline` — a commit that has not actually run yet must be written as pending ("commits at wrap"), never asserted done from memory.

   <!--
   MIRROR NOTE — PORTED 2026-06-01 to the workspace-root copy as its Step 4.4 (positioned before that copy's Step 5 commit). Keep the two in sync on future edits. The workspace-root copy retains a lighter self-authored `### Session Report` (its Step 2b) whose `**Completed:**` line this independent check supersedes; Step 2b's operator questions remain unique to it.
   2026-06-12 — Session Value Audit extension (TYPE/VALUE/SCORE/GATE/OPPORTUNITY/DECISION/LESSON/RULE brief lines, ≤30-line cap, `### Session Value Audit — 80/20 Review` write-back) ported to the workspace-root copy's Step 4.4 same-day. Keep the audit brief text identical across both copies; the roll-up consumer is /friday-checkup's Weekly Session Value Review.
   2026-07-03 — Commit-verb verification sentence appended to the step intro in both copies (improvement-log 2026-07-03 "Wrap note asserted commit as done").
   -->

   - **Gate.** If the operator declined the outcome check in the preflight, skip and note "Outcome check skipped per preflight" in chat. If the session was trivial (single-file edit, one-question read, aborted session), skip with "Outcome check skipped — trivial session" — your judgment call, same standard as the Step 0.5 / Step 12 skips; do not ask the operator.
   - **Resolve the mandate** ("what Claude was supposed to do this session") using `/contract-check`'s priority chain — see `contract-check.md` Step 2; do not duplicate the logic, just follow that order and stop at the first that resolves:
     1. frozen contract `logs/contracts/{today}-*.md` (if present);
     2. the plan file matched by glob `logs/session-plan-*{MARKER}.md` for this session's marker (matches both date-qualified `session-plan-YYYY-MM-DD-S{N}.md` and bare-marker `session-plan-S{N}.md` forms; prefer the most-recently-modified match), if modified today;
     3. today's `**Mandate:**` block in `logs/session-notes.md` (the mandate line + its `Out of scope` / `Files in scope` / `Stop if` / `Required outputs` bullets);
     4. **fallback** — none of the above: judge against the session's stated task as written in today's `### Summary`, and mark the verdict `Confidence: low (no formal mandate)`. Never invent a standard to grade against.
   - **Launch a fresh-context `general-purpose` subagent** with an inline brief (mirror `contract-check.md` Step 4 — NO named agent file, NO disk-notes file; the verdict is short by construction). The brief passes:
     - the resolved **mandate text + its source label**;
     - today's **session-note block** (the claimed outcome: Files Created/Modified, Decisions, Next Steps, Open Questions);
     - explicit permission to **inspect the actual changed files and today's `git log`** to verify the note's claims rather than trusting the self-authored note (this is what keeps the judgment independent — QS-1).

     The brief instructs the subagent to judge **two mandate dimensions plus a Session Value Audit** and return **≤30 lines**:
     - **`COMPLETION: DELIVERED | PARTIAL | MISSED`** — DELIVERED = did what the mandate asked, in usable form; PARTIAL = core delivered but a named part is missing/unfinished/unverified; MISSED = did not deliver, or delivered something materially different.
     - **`EXECUTION: OPTIMAL | ACCEPTABLE | SUBOPTIMAL`** — was the *path* good? Judge three sub-axes: **efficiency** (wasted steps, redundant reads, rework loops, unnecessary subagents/detours), **approach** (was a clearly better method/design/tool available?), **process** (required gates followed — QC, risk-check — or skipped, or over-engineered past the task).
     - **Evidence guard (load-bearing):** a `SUBOPTIMAL` (or any "could be better") call MUST cite a concrete observation — a visible rework loop, a named detour, a skipped gate, an over-built artifact. No vague "could be tighter." With no evidence of waste, default to `ACCEPTABLE`/`OPTIMAL`.
     - `What was asked but not done:` — bulleted; "none" if DELIVERED.
     - `Better path:` — for ACCEPTABLE/SUBOPTIMAL, the concrete better route, each tied to its evidence; "none" if OPTIMAL.
     - `Confidence:` — high | low (low when the mandate came from the fallback).

     — and the **Session Value Audit** lines. Apply the rubric in `ai-resources/docs/session-value-audit-rubric.md` (the subagent reads it) and return its labeled lines verbatim: `TYPE:` / `VALUE:` / `SCORE:` / `GATE:` / `OPPORTUNITY:` / `DECISION:` / `LESSON:` / `RULE:` (~10–14 lines). That rubric carries the byte-identical-output contract — `/friday-checkup`'s roll-up greps those labels and the `### Session Value Audit — 80/20 Review` heading, so they must not drift.
     - **Scope boundary (state in the brief):** judge *this task's* execution against *this mandate*, and *this single session's* worth — nothing wider. Do NOT do general token telemetry (that is `/usage-analysis`), cross-session iteration patterns (that is `/coach` and the `/friday-checkup` roll-up), or propose/log system fixes (that is Step 6.5 + `/improve`). This step **grades**; it does not file improvements.
   - **Write the returned verdict** as an `### Outcome` block (the `COMPLETION:` and `EXECUTION:` lines + the notes) into today's session-note entry, placed **after `### Decisions Made`, before `### Risky actions`**.
   - **Write the returned audit lines** as a `### Session Value Audit — 80/20 Review` block (the `TYPE:` / `VALUE:` / `SCORE:` / `GATE:` / `OPPORTUNITY:` / `DECISION:` / `LESSON:` / `RULE:` lines verbatim, ~10–14 lines) into today's session-note entry, placed **after `### Outcome`, before `### Risky actions`**. Prose with labeled lines — no extra schema, no separate file.
   - **Surface in chat:** show both verdict lines plus the `TYPE:`, `SCORE:`, and `DECISION:` lines. If `COMPLETION: MISSED`, `EXECUTION: SUBOPTIMAL` with a load-bearing better-path, `TYPE:` D or E, or `DECISION:` Batch/Redesign/Stop, surface it prominently — but **advisory only; it does NOT block** the commit or push (a low `SCORE:` never gates anything).
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
     - the target store paths: `logs/friction-log.md` and `logs/improvement-log.md` (the collector greps these for dedup; it does **not** scan `logs/improvement-log-archive.md`)
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
11. **Advisory nudges** (one line each, only when triggered; all advisory — none blocks). Skip any bullet silently when its trigger does not fire.
    - **Mission:** scan today's mandate block (today's `## YYYY-MM-DD` header to the next `##` or EOF) for a `- Mission: <id>` line. If present: "This session served mission `<id>`. Consider updating its `## Open threads` (and closing it if done) with `/mission`."
    - **Blind-spot scan:** if the session touched `.claude/commands/`, `skills/`, `.claude/hooks/`, any CLAUDE.md, or made a ≥3-file change, emit: "Consider `/blindspot-scan` before commit — checks stale dependent artifacts, real-usage fit, capability validity." Do NOT auto-fire.
    - **Improvement-log archival:** `grep -c '^\- \*\*Verified:\*\*' logs/improvement-log.md 2>/dev/null || echo 0` — if ≥ 5, emit: "N resolved entries in improvement-log — consider `/resolve-improvement-log` to archive them."

   *(Cut 2026-07-04: former Step 9 shared-command-drift ask — auto-sync-shared.sh already propagates; former Step 11 /improve reminder — redundant with /session-start + /friday-checkup. Former Step 10 improvement-verify relocated to /friday-checkup.)*
12. **Session telemetry.** If the operator declined telemetry in the preflight, skip this step with a one-line note in chat ("Telemetry skipped per preflight") and proceed to the commit step. Otherwise, run the usage analysis inline before committing. Execute the full `/usage-analysis` flow (build session summary, read existing `logs/usage-log.md` if it exists, delegate to the `session-usage-analyzer` subagent per `ai-resources/skills/session-usage-analyzer/SKILL.md`, write the returned entry to the log). For trivial sessions (single-file edit, one-question read, aborted session), skip with a one-line note in chat ("Telemetry skipped — trivial session") and proceed. Rationale: R14 telemetry baseline depends on consistent capture; inlining the analysis prevents the common failure mode where the operator forgets to invoke it post-wrap and the session drops out of the record.

12b. **End-time `/risk-check` gate.** If the session touched any structural change class (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands or skills, new symlinks, automation with shared-state effects — full list: `ai-resources/docs/audit-discipline.md` § Risk-check change classes), run `/risk-check` once now with `$ARGUMENTS` describing the executed change set across all touched files. Apply paired mitigations before commit if the verdict is PROCEED-WITH-CAUTION; redesign before commit if RECONSIDER. Skip silently if the session touched no class. Rationale: tactile prompt for the end-time gate at the natural session boundary, so the two-gate model doesn't rely solely on operator memory.

12c. **QC-PENDING commit guard (architectural-change backstop).** Before staging, check whether this session produced or modified any `/risk-check` change-class artifact (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands or skills, new symlinks, automation with shared-state effects — full list: `ai-resources/docs/audit-discipline.md` § Risk-check change classes) that did **not** receive a passing independent `/qc-pass` this session. Derive from conversation context; if independent QC was unreachable per `ai-resources/docs/qc-independence.md` § Subagent-unavailable fallback (the 1M-credit subagent gate), it did **not** pass. If any such artifact exists: do **not** stage or commit it — write (or refresh) a QC-PENDING continuity scratchpad via `/handoff` (no args) naming the artifact, and surface in chat: "⚠ Architectural artifact {X} has no independent QC — commit blocked; resume in a fresh session via `/prime` → `/qc-pass` → commit." Stage and commit only the QC-clean remainder in the step below. If uncertain whether QC passed, surface and ask rather than committing. Skip silently if every in-class artifact was independently QC'd this session. Rationale: the reactive escalation in `qc-independence.md` depends on the agent catching the QC failure mid-session; this guard is the memory-independent backstop at the commit boundary.

After updating logs and writing the telemetry entry, stage and commit changes. **Stage by explicit file paths**, not directory wildcards — directory-level `git add` silently sweeps uncommitted files from concurrent sessions. Enumerate from the Files Created / Files Modified sections just written to the session note, plus always-present wrap-touched files:
- Always-staged (if modified this session): `logs/session-notes.md`, `logs/decisions.md`, `logs/coaching-data.md`, `logs/friction-log.md`, `logs/improvement-log.md`, `logs/improvement-log-archive.md`, `logs/innovation-registry.md`, `logs/usage-log.md` (the `friction-log.md` / `improvement-log.md` pair covers Step 6.5 feedback-collector writes)
- Session-specific: every path listed in Files Created / Files Modified for this session, staged by explicit name

Run as two separate commands, not chained:
- `git add <explicit paths>` (enumerate; no trailing `/` wildcards)
- `git commit -m "session: [brief description of session work]"`

**Push gate (replaces autonomous push).** After the wrap commit lands, count unpushed commits across this repo and any other repos this session touched (Bash: `git log @{u}..HEAD --oneline | wc -l` per repo, or `git status -sb` to see ahead-count). Present a single confirmation prompt in chat:

> Ready to push N commits across M repos: [list of repos and ahead-counts]. Push now? y/n

- On `y`: **before pushing each repo**, run `git fetch origin` and check for remote divergence (`git rev-list HEAD..@{u} --count`). If the remote has new commits (count > 0), surface a warning: "Remote has N new commits ahead of local — rebase first to avoid non-fast-forward rejection. Rebase now (`git rebase origin/main`), or skip this repo?" Wait for the operator's choice before proceeding. If no divergence (count = 0), proceed with `git push`. If a push fails (auth, network, non-fast-forward), surface the failure in chat and stop — do not retry silently.
- On `n`: leave commits unpushed and note it in chat ("Push skipped per operator; N commits remain local").
- Ambiguous reply: re-ask, do not assume.

Do NOT push mid-session at any earlier step, even for "critical" fixes — surface the situation and ask the operator instead.

13. **Per-id session-marker teardown (concurrent-session liveness signal).** As the **final** wrap action — after every marker-dependent step above (Step 3.5 attribution, Step 7a mandate read) and after the commit — remove this session's per-id marker so the per-id marker set tracks only **un-wrapped** (≈ live) sessions. This is the signal `.claude/hooks/detect-concurrent-session.sh` reads to distinguish a genuine concurrent same-checkout session from this operator's own already-wrapped one (Fix 1, 2026-06-10):

    ```bash
    [ -n "${CLAUDE_CODE_SESSION_ID}" ] && rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
    ```

    Leave the shared `logs/.session-marker` untouched — it is `/prime`'s same-day increment oracle (date-pruned, not liveness-pruned). Run this **last**: removing the per-id marker earlier would break Step 3.5's marker-aware attribution and Step 7a. If `CLAUDE_CODE_SESSION_ID` is unset, skip silently (no per-id marker was written). A crashed or aborted session that never reaches this step leaves its marker until `/prime`'s next-day orphan prune — an acceptable degrade (an occasional stale over-nudge from the detector, never a missed live collision). Two-end contract registered in `docs/session-marker.md` § Concurrent-session detection. MIRROR NOTE: the workspace-root `/.claude/commands/wrap-session.md` is an independent non-symlink copy — port this teardown there too (as its final step) on the next sync so both wrap paths maintain the liveness signal.
