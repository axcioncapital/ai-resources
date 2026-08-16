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
