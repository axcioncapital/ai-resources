---
description: Implementation triage — structured worth-doing verdict (WORTH-DOING / MARGINAL / NOT-WORTH-DOING) on a proposed implementation, oriented around ROI, perfectionism risk, and downstream impact. Mirrors /risk-check's verdict shape but ROI-oriented, not risk-oriented.
model: opus
---

Triage a proposed implementation. Delegates to the `system-owner` agent (Opus); the agent reads the project's references plus selected vault architectural reference docs and returns a structured worth-doing verdict.

Input: `$ARGUMENTS` — free-text description of the proposed implementation. Examples:

- `/implementation-triage Add a degraded-mode rule to /architecture-review so it produces partial output when an audit fails.`
- `/implementation-triage Add color-coded severity icons to all System Owner output for visual scanning.`
- `/implementation-triage Refactor every existing skill in ai-resources/ to use a custom YAML schema for parameter validation.`

---

### Step 1 — Input validation

If `$ARGUMENTS` is empty, abort with:

```
/implementation-triage requires a description of the proposed implementation.
Example: /implementation-triage Add a cache layer to grounding reads in the system-owner agent.
```

Set `PROPOSAL` = `$ARGUMENTS` verbatim.

---

### Step 2 — Delegate to the `system-owner` agent

Spawn the `system-owner` subagent via the `Task` tool with this brief (verbatim structure):

```
You are the Axcíon AI System Owner. Apply Function D (implementation triage) per references/grounding.md.

Proposed implementation:
{PROPOSAL verbatim}

Apply the procedure in your agent definition: read the three references + systems-building-principles.md, apply the per-function read map for Function D (principles + risk-topology by default; conditional reads per topic), and return a structured verdict.

Output shape:
- First line: WORTH-DOING, MARGINAL, or NOT-WORTH-DOING (verbatim).
- Following 3–6 sentences: rationale citing at least one principle (e.g., principles.md § Lean — P-3) or risk-topology entry. Address all three of:
  - ROI bar (does the value justify the cost?)
  - Perfectionism risk (is this scope-creep dressed as polish?)
  - Downstream impact (what does it change for other components?)

Apply the decline-when-ungrounded rule if grounding is insufficient — output DECLINE — {reason} per persona.md § 5 voice rule 5, with bounded next steps.
```

Wait for the agent's response.

---

### Step 3 — Return the agent's response unmodified

Output the agent's response verbatim to the operator. The verdict on the first line is the System Owner's voice — wrapping it dilutes the structured shape.

---

### Notes for the executor

- The verdict shape mirrors `/risk-check`'s GO / PROCEED-WITH-CAUTION / RECONSIDER pattern but is oriented around ROI, not risk. The two commands coexist (per `references/toolkit-relationship.md` § 2). The operator runs `/risk-check` for risk-class changes; `/implementation-triage` for ROI-class judgments.
- Per locked Decision 1, this command writes nothing to disk at v1. Output is chat-only.
- The three-tier verdict is fixed at v1. If a fourth tier is needed (e.g., "WORTH-DOING-LATER" for valid-but-deferred), operator decides at v1.1.
