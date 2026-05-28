# Fix plan — Wave 3 (Structural / `/risk-check`) — 2026-05-28 19:02

**Source command:** `/fix-repo-issues`
**Wave:** 3 of 3 — `/risk-check`-gated TOCTOU patches (Group F)
**Scopes scanned:** ai-resources, project ai-development-lab, project axcion-ai-system-owner, project nordic-pe-macro-landscape-H1-2026, project nordic-pe-screening-project
**Scanner notes (per scope):** see [Wave 1 plan file](fix-repo-issues-2026-05-28-1902-wave1-hygiene.md) for the per-scope working-notes links.
**Plans directory:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/`
**Items:** 4
**Estimated effort:** 2–3 hours. Every item is a `/risk-check` change class (cross-cutting protocol change OR canonical shared-state automation). Plan-time `/risk-check` gate is REQUIRED per workspace `Autonomy Rules #9` and `ai-resources/docs/audit-discipline.md § Risk-check change classes`.

## Sibling waves

- **Wave 1 (Hygiene):** [fix-repo-issues-2026-05-28-1902-wave1-hygiene.md](fix-repo-issues-2026-05-28-1902-wave1-hygiene.md) — 9 log/config hygiene fixes + new log entries.
- **Wave 2 (Commands/hooks):** [fix-repo-issues-2026-05-28-1902-wave2-commands.md](fix-repo-issues-2026-05-28-1902-wave2-commands.md) — 8 single-file `/prime` + hook + doc edits.

## Sequencing — READ BEFORE EXECUTING

**Item 1 (`id-31` Phase 1 — `.session-marker`) MUST land first.** It is foundational. After it lands, **re-evaluate items 2, 3, and 4** — some may be obsoleted by the marker-write being available downstream:

- Item 2 (`id-09`, auto-mode task count) — likely still needed; tracks task count, not session identity. Re-evaluate whether the new marker payload subsumes the task-count signal.
- Item 3 (`id-32`, CONCURRENT/REMNANT/MIXED classifier) — likely still needed; the classifier reads date from header text, not marker identity. Confirm.
- Item 4 (`nordic-pe-macro/id-13`, `/session-plan` Step 0 wrap-state check) — may simplify if marker presence indicates own-session vs foreign. Re-evaluate the MISMATCH heuristic in light of marker availability.

**Recommended cadence:** land item 1 → run `/qc-pass` + verify → re-read items 2/3/4 against the new state → apply remaining items one at a time, each with its own `/risk-check`. Do NOT batch items 2-4 in a single risk-check pass; the change classes are independent enough that batched mitigations would over-fire.

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in.

Instruct fresh-session Claude:

> Execute the fix plan at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave3-structural.md`. Land item 1 first, then re-evaluate items 2-4 before applying. Each item requires a plan-time `/risk-check` gate per workspace Autonomy Rules #9.

For each item: read the source improvement-log entry in full, draft the precise diff, run `/risk-check` per workspace rule, apply mitigations, edit, `/qc-pass`, commit. Read `ai-resources/.claude/commands/resolve-improvement-log.md` for the status-flip schema.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-31 — Phase 1 ONLY] `/prime` writes session marker to `logs/.session-marker`
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/improvement-log.md):183 ("Concurrent sessions cause TOCTOU races on shared log files")
- **Scope boundary:** This wave covers **Phase 1 only** per the source entry's migration plan. Phases 2–4 (consumer-side reads, file-naming switch, legacy cleanup) are deliberately deferred to subsequent waves. Do NOT extend scope beyond marker generation + persistence + `.gitignore` entry.
- **Fix:**
  1. Edit `ai-resources/.claude/commands/prime.md` Step 8a.3.a, Step 8b.1, and Step 8c.3. At each marker-write site (where `.prime-mtime` is currently captured), ALSO generate and persist a 4-character session marker to `logs/.session-marker`. Marker scheme per the source entry: `S1`, `S2`, … incrementing on the existing file's value if same-day; otherwise reset to `S1`.
  2. Add `logs/.session-marker` to `ai-resources/.gitignore` (it is per-machine session state, not committed).
  3. No other command consumes the marker in this phase — strictly additive write.
  4. Surface the marker value in the `/prime` brief footer line as a one-liner: `Session marker: {value}`.
- **`/risk-check` change class:** YES — cross-cutting protocol change (additive but introduces a new shared-state surface that downstream phases will depend on). Run `/risk-check` BEFORE editing.
- **Post-fix log update:** flip improvement-log.md:183 (ai-resources) entry status to `**Status:** Phase 1 applied 2026-05-{date}` + `**Verified:**` line. Annotate that Phases 2–4 remain `pending`. Update the supersession note on improvement-log.md:174 (the narrow `/session-start` Step 0.5 entry) to reaffirm "Status: superseded by broader entry below; Phase 1 of broader entry applied {date}."
- **QC needed:** yes — `/qc-pass` on the `/prime` edits (3 sites) + verify `.gitignore` line + verify marker file is correctly written by manual smoke test (start `/prime`, check `cat logs/.session-marker`).

### [ai-resources/id-09] Track auto-mode task count for `/wrap-session` Step 3.5 guard
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` + workspace-root copy
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/friction-log.md):85 (Session — 2026-05-28 14:20 entry on the Step 3.5 guard false-positive)
- **Re-evaluation note:** Reconsider in light of item 1 landing. If the new `.session-marker` payload can encode the per-session task count directly, this item may simplify or merge into item 1's marker schema.
- **Fix:**
  1. Edit `/prime` Step 8c (auto-mode chain) to write task count to `.prime-mtime` payload (or a sibling marker `.prime-task-count`). Each chained task in auto mode increments the count.
  2. Edit `/wrap-session` Step 3.5 guard: when computing `FOREIGN_HEADERS = ADDED_HEADERS - 1`, use `FOREIGN_HEADERS = ADDED_HEADERS - PRIME_TASKS` instead. `PRIME_TASKS` defaults to 1 if the marker is absent (preserves current behavior for non-auto-mode sessions).
  3. Update both the canonical `ai-resources/.claude/commands/wrap-session.md` AND the workspace-root paired copy at `~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` (per the existing PAIRED CONTRACT comment block in those files).
- **`/risk-check` change class:** YES — modifies the `/wrap-session` foreign-session guard, which is the same shared-state automation that prior risk-checks have gated. Run `/risk-check`.
- **Post-fix log update:** add new improvement-log entry capturing the friction-log false-positive resolution; cross-ref the friction-log:85 entry. Annotate friction-log:85 with `Resolved: {date}` line.
- **QC needed:** yes — `/qc-pass` on the guard math + verify the auto-mode chain produces the expected `PRIME_TASKS` value.

### [ai-resources/id-32] `/wrap-session` Step 3.5 CONCURRENT/REMNANT/MIXED classification
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` + workspace-root copy
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/improvement-log.md):248
- **Re-evaluation note:** Likely still needed after item 1 lands — the classifier reads dates from `## YYYY-MM-DD` headers, independent of marker identity. Confirm by reading the source entry's proposal against the post-item-1 state.
- **Fix:** Patch `/wrap-session` Step 3.5 to parse the enclosing `## YYYY-MM-DD` header of each extra mandate detected by the foreign-guard, and classify the delta as:
  - **CONCURRENT** — today-dated → current behavior (warn about concurrent session).
  - **REMNANT** — prior-day-dated → offer "commit the orphan as a standalone wrap-recovery commit" path.
  - **MIXED** — both today and prior-day → warn about both, ask operator to pick remediation.
  Update both:
  - `ai-resources/.claude/commands/wrap-session.md` Step 3.5
  - `~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` (paired workspace-root copy)
  Per existing PAIRED CONTRACT comment.
- **`/risk-check` change class:** YES — cross-cutting workflow guard with shared-state semantics. Run `/risk-check`.
- **Post-fix log update:** flip improvement-log.md:248 (ai-resources) entry status to `**Status:** applied {date}` + `**Verified:**` line + ref the risk-check report path.
- **QC needed:** yes — `/qc-pass` on both files (must stay synchronized).

### [project-nordic-pe-macro-landscape-H1-2026/id-13] `/session-plan` Step 0 wrap-state check
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` (canonical command)
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):172
- **Re-evaluation note:** Likely STILL needed after item 1 lands. The MISMATCH heuristic activates on existing plan files; marker availability does not directly tell us whether the previous session WRAPPED. Confirm.
- **Fix:** Extend `/session-plan` Step 0 MISMATCH branch (`ai-resources/.claude/commands/session-plan.md` lines 56–60 region per the source entry) to check whether the existing plan's session has already wrapped:
  - Grep `logs/session-notes.md` for a matching `## {plan_date}` header that ALSO contains `### Summary` + `### Next Steps` subsections beneath it.
  - OR run `git log --grep='^session: {date} wrap'` against the project repo for a wrap-commit signal.
  If either signal indicates the session has wrapped → allow plain overwrite of `session-plan.md` instead of routing to `pass2.md`. If no wrap signal → preserve current MISMATCH → `pass2.md` routing.
- **`/risk-check` change class:** YES — automation against shared-state (`session-plan.md`) that reorders the existing collision-detection logic. Run `/risk-check`.
- **Post-fix log update:** flip improvement-log.md:172 (nordic-pe-macro) entry status to `**Status:** applied {date}` + `**Verified:**` line. Reference the risk-check report path.
- **QC needed:** yes — `/qc-pass` on the Step 0 edit (the MISMATCH branch is load-bearing; misfires either direction are observable).

## Parked items (not this wave)

- Group G (multi-file refactors): id-35 change-shape classifier extraction, id-36 Q1–Q8 placement SKILL.md extraction, id-37 architecture-gap report loop. Reason: `multi-file-refactor` + DR-7 timing (defer until next consumer adds pressure).
- Group H (investigation): id-34 sub-subagent dispatch. Reason: `research-not-fix`. Schedule as a time-boxed Friday-act wave when capacity allows.

## Skipped items

(none new; see wave 1 plan for skipped items.)

## After all 4 items land

- The TOCTOU patch family is at v1.0. Phase 2 of `id-31` (consumer-side marker reads in `/session-start` + `/session-plan`) can be scheduled as the natural next wave.
- Re-run `/fix-repo-issues` after a Friday cadence to confirm the friction signals decay (id-08, id-09, id-32 should all show `applied+Verified` and stop surfacing).
