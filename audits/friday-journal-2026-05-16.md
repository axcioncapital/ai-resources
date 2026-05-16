---
report_date: 2026-05-16
type: friday-journal
source: ai-resources/logs/ai-journal.md
entry_count: 15
items_generated: 15
---

# /friday-journal report — 2026-05-16

## Summary

This week's journal centres on three themes: session-start automation (hook chain that runs /session-plan → /qc-pass → /scope after mandate confirmation), Friday-cadence robustness (/friday-journal needs QC + refinement + drop-check + risk-check; /friday-act input scope is too narrow; /resolve-improvement-log not wired in), and operator autonomy (strengthen CLAUDE.md decision-point posture so Claude picks at gates instead of asking "what do you recommend"). Two pipeline fixes (/new-project missing commands + decisions.md, /repo-dd missing ai-resources comparison) and three smaller investigations round out the list. Calibration note: latest /friday-checkup is from 2026-05-08 (8 days old), still within the 10-day calibration window.

## Items

[high] Add a SessionStart hook chain that captures mandate, waits for operator confirmation, then auto-invokes /session-plan → /qc-pass on the plan → /scope.
[high] Fix /new-project to install all current canonical commands (session-start, session-plan, others) plus a decisions.md template in newly-created projects.
[high] Update CLAUDE.md decision-point posture so Claude picks and proceeds at gates instead of asking "what do you recommend".
[high] Expand /friday-act required-reads to include full SO files, Systems Review Leverage Points, improvement-logs, and project session-notes/friction-logs.
[med] Add a default QC subagent pass to the research-plan-creator skill.
[med] Investigate /audit-repo vs /repo-dd overlap and produce a written merge/delete/keep recommendation.
[med] Add a /repo-dd step that compares CLAUDE.md and file structure between the audited project and ai-resources as the source of truth.
[med] Add auto-QC of the /friday-act execution plan with the systems agent before presenting it to operator.
[med] Add a QC sub-agent pass to /friday-journal that flags vague items and combines duplicates.
[med] Add a refinement pass to /friday-journal that enriches entries with context from repo-documentation.
[med] Add a drop-check step to /friday-journal that verifies no original journal content was silently dropped.
[med] Wire /resolve-improvement-log into /friday-act so improvement-log entries are touched as part of execution flow.
[low] Audit /systems-review to confirm it reviews the repo as a whole and surfaces systems-thinking improvement ideas.
[low] Add a risk-check step to /friday-journal that flags items carrying implementation risk.
[low] Investigate whether coaching logs are linked into /friday-checkup and wire them in if not.

## Item context

### Add a SessionStart hook chain that captures mandate, waits for operator confirmation, then auto-invokes /session-plan → /qc-pass on the plan → /scope.
- **Files:** `.claude/settings.json` (SessionStart hook), `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/session-plan.md`
- **Effort:** medium
- **Recommended approach:** Add SessionStart hook that calls /session-start (captures mandate, prompts operator). On operator confirmation, hook chain auto-invokes /session-plan → /qc-pass on the resulting session-plan.md → /scope. Operator types nothing after the initial mandate confirmation. Risk-check required (shared-state automation + new hook).
- **Source entry:** Hook to session start — at session start, capture mandate and wait for operator confirmation. Once confirmed, auto-invoke /session-plan. When /session-plan completes, auto-invoke /qc-pass on the session plan output, then auto-invoke /scope. No operator prompting needed at any step after mandate confirmation.

### Fix /new-project to install all current canonical commands (session-start, session-plan, others) plus a decisions.md template in newly-created projects.
- **Files:** `ai-resources/.claude/commands/new-project.md`, `ai-resources/agents/pipeline-stage-*.md`, project-template scaffolding
- **Effort:** medium
- **Recommended approach:** Audit the /new-project pipeline (Stage 3a–5) for the symlink/copy step that installs commands into new projects. Add missing commands (session-start, session-plan, open-items, others) to the canonical install list. Also add `logs/decisions.md` scaffold to the project template.
- **Risk-check required:** Yes (matches shared-state automation — affects every newly created project — per audit-discipline.md). /friday-act must run /risk-check before landing this fix.
- **Source entry:** Fix new-project pipeline — two issues: (1) new commands (e.g., session-start, session-plan) are not appearing in newly created projects; fix the pipeline to include all current canonical commands. (2) New projects don't get a decisions.md by default — add it to the project template.

### Update CLAUDE.md decision-point posture so Claude picks and proceeds at gates instead of asking "what do you recommend".
- **Files:** `CLAUDE.md` (workspace root, Decision-Point Posture section), `ai-resources/CLAUDE.md`
- **Effort:** low
- **Recommended approach:** The Decision-Point Posture section already exists in workspace CLAUDE.md. Strengthen the wording: explicitly state Claude should make recommendations and proceed automatically, never seek operator confirmation on the recommendation itself, and trust that downstream /qc-pass + /refinement-pass will catch issues. Add an explicit "do not ask 'what do you recommend' or equivalent" anti-pattern line. Risk-check required (cross-cutting CLAUDE.md edit).
- **Source entry:** Strengthen decision-point posture — Claude stops too often at gates asking "what do you recommend" when the operator already trusts its judgment. Update CLAUDE.md (or equivalent) to explicitly allow Claude to make decisions freely at gates, pick a recommendation and proceed, and only surface decisions that are genuinely novel or high-risk. QC passes catch problems; operator will flag exceptions if something looks wrong.

### Expand /friday-act required-reads to include full SO files, Systems Review Leverage Points, improvement-logs, and project session-notes/friction-logs.
- **Files:** `ai-resources/.claude/commands/friday-act.md` (Step 1.5)
- **Effort:** low
- **Recommended approach:** Update /friday-act Step 1.5 input-reads spec. Replace SO 30-line peek with full-read for the Recommendations and Observations sections. Add full-read for Systems Review Leverage Points. Add improvement-log files for scoped projects. Add Loop 2 (project session-notes + friction-logs) as required reads. Note token cost in spec but justify it: ~5 minutes of read cost saves ~3 rounds of operator-driven correction on heavy Fridays.
- **Source entry:** Fix /friday-act input scope — the spec's minimum read is insufficient on heavy-disposition Fridays. Missing sources: SO Recommendations + Observations (always past line 30), Systems Review Leverage Points (always past line 30), improvement-log files, and project-internal session-notes/friction-logs. Fix: expand the spec's required reads to include these sources.

### Add a default QC subagent pass to the research-plan-creator skill.
- **Files:** `ai-resources/skills/research-plan-creator/SKILL.md`
- **Effort:** low
- **Recommended approach:** research-plan-creator is a skill, not a command. Investigate why it has no QC subagent by default. Add a validation gate step that spawns qc-reviewer with research-plan-specific focus areas (gap coverage, source plausibility, scope creep). Mirror the /friday-journal Step 5.5 contract.
- **Source entry:** Add QC pass to research-plan-creator — the command currently has no QC subagent by default. Investigate why and add a QC pass as a standard step.

### Investigate /audit-repo vs /repo-dd overlap and produce a written merge/delete/keep recommendation.
- **Files:** `ai-resources/.claude/commands/audit-repo.md`, `ai-resources/.claude/commands/repo-dd.md`, output to `ai-resources/audits/` (recommendation report)
- **Effort:** medium
- **Recommended approach:** Read both command specs end-to-end. Compare scope, output shape, subagent dispatch, and typical invocation context. Produce a written recommendation in `ai-resources/audits/repo-audit-commands-recommendation-2026-05-16.md` covering: keep both (with clear role separation), merge into one, or deprecate one. Include migration plan if recommending merge/delete.
- **Source entry:** Audit-repo vs repo-dd — both commands exist; investigate overlap and produce a written recommendation on whether to merge, delete one, or keep both with clearly distinct roles.

### Add a /repo-dd step that compares CLAUDE.md and file structure between the audited project and ai-resources as the source of truth.
- **Files:** `ai-resources/.claude/commands/repo-dd.md`, `ai-resources/agents/repo-dd-auditor.md`
- **Effort:** medium
- **Recommended approach:** Add a new step (likely between current Step 4 and Step 5) that diffs CLAUDE.md content + `.claude/` directory structure between audited project and canonical ai-resources. Output drift items as findings (e.g., "missing autonomy section", "outdated permission template"). Treat ai-resources as authoritative — drift always implies project is stale, not the other way around.
- **Source entry:** Fix repo-dd — add a step that compares CLAUDE.md and file structure between the project being audited and ai-resources. Treat ai-resources as the authoritative, always-most-up-to-date reference.

### Add auto-QC of the /friday-act execution plan with the systems agent before presenting it to operator.
- **Files:** `ai-resources/.claude/commands/friday-act.md` (post-plan step)
- **Effort:** low
- **Recommended approach:** After /friday-act generates its execution plan (typically Step 4 or equivalent), insert an auto-QC step that delegates to the axcion-ai-system-owner agent (or qc-reviewer with systems-thinking focus). Surface findings before operator approves the plan. Use the same disposition loop pattern as /friday-journal Step 5.5.
- **Source entry:** Improve /friday-act — after generating the execution plan, auto-QC it with the systems agent before presenting to operator.

### Add a QC sub-agent pass to /friday-journal that flags vague items and combines duplicates.
- **Files:** `ai-resources/.claude/commands/friday-journal.md` (Step 5.5 extension)
- **Effort:** low
- **Recommended approach:** Extend the existing Step 5.5 qc-reviewer handoff to include two new focus areas: (a) vague-content detection — flag items with "TBD", "investigate", or undefined scope; (b) duplicate-merge detection — flag items that overlap significantly and propose merge directives. Approach for clarification: agent asks operator clarifying questions OR searches repo-documentation for answers before flagging.
- **Source entry:** Fix /friday-journal (QC sub-agent pass) — after the initial report is written, run a QC sub-agent pass that highlights vague or unclear content and combines items that should be merged. Approach: either ask the operator clarifying questions or search repo-documentation for answers.

### Add a refinement pass to /friday-journal that enriches entries with context from repo-documentation.
- **Files:** `ai-resources/.claude/commands/friday-journal.md` (new Step 5.6 or similar)
- **Effort:** medium
- **Recommended approach:** Insert a second refinement pass after the QC pass. Spawn a subagent that reads the report's Items + Item context, then searches repo-documentation (vault/, docs/, CLAUDE.md files) for relevant context to enrich each entry. Update the Item context "Recommended approach" field with pulled context. Cap at 1 enrichment pass per item to avoid runaway token cost.
- **Source entry:** Fix /friday-journal (refinement pass from repo-docs) — run a second refinement pass where Claude adds relevant context from repo-documentation to enrich entries before finalising.

### Add a drop-check step to /friday-journal that verifies no original journal content was silently dropped.
- **Files:** `ai-resources/.claude/commands/friday-journal.md` (new step before Step 6)
- **Effort:** low
- **Recommended approach:** After QC + refinement passes, run a deterministic check comparing the original parsed entries (preserved verbatim per Step 1.6) against the final Items + Item context Source-entry fields. Any entry not represented in the final report is flagged. Operator dispositions each drop (intentional / restore).
- **Source entry:** Fix /friday-journal (drop-check) — after QC and refinement, verify that nothing from the original notes was silently dropped. Flag any missing items explicitly.

### Wire /resolve-improvement-log into /friday-act so improvement-log entries are touched as part of execution flow.
- **Files:** `ai-resources/.claude/commands/friday-act.md`, `ai-resources/.claude/commands/resolve-improvement-log.md`
- **Effort:** low
- **Recommended approach:** Add a step to /friday-act that invokes /resolve-improvement-log after the main disposition loop. Either as a Step 4 sub-step or as a final cleanup pass. Goal: improvement-log entries don't stagnate — they get archived or actioned in the same Friday session that creates new follow-ups.
- **Source entry:** Link /resolve-improvement-log to /friday-act — currently not connected. Connect them so /friday-act triggers or references /resolve-improvement-log as part of its execution flow.

### Audit /systems-review to confirm it reviews the repo as a whole and surfaces systems-thinking improvement ideas.
- **Files:** `ai-resources/.claude/commands/systems-review.md` (or equivalent)
- **Effort:** low
- **Recommended approach:** Read the /systems-review command spec end-to-end. Verify: (a) does it scan the whole repo, or just specific files? (b) does it produce systems-thinking improvement ideas, or just review existing work? Output a one-page assessment to `ai-resources/audits/` and propose specific scope refinements if the answer to either question is "no".
- **Source entry:** Improve /systems-review — investigate whether the command actually reviews the repo as a whole and surfaces systems-thinking improvement ideas. Clarify its scope and improve if not.

### Add a risk-check step to /friday-journal that flags items carrying implementation risk.
- **Files:** `ai-resources/.claude/commands/friday-journal.md` (new step in Step 5.5 or after)
- **Effort:** low
- **Recommended approach:** Add a deterministic risk-check after QC. Cross-reference each Item against `docs/audit-discipline.md` Risk-check change classes (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands, new symlinks, shared-state automation). Items matching a class get a `**Risk-check required:**` bullet in Item context automatically. (Note: Step 5.5 already supports manual `f` disposition for this; this item is about making it automatic.)
- **Source entry:** Fix /friday-journal (risk-check) — run a risk-check on the final report; flag anything that carries implementation risk or shouldn't be there.

### Investigate whether coaching logs are linked into /friday-checkup and wire them in if not.
- **Files:** `ai-resources/.claude/commands/friday-checkup.md`, `ai-resources/.claude/commands/coach.md`, coaching-log.md files in each scope
- **Effort:** low
- **Recommended approach:** Read /friday-checkup spec. Confirm it invokes /coach (which writes coaching-log.md). If already wired (likely is per checkup 2026-05-08 which shows /coach ran), document the wiring explicitly. If not wired, add /coach to the cadence loop alongside /improve. Output a one-line confirmation to chat — this is mostly a verification task.
- **Source entry:** Add coaching logs to Friday cadences — check whether coaching logs are already linked to /friday-checkup. If not, wire them in.
