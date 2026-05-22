# Risk Check — 2026-05-19

## Change

Add an early infrastructure-briefing system-owner touchpoint (Step 6a) to the AI Development Lab pipeline, splitting the existing Step 6 into Step 6a (Function A system-owner dispatch for current-infrastructure inventory before the ai-engineer) and Step 6b (ai-engineer dispatch with briefing as additional input). Also extends the Step 2 resume logic, updates cost-field validation strings in analyze-transcript.md (lines 160, 200), adds coupling note to ref-step7-brief.md, updates ai-engineer.md Input section and instruction, updates project CLAUDE.md wording, and appends a D4-amendment decision entry to logs/decisions.md. The system-owner agent itself is not modified; it is consumed as-is. Step 7 and its brief structure are untouched.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/analyze-transcript.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/pipeline/ref-step7-brief.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/agents/ai-engineer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/decisions.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A self-contained per-run change with no token cost to always-loaded files and no permission widening, but it introduces a second system-owner dispatch with an unstated Function-A brief contract, mutates a HARD cost-validation string and the resume predicate, and silently overloads a mirror-source reference doc — all of which carry High coupling and Medium blast radius unless paired mitigations are applied.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change touches only on-demand pipeline artifacts: `analyze-transcript.md` is a slash command (`model: sonnet`, `analyze-transcript.md:3`), not an always-loaded file — it loads only when `/analyze-transcript` is invoked. No ongoing per-session token cost.
- No hook is added or modified. The change description names no SessionStart / Stop / PreToolUse / UserPromptSubmit registration; the only hook mentioned anywhere in repo context is the pre-existing SessionStart command-sync hook (project CLAUDE.md § Cross-project coupling notes), which this change does not touch.
- No `@import` chain is added. The project CLAUDE.md edit is described as "wording" only; CLAUDE.md is per-project always-loaded, so the wording delta should be kept minimal — see note below.
- `ai-engineer.md` is a subagent definition spawned once per pipeline run (Step 6b), not per turn; an expanded Input section adds a few tokens to a non-frequently-spawned agent. Low.
- **Per-run cost note (not always-loaded, but worth flagging):** the change adds a *second* system-owner Task dispatch per pipeline run. System-owner's grounding base is ~27K tokens per dispatch (`analyze-transcript.md:130`). This roughly doubles the system-owner share of per-run cost. This is pay-as-used (Low for the always-loaded-cost dimension) but is a real per-run cost increase the operator should accept knowingly.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` file is in REFERENCED_FILE_PATHS and the change description names no `allow` / `ask` / `deny` edit.
- The new Step 6a is a `Task`-tool dispatch of `system-owner` — the identical tool and target already used by Step 7 (`analyze-transcript.md:108`, "Dispatch `system-owner` via the `Task` tool"). No new tool family, no new invocation pattern.
- `ai-engineer.md` keeps its existing `tools: Read, Grep, Glob, Write` line (`ai-engineer.md:5`); the change description names no tool-list edit.
- `Write` to ai-resources/ is already allowed per project CLAUDE.md § Cross-project coupling notes; the risk-check report itself writing to `ai-resources/audits/` is within established pattern. No widening.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Files touched directly (6):** `analyze-transcript.md`, `ref-step7-brief.md`, `ai-engineer.md`, project `CLAUDE.md`, `logs/decisions.md`, plus the implicit Step 2 / Step 6 region of `analyze-transcript.md` (same file).
- **Downstream caller enumeration (grep across `projects/ai-development-lab` and `ai-resources`):**
  - `produce-handoff.md` — the only other live command in the pipeline. Verified read: it consumes `memo.md` (Step 1, Step 4) and `logs/pipeline-log.md` (Step 2, Step 6). It does NOT read `analysis-ai-engineer.md`, `analysis-system-owner.md`, or any Step 6/7 intermediate artifact directly (`produce-handoff.md:40-47` lifts only memo sections). Grep for "Step 6/Step 7" in `produce-handoff.md` returns one hit — its own internal "Step 6: Update pipeline log", unrelated. So `produce-handoff` is insulated: compatible, no modification required.
  - `analyze-transcript` referenced in 18 files total (grep `-rl "analyze-transcript"`); of those, all but `analyze-transcript.md` itself and `produce-handoff.md` are pipeline planning/spec/log docs (`technical-spec.md`, `architecture.md`, `project-plan.md`, `implementation-spec.md`, `test-results.md`, `session-guide.md`, `repo-snapshot.md`, `implementation-log.md`, `architecture-proposal-v1.md`, `session-notes.md`) plus three `ai-resources/audits/` artifacts. These are documentation/historical records, not executable callers — they describe the pipeline but nothing executes off them. They become stale-but-harmless after the change unless updated.
  - `ref-step7-brief.md` referenced in 16 files — same pattern: one live consumer (`analyze-transcript.md` Step 7d), the rest are spec/plan/audit docs.
  - `ai-engineer` referenced in 22 files — one live consumer (`analyze-transcript.md` Step 6), one agent definition (`ai-engineer.md`), the rest spec/plan/log/review/audit docs.
- **Contract changes identified — these drive the Medium rating:**
  - **Resume predicate (`analyze-transcript.md:34`):** current logic is "if `extraction.md` and `grilling.md` both exist but `analysis-ai-engineer.md` does not, treat as a resume from Step 6." Inserting Step 6a before the ai-engineer means a run that completed 6a (briefing written) but not 6b (`analysis-ai-engineer.md` absent) now matches the OLD predicate and would be re-detected as a fresh Step 6 — silently re-running the system-owner briefing dispatch and incurring the ~27K cost twice. The change description says it "extends the Step 2 resume logic," so the author is aware; the extension must explicitly account for the 6a artifact's presence/absence as a distinct resume state. Backwards-compatible only if done correctly.
  - **HARD cost-validation strings (`analyze-transcript.md:160` and `:200`):** both read `per-run cost: ~{N}K tokens (system-owner Task dispatch)` (singular dispatch) and are HARD halt conditions. A second dispatch means Metadata must now record two cost sources or an aggregate; the validation string and the Step 8 Metadata field definition (`analyze-transcript.md:150`, item 11) must stay mutually consistent or the pipeline halts on a correctly-formed memo, or accepts an under-counted one.
- No more than 5 dependent live callers; the single live caller (`produce-handoff`) needs no modification; contract changes are backwards-compatible *if* executed per the mitigations. Medium.

### Dimension 4: Reversibility
**Risk:** Medium

- Five of six edits are in-place edits to tracked files (`analyze-transcript.md`, `ref-step7-brief.md`, `ai-engineer.md`, project `CLAUDE.md`) — `git revert` restores these cleanly.
- `logs/decisions.md` is an explicit append-only log: its own header states "Newest entries at the bottom (append-only)" (`decisions.md:3`). Appending a "D4-amendment" entry is a log mutation. A `git revert` of the change commit would strip the entry, but if any later session appends below it before the revert, the revert produces a merge conflict or leaves a dangling reference. Standard append-log reversibility friction — one extra cleanup step (manually re-stitch the log) if revert happens after subsequent appends.
- No state propagates beyond git: no push, no external API, no Notion write is part of this change. No automation (hook/cron/symlink) is added that could fire between landing and revert.
- The change is a spec/definition edit, not a data migration — no run directories or memo artifacts already on disk are rewritten.
- Medium: revert works but the append-only `decisions.md` entry is the one element that does not revert as cleanly as a pure in-place edit.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Undocumented Function-A brief contract.** The new Step 6a is described as a "Function A system-owner dispatch." The existing Step 7 hardcodes `Set Function = B` (`analyze-transcript.md:94`) and dispatches with a brief whose Function line and routing-context block are Function-B-specific (`analyze-transcript.md:112-124`). The mirror-source doc `ref-step7-brief.md` confirms the brief is parameterised `{A or B}` (`ref-step7-brief.md:10-11`) and that `consult.md` Step 4 is the canonical source for BOTH functions (`consult.md:78`, "Function: {A — General consultation | B — Pre-change advisory}"). But `consult.md` Step 3 makes routing-context conditional on `SHAPE = change-shape` and Function A is the "general consultation" path — meaning a Function-A brief has a *different* QUESTION composition and a *different* (likely empty) routing-context block than the Function-B brief Step 7d hardcodes. The change description does not state where the Step 6a Function-A brief structure is specified, nor that it is verified against `consult.md`. An undocumented new brief contract that the pipeline must honor = High coupling.
- **`ref-step7-brief.md` semantic overload.** The change description says it "adds coupling note to ref-step7-brief.md." That file is titled "Step 7 Brief Structure — Mirror Source" and its entire body is scoped to Step 7d (`ref-step7-brief.md:1`, `:7`, `:22` "Step 7d brief"). Adding a Step 6a coupling note into a file whose name, title, and verification checklist all say "Step 7" silently overloads a single-purpose mirror-source doc with a second concern. A future maintainer updating `consult.md` Step 4 and re-verifying per the file's own instructions (`ref-step7-brief.md:17-20`) has no signal that a Step 6a contract also lives there. Functional overlap / mis-placed contract = High.
- **Resume-state silent side effect.** As noted in Dimension 3, the Step 2 resume predicate keys on `analysis-ai-engineer.md` absence (`analyze-transcript.md:34`). Inserting Step 6a creates a new intermediate state (6a done, 6b not done) that the current predicate cannot distinguish from "Step 6 not started." If the resume-logic extension is imperfect, the failure is silent — a duplicate ~27K system-owner dispatch with no error surfaced. Silent cross-state side effect = High.
- **ai-engineer Input contract.** `ai-engineer.md:36-40` defines the Input as exactly two documents (extraction + grilling). Step 6b will now pass a third (the infrastructure briefing). The change description says it "updates ai-engineer.md Input section" — so the agent-side contract is updated, but the *content boundary* must be watched: `ai-engineer.md` § Scope boundary (`:19-33`) and Anti-patterns (`:94-101`) explicitly forbid the agent from "Repo-fit reasoning" and "Naming Axcíon component types." Feeding it a system-owner infrastructure inventory — which by nature names repo components and infrastructure — creates direct tension with the agent's own scope guardrail and the project CLAUDE.md § Agent scope boundary rule ("ai-engineer ... does NOT name Axcíon component types"). This is a coupling between the new input and an existing hard scope contract; if not handled, the Step 6 boundary check (`analyze-transcript.md:85`, scans for component-type words) could now fire on content the agent legitimately echoed from its own briefing input.
- Multiple implicit dependencies plus an undocumented new contract plus a silent-side-effect path = High.

## Mitigations

- **Dimension 5 (undocumented Function-A brief contract):** Before landing, write the Step 6a Function-A brief structure verbatim into `analyze-transcript.md` Step 6a itself (mirroring how Step 7d embeds the Function-B brief verbatim), and verify it against `consult.md` Step 4's `{A — General consultation}` branch and Step 3's routing-context conditional. Record the `consult.md` line range checked and the verification date inside Step 6a, so the brief has a named, dated mirror-source anchor exactly as Step 7d does.
- **Dimension 5 (`ref-step7-brief.md` overload):** Do not append a Step 6a note into `ref-step7-brief.md`. Instead, create a sibling `pipeline/ref-step6a-brief.md` (or rename/restructure to a single `ref-systemowner-brief.md` covering both touchpoints with clearly separated Step 6a and Step 7d sections and two distinct "Last verified" lines). Update the project CLAUDE.md § Reference docs list to point at the new/renamed file.
- **Dimension 5 (resume-state silent side effect) + Dimension 3 (resume predicate):** Rewrite the Step 2 resume detection to branch on the Step 6a briefing artifact explicitly — e.g., "if briefing artifact exists and `analysis-ai-engineer.md` does not, resume from Step 6b; if briefing artifact does not exist, resume from Step 6a." Add a one-line halt or info message naming which sub-step the resume targets, so a duplicate system-owner dispatch can never happen silently.
- **Dimension 5 (ai-engineer Input vs. scope contract):** When updating `ai-engineer.md` Input section, add an explicit instruction that the infrastructure briefing is *context only* — the agent must not adopt its repo-component vocabulary into the "Proposed implementation shape" output, and the Step 6 boundary check (`analyze-transcript.md:85`) wording should be reviewed so it does not false-positive on component-type words the agent quotes back from the briefing.
- **Dimension 3 (HARD cost-validation strings):** Update `analyze-transcript.md:160` and `:200` and the Step 8 Metadata field definition (`:150`, item 11) in one coordinated edit so all three describe the same multi-dispatch cost format (e.g., `per-run cost: ~{N}K tokens (system-owner dispatches Step 6a + Step 7)`). Verify the HARD halt string and the field-definition string are byte-identical in their format expectation to avoid a halt on a correctly-formed memo.
- **Dimension 4 (append-only `decisions.md`):** Land the `decisions.md` D4-amendment append in the same commit as the rest of the change, so a single `git revert` covers it; if revert is needed after later sessions append below it, expect one manual log re-stitch step.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
