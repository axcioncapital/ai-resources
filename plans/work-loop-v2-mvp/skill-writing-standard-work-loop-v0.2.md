# Skill-Writing Standard for the Work Loop Build

**Version:** v0.2 (adds Section 7: write for the operator)
**Who this is for:** Claude, in any session that drafts or revises the Work Loop artifacts: the Claude Code command, the Codex resource, or the executable core.
**What this is:** the writing standard those artifacts must meet. It is based on Matt Pocock's skill-design principles and on the v1 failure lesson that long instructions degrade the work they are meant to guide. This document should itself model the standard: if any rule here does not change what you write, it should not be here.

---

## 1. The prime rule: attention is the budget

Every sentence in a command competes with the actual repository problem for the model's attention. A skill encodes one useful behaviour clearly; it is not a handbook. Pocock's own proof is `/grill-me`: a very short instruction, applied at the right moment, materially changes behaviour.

Practical consequences:

- The command and the resource **link to the executable core** for rules. They never restate the core's content. One policy owner; zero drift.
- Philosophy, rationale, and history never appear in the command. If a sentence explains *why* a rule exists, it belongs in the reference document, not the instruction.
- When in doubt, cut. A shorter instruction that produces the behaviour beats a longer one that describes it.

---

## 2. Behaviour before procedure

Write the observable behaviour first. Only then write the minimum steps that produce it. Every sentence must trace to an observable behaviour; if it does not, delete it.

**Bad (describes an attitude, produces nothing):**

> Claude should carefully and thoroughly verify all assumptions and be rigorous before proceeding with implementation.

**Good (produces a checkable behaviour):**

> Before implementing, check each claim listed under "Verify against repository" in the state file against the live repository. If a load-bearing claim is false, do not implement. Write into the Result section: what you inspected, what you found, and why the premise fails. Commit and stop.

The bad version cannot fail a test. The good version can, which is exactly what makes it an instruction.

---

## 3. Design the trigger like an interface

The description that decides *when* a skill activates matters as much as its body, and it must state when the skill does **not** activate.

**Bad trigger:**

> Use this command for repository work with the Work Loop.

**Good trigger:**

> Use when the operator invokes the Work Loop on a task that has a task-state file, or asks to start one. Do NOT use for small, reversible fixes that need no cross-session continuity; per the admission test in the core, do those directly and say so. If invoked on work that does not need the loop, state that Direct Work applies and proceed directly.

The negative clause is not decoration. It is the admission test working at the trigger layer.

---

## 4. One concrete example beats paragraphs of adjectives

Each artifact carries at most one or two worked examples, and where a behaviour has a failure mode, include the negative example too.

**Example pair the Codex resource should carry (a good brief versus a bad one):**

**Good brief (bounded, verifiable, non-prescriptive):**

> **Objective:** contacts in the CRM can carry a follow-up date, visible in the contact view.
> **Why:** the operator currently tracks follow-ups by memory; missed follow-ups are the top reported friction.
> **Verify against repository:** (1) the contact model has no existing follow-up or reminder field; (2) the contact view is rendered from `contact_view` and nothing else consumes the contact model's display block.
> **Scope:** contact model, contact view, and their tests. **Excluded:** notifications, recurring follow-ups, email integration.
> **Evidence required:** a contact saved with a follow-up date and the date visible on reload.
> **Stop if:** the data model differs materially from claim (1), or the change would touch more than the scoped files.

**Bad brief (prescriptive, unverifiable, unbounded):**

> Add a `followUp: Date` column, update the serializer, refactor the view helpers to be cleaner while you are there, and make sure everything is robust and well tested. Use best practices.

The bad brief dictates implementation (Codex's overreach), invites scope creep ("while you are there"), and demands nothing checkable ("robust"). The resource's example section should show this contrast once; that teaches more than any rule list.

---

## 5. Explicit stop conditions

The best skills state when to stop and report rather than improvise. "If X, stop and hand back" outperforms ten paragraphs of general caution. The Work Loop command must contain, at minimum, stop conditions for:

- a load-bearing premise in the brief is false;
- the work would exceed the approved scope or touch excluded areas;
- the state file is missing, malformed, stale, or belongs to a different task (validate read-only, mutate nothing, report);
- the required evidence cannot be produced;
- a settled decision would need reopening to proceed.

Each stop condition names the behaviour on stopping: write findings to the Result section, commit, hand back. Never silently improvise past a stop condition.

---

## 6. Use the pinned vocabulary exactly

Task, unit, brief, state file, lane, correction, evidence, deferral, close: use the executable core's terminology section, and only it, in every artifact. Never introduce synonyms (no "ticket" for unit, no "handover doc" for state file, no "review round" for correction). Ambiguous words in a skill become ambiguous behaviour in a session.

---

## 7. Write for the operator, not only for the machine

Every artifact must be readable by the operator. He supervises this system. An instruction he cannot understand is an instruction he cannot supervise, correct, or trust.

Rules:

- Use plain, common words. Short sentences, roughly 15 to 25 words. One idea per sentence.
- No unexplained jargon, acronyms, or repository-internal shorthand. If a technical term is unavoidable, define it in plain words at first use.
- Prefer concrete verbs ("check the file", "stop and report") over abstract nouns ("perform validation procedures").
- Machine-required syntax (frontmatter, tool names, command syntax) is exempt, but each such block gets a one-line plain-language comment saying what it does.

Plain language costs the model nothing. A model follows "check each claim, and stop if one is false" at least as well as any technical phrasing of the same rule. If a behaviour seems expressible only in dense language, that is usually a sign the behaviour itself is not yet clear; clarify the behaviour, then the plain words come easily.

**The test, treated as a failing case like any other:** the operator reads the artifact and explains back, in his own words, what it makes the models do. If he cannot, the artifact fails. The fix is revising the instruction, never explaining it to him in chat.

---

## 8. Prove the instruction red-green, like code

An instruction is well-written when it reliably produces its behaviour against a failing case, not when it reads impressively. For each acceptance behaviour in the slice plan: construct the failing case first, run the drafted skill against it, and revise the instruction until the behaviour appears.

The core failing cases for this build:

| Behaviour | Failing case to construct | Pass condition |
|---|---|---|
| False premise refused | State file claiming a field exists that does not | Claude reports the inspection and does not implement |
| Continuity | Brand-new session, no conversational memory | Task continues correctly from state file and Git alone |
| Bounded correction | Assessment names findings A and B | Correction touches A and B only; closure checks A and B only |
| Admission discipline | A two-file reversible fix request | Direct Work path; no state file created |
| Foreign state rejected | State file with a mismatched task identity | Rejected read-only; nothing mutated |
| Scope discipline | Tempting adjacent improvement visible mid-unit | Recorded as a deferral; not implemented |

## 9. When a skill misbehaves, fix in this order

1. Clarify the specific instruction sentence.
2. Add or sharpen one focused example.
3. Adjust the skill's structure or trigger.
4. Only after those fail, consider anything larger.

Never respond to misbehaviour by making the prompt longer in general. Length is the disease v1 died of, not the cure.

---

## 10. Before committing any artifact, check:

- Every sentence traces to an observable behaviour.
- The operator could read this artifact and explain what it makes the models do: plain words, short sentences, technical terms defined at first use, machine syntax commented.
- No rule from the executable core is restated; it is linked.
- The trigger says when NOT to activate.
- At most one or two worked examples, with a negative example where a failure mode exists.
- All stop conditions present, each with its on-stop behaviour.
- Only pinned vocabulary used.
- Every acceptance behaviour has passed its failing case.
- The artifact got shorter, or at least no longer, in the final revision pass.

Where the repository's `skill-creator` conventions apply, follow them for structure and frontmatter; where `ai-resource-evaluator` is available, run it as the targeted review at slice end. The pilot on real CRM and Email OS work remains the only evaluation that finally counts: judge the skill by what it ships.
