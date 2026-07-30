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
