# Risk Check — 2026-07-03

## Change

Phase 1 of the instruction-leanness campaign (plan: ~/.claude/plans/make-an-investigation-clarify-vast-robin.md, scope approved). Proposed edits: (1) fix the git-push contradiction — root CLAUDE.md states gated/batched/y-n-confirmed (canonical, operator's own rule inverted 2026-05-29); docs/autonomy-rules.md line 12 currently says push "proceeds autonomously after commit" — correct that line to match root; (2) fix the newly-discovered second copy of this same contradiction in docs/session-rituals.md, which says "push happens automatically" and is actively parsed by /list-critical-resources; (3) collapse the Decision-Point Posture orphan duplicate (stated in full in both root CLAUDE.md and docs/autonomy-rules.md) to one canonical copy (autonomy-rules.md) + a 2-line pointer in root; (4) collapse the Autonomy 10-item list duplicate similarly — canonical in autonomy-rules.md, root keeps posture + a 4-item shortlist + pointer; (5) collapse the QC-unreachable/commit-blocked rule (root + docs/qc-independence.md) to a 1-line pointer in root, canonical in the doc; (6) collapse the Model-Tier prohibition duplicate (root + ai-resources/CLAUDE.md) to a 1-line pointer in ai-resources/CLAUDE.md, canonical in root; (7) merge ai-resources/CLAUDE.md's adjacent "Git Rules" + "Commit Rules" sections (both restate root's commit/push rule) into one short pointer block; (8) fix docs/session-boundaries.md's stale provenance claim (claims ai-resources/CLAUDE.md and every project CLAUDE.md point to it; only root does) to match reality; (9) small opportunistic corrections: docs/operator-maintenance-cadence.md stale backlog refs, docs/onboarding-daniel.md and onboarding-daniel-cheatsheet.md's deprecated /save-session reference and stale "5 risk dimensions" count. Files touched: root CLAUDE.md, ai-resources/CLAUDE.md, docs/autonomy-rules.md, docs/qc-independence.md, docs/session-boundaries.md, docs/session-rituals.md, docs/operator-maintenance-cadence.md, docs/onboarding-daniel.md, docs/onboarding-daniel-cheatsheet.md. No commands/agents/skills touched in this phase. No behavior actually changes except the two push-wording corrections (which align wording to the already-canonical/practiced rule, not a new behavior) and the deprecated-command-name fixes.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-boundaries.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-rituals.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/operator-maintenance-cadence.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/onboarding-daniel.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/onboarding-daniel-cheatsheet.md — exists

Note: the plan file `~/.claude/plans/make-an-investigation-clarify-vast-robin.md` is named in CHANGE_DESCRIPTION but is NOT in REFERENCED_FILE_PATHS, so it was not read; the plan's contents were evaluated only via the CHANGE_DESCRIPTION summary. All 9 referenced files exist and were read directly.

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A low-risk, leanness-aligned consolidation of duplicated/contradictory always-loaded prose (net token *reduction*, cleanly git-revertable, no permission or behavior change), elevated to PROCEED-WITH-CAUTION by two Mediums — a wide 9-file blast radius that must stay clear of the `/list-critical-resources` parse contract in session-rituals.md, and a partial-closure gap where two command-surface copies of the same push contradiction are deferred out of Phase 1.

## Consumer Inventory

Search terms: basenames of the 9 touched files; contract markers `/list-critical-resources` parse headings (`## Session Start`, `## Phase 3`, `## Session End`); push-policy tokens ("push happens automatically", "proceeds autonomously", "push automatically"); the collapsed section names (Decision-Point Posture, Autonomy Rules list, QC-unreachable, Model Tier). Grepped `{AI_RESOURCES}` and the workspace root one level up. Audit/log/repo-snapshot references excluded as non-live (documentation-of-record, not runtime consumers).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/list-critical-resources.md` (lines 84–85) | parses (session-rituals.md `## Session Start` / `## Phase 3` / `## Session End` sections → lifecycle-command set) | no — edited push line is under `## Before Committing`, outside all three parsed sections |
| `ai-resources/docs/protected-zones.md` (lines 13, 21, 22) | documents (marks root CLAUDE.md, autonomy-rules.md, qc-independence.md as `/risk-check`-mandatory zones) | no — confirms the change is correctly gated by this very risk-check |
| `ai-resources/.claude/commands/resolve-incident.md` (line 237) | documents (parenthetical "push happens automatically after commit" — same contradiction, out of Phase-1 scope) | yes-but-deferred — carries the stale rule; not touched this phase |
| `ai-resources/.claude/commands/graduate-resource.md` (line 154) | invokes (command step "Push automatically after the commit" — same contradiction, out of scope) | yes-but-deferred — carries the stale rule; not touched this phase |
| `ai-resources/docs/weekly-session-guide.md` (line 4) | documents (pointer to session-rituals.md, autonomy/qc docs) | no |
| `ai-resources/docs/repo-architecture.md` (line 264) | documents (session-rituals.md map entry) | no |
| `ai-resources/docs/parallel-sessions-playbook.md` | documents (autonomy-rules.md pointer) | no |
| `ai-resources/docs/ai-resource-creation.md` | documents (qc-independence.md pointer) | no |
| `ai-resources/.claude/commands/prime.md`, `wrap-session.md`, `qc-pass.md`, `contract-check.md`, `friday-act.md`, `promote-workflow.md`; `.claude/agents/context-discovery.md` | documents (methodology pointers to qc-independence.md — canonical doc retains content) | no |
| `ai-resources/docs/onboarding-daniel.md` (lines 173, 243, 256–273, 355; being edited) | documents (restates 10 autonomy triggers + pointers) + co-edits (own /save-session + "5 dimensions" fixes) | yes (own fixes only); 10-item list stays valid — autonomy-rules.md keeps all 10 |
| `ai-resources/docs/onboarding-daniel-cheatsheet.md` (lines 16, 45, 114–115; being edited) | documents (pointers) + co-edits (own /save-session + "5 dimensions" fixes) | yes (own fixes only) |
| root `CLAUDE.md` | co-edits (receives the collapsed pointers) | yes (in-scope touched file) |
| `ai-resources/CLAUDE.md` | co-edits (receives Model-Tier pointer + merged Git/Commit block) | yes (in-scope touched file) |

Total: 12 distinct consumer rows. External must-change = 0 (canonical docs retain their content, so every `documents`/`parses` consumer stays compatible). In-scope co-edited files = the 9 touched files. **Two deferred-consumer rows** (`resolve-incident.md:237`, `graduate-resource.md:154`) hold the *same* push contradiction but are explicitly out of Phase-1 scope — a partial-closure finding, carried into Dimensions 3 and 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Net token *reduction*, not addition. Every collapse removes verbatim prose from always-loaded files: Decision-Point Posture (full section) and the Autonomy 10-item list shrink to a shortlist+pointer in root CLAUDE.md; the QC-unreachable rule and Model-Tier duplicate collapse to 1-line pointers; ai-resources/CLAUDE.md's "Git Rules"+"Commit Rules" merge to one pointer block. Evidence: CHANGE_DESCRIPTION items (3)–(7) ("collapse … to one canonical copy + a 2-line pointer", "1-line pointer in root", "merge … into one short pointer block").
- No new hook, no new SessionStart/Stop/PreToolUse/UserPromptSubmit registration, no new `@import`, no new or expanded subagent brief, no new broadly-triggering skill. Evidence: "No commands/agents/skills touched in this phase."
- This is the stated goal of the instruction-leanness campaign — the change works *for* per-turn token economy, the inverse of a usage-cost risk.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` at any layer is touched; no `allow`/`ask`/`deny` entry added, removed, or narrowed. Evidence: file list contains only CLAUDE.md and `docs/*.md`; "No commands/agents/skills touched in this phase."
- The two push-wording corrections *document* the already-canonical gated/batched push gate (root CLAUDE.md § Push behavior, unchanged) — they do not alter the actual git-push permission or introduce a new tool-invocation pattern. Direction of change is *tightening* (autonomous → gated in prose), which cannot widen the permission surface.
- No cross-repo, external-API, MCP, or scope-escalation (project→user) capability introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- 9 files touched directly, including three protected zones (`protected-zones.md` lines 13/21/22 mark root CLAUDE.md, autonomy-rules.md, qc-independence.md as `/risk-check`-mandatory). Breadth alone puts this above Low.
- Per the Consumer Inventory: **0 external consumers must change** — the canonical docs (autonomy-rules.md, qc-independence.md) *retain* their content, so every `documents`/pointer consumer (weekly-session-guide, repo-architecture, parallel-sessions-playbook, ai-resource-creation, 7 command/agent methodology pointers, both onboarding files) stays compatible. This keeps it out of High.
- **The single mechanical parse consumer is `/list-critical-resources`** (list-critical-resources.md lines 84–85), which parses session-rituals.md's `## Session Start`, `## Phase 3` START/DURING/END, and `## Session End` sections to derive the lifecycle-command set. The Phase-1 push-wording fix lands at session-rituals.md line 90, under `## Before Committing` — **outside all three parsed sections** — so the parse contract is not tripped. Backwards-compatible, but the edit must be kept surgically inside `## Before Committing`.
- **Partial-closure blast finding (inventory surfaced two consumers CHANGE_DESCRIPTION under-weights):** the *same* push contradiction survives in two command surfaces left out of scope — `graduate-resource.md:154` ("Push automatically after the commit") and `resolve-incident.md:237` ("push happens automatically after commit"). Command files are followed literally and are autosynced protected zones (higher stakes than doc prose). Phase 1 closes 2 of ~4 live copies; the contradiction is not fully resolved until the command copies are corrected in a later phase.
- Root's Autonomy list shrinks from 10 items to a 4-item shortlist+pointer: 6 pause-triggers leave the always-loaded surface. Not a parse break, but a behavioral-visibility reduction (a pause-trigger scenario now relies on Claude reading autonomy-rules.md rather than the always-loaded root list).

### Dimension 4: Reversibility
**Risk:** Low

- All 9 edits are prose-markdown changes in the working tree; a single `git revert` fully restores prior state. No sibling files or directories created, no `settings.json` change, no schema/log/registry mutation.
- No state propagates beyond git: no push (commits batch to the gated `/wrap-session` confirmation per root CLAUDE.md § Push behavior), no Notion/external write, no auto-commit, no hook/cron/symlink added that could fire between landing and a potential revert. Evidence: "No behavior actually changes except the two push-wording corrections … and the deprecated-command-name fixes."
- Reverting cleanly restores the *contradictory* prior state — an acceptable rollback property (revert is clean; it just undoes the fix), not a reversibility hazard.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Latent parse-contract coupling (not triggered here, but real):** session-rituals.md's `## Session Start` / `## Phase 3` / `## Session End` headings and their command tokens are a machine-parsed contract for `/list-critical-resources` (lines 84–85). This contract is documented *in the consumer* (list-critical-resources.md), not *at the change site* (session-rituals.md has no in-file marker saying its headings are load-bearing). An editor working only in session-rituals.md cannot see the coupling. This Phase's edit stays clear of it, but the coupling is invisible from the edit site.
- **Residual divergence coupling:** collapsing duplicates to a single canonical copy is the correct de-coupling move, but Phase 1 applies it to only the doc/CLAUDE.md copies. The push rule remains asserted in two *un-collapsed* command copies (`graduate-resource.md:154`, `resolve-incident.md:237`), so multiple surfaces still state the same rule and now diverge — the exact failure the collapse strategy is meant to eliminate, left half-applied.
- **Pointer-resolution coupling (mild, documented at site):** each new root/ai-resources pointer depends on the canonical doc's section still existing under the named heading; if a target heading is later renamed, the pointer dangles. Standard DR-5-exception pointer coupling; low if the pointer names its target section explicitly.
- No silent auto-firing, no new cross-session side effect, no new hook-ordering concern.

### Dimension 6: Principle Alignment
**Risk:** Low

- **DR-5 (CLAUDE.md holds cross-session rules only; "every line loads every turn; only every-turn content earns its place"; pointer acceptable, verbatim duplication is not).** The change is a direct application of DR-5 — collapsing verbatim duplication to pointers. principles-base GAP-3 records CLAUDE.md intentional duplication as a *recognized* DR-5 exception, but this change targets *unnecessary* duplication and outright *contradiction*, squarely pro-DR-5. Aligned.
- **OP-3 / OP-11 (loud failure over silent continuation; surface and resolve practice-vs-principle divergence loudly, never silent drift).** Fixing the push-wording contradiction corrects a documented silent divergence between the written rule and the canonical/practiced gated-push rule (inverted 2026-05-29). This is drift *correction*, the legitimate OP-11 mechanism, not new drift. The Phase-1 deferral of the two command copies is itself acknowledged (recorded in an approved plan), so the partial closure is loud, not silent. Aligned.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction; generalize only on a second confirmed consumer).** The change adds no hook, no generalization, no infrastructure, and introduces no new contract with zero consumers — the Consumer Inventory found it *removes* duplicated content rather than adding a speculative one. No speculative-abstraction signal. Aligned.
- **OP-12 (closure before detection).** The change adds no new detection/scan/flag; it *closes* a known finding (the push contradiction, previously logged across multiple audits). Counts *for* the change. Aligned.
- **OP-5 (advisory vs enforcement) / OP-10 (system boundary) / DR-1·DR-3 (placement).** No advisory→enforcement upgrade, no cross-tool scope expansion, no resource re-homed. All neutral/aligned.
- principles-base.md was readable (frozen-ID set, 41 active principles); IDs above are cited from it directly.

## Mitigations

- **Blast Radius / Hidden Coupling — parse-contract safety:** confine the session-rituals.md edit strictly to the `## Before Committing` block (line ~90). Do NOT alter the `## Session Start`, `## Phase 3` START/DURING/END, or `## Session End` sections or their command tokens — `/list-critical-resources` parses them (list-critical-resources.md lines 84–85). Post-edit, confirm those three sections are byte-unchanged. Optionally add a one-line "load-bearing: parsed by /list-critical-resources" in-file comment near those headings to make the latent coupling visible to future editors.
- **Blast Radius — partial-closure gap:** record explicitly (plan file or session-notes) that Phase 1 leaves two command-surface copies of the push contradiction unfixed — `.claude/commands/graduate-resource.md:154` and `.claude/commands/resolve-incident.md:237` — and schedule them into a named later phase. Command copies are executed literally (higher stakes than doc prose); the contradiction is not fully closed until they are corrected. Before closing Phase 1, re-grep for any *other* surviving "push automatically / proceeds autonomously" copy on an always-loaded or parsed surface.
- **Blast Radius — always-loaded gate visibility:** verify the root 4-item Autonomy shortlist retains the highest-stakes / highest-frequency gates (destructive git ops, external/shared-state writes incl. `git push`, prompt-injection, ambiguous-load-bearing) so no consequential pause-trigger relies solely on a reader following the pointer into autonomy-rules.md.
- **Hidden Coupling — pointer durability:** have each collapsed pointer name both the canonical file AND the specific section heading it targets (e.g., "full list: `docs/autonomy-rules.md` § Pause-trigger enumeration"), so a future rename breaks the pointer loudly rather than dangling silently.
- **Process — protected-zone QC:** run an independent post-edit `/qc-pass` — this change edits three `/risk-check`-mandatory protected zones (root CLAUDE.md, autonomy-rules.md, qc-independence.md per protected-zones.md); the QC-Independence skip conditions do not apply to a multi-file structural consolidation of this size.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-phase-1-instruction-leanness-risk-check-second-opinion.md`

**Routing:** In-place consolidation, not a relocation — the files are already at their canonical homes. Canonical-plus-pointer is the correct expression of `principles.md § DR-5`, so the change is principle-*positive*, not just neutral. Correctly DR-8-gated under the two-gate model (`§ DR-8`; repo-architecture Q5).

**Concur with PROCEED-WITH-CAUTION — yes.** Both Mediums map to real entries: workspace-root + ai-resources CLAUDE.md are Critical load-bearing (`risk-topology.md § 1`); the `/list-critical-resources` parse contract is the exact two-end-contract elevate-signal (`§ 5`). Stays Medium (not higher) because this is prose-consolidation, not behavioral change.

**The 5 mitigations are right, with 4 amendments:**
- (3a) Verify the autonomy shortlist preserves each gate's *trigger conditions*, not just its presence — a gate whose conditions are compressed away mis-fires (`OP-6`, `AP-3`).
- (4a) Pointers must target stable anchors (principle ID / heading), **never line numbers** — the two deferred copies are cited by line number, the most fragile form.
- (5a) Post-edit QC must be context-isolated (subagent/fresh session, not self-check) over final scope (`QS-1`).
- Add a step: classify each duplication as accidental (collapse) vs. deliberate DR-5-mirror (keep) before collapsing.

**Fix the 2 command copies now — do not defer.** They are the same defect class the campaign closes; deferring leaves a *known* contradiction live (`OP-3`, `AP-1`, `OP-11`), parks detection ahead of closure (`OP-12`), and relies on a weak memory-dependent gate. Cost is a ≤5-line mechanical fix (`QS-2`) and the end-time `/risk-check` already fires. Named conflict: folding them in widens the class to "canonical command edit → all projects" (`risk-topology.md § 3`) — so extend the end-time consumer inventory + QC to cover both files. Defer only if either copy's push text is itself a two-end contract (reviewer says it is not).

**Risks the review missed:**
- **R-1 (top):** collapsing a *deliberate* DR-5-exception mirror. If ai-resources CLAUDE.md is opened standalone, a pointer whose canonical target is unloaded breaks. Classify before collapsing.
- **R-2:** the consolidation *manufactures* new pointer→canonical two-end contracts — a future rename silently breaks every pointer. Amendment 4a is the mitigation.
- **R-3:** cumulative drift across 9–11 iterated always-loaded files is invisible to any single QC pass — run `/contract-check` at wrap against the frozen leanness mandate.

**Position:** PROCEED-WITH-CAUTION, adopt 5 mitigations + 4 amendments, fix the 2 copies in-phase, `/contract-check` at wrap.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and the referenced files, and principle IDs read from `projects/strategic-os/ai-strategy/principles-base.md`). The plan file was not in REFERENCED_FILE_PATHS and was not read; its contribution was evaluated from CHANGE_DESCRIPTION only, noted under Referenced files. No training-data fallback was used on any read.
