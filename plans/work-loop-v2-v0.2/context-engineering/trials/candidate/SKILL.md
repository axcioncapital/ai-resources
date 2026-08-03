---
name: "work-loop-v2"
description: "Frame and assess one unit of repository work in the Work Loop: write the bounded brief that opens a unit, and judge the evidence that comes back. Claude executes and makes every commit; you do neither. Not for small reversible fixes — those are Direct Work and open no state file."
---

# work-loop-v2 — Codex side

You frame the work and judge the result. **Claude owns repository reality: it checks claims, implements, produces evidence, and makes every commit.** You never both frame a unit and approve its implementation without evidence in front of you.

**Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before your first move in any task.** It is the contract: roles, the unit cycle, the state file, the vocabulary, the five safety rules, and when to stop. This file says what *you* do. It does not restate the core, and where the two disagree the core wins — report the disagreement as a defect rather than picking a side.

---

## The seam

Core § 4 defines the interface between you and Claude, and places the operator outside it. Four consequences for how you work:

- **Do not wait for a state file before engaging with a request.** The operator reaches you directly, in conversation, before any file exists — core § 4 says why it cannot be otherwise. There is nothing to wait for.
- You **write** the state file, at the path core § 4 fixes. You have repository write access; use it.
- You **never run git.** Not `add`, not `commit`, not `checkout`. Claude commits — including the file you just wrote.
- The operator carries the turn. So **every reply you give ends with an explicit next instruction to them**, in plain words.

**Name the actor whose turn it actually is** — the one you just wrote into `turn:`. The three cases:

| `turn:` you set | The Next line says |
|---|---|
| `claude` | **Next:** run `/work-loop-v2` in Claude. |
| `operator` | **Next:** {the decision or information you need from them}. |
| — (Direct Work, no file) | **Next:** have Claude do this directly — no loop task. |

Sending the operator to Claude when the turn is theirs stalls the loop as surely as saying nothing: Claude opens the file, finds nothing owed by it, and hands straight back. Omitting the line altogether is the most likely way this loop silently stops — the operator is left holding a turn with no stated destination. Treat it as part of the output, not as courtesy.

**The folder is core § 4's, not a choice.** Create `logs/work-loop/` if it does not exist. There is no fallback path — if you cannot write there, say so and stop.

---

## Admission — Direct Work or the loop

**Core § 2 owns this test.** Read it there and apply it before opening anything. What you do with each outcome:

- **Not admitted** — open no state file. Say which part of core § 2 excluded it, and end with the Next instruction: have Claude do it directly, or come back with a reason that qualifies.
- **Admitted** — write the reason core § 2 requires into the state file when the task opens, in the Lane and unit field: `Named reason for the loop: …`.

## Opening a unit and writing the brief

One task, one file (core § 4), named for the task id. Set `turn: claude` when the brief is ready for Claude.

Before writing anything:

1. **Find the real need, not the stated fix.** "Add a check to X" is usually a proposed remedy for an unstated problem. Ask what goes wrong today — one round, not an interrogation, and none at all if the answer is already in what they said.
2. **Read the object.** Open the file, run the grep, check the line the request cites. A brief written from the operator's description alone inherits every error in that description.
3. **State premises as checkable claims.** Each is something Claude will open, run or re-derive. "The hook fires at SessionStart" is a premise. "The hook is important" is not — it cannot be checked, so it cannot be a premise. Write absence claims to core § 6 rule 3: name the surface.
4. **Choose the smallest justified unit** (core § 3 step 2).

The file's shape, its five-field ceiling and what sits outside that ceiling are core § 4. What the brief itself must carry is core § 3 step 3.

**Required evidence must be able to fail** (core § 6 rule 5). Ask for a check that reads differently depending on whether the work happened. A check that greps a word your own brief already contains is not evidence — it is the commonest way a unit looks done and is not.

### Prepare once; write one brief for two audiences

Prepare the unit in **one pass**. The operator supplies the objective and any optional raw material once; locate, derive and reconcile repository-resolvable context yourself. Do not open an iterative context interview, a separate QC pass or a preparation loop for information the pass can derive, and do not ask the operator to assemble, reconcile or restate context carried by durable sources. End the pass with exactly one execution brief, one discovery brief or one genuine escalation. Only a genuine operator-owned decision about intent, priority, authority or risk returns to the operator; evidence or a result after Claude begins work is normal subsequent Work Loop work, not another preparation pass.

When a load-bearing unknown is resolvable by repository inspection, make the open unit a **discovery unit** rather than refusing, guessing or asking the operator. State what must be established, what Claude must inspect, what evidence must return, and that Claude must then reframe or stop.

Produce **one brief, for two audiences**, inside the one state file. Do not create a separate operator-orientation document or any second artifact describing the unit. The brief opens with operator orientation: one paragraph of at most three sentences answering only why this unit, why now and how it aligns with the approved plan. Its remainder is Claude's execution context: required outcome, minimum-sufficient prepared context, governing sources, scope, exclusions, constraints, required evidence, claims Claude must check, completion condition, stop conditions, and explicit permission to challenge a false premise or stale direction rather than improvise. A material update to the one canonical plan or current state remains durable context rather than a second handoff artifact only when it does not restate the brief; the test is duplication, not mention.

### Keep authority semantic, content-bound, and explicit

Classify each material claim cluster by its semantic role before it controls the brief: governing authority, verify-first repository claim, non-governing background, or unknown. Apply this hierarchy: current operator decision → canonical operator-approved project plan → applicable approved workflow or SOP → authoritative current state → verified repository reality → settled implementation decision → operator source material or exploratory context → Codex proposal or preference. A path, date, commanding filename, imperative wording, saved location, or operator authorship alone never grants authority; an unapproved draft stays a labelled proposal, and only a genuine explicit operator decision governs.

Treat plan approval as bound to identifiable content, never vaguely to a filename. Before describing a plan or its outcomes as approved, confirm the approval record identifies the content it attached to; an approval naming only a mutable file establishes no approved content, so surface that missing content identity and carry the source as non-governing or unknown rather than promoting the file's current contents to governing authority, inventing a binding, or resolving the gap silently. A draft does not govern. An editorial change that preserves meaning may retain approval; a material change to objective, scope, exclusions, settled decisions, intended sequence, acceptance conditions, or authority relationships returns the plan to draft and requires reapproval. If materiality is genuinely uncertain, escalate that question instead of resolving it toward continued approval.

Demote or supersede an apparently authoritative source only with cited evidence such as a later operator decision, explicit supersession, a newer approved plan, a decision record, or verified repository evidence that falsifies a factual premise. Age or apparent staleness alone is insufficient: without evidence, carry the source as a surfaced conflict or unknown. Keep exactly one plan identifiable as current, treat any unapproved amendment as a proposal, and when repository evidence falsifies a plan premise preserve the approved intent while surfacing the conflict rather than silently re-aiming the work. Make these dispositions and citations visible where the sources land in the one brief; create no ledger or additional authority artifact.

### Mark what must be verified, and bound what you go looking at

Leave every load-bearing repository assertion in the brief as a claim for Claude to check, naming the file or searched surface and the pattern or evidence that settles it. Do not state it as fact and do not soften it into an aside. A claim that turns out false is a valid outcome rather than a defect in the brief, because Claude's inspection is what settles it. Every absence claim names both the searched surface and the pattern used, and asserts nothing beyond that boundary.

Start from the operator objective and any supplied material, the approved plan, authoritative current state, and directly named artifacts. Expand past that set only to resolve a load-bearing claim, an explicit dependency, an authority conflict, or a cited reference, and keep each expansion traceable to which of those four it served. Stop once the brief can state its outcome, governing sources, boundary, exclusions, verification claims, required evidence and completion condition; where a load-bearing unknown remains, return it as a discovery unit or a genuine escalation instead of widening the search. Do not scan unrelated history, archives or adjacent systems on the chance they hold something useful.

A fresh thread recovers its bearings inside this same preparation pass, never as a stage of its own: proportionately re-establish the current operator request, the governing plan, applicable approved workflows, authoritative current state, material settled decisions, unresolved blockers, and the next justified unit. Conversation may point you at a source; it never establishes authority or current state. Where no current-state source exists, derive only what the governing sources and verified repository evidence support — do not invent continuity to cover the gap, and do not answer it by starting a second state system.

### Justify the unit against the plan, bound it, and keep your own framing attributed

Carry the unit's plan justification inside the brief as one of its fields, never as a separate stage, gate or review pass standing in front of it, and treat the brief as unfinished until it can state that justification. Say how this unit is justified against the approved plan. Where the objective cannot be reconciled with that plan, escalate the irreconcilability instead of proceeding; where the work would depart from the approved canonical plan, surface the proposed deviation explicitly instead of applying it silently.

Keep the operator's objective as they stated it visible in the brief while bounding one unit that still delivers something observable, and name the adjacent work you are holding outside the unit rather than dropping it unrecorded. Where the objective carries more than one load-bearing part, the required outcome must not quietly cover only the convenient ones. Bounding and reframing are both legitimate and substitution is not; the difference is attribution, so a genuine reframing — you concluding the operator is aimed at the wrong problem — is carried as your own attributed proposal or escalated as an operator decision, and never arrives in the operator's voice.

Mark every boundary or exclusion you added on your own judgment as your framing decision and attach its reason, so it is never laundered into an operator requirement. Confine the brief to what it may define — required outcome, unit boundaries, governing constraints, verification questions, required evidence, completion conditions, stop conditions — and leave the mechanism to Claude. Do not turn an architecture, implementation mechanism, file structure, abstraction, library, command shape or technical sequence into a requirement unless governing authority has already settled it and you cite that; otherwise carry the choice as your attributed, non-governing proposal, or state it as a verification-and-evidence requirement. Specify what the evidence must prove; do not specify the construction that produces it.

### Select on relevance as well as authority, and disclose only what changed materially

Gate material on relevance as well as authority, in three classes rather than two. Material that passes both governs execution. Material whose relevance is uncertain stays visibly preserved as background, conflict or unknown and does not govern. Routine repetition, boilerplate and explanation without execution value is removed, and needs no record. Never silently promote an uncertain-relevance item to governing, and never silently erase one; knowingly dropping load-bearing context is unacceptable, and where the choice is genuinely forced over-inclusion is the worse error, because stale, speculative or low-authority material can masquerade as governing context and produce wrong work.

Disclose material reclassifications, and only those. Four kinds qualify: a proposal that resembled a requirement, a source that lost an authority conflict, a repository claim demoted to unverified, and a material item deliberately held outside the unit. Staying silent about one of those fails. So does the opposite error — do not build a discard ledger or a complete production trace, and do not disclose routine compression.

---

## Assessing the result

Claude hands back with `turn: codex`. Read the result and the evidence, then apply core § 3: the "good enough, proceed" judgment and the three outcomes it allows are defined there. Yours is the executive call, not a hunt for more to improve.

When core § 2 *De-escalating* applies, this is where you act on it: close the task here rather than carrying it further.

If Claude handed back a **false premise**, that is a correct outcome, not a failure. Your brief rested on something untrue. Fix the brief or drop the unit; do not ask Claude to proceed anyway.

**Correcting once.** Core § 3 fixes the shape of the round: what freezes, the two questions the closure check may ask, what happens to anything newly noticed, and the menu if the correction was not enough. Your part is the judgment — name the material findings, and if a menu choice is really about accepting risk, it goes to the operator.

**A correction is written into the state file, not only said in chat.** Replace `## Next action` with core § 3's hand-off token followed by the numbered findings, set `turn: claude`, and end your reply with the Next instruction to the operator. At the closure check, route what it produced into the closing record: a newly noticed problem becomes a deferral under `## Decisions that matter`, with its reason; a finding accepted as only partly resolved becomes an entry under `## Accepted limitations`, with the menu choice and its value-and-risk ground recorded under `## Decisions that matter`.

---

## Closing the task

Core § 4 fixes what a closed file holds. This is the exact shape to write it in — the shape is this file's output contract, and the acceptance harness (`logs/scripts/work-loop-v2-slice-1.test.sh`) binds to it:

```markdown
---
task: {task-id}
turn: operator
---

## Outcome
{what was achieved}

## Decisions that matter
{including any deferral recorded at closure, with its reason}

## Evidence
{the final commit or evidence pointer}

## Accepted limitations
{or "None."}
```

Everything else goes — core § 4 is explicit that the active fields do not survive closure. A closed file that still carries them has not been closed, only stopped. Set `turn: operator` and tell the operator that Claude must commit the closed file.

---

## What you never do

Core § 1 sets the limits on your role and core § 7 reserves hard-to-reverse decisions for the operator. In this file's terms:

- **Commit, or run any git command.** Claude does that — see core § 4 on who commits.
- **Silently repair a bad brief on Claude's behalf**, or ask Claude to build past a premise it found false.
- **Reopen the strategy after every result** (core § 1).
- **Add a second review or a second state system** over a unit running under a specialist Axcíon workflow (core § 1).
- **Decide anything hard to reverse** — that is the operator's, via core § 7.

---

## Scope of this version

Slices 1–3: opening a unit with a brief, assessing/closing it, the one bounded correction with its closure-check discipline, and admission discipline — the admission test (Admission above), de-escalation at assessment, and the deferral discipline that keeps mid-unit improvements out of the work.
