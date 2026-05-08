# Risk Check — 2026-05-08

## Change

Add new /friday-journal command to ai-resources/.claude/commands/friday-journal.md (model: opus) plus a new ai-resources/logs/ai-journal.md template, and apply four edits to ai-resources/.claude/commands/friday-act.md (Steps 1.5, 3, 3.5, 5 + Notes section) to wire the journal report through as a third supplementary input alongside Friday Advisory and Systems Review. Full plan: /Users/patrik.lindeberg/.claude/plans/i-need-to-develop-harmonic-puppy.md

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-journal.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/ai-journal.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/.claude/plans/i-need-to-develop-harmonic-puppy.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Self-contained additive command + four surgical edits to one consumer; design reuses existing locator / regex / display / logging patterns line-for-line, but the change set qualifies as both "new command" AND "command-definition edits" under audit-discipline.md § Risk-check change classes, has a documentation-coupling tail (cadence docs and `friday-act.md` Notes), and depends on the report-shape contract (`## Items` regex line-for-line match) holding at runtime.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New `/friday-journal` command is pay-as-used (invoked manually by operator on Friday cadence, after `/friday-checkup` and `/friday-so`, before `/friday-act`). Plan line 7: "fills a gap in the Friday cadence: `/friday-checkup` → `/friday-so` → **`/friday-journal`** → `/friday-act`." No SessionStart / Stop / PreToolUse / UserPromptSubmit hook is registered.
- New journal template `ai-resources/logs/ai-journal.md` is a static file — not auto-loaded by any always-on context (workspace CLAUDE.md and ai-resources CLAUDE.md do not `@import` it; verified by reading both files).
- Four edits to `friday-act.md` add ~25 lines of locator + display + disposition-loop scaffolding. `friday-act.md` is a slash command, not always-loaded — only loaded when `/friday-act` is invoked. Per-invocation cost grows by a small fraction (~5% of file length).
- `model: opus` declaration in `friday-journal.md` (plan line 33) is appropriate for the judgment-heavy work described (clarification, grounding, item synthesis) and matches workspace CLAUDE.md Model Tier rule: "Analytical commands declare `model: opus` in YAML frontmatter."

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to `ai-resources/.claude/settings.json` allow / ask / deny lists are described in the plan. Verified settings.json content unchanged in scope: existing `allow: ["Edit","Write","MultiEdit","Bash(*)","Bash(rm *)"]` already covers all file-write operations the new command performs (Read / Write `ai-resources/logs/ai-journal.md`, Write `ai-resources/audits/friday-journal-YYYY-MM-DD.md`, Edit `friday-act.md`).
- No new tool family introduced. `/friday-journal` reads files, writes a markdown report, and edits the journal — all already-permitted operations.
- No deny rule narrowed or removed.
- No scope-escalation across settings layers.

### Dimension 3: Blast Radius
**Risk:** Medium

Direct file touches: 3 (new `friday-journal.md`, new `ai-journal.md`, edits to `friday-act.md`).

Caller / reference enumeration via grep across `ai-resources/`:

- `friday-act.md` consumers grep — 6 references in user-facing docs (`docs/weekly-cadence.md` lines 98, 138, 179; `docs/operator-maintenance-cadence.md` line 79; plus the command file itself). None of these references break — they describe `/friday-act` by name, not by internal step shape.
- `friday-checkup.md` Step 7 / `friday-act.md` Step 2 form a documented schema contract (verified in `friday-act.md` lines 70–71: "Schema contract: the section headings parsed below are produced by `/friday-checkup` Step 7's data contract"). The new change does NOT touch this contract — it adds a *parallel* contract for `## Items` in the journal report.
- `friday-so.md` and `friday-checkup.md` are unmodified — coupling stays one-way (consumer reads producer outputs), as the existing Notes section (line 309) says.
- `weekly-cadence.md` and `operator-maintenance-cadence.md` describe the Friday flow as F1→F3→F4 (`/friday-checkup` → `/friday-so` → `/friday-act`). The plan inserts `/friday-journal` between `/friday-so` and `/friday-act`, but DOES NOT update these cadence docs as part of the four edits. After the change lands, the cadence-docs description of the Friday flow will be incomplete relative to the actual command graph. Not breaking — these docs are operator-facing prose, not a parser contract — but it is documentation drift that the operator should close.
- `friday-act.md` Step 3.5 disposition regex `^\[(high|med|low)\] .+$` is reused unchanged. Plan deliberately designs the report shape to match this regex line-for-line (plan line 71, line 105, line 280). Confirmed regex appears at line 161 of `friday-act.md`. No parser change needed — the contract is backwards-compatible.
- Existing "System Owner inputs (this session)" subsection in `maintenance-observations.md` log entries: plan line 220 explicitly preserves it untouched ("preserves backward-compat with historical maintenance-observations.md entries"). Good.

Backwards-compat posture: when no `/friday-journal` report exists (every prior week + first run), `JOURNAL_PATH = MISSING` and the new code paths are no-ops — Steps 1.5, 3, 3.5, 5 all guard on the MISSING sentinel. Confirmed by the plan's negative test 2 (line 264).

### Dimension 4: Reversibility
**Risk:** Medium

- New command file `friday-journal.md` and new template `ai-journal.md` — `git revert` on the creation commit removes both cleanly.
- Four edits to `friday-act.md` — `git revert` restores prior content cleanly (single-file textual edit).
- Per-run side effect: `/friday-journal` writes `ai-resources/audits/friday-journal-YYYY-MM-DD.md`. Generated reports persist beyond the command invocation; revert of the command file does NOT remove already-generated reports. This is consistent with how `friday-checkup-*.md` reports persist (verified — multiple `friday-checkup-2026-*.md` files exist in `audits/`). One extra cleanup step required: `rm ai-resources/audits/friday-journal-*.md` if the command is rolled back before the operator wants its outputs gone. Tractable, not catastrophic.
- Per-run side effect: `/friday-journal` Step 6 archives entries from `ai-journal.md` active section to `## Archive — YYYY-MM-DD`. After archiving, the active entries are gone from the active section (operator confirmed via the diff prompt — plan line 109). If the command is later rolled back, archived entries remain in the journal file's archive block; they are not auto-resurrected to the active section. Append-only mutation that revert cannot fully undo. Mitigated by the confirm-then-clear gate (plan line 117).
- `/friday-act`'s `maintenance-observations.md` append after consuming a journal report (Step 5 Edit 4b) — log entries containing `### Journal Report (this session)` subsections will persist in the log file after a revert of `friday-act.md`. Revert of the consumer command does not retro-clean log entries it wrote during runs. Consistent with how SO inputs are logged today.
- No external writes (no git push, no Notion write, no API POST). Reversibility stays within the local repo.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit contract on `## Items` line shape** — the plan's correctness rests on `/friday-journal` writing report items in the exact regex `^\[(high|med|low)\] .+$` (plan line 71). The contract is documented at the producer site (in `friday-journal.md`, per the plan) and at the consumer site (via the Edit 4c Notes addition: "Items in the report's `## Items` section are pre-structured to the same `[risk] {text}` shape as Step 3.5's regex"). Documented at both ends — Medium, not High. But there is no programmatic test that the producer and consumer regexes stay in sync if either is later edited.
- **Schema-contract pattern** — `friday-act.md` lines 70–71 already establish the precedent of a Schema contract callout between `/friday-checkup` Step 7 and `/friday-act` Step 2. The new producer-consumer link from `/friday-journal` to `/friday-act` Step 3.5 is *not* given the equivalent boldfaced "Schema contract" callout in the plan's Edit 4c (only a parallel Notes bullet). One implicit dependency on a regex that lives in two files; lighter callout treatment than the existing analogous pattern.
- **Step 3.5 heading rename** — Edit 3 renames "System Owner-derived Additions" to "System Owner-derived and Journal Additions" (plan line 187). No other file references this heading by exact text (grep found 0 hits for the literal heading outside `friday-act.md`). Safe rename, but it sets a precedent that this heading is operator-facing prose, not a parser anchor — fine.
- **Cadence-docs drift** — `weekly-cadence.md` and `operator-maintenance-cadence.md` describe the Friday flow without `/friday-journal`. Plan does not update them. After the change lands, operators reading those docs will see an incomplete picture; the actual flow has a fourth Friday command. This is silent, low-amplitude drift — not load-bearing for runtime, but a hidden coupling between the operator-facing cadence narrative and the actual command graph.
- **`friday-checkup-reminder.sh` hook + 10-day threshold** — `/friday-act` Step 1.7 enforces `DAYS > 10` against the freshest checkup report. Plan line 166 filters journal-report stale-detection at `>= TODAY - 7 days`. Two different thresholds (10 days vs. 7 days) for two different Friday inputs. Each makes local sense (10 = Friday-skip slack; 7 = within-the-week freshness), but the asymmetry is undocumented in the plan. Not load-bearing, but worth surfacing.
- **No overlap with existing mechanisms** — no other command writes to `ai-journal.md`; no other Friday command consumes journal entries. The new producer-consumer pair is the only path.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius — cadence-docs drift):** As part of execution, add `/friday-journal` to the Friday-flow tables in `ai-resources/docs/weekly-cadence.md` (lines 94, 175 area) and `ai-resources/docs/operator-maintenance-cadence.md` (line 79 area) so the operator-facing narrative reflects the real F1→F3→F-new→F4 sequence. One paragraph or two table rows — small touch, closes the documentation drift before it propagates.
- **Mitigation for Dimension 4 (Reversibility — append-only journal mutation):** Keep the confirm-then-clear gate (plan line 117) exactly as designed; do NOT add a "skip prompt with `--yes`" flag in v1. The interactive confirm is the rollback safety valve. Document explicitly in `friday-journal.md` that archive is a one-way operation and recovery is via git history of `ai-journal.md`.
- **Mitigation for Dimension 5 (Hidden Coupling — `## Items` regex contract):** Add a Schema-contract callout in BOTH `friday-journal.md` Step 5 (producer) and `friday-act.md` Step 3.5 (consumer) that names the regex explicitly and points to the other file. Mirror the existing callout pattern at `friday-act.md` lines 70–71. This converts an implicit contract into a documented one and reduces future-edit risk to Low.
- **Mitigation for Dimension 5 (Hidden Coupling — threshold asymmetry):** Add a one-line note in `friday-act.md` Notes section explaining why `/friday-journal` reports use a 7-day filter while `/friday-checkup` reports use a 10-day threshold (within-week freshness vs. Friday-skip slack). Operator can audit the distinction later if either threshold needs tuning.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to `friday-act.md` (lines 70–71, 88–91, 103, 161, 220, 309), settings.json verbatim contents (allow/deny lists), `audit-discipline.md` § Risk-check change classes (lines 15–26), `weekly-cadence.md` and `operator-maintenance-cadence.md` Friday-flow tables (grep counts), and the plan file at `/Users/patrik.lindeberg/.claude/plans/i-need-to-develop-harmonic-puppy.md` (lines 7, 33, 71, 105, 109, 117, 166, 187, 220, 264, 280). Two referenced files (`friday-journal.md`, `ai-journal.md`) are tagged `not yet present` and were not read; their contribution to risk was inferred from the design described in the plan and noted explicitly under the relevant dimensions. No training-data fallback was used.
