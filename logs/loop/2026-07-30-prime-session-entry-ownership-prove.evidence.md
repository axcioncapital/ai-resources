EVIDENCE
UNIT: 2026-07-30-prime-session-entry-ownership-prove
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: prove
REPO: ai-resources
BASE: 2a651a0^ (pre-S1 baseline; `prime.md` 411 lines)
NEXT: operator — answer G2

**Capability:** prime-runtime-delegation

**STATUS: OPEN, AWAITING G2.** Every criterion plan-v3 § 5 declared is measured below against the
**running** implementation, not against the diff. Plan-v3's own rule is applied without exception: *a
criterion that cannot be run is recorded `unassessed` — never `pass`.* Nine rows are `unassessed` and
are listed as prominently as the passes.

---

## 0. What changed since Codex's post-implementation review

Codex reviewed S1–S6 and returned **changes requested**: five P1 runtime defects plus incomplete route
evidence. All five are closed in `d39572a`, each with a regression test carrying a control proving it
can go red. R1–R8 were subsequently passed by Codex.

Every defect was the same shape — **the code reported success while doing nothing, or the wrong
thing** — which is why none of them surfaced in ordinary use. That shape is the finding, not the five
instances: the stream extracted mechanical work into scripts whose failures were, until now, invisible
to their callers.

| # | Owner | What it did wrong | What closes it |
|---|---|---|---|
| 1 | `prime-session-entry.sh` | both marker writes were unchecked redirections; a failed write returned 0 and the run continued into the header append and the mtime stamp, leaving a partial state the next `/prime` cannot tell from a complete one | both writes tested; per-id write moved **first** so the forbidden shared-without-per-id state (`docs/session-marker.md` § Both-or-neither) is structurally unreachable; a failed shared write rolls the per-id file back to the neither state |
| 2 | `prime-sync.sh` | the fetch result was discarded, so an unreachable remote let the behind-check read a stale tracking ref and report `up to date` | fetch failure classified **before** the upstream state is consulted; upstream existence settled first, because `git fetch` also exits non-zero when there is no remote at all |
| 3 | `promote-findings.sh` | the DONE test searched the whole status line, so `applied` inside `partially applied` read as terminal and silently dropped entries whose own body says half the problem is open | terminal status parsed from the value's **head**; strike-through spans stripped first so a retracted `~~OPEN~~` still reads as closed |
| 4 | `promote-findings.sh` | the EXIT trap cannot run after SIGKILL or a hard crash, so a leftover lock disabled promotion permanently and silently | stale-owner recovery — dead recorded pid reclaims immediately; 10-minute age backstop covers pid reuse and the crash window; a pid-less lock stays **live**, since a just-won lock is briefly pid-less and reclaiming there would break the mutual exclusion the lock exists for |
| 5 | `prime-collect.sh` | the telemetry test was gated on `usage-log.md` existing, so a consumer that had never captured telemetry — the strongest possible gap — reported `TELEMETRY_GAP: no` | existence folded into the staleness test; the trivial-entry exemption is retained |

**Defect 3 was measured before it was accepted, not after.** Running old and new logic across the real
`improvement-log.md` and `friction-log.md` showed exactly **4 entries change state, all genuinely
open**, and **zero false-opens**. One entry (`improvement-log.md:872`) is a retracted `~~OPEN — no fix
applied.~~` followed by a real `**CLOSED — FIXED**`; a naive anchor would have wrongly reopened it,
which is why strike-through spans are stripped first. The live medium-high `/clarify` finding at
`improvement-log.md:1329` now reaches `next-up.md`, and both source logs stayed byte-identical.

---

## 1. Stream-level criteria

```
F-LINES: PASS
  · ran: wc -l .claude/commands/prime.md ; git show 2a651a0^:… | wc -l
  · observed: 264 lines, against a 300 ceiling and a 411-line base — 147 removed, 36 of headroom left
  · Budget B: +40 across the three receiving commands (session-start +9, session-plan +15,
    wrap-session +16), against a drafted +48. Codex independently measured +42 net across all
    model-read files excluding /prime. Under budget; no finding.

F-LOCATOR: PASS — both halves, from a path containing a space
  · ran: prime-session-entry.sh from a consumer root at "…/spaced probe/consumer repo"
  · observed: all four artifacts written INTO the calling repo (shared marker, per-id oracle,
    marker-bearing header, .prime-mtime), exit 0
  · observed (second half): git status on ai-resources' own logs/.session-marker, logs/.prime-mtime
    and logs/session-notes.md returned empty — nothing leaked into ai-resources

F-ROUTES: PASS (Codex, 2026-07-31)
  · the three retained routes exercised from real project-consumer roots, per R1-R8 below
```

---

## 2. F-BEHAVE — the retained-behaviour register

### R1–R8 — the rows S6 exists to satisfy

```
R1-R8: PASS — all eight, Codex, 2026-07-31
```

These are the downstream-outcome rows review-2 R3 added: numbered / free-text / auto × engineered /
direct, plus `auto N` resolution and the wrap reminder on every terminal path. They are what proves
ownership actually transferred; `B14` alone could not.

### B1–B14 — nine measured, five unassessed

**Split each row into the half a script owns and the half the model owns.** The collector's output is
the input `/prime` renders from; it is also the half that can regress *silently*, because no human sees
it. Measuring it is not the same as observing the rendering, and every row below says which half it
proves. Each "empty" result carries a positive control — an inert control means the result proves
nothing, and one was caught inert and fixed before being trusted.

```
B4:  PASS (rule)   the N-auto precedence rule discriminates as written
  · ran: the rule's own regex ^[1-6][[:space:]]+auto$ against six real inputs
  · observed: "2 auto" and "2  auto" -> auto mode item 2; "auto", "2", "7 auto", "2 autos" -> not
    N-auto. So `2 auto` cannot be misread as a bare-number selection of item 2.

B6:  PASS (operands only)
  · observed: with an active mission in a fixture repo, CWD_REPO and the MISSIONS block are both
    emitted, so the cross-repo guard has both operands to compare
  · NOT proven: that the stop PRECEDES the write. That ordering is the whole point of B6 and needs
    a live run.

B8:  PASS (input)   no candidates -> NEXT_STEPS and NEXT_UP both empty
  · control LIVE: a real dated `### Next Steps` entry DOES appear, so the empty result is meaningful
  · the control was first written wrong (undated header), came back INERT, and was fixed — the
    original B8 "pass" was measuring nothing

B9:  PASS (input)   no plan file -> POSITION block not emitted at all
  · control LIVE: with a plan file the cascade DOES emit

B11: PASS (input)   no active missions -> MISSIONS empty
  · control LIVE: an active mission DOES appear

B12: PASS at the collector contract
  · ran: prime-collect.test.sh TEST 8, incl. the new absent-usage-log case
  · observed: TELEMETRY_GAP=yes on a real gap; =yes when usage-log.md is absent entirely;
    =no once the date appears; =no on a trivial entry
  · NOT proven: /prime's RENDERING of the nudge.

B14: PASS (negative half only)
  · observed: /prime ends at Step 9, "Stop. /prime ends at dispatch"; no execution turn follows
  · always insufficient alone — R1-R8 carry the positive half

B1 / B3 (mechanism, STATIC only): {gate:post-plan} and {gate:auto} both present in the dispatch
  region. Static presence is not behavioural proof; R1/R2 and R5/R6 carry that.

STILL UNASSESSED — B2, B5, B7, B10, B13:
    B2  free-text dispatch WITHOUT the token
    B5  plan-mode guard writes nothing (no marker, no header, no mtime)
    B7  wrong menu number asks once and re-classifies
    B10 mission auto-binds from a [mission:<id>] item without prompting
    B13 done-condition check holds an activity-only item
  · B5 is the one that matters most: it is a WRITE-SUPPRESSION guard, so a regression is silent
    and lands in real repo state rather than in a message. B6's ordering half is second.
```

---

## 3. S1-specific — all four PASS

```
F-ENTRY:   PASS — prime-allocator.test.sh TEST 9; one call leaves all four artifacts
F-ORDER:   PASS — TEST 10; header embeds ${MARKER} (allocation preceded the append) and
                  .prime-mtime's own mtime ≥ session-notes.md's at sub-second resolution,
                  WITH the reversed-order control observed red
F-RECOVER: PASS — TEST 12; failure injected after write 4, before the header append.
                  Observed: both markers present, no header, no mtime; the next run allocates
                  S2 and completes. The other five partial states remain `unassessed` by design.
F-TESTS:   PASS — 46 assertions, 0 failed, all under ZSH (baseline 19). Green shown load-bearing:
                  the fail-safe-seed mutant returns S1 over S5 (TEST 13 control).

NEW — F-MARKER-WRITE (TEST 12b, added by the P1-1 fix): a failed marker write stops the sequence.
  · (a) unwritable shared marker → exit 1, per-id rolled back, no header, no mtime
  · (b) unwritable per-id marker → exit 1, shared marker never written (invariant held)
  · control: the unchecked-write mutant DOES append a header, proving the probe is live
```

---

## 4. S3-specific — all four PASS

```
F-BACKLOG:       PASS — sweep over copies of the real logs promoted 33 items; the pre-change
                        Step 3 emit is covered, and the medium-high /clarify finding that the
                        P1-3 defect had been dropping is now present
F-LOOP:          PASS — promote-findings.test.sh TEST 4: a new finding promotes, a rerun adds
                        no duplicate, four distinct promotion ids
F-PROMOTE-RACE:  PASS — TEST 8: two simultaneous sweeps leave three items and three ids, source
                        logs byte-identical, lock released
F-NO-SOURCE-WRITE: PASS — static inspection: no write path in the sweep targets either source
                        log; confirmed behaviourally by byte-identical shasums after every run

NEW — TEST 8b (stale-owner recovery) and TEST 8c (F-PARTIAL) added by the P1-3 and P1-4 fixes.
Suite 35 → 46 assertions, 0 failed.
```

---

## 5. S5-specific — both PASS

```
F-HOOK:    PASS on the MECHANISM, not just the output
  · observed: prime-collect.sh contains no read of logs/.session-marker* at all, so the
    concurrent-session advisory is consumed from the hook's message and never rescanned.
    Consumption and rescan produce the same advisory, which is exactly why the criterion
    tests the mechanism.

F-CWDREPO: PASS
  · ran: prime-collect.sh from a consumer root that is not ai-resources, path containing a space
  · observed: CWD_REPO named the calling repository, intact across the space
  · this supersedes S4's hand-off note ("S5's collector must not re-derive CWD_REPO"), written
    before review-2 M3 made the block part of the collector's counted interface. Corrected in the
    capability record 2026-07-31.
```

---

## 6. F-DUP — the duplication register

| # | Expected fate | Verdict | Observation |
|---|---|---|---|
| D1 | → `prime-sync.sh` | PASS | behind-check present; suite TEST 2 shows the pull skipped on an up-to-date repo, with a mutant control proving the oracle live |
| D2 | → `prime-collect.sh` | PASS | last-entry read still anchored on `^## [0-9]` |
| D3 | scan → collector | PASS | COMMITS scan still spans cwd + ai-resources + siblings |
| D4 | → hook message | PASS | see F-HOOK |
| D5 | → `prime-collect.sh` | PASS | plan-position cascade present in the collector |
| D6 | → `prime-collect.sh` | PASS | 14 bounded reads, no whole-file read of the plan |
| D7 | deleted with Step 3 | PASS | no `/prime` Step 3 backlog-emit remains |
| D8 | three writer contracts repointed | PASS | `wrap-session.md`, `prime-collect.sh` and `improvement-log.md:13` all name `promote-findings.sh` / `next-up.md` as the owner; their remaining "Step 3" mentions are retirement prose ("replaced `/prime` Step 3", "Step 3.5"), not live citations — **verified by reading each match, not by grep count** |
| D9 | → `prime-session-entry.sh` | PASS | F-ENTRY + F-ORDER |
| D10 | leaves with S6 | PASS | R2, R4, R6 (Codex) |
| D11 | stays in `/prime` | PASS | done-condition check retained at `prime.md:218-227`, citing `docs/session-marker.md` § Auto-mode done-condition |
| D12 | deleted with `STRUCTURAL_RISK` | PASS | the two remaining mentions (`:237`, `:256`) are parenthetical retirement notes recording the deletion; no live reference |

**Two of these rows were first measured as FAIL by a naive grep (D8, D12) and corrected by reading the
matches.** Recorded because the same failure mode is already on this repo's record —
`improvement-log.md:48` documents a rule declared contradictory after reading one of the four files
that define it. A grep count is not an observation.

---

## 7. Mission validation-contract lines

| Contract line | Verdict | Observation |
|---|---|---|
| `wc -l` ≤ 300, re-derived live at close | PASS | 264, derived this session, not carried from a plan |
| duplication-declaration grep returns zero, with a positive control | **PARTIAL** | zero now — confirmed. The control does **not** fire at this stream's base (`2a651a0^` → 0 hits): the declarations were removed on 2026-07-29 by `1b96aa6`, a **prior** stream. Under the contract's exact regex the pre-removal file shows **1** hit, not the 8 the mission records. The zero is real; the "8 → 0 across this stream" framing is not. |
| four unloseable properties demonstrated by execution | PASS (Codex) | carried by R1–R8 |
| `prime-allocator.test.sh` passes against the running implementation | PASS | 46/46, baseline 19 |
| no prose moved onto an always-loaded surface | PASS | `ai-resources/CLAUDE.md` unchanged at 81 lines; no new `@`-imports in either CLAUDE.md |
| new durable script qualified through `/develop-ai-resource` | **unassessed** | the capability record exists (`prime-runtime-delegation`) and now records S1–S6 plus the defect closure, but no `/develop-ai-resource` qualification ran for `prime-sync.sh`, `prime-collect.sh` or `promote-findings.sh` |
| marker grammar and session-artifact filenames observably unchanged | PASS | F-ENTRY/F-ORDER plus the spaced-path locator run |

---

## 8. Totals

```
prime-allocator.test.sh   46 passed, 0 failed   (was 19 at stream open, 38 at S1 close)
prime-sync.test.sh        33 passed, 0 failed   (was 28)
prime-collect.test.sh     57 passed, 0 failed   (was 55)
promote-findings.test.sh  46 passed, 0 failed   (was 35)
                         ─────────────────────
                         182 passed, 0 failed   (was 156)

.claude/commands/prime.md   264 lines   (base 411, ceiling 300)
Budget B                    +40         (drafted +48)
```

---

## 9. What is NOT proven — read this before answering G2

1. **Five B-rows are unassessed** (B2, B5, B7, B10, B13), down from nine. Four more (B6, B8, B9, B11)
   are proven only on their **collector half** — the input is correct, the rendering is not observed.
   **B5 matters most**: it is a write-suppression guard, so a regression is silent and lands in real
   repo state rather than in a message. B6's ordering half ("the stop precedes the write") is second.
2. **The telemetry nudge's rendering is unassessed.** The collector returns the right answer; that
   `/prime` surfaces it has not been observed live.
3. **No `/develop-ai-resource` qualification** ran for the three scripts built after `prime-session-entry.sh`.
   The mission's validation contract requires it and it is outstanding.
4. **F-RECOVER's other five partial states remain unassessed by design** (plan-v3 review-2 M4). State 3
   (per-id marker missing) reopens the criterion if ever observed — its blast radius reaches
   `detect-concurrent-session.sh`.
5. **Codex has not re-reviewed since `d39572a`.** Its post-implementation review declined on five P1s;
   those are fixed and R1–R8 subsequently passed, but the fixes themselves have had no independent
   review. Under `docs/qc-independence.md` this is a structural change class, so G2 should not be
   answered on this file alone.
6. **The duplication-declaration control does not reproduce** at this stream's base — see § 7.
