# Risk Check — 2026-07-12

## Change

M-A Phase 0 defect batch (packet: projects/axcion-ai-system-redesign/output/implementation-prep/packets/M-A-phase0-defects.md). Proposed changes: (1) M-A1 — reconcile four contradictions in behaviour-governing docs against canonical workspace CLAUDE.md: strike the autonomous-push claims in ai-resources/docs/autonomy-rules.md rule 2 and ai-resources/docs/session-rituals.md § Before Committing; strike the "wait for the operator's one-word response" fork in ai-resources/docs/session-guardrails.md:5 and re-render the [COST] flag at :65 as a statement; delete the stale "Use /compact strategically" section in session-rituals.md; strike "Review the diff Claude shows you" from session-rituals.md § Before Committing. (2) M-A2a — declare bare-tier model: frontmatter at command-side/inline-spawn sites (/plan-draft, wrap Step 6.4 spawn, drift/contract subagents, skill-eval subagents, RRP investigator, WF10). (3) M-A2b — DELETE the workspace-root hook .claude/hooks/model-classifier.sh (invariant-stem grep found zero consumers). (4) M-A3b — sync the stale installed ai-resources/.git/hooks/pre-commit (mtime 2026-02-20, omits the check-skill-size.sh call) to the repo source ai-resources/.claude/hooks/pre-commit. (5) M-A3c — remove the banned model-declaration from the /new-project generator (new-project.md:170 templates a default-model line into the generated project CLAUDE.md; a generator task writes a model default into settings.local.json; cross-refs at L375/379/402) — both halves are banned by workspace CLAUDE.md § Model Tier. (6) M-A4 — reconcile docs/agent-tier-table.md and skills/CATALOG.md to ground truth (42 live agent files). Deferred, not implemented: M-A3a duplicate startup-context injection (not reproducible from static state; harness dedupe observed active). Note the pre-commit hook is untracked (.git/hooks/), so blanket `git revert` does NOT cover its rollback.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/M-A-phase0-defects.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-rituals.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-guardrails.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/compaction-protocol.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-boundaries.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/CATALOG.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/model-classifier.sh — exists (deletion target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/pre-commit — exists (repo source)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/hooks/pre-commit — exists (installed, stale, UNTRACKED by git)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists (canonical authority the docs are being reconciled TO)

## Verdict

RECONSIDER

**Summary:** The individual fixes are correctly diagnosed and mostly low-risk in isolation, but the batch's own currency check missed a directly relevant, 9-day-old sibling effort (a deferred "instruction-leanness campaign") that already scoped the identical push-contradiction fix with richer, previously-approved mitigations, and missed a third live copy of the same contradiction (`resolve-incident.md:237`) that a prior SO advisory explicitly said must not be deferred again — landing this batch as scoped would repeat a known partial-closure mistake while also bundling a shared-infra pre-commit-hook sync into the same gate.

## Consumer Inventory

Search terms: basenames of all referenced files (`autonomy-rules.md`, `session-guardrails.md`, `session-rituals.md`, `model-classifier.sh`, `pre-commit`, `new-project.md`, `agent-tier-table.md`, `CATALOG.md`); contract markers ("wait for the operator's one-word response", "Push happens automatically", "proceeds autonomously after commit", "Default model for this project is", "Model Selection", "task 2"); the invariant stem `model-classifier`. Grepped `ai-resources/` and the workspace root one level up, plus every `settings.json`/`settings.local.json` at every layer (58 files, including user-level `~/.claude/settings.json`) and `projects/axcion-ai-system-redesign/` for cross-registry context.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/list-critical-resources.md` (parses session-rituals.md `## Session Start` / `## Phase 3` / `## Session End` headings) | parses | no — the edited push line sits under `## Before Committing`, outside all parsed sections, but this constraint is not documented anywhere in the M-A packet itself (found only by cross-referencing a prior risk-check) |
| `ai-resources/.claude/commands/resolve-incident.md:237` — "push happens automatically after commit" | documents (same contradiction M-A1a targets) | **yes — NOT in this packet's scope.** A prior (2026-07-03) risk-check + SO advisory for the identical defect explicitly said "fix the 2 command copies now — do not defer" (OP-12/OP-3/AP-1). One of those two copies (`graduate-resource.md:154`) was independently fixed 2026-07-03; this one was not, and the M-A packet does not mention it. |
| `ai-resources/audits/instruction-audit-2026-07/deferral-note-2026-07-03.md`, `phase0-inventory-diagnosis.md`, `../risk-checks/2026-07-03-phase-1-claude-md-duplication-contradiction-fixes.md` | co-edits (sibling effort, same target files: `autonomy-rules.md`, `session-rituals.md`) | **yes — not reconciled.** A prior, operator-approved plan (`~/.claude/plans/make-an-investigation-clarify-vast-robin.md`) already scoped this exact fix, was risk-checked PROCEED-WITH-CAUTION, began editing, was stopped by the operator for scope creep, and reverted. Its deferral note gives an explicit resume protocol this M-A packet does not follow or cite. |
| `ai-resources/docs/protected-zones.md` (autonomy-rules.md flagged `/risk-check mandatory`) | documents | no — confirms the gate correctly fires |
| All `settings.json` / `settings.local.json` across every layer (58 files, incl. user-level) | (checked for model-classifier registration) | no — zero hits confirmed independently, corroborating the packet's "zero consumers" claim |
| `ai-resources/docs/repo-architecture.md:17` — "hooks/ # workspace-level hooks (model-classifier, sync, etc.)" | documents | no must-change, but goes stale post-deletion; not in packet scope |
| `ai-resources/logs/innovation-registry.md:81` (historical row) | documents | no — historical record, appropriate to leave |
| `artifacts/merged-os-context/.../inventory-notes.md:83` (working note listing unwired hooks) | documents | no must-change, but goes stale post-deletion |
| `.claude/hooks/session-start.sh` | (checked — near-miss pattern flagged in packet) | n/a — independently confirmed NOT a consumer of `model-classifier.sh`; correctly excluded from deletion |
| `ai-resources/.git/hooks/pre-commit` (installed, untracked) | co-edits (direct sync target) | yes — in scope |
| Every future `git commit` inside `ai-resources/` | invokes (git itself calls this hook on every commit) | yes — shared infra, not a single caller |
| `ai-resources/.claude/hooks/check-skill-size.sh` | invoked by the new source hook | no — verified present, executable, informational-only (exits 0 always); sync is functionally safe |
| `ai-resources/logs/decisions.md:182-183,310`; `logs/improvement-log.md:27`; `logs/session-notes.md:167` | documents (pre-existing recorded decisions that already override new-project.md step 11a) | no must-change — this M-A3c edit *closes* these three already-logged findings |
| `ai-resources/.claude/commands/deploy-workflow.md`, `permission-sweep.md`, `placement.md`, `repo-dd.md`, `list-critical-resources.md`, 5× `pipeline-stage-*.md`, `session-guide-generator.md`, `session-guide.md` | invoke/document `/new-project` generally (backbone spine: refs 32, fan-out 16 per `audits/backbone-manifest.md`) | no — none parse or depend on step 11a's model-default line specifically |
| No command/agent/hook found that machine-parses the generated "Default model for this project is …" CLAUDE.md line | — | n/a — zero functional consumers of the generated artifact itself |
| `ai-resources/docs/agent-tier-table.md`, `ai-resources/skills/CATALOG.md` | (reconciliation targets) | no external parsers found for either — pure reference docs |

Total: **15 distinct consumer rows** (2 "not yet present"/not-covered gaps flagged as must-change-but-out-of-scope; 1 shared-infra row with no single caller count). The two starred rows (`resolve-incident.md:237` and the sibling instruction-leanness campaign) are consumers `CHANGE_DESCRIPTION` did not anticipate — this is itself the central Blast-Radius/Hidden-Coupling finding below.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file gains content — M-A1 corrects/shortens wording in `docs/` files that are pointer-loaded, not always-on (only root `CLAUDE.md` and `ai-resources/CLAUDE.md` are always-loaded, and neither is touched).
- M-A2b deletes a `UserPromptSubmit` hook that fires once per session — net *reduction* in per-session token cost, not addition.
- M-A2a adds `model:` frontmatter lines to command files (not always-loaded); no new hook, no new `@import`, no broadened skill-trigger description.
- M-A3b/M-A3c/M-A4 touch a git hook (event-fired, not per-turn), a project-generator command (pay-as-used), and two reference docs (pointer-loaded). None add ongoing per-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json`/`settings.local.json` at any layer is touched by this batch (verified: 58 settings files checked, zero edits proposed to any of them).
- M-A2b *removes* a hook registration surface (net narrowing). M-A3c removes an *instruction* to write a model field into `settings.local.json` — it does not touch an actual permission grant, and removing the instruction can only narrow, not widen, what future scaffolds attempt.
- No new Bash pattern, Write path, external API, or MCP capability is introduced anywhere in the batch.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory: 15 distinct consumer rows across 6 heterogeneous sub-items, touching **3 protected-doc zones** (`docs/autonomy-rules.md`, `docs/session-guardrails.md`, `docs/session-rituals.md` — the first is explicitly flagged `/risk-check mandatory` in `docs/protected-zones.md`), **1 shared-infra file** (the installed `.git/hooks/pre-commit`, invoked by every future `git commit` in `ai-resources` — this alone satisfies the rubric's "shared infra touched in a way that affects multiple workflows"), and **1 backbone-spine command** (`new-project.md`, refs 32 / fan-out 16 per `audits/backbone-manifest.md`), even though the specific edited sub-step (11a) has zero live parsers.
- **The inventory surfaced a consumer `CHANGE_DESCRIPTION` did not anticipate:** `ai-resources/.claude/commands/resolve-incident.md:237` carries the identical "push happens automatically after commit" contradiction M-A1a targets in `autonomy-rules.md`/`session-rituals.md`, but is not in this packet's scope. A prior (2026-07-03) risk-check for the same defect class found and closed a sibling copy (`graduate-resource.md:154`, confirmed fixed via `git log` — commit `e0a821d`) and explicitly told a future session not to defer the remaining copies. This packet, drafted 9 days later by a different tracking system, rediscovers the defect but not this consumer.
- M-A2b (`model-classifier.sh` deletion) is independently confirmed zero-functional-consumer (58 settings files, all doc hits are historical/prose) — this specific sub-item is Low blast radius on its own; it is the doc-reconciliation and hook-sync sub-items that drive the High rating.

### Dimension 4: Reversibility
**Risk:** Medium

- Five of six sub-items (M-A1, M-A2a, M-A2b, M-A3c, M-A4) are ordinary tracked-file edits/deletions — a single `git revert` per commit fully restores prior state.
- **M-A3b is the exception, self-disclosed by the packet itself:** the installed `ai-resources/.git/hooks/pre-commit` is untracked (confirmed: `git ls-files` / `git status` return nothing for `.git/hooks/pre-commit`, as expected for any `.git/` internal path), so `git revert` cannot restore it if the sync goes wrong. The packet's own § 7 Rollback already names the correct mitigation ("capture a copy of the current installed hook before overwriting, and record the restore path") — this is sound, but it is a *manual procedural* safeguard, not a technical guarantee, and the packet does not specify a concrete backup path or verification step.
- Functional verification lowers residual risk here: independently confirmed the source hook (`.claude/hooks/pre-commit`, checks 1–6 + delegates to `check-skill-size.sh`) is behavior-equivalent to the installed hook (checks 1–7, inline body-length WARN) except that `check-skill-size.sh` is verified present, executable, and informational-only (always exits 0) — so the sync introduces no new blocking behavior.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Unacknowledged duplicate-effort coupling (the primary finding).** This M-A packet and the deferred "instruction-leanness campaign" (`audits/instruction-audit-2026-07/`, plan `~/.claude/plans/make-an-investigation-clarify-vast-robin.md`) independently target the identical push-contradiction defect in `docs/autonomy-rules.md` and `docs/session-rituals.md`. The sibling campaign's 2026-07-03 risk-check carries richer, already-approved mitigations this packet does not carry forward: (a) confine the `session-rituals.md` edit strictly to `## Before Committing` (parse-contract safety for `/list-critical-resources`), (b) verify the autonomy shortlist preserves each gate's *trigger conditions*, (c) pointers must target stable anchors/headings, never line numbers, (d) run an independent context-isolated `/qc-pass` because three protected zones are touched. None of these are cited in the M-A packet. Grepping confirms zero cross-reference in either direction (`grep -rn "instruction-leanness\|vast-robin" projects/axcion-ai-system-redesign/` and vice versa returns nothing).
- **Partial-closure repeat.** The sibling campaign's own SO advisory said, of the exact same defect class: "Fix the 2 command copies now — do not defer... parks detection ahead of closure (OP-12)." One copy (`graduate-resource.md:154`) was fixed via an unrelated side-session; the other (`resolve-incident.md:237`) was not, and remains live today. Landing M-A1a/M-A1d as scoped repeats the partial-closure pattern the prior review already flagged.
- **Undocumented parse-contract dependency.** `session-rituals.md`'s `## Session Start`/`## Phase 3`/`## Session End` headings are a machine-parsed contract for `/list-critical-resources` (verified: lines 84-85 of that command). This coupling is documented only in the *consumer* file and in the sibling campaign's risk-check — not in `session-rituals.md` itself and not in the M-A packet, so an editor working only from this packet cannot see it without independently rediscovering it (as this review did).
- **Documentary staleness on deletion.** `model-classifier.sh` deletion (M-A2b) leaves three prose references stale post-deletion (`docs/repo-architecture.md:17`, `logs/innovation-registry.md:81` historical row, a merged-os working-note inventory line) — none block the deletion, but none are in the packet's scope either.

### Dimension 6: Principle Alignment
**Risk:** Medium

Ground: `projects/strategic-os/ai-strategy/principles-base.md` was readable (42-principle frozen-ID index, 41 active).

- **OP-11 / OP-3 (surfacing/revising principles and drift must be loud, never silent).** M-A1, M-A2b, and M-A3c are each themselves *correcting* previously-logged, already-loud divergences (the push rule was loudly inverted 2026-05-29; the model-default ban is loudly stated in workspace `CLAUDE.md`; `logs/decisions.md` already records the new-project.md conflict twice). These sub-items are principle-**positive** — legitimate OP-11/OP-3 drift correction, not new drift.
- **OP-12 (closure before detection — "new detection that does not close findings counts against the change; a detection channel ships behind a working closure, never ahead").** M-A1a/M-A1d re-detects the push contradiction (already detected twice before, on 2026-07-03) and closes 2 of the 3 currently-live copies, again leaving `resolve-incident.md:237` open — the same partial-closure pattern a prior SO advisory explicitly invoked OP-12 to reject. This is a tension, not a clean violation: the packet does close most of what it finds, and the gap exists because the currency check did not discover the consumer, not because of a deliberate choice to defer it loudly. That distinction — an *unrecognized* gap rather than an *acknowledged* deferral — is what keeps this at Medium rather than High.
- **DR-7 / OP-9 / AP-7 (no speculative abstraction).** Not implicated — the batch removes a never-wired speculative hook (M-A2b) and removes speculative/banned scaffolding (M-A3c); both read as principle-positive, the inverse of speculative abstraction.
- **OP-10 (system boundary), OP-5 (advisory vs. enforcement), DR-1/DR-3 (placement).** Not implicated — no cross-tool coordination, no enforcement upgrade, no resource re-homed.
- Net: the batch's *content* is principle-aligned; the *process* gap (an unreconciled sibling effort plus a rediscovered-but-unrecognized partial-closure repeat) is what earns Medium rather than Low.

## Recommended redesign

- **Reconcile before re-submitting.** Read `ai-resources/audits/instruction-audit-2026-07/deferral-note-2026-07-03.md` and the linked 2026-07-03 Phase-1 risk-check in full. Either (a) resume that campaign's already-approved, better-mitigated scope for the push-contradiction fix (which folds in `resolve-incident.md`, preserves autonomy-shortlist trigger conditions, and requires context-isolated `/qc-pass` on the three protected zones), explicitly retiring the M-A packet's M-A1a/M-A1d in favor of it, or (b) log an explicit, loud decision in `logs/decisions.md` stating that this M-A packet supersedes the deferred campaign and why — then fold `resolve-incident.md:237` into M-A1's file list so the push-contradiction fix closes all 3 known live copies in one pass, not 2 of 3 again.
- **Split the batch by risk shape.** Land the doc-reconciliation items (M-A1 with the added `resolve-incident.md` row, M-A2a, M-A4 — all cleanly `git revert`-able, no shared-infra touch) under one gate, and handle the shared-infra items (M-A2b hook deletion, M-A3b pre-commit sync, M-A3c generator edit) under a second, more narrowly-scoped gate. This keeps the pre-commit hook's shared-infra/reversibility profile from inflating the risk verdict on the otherwise-low-risk doc fixes, and lets each gate's consumer inventory stay small enough to audit completely.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line reads of every referenced file plus `docs/protected-zones.md`, `audits/backbone-manifest.md`, `audits/instruction-audit-2026-07/*`, `audits/risk-checks/2026-07-03-phase-1-*`, and `logs/decisions.md`/`improvement-log.md`/`session-notes.md`; independent `grep -rniI` sweeps for the invariant stem `model-classifier` across `ai-resources/` and the workspace root plus all 58 `settings.json`/`settings.local.json` files at every layer (user, workspace, ai-resources, every project); `git log --oneline` confirming `graduate-resource.md`'s prior fix (commit `e0a821d`) and `docs/autonomy-rules.md`/`docs/session-rituals.md`'s edit-then-revert history around commit `fa51d00`; direct byte-comparison of the installed vs. source `pre-commit` hooks and independent read of `check-skill-size.sh`; independent count of live `.claude/agents/*.md` (42) against `docs/agent-tier-table.md` rows (2 dead rows, 5 missing live agents) and live `skills/*/SKILL.md` (80) against `skills/CATALOG.md`'s claimed count (60). No training-data fallback was used on any read. No INCOMPLETE dimensions.
