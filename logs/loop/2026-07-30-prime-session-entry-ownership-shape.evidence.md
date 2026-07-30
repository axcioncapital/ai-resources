EVIDENCE
UNIT: 2026-07-30-prime-session-entry-ownership-shape
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: shape
REPO: ai-resources
BASE: 49c8582
NEXT: operator — answer G1; then Claude closes this unit and opens Build S1

**Capability:** prime-runtime-delegation

**STATUS: OPEN, AWAITING G1.** This file is deliberately not marked `Status: complete`. The G1 gate sits
*inside* the Shape unit (`docs/work-loop.md` § The challenged route), so the unit is not finished until
the operator answers. Tier 1 will therefore resume it. Do not re-run any phase recorded below.

---

## 1. Premise verification — all confirmed, none rejected

```
PREMISE: confirmed — prime.md is 411 lines, byte-identical to the Frame unit's object
  · ran: wc -l .claude/commands/prime.md ; git diff --stat 8c573af HEAD -- .claude/commands/prime.md
  · observed: 411 lines; empty diffstat

PREMISE: confirmed — all six removal targets exist at HEAD, positions re-derived live
  · ran: six targeted greps over prime.md
  · observed: STRUCTURAL_RISK :399 :401 :407 · legacy QC :131 · model alignment :198 :200 :201 :202
    + brief line :228 · multi-item auto :261 :371 · log-trio prefetch :61 :62 · urgent triage :172-197

PREMISE: confirmed — prime-marker.sh reads session-notes.md but writes neither it nor .prime-mtime
  · ran: grep -n session-notes / write-site scan / grep -c prime-mtime on logs/scripts/prime-marker.sh
  · observed: reads at :83 :86; 11 write sites, none to session-notes.md; prime-mtime count = 0
  · POSITIVE CONTROL: the same prime-mtime grep returns 5 in prime.md, so the zero is a real absence

PREMISE: confirmed — docs/session-marker.md:339 still cites the removed Step 8c.2
  · ran: grep -n "8c\.2" docs/session-marker.md
  · observed: :339 "Cited by `/prime` Step 8c.2, which holds the mechanism"

PREMISE: confirmed — the /prime step-citation surface is enumerable
  · ran: recursive grep over .claude, docs, skills (both roots), excluding audits/ and logs/
  · observed: 54 live sites across 17 files
  · POSITIVE CONTROL: the enumerating pattern independently re-found the known dangling 8c.2 at :339
```

**No load-bearing premise rejected.** No edit was made to `prime.md`, to any script, or to any consumer
during this unit — Shape's defining property on the challenged route.

## 2. What this unit produced

| Artifact | Commit | Note |
|---|---|---|
| `…shape.brief.md` | `4826796` | Claude-authored; no independent framing (recorded weakness) |
| record pointer `active_unit` | `a87d5dc` (SO repo) | staged by pathspec only |
| `…shape.plan.md` (v1) | `eebaea0` `6cf5f4f` | immutable, retained |
| `…shape.review-1.md` | `49c8582` | Codex verbatim — REVIEW block + adjudication assessment |
| `…shape.plan-v2.md` | `904faf0` | supersedes v1; dispositions at § 8 |

## 3. Measurement — the central deliverable

**Budget A: `prime.md` 411 → 186 lines** against a frozen ≤300 target; 114 lines of slack, with **zero
compression credited** to any region not drafted in full. **Budget B: +12 lines** to other model-read
prompts against −225 removed, so the move is delegation and not relocation. **Budget C** (three `.sh`
files) is excluded by design — scripts are executed, never read into a model's context.

**Every cell is script-counted, and that was necessary.** Hand-counts were attempted three times and were
wrong every time: 11/28/16 against an actual 12/31/17, then a drafted total of 192 against an actual 186.
The predecessor stream's ≤300 miss (413 delivered) came from the same error class. The mitigation — parse
the fenced blocks and take `len(split('\n'))` — is what makes the number at G1 trustworthy.

## 4. Decisions taken

- **C2 renumbering: preserve retained identifiers, repoint only retired ones, never renumber to close a
  gap.** Basis: of 54 live citation sites, 38 point at retained steps and cost nothing if identifiers
  hold; renumbering would convert all 38 into must-touch edits on a surface where a miss fails silently.
  Endorsed by review-1 Q2.
- **S6 is mandatory, not slack.** v1 made it optional; review-1 M1 correctly called that drift — S1–S5
  could hit the line target while leaving the retired post-dispatch responsibilities intact, passing the
  proxy and failing the mandate.
- **The promotion owner is a backward-looking idempotent sweep**, not a this-session hook. Promotion at
  wrap alone would lose findings from any session that never wraps, which today's Step 3 still catches by
  re-grepping at every `/prime`. Backward-looking makes a missed wrap a delay, not a loss.
- **"Atomic" withdrawn** for "single complete owner" plus a written failure/recovery table. The word was
  claiming a property the design did not define.
- **Two review findings reduced rather than accepted**, both argued in plan-v2 § 8: one injected-failure
  test rather than a matrix (all three partial states are operator-visible, never silent); F-BEHAVE
  bounded to 14 route-and-guard rows rather than an inventory of every executable rule — on the grounds
  review-1 itself gives for why that inventory is undefinable.
- **Review-2 was queued and then dropped.** `docs/work-loop.md` § The challenged route permits a second
  round only when corrections changed what the first verdict rested on, "not on a general wish for more
  assurance." Codex had already stated its four approval conditions and plan-v2 meets all four, so a
  confirming round is exactly the case the contract excludes. Recorded because dropping a review must be
  a reasoned act, not an omission.
- **Slice count reduced 6 → 5.** The old S2's 8-block deletions (multi-item auto, `STRUCTURAL_RISK`) are
  wholly subsumed by S6's drafted replacement of that block; running both would edit the same lines twice.

## 5. Independent review

**Round 1 — Codex, 2026-07-30, object `…shape.plan.md` (v1). Verdict: REVISE BEFORE G1.** Six material
findings (M1–M6). Dispositions: **M1 fixed · M2 fixed and extended beyond the finding · M3 fixed ·
M4 fixed · M5 fixed in part, reduced in part · M6 fixed in part, reduced in part.** Full adjudication with
reasons: `…plan-v2.md` § 8. Two premise-dimension corrections were accepted and applied: observed versus
inferred evidence separated, and Budget A recounted separately from additions to other owners.

**M3 was verified independently rather than accepted on assertion:**
`.claude/hooks/detect-concurrent-session.sh` emits `{"systemMessage": …}` and has **0** persistent write
sites (positive control: `prime-marker.sh` has 11), so a shell collector genuinely cannot read the hook's
result. v1's promised `LIVE_FOREIGN` collector output was impossible and has been removed.

## 6. G1 package — held for the operator

The plan (v2), the review (round 1, verbatim), the adjudication (plan-v2 § 8), and the five-slice list:
**S1** session-entry owner + locator (release blocker) · **S2** promotion owner then retire Step 3 ·
**S3** git sync out + two small deletions · **S4** state collection out · **S5** dispatch redraft.

---

LIMITATIONS:

- **The brief and both plans are Claude-authored.** The removal list is a transcribed operator decision,
  not analysis this stream performed. Verification established that each target *exists* and what removing
  it *costs* — never that removing it is correct.
- **Nothing has been built or run.** Budget A = 186 is a projection from drafted text, not a measurement
  of a file that exists. It becomes a measurement only when `wc -l` runs against the real `prime.md` at
  Prove. This is the single most important thing not yet proven.
- **The three scripts do not exist.** Their correctness is entirely unproven. `prime-collect.sh` subsumes
  five steps and four read disciplines and is the largest behavioural risk in the stream.
- **No falsification criterion has been executed.** F-LINES, F-ROUTES, F-LOCATOR, F-BEHAVE (14 rows),
  F-ENTRY, F-ORDER, F-RECOVER, F-TESTS, F-BACKLOG, F-LOOP, F-HOOK and F-DUP are all **unassessed** and
  must stay so until Build and Prove run them. None is inheritable from the predecessor stream.
- **Only one dangling citation was checked** — the one the predecessor's Prove unit found. A full
  citation sweep across all 17 live files against HEAD has not been re-run.
- **The 54-site citation surface excludes `audits/` and `logs/`** as historical records. If any audit file
  is treated as a live contract, that exclusion is wrong and the repoint set is larger than 16.

*(No `Status: complete` marker: the unit is open at G1 by design. It is added, with the operator's G1
decision and the CLOSE block, when the gate resolves.)*

---

# APPENDED 2026-07-30 — review round 2

**STATUS: still OPEN, awaiting G1.** BASE for this section: `bc8edd6`.

## 7. Round 2 — Codex, object `…plan-v2.md`. Verdict: REVISE BEFORE G1

Four material findings (M1–M4) plus R1–R4 answers and one minor. Transcribed verbatim to
`…shape.review-2.md` (`bc8edd6`). Round-2 justification under `docs/work-loop.md` § The challenged route:
plan-v2 redesigned S3's owner, withdrew F-RULES for F-BEHAVE and re-scoped S6 from optional to mandatory —
each changed something review-1's verdict rested on. **§ 6 of this file recorded that review-2 had been
dropped as a reasoned act; that reasoning is superseded by the round having been run.**

## 8. Every finding was verified against the object before adjudication — none accepted on assertion

```
M1: CONFIRMED — all five hand-backs read at HEAD
  · ran: sed over session-start.md 440-470, 340-355; session-plan.md 228-255
  · observed: :452 "return control to the invoking /prime branch ... 8a.3.d ... 8b.3.d begins execution
    immediately" · :465 "/prime 8c.11 still owns the review-sizing disclosure and 8c.12 owns the execution
    start" · session-plan.md :235-239 "Returning to /prime ... without beginning execution" · :241-245
    "The gate belongs to the caller ... /prime 8a ... Step 8a.d owns the pause" · :349 "/prime owns
    STRUCTURAL_RISK alone"
  · consequence confirmed: with v2's Step 9, three routes dead-end at the hand-back

M1 (8c.9 sub-claim): CONFIRMED, and larger than review-2 stated
  · ran: recursive grep "8c\.[0-9]" over .claude, docs, skills (both roots), excluding audits/ and logs/
  · observed: 10 lines outside prime.md — 8c.9 × 7, 8c.11 × 2, 8c.12 × 2, 8c.5 × 1, 8c.2 × 1
  · v2 § 4 counted 8c.9 as ONE retained site and never enumerated 8c.5 / 8c.11 / 8c.12 at all

M2: CONFIRMED, and the rule violation is stronger than the race
  · ran: grep "lost.update" over docs/ and .claude/ ; read docs/commit-discipline.md § Maintenance-owned
    in-place mutations
  · observed: :132 classifies these two logs' in-place mutation as a lost-update surface confined to
    "dedicated, single-purpose sessions"; the rule states "An ordinary work session appends only; it never
    reaches into an existing entry", and names this exact drift — "a new command that 'helpfully' flips a
    status as a side-effect of ordinary mid-session work would violate it"
  · /wrap-session is an ordinary work session. v2's <!-- promoted --> stamp would have been the rule's
    first violation, independent of any race

M3 (CWD_REPO half): CONFIRMED
  · ran: read prime.md:389 and v2 §§ 6.1, 6.2, 6.4
  · observed: CWD_REPO comes from Step 0 today; v2's drafted Step 0 returns only SYNC, and no drafted
    block defines CWD_REPO. v2's 8g cross-repo guard could not have executed

M3 (telemetry half): REJECTED on evidence — see plan-v3 § 8
  · ran: read the removal list (§ 1 above, prime.md :61-62) against prime.md :67 and ai-resources/CLAUDE.md
    § Session Telemetry
  · observed: the removal target is the log-trio PREFETCH at :61-62; the telemetry-gap nudge is a separate
    paragraph at :67, and CLAUDE.md § Session Telemetry places the nudge on /prime by name
  · what WAS unfixed and now is: v2 deleted the prefetch, kept the nudge, and never stated how the nudge
    still gets its input

M4: CONFIRMED, and the real state count is six, not three
  · ran: read logs/scripts/prime-marker.sh:140-158 ; grep "session-marker-" .claude/hooks/detect-concurrent-session.sh
  · observed: FOUR persistent writes precede the header — mkdir claim (:144), owner breadcrumb (:146),
    logs/.session-marker (:156), logs/.session-marker-${SESSION_ID} (:158). "Marker write fails → nothing
    written" is false
  · observed: the hook keys on logs/.session-marker-* at :158 and :162, so a failure between write 3 and 4
    leaves the session invisible to concurrent detection — a blast radius into a different subsystem that
    v2's three-row table could not express

MINOR (Budget C): CONFIRMED — v2 § 2 lists four script owners (one extended, three new) plus the test
  script, while §§ 0 and 3 said "three scripts"
```

## 9. One defect found by this unit that review-2 did not raise

```
8c.2 IS NOT A DANGLING CITATION — v2 § 4 and § 1 of this file are both wrong
  · ran: read prime.md 8c sub-step 2 ; read docs/session-marker.md:339 in context
  · observed: prime.md 8c.2 is the per-item done-condition presence-check, and :339 sits in
    § Auto-mode done-condition check citing it as the step that "holds the mechanism" — a correct,
    mutual cross-reference
  · ROOT CAUSE: the premise at § 1 above was recorded "confirmed" on a grep proving the STRING was
    present. It never tested whether the referent existed. A positive control was run for the citation
    ENUMERATOR and for the prime-mtime and hook-write greps, but not for this one
  · CONSEQUENCE AVOIDED: S1 was scheduled to "fix" it, which would have broken a correct citation
```

This is the evidence standard's own failure mode — an empty-or-present result treated as evidence without
a control. It is recorded rather than quietly corrected, and named as a residual weakness in plan-v3 § 7:
the same error class was not systematically swept for across the rest of the premise set.

## 10. Measurement — recounted, every cell script-parsed from plan-v3 itself

| Budget | v2 claimed | v3 measured | Why it moved |
|---|---:|---:|---|
| **A** — `/prime` lines | 186 | **188** | v2 counted its own fence line as `/prime` content at §§ 6.1 and 6.3 (13/19 vs 12/18); §§ 6.2 and 6.4 grew by the `CWD_REPO`, telemetry-split and renumbering corrections |
| **B** — other model-read prompts | +12 | **+48** | v2's figure predated any inspection of the receiving owners. Review-2 M1 predicted this |
| **C** — script owners | "three" | **four** + a test script | one extended, three new |

**A = 188 against ≤300, slack 112. 223 lines leave `/prime`; 48 arrive elsewhere — a 4.6 : 1 ratio, so the
move remains delegation rather than relocation.** Verified by re-parsing plan-v3's own fenced blocks and
recomputing both totals: A = 188 and B = +48 both reproduce exactly.

**A fourth hand-count error was found and corrected in this round** (v2's fence-line miscount). Three
prior ones are recorded at § 3. Every figure in plan-v3 is script-produced.

## 11. G1 package — held for the operator, corrected

The plan (**v3**), both reviews verbatim (round 1 and round 2), the adjudication of each (plan-v3 § 8),
and the six-slice list: **S1** session-entry owner + locator (release blocker) · **S2** removals needing
no new owner, incl. `STRUCTURAL_RISK` and its four downstream sites · **S3** promotion owner then retire
Step 3 · **S4** git sync out · **S5** state collection out · **S6** post-dispatch transfer, now including
real edits to `/session-plan` Step 8 and `/session-start` Step 4.

**One explicit G1 decision item:** plan-v3 declines review-2's instruction to remove the telemetry-gap
nudge, on the evidence that `ai-resources/CLAUDE.md` § Session Telemetry places it on `/prime` by name
(plan-v3 § 8). If the operator's settled direction was to remove it, that rule is retired in the same
slice and Budget A falls further.

---

LIMITATIONS (round 2 — superseding nothing above; all round-1 limitations still stand):

- **Still nothing built or run.** A = 188 remains a projection from drafted text. It becomes a measurement
  only when `wc -l` runs against a real `prime.md` at Prove.
- **Budget B could rise again.** The hand-back sweep grepped `/prime` **step identifiers**. A downstream
  command that returns to `/prime` without naming a step identifier is invisible to it. Named, not closed.
- **Four scripts still do not exist.** `prime-collect.sh` remains the largest unproven behavioural surface.
- **Every falsification criterion remains `unassessed`** — including the six added this round (R1–R8,
  F-PROMOTE-RACE, F-NO-SOURCE-WRITE, F-CWDREPO) and the rewritten F-RECOVER. None is inheritable.
- **Five of six marker partial states will remain unassessed by design** (plan-v3 § 5 F-RECOVER), with a
  stated reopen trigger.
- **Promotion reachability is deliberately reduced** — findings from a never-wrapped session now wait for
  the next wrap in that repo rather than the next `/prime`. Accepted with a one-week trigger, not fixed.
- **The `8c.2` error class was not swept for.** One premise was found confirmed-on-partial-observation;
  the rest of the premise set was not re-tested for the same defect.

---

# G1 — RESOLVED 2026-07-30

**Operator decision: APPROVED.** The six-slice plan at `…shape.plan-v3.md` is approved as corrected, at
the scope stated there. Build begins in the **next** session, one unit per slice, starting with S1.

**Telemetry item resolved with the approval.** The G1 package carried one explicit decision item (§ 11):
plan-v3 declined review-2's instruction to delete the telemetry-gap nudge, on the evidence that
`ai-resources/CLAUDE.md` § Session Telemetry places that nudge on `/prime` by name. Approving plan-v3 as
written adopts that resolution — **the nudge is retained**, its input moves into `prime-collect.sh` as
`TELEMETRY_GAP`, and the stale `CLAUDE.md` parenthetical describing how `/prime` reads the log is repaired
in S5. Reversible at any Build unit: retiring the `CLAUDE.md` rule would remove B12 and the
`TELEMETRY_GAP` block and lower Budget A further.

Status: complete

CLOSE
UNIT: 2026-07-30-prime-session-entry-ownership-shape
OUTCOME: **close** — the work landed. The unit's deliverable was the plan; it exists, was reviewed twice,
and is approved.

**Commits:** `4826796` (brief) · `eebaea0` `6cf5f4f` (plan v1) · `49c8582` (review-1) · `904faf0`
(plan v2) · `a1cd788` (evidence) · `bc8edd6` (review-2) · `eb20386` (plan v3) · `77ca339` (evidence,
round 2) · this commit (G1 + close).

**What closed:** the Shape phase. Two independent review rounds run and adjudicated — six findings in
round 1, four plus one minor in round 2, plus one defect this unit found in its own premise work
(§ 9). Every round-2 finding was verified against the object before adjudication; one was rejected on
cited evidence rather than accepted.

**The stream does NOT close with this unit.** `2026-07-30-prime-session-entry-ownership` stays open
through Build (S1–S6), Prove (G2) and Land (G3). Per `docs/work-loop.md` § Artifacts, every
`logs/loop/2026-07-30-prime-session-entry-ownership-*` file is **retained until the stream closes** — the
Prove unit must be able to read this unit's plan and both reviews on disk, days later and after any
number of `/clear`s. Do not delete them at Build.

**NEXT: Build unit S1** — `2026-07-30-prime-session-entry-ownership-build-1`. Opens in a new session, per
operator direction. `/work-loop` will resume it from the record (Tier 3, `active_unit: none` with the
next action stated). S1 is the release blocker: complete the session-entry owner and fix the script
locator. Nothing in `prime.md` has been modified by this unit.

*(Nothing was built, and that is Shape's defining property on the challenged route. Every falsification
criterion in plan-v3 § 5 remains `unassessed` and must stay so until Build and Prove execute them.)*
