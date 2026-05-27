# Risk Check — 2026-05-26

## Change

**Proposed change: Item C of session 2026-05-26 — extend `/spec-evaluate` to parallel-run a new `spec-drift-evaluator` agent alongside `spec-evaluator`, merging both verdicts into `spec-qc-verdict.md` using the canonical `**Verdict:**` top-line + four-section schema. Mirror of the just-landed `/plan-evaluate` extension (commit `4f4c3ff`).**

**Files affected:**
- `projects/project-planning/.claude/agents/spec-drift-evaluator.md` — NEW agent file (~95 lines; mirror of plan-drift-evaluator with spec-vs-plan lenses)
- `projects/project-planning/.claude/agents/spec-evaluator.md` — MODIFIED: output-protocol change (return markdown to dispatcher instead of writing verdict file to disk); interior `### Verdict:` heading renamed to `### Section-Verdict:` to disambiguate from canonical merged top-line (per system-owner advisory)
- `projects/project-planning/.claude/commands/spec-evaluate.md` — REWRITTEN: 6-step single-subagent → 8-step parallel-dispatch with canonical-line merge (mirror of `/plan-evaluate.md`)
- `ai-resources/.claude/commands/new-project.md` — NO EDIT (verify-only target; legacy `^\*\*Verdict:\*\*\s+\**PASS` grep at lines 89-94 preserved by canonical-line architecture)

**Change classes (per `audit-discipline.md`):**
1. **Command behavior change** — `/spec-evaluate` shape rewrite
2. **New agent** — `spec-drift-evaluator`
3. **Modified existing agent** — `spec-evaluator` output-protocol change (load-bearing piece per system-owner advisory)
4. **Consumer-parse contract preservation** — `spec-qc-verdict.md` schema shifts; legacy two-end contract preserved via canonical top-line

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/agents/spec-drift-evaluator.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/agents/spec-evaluator.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/commands/spec-evaluate.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/agents/plan-drift-evaluator.md` — exists (mirror source)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/commands/plan-evaluate.md` — exists (mirror source)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/pipeline/ref-tech-spec.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Change is a precedent-backed mirror of a working plan-side architecture with one elevated risk dimension (hidden coupling — the canonical-line trick has a load-bearing dependency on disciplined emission); single paired mitigation reduces that risk to acceptable.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New agent (`spec-drift-evaluator.md`, ~95 lines) is on-demand only — invoked solely by `/spec-evaluate`. Not auto-loaded, no hook registration, no `@import` chain in always-loaded files.
- Modified `spec-evaluator.md` (existing 76 lines per `log-sweep-project-project-planning-2026-05-18.md:37`) is also on-demand — output-protocol change does not add tokens to always-loaded surface.
- `/spec-evaluate.md` rewrite (6-step → 8-step) lives in command file; loaded only on command invocation. CHANGE_DESCRIPTION confirms "No hook or settings changes."
- No additions to workspace CLAUDE.md, project CLAUDE.md, or any SessionStart/Stop/PreToolUse hook.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION states: "No hook or settings changes."
- New agent file inherits the existing tool grants used by `spec-evaluator` (Read/Glob/Grep per `spec-evaluator.md:6-9`) — no new tool family, no Bash widening, no Write extension.
- No `allow`/`ask`/`deny` mutations; no scope escalation (project → user).

### Dimension 3: Blast Radius
**Risk:** Low

- Files directly touched: 3 (new `spec-drift-evaluator.md`, modified `spec-evaluator.md`, rewritten `spec-evaluate.md`). 1 verify-only file (`new-project.md`) — no edit.
- **Grep for `spec-qc-verdict` parsers** (excluding logs/output/Project Plans): only `ai-resources/.claude/commands/new-project.md:93-94` parses the file. All other matches in `projects/project-planning/pipeline/{architecture,implementation-spec,project-plan,implementation-log}.md` and `CLAUDE.md:35` are documentation-only mentions, not parsing logic. Operator's pre-lock grep confirmed.
- **Grep for `spec-evaluator` direct-write dependency**: only `projects/project-planning/.claude/commands/spec-evaluate.md:24` ("Save the verdict. Write the subagent's output to ...") depends on the current direct-write behavior. All other matches are doc references, audit reports, frontmatter — none execute the direct-write contract. Operator's pre-lock grep confirmed.
- Contract change to `spec-qc-verdict.md` schema is backwards-compatible at the legacy consumer's line: PASS / PASS-WITH-WAIVER both match `^\*\*Verdict:\*\*\s+\**PASS` (verified at `new-project.md:82-83`: "regex `^\*\*Verdict:\*\*\s+\**PASS` matches PASS and PASS-WITH-WAIVER").
- No cross-project propagation (project-local agent class per `repo-architecture.md:116`).

### Dimension 4: Reversibility
**Risk:** Low

- New `spec-drift-evaluator.md` deletes cleanly via `git revert` (no sibling files spawned).
- Modified `spec-evaluator.md` and rewritten `spec-evaluate.md` revert via single-file restore (`git revert` works fully).
- No data/log file mutations carried forward; no append-only state; no settings.json change requiring manual cleanup; no external write (push, Notion, API POST).
- No hook registered that could auto-fire between landing and a hypothetical revert.
- CHANGE_DESCRIPTION's self-classification ("Reversibility: High") is grounded.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Canonical-line emission is a silent contract.** The merge architecture relies on `/spec-evaluate.md` always emitting the `**Verdict:** {TOKEN}` line as the FIRST non-blank content of the merged file. If a future edit reorders the merge (e.g., adds a metadata block above the verdict line), the `^\*\*Verdict:\*\*` anchor in `new-project.md:94` silently fails (emits WARN instead of OK). The contract is documented in `plan-evaluate.md:20-25` (precedent file's "two-end contract" section); the mirror must carry the same documentation block. **Evidence:** verbatim quote from `new-project.md:86-87` — "Do not extend or modify this regex without coordinating with /plan-evaluate's verdict-write step" — this comment names only the plan side and will need updating to also name `/spec-evaluate` after the mirror lands. The risk is real but documentable.
- **Interior heading rename couples to the merge format.** The system-owner advisory's `### Verdict:` → `### Section-Verdict:` rename in `spec-evaluator.md:63` exists to disambiguate from the merged top-line. If a future edit re-renames the section heading without checking the merge dispatcher, the top-line grep could match the interior heading instead. This is the same coupling pattern the plan-side mirror introduced — managed there, must be carried over to spec side identically.
- **Lens-2 self-attestation delta.** CHANGE_DESCRIPTION notes that `spec-drift-evaluator` Lens 2 drops the "Compliance With Context Pack" self-attestation lookup present in `plan-drift-evaluator.md:35` ("Locate the plan's 'Compliance With Context Pack' section by NAME"). The justification — no equivalent target in `ref-tech-spec.md` — is grounded by reading the tech-spec reference (no compliance-self-attestation section in core sections at lines 19-50). This is a deliberate, documented delta, not a silent coupling.
- **Functional overlap check:** there is no existing drift-checking mechanism for specs in the repo (only the just-landed plan-side `plan-drift-evaluator`). No two-systems-handling-same-concern conflict.
- Net: one Medium-grade implicit dependency (canonical-line ordering discipline), which the precedent has already managed for two days without incident.

## Mitigations

- **Hidden coupling (Dimension 5):** In the rewritten `/spec-evaluate.md`, copy the verbatim "Verdict file shape — two-end contract" section from `plan-evaluate.md:20-25` (adjusted for spec terminology), so the canonical-line contract is documented at the change site. Additionally, in the `new-project.md:86-87` advisory comment, extend the line "Do not extend or modify this regex without coordinating with /plan-evaluate's verdict-write step" to also name `/spec-evaluate`'s verdict-write step. This is a one-line text edit to `new-project.md` and is the ONLY edit to that file required by this change set (CHANGE_DESCRIPTION's "NO EDIT" for `new-project.md` should be revised to reflect a one-line comment update — not a behavioral change, not a regex change).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Concur with verdict.** The Dimension 5 (hidden coupling) Medium rating is the correct read; recommended mitigation discharges it. Other four dimensions correctly tagged Low — precedent-backed mirror, blast radius is project-planning-local plus one already-documented upward edge to `new-project.md:89-94`. DR-7 compliant: the second confirmed consumer of the canonical-line + four-section pattern (`/spec-evaluate`) now exists, so mirroring the architecture is the right move — not speculative abstraction (`principles.md § DR-7`, `§ AP-7`).

**Two-end contract framing is correct vocabulary.** `risk-topology.md § 5` names this defect class explicitly: "Change modifies a string literal matched by another component (two-end contract)." Mitigation copies the verbatim contract section from `plan-evaluate.md:20-25` into `spec-evaluate.md` — the correct response per `principles.md § OP-3` (loud failure over silent continuation): document the contract at the change site so canonical-line discipline is enforceable by anyone editing the file in isolation.

**One-line comment update at `new-project.md:86-87` is not a "NO EDIT" violation.** Extending an advisory comment to name a second producer is a non-behavioral edit — the regex stays untouched, no consumer logic changes, no new parser is introduced. Correct application of `principles.md § OP-3` at the consumer end of a two-end contract.

**Risk the dimension review did not name: lateral consumer `/spec-draft`.** `plan-evaluate.md:25` calls out: *"The four-section schema below the verdict line is parsed by `/spec-draft`, NOT by this command. Do not break this contract without updating `/spec-draft` in the same change."* The mirror change inherits the same dependency on `/spec-draft` continuing to parse the four-section schema correctly. The recommended mitigations cover the upward consumer (`new-project.md`); they do NOT address the lateral consumer (`/spec-draft`).

**Extension to mitigation plan:** verify, before commit, that `/spec-draft` does not need a corresponding parser update for `spec-qc-verdict.md`'s four-section schema. If `/spec-draft` only reads `plan-qc-verdict.md` (already verified earlier this session in a /qc-pass on the session plan), this is a no-op confirmation. If `/spec-draft` reads both, the four-section heading discipline must be preserved identically. 30-second grep — costless to add, and closes the only remaining open coupling.

**Position:** Proceed with mitigation as proposed plus the one-step extension above. End-time gate (session-plan Step 10.5) should verify both: (a) verbatim contract section landed in rewritten `/spec-evaluate.md`, (b) `/spec-draft.md` parser behavior is preserved or updated in the same commit.
