---
description: Consult the Axcíon AI System Owner — architectural judgment on systems-thinking questions or proposed repo changes.
model: opus
---

Consult the Axcíon AI System Owner on a structural question or a proposed repo change. Delegates to the `system-owner` agent (Opus); the agent reads the project's persona / grounding / toolkit-relationship references plus selected vault architectural reference docs and returns a grounded judgment in System Owner voice.

Input: `$ARGUMENTS` — free-text question or situation. Examples:

- `/consult I want to add a new /analyze-logs command — where should it live and what does it break?`
- `/consult How should I think about token efficiency when adding a new orchestration command?`
- `/consult Should the friday-checkup auto-fire from a Stop hook?`

**Reserve for genuinely contested or load-bearing system-shape questions, not for verification of already-confident recommendations.**

---

### Step 0 — Read-first gate

Before invoking `/consult`, answer:

(a) Have I already given a recommendation on this question?
(b) If yes, is there a single file (≤ 300 lines) whose contents would either confirm or refute it?

If both (a) and (b) are yes: do the Read first. Only proceed to `/consult` if the Read surfaces a genuine ambiguity or a load-bearing conflict that cannot be resolved from the file.

---

### Step 1 — Input validation

If `$ARGUMENTS` is empty, abort with:

```
/consult requires a question or situation.
Example: /consult Should I move /token-audit to fire from /friday-checkup?
```

Set `QUESTION` = `$ARGUMENTS` verbatim.

---

### Step 2 — Apply the change-shape detection rule

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

If `QUESTION` matches the change-shaped definition, set `SHAPE = change-shape`. Otherwise, set `SHAPE = general`.

---

### Step 3 — Read routing context (change-shape only)

If `SHAPE = change-shape`:

1. Read `ai-resources/docs/repo-architecture.md` from disk. (This is the same source `/route-change` reads. Per locked Decision 3 + Architecture Decision 4, the System Owner reads it in-line; the operator does not need to run `/route-change` separately.)
2. Capture the routing baseline as `ROUTING_CONTEXT` — pass it through to the agent in Step 4.

If `SHAPE = general`, set `ROUTING_CONTEXT` = empty.

---

### Step 4 — Delegate to the `system-owner` agent

Spawn the `system-owner` subagent via the `Task` tool with this brief (verbatim structure):

```
You are the Axcíon AI System Owner. Apply Function {A or B} per references/grounding.md.

Function: {A — General consultation | B — Pre-change advisory}

Operator's question/situation:
{QUESTION verbatim}

{If SHAPE = change-shape, append:}
Routing context (read from ai-resources/docs/repo-architecture.md by /consult before delegation):
{ROUTING_CONTEXT verbatim}

Apply the procedure in your agent definition: read the three references + systems-building-principles.md, apply the per-function read map, and produce a response in System Owner voice. Cite specific principles / blueprint sections / risk-topology entries for each load-bearing recommendation. Apply the decline-when-ungrounded rule if grounding is insufficient.
```

Wait for the agent's response.

---

### Step 5 — Return the agent's response unmodified

Output the agent's response verbatim to the operator. Do NOT add a preamble, do NOT summarize, do NOT add an "I hope this helps" closing. The agent's voice is the System Owner voice; wrapping it in command-shell prose dilutes it.

---

### Notes for the executor

- Per locked Decision 3, this command does NOT invoke `/route-change` as a slash command. The architecture-map read in Step 3 reproduces the routing baseline.
- Per locked Decision 1, `/consult` writes nothing to disk at v1. Output is chat-only.
- The change-shape detection rule in Step 2 is the operator-facing threshold. If the operator wants stricter or looser detection, the rule is updated here in v1.1, not in the agent body.
