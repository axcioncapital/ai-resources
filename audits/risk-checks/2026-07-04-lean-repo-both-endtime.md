# Risk Check — 2026-07-04

## Change

END-TIME risk-check gate on the actually-shipped "Both, whole" change set (files now on disk, not yet committed). This is the batched end-time gate for a change whose PLAN-TIME gate returned RECONSIDER (Hidden coupling High, Principle alignment High), which the operator then explicitly overrode, directing the full legitimate build with the closure/waiver/opt-out pieces the gates required.

Shipped files:
1. docs/ai-resource-creation.md — NEW rule #7 "Complexity budget": no new command/agent/mandatory stage/permanent doc unless it clears prong (a) net-simplification OR prong (b) cited written evidence; includes a 5-question check; explicitly distinguished from docs/materiality-bar.md (which governs review findings, not creation); operationalizes AP-7/DR-7 + OP-12 at creation time; requires a new detector to ship its closure channel; states that a component introduced despite failing the gate is a loud recorded OP-11 exception in logs/decisions.md.
2. .claude/commands/leverage-idea.md — Step 6 enforcement cap: a recommended option introducing a new component must clear rule #7 or is capped at MARGINAL; explicitly labeled OP-5 enforcement (not advisory).
3. .claude/agents/risk-check-reviewer.md — a thin complexity-budget cross-reference appended to the Dimension-6 speculative-abstraction bullet, feeding rule #7's prong test into the EXISTING check (explicitly "not a separate check"). NOTE: this is your own definition; evaluate it as a shipped file.
4. .claude/agents/lean-repo-auditor.md — NEW audit subagent (disk-notes contract per ai-resources CLAUDE.md § Subagent Contracts; model opus; applies a leanness/control-drift lens; writes full notes to audits/working/, returns ≤30-line summary with NOTES: last line; never mutates).
5. .claude/commands/lean-repo.md — NEW diagnose-and-plan-only command (model opus; reads latest on-disk audit outputs and never re-runs audits; emits a disposition-grouped simplification plan to audits/lean-repo-{DATE}.md; never mutates the repo; includes a § Closure channel section and a self-referential OP-11 provenance note).
6. .claude/hooks/auto-sync-shared.sh — added the single token "lean-repo" to EXCLUDE_COMMANDS (opt-out from auto-distribution to the 21 downstream projects; consistent with existing meta-command exclusions pipeline-review/scope-project).
7. logs/decisions.md — a dated, loud OP-11 exception record for the command+agent: names the prong-(a) failure, justifies on prong (b) with cited evidence, records the closure + opt-out, and lists alternatives.

The plan-time RECONSIDER rested on: (a) command+agent fail prong (a) of their own budget gate (two net-new components, none removed); (b) OP-12 — a detector shipped without a closer; (c) duplication of /architecture-review's shape; (d) item 5 mis-targeted to risk-check.md. The shipped set addresses these via: a documented closure channel in lean-repo.md resolving OP-12; a recorded OP-11 waiver (logs/decisions.md) making the prong-(a) failure a loud decision, not drift; a distinctive-lens guardrail (3 questions + disposition output, vs architecture-review's severity synthesis) plus the EXCLUDE_COMMANDS opt-out reducing blast radius; and item 5 retargeted to risk-check-reviewer.md as a thin cross-ref.

Assess whether the shipped legitimacy pieces reduce Hidden coupling and Principle alignment to an acceptable end-time level, and give a verdict. CRITICAL per your own Step 7 special handling: a High on Dimension 6 that LOUDLY acknowledges the principle revision as an explicit recorded decision is scored Medium/Low, NOT High — check whether the logs/decisions.md OP-11 waiver qualifies as that loud acknowledgment. Also fold in a blindspot check: does the closure channel actually close (is /friday-act / a risk-check-gated execution session a real, reachable path for lean-repo's output), and is there real-usage fit (will the command plausibly be invoked, or is it itself an orphan-in-waiting)?

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/leverage-idea.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/lean-repo-auditor.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/lean-repo.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/materiality-bar.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/architecture-review.md — exists (neighbour for the duplication check)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The shipped legitimacy pieces (loud OP-11 waiver, real closure channel, single-source-of-truth opt-out, documented boundary guardrail) successfully bring BOTH plan-time Highs down to Medium — four Mediums / zero Highs — leaving a controllable residual on reversibility ordering and, most materially, an unmonitored adoption risk (the command has no cadence/auto-invoker and is an orphan-in-waiting by its own admission).

## Consumer Inventory

Search terms: `lean-repo`, `lean-repo-auditor`, `complexity budget` / `rule #7`, `ai-resource-creation`, `leverage-idea`, `risk-check-reviewer`, `EXCLUDE_COMMANDS`. Grep run across `ai-resources/`, `projects/`, `workflows/`, and workspace-root `CLAUDE.md`. The overwhelming majority of raw hits are historical audit reports, consultation records, scratchpads, and log archives (non-consumers). Rows below are the distinct **live functional** consumers.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/hooks/auto-sync-shared.sh | co-edits (opt-out list) | yes — shipped as item 6 |
| ai-resources/.claude/commands/fix-symlinks.md | parses (reads `EXCLUDE_COMMANDS` from the hook via `sed`, lines 80–82) | **no — auto-adapts** |
| ai-resources/.claude/commands/lean-repo.md | invokes (spawns lean-repo-auditor; parses its `NOTES:` marker) | yes — the command itself, item 5 |
| ai-resources/.claude/agents/lean-repo-auditor.md | invokes (paired agent) | yes — co-shipped item 4 |
| ai-resources/docs/ai-resource-creation.md (rule #7) | documents (source of the contract the wiring honors) | yes — the change, item 1; existing doc consumers: no |
| ai-resources/.claude/agents/risk-check-reviewer.md | imports (Dimension-6 cross-ref to rule #7) | yes — the change, item 3; its invoker risk-check.md: no |
| ai-resources/.claude/commands/leverage-idea.md | imports (Step 6 cap cites rule #7) | yes — the change, item 2; its consumers: no |
| ai-resources/logs/decisions.md | documents (OP-11 waiver record) | yes — the change, item 7 |
| ai-resources/.claude/commands/friday-act.md | documents (closure channel lean-repo output routes to) | no — generic diagnose→execute path already exists |
| ai-resources/.claude/commands/architecture-review.md | imports (lean-repo reads its output; delineates boundary against it) | no — read-only + boundary only |

External existing consumers of the edited files that reference them generally and are **unaffected** by the additive edits (must-change = no): risk-check.md (agent invoker), placement.md, docs/onboarding-daniel.md, docs/repo-architecture.md, docs/agent-tier-table.md, projects/axcion-ai-system-owner/references/toolkit-relationship.md, workspace CLAUDE.md § AI Resource Creation pointer.

**Total: 10 live consumers, 7 must-change — and all 7 are the shipped files themselves. ZERO external consumers require modification.** The one consumer that could have required a paired edit (`fix-symlinks.md`) reads the exclusion list straight from the hook (single source of truth) and auto-adapts. Verified: no `lean-repo`/`lean-repo-auditor` symlink has leaked into any of the 18 shared-manifest downstream projects (`find projects -name lean-repo*.md` → none).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added. None of the 7 shipped files is a CLAUDE.md; `ai-resources/git status` confirms the touched files are the two new components, three additive doc/agent edits, the hook, and the decisions log — no per-turn context growth.
- `docs/ai-resource-creation.md` is a read-on-demand doc, not always-loaded — its own header (line 3): "**When to read this file:** When a session identifies the need for a new or modified AI resource." Rule #7 (~14 lines) adds zero per-turn tokens.
- New command + agent are pay-as-used: `/lean-repo` is invoked on demand; `lean-repo-auditor` is spawned only by that command (lean-repo.md Step 3). No hook, no cadence entry, no auto-load.
- The only auto-firing touch is `auto-sync-shared.sh` (SessionStart) — but the edit ADDS one token to an existing list (`EXCLUDE_COMMANDS="… scope-project lean-repo"`, line 46); no new hook is registered and the marginal cost is negligible.
- `/lean-repo` is excluded from auto-distribution, so it does not even add 18 symlink files across projects.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json / settings.local.json change in the shipped set. The only pre-existing risk-check-reviewer reference in settings.local.json is `"Bash(ls .claude/agents/risk-check-reviewer.md)"` — unchanged.
- `lean-repo-auditor.md` declares `tools: Read, Write, Bash, Glob, Grep` (lines 5–10) — the same toolset already established for audit subagents (`token-audit-auditor`, `repo-dd-auditor`, `risk-check-reviewer` per ai-resources CLAUDE.md § Subagent Contracts). Its Write is constrained to `NOTES_PATH` in the agent body (line 73: "Do not edit, create, or delete any file other than `NOTES_PATH`"). No new permission grant required.
- The hook edit NARROWS distribution (adds an exclusion) — if anything it reduces surface, not widens it.
- `/lean-repo` reads a cross-repo path (`../projects/axcion-ai-system-owner/output/architecture-reviews/…`, lean-repo.md Step 2) but read-only; cross-workspace reads are already established via `--add-dir`. No new write capability introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Directly touches 7 files; the Step-1.5 inventory found **10 live consumers, 7 must-change — all 7 being the shipped files themselves.** No external consumer requires modification.
- The single external consumer that parses the edited hook's contract — `fix-symlinks.md` — reads `EXCLUDE_COMMANDS` directly from the hook (`sed -n 's/^EXCLUDE_COMMANDS="\(.*\)"$/\1/p'`, lines 80–82) rather than hardcoding it, so the new `lean-repo` token flows through automatically. The edited line is single-line double-quoted and still matches that regex. No drift, no paired edit needed — verified.
- New contract introduced: rule #7 (the complexity-budget gate), now honored by three components (`risk-check-reviewer` Dimension 6, `leverage-idea` Step 6, `lean-repo-auditor` Q2). All three were shipped in lockstep, so the contract's consumers are wired atomically — no dangling consumer.
- Shared infra touched: `auto-sync-shared.sh` (the SessionStart distribution hook, read by every project session and by `fix-symlinks`). This is why the dimension is Medium not Low. But the edit is contained: opt-out only, `fix-symlinks` auto-syncs, and no symlink has leaked into the 18 shared-manifest projects.
- No inventory consumer was surprised — every functional dependency was anticipated by the shipped set. Score: Medium (a new contract + shared-infra touch, all consumers compatible), not High (no external caller must change; hook edit verified contained).

### Dimension 4: Reversibility
**Risk:** Medium

- Base case is clean-ish: `git checkout` the 5 modified files + `rm` the 2 new files (`lean-repo.md`, `lean-repo-auditor.md`) restores prior state. Commits are still local (`git status` shows all 7 uncommitted) — nothing has propagated beyond git (no push, no external write).
- **Append-only-log caveat:** `logs/decisions.md` carries multiple 2026-07-04 entries that landed in prior commits (worktree-flow disposition, reconcile-activate, wrap-session refactor). A wholesale file revert would wrongly remove those. Undoing this change requires **surgical removal of only the "2026-07-04 — `/lean-repo` + `lean-repo-auditor` shipped under a loud OP-11 …" block** (decisions.md lines 5–17), not a file-level revert. One extra manual step.
- **Automation-ordering caveat:** if the hook exclusion is reverted while `lean-repo.md` still exists, the next SessionStart would START distributing `/lean-repo` to the 18 projects (auto-sync-shared.sh fires per session). A correct rollback must `rm` the command+agent BEFORE (or atomically with) reverting the hook line — otherwise the automation fires between the change landing and the revert. This is the "adds automation that could fire between change and revert" flag (risk-check Step 5). Bounded and predictable, but order-dependent.
- Two extra cleanup considerations, no state beyond git → Medium (not Low; not High because the steps are known, bounded, and local).

### Dimension 5: Hidden Coupling
**Risk:** Medium (down from plan-time High)

- **Plan-time concern (c) — functional overlap with `/architecture-review` — is now bounded and documented at the change site.** `lean-repo.md` carries an explicit "Boundary vs neighbours" section (line 13: applies "one lens none of them do … a *disposition-grouped plan* … not a severity-ranked findings list") and a Guardrail (line 120: "The three questions are the boundary … route it there, don't restate it here"), plus a retirement path (line 15: "fold it into `/architecture-review` and retire this command"). Per the Dimension-5 heuristic, a new-but-documented contract at the change site is Medium, not High.
- **Silent dependency on sibling audit filename conventions:** `lean-repo` Step 2 globs `token-audit-*.md`, `repo-health-*.md`, the arch-review path, `pipeline-reviews/*.md`, `friday-checkup-*.md`. If any producer renames its output, lean-repo's glob silently misses it — but it degrades to `MISSING` with a degraded-mode header (lean-repo.md line 43; lean-repo-auditor.md Rule "If an input is MISSING, note the gap"), so the failure is loud, not silent. Mitigated by design.
- **NOTES: last-line contract** between `lean-repo.md` (Step 3 parse) and `lean-repo-auditor.md` (line 71) is fully specified at both ends and matches the established Subagent-Contract convention — low residual.
- **Doc-to-doc cross-refs** (`risk-check-reviewer` Dimension 6 and `leverage-idea` Step 6 both cite "`docs/ai-resource-creation.md` rule #7"): a rename/renumber of rule #7 would break the citation. Explicit and documented, but a real coupling — the item-5 retarget (to `risk-check-reviewer.md`, kept as a cross-ref "not a separate check", verified present at line 166 of the agent) is the clean form of this.
- Multiple couplings, but each is documented at the change site or degrades loudly. Not Low (genuine functional overlap with arch-review + 5 silent convention dependencies), not High (all bounded/documented) → Medium.

### Dimension 6: Principle Alignment
**Risk:** Medium (down from plan-time High — the loud OP-11 waiver qualifies)

Principles-base read and applied: `projects/strategic-os/ai-strategy/principles-base.md` (OP-5, OP-9, OP-10, OP-11, OP-12, AP-7, DR-1/DR-3/DR-7).

- **OP-9 / AP-7 / DR-7 (speculative abstraction / complexity budget) — the crux.** `/lean-repo` + `lean-repo-auditor` are two net-new components that **fail prong (a)** of rule #7 (they add components, remove none) — the exact zero-net-simplification signal. On its face this is the plan-time High.
- **The loud OP-11 acknowledgment converts it out of High.** Per my own Step 7 special handling ("A High on Dimension 6 that *does* loudly acknowledge the revision … is not a violation — score it Medium or Low with a note, not High"), I checked the `logs/decisions.md` 2026-07-04 entry against every OP-11 criterion:
  - Dated + in the canonical Decision Journal, not an inline "it's fine" assertion ✓ (lines 5–17).
  - Names the specific failure: "two net-new components that **fail prong (a)** of their own rule #7 (they add components and remove none)" ✓.
  - Justifies on prong (b) with **cited written evidence**: `friction-log.md` 2026-07-02 `/tech-consult` orphan; `coaching-log.md` "shipping capabilities faster than adopting them"; over-control; CLAUDE.md over its line target ✓.
  - Records the OP-12 closer + the distribution opt-out ✓; lists three alternatives ✓; records who decided (operator explicit override) ✓.
  - Self-referenced at the point of use (lean-repo.md provenance header, line 15, points back to the decisions.md entry) ✓.
  This is a textbook loud, recorded OP-11 exception — it satisfies OP-11's "explicit, recorded evolution, never silent drift." Therefore Dimension 6 is **not** a violation; it is scored Medium, not High.
- **OP-12 (closure before detection) — satisfied, verified real.** `lean-repo.md` ships a "Closure channel" section (lines 104–112) routing structural items to a `/risk-check`-gated execution session / `/friday-act`. Blindspot check: **the closer exists** — `friday-act.md` is present on disk (36KB command, verified). The path is reachable, not vaporware. Caveat: `friday-act` does not yet *name* lean-repo as an input, so the bridge is one-directional (lean-repo → friday-act by convention, mirroring how `/token-audit` and `/architecture-review` hand off to a separate session). Acceptable for OP-12; wiring lean-repo into friday-act's input list would upgrade convention to a wired path.
- **OP-5 (advisory vs enforcement) — new enforcement point, but loud and per-component.** `leverage-idea` Step 6 adds an enforcement cap (fail rule #7 → capped at MARGINAL), explicitly labeled "enforcement, not advisory" (leverage-idea.md line 124) and recorded in decisions.md. OP-5 requires enforcement authority to be an "explicit per-component decision" — this is exactly that. Loud, not a silent upgrade. No violation.
- **OP-10 (system boundary) — clean.** Nothing extends reach beyond Claude Code; no GPT/Perplexity/Notion/NotebookLM governance introduced.
- **DR-1 / DR-3 (placement) — clean.** Command in `.claude/commands/`, agent in `.claude/agents/`, doctrine in `docs/`, waiver in `logs/` — every artifact in its canonical home.
- **Why Medium and not Low:** the principle *tension* is real and ongoing — the components still fail prong (a); the waiver records the decision to bear that cost, it does not erase it. Coupled with the unmonitored adoption risk (see below), the change sits in tension-but-acknowledged territory = Medium.

**Blindspot — real-usage fit (orphan-in-waiting):** this is the strongest residual signal. `/lean-repo` has **no auto-invoker and no cadence wiring** — it is absent from ai-resources CLAUDE.md § Maintenance Cadence (contrast `/pipeline-review`, which is named there "once per week"), from every hook, and from friday-act's input list. It is operator-memory-invoked only. Its own provenance header concedes the risk ("If a future review finds the lens is used rarely, the lean move is to fold it into `/architecture-review` and retire this command"). Additionally, one of its five inputs is currently unavailable: the `architecture-reviews/` output dir is **empty** (`ls` → total 0), so lean-repo's first run degrades on that input. Honest self-acknowledgment does not eliminate the risk — it just documents it. This is the primary reason the verdict is PROCEED-WITH-CAUTION rather than GO.

## Mitigations

Verdict is PROCEED-WITH-CAUTION with zero High dimensions; the following are paired actions on the Medium dimensions that carry a named residual. Apply before/at commit.

- **(Dimension 4 — Reversibility) Record the rollback order in the commit message or a one-line rollback note:** to undo, `rm .claude/commands/lean-repo.md .claude/agents/lean-repo-auditor.md` *before* reverting the `EXCLUDE_COMMANDS` line in `auto-sync-shared.sh` (else the next SessionStart re-distributes the deleted command to 18 projects), and surgically delete only the 2026-07-04 lean-repo OP-11 block from `logs/decisions.md` (lines 5–17) rather than reverting the whole file, which carries other same-day entries.
- **(Dimension 6 / adoption — the orphan-in-waiting) Give the command a concrete review trigger before it can drift into the exact orphan its doctrine warns against:** either wire `/lean-repo` into a real recurring cadence (e.g., a `/friday-checkup` quarterly-tier step, or an ai-resources CLAUDE.md § Maintenance Cadence line), OR log a dated `improvement-log.md` review-cycle entry (concrete date/quarter) to check its invocation count and, if unused, execute the self-declared "fold the three questions into `/architecture-review` and retire" path. Do not leave adoption unmonitored.
- **(Dimension 6 / OP-12 closure — optional hardening) Upgrade the closure bridge from convention to wired:** add `/lean-repo` output (`audits/lean-repo-*.md`) to `friday-act`'s input-glob list so the closer explicitly ingests the plan, rather than relying on the operator to carry it into a separate session by memory.
- **(Dimension 5 / first-run readiness) Before the first real `/lean-repo` run, populate its input corpus** (run `/audit-repo`, `/token-audit`, and `/architecture-review` so the currently-empty `architecture-reviews/` dir and the other four inputs are `fresh`), or accept and note the degraded-mode header on the first pass.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (auto-sync-shared.sh line 46, lines 80–82; fix-symlinks.md lines 80–82; lean-repo.md lines 13/15/43/104–112/120; lean-repo-auditor.md lines 5–10/71/73; risk-check-reviewer.md line 166; leverage-idea.md line 124; ai-resource-creation.md line 3; decisions.md lines 5–17), grep counts across ai-resources/projects/workflows/CLAUDE.md, filesystem checks (`git status --short` on ai-resources; `find projects -name lean-repo*.md` → none; `ls architecture-reviews/` → empty; `ls friday-act.md` → present), and verbatim quotes from the referenced files and CHANGE_DESCRIPTION. No training-data fallback was used on any read.
