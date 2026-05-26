# Risk Check — 2026-05-26

## Change

Evaluate the proposed structural change: extend `/plan-evaluate` (a project-planning pipeline-gate command) to run a second, parallel drift-QC subagent in addition to the existing structural QC, and merge both verdicts into a new four-section `plan-qc-verdict.md` shape. Plan: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/plans/plan-evaluate-drift-check.md` (QC-passed).

Pre-filled brief (from the plan):

- **Change class:** Edit to an existing command (`/plan-evaluate`) that is a pipeline gate before `/spec-draft`. Adds a new subagent invocation (`plan-drift-evaluator` — new project-local agent file). Changes verdict semantics (PASS now requires two-verdict alignment; new tri-state drift verdict; new operator-waiver mechanism for MINOR-DRIFT).
- **Blast radius:** Project-planning pipeline only. No cross-project propagation. Every plan that goes through Stage 2 of this pipeline runs through `/plan-evaluate`, so the change is load-bearing for all project-planning outputs.
- **Reversibility:** Full — Edit revert restores the prior single-QC behavior. No persistent state schema change. New agent file can be deleted.
- **Hidden coupling risk:** Medium. The merged verdict file shape changes from a single-verdict file to four sections (`## Structural QC`, `## Drift QC`, `## Combined verdict`, `## Operator waiver`). Downstream consumer `/spec-draft` will be updated in the same session (plan acceptance #4). Implementation session must grep for `plan-qc-verdict` across the project before landing (plan acceptance #6).
- **Permissions surface:** No change — subagent dispatch already permitted.
- **Usage cost:** One additional subagent invocation per `/plan-evaluate` call (drift QC). Plans run through `/plan-evaluate` once or twice per project — cost is bounded.
- **Cross-model boundary:** Drift QC runs on Opus (judgment work — lens interpretation under ambiguity). Declared in new agent file's `model: claude-opus-4-7` frontmatter.

Expected verdict per the plan: PROCEED-WITH-CAUTION. Mitigations: (a) downstream-consumer audit before landing (plan acceptance #6); (b) legacy file-shape fallback in `/spec-draft` (plan lines 137–142); (c) primary + secondary test fixtures must both pass before commit (plan acceptance #5).

This is the plan-time gate (Autonomy Rule #9). A second `/risk-check` run is planned pre-commit (end-time gate).

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/plans/plan-evaluate-drift-check.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/commands/plan-evaluate.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/agents/plan-drift-evaluator.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/commands/spec-draft.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/agents/plan-evaluator.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Reversible, well-scoped pipeline-gate edit with strong test discipline, but the plan's "project-planning only" blast-radius claim misses one cross-project parsed reader (`ai-resources/.claude/commands/new-project.md`) whose grep pattern will silently break against the new four-section verdict file shape; the audit scope must extend to `ai-resources/` before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Adds one extra Opus subagent invocation per `/plan-evaluate` call — evidence: plan line 64 ("Step 5 — Launch the drift QC subagent. New."). Plans run through `/plan-evaluate` once or twice per project (plan line 153), so this is on-demand pay-as-used, not auto-loaded.
- No content added to always-loaded files (workspace `CLAUDE.md`, project `CLAUDE.md`) — the change lives in a slash-command file and a new agent file, both loaded only when invoked.
- No hook registration (SessionStart, Stop, PreToolUse, UserPromptSubmit). Confirmed from plan body — no hook-section reference.
- The drift agent's three-lens brief is embedded in the new agent's system prompt (plan line 83), spawned only when `/plan-evaluate` runs. Plan line 64 explicitly notes the brief is NOT re-embedded in the dispatcher prompt — keeps the always-loaded surface unchanged.
- The two QC subagents are dispatched in a single tool-call message for parallel execution (plan line 65) — no serial cost stack.

### Dimension 2: Permissions Surface
**Risk:** Low

- Plan explicitly states no permission changes ("Permissions surface: No change — subagent dispatch already permitted." — plan line 152).
- New agent file declares `tools: [Read, Glob, Grep]` (plan line 48) — strictly read-only, matching the existing `plan-evaluator.md` pattern (verified in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/agents/plan-evaluator.md` lines 5–8).
- No `allow`/`ask`/`deny` rule changes implied or required.
- No new tool family or external API access introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grep across `projects/project-planning/` for `plan-qc-verdict` produced ~30 matches. Classification:
  - **Parsed readers (must update):** `projects/project-planning/.claude/commands/spec-draft.md` line 11 (existing loose PASS/FAIL read — plan addresses this in plan lines 137–142).
  - **Human-readable references (no change needed):** `CLAUDE.md` line 34, `pipeline/architecture.md` lines 55/87, `pipeline/implementation-spec.md` lines 349/385/537, log files, scratchpads, and the verdict files themselves.
- **Cross-project parsed reader the plan missed:** `ai-resources/.claude/commands/new-project.md` lines 78–82. This command consumes `plan-qc-verdict.md` from project-planning outputs at `/new-project` Stage 3 and uses `grep -qE "^\*\*Verdict:\*\*\s+\**PASS"` to detect the PASS verdict. The new four-section shape (plan lines 65–72) does NOT emit a top-level `**Verdict:** PASS` line — the closest equivalent is the `## Combined verdict` one-liner inside its own section, which does not match the existing regex. Result: silent fallback to "WARN: plan-qc-verdict.md does not show PASS — proceeding anyway" for every QC-passed plan handed to `/new-project`.
- The plan's "Blast radius: project-planning pipeline only. No cross-project propagation." claim (plan line 149) is contradicted by this cross-project reader. The plan's downstream-consumer audit acceptance #6 (plan line 167) scopes the grep to `projects/project-planning/` and `Project Plans/` only — `ai-resources/` is not in that scope and would miss this reader.
- Contract change to `plan-qc-verdict.md` file shape (single-verdict → four sections) is backwards-incompatible for any parser keyed on a top-level `**Verdict:**` line. `/spec-draft` gets fixed in-session; `new-project.md` does not, under the current acceptance criteria.
- 1 confirmed parsed reader requiring update in-scope; 1 confirmed parsed reader requiring update out-of-scope (per current plan).

### Dimension 4: Reversibility
**Risk:** Low

- Primary file is a slash-command Edit (`.claude/commands/plan-evaluate.md`); `git revert` restores prior behavior cleanly. Plan line 150 ("Full — Edit revert restores the prior single-QC behavior. No persistent state schema change.") is accurate for this file.
- New agent file `plan-drift-evaluator.md` is git-tracked; `git revert` removes it from the tree. No sibling state.
- `/spec-draft` edit is a single-file modification (`.claude/commands/spec-draft.md`); revertible.
- `plan-qc-verdict.md` is a per-project output file, overwritten on each QC run — no append-only log to clean up. Existing four-section files would be regenerated as single-verdict files on the next `/plan-evaluate` run after revert.
- The plan's legacy-fallback in `/spec-draft` (plan lines 137–142) means that during the rollout window, both file shapes are readable; revert during this window does not strand any verdict file.
- No external writes (push, Notion, API POST). No hook/cron/symlink automation registered by this change.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- New contract: the four-section file shape (`## Structural QC` / `## Drift QC` / `## Combined verdict` / `## Operator waiver`) is the implicit interface between `/plan-evaluate` and any downstream parser. The contract is documented inside the `/plan-evaluate.md` body (plan lines 65–72) but is not visible from `/new-project`'s consumption site in `ai-resources/`.
- Operator-waiver mechanism (plan line 69) introduces a quiet operator-side workflow: operator must edit `## Operator waiver` in-place between `/plan-evaluate` and `/spec-draft` for MINOR-DRIFT cases. This is documented in the announce matrix (plan line 78) but is a new convention the operator must remember; no automation enforces the in-between step.
- Context-pack path resolution (plan line 56) implicitly depends on the canonical filename `context-pack.md` (or versioned `context-pack-v{n}.md`) inside `output/{project-name}/` — a convention that holds today but could shift if the context-pack workflow changes naming. Plan handles this with a SKIPPED fallback (plan line 61), which softens the coupling.
- Functional overlap check: there is one prior ad-hoc drift verdict file on disk — `Project Plans/strategic-os/plan-drift-check-verdict.md` (referenced from plan line 166). This is a one-off artifact from the original 2026-05-26 manual drift QC, not an active concurrent mechanism — no live overlap.
- The `plan-evaluator` subagent contract returns markdown with `**Verdict:** PASS / FAIL` as the top-level verdict line (verified in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/agents/plan-evaluator.md` line 63 — `### Verdict: {PASS / FAIL}`). The dispatcher will embed this verbatim inside `## Structural QC`, which means the existing `^\*\*Verdict:\*\*` regex in `new-project.md` line 79 may still pattern-match against the structural section's verdict line if section nesting permits — but since the structural agent's output uses `### Verdict:` (heading), not `**Verdict:**` (bold), the regex will NOT match and will fall through to the WARN branch. This is an asymmetric coupling the plan does not surface explicitly.

## Mitigations

- **Dimension 3 mitigation (extend audit scope to `ai-resources/`):** Before landing, the implementation session must grep `plan-qc-verdict` across `ai-resources/` in addition to the plan's scoped `projects/project-planning/` and `Project Plans/` directories. Specifically, update `ai-resources/.claude/commands/new-project.md` lines 78–82 so the verdict probe recognises the new file shape: either (a) replace the regex with one that matches `## Combined verdict` line variants (`PASS — green-light`, `PASS with operator waiver required`, `PASS with caveat`, `BLOCK`) and emit WARN only on `BLOCK` / `FAIL`, or (b) keep the legacy regex as a fallback path and add a parallel `## Combined verdict` parse that takes precedence when the new section exists. Whichever option is chosen, add a one-line acceptance criterion to the implementation session: "`ai-resources/.claude/commands/new-project.md` updated to recognise the new file shape; legacy fallback retained for older verdict files." This extends plan acceptance #6.
- **Dimension 5 mitigation (document the new contract at the change site):** In the edited `/plan-evaluate.md`, add a short "Verdict file shape contract" block (3–5 lines) that names the four sections and the Combined verdict line variants — so any future reader of the command sees the contract without having to grep the plan or read the announce matrix. Mirror this brief contract in a comment inside `ai-resources/.claude/commands/new-project.md` near the verdict-check block so the cross-project consumer documents what it expects to find.

## Recommended redesign

(Section omitted — verdict is PROCEED-WITH-CAUTION, not RECONSIDER. Paired mitigations above resolve the elevated dimensions.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: plan file line citations (plan lines 56, 61, 64, 65, 69, 78, 83, 137–142, 149–153, 167); existing command/agent file inspection (`projects/project-planning/.claude/commands/plan-evaluate.md`, `projects/project-planning/.claude/agents/plan-evaluator.md`, `projects/project-planning/.claude/commands/spec-draft.md`); cross-repo grep for `plan-qc-verdict` producing ~30 matches enumerated and classified; verbatim quotes from `ai-resources/.claude/commands/new-project.md` lines 78–82 establishing the cross-project parsed-reader gap. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — `/plan-evaluate` Drift-QC Extension

## Routing position

Routing baseline (from `repo-architecture.md`) is correct as the risk-check verdict and the brief describe it:

- `/plan-evaluate` is a project-local pipeline-stage command (per `repo-architecture.md` § Project-local exceptions) — edits stay in `projects/project-planning/.claude/commands/`.
- The new `plan-drift-evaluator` agent is a project-local evaluator (same exception class as the existing `plan-evaluator`, `spec-evaluator`, `context-evaluator`) — stays in `projects/project-planning/.claude/agents/`.
- `plan-qc-verdict.md` is a project-output artifact under `projects/project-planning/Project Plans/{project}/`.

Routing is sound. The architectural defect is not "where things go" — it's the **two-end contract** between `/plan-evaluate` (producer) and `new-project.md` (consumer). That contract is the load-bearing concern, and the routing layer doesn't cover it.

## Architectural commentary

### 1. Verdict: we concur with PROCEED-WITH-CAUTION, but with one binding mitigation upgrade.

The risk-check verdict is correctly calibrated for this change. Reversibility is genuinely Low (Edit revert restores prior behavior), permissions are unchanged, and the scope is well-bounded. The reviewer's Hidden Coupling = Medium reflects the real exposure: the verdict file shape is a two-end contract that the plan does not name as such, and the cross-project consumer was missed. That misclassification is what the mitigations must close — not the verdict tier itself.

Escalation to RECONSIDER is **not** warranted, because:

- The pre-existing always-WARN state means the cross-project consumer is currently broken in a soft way (warns, proceeds). The new shape preserves that broken behavior — it does not introduce a new break (risk-topology.md § 1 High table; the consumer is downstream of a non-load-bearing artifact for *runtime* behavior, but is a two-end contract for *workflow* behavior).
- Reversibility remains genuinely Low (single Edit revert) — the dominant risk dimension. RECONSIDER is reserved for changes where the operator cannot cheaply back out.

The binding mitigation upgrade: **the audit scope must extend to `ai-resources/` and to any other cross-project reader of `plan-qc-verdict.md`, not just `projects/project-planning/` and `Project Plans/`**. The plan's line 149 blast-radius claim ("project-planning pipeline only. No cross-project propagation") is factually wrong — `new-project.md` lives in `ai-resources/.claude/commands/` and reads `plan-qc-verdict.md` during Stage 3 ingestion. That claim must be revised in the plan before landing, or DR-9 (top-3 analysis) is silently violated (`principles.md § DR-9`).

### 2. The "single canonical `**Verdict:**` line" architectural fix is the right answer.

The operator's proposed cleaner fix — emit a canonical `**Verdict:**` line at the top of the new merged file so the legacy regex keeps working, with the new four sections below — is architecturally superior to the plan's "update the consumer to parse the new shape" mitigation. Three reasons:

**(a) Preserve the legacy interface; add to it. Don't break it.** The legacy `^\*\*Verdict:\*\*\s+\**PASS` regex is the documented two-end contract between the producer and every existing reader. Changing the file shape so the legacy regex stops matching forces every consumer to update in lockstep. Adding a canonical `**Verdict:**` line at the top means existing consumers keep working without coordinated changes — and new consumers can opt into the richer section-based parse. This is the same pattern `risk-topology.md § 5 — Signals that elevate a change to structural risk` warns against ("Change modifies a string literal matched by another component") — the cleanest mitigation is to *not* change the string literal.

**(b) It defers DR-7 (generalize only when a second confirmed consumer exists).** The plan adds a four-section schema for a single confirmed consumer (`/spec-draft`). Updating `new-project.md` to parse the new shape adds a second consumer of the new schema — but the new schema's *value* over the old single-line verdict is only realized when a consumer cares about the Drift QC verdict separately from the Combined verdict. `new-project.md` doesn't care about that distinction; it just needs PASS/FAIL. Forcing it onto the new schema is speculative coupling (`principles.md § DR-7`, `principles.md § AP-7 — Speculative abstraction`). The canonical `**Verdict:**` line at the top means new-project.md keeps reading what it already reads, and `/spec-draft` (the genuine second consumer) gets the new schema.

**(c) The fix matches the "two-end contract" framing in risk-topology.md.** `risk-topology.md § 3` flags `friday-checkup.md` source-label strings as "two-end contracts" exactly because string-literal coupling between producers and consumers is fragile. The same framing applies here: the `**Verdict:** PASS` line IS a two-end contract. The architectural move is to preserve it as the stable interface and layer the new schema underneath.

**Recommended implementation:**
- First line of the merged `plan-qc-verdict.md` body: `**Verdict:** {PASS | PASS-WITH-WAIVER | FAIL | BLOCK-DRIFT}` — derived mechanically from the Combined verdict announce matrix.
- The four sections (`## Structural QC`, `## Drift QC`, `## Combined verdict`, `## Operator waiver`) follow as the plan currently specifies.
- `/spec-draft` reads the section structure (already requires it for waiver handling); `new-project.md` reads the top-line — no change required at `ai-resources/.claude/commands/new-project.md` lines 78–82.
- The pre-existing always-WARN state in `new-project.md` is a separate defect (the current `/plan-evaluate` writes `## Verdict: PASS`, which the regex never matched). Fix it as a sibling commit, but keep it out of this plan's scope to preserve scope discipline (`principles.md § OP-9` — paired constraint).

### 3. Document the contract at both ends.

The plan's recommendation #2 (document the contract at both ends) is correct and should land regardless of which fix path the operator picks.

## Position

The right answer is:

1. **Concur with PROCEED-WITH-CAUTION.** Do not escalate to RECONSIDER — reversibility remains genuinely Low.
2. **Adopt the canonical `**Verdict:**` line architectural fix** as a strict replacement for the plan's "update new-project.md" mitigation.
3. **Fix the plan's blast-radius claim** before landing — line 149 must name `ai-resources/.claude/commands/new-project.md` as a cross-project consumer, even if the canonical-verdict-line fix means no edit is needed there.
4. **Extend acceptance #6's audit scope** from `projects/project-planning/` + `Project Plans/` to also include `ai-resources/` — regardless of which fix path is chosen, the audit must verify the scope claim.
5. **Add a two-end-contract advisory** at both ends of the contract (recommendation #2 in the report) — keep it as written; it's correct.
6. **Track the pre-existing always-WARN bug** in `ai-resources/.claude/commands/new-project.md` lines 78–82 as a separate improvement-log entry. The current regex `^\*\*Verdict:\*\*\s+\**PASS` doesn't match the existing `## Verdict: PASS` shape. Sibling fix to this change, not part of it.

If the operator chooses to keep the plan's original "update new-project.md parser" mitigation instead of the canonical-verdict-line fix, that's defensible — but the trade-off is a confirmed DR-7 / AP-7 violation in exchange for slightly cleaner downstream consumer code. We'd choose the canonical-verdict-line fix; the operator picks.
