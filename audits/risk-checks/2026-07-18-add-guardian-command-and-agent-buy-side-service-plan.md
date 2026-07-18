# Risk Check — 2026-07-18

## Change

Plan-time gate for an approved implementation plan. Add a new project-local command `.claude/commands/guardian.md` (frontmatter: `friction-log: true`, `model: sonnet`) in the `buy-side-service-plan` project. It orchestrates three EXISTING project-local review agents — `qc-reviewer-buy-side`, `strategic-critic`, `service-designer` — dispatching them in parallel, directly by name (not via their own commands `/content-review`, `/challenge`, `/service-design-review`, so their QC→Triage auto-fix/auto-promote loops never fire). It then dispatches one NEW project-local agent, `.claude/agents/service-model-guardian.md` (frontmatter: `model: opus`, tools: Read, Glob, Grep, Write), which does two things: (1) independent judgment on two dimensions no existing reviewer covers — cumulative drift of a `parts/` draft against `context/content-architecture.md` + `context/mandate-rubric.md`, and value-add/existence-justification (explicitly narrowed to cede passage-level "repeats approved text" redundancy to `qc-reviewer-buy-side` Criterion 7, which already covers it — verified: Criterion 7 reads "Does this section contradict or repeat content in other approved sections?"); (2) mechanical consolidation of all four verdicts into one advisory report written to `logs/guardian-reports/{date}-{slug}.md` (new directory), plus a one-line index row appended to `logs/guardian-log.md` (new file). The command is advisory-only by design: it never edits the reviewed target, never promotes to `approved/`, never triggers the existing QC→Triage auto-loop, and blocks nothing — it only writes to the two new log paths. Every invocation runs the full 4-subagent pipeline (3 on opus) — no caching/mode-switching logic, by deliberate design choice after an earlier LIGHT-mode idea was dropped for being overengineered.

Two additional edits ride in the same change: (a) `CLAUDE.md` (project-level, always-loaded) gets a new 3-line "Guardian Auto-Invoke" subsection instructing Claude to proactively run `/guardian {path}` after finishing a substantive `parts/` addition, unless `/guardian` already ran on that exact draft this session — advisory nudge only, does not block. (b) `reference/file-conventions.md`'s Canonical Naming Standard table gets two new rows: one for the new `logs/guardian-reports/` pattern, and a piggyback fix adding the row for the pre-existing (already-shipped) `logs/reconcile-reports/` directory used by `/reconcile`, which the table was missing.

Verified premises (already checked, do not re-verify): `.claude/agents/qc-reviewer-buy-side.md`, `strategic-critic.md`, `service-designer.md` all exist project-locally; `context/content-architecture.md` and `context/mandate-rubric.md` exist and are ratified; Criterion 7's exact wording confirmed; `reference/file-conventions.md` confirmed to have no `reconcile-reports` row; none of `logs/guardian-reports/`, `logs/guardian-log.md`, `.claude/commands/guardian.md`, `.claude/agents/service-model-guardian.md` exist yet (nothing built — this is the plan-time gate).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/guardian.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/agents/service-model-guardian.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/reference/file-conventions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/agents/qc-reviewer-buy-side.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/agents/strategic-critic.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/agents/service-designer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/content-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/context/content-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/context/mandate-rubric.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/logs/guardian-reports/ — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/logs/guardian-log.md — not yet present

## Verdict

RECONSIDER

**Summary:** The change is technically low-permission-risk and reversible-ish, but its central justification — "no existing reviewer covers" cumulative-drift-vs-mandate and value-add checking — is contradicted by direct reads of `/contract-check` and `/reconcile`/`reconcile-reviewer`, which already cover materially overlapping ground against the same `context/mandate-rubric.md`, and it introduces a new 4-subagent, Opus-heavy, proactively-self-triggered component with zero current consumers and no cited failure evidence, which fails the repo's own complexity-budget gate without a recorded OP-11 exception.

## Consumer Inventory

Search terms used: `guardian`, `service-model-guardian`, `qc-reviewer-buy-side`, `strategic-critic`, `service-designer`, `logs/guardian-reports`, `logs/guardian-log.md`, `reconcile-reports`, `Canonical Naming Standard`. Searched `ai-resources/`, workspace root (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`, which recursively includes `projects/buy-side-service-plan/`), `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `reference/`, `logs/`.

`guardian` and `service-model-guardian` return **zero hits** anywhere in the repo except an unrelated `brand-guardian` agent in a different project (`axcion-design-studio`) — confirming the new contract markers have no current consumers. The rows below are the consumers of the *existing* components the change wires into or functionally overlaps with.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/content-review.md:9` | invokes `qc-reviewer-buy-side` (same agent guardian will dispatch directly, bypassing this command's QC→Triage loop) | no |
| `.claude/commands/challenge.md:11` | invokes `strategic-critic` (same agent guardian will dispatch directly) | no |
| `.claude/commands/service-design-review.md:11` | invokes `service-designer` (same agent guardian will dispatch directly) | no |
| `.claude/commands/compile-wiki.md:59` | invokes `qc-reviewer-buy-side` independently for wiki QC (unrelated purpose, unaffected) | no |
| `.claude/shared-manifest.json` (agents.local: qc-reviewer-buy-side, reconcile-reviewer; commands.local: reconcile, review, …) | documents/registers project-local commands/agents; `guardian` and `service-model-guardian` are absent from both lists | recommended, not required (see Dimension 3) |
| `reference/stage-instructions.md:174-182` | documents the mandatory 3-layer pre-approval sequence (`/review`→`/challenge`→`/service-design-review`); does not mention `/guardian` | no (functions without it, but creates a split source of truth on "what gates approval") |
| `.claude/commands/contract-check.md` (canonical, symlinked in) + `.claude/commands/reconcile.md` / `.claude/agents/reconcile-reviewer.md` | functionally overlapping — both already read/target `context/mandate-rubric.md`; `/contract-check` can take `context/content-architecture.md` directly as its contract argument | no (see Dimensions 6/7 — this is the core finding) |
| `.claude/hooks/detect-innovation.sh` | passively auto-registers new `.claude/commands/*` and `.claude/agents/*` files into `logs/innovation-registry.md` on Write — will fire automatically when `guardian.md`/`service-model-guardian.md` are created | no (already handles this) |
| `.claude/hooks/log-write-activity.sh` | will log the new agent's report writes to `logs/friction-log.md` if a friction session is active (guardian.md sets `friction-log: true`, which auto-starts one) | no |

Total: 9 consumers found, 0 strictly must-change (1 soft/recommended: `shared-manifest.json` for registry completeness). This is not an empty inventory — it is a *populated-but-non-blocking* inventory, which is itself informative: nothing downstream requires modification for the change to run, but two existing commands (`/contract-check`, `/reconcile`) already occupy the analytical territory the change claims is uncovered.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** High

- The new "Guardian Auto-Invoke" subsection adds prose to `CLAUDE.md`, which is always-loaded every session in this project (per the file's own frontmatter framing and workspace `CLAUDE.md` § CLAUDE.md Scoping). Described as "3-line" — within the ~50-150 token Medium band on size alone.
- The larger driver: the subsection instructs Claude to *proactively* (not on operator request) dispatch a 4-subagent pipeline — 3 of them Opus-tier (`strategic-critic: model: opus`, `service-designer: model: opus`, `service-model-guardian: model: opus` per the change description) plus one Sonnet (`qc-reviewer-buy-side`) — "after finishing a substantive `parts/` addition." Drafting `parts/` content is this project's core, high-frequency activity (file-conventions.md's own example is `2.8-draft-15.md` — a 15th iteration on one section), so this self-triggering condition will fire often during active drafting sessions.
- CHANGE_DESCRIPTION states explicitly: "Every invocation runs the full 4-subagent pipeline (3 on opus) — no caching/mode-switching logic, by deliberate design choice." There is no throttle beyond "unless `/guardian` already ran on that exact draft this session" — a new draft iteration re-triggers the full pipeline.
- This matches the High heuristic bullet directly: "adds a frequently-spawned subagent with an oversized brief" — here, three frequently-spawned Opus subagents plus one Sonnet subagent, self-triggered by Claude's own judgment rather than gated to operator request.

### Dimension 2: Permissions Surface
**Risk:** Low

- New agent tools (`Read, Glob, Grep, Write`) are a strict subset of already-granted project capabilities. `projects/buy-side-service-plan/.claude/settings.json` already sets `"defaultMode": "bypassPermissions"` and globally allows `Write`, `Read`, `Edit`, `Bash(*)`, `Agent` at the project level — the new agent introduces no capability the project doesn't already grant broadly.
- The `Write` capability matches the established pattern of the sibling `reconcile-reviewer.md` agent (also `tools: Read, Write, Bash, Glob, Grep`, also writes advisory reports to a `logs/*-reports/` subdirectory).
- No `deny` rule is narrowed or removed, no scope escalation (project stays project-scoped throughout), no new external/cross-repo capability introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct touches: 2 new files created (`guardian.md`, `service-model-guardian.md`), 2 new log paths created (`logs/guardian-reports/`, `logs/guardian-log.md`), 2 existing shared-infra files edited (`CLAUDE.md`, `reference/file-conventions.md`).
- Per the Step 1.5 inventory: 9 consumers found, 0 strictly must-change, 1 soft/recommended (`shared-manifest.json`). No caller is broken by this change — it is additive at every call site.
- However, three existing commands (`content-review.md`, `challenge.md`, `service-design-review.md`) each own a single canonical invocation path to their respective agent; the change adds a **second, parallel invocation path** to all three agents via `guardian.md`, with materially different post-processing (no QC→Triage loop, no promotion). This doesn't force those commands to change, but it does mean the same underlying review logic is now reachable two different ways with two different behaviors — a shared-infra consistency risk, not a breakage risk.
- `reference/file-conventions.md`'s Canonical Naming Standard table is read broadly (by any command following Rule 3's "unknown artifact protocol") — editing it is low-risk (pure addition) but it is genuinely shared infrastructure.
- Not High: no caller requires modification, no contract change breaks backward compatibility, and the touched shared infra (CLAUDE.md, file-conventions.md) receives only additive edits.

### Dimension 4: Reversibility
**Risk:** Medium

- The two new command/agent files and the two CLAUDE.md/file-conventions.md edits are pure additions — a plain `git revert` of the landing commit fully restores prior state for all four.
- `projects/buy-side-service-plan/.claude/settings.json`'s `PostToolUse` Write hook auto-commits writes matching `/(preparation|execution|analysis|report|parts)/` in the path — `logs/` is **not** in that regex, so writes to `logs/guardian-reports/*.md` and `logs/guardian-log.md` will **not** be auto-committed. Once the feature is used, generated reports and log rows will sit as uncommitted/untracked state (or get manually committed later), meaning a later `git revert` of the landing commit removes the command/agent but leaves behind orphaned reports and log rows with no owning command — a stale-artifact cleanup step git alone doesn't perform.
- `.claude/hooks/detect-innovation.sh` will auto-append an entry to `logs/innovation-registry.md` the moment `guardian.md`/`service-model-guardian.md` are written (it fires on any Write under `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`) — another append-only log mutation a plain revert doesn't clean up.
- Not High: no push, no external-system writes, no operator muscle-memory dependency beyond remembering to clean two log paths — one extra, well-defined cleanup step, matching the Medium band exactly.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Undocumented cross-agent verdict contract.** Guardian's "mechanical consolidation of all four verdicts" implicitly depends on the exact verdict vocabulary of three independently-owned agents: `qc-reviewer-buy-side.md:40` (`PASS / CONDITIONAL PASS / REVISE`), `strategic-critic.md:37` (`ROBUST / CHALLENGED / EXPOSED`), `service-designer.md:78` (`WORKS / FRICTION / BROKEN`). None of these three files declares its verdict vocabulary as a shared, versioned contract — each is currently interpreted only by its own paired command (`content-review.md`, `challenge.md`, `service-design-review.md`). The new agent becomes a silent fourth consumer of all three vocabularies with no test or reviewer positioned to catch a future label change in any of them.
- **Duplicate invocation paths, divergent behavior.** Guardian dispatches `qc-reviewer-buy-side`, `strategic-critic`, `service-designer` "directly by name," explicitly bypassing the QC→Triage auto-loop each agent's canonical command applies (`content-review.md:13-16`, `challenge.md:15-18`, `service-design-review.md:15-18`). Two call sites now exist for the same review logic with different consequences (one can auto-promote to `approved/`, the other never does) — the exact "two systems both try to handle the same concern" pattern this dimension flags.
- **Functional overlap with two already-shipped mechanisms.** Guardian's stated novel-coverage claim overlaps with `.claude/commands/contract-check.md` (already compares an artifact against an explicit contract file — `contract-check.md:16-19`'s input grammar takes a path directly, so `/contract-check context/mandate-rubric.md` or `/contract-check context/content-architecture.md` already performs a materially similar check) and with `.claude/agents/reconcile-reviewer.md` (Step 4, "Genericness Check" — a substitution test against the same `context/mandate-rubric.md`). See Dimension 7 for the full re-derivation.

### Dimension 6: Principle Alignment
**Risk:** High

Grounded against `ai-resources/docs/ai-resource-creation.md` rule #7 (Complexity budget) and `projects/strategic-os/ai-strategy/principles-base.md` (both read successfully).

- **Rule #7 prong (a) — net-simplification: fails.** The change adds 1 new command, 1 new agent, and 1 new always-loaded CLAUDE.md subsection; it removes or consolidates nothing.
- **Rule #7 prong (b) — evidenced-failure: fails.** No `logs/friction-log.md`, `logs/defect-log.md`, `logs/coaching-log.md`, or `logs/incident-log.md` citation is offered. Direct greps of `logs/decisions.md`, `logs/session-notes.md`, and `logs/friction-log.md` for `guardian`, `LIGHT-mode`, `cumulative drift`, `value-add`, and `existence-justification` return **zero hits** — the claimed need is asserted, not evidenced. Per rule #7's own text: "A net-additive component leaning only on 'it'll be useful' fails prong (a) and, absent cited evidence, fails (b) too → High here, unless the addition is a loudly-recorded OP-11 exception in `logs/decisions.md`." No such exception exists.
- **Rule #7 question 5 fires directly:** "Does an existing component already do this, or ~80% of it? (If yes → extend it, don't add.)" — see Dimension 7: `/contract-check` and `/reconcile`/`reconcile-reviewer` already cover materially overlapping ground against the same `context/mandate-rubric.md`.
- **OP-9 / AP-7 / DR-7 (speculative abstraction — `principles-base.md` lines 27, 31, 60).** The Step 1.5 inventory found **zero current consumers** of the new `guardian` / `service-model-guardian` contract markers — the explicit speculative-abstraction signal this dimension is built to catch.
- **No loud OP-11 acknowledgment.** OP-11 (`principles-base.md` line 33, 49) permits deliberately revising a guardrail, but only as an explicit, recorded decision. Nothing in the change touches `logs/decisions.md` to record this as a conscious complexity-budget exception; it reads as a straightforward net-additive build.
- This is a clear, unacknowledged violation — not a Medium tension — so per Step 7's special handling this cannot be paired down to PROCEED-WITH-CAUTION.

### Dimension 7: Problem Reality
**Risk:** High

- **Defect claim identified.** CHANGE_DESCRIPTION asserts a missing-coverage defect: "independent judgment on two dimensions no existing reviewer covers." This is a "missing/unwired" claim per the gate's own trigger language, so Dimension 7 applies in full — it is not a bare capability addition.
- **Defect — observed or inferred?** I directly opened and read the full text of `.claude/commands/contract-check.md`, `.claude/commands/reconcile.md`, and `.claude/agents/reconcile-reviewer.md` (not merely cited from memory). `contract-check.md:2` states its own purpose verbatim: "Catches cumulative drift introduced across multiple rounds of QC fixes." Its input grammar (`contract-check.md:16-19`, Step 2 item 4) accepts an explicit path as the contract — so `/contract-check context/content-architecture.md` or `/contract-check context/mandate-rubric.md` already runs a comparable structural/mandate-drift check today. `reconcile.md:32` sets `MANDATE_RUBRIC_PATH = context/mandate-rubric.md` as a required input and `reconcile.md:47-49` invokes `/contract-check {MANDATE_RUBRIC_PATH}` as a cross-check. `reconcile-reviewer.md` Step 2 ("Mandate Compliance") scores every rubric dimension in `context/mandate-rubric.md` against the target, and Step 4 ("Genericness Check") runs a substitution test on the highest-weight claims — directly overlapping territory with Guardian's stated "value-add/existence-justification" dimension.
- **Consequence — traced or assumed?** The claimed consequence (a coverage gap that justifies a new 4-subagent pipeline) does not hold once the existing tools are actually read: what is genuinely missing is *automatic, mandatory wiring* of `/contract-check`/`/reconcile` into the pre-approval sequence — `reference/stage-instructions.md:174-182` requires only `/review` → `/challenge` → `/service-design-review` before promotion to `approved/`, and does not name `/contract-check` or `/reconcile`. That is a real, narrower gap (a wiring gap, not a capability gap) — materially different from "no existing reviewer covers this."
- **Re-derivation vs. the change description:** Disagreement found. "No existing reviewer covers" cumulative-drift-vs-mandate and value-add/genericness checking is contradicted by direct reads of `/contract-check` and `/reconcile`/`reconcile-reviewer`, both of which already operate against the same `context/mandate-rubric.md` the change proposes to hand to a new agent. The actual gap is that these tools are not wired into the mandatory pre-approval sequence — a much smaller, and differently-shaped, problem than "build a new 4-subagent pipeline."
- Per the gate's own rule: "A High or INCOMPLETE on Dimension 7 forces `RECONSIDER` on its own — it cannot be outvoted by Lows on the other six, and it cannot be mitigated."

## Recommended redesign

Two independent High findings apply here — Dimension 7 (contradicted premise, no technical mitigation exists) and Dimension 6 (unacknowledged complexity-budget/speculative-abstraction violation, no OP-11 record exists). Both point to the same remedy path:

- **Observe the defect, don't build past it.** Run `/contract-check context/content-architecture.md` and `/contract-check context/mandate-rubric.md` (or `/reconcile`) against a real in-progress `parts/` draft and record concretely what they miss that a new agent would need to catch. If the residual gap is genuinely "these checks exist but aren't in the mandatory pre-approval sequence," the structural fix is to add `/contract-check` and/or `/reconcile` as an explicit step in `reference/stage-instructions.md`'s § Strategic Evaluation gate (alongside `/review` → `/challenge` → `/service-design-review`) — this is a net-simplification-compatible extension of existing components (clears rule #7 prong (a) territory) rather than a new command + new agent + new always-loaded CLAUDE.md nudge.
- **If a genuine residual gap survives that observation** (something neither `/contract-check` nor `/reconcile` can produce even when properly wired in), rescope Guardian to a thin orchestrator that calls the three existing agents *through their canonical commands* (preserving the QC→Triage loops rather than bypassing them) plus `/contract-check`/`/reconcile`, and adds only the missing piece — a single consolidated summary/log row — rather than re-implementing agent dispatch and duplicating verdict-parsing logic three other commands already own. Log the residual gap and the scoping decision in `logs/decisions.md` (satisfying rule #7 prong (b) and OP-11) before building.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
