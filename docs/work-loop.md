# The work loop — contract

Reference contract for `/work-loop`. The command orchestrates and implements; this file defines the vocabulary, the artifacts and the rules both models rely on. Read by `/work-loop` on every invocation and by the Codex `work-loop` controller skill.

`ai-resources` is the **required Codex control room.** Codex is opened rooted there, reads sibling repositories from that root, and writes only within `ai-resources`. Nothing in this design depends on Codex write access to a sibling. Briefs and reviews are printed in chat and transcribed by Claude into the target repository, where **Claude is the single writer.**

---

## Boundary sentences

> **Outcome versus artifact.** `/work-loop` with `capability-development` owns the operating outcome. `/develop-ai-resource` owns the artifact. The skill is not the capability; it is one implementation component.

> **Capability versus project.** A capability lives inside a project that already exists. A project is a new domain with its own deliverables.

> **Goal versus development record.** `logs/missions/{id}.md` answers *what multi-session goal is this serving, and is it drifting?* `development/{slug}.md` answers *what is this capability, where does it stand, what happens next?*

---

## The eight steps

Every invocation runs 1–2. Steps 3–8 run per unit.

| # | Step | Output |
|---|---|---|
| 1 | **Reconcile** — repair inconsistent state before anything is consulted (§ Reconciliation) | One line per repair, or silence |
| 2 | **Resume or ingest** — tiered resume (§ Resume order); with no open work, ingest a brief | The unit being worked |
| 3 | **Open the unit** — allocate or carry the stream; write the brief, then the pointer, then commit both | `STREAM` + `UNIT` |
| 4 | **Verify premises** — run what the brief cites; open the lines it names; re-derive its counts | `PREMISE: confirmed` / `rejected` with evidence |
| 5 | **Classify route** — solo / reviewed / challenged (§ Route triggers) | Route + the criterion that fired |
| 6 | **Execute the phase** — implement in-scope changes, or route out (§ Execution boundary) | Working-tree changes |
| 7 | **Return evidence, review, adjudicate** — evidence to Codex; every material finding gets one disposition | Evidence + review + dispositions |
| 8 | **Close** — close the unit; the stream's last unit closes the stream in the same commit | Closure + artifact deletion at stream close |

**The unit opens before its premises are verified, and that order is deliberate.** A rejected premise is a *result* — it says a need was brought and its foundation was disproved — and a result needs an identity to be recorded under. Verifying first would produce that result before any stream, unit id or brief existed, so it could only be written to an unbound path, and § Resume order (which indexes on briefs) and § Reconciliation (whose every row keys on a brief or a pointer) would both be blind to it. Opening first costs one commit on a unit that may stop immediately; it buys a rejection that is addressed, indexed, closed and recoverable like every other outcome.

**A rejected premise stops at step 4** — see § Closing without a change. Report the rejection with the evidence that disproves it, make **zero edits to the object under work**, and close the unit. Do not repair the brief's reasoning on its behalf.

**What step 4 gates is the object under work, not the loop's own bookkeeping.** The unit's artifacts in `logs/loop/` are written before the gate; nothing else is. The invariant is checkable rather than a matter of judgement: every commit made before premise verification passes stages `logs/loop/{unit}.*` paths and nothing else.

---

## Execution boundary

`/work-loop` **implements** ordinary, in-scope edits to things that already exist, and capability slices: defect fixes, documentation, standards, decision rules, processes, data structures, configuration, project-local artifacts, and settled corrections to existing commands, skills, scripts and hooks.

It **routes out**, and does not implement, in exactly two cases:

- **`/develop-ai-resource`** — a **new** durable AI artifact must be authored, or an existing one materially expanded. This matches that command's own authority text at `.claude/commands/develop-ai-resource.md:13-17`.
- **`/scope-project` → `/new-project`** — owner selection finds no legitimate owner, or the work is a new enduring programme. Terminal exit: the stream closes, any record closes `status: rejected` with the routing note, and **nothing is held open pending a project.**

`/work-loop` never writes mission files. `/mission` is the sole writer of `logs/missions/{id}.md`.

---

## Route triggers

Universal — every unit of any type. Any one fires; ambiguity resolves **upward**.

- **Challenged** — touches a `/risk-check` structural change class **as listed at `docs/audit-discipline.md:60-65`** (that file is the sole owner of the list; it is cited here, never copied); or deletes or retires an active resource; or changes git, branch or worktree behaviour; or touches three or more repositories; or has already failed to converge twice.
- **Reviewed** — changes a shared `ai-resources` resource symlinked into projects; or produces an artifact that leaves the repository; or changes five or more files; or produces analytical output the operator cannot judge unaided.
- **Solo** — residual: one repository, revert-reversible, four files or fewer, no shared blast radius, no external delivery.

Capability units carry **additional** triggers owned by `skills/capability-development/SKILL.md` § Route triggers. That file cites this section and does not restate it.

`/risk-check` fires at its own two gates on its own schedule (`docs/audit-discipline.md:73-81`), unchanged. The route never absorbs, replaces or reschedules it.

**Escalation** is additive: nothing already produced is discarded, and escalation into challenged arms G1 immediately. **De-escalation** requires every trigger disproven with cited evidence, only at a phase boundary, and never after a stop has approved the heavier route.

### Route → depth → stops

| Route | Independent review | Operator stops |
|---|---|---|
| **solo** | None. A mandatory risk class escalates the route rather than bolting a gate onto it. | 0 |
| **reviewed** | One Codex review of the result. `/qc-pass` only as fallback, when Codex cannot reach the object. | 1 — the lifecycle decision, and only when the stream has a genuine adoption question. A defect fix closes as `close` with no stop. |
| **challenged** | Codex before implementation and after, **in separate units**. | 3 — G1 scope and package · G2 release · G3 lifecycle |

---

## Streams, units and phases

A **stream** spans many units. A **unit** is one bounded piece of work with one brief, one evidence package and at most one review round.

```
STREAM = {date-of-first-unit}-{slug}[-{n}]
UNIT   = {STREAM}-{phase}
```

The stream is allocated once, at its first unit, and carried forward unchanged — a Prove unit keeps the stream's original date even when run days later.

**Collision handling.** Before allocating, check **both** surfaces for the candidate id: any `logs/loop/{candidate}-*` artifact, and any `development/*.md` carrying `stream: {candidate}`. On a hit append `-2`, then `-3`, until clear. Unit ids derive from the resolved stream and cannot collide independently. Allocation is single-writer, so an existence check suffices — no allocator, no shared counter.

**Cardinality.** Solo is exactly **one** unit; the stream is that unit, with no record and no `active_unit`. Reviewed and challenged run **one unit per phase**, except Build, which is **one unit per slice**. One unit per phase is what makes distinct pre- and post-implementation reviews structural rather than procedural: they belong to different units, so they are different files by construction and neither is ever mutated.

| Phase | Question it closes |
|---|---|
| **Frame** | What is the need, who owns it, and is it in scope at all? |
| **Shape** | What exactly will be done, and what would falsify it? |
| **Build** | One slice implemented — repeated per slice |
| **Prove** | Did it work, judged against what Shape said would falsify it? |
| **Land** | Adopt, hold or reject — the lifecycle decision |

**Correlation.** Siblings are found by globbing `logs/loop/{STREAM}-*`. Challenged **non-capability** work has no capability record and correlates purely by stream — no extra file is required. Capability units use the same stream key and *additionally* get the `## Units` table in their record.

---

## Artifacts

Durable state: `projects/{p}/development/{slug}.md` (written by `/work-loop`), `logs/decisions.md` (append-only, any session), `logs/missions/{id}.md` (`/mission` only), and git history.

Temporary state lives entirely in `logs/loop/`, single-writer:

| Artifact | Authored by | Written by | Mutability |
|---|---|---|---|
| `{unit}.brief.md` | Codex | Claude transcribes once — or Codex directly when rooted in the target repo | **Immutable** |
| `{unit}.plan.md` | Claude | Claude | **Immutable** — a revision is `-v2` |
| `{unit}.evidence.md` | Claude | Claude | **Append-only, not immutable** |
| `{unit}.review-{n}.md` | Codex | Claude transcribes | **Immutable** |

The `-{n}` ordinal starts at 1. A closure review after corrections — justified only on the Independent Review SOP's five triggers — is `-2`, never an edit to `-1`. Pre- and post-implementation reviews are never both in one unit.

**Commit boundary.** Every temporary artifact is committed by explicit pathspec **at write time**, before the next phase begins.

**Retention is per stream, not per unit.** A Prove unit must be able to read its stream's Shape review **on disk**, and reconciliation must be able to see completed units. The **stream-closing commit deletes every `logs/loop/{STREAM}-*` file together.** The final unit of a stream closes the stream in that same commit — no stream sits in an "awaiting closure" state. The record's `## Pointers` carries the commit SHAs, so every deleted artifact stays recoverable from git; there is no permanent handoff archive.

**Never in the repository:** trial material containing real buyer, CRM, email or relationship data. Session scratchpad only.

**Ordering rule (crash atomicity).** Git commits are atomic; the write sequence leading to one is not. Within a unit-open operation write `logs/loop/{unit}.brief.md` **first**, then set `active_unit` in the record, then commit both by pathspec. The brief is the fact; `active_unit` is only a pointer. A dangling pointer and an orphan brief are both detectable and repairable; a pointer written with no brief behind it is the harder case, so it is written second.

**Artifact root — one rule, no judgement.** A unit's artifacts live in `logs/loop/` **of the repository its block names in `REPO`**, and `/work-loop` is invoked **from that repository's root**. So the invoking session's cwd, the artifact root and `REPO` are always the same directory, and every glob in § Reconciliation and § Resume order — all of which are repository-relative — keeps working with no extra machinery. A session rooted elsewhere does not write the unit to its own root and hope: it stops and says which root to re-invoke from.

Observed failure this makes impossible (2026-07-28, `logs/decisions.md`): a unit declaring `REPO: ai-resources` had its brief and evidence committed at the *workspace* root, because the command globbed the invoking session's cwd. Nothing was wrong on disk and nothing warned, but a `/work-loop` rooted in `ai-resources` could not see the open unit at all — the stream was unreachable from the only root entitled to resume it. *Rejected alternative:* let artifacts follow the invoking root and treat `REPO` as informational. Simpler to state, but it lets one stream split across two roots with no signal, and a stream whose Shape and Prove units sit in different repositories cannot correlate — a silent wrong answer where this rule gives a loud stop.

**The brief precedes every other artifact of its unit, without exception.** It is the index the whole resume and reconciliation design keys on: § Resume order globs briefs, and every row of § Reconciliation matches on a brief or on a pointer to one. An evidence, plan or review file whose brief does not exist is therefore unreachable by both — not merely untidy, but invisible. This is why the unit opens at step 3, before premise verification: it guarantees that any artifact a unit produces, including the evidence for its own rejection, already has a brief in front of it.

---

## Block formats

Six blocks carry work between the models. Every block header carries all six fields:

```
UNIT: {unit-id}      STREAM: {stream-id}    PHASE: {phase}
REPO: {target repo}  BASE: {git SHA}        NEXT: {who acts next}
```

| Block | Direction | Body |
|---|---|---|
| **BRIEF** | Codex → Claude | Need · scope · premises to verify · what would falsify success. 15–25 lines |
| **PLAN** | Claude, challenged only | What will be done, in order · what it touches · what would falsify it |
| **EVIDENCE** | Claude → Codex | Per claim: what was run, what was observed. `LIMITATIONS:` populated, never blank |
| **REVIEW** | Codex → Claude | Findings, **premise dimension first**. Each finding states the object it inspected |
| **ADJUDICATION** | Claude | One disposition per material finding (below), each with its reason |
| **CLOSE** | Claude | Outcome · commits · what closed · whether the stream closed with it |

**Four outcomes**, exactly one per `CLOSE` block. The first changed the object under work; the other three did not, and all three take § Closing without a change:

`close` — the work landed · `rejected-premise` — a load-bearing premise was disproved at step 4 · `route-unavailable` — the classified route is not built in this revision · `routed-out` — ownership left the loop terminally under § Execution boundary.

This is the unit's outcome axis. A capability's `status:` (adopt / hold / reject at Land) is a separate axis on the record and never substitutes for one of these.

**Six dispositions**, one per material finding: `fixed` · `deferred` (with the trigger that reopens it) · `rejected` (with the evidence that disproves it) · `already-true` (with the citation) · `out-of-scope` (with the owner) · `operator` (needs a decision this loop cannot make). `/resolve` and `/triage` do not fire — adjudication is the loop's own step 7.

**Evidence standard.** Every claim names what was run and what was observed. A bare assertion is not evidence, and an empty result is not evidence until a positive control has shown the check can detect the thing it is looking for.

---

## Closing without a change

Three outcomes close a unit that never altered the object under work: `rejected-premise`, `route-unavailable` and `routed-out`. All three take the **same** path, and it is the ordinary one — there is no separate lifecycle for a unit that stops early.

1. **Write `logs/loop/{unit}.evidence.md`** carrying the outcome and the proof of it: for `rejected-premise`, the premise and what disproved it; for `route-unavailable`, the trigger that fired and the revision that lands the route; for `routed-out`, the owner and the brief handed over. `LIMITATIONS:` is populated as on any unit. Mark it `Status: complete` — the unit is finished, not outstanding, and § Resume order must not offer it again.
2. **Write the `CLOSE` block** with that outcome, then close the stream. A unit that stops before implementation is always its stream's last unit, so the stream closes in the same commit and its artifacts are deleted there, exactly as § Artifacts prescribes.
3. **Append the durable pointer** (below) in that same commit.

**The durable pointer is not optional, and it is what keeps the outcome findable.** A unit that closed as `close` leaves its change in the repository; the change *is* the durable trace. These three leave nothing — no change, no record for non-capability work, and artifacts deleted at stream close. Without a pointer their only trace is a deleted file in a commit no one holds the SHA for, which is indistinguishable from the work never having been attempted. That is how a disproved premise comes back as the same brief a week later.

So the closing commit appends one entry to `logs/decisions.md`:

```
## {date} — /work-loop {unit}: {outcome}

**Need.** {the brief's need, one line}
**Outcome.** `{outcome}` — {the premise and what disproved it · the unbuilt route · the owner}
**Artifacts.** `logs/loop/{unit}.*`, deleted at stream close; recoverable at {SHA}.
```

Four lines. It is a decision record in the ordinary sense — *this was not done, and here is the evidence for why* — so it needs no new log and no new convention.

**Never delete the evidence without writing the pointer**, and never write the pointer without the SHA. Either half alone re-creates the gap this section closes.

---

## Reconciliation

Runs at **every** invocation, before any resume tier is consulted. Deterministic — no guessing. Every repair reported in one line. Git is the tiebreak: the last commit is the last known-consistent state, and `git status` names what is uncommitted.

| Observed | Action |
|---|---|
| `active_unit: X`; no `X.brief.md` on disk **and** none in git | The unit never opened. Reset to `none`, report, offer a fresh open. |
| `active_unit: X`; `X.brief.md` absent from the tree but **present in git history** | Uncommitted deletion or lost working tree. Restore from git, report the SHA, continue. |
| `X.brief.md` names a capability whose record reads `active_unit: none`, **and `X.evidence.md` is absent or lacks `Status: complete`** | The record write was lost. Show both paths, re-point `active_unit` to X, report. |
| Same, but **`X.evidence.md` carries `Status: complete`** | **Normal — no action, no report, no repoint.** A completed unit whose artifacts are retained until the stream closes is not outstanding work. |
| `active_unit: Y` while an **incomplete** `X.brief.md` for the same stream is open | **Stop. Report both paths. The operator decides.** Never merge, never guess. |
| Any `logs/loop/{unit}.{evidence,plan,review-*}.md` whose `{unit}.brief.md` is absent **from the tree and from git history** | The ordering rule was violated — an artifact exists that no tier can reach. **Report the path and stop.** Do not resume it, do not synthesise the missing brief, and **never delete it**: it may be the only copy of a real result, and a rejected premise is exactly the result that lands here. The operator decides whether to re-brief or to record and remove. |
| Uncommitted changes in `logs/loop/` at invocation | Report before resuming. Do not commit silently. |

## Resume order

**Tier 1** — capability records with `status: in-development` and `active_unit != none`.
**Tier 2** — streams with an incomplete unit. Glob `logs/loop/*.brief.md`; a unit is **incomplete** when its evidence is absent or lacks `Status: complete`. Group by stream. Exclude any stream whose incomplete unit is already named by a Tier-1 record. **Completed units are ignored here.**

Tier 2 indexes on briefs, so it cannot see an artifact whose brief is missing. That is deliberate and safe **only because § Artifacts guarantees the brief is written first and § Reconciliation stops on any artifact that lacks one** — the blind spot is closed upstream, before this tier is consulted. Do not widen the glob to compensate; an evidence file with no brief is a reconciliation stop, not a resume candidate.
**Tier 3** — capabilities with `status: in-development` and `active_unit: none`; the record's `## Current phase and next action` states what opens next.

Exactly one candidate in the highest non-empty tier → resume it, announcing in one line. More than one → list them once and ask. All tiers empty → treat any argument as a new need; with no argument, ask once. A lower tier is consulted only when every higher tier is empty. **No path sorts by timestamp.**

**Named residual:** a reviewed capability with no mission binding is invisible at session start unless the operator runs `/work-loop`. Accepted. Mission binding is offered when a record opens. If this bites twice in real use, that is the trigger to reconsider a `/prime` step as its own separable change.
