# Friday Checkup — 2026-05-22

## Tier

weekly (auto-detected)

## Scopes audited

- ai-resources
- workspace
- project ai-development-lab
- project axcion-ai-system-owner
- project global-macro-analysis
- project nordic-pe-macro-landscape-H1-2026
- project obsidian-pe-kb
- project project-planning
- project repo-documentation

## Prioritized findings (rolled up across all scopes)

No CRITICAL findings.

1. **[HIGH]** `/improve` nordic-pe — **verified `/session-plan` fix never reached the project.** Improvement-log entries #2/#3/#6 are marked `applied`+`Verified` against the canonical `ai-resources` copy, but `session-plan` is a `local` (non-symlink) command in the project's `shared-manifest.json`, so the project still runs the un-fixed Step 0/1/7 code. The session-plan-overwrite recurrence the log claims to have closed can still happen. A false-positive verification.
2. **[HIGH]** `/coach` nordic-pe — independently surfaces the same issue: "verified" was asserted against the source-of-truth artifact, not the executing artifact. Top issue for 3 consecutive coaching cycles.
3. **[HIGH]** `/improve` + `/coach` global-macro-analysis — **concurrent-session collision is RECURRING (3rd occurrence).** improvement-log #3 (concurrent-session detection hook) has been `logged (pending)` since 2026-05-08 and has now leaked twice on 2026-05-20. The hook build is blocked on operator approval (Autonomy Rule #8), not engineering.
4. **[HIGH]** `/permission-sweep` — `projects/ai-development-lab/.claude/settings.json` missing `"Bash(rm *)"` in allow. Delete operations will prompt.
5. **[HIGH]** `/permission-sweep` — `projects/axcion-brand-book/.claude/settings.json` missing `"Bash(rm *)"` in allow. Delete operations will prompt.
6. **[MEDIUM]** `/permission-sweep` — `~/.claude/settings.json` carries `"model": "sonnet"`. Violates the workspace Model Tier rule (model defaults prohibited in any settings.json — they contest in-session `/model` switches). Fix = remove the field. *(findings-extractor flagged this CRITICAL; the permission-sweep report rates it MEDIUM — source severity used here.)*
7. **[MEDIUM]** `/log-sweep` — log-sweep-auditor again misclassified `global-macro-analysis/pipeline/source-docs/operations-manual-v1.3.md` as an over-threshold Cat A2 log. It is a documentation file with section headers, not a dated log. This false positive was documented in `decisions.md` 2026-05-18 and the auditor heuristic was never fixed — a recurring auditor bug.
8. **[MEDIUM]** `/kb-integrity` (repo-documentation vault) — `vault/components/projects.md` validated against the wrong schema: all 7 entries use the §4.1 12-field table instead of the §4.4 projects-registry schema (28 missing-field instances, one systematic root cause).

**Clean:** `/audit-repo` returned **GREEN with 0 Critical / 0 Important** for all 3 deployed scopes (ai-resources, global-macro-analysis, nordic-pe).

## Per-scope summary

### ai-resources
- /audit-repo: GREEN — 0 Critical, 0 Important, 9 Minor → snapshot `audits/repo-health-ai-resources-2026-05-22.md`
- /improve: 4 logged, 1 dismissed → `logs/improvement-log.md`
- /coach: ran (10 sessions) → `logs/coaching-log.md` append. The One Thing: name the bright-line before review.
- /audit-claude-md, /token-audit: not run (weekly tier)

### workspace
- /audit-repo: skipped — repo-health-analyzer not deployed
- /improve: skipped — no `logs/improvement-log.md`
- /coach: skipped — no `logs/session-notes.md`

### project ai-development-lab
- /audit-repo: skipped — repo-health-analyzer not deployed
- /improve: skipped — no `logs/improvement-log.md`
- /coach: ran (8 sessions, baseline) → `logs/coaching-log.md` created. The One Thing: stop concurrent sessions on shared files.

### project axcion-ai-system-owner
- /audit-repo: skipped — repo-health-analyzer not deployed
- /improve: skipped — no `logs/improvement-log.md`
- /coach: ran (7 sessions) → `logs/coaching-log.md` append. The One Thing: plan-mode pre-flight check before heavy subagent dispatch.

### project global-macro-analysis
- /audit-repo: GREEN — 0 Critical, 0 Important, 7 Minor → snapshot `audits/repo-health-project-global-macro-analysis-2026-05-22.md`
- /improve: 4 new logged + 1 RECURRING escalation note (concurrent-session hook) → `logs/improvement-log.md`
- /coach: ran (8 sessions) → `logs/coaching-log.md` append. HIGH-severity concern: concurrent-session collision.

### project nordic-pe-macro-landscape-H1-2026
- /audit-repo: GREEN — 0 Critical, 0 Important, 6 Minor → snapshot `audits/repo-health-project-nordic-pe-macro-landscape-H1-2026-2026-05-22.md`
- /improve: 5 logged (incl. 1 HIGH structural finding) → `logs/improvement-log.md`
- /coach: ran (12 sessions) → `logs/coaching-log.md` append. HIGH-severity concern: verification false-positive.

### project obsidian-pe-kb
- /audit-repo: skipped — repo-health-analyzer not deployed
- /improve: skipped — no `logs/improvement-log.md`
- /coach: ran (13 sessions) → `logs/coaching-log.md` append. Workflow Evolution downgraded Watch→Act (no improvement-log infrastructure).

### project project-planning
- /audit-repo: skipped — repo-health-analyzer not deployed
- /improve: skipped — no `logs/improvement-log.md`
- /coach: ran (12 sessions) → `logs/coaching-log.md` append. The One Thing: redirect review attention from plan-approval to content-review/QC gates.

### project repo-documentation
- /audit-repo: skipped — repo-health-analyzer not deployed
- /improve: skipped — no `logs/improvement-log.md`
- /coach: skipped — insufficient session volume (4/5)
- W2.1 doc-scanner: 136 added / 1 removed / 7 modified → `output/phase-2/w2-1-doc-scan-2026-05-22.md`
- W2.3 maintenance + /kb-integrity: 1 error, 2 warnings, 1 info → `output/phase-2/w2-3-maintenance-2026-05-22.md`, `vault/_integrity-report-2026-05-22.md`

### permission-sweep (workspace-wide)
- 26 settings files scanned — 0 CRITICAL, 2 HIGH, 1 MEDIUM, 6 advisory → `audits/permission-sweep-2026-05-22.md`

### log-sweep (workspace-wide)
- 12 scopes, ~1,754 files inventoried — 3 over threshold (2 genuine candidates, 1 known false positive) → `audits/log-sweep-2026-05-22.md`

## Tactical follow-ups

**Permissions (run `/permission-sweep` without `--dry-run` for items 1–5 in one approved pass):**
- [ ] Add `"Bash(rm *)"` to `projects/ai-development-lab/.claude/settings.json` allow list — risk: high
- [ ] Add `"Bash(rm *)"` to `projects/axcion-brand-book/.claude/settings.json` allow list — risk: high
- [ ] Remove the `"model": "sonnet"` field from `~/.claude/settings.json` — Model Tier policy violation — risk: med
- [ ] Add `Edit(**/.claude/**)` + `Write(**/.claude/**)` + `NotebookEdit` to ai-development-lab and axcion-brand-book settings.json (advisory hardening) — risk: low
- [ ] Resolve Rule 14 advisory: 7 project settings files carry `Read(archive/**)` deny with no `archive/` entry in their `.gitignore` — risk: low

**Workflow / infrastructure fixes (from /improve):**
- [ ] **nordic-pe HIGH** — port the 3 verified `/session-plan` edits (Step 0/1/7) into the project-LOCAL `.claude/commands/session-plan.md`; add a "local commands verify per-copy" rule to the improvement-log — risk: high
- [ ] **global-macro RECURRING** — build the concurrent-session detection hook (improvement-log #3, leaked 3×); requires operator approval per Autonomy Rule #8 — risk: high
- [ ] Triage the 11 other `/improve` findings logged this checkup across ai-resources / global-macro / nordic-pe improvement-logs — risk: med

**Coaching follow-ups (from /coach):**
- [ ] `bright-line-review` gate is a rubber-stamp for the 4th consecutive ai-resources coaching cycle — name the specific bright-line before reviewing, or retire/recalibrate via `gate-calibration.md` — risk: med
- [ ] 2 ai-resources improvement-log entries (`/wrap-session` leaner, permission-sweep-auditor) were re-deferred 2026-05-18 — schedule one dedicated session rather than deferring a third time — risk: med
- [ ] obsidian-pe-kb, project-planning, and ai-development-lab have no `logs/improvement-log.md` — friction signal is generated but not tracked — risk: low

**Log archival (from /log-sweep):**
- [ ] Run `/log-sweep` (no `--dry-run`) to archive 2 over-threshold `decisions.md` files (buy-side 404L, nordic-pe 606L) — verify `## ` entry count first; both may correctly no-op — risk: low
- [ ] Fix the log-sweep-auditor Cat A2 heuristic — it again misclassified `operations-manual-v1.3.md` (section headers ≠ dated log headers); documented 2026-05-18, never fixed — risk: med

**Documentation vault (from W2.1 / W2.3 / /kb-integrity):**
- [ ] Triage the 8 grouped registry actions in `repo-documentation/output/phase-2/w2-3-maintenance-2026-05-22.md` at `/friday-act` (136 added / 1 removed / 7 modified components) — risk: low
- [ ] Apply 2 renames as rename-updates not deprecate-and-add: `resolve-improvements`→`resolve-improvement-log`; `nordic-pe-landscape-mapping-4-26`→`nordic-pe-macro-landscape-H1-2026` — risk: low
- [ ] Re-author `vault/components/projects.md` against the §4.4 projects-registry schema (28 missing fields, one root cause) — risk: med
- [ ] Run `/kb-update {category}` to align the vault with the registry once W2.1 pastes are triaged — risk: low

**Repo-health Minor items (from /audit-repo — all scopes GREEN):**
- [ ] ai-resources: confirm whether the 2 apparently-orphaned skills (`fund-triage-scanner`, `prose-refinement-writer`) are still intended in the library — risk: low
- [ ] nordic-pe: resync `shared-manifest.json` — it lists a renamed command and omits `project-status` / `produce-jargon-gloss` — risk: low
- [ ] global-macro: optionally extract the 2 inline PreToolUse hooks into versioned `.claude/hooks/` script files — risk: low

**Working tree / git:**
- [ ] `/cleanup-worktree` — ai-resources working tree dirty (5 modified, 13 untracked). Most is this checkup's own output (commit at wrap). Pre-existing untracked: 5 risk-check files + `inbox/workflow-diagnosis.md` — risk: med
- [ ] `git push` — ai-resources: 5 unpushed commit(s). Note: `/prime` reported 0 unpushed at session start — likely concurrent-session commits; verify before pushing — risk: med

## All reports generated

**Repo-health (per-scope reports + dated cadence snapshots):**
- `ai-resources/reports/repo-health-report.md` → snapshot `ai-resources/audits/repo-health-ai-resources-2026-05-22.md`
- `projects/global-macro-analysis/reports/repo-health-report.md` → snapshot `ai-resources/audits/repo-health-project-global-macro-analysis-2026-05-22.md`
- `projects/nordic-pe-macro-landscape-H1-2026/reports/repo-health-report.md` → snapshot `ai-resources/audits/repo-health-project-nordic-pe-macro-landscape-H1-2026-2026-05-22.md`

**Improvement logs (appended):**
- `ai-resources/logs/improvement-log.md` (4 entries)
- `projects/global-macro-analysis/logs/improvement-log.md` (4 entries + 1 escalation note)
- `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` (5 entries)

**Coaching logs (appended / created):**
- `ai-resources/logs/coaching-log.md`
- `projects/ai-development-lab/logs/coaching-log.md` (created — first run)
- `projects/axcion-ai-system-owner/logs/coaching-log.md`
- `projects/global-macro-analysis/logs/coaching-log.md`
- `projects/nordic-pe-macro-landscape-H1-2026/logs/coaching-log.md`
- `projects/obsidian-pe-kb/logs/coaching-log.md`
- `projects/project-planning/logs/coaching-log.md`

**Workspace-wide sweeps:**
- `ai-resources/audits/permission-sweep-2026-05-22.md` (+ working notes `audits/working/permission-sweep-2026-05-22.md` + `.summary.md`)
- `ai-resources/audits/log-sweep-2026-05-22.md` (+ 12 working notes `audits/working/log-sweep-*-2026-05-22.md` + manifest `log-sweep-manifest-2026-05-22.md`)

**Documentation vault (repo-documentation):**
- `projects/repo-documentation/output/phase-2/w2-1-doc-scan-2026-05-22.md`
- `projects/repo-documentation/output/phase-2/w2-3-maintenance-2026-05-22.md`
- `projects/repo-documentation/vault/_integrity-report-2026-05-22.md`

**This report:**
- `ai-resources/audits/friday-checkup-2026-05-22.md`

---

*Review-only — no fixes auto-applied. All files land unstaged; review and commit at session wrap (`/wrap-session`). Two `/coach` runs (ai-development-lab, axcion-ai-system-owner) needed a path-corrected retry — the collaboration-coach agent mis-resolved project roots on first invocation; worth a hardening note if it recurs.*
