# Session Notes

> Archive: [session-notes-archive-2026-05.md](session-notes-archive-2026-05.md)

## 2026-05-16 — fix /prime Step 2 innovation-count grep (BSD grep BRE false positive)

### Summary
Single targeted fix to /prime Step 2. The innovation-count grep used `\|` escapes which BSD grep on macOS treats as BRE alternation, causing the pattern to match every pipe-starting table row (returning 98 instead of 0). Replaced with a column-scoped awk command that correctly checks the Status column value.

### Files Created
- None.

### Files Modified
- `.claude/commands/prime.md` — Step 2 innovation-count: replaced broken grep pattern with `awk -F'|' 'NR>2 && $5~/^ detected $/{c++}END{print c+0}'`

### Decisions Made
- None beyond the bug fix itself.

### Next Steps
- Push: 2 commits pending (`9ff8b05` session wrap, `d3c27ff` prime fix)
- Run `/friday-act` — friday-journal report is ready to consume

### Open Questions
- None.

## 2026-05-16 — /friday-checkup (weekly tier, off-schedule Saturday)

### Summary
Off-schedule Saturday run of `/friday-checkup` weekly tier across 5 scopes (ai-resources, workspace, interpersonal-communication, nordic-pe-macro-landscape-H1-2026, project-planning). Diagnostic-only per operator directive — no fixes applied. Top critical: nordic-pe-macro-landscape-H1-2026 references a missing `context/` directory in `produce-prose-draft.md` and `produce-architecture.md`. Permission-sweep returned 0 critical / 4 high / 1 medium; log-sweep flagged a single archive candidate (`usage-log.md` 652 lines). Coach run produced 3 fresh coaching-log entries (1 appended, 2 created from baseline). 22 tactical follow-ups consolidated for `/friday-act`.

### Files Created
- `audits/friday-checkup-2026-05-16.md` — consolidated weekly checkup report
- `audits/permission-sweep-2026-05-16.md` — dry-run report
- `audits/log-sweep-2026-05-16.md` — dry-run report
- `audits/repo-health-ai-resources-2026-05-16.md` — cadence snapshot
- `audits/repo-health-project-nordic-pe-macro-landscape-H1-2026-2026-05-16.md` — cadence snapshot
- `audits/working/permission-sweep-2026-05-16.md` + `.summary.md` — full notes + ≤30-line summary
- `audits/working/log-sweep-ai-resources-2026-05-16.md`
- `audits/working/log-sweep-project-interpersonal-communication-2026-05-16.md`
- `audits/working/log-sweep-project-nordic-pe-macro-landscape-H1-2026-2026-05-16.md`
- `audits/working/log-sweep-project-project-planning-2026-05-16.md`
- `projects/nordic-pe-macro-landscape-H1-2026/logs/coaching-log.md` — baseline coach entry
- `projects/project-planning/logs/coaching-log.md` — baseline coach entry

### Files Modified
- `ai-resources/logs/session-notes.md` — mandate line for this session + this wrap entry
- `ai-resources/logs/session-plan.md` — overwritten with friday-checkup plan
- `ai-resources/logs/coaching-log.md` — appended 2026-05-16 entry
- `ai-resources/reports/repo-health-report.md` — refreshed by `/audit-repo` (prior archived as `repo-health-report-2026-05-16.md`)
- `projects/nordic-pe-macro-landscape-H1-2026/reports/repo-health-report.md` — refreshed by `/audit-repo`

### Decisions Made
- **Diagnostic-only run.** No improvement-log findings applied; all 6 analyst findings were already logged from a prior session today (de-dup hit). Continued through Steps C–G without remediation. Rationale: operator stated "diagnostic only" early in the run.
- **Skip H-1 and M-1 permission-sweep findings.** Both recommend adding to deny list; conflicts with stored operator policy (`feedback_zero_permission_prompts`: never add to deny list; bypassPermissions floor is the agreed setup).
- **/coach run across 3 eligible scopes in parallel.** ai-resources, nordic-pe-macro, project-planning all met ≥5 sessions threshold; interpersonal-communication (4) and workspace (no session-notes) skipped.
- **Off-schedule Saturday run accepted as weekly tier.** /friday-checkup last ran 2026-05-08 (8 days ago, within the 10-day recovery window); operator overrode the off-schedule prompt with `weekly`.

### Next Steps
- Run `/friday-act` to triage the 22 tactical follow-ups in `audits/friday-checkup-2026-05-16.md` (1 critical, 6 high, 13 medium/low, 2 deferred-by-policy)
- Top-priority items for /friday-act: (1) resolve nordic-pe-macro missing `context/` directory; (2) push 6 unpushed ai-resources commits; (3) apply 4 HIGH permission-sweep fixes (gitignore + additionalDirectories); (4) run `/improve` against nordic-pe-macro session-plan hook overwrite (3 deferred occurrences); (5) run `/resolve-improvement-log` session against ai-resources logged-pending entries
- Optional: cleanup-worktree on workspace root (21 deletions of `projects/personal/*` accumulating)

### Open Questions
- None.

## 2026-05-16 — Prohibit model defaults workspace-wide (settings.json AND CLAUDE.md)

### Summary
Operator reported that declaring a model in settings.json or as a default in CLAUDE.md prevents in-session `/model` switches from taking effect. Extended the existing "no model in settings.json" rule (originally 2026-05-08) to also cover CLAUDE.md — model defaults are now prohibited at every config layer workspace-wide. The only permitted mechanism for declaring a tier outside the live session is per-command, per-agent, and per-skill `model:` YAML frontmatter. Removed all model defaults from settings + CLAUDE.md, updated repo documentation, rewrote the related memory note.

### Files Created
- None.

### Files Modified
- `.claude/settings.json` — removed `"model": "sonnet[1m]"` (workspace root)
- `projects/buy-side-service-plan/.claude/settings.local.json` — emptied to `{}`
- `projects/project-planning/.claude/settings.local.json` — emptied to `{}`
- `projects/obsidian-pe-kb/.claude/settings.local.json` — emptied to `{}`
- `projects/obsidian-pe-kb/.claude/settings.json` — removed `"model"` field
- `projects/interpersonal-communication/vault/.claude/settings.json` — removed `"model"` field
- `ai-resources/workflows/research-workflow/.claude/settings.json` — removed `"model"` field
- `ai-resources/skills/obsidian-kb-builder/templates/scaffold/settings.json` — removed `"model"` field (template; propagates to new vaults)
- `CLAUDE.md` — workspace-level § Model Tier rewritten with explicit prohibition + rationale; per-skill frontmatter added to permitted mechanisms
- `ai-resources/CLAUDE.md` — § Model Selection rewritten with prohibition pointer
- `projects/buy-side-service-plan/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/project-planning/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/obsidian-pe-kb/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/interpersonal-communication/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/global-macro-analysis/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/personal/travel-os/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `ai-resources/docs/permission-template.md` — removed `"model": "sonnet"` from canonical Layer C template; key-assertion flipped to "no `model` field" with rationale
- `ai-resources/docs/audit-discipline.md` — model-default audit recommendations must be rejected outright, not run through the discipline
- `ai-resources/docs/autonomy-rules.md` — Autonomy Rule #8 no longer lists model-default changes (prohibited outright, not gateable)
- `ai-resources/docs/onboarding-daniel.md` — "Set up your model tier" rewritten as "Select your session model" (per-session via `/model`)
- `ai-resources/docs/repo-architecture.md` — project directory map annotated "no default model — prohibited"
- `ai-resources/.claude/commands/deploy-workflow.md` — canonical-merge no longer adds `model: sonnet[1m]`; uses `del(.model)` to strip pre-existing model fields on deploy
- `~/.claude/projects/.../memory/feedback_no_model_in_settings_json.md` — rewritten to cover settings.json AND CLAUDE.md, clarifies per-command/agent/skill frontmatter remains permitted

### Decisions Made
- **Scope of prohibition.** Extended from settings.json-only (prior rule, 2026-05-08) to also cover CLAUDE.md, per operator directive. Rationale: same downstream effect — both layers block in-session `/model` switches.
- **Recommended-posture preserved in project CLAUDE.md.** Operator did not direct removal of the per-project Model Selection sections; rewrote them as recommendation-only ("lean Opus for plan drafting; Sonnet for routine edits") rather than deleting. This preserves project-specific tier guidance without asserting a default.
- **Skills added to permitted mechanisms** (operator correction mid-session: "Yes, and its also allowed for skills"). Initial draft only mentioned commands + agents; expanded to commands + agents + skills across workspace CLAUDE.md, ai-resources CLAUDE.md, and the memory note.
- **deploy-workflow merge procedure now strips a pre-existing `model` field** via `del(.model)` rather than just not setting one. Catches drift from older deploys that ran the previous merge logic.

### Next Steps
- Push the upcoming commit (operator approval required).
- Verify `/model` switches work as expected in the next session start.
- Optional `/friday-act` candidate: scan archived/historical audit files for stale "add canonical model baseline" recommendations and tag them as superseded.

### Open Questions
- None.

### End-time risk-check
Skipped. Change scope was operator-directed end-to-end with a mid-session correction (skills added to permitted mechanisms) already incorporated. Touched classes: cross-cutting CLAUDE.md edits, settings edits, one shared command edit (`deploy-workflow.md`). All changes are reversible config/doc edits; no hook execution paths, no permission allow/deny shifts, no symlinks. Operator directive was explicit and tightly scoped. Coaching + telemetry both declined in preflight.

## 2026-05-16 — Innovation sweep: 6 projects, 7 graduate candidates identified

### Summary
Ran a full innovation triage sweep across 6 selected projects (axcion-ai-system-owner had 0 local resources and was skipped; 5 projects active). Used /clarify and /scope to structure the request before entering plan mode, then spawned 5 parallel `innovation-triage-auditor` subagents. Classified 101 items total and produced a consolidated triage report with 7 graduate candidates, 8 loose ends, 40 already-graduated, and 46 keep-local verdicts. Key finding: nordic-pe's 17 "local" commands turned out to be byte-identical research-workflow deploys — the upstream inventory had missed the `ai-resources/workflows/research-workflow/` path. Updated the innovation registry with 23 new entries.

### Files Created
- `audits/innovation-sweep-2026-05-16.md` — consolidated triage report with graduate candidates, loose ends, verdict summary table
- `audits/working/innovation-sweep-2026-05-16/global-macro-analysis/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/interpersonal-communication/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/nordic-pe-macro-landscape-H1-2026/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/obsidian-pe-kb/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/repo-documentation/notes.md` — per-project working notes (gitignored)

### Files Modified
- `logs/innovation-registry.md` — 23 new entries appended (7 graduate, 8 loose-end, 8 keep-local/already-graduated)

### Decisions Made
- **Project selection:** Operator selected projects 1 (axcion-ai-system-owner), 4 (global-macro-analysis), 5 (interpersonal-communication), 7 (nordic-pe-macro-landscape-H1-2026), 8 (obsidian-pe-kb), 10 (repo-documentation)
- **Verdict bar:** "anything that looks generalizable" (operator-directed, not usage-proven)
- **Scope:** Triage only — no actual graduation executed this session
- **Implementation:** Consolidated into one report (not per-project); parallel subagents rather than sequential /innovation-sweep skill invocations

### Next Steps
- Graduate G1 (SessionStart upward-walk pattern) → `ai-resources/docs/permission-template.md`: run `/graduate-resource` or edit permission-template.md directly
- Graduate G2 (deny-archive permissions shape) → same target
- Graduate G3–G5 (decision-logger, checkpoint-nag, five-hook taxonomy) → workflow-level settings reference
- Graduate G6 (compaction "trust the summary" rule) → `ai-resources/docs/compaction-protocol.md`
- **Fix LE4 (urgent):** Delete or repoint broken symlink `obsidian-pe-kb/.claude/commands/resolve-improvements.md` → `resolve-improvement-log.md`
- **Fix LE5 (urgent):** Remove `model` field from `obsidian-pe-kb/.claude/settings.json`
- Decide on loose ends LE1–LE3, LE6–LE8 (today-drill, auto-commit policy, friction-log-trigger, compaction scratchpad)

### Open Questions
- LE3 (auto-commit hook): conflicts with workspace Commit Rules — intentional exception or remove?
- LE2 (CLAUDE.md §Autonomy Rules from nordic-pe): graduate to workspace docs or keep project-local?

### End-time risk-check
Skipped — session touched no structural change classes (no hooks, no permission changes, no CLAUDE.md edits, no commands/skills/symlinks). Files produced were audit outputs and a registry log append only.

## 2026-05-16 — /friday-act: weekly checkup triage, 7 plan files (28 fix-now items)
Class: execution

### Summary
Ran /friday-act against the 2026-05-16 weekly checkup report. Disposititioned 46 items across three sources (17 checkup, 14 innovation-sweep, 15 friday-journal) into 28 fix-now and 18 deferred. Used /recommend to self-determine all dispositions after operator expanded scope to include the innovation-sweep report. Generated 7 plan files grouped by area. QC pass (qc-reviewer) returned REVISE verdict; 3 fixes applied before commit.

### Files Created
- `audits/friday-plans/2026-05-16-nordic-pe-macro.md` — 4 items: context/ restore decision, SKILL.md frontmatter, CLAUDE.md pipeline-frontmatter note, /improve run
- `audits/friday-plans/2026-05-16-permission-sweep.md` — 3 items: gitignore fixes (H-2/H-3), additionalDirectories (H-4), form-normalization advisories
- `audits/friday-plans/2026-05-16-ai-resources-maintenance.md` — 6 items: git push, /resolve-improvement-log, cleanup-worktree ×2, hardcoded path fix, usage-log archive
- `audits/friday-plans/2026-05-16-permission-template.md` — 3 items: G1 SessionStart upward-walk, G2 deny-archive pattern, G5 PostToolUse taxonomy doc
- `audits/friday-plans/2026-05-16-innovation.md` — 4 items: G6 compaction cost-test rule, LE4 broken symlink fix, LE5 model field removal, registry update
- `audits/friday-plans/2026-05-16-journal-improvements.md` — 5 items: SessionStart hook chain, /new-project canonical commands, CLAUDE.md decision-point posture, /friday-act required-reads expansion, /audit-repo vs /repo-dd investigation
- `audits/friday-plans/2026-05-16-friday-journal.md` — 3 items: QC sub-agent (vague/duplicate detection), drop-check step, risk-check auto-flagging step

### Files Modified
- `logs/maintenance-observations.md` — 2026-05-16 Friday Act session block appended (28 fix-now, 18 defer, 7 plan files, all-hold autonomy axes)

### Decisions Made
- **Disposition strategy (/recommend):** Self-dispositioned all 46 items; 28 fix-now across 7 plan files, 18 deferred, 0 skipped. Autonomy-axis all hold; operator observations defaulted to (none).
- **Innovation-sweep scope expansion:** Operator requested inclusion of `audits/innovation-sweep-2026-05-16.md` findings alongside checkup and journal sources. Items labeled as source: innovation-sweep in maintenance-observations; plan files use `journal-derived` tag per /friday-act spec (only three allowed source values).
- **Journal items retroactively dispositioned:** 15 friday-journal items were inadvertently dropped when the innovation-sweep was merged into the disposition prompt. Self-added dispositions via /recommend; 2 extra plan files written (journal-improvements, friday-journal).
- **QC fixes applied (REVISE verdict):** (1) permission-template.md Item 1 — risk-check flag corrected from "no" to "yes — change class: settings.json/hooks" (cross-project hook updates are in-class even though the doc edit is not); (2) journal-improvements.md Item 4 — added execution-note caveat re shared-state-automation boundary; (3) friday-journal.md Items 1–3 — same caveat added.

### Next Steps
- Push: `git push` — 9 unpushed commits in ai-resources (8 prior sessions + this wrap commit)
- Execute plan files in follow-up sessions — priority order:
  1. `nordic-pe-macro` (CRITICAL: missing context/ directory)
  2. `permission-sweep` (HIGH: gitignore + additionalDirectories)
  3. `ai-resources-maintenance` (git push + resolve-improvement-log + cleanup)
  4. `permission-template`, `innovation`, `journal-improvements`, `friday-journal` (in any order)
- Each plan file is one follow-up session; run /risk-check for items flagged "yes" before executing those items

### Open Questions
- None.

## 2026-05-16 — /friday-act implementation: Tier 1 + Tier 2 (13 items)
Class: execution
**Mandate:** Execute Tier 1 + Tier 2 items from the 7 friday-plans/2026-05-16-*.md files (13 items: 7 quick wins + 6 risk-check-required mechanical fixes) — done when: all 13 items completed and committed; push completed for the unpushed-commits item.
- Out of scope: Tier 3 heavy design items (nordic-pe-macro #1/#3/#4, both /cleanup-worktree runs, all 5 journal-improvements items, all 3 friday-journal command-spec edits)
- Files in scope: audits/friday-plans/2026-05-16-*.md (read-only); projects/{nordic-pe-macro-landscape-H1-2026,global-macro-analysis,obsidian-pe-kb,project-planning}/.gitignore; projects/{nordic-pe-landscape-mapping-4-26,interpersonal-communication}/.claude/settings.json; projects/obsidian-pe-kb/.claude/{commands/resolve-improvements.md (symlink),settings.json}; ai-resources/.claude/settings.json; ai-resources/docs/{permission-template.md,compaction-protocol.md}; ai-resources/logs/innovation-registry.md; projects/nordic-pe-macro-landscape-H1-2026/reference/skills/knowledge-file-producer/SKILL.md; whatever /log-sweep touches; ai-resources/logs/session-notes.md (wrap)
- Stop if: scope drift into Tier 3 without operator approval; risk-check returns RECONSIDER on any item; push fails or remote state diverges

## 2026-05-16 — /friday-act implementation: Tier 1 + Tier 2 execution

### Summary
Executed Tier 1 (7 items) and Tier 2 (scope-reduced to 4 actual edits after pre-validation) from the 7 friday-plans/2026-05-16-*.md plan files. Pre-validation revealed significant stale state in the plan: several Tier 2 items were already done (additionalDirectories, model field removal, NotebookEdit normalization, upward-walk pattern) or moot (nordic-pe-landscape-mapping-4-26 no longer exists). Tier 1 similarly found G5/G6 and registry entries already applied by prior sessions. Real work completed: 12-commit push, 4 .gitignore additions, G2 Read-deny doc edit, SKILL.md frontmatter, ADV-1/ADV-7 settings normalizations, LE4 broken symlink fix, G1 auto-sync hook doc, T2-5 audit-finding rejection. End-time risk-check skipped per policy (plan-time GO, no drift).

### Files Created
- `audits/risk-checks/2026-05-16-tier-2-reduced-batch-4-mechanical-edits.md` — plan-time risk-check report for Tier 2 reduced batch (GO, all dimensions Low)

### Files Modified
- `logs/session-notes.md` — mandate header + this wrap entry
- `logs/session-plan.md` — session plan (Tier 1 + Tier 2 execution, Gated posture)
- `logs/decisions.md` — T2-5 rejection decision entry
- `logs/coaching-data.md` — coaching entry for this session
- `docs/permission-template.md` — G2 Read-deny Layer D assertion; G1 auto-sync-shared.sh canonical hook block; T2-5 Layer C hardcoded-paths canonical note
- `.gitignore` — ADV-7: added `.claude/settings.local.json` entry

In workspace root repo:
- `.claude/settings.json` — ADV-1: `Bash(git push *)` → `Bash(git push*)` (remove space)

In project repos (committed separately, each has its own repo):
- `projects/nordic-pe-macro-landscape-H1-2026/.gitignore` — added `.claude/settings.local.json`
- `projects/nordic-pe-macro-landscape-H1-2026/reference/skills/knowledge-file-producer/SKILL.md` — added `model: opus` + `effort: high` frontmatter
- `projects/global-macro-analysis/.gitignore` — added `.claude/settings.local.json` (created new file)
- `projects/obsidian-pe-kb/.gitignore` — added `.claude/settings.local.json`
- `projects/obsidian-pe-kb/.claude/commands/resolve-improvement-log.md` — new symlink replacing broken `resolve-improvements.md`
- `projects/project-planning/.gitignore` — new file with `.claude/settings.local.json`

### Decisions Made
- **T2-5 (hardcoded paths in Layer C settings.json):** Rejected audit finding. Paths `Edit(/Users/.../...)` and `Write(/Users/.../...)` are canonical Layer C entries from permission-template.md. Claude Code permission matching is literal; env-var replacement would break permission grants. Documented in decisions.md 2026-05-16 + inline note added to permission-template.md. Future audit runs re-flagging this should be dismissed using the decision entry as precedent.
- **End-time risk-check skipped:** plan-time GO covered exact same 4 mechanical edits; no drift; no mitigations needed; per `feedback_end_time_risk_check_skip` policy.
- **T1-2 usage-log.md archive deferred:** log-archiver.sh date-guard fires because the file's first header is today. Execute on next session day.

### Next Steps
- Push all repos (operator approval): ai-resources (4 new commits), workspace root (1), nordic-pe-macro (2), global-macro-analysis (1), obsidian-pe-kb (2), project-planning (1)
- T1-2: re-run `/log-sweep` without `--dry-run` on a future day when today is no longer the first header in `logs/usage-log.md`
- Tier 3 items still deferred: nordic-pe-macro #1 (restore vs retire context/ decision), #3 (CLAUDE.md pipeline-frontmatter note, needs risk-check), #4 (/improve session-plan hook overwrite); workspace /cleanup-worktree (21 deleted personal/* files); journal-improvements #1–5; friday-journal #1–3

### Open Questions
- None.

## 2026-05-16 — Tier 3 friday-act execution: journal-improvements (5) + friday-journal (3)
Class: execution
**Mandate:** Execute 8 Tier 3 items from `audits/friday-plans/2026-05-16-journal-improvements.md` and `audits/friday-plans/2026-05-16-friday-journal.md` in 4 sequenced waves — done when: all 8 items committed or explicitly deferred (with reason).
- Out of scope: Other Tier 3 items (nordic-pe-macro #1/#3/#4, ai-resources-maintenance #3/#4 cleanup-worktrees); any item escalated to RECONSIDER by `/risk-check`
- Files in scope: `ai-resources/.claude/commands/{friday-journal.md, friday-act.md, new-project.md, session-start.md, session-plan.md}`; `ai-resources/audits/repo-audit-commands-recommendation-2026-05-16.md` (new); workspace root `CLAUDE.md` (§Decision-Point Posture); `.claude/settings.json` (SessionStart hook)
- Stop if: `/risk-check` RECONSIDER on any item → defer that item, continue rest; context exhaustion before Wave 4 → commit Waves 1–3 and defer journal-improvements #1+#2; ≥30 turns without natural break → checkpoint and wrap

### Summary
Executed 7 of 8 Tier 3 items in 4 sequenced waves; deferred 1 of 8 (Wave 4 #1) per risk-check verdict + session-plan stop point. Used inline `/risk-check` for both Wave 3 and Wave 4 in-class changes — both shipped items received plan-time GO. The deferred item (SessionStart hook chain) returned PROCEED-WITH-CAUTION with 6 required mitigations including paired doc updates to 4 other files; risk-check report committed as the deferred-item record. End-time `/risk-check` skipped per saved-memory rule ([feedback_end_time_risk_check_skip]) since both shipped in-class items had plan-time GO with no drift. Friday-journal trio (Wave 2 #1–#3) was batched in one commit since all three modify the same command file and share the pre-Step-6 gate region; pre-batching re-evaluation confirmed no risk-check class crossed.

### Files Created
- `audits/repo-audit-commands-recommendation-2026-05-16.md` — synthesis recommending keep-both-with-role-split for /audit-repo and /repo-dd (Wave 1 #5)
- `audits/risk-checks/2026-05-16-strengthen-workspace-claude-md-decision-point-posture.md` — plan-time risk-check report (Wave 3, GO)
- `audits/risk-checks/2026-05-16-new-project-decisions-scaffold-and-command-verification.md` — plan-time risk-check report (Wave 4 #2, GO)
- `audits/risk-checks/2026-05-16-session-start-auto-chain.md` — plan-time risk-check report (Wave 4 #1, PROCEED-WITH-CAUTION, item deferred)

### Files Modified
- `.claude/commands/friday-act.md` — Step 1.5 + 16a expansion: project-internal logs locator, targeted SO-section reads, token-cost notes (Wave 1 #4)
- `.claude/commands/friday-journal.md` — Step 5.5 focus-area expansion (vagueness + duplicate-merge), new Step 5.6 (drop-check), new Step 5.7 (deterministic risk-class scan); producer-side flag now authoritative, consumer-side gap documented as follow-up (Wave 2 #1+#2+#3)
- `../CLAUDE.md` (workspace root) — §Decision-Point Posture strengthened with explicit anti-pattern wording ("do not ask 'what do you recommend'") and trust-downstream-/qc-pass-and-/refinement-pass language (Wave 3 #3)
- `.claude/commands/new-project.md` — Post-Pipeline Enrichment additions: Step 4a (logs/decisions.md scaffold), Step 5a (canonical command verification safety-net); Report section updated (Wave 4 #2)

### Decisions Made
- **Implementation approach for SessionStart hook chain (Wave 4 #1):** identified that Claude Code hooks (shell scripts on lifecycle events) cannot directly invoke slash commands; proposed command-spec-only implementation (no settings.json hook entry) for risk-check evaluation. Risk-check returned PROCEED-WITH-CAUTION with 6 mitigations including paired doc updates to prime.md, session-rituals.md, weekly-session-guide.md, operator-maintenance-cadence.md, and reconciliation with qc-independence.md. Item deferred per session-plan stop point ("if target file diverges materially from plan-file spec: pause and reassess").
- **friday-journal trio batching:** All three plan items (#1+#2+#3) modify the same command file (`friday-journal.md`) and share the pre-Step-6 gate region. Batched into one commit (9648278) rather than three. Pre-batch risk-check re-evaluation confirmed no class crossed (subagent focus-area expansion + deterministic checks + single-session report annotations — no hooks, settings, CLAUDE.md, symlinks, or cross-session writes).
- **#4 risk-classification reconciliation during QC fix:** Initial session-plan listed journal-improvements #4 as "no structural class"; QC review caught the source-plan caveat ("re-evaluate at execution time"). Plan revised to restate the caveat. At execution time, re-evaluated: edit adds read-only project log paths and section-targeted parsing; no new automation, no shared-state writes. No `/risk-check` needed.
- **Producer-consumer gap documented as known follow-up:** friday-journal Item context Risk-check bullet does not currently propagate to /friday-act plan files (consumer sub-step 15a re-derives risk-class from directive text only, not from upstream Item context). Documented in friday-journal.md Notes section; not fixed this session.
- **End-time `/risk-check` skipped per saved memory rule:** Both shipped in-class items (Wave 3 + Wave 4 #2) had plan-time GO verdicts. Commits already shipped, drift bounded, no mitigations to track. Documented per `feedback_end_time_risk_check_skip`.

### Next Steps
- Push: 10 unpushed commits in ai-resources (6 from this session + 4 prior) + 2 unpushed in workspace. Operator approval required (Autonomy Rule #2).
- Wave 4 #1 deferred — schedule a dedicated design session for SessionStart hook chain. Required scope: address all 6 mitigations from the risk-check report (`audits/risk-checks/2026-05-16-session-start-auto-chain.md`), draft paired doc updates to prime.md + session-rituals.md + weekly-session-guide.md + operator-maintenance-cadence.md, reconcile auto-chain with `docs/qc-independence.md`, decide opt-in vs opt-out semantics.
- Tier 3 items still deferred from prior session: nordic-pe-macro #1 (restore vs retire context/ decision), #3 (CLAUDE.md pipeline-frontmatter note, risk-check), #4 (/improve session-plan hook overwrite); ai-resources-maintenance #3 (/cleanup-worktree ai-resources) + #4 (/cleanup-worktree workspace root).
- Pending producer-consumer gap follow-up: extend `/friday-act` sub-step 15a to read upstream `**Risk-check required:**` bullet from journal-derived items' Item context blocks (currently re-derives from directive text only).

### Open Questions
- None.

## 2026-05-16 — Improvement-log execution sprint: 6 friction fixes
Class: execution

### Summary
Executed 6 of 8 improvement-log items targeting recurring friction patterns across the session infrastructure. Each item followed read → edit → /qc-pass (GO) → commit. Item #6 (workspace CLAUDE.md + friday-act.md) required a two-gate /risk-check: plan-time PROCEED-WITH-CAUTION with 3 mitigations applied, end-time GO (all dimensions Low after mitigations). The session plan itself went through two /qc-pass + revision cycles before execution started. QC reviewer flagged a stale Notes line (friday-act.md line 416 still says "first 30 lines") as a follow-up.

### Files Created
- `audits/risk-checks/2026-05-16-item-6-read-scope-floors-workspace-claude-md-and-friday-act.md` — plan-time risk-check report (PROCEED-WITH-CAUTION, 3 mitigations)
- `audits/risk-checks/2026-05-16-end-time-gate-item-6-read-scope-floors-claude-md.md` — end-time risk-check report (GO, all dimensions Low)

### Files Modified
- `.claude/commands/prime.md` — Step 1a: git log cross-check flags stale Next Steps; sibling same-day entry sweep warning; top-of-file principle added (recurrence-fix #3)
- `.claude/commands/session-start.md` — Step 2: explicit confirmation tokens (confirm/y/yes), one-time re-ask for ambiguous single letters, colon-required correction syntax
- `.claude/commands/session-plan.md` — Step 7 template: added Findings/Items to Address, Execution Sequence, Scope Alternatives sections; precondition + self-check for sparse plans
- `.claude/commands/monday-prep.md` — C15: replaced inline /session-plan invocation with scaffold write (logs/session-plan-next.md stub)
- `docs/weekly-cadence.md` — step 15 updated; Scope separation paragraph added
- `.claude/commands/consult.md` — Step 0 Read-first gate; reservation note added
- `.claude/commands/friday-act.md` — Step 16a: explicit floor-not-ceiling note with claim-making trigger example
- `logs/session-notes.md` — this entry
- `logs/session-plan.md` — session plan for this session

In workspace root repo (separate commit):
- `CLAUDE.md` — Read-scope floors bullet added to Working Principles

### Decisions Made
- **Plan-time risk-check mitigations (item #6):** CLAUDE.md bullet kept to ≤30 tokens; placed under Working Principles (not Design Judgment Principles); trigger named explicitly ("when a downstream claim depends on content past the read window"); friday-so.md dropped (pattern not present per grep)
- **QC fix — plan (round 1):** Added friday-so.md conditional trigger spec; named docs/weekly-cadence.md source content; corrected QC sequencing to pre-commit; clarified item #6 ships as one commit
- **QC fix — plan (round 2):** Normalized file paths in table; added batch-sizing justification; fixed two-gate risk-check structure (plan-time gate before execution, not just end-time)
- **prime.md --all flag:** Advisory note added in commit message — drop `--all` if false positives appear on repos with active feature branches
- **⚠ → WARNING:** Replaced non-ASCII symbol in prime.md Step 1a per no-emojis CLAUDE.md rule

### Next Steps
- Push all repos (operator approval): ai-resources (6 new commits), workspace root (1)
- Update improvement-log: mark 6 applied items with `Status: applied 2026-05-16` + `Verified:` lines
- Run `/resolve-improvement-log` once verified (8 logged/pending → 6 applied items ready to archive)
- Follow-up: friday-act.md Notes line 416 staleness — "displays the first 30 lines" contradicts current Step 16a section-targeted reads; log as improvement-log entry

### Open Questions
- None.

## 2026-05-16 — Harness roadmap orientation + A1 fixes

### Summary
Oriented the harness project from scratch: clarified the Phase 0–8 build structure, located the master project plan (project-plan-v2.md), and produced a Notion-ready session roadmap at `harness/prep/harness-roadmap.md` covering Track A (data collection prerequisites) and Track B (the build) in full. Executed Session A1 fixes — found 7 of 8 already applied in prior sessions, applied the remaining Fix 2b (session-mandate-template.md "not parsed" label was wrong; session-start.md already captures all 5 mandate fields). Confirmed A2–A6 data collection sessions are redundant given months of existing session data. Project is now ready for A7 Part 2 (Phase 2 re-activation) which gates Track B.

### Files Created
- `harness/prep/harness-roadmap.md` — Track A/B session roadmap; Track A detailed, Track B milestone table

### Files Modified
- `harness/prep/session-mandate-template.md` — Fix 2b: corrected "not parsed" label; all 5 fields now in one block with accurate defaults note
- `harness/prep/harness-roadmap.md` — A1 marked complete, Decision 1 resolved, current focus updated to A2–A6 (then immediately noted as redundant)

### Decisions Made
- **A2–A6 data collection skipped:** Months of existing friction logs, improvement logs, coaching data, and session notes provide equivalent signal. The 5-session minimum was designed for a fresh install. No additional structured sessions needed before Track B.
- **Fix 3 (wrap-session sub-bullet read) deferred:** LOW impact; wrap-session has evolved significantly since the fix plan was written; the spirit of the fix is no longer a clear improvement. Logged as a potential future enhancement only.

### Next Steps
- **A7 Part 2 — Phase 2 re-activation (~1h):** Re-enable SessionStart hook in `.claude/settings.json` (disabled at commit 178b293); clean stale crash state in `harness/session/` (startup-state.json, mandate.json, session-log.json — prep-components-fix-plan Group C3); validate Phase 2 sufficiency criteria against test workflow (simulated crash, recovery summary, mandate-history.jsonl entry).
- After A7 Part 2: proceed to Track B, Session B1–B2 (Phase 3 — Governor skeleton).

### Open Questions
- None.
