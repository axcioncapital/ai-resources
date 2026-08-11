# `/work-loop` — Operational Specification (Work Loop v1 — RETIRED)

> ## ⚠️ Retired legacy material — do not execute
>
> **Work Loop v1 is retired and none of the components this specification governs still exist as a
> live route.** `.claude/commands/work-loop.md` was deleted on 2026-08-06 (`0516bf6`);
> `.agents/skills/work-loop/SKILL.md` was retired on 2026-08-11 under Axcíon Harness v0.2 Phase 0,
> which required that Work Loop v2 be the only plausible semantic router.
>
> **The live Work Loop is v2:** `/work-loop-v2` (Claude side), `.agents/skills/work-loop-v2/SKILL.md`
> (Codex side), and `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (the executable
> core). This file is **not** a specification of v2 and must not be read as one — v2 has a different
> admission rule, a different unit cycle and a different artifact set.
>
> This document is kept as **historical evidence** of what v1 was intended to do. Its body is
> preserved unchanged below. Nothing in it is an instruction.

**Status:** Retired 2026-08-11 — historical record only, no live implementation
**Applied to (all retired):** `.claude/commands/work-loop.md` (Claude-side controller, deleted 2026-08-06), `.agents/skills/work-loop/SKILL.md` (Codex-side controller, retired 2026-08-11), `docs/work-loop.md` (shared contract — left in place as an inert v1 method document, ownership unresolved)
**Last material revision:** 2026-07-31 — first issue

This specification defines the intended operational behaviour of `/work-loop`. It is written for operator and internal use, not as a technical implementation specification. It describes what the resource is for, where its boundaries sit, what a correct run looks like, and what must be observable afterwards.

It is deliberately separate from `docs/work-loop.md`. That file is the **contract** — the vocabulary, formats and rules the two models execute against. This file is the **specification of intent** — what the resource is supposed to achieve and how a real run is judged. Where the two disagree on a mechanism, the contract wins and the disagreement is a defect to report against this file.

---

## 1. Resource Overview

### Purpose

`/work-loop` exists because substantive repository work in this workspace is done by a model that is also the party judging its own work. Left unstructured, that produces changes which look complete and reviewed but were never independently examined, never proved against a stated failure condition, and cannot be reconstructed once the conversation is gone. `/work-loop` exists to make a piece of work **provable**: what was asked, what was checked before acting, what was actually changed, who reviewed it, what the operator approved, and what state the work is in now. It carries a single bounded unit of work from a stated need to a recorded outcome, with the depth of scrutiny matched to how much the change could cost if it is wrong.

### Role in the System

`/work-loop` is the **execution controller for consequential repository work**. It owns the sequence — ingest, verify, classify, implement, evidence, review, adjudicate, close — and it owns the durable trace that sequence leaves behind. It is the only resource that opens, advances and closes work units and streams.

It does **not** own several adjacent things, and this boundary is load-bearing:

- **Method** belongs to skills. How a capability is actually practised — trial design, seam selection, slice standards, lifecycle judgement — is owned by `skills/capability-development/SKILL.md`. `/work-loop` cites it and never restates it.
- **Independent judgement** belongs to Codex. `/work-loop` never calls a Claude-side review independent.
- **New durable artifacts** belong to `/develop-ai-resource`. `/work-loop` implements changes to things that already exist; authoring a genuinely new resource is routed out.
- **New programmes** belong to `/scope-project`. Work with no legitimate owner leaves the loop terminally.
- **Session lifecycle** belongs to `/prime`, `/session-plan` and `/wrap-session`. `/work-loop` is not a session command: it does not orient the session, does not chain into wrap, and does not push.
- **Multi-session goals** belong to `/mission`. `/work-loop` may offer a binding but never writes a mission file.

### Intended Users

- **Operator (Patrik)** — invokes the command, and is the only party that can pass a gate. The operator is the decision authority the loop's stops exist to serve.
- **Claude Code** — runs the loop. It is the **single writer**: everything that lands in a repository lands through Claude, including material Codex authored.
- **Codex** — the independent reviewer, rooted in `ai-resources` as its control room. It authors briefs and reviews, and reads sibling repositories, but writes nothing outside `ai-resources`.
- **A later Claude session** — a first-class user. A large fraction of the loop's rules exist so that a session with no memory of the work can pick the stream up from disk alone.

---

## 2. When the Resource Should Be Used

### Trigger Conditions

`/work-loop` should be used when there is a **specific unit of repository work whose correctness matters enough to be proved**. In practice:

- The operator has a concrete need for a change to something that already exists — a defect fix, a rule change, a process correction, a documentation or standards change, a configuration change, a settled correction to an existing command, skill, script or hook.
- Codex has produced a `BRIEF` block that needs executing.
- A capability is being developed inside an existing project and needs its next phase run.
- A stream opened by an earlier session has an open unit or an unopened next phase, and work should continue. A bare `/work-loop` with no argument is the normal way to resume.
- The change is of a kind where a wrong answer would be expensive, shared, or hard to notice — anything touching a structural class, deleting or retiring an active resource, changing git/branch/worktree behaviour, or reaching across three or more repositories.

### When It Should Not Be Used

- **Authoring a new durable AI resource** — a new skill, command, agent or hook, or a material expansion of an existing one. That is `/develop-ai-resource`. If a live stream needs such an artifact as one component, the loop hands the artifact out and keeps the operating outcome.
- **A new enduring programme with no existing owner** — that is `/scope-project` → `/new-project`.
- **Investigation with no decided change** — diagnosis, triage and open-ended "what is wrong here" work belongs to `/resolve-repo-problem`, `/audit-repo`, `/repo-dd` or `/consult`. `/work-loop` runs a need someone has already framed; it is not a discovery instrument.
- **Trivial edits.** A one-line typo fix, a cosmetic tweak or a single-file wording change does not need a unit, a stream, an evidence file and a commit boundary. `/tweak` or a direct edit is correct. The loop's ceremony must be earned by consequence.
- **Session orientation, planning or wrap.** `/prime`, `/session-plan`, `/wrap-session` own those.
- **Anything requiring a mission file to be written.** `/mission` is the sole writer.

### Preconditions

- The invoking session is rooted at the repository the work targets. If the brief names `REPO: ai-resources`, the session must be running from `ai-resources`. This is checked before anything is written, and a mismatch is a hard stop.
- A need exists and is expressible — either as a pasted Codex `BRIEF`, as plain English from the operator, or as an open unit or stream already on disk.
- For a resumed unit, its artifacts are on disk. A phase whose artifact is missing is a reconciliation stop, not something to reconstruct.
- For challenged work, Codex is reachable, or the operator accepts that the review will be recorded `unassessed`.
- For a capability unit, the owning project exists. A capability lives inside a project that already exists; if there is no owner, the work is out of scope for this loop.

No precondition requires a clean working tree, a plan, or a prior session. Uncommitted changes in `logs/loop/` are reported, not blocked on.

---

## 3. Intended Outcome

### Primary Outcome

One bounded unit of work has reached a **recorded outcome** — exactly one of `close`, `rejected-premise`, `route-unavailable` or `routed-out` — and that outcome is supported by evidence stating what was run and what was observed. If the outcome is `close`, the change is in the repository, committed by explicit pathspec. If it is any of the other three, the object under work is untouched and the reason is durably recorded.

### Secondary Outcomes

- **The scrutiny matched the consequence.** The route was classified against stated triggers, the criterion that fired was named, and the review depth and number of operator stops followed from it.
- **Independent review actually happened where the route requires it**, against the real object — the plan for a pre-implementation review, the implemented result for a post-implementation one — and every material finding carries exactly one disposition with a reason.
- **The operator decided what only the operator can decide.** Gates were presented with a complete package and the loop waited.
- **The work is resumable from disk.** A later session with no memory can find the stream, read what each phase produced, and know what opens next.
- **The trace survives the artifacts.** When a stream closes, its temporary files are deleted in the closing commit and the commit SHAs — plus, for capabilities, the record's pointers — are the route back.

### Completion State

When `/work-loop` finishes correctly:

> The unit has reached exactly one recorded outcome, its evidence file exists and is marked `Status: complete`, every artifact it wrote is committed by explicit pathspec, any capability record's pointer reads `active_unit: none` with a `## Units` row appended, the stream is either still open at a stated next phase or closed with its artifacts deleted in the closing commit, and the operator has been told in one line what closed and where the work landed. If the outcome changed nothing in the repository, a four-line pointer exists in `logs/decisions.md` so the outcome remains findable after the artifacts are gone.

---

## 4. Expected Behaviour

When `/work-loop` is functioning correctly, Claude repairs inconsistent state before consulting anything, resumes existing work rather than restarting it, establishes an identity for the unit before producing anything under it, tests the brief's factual claims against the live repository before touching the object under work, sizes the scrutiny to the consequence, implements only what the brief scoped, returns evidence that another session could reproduce, adjudicates every finding rather than arguing with it, stops exactly where the operator's decision is required, and leaves the work in a state a fresh session can continue from disk alone.

### Critical Behaviours

1. **Reconciles before resuming.** Inconsistent state on disk is matched to a rule and repaired or stopped on, before any resume tier is consulted. Repairs are reported one line each. Benign retained state is left silent.
2. **Resumes rather than re-asks.** Open work is picked up at the phase it was in, its stream carried forward unchanged. A completed phase is never re-run, and the operator is never asked to re-explain a need already briefed.
3. **Verifies premises against the live repository before touching the object under work.** Each claim the brief asserts is re-derived — the script run, the lines opened, the count recomputed — and reported as confirmed or rejected with what was observed. A negative result carries a positive control. A rejected load-bearing premise stops the unit with zero edits made.
4. **Classifies the route explicitly and states the criterion that fired.** Ambiguity resolves upward. A structural class escalates the route rather than adding a gate. De-escalation happens only at a phase boundary with every trigger disproven.
5. **Keeps the change inside the brief's scope.** Work that is clearly worth doing but outside scope becomes a `deferred` finding, never a quiet extra edit. Staging is by explicit pathspec, never `git add -A`.
6. **Obtains real independent review where the route requires it, and never counterfeits it.** The reviewed object is the plan before implementation and the result after. If Codex cannot reach the object, the review is recorded `unassessed` — never `passed`, and never replaced by a Claude subagent described as independent.
7. **Adjudicates every material finding with one of six dispositions and a reason.** A finding is not dismissed by disagreeing with it; `rejected` requires the evidence that disproves it.
8. **Stops exactly at the gates the route defines — no more, no fewer.** On the challenged route that is G1, G2, G3. A passing verdict produces no stop. A decision the loop genuinely cannot take becomes an `operator` finding surfaced at the next gate, not a new stop.
9. **Leaves the work resumable and the outcome findable.** Evidence marked complete, pointer cleared, record row appended, stream closed or its next phase stated, and a `logs/decisions.md` entry when nothing changed.

---

## 5. Operator and Resource Responsibilities

### Resource May Decide

- Which reconciliation row the observed state matches, and how to repair it.
- Which unit or stream to resume, by the tiered resume order.
- Stream and unit identifiers, including collision resolution.
- Whether a premise is confirmed or rejected, and what evidence settles it.
- The route, from the stated triggers — including escalating when a trigger fires.
- How the in-scope change is implemented: file choices, sequencing, slice boundaries within an approved slice list.
- The disposition of every material review finding, and the reason for it.
- Whether a `review-2` is justified — i.e. whether corrections changed something the first verdict rested on.
- Whether work is in scope or becomes a `deferred` finding.
- Which of the four outcomes the unit closes on, and whether the stream closes with it.
- Whether the work must be routed out, and to which of the two receiving commands.

### Resource Must Not Decide

- **Whether to pass a gate.** G1 (scope and package), G2 (release) and G3 (lifecycle) are the operator's. The loop presents the package and waits. It never opens a Build unit on its own authority after G1 is armed.
- **Whether to proceed on a disproved premise.** A brief whose foundation is wrong needs re-briefing by its author, not salvage.
- **Whether a same-model review counts as independent.** It does not, ever.
- **Whether to run a challenged unit as reviewed.** Down-routing to skip the pre-implementation review is prohibited regardless of how confident the change looks.
- **Whether to push.** Push is gated and batched to session wrap, and `/work-loop` never pushes.
- **Whether a conflicting or ambiguous state can be merged.** A record pointing one way while an incomplete brief points another is a stop: report both paths, let the operator choose.
- **Whether to expand the approved scope.** Post-G1, the slice list is the contract.
- **Whether to delete an unreachable artifact.** An artifact with no brief may be the only copy of a real result; the operator decides whether to re-brief or record and remove.
- **Whether a capability is adopted, held or rejected.** That is the G3 decision.

---

## 6. Resource Relationships

| Relationship | Resource | Why the Relationship Matters |
|---|---|---|
| Upstream | Codex `work-loop` skill (`.agents/skills/work-loop/SKILL.md`) | Authors the `BRIEF` that opens most units and the `REVIEW` blocks the loop adjudicates. Its independence is the entire justification for the reviewed and challenged routes. |
| Upstream | Operator's plain-English need | The other way a unit opens. A Claude-authored brief has had no independent framing, and the loop must say so aloud — it is a recorded weakness of the unit. |
| Upstream | `docs/work-loop.md` (contract) | Read on every invocation. Owns vocabulary, route triggers, block formats, artifact rules, reconciliation and resume order. Where command and contract disagree, the contract wins. |
| Downstream | `/develop-ai-resource` | Receives artifact-authoring work with the brief attached and both handoff labels. Returns the artifact's disposition through the capability record, not through the (possibly closed) unit. |
| Downstream | `/scope-project` → `/new-project` | Receives work with no legitimate owner. Terminal — the stream closes `routed-out` and nothing is held open. |
| Downstream | A later `/work-loop` session | Resumes the stream from disk. Every retention, ordering and correlation rule exists for this consumer. |
| Uses | `skills/capability-development/SKILL.md` | Owns capability method entirely. Read only for capability units, never for ordinary work. |
| Uses | `docs/qc-independence.md` | Supplies the risk-aware review dimensions and the premise-verification precondition used when a change is high-consequence. |
| Uses | `docs/audit-discipline.md` | Sole owner of the structural change class list that fires the challenged route. Cited, never copied. |
| Uses | `templates/capability-record.md` | Owns the record's status vocabulary — which statuses are ACTIVE (resumable) and which are TERMINAL. |
| Uses | `logs/decisions.md` | The durable pointer for any outcome that changed nothing, and the only trace such an outcome leaves once artifacts are deleted. |
| Used by | Capability development streams | The loop is how each phase of a capability is actually executed and recorded. |
| Used by | `/mission` and `/drift-check` | A capability record may carry a mission binding; drift checks measure sessions against it. `/work-loop` offers the binding but never writes the mission file. |

### Key Dependencies

- **Codex reachability.** Reviewed and challenged routes depend on it. When it is unreachable the loop degrades honestly (`unassessed`) rather than silently.
- **Single-writer discipline.** Claude is the only writer into the target repository. Two concurrent sessions writing one stream breaks every guarantee below it.
- **Artifact root alignment.** cwd, `REPO` and the artifact root must be the same directory. A mismatch makes the stream unreachable from the only root entitled to resume it.
- **Brief-first ordering.** Resume and reconciliation both index on briefs. An artifact whose brief does not exist is invisible to both.
- **Stream-date stability and per-stream retention.** Together they are what lets a Prove unit read its Shape review on disk days later. Neither alone suffices.
- **The `Status: complete` marker.** It is the only thing that distinguishes a finished unit from an outstanding one.

### Downstream Impact

If `/work-loop` behaves incorrectly, the damage is characteristically **silent**:

- A skipped or counterfeited review means a change enters the repository carrying a false claim of independent scrutiny. This is the most serious failure, because everything downstream trusts that claim.
- A gate passed without a complete package means the operator approved something other than what they believed they were approving.
- A broken stream (re-dated, split across roots, missing a brief) means later phases cannot correlate — a Prove unit cannot judge against the plan it is supposed to judge against, and no error appears.
- A missing `Status: complete` marker or an uncleared pointer jams resume: the loop re-offers finished work forever, or refuses to advance.
- A missing `logs/decisions.md` pointer means a disproved premise returns as the same brief a week later.
- A mis-closed component handoff (`routed-out` where the stream should survive) deletes the artifacts of a capability still in development and strands the record the disposition must return to.

---

## 7. Outputs and Handoffs

### Expected Outputs

**In chat, per run:**
- Reconciliation lines — one per repair, or silence.
- A one-line resume or continuation announcement, or a new-unit announcement carrying unit, stream and phase.
- One `PREMISE:` line per premise, confirmed or rejected, with what was run and what was observed.
- A `ROUTE:` line naming the route and the criterion that fired; on challenged, the armed gates.
- The evidence (and on Shape, the plan) emitted as a block for the operator to paste to Codex, with plain instructions on what to do with it.
- The adjudication — one disposition per material finding, each with its reason.
- At each gate: the full package, and then a wait.
- A closing line: what closed and where the work landed.

**On disk, per unit:**
- `logs/loop/{unit}.brief.md` — immutable, written first.
- `logs/loop/{unit}.plan.md` — Shape units on the challenged route; immutable, revisions are `-v2`; must state what would falsify it.
- `logs/loop/{unit}.evidence.md` — append-only, `LIMITATIONS:` never blank, marked `Status: complete` at close on every outcome.
- `logs/loop/{unit}.review-{n}.md` — Codex reviews transcribed verbatim; immutable.
- Commits, by explicit pathspec, at write time.

**On disk, durable:**
- `projects/{p}/development/{slug}.md` — for reviewed and challenged capability units: opened at Frame, `## Units` appended per unit, `active_unit` cleared at close, `status:` set at Land, commit SHAs written to `## Pointers` before the stream closes.
- `logs/decisions.md` — one four-line entry for any outcome that changed nothing.
- The change itself, for `close`.

### Handoff Requirements

- **To a later `/work-loop` session:** an on-disk brief for every artifact; the stream id unchanged and carrying its original first-unit date; every `logs/loop/{STREAM}-*` file retained until the stream closes; the evidence marked complete; the pointer accurate; and, for a capability, `## Current phase and next action` stating what opens next.
- **To Codex:** a block carrying all six header fields (unit, stream, phase, repo, base SHA, next actor), and a clearly named object under review — the plan, or the implemented result plus its evidence.
- **To the operator at a gate:** the complete package the gate is defined to hold. G1: the plan, the review, the adjudication, the slice list. G2: the evidence, the review, the adjudication, any residual limitation. G3: all of that plus the real-use result.
- **To `/develop-ai-resource`:** the brief plus both labels — `**Capability:**` (bare slug or path, nothing else) and `**Settled upstream:**`. Either alone is malformed and is reported, not repaired.
- **To `/scope-project`:** the routing note, with the stream closed and nothing held open.

### What Should Not Be Produced

- A review labelled independent that a Claude subagent produced.
- A fourth operator stop, a confirmation prompt between slices, or a pause to announce a passing verdict.
- Edits to the object under work before premise verification passes.
- A rewritten, improved or merged brief; a mutated review; a Shape review reconstructed from memory inside a Prove unit.
- A capability record opened for a solo unit "for completeness".
- A mission file, a new log, or a new governance convention invented mid-run.
- Edits to `/prime`, workspace `CLAUDE.md`, permissions, hooks or settings.
- `git add -A` / `git add .`, commits outside the unit's declared paths, or any push.
- Methodology restated from `skills/capability-development/SKILL.md` into the command.
- A completion claim unsupported by evidence naming what was run and what was observed — or a blank `LIMITATIONS:`.

---

## 8. Boundaries and Non-Goals

### In Scope

Executing and proving one bounded unit of repository work: ingesting the brief, verifying its premises, classifying the route, implementing in-scope changes to things that already exist, producing reproducible evidence, obtaining and adjudicating independent review, presenting the route's gates, and closing the unit and its stream with a durable trace.

### Out of Scope

- Authoring new durable AI artifacts, or materially expanding existing ones (`/develop-ai-resource`).
- Establishing new projects or programmes (`/scope-project`, `/new-project`).
- Capability method (`skills/capability-development/SKILL.md`).
- Independent judgement of Claude's own work (Codex).
- Session lifecycle — orientation, planning, wrap, telemetry, push.
- Multi-session goal tracking (`/mission`, `/drift-check`).
- Open-ended diagnosis and triage (`/resolve-repo-problem`, the audit family).

### Non-Goals

- **Not optimising for speed or minimal ceremony.** The loop is deliberately heavier than a direct edit; the answer for light work is not to run it.
- **Not maximising review coverage.** Exactly one review round per unit, one bounded correction pass. More assurance is not a reason for another round.
- **Not eliminating operator decisions.** The gates exist; the goal is to put good packages in front of them, not to reduce their number.
- **Not a general project-management or backlog system.** It runs one unit at a time.

---

## 9. Known Failure Modes

The failures below were observed in real streams during July 2026 and are documented in `reports/work-loop-problem-definition-2026-07-31.md` and `logs/decisions.md`. They share one cause: the loop tracks work by human-readable names and prose instructions where it needs enforceable identity and transition checks. All of them can occur in a run that looks entirely successful.

**Failure mode: an unreviewed final plan reaches G1.**
*Why it matters:* the pre-implementation review is the only control that can stop a bad change before it is made. If the plan is revised after the review, G1 approves something Codex never saw, and the route's central guarantee is void while appearing satisfied.
*Observable signal:* a plan version at G1 (`-v2`, `-v3`) higher than the version the transcribed review names; a review whose findings do not correspond to the plan text being approved; a revision commit timestamped after the review transcription.

**Failure mode: the released result is not the reviewed result.**
*Why it matters:* corrections made after the post-implementation review move the candidate. G2 then approves a commit no independent party inspected.
*Observable signal:* commits touching the object under work between the review transcription and the G2 presentation; a G2 package that does not name the exact final commit.

**Failure mode: Prove repairs what it is supposed to judge.**
*Why it matters:* the reviewer and the repairer become the same working session, the candidate moves during review, and the corrections have no contemporary brief. The result may be good, but nothing can any longer claim it was independently reviewed.
*Observable signal:* object-file edits inside a Prove unit; corrections with no brief of their own; evidence written and adjudicated in the same pass that changed the object.

**Failure mode: required records are missing and the loop advances anyway.**
*Why it matters:* resume and reconciliation index on briefs and the `Status: complete` marker. Missing briefs, missing markers or an un-transcribed review make the stream partially invisible and unresumable, and later reconstruction repairs reachability only — it cannot make brief-first planning or independent review happen retroactively.
*Observable signal:* evidence files with no matching brief; Build units without `Status: complete`; a review referenced in chat but absent from `logs/loop/`; a brief written after the work it describes.

**Failure mode: two sessions write the same stream.**
*Why it matters:* single-writer is the assumption under every ordering and atomicity rule. Two writers mean one session decides on repository state that changed underneath it.
*Observable signal:* interleaved commits from separate sessions on one stream; a stream advancing while another session believes it is holding it; a collision noticed only because a session happened to stop.

**Failure mode: verification passes while the underlying condition is unmet.**
*Why it matters:* a search that looks for one textual shape of a concept misses the same concept expressed as a field name, a step name, a prose instruction, a verdict token, a filename or a generated example. The evidence reads clean and the cleanup is not done. In one stream, four Build units reported clear sweeps and Prove later found 24 surviving references.
*Observable signal:* evidence citing a grep with no stated working directory, scope, exclusions or positive control; a later phase finding what an earlier phase declared clear; negative results with no control demonstrating the check can fire.

**Failure mode: the correction budget has no terminal outcome.**
*Why it matters:* "at most one review round" and "a justified `review-2`" coexist without stating what happens if `review-2` still finds a material problem. Without a stop condition the loop can drift into repeated review-and-correct cycles — exactly what the bounded model exists to prevent.
*Observable signal:* a third review round; corrections continuing past `review-2`; a unit that will not close.

**Failure mode: scope creep inside an approved slice list.**
*Why it matters:* G1 approved a specific set of slices. Additional "obviously worth doing" edits mean the released change is not the approved change.
*Observable signal:* commits in Build units touching files outside the G1 slice list; no `deferred` findings recorded despite adjacent work clearly having been noticed.

**Failure mode: silent down-routing, or ceremony without consequence.**
*Why it matters:* running a challenged unit as reviewed skips the only pre-implementation control. The inverse — running trivial work through the full loop — trains the operator to treat gates as noise.
*Observable signal:* a challenged trigger present in the change but a `ROUTE: reviewed` line; a route line with no criterion stated; a solo-sized change carrying three gates.

**Failure mode: the trace does not survive the artifacts.**
*Why it matters:* stream close deletes `logs/loop/{STREAM}-*`. Without the commit SHAs in the record's `## Pointers`, or a `logs/decisions.md` entry for an outcome that changed nothing, the work becomes indistinguishable from work never attempted.
*Observable signal:* a closed stream with no SHAs recorded; a `rejected-premise` or `routed-out` close with no decisions entry; a brief re-appearing weeks later for a need already disproved.

---

## 10. Evaluation Criteria

After a real run, evaluate against this section. The objective is not process uniformity. Wording, sequence and internal reasoning will vary between runs and that variation is not a defect. The objective is whether the run achieved its intended outcome while respecting the behavioural and decision boundaries above.

### Evaluation Questions

1. **Appropriate situation.** Was this work that belonged in the loop — a bounded change to something that already exists, consequential enough to justify the ceremony — rather than a trivial edit, an investigation, a new artifact or a new programme?
2. **Understood outcome.** Did the run act on the need the brief actually stated, at the scope it stated? Was a Claude-authored brief declared as such?
3. **Critical behaviours.** Were the nine behaviours in §4 observable? In particular: reconciliation before resume; premises re-derived against live files with positive controls on negatives; the route stated with its criterion; scope held; a real independent review of the right object; every material finding adjudicated with a reason; exactly the route's gates.
4. **Decision boundaries.** Did the loop decide only what §5 permits, and stop for everything §5 reserves? Was any gate self-passed? Was any same-model review presented as independent?
5. **Expected outputs.** Do the artifacts in §7 exist, in the right places, with the right mutability respected — brief first, evidence marked complete, reviews verbatim and immutable, commits by pathspec, pointer cleared, record row appended?
6. **Handoffs and dependencies.** Could a fresh session resume this stream from disk alone? Did Codex receive a complete block naming the right object? If work was routed out, did it carry both labels, and did the stream survive or close correctly for the case?
7. **Known failure modes.** Did any §9 failure occur? Check specifically for the identity failures — is the approved plan the reviewed plan, and is the released commit the reviewed commit?
8. **Specification feedback.** Did anything happen that this specification did not anticipate, or that suggests a boundary here is wrong?

### Overall Run Assessment

**Met specification** — the unit reached a recorded outcome supported by evidence, the route was correctly classified and honoured, review and gates happened where required, the trace is complete and resumable, and no material behavioural failure occurred.

**Partially met specification** — the run was useful and its outcome sound, but one or more meaningful deviations occurred: a missing marker or record repaired afterwards, thin evidence, an unstated route criterion, a scope excursion recorded late, or a handoff missing a required element.

**Did not meet specification** — the run failed its role or crossed an important boundary. Any of the following alone is sufficient: a gate self-passed; a review skipped, counterfeited, or performed on a version other than the one approved or released; edits to the object under work before premises passed; a challenged unit run as reviewed; a stream left unresumable; a completion claim without evidence.

### Evidence

Record the specific observations supporting the assessment — commit SHAs, artifact paths, the route line, the premise lines, the gate packages, and the closing line. Prefer what is on disk and in git over what was said in chat; the loop's own standard is that a claim names what was run and what was observed, and this assessment is held to the same bar.

Do not fail a run because its phrasing, ordering or reasoning differed from a previous run. Judge observable operational behaviour and outcomes.

---

## 11. Specification Notes

### Known Limitations

These are accepted properties of the current design and should not be logged as defects:

- **Enforcement is largely by prose.** Most rules are instructions the controller is expected to follow, not checks it performs before advancing. The identity failures in §9 follow directly from this. A remediation specification exists (`reports/work-loop-remediation-report-2026-07-30.md`, `reports/work-loop-problem-definition-2026-07-31.md`) and is not yet implemented. Until it is, runs must be evaluated against §9 with particular care, and the current loop should not control a new substantive challenged implementation — least of all its own repair.
- **No ownership mechanism.** Single-writer is a contract statement, not something enforced. Concurrent sessions on one stream are possible.
- **`paused` records are not date-gated.** A record parked with a future `reopen_trigger:` still re-offers itself at every bare invocation. Accepted: only one of the three trigger shapes is machine-comparable. The trigger to revisit is a park that has become noise.
- **A reviewed capability with no mission binding is invisible at session start** unless the operator runs `/work-loop`. Accepted; the trigger to reconsider is this biting twice in real use.
- **A Claude-authored brief has had no independent framing.** The loop declares it, but the weakness remains real for that unit.
- **`unassessed` is a real state.** When Codex cannot reach the object, the review does not happen. This is honest degradation, not a passed review, and the operator carries the resulting decision.

### Open Questions

- **What terminates the correction budget?** If `review-2` still finds a material problem, the intended behaviour is to stop and reframe the stream rather than open `review-3` — but the authorities do not yet state this unambiguously. Until they do, treat a third round as a specification violation and reframe.
- **How is "the exact object reviewed" to be identified?** Path plus version suffix has proved insufficient. Whether the answer is a content hash, a commit SHA, or both, and where it is recorded, is unresolved.
- **Should Codex inspect the working tree directly** rather than reviewing pasted blocks? Direct inspection would close the identity gap at G2, but changes the control-room model in which Codex reads from `ai-resources` and writes nothing outside it.
- **Should a substantive unit run in a dedicated task worktree** from a recorded base, with an explicit current writer? This is the proposed answer to single-writer enforcement; it is not yet part of the design.
- **Where is the boundary between "settled correction to an existing resource" (implement) and "material expansion" (route out)?** It is currently a judgement call, and the two cases sit adjacent often enough to be worth watching.

### Last Material Revision

**2026-07-31** — first issue. Written against the command, contract and Codex-side skill as they stand at commit `59330e0`, incorporating the failure modes observed in the July 2026 streams and recorded in `reports/work-loop-problem-definition-2026-07-31.md`.

Implementation history stays in git and in `logs/decisions.md`; it is not duplicated here.
