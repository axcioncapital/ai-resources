# Risk Check — 2026-05-27

## Change

FX-B4 — END-TIME GATE for canonical `quality-standards.md` extension (80 → 194 lines). Batched with FX-B3 + FX-B5 + FX-B6 sibling template files in the same `ai-resources/workflows/research-workflow/reference/` directory.

Plan-time gate verdict was PROCEED-WITH-CAUTION (`ai-resources/audits/risk-checks/2026-05-27-fx-b4-extend-canonical-quality-standards.md`). System-owner second opinion concurred and added M-6/M-7/M-8/M-9 plus a canonical-ordering rule. This end-time gate evaluates whether the executed change actually applied all 9 mitigations, and what residual risk remains pre-commit.

Executed set (all in `ai-resources/workflows/research-workflow/reference/`):
1. `quality-standards.md` extended 80 → 194 lines (target was 150–180; over by 14L).
2. `source-class-hierarchy.template.md` — NEW (106L; FX-B3).
3. `known-limits.template.md` — NEW (83L; FX-B3).
4. `claim-permission.template.md` — NEW (71L; FX-B5).
5. `jargon-gloss-config.template.md` — NEW (79L; FX-B6).

## Referenced files

- `ai-resources/workflows/research-workflow/reference/quality-standards.md` — exists (194 lines, verified)
- `ai-resources/workflows/research-workflow/reference/source-class-hierarchy.template.md` — exists (106 lines, verified)
- `ai-resources/workflows/research-workflow/reference/known-limits.template.md` — exists (83 lines, verified)
- `ai-resources/workflows/research-workflow/reference/claim-permission.template.md` — exists (71 lines, verified)
- `ai-resources/workflows/research-workflow/reference/jargon-gloss-config.template.md` — exists (79 lines, verified)
- `ai-resources/audits/risk-checks/2026-05-27-fx-b4-extend-canonical-quality-standards.md` — exists (plan-time report + /consult)
- `ai-resources/skills/claim-permission-gate/SKILL.md` — exists (consumer, unchanged)
- `ai-resources/skills/cluster-memo-refiner/SKILL.md` — exists (consumer, unchanged)
- `ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md` — exists (consumer, unchanged)

## Verdict

GO

**Summary:** All 9 plan-time mitigations applied; two-end heading-string contract verified verbatim against the three named fail-closed consumers; project-leakage scan clean; M-9 concurrent-session risk did not materialize. Residual risk is Low-Medium across dimensions and is fully covered by the documented mitigations. No High dimension survives the end-time scan.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The five files are load-on-demand reference docs — not always-loaded. Plan-time finding (Dimension 1) re-confirmed: `workflows/research-workflow/CLAUDE.md` line 57 names `quality-standards.md` as load-on-demand. Same disposition for the four templates (templates are read only at project deployment / fill time).
- Token cost from 80→194 (~114 lines added) is paid only by sessions that already read this file at their stage; no new always-loaded surface introduced.
- No new hooks, no new auto-loaded skills, no skill-description-pattern widening.
- No `@import` chain introduced — grep across `workflows/research-workflow/CLAUDE.md` shows no canonical import of `quality-standards.md`.

### Dimension 2: Permissions Surface
**Risk:** Low

- Five-file edit/create inside `ai-resources/workflows/research-workflow/reference/`. No `.claude/settings.json` or `.claude/settings.local.json` change.
- No new tool invocation pattern (Bash command, Write path, external API).
- No `allow` / `ask` / `deny` rule touched. No scope escalation.

### Dimension 3: Blast Radius
**Risk:** Medium (down from plan-time High)

- Plan-time enumeration of consumers (12+ skills/commands) was correct. End-time verification of the two-end heading-string contract:
  - `grep` for the six canonical heading strings (`## Claim-Permission Classes`, `### Source-Diversity Matrix`, `## No-Source-Substitution Rule`, `## Country Coverage Table`, `## Research Stop Conditions`, `## Source-Conflict Resolution Procedure`) returned **41 consumer-side reference hits** across `ai-resources/skills/` and `ai-resources/workflows/research-workflow/.claude/commands/`. Every cited form in those 41 hits matches the chassis exactly. No consumer references a heading the chassis omits.
  - Three fail-closed consumers verified specifically:
    - `skills/claim-permission-gate/SKILL.md` lines 49, 50, 57, 70, 146, 158, 191 cite `## Claim-Permission Classes` and `## Source-Diversity Matrix` — both present in chassis at line 114 and 135.
    - `skills/cluster-memo-refiner/SKILL.md` lines 197, 222, 228, 234, 252 cite `§ Country Coverage Table` (chassis line 90), `§ Claim-Permission Classes` (chassis line 114, with the embedded "Blocking-Gate" subsection at 147), and `§ Source-Conflict Resolution Procedure` (chassis line 180).
    - `commands/run-sufficiency.md` lines 27, 28 cite `## Claim-Permission Classes` and `## Source-Diversity Matrix` — both present.
- Risk reduced from High to Medium because the two-end contract has been verified verbatim; the remaining Medium reflects the structural breadth (>5 consumers, fail-closed parser surface) which the verification cannot eliminate, only confirm at this moment in time.
- **Line-number discrepancy noted (non-blocking).** The CHANGE_DESCRIPTION cited chassis heading positions at lines 85/103/127/148/180/193; actual chassis positions are 72/90/114/135/167/180. The heading **strings** match consumer expectations exactly; only the line-number annotations in the CHANGE_DESCRIPTION are off. Consumers parse by heading string, not line number, so this does not affect the contract — but it does indicate the CHANGE_DESCRIPTION's self-verification was approximate.

### Dimension 4: Reversibility
**Risk:** Low

- Five-file change inside a single ai-resources directory. Single `git revert` of one commit restores prior state cleanly.
- Templates are net-new files; revert deletes them with no orphan state. `quality-standards.md` revert restores the 80-line state.
- No data file mutation (no log append, no decisions.md write). No external write. No automation that could fire between commit and a hypothetical revert.
- M-9 satisfaction confirmed (see Dimension 5): WU4a left no working-tree changes, so concurrent-session merge-conflict surface is empty. Revert path stays single-commit.

### Dimension 5: Hidden Coupling
**Risk:** Low (down from plan-time Medium)

- **M-7 — chassis-status pointer (replaces deferred-additions warning).** Chassis line 3 reads `> **Chassis status.** Source-pipeline chassis landed FX-B4 (2026-05-27). Deferred items pending: S-08, S-09, S-14, S-15, S-17, S-18 — see project's v6 Post-R2 Review Trigger for the activation timing of these items.` This preserves the controlled-debt signal the original callout carried — future readers know which items are deferred and where to look for activation timing. Adequate.
- **M-8 — tunable-vs-immutable boundary declaration.** Chassis lines 5–7 explicitly enumerate (a) project-tunable fields with placeholder names, and (b) canonical-immutable items: four permission-class names, permitted-prose-verb lists, six structural section headings (verbatim string-listed), gate-clearance artifact schema. Explicit and load-bearing. The 30%/40% thresholds at chassis lines 151–152 are also marked "(project-tunable; default 30%)" / "(project-tunable; default 40%)" inline, mirroring M-8 at the use site.
- **Canonical-ordering rule (first-time enforcement).** Declared in **both** files:
  - Chassis line 116: "This chassis is the source of truth for permission-class names, the permitted-prose-verb lists, and gate semantics. Per-claim-type evidence thresholds (the project-fillable table) live in `reference/claim-permission.md` (derived from `claim-permission.template.md`). Future edits that cross this boundary in either direction require `/risk-check` re-fire."
  - Template `claim-permission.template.md` line 5: mirror statement naming the chassis as source-of-truth for class names + verb lists + gate semantics; the template as source-of-truth for per-claim-type evidence thresholds only.
  - Cross-file consistency verified. Sufficient for first-time enforcement — boundary is visible at both ends of the contract, both files cite each other.
- **Verb-list verbatim mirroring (M-3, M-4 plan-time, M-6 system-owner).** Chassis lines 124–127 contain the four-class table with verb lists in the exact form consumers expect: `shows / confirms / establishes / demonstrates / records` (SUPPORTED), `suggests / is consistent with / points to / indicates` (PROXY-SUPPORTED), `illustrates / shows in one named case / appears in` (ILLUSTRATIVE-ONLY), `(may not state)` (NOT-SUPPORTED). The `evidence-to-report-writer` / `chapter-prose-reviewer` exact-match enforcement target (chassis line 129) is also present verbatim.
- **Project-leakage post-write scan.** Grep across all five files for `Sweden|Norway|Finland|Nordic|KPMG|EY|Argentum|PitchBook|Mergermarket|Preqin|€2|H1 2025|Axcion`. One literal hit: `source-class-hierarchy.template.md` line 12, inside an HTML comment listing example licensed databases — `"Mixed sources — public + named licensed databases (e.g., Mergermarket, S&P Capital IQ)."`. This is an enumerated example of a posture option, not project-specific content. Acceptable. No other project-token leakage. CHANGE_DESCRIPTION's claim of "All five files clean" is substantively correct (the "cision" false-positives noted in CHANGE_DESCRIPTION are also confirmed false-positives — substrings inside "decisions").
- **M-9 — concurrent-session sequencing.** ai-resources working-tree state at scan time:
  - Modified: `logs/session-notes.md`, `workflows/research-workflow/reference/quality-standards.md` (the FX-B4 edit itself).
  - Untracked: the four new template files, the plan-time risk-check report, `logs/inbox-triage-2026-05-27.md`.
  - No WU4a-scoped files (`produce-prose-draft.md`, `produce-formatting.md`, `produce-jargon-gloss.md`, `research-prompt-creator/SKILL.md`, `language-search-blocks.template.md`) appear in modified or untracked. No WU4a commit in recent `ai-resources/` history (`git log -10 --oneline` on `workflows/research-workflow/reference/` shows the most recent commit is `eaad408 new: Bundle 2a` from a prior session; no WU4a commits since). M-9's concurrent-rewrite risk did not materialize. Staging-by-name discipline can proceed safely.

## Mitigations

(Verdict is GO. Mitigation section is omitted per report-format rule. The 9 plan-time mitigations have already been applied and verified above.)

## Side observations (non-blocking, advisory only)

- **14-line overage on the 150–180 line target.** Justified by the system-owner additions (M-7 chassis-status pointer at line 3; M-8 tunable-vs-immutable block at lines 5–7; canonical-ordering rule at line 116; verb-list enforcement statement at line 129). Each addition is load-bearing for one of the mitigations the system-owner second opinion required. Trimming to hit 180L would mean dropping mitigation content — not advisable. Accept the overage.
- **Line-number annotations in CHANGE_DESCRIPTION's "Mitigation-application verification" block are inaccurate** (cited 85/103/127/148/180/193 vs. actual 72/90/114/135/167/180). Strings match exactly; only line-number annotations drift. Suggest the operator update the FX-B4 commit-message body (or session-notes entry) to cite the actual line numbers rather than the values from the CHANGE_DESCRIPTION — minor hygiene only, not a contract issue.
- **First-time canonical-ordering rule.** This is the first cross-file boundary of its kind in the workflow reference set. The boundary is visible at both ends (chassis line 116 + template line 5), which is the minimum bar. As future workflow consumers arrive, this pattern will be tested — recommend the operator note "canonical-ordering rule introduced FX-B4" in `system-doc.md` (or equivalent) so future maintainers know when this pattern was established.

## Evidence-Grounding Note

All risk levels grounded in direct evidence — full read of all five files (533 lines total verified), consumer parser-surface grep verified verbatim against 41 hits across `skills/` + `workflows/research-workflow/.claude/commands/`, working-tree-state grep for M-9, project-leakage grep across all five files. The plan-time risk-check report was also read in full (188 lines including /consult appendix). No training-data fallback used.
