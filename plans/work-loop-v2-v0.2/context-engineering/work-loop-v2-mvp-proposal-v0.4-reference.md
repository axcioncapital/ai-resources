# Proposal: Building the Work Loop v2 MVP

**Version:** v0.4 (supersedes all prior versions; folds in the final review's four findings under the frozen-findings rule)
**Status:** Approved direction. **Planning is closed.** Further plan-level observations become reopening triggers unless they materially block Phase 1. The next session produces evidence, not documents.
**Companion document:** "The Pocock Lifecycle for Building the Work Loop MVP" v0.2 is the step-by-step execution guide derived from this plan. This proposal is the authority; the playbook follows it.

**This plan optimises for exactly one thing:**

> Get to a small, functioning end-to-end Work Loop quickly enough that real use can teach us what actually needs strengthening.

Every rule in this document either serves that goal or protects against the specific failure modes that killed v1. Nothing else earns a place.

---

## 1. What this document is

A self-contained plan for building the first working version (the MVP) of the Work Loop command system. You can read it without opening the v2 specification, the v1 failure review, or the Matt Pocock materials. It covers: the situation, the decisions now settled, the destination, four evidence-gated build phases, the standing rules of the build, and what happens after the MVP.

---

## 2. The situation in brief

The Work Loop is the operating model connecting two AI systems across one shared repository. **Codex** (in the Codex app) prepares and prioritises the next justified work unit, protects alignment with the approved project objective, and assesses whether evidence supports progression. **Claude Code** owns repository reality: it verifies premises against the live repository, implements, tests, and produces evidence. **You** own priorities, scope, and consequential decisions. Codex manages progression; it is not sovereign over the project or over repository reality. Codex's ordinary assessment is a concise progression decision, not a strategic reinterpretation after every result. And where a work unit runs under a specialist Axcíon workflow, that workflow owns its method; the Work Loop supplies orientation, progression, and assessment only, and never layers a second review or state system over it.

Version 1 of the Work Loop failed in a documented way: every discovered weakness produced new process machinery, reviews kept discovering new findings after corrections, you became the copy-paste transport layer between the two systems, and the workflow became better at detecting its own deviations than at delivering fixes. The binding lesson: optimise for time to a sufficiently verified useful outcome, not procedural completeness.

Two facts shape the rebuild. First, the Codex app and Claude Code share the same repository, so **the repository is the transport**: a handoff is a commit to a task-state file, and the copy-paste failure category is designed out rather than mitigated. Second, the MVP is built with a deliberately plain process. Neither v1 nor the emerging v2 governs its own construction.

---

## 3. Settled decisions

These were open questions in v0.2. They are now decided and recorded here. They do not get reopened without new evidence that materially changes them.

1. **Lane scope: Direct + Standard.** The MVP handles ordinary meaningful work (Standard lane) and refuses to inflate small work (Direct Work bypass). Consequential-lane machinery is fully post-MVP.
2. **Build governance: plain build plus one bounded fresh-context review.** You and Claude Code build the MVP. Before pilot use, the complete candidate receives one serious fresh-context review, governed by the frozen-findings rule (Section 6). No other formal review layers.
3. **Quality bar: pilot quality, roughly 90%, disclosed limitations allowed.** The MVP ships to the pilot with a written list of known limitations. Theoretical completeness is explicitly not the target. Codex is responsible for making the executive "good enough, proceed" decision rather than continuously finding refinements.
4. **v1 retirement: decided at pilot start, no later.** The choice (archive immediately versus after pilot success) can wait until then, but pilot start is a hard decision boundary. Two active Work Loop systems must not drift indefinitely.
5. **Codex packaging: investigated, not guessed.** How Codex resources are actually installed, invoked, and how they read repository files gets checked against the real Codex app in Phase 1.
6. **Task-state interface: one authoritative interface, probably one file, not dogma.** The tracer bullet uses a single state file. If real use later shows that a current-state file plus a separate result object is cleaner, the interface may evolve. "One physical file forever" is not an architectural requirement.
7. **Terminology: one short section in the executable core.** The core defines task, unit, brief, state file, lane, correction, evidence, deferral, and close, once. No separate domain-modeling exercise, no ADR structure for the MVP.
8. **Planning stays small.** No Wayfinder ticket network. The Wayfinder principles (resolve blocking unknowns first, prototype the riskiest seam, advance on evidence) apply as principles, executed in ordinary focused sessions.
9. **The formal-review candidate is frozen by exact Git commit.** The one serious review names the commit it examined. Any subsequent change to the candidate creates a new candidate and makes that review stale. This identity rule applies to this one object at this one moment; it does not spread to ordinary work.
10. **The task-state file has a content ceiling.** Active state contains at most: objective and approved scope; current lane and unit; latest material result; unresolved blocker; next action. On closure, only the outcome, important decisions, final commit or evidence pointer, and accepted limitations remain. The ceiling is a maximum, not a mandatory minimum: the Phase 1 prototype may prove fields unnecessary. This is what keeps the state file current truth rather than a diary.

---

## 4. The destination

Stated as observable behaviours, because behaviour comes before architecture. When the MVP is done, all of the following have been demonstrated, not just claimed:

1. You give Codex an objective; Codex writes a bounded brief into a task-state file in the repository and commits it. You transport nothing.
2. Claude, invoked through the Work Loop command, reads the state file, verifies the brief's premises against the live repository, and refuses with a report if a premise is false, rather than building on it.
3. Claude executes the bounded unit and writes its result and evidence into the state file.
4. Codex reads the result, assesses it against the approved objective, and closes, requests exactly one bounded correction, or escalates a genuine decision to you.
5. Both sessions can be closed and fresh ones continue the task correctly from the state file and Git alone.
6. A small, reversible fix stays Direct Work: no state file, no brief, no ceremony.
7. At least two real units of the CRM and Email OS project have been completed through the loop, and you judged the outcomes useful.

---

## 5. The four phases

Phases are **evidence-gated, not calendar-gated**. Each phase exits when its exit condition is demonstrated, whether that takes two days or two weeks. Rough capacity guidance appears at the end of each phase purely for your planning; it never controls progression.

### Phase 1: Establish the executable core

**What happens.** Three activities, in order.

First, a short investigation: open the actual Codex app and confirm how a Codex-side resource is installed, invoked, and how it reads and writes repository files. Record the findings in a brief note. This is the one factual unknown that could invalidate the architecture, so it goes first. (Claude Code command conventions do not need investigating now; Claude inspects the repository when implementation starts.)

Second, the **transport prototype**: prove the riskiest seam with throwaway material. Codex writes a toy brief into a minimal state file and commits. Claude reads it, writes a toy result, commits. Codex reads the result. No command logic, just the seam. The state file used here is deliberately the smallest interface that works, which means the prototype also teaches us the schema: what the file genuinely needs, what it does not. Keep the conclusions and discovered constraints; discard the prototype itself.

Third, write the **executable core**: the short document both the Claude command and the Codex resource will reference instead of restating rules. It contains: the admission test (Direct is the default; escalation to the loop requires a named reason); the unit cycle (orient, choose the smallest justified unit, brief, execute, assess, close or correct once or stop); the task-state interface (informed by the prototype and constrained by Decision 10's content ceiling); the terminology section; the handful of universal safety rules that earned their place in v1's failure review (verify premises against the repository before acting, validate untrusted input read-only before mutating anything, absence claims state what was searched, scope and success criteria do not silently change, evidence must be capable of exposing failure); and the escalation triggers, which in the MVP mostly say "stop and bring this to the operator." The full v2 philosophy lives in a separate reference document that is not loaded during normal work.

**Exit condition:** the Codex packaging facts are known, the round trip has worked once with the minimal interface, and you have approved the executable core.
**Rough capacity guidance:** a few sessions; plausibly under a week.

### Phase 2: Build the tracer bullet

**What happens.** Implement the MVP as two or three vertical slices, each a complete observable behaviour, each in a fresh implementation session:

- **Slice 1: the core round trip.** Codex brief in the state file, Claude reads and verifies premises (including refusing a deliberately wrong premise), Claude executes a small real unit, writes result and evidence, Codex assesses and closes. This is one integration seam and is deliberately kept as one slice. **Predefined split point:** if Slice 1 cannot realistically fit one clean implementation session, split it between the Codex side and the Claude side of the round trip. Do not force either three or six slices ideologically; the session boundary decides.
- **Slice 2: continuity and correction.** Fresh-session recovery from the state file alone, plus exactly one bounded correction cycle, plus clean closure.
- **Slice 3: admission discipline.** The Direct Work bypass and the remaining core anti-failure behaviours (deferral recording, the executive "good enough, proceed" behaviour).

Each slice is built one behaviour at a time in a red-green style adapted to command artifacts: define the observable behaviour, construct the failing case (for example, a state file with a false premise), implement until it passes, demonstrate, commit. Review during slices is **targeted**: a focused check that the slice delivers its behaviour and respects the core, not a formal multi-context review protocol per slice.

Then, when the complete candidate exists: **one serious fresh-context review** of the whole MVP as a single defined object (per Decision 2), named by its exact Git commit (per Decision 9), operating under the frozen-findings rule in Section 6. Blocking findings are corrected once; the closure check verifies only the frozen findings and blocking regressions; the candidate is then accepted for pilot use with its disclosed-limitations list.

**Exit condition:** one genuine end-to-end run has worked on a small real task without any copy-paste, the wrong-premise refusal has been demonstrated, and the reviewed candidate is accepted.
**Rough capacity guidance:** one to two weeks.

### Phase 3: Pilot on real project work

**What happens.** At pilot start, the v1 retirement decision is made (hard boundary, per Decision 4). Then run two or three genuine CRM and Email OS work units through the MVP, chosen so that at least one Standard-lane unit needs a session handoff mid-task. You operate as the operator: give objectives, make escalated decisions, judge usefulness.

The pilot tests, in real conditions: useful context preparation, alignment with the approved project plan, state recovery, one bounded correction, the Direct Work bypass, operator intervention, and clean fresh-session continuation. Every friction point goes into a pilot log.

**The presumption is no change.** A pilot observation enters immediate MVP scope only if it materially obstructed useful operation. Everything else becomes a reopening trigger (the idea, why not now, what evidence would reopen it) or an accepted limitation. This rule is what makes the loop learn through use rather than through speculation.

**Exit condition:** you can honestly say the loop helped you get real project work done.
**Rough capacity guidance:** one to two weeks, running alongside real project progress.

### Phase 4: Harden from evidence and stop

**What happens.** Fix demonstrated blockers from the pilot log, each under the frozen-findings discipline: one implementation pass, at most one bounded correction, closure check against the fix's own scope. Run a short regression set, demonstrating once each: a small fix stays Direct Work; a Standard task survives full session replacement on the state file alone; a false premise gets caught; a disclosed limitation closes a task without another cycle; a full successful task produces less process text than implementation and evidence; a task de-escalates when discovery shows the problem is smaller than assumed; a stale or foreign task-state file is rejected before any mutation; and a change to the reviewed candidate after its formal review renders that review stale. If a pilot unit naturally invoked a specialist workflow, also confirm that the workflow owned its method without the Work Loop layering a second review or state system over it; do not manufacture a pilot unit just to test this.

Then the **post-pilot assessment**, which includes one lightweight doctrine check folded in (this satisfies the repository's doctrine convention without a separate governance cycle): What did real use show we do not need? What can be deleted or simplified? What, if anything, now deserves automation? The purpose is deletion and simplification based on what the pilot taught, not reopening the MVP design.

Execute the v1 retirement decision. Close out with one authoritative Work Loop in the repository and a final disclosed-limitations list.

**Then stop.** Use the loop instead of continuing to design it.

**Exit condition:** MVP v1.0 exists, is useful, is stable enough, and has known limitations written down.
**Rough capacity guidance:** about a week.

---

## 6. Standing rules of the build

These apply throughout all phases.

**The frozen-findings closure rule.** When a broad review runs (the Phase 2 candidate review, or any pilot-blocker fix), it works like this and only like this:

```
Broad review identifies material findings: A, B, C
        ↓
Correction scope is frozen at A, B, C
        ↓
Claude corrects A, B, C
        ↓
Closure review checks: A, B, C resolved? Any blocking regression caused by the correction?
        ↓
Close or reject. It does NOT restart a fresh broad review and discover D, E, F.
```

Newly noticed non-blocking improvements during closure are deferred, never converted into another correction cycle. Codex's responsibility at closure is the executive judgment "good enough, proceed," not the continuous discovery of refinements.

**The candidate freeze.** The formal review names the exact Git commit it examined. Any subsequent change to the candidate creates a new candidate and makes that review stale. Approval attaches to reviewed bytes, never to a name.

**The post-correction menu.** If the closure check finds the correction insufficient, the answer is not another cycle by default. Codex chooses **once**, on value and risk rather than a round counter, among: accept a disclosed limitation; permit one final tightly bounded fix; revert; reframe; or stop. The guardrail on the "final fix" option: it receives no new broad review, and its closure check covers only that fix's own scope plus blocking regressions. Genuine risk-acceptance choices escalate to the operator. The menu is invoked once; it is the exit from correction, not a door back into it.

**Local decisions stay local.** Reversible technical decisions discovered during implementation (a missing field, a naming choice, an internal structure) are made inside the implementation session and noted. Planning reopens only if new evidence materially changes the objective, scope, ownership, architecture, operator policy, or another genuinely load-bearing decision.

**The pilot presumption.** No pilot observation becomes scope by default. Only material obstruction of useful operation does.

**One interface, not one dogma.** The task-state interface is the single seam between Codex, Claude, and you. It starts as one file. Its physical shape may evolve if real use justifies it; its authority as the single interface does not.

**No self-hosting.** Neither v1 nor the emerging v2 governs any part of this build.

---

## 7. Post-MVP (evidence-triggered, not scheduled)

None of the following is MVP work. Each requires a real operational trigger before it is built:

- Consequential-lane capabilities: isolated worktrees, frozen candidate identity at release, fresh independent-review machinery, deeper independence mechanisms.
- Automation: automatic Claude or Codex triggering, automatic session creation, context monitoring, hooks.
- Any enforcement mechanism for single-writer ownership (an operating assumption until recurrence proves otherwise).

Until a trigger fires, the MVP's escalation answer for genuinely consequential situations is "stop and bring this to the operator," which is honest and safe.

---

## 8. What happens next

1. Phase 1, first session: the Codex packaging investigation. This is the only remaining factual unknown standing in front of the prototype.
2. Then the transport prototype, then the executable core, per Phase 1.
3. The companion playbook (v0.2) gives the session-by-session execution steps.
