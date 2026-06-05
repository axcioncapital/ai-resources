# Risk Check — 2026-06-05

## Change

Proposed change F4 from post-project-review-canonical-fix-plan-2026-06-05.md:

Files to change:
1. `ai-resources/docs/autonomy-rules.md` — add one new rule to the pause-trigger enumeration: "A command-authored unconditional operator gate (marked 'unconditional — no timeout, no auto-approve') ranks above the workspace full-autonomy default and stops execution even in auto-mode, including sessions running under `/prime` auto-mode."
2. `ai-resources/workflows/research-workflow/.claude/commands/run-analysis.md` Step 2 bullet 5 — change the soft PAUSE marker ("5. PAUSE — Present gap assessment to the operator.") to an unconditional gate matching the hardening standard already used in `run-report.md` Step 4.2e ("unconditional — no timeout, no auto-approve").

Rationale: In session S3 of the research-pe-regime-shift-advisory-gap project, the run-analysis Step 2.5 explicit operator-PAUSE was bypassed under the workspace full-autonomy default. No precedence rule ranked the command-authored gate above the default posture. run-report Step 4.2e already gets this right with "unconditional — no timeout, no auto-approve" — this change closes the inconsistency and codifies the rule so all pipeline commands get the same protection.

Consumer inventory (who reads autonomy-rules.md): workspace CLAUDE.md points to it; project CLAUDE.md files point to it; the rule is referenced in prime.md, session-start.md, and wrap-session.md. Every Claude Code session in the workspace loads the rule at session start.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-analysis.md — exists

## Verdict

GO

**Summary:** A consistency/hardening fix that adds one precedence rule and aligns one soft PAUSE marker to an already-established standard (`run-report.md` Step 4.2e); it strengthens operator gating (serves OP-3/OP-5/OP-11), with the only real follow-through being a `/sync-workflow` push of the canonical command edit to the project copy.

## Consumer Inventory

The two change targets have distinct consumer classes. (1) `autonomy-rules.md` is a **reference doc loaded/interpreted by the live session** (pointed to from always-loaded CLAUDE.md files); its "consumers" are the session-runtime and the commands that assert an autonomy posture. (2) `run-analysis.md` Step 2.5 is a **per-command marker** consumed by the live session executing that command, plus the project-local copy that must be re-synced.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md (§ Autonomy Rules → points to autonomy-rules.md) | documents | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md (Step 8c auto-mode: "single combined approval gate and no per-stage prompts", line 270/470) | parses (honors autonomy posture at runtime) | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/prime.md (workspace-root duplicate of prime, same Step 8c) | parses | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-report.md (Step 4.2e — the existing standard this change mirrors, "unconditional — no timeout, no auto-approve", line 88) | documents (precedent; unchanged) | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-analysis.md (project-local COPY, not a symlink — 14572 bytes regular file) | co-edits (needs the same Step 2.5 hardening to take effect in the live project) | yes |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/ (and other deployed research-workflow project copies) | co-edits (carry their own run-analysis copies; pick up the fix on next `/sync-workflow`) | no (compatible until synced) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/sync-workflow.md (diffs canonical→project, line 50/115 keys on `commands/run-analysis.md`) | invokes (the propagation channel) | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/onboarding-daniel.md, parallel-sessions-playbook.md, protected-zones.md (prose references to autonomy-rules.md) | documents | no |

Total: 8 distinct consumer rows, 1 must-change (the project-local `run-analysis.md` copy). The ~50 other grep hits on "autonomy-rules" / "run-analysis" are audit reports, logs, scratchpads, archived projects, and repo-snapshots — historical/derived artifacts, not live consumers of the contract; excluded from the inventory by design. Note: the `unconditional — no timeout, no auto-approve` contract marker already exists in `run-report.md` — this change is its **second** application, so the marker is a pre-existing, documented contract rather than a new one.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The autonomy-rules.md edit adds one numbered rule to a file that is *pointed to* by CLAUDE.md, not inlined into it. autonomy-rules.md header states "Before pausing or proceeding… for the full enumeration" (line 3) — it is read on demand, not loaded every turn. No always-loaded token cost.
- The CLAUDE.md § Autonomy Rules entry (workspace) is a pointer ("Full rationale and gate semantics: `ai-resources/docs/autonomy-rules.md`") — F4 does not require expanding the always-loaded CLAUDE.md text.
- The run-analysis.md edit changes one bullet's marker text (Step 2 bullet 5, line 42) — no new hook, no `@import`, no subagent brief expansion. Pay-as-used: cost incurred only when `/run-analysis` runs.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` change, no `allow`/`ask`/`deny` edit, no new tool-invocation pattern. Grep of the change targets shows documentation/marker edits only.
- The change *narrows* effective autonomy (adds a stop condition); it removes capability rather than widening it. Net permission-surface direction is restrictive, not expansive.

### Dimension 3: Blast Radius
**Risk:** Medium

- From the Step 1.5 inventory: 8 distinct live consumers, **1 must-change** — the project-local `run-analysis.md` copy at `projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-analysis.md`, which is a regular 14572-byte file (verified `ls -la`), **not a symlink**. The canonical edit does NOT auto-propagate; the live project keeps the soft PAUSE until `/sync-workflow` pushes the diff (sync-workflow.md line 50/115 keys on `commands/run-analysis.md` and shows a diff for operator approval). If F4 lands canonically but the project copy is not synced, the S3-class bypass the change is meant to fix can recur in that exact project.
- Contract interaction (the load-bearing one): the new precedence rule deliberately overrides `/prime` auto-mode, whose Step 8c states it runs picked items "end-to-end with a single combined approval gate and no per-stage prompts" (prime.md line 270) and "do NOT pause between items" (line 470). The change introduces a *carve-out* in that previously-uniform no-pause guarantee. This is intended and is the point of F4, but it is a behavior change to the most-invoked orchestration command — hence Medium not Low. The carve-out is backwards-compatible (it only ever *adds* a stop, never removes one), and `/prime` already has paused-execution paths (e.g., RECONSIDER risk-check verdict, line 466), so the auto-mode loop already knows how to halt mid-run.
- Other deployed research-workflow project copies (buy-side-service-plan, etc.) carry their own run-analysis copies and stay compatible — they retain the old soft PAUSE until separately synced; no breakage, just non-propagation.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are in-tree text edits to two tracked files (`autonomy-rules.md`, canonical `run-analysis.md`). `git revert` restores both cleanly.
- No data/log mutation, no settings cache, no external write, no automation that fires between landing and revert. The only manual follow-through is symmetric: if the project copy was synced, a revert should also re-sync the project copy — one extra `/sync-workflow` step, but it is the same channel and is not load-bearing for correctness (reverting to the softer marker only loosens a gate).

### Dimension 5: Hidden Coupling
**Risk:** Low

- The contract marker `unconditional — no timeout, no auto-approve` is **already documented and in use** at `run-report.md` Step 4.2e (line 88: "The halt is unconditional — no timeout, no auto-approve"). F4 reuses an existing, named convention rather than inventing a silent one — the precedence rule it adds to autonomy-rules.md *documents* the marker's authority explicitly, closing the gap that previously left the marker's precedence implicit. This is coupling being made visible, not hidden.
- One implicit dependency: the live session must recognize the literal marker string when executing a pipeline command and honor it over the auto-mode no-pause default. This is an established repo convention (already relied on by run-report), and F4's autonomy-rules.md edit is exactly what makes the dependency explicit. No silent auto-firing, no functional overlap with a competing mechanism.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read OK at `projects/strategic-os/ai-strategy/principles-base.md` (42 frozen-ID principles).
- **Serves OP-3 (loud failure over silent continuation)** and **OP-11 (surface practice-vs-principle divergence loudly).** F4 originates from a recorded post-project review of an actual S3 bypass; codifying the precedence rule is the loud, recorded correction OP-11 prescribes — it converts a silent-drift incident into an explicit rule. Not a violation; an active alignment.
- **Serves OP-5 (advisory vs enforcement).** The gate *stops and asks the operator* — it does not auto-correct or auto-act. F4 strengthens an "advise and stop" boundary; it does not move advisory automation toward enforcement. OP-5-positive.
- **OP-2 (automate execution, gate judgment) positive.** The gap-assessment routing the gate protects (Path A vs Path B, "the operator approves routing", run-analysis.md line 45) is a genuine judgment call, exactly the class OP-2 says stays operator-gated. Hardening it aligns with OP-2; it does not re-gate routine execution (no AP-4 rubber-stamp risk added).
- **DR-7 / AP-7 / OP-9 (no speculative abstraction): clears.** The marker has a *second confirmed consumer* — `run-report.md` Step 4.2e already uses it, and `run-analysis.md` is the second. F4 generalizes the precedence rule only after two real consumers exist, which is precisely what DR-7 licenses. Not speculative.
- **DR-1/DR-3 (placement): clears.** The precedence rule lands in `docs/autonomy-rules.md` (the canonical home for autonomy exceptions), and the marker edit lands in the canonical workflow command — correct tiers.
- No OP-10 boundary expansion (Claude-Code-internal only; no cross-tool governance). No unannounced enforcement upgrade.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (autonomy-rules.md line 3/22; run-analysis.md line 42/45; run-report.md line 88; prime.md lines 270/466/470; sync-workflow.md line 50/115), `ls -la` symlink-vs-copy verification of the project run-analysis.md, grep counts across `ai-resources` and the workspace root, and principle IDs from `projects/strategic-os/ai-strategy/principles-base.md`. No training-data fallback was used on any read.
