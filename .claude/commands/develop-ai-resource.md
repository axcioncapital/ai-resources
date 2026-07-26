---
description: Decide whether a durable AI resource should exist, then build, verify and demonstrate the smallest one that does. Qualify → Build → Verify → Decide. No build is a valid outcome; nothing is adopted without the operator.
model: opus
argument-hint: "[a need in plain English, a path to an inbox brief, or an existing resource to improve]"
---

# /develop-ai-resource — need → mechanism → candidate → demonstrated decision

Decide whether a durable Axcíon AI resource should exist — skill, reusable prompt, persistent instruction, reference file, command, script or hook — then build, test and demonstrate the smallest one that does.

**Authority (v1).** This is the **standard qualification path for creating a new durable AI resource** — `/create-skill` bounces an unqualified brief back here once, so new-skill work reaches a build engine through this command. It **can also qualify an improvement when deliberately invoked**, and that is the right call when the improvement is large, contested, or might really be a new resource. It is **not** the required route for improvements: `/improve-skill` stays independently reachable in v1 and is not subordinate to this command. An improvement to an already-identified skill has its mechanism question settled, so calling `/improve-skill` directly is the ordinary path, not a bypass.

**Boundary vs neighbours.**
- `/create-skill` and `/improve-skill` are the build engines this command hands skill-class work to at Step 2. `/improve-skill` is additionally an entry point in its own right, per **Authority** above.
- `/placement` remains a standalone advisory route. This command reads the same authoritative placement heuristics when mechanism or location is genuinely open.
- `/leverage-idea` starts from an idea dump and stops at a plan; `/request-skill` captures a brief for later. This qualifies and builds now.
- `/risk-check`, `/qc-pass` and `/implementation-triage` are specialist capabilities Step 3 draws on when the claim and consequence warrant it.

Input: `$ARGUMENTS` — a plain-English need, a path to a brief in `ai-resources/inbox/`, or an existing resource to improve. If empty, ask for the need in one line and wait.

---

### Step 1 — Qualify

**1.1 State the understanding.** Three lines: the practical outcome wanted, what happens today, and any ambiguity blocking responsible progress. Read attachments and conversation first, then ask only where an answer would change the outcome, boundary or usefulness — grouped, in plain English.

**1.2 Establish the evidence.** What shows a real gap: a cited log entry, a reproduced failure, an operator-stated need, an observed workflow cost. Classify it **recurring · one-off but consequential · speculative**. Speculative is a valid finding — name it as such and let it shape the verdict.

**1.3 Inspect existing capability.** Scope the search to the proposed capability. Search by purpose and behaviour, not name alone, across `.claude/commands/`, `.claude/agents/`, `skills/`, `docs/`, `prompts/`, hooks and project-local equivalents. Use skill frontmatter to locate candidates, then **read the relevant skill body and its observable behaviour** — coverage means the resource performs the work and produces an observable result.

Disposition every near-match as **covers it · covers part of it · adjacent but different**, with the path.

Read `docs/repo-architecture.md` § Placement heuristics (Q1–Q8) when mechanism or location is genuinely open.

**1.4 Select the smallest mechanism.** Weigh only the rungs materially relevant to this need, preferring the less permanent:

accept the limitation → change an operating habit or information flow → normal prompting → reuse or improve an existing resource → use an external resource → a reusable prompt or reference file → a narrowly scoped persistent instruction → an operator-facing command or specialist skill → a deterministic script → a hook or other automatic enforcement.

A thinking aid — go straight to a later rung when the evidence warrants it.

**1.5 Apply the complexity budget** when the verdict is a **new or materially expanded** durable component. Read `docs/ai-resource-creation.md` rule #7 and apply it insofar as it stays compatible with the governing specification and foundational principles — a consequential one-off need can qualify without a prescribed log entry. Where rule #7 and the specification genuinely conflict, bring the conflict to the operator and ask which governs; `/risk-check` judges premise and consequence, not which document wins.

**1.6 Verdict.** One of: **no build · accept the limitation · normal prompting · change an operating habit · reuse as-is · improve an existing resource · use an external resource · bounded experiment · project-local resource · shared resource · defer** (with a concrete trigger — a date, a quarter or a named event).

**Completion criterion:** the verdict names the mechanism *and* the evidence it rests on, and every near-match from 1.3 is dispositioned. On no build, reuse as-is or defer — go to Step 4 and stop.

---

### Step 2 — Build

**2.1 Assemble only what the candidate needs:** the need, representative examples, authoritative sources **by path rather than copied**, boundaries and confidentiality limits, expected behaviour, stopping conditions, and the cases Step 3 will test.

**2.2 Route by mechanism.**

- **Skill (new)** → invoke `/create-skill` via the Skill tool with a qualified brief.
- **Skill (improvement)** → invoke `/improve-skill` via the Skill tool with the target and the improvement.
- **Prompt, reference file, persistent instruction** → draft directly. Small, bounded, reversible.
- **Command, script, hook** → build the smallest version; Step 3 selects the verification. Deterministic surfaces get executable tests.

**2.3 Apply the specialist authoring method to any skill-class candidate.** The five practices below are the authoritative Axcíon copy — adapted, not installed, and not tracking upstream. Source: Matt Pocock's `writing-great-skills` (`SKILL.md` + `GLOSSARY.md`) at commit `697d4ce9742da558fd1ba6697c8e9775e2e302dd` of `github.com/mattpocock/skills`, the latest revision touching that path as of 2026-07-26. They cover only what `skills/ai-resource-builder/` leaves uncovered — trigger front-loading, negative triggers, progressive disclosure, required sections and the size budget already live there.

- **Leading words.** A compact concept already in the model's pretraining that the agent thinks with while running the skill. Make the steering word load-bearing: *"a weak leading word (be thorough when the agent is already thorough-ish) is a no-op; the fix is a stronger word (relentless), not a different technique."*
- **Completion criteria as steering.** *"A demanding completion criterion drives thorough legwork."* Each step states the condition that tells the agent the work is done — checkable, and exhaustive where that matters — not merely what to do.
- **Premature completion.** Steps still ahead create forward pull that tempts the agent to rush the one in front. Sharpen the current step's completion criterion first; split the sequence only if that fails.
- **No-op detection.** For every sentence ask *does this change behaviour versus the default?* When one fails, delete the whole sentence rather than trimming words from it.
- **Negation backfires.** Prohibition drags the forbidden behaviour into context: *"don't think of an elephant"* names the elephant and makes it **more** available. State the positive target wherever a target can be stated. This governs skill *bodies*; a description's negative triggers stay negative — they route, they do not steer.

Apply these while drafting the brief for the engine **and** while reading what the engine returns — not as a post-hoc read. Select only the practices this candidate turns on, and in the Step 4 report **name each practice used and the concrete change it produced**. A practice named without a change it produced is not evidence it was applied. This method governs skill *quality*; need validation, mechanism selection, placement, system fit and adoption stay with this command.

**Qualified brief contract.** The `/request-skill` brief shape (`# Resource Brief:` / Requested / Origin / Capability / Trigger Conditions / Exclusions / Context / Existing Skills Reviewed) plus two required fields:

```
**Mechanism:** {the 1.4 verdict and why this rung, not a lower one}
**Evidence:** {the 1.2 evidence, cited — or "speculative"}
```

Both fields present means qualified. A brief without them is raw and belongs at Step 1.

**2.4 Build the minimum.** Modify an existing resource when responsibilities substantially overlap. Keep the change narrow enough to evaluate, leave adjacent improvements alone, and follow current repository and Git practice. Add infrastructure only when the candidate cannot work or be tested without it — a draft lives in its intended location, not in a `v2` scaffold.

**Completion criterion:** one candidate exists, its scope matches the Step 1 verdict, and nothing outside that scope was touched.

---

### Step 3 — Verify

Three questions, answered separately. **Answer all three before reading Step 4** — the decision is visible from here, and a skimmed verification is how this command fails.

**3.1 Is the candidate well made?** Clear purpose and scope; correct inputs and authoritative sources; appropriate invocation; necessary boundaries; useful output; a checkable completion or stopping condition; visible handling of missing evidence; proportionate length. For skill-class work, read the selected engine's own evaluation rather than repeating it.

**3.2 Does it belong in the system?** A durable resource is still justified; the mechanism is still the smallest reliable one; it duplicates and conflicts with nothing; it references rather than copies authoritative context; its consumers and handoffs are clear; its maintenance cost is proportionate; it can be replaced or removed cleanly. **Keep this separate from 3.1** — a well-made resource can still be the wrong thing to own.

**3.3 Does it do what it claims?** Choose tests from the candidate's own behavioural claims: a normal case, a materially different case, a non-interference case, a missing-evidence or stopping case, invocation and non-invocation, failure and recovery.

Judge depth in-session and store no classification. Deeper verification fits a resource that acts automatically, spans consumers, changes shared or persistent instructions, can destroy or overwrite work, or is hard to reverse. For mandatory change classes see `docs/audit-discipline.md`; for the verification floor by output class see `docs/spine-schemas.md` §4.

**3.4 Report what was observed.** A test that did not run is **unassessed** or **blocked**. Runtime behaviour is evidenced by execution — a file existing, documentation claiming a control is active, or a static check passing evidences none of it.

**3.5 Simplify.** Remove instructions, content or machinery that do not contribute to the demonstrated behaviour, then rerun the affected cases.

**Completion criterion:** 3.1, 3.2 and 3.3 each have a stated answer; every claim is marked observed, unassessed or blocked; simplification was considered, any non-contributing material removed, and every materially affected case rerun.

---

### Step 4 — Decide

**When a candidate was built,** give the operator: the need; the mechanism and why; what was reused, changed or left alone; **what happened before and what happens with the candidate**; where it applies and where it does not; what was actually tested and observed; what changes if it ships; and what would later justify simplifying, replacing or removing it.

The operator then chooses **Ship** (adopt via normal integration practice) · **Revise** (return only to the step the feedback affects) · **Defer** (preserve recoverably, unadopted) · **Delete candidate** (remove it, system unchanged). Adoption and integration wait for that choice.

**When no candidate was built,** give the recommendation, the evidence, and the existing capability or habit that serves the need instead. The operator chooses **Accept** or **Reconsider with additional evidence**.

Where the recommendation is an external resource, state which is proposed — **reference without installing · install or enable · adapt or copy into Axcíon · use only its method now**. Each is a separate decision.

**Completion criterion:** candidate built — before/after demonstrated and a disposition obtained. No candidate — recommendation explained, and accepted or reconsidered.

---

## Guardrails

- **Decide the technical questions here.** File shape, invocation model, hook design and test method are this command's job. Bring the operator business decisions — worth doing, acceptable burden, adoption.
- **Keep authoritative context by reference.** Copy when the source is unreachable, the content must stay fixed with the resource, or a pointer has demonstrably failed.
- **Stay inside the resource.** Portfolio prioritisation, repository redesign, incident recovery, architecture review, recurring audits, permission redesign and publication belong elsewhere — name the owner and route it.
- **These are reasoning phases.** They leave no stored state, gate or per-phase document.
- **Stop and surface** when the work needs a broader migration, or when two authoritative sources conflict.
