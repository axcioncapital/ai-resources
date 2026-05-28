---
description: Consult the Axcíon AI Project Manager — project-content advisory grounded in the active project's constitution docs. Pairs with /consult (which handles repo/workspace structure).
model: opus
---

Consult the Axcíon AI Project Manager on a mid-session question grounded in the active project's constitution docs (project `CLAUDE.md`, plan, context-pack, decisions, architecture). Delegates to the `project-manager` agent (Opus); the agent reads the project's constitution docs, classifies the question, optionally escalates to `system-owner` for general structure questions, and returns a three-part ruling (Verdict, Reasoning with citations, Recommended action) in chat.

**For repo/workspace structure questions, use `/consult` instead — `/pm` is project-content scoped.**

Two question shapes:

- **Retrospective** — "is X consistent with the plan?", "what does decision 5 imply for Phase 2?"
- **Forward-looking** — "propose a mandate for this session", "what should the next session focus on?", "suggest a session plan for completing W1"

Input: `$ARGUMENTS` — free-text question, or empty (in which case `/pm` reads the most recent inline conversation). Examples:

- `/pm` (no args — reads recent inline conversation to identify the open question)
- `/pm "Should W2 source enrichment data from Perplexity or GPT-5?"` (retrospective)
- `/pm "Propose a mandate for this session."` (forward-looking — mandate generation)
- `/pm "What should I focus on next given W0 is complete?"` (forward-looking — next-step)
- `/pm "Suggest a session plan for completing W1 Phase 2."` (forward-looking — session plan)
- `/pm "Use docs/spec.md as the plan. Does the spec allow Phase 3 to use synthetic data?"` (steering — token ending in `.md` overrides constitution-doc discovery for the plan slot)

**Reserve for genuinely contested or load-bearing project-content questions, not for verification of already-confident recommendations.**

---

### Step 0 — Read-first gate

Before invoking `/pm`, answer:

(a) Have I already given a recommendation on this question?
(b) If yes, is there a single file (≤ 300 lines) whose contents would either confirm or refute it?

If both (a) and (b) are yes: do the Read first. Only proceed to `/pm` if the Read surfaces a genuine ambiguity or a load-bearing conflict that cannot be resolved from the file.

---

### Step 1 — Identify the open question

If `$ARGUMENTS` is **non-empty**:
- Set `OPEN_QUESTION` = `$ARGUMENTS` verbatim.
- Set `OPTIONAL_STEERING` = `$ARGUMENTS` (same field at v1 — the argument carries both the question and any steering tokens such as `Use X.md as the plan`).

If `$ARGUMENTS` is **empty**:
- Scan the ~30 most recent turns of the conversation for an explicit operator question, an unresolved `[AMBIGUOUS]` flag, or a load-bearing decision the main session was about to make on the fly without grounding.
- Restate the identified question in one sentence and set that as `OPEN_QUESTION`. Set `OPTIONAL_STEERING` = empty.
- **State the restatement in chat before invoking the agent**, so the operator can catch a misread before the agent burns time. Format:
  ```
  Identified open question: "{restatement}"
  Proceeding with /pm.
  ```
- If no question can be identified, abort with:
  ```
  /pm could not identify an open question in the recent conversation.
  Re-invoke with: /pm "your question here"
  ```

---

### Step 2 — Capture the working directory

Set `CWD` = current working directory of the invoking session. Do not walk for `projects/<name>/` here; that's the agent's Phase 1 responsibility.

---

### Step 3 — Delegate to the `project-manager` agent

Spawn the `project-manager` subagent via the `Task` tool with this brief (verbatim structure):

```
You are the Axcíon AI Project Manager.

Operator's open question:
{OPEN_QUESTION verbatim}

Steering (may be empty):
{OPTIONAL_STEERING verbatim}

Working directory of the invoking session:
{CWD}

Apply your full procedure (Phase 1 project detection → Phase 2 constitution-doc discovery → Phase 3 classification → Phase 4 escalation if needed → Phase 5 ruling). Output the three-part ruling to chat per your agent definition. Apply fallback 5a / 5b / 5c / 5d when applicable.
```

Wait for the agent's response. Capture it verbatim as `PM_RULING`.

**Skip QC and go directly to Step 6 if `PM_RULING` is a fallback (5a DECLINE / 5b NO PROJECT DETECTED / 5c NO CONSTITUTION DOCS / 5d REDIRECT TO /consult).** Fallbacks are bounded outputs; QC adds no signal there.

---

### Step 4 — QC the ruling

Spawn the `qc-reviewer` subagent via the `Task` tool with this brief (verbatim structure):

```
## QC Request

**Artifact:** Project Manager ruling produced by the `project-manager` agent in response to a /pm invocation.

**Artifact content (verbatim):**
{PM_RULING verbatim}

**Original operator request:**
{OPEN_QUESTION verbatim}

**Scope / artifact purpose:** Project-content advisory ruling grounded in the active project's constitution docs. The ruling must (a) ground every load-bearing claim in a citation to a constitution doc, (b) classify the question correctly per PM's Phase 3 rules, (c) produce a declarative verdict (not opinion-seeking), (d) surface conflicts between constitution docs rather than silently resolve them, and (e) for forward-looking questions, produce paste-ready mandate/plan text in the Verdict section.

Constitution docs the project-manager read (extract from the ruling's header line) are accessible at the active project root. Verify citations against the actual files where load-bearing.

Apply your standard rubric. Return GO, REVISE (with specific findings), or FLAG FOR EXTERNAL QC.
```

Wait for the qc-reviewer's response. Capture as `QC_VERDICT`.

---

### Step 5 — Apply QC verdict (pass cap: 2 total)

If `QC_VERDICT` is **GO**:
- Set `FINAL_RULING` = `PM_RULING`. Proceed to Step 6.

If `QC_VERDICT` is **REVISE**:
- If this is the first revision (`PASS_COUNT` = 1): spawn the `project-manager` agent again via `Task` with the same brief as Step 3, plus an additional steering paragraph appended at the bottom:
  ```
  QC revision note: the prior ruling was flagged by qc-reviewer with these findings:
  {qc-reviewer's findings, verbatim}

  Produce a revised ruling that addresses these findings while staying within your standard procedure. Do not abandon the constitution-doc grounding to satisfy QC — if a finding asks for content the docs don't support, apply Fallback 5a (DECLINE) on that claim and surface the limitation in the verdict.
  ```
  Capture the revised output as `PM_RULING` (overwriting prior). Increment `PASS_COUNT` to 2. Return to Step 4 (re-QC the revision).

- If this is the second revision (`PASS_COUNT` = 2): pass cap reached. Set `FINAL_RULING` = `PM_RULING` (the second-pass output) and append a footer to it:
  ```
  ---
  ### QC Note
  This ruling reached the /pm QC pass cap (2 passes). qc-reviewer's remaining findings on the final pass: {qc-reviewer's findings, verbatim}. Operator may run `/qc-pass` externally for a fresh independent review, or invoke `/pm` again with refined steering.
  ```
  Proceed to Step 6.

If `QC_VERDICT` is **FLAG FOR EXTERNAL QC**:
- Set `FINAL_RULING` = `PM_RULING` and append:
  ```
  ---
  ### QC Note
  qc-reviewer flagged this ruling for external QC: {qc-reviewer's flag reason}. Recommend running `/qc-pass` before treating the ruling as load-bearing.
  ```
  Proceed to Step 6.

---

### Step 6 — Return the final ruling unmodified

Output `FINAL_RULING` verbatim to the operator. Do NOT add a preamble, do NOT summarize, do NOT add an "I hope this helps" closing. The agent's voice is the Project Manager voice; wrapping it in command-shell prose dilutes it. The QC footer (if any) is part of the final ruling and is preserved as-is.

---

### Notes for the executor

- `/pm` writes nothing to disk at v1. Output is chat-only.
- `/pm` is **advisory with strong precedence** — the main session treats the ruling as the default answer. Operator retains veto.
- `/pm` includes an **internal QC pass** (Step 4) — the PM ruling is reviewed by `qc-reviewer` before being returned to the main session, with a pass cap of 2. This diverges from `/consult` (which has no internal QC). Rationale: PM rulings will be cited as load-bearing project-content decisions and feed forward-looking artifacts (mandate text, session-plan outlines) into `/session-start` / `/session-plan` — the internal QC step reduces the chance of an ungrounded ruling propagating downstream. Operator can still run `/qc-pass` externally on any ruling that feels especially load-bearing.
- Fallback rulings (5a/5b/5c/5d) skip QC. Those are bounded outputs; QC adds no signal.
- `/pm` does NOT auto-fire from any hook; operator-invoked only.
- The agent decides whether to escalate to `system-owner` internally; the operator does not pre-route.
- For change-shaped structure questions (operator proposes a specific repo modification), the agent emits Fallback 5d (REDIRECT TO /consult) — re-invoke `/consult` directly for those.
- **Plan divergence note:** the approved plan at `/Users/patrik.lindeberg/.claude/plans/i-want-to-build-tidy-lake.md` specified no internal QC step (mirroring `/consult`). This implementation diverges per operator direction (2026-05-28) given that PM rulings will solve "quite important issues" — the QC pass is binding precedence for any future audit.
