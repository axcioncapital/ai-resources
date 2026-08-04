# Implementation plan: Context Engineering for the Work Loop

**Version:** v0.1 · **Stage:** **draft — returned to draft 2026-08-04** by the Route 3 deviation recorded in §7.2. The 2026-08-02 approval against commit `e1ce895` is retained as history and does not cover this content ·
**Status:** not authorisation to implement — the specification's approval (O-1) is still outstanding.

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
> Current status:    RETURNED TO DRAFT — 2026-08-04, by the Route 3 material edit recorded below and
>                    stated in full at §7.2. Needs explicit content-bound reapproval, after Codex has
>                    assessed the amendment.
> Note:              Route 3 authorised the deviation. It did not approve this wording, which did not
>                    exist when the route was chosen — an authorisation to prepare an amendment is not
>                    an approval of the amendment.
>
> Prior approval:    APPROVED as the plan of record — operator, 2026-08-02
> Approved commit:   e1ce895b3da1387bae7ce50623afc3875cb050ba
> Approved on:       2026-08-02
> Statement:         "I reapprove `context-engineering-implementation-plan-v0.1.md` as the plan of
>                    record, bound to commit `e1ce895b3da1387bae7ce50623afc3875cb050ba`, dated
>                    2026-08-02."
> Binds to:          the substantive content at e1ce895. The commit carrying this approval record is
>                    necessarily later than the content it approves — an approval record cannot be part
>                    of the approved content without becoming self-referential. It does not cover the
>                    2026-08-04 amendment.
>
> Earlier approval:  APPROVED as the plan of record — operator, 2026-08-02
> Approved commit:   cc635d4
> Approved on:       2026-08-02
> Returned to draft: 2026-08-02, by the earlier material edit recorded below. It binds to commit
>                    cc635d4 and does not cover this content.
> ```
>
> **The material edit of 2026-08-04 that returned it to draft again.** S8b closed without the behavioural
> seam proof, and the operator chose Route 3 — continue while S8b stays skipped. The amendment adds §7.2
> and qualifies the five passages that carried the proof as a progression gate: S8b's exit, S9's
> precondition, Phase 3's exit condition 3, the Phase 4 and Phase 5 entries, and Phase 6's adoption
> condition 4. That changes the phase sequence and an exit condition, so the content-bound rule above
> fires. **Nothing about the adoption bar moved:** condition 4 is unmet, adoption is unavailable, and
> §7.2 says so where the permission is granted.
>
> **The earlier material edit (2026-08-02).** S3's pre-revision run — the same seeded input against
> the unrevised candidate — falsified this plan's premise that the candidate is *behaviourally* empty and
> that all five Slice A cases start red. Four came back green and only CE-3 was red. The §4.4 candidate
> contract, the Phase 2 cycle and S3's evidence and exit conditions were corrected to match, which changes
> a material exit condition and therefore triggers the content-bound rule above. Reapproval binds to the
> commit carrying this correction, not to `cc635d4`.
>
> **What this approval does not do.** It answers the second of Phase 0's two questions only. **O-1 — does
> the specification become governing — is still unanswered**, and §12 states that nothing below starts
> until both exist. This plan is therefore the plan of record and still not authorisation to implement.
> S1 cannot open until O-1 is recorded in the specification, bound to a commit.
>
> **Assessment status: `unassessed`.** The operator approved before Codex's final closure check on the
> one-file-candidate fix ran. That check is not owed retrospectively; it is recorded as not run so a later
> reader does not mistake approval for independent assessment.
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

A self-contained plan for building Context Engineering as a core Work Loop function. A fresh session
executes one named session from it by reading three things and no more: the task-state file, this plan's
section for that session, and the specification sections that session names.

It covers: the situation, the constraints already settled, the implementation surface as *verified on
2026-08-02*, an observable destination with falsification criteria, the operator decisions this plan
deliberately does not take, seven evidence-gated phases broken into named sessions with named actors, a
CE-1…CE-17 assignment map, a grouped regression, a boundary audit against the specification's
prohibitions, the standing rules of the build, and the accepted limitations.

**There is no companion playbook and no companion summary.** The session detail is folded in here (§7). A
second document describing the same work is the FP-4 staleness failure the specification itself cites.

**Where the same thing is said once.** A behaviour's *constructible failing case* is stated in the §7
session that builds it, and nowhere else in this plan — §8 maps behaviours to sessions and does not
restate them. A *prohibition*'s active handling is stated in §9 and cited elsewhere. A *falsification
criterion* is stated in §5.2 and cited elsewhere. Repetition here is a defect, not thoroughness.

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
up. This plan's standing rules (§10) exist to keep it pointing down.

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
| C-9 | One bounded correction round, frozen at the named findings, followed — if it was not enough — by the existing value-and-risk menu, chosen **once**. Anything newly noticed inside a round is a deferral, never a second round. This plan adds no correction lifecycle of its own. | Core §3 *Correcting once*, *If the correction was not enough* |
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
| F-11 | **The Codex→Claude handoff surface already exists end to end** and needs no new transport artifact. Set out in §4.5, which S8b implements against. | SKILL.md and command read in full |

### 4.2 The entrypoint inventory

CE-17's adoption boundary requires **every relevant Work Loop entrypoint** to invoke the capability before
plan-dependent continuation. This is that inventory, verified 2026-08-02 — and verifying it needed a
symlink-following scan, because a plain `find` misses files reached through symlinked command directories.
**A later session must repeat it with `find -L`; the naive scan under-reports.**

What the word *relevant* covers is **not** settled by this table. It is an operator decision (O-3),
because it turns on whether the specification's adoption boundary means the v0.2 entry protocol or every
live Work Loop generation. The table records technical facts; S8a applies the technical test; the operator
settles the semantic scope.

| Entrypoint | Where it lives | Access paths | Plan-dependent? |
|---|---|---|---|
| Claude command `/work-loop-v2` | One canonical file (F-2) | Three: `ai-resources`, `projects/axcion-systems-builder` (symlink), `projects/axcion-design-studio` (symlinked `commands/` directory) | **Consumes** a brief; does not prepare one. Not a CE invocation site — it is where a badly-prepared brief surfaces. |
| Codex skill `work-loop-v2` | One canonical file (F-3) | Two: `ai-resources`, `projects/axcion-systems-builder` (symlinked skill directory). **`axcion-design-studio` has no `.agents/` directory at all.** | **Yes — two sites:** opening a unit and writing the brief, and assessing/continuing a task. Both are plan-dependent. |
| Executable core | One canonical file (F-1) | Read by both sides; no copies found | Not an invocation site. It is the shared contract both entrypoints obey, so the orientation duty belongs here or it belongs in two places and drifts. |
| Work Loop **v1** — `.claude/commands/work-loop.md` (251 lines), `docs/work-loop.md` (260 lines) | ai-resources; reachable from the symlinked project command directories. **It has its own Codex skill**, `.agents/skills/work-loop/SKILL.md`, and its own state directory, `logs/loop/` | Still live | **Plan-dependent, live, and it authors its own brief.** `work-loop.md:41` — given a plain-English need, *"compose the brief yourself in the contract's `BRIEF` shape."* That is a CE invocation site by any reading of the behaviour. Whether it is *in scope* is O-3, not a fact this table can settle. |

**There is one command file and one skill file, not three copies.** The mission thread that describes
`axcion-design-studio` as holding *"a copy of the command"* is imprecise: it reaches the same bytes
through a symlinked directory. What that project genuinely lacks is the Codex skill and a
`logs/work-loop/` directory — so a v2 task cannot be *opened* there, whatever the command's presence
suggests. Under O-3's narrow reading, adoption coverage reduces to two files — the Codex skill's two
plan-dependent sites and the executable core's orientation step — which makes this integration a seam edit
rather than a subsystem. Under the wide reading it also reaches v1.

### 4.3 Proposed, not observed

Everything below is this plan's proposal. None of it is settled, and an implementation session may
discard any of it on live evidence.

- **Trial artifacts live under `plans/work-loop-v2-v0.2/context-engineering/`**, alongside this plan:
  seeded scenarios and fixtures in a `trials/` subfolder, one evidence record per session. §7.5 says which
  of those survive the build and which are deleted at S12.
- **The seam edit's starting candidate is the design reverted in S4-510** — recorded in
  `../../../logs/scratchpads/2026-08-02-13-08-scratchpad.md` so it need not be re-derived. It is a
  *starting point re-derived against live files*, not a specification.
- **Carriage of the behaviour at runtime** (Phase 1, U-1) — the single inline candidate described there is
  a construction to test, not a settled runtime packaging answer. If it fails to deliver, U-1 escalates.

### 4.4 The candidate — the thing Phase 2 actually builds

F-5 is the reason this section exists: Context Engineering is absent from every live runtime artifact, so
**nothing today can exhibit the behaviour.** A trial that only writes an evidence file cannot turn a
constructed failing case green, because nothing changed between the failing run and the passing one. Phase
2 therefore needs a named object that starts without the behaviour and gains it one family at a time.

**The candidate is one file: `trials/candidate/SKILL.md`** — a working revision of the Codex skill
(`.agents/skills/work-loop-v2/SKILL.md`, F-3), held *outside* the live path. Three properties make it the
right object rather than a new invention:

- **It is a revision of an artifact that already exists,** not a new artifact kind. At S8b its content
  lands in the live skill file and `trials/candidate/` is deleted. Nothing new survives into runtime, so
  CE-16 is untouched — the prohibition is on new and per-run *runtime* artifacts, and this is development
  material for a build, deleted when the build lands.
- **It is what Codex actually reads.** The skill is where Codex's behaviour is defined, so evolving the
  skill *is* evolving the behaviour. Nothing else has to be built for a slice to demonstrate anything.
- **It is isolated by construction.** It sits under `trials/`, not under `.agents/skills/`, so no live
  session can pick it up. The operator points a fresh Codex thread at it explicitly, for the trial only.

**What the candidate contains when Phase 2 opens.** Phase 1 answers *how* an instruction reaches a fresh
Codex thread. It must not answer *which* CE behaviours the thread exhibits, so the candidate at Phase 1
exit is a **carriage with no CE content**: the mechanism proved, Families 1–6 not yet written. The
construction S2 uses to keep those two questions apart is stated in S2.

**"No CE content" is a claim about the candidate's text, not about the thread's behaviour.** It means the
candidate carries no explicit family instruction. It does **not** establish that the specified behaviour is
absent. The candidate is a revision of the live Codex Work Loop skill (F-3), and that skill and the
executable core already produce some of the specified results on their own — a thread reading them has
reasons to behave well that no CE family put there. Where that is so, the pre-revision run comes back
green, and that is a fact about the starting point, not a defect in the construction and not a failure of
the slice.

**A clean pre-revision pass is baseline evidence, not contamination.** It records that the behaviour was
already present before the candidate carried any instruction for it, and it is kept as the evidence for
that behaviour. It may not be relabelled red, discarded, or re-run against a different scenario in order to
manufacture causality, and **the seeded input may not be tuned after the result is seen** — that is
building the instrument around the answer (§5.2, *a control that proves nothing*; core §6 rule 5).
Contamination is a different finding and needs its own evidence — that the candidate or the seed carried
the behaviour in — not merely a green line where red was expected.

**Each slice therefore separates two kinds of green.** **Baseline green** — present before the revision,
proved by the recorded pre-revision run. **Caused green** — red before the revision and green after it,
with both primary outputs inspectable. A slice proves causality for the second group and **no regression**
for the first. Presenting a baseline-green behaviour as one the revision made pass is the specific overclaim
this rule exists to prevent; so is quietly dropping a baseline-green behaviour from the record because it
demonstrated nothing.

**Every Phase 2 session therefore has two outputs, not one:** a revision of the candidate, and the
evidence record — for the behaviours that revision made pass, and for those it had to leave unbroken. A
session that produces only an evidence record has not exited.

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

### 4.5 The no-ferry seam — the existing surface S8b wires

CE-17 clause 3 asks that Claude receive and act from the brief **with no operator context-transfer
action**. The Work Loop already has the surface that makes this possible. It is named here, with live
evidence, so S8b reuses it and builds no transport artifact and no second state system.

| Question | The existing answer | Live evidence |
|---|---|---|
| Where does Codex write the engineered brief? | Into the task-state file's `## Brief` section, at `logs/work-loop/{task-id}.md`. Codex has repository write access and uses it directly. | `SKILL.md:19` *"You **write** the state file, at the path core § 4 fixes."*; `SKILL.md:33` *"The folder is core § 4's, not a choice."*; core §4 *Where it lives* |
| Where does Claude read it? | The same path. The command resolves the task id from its argument, or from the single file under `logs/work-loop/` whose `turn:` is `claude`. | `work-loop-v2.md:32` |
| How is **task identity** checked? | Frontmatter `task:` must match the resolved id. A mismatch is reported and **nothing is changed** — no turn flip, no commit. | `work-loop-v2.md:36`; core §6 rule 2 |
| How is **turn ownership** checked? | Frontmatter `turn:`. Codex sets `turn: claude` when the brief is ready; Claude stops if it is anything else. This says *whose move it is* — nothing more. | `SKILL.md:46`; `work-loop-v2.md:38` |
| How is **freshness** checked? | **It is not.** Core §6 rule 2 names four conditions — missing, malformed, stale, belongs to another task — and the live command implements identity, turn and readable-frontmatter. **Nothing checks staleness**: a `turn: claude` file whose brief was written against a repository that has since moved is indistinguishable from one written a minute ago. | `work-loop-v2.md:32-38` read in full; core §6 rule 2 (`:269`) |
| What does the operator actually do? | Carries the *turn*, not the *context* — but the action count is **conditional, not always one**. Bare `/work-loop-v2` resolves automatically **only when exactly one** file under `logs/work-loop/` has `turn: claude`. With more than one, the command lists them and asks which — so the operator must also **name the task**, a second action. | `work-loop-v2.md:32` *"If more than one qualifies, list them and ask which. Never guess."*; `SKILL.md:21`, `SKILL.md:27` |

**Why that last row is the whole of clause 3 — and where it needs care.** The operator typing
`/work-loop-v2` is a trigger, not a context transfer: the context is already in the file Claude opens by
itself. Clause 3 fails on *ferrying* — the operator assembling, restating or hand-carrying the brief. It
does not fail on the operator being the one who says "go". **Naming which task to open is the same kind of
action:** it identifies a file, it transfers no context, and it is what the live command requires whenever
more than one task is open. So S11 counts it, states it separately, and does **not** treat it as ferrying.
The distinction the S11 record must make explicit is between *identifying* a task and *supplying* its
content; only the second fails clause 3.

**Two things this seam does not provide, named here so no later session assumes them.** There is no
staleness check — freshness is a property nothing in the live path verifies, and a brief that has aged
badly is caught, if at all, by Claude's ordinary premise check under core §6 rule 1, which is a different
mechanism with a different scope. And there is no single-trigger guarantee when several tasks are open.
Both are live Work Loop facts (C-3, transport), not Context Engineering's to fix; S8b **must not** build a
freshness field or a task-selection mechanism to close either.

**What S8b must therefore not do:** create a delivery file, a queue, a handoff document, a second state
system, or a turn mechanism. All five already exist or are prohibited. The seam edit changes *what the
brief contains* and *what the entrypoints do before writing it* — nothing about how it travels.

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
9. **The candidate carrying all of the above is the one that was last proved.** Where hardening changed
   runtime behaviour after a proof, the affected behaviours were re-proved against the changed candidate,
   and the grouped regression ran on it.
10. The operator can say the capability got real work started sooner, with less process than the failure
    it prevents.

Items 1–6 and 8 are the **isolated** proof. Item 7 is the **integrated** proof. Item 9 is what stops a
proof from being inherited by a candidate that no longer matches it. Item 10 is the acid test, and it is
the only one that can shrink the capability.

### 5.2 What would falsify success

Named in advance, so a later session cannot quietly redefine the target. Every stop condition in §7 and
every row in §9 traces to one of these; they are stated here once.

- **The substitution.** An isolated trial produces a complete brief and the result is reported as
  demonstrating the one-touch handoff. This fails on the substitution alone, however good the brief is.
  **The shadow slice (S3b) is the same failure in a new place** — it involves both models and still is not
  the integrated proof, because the operator triggers it outside the wired seam.
- **Counts above their target.** More than one preparation pass, or **any** operator *context* action
  beyond stating the objective and a genuine decision, in a trial the plan calls successful. Trigger
  actions are counted separately and are not this criterion (§4.5, S11) — but a trial that reports them
  merged into one number, or omits how many tasks were open, fails on the concealment.
- **A control that proves nothing.** A CE-9 trial whose memory-only control produces an indistinguishable
  brief has demonstrated only that conversational memory happened to be sufficient. The seeded material
  fact must be absent from the request.
- **A proof inherited by a changed candidate.** Hardening alters runtime behaviour, and an earlier proof
  or review is allowed to stand for the altered candidate without the affected behaviours being re-run.
- **A bootstrap that cannot fail.** A candidate declared to carry behaviours it is then required to lack,
  so the red runs that follow could never have failed.
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
| O-3 | **What does "every relevant Work Loop entrypoint" mean?** — the two readings are below. | A question about the *scope of the adoption boundary*: semantics and priority, not a technical fact. Evidence informs it; evidence cannot answer it. | **Adoption condition 3.** It decides what population S8a classifies, and it must be settled before an adoption claim. |
| O-4 | **Will a genuinely two-model session be scheduled?** The integrated proof needs the operator driving Codex while Claude works the same repository. | Only the operator can run Codex. | Without it, Phase 4 cannot run and the honest outcome is the isolated proof plus an owed integrated proof. |

**O-3, stated in full, because this plan must not lean toward either answer.**

The specification's adoption boundary says the capability takes effect once *"every relevant Work Loop
entrypoint"* invokes it before plan-dependent continuation (CE-17). Two readings are available and the
plan takes neither.

| Reading | What it means | Consequence if chosen |
|---|---|---|
| **A — the v0.2 entry protocol only** | "Relevant" names the Work Loop generation this specification was written for. Work Loop v1 is a different generation and sits outside the boundary. | Adoption becomes available without touching v1. The claim is correspondingly narrower: plan-dependent work can still continue through v1 without Context Engineering, which is the gap CE-17 exists to close. That narrowing is written into the adoption record, not left implied. |
| **B — every live generation** | "Relevant" names any entrypoint through which plan-dependent Work Loop work is actually opened or continued today, whatever its version. | v1 must invoke the capability, or be retired, before adoption. More work, later adoption, and a claim that matches what an operator would reasonably assume "adopted" means. |

Evidence bearing on the question, offered and not treated as decisive: spec §8 records the dependency
against *"the **Work Loop entry protocol**"*, singular, which leans toward A; §4.2 observes that v1 is
live and plan-dependent today, which is what makes B substantive. Neither settles it.

**Retirement is not assumed either way.** Reading B does not require retiring v1 — wiring it is the other
option. Reading A does not require keeping it. Retirement remains mission Step 8's question, undispatched,
and this plan does not sequence it.

**Where an implementation session hits one of these, it stops and escalates** — it does not pick the
reading that lets work continue (spec §5.5: never manufacture a tie-break to keep the process moving).

---

## 7. The phases

**Evidence-gated, not calendar-gated.** A phase exits when its exit condition is demonstrated. Each
session states: *inputs · actors · one job · repository output · evidence capable of failing · exit
condition · stop condition · next-session handoff.* Capacity notes are for planning and never control
progression.

### 7.0 Who produces the evidence, and how much of it needs the operator

Every session names a **lead** — who performs the work — and an **observer** — who checks the result
against a stated list. The observer is never the party whose output is being judged. **This adds no review
stage:** the observer is always someone already in the loop for that session, doing the checking inside it.

**An observer is a party, never a command.** A grep, a question or a re-derivable table is *what the
observer checks against*; it cannot be the observer. Every row below therefore names a person or a model
in both columns, with the checked-against list beside it.

| Session | Lead | Observer — and what they check against | Needs the operator to drive Codex? |
|---|---|---|---|
| S1 · CE-9 instrument | Claude | **The operator** — re-runs the two stated greps (one hit, one miss) before authorising S2. Mechanical, no judgment, and it is not Claude checking its own output | No |
| S2 · carriage probe | **Claude** authors the one candidate file; **the operator** then leads the two runs, driving fresh Codex threads | **Claude** — wrote none of the briefs; applies the probe check and verifies the named files really exist | **Yes** |
| S3 · Slice A | Operator, driving Codex | Claude — the per-case pre-revision and post-revision record (which cases were baseline green, which were caused green) and the four counts | **Yes** |
| S3b · shadow slice | Operator (drives Codex) **and Claude** (does the real work from the brief) | Claude reports usability; the operator reports their own effort. Neither judges the other's half | **Yes** |
| S4 · Slice B | Operator, driving Codex | Claude — each seeded item against its constructed case | **Yes** |
| S5 · Slice C | Operator, driving Codex | **Claude** — for CE-7 this is the ordinary Work Loop premise check (command Step 2) run against the trial brief | **Yes** |
| S6 · Slice D | Operator, driving Codex | Claude — each seeded item against its constructed case | **Yes** |
| S7 · Slice E + first grouped regression | Operator, driving Codex | Claude — the file-count diff, the fixture-escape grep, and R-1…R-5 | **Yes** |
| S8a · entrypoint classification | Claude | **The operator** — re-runs the stated commands per row and confirms the O-3 reading recorded is the one they chose | No |
| S8b · seam edit | Claude | **Claude** for the structural checks; **the operator** owns both halves of the pre/post pair, since each needs a fresh Codex thread | **Yes**, for **both** the pre-run and the post-run |
| S9 · candidate review | An independent reviewer, fresh context | **Claude** — checks only that the review names the exact commit examined and that the candidate has not changed since. A staleness check, not a second review | No |
| S10 · bounded correction | Claude | **Codex** — it owns the closure check's two questions (core §3 step 5) | No |
| S11 · integrated proof | Operator + Codex + Claude | Claude records the run; the operator counts their own actions | **Yes** |
| S12 · hardening, reproof, final regression | Claude | **Claude** for the fixes and the affected reproof; **the operator** for the regression cases needing a fresh Codex thread, which they drive and report | **Yes**, for those cases |

**Operator load, stated rather than implied: ten of the fourteen sessions need the operator to drive
Codex** — every session from S2 to S7, plus S8b, S11 and S12. Only S1, S8a, S9 and S10 do not. (An earlier
version of this table said nine and assigned the operator to just one half of S8b's pre/post pair; both
were undercounts.) That is the real cost of this build, and it is why the phases are sized to one session
each rather than compressed.

### 7.1 The grouped regression

**What it is.** Five rich seeded cases that between them exercise CE-1…CE-16 and CE-17 clauses 1–2. Not a
new session, not a new stage, not a review — a set of fixtures and checks run *inside* sessions that
already exist.

**When it runs.** In full at the Phase 2 candidate boundary (inside S7), and in full on the final
candidate after the last runtime change (inside S12). After an intermediate correction, only the cases
covering behaviours the correction touched are re-run — and which cases were skipped, with the reason,
goes into that session's record.

**Why it exists.** Without it, a behaviour proved against the S3-era candidate would be treated as proved
for a candidate five revisions later. The regression is what makes §5.1 item 9 checkable.

| Case | What it seeds | Behaviours it exercises |
|---|---|---|
| **R-1 · The two-part objective** | One objective with two load-bearing parts, one inconvenient; one derivable unknown (a file's location); one genuine intent question; one unknown resolvable only by inspection | CE-1, CE-2, CE-3, CE-11, CE-15, CE-17 clauses 1–2 |
| **R-2 · The edited approved plan** | An approved plan plus one editorial and one material edit with the approval line untouched; a draft plan; a non-authoritative imperative file; a casual operator message; a genuine decision; verified evidence falsifying a plan premise | CE-4, CE-5, CE-6 |
| **R-3 · The blind fresh thread** | S1's seeded material fact — present in durable sources, absent from the request; a false repository claim; an absence claim; one irrelevant repository area | CE-7, CE-8, CE-9 |
| **R-4 · The unsettled preference** | A design choice Codex prefers that no authority has settled; material of uncertain relevance; material that must be reclassified | CE-10, CE-12, CE-13, CE-14 |
| **R-5 · The routine run** | A sequence of routine invocations — no new operator input, no approval, no materially changed understanding | CE-16, and CE-15's artifact count re-confirmed |

**The cases are listed by behaviour number; they are not *run* by behaviour number.** A case that reported
one verdict per behaviour could pass while a subcase inside it was never exercised — R-2 returning "CE-4
green" while CE-4 A was not seeded, for instance. Two rules close that:

1. **Each regression case inherits the complete seeded subcase set from the slice that built those
   behaviours** — R-2 carries every CE-4 A–D, CE-5 and CE-6 A–C condition S4 constructed, R-4 every CE-10
   A–B, CE-11 A–B, CE-12 A–B, CE-13 A–C and CE-14 condition S6 constructed, and so on.
2. **Each case's record reports one line per subcase, not one per behaviour.** A subcase with no line is a
   failed regression run, exactly as a behaviour with no row fails §8. This is a reporting granularity
   rule; it adds no case, no session and no check beyond the ones the slices already built.

**CE-17 clause 3 is deliberately absent from this table.** It cannot be exercised by a seeded case, because
it needs a genuinely two-model session (S11). Its regression, where S12's hardening touched the seam, is a
re-run of S11 — stated in S12.

**Retention.** The regression's cases and fixtures are the material that *survives* the build (§7.5).
Everything else under `trials/` is temporary.

---

### 7.2 The Route 3 deviation — progression under an explicit evidence debt

**What the operator decided.** On 2026-08-04, with S8b closed and the behavioural seam proof not obtained,
the operator chose **Route 3**: work continues while S8b stays skipped. This section records that decision
and its exact boundary. It is the only place in this plan where progression past an unmet evidence
condition is permitted, and it permits it once, here, for this one debt.

**The debt, named so it cannot be mislaid.** `../../../logs/work-loop/context-engineering-s8b-seam-proof.md`
closes S8b with three checks unmet. This plan carries them forward as **owed**, never as obtained:

1. **The causal post half** of the pre/post pair at the real entrypoint. A pre-integration red run exists
   and is retained as evidence; no byte-identical post half does.
2. **The Direct Work check, passing** — the observed absence of a state file after a small reversible fix
   is run through the wired entrypoint.
3. **The post-integration false-premise refusal**, with the named target file observably unmodified.

**What Route 3 permits.** S9 may open with the debt outstanding, and — subject to this plan's ordinary
session-by-session decisions, not automatically — Phases 4 and 5 may follow. What those sessions do is
evidence-gathering, review, correction, integration and hardening. That is the whole permission.

**What Route 3 does not do**, stated plainly because a deviation is exactly where these slip:

- **It does not make the missing evidence exist.** No passage of this plan, and no record produced
  downstream of it, may describe the seam as behaviourally proved.
- **It does not make adoption available.** Phase 6 condition 4 is **unmet** and stays unmet until a
  separate, explicitly authorised proof task establishes it. Everything produced while the debt stands is
  **non-adoption evidence**, whatever else it demonstrates.
- **It does not reopen S8b.** That task is closed and this section changes nothing in its record.
- **It is not a waiver mechanism.** No general route exists by which an unmet condition becomes optional,
  and this section is not precedent for one. A further deviation is a fresh operator decision, taken and
  recorded the same way.

**Why this is not a limitation.** §11's table records what is *unmeasured or deferred*, and it explicitly
cannot record an unmet adoption condition. The seam proof is one of the five, so it does not go there — it
lives here, where the permission and the block are stated in the same place and cannot be read apart.
Moving it into §11 would turn a blocked condition into a written limitation, which is the substitution
§5.2 names, one level up.

**How this section stops being needed.** A separate, explicitly authorised task obtains the three checks
above with their failing runs on record. Condition 4 is then met, this deviation has nothing left to
permit, and the passages citing it revert to their unqualified form.

---

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
  question."* Nobody has yet shown that a fresh Codex thread reliably picks up and acts on an instruction
  delivered through any particular carriage.
- **U-2 · Can fresh-session recovery be measured at all?** CE-9 requires a memory-only control, and the
  pilot already found that a clean proof *"is not available through the normal orientation path"* on the
  Claude side, because `/prime` preloads the prior session note (FP-11). The Codex-side analogue is
  untested.

> **A carriage failure does not shrink the behaviour.** Spec §7 explicitly rejects *"a rule that required
> behaviour shrinks merely because packaging is difficult."* If the candidate carriage fails, the outcome
> is an escalation, not a smaller contract. Only the §9 acid test, in a real trial, shrinks anything.

**Session S1 — build the measurement instrument**
- *Inputs:* the CE specification §3.5, §5.7, CE-9; F-1…F-11 re-verified; this plan §4, §7.1.
- *Actors:* lead Claude; observer — **the operator**, who re-runs the two greps below before authorising
  S2. They are written down so that check is mechanical.
- *One job:* construct one seeded scenario in which the durable sources carry **at least one material fact
  the operator's request message does not**, and state in writing which fact that is and how the control
  run is kept blind to it.
- *Repository output:* `trials/ce-9-recovery-scenario.md` plus the seeded durable sources it needs. This
  scenario is also R-3's seed, so it is built to survive the build (§7.5).
- *Evidence capable of failing:* the seeded fact is greppable in the durable sources and **absent** from
  the request text — shown by both greps, one hit and one miss. If the fact appears in the request, the
  instrument is broken and the session has failed, not succeeded.
- *Exit:* the scenario exists and its blind-control property is demonstrated.
- *Stop:* if no material fact can be seeded that the request would not naturally carry, stop — CE-9 may
  not be measurable as written, and that is a specification finding, not something to work around.
- *Next:* hand to the operator to run S2 with Codex.

**Session S2 — the carriage probe trial (operator-driven, Codex)**

*What this session answers, and what it must not.* U-1 is a question about **mechanism**: does an
instruction written into a candidate file reliably reach a fresh Codex thread and change what it does? It
is **not** a question about which CE behaviours the thread exhibits. Answering the second here would make
Phase 2's red runs impossible — the candidate cannot both carry CE-1…CE-16 and be missing them (§5.2, *a
bootstrap that cannot fail*).

*The construction that keeps them apart — the carriage probe.* The candidate contains **one probe
instruction that is not any of CE-1…CE-17** and that a fresh thread would not follow by default:

> Under this carriage, end every brief with a section named `Carriage check`, listing — in the order you
> opened them — the repository files you opened while preparing it.

The probe is behaviour-shaped rather than a magic string: satisfying it requires the thread to *act* on
the instruction, and its content is checkable against reality (do those files exist, and are they the ones
the scenario makes relevant?). A string the thread could echo would prove only that it read the file.

*What the candidate carries — mechanism, and nothing else.* S2 tests **one file and no alternative**:
`trials/candidate/SKILL.md`, holding the probe text **inline, in its own body**. There is no second
carriage and no referenced instruction file, because §4.4 fixes the Phase 2 candidate at exactly one file
and any indirection branch would end the session with two.

**That file mentions Context Engineering, CE-1…CE-17 and the specification nowhere.** Earlier drafts of
this session distinguished two carriages by *content* — one referencing the specification, one carrying a
compressed behavioural checklist — which contradicted the requirement that the survivor be behaviourally
empty and would have made S3's red run invalid. A later draft replaced that with an indirect-versus-inline
competition; it fixed the contamination but broke the one-file invariant, because an indirect winner leaves
a pointer file plus the file it points at. A single inline candidate is the construction that holds both.

*What this drops, stated rather than left implicit.* The plan no longer tests whether an instruction
survives **one level of indirection**. That question is not answered anywhere in this build. Inline is what
the one-file constraint permits, so indirection is untested here, not ruled out — a later runtime design
that wants it must prove it then.

- *Inputs:* S1's scenario; the one candidate file.
- *Actors:* **author — Claude**, which writes that file before any thread runs; it is a fixture, built the
  way S1 builds its scenario. Lead for the runs — the operator, driving two fresh Codex
  threads. Observer — **Claude**, which wrote none of the *briefs*: it reads the outputs, applies the
  probe check, and verifies the listed files exist and are the scenario's. Authoring the instrument and
  judging Codex's output are not the same output, so the observer independence §7.0 requires holds.
- *One job:* determine whether an inline candidate delivers an instruction to a fresh thread, using the
  probe and a negative control.
- *How it is installed and isolated:* **it is not installed.** It sits under `trials/candidate/`,
  outside `.agents/skills/`, so Codex's ordinary skill discovery cannot reach it and no live session
  can pick it up by accident. For the probe run the operator points a fresh Codex thread at that file
  explicitly, by path. The live `.agents/skills/work-loop-v2/SKILL.md` is not touched in this phase —
  `git diff` on it must be empty at S2's exit, and that is part of the evidence.
- *What this construction cannot answer, stated so the result is not over-read:* because the candidate
  is not installed, S2 answers only that an instruction reaching an **explicitly named** file is acted on.
  It does **not** show that the same instruction is picked up through
  ordinary skill discovery once installed. That half of U-1 is answered by S8b's pre/post invocation at
  the live entrypoint, which is the first run where the candidate is installed — and it is why S8b's
  behavioural evidence is required and its structural checks are explicitly not sufficient. A candidate
  that passes S2 and then fails S8b's pre/post pair is a Phase 3 finding, not a Phase 1 one.
- *Repository output:* `trials/carriage-trial-record.md`, and `trials/candidate/SKILL.md` — the validated
  candidate **with the probe removed**, so what enters Phase 2 has no behavioural content at all. **Phase
  2's slices write their families into that same single file**, under every outcome; there is no second
  file for a family to go into and none may be created. The trial record states the result in one line,
  because every later slice depends on it.
- *Evidence capable of failing — two runs, one of which must fail:*
  1. **Negative control.** A fresh thread on the same scenario with **no candidate**. The `Carriage check`
     section must be **absent**. If it appears, the probe is not measuring the candidate, the instrument is
     broken, and the session has failed rather than succeeded.
  2. **The candidate.** The section appears, and the files it names exist and match the scenario.

  Plus: `git diff -- .agents/skills/work-loop-v2/SKILL.md` returns empty, proving nothing was installed.
  Plus: `trials/candidate/` contains **exactly one file**, `SKILL.md`. A second file there fails the
  session, whatever it contains.

  **What emptiness means here, and what it does not — because the grep is not enough.**
  `grep -c 'CE-' trials/candidate/SKILL.md` returning **0** at exit proves only that no CE *identifier* is
  present; a paraphrase would pass it. It is a necessary check, not a sufficient one. Emptiness is
  established **by construction** — the candidate is authored to hold the probe and the mechanism and
  nothing else.

  **That is textual emptiness, and it is all S2 can establish.** The candidate is a revision of the live
  Codex Work Loop skill, so a thread reading it also reads the skill and the executable core, which
  already produce some of the specified results on their own (§4.4). **Carrying no explicit CE instruction
  therefore does not make the behaviour absent**, and S2 must not be read as claiming it does.

  **So a clean pre-revision result in a later slice is not this session's failure.** A case that comes back
  green before its family is written is **baseline green** and is handled under §4.4 — kept as recorded,
  protected from relabelling, and required not to regress. Phase 2 returns to S2 only on evidence of actual
  **contamination**: that the candidate's own text, or the seeded input, carried the behaviour in. A green
  line where red was expected is not that evidence.
- *Exit:* the negative control is clean, the candidate delivers the probe, and it survives as
  `trials/candidate/SKILL.md` with the probe stripped — **or** inline delivery fails and U-1 escalates to
  the operator. **No branch adds an indirection file or a second carriage.** If inline does not deliver,
  the session escalates rather than reaching for a different packaging.
- *What survives:* **exactly one file** — `trials/candidate/SKILL.md`. Nothing is kept alongside it: a
  retained alternative would be a second document describing the same thing, which is the FP-4 shape and,
  held as a record of what was rejected, is the plan-history machinery §7 prohibits. The trial record
  states the outcome and why; that is the only thing preserved about the trial itself.
- *Stop:* if the trial cannot be run because Codex cannot reach the repository as assumed, stop — that is
  a transport fact (C-3) and it belongs to the operator, not to this capability.
- *Next:* Phase 2, Slice A, with the validated candidate stated.

*Capacity: one Claude session and one operator-driven Codex session of two threads.*

**Phase 1 exit:** U-1 answered by trial and U-2 answered by a working instrument; one named candidate
exists at `trials/candidate/SKILL.md` and is **the only file in `trials/candidate/`**; and that candidate
contains **the carriage mechanism and no explicit CE instruction** — which is what makes a Phase 2 slice's
pre-revision run a real measurement of the starting point rather than a formality. It does **not**
establish that any behaviour is absent (§4.4); which cases start red is what the pre-revision run finds
out.

---

### Phase 2 — The isolated proof, in thin slices

Each slice is one complete observable result, sized for a fresh session. **The cycle is red–green against
the candidate (§4.4):**

```
run the constructed failing case against the CURRENT candidate  → record the result, per case
revise the candidate to carry this family's behaviour           → one file, one family
run the SAME case against the REVISED candidate                 → record the result, per case
```

Both runs are Codex runs on the same seeded input, so the operator drives them; the only variable between
them is the candidate revision. **The pre-revision run is recorded per case, not assumed red.** Phase 1
exits with a carriage carrying no explicit family instruction, so a case the live skill and the executable
core do not already cover has no reason to pass — that is the case whose green the revision can be shown
to have caused. A case that comes back green before the revision is **baseline green** (§4.4): it is kept
as recorded, the revision must not regress it, and neither the seed nor the label may be changed to turn
it red.

**A slice proves causality only for the cases it can show failing first** — for those, the red record is
what makes the later green mean anything; without it the slice has shown the behaviour is present, not
that its absence was detectable. A slice whose every case comes back green before the revision has proved
no causality at all, and the honest report of that is a finding about the starting point handed back to
Codex, not a proof written up as one. No slice builds a layer for a later slice to use, and no
slice touches the live `.agents/skills/work-loop-v2/SKILL.md`: `git diff` on it is empty throughout Phase
2, and S8b is the first session that changes it.

**Session S3 — Slice A · one pass, one artifact** *(CE-17 clauses 1–2, CE-1, CE-2, CE-3, CE-15)*
- *Inputs:* the validated candidate; spec §2, §4.1, Family 1, CE-15.
- *Actors:* lead — the operator, driving Codex; observer — Claude.
- *One job:* demonstrate that one objective plus material yields exactly one artifact in one pass, that
  only a genuine decision returns to the operator, and that a resolvable unknown becomes a discovery unit
  rather than a refusal.
- *Candidate change:* the candidate gains Family 1 and CE-15 — the single-pass rule, the §4.1 output
  contract, and the three-sentence orientation. Nothing else. **Unchanged by the correction below:** a
  behaviour that is already baseline green is still written into the candidate explicitly, because the
  slice's job is to put the behaviour into the candidate's own text, not to rely on the live skill
  continuing to produce it.
- *Constructed failing cases:* a load-bearing file whose location is unstated but discoverable, where
  asking the operator where it is fails (CE-1); material carrying both a resolvable repository question
  and a genuine intent question, where both returning fails (CE-2); a load-bearing unknown answerable by
  inspection, where a refusal or a guess fails (CE-3); a run that produces a separate operator-orientation
  document, which fails on the second document (CE-15); and a preparation loop or context interview for
  information the pass could derive (CE-17 clause 1).
- *Repository output:* `trials/candidate/SKILL.md` (revised) **and** `trials/slice-a-evidence.md`.
- *Evidence capable of failing:* the pre-revision run first — the same seeded input against the
  pre-revision candidate, its result recorded **per case**. That run has been performed, and it came back
  **four green and one red**: CE-1, CE-2/CE-17 clause 2, CE-15 and CE-17 clause 1 were already satisfied
  before the revision; **CE-3 was red**. Those four are **baseline green** (§4.4), and the recorded run is
  retained as their evidence; it may not be relabelled red, discarded, or re-seeded to widen the red set.
  **CE-3 is the case this slice must show red-then-green**, with both primary outputs inspectable. Then,
  against the revised candidate: a count of preparation passes (target 1); a count of operator context
  actions **beyond stating the objective** (target 0, excluding genuine decisions — the same wording S3b
  and S11 use, so the three counts compare); the count of artifacts describing the unit (must be 1); the
  orientation's sentence count (≤3). **CE-3 green with no recorded CE-3 red fails the slice** — and so does
  an evidence record presenting all five behaviours as caused by the revision, which is the §4.4 overclaim.
- *Exit:* against the revised candidate and the same seeded input, all five behaviours pass; **CE-3 is
  demonstrated red-then-green** with the red and green primary outputs both inspectable; the four
  baseline-green behaviours are **still green — no regression**; and all four counts meet the targets above.
- *Stop:* if the pass terminates in more than one artifact and the cause is the carriage, return to Phase 1
  rather than adding a reconciliation step.
- *Next:* S3b.

**Session S3b — the shadow slice · early feedback on a real objective**

*Why here.* S3 leaves the smallest coherent behaviour kernel in the candidate: one pass, one brief, the
§4.1 interface, nothing derivable returned. That is the earliest point at which a brief is usable at all.
Running one genuine objective through it now buys feedback on context quality, operator effort and handoff
friction while four slices of design decisions are still changeable. Waiting until Phase 4 buys the same
feedback after they are not.

*What it is not.* **It is not the integrated proof and may never be reported as one** (§5.2). The live
entrypoints are untouched, so the operator triggers Claude by hand — which is exactly the ferrying clause 3
forbids. It authorises nothing, and it permits no early wiring.

- *Inputs:* the S3 candidate; one **genuine Standard-lane unit** the operator wanted done anyway — low
  risk, but **not small and reversible**, and not part of this build.

  **Why it must be a Standard unit and not Direct Work.** An earlier version of this session specified a
  *small, reversible* objective and called its output ordinary Direct Work. That contradicts core §2:
  small and reversible work gets **no state file and no brief**, so running a brief-producing capability
  over it would have measured a path that is not supposed to exist, and inflated the result. The unit
  S3b uses is therefore admitted to the loop the ordinary way — with the **named reason core §2 requires**
  written into its own state file at open, chosen from core §2's list, not from this build's convenience.
  Low risk is a property of the unit's blast radius; it is not the admission test.
- *Actors:* lead — the operator (drives Codex) and Claude (does the real work from the brief). Observer —
  Claude reports whether the brief was sufficient to start without asking back; the operator reports their
  own effort. Neither judges the other's half.
- *One job:* run one real objective end to end in shadow form, and record what the brief was actually like
  to work from.
- *Repository output:* `trials/shadow-slice-record.md` — **and nothing else belonging to this build.**
  The genuine unit owns everything of its own: its state file at `logs/work-loop/{its-own-task-id}.md`,
  its scope, its evidence, and its commits, none of which are this plan's. **Two separations, both
  checkable:** the real unit's changes and the shadow record are never in the same commit, and the real
  unit's state file is never edited by this build. A commit carrying both fails the session — that is how
  an unrelated implementation gets smuggled into the build's evidence.
- *Evidence capable of failing:* three counts, each able to come back badly — the number of times Claude
  had to ask a question the brief should have answered (target 0); the number of operator actions beyond
  stating the objective and triggering Claude (target 0, excluding genuine decisions); and Claude's stated
  verdict on whether the brief was sufficient to begin correct work, which is allowed to be *no*. A record
  with no negative findings and no stated attempt to find any fails the session.
- *Exit:* the run happened, the three counts are recorded, and the record states explicitly that this is
  not the integrated proof.
- *Consequence for the remaining build:* findings enter S4–S7 as **constraints on how the remaining
  families are written**. They do not become new behaviours, new sessions, or new checks. A finding that
  cannot be absorbed that way is a specification finding and escalates.
- *Stop:* if the brief is not usable at all — Claude cannot begin correct work from it — stop and return
  to Phase 1's carriage question rather than adding families to a carriage that does not deliver.
- *Next:* S4.

**Session S4 — Slice B · authority integrity** *(CE-4 A–D, CE-5, CE-6 A–C)*
- *Inputs:* spec §5 in full, Family 2; S3b's findings as constraints.
- *Actors:* lead — the operator, driving Codex; observer — Claude.
- *One job:* demonstrate that governing authority follows semantic role, that a draft does not govern, that
  an approval bound only to a filename fails on that shape alone, that a materially edited approved plan
  returns to draft, and that demotion requires a citation.
- *Candidate change:* the candidate gains Family 2 — the semantic hierarchy, draft-does-not-govern,
  content-bound approval, material-edit demotion, and citation-required supersession.
- *Constructed failing cases — one seeded condition per subcase, because a subcase named in the header and
  not separately seeded is not covered:*
  - **CE-4 A** · a stale plan at a high-authority path, contradicted by a later dated operator decision in
    the seeded decisions source. *Fails* if the brief carries the plan's requirement.
  - **CE-4 B** · a Codex-authored plan draft the operator never approved. *Fails* if it is used as
    governing direction or presented as approved.
  - **CE-4 C** · an approval line naming **only the file**, with nothing identifying which content was
    approved. *Fails* on that shape alone — this needs its own seeded plan, because the case is about the
    approval record's form, not about any edit made to it.
  - **CE-4 D** · one editorial and one material edit applied to an approved plan **without touching the
    approval line**. *Passes* if the editorial one stays governing and the material one returns to draft;
    *fails* if both are carried as governing.
  - **CE-5** · four seeded items in one run — a non-authoritative imperative file, preserved speculative
    material, a casual operator message, a genuine decision. *Fails* if any of the first three appears as
    a requirement; the test is role accuracy, with only the decision carrying authority.
  - **CE-6 A** · a source that reads as stale but carries **no** supersession evidence. *Fails* if it is
    silently demoted or dropped; *passes* only if carried as a surfaced conflict or an unknown. This is
    the case an earlier version of this session named in its header and never seeded.
  - **CE-6 B** · a second plan document describing the same seeded project. *Fails* if two plans are left
    able to appear current, or an amendment is applied silently as governing.
  - **CE-6 C** · verified evidence falsifying a factual premise of the approved plan. *Fails* if the brief
    re-aims the work at what the evidence suggests instead of surfacing the conflict.
- *Repository output:* `trials/candidate/SKILL.md` (revised); `trials/slice-b-evidence.md`; the seeded plan
  fixtures under `trials/`, each carrying §4.4's `FIXTURE —` first line. These fixtures are R-2's seed and
  are built to survive (§7.5).
- *Evidence capable of failing:* the red run first, against the pre-revision candidate. Then, against the
  revised candidate: the four items each classified to their semantic role, with only the decision carrying
  authority; the count of plans presented as current (must be 1); and the conflict section present for CE-6
  case C, with the required outcome still tracking approved intent.
- *Exit:* all three behaviours demonstrated red-then-green.
- *Stop:* CE-6 B **requires** a second plan document, so seeding one is the test, not a breach — but only
  **inside the seeded scenario**. If a plan fixture cannot be built without a second plan appearing
  current in the repository's own plan space, stop: that would reproduce the failure in the live
  repository while testing for it. §4.4's fixture rules — the `FIXTURE —` first line and placement no real
  discovery reaches — are what keep the two spaces apart, and S7's fixture-escape grep is what proves they
  stayed apart.
- *Next:* S5.

**Session S5 — Slice C · claims, absence, and recovery** *(CE-7, CE-8, CE-9 A–C)*
- *Inputs:* S1's scenario; spec §3.5, §5.7 *Current state*, Family 3.
- *Actors:* lead — the operator, driving Codex. Observer — **Claude**, and for CE-7 specifically Claude's
  role is the ordinary Work Loop premise check (command Step 2) run against the trial brief: the seeded
  claim coming back marked `FALSE` is the confirming evidence, not a contradiction. No extra reviewer is
  added — this is the check Claude already performs on every brief.
- *One job:* demonstrate that load-bearing repository claims leave as claims naming surface and pattern,
  that discovery expansions each name one of four reasons, and that a fresh thread recovers the unit from
  durable sources.
- *Candidate change:* the candidate gains Family 3 — claims-not-facts, absence claims naming surface and
  pattern, and relevance-gated discovery with the four expansion reasons.
- *Constructed failing cases:* material asserting a file holds content at a line where it does not, which
  fails if it leaves as a fact (CE-7); *"nothing consumes this file"* repeated with no surface named, which
  fails on the missing surface and pattern (CE-8); an irrelevant repository area seeded into the discovery
  set, a fresh thread drafting from memory, and a scenario with no current-state source (CE-9 A–C).
- *Repository output:* `trials/candidate/SKILL.md` (revised); `trials/slice-c-evidence.md` — including the
  inspected-source set with each expansion mapped to its reason; any current-state fixture, `FIXTURE —`
  marked.
- *Evidence capable of failing:* the red run first. Then the paired memory-only control from S1. If the two
  briefs are indistinguishable, the trial proved nothing and the record must say so rather than claiming
  recovery.
- *Exit:* CE-7, CE-8 and all three CE-9 cases demonstrated red-then-green, with the control distinguishing.
- *Stop:* if the control cannot be kept blind in practice, stop and report CE-9 as unmeasured. Do **not**
  substitute a weaker control and call it recovery.
- *Next:* S6.

**Session S6 — Slice D · framing, bounding, attribution, selection** *(CE-10, CE-11, CE-12, CE-13, CE-14)*
- *Inputs:* spec §3.2, §5.6, Families 4 and 5.
- *Actors:* lead — the operator, driving Codex; observer — Claude.
- *One job:* demonstrate that plan alignment is a field and not a gate, that the unit is bounded with
  held-back work named, that Codex's technical preferences stay attributed proposals, that
  uncertain-relevance material is preserved visibly, and that material reclassification is disclosed
  without a discard ledger.
- *Candidate change:* the candidate gains Families 4 and 5 — the inline plan-alignment field, unit bounding
  with named held-back work, attributed Codex boundaries and non-prescription, three-way relevance, and
  reclassification disclosure.
- *Constructed failing cases — one seeded condition per subcase:*
  - **CE-10 A** · an objective that cannot be reconciled with the approved plan. *Fails* if the brief
    proceeds silently.
  - **CE-10 B** · work that **deviates** from the approved canonical plan. *Fails* if the deviation is
    applied silently; *passes* if the brief either shows alignment or surfaces the proposed deviation
    rather than applying it. An earlier version of this session labelled the no-gate check as case B; that
    check is CE-10's *evidence* requirement — zero additional operator-visible stages — and it is kept
    below, correctly labelled. It is not a substitute for seeding a deviation.
  - **CE-11 A** · an objective plainly spanning several units. *Fails* if the brief is unbounded, or is
    bounded silently with nothing naming what was held back.
  - **CE-11 B** · an objective with two load-bearing parts, one inconvenient. *Fails* if the brief silently
    covers only the convenient part; the seeded second part is what the evidence looks for.
  - **CE-12 A** · an exclusion Codex added on its own judgment. *Fails* if it appears without a reason, or
    in the operator's voice; *passes* if marked as Codex's framing decision with its reason attached.
  - **CE-12 B** · a unit where Codex holds a clear design preference no governing authority has settled.
    *Fails* if a "required" section names the preferred mechanism.
  - **CE-13 A/B/C** · over-inclusion of a stale speculative document; a load-bearing constraint buried in
    low-value material disappearing entirely; an uncertain-relevance item silently promoted or erased.
  - **CE-14** · a proposal demoted with no disclosure — and its opposite error, a complete discard ledger.
- *Repository output:* `trials/candidate/SKILL.md` (revised) **and** `trials/slice-d-evidence.md`. The
  seeded material here is R-4's seed and is built to survive (§7.5).
- *Evidence capable of failing:* the red run first. Then, against the revised candidate: every technical
  element traced to a cited decision, an attributed proposal, or an evidence requirement; the seeded second
  objective part present in the required outcome; the disclosure section checked against the four kinds;
  and **zero** new operator-visible stages or gates introduced by the alignment justification.
- *Exit:* all five behaviours demonstrated red-then-green.
- *Stop:* if satisfying CE-10 appears to need a separate alignment check, stop — that is failing case A,
  not a design need.
- *Next:* S7.

**Session S7 — Slice E · non-accretion, and the first grouped regression** *(CE-16 A–B; CE-15 re-confirmed)*
- *Inputs:* spec §5.7, §7, CE-16; §7.1's five cases; all prior slice records.
- *Actors:* lead — the operator, driving Codex; observer — Claude.
- *One job:* two things, in order. First, run a sequence of **routine** invocations — no new operator
  input, no approval, no materially changed understanding — and show the capability writes nothing durable.
  Second, run the full grouped regression against the cumulative candidate.
- *Candidate change:* **none.** S7 measures the candidate as it stands; a revision here would mean an
  earlier slice left a behaviour incomplete, and that is a finding, not a fix to fold in silently.
- *Constructed failing cases:* new machinery added — a context-QC pass, an alignment gate, a review stage,
  a new document type, an archive, a context-pack lifecycle, a decision register, a provenance ledger, an
  approval artifact, a plan-history log, a plan copy, or a second state system (CE-16 A). A routine
  invocation writing a context file, discovery log, run record or session note (CE-16 B).
- *Repository output:* `trials/slice-e-evidence.md`, including the regression's per-case result.
- *Evidence capable of failing:* `git status` before and after the run, plus a file-count diff of the
  repository. Target: **zero net new durable files**, and zero additional operator-visible stages, gates,
  review passes or persistent artifacts beyond the brief and §5.7's three categories. One file appearing is
  a failure, and the trial records must not be counted as the capability's output — they are this build's
  development evidence, and the run must be constructed so that distinction is observable. **Plus the
  fixture-escape check (§4.4 rule 3):** grep the repository for the `FIXTURE —` marker outside `trials/`;
  any hit fails the slice. **Plus the grouped regression:** all five cases pass against the cumulative
  candidate. A case that passed in its own slice and fails here is a real finding — a later revision broke
  an earlier behaviour, which is exactly what the regression exists to catch.
- *Exit:* the run is clean, no fixture escaped, CE-15's artifact count of one is re-confirmed under real
  conditions, and R-1…R-5 all pass against the cumulative candidate.
- *Stop:* if a routine invocation genuinely needs to write something durable, stop and escalate — that is a
  specification finding, not an implementation liberty.
- *Next:* Phase 3, subject to the progression decision below.

**Phase 2 exit:** every behaviour except CE-17 clause 3 **demonstrated against its constructed failing
case** — **red-then-green where the pre-revision run was red**, and **preserved baseline evidence plus no
regression where it was already green** (§4.4), with each behaviour recorded as one or the other and
neither presented as the other; the grouped regression green against the cumulative candidate; one named
candidate at `trials/candidate/SKILL.md`; the live skill file still unmodified (`git diff` empty); and one
real objective run in shadow with its friction recorded. **Then an explicit progression decision by
Codex**, stating in writing which proof has been obtained and that clause 3 remains owed. Phase 3 does not
start on momentum.

*Capacity: six sessions; assume one behaviour family per session and do not compress two families to save
one session.*

---

### Phase 3 — Classify every entrypoint, wire the relevant ones, prove the seam, then one review

**Session S8a — the entrypoint classification**
- *Inputs:* a fresh symlink-following scan (`find -L`) of every access path to the Claude command, the
  Codex skill and Work Loop v1; **O-3's answer**, which decides what population the test is applied to.
- *Actors:* lead Claude; observer — **the operator**, who re-runs the stated command for each row and
  confirms the recorded O-3 reading is the one they chose.
- *One job:* classify **every** access path as *relevant* or *not relevant*, each with evidence. Nothing is
  left unclassified and nothing is waived.
- *The order is load-bearing: the operator's reading sets the population, then the test runs inside it.*
  O-3 is applied **first**. Reading A puts only v0.2-generation paths in the population; reading B puts
  every path through which plan-dependent Work Loop work is opened or continued today, whatever its
  generation. A path the chosen reading includes **cannot** be classified out by the test below. Getting
  this order wrong is what an earlier version of this session did, and it silently deleted reading B.
- *The relevance test, stated once, and it is one condition:* a path in the population is **relevant** if
  **plan-dependent briefing or continuation actually happens through it**. That is the whole test. It is
  generation-neutral by construction, because it describes behaviour rather than architecture.
- *Two further facts are recorded per path — and they decide **how** it gets wired, never **whether** it
  is relevant:* whether a Codex skill is discoverable from it, and which state directory it uses
  (`logs/work-loop/`, `logs/loop/`, or none). An earlier version made these two conditions of relevance,
  conjoined with the first. That was wrong twice over: it encoded v2's architecture as the definition of
  relevance, and — as §4.2 records — v1 in fact **has** a Codex skill, so the conjunction would have
  excluded v1 on its state directory alone, which is a naming difference, not a reason to leave a
  plan-dependent entrypoint unwired.
- *The test's limit, stated equally plainly:* relevance establishes a fact about behaviour. It does not
  establish **scope** — that is O-3, settled by the operator before this session runs. If O-3 is
  unanswered, S8a stops rather than picking the reading that shortens the work.
- *Repository output:* `trials/entrypoint-classification.md` — one row per access path: path, the O-3
  reading applied, whether plan-dependent briefing or continuation happens through it (with the observed
  evidence), the two wiring-shape facts, the verdict, and the command whose output produced it.
- *Evidence capable of failing:* every row's conditions are re-derivable by running the stated command. A
  row whose verdict does not follow from its own conditions and the recorded O-3 reading fails. **A path
  with no row fails the session** — the scan's output and the table must have the same row count.
- *Exit:* every access path carries a verdict backed by an observed condition and a named O-3 reading.
- *Stop:* if a path's relevance genuinely cannot be settled by inspection, it counts as **relevant** — the
  fail-safe direction — and either gets wired or blocks adoption. Do not resolve an ambiguous path toward
  "not relevant" because that is the reading that lets the work continue.
- *Next:* S8b.

> **Why this is a session and not a line in S8b.** An earlier version let uncovered entrypoints be named as
> limitations at Phase 3's exit. That inverted CE-17: the specification makes wiring *every relevant
> entrypoint* an adoption **condition**, not a preference to be traded away. A limitation can record
> something unmeasured; it cannot excuse an unmet condition.

**Session S8b — the seam edit**
- *Inputs:* S8a's classification; the reverted candidate design; the Phase 2 candidate
  (`trials/candidate/SKILL.md`); §4.5's no-ferry surface; F-6, F-7, F-9 re-checked.
- *Actors:* lead Claude, which makes the edit and runs the structural checks. **Both halves of the pre/post
  pair are driven by the operator through Codex** — the pre-run because only a fresh Codex thread can
  produce the failing brief, and the post-run for exactly the same reason. Claude cannot invoke either.
  Observer — Claude for the structural checks; the operator reports what their two runs produced.
- *One job:* wire **every path S8a classified relevant**. For the canonical files that means the Codex
  skill's two plan-dependent sites and the executable core's orientation step; the Claude command changes
  only insofar as a richer brief needs consuming.
- *What it must reuse and must not build:* §4.5 names the whole delivery path — Codex writes the brief into
  `logs/work-loop/{task-id}.md`, Claude resolves and opens the same path, `task:` checks identity, `turn:`
  checks whose move it is, and the operator's only action is the trigger line. **No delivery file, queue,
  handoff document, second state system or turn mechanism is created.** A diff that adds one fails the
  session.
- *Repository output — and it depends on the O-3 reading, which is the point:*
  - **Under either reading:** edits to `.agents/skills/work-loop-v2/SKILL.md`,
    `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, and `.claude/commands/work-loop-v2.md`.
    **No new file.** `trials/candidate/` is deleted in this session — its content has landed.
  - **Under reading B additionally, and this is not optional:** v1 is in the population and S8a will
    classify it relevant, because §4.2 records that it authors its own plan-dependent brief. The operator
    then chooses **one** of two routes at S8a's close, and the choice is recorded there:
    **wire** — the allowed outputs extend to `.claude/commands/work-loop.md`,
    `.agents/skills/work-loop/SKILL.md` and `docs/work-loop.md`, and v1 gets the same pre/post behavioural
    evidence below, run against v1's own entrypoint; or **retire** — S8b makes **no** v1 edit and
    **stops**, and adoption stays blocked under Phase 6 condition 2 until mission Step 8's retirement
    actually executes. Retirement is that mission's work, not this plan's, and this plan does not sequence
    it — it only records that adoption cannot complete before one of the two routes does.
  - **An earlier version of this session listed only the three v2 files.** That made reading B
    unexecutable: the plan promised "wire or retire v1" and had no session able to do either.
- *Evidence capable of failing — behavioural first, structural second.* The structural checks alone are
  not sufficient: greps, counts and a clean diff can all pass while the entrypoint still produces the
  wrong brief.
  1. **The constructed pre/post invocation at the real entrypoint.** Take one seeded request. Run it
     against the live entrypoint **before** the edit: it must fail to exhibit the required CE behaviour,
     and that failure is recorded. Run the **same** request after the edit: it must exhibit it. A post-run
     that passes with no recorded pre-run failure fails the session — the same red-run rule Phase 2 works
     under, applied at the seam.
  2. **Direct Work, as a fail-capable check.** Construct a small reversible fix and run it through the
     wired entrypoint. It must stay Direct Work: **no state file appears** in `logs/work-loop/`. The check
     is the absence of the file, observed — not an assertion that the bypass is intact.
  3. **False-premise refusal, as a fail-capable check.** Construct a state file whose brief carries one
     deliberately false claim, run it, and confirm the hand-back happens **and the named target file is
     unmodified**. The fixture pair for this already exists in the acceptance harness's Slice 1 shape;
     reuse the construction, not the harness.
  4. **Then** the structural checks: F-5's greps re-run (zero before, non-zero at named surfaces after);
     core §3 step 3's item count moved from 7 toward §4.1's semantic interface; the state file's five-field
     ceiling **unchanged**, which F-9 says is possible because the brief already sits outside it. A diff
     touching the state schema fails.
- *Exit:* every relevant path is wired, all three behavioural checks passed with their failing runs
  recorded, and the diff contains nothing unrelated.
- *Exit status, 2026-08-04 — **not met**.* S8b closed with all three behavioural checks unmet
  (`../../../logs/work-loop/context-engineering-s8b-seam-proof.md`). The exit condition above is unchanged
  and is **not** treated as satisfied; progression past it runs under §7.2 and under nothing else.
- *Stop:* if the edit cannot be made without expanding the state schema, adding a fourth durable category,
  or building any part of the delivery path §4.5 shows already exists, stop — the integration has stopped
  being a seam edit and the operator decides whether it proceeds at all.
- *Next:* S9.

**Session S9 — one fresh-context candidate review**
- *Inputs:* the candidate, **named by its exact Git commit**; the specification; this plan; and S8b's
  behavioural evidence — **which does not exist** (§7.2). Under the deviation that input is replaced by
  S8b's closing record and the retained pre-integration red run, and the reviewer is **told** the seam is
  unproved rather than left to infer it from a gap in the pack.
- *Actors:* lead — an independent reviewer with fresh context, which is not the party that wrote the
  candidate. This is the one review the build gets; it replaces nothing and adds nothing. Observer —
  **Claude**, whose check is narrow and mechanical: the review names the exact commit it examined, and the
  candidate has not changed since. That is a staleness check on the review, not a review of the review.
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
> reasons about it — competently, and still without ever invoking the thing. Reversing the order would put
> the most persuasive evidence (a careful reviewer's approval) in front of the only evidence that can
> actually fail (the seam refusing to work), which is how a candidate ships looking proved.
>
> **Under §7.2 this ordering is deviated from once, by operator decision.** S9 may open with S8b's three
> checks unmet. The reasoning above is not withdrawn — it is precisely what the deviation costs. A review
> that runs before the behavioural evidence cannot supply it, so S9's acceptance says the candidate *reads*
> correctly and never that the seam *works*, and its output is non-adoption evidence while condition 4 is
> unmet.

**Session S10 — the one bounded correction** *(only if S9 produced findings)*
- *Inputs:* the frozen findings.
- *Actors:* lead Claude; observer — **Codex**, which owns the closure check's two questions (core §3
  step 5). The questions are what it checks against; they are not themselves the observer.
- *One job:* correct exactly those. Anything newly noticed is recorded as a deferral and left unimplemented.
- *Repository output:* the corrected files.
- *Evidence capable of failing:* the closure check asks two questions only — are the frozen findings
  resolved, and did the correction break something. A third question means the round has escaped its frame.
  **Plus** the affected cases of the grouped regression where the correction touched runtime behaviour:
  which cases were re-run and which were skipped, with the reason, is part of the record.
- *Exit:* closure, or core §3's post-correction menu chosen **once** on value and risk. That is the
  existing menu, not a new lifecycle: accept as a written limitation · one final tightly-bounded fix ·
  revert · reframe · stop (C-9).
- *Stop:* menu choices that are really risk acceptance go to the operator.
- *Next:* Phase 4.

**Phase 3 exit — three conditions, all required:**

1. **Every access path carries a verdict** from S8a, each backed by an observed condition and the O-3
   reading applied.
2. **Every path classified relevant is wired.** There is no "named as a limitation" alternative. An
   uncovered relevant path does not exit Phase 3 and does not reach an adoption claim.
3. **The seam is proved behaviourally** — S8b's pre/post invocation, plus the Direct Work and
   false-premise checks, each with its failing run recorded — and the candidate review has run after that
   evidence exists.

**Status of condition 3, 2026-08-04: not met, and deviated from once under §7.2.** Phase 3 is exited for
**progression** purposes only. Condition 3 stays outstanding, keeps its full force as Phase 6's adoption
condition 4, and no downstream session may report Phase 3 as cleanly exited. Conditions 1 and 2 are
unaffected by the deviation and are assessed on their own evidence.

---

### Phase 4 — The integrated proof

**Entry, 2026-08-04.** Phase 3's condition 3 is unmet, so Phase 4 is entered under §7.2's deviation and
not on a clean Phase 3 exit. S11's result is **non-adoption evidence** while the seam-proof debt stands,
whatever it demonstrates about clause 3 — obtaining the integrated proof satisfies condition 1 and leaves
condition 4 exactly where it was.

**Session S11 — the two-model trial (operator-driven)**
- *Inputs:* the accepted candidate; one **genuine** unit of work the operator wanted done anyway. A
  manufactured unit tests nothing.
- *Actors:* lead — the operator, Codex and Claude together. Observer — Claude records the run; the operator
  counts their own actions, because only they know what they did.
- *One job:* the operator gives Codex an objective once. Codex prepares and delivers a brief. Claude picks
  it up and works from it. The operator carries no context.
- *Repository output:* `trials/integrated-proof-record.md`, plus whatever the genuine unit itself produces.
- *Evidence capable of failing — two counts, kept apart:*
  1. **Context actions**, from objective to Claude's first action. Target **zero** beyond stating the
     objective, plus any genuine decision. **Any** hand-carrying, restating or assembling of the brief
     fails clause 3 outright.
  2. **Trigger actions**, counted and reported separately. One if exactly one task was open when Claude
     was invoked; **two** if more than one was, because the live command then requires the operator to
     name the task as well (§4.5). The record states **how many `turn: claude` files existed at the moment
     of invocation**, so the number is derived from an observed repository state rather than asserted, and
     a run with several tasks open is not silently reported as a one-action run.

  Both counts appear in the record. The record also states which of the two proofs was obtained, and cites
  §4.5's reading of the trigger — that typing `/work-loop-v2`, and naming which task, carry the turn and
  not the context — so neither count can be read two ways. **A trigger count of two does not fail clause
  3**; concealing it would.
- *Exit:* clause 3 demonstrated, or honestly recorded as not obtained.
- *Stop:* if a fresh Claude subagent is proposed as a substitute for a fresh Codex thread, stop — the
  specification names that substitution as a failing case, and it is how the previous attempt went wrong.
- *Next:* Phase 5. **Not the adoption decision** — the candidate is not yet in the state adoption would
  apply to.

**Phase 4 exit:** clause 3 demonstrated or recorded as owed, with the operator context-action count on
record.

---

### Phase 5 — Harden from evidence, reprove what changed

**Entry, 2026-08-04.** As Phase 4 — entered under §7.2, and its hardening evidence is non-adoption
evidence while the seam-proof debt stands. One consequence is worth stating here rather than discovering
later: if a separate authorised task obtains S8b's three checks and a Phase 5 fix then touches the seam,
those checks are **owed again** against the changed candidate — §5.2's *proof inherited by a changed
candidate*, applied to a proof obtained out of sequence.

**Session S12**
- *Inputs:* every trial record; the friction observed in S3b and S11; §7.1's five cases.
- *Actors:* lead Claude, for the fixes, the affected reproof and the checks it can run itself. **The
  operator drives every regression case that needs a fresh Codex thread and reports what it produced** —
  which is most of §7.1's five, so this session is only partly Claude's. Observer — Claude for the fixes
  and the reproof; the operator for their own runs.
- *One job:* four things, in order. Fix demonstrated blockers under the frozen-findings discipline; re-prove
  the behaviours the fixes touched; run the full grouped regression on the final candidate; and consolidate
  the development evidence per §7.5.
- *Repository output:* the fixes; `trials/evidence-summary.md`; and the deletions §7.5 requires. **No
  successor plan document is written**, and this plan is not rewritten into a v0.2 at closure — a second
  document describing the same finished work is the FP-4 shape. The evidence summary is not that: it
  records what was proved, not what to do.
- *Evidence capable of failing:*
  1. Each fix has its own failing case, recorded red-then-green.
  2. **The affected reproof.** Every behaviour whose runtime path a fix touched is re-run against the
     changed candidate. Which behaviours those are, and which were left alone because nothing touched them,
     is stated. **A behaviour listed as proved against an earlier candidate and not re-run, where a fix
     touched its path, fails the session** (§5.2, *a proof inherited by a changed candidate*).
  3. **The full grouped regression on the final candidate** — all five cases, after the last runtime
     change. Not the affected subset: this is the run that says the shipped candidate is the proved one.
  4. **Clause 3's regression, if the hardening touched the seam.** S11 is re-run. If it did not touch the
     seam, that is stated as an observation, with the diff that shows it.
  5. The Work Loop regression set confirms the state ceiling, the Direct Work bypass, and the false-premise
     refusal still behave as before.
- *Exit:* the capability is useful, stable enough, the shipped candidate is the proved one, and the known
  limitations are written down.
- *Stop:* if a fix cannot be made without new machinery, stop and escalate — §5.2 makes that a
  falsification, not a design option.
- *Next:* Phase 6.

### 7.5 What survives the build, and what is deleted

Development evidence is not a runtime artifact, but it is also not permanent. The end state is stated here
so that "clean up later" is not what happens instead.

**Survives** — because it is reusable, and is the same kind of thing this repository already hosts (an
acceptance harness and its fixtures, F-4):

- `trials/regression/` — §7.1's five cases and the fixtures they need, including S1's CE-9 scenario, S4's
  plan fixtures and S6's seeded material. Each keeps its `FIXTURE —` first line and its
  unreachable-by-discovery placement (§4.4).
- `trials/evidence-summary.md` — one concise record of what was proved, against which candidate commit, and
  what was not.
- `trials/integrated-proof-record.md` — S11's record.

**Deleted at S12**, once the evidence summary carries their conclusions: `trials/carriage-trial-record.md`,
`trials/slice-a-evidence.md` through `trials/slice-e-evidence.md`, `trials/shadow-slice-record.md`,
`trials/entrypoint-classification.md`. `trials/candidate/` was already deleted at S8b.

**Why deleting is safe.** Git holds every one of them, and the closing record's evidence pointer names the
commits. Nothing is lost; what goes away is a folder of intermediate records a later reader would have to
reconcile against the summary — the FP-4 shape at file-count scale.

**What this is not.** Not a retention policy, not an archive lifecycle, not a register, and not a runtime
log. It is one deletion, at one named point, of files this build created for itself. No routine invocation
of the capability ever writes to `trials/`, and CE-16's zero-net-new-durable-files check (S7) is measured
against the repository outside it.

---

### Phase 6 — Assess, decide, stop

**No new session, and no new gate.** Codex's assessment here is the loop's ordinary step 5 (core §3), run
once against the final candidate — not an added review stage.

1. **Final Codex assessment.** The executive "good enough, proceed" call against the final candidate, with
   S12's reproof and regression results in front of it.
2. **The adoption decision.** Operator-owned. **Adopt** is available only when all five conditions below
   hold. Otherwise the outcome is **do not adopt yet**, naming the specific unmet condition, or **stop**.

| # | Condition for an adoption claim | Where it is established |
|---|---|---|
| 1 | The integrated proof is obtained — clause 3 demonstrated, not owed | S11 |
| 2 | Every access path is classified, and every *relevant* one is wired | S8a, S8b, Phase 3 exit |
| 3 | O-3 is settled — the operator has chosen reading A or B, and the classification and wiring were done under the reading chosen | Operator, before S8a; re-derived at adoption |
| 4 | The seam is proved behaviourally, with failing runs on record | S8b — **unmet as of 2026-08-04** (§7.2). Establishable only by a separate, explicitly authorised proof task. The Route 3 deviation neither establishes it nor waives it |
| 5 | The shipped candidate is the proved candidate — affected behaviours re-proved after hardening, and the full grouped regression green on the final candidate | S12 |

**"Adopt with stated limitations" is deliberately not an option for conditions 1–5.** A limitation records
something *unmeasured* — an unproved CE-9 control, a deferred second caller. It cannot stand in for an
unmet adoption **condition**, and CE-17 makes entrypoint coverage a condition. Accepting one as a
limitation would be exactly the substitution the specification names as a failing case, one level up: the
weaker result presented as the stronger claim.

If only the isolated proof exists, the honest outcome is "isolated proof obtained, integrated proof owed" —
and that is a legitimate place to stop for a while. It is not adoption.

**The Route 3 deviation (§7.2) does not touch any of this.** It permits progression while condition 4 is
unmet; it does not convert condition 4 into a limitation, and adoption stays unavailable for exactly as
long as the condition is unmet. A deviation that permitted continuation *and* adoption would be the same
substitution again, one level higher: the permission to keep working read as the proof that the work is
done.

3. **Then stop.** The adoption decision is recorded in the implementation task's state file and, at
   closure, in its closing record — core §4's closure shape: the outcome, the decisions that matter, the
   final commit or evidence pointer, and the accepted limitations — with the proof it rests on named and
   each of the five conditions marked met or unmet. Then use the capability instead of continuing to design
   it. A further observation becomes a reopening trigger, not scope.

---

## 8. CE-1…CE-17 assignment map

**This table assigns; it does not restate.** Each behaviour's constructible failing case is written once,
in the §7 session that builds it, and in full in the specification. Repeating it here is the duplication
§1 forbids.

| # | Behaviour, in short | Built in | Regression case | Failing case stated in |
|---|---|---|---|---|
| CE-1 | Nothing derivable is asked of the operator | Slice A · S3 | R-1 | S3 |
| CE-2 | Escalation only for genuine operator-owned decisions | Slice A · S3 | R-1 | S3 |
| CE-3 | Resolvable uncertainty becomes a discovery unit | Slice A · S3 | R-1 | S3 |
| CE-4 | Semantic hierarchy governs; a draft does not; approval binds to content | Slice B · S4 | R-2 | S4 |
| CE-5 | Imperative wording, saving, and operator authorship create nothing | Slice B · S4 | R-2 | S4 |
| CE-6 | Demotion needs a citation; supersession is explicit; evidence ≠ intent | Slice B · S4 | R-2 | S4 |
| CE-7 | Repository claims leave as claims, never facts | Slice C · S5 | R-3 | S5 |
| CE-8 | Absence claims state what was searched | Slice C · S5 | R-3 | S5 |
| CE-9 | Relevance-gated discovery; fresh threads orient from durable sources | Slice C · S5 (instrument: S1) | R-3 | S5 |
| CE-10 | Plan-alignment justification as a field, not a gate | Slice D · S6 | R-4 | S6 |
| CE-11 | Bounded unit; held-back work named; objective not substituted | Slice D · S6 | R-1, R-4 | S6 |
| CE-12 | Codex boundaries attributed; preferences are not requirements | Slice D · S6 | R-4 | S6 |
| CE-13 | Three-way relevance — governs / preserved visibly / removed | Slice D · S6 | R-4 | S6 |
| CE-14 | Material reclassification disclosed; routine compression not | Slice D · S6 | R-4 | S6 |
| CE-15 | One execution handoff artifact, two audiences | Slice A · S3 | R-1, R-5 | S3 |
| CE-16 | No new or per-run persistent artifacts; maintenance stays allowed | Slice E · S7 | R-5 | S7 |
| CE-17 | One input, one pass, one consumable brief | Clauses 1–2: Slice A · S3. **Clause 3: S11.** Adoption boundary: S8a + S8b | R-1 (clauses 1–2 only) | S3 (clauses 1–2); S11 (clause 3); S8a (the boundary) |

**Coverage:** 17 of 17. No behaviour is unassigned; no behaviour counts as finally proved against an
intermediate candidate (§7.1); and no new behaviour number is introduced — the count stays seventeen, per
spec §7.

**This table's unit is the behaviour number; the proof's unit is the subcase.** A row here says *where* a
behaviour is built and regressed. It does **not** assert that every subcase of that behaviour is
constructed — that claim lives only in the §7 session's `Constructed failing cases` list, one seeded
condition per subcase, and in §7.1's per-subcase reporting rule. Reading a green row here as subcase
coverage is the specific error an earlier version of this plan made: headers promising CE-4 A–D, CE-6 A–C
and CE-12 over sessions that seeded one subcase each.

**CE-17 carries a second obligation the others do not.** Besides its three clauses it states the adoption
boundary — *every relevant Work Loop entrypoint* must invoke the capability before plan-dependent
continuation. That is an adoption **condition**, discharged by S8a's classification and S8b's wiring under
the O-3 reading the operator chose, which is why those two sessions appear in the row above alongside the
clause proofs.

---

## 9. Boundary audit — the prohibitions, and how this plan holds them

A prohibition mentioned only as something to build is not covered. Each row names the *active* handling.

| Prohibition (spec §7 / CE-16) | How this plan holds it |
|---|---|
| Any separate context-QC pass, including risk-triggered | §5.2 makes adding one a **falsification criterion**, not a design option. S6's stop condition fires if CE-10 appears to need an alignment check. Phase 6's assessment is core §3 step 5, explicitly not a new stage. |
| Lane classification | Not in any slice. Admission stays core §2's, cited in §4.2 as *not* a CE invocation site. |
| A new backlog, register, or log | S7 measures **zero net new durable files** across routine invocations; the trial records are development evidence, bounded by §7.5, and the run is constructed so the distinction is observable. |
| Context archive · context-pack lifecycle · decision register · provenance ledger · approval artifact · plan-history system | S7's failing case A lists these as the things whose appearance fails the slice. No phase produces any. **The Phase 2 candidate is not one:** a revision of an existing artifact, held under `trials/`, deleted at S8b. **§7.5 is not one either:** a single deletion at a named point, not a lifecycle — and S2 leaves exactly one file in the candidate folder rather than a survivor beside a rejected alternative, which is what stops that folder becoming a plan-history log. |
| Separate draft / approved / amended plan copies; raw-material archive by default | Phase 0 records **both** approvals in the approved documents themselves, each bound to content. No approval artifact is created and no approved copy is forked. S4's stop condition refuses fixtures that would leave two plans appearing current, and §4.4's fixture rules keep seeded plans unreachable and marked. |
| A second project-state file or state system | Progression across S1–S12 is recorded in **the existing task-state interface** at `logs/work-loop/context-engineering-implementation.md` (Phase 0), spec §5.7's third permitted category. S8b's evidence requires the five-field ceiling **unchanged** and fails on a diff that adds a delivery file, queue, handoff document or turn mechanism (§4.5); its stop condition fires if the edit needs schema expansion. F-9 is why that is achievable. |
| Transport machinery | Owned by the Work Loop, not by this capability. §4.5 shows the delivery path already exists in full, so S8b *reuses* rather than builds; clause 3 is proved in S11 by *observing* delivery. S2's stop condition routes a transport fact to the operator. |
| General non-repository context engineering | Not in scope; reopening trigger is a real second caller (§11). |
| Portfolio prioritisation | O-2 and O-3 are handed to the operator rather than sequenced by the plan. |
| A required task-state file **as the brief format** | The brief stays delivery-mechanism-independent. S8b enriches the brief where core §4 already places it — outside the state ceiling. Using the existing state interface to record *progression* (Phase 0) and to *carry* the brief (§4.5, already the live behaviour) is §5.7 category 3 — a different thing from prescribing a new serialization. |
| Any dependency on the existing acceptance harness or slice plan | **No CE trial depends on `work-loop-v2-slice-1.test.sh`.** It appears only in S12's regression check on the Work Loop wiring, which is Work Loop work. Its known `KNOWN_WORKLOOP_FILES` defect is a deferral (§11), not a blocker for Phases 1–5. |
| A separate fresh-session orientation prerequisite, checklist, gate, or orientation-core artifact | CE-9 is proved **inside** the single pass (S5). No phase creates an orientation stage. |
| Core-versus-opportunistic proving tiers; a new CE behaviour number | §8 assigns all 17 at one tier. The count stays 17. The grouped regression re-runs existing behaviours; it defines none. |
| Behaviour shrinking because packaging is difficult | Phase 1's boxed note: a carriage failure escalates. S2 tests the carriage *mechanism* only, so a packaging result can never be read as a statement about which behaviours are required. Only §9's acid test, in a real trial, shrinks anything. |
| A runtime packaging decision as a constraint fixed now | S2 tests **one** inline candidate and either validates it on evidence or escalates U-1; it never selects a packaging option, and no phase writes one into the runtime. What the one-file candidate constraint does fix is the *trial's* construction — inline — and S2 says so in its own text rather than leaving it implicit: indirection is untested by this build, not decided against. |
| A new correction lifecycle | C-9. S10 is core §3's one round followed by core §3's menu, chosen once. This plan adds no round, no counter, no second review. |

---

## 10. Standing rules of the build

- **The trial decides, not the design.** Every phase exists to produce evidence. A phase that produces only
  a better document has not exited.
- **One behaviour at a time, failing case first.** Define it, break it, fix it, demonstrate it, record it.
  A behaviour that was never seen to fail was never proved.
- **A proof belongs to the candidate it ran against.** Change the candidate's runtime behaviour and the
  affected proofs are owed again (§7.1, S12).
- **No horizontal layers.** No slice builds infrastructure for a later slice. If a slice needs something a
  later slice would build, the slice is wrong, not the order.
- **Frozen findings.** One correction round per review, frozen at the named findings, then core §3's menu
  once. Anything newly noticed is a deferral with its reason.
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
It can never record an unmet *adoption condition* — the five in Phase 6's table — because that would let
the plan waive by wording what CE-17 makes a requirement. **Entrypoint coverage and the O-3 reading are
therefore not listable here.**

**The S8b seam-proof debt is not listable here either**, for the same reason: it is adoption condition 4,
not something unmeasured. It is recorded in §7.2, together with the permission it runs under. Adding a row
for it in this table would be the waiver §7.2 refuses.

| Item | Why not now | Reopening trigger |
|---|---|---|
| **The integrated proof is owed until Phase 4 runs.** Everything before S11 is the isolated proof and must be reported as such — including S3b's shadow slice, which involves both models and is still not it. | Needs a genuinely two-model operator-driven session (O-4). | The operator schedules that session. |
| **The acceptance harness's `KNOWN_WORKLOOP_FILES` allowlist is stale** — 147 passed / 2 failed on a clean tree, because the allowlist predates a committed pilot file. | One-line fix, already queued at medium-high, and **no CE phase depends on the harness** (§9). | S12's regression run, or any session that needs the harness green. |
| **General (non-repository) context engineering.** | Deferred by the specification. | A real second caller. |
| **The v0.2 rework may re-shape the wired files.** | Its scope is undecided (C-10). | O-2 is answered, or the rework starts. |
| **CE-9 may prove unmeasurable** if no material fact can be seeded that the request would not naturally carry. | S1's stop condition; it is a specification finding, not a workaround. | A control design that keeps the fresh thread genuinely blind. |
| **The grouped regression is five cases, not seventeen.** A case exercising four behaviours can in principle pass while one of them is only weakly satisfied. | Seventeen per-behaviour regression runs would be a session per behaviour, which this build explicitly rejects. The per-behaviour proof is the slice; the regression's job is catching *breakage*, not re-proving. | A behaviour breaks between slices and the regression does not catch it. |

**Not limitations, and recorded here so they are not mistaken for any.** `axcion-design-studio` reaches
the Claude command through a symlinked directory but has no `.agents/` and no `logs/work-loop/`, so **no
plan-dependent briefing or continuation happens through it** — S8a's one relevance condition fails, and
those two absences are the evidence for *that*, not conditions in their own right. The verdict is
established there, re-derived at adoption, and flips the moment briefing becomes possible. **Under reading
B, S8a must also check whether v1 is reachable from that project** — v1 uses `logs/loop/`, a different
directory, so the two absences above do not settle it and it is not assumed either way here. Work Loop v1
in `ai-resources` is live and plan-dependent and authors its own brief (§4.2); whether it is in scope is
O-3, an operator decision that adoption condition 3 requires settled.

---

## 12. The exact next session

**Phase 0 first, and it is two answers, not one.** Nothing below starts until both exist:

1. **O-1 — does the specification become governing?** Recorded in the specification, bound to a commit.
2. **Is this plan approved as the plan of record?** Recorded in this document's header slot (§ Authority
   notice), bound to a commit. Answered after Codex has assessed the plan.

**O-3 is not needed to start, but is needed before S8a.** It decides the population S8a classifies, and
S8a stops rather than guessing. Answering it early costs nothing; answering it late stalls Phase 3.

Then **Session S1 — build the CE-9 measurement instrument.** It is first because it is the only thing that
makes the riskiest trial (S2) falsifiable, and because everything in Phase 2 inherits its control design.

S1 needs, and needs only: this plan's §4, §7.0, §7.1 and Phase 1; the CE specification's §3.5, §5.7 and
CE-9; and a re-verification of §4.1's facts. Its output is one scenario file whose seeded material fact is
provably present in the durable sources and provably absent from the request text. If that cannot be
constructed, S1 stops and reports CE-9 as possibly unmeasurable — which is a finding worth having, and is
not a failure of the session.

**S1 also opens the implementation task's state file**, `logs/work-loop/context-engineering-implementation.md`
— the existing task-state interface, no new system — and from that point it, not this section, is what says
where the work actually is. The `Next:` lines in §7 are the plan's static ordering; the state file is the
live position.

**This unit ends here. No implementation was performed in it.**
