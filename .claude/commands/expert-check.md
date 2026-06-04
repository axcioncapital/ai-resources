---
model: sonnet
---

# /expert-check — Compare a drafted step against best-principle reference material

Run an independent **Expert Check** on the work you just drafted: an agent reads the relevant book summaries in a knowledge-base (KB) vault, compares your draft against those principles, and returns advisory divergence findings. Use it after a project step is drafted to confirm the work follows the best principles the firm has chosen to ground on.

**Advisory only — never blocking.** The KB summary is a reference lens, not a binding spec. Expert Check surfaces divergences for operator judgment; it does not gate the step.

**Arguments:** `$ARGUMENTS` — optionally the KB target (a vault name under `knowledge-bases/`, or an absolute path) and/or the artifact path. Anything missing is collected in Step 2.

## Why a subagent?

You drafted the work — you cannot objectively measure it against an external framework. The `expert-check-reviewer` runs as a separate agent with no access to your conversation, so the comparison is independent (same rationale as `/qc-pass`).

## Boundary — what this is NOT

- **`/expert-check`** tests the draft against **external KB principles** (does it follow the book's method?).
- **`/qc-pass`** tests the artifact against **its own criteria** (is it internally correct, in-scope, sound?).
- **`/refinement-pass`** polishes prose and structure.

Run them for different reasons. Do not use Expert Check to catch internal defects, and do not use `/qc-pass` to check framework adherence.

## Steps

1. **Identify the drafted step.** State in one line what you are checking (which step / artifact) and its file path(s).

2. **Resolve the inputs.** Gather, asking the operator for anything not derivable:
   - **Artifact** — the file path(s) of the drafted work (or content if unwritten).
   - **Step subject** — one line naming what the work is about (drives topic-matching).
   - **KB target — REQUIRED.** The vault to check against (a name under `knowledge-bases/`, or an absolute path). There is **no "search all KBs" default** — if the operator has not named a KB, ask which one. Do not guess.
   - **Intent of the step** — one line on what the work is supposed to achieve.

3. **Launch the `expert-check-reviewer` subagent.** Pass it the four items above (artifact, step subject, KB target, intent). Do NOT pass conversation history or your reasoning.

4. **Present the results verbatim.** Show the subagent's output exactly as returned — including `ALIGNED`, `DIVERGENCES FOUND`, or `NO APPLICABLE REFERENCE`. Do not filter or soften divergences.

5. **State the closure path, then wait.** Findings are advisory inputs, not decisions. Offer the operator the ways to act:
   - Route the divergences through `/decide` or `/resolve` for a structured disposition, OR
   - Disposition them inline (accept / reject / revise each), OR
   - Note them and proceed (the check is advisory; the step is not blocked).

   The operator decides whether and how to act. Do not auto-apply reconciliations.
