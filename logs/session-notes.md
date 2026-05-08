# Session Notes

> Archive: [session-notes-archive-2026-05.md](session-notes-archive-2026-05.md)

## 2026-05-04 — Deploy-KB: Obsidian KB Infrastructure Pipeline

### Summary
Executing plan from `.claude/plans/i-need-to-develop-scalable-quiche.md`. Building two artifacts: (1) `skills/obsidian-kb-builder/SKILL.md` via `/create-skill` pipeline, (2) `ai-resources/.claude/commands/deploy-kb.md` command.

### Scope
Deliverables only: SKILL.md + bundled templates + deploy-kb.md command. No other changes.

### Files Created
- `skills/obsidian-kb-builder/SKILL.md` — skill spec (146 lines, model: sonnet, effort: medium)
- `skills/obsidian-kb-builder/templates/scaffold/` — 11 scaffold templates (vault-claude-md, _master-index, subfolder-index, kb-query, kb-update, kb-integrity, settings.json, 4 obsidian configs)
- `skills/obsidian-kb-builder/templates/note-templates/` — 4 note templates (research, decision, architecture, finding)
- `.claude/commands/deploy-kb.md` — 10-step deploy command

### Decisions Made
- Inbox and templates/ folders are intentionally indexless (not content-type folders)
- Commit message in Option B git-init uses resolved KB display name (not template literal)
- 90-day staleness, 5-read cap, 500-note scan limit are unexplained constants (C17 — parked for future improvement)

### Next Steps
- Push commits `d81bd68` and `189d78a`
- Run `/wrap-session` if done
- Test `/deploy-kb` on a real project to validate end-to-end

### Open Questions
- None

---

## 2026-05-04 — audit-claude-md on workspace CLAUDE.md

### Summary

Ran `/audit-claude-md` (workspace-only scope) on the root `CLAUDE.md`. The audit produced 26 findings (9 HIGH, 11 MEDIUM, 6 LOW) and projects ~2,500 tokens/turn savings under a Trim + Move + Delete scenario, reducing the file from ~4,160 tokens to ~1,650 — inside the practitioner upper-bound target. The report is committed to `ai-resources`; the CLAUDE.md itself was not modified (diagnostic-only pass).

### Files Changed

**Created:**
- `ai-resources/audits/claude-md-audit-2026-05-04-workspace-only.md` — 531-line audit report with per-block verdict table and savings projections (committed `375ff22`)
- `ai-resources/audits/working/audit-claude-md-external-guidance-2026-05-04.md` — external guidance synthesis from Anthropic docs + 2026 practitioner sources (working file, not committed)
- `ai-resources/audits/working/audit-claude-md-working-notes-2026-05-04.md` — file measurements and context notes (working file, not committed)

### Decisions Made

- Scoped audit to workspace-only (operator said "in the root folder"; no project subdirectory detected from cwd).

### Next Steps

1. **Review the findings report** — [ai-resources/audits/claude-md-audit-2026-05-04-workspace-only.md](../audits/claude-md-audit-2026-05-04-workspace-only.md) — and decide which blocks to Keep / Trim / Move / Delete.
2. **Highest-leverage Moves** (6 blocks, ~2,200 tokens): `QC Independence Rule`, `QC → Triage Auto-Loop`, `Autonomy Rules` (trim to 5-line summary), `Session Guardrails` (already has a doc target), `File Write Discipline`, `Plan Mode Discipline` → `ai-resources/docs/` with `@`-import pointers.
3. **Fix the two HIGH contradictions** identified in Tier 3: (a) add `Assumptions Gate` as Autonomy Rules pause-trigger #10; (b) clarify how the `v2.md` version-file rule composes with the `output/{project}/` Write rule.
4. **Push** the `ai-resources` audit commit (`375ff22`).
5. After CLAUDE.md edits land, run `/token-audit` to measure actual token reduction.

### Open Questions

- None — audit is diagnostic; all edits await operator direction.

## 2026-05-05 — Designed Monday + Friday weekly maintenance cadence

### Summary
Designed a new two-day weekly cadence: Monday ("Oil the Gears") for infrastructure readiness and week setup, Friday for structured review, fixes, and harness development. Ran two QC passes (both REVISE), one triage pass, resolved all Do items, and committed the final Version 4 plan. No commands or skills were built — this was a plan-only session by operator instruction.

### Files Created
- `ai-resources/docs/weekly-cadence.md` — confirmed cadence plan (Version 4), covering Monday phases A–D and Friday Sessions 1–2 with full function map

### Files Modified
- `ai-resources/logs/session-notes-archive-2026-04.md` — auto-created by check-archive.sh (6 entries archived, 10 kept in active file)

### Decisions Made
**Cadence design:**
- Monday includes full `/audit-claude-md project <name>` (not just a pointer scan) with a 14-day AND <100-line skip guard (both conditions must hold)
- Log health check splits into per-project (session-notes, friction-log) and workspace-level (improvement-log, maintenance-observations) — `improvement-log.md` is workspace-only
- Tunable thresholds (200-line, 14-day, 100-line) declared as defaults in the cadence document; session-specific overrides go in the week mandate
- Week mandate written to `harness/session/week-mandate-YYYY-Www.md` each Monday

**Friday command corrections (from QC):**
- Monthly systems-review slot uses `/so-monthly` (not `/systems-review`, which does not exist as a command)
- `/friday-so` output path confirmed: `projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-YYYY-MM-DD.md`
- `/so-monthly` output path confirmed: `projects/axcion-ai-system-owner/output/monthly-reviews/so-monthly-YYYY-MM-DD.md`
- F3 (`/friday-so`) runs before F2 (`/so-monthly`) — `/so-monthly` self-describes as "run after /friday-so"
- Explicit cwd stated for all Friday steps; F3/F2 require `axcion-ai-system-owner` project context

**QC fixes applied:**
- Two QC passes both returned REVISE; triage identified 3 Do / 3 Park items; all 3 Do items applied in Version 4

### Next Steps
- Build the cadence in a separate session: create `/monday-prep` command, update `ai-resources/docs/session-rituals.md` to document the new Friday ordering and add Monday reference
- Phase 3 harness sessions can begin immediately using the confirmed plan — no new commands needed for Phase 3

### Open Questions
- None

---

## 2026-05-05 — Continue weekly-cadence: /monday-prep + session-rituals update

### Summary
Built the /monday-prep command and updated session-rituals.md. /monday-prep executes Phases A–D from weekly-cadence.md: git pull + working-tree scan, symlink audit, CLAUDE.md audit (guarded), log health, permission spot-check, inbox, harness state, week mandate write, and session-notes append. Corrected harness path to workspace root (/harness/, not ai-resources/harness/).

### Files Created/Modified
- `ai-resources/.claude/commands/monday-prep.md` — new command (commit 46e2105)
- `ai-resources/docs/session-rituals.md` — replaced "full project scan" with /monday-prep reference; replaced "Improvement Flush" with Friday cadence summary

### Next Steps
- Push commit 46e2105
- Run /monday-prep on the next Monday to validate it end-to-end
- Consider whether weekly-cadence.md needs explicit workspace-root path note for harness/ references (currently uses relative paths — clear in context, but could be made explicit)

### Open Questions
- None

---

## 2026-05-05 — Built /monday-prep and consolidated weekly session guide

### Summary
Built the /monday-prep command (Phases A–D from weekly-cadence.md) and created a single consolidated weekly-session-guide.md covering repo maintenance and harness preparation. The guide went through two QC passes (both REVISE) with fixes applied via triage. Harness path corrected to workspace root (/harness/, not ai-resources/harness/).

### Files Created
- `ai-resources/.claude/commands/monday-prep.md` — Monday infrastructure cadence command: git pull, working-tree scan, symlink audit, CLAUDE.md audit (guarded), log health, permission spot-check, inbox, harness state, week mandate write
- `ai-resources/docs/weekly-session-guide.md` — consolidated single guide covering Monday /monday-prep, standard sessions, Phase 3 harness sessions, Friday two-session structure, harness-prep reference files, tier detection

### Files Modified
- `ai-resources/docs/session-rituals.md` — replaced "full project scan" with /monday-prep reference; replaced "Improvement Flush" with Friday cadence summary; added pointer to weekly-session-guide.md as canonical entry point

### Decisions Made
**Command build:**
- Harness path corrected mid-session to workspace root (`/harness/`) — initial draft used `ai-resources/harness/` which does not exist
- week mandate path: `harness/session/week-mandate-YYYY-Www.md` at workspace root

**Session guide:**
- Operator directed single consolidated guide (repo maintenance + harness prep) replacing separate docs
- QC pass 1 (guide v1): triage → 4 Do items applied: /prime added to Friday session headers, F0 time bounds restored, F2 trigger phrasing fixed, /so-monthly quick-ref row aligned
- QC pass 2 (consolidated guide): 6 items applied per operator instruction: Phase B guard rules, Phase D commit scoping rule, F2 forward-reference, F5 path corrected to logs/innovation-registry.md, F5 scan location detailed, F6 Phase 3 scope marked with Phase 4+ pointer
- session-rituals.md: added pointer to weekly-session-guide.md as canonical weekly-rhythm entry point

### Next Steps
- Push all commits from this session
- Run /monday-prep on next Monday to validate end-to-end
- weekly-cadence.md uses relative harness/ paths — acceptable in context but could be made explicit with workspace-root note (low priority)

### Open Questions
- None

## 2026-05-07 — Lunch prep: Bird & Bird senior associate meeting

Preparing conversational answers to 7 likely questions from a Finnish M&A lawyer (Bird & Bird senior associate). Relationship-building lunch; he knows nothing about Axcion yet. Tone: plain spoken, smart-but-not-AI-hype, how-I'd-actually-answer-at-lunch.

### Summary
Prepared a session brief for an upcoming relationship-building lunch with a Bird & Bird senior associate. Initial approach was full drafted answers; operator switched to an alternatives-selection format (3 framings per question, operator picks). Brief is self-contained — next session reads it and runs the selection process without re-explaining. QC pass returned REVISE with 4 findings; all applied.

### Files Created
- `logs/session-plan.md` — session plan for this session (alternatives-selection brief work)
- `projects/meeting-prep/bird-and-bird-lunch-brief.md` — self-contained brief: Axcion context, audience profile, tone target, 7 questions with A/B/C framing instructions, assembly pass instructions

### Files Modified
- `logs/session-notes.md` — session header appended by /prime

### Decisions Made
- **Alternatives-selection format chosen over final draft:** Operator switched approach mid-session — produce 3 framings (A/B/C) per question so operator can choose the one that matches their natural voice, rather than editing a single draft.
- **Q5 scope narrowed:** Answer only "what have you successfully handed over to AI" — drop the "which did you try to automate but pull back from" half per operator direction.
- **QC fixes applied:** Sentence length 3–4 (not 2–4); Q5 framings redesigned around successes only; Q5 "fallback" framing removed (no longer relevant after scope change); Q6 gap flag made firm (not optional).

### Next Steps
- Next session: read `projects/meeting-prep/bird-and-bird-lunch-brief.md` and run the alternatives-selection session (Q1 → Q7, one at a time, pick A/B/C)
- Before that session: (1) optional — have a concrete example ready for Q6 (catching an AI error before it went out; makes framing B stronger); (2) confirm DPA status for Q7 — the lawyer will likely ask

### Open Questions
- Q6: do you have a concrete example of catching an AI error before it went out? Not required, but framing B needs it.
- Q7: is a Data Processing Agreement in place? What is the lawful basis for processing fund criteria data? Lawyer will likely ask directly.

## 2026-05-08 — /friday-checkup weekly cadence

Ran the weekly Friday maintenance cadence across ai-resources, workspace root, axcion-ai-system-owner, global-macro-analysis, and repo-documentation.

### Summary
Full weekly tier checkup completed. Audit-repo found ai-resources RED (1 critical: broken consult.md symlink in research-workflow). Permission sweep found 3 HIGH (missing tool grants + additionalDirectories in ai-resources settings.json, unresolved placeholder in research-workflow). Coach ran for all 5 scopes — 3 new baseline logs created (workspace, axcion-ai-system-owner, global-macro-analysis). Improve ran for ai-resources (0 new; friction already resolved) and global-macro-analysis (3 entries logged: concurrent-session race, /kb-review skip condition, concurrency hook). W2.1 doc-scan: 44 added, 3 removed. Vault integrity: 1 error (innovation-sweep missing 5 schema fields), 8 warnings.

### Files Created
- `ai-resources/audits/friday-checkup-2026-05-08.md` — consolidated report
- `ai-resources/audits/repo-health-ai-resources-2026-05-08.md` — audit-repo snapshot
- `ai-resources/audits/permission-sweep-2026-05-08.md` — permission sweep dry-run report
- `logs/coaching-log.md` — workspace coaching baseline
- `projects/axcion-ai-system-owner/logs/coaching-log.md` — coaching baseline
- `projects/global-macro-analysis/logs/coaching-log.md` — coaching baseline
- `projects/global-macro-analysis/logs/improvement-log.md` — 3 entries appended
- `projects/repo-documentation/output/phase-2/w2-1-doc-scan-2026-05-08.md`
- `projects/repo-documentation/output/phase-2/w2-3-maintenance-2026-05-08.md`
- `projects/repo-documentation/vault/_integrity-report-2026-05-08.md` (gitignored)

### Files Modified
- `ai-resources/logs/coaching-log.md` — 2026-05-08 entry appended
- `projects/repo-documentation/logs/coaching-log.md` — 2026-05-08 entry appended
- `ai-resources/reports/repo-health-report.md` — replaced by new audit

### Next Steps
- Fix `consult.md` symlink in research-workflow (3-level → 4-level path) — risk: high
- Run `/permission-sweep` (without --dry-run) to fix ai-resources settings.json
- Fix `innovation-sweep` schema entry in vault/components/commands.md
- Run `/cleanup-worktree` to commit this session's outputs
- Paste 44 new W2.1 entries into vault/components/ via /kb-update

### Open Questions
- None

## 2026-05-08 — /friday-so, /systems-review

Running /friday-so → /systems-review. /so-monthly dropped — today's checkup is weekly tier; save for next monthly-tier Friday.

### Next Steps
- Execute the session plan: run /friday-so → /systems-review on Opus (plan at logs/session-plan.md)
- Model pin removed from settings.local.json — use /model opus at session start before running these commands

## 2026-05-08 — /friday-so + /systems-review + /friday-act SO awareness

Ran /friday-so against today's checkup (weekly tier; produced friday-advisory v2 alongside the morning's v1 per workspace iteration rule), then /systems-review on a 4-projects + cadence-doc scope. Systems-review surfaced Loop 3 (System Owner outputs → action) as open. Operator directed closing it: edited /friday-act to read the freshest /friday-so + /systems-review outputs as supplementary inputs (Steps 1.5 + 3.5; manual paste, no prose parsing). Plan-time /risk-check returned PROCEED-WITH-CAUTION; three mitigations applied inline. Post-commit /qc-pass returned GO with one editorial flag (sub-item numbering collision; functional impact zero — declined).

### Summary
Three commands executed (/friday-so, /systems-review, /friday-act enhancement). The systems-review identified operator attention at the cadence-project interface as the binding constraint and named five Meadows leverage points. Operator chose to act on Leverage Point #2 (Information flows — close Loop 3) immediately by patching /friday-act. Two commits landed: workspace-root (SO outputs) and ai-resources (friday-act + risk-check audit).

### Files Created
- `projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-2026-05-08-v2.md` — v2 against today's weekly-tier checkup (v1 was generated earlier today against last week's monthly-tier checkup; preserved per iteration rule)
- `projects/axcion-ai-system-owner/output/systems-reviews/systems-review-2026-05-08-4-projects-cadence-doc.md` — systems-thinking analysis of 4 projects + operator-maintenance-cadence doc
- `audits/risk-checks/2026-05-08-edit-friday-act-md-to-make-it-aware-of-the-freshest-friday.md` — plan-time risk-check report (PROCEED-WITH-CAUTION)

### Files Modified
- `.claude/commands/friday-act.md` — added Step 1.5 (locate System Owner outputs), Step 3.5 (paste-driven disposition for SO-derived items), updated Step 3 display and Step 5 session block schema; added Notes bullet documenting the new awareness behavior
- `logs/session-notes.md` — this entry

### Decisions Made
- **Shape A (same-Friday read in /friday-act) over Shape B (cross-week absorb in /friday-checkup):** Same-Friday closes the loop today rather than introducing a 7-day delay; the systems-review explicitly flagged delay-shortening as the right direction (LP 9). Logged separately to decisions.md.
- **Manual paste (option b) over auto-extract (option a):** SO outputs are prose, not structured. Auto-parsing would create shape-fragile coupling vulnerable to producer-side prose changes. Logged separately to decisions.md.
- **Wrote v2 friday-advisory alongside v1 (not overwrite):** Per workspace CLAUDE.md iteration rule. v1 grounded in last-week's monthly-tier checkup; v2 grounded in this-week's weekly-tier checkup.
- **Skipped optional /risk-check mitigation #4 (producer-side notes in /friday-so + /systems-review):** Would stretch single-file scope; revisit if drift surfaces.
- **Skipped end-time /risk-check per memory rule:** Plan-time covered, all required mitigations applied inline, drift bounded (executed plan exactly + one Notes-section bullet documenting the new behavior). Documented the skip in the friday-act commit body.
- **Accepted /qc-pass GO with one editorial flag declined:** Sub-item numbering collision (Step 3 has item 16; Step 3.5 sub-items numbered 16a–16e) — reviewer explicitly tagged as editorial-only, functional impact zero. Renumbering would add churn without behavior change.

### Next Steps
- Push both commits when ready (operator approval required per Autonomy Rules #2). Two repos: workspace root (162efaa) and ai-resources (e9e0693).
- Carry-forward from prior session-notes (still applicable):
  - Fix consult.md symlink in research-workflow (3-level → 4-level path)
  - Run /permission-sweep (without --dry-run) to fix ai-resources settings.json (3 HIGH)
  - Fix innovation-sweep schema entry in vault/components/commands.md
  - Paste 44 new W2.1 entries into vault/components/ via /kb-update

### Open Questions
- None

## 2026-05-08 — /friday-journal command + ai-journal workflow

### Summary
Built the `/friday-journal` command to convert the operator's freeform weekly AI journal into a structured implementation report consumed by `/friday-act`. Closes the Friday cadence gap between informal note-taking and structured execution. Two-gate `/risk-check` model applied (plan-time PROCEED-WITH-CAUTION → mitigations applied → end-time GO).

### Files Created
- `ai-resources/.claude/commands/friday-journal.md` — new command, `model: opus`, 7-step workflow (load → ambiguity → batch clarify → grounding → generate report → confirm-archive → exit summary)
- `ai-resources/logs/ai-journal.md` — freeform journal template; pre-seeded with one active entry (deny-list permission issue)
- `ai-resources/audits/risk-checks/2026-05-08-add-new-friday-journal-command-to-ai-resources-claude.md` — plan-time risk-check (PROCEED-WITH-CAUTION; blast/reversibility/coupling Medium)
- `ai-resources/audits/risk-checks/2026-05-08-end-time-friday-journal-feature-executed.md` — end-time risk-check (GO; all dimensions Low)

### Files Modified
- `ai-resources/.claude/commands/friday-act.md` — four edits (Step 1.5 locator, Step 3 display block, Step 3.5 disposition + sub-step 16f, Step 5 logging + Notes bullets) wiring journal report as third supplementary input alongside Friday Advisory and Systems Review
- `ai-resources/docs/weekly-cadence.md` — added F3.5 in session/cwd map, description block, full function map
- `ai-resources/docs/operator-maintenance-cadence.md` — added structured F3.5 row to Friday Session 1 table

### Decisions Made
- Report shape: flat `## Items` matching existing `^\[(high|med|low)\] .+$` regex, detail in separate `## Item context` block — zero parser change in `/friday-act`
- Same-day collision: overwrite-with-prompt (single canonical file per day) instead of `-v2` suffix — `-` lex-sorts before `.` and would break `/friday-act` Step 1.5 locator
- Schema-contract callout pattern mirrored on producer (`friday-journal.md` Step 5 sub-step 14) and consumer (`friday-act.md` Step 3.5 sub-step 16f) sides
- Renamed `JOURNAL_PATH` → `JOURNAL_SOURCE` inside friday-journal.md to avoid name collision with friday-act's `JOURNAL_PATH` variable
- Separately, did NOT fix the deny-list issue (8 entries in `ai-resources/.claude/settings.json` overriding `bypassPermissions`) — diagnosed mid-session, logged to ai-journal for later /risk-check + remediation

### Next Steps
- Push commit c3b1c15 (operator approval required per Autonomy Rules #2)
- Test `/friday-journal` end-to-end on next Friday (2026-05-15) — F3.5 slot in Session 1
- Address deny-list permission issue logged in `ai-resources/logs/ai-journal.md` (requires `/risk-check` first per audit-discipline.md change classes)
- Carry-forward from prior session-notes (still applicable):
  - Push prior commits (workspace root 162efaa, ai-resources e9e0693)
  - Fix consult.md symlink in research-workflow
  - Run /permission-sweep to fix ai-resources settings.json
  - Fix innovation-sweep schema entry in vault/components/commands.md
  - Paste 44 new W2.1 entries into vault/components/ via /kb-update

### Open Questions
- None

## 2026-05-08 — /friday-act plan-branching refactor

Converted `/friday-act` from inline-execution to plan-file production. The command now dispositions items across all three sources (checkup, SO-derived, journal-derived) and writes one or more plan files to `audits/friday-plans/` instead of executing fixes inline. Threshold: ≤ 4 fix-now items → one consolidated plan; > 4 → per-area split. Also ran `/fewer-permission-prompts` — no changes needed (project already has `bypassPermissions` + `Bash(*)`).

### Files Created
- None (plan file lives in `~/.claude/plans/`, outside repo)

### Files Modified
- `.claude/commands/friday-act.md` — 8 change clusters: blurb update, disposition label, items 15a–g replaced with 15a–c, 16d/16f updated, new Step 3.6 (Plan Generation), Step 5 session block, Step 7 exit summary, Notes section

### Decisions Made
- **Split axis: by target file/area** — minimize context-switching cost per follow-up session
- **Threshold N = 4** — ≤ 4 fix-now items → consolidated plan, > 4 → per-area split
- **Inline execution removed entirely** — single execution model, no dual-path maintenance
- **`/risk-check` gate deferred to execution time** — annotated in plan file; avoids heavy Opus subagent during /friday-act disposition
- **W2.4 sub-disposition deferred to execution time** — `(a) auto-draft / (b) manual` choice made when opening plan, not at queue time
- **Plan-file schema defined in this edit** — 7-field fixed schema in Step 3.6 ensures consistent plan files from day one
- **End-time `/risk-check` skipped** — plan-time covered (2× /qc-pass + ExitPlanMode approval, all mitigations applied inline); commit shipped (af7811a); drift bounded (verified by grep against all 8 change clusters)

### Next Steps
- Push commit af7811a (ai-resources) + prior commits 162efaa (workspace root) + e9e0693 (ai-resources)
- Fix `consult.md` symlink in research-workflow (3-level → 4-level path)
- Run `/permission-sweep` (without `--dry-run`) to fix ai-resources settings.json (3 HIGH)
- Fix `innovation-sweep` schema entry in vault/components/commands.md
- Paste 44 new W2.1 entries into vault/components/ via /kb-update

### Open Questions
- None

## 2026-05-08 — /friday-journal validation gate + archive + improvement spec

### Summary
Implemented the output-validation gate for /friday-journal (Steps 5.4 + 5.5), adding a deterministic mechanical pre-check and an auto-spawned qc-reviewer pass between Step 5 (report generation) and Step 6 (archive). Archived all 32 active ai-journal entries. Ran the gate as a catch-up on today's report, applying 7 findings and tagging 12 items with `**Risk-check required:**` bullets. Drafted an 8-suggestion improvement spec for /friday-journal based on today's session friction.

### Files Created
- `audits/working/friday-journal-improvement-spec-2026-05-08.md` — 8 improvements (S1–S8) with sequencing, open questions, and recommended landing order (gitignored)

### Files Modified
- `.claude/commands/friday-journal.md` — Steps 5.4 (mech pre-check) + 5.5 (output validation gate) inserted; Step 5 frontmatter template updated to include `items_generated` field; Step 7 exit summary updated with validation telemetry; Notes section updated
- `.claude/agents/qc-reviewer.md` — description updated to add `/friday-journal Step 5.5` as second invoker
- `logs/ai-journal.md` — all 32 active entries archived to `## Archive — 2026-05-08`, active section cleared
- `audits/friday-journal-2026-05-08.md` — catch-up gate applied: line 75→77 fix (×2), wording fix for E8 drop, bookkeeping ledger added to Summary, 12 items received `**Risk-check required:**` bullets

### Decisions Made
- **Reuse qc-reviewer vs. new agent:** qc-reviewer's 6-dimension rubric maps cleanly onto journal-output concerns; journal-specific focus areas passed as scope context in spawn prompt — no new agent file needed.
- **`entry_count ≤ items_generated` rule dropped:** Today's run (32 entries → 31 items) revealed the inequality is wrong when drops+merges outnumber splits. Check now only enforces `items_generated == count of ## Items lines`.
- **Catch-up gate run on already-generated report:** Recommended and approved over skipping to archive. Proved the gate produces useful findings (12 risk-class flags missed in original generation).
- **F4 (clarify.md) and F8 (background-agent pattern) kept:** Operator overrides.

### Next Steps
- Push today's commits + 17 older unpushed commits (operator manual step)
- Run `/friday-act` on `audits/friday-journal-2026-05-08.md` (31 items, 12 with `**Risk-check required:**`)
- Review improvement spec open questions before promoting to implementation plan
- Fix pre-existing dirty state: `M .claude/commands/clarify.md`, `M logs/session-plan.md`, 8 untracked risk-check files

### Open Questions
- /friday-act doesn't yet read `**Risk-check required:**` bullets — follow-up to integrate the contract on the /friday-act side

## 2026-05-08 — /friday-act on audits/friday-journal-2026-05-08.md


## 2026-05-08 — Diagnose and fix early auto-compact on 1M sessions

### Summary
Investigated premature auto-compact firing in Claude Code. User reported compaction triggering at ~25% context fill on 1M sessions. Confirmed the 1M window is active (not the silent-drop bug #50803); root cause is the early-trigger regression (#43989/#34332) where the internal threshold is calibrated to a 200k absolute count and ignores `autoCompactWindow`. Applied the `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` env-var fix to push the trigger to ~95% of the configured 950k window (~902k tokens).

### Files Created
None.

### Files Modified
- `~/.claude/settings.json` — added `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: "95"` to `env` block

### Decisions Made
- Set override to `95` (not `90` or `80`) — gives ~97k buffer before hard 1M wall, enough for compaction to complete; operator instructed to lower to `90` if compaction failures occur.

### Next Steps
- Restart Claude Code for the env-var to take effect (new sessions only).
- Monitor: run `/context` after next long session to confirm trigger moved.
- If still compacting early after restart: override is also being ignored → escalate (check Claude Code changelog for 2.1.132 fix, or downgrade to 2.1.91 per #43989 workaround).

### Open Questions
- Whether v2.1.132 has a partial fix for #43989 that affects the override behavior — not confirmed.

## 2026-05-08 — Add unpushed-commits check to /friday-checkup

### Summary
User asked whether there's an existing check that surfaces uncommitted or unpushed commits during Friday cadence. Audit found the existing Cleanup-worktree tactical item (Step 6) covers dirty working trees but nothing detects commits that are committed but not yet pushed. Patched friday-checkup to add an "Unpushed commits" tactical follow-up that checks both `ai-resources/` and the workspace root using `git log @{u}..HEAD`.

### Files Created
None.

### Files Modified
- `ai-resources/.claude/commands/friday-checkup.md` — added Unpushed commits tactical follow-up after Cleanup-worktree (Step 6, line 288)

### Decisions Made
- Placed check in Step 6 (Compile Follow-Ups) to mirror Cleanup-worktree pattern rather than adding a new early-phase pre-flight scan — consistent shape, no new step needed.
- Covers both `ai-resources/` and workspace root (the Cleanup-worktree check only covers `ai-resources/`; extended scope because user's concern was repo-level sync, not just ai-resources).
- Risk tier: `med` (matches Cleanup-worktree).

### Next Steps
- Consider adding the same check to `/monday-prep` Phase A (currently runs `git status --short` but no unpushed check) — suggested but not requested this session.
- Push when ready.

### Open Questions
None.
