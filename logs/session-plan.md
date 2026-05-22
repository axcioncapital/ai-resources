# Session Plan — 2026-05-22

## Intent
Execute the 3 ungated friday-act plans from 2026-05-22 (session-plan, log-sweep, improvement-log) plus general items #3 and #4, committing each fix separately.

## Class
execution

## Model
opus — match (session is execution-dominant, but improvement-log #1 triage and #2 gate-calibration are genuine judgment work; log-sweep #1 edits an agent that shapes all future audits — Opus is warranted)

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-22-session-plan.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-22-log-sweep.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-22-improvement-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-22-general.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/log-sweep-auditor.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/gate-calibration.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md (confirm change classes)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/shared-manifest.json
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/logs/improvement-log.md

## Findings / Items to Address
1. **session-plan #1** — port 3 verified `/session-plan` edits (Step 0 freshness check, Step 1 timestamp display, Step 7 `Class:`-replace dedup) into the nordic-pe project-LOCAL `.claude/commands/session-plan.md`; add a "local commands verify per-copy" standing rule to nordic-pe improvement-log. [src: 2026-05-22-session-plan.md #1, HIGH]
2. **log-sweep #1** — fix `log-sweep-auditor` Cat A2 heuristic so it stops misclassifying `operations-manual-v1.3.md` as a dated log (exclude `source-docs/` + `docs/` dirs and `manual`/`guide`/`overview`-named `.md` files). [src: 2026-05-22-log-sweep.md #1]
3. **log-sweep #2** — verify entry counts of the 2 flagged `decisions.md` files first, then run `/log-sweep` (no `--dry-run`) only if confirmed over-threshold. [src: 2026-05-22-log-sweep.md #2]
4. **improvement-log #2** — read `gate-calibration.md`, make and log a `bright-line-review` calibration decision (retire / recalibrate / narrow scope) — 4th-cycle rubber-stamp flag. [src: 2026-05-22-improvement-log.md #2]
5. **improvement-log #3** — log a `review-cycle` entry that BOOKS a dedicated session (with target date) for the 2 re-deferred entries (/wrap-session leaner + permission-sweep-auditor); does NOT execute those 2 fixes. [src: 2026-05-22-improvement-log.md #3]
6. **improvement-log #1** — triage 11 `/improve` findings across the ai-resources / global-macro / nordic-pe improvement-logs; read-only assess + annotate + queue, no fixes executed. [src: 2026-05-22-improvement-log.md #1]
7. **general #4** — resync `nordic-pe/.claude/shared-manifest.json` (stale renamed command + 2 missing: `project-status`, `produce-jargon-gloss`). [src: 2026-05-22-general.md #4]
8. **general #3** — investigate the 2 apparently-orphaned skills (`fund-triage-scanner`, `prose-refinement-writer`); INVESTIGATE + RECOMMEND only. [src: 2026-05-22-general.md #3]

## Execution Sequence
1. **session-plan #1** — port the 3 edits → verify each present in the nordic-pe local file → commit (command file). Add the improvement-log rule → commit (rule). *Verify: local copy structure matched canonical pre-patch; 2 commits.*
2. **general #4** — resync manifest → verify JSON parses and the 3 entries are corrected → commit.
3. **log-sweep #1** — edit the Cat A2 heuristic → verify the rule now excludes `source-docs/`/`docs/` + manual-named files → commit.
4. **log-sweep #2** — verify entry counts of the flagged `decisions.md` files → run `/log-sweep` only if over-threshold → commit archive output (or record a no-op). *Verify: archival applied only to confirmed over-threshold files.*
5. **improvement-log #2** — read `gate-calibration.md`, log the decision → commit. *Verify: decision is one of retire/recalibrate/narrow with rationale.*
6. **improvement-log #3** — log the `review-cycle` booking entry with a target date → commit. *Verify: entry books a session, does not mark the 2 fixes done.*
7. **improvement-log #1** — triage 11 findings, annotate the 3 improvement-logs → commit. *Verify: read-only annotations only; no fix applied.*
8. **general #3** — investigate both skills, produce a recommendation. *STOP if conclusion is "archive" (Autonomy Rule #3 — file deletion outside session output scope).*
9. **Session end** — offer the push (operator approval; re-verify `git log @{u}..HEAD` against the grown commit set, which now includes the concurrent session's commits) → `/wrap-session` → `/usage-analysis`.

## Scope Alternatives
- **Min:** session-plan #1 + log-sweep #1/#2 only (HIGH-priority nordic-pe port + the recurring auditor false-positive fix) — ~5 commits.
- **Recommended:** all 8 items above — ~9–10 commits, 1 subagent spawn (`/log-sweep`). Confirmed mandate.
- **Max:** fold in the permissions plan via one `/permission-sweep` run — REJECTED: Autonomy Rule #8 gated, outside the confirmed scope.

## Autonomy Posture
Gated

**Stop points:**
- general #3 — if the investigation concludes a skill should be archived (Autonomy Rule #3 — file deletion).
- Session-end push — operator approval required (Autonomy Rule #2).
- log-sweep #2 — if entry-count verification surfaces unexpected archive scope.
- Any deferred-plan gate hit.

## Risk
No canonical structural change classes apparent — session-plan #1 edits an existing command file and log-sweep #1 edits an existing agent definition; neither is a canonical `/risk-check` change class per `docs/audit-discipline.md` (the class is "new commands or skills"). general #4 edits a JSON manifest; improvement-log items append to logs. Run `/risk-check` if scope changes. **Concurrent-session note:** a separate `/friday-act journal-commands` session is committing to `ai-resources` — stage specific paths on every commit, never `git add -A`; defer or scope the session-end push so it does not push that session's in-flight work.
