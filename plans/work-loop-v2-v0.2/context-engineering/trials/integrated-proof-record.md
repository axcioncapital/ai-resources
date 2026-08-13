# S11 — integrated proof record

**What this is.** The Context Engineering S11 observation record: one **genuine** two-model unit of work the operator wanted done anyway, carried from a Codex-written brief to a Claude implementation, with the two operator action counts recorded separately.

**Date:** 2026-08-04. **Session type:** genuinely two-model — the operator, a Codex thread, and a Claude Code session.

> **This is non-adoption evidence.** The plan is in Phase 4 under the **Route 3 deviation** (§7.2): S8b closed with three checks unmet, the operator chose to continue while the debt stands, and **everything produced while it stands is non-adoption evidence, whatever else it demonstrates.** Nothing below makes adoption available, and nothing below discharges S8b's debt. See §5 of this record.

---

## 1. What this record claims, and what it does not

**It claims CE-17 clause 3 was demonstrated on this run.** Claude received the brief from the state file and acted on it with **zero operator context-transfer actions** — the count is §3 below, and it is the operator's own, not inferred.

**It does not claim:**

- that the seam is **behaviourally proved** — §7.2 forbids any downstream record from describing it that way, and this record does not;
- that **adoption** is available — Phase 6 condition 4 remains unmet;
- that **S8b's three owed checks** are obtained, in whole or in part;
- that the brief was **produced by the candidate** rather than by a Codex thread working to the same interface. §4 states exactly what is and is not observable about that from this side.

**Two proofs exist and only one is at issue here.** The isolated proof is items 1–6 and 8 of the plan's §5.1 observable destination; **the integrated proof is item 7 — clause 3 — and that is what this run addresses.** The S3b shadow-slice record is explicit that it is *not* the integrated proof; this record does not inherit anything from it, and it is not a substitute for S8b.

---

## 2. The genuine unit

A manufactured unit tests nothing, so this was a real piece of work with its own value independent of the trial.

| | |
|---|---|
| Task id | `axcion-writing-studio-phase-11-v3` |
| Task path | `projects/axcion-systems-builder/logs/work-loop/axcion-writing-studio-phase-11-v3.md` |
| Repository | `axcion-systems-builder` — its own git repository, separate from `ai-resources` |
| Lane and unit | Standard, unit 1 |
| Objective | Produce the Axcíon Writing Studio Phase 11 solution-definition draft (V3) from the approved V2, the approved MVP boundary and the operator-selected Phase 10 solution; record the selection durably; leave the case ready for Phase 12 Codex Review 4 |

**Why it qualifies as genuine.** It is the next justified step in an eleven-phase case the operator has been running since 2026-07-23. It was going to be done whether or not a trial observed it, and its deliverable — a sixteen-section V3 draft — has value to that case and none to this plan.

---

## 3. The two counts, kept apart

**The plan requires these separately** and names merging them, or omitting the open-task count, as failures on the concealment rather than on the number.

### Count 1 — operator context actions: **0**

**Target: zero**, beyond stating the objective once and any genuine decision.

**Source: the operator's own report.** They were asked directly, because only they know what they did, and the question defined a context action as *restating, assembling, pasting, summarising or hand-carrying the brief or its content between the models*. **This number is not inferred from anything Claude observed**, and inferring it was explicitly prohibited by the unit's own brief.

**Claude's side is consistent with it.** Claude opened the state file itself, read the brief there, and worked from it. **No brief content reached Claude through the operator.**

### Count 2 — operator trigger actions: **1**

**Derived from an observed repository state, not asserted.** At the moment Claude was invoked, `projects/axcion-systems-builder/logs/work-loop/` held **four** state files, of which **exactly one** carried `turn: claude`:

| File | `turn:` at invocation |
|---|---|
| `axcion-writing-studio-phase-11-v3.md` | **`claude`** |
| `crm-derived-answer-authority.md` | `operator` |
| `decision-entry-referenceability.md` | `operator` |
| `review-packet-preservation.md` | `operator` |

**One `turn: claude` file existed.** The live command therefore resolved the task without the operator naming it, so the trigger cost was **one action — typing `/work-loop-v2` with no argument.**

> **These are working-tree values — what the command actually reads — and two of them differ from what is committed.** §7 sets out which, and shows the count of one holds under either reading. A reader checking git alone would otherwise find an apparent contradiction here.

**This count could have read two.** Had a second `turn: claude` file existed, the command would have listed the candidates and asked which — a second operator action. **The number is a property of the repository at that moment, not a claim about how well the run went.**

### Why the second count does not fail clause 3

Per §4.5 of the implementation plan, which this record cites rather than re-derives:

> The operator typing `/work-loop-v2` is a **trigger, not a context transfer**: the context is already in the file Claude opens by itself. Clause 3 fails on **ferrying** — the operator assembling, restating or hand-carrying the brief. It does not fail on the operator being the one who says "go". **Naming which task to open is the same kind of action:** it identifies a file, it transfers no context.

**The distinction is between *identifying* a task and *supplying* its content; only the second fails clause 3.** A trigger count of two would not have failed it either. **Concealing the count would.**

### One operator action that belongs in neither count, disclosed rather than filed away

**Claude asked the operator for count 1, mid-run, and they answered.** That is an operator action, and it is neither a trigger nor a context transfer — it is the **measurement instrument**, required by S11's own design ("the operator counts their own actions, because only they know what they did") and by this unit's brief, which required the count to be obtained rather than inferred.

**It is recorded here rather than silently excluded**, because §5.2's failure mode is concealment, and a reader should be able to see every operator action the run involved and judge the classification for themselves. **It transferred no brief content in either direction** — the question was about the operator's own behaviour, not about the work.

---

## 4. What is and is not observable from Claude's side

Stated plainly, because the boundary matters more than the verdict.

**Observable, and observed:**

- The state file existed at the path §4.5 names, with `task:` matching the resolved id and `turn: claude`.
- Its `## Brief` visibly carried the §4.1 semantic interface: the unit's justification against the approved plan, each material source with its disposition, the adjacent work held back, **Codex's own framing decisions marked as its own** (a `Boundaries added by Codex` heading with a reason per boundary), and six load-bearing repository claims each naming its surface and the evidence that settles it.
- Claude checked all six claims by inspection before acting; **all six held**, and the inspection record is in the task's own state file.
- Claude went from reading the brief to running the first inspection with no gap it had to guess across.

**Not observable from this side, and therefore not claimed:**

- **Whether the brief was produced by the candidate** (`trials/candidate/SKILL.md`) or by a Codex thread working to the same interface by other means. The artifact shape is consistent with the candidate; **shape is not provenance**, and no repository surface in either project records which produced it.
- **How many preparation passes Codex took**, or whether anything was returned to the operator on the Codex side before the brief was written. §5.1 items 1–2 are isolated-proof items and are not evidenced here.
- **Whether the operator stated the objective exactly once.** Their count of zero context actions bears on the ferrying question; it is not a transcript of the Codex thread.

**This split is the point of the record.** Clause 3 is a claim about the *handoff*, and the handoff is the half Claude can see.

---

## 5. Standing against the Route 3 debt

**S8b's three checks remain owed and are not touched by this run.** The task record is `logs/work-loop/context-engineering-s8b-seam-proof.md` in this repository, and §7.2 carries them forward as owed, never as obtained:

1. The **causal post half** of the pre/post pair at the real entrypoint.
2. The **Direct Work check, passing** — the observed absence of a state file after a small reversible fix run through the wired entrypoint.
3. The **post-integration false-premise refusal**, with the named target file observably unmodified.

**None of the three is demonstrated here, and this run is not a substitute for any of them.** Clause 3 and S8b's pre/post pair are different evidence about different things: clause 3 asks whether the operator had to ferry context; S8b's checks ask whether the *edited candidate* changes behaviour causally at the live entrypoint.

**Consequences, stated so a later reader cannot mistake them:**

- **Phase 6 condition 4 is unmet and stays unmet** until a separate, explicitly authorised proof task establishes it.
- **This record is non-adoption evidence.**
- **The seam is not described as behaviourally proved anywhere in this document**, and it must not be described that way on the strength of it.
- If a later authorised task obtains S8b's three checks and a subsequent fix then touches the seam, **those checks are owed again** against the changed candidate.

---

## 6. Phase 4 exit condition

> **Phase 4 exit:** clause 3 demonstrated or recorded as owed, with the operator context-action count on record.

**Met, in its first form.** Clause 3 was **demonstrated** on this run: context actions **0**, trigger actions **1**, one `turn: claude` file open at invocation, and the operator's count supplied by the operator.

**What this does and does not unlock.** It satisfies Phase 4's exit and nothing beyond it. **It is not the adoption decision** — the plan states plainly that the candidate is not yet in the state adoption would apply to, and Route 3 keeps everything downstream of it non-adoption evidence while S8b's debt stands.

---

## 7. Evidence pointers

| What | Where |
|---|---|
| The genuine unit's state file, with its inspection record and result | `projects/axcion-systems-builder/logs/work-loop/axcion-writing-studio-phase-11-v3.md` (in the `axcion-systems-builder` repository) |
| The unit's deliverable | `cases/axcion-writing-studio/05-approved-solution-definition-v3.md`, same repository |
| The open-task count at invocation | The four files listed in §3, count 2 — **partly re-derivable from git; see the note below, which says exactly how far** |
| The trigger/context distinction cited in §3 | `../context-engineering-implementation-plan-v0.1.md` §4.5 |
| The Route 3 deviation and the three owed checks | `../context-engineering-implementation-plan-v0.1.md` §7.2; `logs/work-loop/context-engineering-s8b-seam-proof.md` |
| The isolated shadow proof, which this does **not** extend | `shadow-slice-record.md` |

**The two artifact commits**, both made by Claude at the close of the unit:

| Commit | Repository | Contains |
|---|---|---|
| `d2f967e9fb28a1898ce6e352ee390ce3df945547` | `axcion-systems-builder` | The V3 draft, the Phase 10 decision record, the case-index status, and the unit's state file — 4 files |
| `d985043c8524d586c9e0ab164942f7d77152ac4b` | `ai-resources` | This record — 1 file |

### How far the open-task count is re-derivable from git — stated exactly

**It is not fully re-derivable, and the earlier wording in this table implied it was.** Corrected here rather than left standing. Two of the four files' invocation-time states lived only in the working tree:

- **This unit's own state file was untracked at invocation.** It first enters git at `d2f967e`, by which point Claude had already set `turn: codex`. **Git therefore holds no commit showing it as `turn: claude`**, which is the very value the count turns on.
- **`decision-entry-referenceability.md` was modified-uncommitted**, and still is. Its working-tree value at invocation was `turn: operator` — which is what §3 records, because that is what the command reads. **Its committed value at the pre-unit HEAD `a0ae384` is `turn: codex`.** A reader checking git alone would see a different value and could reasonably think §3 was wrong.

**The count of one is unaffected by either gap, and that is checkable.** `codex` is not `claude`, and `operator` is not `claude`. At `a0ae384` the three tracked files read `operator`, `codex`, `operator`; in the working tree at invocation they read `operator`, `operator`, `operator`. **Under both readings, none of the three is `claude`**, so the only `turn: claude` file was this unit's own — exactly one, and the trigger count of 1 stands.

**What a later reader can and cannot verify:** they can verify the three other files were never `claude` in either form, and they can verify both commits above contain what is attributed to them. **They cannot verify from git alone that this unit's file read `turn: claude` at invocation** — that rests on the run's own record, which is this document and the unit's state file. The distinction is recorded because the alternative is an evidence pointer that looks stronger than it is.

**The context-action count is capable of failing and did not:** any value above zero would have failed clause 3 outright, and the operator was asked in a form that made a non-zero answer available.
