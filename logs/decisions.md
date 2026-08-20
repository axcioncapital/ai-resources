# Decision Journal

> Archive: [decisions-archive-2026-08.md](decisions-archive-2026-08.md)

## 2026-08-13 — Replacement Normal Trial 1 run does not count as the trial

**Context.** This session's Work Loop v2 execution repaired the `3.1a` regression cleanly and Codex
accepted the implementation with no correction round. The state file's completion condition asked
Codex to separately judge whether the run's *operating evidence* was sufficient to count it as Axcíon
Harness v0.2 Normal Trial 1.

**Decision.** Codex ruled it does not count. The code work stands; the trial claim does not.

**Rationale.** The operator invoked `/work-loop-v2` directly rather than through the canonical
attended carrier (`scripts/axcion-harness-v0.2/carry-turn.sh`), so the run demonstrates neither the
pilot's transport claim nor reduced manual transport through the released carrier. Whether the Claude
process was freshly launched could not be confirmed from inside the session either. Codex recorded
this as a limitation in its own framing of the trial rather than a Claude implementation finding, and
explicitly ruled it is not something a correction round could fix.

**Alternatives considered.** Accepting the run as Normal Trial 1 anyway (rejected — it would credit
the pilot's transport claim with evidence that never touched the carrier) versus reopening the unit to
retroactively route it through the carrier (rejected — the carrier has to be the entry point from the
start for freshness and transport to be observable; it cannot be substituted after the fact).

## 2026-08-13 — Merge the 59-commit backlog now rather than defer it, and split the deferral in two

**Context.** `ai-resources` stood 8 ahead / 59 behind. All 8 local commits were operator-authored
findings; 6 of the 8 touched `logs/improvement-log.md` only. A concurrent `axcion-si-worktrees` session
had inspected them, declined to push blind, and recommended leaving the repo untouched until Friday. Its
argument: `logs/improvement-log.md` is deliberately excluded from the `merge=union` list in
`.gitattributes` (because that file takes prepend writes and in-place status flips, which union would
corrupt), the 59 incoming commits touch that file, and therefore the merge needs hand resolution — work
not to be rushed at the end of a long session, at the risk of dropping or duplicating findings.

**Decision.** Merge and push now; defer only the analytical follow-up.

**Rationale.** The concurrent session reasoned about the risk class instead of measuring the instance.
Measured, the range was benign: remote +207/−0 and local +177/−0 — pure additions on both sides, no
in-place status flips, no overlapping entries (the remote's 7 new entries are harness findings, the
local 8 are sector-intelligence findings). The `.gitattributes` exclusion describes what the file can do
in general, not what these two sides did. With no deletions on either side, "keep both sides" is
mechanical, and its correctness is checkable by arithmetic: merged-vs-each-parent must equal the other
side's insertions exactly. It did (207/0 and 177/0), at a predicted 3747 lines.

The timing argument then runs the other way. Both sides being pure-append is the cheapest this merge
will ever be; the next session that flips a `**Status:**` in place converts it into the hard case the
deferral was meant to avoid. Waiting invited the risk it was citing as the reason to wait.

**The split.** The concurrent session bundled two independent things under one deferral: the mechanical
merge, and reading the 59 incoming commits for retirements bearing on the findings logged today. Only
the second is real analytical work, and it is *easier* after merging (working tree rather than
`git show`). So the mechanical half was pulled forward and the analytical half stays on Friday.

**Alternatives considered.** Defer everything to Friday as recommended (rejected — defers the easy half
with the hard half, grows the divergence, and forfeits the benign window). Push without merging
(impossible — non-fast-forward). Cherry-pick the 8 local commits onto `origin/main` (rejected — same
conflict, more steps, and it discards the existing merge commit `43f7b60` that had already resolved an
earlier round of this same conflict). Fold the heading normalisation into the merge commit while the
file was already open (rejected — it would have broken the arithmetic check that made the resolution
verifiable, and it is an in-place edit to a file with a live concurrent writer).

**Confirmed by.** The concurrent session re-verified the measurement independently and withdrew its
recommendation, noting it had "reasoned about the risk instead of measuring it."

---

## 2026-08-14 — Accept a temporary 500-line budget overrun on `work-loop-v2/SKILL.md` rather than split it inside the incident fix

**Context.** Fixing the 2026-08-14 unit-packaging incident required adding split triggers, a
front-loaded-evidence rule, and mode-dependent packaging lines to `.agents/skills/work-loop-v2/SKILL.md`.
The file was already over `ai-resource-builder`'s 500-line body budget before this session started
(552 lines at `HEAD`), and the additions pushed it to 580.

**Decision.** Ship the incident fix at 580 lines rather than splitting the skill into `references/`
siblings in the same session. Log the breach to `logs/improvement-log.md` with full schema
(`Category` / `Severity: low` / `Proposal` / `Review-cycle`) and an explicit operator-acceptance line,
deferred to the next change that adds body lines to the file (backstop: 2026 Q4).

**Rationale.** Splitting a live instruction file that both a Codex skill session and the dispatcher read
on every invocation needs its own progressive-disclosure design (which sections are load-bearing on
every run vs. reachable on demand) and its own review. Folding it into an incident fix would have been
exactly the scope creep an independent review round confirmed was otherwise absent from this change.
Per the workspace's structural-fix rule, "too expensive to do structurally right now" means park for a
dedicated session, not patch around it by trimming prose that would cost load-bearing rules.

**Alternatives considered.**
- Trim existing prose to fit under 500 lines before adding the new material (rejected — the file's whole
  failure mode is guidance being forgotten under time pressure; cutting rules to satisfy a line count is
  the wrong trade).
- Split into `references/` now, in the same session (rejected — see rationale; a session already three
  review rounds deep is the wrong context for a structural redesign of a shared instruction file).
- Silently exceed the budget with no log entry (rejected — the workspace's own schema requires
  `Severity` on every entry precisely so a real gap stays reachable rather than disappearing; an
  unlogged breach is the failure mode the schema exists to prevent).

**Confirmed by.** Operator, explicitly, in the round-3 wrap-up instruction: "Accept the temporary
575-line exception explicitly" (later 580 after the bounded cleanup pass).

## 2026-08-15 — Add `$realign` as an explicit Work Loop corrective, separate from `$reorient`

**Context.** The operator asked for an invocable Codex skill that can interrupt a Work Loop course
when it starts drifting into excess governance, over-gating, ceremony, or overengineering. The
failure class is documented rather than hypothetical: `logs/friction-log.md:4040` records a bounded
four-file edit paying four setup gates before any edit, and `logs/friction-log.md:4096` records an AI
promoting its own inference into an operator decision. `logs/coaching-log.md:120` and `:136` record the
same over-gating pattern across several cycles: a bright-line review was confirming 79–83% of the
time and should proceed immediately when no material bright line can be named.

**Decision.** Add `.agents/skills/realign` as a manually invoked, instruction-only Codex skill. It
reads the existing Work Loop state and governing authority, judges only the proposed move at risk,
and either continues unchanged or applies the smallest correction through Work Loop v2's existing
protocol. It adds no hook, script, state, log, score, registry, review stage, or automatic trigger.

**Complexity-budget answers.** (1) It prevents a live course from silently turning an approved
objective into wider scope or self-maintaining process. (2) The failure is recurrent: the evidence
above covers authority drift and disproportionate gate cost, and the operator supplied a broader
historical checklist from repeated sessions. (3) The cost is one 198-line skill plus UI metadata and
one deliberate invocation; `policy.allow_implicit_invocation: false` makes its routine-session cost
zero. (4) It fires conditionally only when the operator invokes `$realign`; it is not a standing
gate. (5) `$reorient` overlaps on durable-source reading but owns a different failure boundary:
recovering authoritative state after compaction or context degradation. Broadening it into a live
course correction would mix recovery with governance judgment and weaken its deliberately narrow
task-identification contract.

**Closure channel.** The skill is not a detector that emits a backlog. `ALIGNED` resumes immediately;
`REALIGNED` removes, narrows, simplifies, verifies, or escalates the current move in the same pass;
`OPERATOR DECISION NEEDED` names the one decision required; `STOPPED` names the unsafe or unresolved
condition. Nothing persists beyond the existing Work Loop task state.

**Alternatives considered.** Extend `$reorient` (rejected — different trigger and job); add the
failure checklist to `work-loop-v2` itself (rejected — it would load on every turn and enlarge an
already over-budget skill); add an automatic hook or mandatory alignment gate (rejected — it would
recreate the ceremony the capability exists to remove); keep the attachment as an ad hoc prompt
(rejected — the operator explicitly needs a reusable invocation, and a prompt has no durable Work
Loop turn/state boundary).
## 2026-08-15 — Scope reduction: close autonomy-authority-capability at T7, drop T8/T9

**Context.** The implementation plan's exit conditions made T8 (twelve constructed autonomy scenarios)
and T9 (3–5 organic Standard-lane tasks across ≥2 capability shapes) strict, non-negotiable requirements
for closing the task — proposal §16's observable-success standard depended on running them. By 2026-08-15,
T1 through T7 had all landed (the governing autonomy rule, its reconciliation across the core/skill/
command/docs surfaces, the MVP capability envelope, and symmetric nested-actor request handling on the
Codex path). T8/T9 remained entirely unstarted: zero of twelve scenario rows, zero organic tasks.

**Decision.** The operator elected to stop spending further effort on the T8/T9 evidence program and
close the task at the completed T7 boundary. T8 and T9 are removed from the task's required completion
bar — explicitly **not** treated as passed, bypassed, waived on partial evidence, or satisfied by a
substitute. Both remain accurate specifications for optional future validation, re-openable only as
separately approved new work. Proposal §16's observable-success standard is recorded as **not
established by this project** — an accepted, explicit limitation of closing here, not a discharged one.

**Rationale.** All nine implementation tracers (T1–T7 plus T1a/T3a) were complete and independently
reviewed; the twelve-scenario trial program and the 3–5-task organic-evidence program represented a large
further time cost (proposal §12 itself estimates ~twelve paired live trials) for evidence that validates
the *already-built* mechanism's behaviour rather than building anything new. The mechanism's construction
was the higher-value, harder-to-defer work; live-validation evidence can be gathered later, incrementally,
without blocking closure or re-litigating the implementation.

**Alternatives considered.**
- **Run T8/T9 to their strict exits before closing** — rejected as the status quo the operator explicitly
  decided against on 2026-08-15; would have required roughly twelve additional paired live trials plus
  3–5 organic tasks before any closure.
- **Extend the pre-authorized capability set so T9's two-capability-shape requirement could be met, then
  run a narrower T9** — one of three options T9's own exit condition offered; not selected.
- **Wait for organic tasks to arrive naturally and count them toward T9 retroactively** — the other T9
  option; not selected, since it would leave the task open indefinitely with no target date.
- **Mark T8/T9 as accepted limitations without formally amending the Fixed Point** — rejected because the
  plan's own exit conditions state explicitly that "recording a limitation" is *not* an alternate exit for
  either tracer; only an operator-owned change to the Fixed Point is. Doing anything less would have left
  the plan's authoritative status Loop-v2 record misrepresenting what actually happened.

**Confirmed by.** The operator gave explicit content-bound approval of the exact amended plan content
(implementation plan blob `ad97ded715e80fd1370b27e79437c4880c8416d4`, commit `ff3175cd`) recording this
scope decision, and Codex then issued the Work Loop v2 close verdict on that basis.

## 2026-08-16 — Reject the frozen finding's own prescribed fix mechanism for the ownership fail-open

**Context.** Tracer bullet 8's independent readiness assessment found that `work-loop-owner.sh`
failed open at repository depth: a registered worktree that could not be entered was silently skipped,
letting a task already declared there appear unclaimed elsewhere. Codex's frozen correction instructed
using Git's `prunable` marker to distinguish a worktree that is genuinely gone from one that is merely
unreachable, preserving that distinction "based on the porcelain evidence."

**Decision.** Built and rejected the prescribed mechanism, then corrected on a filesystem test instead:
a worktree counts as gone only when its path does not exist *and* its parent directory is readable and
searchable. Anything else that cannot be entered makes ownership `AMBIGUOUS` rather than `PROCEED`.

**Rationale.** Measured directly against Git across five worktree states (healthy, present-but-unreadable,
deleted, moved, locked-then-deleted): Git reports `prunable` for both a deleted worktree and one that is
merely unreadable, because both conditions resolve to the same failed stat of the worktree's gitdir
target. A rule keyed on `prunable` would skip the unreadable checkout exactly as the original bug did —
confirmed by building it that way first and watching the proof still return `PROCEED` for an unreadable
competitor. The finding's own prescribed mechanism was therefore factually wrong, not merely one valid
option among several. The substitution was flagged explicitly in the handback for Codex to rule on, and
Codex accepted it in the close verdict on the same measured evidence, expressly naming the original
`prunable` suggestion as rejected.

**Alternatives considered.** Following the `prunable`-based instruction as written (rejected — measured
to reinstate the exact fail-open being corrected). Treating every uninspectable worktree as unestablished
with no gone/present distinction at all (rejected — would turn any repository with a merely-deleted
worktree into a permanent `AMBIGUOUS`, which is over-refusal the frozen plan does not call for and Tracer
8's own proof matrix would catch as a regression against ordinary reuse).

## 2026-08-16 — Commit the Tracer 8 correction without waiting for its independent re-check

**Context.** After correcting both frozen findings, a second independent-review subagent was dispatched
to re-verify the correction against exactly two questions: are the findings resolved, and did the
correction break something. It had not completed after roughly ten minutes with no visible progress
signal available to check.

**Decision.** Operator chose to cut the wait short. The correction was committed with the re-check
explicitly recorded as `unassessed` in the state file's evidence and Next-action sections, rather than
silently proceeding as if it had passed or fabricating a result.

**Rationale.** The frozen scope asked for the re-check in the same handback as the correction, but
nothing in the loop's contract requires blocking indefinitely on a subagent that may be running long for
reasons (e.g., building its own throwaway git repositories and running full courier suites) unrelated to
the correction's correctness. Recording the gap loudly and handing the decision to Codex — whose bounded
closure check subsequently accepted the correction on independent grounds anyway — kept the loop's
"never silently claim an unassessed result as passed" invariant intact while not stalling the session.

**Alternatives considered.** Waiting indefinitely for the re-check (rejected by the operator — no fixed
bound on the wait, and the correction's own fail-capable evidence was already strong). Killing the
subagent and self-certifying the correction as reviewed (rejected — would have violated the "independent
reviewer, never the author" rule the Work Loop QC framework requires).

## 2026-08-18 — SHRINK the dispatcher-reliability task at the pre-run terminal-result boundary

**Context.** Unit 36 of `work-loop-v2-dispatcher-reliable-supervised-use` established a
`PLAN/INTERFACE CONFLICT`: plan § 5 Change set A requires every dispatcher termination — including
usage and argument refusal — to produce one durable, run-bound terminal result. Every input to run
identity and evidence location (`--checkout`, `--task`, `--log-dir`) is itself an argument that class
of refusal rejects or lacks, so the requirement is uncoverable for early refusals inside the current
interface without either trusting a rejected value (unsafe) or adding a second evidence mechanism
(a new argument-free evidence root, an independent pre-parse run identity, and matching schema/consumer
changes).

**Decision.** Patrik chose `SHRINK`. Invalid pre-run invocations may refuse with clear stderr and a
nonzero exit without a durable terminal result; the durable-result guarantee begins only once
checkout, task and evidence location are all trusted. The task closes under this narrowed boundary. No
integrated candidate passed Gate SA and no independent review returned `ADOPT`; the release label
**Reliable supervised semi-autonomous dispatcher** is not authorized. Any future implementation of the
narrowed envelope requires a new or materially revised content-bound plan/task — not a resumption of
the closed task under the old Gate SA authority.

**Rationale.** The architecture change needed to close the gap (dispatcher-global evidence root +
independent pre-parse identity + weakened consumer identity contract) exists solely to describe
malformed non-runs — invocations that never became a real dispatcher run in the first place. Its cost
(new state surface, a second identity path, schema changes) was judged disproportionate to the value of
durable evidence for inputs that were already rejected and already visible on stderr.

**Alternatives considered.** Re-scoping the plan clause to cover only the sub-class with an admitted
evidence root (late-stage refusals after leases are held) and recording the earlier sub-class as an
accepted limitation — left as a live option, not taken, because it would have required a formal plan
amendment rather than settling the question at the task level. Accepting the full architecture change
as an operator-owned decision to keep Gate SA reachable — rejected on cost/value grounds above. Amending
plan item 7 to explicitly accept stderr-only evidence for the whole class — functionally close to what
was chosen, but as a plan edit rather than a task-level SHRINK; the SHRINK path was preferred because it
closes the task cleanly without touching the content-bound plan's own text.
