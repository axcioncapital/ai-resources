# The Pocock Lifecycle for Building the Work Loop MVP

**Version:** v0.4 (supersedes all prior versions; aligned with Proposal v0.4, which is the authoritative plan; adds Step 0 and the full session map to MVP)
**What this is:** the session-by-session execution guide. The proposal says what and why; this says exactly what to do, in order, in which kind of session.

---

## The session map: every session from tomorrow to the MVP

This is the whole journey at session granularity. Session counts are estimates, not gates; a step exits when its exit condition is met. Every session has one job and a hard stop.

**Session 1 — Install the project (Step 0).** In Claude Code: commit the three governing documents to the repo, write the authority README, create the mission with the /mission command. Build nothing. Stop.

**Session 2 — Codex packaging facts (Step 1).** Mostly you, in the Codex app: answer the packaging questions by inspection. Then a five-minute Claude Code session: commit the findings note, update the mission's next action. Stop.

**Session 3 — Transport prototype (Step 2).** Both apps: Codex writes a toy brief into a minimal state file, Claude writes a toy result, Codex reads it. Throwaway; keep only the conclusions note. Stop.

**Sessions 4 to 5 — Executable core (Step 3).** Claude drafts the core from the settled decisions plus the Step 1 and 2 notes. You read and approve it. The slice plan (Step 4) is written at the end of the same session or as its own short session. Stop.

**Sessions 6 to 8 — Build the slices (Step 5).** One fresh session per slice: Slice 1 core round trip (split Codex-side and Claude-side across two sessions only if it does not fit one), Slice 2 continuity and correction, Slice 3 admission discipline. Red-green per behaviour, targeted review at slice end, commit. Stop after each slice.

**Session 9, possibly 10 — Candidate review (Step 6).** One fresh-context review of the complete candidate, frozen by exact commit. Findings A, B, C frozen; one correction session if findings exist; closure check against A, B, C only. Candidate accepted with its disclosed-limitations list. Stop.

**Session 11 — Pilot start (Step 7 opens).** First action: the v1 retirement decision. Then begin the first real CRM and Email OS unit through the loop.

**Sessions 11 to 14 — Pilot units (Step 7).** Two or three real work units, at least one Standard-lane unit with a mid-task session handoff. Pilot log running throughout. The presumption is no change; only blockers become work.

**Sessions 15 to 17 — Harden and stop (Step 8).** Fix demonstrated blockers under frozen-findings discipline. Run the regression set. Post-pilot assessment with the doctrine check folded in. Archive v1. **MVP v1.0.**

Roughly 12 to 17 sessions in total. If it goes faster, nothing stretches to fill the estimate.

---

## Step 0: Install the project and create the mission (Session 1, tomorrow)

**Session type:** setup, in Claude Code, pointed at ai-resources. This session builds nothing and designs nothing.

**Before the session:** have the three current documents downloaded: Proposal v0.4, this Playbook, and the Complete System explainer v0.2. Delete any older versions on your side.

**What to do:** attach the three files and instruct Claude to do exactly four things:

1. Inspect the repo's conventions for project documentation and commit the three documents into a folder for this project.
2. Add a short README in that folder stating the authority order: the Proposal is authoritative and its settled decisions are binding; the Playbook is the execution guide, subordinate to the Proposal; the Complete System explainer is destination reference only, never a requirements document, and must not be used to justify building beyond the MVP scope.
3. Read the repo's /mission command and create the mission: objective (build the Work Loop v2 MVP per the Proposal), links to the three documents, and the exact next action (Step 1: investigate Codex-side resource packaging).
4. Show the result and stop. No design work, no drafting, no Step 1.

**Why the authority README matters:** the repo's own rule is that repository content creates requirements only when its source is explicitly authoritative. Without the README, a future session could read the Complete System document and helpfully start building the Consequential lane.

**Done when:** the documents and README are committed, the mission exists, and nothing else happened.

---

**What changed from v0.1:** the full Wayfinder ticket network (G1 to G5, R1 to R2, P1 to P2, T1) is gone. The decisions it existed to resolve are now settled and recorded in the proposal. What remains is the Wayfinder *mindset* applied through ordinary focused sessions: resolve blocking unknowns first, prototype the riskiest seam, build thin complete slices, advance on evidence. Pocock's lesson here is not "use every skill in the stack." It is: reduce uncertainty enough to build a thin complete slice, then let real behaviour teach you what comes next.

**Standing rule for every step:** neither v1 nor the emerging v2 governs this build. This playbook is the process.

---

## Step 1: Investigate Codex packaging (one session)

**Session type:** research-style, in the spirit of `/research`: primary sources, cited note, no decisions made on the operator's behalf.

**What to do:** open the actual Codex app and answer, by inspection: How is a Codex-side resource installed? How is it invoked? How does it read and write repository files? Are there format or size constraints? Commit a short cited note with the findings to ai-resources.

**Do not** investigate Claude Code command conventions here. Claude inspects the repository itself when implementation starts (the repository answers repository questions).

**Done when:** the note exists and nothing about the Codex side is guessed.

---

## Step 2: Prototype the transport seam (one session, throwaway)

**Session type:** prototype, in the spirit of `/prototype`: build the smallest disposable thing that answers one important question, react to it, keep the conclusion, discard the code.

**The question:** does the repository-based round trip actually work cleanly? Codex writes a toy brief into a minimal state file and commits. Claude reads it, writes a toy result, commits. Codex reads the result.

**Use the smallest state interface that works.** This is deliberate: building the round trip with a minimal file teaches the schema at the same time. Note what the file genuinely needed, what it did not, and any constraints discovered (commit friction, file reading quirks, anything from Step 1's findings that behaves differently in practice).

**Done when:** the round trip has worked once, and a short conclusions note (kept) records the seam's behaviour and the minimal viable schema. The prototype itself is discarded.

---

## Step 3: Write the executable core (one to two sessions)

**Session type:** specification, in the spirit of `/to-spec`: synthesize what is already decided; do not reopen decisions.

**Inputs:** the proposal's settled decisions (Section 3), the Step 1 note, the Step 2 conclusions.

**What the core contains, in order:**

1. Role statement: Codex prepares and prioritises the next justified work unit, protects alignment with the approved project objective, and assesses whether evidence supports progression. Claude owns repository reality. The operator owns priorities, scope, and consequential decisions. Codex manages progression; it is not sovereign. Codex's ordinary assessment is a concise progression decision, not a strategic reinterpretation after every result. Where a unit runs under a specialist workflow, that workflow owns its method; the Work Loop supplies orientation, progression, and assessment only.
2. The admission test: Direct Work is the default; escalation to the loop requires a named reason.
3. The unit cycle: orient, choose the smallest justified unit, brief, execute, assess, close or correct once or stop, including the executive "good enough, proceed" judgment and the frozen-findings closure rule.
4. The task-state interface, as learned from Step 2: one authoritative interface, one file to start, contents and an example. Active state contains at most: objective and approved scope; current lane and unit; latest material result; unresolved blocker; next action. On closure, only the outcome, important decisions, final commit or evidence pointer, and accepted limitations remain. The ceiling is a maximum, not a mandatory minimum: the Step 2 prototype may prove fields unnecessary.
5. The terminology section: task, unit, brief, state file, lane, correction, evidence, deferral, close. One definition each. This replaces any separate domain-modeling exercise.
6. The universal safety rules: verify premises against the live repository before acting; validate untrusted input read-only before mutating; absence claims state what was searched; scope and success criteria do not silently change; evidence must be capable of exposing failure.
7. Escalation triggers, which for the MVP mostly resolve to "stop and bring this to the operator."

The full v2 philosophy goes into a separate reference document that is not loaded during normal work. The Claude command and the Codex resource will link to the core rather than restating it.

**Done when:** the operator has read and approved the core.

---

## Step 4: Slice the build (part of a session)

**Session type:** lightweight, in the spirit of `/to-tickets` but without ticket machinery. Write the slice plan into one short note.

**The slices (from the proposal):**

- **Slice 1: core round trip.** Codex brief → Claude reads and verifies premises (including refusing a false one) → Claude executes a small real unit → result and evidence written → Codex assesses and closes.
- **Slice 2: continuity and correction.** Fresh-session recovery from the state file alone; exactly one bounded correction; clean closure.
- **Slice 3: admission discipline.** Direct Work bypass; deferral recording; remaining anti-failure behaviours.

**Predefined split point:** if Slice 1 does not fit one clean implementation session, split it between the Codex side and the Claude side of the round trip. The session boundary decides the slice count, not ideology.

Each slice gets a few acceptance behaviours: observable, demonstrable, few.

**Done when:** the slice note exists with acceptance behaviours and the operator has glanced at it.

---

## Step 5: Implement each slice (one fresh session per slice)

**Session type:** implementation, in the spirit of `/implement` with `/tdd` inside, adapted to command artifacts.

**Per slice:**

1. Fresh session. Load the slice note, the executable core, and nothing else from planning history. Claude inspects the live repository for conventions and current state (this is where the old R2 research happens, at zero planning cost).
2. Build one behaviour at a time, red-green: define the observable behaviour, construct the failing case (for example: a state file containing a deliberately false premise; a fresh session with no conversational memory), implement until it passes, demonstrate, commit.
3. **Local decisions stay local.** A missing field, a naming choice, an internal structure: decide it in-session and note it. Return to planning only if something materially changes objective, scope, ownership, architecture, or operator policy.
4. **Targeted review, not formal review.** At slice end, one focused check: does the slice deliver its acceptance behaviours, and does it respect the core? Fix, commit, mark the slice done.

**Done when:** all slices are complete and each has been demonstrated individually.

---

## Step 6: One serious candidate review (one fresh-context session)

**Session type:** review, in the spirit of `/code-review`, run exactly once on the complete MVP candidate as one defined object.

**The frozen-findings protocol, followed strictly:**

1. The candidate is frozen and named by its exact Git commit. Any later change to the candidate creates a new candidate and makes this review stale; approval attaches to reviewed bytes, never to a name. The fresh-context reviewer then examines the whole candidate against the executable core and the acceptance behaviours, on two axes: does it follow the repository's conventions, and does it deliver the specified behaviours, nothing missing, nothing extra.
2. Material findings are identified: A, B, C. The correction scope freezes there.
3. Claude corrects A, B, C in one pass.
4. The closure check verifies A, B, C and any blocking regression the correction caused. It does not restart a broad review. D, E, F do not get discovered. Newly noticed non-blocking improvements are written down as deferrals.
5. If the closure check finds the correction insufficient, Codex chooses **once**, on value and risk rather than a round counter, among: accept a disclosed limitation; permit one final tightly bounded fix; revert; reframe; or stop. The "final fix" option receives no new broad review, and its closure check covers only that fix's own scope plus blocking regressions. Genuine risk-acceptance choices escalate to the operator. The menu is the exit from correction, not a door back into it.
6. Close: the candidate is accepted for pilot use, together with its disclosed-limitations list. The closing judgment is the executive "good enough, proceed."

**Done when:** the candidate is accepted and the limitations list is written.

---

## Step 7: Pilot on real work (multiple working sessions)

**At pilot start, first action:** make the v1 retirement decision (archive now versus after pilot success). This is the hard boundary; it does not slip past pilot start.

**Then:** run two or three genuine CRM and Email OS units through the MVP, at least one being a Standard-lane unit with a mid-task session handoff. Operate normally: give objectives, make escalated decisions, judge usefulness. Keep a running pilot log of every friction point.

**The presumption is no change.** A log entry becomes immediate work only if it materially obstructed useful operation. Everything else becomes a reopening trigger or an accepted limitation, written down in the log with what evidence would reopen it.

**If a defect's cause is unclear:** use the `/diagnosing-bugs` discipline: build a tight reproduction first, then fix.

**Done when:** the units are complete and you can honestly say the loop helped you get real project work done.

---

## Step 8: Harden, assess, stop (one to three sessions)

1. **Fix demonstrated blockers only,** each under the frozen-findings discipline: one pass, at most one bounded correction, closure check against that fix's own scope.
2. **Run the short regression set,** demonstrating once each: a small reversible fix stays Direct Work; a Standard task survives full session replacement from the state file and Git alone; a false premise gets caught and refused; a disclosed limitation closes a task without another cycle; a completed task produced less process text than implementation and evidence; a task de-escalates when discovery shows the problem is smaller than assumed; a stale or foreign task-state file is rejected before any mutation; a change to the reviewed candidate after its formal review renders that review stale. If a pilot unit naturally invoked a specialist workflow, also confirm it owned its method without the Work Loop layering a second review or state system over it; do not manufacture a unit to test this.
3. **Post-pilot assessment with the doctrine check folded in** (one lightweight pass, no separate artifact or cycle): What did real use show we do not need? What can be deleted or simplified? What, if anything, now deserves automation? Act on deletions and simplifications; defer the rest.
4. **Execute the v1 retirement decision.** One authoritative Work Loop remains in the repository.
5. **Stop.** MVP v1.0 exists. From here, use the loop; do not keep designing it.

---

## Post-MVP triggers (for reference, not for scheduling)

Each of these waits for a real operational trigger from actual use:

- A genuinely consequential task appears → consider worktree isolation, candidate identity, or a fresh-review mechanism, built as its own thin slice against that task.
- Manual invocation becomes a demonstrated bottleneck → consider automation (triggering, session creation, hooks).
- Multi-writer conflicts actually recur → consider a lightweight ownership mechanism.

Until a trigger fires, "stop and bring it to the operator" remains the escalation answer, and that is fine.

---

## The whole lifecycle on one page

```
0. Install project + create mission     (commit docs, authority README, /mission; build nothing)
1. Investigate Codex packaging          (research session, cited note)
2. Prototype the transport seam         (throwaway; minimal state file; keep conclusions)
3. Write the executable core            (synthesis; terminology inside; philosophy offloaded)
4. Slice the build                      (2–3 vertical slices; predefined split point)
5. Implement per slice                  (fresh session; red-green; local decisions local;
                                         targeted review per slice)
6. One serious candidate review         (fresh context; frozen findings A/B/C; one correction;
                                         closure checks A/B/C only)
7. Pilot on real CRM / Email OS work    (v1 decision at start; presumption of no change;
                                         blockers only)
8. Harden, assess (doctrine folded in), retire v1, stop
                                         = MVP v1.0
```

**One habit across all sessions:** every session ends by updating the mission's "exact next action" before stopping. That single line is how twenty or thirty sessions stay coherent: each new session opens by reading the mission, doing the one named thing, and naming the next.

**The governing idea in one sentence:** resolve only what blocks building, prove the riskiest seam with a throwaway prototype, build the loop as a few thin complete slices, review the whole candidate once under frozen findings, and then let real CRM and Email OS work, not further design, decide what the Work Loop becomes next.
