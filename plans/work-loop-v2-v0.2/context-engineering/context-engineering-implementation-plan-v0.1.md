# Implementation plan: Context Engineering for the Work Loop

**Version:** v0.1 · **Stage:** draft implementation plan — awaiting operator approval · **Status:** not
authorisation to implement.

> **Authority notice.** This plan sequences work; it creates no permission to do it. It is subordinate to
> [`../context-engineering-spec-v0.1.md`](../context-engineering-spec-v0.1.md), which is itself still a
> draft specification awaiting operator approval and states that *"nothing here authorises
> implementation."* Two approvals are therefore outstanding, and the specification's is the first
> (§ Phase 0). Where this plan and the specification disagree, the specification wins and the
> disagreement is a defect in this plan.
>
> **Approval binds to content, not to this filename.** If the operator approves this plan, the approval
> records the exact Git commit approved. A later material edit — to the objective, scope, exclusions,
> settled constraints, phase sequence, or exit conditions — returns this document to draft and needs
> explicit reapproval. This is the specification's own rule (§5.7, CE-4 failing case C) applied to the
> plan that implements it.
>
> **Operator approval of this plan — recorded here, or not at all.** Phase 0 requires both approvals and
> this is the slot for the second one. It stays empty until the operator fills it, and while it is empty
> this plan is a proposal.
>
> ```
> Plan approval:   (none — draft)
> Approved commit: (none)
> Approved on:     (none)
> ```
>
> **This is not "the one canonical project plan" of spec §5.7.** That term names the durable plan a
> *project* carries so Context Engineering can prepare briefs against it. This is a build plan for the
> capability itself. A later reader must not treat this file as the artifact CE-4 and CE-6 reason about.

**Written by:** Claude, 2026-08-02, under Work Loop v2 task `context-engineering-implementation-plan`,
from a Codex brief. Codex assesses it; the operator decides whether it becomes the plan of record.

**What it optimises for:** one thing —

> Reach a *real trial* of Context Engineering quickly enough that the trial, not the design, decides
> what the capability finally is.

---

## 1. What this document is

A self-contained plan for building Context Engineering as a core Work Loop function. A fresh session can
execute from it without this conversation, without design history, and without reading the whole
specification first — though every implementation session opens the specification for the behaviours it
is proving.

It covers: the situation, the constraints already settled, the implementation surface as *verified on
2026-08-02*, an observable destination with falsification criteria, the operator decisions this plan
deliberately does not take, six evidence-gated phases broken into named sessions, a CE-1…CE-17 coverage
map, a boundary audit against the specification's prohibitions, the standing rules of the build, and the
accepted limitations.

**There is no companion playbook.** The session detail is folded in here (§7). A second document
describing the same work is the FP-4 staleness failure the specification itself cites.

---

## 2. The situation in brief

Context preparation already happens — Codex did it in the Work Loop v2 pilot, and it was the one pilot
condition that scored `yes` in all three units. What does not exist is a **contract**: a stated boundary,
a defined output, and behaviours that can be shown to fail. Informal competence cannot be verified, cannot
survive a fresh thread, and cannot be improved except by anecdote.

The specification converts that duty into seventeen observable behaviours in six families. It stops
deliberately at *definition*: **"proof does not occur in this specification session."** This plan is how
the proof happens.

Two facts shape the build.

**First — the primary win is not delivered by Context Engineering alone.** The one-touch handoff (CE-17)
has three clauses, and clause 3 — the brief reaching Claude with no operator ferrying — is *transport*,
which the specification puts outside its own boundary. So there are two proofs, and only the integrated
one supports an adoption claim. A previous session (2026-08-02, S4-510) was structured as "Claude
implements and proves it" and was withdrawn mid-session for exactly this reason: Codex runs in the ChatGPT
app and is operator-driven, so Claude working alone could only ever produce half the evidence
(`../../../logs/decisions.md`, 2026-08-02).

**Second — the failure mode this capability is most likely to reproduce is the one that killed Work Loop
v1:** answering every discovered weakness with new process machinery. The specification forbids that
directly (§9: *"no new governance machinery is authorised by v0.1"*), and §9's escape hatch — behaviour
shrinks if a real trial says the process costs more than the failure it prevents — points **down**, never
up. This plan's standing rules (§9) exist to keep it pointing down.

---

## 3. Settled constraints

Not decisions this plan takes. Each is already settled elsewhere and is recorded here so an executing
session does not reopen it.

| # | Constraint | Settled by |
|---|---|---|
| C-1 | Seventeen behaviours, six families. The count does not grow; a new behaviour number is explicitly rejected. | Spec §6, §7 |
| C-2 | Two proofs. Isolated (clauses 1–2) is necessary and not sufficient; the integrated proof is what an adoption claim requires, and the isolated one must never be presented as it. | Spec CE-17 |
| C-3 | Transport is out of scope — runtime delivery, turn flags, unit numbering, session mechanics, packaging, technical identity, Git mechanics, who carries a turn. Durable persistence is **not** transport and is owned. | Spec §3.3 |
| C-4 | Durable context is three permitted categories and no fourth: optional operator source material, one canonical project plan, the **existing** current-state interface. | Spec §5.7 |
| C-5 | Codex authors and edits durable context; Claude verifies repository reality, implements, and makes every commit. A commit restriction is not a decision restriction. | Spec §4; core §4 |
| C-6 | Discovery is relevance-gated: a starting set, four permitted reasons to expand, and a stop condition. Not a file count, not a token budget. | Spec §3.5 |
| C-7 | The behavioural standard is the mission's: every acceptance behaviour is demonstrated against a **constructed failing case** before it counts as done. | Spec §6; MVP proposal |
| C-8 | Quality bar is pilot quality with limitations written down — not completeness. Codex makes the executive "good enough, proceed" call. | Core §3; MVP proposal decision 3 |
| C-9 | One bounded correction round, frozen at the named findings. Anything newly noticed is a deferral, never a second round. | Core §3 |
| C-10 | The Work Loop v0.2 rework will shed bookkeeping from v2. Direction is fixed; scope and shape are not, and are not designed here. | `../../work-loop-v2-mvp/step-7-pilot-log.md` § The decision |

---

## 4. The implementation surface, as verified

**Everything in this section was verified by inspection on 2026-08-02.** It is stated separately from the
plan's *proposals* because a later session must be able to tell what was observed from what was suggested.
Re-verify before acting on any of it: these are claims about a live repository and they age.

### 4.1 Observed facts

| # | Fact | How verified |
|---|---|---|
| F-1 | The executable core is `../../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, 300 lines. Both sides read it first and neither restates it. | Read in full |
| F-2 | The Claude entrypoint is `../../../.claude/commands/work-loop-v2.md`, 113 lines. | Read in full |
| F-3 | The Codex entrypoint is `../../../.agents/skills/work-loop-v2/SKILL.md`, 116 lines. | Read in full |
| F-4 | The acceptance harness is `../../../logs/scripts/work-loop-v2-slice-1.test.sh`, 673 lines, covering Slices 1–3 by end-state assertion. | Read header + assertion set |
| F-5 | `/context.?engineering/i` returns **zero** matches across F-1, F-2 and F-3. So does `governing\|canonical project plan\|durable\|approved plan`. Context Engineering is absent from every live runtime artifact. | Grep, S4-510, recorded in `../../../logs/scratchpads/2026-08-02-13-08-scratchpad.md` |
| F-6 | Core §3 step 1 (Orient) reads only *"the state file and the repository"* — no recovery of governing plan, current state, settled decisions, blockers, or next justified unit. | Core §3, read |
| F-7 | Core §3 step 3 (Brief) carries **7** items against the specification §4.1 semantic interface's **11**, plus the operator-orientation paragraph. | Counted against both sources |
| F-8 | `SKILL.md:18` instructs Codex not to wait for a state file, because at task open none exists — leaving the operator's conversational message as Codex's only stated input. That is CE-17 clause 2's failing case, live in the artifact. | Read |
| F-9 | **The brief already sits outside the state file's five-field ceiling** (core §4, *"What the ceiling covers, and what it does not"*). Enriching the brief therefore expands no state schema. | Core §4, read |
| F-10 | The CE specification is 913 lines and carries exactly 17 unique `CE-n` identifiers, CE-1…CE-17 with no gaps. | `grep -o 'CE-[0-9]*' \| sort -u` |

### 4.2 The entrypoint inventory

CE-17's adoption boundary requires **every relevant Work Loop entrypoint** to invoke the capability before
plan-dependent continuation. This is that inventory, verified 2026-08-02 — and verifying it needed a
symlink-following scan, because a plain `find` misses files reached through symlinked command directories.
**A later session must repeat it with `find -L`; the naive scan under-reports.**

| Entrypoint | Where it lives | Access paths | Plan-dependent? |
|---|---|---|---|
| Claude command `/work-loop-v2` | One canonical file (F-2) | Three: `ai-resources`, `projects/axcion-systems-builder` (symlink), `projects/axcion-design-studio` (symlinked `commands/` directory) | **Consumes** a brief; does not prepare one. Not a CE invocation site — it is where a badly-prepared brief surfaces. |
| Codex skill `work-loop-v2` | One canonical file (F-3) | Two: `ai-resources`, `projects/axcion-systems-builder` (symlinked skill directory). **`axcion-design-studio` has no `.agents/` directory at all.** | **Yes — two sites:** opening a unit and writing the brief, and assessing/continuing a task. Both are plan-dependent. |
| Executable core | One canonical file (F-1) | Read by both sides; no copies found | Not an invocation site. It is the shared contract both entrypoints obey, so the orientation duty belongs here or it belongs in two places and drifts. |
| Work Loop **v1** — `.claude/commands/work-loop.md`, `docs/work-loop.md` | ai-resources; reachable from the symlinked project command directories | Still live | **Yes, until retired.** Retirement is Work Loop v2 mission Step 8, not this plan's work. Until it happens, v1 is a plan-dependent entrypoint that will not invoke Context Engineering. |

Two consequences, both observed rather than assumed:

- **There is one command file and one skill file, not three copies.** The mission thread that describes
  `axcion-design-studio` as holding *"a copy of the command"* is imprecise: it reaches the same bytes
  through a symlinked directory. What that project genuinely lacks is the Codex skill and a
  `logs/work-loop/` directory — so a v2 task cannot be *opened* there, whatever the command's presence
  suggests.
- **Adoption coverage therefore reduces to two files** — the Codex skill's two plan-dependent sites, and
  the executable core's orientation step — plus a stated position on v1. That is what makes this
  integration a seam edit rather than a subsystem.

### 4.3 Proposed, not observed

Everything below is this plan's proposal. None of it is settled, and an implementation session may
discard any of it on live evidence.

- **Trial artifacts live under `plans/work-loop-v2-v0.2/context-engineering/`**, alongside this plan:
  seeded scenarios and fixtures in a `trials/` subfolder, one evidence record per session.
- **The seam edit's starting candidate is the design reverted in S4-510** — recorded in
  `../../../logs/scratchpads/2026-08-02-13-08-scratchpad.md` so it need not be re-derived. It is a
  *starting point re-derived against live files*, not a specification.
- **Carriage of the behaviour at runtime** (Phase 1, U-1) — the two candidate shapes are described there
  as candidates to test, not as a choice already made.

### 4.4 The candidate — the thing Phase 2 actually builds

F-5 is the reason this section exists: Context Engineering is absent from every live runtime artifact, so
**nothing today can exhibit the behaviour.** A trial that only writes an evidence file cannot turn a
constructed failing case green, because nothing changed between the failing run and the passing one. Phase
2 therefore needs a named object that starts without the behaviour and gains it one family at a time.

**The candidate is one file: `trials/candidate/SKILL.md`** — a working revision of the Codex skill
(`.agents/skills/work-loop-v2/SKILL.md`, F-3), held *outside* the live path. Three properties make it the
right object rather than a new invention:

- **It is a revision of an artifact that already exists,** not a new artifact kind. At S8 its content
  lands in the live skill file and `trials/candidate/` is deleted. Nothing new survives into runtime, so
  CE-16 is untouched — the prohibition is on new and per-run *runtime* artifacts, and this is development
  material for a build, deleted when the build lands.
- **It is what Codex actually reads.** The skill is where Codex's behaviour is defined, so evolving the
  skill *is* evolving the behaviour. Nothing else has to be built for a slice to demonstrate anything.
- **It is isolated by construction.** It sits under `trials/`, not under `.agents/skills/`, so no live
  session can pick it up. The operator points a fresh Codex thread at it explicitly, for the trial only.

**Every Phase 2 session therefore has two outputs, not one:** a revision of the candidate, and the
evidence record for the behaviours that revision made pass. A session that produces only an evidence
record has not exited.

> **Fixtures must never look authoritative.** Slices B and C seed plans and current-state files, and a
> seeded "approved plan" is exactly the shape CE-4 and CE-6 warn about. Three rules, and they are
> checkable rather than aspirational:
>
> 1. Every fixture lives under `trials/` and **opens with a first line reading
>    `FIXTURE — not a project artifact; seeded for {behaviour}. Carries no authority.`** A fixture without
>    that line fails its own slice.
> 2. **No fixture is placed at a path that a real project's discovery would reach** — not in `plans/` root,
>    not in any `logs/work-loop/` directory, not anywhere §5.7's three durable categories are looked for.
> 3. At the end of Phase 2, S7's non-accretion run greps the repository for the fixture marker outside
>    `trials/`. A hit means a fixture escaped, and S7 fails.
>
> This is a naming and placement discipline, not a register. Nothing tracks fixtures; the marker and the
> grep are the whole mechanism.

---

## 5. The destination, and what would falsify it

### 5.1 Observable destination

Done means all of the following have been **demonstrated**, not claimed:

1. A fresh Codex thread, given one operator objective plus whatever material exists, produces exactly one
   execution brief, discovery brief, or genuine escalation — in one preparation pass.
2. The only thing that returns to the operator is a genuine operator-owned decision. Nothing derivable is
   asked of them.
3. The brief carries the §4.1 semantic interface, opening with an orientation paragraph of at most three
   sentences, in **one** artifact.
4. Load-bearing repository claims leave as claims naming surface and pattern, never as facts.
5. A fresh Codex thread recovers the unit from durable sources, and does so demonstrably — a memory-only
   control produces a materially different brief.
6. Governing authority is decided by semantic role, not by path, date, filename or imperative wording; a
   draft does not govern, and a materially edited approved plan returns to draft.
7. Claude receives and acts from the brief **with no operator context-transfer action** — the integrated
   proof, obtainable only in a genuinely two-model session.
8. Across a run of routine invocations, **zero net new durable files** and zero additional
   operator-visible stages, gates, review passes or persistent artifacts.
9. The operator can say the capability got real work started sooner, with less process than the failure it
   prevents.

Items 1–6 and 8 are the **isolated** proof. Item 7 is the **integrated** proof. Item 9 is the acid test,
and it is the only one that can shrink the capability.

### 5.2 What would falsify success

Named in advance, so a later session cannot quietly redefine the target.

- **The substitution.** An isolated trial produces a complete brief and the result is reported as
  demonstrating the one-touch handoff. This fails on the substitution alone, however good the brief is.
- **Counts above one.** More than one preparation pass, or more than one operator context action beyond a
  genuine decision, in a trial the plan calls successful.
- **A control that proves nothing.** A CE-9 trial whose memory-only control produces an indistinguishable
  brief has demonstrated only that conversational memory happened to be sufficient. The seeded material
  fact must be absent from the request.
- **Machinery.** Any phase that closes by adding a context-QC pass, an alignment gate, a review stage, a
  per-run record, a second state system, or a new document type. Adding one *is* the v1 failure, and the
  specification forbids an implementation from deciding the evidence justifies it (§9).
- **Grep-shaped evidence.** A check that greps for a word the plan or the brief already contains. It
  passes before the work happens, so it is not evidence (core §6 rule 5).
- **Silent scope drift in the brief.** A required outcome that covers only the convenient part of a
  two-part objective, with nothing recording that the other part was dropped (CE-11 failing case B).

---

## 6. Operator decisions this plan does not take

Identified, not resolved. Each is genuinely operator-owned; the plan states the consequence of each answer
and stops there.

| # | Decision | Why it is the operator's | Consequence |
|---|---|---|---|
| O-1 | **Does the CE specification become governing?** Its header still reads *"draft specification — awaiting operator approval · not requirements"*, and `logs/decisions.md` (2026-08-02) explicitly leaves the flip undecided — the approval given on 2026-08-02 was scoped *"for this implementation unit"*. | Approval promotes a draft to governing. Codex may not promote its own plan and neither may Claude. | **Phase 0. Nothing in Phase 1 onward may start without it.** |
| O-2 | **Ordering against the Work Loop v0.2 rework.** The rework will reshape the same three runtime files this integration edits, and its scope is undecided. | Sequencing two efforts against each other is priority, not technique. | Wire first and re-wire after the rework; or rework first and wire once. Phase 3 is the collision point. |
| O-3 | **v1 retirement** (mission Step 8, still undispatched). | Retiring a live system is priority and risk, not technique. | **Adoption condition 3.** v1 must be retired, or evidenced as *not relevant* under S8a's test, before an adoption claim. There is no third answer: a stated limitation cannot discharge it. |
| O-4 | **Will a genuinely two-model session be scheduled?** The integrated proof needs the operator driving Codex while Claude works the same repository. | Only the operator can run Codex. | Without it, Phase 4 cannot run and the honest outcome is the isolated proof plus an owed integrated proof. |

**Where an implementation session hits one of these, it stops and escalates** — it does not pick the
reading that lets work continue (spec §5.5: never manufacture a tie-break to keep the process moving).

---

## 7. The phases

**Evidence-gated, not calendar-gated.** A phase exits when its exit condition is demonstrated. Each
session below states: *inputs · one job · repository output · evidence capable of failing · exit condition
· stop condition · next-session handoff.* Capacity notes are for planning and never control progression.

### Phase 0 — Authority (no session)

**Two approvals, both required, neither implied by the other.** Nothing in Phase 1 onward is authorised
until both exist.

1. **The specification becomes governing.** The operator answers O-1. If no, this plan stops here and
   nothing else in it is authorised. If yes, the approval is recorded **in the specification itself**,
   bound to identifiable content — a commit hash or equivalent — not to the filename.
2. **This plan is approved as the plan of record.** Separately answered, after Codex has assessed it. The
   approval is recorded **in this document's header**, bound the same way. A specification that is
   governing does not make its implementation plan approved: the first says the behaviour is settled, the
   second says this sequence is how it gets built.

Both bindings follow spec §5.7 and CE-4 failing case C — an approval that identifies only a filename fails
on that shape alone, because the file's meaning can change with nothing appearing to have happened. A
**material** edit to either document afterwards — objective, scope, exclusions, settled decisions,
sequence, exit conditions, or authority relationships — returns that document to draft and needs explicit
reapproval. Genuine uncertainty about whether an edit is material is escalated, not resolved in favour of
carrying on.

**Where progression is recorded from here.** Phase 1 opens **one Work Loop task-state file** for the
implementation — `logs/work-loop/context-engineering-implementation.md`, the existing task-state
interface at the path core §4 fixes. It is spec §5.7's third permitted durable category, **not a new
state system**, and it is what carries the live phase, the open session, the latest material result, any
blocker and the exact next action across S1–S12. The per-session `Next:` lines below are the plan's
*static* ordering; **the state file is what says where the work actually is.** A fresh session reads the
state file first and this plan second.

**Exit:** the specification carries a recorded approval identifying the content approved; this plan
carries its own; and neither has been materially edited since.

---

### Phase 1 — Resolve the two blocking unknowns

Riskiest first. Both unknowns can invalidate every later slice, and neither can be settled by reasoning
about it.

- **U-1 · How is the behaviour carried at runtime?** The specification is 913 lines; the Codex skill is
  116 (F-3, F-10). Spec §7 leaves runtime packaging explicitly open as *"an implementation-planning
  question."* Nobody has yet shown that a fresh Codex thread reliably exhibits the behaviour under any
  particular carriage.
- **U-2 · Can fresh-session recovery be measured at all?** CE-9 requires a memory-only control, and the
  pilot already found that a clean proof *"is not available through the normal orientation path"* on the
  Claude side, because `/prime` preloads the prior session note (FP-11). The Codex-side analogue is
  untested.

> **A carriage failure does not shrink the behaviour.** Spec §7 explicitly rejects *"a rule that required
> behaviour shrinks merely because packaging is difficult."* If both candidate carriages fail, the outcome
> is an escalation, not a smaller contract. Only the §9 acid test, in a real trial, shrinks anything.

**Session S1 — build the measurement instrument**
- *Inputs:* the CE specification §3.5, §5.7, CE-9; F-1…F-10 re-verified; this plan.
- *One job:* construct one seeded scenario in which the durable sources carry **at least one material fact
  the operator's request message does not**, and state in writing which fact that is and how the control
  run is kept blind to it.
- *Repository output:* `trials/ce-9-recovery-scenario.md` plus the seeded durable sources it needs.
- *Evidence capable of failing:* the seeded fact is greppable in the durable sources and **absent** from
  the request text — shown by both greps, one hit and one miss. If the fact appears in the request, the
  instrument is broken and the session has failed, not succeeded.
- *Exit:* the scenario exists and its blind-control property is demonstrated.
- *Stop:* if no material fact can be seeded that the request would not naturally carry, stop — CE-9 may
  not be measurable as written, and that is a specification finding, not something to work around.
- *Next:* hand to the operator to run S2 with Codex.

**Session S2 — the carriage trial (operator-driven, Codex)**
- *Inputs:* S1's scenario; the specification; two candidate carriages, written as two files under
  `trials/candidate/` — **(a)** `carriage-a-SKILL.md`, the skill referencing the specification by path;
  **(b)** `carriage-b-SKILL.md`, the skill carrying a compressed behavioural checklist with the
  specification as the cited authority. Both are candidates; neither is chosen in advance.
- *One job:* run a fresh Codex thread on S1's scenario under each carriage and record which behaviours
  reach the brief.
- *How they are installed and isolated:* **neither is installed.** Both sit under `trials/candidate/`,
  outside `.agents/skills/`, so Codex's ordinary skill discovery cannot reach either and no live session
  can pick one up by accident. For each run the operator points a fresh Codex thread at one file
  explicitly, by path. The live `.agents/skills/work-loop-v2/SKILL.md` is not touched in this phase —
  `git diff` on it must be empty at S2's exit, and that is part of the evidence.
- *What survives the trial:* **one file.** The winning carriage is renamed to `trials/candidate/SKILL.md`
  and becomes the Phase 2 candidate (§4.4). The loser is **deleted**, not archived — a kept-alongside
  alternative is a second document describing the same thing, which is the FP-4 shape and, retained as a
  record of what was rejected, is the plan-history machinery §7 prohibits. The trial record states which
  won and why; that is the only thing preserved about the loser.
- *Repository output:* `trials/carriage-trial-record.md` — the two briefs and a per-behaviour table of
  present/absent — **plus** `trials/candidate/SKILL.md`, the surviving carriage.
- *Evidence capable of failing:* the behaviours are counted against CE-1…CE-16 by an observer who did not
  write the brief. A carriage that misses a load-bearing behaviour fails, and the record says so. Plus:
  `git diff -- .agents/skills/work-loop-v2/SKILL.md` returns empty, proving nothing was installed.
- *Exit:* one carriage is demonstrably sufficient and survives as the candidate, **or** both fail and U-1
  escalates to the operator.
- *Stop:* if the trial cannot be run because Codex cannot reach the repository as assumed, stop — that is
  a transport fact (C-3) and it belongs to the operator, not to this capability.
- *Next:* Phase 2, Slice A, with the chosen carriage stated.

*Capacity: one Claude session and one operator-driven Codex session.*

**Phase 1 exit:** U-1 answered by trial, U-2 answered by a working instrument, and one named candidate
exists at `trials/candidate/SKILL.md`.

---

### Phase 2 — The isolated proof, in thin slices

Each slice is one complete observable result, sized for a fresh session. **The cycle is red–green against
the candidate (§4.4), and the candidate revision is what makes it possible:**

```
run the constructed failing case against the CURRENT candidate  → it fails, recorded
revise the candidate to carry this family's behaviour           → one file, one family
run the SAME case against the REVISED candidate                 → it passes, recorded
```

Both runs are Codex runs on the same seeded input, so the operator drives them; the only variable between
them is the candidate revision. **A slice that cannot show the red run has not proved anything** — it has
shown that the behaviour is present, not that its absence was detectable. No slice builds a layer for a
later slice to use, and no slice touches the live `.agents/skills/work-loop-v2/SKILL.md`: `git diff` on it
is empty throughout Phase 2, and S8 is the first session that changes it.

**Session S3 — Slice A · one pass, one artifact** *(CE-17 clauses 1–2, CE-1, CE-2, CE-3, CE-15)*
- *Inputs:* the chosen carriage; spec §2, §4.1, Family 1, CE-15.
- *One job:* demonstrate that one objective plus material yields exactly one artifact in one pass, that
  only a genuine decision returns to the operator, and that a resolvable unknown becomes a discovery unit
  rather than a refusal.
- *Candidate change:* the candidate gains Family 1 and CE-15 — the single-pass rule, the §4.1 output
  contract, and the three-sentence orientation. Nothing else.
- *Repository output:* `trials/candidate/SKILL.md` (revised) **and** `trials/slice-a-evidence.md`.
- *Evidence capable of failing:* the red run first — the same seeded input against the pre-revision
  candidate, recorded as failing. Then, against the revised candidate: a count of preparation passes
  (target 1); a count of operator context actions (target 1 plus any genuine decision); the count of
  artifacts describing the unit (must be 1); the orientation's sentence count (≤3). Each seeded case
  includes one question of a *derivable* kind — if it returns to the operator, CE-1 fails and the record
  says so. **A green run with no recorded red run fails the slice.**
- *Exit:* all five behaviours demonstrated red-then-green against their constructed failing cases.
- *Stop:* if the pass terminates in more than one artifact and the cause is the carriage, return to Phase 1
  rather than adding a reconciliation step.
- *Next:* S4.

**Session S4 — Slice B · authority integrity** *(CE-4 A–D, CE-5, CE-6 A–C)*
- *Inputs:* spec §5 in full, Family 2.
- *One job:* demonstrate that governing authority follows semantic role, that a draft does not govern, that
  an approval bound only to a filename fails on that shape alone, that a materially edited approved plan
  returns to draft, and that demotion requires a citation.
- *Candidate change:* the candidate gains Family 2 — the semantic hierarchy, draft-does-not-govern,
  content-bound approval, material-edit demotion, and citation-required supersession.
- *Repository output:* `trials/candidate/SKILL.md` (revised); `trials/slice-b-evidence.md`; the seeded
  plan fixtures under `trials/`, each carrying §4.4's `FIXTURE —` first line.
- *Evidence capable of failing:* the red run first, against the pre-revision candidate. Then the
  specification's own construction — seed an approved plan, apply one editorial and one material edit
  without touching the approval line. A brief carrying the editorial one as governing and the material one
  as draft passes; carrying both as governing fails. Separately: four seeded items (non-authoritative
  imperative, preserved speculative material, a casual operator message, a genuine decision) each
  classified to its semantic role, with only the decision carrying authority.
- *Exit:* all three behaviours demonstrated red-then-green, including CE-6 case C — evidence falsifying a
  plan's factual premise is surfaced as a conflict, and does **not** re-aim the work.
- *Stop:* if the fixtures cannot be built without creating a second plan that appears current, stop —
  building one would violate CE-6 case B while testing it. The §4.4 fixture rules exist to make this
  avoidable, not to make it acceptable: a fixture that would be reachable by a real project's discovery is
  the stop, whatever it is marked.
- *Next:* S5.

**Session S5 — Slice C · claims, absence, and recovery** *(CE-7, CE-8, CE-9 A–C)*
- *Inputs:* S1's scenario; spec §3.5, §5.7 *Current state*, Family 3.
- *One job:* demonstrate that load-bearing repository claims leave as claims naming surface and pattern,
  that discovery expansions each name one of four reasons, and that a fresh thread recovers the unit from
  durable sources.
- *Candidate change:* the candidate gains Family 3 — claims-not-facts, absence claims naming surface and
  pattern, and relevance-gated discovery with the four expansion reasons.
- *Repository output:* `trials/candidate/SKILL.md` (revised); `trials/slice-c-evidence.md` — including the
  inspected-source set with each expansion mapped to its reason; any current-state fixture, `FIXTURE —`
  marked.
- *Evidence capable of failing:* the red run first, against the pre-revision candidate. Then the paired
  memory-only control from S1. If the two briefs are indistinguishable, the trial proved nothing and the
  record must say so rather than claiming recovery. CE-7 additionally succeeds *while the seeded claim is
  false* — Claude's later inspection marking it FALSE is the confirming evidence, not a contradiction.
- *Exit:* CE-7, CE-8 and all three CE-9 cases demonstrated red-then-green, with the control distinguishing.
- *Stop:* if the control cannot be kept blind in practice, stop and report CE-9 as unmeasured. Do **not**
  substitute a weaker control and call it recovery.
- *Next:* S6.

**Session S6 — Slice D · framing, bounding, attribution, selection** *(CE-10, CE-11, CE-12, CE-13, CE-14)*
- *Inputs:* spec §3.2, §5.6, Families 4 and 5.
- *One job:* demonstrate that plan alignment is a field and not a gate, that the unit is bounded with
  held-back work named, that Codex's technical preferences stay attributed proposals, that
  uncertain-relevance material is preserved visibly, and that material reclassification is disclosed
  without a discard ledger.
- *Candidate change:* the candidate gains Families 4 and 5 — the inline plan-alignment field, unit
  bounding with named held-back work, attributed Codex boundaries and non-prescription, three-way
  relevance, and reclassification disclosure.
- *Repository output:* `trials/candidate/SKILL.md` (revised) **and** `trials/slice-d-evidence.md`.
- *Evidence capable of failing:* the red run first, against the pre-revision candidate. Then the
  specification's constructions — an objective with two load-bearing parts, one inconvenient (a brief
  silently covering only the convenient part fails, and the seeded second part is what the evidence looks
  for); and a unit where Codex holds a clear design preference that no governing authority has settled (a
  "required" section naming the preferred mechanism fails). Additionally, **zero** new operator-visible
  stages or gates introduced by the alignment justification.
- *Exit:* all five behaviours demonstrated red-then-green.
- *Stop:* if satisfying CE-10 appears to need a separate alignment check, stop — that is failing case A,
  not a design need.
- *Next:* S7.

**Session S7 — Slice E · non-accretion across a run** *(CE-16 A–B; CE-15 count re-confirmed)*
- *Inputs:* spec §5.7, §7, CE-16; all prior slice records.
- *One job:* run a sequence of **routine** invocations — no new operator input, no approval, no materially
  changed understanding — and show the capability writes nothing durable.
- *Candidate change:* **none.** S7 measures the candidate as it stands; a revision here would mean an
  earlier slice left a behaviour incomplete, and that is a finding, not a fix to fold in silently.
- *Repository output:* `trials/slice-e-evidence.md`.
- *Evidence capable of failing:* `git status` before and after the run, plus a file-count diff of the
  repository. Target: **zero net new durable files**, and zero additional operator-visible stages, gates,
  review passes or persistent artifacts beyond the brief and §5.7's three categories. One file appearing is
  a failure, and the trial records must not be counted as the capability's output — they are this build's
  development evidence, and the run must be constructed so that distinction is observable. **Plus the
  fixture-escape check (§4.4 rule 3):** grep the repository for the `FIXTURE —` marker outside `trials/`;
  any hit fails the slice.
- *Exit:* the run is clean, no fixture escaped, and CE-15's artifact count of one is re-confirmed under
  real conditions.
- *Stop:* if a routine invocation genuinely needs to write something durable, stop and escalate — that is a
  specification finding, not an implementation liberty.
- *Next:* Phase 3, subject to the progression decision below.

**Phase 2 exit:** every behaviour except CE-17 clause 3 demonstrated **red-then-green** against a
constructed failing case, carried by one named candidate at `trials/candidate/SKILL.md`, with the live
skill file still unmodified (`git diff` empty). **Then an explicit progression decision by Codex**,
stating in writing which proof has been obtained and that clause 3 remains owed. Phase 3 does not start on
momentum.

*Capacity: five sessions; assume one behaviour family per session and do not compress two families to save
one session.*

---

### Phase 3 — Classify every entrypoint, wire the relevant ones, prove the seam, then one review

**Session S8a — the entrypoint classification**
- *Inputs:* a fresh symlink-following scan (`find -L`) of every access path to the Claude command, the
  Codex skill and Work Loop v1; O-3's answer.
- *One job:* classify **every** access path as *relevant* or *not relevant*, each with evidence. Nothing
  is left unclassified and nothing is waived.
- *The relevance test, stated once:* a path is **relevant** if a Work Loop task can be opened or continued
  through it in a way that depends on the plan. Concretely, it is relevant if all three hold — a Codex
  skill is discoverable from it, a `logs/work-loop/` directory exists or can be created by an ordinary
  session, and plan-dependent briefing or continuation happens there. A path failing any of the three is
  **not relevant**, and the failing condition is the evidence.
- *Repository output:* `trials/entrypoint-classification.md` — one row per access path: path, the three
  conditions with their observed values, verdict, and the command whose output produced it.
- *Evidence capable of failing:* every row's conditions are re-derivable by running the stated command.
  A row whose verdict does not follow from its own conditions fails. **A path with no row fails the
  session** — the scan's output and the table must have the same row count.
- *Exit:* every access path carries a verdict backed by an observed condition.
- *Stop:* if a path's relevance genuinely cannot be settled by inspection, it counts as **relevant** —
  the fail-safe direction — and either gets wired or blocks adoption. Do not resolve an ambiguous path
  toward "not relevant" because that is the reading that lets the work continue.
- *Next:* S8b.

> **Why this is a session and not a line in S8.** The plan's earlier version let uncovered entrypoints be
> named as limitations at Phase 3's exit. That inverted CE-17: the specification makes wiring *every
> relevant entrypoint* an adoption **condition**, not a preference to be traded away. A limitation can
> record something unmeasured; it cannot excuse an unmet condition. The two currently-open cases are
> exactly why the test has to be written down before either is judged — `axcion-design-studio` (no
> `.agents/`, no `logs/work-loop/`) and Work Loop v1 (live, plan-dependent, retirement undispatched).

**Session S8b — the seam edit**
- *Inputs:* S8a's classification; the reverted candidate design; the Phase 2 candidate
  (`trials/candidate/SKILL.md`); F-6, F-7, F-9 re-checked.
- *One job:* wire **every path S8a classified relevant**. For the canonical files that means the Codex
  skill's two plan-dependent sites and the executable core's orientation step; the Claude command changes
  only insofar as a richer brief needs consuming.
- *Repository output:* edits to `.agents/skills/work-loop-v2/SKILL.md`,
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, and `.claude/commands/work-loop-v2.md`.
  **No new file.** `trials/candidate/` is deleted in this session — its content has landed.
- *Evidence capable of failing — behavioural first, structural second.* The structural checks alone are
  not sufficient: greps, counts and a clean diff can all pass while the entrypoint still produces the
  wrong brief.
  1. **The constructed pre/post invocation at the real entrypoint.** Take one seeded request. Run it
     against the live entrypoint **before** the edit: it must fail to exhibit the required CE behaviour,
     and that failure is recorded. Run the **same** request after the edit: it must exhibit it. A post-run
     that passes with no recorded pre-run failure fails the session — that is the same red-run rule
     Phase 2 works under, applied at the seam.
  2. **Direct Work, as a fail-capable check.** Construct a small reversible fix and run it through the
     wired entrypoint. It must stay Direct Work: **no state file appears** in `logs/work-loop/`. The
     check is the absence of the file, observed — not an assertion that the bypass is intact.
  3. **False-premise refusal, as a fail-capable check.** Construct a state file whose brief carries one
     deliberately false claim, run it, and confirm the hand-back happens **and the named target file is
     unmodified**. The fixture pair for this already exists in the acceptance harness's Slice 1 shape;
     reuse the construction, not the harness.
  4. **Then** the structural checks: F-5's greps re-run (zero before, non-zero at named surfaces after);
     core §3 step 3's item count moved from 7 toward §4.1's semantic interface; the state file's
     five-field ceiling **unchanged**, which F-9 says is possible because the brief already sits outside
     it. A diff touching the state schema fails.
- *Exit:* every relevant path is wired, all three behavioural checks passed with their failing runs
  recorded, and the diff contains nothing unrelated.
- *Stop:* if the edit cannot be made without expanding the state schema or adding a fourth durable
  category, stop — the integration has stopped being a seam edit and the operator decides whether it
  proceeds at all.
- *Next:* S9.

**Session S9 — one fresh-context candidate review**
- *Inputs:* the candidate, **named by its exact Git commit**; S8b's behavioural evidence; the
  specification; this plan.
- *One job:* one serious review of the whole candidate — capability plus wiring — under the frozen-findings
  rule. Not a chain, not a per-slice review.
- *Repository output:* the findings, written into the task-state file.
- *Evidence capable of failing:* the review names the commit it examined. Any later change to the candidate
  makes the review stale and creates a new candidate.
- *Exit:* findings frozen, or the candidate accepted.
- *Stop:* if a finding is really about accepting risk, it goes to the operator (core §7).
- *Next:* S10 if findings exist; otherwise Phase 4.

> **The review follows the behavioural pass; it does not stand in for it.** S9 cannot start until S8b's
> three fail-capable checks have run and their failing runs are on record. A review reads a diff and
> reasons about it — competently, and still without ever invoking the thing. Reversing the order would
> put the most persuasive evidence (a careful reviewer's approval) in front of the only evidence that can
> actually fail (the seam refusing to work), which is how a candidate ships looking proved.

**Session S10 — the one bounded correction** *(only if S9 produced findings)*
- *Inputs:* the frozen findings.
- *One job:* correct exactly those. Anything newly noticed is recorded as a deferral and left unimplemented.
- *Repository output:* the corrected files.
- *Evidence capable of failing:* the closure check asks two questions only — are the frozen findings
  resolved, and did the correction break something. A third question means the round has escaped its frame.
- *Exit:* closure, or the post-correction menu chosen **once** on value and risk.
- *Stop:* menu choices that are really risk acceptance go to the operator.
- *Next:* Phase 4.

**Phase 3 exit — three conditions, all required:**

1. **Every access path carries a verdict** from S8a, each backed by an observed condition.
2. **Every path classified relevant is wired.** There is no "named as a limitation" alternative. An
   uncovered relevant path does not exit Phase 3 and does not reach an adoption claim.
3. **The seam is proved behaviourally** — S8b's pre/post invocation, plus the Direct Work and
   false-premise checks, each with its failing run recorded — and the candidate review has run after that
   evidence exists.

---

### Phase 4 — The integrated proof, and the adoption decision

**Session S11 — the two-model trial (operator-driven)**
- *Inputs:* the accepted candidate; one **genuine** unit of work the operator wanted done anyway. A
  manufactured unit tests nothing.
- *One job:* the operator gives Codex an objective once. Codex prepares and delivers a brief. Claude picks
  it up and works from it. The operator carries no context.
- *Repository output:* `trials/integrated-proof-record.md`, plus whatever the genuine unit itself produces.
- *Evidence capable of failing:* a count of operator context actions from objective to Claude's first
  action — target one, plus any genuine decision. **Any** hand-carrying of context fails clause 3. The
  record states explicitly which of the two proofs was obtained.
- *Exit:* clause 3 demonstrated, or honestly recorded as not obtained.
- *Stop:* if a fresh Claude subagent is proposed as a substitute for a fresh Codex thread, stop — the
  specification names that substitution as a failing case, and it is how the previous attempt went wrong.
- *Next:* the adoption decision.

**The adoption decision.** Operator-owned, informed by Codex's assessment. **Adopt** is available only
when all four conditions below hold. Otherwise the outcome is **do not adopt yet**, naming the specific
unmet condition, or **stop**.

| # | Condition for an adoption claim | Where it is established |
|---|---|---|
| 1 | The integrated proof is obtained — clause 3 demonstrated, not owed | S11 |
| 2 | Every access path is classified, and every *relevant* one is wired | S8a, S8b, Phase 3 exit |
| 3 | O-3 is settled: Work Loop v1 is retired, or evidenced as not relevant under S8a's test | Operator, before adoption |
| 4 | The seam is proved behaviourally, with failing runs on record | S8b |

**"Adopt with stated limitations" is deliberately not an option for conditions 2–4.** A limitation records
something *unmeasured* — an unproved CE-9 control, a deferred second caller. It cannot stand in for an
unmet adoption **condition**, and CE-17 makes entrypoint coverage a condition. Accepting one as a
limitation would be exactly the substitution the specification names as a failing case, one level up: the
weaker result presented as the stronger claim.

If only the isolated proof exists, the honest outcome is "isolated proof obtained, integrated proof owed"
— and that is a legitimate place to stop for a while. It is not adoption.

**Phase 4 exit:** the adoption decision is recorded — in the implementation task's state file, and at
closure in its closing record — with the proof it rests on named and each of the four conditions marked
met or unmet.

---

### Phase 5 — Harden from evidence, then stop

**Session S12**
- *Inputs:* every trial record; the friction observed in S11.
- *One job:* fix demonstrated blockers under the frozen-findings discipline, run the regression checks for
  the affected Work Loop paths, and write the limitations list.
- *Repository output:* the fixes; and the **closing record of the implementation task's state file**
  (`logs/work-loop/context-engineering-implementation.md`) — core §4's closure shape: the outcome, the
  decisions that matter, the final commit or evidence pointer, and the accepted limitations. That is the
  one durable destination for the limitations list. **No successor plan document is written**, and this
  plan is not rewritten into a v0.2 at closure — a second document describing the same finished work is
  the FP-4 shape.
- *Evidence capable of failing:* each fix has its own failing case. The regression set confirms the state
  ceiling, the Direct Work bypass, and the false-premise refusal still behave as before.
- *Exit:* the capability is useful, stable enough, and its known limitations are written down.
- *Stop:* **then stop.** Use the capability instead of continuing to design it. A further observation
  becomes a reopening trigger, not scope.

---

## 8. CE-1…CE-17 coverage map

Every behaviour is assigned to one slice and one constructible failing case or proof. The specification
carries each case in full; this table cites rather than restates it (spec §4.1's qualified reference rule
applied to the plan itself).

| # | Behaviour, in short | Slice / session | Constructible failing case | Proved by |
|---|---|---|---|---|
| CE-1 | Nothing derivable is asked of the operator | A · S3 | A load-bearing file's location is unstated but discoverable; the run asks where it is | Every returned question classified under §5.4; a derivable one fails |
| CE-2 | Escalation only for genuine operator-owned decisions | A · S3 | Material carrying both a resolvable repository question and an intent question; both return | The returned set, classified; the repository question appears as a claim instead |
| CE-3 | Resolvable uncertainty becomes a discovery unit | A · S3 | A load-bearing unknown answerable by inspection; output is a refusal or a guess | The brief's stated unit and its completion condition |
| CE-4 | Semantic hierarchy governs; a draft does not; approval binds to content | B · S4 | Four cases A–D, incl. approval bound only to a filename, and a materially edited plan still shown as approved | Seed an approved plan; apply one editorial and one material edit without touching the approval line |
| CE-5 | Imperative wording, saving, and operator authorship create nothing | B · S4 | Four seeded items; a casual operator message promoted to a decision because the operator wrote it | All four classified to semantic role; only the genuine decision carries authority |
| CE-6 | Demotion needs a citation; supersession is explicit; evidence ≠ intent | B · S4 | Three cases, incl. verified evidence falsifying a plan premise and the brief re-aiming the work | Conflict section; count of plans presented as current (must be 1); required outcome tracks approved intent |
| CE-7 | Repository claims leave as claims, never facts | C · S5 | Material asserting a file holds content at a line, where it does not | The brief's claims section, then Claude's inspection marking it FALSE — succeeds *because* the claim is false |
| CE-8 | Absence claims state what was searched | C · S5 | *"Nothing consumes this file"* repeated without a surface | The claim text contains both surface and pattern |
| CE-9 | Relevance-gated discovery; fresh threads orient from durable sources | C · S5 (instrument: S1) | Three cases: irrelevant area seeded; fresh thread drafting from memory; no current-state source | The inspected-source set **paired with a memory-only control**; indistinguishable briefs prove nothing |
| CE-10 | Plan-alignment justification as a field, not a gate | D · S6 | An irreconcilable objective proceeding silently; or a separate alignment stage introduced | The brief's orientation vs the approved plan; **zero** added stages |
| CE-11 | Bounded unit; held-back work named; objective not substituted | D · S6 | An objective with two load-bearing parts, one inconvenient | A brief covering only the convenient part fails; the seeded second part is what evidence looks for |
| CE-12 | Codex boundaries attributed; preferences are not requirements | D · S6 | A brief whose "required" section names a preferred mechanism no authority settled | Every technical element traced to: a cited decision, an attributed proposal, or an evidence requirement |
| CE-13 | Three-way relevance — governs / preserved visibly / removed | D · S6 | Over-inclusion; silent drop; the middle class silently promoted or erased | Seeded material traced to its expected class |
| CE-14 | Material reclassification disclosed; routine compression not | D · S6 | A proposal demoted with no disclosure — or a full discard log, the opposite error | The disclosure section checked against the four kinds |
| CE-15 | One execution handoff artifact, two audiences | A · S3, re-confirmed E · S7 | The run produces a separate operator-orientation document | Count of artifacts describing the unit (must be 1); orientation sentence count (≤3) |
| CE-16 | No new or per-run persistent artifacts; maintenance stays allowed | E · S7 | New machinery added; or a routine invocation writing a context file, log or run record | `git status` and file-count diff across a run of routine invocations: **zero net new durable files** |
| CE-17 | One input, one pass, one consumable brief | A · S3 (clauses 1–2) · **S11 (clause 3)**; adoption boundary · **S8a + S8b** | An isolated trial reported as demonstrating the one-touch handoff; or an adoption claim made with a relevant entrypoint unwired | Pass count (1); operator context-action count (1 + genuine decisions); an explicit statement of which proof was obtained; and S8a's classification table with every relevant path wired |

**Coverage:** 17 of 17. No behaviour is unassigned, and no new behaviour number is introduced — the count
stays seventeen, per spec §7.

**CE-17 carries a second obligation the others do not.** Besides its three clauses it states the adoption
boundary — *every relevant Work Loop entrypoint* must invoke the capability before plan-dependent
continuation. That is an adoption **condition**, discharged by S8a's classification and S8b's wiring, and
it is why those two sessions appear in the row above alongside the clause proofs.

---

## 9. Boundary audit — the prohibitions, and how this plan holds them

A prohibition mentioned only as something to build is not covered. Each row names the *active* handling.

| Prohibition (spec §7 / CE-16) | How this plan holds it |
|---|---|
| Any separate context-QC pass, including risk-triggered | §5.2 makes adding one a **falsification criterion**, not a design option. S6's stop condition fires if CE-10 appears to need an alignment check. |
| Lane classification | Not in any slice. Admission stays core §2's, cited in §4.2 as *not* a CE invocation site. |
| A new backlog, register, or log | S7 measures **zero net new durable files** across routine invocations; the trial records are development evidence and the run is constructed so the distinction is observable. |
| Context archive · context-pack lifecycle · decision register · provenance ledger · approval artifact · plan-history system | S7's failing case A lists these as the things whose appearance fails the slice. No phase produces any. **The Phase 2 candidate is not one:** it is a revision of an existing artifact (the Codex skill), held under `trials/`, and **deleted at S8b** when its content lands. Nothing new survives into runtime. S2's losing carriage is deleted rather than kept, which is what stops the candidate folder becoming a plan-history log. |
| Separate draft / approved / amended plan copies; raw-material archive by default | Phase 0 records **both** approvals in the approved documents themselves — the specification's in the specification, this plan's in this plan's header — each bound to content. No approval artifact is created and no approved-copy is forked. S4's stop condition refuses fixtures that would leave two plans appearing current, and §4.4's fixture rules keep seeded plans unreachable and marked. |
| A second project-state file or state system | Progression across S1–S12 is recorded in **the existing task-state interface** at `logs/work-loop/context-engineering-implementation.md` (Phase 0), which is spec §5.7's third permitted category — not a new system. S8b's evidence requires the five-field ceiling **unchanged**, and its stop condition fires if the edit needs schema expansion. F-9 is why that is achievable. |
| Transport machinery | Owned by the Work Loop, not by this capability. Clause 3 is proved in S11 by *observing* delivery, never by building it. S2's stop condition routes a transport fact to the operator. |
| General non-repository context engineering | Not in scope; reopening trigger is a real second caller (§11). |
| Portfolio prioritisation | O-2 and O-3 are handed to the operator rather than sequenced by the plan. |
| A required task-state file **as the brief format** | The brief stays delivery-mechanism-independent. S8b enriches the brief where core §4 already places it — outside the state ceiling. Using the existing state interface to record *progression* (Phase 0) is §5.7 category 3, a different thing from prescribing it as the brief's serialization. |
| Any dependency on the existing acceptance harness or slice plan | **No CE trial depends on `work-loop-v2-slice-1.test.sh`.** It appears only in S12's regression check on the Work Loop wiring, which is Work Loop work. Its known `KNOWN_WORKLOOP_FILES` defect is a deferral (§11), not a blocker for Phases 1–4. |
| A separate fresh-session orientation prerequisite, checklist, gate, or orientation-core artifact | CE-9 is proved **inside** the single pass (S5). No phase creates an orientation stage. |
| Core-versus-opportunistic proving tiers; a new CE behaviour number | §8 assigns all 17 at one tier. The count stays 17. |
| Behaviour shrinking because packaging is difficult | Phase 1's boxed note: a carriage failure escalates. Only §9's acid test, in a real trial, shrinks anything. |
| A runtime packaging decision as a constraint fixed now | U-1 tests two candidates and picks on evidence in S2. Neither is chosen in this plan. |

---

## 10. Standing rules of the build

- **The trial decides, not the design.** Every phase exists to produce evidence. A phase that produces only
  a better document has not exited.
- **One behaviour at a time, failing case first.** Define it, break it, fix it, demonstrate it, record it.
  A behaviour that was never seen to fail was never proved.
- **No horizontal layers.** No slice builds infrastructure for a later slice. If a slice needs something a
  later slice would build, the slice is wrong, not the order.
- **Frozen findings.** One correction round per review, frozen at the named findings. Anything newly
  noticed is a deferral with its reason. There is no second round.
- **Do not expand scope while implementing.** An adjacent improvement noticed mid-session is recorded and
  left undone (core §5).
- **Reversible details stay local.** File layout, naming, and internal structure are decided inside the
  implementing session and noted. Planning reopens only when evidence materially changes objective, scope,
  ownership, or a load-bearing decision.
- **When the answer is more process, the answer is wrong.** The specification's escape hatch points down.
- **No self-hosting on unproved machinery.** This build runs under the existing Work Loop v2 as it stands;
  the capability being built does not govern its own construction.

---

## 11. Accepted limitations and deferrals

**What may and may not appear in this table.** A limitation records something **unmeasured or deferred**.
It can never record an unmet *adoption condition* — the four in Phase 4's table — because that would let
the plan waive by wording what CE-17 makes a requirement. **Entrypoint coverage is therefore not
listable here.** Both entrypoint questions moved out of this table for exactly that reason and are now
decided in S8a against a stated test.

| Item | Why not now | Reopening trigger |
|---|---|---|
| **The integrated proof is owed until Phase 4 runs.** Everything before S11 is the isolated proof and must be reported as such. | Needs a genuinely two-model operator-driven session (O-4). | The operator schedules that session. |
| **The acceptance harness's `KNOWN_WORKLOOP_FILES` allowlist is stale** — 147 passed / 2 failed on a clean tree, because the allowlist predates a committed pilot file. | One-line fix, already queued at medium-high, and **no CE phase depends on the harness** (§9). | S12's regression run, or any session that needs the harness green. |
| **General (non-repository) context engineering.** | Deferred by the specification. | A real second caller. |
| **The v0.2 rework may re-shape the wired files.** | Its scope is undecided (C-10). | O-2 is answered, or the rework starts. |
| **CE-9 may prove unmeasurable** if no material fact can be seeded that the request would not naturally carry. | S1's stop condition; it is a specification finding, not a workaround. | A control design that keeps the fresh thread genuinely blind. |

**Moved out of this table by the correction round — now conditions, not limitations:**

- **`axcion-design-studio`.** It reaches the Claude command through a symlinked directory but has no
  `.agents/` and no `logs/work-loop/`. That makes it *not relevant* under S8a's test — but the verdict is
  established there, with the two absences as its evidence, and re-derived at adoption. It is not waived
  here, and it flips to relevant the moment either directory appears.
- **Work Loop v1.** Live, plan-dependent, retirement undispatched. Adoption condition 3 requires O-3
  settled first: v1 retired, or evidenced as not relevant under the same test. Neither this plan nor a
  limitation can decide it.

---

## 12. The exact next session

**Phase 0 first, and it is two answers, not one.** Nothing below starts until both exist:

1. **O-1 — does the specification become governing?** Recorded in the specification, bound to a commit.
2. **Is this plan approved as the plan of record?** Recorded in this document's header slot (§ Authority
   notice), bound to a commit. Answered after Codex has assessed the plan.

Then **Session S1 — build the CE-9 measurement instrument.** It is first because it is the only thing that
makes the riskiest trial (S2) falsifiable, and because everything in Phase 2 inherits its control design.

S1 needs, and needs only: this plan, the CE specification's §3.5, §5.7 and CE-9, and a re-verification of
§4.1's facts. Its output is one scenario file whose seeded material fact is provably present in the durable
sources and provably absent from the request text. If that cannot be constructed, S1 stops and reports
CE-9 as possibly unmeasurable — which is a finding worth having, and is not a failure of the session.

**S1 also opens the implementation task's state file**, `logs/work-loop/context-engineering-implementation.md`
— the existing task-state interface, no new system — and from that point it, not this section, is what says
where the work actually is. The `Next:` lines in §7 are the plan's static ordering; the state file is the
live position.

**This unit ends here. No implementation was performed in it.**
