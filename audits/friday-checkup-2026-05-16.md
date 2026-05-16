# Friday Checkup — 2026-05-16

## Tier
weekly (operator-override — off-schedule Saturday run)

## Scopes audited
- ai-resources
- workspace
- project interpersonal-communication
- project nordic-pe-macro-landscape-H1-2026
- project project-planning

## Prioritized findings (rolled up across all scopes)

1. **[CRITICAL]** `projects/nordic-pe-macro-landscape-H1-2026/` — Context-health auditor flagged missing `context/` directory referenced by `produce-prose-draft.md` and `produce-architecture.md` (paths: `context/prose-quality-standards.md`, `context/content-architecture.md`, `context/project-brief.md`). Either restore the files if prose production is still in scope, or document in CLAUDE.md that those commands are retired.
2. **[HIGH]** Two project `settings.json` files missing `additionalDirectories` (Rule 8) — `nordic-pe-landscape-mapping-4-26`, `interpersonal-communication`. ai-resources symlinks may not resolve from these projects.
3. **[HIGH]** Four project repos lack explicit gitignore entry for `.claude/settings.local.json` (Rule 12) — nordic-pe-macro-landscape-H1-2026, global-macro-analysis, obsidian-pe-kb, project-planning (project-planning has no `.gitignore` at all). Covered only by global `~/.config/git/ignore`.
4. **[HIGH]** `projects/nordic-pe-macro-landscape-H1-2026/reference/skills/knowledge-file-producer/SKILL.md` missing required `model:` and `effort:` frontmatter fields.
5. **[HIGH]** `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` should document that project pipeline commands use YAML frontmatter headers instead of `Usage:` lines (turn audit flag into documented design decision).

## Per-scope summary

### ai-resources
- /audit-repo: **YELLOW** — 14 minor findings, 0 critical/important. Top items: 14 skills lack trigger/exclusion language; 2 hardcoded absolute paths in `.claude/settings.json`; 2 skills (answer-spec-generator 487, research-plan-creator 466) approaching 500-line content-extraction threshold; 2 orphaned skills (fund-triage-scanner, prose-refinement-writer). Snapshot: `audits/repo-health-ai-resources-2026-05-16.md`.
- /improve: 0 new appended (6 analyst findings all duplicates against existing 2026-05-16 entries in `logs/improvement-log.md`).
- /coach: ran (14 sessions). Iteration ↑ Healthy, Decision Patterns → Watch, QC ↑ Healthy, Delegation → Healthy, Workflow ~ Watch. The One Thing: run a dedicated `/resolve-improvement-log` execution session against the three 2026-05-16 logged-pending entries (session-start token, /prime single-snapshot RECURRING, /session-plan sparse template). Bright-line-review gate slipping to rubber-stamp (78% confirm).

### workspace
- /audit-repo: skipped (not applicable — no repo-health-analyzer deployed at workspace root).
- /improve: skipped (no `logs/improvement-log.md`).
- /coach: skipped (no `logs/session-notes.md`).

### project interpersonal-communication
- /audit-repo: skipped (repo-health-analyzer not deployed).
- /improve: skipped (no `logs/improvement-log.md`).
- /coach: skipped (insufficient session volume: 4/5).

### project nordic-pe-macro-landscape-H1-2026
- /audit-repo: **RED** — 1 critical, 3 important, 6 minor. Critical: missing `context/` directory; Important: skill missing model/effort fields, CLAUDE.md missing pipeline-frontmatter note, one auditor-flagged command/agent gap. Positive signals: 93 symlinks intact, 12 executable hooks, lean CLAUDE.md (60 lines), no broken cross-references, qc-gate isolation correct. Snapshot: `audits/repo-health-project-nordic-pe-macro-landscape-H1-2026-2026-05-16.md`.
- /improve: skipped (no `logs/improvement-log.md`).
- /coach: ran (11 sessions, baseline). Iteration ↑ Healthy, Decision → Healthy, QC ↑ Healthy, Delegation ↑ Healthy, Workflow ~ Watch. The One Thing: run `/improve` on the session-plan hook overwrite (fired 3 times across 3 consecutive sessions, each deferred). Coaching-log written (was missing). *Note: a second 2026-05-16 entry was appended to the coaching-log by a parallel session/hook after this run.*

### project project-planning
- /audit-repo: skipped (repo-health-analyzer not deployed).
- /improve: skipped (no `logs/improvement-log.md`).
- /coach: ran (7 sessions, baseline). Iteration ↑ Healthy, Decision → Healthy, QC ↑ Healthy, Delegation → Watch, Workflow N/A (no improvement-log). The One Thing: 30-second skill-applicability check before reading any SKILL.md (skill-scope-mismatch fired in 3 of 7 sessions). Coaching-log written. Data gap: coaching-data.md lags session-notes by 3 sessions; no improvement-log.md exists.

### Workspace-wide (single-pass)
- /permission-sweep --dry-run: **0 CRITICAL, 4 HIGH, 1 MEDIUM, 5 ADVISORY** across 25 settings files. Two findings (H-1 git-push allow→deny; M-1 user-level deny list) flagged as conflicting with operator policy memory (`feedback_zero_permission_prompts`) — leave as-is. Report: `audits/permission-sweep-2026-05-16.md`.
- /log-sweep --dry-run: **1 archive candidate** (`ai-resources/logs/usage-log.md` Cat B 652 lines, threshold 500). All other scopes within thresholds. Cat D age-check: 69 ai-resources working files, 0 meet 60-day/30-day threshold. Report: `audits/log-sweep-2026-05-16.md`.

## Tactical follow-ups

**Critical (act this week):**
- [ ] Resolve `projects/nordic-pe-macro-landscape-H1-2026/` missing `context/` directory — either restore prose-quality-standards.md / content-architecture.md / project-brief.md, or document in CLAUDE.md that produce-prose-draft and produce-architecture are retired — risk: high
- [ ] `git push` — ai-resources: 6 unpushed commits — risk: med

**High (act this cycle):**
- [ ] Apply permission-sweep gitignore fixes (H-2, H-3): add `.claude/settings.local.json` to nordic-pe-macro, global-macro-analysis, obsidian-pe-kb `.gitignore`; create `.gitignore` for project-planning — risk: high
- [ ] Apply permission-sweep `additionalDirectories` fixes (H-4): nordic-pe-landscape-mapping-4-26 and interpersonal-communication settings.json — risk: high
- [ ] Add `model: opus` and `effort: high` to `nordic-pe-macro-landscape-H1-2026/reference/skills/knowledge-file-producer/SKILL.md` — risk: high
- [ ] Add CLAUDE.md note in nordic-pe-macro-landscape-H1-2026 that project pipeline commands use YAML frontmatter (not `Usage:` lines) — risk: high
- [ ] Run `/improve` against the session-plan hook overwrite in nordic-pe-macro (3 deferred occurrences) — risk: med
- [ ] Run `/resolve-improvement-log` execution session against 3 logged-pending 2026-05-16 entries (ai-resources) — risk: med

**Medium / Low:**
- [ ] `/cleanup-worktree` — ai-resources: 4 modified, 8 untracked (mostly this session's audit artifacts) — risk: med
- [ ] `/cleanup-worktree` — workspace root: 1 modified, 21 deleted (projects/personal/*), 86 untracked. Recent commits show ongoing untracking pattern (84d3103). Investigate before bulk action — risk: med
- [ ] Add trigger/exclusion language to 14 ai-resources skills (`/improve-skill` pass) — risk: low
- [ ] Fix 2 hardcoded absolute paths in `ai-resources/.claude/settings.json` — risk: low
- [ ] Content extraction for `answer-spec-generator` (487 lines) and `research-plan-creator` (466 lines) — approaching threshold — risk: low
- [ ] Resolve 2 orphaned ai-resources skills (fund-triage-scanner, prose-refinement-writer) — risk: low
- [ ] Backfill coaching-data.md in project-planning (lags session-notes by 3 sessions) — risk: low
- [ ] Permission-sweep form-normalization advisories (ADV-1 `Bash(git push *)` → `Bash(git push*)`; ADV-2 `NotebookEdit(**)` → `NotebookEdit`; ADV-7 explicit `.claude/settings.local.json` in `ai-resources/.gitignore`) — risk: low
- [ ] Archive `ai-resources/logs/usage-log.md` (652 lines, Cat B over threshold) — re-run `/log-sweep` without `--dry-run` — risk: low

**Deferred (operator-policy conflicts — do not apply):**
- ~~H-1 `Bash(git push *)` allow→deny (workspace Layer B)~~ — conflicts with operator policy "never add to deny list"
- ~~M-1 user-level deny list canonical fix~~ — same policy conflict

## All reports generated

- `ai-resources/reports/repo-health-report.md` (latest) + `ai-resources/audits/repo-health-ai-resources-2026-05-16.md` (cadence snapshot)
- `projects/nordic-pe-macro-landscape-H1-2026/reports/repo-health-report.md` (latest) + `ai-resources/audits/repo-health-project-nordic-pe-macro-landscape-H1-2026-2026-05-16.md` (cadence snapshot)
- `ai-resources/audits/permission-sweep-2026-05-16.md`
- `ai-resources/audits/log-sweep-2026-05-16.md`
- `ai-resources/audits/working/permission-sweep-2026-05-16.md` (full notes) + `.summary.md`
- `ai-resources/audits/working/log-sweep-ai-resources-2026-05-16.md`
- `ai-resources/audits/working/log-sweep-project-interpersonal-communication-2026-05-16.md`
- `ai-resources/audits/working/log-sweep-project-nordic-pe-macro-landscape-H1-2026-2026-05-16.md`
- `ai-resources/audits/working/log-sweep-project-project-planning-2026-05-16.md`
- `ai-resources/logs/coaching-log.md` (appended 2026-05-16 entry)
- `projects/nordic-pe-macro-landscape-H1-2026/logs/coaching-log.md` (new file)
- `projects/project-planning/logs/coaching-log.md` (new file)
