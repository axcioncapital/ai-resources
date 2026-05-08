# Friday Checkup — 2026-05-08

## Tier
weekly (auto-detected — DOW=5, DAY=08 > 7)

## Scopes audited
- ai-resources
- workspace
- project axcion-ai-system-owner
- project global-macro-analysis
- project repo-documentation

---

## Prioritized findings (rolled up across all scopes)

1. [CRITICAL] **Broken symlink — `workflows/research-workflow/.claude/commands/consult.md`** — 3-level relative path (`../../../`) should be 4-level (`../../../../`). Any deployed research-workflow project will fail at runtime when calling `/consult`. Fix: `cd workflows/research-workflow/.claude/commands && ln -sf ../../../../.claude/commands/consult.md consult.md`

2. [HIGH] **ai-resources/.claude/settings.json — missing canonical tool grants** — Allow list missing: `Read`, `Agent`, `Skill`, `TodoWrite`, `Glob`, `Grep`, `WebFetch`, `WebSearch`, `NotebookEdit`, `ToolSearch`, `Edit(**/.claude/**)`, `Write(**/.claude/**)`, plus absolute-path fallbacks. Run `/permission-sweep` to apply.

3. [HIGH] **ai-resources/.claude/settings.json — missing `additionalDirectories`** — Workspace root path absent; ai-resources symlinks may not resolve. Fix: add `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`.

4. [HIGH] **research-workflow/settings.json — unresolved `{{WORKSPACE_ROOT}}` placeholder** — `additionalDirectories` contains the literal placeholder string; path does not exist on disk.

5. [MEDIUM] **User-level `~/.claude/settings.json` — empty deny list** — Canonical requires `Bash(rm -rf *)` and `Bash(sudo *)` as safety floor.

6. [MEDIUM] **Workspace root settings.json — no deny block** — Canonical requires four deny entries including `Bash(git reset --hard *)`.

---

## Per-scope summary

### ai-resources
- `/audit-repo`: **RED** — 1 critical (consult.md symlink), 2 important, 9 minor → `audits/repo-health-ai-resources-2026-05-08.md`
- `/improve`: 0 appended (both friction events already resolved in archive) → `logs/improvement-log.md`
- `/coach`: ran (13 sessions) → `logs/coaching-log.md` — Watch: design-session first-pass quality slipping (5 REVISE in 8 QC cycles); forward-creation velocity high but improvement-log resolution stalled

### workspace
- `/audit-repo`: skipped — not a project scope
- `/improve`: skipped — no improvement-log.md
- `/coach`: ran (10 sessions) → `logs/coaching-log.md` (baseline) — Watch: reworks concentrate on scoping/framing; delegation sometimes forgotten under autonomy pressure

### project axcion-ai-system-owner
- `/audit-repo`: skipped — repo-health-analyzer not deployed
- `/improve`: skipped — no improvement-log.md
- `/coach`: ran (6 sessions) → `projects/axcion-ai-system-owner/logs/coaching-log.md` (baseline) — Watch: ~8 structural decisions in session-notes not promoted to decisions.md

### project global-macro-analysis
- `/audit-repo`: skipped — repo-health-analyzer not deployed
- `/improve`: 3 entries appended → `projects/global-macro-analysis/logs/improvement-log.md` (concurrent-session race fix, /kb-review skip condition, concurrency hook)
- `/coach`: ran (11 sessions) → `projects/global-macro-analysis/logs/coaching-log.md` (baseline) — Watch: concurrent Claude Code sessions on shared macro-kb/ state; content-review gate approaching rubber-stamp (93% confirmed)

### project repo-documentation
- `/audit-repo`: skipped — repo-health-analyzer not deployed
- `/improve`: skipped — no improvement-log.md
- `/coach`: ran (20 sessions) → `projects/repo-documentation/logs/coaching-log.md` — Healthy: "verify against actual artifact" pattern strengthened; first complete drift-detection-fix loop closed
- W2.1 doc-scanner: 44 added, 3 removed, 0 modified → `output/phase-2/w2-1-doc-scan-2026-05-08.md`
- W2.3 maintenance consolidator: 1 error, 8 warnings, 2 info in vault integrity → `output/phase-2/w2-3-maintenance-2026-05-08.md`

### permission-sweep (workspace-wide)
- 0 CRITICAL, 3 HIGH, 2 MEDIUM, 7 ADVISORY, 0 intentional-narrow → `audits/permission-sweep-2026-05-08.md`

---

## Tactical follow-ups

- [ ] Fix `consult.md` symlink: `ln -sf ../../../../.claude/commands/consult.md workflows/research-workflow/.claude/commands/consult.md` — risk: high
- [ ] Run `/permission-sweep` to add missing canonical tool grants + `additionalDirectories` to `ai-resources/.claude/settings.json` — risk: high
- [ ] Fix `innovation-sweep` entry in `vault/components/commands.md` — add 5 missing schema fields (`Scope`, `Used By`, `Depends On`, `State Writes`, `Governed By`) — risk: high
- [ ] Remove stale `Read(archive/**)` deny entry from `ai-resources/.claude/settings.json` (`archive/` does not exist) — risk: med
- [ ] Resolve `{{WORKSPACE_ROOT}}` placeholder in `ai-resources/workflows/research-workflow/.claude/settings.json` additionalDirectories → replace with absolute path — risk: med
- [ ] Investigate 3 removed components from W2.1: `resolve-improvements` (likely renamed), `CLAUDE.md (workflows)`, `settings.local.json (workflows)` — mark deprecated if intentional — risk: med
- [ ] Fix 4 dead wiki-links in vault: `[[audit-discipline]]`, `[[documentation-structure]]`, `[[friday-checkup]]` in `architecture/risk-topology.md` and `projects/projects.md` — risk: med
- [ ] `/cleanup-worktree` — working tree dirty (3 modified, 12 untracked) — risk: med
- [ ] Promote 3–5 structural decisions from session-notes to `decisions.md` in axcion-ai-system-owner (staleness threshold, scope-slug convention, halt-and-re-run gate shape) — risk: low
- [ ] Paste 44 new component entries from W2.1 drift report into `vault/components/` — run `/kb-update` per category — risk: low
- [ ] Convert 5 short-name wiki-links to full-path form (e.g. `[[principles/principles.md]]`) — risk: low
- [ ] Review and resolve at least 1 improvement-log `logged (pending)` entry — 5 entries pending 10–16 days; 3 flagged as "no active friction" candidates for deletion — risk: low

---

## All reports generated

- `ai-resources/reports/repo-health-report.md`
- `ai-resources/audits/repo-health-ai-resources-2026-05-08.md`
- `ai-resources/logs/coaching-log.md` (appended)
- `logs/coaching-log.md` (created baseline)
- `projects/axcion-ai-system-owner/logs/coaching-log.md` (created baseline)
- `projects/global-macro-analysis/logs/coaching-log.md` (created baseline)
- `projects/global-macro-analysis/logs/improvement-log.md` (3 entries appended)
- `projects/repo-documentation/logs/coaching-log.md` (appended)
- `ai-resources/audits/permission-sweep-2026-05-08.md`
- `ai-resources/audits/working/permission-sweep-2026-05-08.md` (full notes)
- `ai-resources/audits/working/permission-sweep-2026-05-08.md.summary.md`
- `projects/repo-documentation/output/phase-2/w2-1-doc-scan-2026-05-08.md`
- `projects/repo-documentation/vault/_integrity-report-2026-05-08.md` (gitignored, vault-local)
- `projects/repo-documentation/output/phase-2/w2-3-maintenance-2026-05-08.md`
