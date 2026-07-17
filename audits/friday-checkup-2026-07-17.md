# Friday Checkup — 2026-07-17

## Tier
weekly (auto-detected — Friday, day-of-month 17; recovery run, last checkup was 2026-07-03, 14 days prior)

## Scopes audited
- ai-resources
- workspace root (workspace CLAUDE.md scope)
- project axcion-ai-system-owner
- project axcion-website

## Prioritized findings (rolled up across all scopes)

No CRITICAL findings in the workspace-health sense (audit-repo: 0 Critical). Highest-priority items:

1. **[HIGH] Permission drift — 3 actionable CRITICAL structural gaps causing live/future prompts.**
   - `projects/axcion-brand-book/.claude/settings.json` — Rule 3: scoped Edit/Write globs, no `Edit/Write(**/.claude/**)` companion.
   - `projects/interpersonal-communication/knowledge-base/.claude/settings.json` — Rule 4: missing bare `MultiEdit`.
   - `ai-resources/.claude/settings.local.json` — Rule 5: narrow `Bash(...)` grants, no `Bash(*)` (also HIGH Rule 6: no `Bash(rm *)`).
   Fix by running `/permission-sweep` (no `--dry-run`). Report: `audits/permission-sweep-2026-07-17.md`.
2. **[HIGH] `~/.claude/settings.json` declares `"model": "opus[1m]"`.** Violates workspace Model-Tier prohibition ("no `model` field in ANY settings.json") AND carries the `[1m]` suffix that causes subagent-spawn failures (inverted rule, 2026-06-18). Remove the field. (User-level file — operator's own change; outside auto-remediation.)
3. **[HIGH] assert-from-recall pattern hit its own 6-instance escalation trigger** (improvement-log L857). The ai-resources /improve pass recommends /friday-act close L857 + L1084 together as a standing workspace-CLAUDE.md rule ("any repo fact stated to a reviewer or in a plan must cite the command that produced it").
4. **[HIGH] Stale worktree-path permission entries** — workspace-root `.claude/settings.local.json` (Rule 9): 6 `Bash(...)` allow entries hardcode two agent-worktree dirs that no longer exist. Safe to remove.
5. **[MEDIUM] audit-repo (ai-resources): Overall YELLOW** — 1 Important + 2 Minor all trace to gitignored/untracked `output/deploy-test-scratch-2026-06-12/`. Delete it to clear all three. 6 of 7 areas GREEN; zero dead references (80 skills, 90 commands, 42 agents resolve).
6. **[MEDIUM] Over-threshold logs (log-sweep dry-run)** — website `session-notes.md` (1861 lines) + `decisions.md` (1163); ai-resources `session-notes.md` (543) + 34 age-eligible `audits/working/` files. Run `/log-sweep` to archive.

## Per-scope summary

### ai-resources
- /audit-repo: **YELLOW** — 0 Critical / 1 Important / 16 Minor (Settings & Permissions YELLOW; 6/7 areas GREEN). → snapshot `audits/repo-health-ai-resources-2026-07-17.md`
- /improve: 0 new findings — all recent friction already logged as OPEN/pending. Key signal: assert-from-recall escalation trigger MET (see Prioritized #3). → `logs/improvement-log.md`
- /coach: ran (10 sessions, 2026-07-13→07-15). Iteration=Watch↓, Decision=Healthy(strong)↑, QC=Healthy→, Delegation=Watch→, Workflow=Watch(mixed)→. One Thing: decide the research-workflow deploy-gate before opening mission thread 3 (premise falsified on 3 consecutive threads). Prior rec substantially acted on. → coaching-log appended.

### workspace root
- /audit-repo: skipped (no repo-health-analyzer deployed at workspace root).
- /improve: 0 new findings; open backlog item persists — 2026-06-09 graduated-agent same-session dispatch (logged-pending). → `logs/improvement-log.md`
- /coach: ran (15 sessions, 2026-05-21→07-13). Iteration=Healthy→, **Decision=Act↓**, QC=Healthy↑, Delegation=Healthy→, Workflow=Watch→. One Thing: mirror rule-class decisions into `decisions.md` at wrap — newest entry still 2026-05-26 (**4th consecutive cycle** flagging this; prior rec NOT acted on). → coaching-log appended.

### project axcion-ai-system-owner
- /audit-repo: skipped (no repo-health-analyzer deployed).
- /improve: skipped (no `logs/improvement-log.md`).
- /coach: ran (8 sessions, 2026-05-04→06-01; corpus unchanged since 2026-06-05). Delegation=Watch→, rest Healthy→. One Thing: plan-mode pre-flight — never dispatch a write-producing heavy subagent in plan mode. Prior rec not yet testable. → coaching-log appended.

### project axcion-website
- /audit-repo: skipped (no repo-health-analyzer deployed).
- /improve: **2 new findings** — (1) page-producing command specs must ground against frozen page-authority docs 01/03, not just source-approval [Do now]; (2) re-anchor session-notes mandate when a mid-session operator pivot supersedes it [batch]. → `logs/improvement-log.md`
- /coach: ran (~50 sessions, 2026-06-16→07-16; baseline run). **Iteration=Act↓**, Decision=Healthy→, QC=Watch↔, Delegation=Watch↔, **Workflow=Act↓**. One Thing: give the per-page Tier-C visual verdict promptly, page-by-page; stop new refinement briefs on a page until its prior verdict lands (never-arriving verdict holds 37 files). → coaching-log created.

## Weekly Session Value Review

### Highest-value sessions
- 2026-07-14 — ai-resources Session S7 (qc-reviewer / risk-check-reviewer hardening) — TYPE A / 9/10
### Lowest-yield sessions
- (thin window — only 1 scored Session Value Audit block in-window; same session as above. The 2026-07-13 ai-resources block carried no scored fields.)
### Session types to repeat
- "Repeat with constraints" — test-before-wire builds: assert a hook's exit code against a synthetic payload before wiring; re-derive a plan's counts/claims by execution before implementing (found 5 plan errors, 2 load-bearing).
### Session types to constrain or batch
- Same test-before-wire pattern — repeat with the two constraints above.
### Session types to stop
- (none this window)
### One operating rule change
- Adopt: "A hook's payload contract is unverifiable by reading — pipe a synthetic payload and assert the exit code before wiring, and never model a new hook on an unwired one." Trigger: any new/edited `.claude/hooks/*.sh`. Home: `docs/audit-discipline.md` § hook change class. (From ai-resources S7 RULE line.)

_Note: Session Value Audit blocks exist only where `/wrap-session +audit/full` ran; the window (since 2026-07-03) is thin because most sessions ran core-path wrap._

## Tactical follow-ups

**Permissions / settings**
- [ ] Fix 3 actionable CRITICAL permission gaps (brand-book Rule 3; ipc/knowledge-base Rule 4; ai-resources `settings.local.json` Rule 5) — run `/permission-sweep` — risk: high
- [ ] Remove `"model":"opus[1m]"` from `~/.claude/settings.json` (Model-Tier + `[1m]` spawn-failure) — risk: high
- [ ] Remove 6 stale worktree-path Bash entries from workspace-root `.claude/settings.local.json` (Rule 9) — risk: high
- [ ] Create `settings.local.json` with additionalDirectories grant for axcion-brand-book + axcion-website (Rule 8) — risk: med
- [ ] Decide user-vs-workspace confidentiality deny divergence (Rule 11 — `Read(**/*deal-*)` etc.) — risk: med
- [ ] Batch 34 ADVISORY hygiene fixes (22× `archive/` gitignore, 10× additionalDirectories relocate, 2× dupes) via `/permission-sweep` — risk: low
- [ ] Update `docs/permission-template.md` stale intentional-narrow example (names non-existent `obsidian-pe-kb/vault`; actual is `strategic-os`) — risk: low

**Repo health / logs**
- [ ] Delete gitignored `ai-resources/output/deploy-test-scratch-2026-06-12/` (clears audit-repo's 1 Important + 2 Minor) — risk: low
- [ ] Archive over-threshold logs — website `session-notes.md`/`decisions.md`, ai-resources `session-notes.md` + 34 stale `audits/working/` files — run `/log-sweep` — risk: low
- [ ] Fix log-sweep-auditor shared-scratchpad race under parallel dispatch (use per-invocation unique temp filename) — risk: med

**Improvement backlog (ai-resources)**
- [ ] `/resolve-improvement-log` — 7 applied+verified entries pending archive — risk: low
- [SESSION-ISSUE] Step 3.5 CONCURRENT block strands a no-own-marker session whose work is already committed — investigated 2026-06-04, fix-ready — risk: med
- [SESSION-ISSUE] Unmarked /clarify-first session risks false-CONCURRENT wrap guard in a shared checkout — investigated 2026-06-10 — risk: med
- [ ] 19 [STALE] improvement entries pending 29–53 days (no Review-cycle park) — decide apply / defer-with-Review-cycle / close — risk: med:
  - Purge `[1m]` / 1M-context model declarations (29d) · /new-project symlink registration for standalone projects (31d) · check-foreign-staging.sh fails open for footprint-less sessions (38d) · non-/prime session start writes no per-id marker (35d) · split-log.sh tripwire propagation to 11 copies (35d) · Graduation verdicts recorded without second-consumer test (43d) · PreToolUse commit-block hook for QC-PENDING (39d) · Reusable `/create-requirements-doc` (34d) · Mission promote-rw-canonical close findings (35d) · Routine-Yield Review in /pipeline-review (35d) · Extract shared rendering-convention doc (53d) · /pm forward-looking handling (50d) · sub-subagent dispatch limitation (50d) · /pm internal QC step (50d) · B-04/S-04 extraction (50d) · placement-verifier four-pipeline extension (50d) · Q1–Q8 placement logic extraction (50d) · fix-spec Milestone 4 follow-ups (38d) · refresh-project-state read-surface hardening (38d)

**Improve findings (→ /friday-act triage)**
- [ ] website: add page-authority (doc 01/03) grounding rule + QC-gate item to project CLAUDE.md [Do now] — risk: med
- [ ] website: re-anchor session-notes mandate on mid-session operator pivot [batch] — risk: low
- [ ] workspace: 2026-06-09 graduated-agent same-session dispatch (logged-pending) — risk: med

**Coach actionables (Act-rated)**
- [COACH] workspace: `decisions.md` stale 4th consecutive cycle — mirror rule-class decisions into `decisions.md` in the wrap pass — risk: med
- [COACH] website: per-page Tier-C visual-verdict backlog holding 37 files — give verdicts page-by-page; stop new briefs until prior lands — risk: med
- [COACH] ai-resources: research-workflow deploy-gate premise falsified 3× — decide the gate before opening mission thread 3 — risk: med

**Open items**
- [OPEN-ITEM] inbox brief: audit-workflow-pipeline — `inbox/audit-workflow-pipeline.md` — risk: med
- [OPEN-ITEM] inbox brief: codex-second-opinion-brief — `inbox/codex-second-opinion-brief.md` — risk: med
- [OPEN-ITEM] inbox brief: decision-report — `inbox/decision-report.md` — risk: med
- [OPEN-ITEM] inbox brief: repo-review-brief — `inbox/repo-review-brief.md` — risk: med
- [OPEN-ITEM] inbox brief: workflow-diagnosis — `inbox/workflow-diagnosis.md` — risk: med
- [OPEN-ITEM] 7 applied-but-unverified improvements (2026-07-13/14) in ai-resources — verify or close — risk: med

**Git state**
- [ ] `git push` — ai-resources: 2 unpushed commits — risk: med
- [ ] `git push` — workspace: 1 unpushed commit — risk: med
- [ ] `/cleanup-worktree` — ai-resources working tree dirty (6 modified, ~11 untracked incl. this cadence's outputs). NOTE: a concurrent session appears active in the ai-resources `main` checkout today (untracked `.gitattributes` + today-dated risk-check on "gitattributes merge=union for append-only session logs" + freshly-modified `decisions.md`/`session-notes.md` not written by this cadence). Reconcile before committing. — risk: med

## All reports generated
- `reports/repo-health-report.md` (current) + `reports/repo-health-report-2026-07-03.md` (archived prior)
- `audits/repo-health-ai-resources-2026-07-17.md` (dated snapshot)
- `audits/permission-sweep-2026-07-17.md` + `audits/working/permission-sweep-2026-07-17.md` (full notes) + `.summary.md`
- `audits/log-sweep-2026-07-17.md` + `audits/working/log-sweep-ai-resources-2026-07-17.md` + `audits/working/log-sweep-project-axcion-ai-system-owner-2026-07-17.md` + `audits/working/log-sweep-project-axcion-website-2026-07-17.md`
- Coaching-log appends: `ai-resources/logs/coaching-log.md`, `logs/coaching-log.md` (workspace), `projects/axcion-ai-system-owner/logs/coaching-log.md`; created `projects/axcion-website/logs/coaching-log.md`

---

_Section presence: weekly tier → Tactical follow-ups only (Policy-level observations and Architectural retrospective omitted; Weekly Session Value Review present on all tiers). Findings populated directly (not via findings-extractor subagent) — only two report sources for a weekly run, both already held in main-session context._
