# Session Plan — 2026-06-04

## Intent
Implement two AI-strategy deliverables into `/risk-check`: (1) add a principle-alignment dimension so changes are assessed for fit with the system's operating principles, not only technical risk; (2) add a reliable pre-spec consumer-inventory step (grep-based blast-radius) so affected consumers are identified before a change is approved.

## Model
opus — match (designing a new principle-grounded review dimension + a reliable inventory process is judgment work).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md` — the 5-dimension reviewer (primary edit surface)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md` — the orchestrator (count + validation + display sync edits)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/principles-base.md` — frozen-ID principle index (Dimension 6 grounding)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change-class list (referenced by both deliverables)

## Findings / Items to Address
1. **Deliverable 1 — Principle Alignment (new Dimension 6).** The reviewer scores five *technical* risk dimensions (cost, permissions, blast radius, reversibility, hidden coupling) but never asks whether the change *fits the operating principles*. Add Dimension 6 grounded in the frozen principle set — most-relevant checks for structural changes: OP-12 (closure before detection), OP-9/AP-7/DR-7 (speculative abstraction / build for absent consumers), OP-10 (system-boundary expansion needs an explicit decision), OP-5 (advisory vs enforcement automation), OP-11/OP-3 (a principle revision must be loud, never silent drift). Source: `principles-base.md` lines 26–50.
2. **Deliverable 2 — Consumer Inventory (new pre-dimension step).** Grep-based caller-counting currently lives *inside* Dimension 3 (Blast Radius) and is ad-hoc ("Use Grep/Glob ... to quantify", agent line 76). Promote it to an explicit, reliable **Step 1.5 — Consumer Inventory** that runs before dimension scoring, produces an explicit `consumer path → reference type` list, and feeds Dimension 3. Make the inventory visible in the report (`## Consumer Inventory`) and the chat summary so blast radius is explicit *before* approval.

## Execution Sequence
1. **Agent — Consumer Inventory step.** Insert `### Step 1.5: Consumer Inventory` after Step 1 (grounding), before Dimension 1. Verify: a reliable grep recipe (by filename, component name, contract markers) producing an explicit inventory list. ✓ when the step names concrete grep targets and an output shape.
2. **Agent — wire Dimension 3 to the inventory.** Dimension 3 consumes the Step 1.5 inventory rather than ad-hoc grep. ✓ when Dimension 3 references the inventory.
3. **Agent — Dimension 6 (Principle Alignment).** Insert `### Step 6.5: Dimension 6 — Principle Alignment` after Dimension 5, grounded in the named principle IDs with Low/Medium/High calibration (Low=aligned, Medium=tension, High=clear violation). ✓ when calibration + principle citations present.
4. **Agent — Step 7 verdict + Step 8 report template + Step 9 summary.** Update "five dimensions" → "six"; add `## Consumer Inventory` and `### Dimension 6` to the report template; add `- Principle alignment:` and a consumer-count line to the summary. ✓ when all three sub-sections updated and internally consistent.
5. **Command — sync edits.** Line 5 "five" → "six"; Step 4 validation "(1–5)" → "(1–6)"; Step 5 display add `- Principle alignment:` + consumer-count line. ✓ when command's count/validation/display match the agent's new contract.
6. **`/qc-pass`** on both edited files (fresh-context independent review). Resolve via `/resolve` if findings surface.
7. **Commit** both files together (command↔agent contract must land atomically).

## Scope Alternatives
- **Min:** Dimension 6 only (Deliverable 1) — defer the inventory promotion.
- **Recommended:** both deliverables (Dimension 6 + Consumer Inventory) — they are independent and both small; the inventory also strengthens Dimension 6's boundary check.
- **Max:** + add a `## Consumer Inventory` parse/validation rule to the command's Step 4 structural validation. Deferred — adds parse-contract surface for marginal value; the inventory is advisory-visible, not a gated section.

## Autonomy Posture
Full autonomy — additive, bounded to two files, git-revertible, command+agent edited in sync. `/qc-pass` before commit catches judgment errors.

**Stop points:**
- None. (QC DISAGREE on an editorial call would pause per workspace rules.)

## Risk
Edits an existing backbone command + its reviewer agent. Not in the gated structural classes per `audit-discipline.md` (not a hook / permission / cross-cutting CLAUDE.md / new command / symlink / shared-state automation). The one real risk is the command↔agent **contract** (dimension count: 5→6) — handled by editing both files together and QC'ing before commit. `/risk-check` itself is advisory here (additive + reversible); run it if scope grows. Mild note: the change edits the risk-checker, so QC stands in for a self-referential risk-check.
