# Decision Journal

> Archive: [decisions-archive-2026-07.md](decisions-archive-2026-07.md)

## 2026-08-01 — Declined an external review finding on verified-premise grounds

**Context.** An external review (Fable) of the executable core raised three findings. Finding A —
the substantive one — held that the core had dropped "genuine uncertainty about the problem or
solution" from the Proposal's named admission reasons, and recommended restoring it.

**Decision (Claude, endorsed by the operator).** Declined. Findings B and C were reported as already
fixed rather than re-fixed.

**Rationale.** The premise was checked before acting and is false. `grep -i uncertain` returns **zero
matches** in the Proposal. The eight-reason admission list is at
`the-work-loop-explained-complete-system-v0.2.md:45` — Document 4, which the folder README designates
"DESTINATION REFERENCE ONLY. NOT A REQUIREMENTS DOCUMENT." That line opens with "The loop is entered
only for a named reason", which is the precise phrase the README quotes as its example of imperative
wording that creates nothing. Adopting the finding would have imported scope from the one document
the build forbids as a source. Two mitigations also apply: the core's reason list had already been
opened (it reads "a guide and not a closed list") by an earlier correction Fable had not seen, and
the five safety rules apply in every lane, so discovery work retains premise verification whether or
not it enters the loop.

**Alternatives considered.**
- **Adopt it as recommended.** Rejected on the above.
- **Adopt it as a deliberate widening rather than a restoration.** Offered to the operator as an
  available override; not taken.

**Wider point this is an instance of.** External review input is a brief like any other and its
premises are verified before adoption. Here the reviewer was sincere, specific, and wrong about which
document it was quoting — which is exactly the failure mode the folder README was written to prevent.

## 2026-08-01 — Amended the work-loop-v2-mvp mission's frozen acceptance assertion 1

**Context.** The prior session (S3-19b) settled that Claude, not Codex, commits the Work Loop v2
task-state file — forced by Step 2's finding that Codex is refused write access to `.git` in two
independent sessions, with a positive control proving it is not a repository fault. That decision
amended the Proposal's destination behaviour 1, but the mission's validation contract — frozen at
mission creation, before implementation began — still carried the pre-amendment wording ("Codex …
writes a bounded brief into a task-state file, and commits it"). As written, the mission could not
satisfy its own definition of done. S3-19b deliberately left the choice to the operator rather than
deciding it.

**Decision.** Amend acceptance assertion 1 to read "Codex is given an objective and writes a bounded
brief into a task-state file; **Claude commits it** — the operator transports nothing by hand." The
date, the original wording, and the basis are recorded inline beside the assertion in
`logs/missions/work-loop-v2-mvp.md`, and the resolution is cross-referenced in
`plans/work-loop-v2-mvp/README.md`.

**Rationale.** A contract that cannot be satisfied measures nothing. The alternative — leaving the
freeze absolute and recording a standing divergence — keeps the freeze more literally intact, but
means the assertion is either waived at mission close or blocks closure permanently. A waived
assertion teaches the habit of waiving assertions, which is worse than a recorded, reasoned amendment.
The amendment is narrow by design: it does not lower the bar the assertion sets. The substance —
a bounded brief reaches the state file and is committed, with nothing carried by hand — is unchanged.
Only who runs the commit changed, and that changed on evidence, not preference.

**Alternatives considered.**
- **Record the divergence, do not edit the frozen contract.** Rejected — keeps the mission
  permanently unable to close against its own literal text, and pushes the judgment call to whoever
  closes the mission later, with less context than the operator has now.
- **Leave it open, decide at mission close.** Not offered as an option — the contradiction was already
  known and named at S3-19b; deferring a known, resolvable contradiction serves no one.

**Scope of the amendment.** This is the *only* edit made to `work-loop-v2-mvp.md`'s frozen prefix
(`## Goal` through `## Validation contract`). Verified by hashing the prefix before and after both the
`/mission update` and `/mission check` operations that touched the file this session — byte-identical
in both cases, confirming nothing else in the frozen contract moved.

## 2026-08-01 — Wrote concrete `files_in_scope` paths at `/session-start` instead of the `(inferred)` marker

**Context.** `/session-start` Step 3's literal instruction writes `(inferred)` to the mandate line
whenever the operator did not state or correct `files_in_scope`, unless the project's `DIRECT`
predicate evaluates to 1 (an explicit `**Execution route:** direct` line in the project's CLAUDE.md).
This project's CLAUDE.md carries no such line, so `DIRECT=0` and the literal rule calls for
`(inferred)`. The operator had, however, just confirmed a mandate echo that already listed concrete
paths (`logs/missions/work-loop-v2-mvp.md`, `logs/session-notes.md`, `.gitignore`) derived from the
slice plan and executable core.

**Decision.** Wrote the concrete paths to the mandate line's `Files in scope` bullet instead of the
literal `(inferred)` marker, and stated the deviation in chat at the time rather than applying it
silently.

**Rationale.** The immediately prior session (S4-1bc) recorded a live incident from this exact gap:
an `(inferred)` scope on its own commit triggered `check-foreign-staging.sh`'s highest-risk branch —
the guard could not tell which staged files were the session's own against a live per-id marker from
an unrelated abandoned session, and blocked the commit until the mandate carried concrete paths. That
session's own fix was "replace `(inferred)` with the concrete paths already confirmed with the
operator" — precisely the situation this session started in, with the confirmed paths already in
hand from the Step 2 echo. Writing `(inferred)` here would have recreated a known, already-diagnosed
failure mode for no gain, since the concrete list was not speculative — it was the exact text the
operator had just confirmed.

**Alternatives considered.**
- **Follow the literal instruction and write `(inferred)`.** Rejected — reproduces a defect this
  workspace's own logs already diagnosed and fixed once this week, in the same repo, for the same
  reason.
- **Ask the operator whether to deviate.** Not taken — this is a mechanical consequence of a fact
  already in hand (the confirmed paths), not a judgment call needing operator input; stating the
  deviation inline was judged sufficient per Decision-Point Posture.

**Scope of the deviation.** Only the `Files in scope` bullet's literal-vs-marker choice. No other part
of `/session-start` Step 3 was altered or skipped.

## 2026-08-01 — No separate Codex review for Work Loop v2 Slice 1

**Context.** Session S6-974 completed Slice 1 of the Work Loop v2 MVP build (all four acceptance
behaviours green against constructed failing cases, harness 34/34). Claude's wrap summary flagged
that the Claude-side command and harness from the prior session (S5-646) remained `unassessed` by
independent review, and proposed sizing a Codex review of the combined artifact before Slice 2.

**Decision.** The operator declined: "I don't think we need to do a codex review if it already
worked. We don't need more ceremony." No review is sized for Slice 1. Settled, not deferred.

**Rationale.** On checking rather than just accepting the operator's stated reason, Claude found the
proposal was not merely unnecessary — it was **off-mission**. `logs/missions/work-loop-v2-mvp.md`'s
frozen non-negotiables state: "Do not add a review layer, gate, or governance step beyond the one
fresh-context candidate review." Step 6 of the mission plan already **is** that one review, reserved
for the finished candidate, not per-slice. Two further reasons support the operator's call rather
than merely permit it: Slice 2's behaviour 2.1 (a fresh session continuing the task from the state
file and Git alone, no conversational memory) exercises the Claude-side command more rigorously than
a reading review would, since it is a real execution rather than an inspection; and the 34-assertion
harness — which has now twice caught a real defect in itself before being trusted — is the standing
mechanical check.

**Alternatives considered.** (1) Size a lightweight risk-aware review anyway, on the grounds that the
work touched structural change classes (a new Codex resource, a `.gitignore` rule). Rejected: the
mission's non-negotiable is unconditional on class, and inventing an exception would itself be
scope drift from the frozen contract. (2) Defer the question to the Step 6 candidate review rather
than resolve it now. Rejected as unnecessary — the decision is fully resolvable today and re-litigating
it at Step 6 would just be the same conversation twice.

**Recorded:** `logs/missions/work-loop-v2-mvp.md` § Open threads (Step 5 Slice 1 entry), verified
byte-identical against the frozen contract prefix before and after the write.
