UNIT: 2026-07-29-prime-allocator-extraction-shape    STREAM: 2026-07-29-prime-allocator-extraction    PHASE: shape
REPO: ai-resources                                    BASE: 6a2cd0b119c9370c31363700f0ec9077dcb5e226    NEXT: operator

EVIDENCE

Status: complete

## What this unit was asked to produce

Per its immutable brief (`…-shape.brief.md`, unchanged): the Shape PLAN only, defining the
smallest safe package giving `/prime`'s embedded marker allocator one executable owner, with
no object-under-work edit. The brief is untouched by this closing unit, per the operator's
explicit instruction and § Artifacts (`{unit}.brief.md` is immutable).

## What was produced — claim, what was run, what was observed

**CLAIM: the plan was produced, reviewed twice and adjudicated, and the G1 package was
delivered.**
Run: `ls logs/loop/2026-07-29-prime-allocator-extraction-shape.*`
Observed: six artifacts — `brief.md`, `plan.md` (v1, `e57e72d`), `plan-v2.md` (`dcc876a`),
`plan-v3.md` (`aa6eade`, current), `review-1.md` (`c9a2b1d`, 4 findings / 3 material),
`review-2.md` (`aa6eade`, 1 material finding R2-F1). All plan revisions retained; no prior
version mutated, per § Artifacts (`{unit}.plan.md` immutable, a revision is `-v{n}`).

**CLAIM: zero edits were made to the object under work, across the whole stream.**
Run: `git status --porcelain -- .claude/commands/prime.md` → empty.
Run: `git log --oneline d047543..HEAD -- .claude/commands/prime.md` → empty.
Positive control (the same query must fire on a path the stream did touch):
`git log --oneline d047543..HEAD -- logs/loop/` → 4 commits (`aa6eade`, `dcc876a`, `c9a2b1d`,
`e57e72d`). The negative result is therefore a real absence, not a broken query.
Observed: `prime.md` is untouched in both the working tree and the stream's commit range. The
challenged route's defining property (Step 5a Shape #2) held.

**CLAIM: `prime.md`'s measured size is unchanged from the figure the plan bounded itself by.**
Run: `wc -l .claude/commands/prime.md; wc -c .claude/commands/prime.md`
Observed: 830 lines, 97,915 bytes — identical to the figure recorded when the plan was written.
Re-derived live at close, not carried from the plan.

## G1 outcome

The G1 package (plan-v3, review-1, review-2, both adjudications, the two-slice list) was put to
the operator. **Decision returned: changes — do not build the allocator-extraction plan.**

Operator's stated reason, recorded verbatim rather than paraphrased: *"The package solves only
the 138-line allocator boundary and would preserve the larger ownership problem. The real need is
for /prime to become a thin orientation-and-dispatch command."*

This is a decline of the package with the need redirected, not a request for a plan-v4. The
operator's instruction was explicit on both halves: resolve this unit under the contract without
changing its immutable brief, and open a fresh Frame unit rather than expanding this stream.
No `-v4` was written; the brief was not edited.

**Consequence: no Build unit follows, so this Shape unit is its stream's last unit.** The stream
closes in the same commit and every `logs/loop/2026-07-29-prime-allocator-extraction-*` file is
deleted there, per § Artifacts (retention is per stream). Recoverable at `aa6eade`.

## Two contract defects found while closing this unit — reported, not worked around

**(1) The four-outcome axis has no token for a G1-declined package, and its gloss contradicts the
challenged route's own structure.** § Block formats line 196 reads *"The first changed the object
under work; the other three did not, and all three take § Closing without a change."* But a Shape
unit **never** changes the object under work — that is stated as the route's defining property at
Step 5a Shape #2 and again at contract line 91. Under a literal reading of line 196, every Shape
unit on every challenged stream would have to take § Closing without a change, which closes the
stream in the same commit — making it structurally impossible to reach Build, Prove or Land. The
challenged route could never execute past its second phase.

The reading applied here: line 196's clause is **descriptive of the common case, not
definitional**, and `close` means *the unit's own deliverable landed* — whatever that deliverable
is. For Shape the deliverable is the plan, and it landed, was reviewed twice and was adjudicated.
What did not land is the build, which was never this unit's scope. Closed `close`.

**(2) § Closing without a change's durable-pointer requirement under-covers its own rationale.**
Its trigger list names only `rejected-premise`, `route-unavailable` and `routed-out`. Its
rationale at line 216 is that those three *"leave nothing — no change, no record for
non-capability work, and artifacts deleted at stream close."* All three conditions hold for this
`close` as well: the repository is unchanged, there is no capability record, and § Artifacts
deletes every stream artifact in this commit. So the rationale demands the pointer where the
trigger text does not reach it. **The pointer is written**, because a stream that consumed three
plan revisions and two review rounds and left no trace is precisely the gap that section exists to
close — and without it the same allocator-extraction brief returns in a week.

Both are defects in `docs/work-loop.md`, not in this unit's execution. Neither was silently
resolved. This is the second consecutive unit on this stream family to find a real contract tension
at closing time (the first: § Closing without a change's evidence-and-deletion single-commit
requirement, recorded in `logs/decisions.md`, 2026-07-29).

## What this unit did NOT establish

The plan's own technical content was never disproved. Review-1's three material findings and
review-2's R2-F1 were all adjudicated `fixed` and each was verified empirically before acceptance.
The package was declined on **scope**, not on correctness — it was judged too small a boundary for
the real need, not wrong within its boundary. Nothing here licenses a later session to treat the
allocator analysis as unsound; it is superseded, not refuted.

LIMITATIONS:
- The G1 decision is an operator judgement about scope. This unit did not independently test the
  operator's claim that the allocator boundary "preserves the larger ownership problem" — that is
  precisely the question handed to the fresh Frame unit, and answering it here would pre-empt the
  Frame it was redirected to.
- The `−114 ± 10` line delta the plan predicted was never measured against a real edit, because no
  edit was made. The prediction stands untested and now expires with the stream.
- The two contract defects above are reported, not fixed. Fixing `docs/work-loop.md` is a change
  to a shared `ai-resources` resource and is out of this unit's brief scope; it needs its own unit.
- No independent review was run on this closing evidence. Frame and Land carry no review by the
  route's own structure, and a G1-declined close is not a phase the contract assigns one to.
