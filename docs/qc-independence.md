# QC Independence Rule

> **When to read this file:** When running QC (post-edit QC, plan QC, mechanical-mode decisions); when applying triage findings via the QC → Triage Auto-Loop; or when a skip-condition decision affects whether QC fires.

Evaluation and QC must run with fresh context to avoid self-evaluation bias. In Claude Code, this means running evaluators as subagents — separate Claude instances that receive only the artifact under review and the evaluation criteria, with no knowledge of the creation conversation.

- **Context isolation:** Evaluators receive only the artifact, the criteria, and the artifact's declared purpose. Never pass conversation history, creation rationale, or operator feedback.
- **Post-edit QC is mandatory.** After applying fixes to an artifact, run an independent post-edit QC pass via subagent (fresh context) before operator approval or commit. Mechanical verification by the main agent (word counts, grep) is not a substitute. Skip QC when **all** of the following are true: (a) ≤5 lines changed; (b) the change is a mechanical substitution (renaming a value, fixing a syntax pattern, updating a reference) with unambiguous intent; (c) the correct form is already validated elsewhere in the repo (e.g., the same syntax exists and works in another file). If any condition fails, run QC. Formatting-only and whitespace changes always skip.
- **Mechanical-mode QC (second gear).** When QC runs on a substitution-shaped edit to a repo-infrastructure file (settings, commands, agents, SKILL.md, CLAUDE.md, hooks, prompts, and analogous infra) — e.g., string/typo fixes, value edits, permission entries, path/key renames, reference updates, small wording corrections — and qc-reviewer selects `Rubric: mechanical-mode`, accept the narrower M1/M2/M3 rubric. The main agent does not re-expand scope post-hoc or request a full-rubric re-run unless the mechanical-mode verdict flagged a blocking-adjacent Note. Rationale: full-rubric QC on mechanical infra work surfaces out-of-scope observations as findings and triggers over-escalation in triage — the exact pattern that motivates this rule. Mechanical mode does NOT apply to new files, new sections/capabilities, or structural reorganization; those always get the full rubric.
- **Plan QC before presenting plans for approval.** When presenting a non-trivial execution plan to the operator, run an independent `qc-reviewer` pass on the plan itself. The reviewer evaluates the plan against the governing spec and surfaces conformance gaps, missing pause points, unverified assumptions, and scope hazards. Required when a plan affects >3 files, has >2 decision gates, or introduces new conventions. Below that threshold, plan QC is optional but recommended.
- **Self-check before external plan QC.** Before spawning `qc-reviewer` on a plan, run a quick self-check against the reviewer's rubric (evaluation dimensions in `.claude/agents/qc-reviewer.md`). Catches the highest-ROI findings without the cost of an external pass; avoids full-rewrite feedback cycles.

# QC → Triage Auto-Loop

Whenever a QC subagent (`qc-reviewer`, `qc-gate`, `refinement-reviewer`, post-edit QC, or any `/qc-pass` or `/refinement-pass` output) returns findings:

1. **Auto-spawn `triage-reviewer` subagent** on the **Findings** (not Notes). Skip triage entirely when qc-reviewer returned verdict GO and either (a) all content is under the Notes section (only `[Out-of-scope]` observations), or (b) the rubric was `mechanical-mode` with all M-checks Clear. In either case, spawning triage re-escalates what QC correctly deprioritized or runs on an empty findings list. Pass the scope line from qc-reviewer's output into the triage brief so triage can apply the Out-of-scope → Park default to any remaining tagged findings.
2. **Apply everything triage outputs** — Keep / Fix / Rework items, including structural rework.
3. **Run post-edit QC subagent** (fresh context) on the modified artifact. (Skip per QC Independence Rule skip conditions when applicable — see post-edit QC mandatory clause above.)
4. **If post-edit QC surfaces new findings**, apply one more triage + fix pass.
5. **Stop after the second post-edit QC** regardless of result. Report the final verdict in the turn summary.

Cap the loop at two post-edit passes — if two passes don't clean the artifact, the problem is structural and the operator decides.
