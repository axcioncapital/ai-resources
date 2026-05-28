# Risk Check — 2026-05-28

## Change

**Proposed change:** Add a new "Placement Discipline" section (~15 lines) to the workspace-level `CLAUDE.md` at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`, positioned between the existing `## AI Resource Creation` and `## Design Judgment Principles` sections. The section instructs the model to invoke `/route-change` before creating genuinely new files in new/uncertain locations, lists four trigger conditions (new top-level dir; new artifact category; layer ambiguity; multi-type coupling) and three skip conditions (editing existing file; sibling in established folder; target home already written this session). The rule closes with a feedback-loop line directing misses to `friction-log.md`.

Final locked rule body (verbatim):

```markdown
## Placement Discipline

Before creating a genuinely new file in a new or uncertain location, run `/route-change <one-line description>` and use the recommendation as the default. Triggers (any one fires):

- New top-level directory, or first file in a directory that doesn't yet exist.
- New artifact category (a kind of file the repo doesn't already host).
- Ambiguity between layers (workspace root vs. `ai-resources/` vs. a project; skill vs. command vs. agent vs. doc; canonical vs. project-local).
- Coupling that touches multiple resource types at once (e.g., new command + new agent + new doc section).

Skip when: editing an existing file, adding a sibling inside a clearly-established folder (e.g., another skill under `skills/`), or the target home is one this session has already written to in a prior turn.

`/route-change` is advisory and non-mutating — it produces a recommendation, then I proceed. Not an operator-confirmation gate.

If a misplacement is later detected that this rule should have caught, log it in `ai-resources/logs/friction-log.md` — the signal triggers the hook upgrade path.
```

**Second edit:** Single-sentence cross-reference folded into the existing "When to read this file" blockquote in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md` (no new line; merged into existing callout).

**Change class:** Workspace-level CLAUDE.md edit (always-loaded rule, cross-project scope). Plan-time gate per `audit-discipline.md § Risk-check change classes`. Operator-rated importance: medium.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md` — exists
- `/Users/patrik.lindeberg/.claude/plans/would-it-be-possible-binary-swan.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/route-change.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` — exists

## Verdict

**GO**

**Summary:** A short, self-contained workspace-CLAUDE.md rule with explicit trigger/skip lists, no permissions or hook changes, no new contracts, and clean reversibility — the residual ongoing-token cost (~15 lines added to a 189-line always-loaded file) is the only elevated dimension, and it is bounded and proportionate to the rule's purpose.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Adds ~15 lines (~120–140 tokens, estimated from the locked body which contains ~110 words plus markdown) to workspace `CLAUDE.md`, which is loaded in every session across `ai-resources/`, `workflows/`, `projects/*`. Evidence: current file is 189 lines (`wc -l` result on `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`); rule body in plan (`would-it-be-possible-binary-swan.md:31-45`) is 15 lines.
- No `@import` chain introduced — the rule is self-contained and inlined verbatim in workspace CLAUDE.md. Evidence: plan body has no `@` directives; references to `friction-log.md` and `/route-change` are by-name pointers, not auto-loads.
- No hook is registered. The plan explicitly forecloses a hook: "No hook on `Write`/`Edit` — you chose the soft model-side option" (`would-it-be-possible-binary-swan.md:70`). `/route-change` itself is operator-invoked / model-invoked on demand — pay-as-used.
- Second edit (cross-reference in `ai-resource-creation.md`) adds a single sentence to an already-existing blockquote in a load-on-demand doc (29 lines, not always-loaded). Evidence: `ai-resource-creation.md:3` is the existing "When to read this file" callout — the second edit lengthens it by one clause, no new always-loaded content.
- Sits in the 50–150 token band per the rubric (~120–140 tokens added to always-loaded content). Solidly Medium, not High.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` change. Plan explicitly states: "No new permission entries, no `settings.json` change" (`would-it-be-possible-binary-swan.md:72`).
- No new `allow` / `ask` / `deny` entries. No new tool invocations enabled.
- `/route-change` already exists as an operator/model-invokable command (`ai-resources/.claude/commands/route-change.md`) — its permissions are pre-existing.
- No scope-escalation across settings layers.

### Dimension 3: Blast Radius
**Risk:** Low

- Two files touched directly: workspace `CLAUDE.md` and `ai-resources/docs/ai-resource-creation.md`. No other files modified.
- Workspace `CLAUDE.md` reach: cross-project (loaded in every session under workspace root). Effect: model-side behavior nudge, not a contract change.
- No contract changes. No subagent input schema, hook output shape, slash-command invocation syntax, or frontmatter schema altered.
- Grep enumeration of `/route-change` references across `ai-resources/` (using `grep -rln "route-change"`): 22 files match — primarily audit reports (`audits/risk-checks/*.md`, `audits/repo-due-diligence-*.md`), `plans/repo-architecture-knowledge-bases-update.md`, `docs/repo-architecture.md`, `.claude/commands/route-change.md`, `.claude/commands/consult.md`, `.claude/commands/risk-check.md`, `logs/innovation-registry.md`, `logs/session-notes-archive-2026-04.md`. None of these are callers that would *break* — they are descriptive references in audit text or pointers in adjacent commands. The new CLAUDE.md rule does not modify `/route-change`'s contract; it merely elevates its invocation prompt to model-side default.
- Grep enumeration of `ai-resource-creation.md` references: 15 files (`grep -l "ai-resource-creation.md"`). The second edit only extends an existing blockquote — does not rename or restructure anything that callers reference.
- No "Placement Discipline" string exists anywhere in the repo today (grep returned no matches), so no collision with an existing rule of the same name.
- Cumulative caller-modification count: zero. No file requires editing to keep working after this change lands.

### Dimension 4: Reversibility
**Risk:** Low

- Clean `git revert` cleanup — both edits are markdown-only modifications to existing tracked files (workspace `CLAUDE.md` and `ai-resources/docs/ai-resource-creation.md`). No new files created, no log/data append, no symlink, no settings cache, no hook registration.
- No sibling files or directories generated as a side effect.
- No state propagated beyond the local working tree: no push, no external API call, no Notion write, no auto-fired hook.
- No operator muscle-memory dependency on a new command or flag — `/route-change` already exists and is unchanged; the rule just elevates its invocation cadence.
- Rollback cost: a single `git revert <sha>` restores prior state in both files.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The rule's trigger/skip semantics are stated **at the change site** (workspace `CLAUDE.md` rule body itself, `would-it-be-possible-binary-swan.md:33-44`) — no implicit dependency on conventions documented elsewhere that callers must discover.
- Third skip condition is structural and checkable — "target home is one this session has already written to in a prior turn" (`would-it-be-possible-binary-swan.md:40`). Plan notes this was hardened deliberately against the alternative "obvious from session context" to avoid leaning on the same judgment the rule exists to backstop (`would-it-be-possible-binary-swan.md:49`). The structural form does not couple silently to model-judgment heuristics elsewhere.
- Composes with three existing always-loaded rules without overlap or contradiction. Verified from `CLAUDE.md`:
  - § Decision-Point Posture (lines 106–108): "pick the recommended option and proceed automatically" — the new rule says "use the recommendation as the default," consistent with picking and proceeding rather than asking the operator.
  - § Autonomy Rules (lines 89–104): no new operator-confirmation gate introduced; `/route-change` is non-mutating and advisory by its own frontmatter (`route-change.md:5` — "Non-mutating — reads files only, writes nothing").
  - § AI Resource Creation (lines 31–33): adjacent section already directs resources through canonical pipelines; the new rule extends placement reasoning to the broader (non-resource-only) scope without duplicating the pipeline directive.
- No functional overlap with existing mechanisms. No auto-firing context — the rule fires only at the model's discretion when a trigger condition is met, and `/route-change` itself does not register any hook.
- The closing feedback-loop sentence directs misses to `ai-resources/logs/friction-log.md`. Verified the log exists and follows an established session-block format (`friction-log.md:1-49`). The rule's pointer is to an existing logging convention, not a new contract.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: line counts from `wc -l` on the workspace `CLAUDE.md` and `ai-resource-creation.md`; grep enumeration of `route-change` and `ai-resource-creation.md` references across `ai-resources/`; direct line citations from the locked plan (`would-it-be-possible-binary-swan.md`), the workspace `CLAUDE.md` (autonomy and decision-point sections), the `route-change.md` command definition, and the `audit-discipline.md § Risk-check change classes` section. No training-data fallback was used.
