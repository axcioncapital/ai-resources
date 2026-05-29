# Change-Shape Classifier

Canonical definition of "change-shaped" questions, used by `/consult` Step 2 and the `project-manager` agent (invoked by `/pm`) Phase 3 to route questions between Function A (general consultation) and Function B (pre-change advisory).

**Consumers (two-end contract per `risk-topology.md § 5`):**
- `ai-resources/.claude/commands/consult.md` Step 2 — gates `Function B` routing.
- `ai-resources/.claude/agents/project-manager.md` Phase 3 — gates Fallback 5d redirect to `/consult`.

If you edit the classifier list below, every consumer above auto-picks up the change on next invocation (each consumer reads this file at runtime). Drift is structurally prevented — no verbatim copies to keep in sync.

## Definition

A question is **change-shaped** when the operator describes an intended, proposed, pending, or evaluated repo modification affecting any of:

- Files (creating, deleting, restructuring, moving, renaming).
- Commands (`.claude/commands/*.md`) — adding, removing, modifying, splitting, collapsing.
- Agents (`.claude/agents/*.md`) — same.
- Models (model-tier changes; opt-ins or opt-outs).
- Folder structure (new directories, moving directories, deprecating directories).
- Hooks (`.claude/hooks/*.sh`) — adding, removing, modifying.
- Workflows (workflow templates, workflow deployment).
- Project boundaries (new project, deprecating project, project scope changes).
- Permissions (`settings.json` `allow` / `ask` / `deny` edits).

A question is **general** when it is purely conceptual ("how should I think about X" / "what is the right pattern for Y") AND does not name a specific repo modification — UNLESS the operator explicitly asks about implementation impact, in which case treat as change-shaped.

## Consumer-specific routing rules

These belong with the consumer, not with the classifier. Each consumer applies its own routing rule on top of the same definition:

- **`/consult` Step 2:** If `QUESTION` matches the change-shaped definition, set `SHAPE = change-shape` and proceed to Step 3 (read routing context). Otherwise, set `SHAPE = general` and skip to Step 4.
- **`project-manager` agent Phase 3:** If classification is `structure (change-shaped)` or hybrid's change-shaped subset, decline and redirect via Fallback 5d (emit "REDIRECT TO /consult"). Do NOT escalate to `system-owner` via Task tool — change-shaped questions require Function B routing which lives in `/consult`, not in this agent.

## Bias rules

- The bias rule "when in doubt, answer content" (content-vs-structure boundary at `project-manager` Phase 3) does NOT apply to change-shape detection. Silent mis-routing of a change-shaped question is the failure mode this classifier exists to prevent.
- When in doubt between the change-shaped enumerable categories above and a general conceptual framing, prefer change-shaped if the operator's question names a specific file, command, agent, hook, or settings key. The category-by-category list is exhaustive for the current resource taxonomy; new categories are added to this doc, never inferred at consumer-runtime.

## Provenance

Extracted 2026-05-29 (S6 Wave 3, Friday-checkup-2026-05-29 / general plan item #3) from the previously-duplicated verbatim block in `consult.md` Step 2 and `project-manager.md` Phase 3. DR-7 trigger (two confirmed consumers sharing the same logic) was met; the extraction closes the two-end contract by replacing it with a one-end contract anchored on this file.
