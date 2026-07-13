# Risk Check — 2026-07-13

## Change

RR-03 — the wrap-note cut, as EXECUTED (uncommitted, in the working tree now). Retires `### Files Created` / `### Files Modified` from the canonical wrap note (8 blocks → 6) and `### Files Changed` from the workspace-root mirror (7 → 6). `### Decisions Made` is deliberately RETAINED in both. The run manifest's `files_changed` array (logs/runs/{date}-{marker}.json) becomes the session's SOLE file record.

Repointed as part of the change:
- The `--file` derivation in BOTH wrap copies now derives paths from conversation context directly. Previously it was transcribed from the very note blocks being deleted — this circular dependency was named "F1" by a prior session and is the core thing this change had to fix.
- The staging enumeration in both copies now enumerates from that same conversation-derived list (previously read off the note's file sections).
- Four downstream readers repointed at the manifest: .claude/agents/session-feedback-collector.md, .claude/agents/collaboration-coach.md, docs/session-value-audit-rubric.md, docs/commit-discipline.md.

EXECUTED FILES (6):
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md  (canonical)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md  (workspace-root mirror — PAIRED COPY, must move in lockstep)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-value-audit-rubric.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md

KNOWN RESIDUAL EXPOSURE (accepted by the authoring session, documented in-file): a session that dies before wrap, or whose manifest is absent, now has NO file record on EITHER surface — the wrap-time stub writes an empty `files_changed`, and the note no longer carries a list. Previously the note carried one.

AUTHORITY: ai-resources/plans/repo-redesign-authoritative-implementation-report.md § RR-03.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-value-audit-rubric.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/repo-redesign-authoritative-implementation-report.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The six executed edits are internally consistent, correctly scoped, and verified against `git status`/`git diff` (no scope creep) — but an independent workspace-wide grep found a real, live consumer the authoring session's ai-resources-scoped search missed: `collaboration-coach.md` (edited, now manifest-only) is symlinked into every project, including at least one active project (`positioning-research`) whose own `wrap-session.md` is a permanently un-migrated, non-symlinked fork that never adopted the run-manifest substrate — so that project's coaching signal silently degrades.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/wrap-session.md` (canonical) | co-edits | yes — edited (verified via `git diff`) |
| `.claude/commands/wrap-session.md` (workspace-root mirror) | co-edits | yes — edited (verified via `git diff`), paired-copy contract intact |
| `ai-resources/.claude/agents/session-feedback-collector.md` | parses (reads `files_changed` for the file record) | yes — edited |
| `ai-resources/.claude/agents/collaboration-coach.md` | parses (reads `files_changed` for draft-iteration counts) — also **invokes across every project** via `/coach` (PROJECT_ROOT-scoped) | yes — edited, but see finding below: the edit is incomplete for a real subset of its invocation contexts |
| `ai-resources/docs/session-value-audit-rubric.md` | documents (evidence-base description for the wrap outcome-check subagent) | yes — edited |
| `ai-resources/docs/commit-discipline.md` | documents (staging-enumeration guidance) | yes — edited |
| `ai-resources/skills/handoff/SKILL.md` | documents (different schema: `## Files Modified`, H2, in the *handoff scratchpad*, a different file — `logs/scratchpads/*.md`, not `session-notes.md`) | no — independently verified false positive, confirms the authoring session's judgment |
| `ai-resources/workflows/research-workflow/.claude/commands/wrap-session.md` | invokes (independent, non-symlinked, 33-line pre-manifest-era fork; declared `"local"` — never symlinked, never auto-synced — in this template's own `.claude/shared-manifest.json`) | no (not touched by RR-03) — **flagged**: every future project deployed from this template inherits the stale block-based design permanently |
| `projects/positioning-research/.claude/commands/wrap-session.md` | invokes (byte-identical to the research-workflow template's stale fork; confirmed via diff; project has no `logs/runs/` directory and no local `run-manifest.sh`) | **effectively yes — unresolved**: this is a live, real project (30KB `decisions.md`, 29KB `friction-log.md`, session notes through 2026-06-12) whose paired `collaboration-coach.md` (shared/symlinked, just edited) now points exclusively at a manifest this project can never produce |
| `ai-resources/output/deploy-test-scratch-2026-06-12/.claude/commands/wrap-session.md` | invokes (same stale fork) | no — low materiality, a deploy-test scratch artifact, not a live project |
| `ai-resources/.claude/commands/coach.md` | invokes `collaboration-coach.md`, resolving `PROJECT_ROOT` via `git rev-parse --show-toplevel` per-project (confirmed: `positioning-research` is its own nested git repo, so this resolves correctly to the affected project) | no direct edit needed — this is the delivery mechanism that carries the cross-project exposure |
| ~20 other project `.claude/commands/wrap-session.md` symlinks → canonical (verified via `find … -iname wrap-session.md`) | co-edits (auto-inherit via symlink) | no — automatically fixed, confirmed no action needed |
| `friday-checkup.md`'s Weekly Session Value Review roll-up | parses `### Session Value Audit — 80/20 Review` heading/labels | no — untouched, unaffected by this specific change (grep confirmed no hit on the retired headings) |

**Total: 12 distinct consumer rows, 6 confirmed must-change (all executed), 1 additional live consumer (`positioning-research`, via its paired `collaboration-coach.md`) effectively requires a follow-up fix that this change did not make.**

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change reduces future note bulk (8→6 / 7→6 blocks per session note), which `/prime` reads at every future session start — a net token-cost *improvement*, not a cost addition (`plans/repo-redesign-authoritative-implementation-report.md:100`: "14, 17 and 14 lines out of 52, 53 and 58" removed per note).
- No new hook registered, no new `@import`, no expansion of a frequently-spawned subagent brief — `session-feedback-collector.md` and `collaboration-coach.md` were repointed, not lengthened (confirmed via full `Read` of both).
- `wrap-session.md` is not always-loaded; it is invoked on demand.

### Dimension 2: Permissions Surface
**Risk:** Low

- `git status` on both repos (workspace root and `ai-resources`) confirms `.claude/settings.json` is not among the modified files in either checkout — no permission entries added, removed, or widened.
- The change is pure prose/instruction editing across 6 markdown files; no new Bash pattern, Write path, or external-API call is introduced.

### Dimension 3: Blast Radius
**Risk:** High

- Direct dependent-caller count from the Consumer Inventory: **4 repointed readers** (`session-feedback-collector.md`, `collaboration-coach.md`, `session-value-audit-rubric.md`, `commit-discipline.md`) plus the 2 wrap copies themselves = 6 edited files, matching the change description exactly (independently verified via `git status`/`git diff --stat` in both the workspace-root and `ai-resources` checkouts — no scope creep).
- **SCRUTINIZE (a) — did the change miss a live reader?** Yes. An independent, workspace-wide grep (not scoped to `ai-resources`, per the task's explicit instruction) found `ai-resources/workflows/research-workflow/.claude/commands/wrap-session.md` and `projects/positioning-research/.claude/commands/wrap-session.md` — two real, non-symlinked, 33-line pre-manifest-era forks of `wrap-session.md` that still write `### Files Created` / `### Files Modified` and have **no** `run-manifest.sh` integration at all (confirmed: `grep -n "run-manifest\|files_changed"` on both returns zero hits). `positioning-research` is a **live project** (30KB `decisions.md`, 29KB `friction-log.md`, session entries through 2026-06-12, its own nested `.git`) — not a hypothetical.
- **The contract break:** `collaboration-coach.md` (edited by this change) is declared `"shared"` in `research-workflow`'s `.claude/shared-manifest.json` — i.e. it **is** symlinked into `positioning-research` and every future research-workflow-deployed project — while `wrap-session` is declared `"local"` in the same manifest, meaning it is **permanently excluded** from auto-sync. So the edited agent propagates; the fix that would let it work does not, and never will via the existing sync mechanism.
- Concretely: `collaboration-coach.md` Dimension 1 ("Iteration Efficiency") now instructs the agent to count draft iterations exclusively from "the run manifest's `files_changed`" (`ai-resources/.claude/agents/collaboration-coach.md:47`). `positioning-research` has no `logs/runs/` directory (confirmed via `ls`) and never will under its current, un-synced `wrap-session.md`. Before this change, the same dimension read the note's `Files Created` block directly — data that project's session notes *do* still contain. The signal is now unreachable by the agent's documented read path for that project (and any future research-workflow deployment), even though the underlying data exists on disk.
- This is a **contract change that is not backwards-compatible** for a confirmed, live, out-of-declared-scope consumer — the defining High trigger for this dimension. It is not a hard crash (the agent's general Phase-1 fallback — "If a file doesn't exist, note it as a data gap and proceed" — means it degrades to "Insufficient data" rather than erroring or fabricating), but it is an undeclared, silent loss of a previously-available signal for a real project the authoring session's search did not surface.
- The authoring session's own SCRUTINIZE-(a) self-check found only `skills/handoff/SKILL.md` and correctly judged it a false positive (independently confirmed above: different heading level, different file, different schema). That search did not extend past `ai-resources/` and therefore could not find the `research-workflow` / `positioning-research` pair, which sit at the workspace root and inside `projects/`.

### Dimension 4: Reversibility
**Risk:** Medium

- The 6 edited files are pure content changes with no data mutation and no external-state writes — `git revert` (or a plain `git checkout -- <path>`) on all 6 fully restores the prior dual-record behavior. This part is clean (Low on its own).
- **SCRUTINIZE (b) — is it safe to make the manifest the sole record, given `close` is advisory/never-blocking?** The evidence base is thin but consistent: `run-manifest.sh` was first committed **2026-07-12** (`git log --diff-filter=A`), i.e. it has existed for **1 day** at the time of this change. `logs/runs/*.json` currently holds exactly 8 files (`2026-07-12-S1..S5`, `2026-07-13-S1..S3`), and `logs/session-notes.md` shows exactly 8 session headers in that same window (`## 2026-07-12 — Session S1..S5`, `## 2026-07-13 — Session S1..S3`) — an 8/8 match, consistent with the plan's own claim of "7/7" as of its writing (`plans/repo-redesign-authoritative-implementation-report.md:100`).
- That is a **100% close rate over a 2-day, 8-session sample** — reassuring but statistically thin. The mechanism (`close` writes a wrap-time stub and never blocks) is sound and the "advisory rule" is well-documented in `run-manifest.sh` itself, but the change is retiring the note's redundant safety net for a substrate proven only over ~48 hours of production use.
- The change's own text names and accepts the residual exposure explicitly ("a session that dies before wrap, or whose manifest is absent, now has NO file record on EITHER surface") — this is a real, if low-probability and now-orphaned-from-recovery, data-loss window that a code-level `git revert` cannot retroactively repair for any session that crashes during it. That combination (clean code revert + a real, accepted, not-git-recoverable data-loss edge case) is the definition of Medium rather than Low here.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **SCRUTINIZE (c) — paired-copy lockstep.** Independently re-read both wrap copies in full: the RR-03-specific language ("This is now the session's ONLY file record", the `### Decisions Made` retention rationale, the Step-12d/4.7 `--file` derivation note, the commit-step staging-enumeration note) is present and consistent in both, using copy-appropriate step numbers (canonical Step 12d / workspace-root Step 4.7) as the pre-existing paired-but-not-identical convention requires. No new divergence was introduced by this specific edit; the 2026-07-13 S1 divergence the task flagged (the `### Decisions Made` retention rule) was already reconciled in both copies before this change and remains reconciled. This sub-check passes clean.
- The one real implicit dependency: `collaboration-coach.md`'s new Dimension-1 instruction assumes the `run-manifest.sh` substrate is present wherever the agent is invoked (workspace-wide, via `/coach` across ~20+ `PROJECT_ROOT`s) — an assumption that is true for `ai-resources` and the workspace-root mirror but **not** documented as project-conditional at the change site, and **not** true for at least one confirmed live project (see Dimension 3). This is an undocumented new contract a cross-project consumer must now satisfy, but it is not silent: the agent's own general data-gap handling ("If a file doesn't exist, note it as a data gap and proceed with available data") surfaces the shortfall as "Insufficient data" rather than fabricating a wrong answer — which keeps this at Medium rather than High (the failure mode is honest, not silent).
- A secondary, minor coupling: the `--file` derivation for the manifest is now purely "conversation context," with the change's own text acknowledging "there is nothing to transcribe from and nothing to cross-check against" (`wrap-session.md:227`). This removes a cross-check that existed only incidentally (both surfaces being independently, redundantly hand-derived) — a real but narrow loosening, not a new failure mode.

### Dimension 6: Principle Alignment
**Risk:** Low

- Read `ai-resources/../CLAUDE.md` (workspace) and `ai-resources/CLAUDE.md` (repo) at Step 1; read `projects/strategic-os/ai-strategy/principles-base.md` (found and readable) for the frozen-ID index.
- **OP-9 / DR-7 / AP-7 (speculative abstraction):** not triggered — this change is *consolidation*, not generalization. It removes a duplicated, hand-maintained record (the note's file-list blocks) in favor of one that already existed and was proven (`run-manifest.sh`, shipped as R3 Pass 1, "7/7" success per the plan). No new component is built for an absent consumer; the manifest already had a confirmed consumer (the wrap outcome-check subagent) before this change.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7):** not applicable in the "new component" sense — no new command, agent, gate, or always-loaded doc is introduced. If anything, this clears prong (a) (net simplification: removes a load-bearing duplicated record while preserving the underlying capability via the manifest).
- **OP-5 (advisory vs. enforcement):** the manifest's `close` subcommand remains explicitly advisory / never-blocking, unchanged by this edit (`run-manifest.sh:15-23`, "THE ADVISORY RULE"). No enforcement upgrade occurred.
- **OP-12 (closure before detection):** not implicated — no new detection/scan capability is added.
- **OP-3 (loud failure over silent continuation):** the Dimension-3/5 findings above show a real signal-loss for one project, but it surfaces as an explicit "Insufficient data" report rather than a silently wrong answer — consistent with, not violating, OP-3.
- **DR-8:** this change is itself going through the required `/risk-check` — the gate this report exists to satisfy.
- No principle is clearly violated; the one live tension identified (the `collaboration-coach.md` cross-project gap) is a blast-radius/coupling finding, not a principle-alignment one — it does not map to any specific frozen-ID violation on its own. Low is warranted, not Medium, because the change's own design choices (advisory manifest, consolidation not speculation, honest data-gap reporting) are principle-*supportive*.

## Mitigations

- **(Dimension 3, High)** Before or shortly after landing: run `/sync-workflow` on `projects/positioning-research` to convert its local `.claude/commands/wrap-session.md` to a symlink onto the canonical copy (the project's own 2026-06-12 session note already names this as pending follow-up work — "Follow-up session: post-land `/sync-workflow` on positioning-research … convert now-identical copies back to symlinks"). This is the structural fix and closes the gap for the one confirmed live consumer.
- **(Dimension 3, High)** If `/sync-workflow` cannot run immediately, add one explicit fallback branch to `collaboration-coach.md`'s Dimension 1 instructions: "If `logs/runs/` is absent or empty for this `PROJECT_ROOT`, fall back to counting draft iterations from the session note's `### Files Created` block directly (present in projects whose `wrap-session.md` predates the manifest substrate)." This restores backward compatibility without re-adding the note-level duplication in the canonical/mirror pair.
- **(Dimension 3/5)** Note in the RR-03 execution record (`plans/repo-redesign-authoritative-implementation-report.md` § Results/Notes) that `research-workflow`'s `shared-manifest.json` permanently classifies `wrap-session` as `"local"` — so every *future* project deployed from that template will reproduce this same gap unless the template's own `wrap-session.md` is separately updated or `wrap-session` is reclassified `"shared"`.
- **(Dimension 4, Medium)** Track manifest-close reliability for another 1–2 weeks (a larger sample than the current 8 sessions) before treating the "advisory, never-blocking" substrate as fully proven; a natural checkpoint is `/friday-checkup` comparing `logs/runs/*.json` count against `logs/session-notes.md` header count and flagging any gap.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, `git status`/`git diff --stat` output, verbatim quotes from `CHANGE_DESCRIPTION` or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
