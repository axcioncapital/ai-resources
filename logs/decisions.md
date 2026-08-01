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

---

## 2026-08-01 — Narrow § 6's model bullet rather than invert it, to avoid pre-empting a reserved operator decision

**Context:** `docs/harness-and-permission-troubleshooting.md` § 4.5 was corrected the same day it was
written: the `model` key in `~/.claude/settings.json` is written by `/model` itself, so the original
advice to delete it was destructive. The correction did not reach § 6 ("What not to do"), whose bullet
still read *"Do not add a `model` field to any `settings.json` … This rule is non-negotiable."* That
left the doc contradicting itself at the section a reader is most likely to skim.

**The complication:** that bullet is lifted verbatim from workspace `CLAUDE.md` § Model Tier — the rule
that is *itself* the subject of a pending operator decision (whether to narrow it to committed layers
and carve out the user layer). So the obvious fix, inverting the bullet to match § 4.5, would have
silently decided the very question the doc elsewhere flags as reserved for the operator.

**Decision:** narrow the bullet to committed layers (workspace / ai-resources / project / vault), state
the user layer as an explicit exception, and point at § 4.5's conflict box rather than restating either
position as settled. The doc now records the conflict in three places without resolving it.

**Rationale:** the doc's internal consistency and the operator's authority over the `CLAUDE.md` rule are
both preservable at once. A reader gets correct, non-destructive guidance today; the rule question stays
open and visible for the operator to rule on.

**Alternatives considered:**
- *Invert the bullet to match § 4.5.* Rejected — resolves the pending decision by side effect, in a
  document whose own § 4.5 says the rule "has not been changed" because it is marked non-negotiable.
- *Leave § 6 alone and rely on § 4.5.* Rejected — leaves live destructive advice in the doc's most
  skimmable section. Entry-point sections are read *instead of* the body, not after it.
- *Delete the bullet entirely.* Rejected — the committed-layer half of the rule is correct and worth
  keeping; deleting it loses real guidance to avoid an editing problem.

**Recorded:** `docs/harness-and-permission-troubleshooting.md` §§ 1, 4.5, 5, 6; commit `2eab561`.
Pending-decision entry already exists at `logs/improvement-log.md:2301`.

---

## 2026-08-01 — Work Loop v2 Slice 3: admission discipline lives in both artifacts, asymmetrically

**Context.** Slice 3 (admission discipline) had to be implemented against a frozen slice plan
(`plans/work-loop-v2-mvp/step-4-slice-plan.md`) that deliberately delegates file placement to the
implementing session (`:131-134`). The plan gives Slice 3 no split point — unlike Slice 1, which
names a Codex-side / Claude-side boundary — and no source says whether the admission test,
de-escalation and mid-unit deferral belong to the Claude command
(`.claude/commands/work-loop-v2.md`), the Codex resource (`.agents/skills/work-loop-v2/SKILL.md`),
or both. The context-discovery engine flagged this as an unknown-scope item before the session
started.

**Decision.** Both artifacts carry the behaviours, split by what each side can actually act on.
Claude's command received an `Admission` section (Direct Work default, named-reason requirement,
the "this feels significant" refusal), a `De-escalating` section, and the mid-unit deferral rule
inside Step 4. The Codex resource received an `Admission` section (refuse to open on felt
importance; write the named reason into the file it opens) plus one line in its assessment section
closing a task found smaller than assumed.

**Rationale.** The Slice-2-era scope-exclusion lines being replaced existed in *both* artifacts —
`work-loop-v2.md:15` and `SKILL.md:100-102` each named the same three missing behaviours as "not yet
built, and not to be improvised here". Both files had therefore already promised the behaviour to
their reader, and leaving either one disclaiming it would have left a live artifact telling its model
to stop on work the system now supports. The asymmetry follows role ownership from the executable
core § 1: Codex decides whether a unit opens (so it owns the refusal and writes the named reason);
Claude owns repository reality (so it owns de-escalation and mid-unit scope discipline, both of which
are discovered while doing the work).

**Alternatives considered.**
- *Claude-side only.* Rejected — Codex is the party that opens units, so an admission test absent
  from the resource cannot prevent a task being opened for a bad reason; it could only refuse one
  after the file exists.
- *Codex-side only.* Rejected — de-escalation and mid-unit deferral are discovered during
  implementation, which is Claude's half. Codex cannot notice mid-unit that a task is smaller than
  assumed.
- *Symmetric duplication of all three behaviours in both files.* Rejected — it would restate rules
  the executable core owns, violating the skill-writing standard § 1 ("link to the core, never
  restate") and the mission's own off-mission signal about artifacts growing in their final pass.

**Recorded:** `plans/work-loop-v2-mvp/step-5-slice-3-evidence.md` § "The scope decision this slice
had to make"; commits `f0b06c1` (both artifacts), `59cabcd` (harness green at 136).

## 2026-08-01 — Work Loop v2 Step 6: finding C deferred rather than settled under an authorship conflict

**Context.** Step 6's fresh-context review (Codex) returned *Accept with corrections* on three
material findings. A (a contradictory operator↔Codex routing contract) and B (a harness assertion
that tested a filename instead of state) were corrected in the one permitted correction pass.
Finding C — both runtime artifacts restate executable-core policy instead of linking it, violating
the skill-writing standard § 10 — was not.

**Decision.** Defer C to the next session rather than settle it inside the correction pass.

**Rationale.** Three things made C unlike A and B. First, correcting it is not contained: six harness
assertions test *for* the restatement C wants removed, so the fix lands on all three runtime files at
once, at the freeze, with only a narrow closure check permitted afterward — the mission forbids a
second broad review. Second, the harm C names is *"the duplicated policy has already drifted into
finding A's contradictory interface and next-turn rules"* — and that drift is finding A, now fixed;
the remainder is prospective. Third, and decisively for the deferral: Claude authored all four
candidate files and its recommendation was not to rewrite them. The convenient answer and the
recommended answer were the same answer, which is the condition under which the author's judgment is
least reliable. Escalating is what `pocock-lifecycle-work-loop-mvp-v0.4.md` § Step 6 point 5
prescribes — *"genuine risk-acceptance choices escalate to the operator."*

**Alternatives considered.** *Correct C fully in the pass* — rejected for now, not on merit but on
sequencing: the largest change to the candidate would land at the moment with the least review left
to catch a mistake. *Accept C outright as a disclosed limitation* — rejected as the weakest option;
it carries no reopening trigger, so the finding would simply stop existing. *Let Claude choose* —
rejected by the operator, correctly, given the authorship conflict Claude had disclosed.

**Evidence found at wrap that bears on the pending decision.** `logs/decisions.md` (Slice 3, this
file, ~line 207) records that symmetric duplication of Slice 3's behaviours was *rejected* precisely
because it "would restate rules the executable core owns, violating the skill-writing standard § 1."
The rule was therefore understood and applied selectively during the build, which suggests some of
the remaining restatement is a judged trade-off rather than oversight. Weigh this before choosing
full correction.

**Recorded:** `plans/work-loop-v2-mvp/step-6-candidate-review.md` § 6 (self-contained, with all three
options); `step-6-review-findings.md` (the frozen findings); commit `edd0d97` (A and B corrected),
`627001e` (the review record).

## 2026-08-01 — Work Loop v2 Step 6: finding C adjudicated by Codex, ruled against Claude's recommendation

**Context.** The prior entry recorded finding C deferred rather than settled, precisely because
Claude authored all four candidate files and its recommendation (the bounded option) was the
convenient one. This session the operator moved from deferral to a resolution mechanism: Codex
adjudicates independently, and the operator would not decide before that verdict existed.

**Decision.** Claude wrote a self-contained adjudication brief for Codex
(`step-6-finding-c-adjudication-brief.md`) rather than settling C itself. Codex returned option 1 —
correct finding C in full — against Claude's recommended option 2 (bounded correction with a
reopening trigger). Claude implemented Codex's verdict as written.

**Rationale, as Codex gave it.** The duplicated policy is executable instruction inside the prompts
that run the loop, not documentation debt. Correcting finding A removed the observed contradiction
but not the mechanism that produced it. Option 2's reopening trigger would have made the pilot wait
for a known source-of-truth violation to cause real harm before honouring a binding standard and a
material independent finding. On whether the remaining restatement was a judged trade-off (Slice 3
had rejected duplication under this same rule) or an inconsistency, Codex ruled inconsistency: the
build's asymmetric assignment of *actions* by actor was sound and did not license restating the
*rule* each actor applies.

**A secondary correction inside the same verdict.** Codex re-derived Claude's blast-radius
measurement and found it wrong in Claude's own favour: 11 positive policy-wording locks, not the 10
Claude reported (a grep filter missed one assertion routed through a helper function). A larger
count made the option Claude argued against look more expensive — exactly the kind of error the
authorship-conflict concern predicts, and exactly why the brief asked for re-derivation rather than
trust.

**Alternatives considered.** *Let Claude choose* — already rejected in the prior entry, for the same
authorship-conflict reason; not revisited. *Settle C by operator judgment directly* — not taken; the
operator explicitly wanted an independent verdict before any decision, including their own. *Split
the difference (partial correction)* — not on Codex's menu and not proposed; the verdict was binary
against the three options as framed.

**Recorded:** `plans/work-loop-v2-mvp/step-6-finding-c-adjudication-brief.md` (the brief);
`step-6-finding-c-verdict.md` (Codex's full verdict); commit `fc6c07c` (the correction implemented).

## 2026-08-01 — Work Loop v2 Step 6: closure check returned not-resolved; cleared by live verification, not a second sign-off

**Context.** After the finding C correction, Codex's closure check (scoped to core § 3's two
questions — are A/B/C resolved, did the correction break anything) returned **not resolved yet**. Its
objection: the harness's behavioural assertions read outcomes the *pre-correction* prompts produced,
recovered from git history. That proves those behaviours once happened; it does not prove a model
reading the *corrected* prompts still performs them. Harness-green was therefore insufficient
evidence for the one question the closure check exists to answer.

**Decision.** Codex spent core § 3's "one final tightly bounded fix" as a verification step rather
than a code change: two live invocations of the corrected prompts (Claude-side foreign-state
rejection, Codex-side non-qualifying admission) plus a harness re-run, with **no code edit unless a
live check failed**. Both live checks passed. Claude then closed Step 6 — accepted candidate
recorded, limitations written, mission thread ticked — on the condition Codex had stated in advance:
*"If both live checks pass, no code change is needed and the closure may clear on that evidence."*

**Rationale.** Codex's objection was correct and Claude had missed it: proving behaviour from history
is not the same as proving it from the current prompts, especially when the prompts themselves are
what changed. The live tests close that gap directly rather than adding more historical assertions.

**A process choice, disclosed rather than smoothed over.** Claude cleared the closure on the
pre-authorised condition rather than sending the live-verification evidence back to Codex for an
explicit second "resolved." The evidence is objective and independently re-checkable (blob hashes, a
file count on disk, a harness exit code), and Codex's own verdict pre-authorised exactly this
outcome. But it is still Claude, not Codex, who judged that the evidence satisfied the condition.
Flagged to the operator at the time; `step-6-live-verification.md` is written so the operator can send
it to Codex for that explicit confirmation if they would rather not accept Claude's reading of a
pre-authorised condition.

**Alternatives considered.** *Send the live-verification record back to Codex for explicit
re-confirmation before closing* — not taken, on the grounds above; left open for the operator to
request. *Treat "not resolved" as a hard block requiring a full new adjudication cycle* — not taken;
Codex's own verdict specified the narrower live-check path as sufficient, and re-opening beyond that
would have been the second broad review the mission's non-negotiables forbid.

**Recorded:** `plans/work-loop-v2-mvp/step-6-closure-check-brief.md` (the scope brief);
`step-6-closure-verdict.md` (Codex's not-resolved verdict); `step-6-live-verification.md` (both live
tests, independently verified); `step-6-candidate-review.md` §§ 2, 8.5, 9 (the closed record); commit
`882e53b` (Step 6 closed).

## 2026-08-01 — Work Loop v1 retires immediately (Proposal Decision 4, settled at pilot start)

**Context.** Proposal Decision 4 makes the v1 retirement choice a hard boundary at Work Loop v2 pilot
start: archive immediately, or archive after pilot success, but decided no later than pilot start.
Step 7 opened the pilot, so the decision came due.

Inspection before the decision established two things the Proposal's binary framing did not
anticipate. First, **v2 does not replace all of v1**: v1 carries a capability-development subsystem
(the `capability-development` skill, capability records, G1–G3 gates) and a challenged route, and the
string `capability` appears zero times across all three v2 artifacts — by design, since Proposal
Decision 1 scopes the MVP to the Direct and Standard lanes. Second, **v1 has live dependants and
in-flight work**: two live commands (`/develop-ai-resource`, `/leverage-idea`), the wording of
`docs/qc-independence.md`'s Independent Review Rule, one in-development capability record
(`prime-runtime-delegation`), the open `lean-prime-2026-07` mission, and 64 commits unmerged across
three v1 branches in git worktrees.

**Decision (operator).** **Option A — archive v1 immediately.** Claude presented three options and
recommended C (retire only the half v2 replaces; decide the capability route separately on its own
evidence). The operator chose A. Recorded as settled, not deferred.

**Not reopened.** The coverage gap was surfaced before the choice, not after it. This entry records
the decision and its blast radius; it does not relitigate the option.

**Execution is deliberately not part of this decision.** Retiring a command wired into two live
commands, one doctrine document and 64 unmerged commits is a structural change class, so it takes one
risk-aware independent Codex review before implementation (`docs/qc-independence.md` § Risk-aware
review). No such review has been sized. Execution belongs to Step 8 (Proposal `:111`) and must, in
order: resolve the 64 unmerged commits; close or migrate the `prime-runtime-delegation` record and
`lean-prime-2026-07`'s two open threads; decide the fate of the capability-development subsystem,
which A leaves with no successor; repair the six documentation and routing consumers; prune the
already-`prunable` `session/2026-07-29-work-loop` worktree; then archive the four v1 artifacts.

**Alternatives considered.** *B — archive after pilot success*: not taken; same stranding as A, later.
*C — scoped retirement, Claude's recommendation*: not taken; it concedes part of Decision 4's
anti-drift purpose and holds only if the deferred second decision carries a hard trigger.

**Recorded:** `plans/work-loop-v2-mvp/step-7-v1-retirement-decision.md` (the full record, with the
verified dependant list and the execution checklist); Proposal Decision 4 (`:38`) and Decision 1
(`:35`); `logs/missions/work-loop-v2-mvp.md` (Step 7 thread).

## 2026-08-01 — Work Loop v2 portable installation: split into a named Step 8 blocker and a post-MVP install-contract thread, rather than adopted whole

**Decision (operator, with Claude's split) — 2026-08-01. Add portable installation to the MVP pipeline, but split it on the MVP's own boundary rather than adopting the full proposal into Step 8.** **Context:** the operator raised a proposed item — make the shared core resolve from every consuming project, remove the machine-local symlink workarounds, define a canonical installation route, verify in a fresh checkout, and ensure a project cannot appear installed while its core path is broken — and asked whether it was already in the pipeline, directing "if not, we need to add it." Verified against the plan: it was **mostly not**. Only FP-2 (the bare core path) was carried to Step 8, and only as "fix the prefix". FP-1 entered Step 8 by the pilot log's OBSTRUCTION rule but appeared in **no** Step 8 item list — neither the Proposal's five items nor the mission thread names installation. The rest was FP-3, explicitly classified TRIGGER and out of MVP scope. **The classification rested on a count that was already wrong:** FP-3's reopening trigger reads "the moment v2 is installed into a third project", and a scan found v2 in **three** projects — `axcion-design-studio` holds an untracked byte-identical *copy* of the command, dated 2026-08-01 18:33, with no core, no skill and no `logs/work-loop/`. It looks installed; its first instruction cannot resolve; and being a copy rather than a link it will drift silently. The trigger had fired about an hour before FP-3 was written, unobserved. **Decision:** the bounded half is named inside the Step 8 thread — core resolution without a symlink faking a local `plans/` folder, a tracked install route for the command and skill, loud failure when the core is unreachable, and disposal of the stray copy. The full contract — `/new-project` scaffolding, the update path for existing projects, fresh-checkout verification — becomes its own **post-MVP thread**, opened rather than scheduled. **Rationale:** Step 8's own wording is "fix demonstrated blockers only" and it ends "stop; do not keep designing it"; adopting the whole proposal there would turn the MVP's final step into a distribution project, which is the shape this Proposal repeatedly refuses. The split keeps the demonstrated blocker (FP-1 was classified OBSTRUCTION — the pilot could not run until symlinks were hand-made) inside the MVP, and leaves the undemonstrated remainder behind a trigger that has now legitimately fired. **Alternatives considered:** (a) adopt item 14 whole into Step 8 — rejected as scope inflation of the MVP's stop condition, and the operator was explicitly told they may override this and widen it; (b) leave it entirely post-MVP — rejected, because FP-1 materially obstructed the first real pilot unit and the pilot's own rule routes OBSTRUCTION into Step 8; (c) treat the design-studio copy as an install and count v2 as portable — rejected, it is the failure mode itself, not evidence against it. **Consequence:** Step 8 now carries the retirement-execution obligations **and** an installation blocker, and is materially heavier than its five Proposal items suggest. One authoritative core remains the constraint; copying the core into projects is the drift the new thread exists to prevent.
