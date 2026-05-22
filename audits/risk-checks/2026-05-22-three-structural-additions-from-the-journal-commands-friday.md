# Risk Check — 2026-05-22

## Change

Three structural additions from the journal-commands /friday-act plan (audits/friday-plans/2026-05-22-journal-commands.md): (1) Add a between-gate executive-summary rule under "## Working Principles" in the workspace CLAUDE.md at /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — an always-loaded file — requiring Claude to emit a visible chat summary block at each phase boundary of multi-phase approved-plan work (what the phase did, what the next phase does, any mandate deviation); the rule is visibility-only, not a blocking approval gate, and references the existing [AMBIGUOUS] guardrail and decision-point posture. (2) Create a new advisory-only slash command /drift-check at ai-resources/.claude/commands/drift-check.md that is invokable mid-session, reads the session mandate from logs/session-plan.md plus today's logs/session-notes.md entries and any in-progress plan file, spawns a lightweight qc-reviewer-pattern subagent to compare work-done-and-planned against the original mandate, and returns ALIGNED / MINOR-DRIFT / MAJOR-DRIFT with bulleted deviations — advisory only, modifies no files. (3) Create a new advisory-only slash command /resolve-repo-problem at ai-resources/.claude/commands/resolve-repo-problem.md that takes an operator problem description, spawns an investigator subagent (Read/Glob/Grep) to locate relevant files, read CLAUDE.md and recent decisions.md, produce a root-cause diagnosis, and write a ranked 3-option fix plan (quick patch / structural fix / defer) to audits/working/ — advisory/triage only, applies no fix. All three are journal-derived operator-directed operator-directed infrastructure improvements.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-22-journal-commands.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-repo-problem.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Two new advisory commands are low-risk pay-as-used additions, but the workspace CLAUDE.md rule adds permanent always-loaded token cost AND introduces a behavioral contract whose definition of "phase boundary" is not pinned, so it needs a length-bounded draft and an explicit scope clause before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Item 1 adds a new bullet under `## Working Principles` in the workspace CLAUDE.md — an always-loaded file on every turn of every session in the workspace. CLAUDE.md is currently 173 lines (`wc -l CLAUDE.md`); the section currently holds 4 bullets (CLAUDE.md lines 54-61).
- The journal draft rule text is ~95 words / ~600 characters as quoted in the plan (audits/friday-plans/2026-05-22-journal-commands.md line 16: "When work involves two or more approved plan phases ... not buried in tool output."). At roughly 130-160 tokens, this lands at the upper edge of the Medium band (50-150 tokens to always-loaded files) and risks crossing into High if the landed text is not condensed.
- Items 2 and 3 are new optional slash commands invoked on demand — no always-loaded cost, no auto-load hook, no `@import`. The plan states both are "invokable mid-session" / "invoked when ... encounters an unexpected repo error" (plan lines 41, 50), i.e., pay-as-used. This keeps the dimension at Medium rather than High.
- Neither new command registers a SessionStart / Stop / PreToolUse / UserPromptSubmit hook — the plan describes them as manual slash commands only (plan lines 43, 51).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` `allow` / `ask` / `deny` edits are described in any of the three items (plan lines 12-52). Target files are CLAUDE.md and two new `.claude/commands/*.md` files only.
- Both new commands spawn subagents using Read / Glob / Grep (plan line 50) — read-only tool families already broadly authorized in this repo (the repo runs `bypassPermissions`, per session-notes B9, ai-resources/logs/session-notes.md line 33).
- Item 3 writes a fix-plan file to `audits/working/` (plan line 50). `audits/working/` is the established subagent working-notes directory named in ai-resources/CLAUDE.md § Subagent Contracts ("audits/working/...") — Write to this path is an existing pattern, not a new capability.
- No scope escalation (project → user), no cross-repo write, no external API call introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Item 1 touches 1 file (workspace CLAUDE.md). Items 2 and 3 each create 1 new file. Three files total, all additive.
- New-command callers — grep for `drift-check` and `resolve-repo-problem` across `.claude/`, `docs/`, `skills/` returned 0 references each (no existing file invokes either command). New commands have zero inbound callers; nothing depends on them.
- Repo currently holds 59 slash commands (`ls .claude/commands/ | wc -l`); adding 2 is a 3% increase with no namespace collision — `ls .claude/commands/ | grep` confirms no existing `drift-check.md` or `resolve-repo-problem.md`.
- Item 1's rule does not change any existing contract (no subagent input schema, no report headings, no hook output shape). It adds an additive behavioral instruction; existing commands keep working unchanged. It references — does not modify — the existing `[AMBIGUOUS]` guardrail and decision-point posture (both already in workspace CLAUDE.md).
- Dependency assets the new commands rely on already exist: the `qc-reviewer` agent (`.claude/agents/qc-reviewer.md`) and the `consult` command (`.claude/commands/consult.md`) are both present — the plan's "qc-reviewer pattern" and "Consider using /consult internally" (plan line 41) point at live components, not missing ones.

### Dimension 4: Reversibility
**Risk:** Low

- Item 1 is a single-bullet addition to one file — `git revert` of that commit fully restores prior CLAUDE.md state within the working tree.
- Items 2 and 3 create new sibling files. A `git revert` of the creating commit removes a tracked new file cleanly (git tracks the addition); no orphaned sibling directory is created — both land directly in the existing `.claude/commands/` directory.
- Neither new command auto-fires: no hook, no cron, no symlink registered (plan lines 43, 51 describe manual invocation only). There is no automation that could fire in the window between landing and a potential revert.
- Item 3 writes to `audits/working/` at runtime, but only when the command is actually invoked — creation of the command file itself mutates no data/log file. The plan does not register the command in any registry. Reverting the command file removes the capability; any `audits/working/` artifacts produced by a prior run are disposable working notes (gitignored-style scratch area), not canonical state.
- No state propagates beyond git (no push, no Notion write, no external POST) as part of landing these three items.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Item 1's rule defines a new behavioral trigger — "two or more approved plan phases" / "each phase boundary" (plan line 16) — but does not pin what counts as a phase boundary. The draft gives examples (`/new-project` pipeline, multi-wave `/friday-act`, "any session with a phased plan file") but "any session with a phased plan file" is open-ended: it silently couples the rule's firing to whatever future commands happen to produce a plan file. A command author adding a plan file later inherits this summary obligation without knowing the rule exists. This is an undocumented-at-the-trigger-site contract.
- Item 1 functionally overlaps with item 4 of the same plan (the new `/drift-check` command) — both compare work-done against mandate and surface deviations. The plan itself acknowledges this ("Complements item 1's between-gate summary rule", plan line 41). The CLAUDE.md rule fires automatically at phase boundaries; `/drift-check` fires on manual invocation. Two mechanisms now address the same concern (mandate-deviation detection); without a one-line demarcation in the rule text, it is unclear when the always-on rule suffices and when an operator should additionally run `/drift-check`.
- Items 2 and 3 carry one implicit dependency each on established repo conventions, both satisfied: `/drift-check` reads `logs/session-plan.md` and `logs/session-notes.md` (both confirmed to exist), and assumes session-notes uses dated `## ` entry blocks for "today's entries" — that convention holds in the current file (session-notes.md uses `## 2026-05-22 — ...` headers). `/resolve-repo-problem`'s subagent writing full notes to `audits/working/` and returning a short summary matches the ai-resources/CLAUDE.md § Subagent Contracts pattern. These are Medium-grade (established convention) not High.
- `/drift-check`'s subagent must rely on the session-notes "today's entries" parse being unambiguous. session-notes.md currently contains multiple same-day entries (six `## 2026-05-22` headers in the current file) — the command spec must say how the subagent isolates the *current session's* mandate vs. sibling concurrent-session entries, or it risks comparing trajectory against the wrong mandate.

## Mitigations

- **Dimension 1 (Usage Cost):** Before landing item 1, condense the rule to a single bullet of ≤55 words (target ≤90 tokens) — push the worked examples and the `[AMBIGUOUS]`/decision-point cross-reference into a one-line pointer to a docs file (e.g., `ai-resources/docs/session-guardrails.md` or a new short doc) rather than inlining all of it in the always-loaded CLAUDE.md. Verify the landed bullet length by reading the file after the edit.
- **Dimension 5 (Hidden Coupling) — undefined trigger:** In the landed rule text, replace the open-ended "any session with a phased plan file" with a closed definition — either name the specific phased pipelines (`/new-project`, multi-wave `/friday-act`) or define a phase boundary precisely (e.g., "a transition between numbered stages of an approved plan file in `logs/session-plan.md`"). The trigger must be determinable without guessing.
- **Dimension 5 (Hidden Coupling) — overlap with /drift-check:** Add one sentence to the item 1 rule (or to `/drift-check`'s command body) demarcating the two mechanisms — e.g., "the between-gate summary is automatic and visibility-only; `/drift-check` is the operator-invoked deeper check when the summary surfaces a possible deviation." Land item 1 and item 4 in awareness of each other so the demarcation is consistent in both files.
- **Dimension 5 (Hidden Coupling) — /drift-check session isolation:** In the `/drift-check` command spec, specify how the subagent isolates the current session's mandate when `session-notes.md` holds multiple same-day entries (e.g., match the most recent `## {DATE}` block, or the block whose `Class:`/`Mandate:` line matches `session-plan.md`'s intent) — do not leave "today's entries" as an unqualified parse instruction.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to CLAUDE.md and the friday-plan, grep counts for command references and command-directory size, verbatim quotes from the plan's draft rule text, and confirmation that the `qc-reviewer` agent and `consult` command exist on disk). Items 2 and 3 are tagged `not yet present` — their risk is evaluated from the described intent in CHANGE_DESCRIPTION and the plan file, as noted under Dimensions 1, 3, 4, and 5. No training-data fallback was used on fetch/read failures.
