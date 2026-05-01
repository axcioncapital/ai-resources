---
model: sonnet
---

# /friday-checkup — Weekly Maintenance Cadence

Run a tiered Friday maintenance cadence against `ai-resources/`, the workspace root, and operator-selected active projects. Produces a single consolidated review-only report under `ai-resources/audits/`. No auto-fix; findings direct next week's work.

Input: `$ARGUMENTS` (optional) — `weekly` | `monthly` | `quarterly` to override auto-detected tier.

---

### Step 0: Skipped-Friday Recovery

0. Locate the most recent existing checkup report:
   ```bash
   ls -1 "{AI_RESOURCES}/audits/friday-checkup-"*.md 2>/dev/null | sort | tail -1
   ```
   - If no report exists (first run ever), skip this step and continue to Step 1.
   - Extract `LAST_DATE` from the filename (the `YYYY-MM-DD` between `friday-checkup-` and `.md`).
   - Compute days elapsed with Python: `from datetime import date; print((date.today() - date.fromisoformat('LAST_DATE')).days)`.
   - If `DAYS ≤ 10`, skip this step and continue to Step 1.

   If `DAYS > 10`, ask:
   ```
   Last /friday-checkup was {DAYS} days ago (last: {LAST_DATE}).
   Skipped-Friday recovery options:
     (a) Run now as a recovery Friday — execute the normal tier sequence today.
     (b) Skip today — defer until next scheduled Friday.
   ```
   - On `a`: continue to Step 1 (normal execution).
   - On `b`: print `"Deferred. Run /friday-checkup on the next scheduled Friday."` and stop.

---

### Step 1: Detect Tier

1. Compute date fields with Bash:
   ```bash
   TODAY=$(date +%Y-%m-%d)
   DOW=$(date +%u)        # 5 = Friday
   DAY=$(date +%d)
   MONTH=$(date +%m)
   ```
2. Determine the auto-detected tier:
   - **quarterly** = `DOW=5` AND `DAY ≤ 7` AND `MONTH ∈ {01,04,07,10}`
   - **monthly** = `DOW=5` AND `DAY ≤ 7`
   - **weekly** = `DOW=5`
   - **off-schedule** = any other day
3. If `$ARGUMENTS` is `weekly`, `monthly`, or `quarterly`, set `TIER` to that override. Otherwise use the auto-detected tier.
4. If off-schedule and no override, ask the operator: "Today is not a Friday. Run `/friday-checkup` anyway? (y/n, or specify `weekly`|`monthly`|`quarterly`)". Wait for response before proceeding.

---

### Step 2: Confirm Tier and Checks

5. Display the tier plus the auto-run checks that tier will perform:
   ```
   Tier: {TIER}  ({auto-detected | operator-override})

   Auto-run checks:
     Weekly:  /audit-repo, /improve, /coach (if ≥5 sessions), /permission-sweep --dry-run
     Monthly: + /audit-claude-md, /token-audit
     Quarterly: (same auto-run as monthly)

   {If TIER=quarterly:}
   Follow-up checklist (surfaced in report, NOT auto-run):
     /repo-dd deep per scope
     /analyze-workflow per workflow under workflows/
   ```
6. Ask: "Proceed with this tier? (y / n / `weekly` / `monthly` / `quarterly`)". Wait for reply. Treat `y` as confirm; a tier name re-sets `TIER`.

---

### Step 3: Scope Selection

7. Enumerate project directories under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/`:
   ```bash
   ls -1d /Users/patrik.lindeberg/Claude\ Code/Axcion\ AI\ Repo/projects/*/ 2>/dev/null
   ```
   Store as ordered list.
8. Present numbered menu:
   ```
   Scopes:
     1. ai-resources           (always — cannot be deselected)
     2. workspace root         (workspace CLAUDE.md audit only)
     3a. {project-name-1}
     3b. {project-name-2}
     ...
   ```
9. Ask: "Select active projects (comma-separated letters like `3a,3c`, or `none`, or `all`):". Parse the reply into `ACTIVE_PROJECTS`.
10. Build `ACTIVE_SCOPES` as a list of `(scope_label, scope_slug, scope_path, is_project)` tuples:
    - `("ai-resources", "ai-resources", "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources", false)`
    - `("workspace", "workspace", "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo", false)`
    - For each selected project: `("project {name}", "project-{name}", "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/{name}", true)`

---

### Step 4: Runtime Estimate

11. Compute rough runtime estimate using these per-check ceilings:
    - `/audit-repo` = 1 min per scope (ai-resources + active projects; skip workspace)
    - `/improve` = 5 min per scope
    - `/coach` = 15 min per scope (skipped ones count 0)
    - `/permission-sweep --dry-run` = 2 min per scope (ai-resources + workspace + active projects)
    - `/audit-claude-md` = 10 min per scope (workspace + active projects)
    - `/token-audit` = 30 min per scope (ai-resources + workspace + active projects)
12. Display the estimate: `"Estimated runtime: ~{N} min"`.
13. If estimate > 45 min, require the operator to type the exact phrase `proceed with long run` before continuing. Any other response aborts.

---

### Step 5: Run Auto-Run Checks

Run the checks below in sequence (not in parallel — avoid context contention). For each sub-command invocation: use the Skill tool with the slash-command name and the argument shown. Between scopes, `cd` to the scope's path first. After each check, record the produced report path(s) in a running `RESULTS` list.

Skip any scope that cannot support a check (e.g. `/audit-repo` on workspace root — no repo-health-analyzer skill deployed there). Note the skip with reason in `RESULTS`.

**A. `/audit-repo` — all tiers, per scope (skip workspace)**

For each scope where `is_project=true` OR `scope_label="ai-resources"`:
1. `cd "{scope_path}"`
2. Verify `reference/skills/repo-health-analyzer/agents/` OR `skills/repo-health-analyzer/agents/` exists. If neither, record `skipped: repo-health-analyzer not deployed` and continue.
3. Invoke `/audit-repo`.
4. After completion, copy the per-scope report to a dated cadence snapshot:
   ```bash
   cp "{scope_path}/reports/repo-health-report.md" "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/repo-health-{scope_slug}-{TODAY}.md"
   ```
5. Record both paths in `RESULTS`.

**B. `/improve` — all tiers, per scope**

For each scope:
1. `cd "{scope_path}"`
2. If `logs/improvement-log.md` does not exist, record `skipped: no improvement-log.md` and continue.
3. Invoke `/improve`. The command reads `logs/friction-log.md`, appends new entries to `logs/improvement-log.md`. Entries land in the scope's own logs, not `ai-resources/logs/`.
4. Record the appended count (best-effort, from `/improve`'s own output) and the log path in `RESULTS`.

**C. `/coach` — all tiers, per scope (skip if thin)**

For each scope:
1. `cd "{scope_path}"`
2. If `logs/session-notes.md` does not exist, record `skipped: no session-notes.md` and continue.
3. Count wrapped sessions with Bash: `grep -c "^## " "{scope_path}/logs/session-notes.md"`. If count < 5, record `skipped: insufficient session volume ({N}/5)` and continue.
4. Invoke `/coach`.
5. Record the produced coaching-log append in `RESULTS`.

**D. `/audit-claude-md` — monthly and quarterly only**

Skip entirely if `TIER=weekly`.

For each scope:
1. ai-resources → not applicable (no standalone ai-resources CLAUDE.md audit; `workspace` arg covers the workspace CLAUDE.md, and ai-resources' own CLAUDE.md is audited there). Record `skipped: covered by workspace scope` and continue.
2. workspace → invoke `/audit-claude-md workspace`.
3. project {name} → invoke `/audit-claude-md project {name}`.

Record the produced audit report path in `RESULTS`.

**E. `/token-audit` — monthly and quarterly only**

Skip entirely if `TIER=weekly`.

For each scope:
1. ai-resources → invoke `/token-audit ai-resources`.
2. workspace → invoke `/token-audit workspace`.
3. project {name} → invoke `/token-audit project {name}`.

Record the produced audit report path in `RESULTS`.

**F. `/permission-sweep --dry-run` — all tiers, once per checkup run**

Permission-sweep scans every settings file in the workspace in one pass — it is **not** per-scope. Invoke it exactly once regardless of how many scopes are selected.

1. `cd "{WORKSPACE_ROOT}"` (the workspace root, not a scope path).
2. Verify `ai-resources/.claude/agents/permission-sweep-auditor.md` exists. If missing, record `skipped: permission-sweep-auditor not deployed` and continue.
3. Invoke `/permission-sweep --dry-run`.
4. The command writes the consolidated dry-run report to `ai-resources/audits/permission-sweep-{TODAY}.md` (same dated path regardless of scope).
5. Record the report path in `RESULTS` under a synthetic scope label `permission-sweep (workspace-wide)`.

**G. W2.1 — `doc-scanner-agent` (repo-documentation only) — monthly and quarterly only**

Skip entirely if `TIER=weekly`. Skip if scope `project repo-documentation` is not selected.

This step invokes the W2.1 component-registry drift scanner. It is project-local to repo-documentation; it does not run for other scopes.

1. Verify `projects/repo-documentation/.claude/agents/doc-scanner-agent.md` exists. If missing, record `skipped: doc-scanner-agent not deployed` and continue.
2. Spawn the agent via Agent tool, agent name `doc-scanner-agent`, with brief: "Scan live Axcion AI repo for component drift against the Phase 1 archived registry. Workspace root: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. Project root: `projects/repo-documentation/`. Today: `{TODAY}`. Produce drift report at `projects/repo-documentation/output/phase-2/w2-1-doc-scan-{TODAY}.md`."
3. After completion, record the report path in `RESULTS` under scope label `repo-documentation:w2-1-doc-scan`.

**H. W2.2 — `principles-checker-agent` (repo-documentation only) — monthly and quarterly only**

Skip entirely if `TIER=weekly`. Skip if scope `project repo-documentation` is not selected.

1. Verify `projects/repo-documentation/.claude/agents/principles-checker-agent.md` exists. If missing, record `skipped: principles-checker-agent not deployed` and continue.
2. Spawn the agent via Agent tool, agent name `principles-checker-agent`, with brief: "Scan live Axcion AI repo for violations of DR-1, DR-3, QS-6. Workspace root: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. Today: `{TODAY}`. Produce violations report at `projects/repo-documentation/output/phase-2/w2-2-principles-{TODAY}.md`. Skip DR-4 (deprecated)."
3. After completion, record the report path in `RESULTS` under scope label `repo-documentation:w2-2-principles`.

**I. W2.3 — Maintenance consolidator (repo-documentation only) — monthly and quarterly only**

Skip entirely if `TIER=weekly`. Skip if scope `project repo-documentation` is not selected. Runs AFTER §G (W2.1) so the drift report exists; runs after §J (W2.4 improvement-analyst) is irrelevant — independent.

This is an orchestration step (no separate agent — D-7). It consolidates the §G drift report and (post-W2.5 vault deployment) `/kb-integrity` output into a single maintenance summary.

1. Read the §G W2.1 drift report at `projects/repo-documentation/output/phase-2/w2-1-doc-scan-{TODAY}.md`. If missing (§G skipped or failed), record `skipped: w2-1 prerequisite missing` and continue.
2. Determine vault state: check whether `projects/repo-documentation/vault/CLAUDE.md` exists. If yes (vault deployed):
   a. Invoke `/kb-integrity` from `projects/repo-documentation/vault/`. The command writes `_integrity-report-{TODAY}.md` to vault root (gitignored content).
   b. Read the produced integrity report.
3. Compose a consolidated maintenance summary at `projects/repo-documentation/output/phase-2/w2-3-maintenance-{TODAY}.md` with sections:
   - **Drift since last scan** — copied from §G drift report (Added/Removed/Modified counts and one-line per finding).
   - **Integrity violations** — copied from `/kb-integrity` report if available; otherwise note `vault not yet deployed; integrity check skipped`.
   - **Recommended actions** — operator-facing list combining both: registry pastes (from §G), drift investigations, integrity fixes.
4. Record the consolidated report path in `RESULTS` under scope label `repo-documentation:w2-3-maintenance`.

**J. W2.4 — `improvement-analyst` (Phase 2 cadence-driven catch-up) — monthly and quarterly only**

Skip entirely if `TIER=weekly`. The weekly tier already runs `/improve` per scope at §B. This step is the Phase 2 monthly+ catch-up: it ensures Phase 2 friction-log + improvement-log analysis runs regardless of whether the operator invoked `/improve` mid-week.

1. Verify `ai-resources/.claude/agents/improvement-analyst.md` exists (canonical agent — should always be present).
2. Verify `ai-resources/logs/friction-log.md` exists (the Phase 2 input). If missing, record `skipped: no friction-log` and continue.
3. Spawn the agent via Agent tool, agent name `improvement-analyst`, with brief: "Analyze friction patterns and propose improvements. Read: `ai-resources/logs/friction-log.md`, `ai-resources/logs/improvement-log.md`, and (if present) `ai-resources/logs/improvement-log-archive.md`. Project context: `projects/repo-documentation/`. Output findings as markdown. Up to 7 findings, ranked by impact-to-effort ratio."
4. Capture the agent's findings output and write to `projects/repo-documentation/output/phase-2/w2-4-improvements-{TODAY}.md` with a frontmatter header:

   ```markdown
   ---
   title: "W2.4 Improvement Analysis — {TODAY}"
   date_created: {TODAY}
   scan_type: w2-4
   status: report
   phase: phase-2
   ---

   # W2.4 Improvement Analysis — {TODAY}

   {agent findings inline}

   ## Operator notes

   - Run `/friday-act` to triage findings. For each finding the operator approves: dispatch to `system-developer-agent` to draft an implementation proposal in `output/phase-2/w2-4-proposals/{TODAY}-{slug}.md`. Operator reviews the proposal before any live-file edit.
   ```

5. Record the report path in `RESULTS` under scope label `repo-documentation:w2-4-improvements`.

**K. Projects-layer refresh (repo-documentation only) — monthly and quarterly only**

Skip entirely if `TIER=weekly`. Skip if scope `project repo-documentation` is not selected.

This step refreshes the work-layer documentation: `projects.md` (project registry) and `repo-state.md` (current state snapshot).

1. For each project under `projects/`:
   a. Read the first 40 lines of the project's `CLAUDE.md` (extracts Purpose, Phase, Model, Status).
   b. Read the last 20 lines of the project's `logs/session-notes.md` (if it exists) to extract the most recent open threads and pending steps.
2. Update `projects/repo-documentation/output/phase-1/components/projects.md`: for each project H4 entry, update the `Status`, `Phase`, and optional prose if the project state has changed materially. Do not add or remove entries — that requires operator approval.
3. Update `projects/repo-documentation/output/phase-1/repo-state.md`:
   - §1 Active projects: update Phase, last session date, in-flight work, and open threads per project.
   - §2 Pending manual steps: append any new pending steps found in session notes; mark completed steps as resolved (remove or annotate `resolved: {date}`).
   - §4 Push state: note last known push date if determinable from git log.
4. Update the `last_updated` frontmatter field in both files to `{TODAY}`.
5. Update the vault equivalents at `projects/repo-documentation/vault/projects/projects.md` and `projects/repo-documentation/vault/architecture/repo-state.md` with the same changes (same content, vault-adapted format — wiki-links instead of relative markdown links).
6. Record paths of modified files in `RESULTS` under scope label `repo-documentation:projects-refresh`.

---

### Step 6: Compile Follow-Ups

14. Check follow-up triggers and assemble three tier-differentiated sections.

    **Tactical follow-ups (all tiers).** Per-item shape: `[ ] {item} — risk: {low | med | high}`. Risk derivation:
    - Sub-report severity `CRITICAL` → `high`
    - Sub-report severity `HIGH` → `high`
    - Sub-report severity `MEDIUM` → `med`
    - Anything else (advisory, info) → `low`
    - Hand-coded items below: `med` unless an upstream signal raises them.
    - W2.1 doc-scan Added entry → `[ ] Paste new entry into output/phase-1/components/{category}.md and review for Status: active — risk: low`
    - W2.1 doc-scan Removed entry → `[ ] Investigate removed component {name}; if intentional deletion, mark Status: deprecated — risk: med`
    - W2.1 doc-scan Modified entry → `[ ] Update registry field for {name} per drift report — risk: low`
    - W2.2 principle violation severity `error` → `[ ] Fix DR/QS violation at {path} — risk: high`
    - W2.2 principle violation severity `warn` → `[ ] Review possible violation at {path}; confirm legitimate or fix — risk: med`
    - W2.3 maintenance: registry-vault drift detected → `[ ] Run /kb-update {category} to align vault with operator-approved registry pastes — risk: low`
    - W2.4 improvement finding (any) → `[ ] Triage at /friday-act; if approved, dispatch to system-developer-agent — risk: med`

    Standard tactical items:
    - **Resolve-improvements:** in `ai-resources/logs/improvement-log.md`, count entries that have both `**Status:** applied` and `**Verified:**` lines. If count ≥ 5, add `` `/resolve-improvement-log` — {N} resolved entries pending archive `` (risk: `low`).
    - **Cleanup-worktree:** run `git status --short` in `ai-resources/`. If non-empty, count modified vs untracked lines and add `` `/cleanup-worktree` — working tree dirty (M modified, U untracked) `` (risk: `med`).
    - **Quarterly follow-ups:** if `TIER=quarterly`, add one item per scope for `/repo-dd deep` (risk: `low`), and one item per directory under `workflows/` for `/analyze-workflow` (risk: `low`).

    **Policy-level observations (monthly + quarterly).** Skip if `TIER=weekly`. Sources:
    - `/audit-claude-md` reports: any finding tagged as a rule-level recommendation (suggests adding/removing/rewording a CLAUDE.md rule rather than a single file fix).
    - `/token-audit` reports: any finding that recommends a workspace- or project-wide policy change (default-model tier, frontmatter convention, hook-firing pattern, agent-tier table revision).
    - Recurrence signals: if any tactical item appears in both this checkup AND the prior `audits/friday-checkup-*.md` (search backward by filename date, comparing item text), flag as `[recurring]` — recurrence is the canonical trigger for policy-level review.

    Surface up to 5 observations. If none qualify, write `(none flagged this cycle)`.

    **Architectural retrospective (quarterly only).** Skip if `TIER ∈ {weekly, monthly}`. Populate with:
    - Standard substrate questions (always present): "What's the repo drifting toward?" / "What's accumulating without a forcing function to remove it?" / "Which boundary felt fuzziest this quarter?"
    - Quarterly follow-up references already added to Tactical (`/repo-dd deep`, `/analyze-workflow`) — repeat their paths here so the retrospective section is self-contained for `/friday-act`'s quarterly review.
    - Auto-detect substrate-drift signals: count of `audits/risk-checks/*.md` files this quarter; count of new `.claude/commands/*.md` files this quarter (`git log --since="3 months ago" --name-only -- ai-resources/.claude/commands/`). Surface counts as one-liners; the operator interprets in `/friday-act`.

---

### Step 7: Write Consolidated Report

15. Write the consolidated report to `ai-resources/audits/friday-checkup-{TODAY}.md`. Structure:

    ```
    # Friday Checkup — {TODAY}

    ## Tier
    {TIER} ({auto-detected | operator-override})

    ## Scopes audited
    - {scope_label for each ACTIVE_SCOPES entry}

    ## Prioritized findings (rolled up across all scopes)
    1. [CRITICAL] …
    2. [HIGH] …
    3. [MEDIUM] …
    (Extract HIGH/CRITICAL findings from each sub-report read in Step 5.
     If a sub-report has no findings, note "clean" for that check.)

    ## Per-scope summary
    ### {scope_label}
    - /audit-repo: {summary} → {snapshot path OR skipped reason}
    - /improve: {N appended | skipped} → {log path}
    - /coach: {ran ({N} sessions) | skipped: insufficient session volume ({N}/5) | skipped: no session-notes.md}
    - /audit-claude-md (monthly): {summary} → {path OR skipped reason}
    - /token-audit (monthly): {summary} → {path}

    ## Tactical follow-ups
    - [ ] {item} — risk: {low | med | high}
    (One bullet per Step 6 tactical item. Always present.)

    ## Policy-level observations
    - {observation} — {source: /audit-claude-md | /token-audit | recurring | …}
    (Monthly and quarterly only. Omit the heading if TIER=weekly. If TIER ∈ {monthly, quarterly} but no observations qualify, write the heading followed by "(none flagged this cycle)".)

    ## Architectural retrospective
    - Substrate questions:
      - What's the repo drifting toward?
      - What's accumulating without a forcing function to remove it?
      - Which boundary felt fuzziest this quarter?
    - Quarter-over-quarter signals:
      - /risk-check reports filed this quarter: {N}
      - New commands added this quarter: {N}
    - Quarterly follow-ups (also listed under Tactical):
      - /repo-dd deep — {scope_label}
      - /analyze-workflow — {workflow_path}
    (Quarterly only. Omit the heading entirely if TIER ∈ {weekly, monthly}.)

    ## All reports generated
    - {every path recorded in RESULTS}
    ```

    **Section presence by tier (data contract for `/friday-act`):**
    - `weekly` → Tactical follow-ups only (Policy-level and Architectural retrospective omitted).
    - `monthly` → Tactical + Policy-level (Architectural retrospective omitted).
    - `quarterly` → Tactical + Policy-level + Architectural retrospective.

    `/friday-act` parses these section headings verbatim. Do not rename them.

16. To extract findings: Read each sub-report produced in Step 5 (the snapshot audit-repo files, the audit-claude-md reports, the token-audit reports, the permission-sweep report). For each, look for sections titled `HIGH`, `CRITICAL`, `Top findings`, or the report's executive summary. Pull headline items; do not re-evaluate severity. If a report uses numeric scoring (e.g. repo-health RED/YELLOW/GREEN), surface RED findings only. For the permission-sweep dry-run, surface all CRITICAL findings (the primary signal of live permission-prompt issues) and HIGH findings in aggregate (e.g., "5 HIGH gaps across 3 projects — see report").

---

### Step 8: Summary and Exit

17. Print to operator:
    ```
    Friday checkup complete.

    Tier: {TIER}
    Scopes: {scope_labels joined by comma}
    Auto-run checks: {completed count} / {attempted count}  ({N} skipped: reasons listed in report)
    Follow-ups flagged: {count}

    Consolidated report:
      ai-resources/audits/friday-checkup-{TODAY}.md

    Review the report and commit at session wrap (`/wrap-session`).
    Run `/resolve-improvement-log` to archive any resolved improvement entries.
    ```

18. **Do NOT commit.** All files land unstaged. Operator reviews and commits at session wrap per workspace `Commit behavior` rules (handles concurrent-session staging enumeration correctly).

---

### Notes

- **Scope-slug convention:** `ai-resources`, `workspace`, `project-{name}`. Matches existing audit filename convention (see `repo-due-diligence-*.md` and `token-audit-*.md` under `ai-resources/audits/`).
- **No subagent orchestration here.** Each sub-command manages its own subagents; this command only sequences them and consolidates outputs.
- **Interactive sub-commands to avoid:** `/resolve-improvement-log` and `/cleanup-worktree` both prompt for confirmation mid-run. They are listed only in the follow-ups section, never auto-invoked. `/repo-dd deep` and `/analyze-workflow` are deferred to quarterly follow-ups for the same reason plus runtime.
- **Failure handling:** if a sub-command errors, record the error as the per-scope result and continue to the next check. Do not abort the whole run.
