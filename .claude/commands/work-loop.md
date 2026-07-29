---
model: opus
effort: high
argument-hint: "[a need in plain English, a pasted Codex BRIEF block, or nothing to resume]"
---

Run one unit of the cross-model work loop: ingest a brief, verify its premises, classify the route, implement in-scope changes, return evidence for independent review, adjudicate the findings, and close. Codex is the independent reviewer; Claude is the single writer.

Input: `$ARGUMENTS` — a plain-English need, a pasted Codex `BRIEF` block, or empty to reconcile and resume.

**Read `ai-resources/docs/work-loop.md` before anything else, every invocation.** It is the contract: vocabulary, route triggers, block formats, artifact rules, reconciliation and resume order. This command orchestrates and implements; it does not restate the contract. Where this file and the contract disagree, the contract wins and the disagreement is a defect to report.

This command does **not** invoke `/session-start` or `/session-plan` — it is not a session lifecycle command, and `session-start.md:330` hard-fails without a `/prime` marker it has no business creating.

---

## Step 1 — Reconcile

Before consulting any resume tier, run the reconciliation table in `docs/work-loop.md` § Reconciliation. It is deterministic: match the observed state to a row and take that row's action. Report each repair in one line. Two rows are stops, not repairs:

- A record pointing at `Y` while an **incomplete** brief for `X` in the same stream is open → **stop, report both paths, ask.** Never merge, never guess.
- Uncommitted changes in `logs/loop/` → **report before resuming.** Never commit them silently.

One row is deliberately silent: a completed unit whose record reads `active_unit: none` is normal retained state, not an orphan. Do not report it and do not re-point to it.

## Step 2 — Resume or ingest

Apply the tiered resume in `docs/work-loop.md` § Resume order. No code path sorts by timestamp.

- **An open unit was resumed** (Tier 1, or Tier 2's incomplete unit) → announce in one line (`Resuming {UNIT} — {phase}, route {route}.`) and continue at the phase that unit was in. Never re-run a completed phase and never ask the operator to re-explain.
- **An open stream needs its next phase opened** → announce `Continuing {STREAM} — opening {phase}.` and go to Step 3 **carrying the existing stream unchanged**. Two shapes reach here, and both are ordinary multi-session work, not an edge case:
  - **Tier 3** — a capability record in the ACTIVE set with `active_unit: none`. Take the phase from its `## Current phase and next action`, and its stream from the record's `stream:`.
  - **A challenged or reviewed non-capability stream** whose units are all complete but whose last closed phase is not Land. It has no record by design, so read the phase from the stream's own artifacts: glob `logs/loop/{STREAM}-*`, take the furthest-along unit, and open the next phase after it.
- **No open work, `$ARGUMENTS` present** → treat it as a new need and continue to Step 3.
- **No open work, no `$ARGUMENTS`** → ask once what the need is. Wait.

> **Carrying the stream is the whole point, and getting it wrong is silent.** On the continuation branch, Step 3 **carries** the stream — it does not allocate. Allocating would mint a *new* stream id, and because the collision check appends `-2` on a same-date same-slug repeat, the new unit's `logs/loop/{STREAM}-*` glob could never reach the earlier phases' artifacts. Prove would then be unable to read Shape's review, which is the cross-session guarantee `docs/work-loop.md` § Correlation exists to provide. Nothing would error; the stream would just quietly split in two.

**If `$ARGUMENTS` is a pasted Codex `BRIEF` block**, transcribe it verbatim to `logs/loop/{unit}.brief.md` at Step 3. Do not rewrite it, do not improve it, and do not merge two briefs. If it lacks the six header fields, ask Codex for a corrected block rather than filling them in yourself.

**If `$ARGUMENTS` is plain English**, compose the brief yourself in the contract's `BRIEF` shape. Say plainly in chat that this brief is Claude-authored, so it has had no independent framing — that is a real, recorded weakness of the unit, not a formality.

## Step 3 — Open the unit

**The unit opens before its premises are verified, and that order is the contract's** (`docs/work-loop.md` § The eight steps). It is deliberate: a rejected premise is a *result*, and a result needs an identity to be recorded under. Opening first guarantees that every artifact a unit produces — including the evidence for its own rejection — has a brief in front of it, which is exactly what § Resume order and § Reconciliation index on.

**Check the artifact root first** (`docs/work-loop.md` § Artifacts → Artifact root). The unit's artifacts belong in `logs/loop/` of the repository its block names in `REPO`, and this command must be running from that repository's root. If the invoking session's cwd is not that root, **stop before writing anything**:

> This unit declares `REPO: {repo}`, but this session is rooted at `{cwd}`. Its artifacts would be written where no `{repo}`-rooted `/work-loop` could find them. Re-invoke from `{repo}`. Nothing has been written.

Do not write the unit to the current root instead — that is the exact silent failure the rule exists to stop.

Allocate or carry the stream per `docs/work-loop.md` § Streams, units and phases, including the collision check against **both** surfaces (`logs/loop/{candidate}-*` and any `development/*.md` carrying `stream: {candidate}`).

Write in this order, and this order is load-bearing (contract § Ordering rule):

1. `logs/loop/{unit}.brief.md` — the fact.
2. The record pointer — **capability units only.** Set `active_unit: {unit-id}` in `projects/{p}/development/{slug}.md`, and `updated:` to today. Skip entirely for non-capability work and for **solo** capability units, which write no record at all. If the record does not exist yet, this is the unit that opens it — see Step 5b.
3. `git add` **by explicit pathspec**, then commit.

The brief is written **before** the pointer and both land in **one** commit — contract § Ordering rule. The brief is the fact; `active_unit` is only a pointer to it. A dangling pointer and an orphan brief are both detectable and repairable by § Reconciliation; a pointer with no brief behind it is the harder case, which is why it is written second.

Never `git add -A`, never `git add .`. Stage the paths this unit wrote, by name.

Announce: `UNIT: {unit-id}  STREAM: {stream-id}  PHASE: {phase}`

The route is not known yet — it is classified at Step 5, once the premises hold. Announce it there.

## Step 4 — Verify premises

**This step gates every edit to the object under work. Nothing is written to the brief's target before it passes.** Opening the unit at Step 3 is not an exception to that rule: the brief is the unit's own record, not a change to the object.

For each premise the brief asserts: run the script it cites, open the lines it names, re-derive the count it states — recording which primitive produced the number. Recall is not verification. A citation is not a check. **Re-derive against the live file every time** — a copy read earlier in the same session may already be stale.

Emit one line per premise:

```
PREMISE: confirmed — {claim} · {what was run} → {what was observed}
PREMISE: rejected  — {claim} · {what was run} → {what was observed instead}
```

**On any rejected load-bearing premise: stop the unit.** Make **zero edits to the object under work** and close as `rejected-premise` by the ordinary path in `docs/work-loop.md` § Closing without a change — evidence carrying the premise and what disproved it, the `CLOSE` block, the stream close and the durable `logs/decisions.md` pointer, all in one commit. Do not repair the brief's reasoning on its behalf and do not proceed on the surviving premises — a brief whose foundation is wrong needs re-briefing, not salvage.

**Negative results need a positive control.** An empty grep, a zero count or a "no matches" is not evidence until the same check has been shown to fire on a case that should match. State the control and its result alongside the negative.

## Step 5 — Classify the route

Apply `docs/work-loop.md` § Route triggers. Any one trigger fires; ambiguity resolves **upward**. State the route and the specific criterion that fired:

```
ROUTE: solo — one repository, 2 files, revert-reversible, no shared blast radius
```

For a **capability** unit, additionally apply `skills/capability-development/SKILL.md` § Route triggers. Read that skill only for capability units; never for ordinary work.

**Branch:**

| Route | This build |
|---|---|
| **solo** | Live — continue to Step 6 |
| **reviewed**, non-capability | Live — continue to Step 6 |
| **challenged**, non-capability | Live — see Step 5a |
| any **capability** unit | Live — see Step 5b, **in addition to** this row's route branch |

`/risk-check` fires at its own two gates on its own schedule (`docs/audit-discipline.md:73-81`). This command never absorbs, replaces, reschedules or substitutes for it. If the unit touches a structural class, the route escalates to challenged *and* `/risk-check` still runs at its own gates.

### Step 5a — Challenged route

Reference for the gates and review placement is `docs/work-loop.md` § The challenged route — read it; this step does not restate it. What follows is how to run the branch.

**One unit per phase.** This unit is *one* phase of the stream, not the whole stream. Identify which phase it is from its unit id and run only that phase's block below, then close the unit at Step 8. The next phase is a new unit, opened by a later invocation — possibly days later, in a fresh session.

**Announce the route and the gate that is now armed:**

```
ROUTE: challenged — {criterion that fired}
GATES: G1 (scope and package) · G2 (release) · G3 (lifecycle) — three, no fourth
```

**Escalation into challenged arms G1 immediately.** If this unit escalated mid-flight, stop at G1 with whatever package exists and say what is missing rather than back-filling it.

#### Frame unit

Close the phase's question — what is the need, who owns it, is it in scope at all — and write the evidence. **No gate here.** Continue to Step 7 (evidence, no review on Frame), then Step 8. The next unit is Shape.

#### Shape unit — the pre-implementation review, then G1

1. **Write `logs/loop/{unit}.plan.md`** in the contract's `PLAN` shape: what will be done, in order · what it touches · **what would falsify it**. The falsification criteria are load-bearing — Prove is judged against them, so a plan that states none makes G2 unfalsifiable. Immutable; a revision is `-v2`. Commit by pathspec.
2. **Make no edit to the object under work.** This is the route's defining property. The plan is the deliverable of this unit.
3. **Emit the plan for Codex review** as a chat block, and tell the operator plainly: paste it into the Codex `work-loop` task, then paste the returned `REVIEW` block back here. **The object under review is the plan, not a diff.**
4. **Transcribe the review verbatim** to `logs/loop/{unit}.review-1.md`. Commit by pathspec. Adjudicate every material finding per Step 7's disposition rules.
5. **G1 — stop.** Put in front of the operator: the plan, the review, the adjudication, and the slice list Build will execute. Ask for scope-and-package approval. **Wait.** Do not open a Build unit on your own.

If Codex cannot reach the plan, apply Step 7's fallback — `/qc-pass`, recorded **`unassessed`, never passed** — and say so at G1 so the operator decides with the gap explicit.

#### Build units — one per slice, no gate

Execute exactly one slice per unit, under Step 6's implementation rules and inside the G1-approved scope. Write evidence, commit by pathspec, close the unit. **No review and no gate on Build** — a slice that cannot be verified becomes a finding at Prove, not a fourth stop. Work that is worth doing but outside the approved slice list is a `deferred` finding, never a quiet extra edit.

#### Prove unit — the post-implementation review, then G2

1. **Read the stream's Shape plan and review from disk** — glob `logs/loop/{STREAM}-*`. **Do not reconstruct either from memory or from the conversation**; if a phase's artifact is missing, that is a § Reconciliation stop, not something to re-derive.
2. **Judge the result against Shape's falsification criteria**, not against whether the work looks reasonable. Write evidence saying, per criterion, what was run and what was observed.
3. **Emit the evidence for Codex review**, transcribe verbatim to `logs/loop/{unit}.review-1.md`, commit by pathspec, adjudicate.
4. **G2 — stop.** Put in front of the operator: the evidence, the review, the adjudication, and any residual limitation. Ask for release approval. **Wait.**

This unit's `review-1` is a **different file** from Shape's, because they are different units. Never mutate Shape's review, and never file a post-implementation review into the Shape unit.

#### Land unit — G3

Take the lifecycle decision: adopt, hold or reject. **G3 — stop.** Put the full package and the real-use result in front of the operator and wait. For non-capability work this is the stream's last unit and closes the stream per Step 8. For a capability it also sets the record's `status:` — see Step 5b § Land.

#### Exactly three stops

G1, G2, G3 — no fourth. A passing Codex verdict produces **no** stop; it is reported in one line and the unit continues. Do not add a confirmation prompt between slices, before a commit, or after an adjudication. If a decision genuinely cannot be made inside the loop, it is a finding with disposition `operator`, which surfaces at the next gate rather than creating one.

**Never silently down-route to `reviewed`.** A challenged unit run as reviewed skips the pre-implementation review — the only gate that stops a bad change *before* it is made. De-escalation requires every trigger disproven with cited evidence, only at a phase boundary, and never after a stop has approved the heavier route.

### Step 5b — Capability unit

**Read `skills/capability-development/SKILL.md` now, and only now.** It owns the method — what a capability is, the five phases, the intervention ladder, trial design and its stop condition, owner and seam selection, slice standards, the evidence-to-claim rule, lifecycle-decision standards and data handling. This command owns none of that and restates none of it. Never read that skill for ordinary work.

Its § Route triggers are **additional** to the universal ones already applied at Step 5. Apply both; ambiguity still resolves upward. The route you end with governs the depth and stops exactly as for non-capability work — a challenged capability runs Step 5a's branch *as well as* this one.

#### Solo capability — no record

A solo capability unit **writes no record**, creates no `development/` directory, and takes no stop. The stream is that one unit. At most one `logs/decisions.md` entry. Do not open a record "for completeness" — a record that exists for a unit with nothing to correlate is a file that must then be maintained forever.

#### Reviewed or challenged capability — the record

**The record opens at Frame, not as a wrap-up artifact.** It is `projects/{p}/development/{slug}.md`, where `{p}` is the owning project chosen by the skill's owner-selection procedure and `{slug}` is derived from the operating outcome. Create it from `templates/capability-record.md`, filling the frontmatter — `capability:`, `name:`, `route:`, `phase:`, `status: in-development`, `owner_project:`, `stream:`, `active_unit:`, `opened:`, `updated:`. **`owner_project:` must equal the `{p}` segment of the record's own path**, and `capability:` must equal `{slug}`; `/develop-ai-resource` Step 1.0 verifies both on any handoff, and a record that disagrees with its own location is reported there as a malformed upstream handoff.

**Offer mission binding when the record opens** — one line, once. If the operator names a mission, note it in the record; if not, continue. Never write `logs/missions/{id}.md`: `/mission` is its sole writer.

**Correlation.** The record carries `stream:` (allocated once at the first unit, carried unchanged) and `active_unit:` (the open unit's id, or `none` between units). Append one row to `## Units` as each unit closes: unit · phase or slice · route · commits · outcome. The table is **append-only** — never rewrite a closed row.

**Between units `active_unit` reads `none`, and that is normal.** Contract § Reconciliation treats a completed unit whose record reads `none` as ordinary retained state: **no action, no report, no repoint.** Do not "repair" it.

**Status is a set, not a flag.** `in-development` · `continue-trial` · `revise` · `paused` are ACTIVE — all four resumable, per contract § Resume order. `paused` **requires** a `reopen_trigger:`; one without is malformed — report it, never auto-repair it. Only a TERMINAL status (`adopted` · `keep-local` · `closed` · `retired` · `rejected`) leaves the active set.

#### Cardinality

One unit per phase — Frame, Shape, Prove, Land — **except Build, which is one unit per slice.** Each Build unit implements exactly one slice to the skill's slice standard, appends its own `## Units` row, and closes. Do not batch two slices into one unit to save a commit: the per-slice boundary is what caps crash cost and keeps each brief describable in a 15–25 line block.

#### Land — the lifecycle decision

Take the decision to the skill's lifecycle standards and set the record's `status:` accordingly. On the challenged route this is G3 and stops for the operator; on reviewed it stops **only when the stream has a genuine adoption question** — a defect fix closes as `close` with no stop.

**The record's `status:` and the unit's `CLOSE` outcome are two different axes and neither substitutes for the other.** The unit closes `close` / `rejected-premise` / `route-unavailable` / `routed-out`; the capability's `status:` says what happened to the capability. A rejected capability keeps its record at `status: rejected` — **a record is never deleted to tidy up**, because that record is the evidence the question was asked and answered.

Write the closing commit SHAs into `## Pointers` before the stream closes — once `logs/loop/{STREAM}-*` is deleted, those SHAs are the only route back to the briefs, evidence and reviews.

## Step 6 — Execute

Implement the in-scope change. `docs/work-loop.md` § Execution boundary governs what this command implements versus routes out — read it rather than judging by feel.

**Route out, do not implement, in exactly two cases:**

- A **new** durable AI artifact must be authored, or an existing one materially expanded → hand to `/develop-ai-resource` with the brief attached, per its authority at `.claude/commands/develop-ai-resource.md:13-17`. Attach both handoff labels in the contract's shape (`docs/work-loop.md` § Block formats) — `**Capability:**` and `**Settled upstream:**`; either alone is a malformed handoff and that command reports it rather than repairing it. **Not a terminal exit when the artifact is one component of a live stream:** the operating outcome and the adoption decision stay here, so the stream stays open and this unit closes on its ordinary outcome — **not** `routed-out`, which is reserved for a whole need leaving (contract § Execution boundary). The **artifact** disposition returns through the capability record, not through this unit, which may be closed by then: adjudicate it, record it under the record's `## Pointers` and `## Verification evidence`, then resume the slice. An artifact judged unfit for purpose is a material scope change — record it as a decision and re-test, never retry quietly.
- No legitimate owner exists, or the work is a new enduring programme → hand to `/scope-project`. **Terminal exit:** close the stream as `routed-out`, record the routing note, and hold nothing open pending a project.

While implementing:

- Read before writing. Verify each target file is what the brief assumes it is — a path that resolves is not a file whose content matches the claim.
- Keep the change inside the brief's stated scope. Work that is obviously worth doing but outside scope becomes a finding with disposition `deferred`, not a quiet extra edit.
- Commit the unit's artifacts by pathspec at write time, before the next phase begins.

## Step 7 — Evidence, review, adjudication

**Write `logs/loop/{unit}.evidence.md`** in the contract's `EVIDENCE` shape. Append-only — never rewrite a prior entry. Every claim names what was run and what was observed. `LIMITATIONS:` is populated on every unit; if nothing limits the result, say what was *not* checked and why that is acceptable. A blank `LIMITATIONS` fails the unit.

**Solo route:** no review. Continue to Step 8.

**Reviewed route:** emit the evidence as a chat block for Codex, and tell the operator plainly what to do with it — paste it into the Codex `work-loop` task, then paste the returned `REVIEW` block back here. Transcribe the review verbatim to `logs/loop/{unit}.review-1.md`. Commit by pathspec.

**Challenged route:** the review is **per phase and already placed** — Step 5a runs it inside the Shape unit (object: the plan) and the Prove unit (object: the result), and Frame, Build and Land carry none. Do not add a review here on top of Step 5a's; that would produce a third review the route does not define. This step still owns the evidence write and the adjudication rules for whichever review Step 5a ran.

**If Codex cannot reach the object under review** — no repository access, or the object is outside `ai-resources` and unreadable — fall back to `/qc-pass` **and record the review as `unassessed`, not passed.** Never substitute a Claude subagent and describe it as independent: same model, same session lineage, no independence. The operator decides with the gap explicit.

**Adjudicate every material finding** with exactly one of the six dispositions in `docs/work-loop.md` § Block formats — `fixed` · `deferred` · `rejected` · `already-true` · `out-of-scope` · `operator` — each with its reason, and `rejected` with the evidence that disproves the finding. A finding is not dismissed by disagreeing with it.

`/resolve` and `/triage` do **not** fire. Adjudication is this step.

One correction pass, then the unit closes. A second review round is `review-2` and is justified only when the corrections changed something the first review's verdict rested on (`docs/work-loop.md` § The challenged route) — not on a general wish for more assurance.

## Step 8 — Close

**Mark the evidence `Status: complete` — on every outcome, including `close`.** This is not bookkeeping. § Resume order calls a unit *incomplete* when its evidence is absent or lacks that marker, so an unmarked evidence file leaves the unit outstanding forever: Tier 2 keeps re-offering the stream, and § Reconciliation re-points `active_unit` at a unit that already finished — the exact benign case Step 1 says must stay silent. The marker is what makes a finished unit finished.

**Capability units — clear the pointer in the same commit.** Append the unit's `## Units` row, then set `active_unit: none` and `updated:` to today in `projects/{p}/development/{slug}.md`. Step 5b's "between units `active_unit` reads `none`" is a state *this step produces*; nothing else writes it. Leave it pointing at a closed unit and Tier 1 matches forever, so the next bare `/work-loop` resumes a finished phase — and Step 2 forbids re-running one, so the loop jams with no route out.

**If the stream stops here without reaching Land** — abandoned, blocked, or deferred — do not leave the record in limbo. Set `status: paused` with a concrete `reopen_trigger:` (a date, a quarter or a named event) alongside `active_unit: none`. A record parked with no trigger never drains; `skills/capability-development/SKILL.md` names that as this method's most common failure.

Write the `CLOSE` block: outcome · commits · what closed · whether the stream closed with it. The outcome is exactly one of the four in `docs/work-loop.md` § Block formats — `close` · `rejected-premise` · `route-unavailable` · `routed-out`.

**Only `close` leaves its trace in the repository.** The other three changed nothing, so they all take § Closing without a change, which requires the durable one-entry pointer in `logs/decisions.md` alongside the evidence — without it, a unit that stopped is indistinguishable from one never attempted, and the same disproved brief returns a week later.

**The stream's last unit closes the stream in the same commit.** For solo, that is this single unit. On stream close, delete **every** `logs/loop/{STREAM}-*` file together, in the closing commit, by pathspec. Artifacts stay recoverable from git afterwards; the commit SHAs are the pointer. No stream is left in an "awaiting closure" state.

Announce in one line what closed and where the work landed. Then stop — this command does not chain into `/wrap-session` and does not push.

---

## What this command never does

- Never writes `logs/missions/{id}.md` — `/mission` is its sole writer.
- Never edits `/prime`, workspace `CLAUDE.md`, permissions, hooks or settings.
- Never runs `git add -A` or `git add .` — pathspec staging only.
- Never pushes. Never commits outside the unit's declared paths.
- Never holds methodology. Everything about *how* a capability phase is actually practised belongs to `skills/capability-development/SKILL.md`; this command cites that skill and never restates any part of it. The boundary is tested in both directions by A-CORE-7, which outranks the size target above.
- Never calls a same-model review independent.
