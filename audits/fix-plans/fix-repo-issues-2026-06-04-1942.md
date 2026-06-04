# Fix plan — 2026-06-04 19:42

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, project research-pe-regime-shift-advisory-gap
**Scanner notes (per scope):**
- ai-resources: [audits/working/fix-repo-issues-2026-06-04-1942-ai-resources.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-06-04-1942-ai-resources.md)
- project research-pe-regime-shift-advisory-gap: [audits/working/fix-repo-issues-2026-06-04-1942-project-research-pe-regime-shift-advisory-gap.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-06-04-1942-project-research-pe-regime-shift-advisory-gap.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 3

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `ai-resources/audits/fix-plans/fix-repo-issues-2026-06-04-1942.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [project-research-pe-regime-shift-advisory-gap/id-06] Project `logs/scripts/` stale vs canonical — bash-4 `mapfile` crashes every wrap on macOS bash 3.2
- **Scope:** project research-pe-regime-shift-advisory-gap — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md) (S1 entry, line 97)
- **Fix:** The project's `logs/scripts/split-log.sh` line 18 still uses `mapfile -t HEADERS < <(...)`, a bash-4.0+ builtin that fails under macOS default bash 3.2 (`mapfile: command not found`) — the wrap archive step crashes on every macOS wrap that exercises it. The canonical `ai-resources/logs/scripts/split-log.sh` was already made portable (uses a `while IFS= read -r` loop). The project's `check-archive.sh` is ALSO stale vs canonical — it is missing the date-guard (refuses to archive when the first dated entry is today's, preventing fresh-write clobber), the relative-path `PROJECT_DIR` derivation, and the `coaching-data.md` exclusion comment. **Action:** copy the canonical `split-log.sh` and `check-archive.sh` from `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/` over the project's stale copies. Before copying, `diff` each pair to confirm the only divergence is canonical-ahead drift (not a deliberate project fork) — verified at plan time: split-log.sh differs only at the mapfile→while-loop block; check-archive.sh differs only by the canonical-ahead features named above. Optionally `diff` the rest of the project's `logs/scripts/` against canonical and re-sync any other stale scripts found.
- **Post-fix log update:** Flip the `2026-06-04 (S1)` `split-log.sh`/`mapfile` friction-log entry to resolved (annotate: re-synced from canonical, bash-3.2 portable). The S2/S3 entries note the same recurrence — annotate them as covered by this fix.
- **QC needed:** no — script re-sync from verified-canonical source; confirm by re-running `bash logs/scripts/check-archive.sh` (or the wrap archive path) and observing no `mapfile: command not found`.

### [ai-resources/id-02] Innovation-registry `doc-scanner-agent` row stale — still `triaged:graduate` after S6 reversed verdict to KEEP-LOCAL
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/innovation-registry.md) (line 134)
- **Fix:** The `doc-scanner-agent` row carries `triaged:graduate`, but the S6 session (`45ce8f4 … E1 KEEP-LOCAL`) reversed that verdict to KEEP-LOCAL via a `/risk-check` (RECONSIDER) — `doc-scanner-agent` is N=1 (genuinely project-local to repo-documentation), and `auto-sync-shared.sh` would have fanned it out as symlinks into ~10 unrelated projects. Update the row's status from `triaged:graduate` to `KEEP-LOCAL` (or the registry's canonical equivalent), with a one-line note citing the S6 RECONSIDER reversal and the DR-7 second-consumer/N=1 rationale. Read a couple of adjacent KEEP-LOCAL rows first to match the exact status-token format used in the registry.
- **Post-fix log update:** This IS the log update (innovation-registry row flip). No separate improvement-log entry to flip.
- **QC needed:** no — single registry-row status correction; ground-truth is the S6 decision already recorded in `logs/decisions.md` / commit `45ce8f4`.

### [project-research-pe-regime-shift-advisory-gap/id-12] `/run-cluster` + `/run-sufficiency` Step 0 name a stale cluster-memos path literal
- **Scope:** project research-pe-regime-shift-advisory-gap — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/research-pe-regime-shift-advisory-gap/logs/improvement-log.md) (line 19)
- **Fix:** Both `.claude/commands/run-cluster.md` and `.claude/commands/run-sufficiency.md` name the stale literal path `analysis/1.1/cluster-memos-refined/` in their Step 0, which disagrees with the canonical `analysis/cluster-memos/1.1/` (per `reference/file-conventions.md` row 43 + Rule 2). Every run risks writing memos to the wrong directory; S2 worked around it by passing the canonical path explicitly to sub-agents. **Action:** update the Step 0 path literal in both command files to the canonical `analysis/cluster-memos/{section}/` form (prefer deriving from `file-conventions.md` over hardcoding, if the surrounding command text supports it). **Sync check first:** confirm whether these two project `.claude/commands/` files are local or synced from the `ai-resources/workflows/research-workflow/` template (compare with `diff`). If template-synced, apply the fix at the canonical template source and re-sync, so the next deploy does not re-introduce the stale literal.
- **Post-fix log update:** Flip the `2026-06-03` `/run-cluster + /run-sufficiency Step 0 stale path` improvement-log entry (project scope) to `**Status:** applied 2026-06-04` + `**Verified:**` per the canonical resolve-improvement-log schema.
- **QC needed:** yes (light) — run `/qc-pass` on the two edited command files to confirm the path change is internally consistent with `file-conventions.md` and did not break adjacent Step 0 references.

## Parked items (not this plan)

- [project-research-pe-regime-shift-advisory-gap/id-02 + id-13] Default autonomy overrode an explicit command-level Step 2.5 PAUSE in `/run-analysis` — reason: risk-check-class (changes `ai-resources/docs/autonomy-rules.md` semantics — making command-level PAUSE non-overridable is cross-cutting and governs every session)
- [project-research-pe-regime-shift-advisory-gap/id-11] Canonical `cluster-memo-refiner` 10-check vs project 6-check contract drift — reason: decision-needed (config-gate the extra 3 checks vs document the contract split)
- [project-research-pe-regime-shift-advisory-gap/id-14] Stage-4 skill text calls style reference "pre-provided" but project derives-and-locks it after Part 1 — reason: decision-needed (reconcile direction + target files unconfirmed at disposition)
- [project-research-pe-regime-shift-advisory-gap/id-09 + id-17] citation-converter subagent misclassifies auto-commit hook entries as prior-session — reason: needs-dedicated-session (pipeline-logic investigation)
- [project-research-pe-regime-shift-advisory-gap/id-07] session-plan filename omits date → cross-day same-marker collision (manual rename every reuse) — reason: risk-check-class (session-marker contract; visible live as `session-plan-S1/S2/S3.md` working-tree drift)
- [project-research-pe-regime-shift-advisory-gap/id-03, id-04, id-05] 3 untriaged innovation-registry entries (log-sweep.md, run-report.md project, run-report.md workflow) — reason: needs-/innovation-sweep
- [ai-resources/id-34] wrap-session Step 3.5 clobber false-negative for no-`/session-start` sessions — reason: risk-check-class (the standing carryover item; fold with the same-block id-14 date-rollover edit applied 2026-06-04)
- [ai-resources/id-01] S6 wrap: auto-bundle item with no deliverable entered the executable bundle before recognition — reason: needs-dedicated-session (process-guard design)
- [ai-resources/id-03] gate-calibration bright-line-review durable CLAUDE.md enforcement — reason: risk-check-class (gated CLAUDE.md edit)
- [ai-resources/id-35] Graduation verdicts recorded at wrap skip the DR-7/AP-7 second-consumer test (2 same-day instances) — reason: needs-dedicated-session
- [ai-resources/id-36] Pattern-to-watch: same-day multi-session unwrapped-notes → recovery-commit accumulation — reason: watch-only (its own disposition says no build this round)
- [ai-resources/id-04, id-05, id-14, id-37] 4 inbox build briefs (`/codex-dd`, workflow-diagnosis, `/audit-workflow`, `/repo-review`) — reason: needs-/create-skill
- [ai-resources/id-19 through id-33] ~15 improvement-log watch items from the prior SO-advisory batch (placement-verifier four-pipeline extension, `/pm` internal QC, change-shape classifier extraction, pre-spec consumer-inventory checklist, /risk-check Dimension 6, etc.) — reason: needs-dedicated-session (coherent batch; plan separately)
- [ai-resources/id-06 through id-13, id-15 through id-18] ~14 innovation-registry loose-end / pending-triage rows — reason: needs-/innovation-sweep

## Skipped items

- [project-research-pe-regime-shift-advisory-gap/id-08] 1M-context credit gate not pre-checked at session start — reason: already-resolved (today's commit `ff966cf` "fix(run-report): pin subagent dispatches to standard-context model" added a Subagent model policy block pinning every `/run-report` dispatch to a standard-context `model` override, which directly stops the 1M-context credit-gate stall this entry describes)
