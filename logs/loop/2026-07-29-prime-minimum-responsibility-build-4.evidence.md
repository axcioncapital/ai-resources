EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-build-4
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: 6a81121
NEXT: Codex — G2 review at the Prove unit (not this one)

Status: complete

---

## 0 · Live smoke test of the Slice 2 allocator (operator directive 7)

**This is the first production allocation through `logs/scripts/prime-marker.sh`.** S3-060 was allocated
by the old inline Step 8k block, before the swap; this session's own `/prime` is the first run of the
extracted script in real use.

**Expectation was registered BEFORE the run, and it was falsifiable.** Pre-state was captured first:
marker file `2026-07-29 S3-060`, zero per-id markers on disk, claim dir holding `2026-07-29-S{1,2,3}`,
`session-notes.md` headers up to S3. All four HIGH sources therefore agreed at 3, predicting
`N = 4`; `CLAUDE_CODE_SESSION_ID` = `efd076a3-…` predicted the suffix `efd`. **Predicted marker:
`S4-efd`.** A different N, a missing per-id file, or an unclaimed dir would each have falsified it.

| Check | Predicted | Observed | |
|---|---|---|---|
| stdout (one line, `${TODAY} ${MARKER}`) | `2026-07-29 S4-efd` | `2026-07-29 S4-efd` | PASS |
| `logs/.session-marker` rewritten | `2026-07-29 S4-efd` | `2026-07-29 S4-efd` | PASS |
| per-id oracle written | `.session-marker-efd076a3-…` created | created, same content | PASS |
| atomic `mkdir` claim | `2026-07-29-S4` created | created | PASS |
| exit status | 0 | 0 | PASS |

**Caller contract (the half the script deliberately does not own) also held.** After the script
returned, the sequence ran marker → header → mtime in that order: `grep -Fxq` reported the header
absent (exit 1, the common case), `## 2026-07-29 — Session S4-efd` was appended with its work
description, and `logs/.prime-mtime` was then stamped. Verified: header present by literal whole-line
grep; `.prime-mtime` = `1785350425` = `session-notes.md` mtime exactly, which is only true if the stamp
followed the append.

**Recorded limitation:** the smoke test exercised Step 8k as it stood *after Slice 2* — i.e. the
allocator call site. It ran against the **pre-Slice-4** orientation text (503 lines), because `/prime`
executed before this unit's edits. Slice 4's own orientation changes have **not** been exercised by a
live run. See § 4.

---

## 1 · Premise verification (work-loop step 4)

| # | Premise | Instrument | Verdict |
|---|---|---|---|
| P1 | Orientation still 356 lines; region boundaries match plan-v4 § 1 | `wc -l` = 503; `grep -nE "^[0-9]+[a-z]?\. "` → Step 7 at `:348`, `8m` at `:357` ⇒ orientation = 1–356 | **CONFIRMED** |
| P2 | All six Budget A rationale destinations exist | `test -f` on each: `commit-discipline.md` (141 L), `heavy-read-discipline.md` (108), `backlog-reconciliation.md` (111), `session-marker.md` (385), `qc-independence.md` (34), `project-next-steps.md` (130) | **CONFIRMED** |
| P3 | `:281` cites deleted step 11a and calls the wrong branch "normal" | Direct read of `:277–288`. `:281` read *"as `/new-project` step 11a **now writes it**"* — present tense — while `:283` already stated nothing writes it since 2026-07-27 | **CONFIRMED** |
| P4 | Step 1d has no citation destination | **Not re-derived.** Settled by build-2 P1b (REJECTED); brief forbids reopening | carried |

**P1 carries a consequence worth stating:** Slice 2 touched only `:366+`, so the entire orientation
region was byte-identical to plan-v4's baseline. Budget A's per-cell table applied unchanged, with no
re-apportionment needed.

**P2 refinement found during execution.** `backlog-reconciliation.md` already carried Step 1a's merged
scan *verbatim*, plus the cost note, the tolerance posture and the fall-through rule, and already named
`/prime` Step 1a its reference implementation. So Step 1a's relocation required **no new prose in the
destination** — only a citation from the command. That is why 1a beat its cell without losing a rule.

---

## 2 · What was executed

**Rationale destinations written (5 files).** Every one is an existing document; no new file was created.

| Destination | Received | New section? |
|---|---|---|
| `docs/commit-discipline.md` | Step 0's four rationales: behind-check incident (2026-07-14 S5→S8), why `--rebase --autostash` is explicit, why a half-rebased repo is an incident, why autostash-pop needs its own detection | **new § Orientation pull** (the only new section, as plan-v4 § 3 anticipated) |
| `docs/heavy-read-discipline.md` | Steps 1, 1c and 3: the grep-not-window reasoning, the token-audit R4 provenance, the position-before-spine inversion, the 900-line 2026-07-19 verification, the ~50–60k cost history, `-B6` sizing, both anchor widenings + the backtick exclusion, the count-not-content essay, the 2026-07-24 `medium-high` near-miss | new § Bounded-read recipes |
| `docs/session-marker.md` | Step 1a's concurrent-session rationales: same-day-headers-are-normal, why the advisory watches those files, why the nudge uses per-id markers not `SIBLING_COUNT` | new subsection under § Concurrent-session detection |
| `docs/qc-independence.md` | Step 1b's QC-PENDING precedence rationale (why mtime-override and date-exemption are both load-bearing) | inline, § Subagent-unavailable fallback |
| `.claude/commands/project-next-steps.md` | A pointer noting `/prime` Step 1c's deliberate cascade inversion, so the divergence is discoverable from the cascade source | inline, Step 2 |

**Slice 5 landed inside Step 4.** The stale `:281` prose was removed and the four-case model ladder
collapsed to two. "Normal" now labels the **absent-section** branch, which is the branch that is
actually normal; the deleted step 11a is referenced only in the past tense, as the reason nothing
writes the section any more.

---

## 3 · Measured result

| | Before | After | Δ |
|---|---:|---:|---:|
| `prime.md` total | 503 | **413** | **−90** |
| Orientation (1 → `8m`−1) | 356 | **266** | **−90** |
| Dispatch (`8m` → EOF) | 147 | **147** | **0** |
| Characters | 72,079 | **58,138** | **−13,941 per read** |

**≤430 waypoint: MET, by 17 lines.** Budget A projected 426; the measured result is 413.
**≤300 mission target: MISSED by 113. Recorded unmet, not renegotiated** (D2 — the assertion stays
frozen). This is consistent with plan-v5 § 4, which already recorded ≤300 as falsified for the
relocation-only package.

**Orientation beat its own Budget A target of 279 by 13 lines**, driven by two regions:

| Region | Live | Budget A | Measured | |
|---|---:|---:|---:|---|
| Preamble | 12 | 10 | 10 | on cell |
| 0 Pull | 58 | 42 | 44 | **+2 over** |
| 1 session-notes | 24 | 16 | 14 | −2 |
| 1a Cross-check | 69 | 54 | 55 | +1 over |
| 1b Scratchpad | 12 | 9 | 10 | **+1 over** |
| 1c Plan position | 39 | 29 | 22 | **−7** |
| 1d Missions | 19 | 16 | 15 | −1 |
| 2 next-up | 4 | 3 | 2 | −1 |
| 3 Urgent scan | 39 | 30 | 26 | **−4** |
| 4 Exceptions | 12 | 9 | 8 | −1 |
| 5 Menu | 20 | 16 | 16 | on cell |
| 6 Brief | 39 | 36 | 35 | −1 |
| 7 Classifier | 9 | 9 | 9 | preserved entire |
| **Total** | **356** | **279** | **266** | **−13** |

**Three cells were missed on the high side and are reported rather than forced.** Steps 0, 1a and 1b
each came in 1–2 lines above their cell because the residue was rule, not rationale. Per the brief's
falsification clause the real figure is reported; the aggregate absorbed it.

---

## 4 · Verification — what was run, what was observed

**A. Rule-preservation diff, with a falsification control.** Extracted every tool invocation, git
command, grep flag and shell variable assignment from the before and after files and diffed the sets.

- Run: `grep -oE '(Bash|Read|Grep|Glob)\(…\)|git …|grep -[a-zA-Z]+|python3 -c|stat …|[A-Z_]{3,}='`,
  sorted unique, `comm -23 before after`.
- Observed: 50 → 44 entries. **All 6 differences are prose fragments the greedy regex caught
  mid-sentence** (e.g. `git cross-check below is the`, `git call at all.**`), not invocations. Zero
  executable rules dropped.
- **Control (this is what makes the empty result mean something).** The same check was run against a
  deliberately mutated copy with the `FOREIGN_SHARED=$(git status --short …)` line deleted. It
  **reported the deletion**, surfacing both `FOREIGN_SHARED=` and the full `git status --short --`
  pathspec. The check can fail, so its passing on the real file is evidence.

**B. One compression was caught by this check and reverted.** The first draft replaced the literal
`git -C "$AI_RESOURCES" log --since=…` with the phrase *"ALSO run that same command against
`$AI_RESOURCES`"*. The invocation count fell 4 → 3. That is compressing a **rule** into an anaphoric
reference, which the brief forbids, so the literal was restored (+2 lines) and the count returned to 4.
**This is the one place Slice 4 crossed the rule/rationale line, and it was caught by instrument rather
than by reading.**

**C. Step 7 byte-identity.** `diff` of the region between `^7\.` and `^8m\.`, before vs after:
**IDENTICAL, 9 lines.** The reply classifier is preserved entire, as directive 4 requires.

**D. The other three protected items.** Step 1a's merged scan: `rev-parse --show-toplevel` 2→2,
`log --since=` 4→4. Step 1d's mission scan: `logs/missions/*.md` 2→2, `status: active` 1→1. Step 3's
severity anchor: 1→1 occurrence, byte-identical, `medium-high` still in both the anchor and the include
clause. `LIVE_FOREIGN_HERE` 5→5, `FOREIGN_SHARED` 2→2. (`SIBLING_COUNT` 8→5 — the three lost are prose
repetitions, including one paragraph that restated the preceding sentence; the assignment survives.)

**E. Structural integrity.** Code-fence markers: 22, balanced. Step sequence intact and in order:
`0 1 1a 1b 1c 1d 2 3 4 5 6 7 8m 8k 8h 8a 8b 8c`.

**F. Consumer surface.** 37 `prime.md` paths under `*/commands/*`: **28 symlinks, all resolving to the
edited canonical, 0 broken, 0 pointing elsewhere**; 9 real files (sibling worktrees and archived
projects, which receive this on merge — "29 consumers updated" is true of `main` only).

**G. Deterministic suite.** `bash logs/scripts/prime-allocator.test.sh` → **19 passed, 0 failed**, all
runs under zsh. **Stated precisely: this suite exercises `prime-marker.sh`, which Slice 4 did not
touch.** It is evidence of *no collateral damage*, not evidence that Slice 4 is correct. Do not read it
as validating this unit.

**H. Directive 6 — the retired differential suite is resolved.** `bash logs/scripts/prime-marker.test.sh`
was run first to record its state: it hard-exits with *"FATAL: allocator extraction from prime.md failed
… Either Slice 2 has landed (block replaced by a call to the script — retire this suite), or the
fence/anchor moved."* Slice 2 has landed, so the file's own header prescribes retirement. Referent
search found **no live consumer** — only log records (`friction-log`, `session-notes`, a run manifest,
build-2's evidence). Removed with `git rm`; recoverable from `28f046c` and earlier.

---

## LIMITATIONS

- **No live `/prime` run has exercised the new orientation text.** This session's `/prime` executed the
  pre-Slice-4 file. Every claim in § 3 is a measurement of the artifact at rest, and every claim in § 4
  is a static check. **The next fresh `/prime` in this checkout is the first real behavioural test of
  Slice 4** and its evidence belongs to the Prove unit.
- **The rule-preservation diff proves no *invocation* was dropped. It cannot prove the surrounding prose
  still directs correctly.** Compressed instructions are judgement-bearing text; a regex cannot tell
  whether a shortened sentence still means what it meant. Eleven of the thirteen regions were drafted
  fresh in this unit and have been read once, by their author.
- **`/risk-check`, `/qc-pass` and all subagent dispatch are operator-DECLINED for this unit** — recorded
  as declined, never as passed, satisfied or waived, and deliberately **not** encoded as a QC-PENDING
  commit-block. There is therefore **no independent review of this unit's output**, and the unreviewed
  surface carried since plan-v4 is now wider, not narrower.
- **Three Budget A cells were missed on the high side** (Steps 0, 1a, 1b, by 1–2 lines each). The
  aggregate is 13 under target, so nothing was forced, but the per-cell apportionment was not achieved
  as written.
- **The −13,941 char/read figure counts characters, not tokens.** The direction is not in doubt; the
  magnitude in tokens was not measured. Same limitation plan-v5 recorded.
- **Rationale is now split across five documents.** A reader of `prime.md` alone no longer sees why a
  rule is shaped as it is. Each relocation carries a named § pointer, but the failure mode this creates
  — a future editor changing a rule without reading its rationale — is real and not mitigated by
  anything mechanical.
- **The ≤300 mission target is missed by 113 and recorded unmet.** The mission's acceptance assertion
  was not renegotiated to fit this result.
