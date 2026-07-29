EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-build-2
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: c07c9fa
NEXT: Prove unit — judge the stream against Shape's falsification criteria (a later unit)

Status: complete

The qualification this unit suspended at route-out for has **returned**. The artifact exists and is
green; **it is not wired** — `prime.md` is untouched by this unit. The unit stays open for the wiring.

---

## Premise verification (brief's four premises, re-derived — not inherited from plan-v4)

**P1a — `docs/backlog-reconciliation.md` carries Step 1a's merged scan verbatim.**
Run: `diff -u` of `prime.md:110-116` against `docs/backlog-reconciliation.md:56-62`, both
indent-normalised via `sed 's/^[[:space:]]*//'`.
Observed: **CONFIRMED substantively, "verbatim" imprecise.** Same loop, same `rev-parse
--show-toplevel` de-dupe, same two skip guards, same `git log --since ... --pretty="%h %s" --all`.
3 of 7 lines differ textually: comment suffix (`already scanned above` vs `already scanned`) and the
date placeholder (`<entry-date>` vs `${ANCHOR}`).

**P1b — `mission.md:47-48` carries Step 1d's enumeration verbatim.**
Run: search of `.claude/commands/mission.md` for `for d in` / `for repo in` /
`rev-parse --show-toplevel` / `logs/missions/*.md` / `WORKSPACE_ROOT`, plus a direct read of `:40-60`.
Observed: **REJECTED.** `mission.md` contains **no shell** implementing this. Line 47 is a single
prose sentence that *cites* `/prime`: "Enumerate the same repo set `/prime` Step 1a uses." The three
fenced `bash` blocks in that file (`:91`, `:102`, `:114`) belong to the `update` verb's frozen-prefix
guard and are unrelated. The dependency runs **the opposite way** from the brief's claim — `mission.md`
depends on `/prime`, not the reverse. This materially changed the verdict; see D3 in the record.

**P2 — `prime-allocator.test.sh` extracts the allocator by awk, hard-exits 2 on anchor drift,
baseline 19/0.**
Run: `bash logs/scripts/prime-allocator.test.sh`; read of `:8-40`.
Observed: **CONFIRMED.** 19 passed / 0 failed, all runs under zsh. Extraction at `:26-33` is anchored
on a ```bash fence, the literal `Allocate N = 1`, and a nine-space dedent; `:35-39` exits 2 on failure
with "do NOT fall back to a copy, which is the defect this replaced". `:8-16` records the defect that
produced it — 2026-07-14, "12 passed, 0 failed" while testing a stale copy holding none of that
session's fix.

**P3 — `logs/scripts/` already holds live `/prime` consumers.**
Run: `ls -la logs/scripts/`; search of `run-manifest.sh` for `/prime`.
Observed: **CONFIRMED, and stronger than stated.** `run-manifest.sh` (32 KB) references `/prime`
behaviour at 11 sites (`:39,153,180,241,246,262,276,288,302,322,327,492`) — it restates Step 8k's
semantics in prose to explain its own failure modes. Marker knowledge is currently in three places:
the prompt, the test's scrape, and this consumer's comments.

**P4 — the three orientation scans are genuinely deterministic.**
Run: direct read of `prime.md:109-125` (1a), `:215-233` (1d), `:366-512` (8k), and
`docs/backlog-reconciliation.md:80-94`.
Observed: **PARTIALLY REJECTED.** 8k and 1d are pure deterministic shell. Step 1a is a deterministic
*scan* wrapped around a *judgement* classification — distinctive-keyword matching, generic-token
dropping, and an explicit "when in doubt, classify still-open" accuracy floor. The judgement half
cannot leave the prompt.

---

## Artifact verification

**`logs/scripts/prime-marker.sh` ≡ the live Step 8k block.**
Run: `bash logs/scripts/prime-marker.test.sh` — a differential suite that awk-extracts the live block
using the *same* anchors the existing tripwire uses, then runs both engines through identical
fixtures and compares stdout **and** the resulting `logs/.session-marker` bytes.
Observed: **20 passed / 0 failed.** Every case executed under **both bash and zsh**. Cases: fresh repo
with/without session id; seeded same-day `S1`; seeded **suffixed** `S7-a4f` (the fail-safe parse whose
inversion is the documented destructive regression); multi-digit `S12`; stale prior-day marker;
malformed marker; punctuated session id; non-git directory (mutex-less degrade path); and a direct
assertion that a seeded `S5` never re-allocates at or below `S5`.

**Block unchanged by this unit.** Run: `bash logs/scripts/prime-allocator.test.sh` after the artifact
was written. Observed: 19 passed / 0 failed.

**Runtime cost** (the brief's falsification condition "owner's runtime cost exceeds the prose").
Run: `wc -c` on `prime.md:366-512` and on the script.
Observed: **falsification NOT triggered — cost moves down.** Prose region 11,130 chars, read at every
`prime.md` read across 29 consumers; replacement call site ~260 chars; net **−10,870 chars per read**.
The script's own 10,143 chars are executed, never model-read.

**Line accounting.** `prime.md` 635 today; Step 8k region 147 lines; script 164 lines (55 executable,
109 comment/blank). Substitution projects `prime.md` to **~493**.

---

## Instrument failure found mid-verification (and it nearly produced a fabricated premise)

`grep` in this environment is a **shell function** from Claude Code's shell snapshot, not `/usr/bin/grep`.
It **expands `$VAR` inside single quotes**, which POSIX quoting guarantees it must not. A search for
`'for d in "$WORKSPACE_ROOT"/projects'` therefore became `'for d in ""/projects'` and returned **empty**
— indistinguishable from "this code does not exist". The loop is plainly at `prime.md:111`.

Caught only by running a positive control on the instrument before trusting its empty result. Without
it, this unit would have reported Step 1a's loop as absent — a fabricated premise inside a
qualification decision, which is the exact failure family the 2026-07-29 usage-log entry scored Major.
Logged to `logs/improvement-log.md`. Escape `$` in single-quoted patterns, or use the `Grep` tool.

---

LIMITATIONS:
- **`prime.md` is untouched.** Nothing is wired. The artifact is proven equivalent to the block, not
  proven in production — no `/prime` has run through the script down any dispatch branch.
- **`/risk-check`, `/qc-pass` and all subagent dispatch were operator-declined for this session and
  were NOT run.** Recorded as **declined**, not passed and not waived. Independent review of this
  artifact is **outstanding**. The route is `challenged`, which normally requires Codex review — that
  obligation is unmet, not satisfied.
- **The 20/0 differential result is only as good as its extractor.** It reads the block with the same
  awk anchors as the tripwire; if those anchors silently stopped matching, both suites would degrade
  together. Both hard-exit 2 rather than pass on extraction failure, which bounds but does not
  eliminate the shared-mode risk.
- **Equivalence is tested on the cases enumerated above, not exhaustively.** The genuine concurrency
  property (two checkouts racing the same `mkdir`) is inherited from the block's own 19/0 suite via
  equivalence rather than re-exercised here.
- **≤300 is not reached** by this substitution (~493 projected) and, per D2, is not renegotiated.
- **The measured package amendment is not yet produced** — its third input (what S4+5 can still
  reach) is unmeasured.
- Two of the brief's four premises did not hold as written (P1b rejected, P4 partially). The verdict
  was re-derived from what was observed rather than from the brief's framing.

---

# Session 2 — 2026-07-29 (S3-060): the package amendment, and Slice 2 landed

Operator directive unchanged and re-recorded: **`/risk-check`, `/qc-pass` and all subagent dispatch
are DECLINED.** They were **not run**. Recorded as **declined** — never as passed, satisfied or
waived. Everything below is direct inspection and deterministic executable tests.

## 1 · The measured package amendment (deliverable 1)

Written to `logs/loop/2026-07-29-prime-minimum-responsibility-shape.plan-v5.md`. Plan-v4 is immutable
and was **not** edited; v5 supersedes its § 4 arithmetic and § 5 option set only.

What the amendment records, and what was run to establish each:

- **Option (ii) is foreclosed.** D3 qualified **only** `prime-marker.sh`; Step 1a's cross-check and
  Step 1d's mission scan were qualified and **declined for v1**, each with a reopening trigger. So
  F10's 66 lines — plan-v4's "single biggest line saving available" — are **uncashable in v1**, not
  merely uncashed. Read from the record's D3 (`prime-runtime-delegation.md:204-232`).
- **Two of plan-v4's own budget cells rested on a rejected premise.** Its Step 1d budget (A=12, B=6)
  was justified by *"`mission.md:47–48` already carries the identical repo enumeration"*. Build-2's
  premise P1b tested that and **rejected** it — `mission.md` carries no such shell; `:47` is one prose
  sentence that *cites* `/prime`, so the dependency runs the opposite way. Corrected to A=16, B=16.
  Budget B's Step 1a cell (16) likewise assumed a relocation plan-v4 § 2 itself disrecommends and D3
  has now declined as a script; corrected to 54.
- **Revised arithmetic.** Orientation floor A 275 → **279**, B 172 → **220**. Final reachable
  **426** (A) / **367** (B). **≤300 remains falsified, and by a wider margin than v4 stated** — B is
  **67** short, not 16. Per D2 and the operator's 2026-07-29 scoping, the frozen ≤300 assertion is
  **not** renegotiated; a shortfall is recorded unmet.

## 2 · Slice 2 landed (deliverable 2)

**`prime.md` Step 8k replaced by a call to the script.**
Run: python splice of `.claude/commands/prime.md`, asserting `lines[365]` starts `8k. **Marker
allocation` and `lines[512]` starts `8h. **Session-entry write` before writing.
Observed: 147 lines (`:366–512`, 11,130 chars) → **15 lines** (`:366–380`, 2,293 chars).
`wc -l` **635 → 503**, measured, not computed. **−132 lines; −8,837 chars per read × 29 consumers.**

**`prime-allocator.test.sh` repointed in the same change.**
Run: three edits — `ALLOC_SRC` from `.claude/commands/prime.md` to `logs/scripts/prime-marker.sh`;
the 8-line awk extractor + dedent replaced by a single `cp`; the FATAL branch reworded from
"extraction failed" to "carries no MARKER= assignment"; temp file renamed `newblock.txt` → `alloc.sh`.
Observed: the suite no longer scrapes markdown. **There is no anchor left to drift** — the fence
position, the `Allocate N = 1` literal and the nine-space dedent are all gone from the test's path.

**All in-file references to 8k survive.** Run: `grep -n "8k"` over the new `prime.md`.
Observed: 5 hits (`:366`, `:377`, `:385`, `:406`, `:419`) — every one names the sub-step's *identity
or contract*, none referenced the inline shell. `8h`'s "Run the **Step 8k marker-allocation
sub-step**" hand-off is unchanged and still resolves.

**A formatting defect was introduced and caught.** The splice consumed the blank line separating 8k
from 8h. Detected by a mechanical check over every `^8[a-z]\. ` sub-step confirming a blank line
precedes each; 8h failed it. Fixed, re-checked — 6 of 6 OK. This is why the final figure is 503/−132
and not the 502/−133 the amendment was first drafted at; **the amendment was corrected before it was
committed**, rather than shipping a number that was wrong by one.

## 3 · Both suites run (deliverable 3)

| Suite | Before the swap | After the swap |
|---|---|---|
| `prime-allocator.test.sh` (tripwire) | 19 passed / 0 failed | **19 passed / 0 failed**, repointed at the script |
| `prime-marker.test.sh` (differential) | **20 passed / 0 failed**, both bash and zsh | **hard-exit 2 — retired by design** |

**The differential suite's exit is the expected terminal state, and its own author anticipated it.**
Its failure text reads: *"Either Slice 2 has landed (block replaced by a call to the script — retire
this suite), or the fence/anchor moved."* Its 20/0 run **before** the swap is the equivalence proof
that licensed the swap; with the block gone it has nothing left to compare. **It is left on disk, not
deleted** — see § 5.

**FALSIFICATION CONTROL — the green run is load-bearing, not vacuous.** A green tripwire proves
nothing unless it can go red; that is precisely the 2026-07-14 defect this whole slice exists to
retire. Run: reverted the script's fail-safe seed from the suffix-tolerant
`tok="${PREV#* }"; n="${tok#S}"; n="${n%%-*}"` to the naive `n="${PREV##*S}"`, re-ran the suite,
restored, confirmed `git diff` empty, re-ran again.
Observed: **18 passed / 1 failed, `*** DO NOT SHIP ***`** — and it failed on exactly the destructive
regression the invariant names: *"FAIL-SAFE reads a SUFFIXED marker: S7-a4f => S8 — got S1, wanted
S8"*, i.e. S1 allocated over an existing S7. After restore, **19/0**. The suite is reading the
shipped script.

**CALL-SITE CONTRACT — proven by execution, closing build-2's largest prior limitation.**
The earlier evidence recorded *"no `/prime` has run through the script down any dispatch branch"*.
Run: the call site copied **verbatim** out of the new `prime.md:371-372` into a throwaway git fixture,
executed under **zsh** (the Bash tool's real shell), six cases.
Observed:
1. `TODAY=[2026-07-29]`, `MARKER=[S1-zzz]` — the `${MARKER_LINE%% *}` / `${MARKER_LINE#* }` split works.
2. Both marker files written: `.session-marker` and `.session-marker-zzz99999-…`, content `2026-07-29 S1-zzz`.
3. Second invocation → `S2-zzz`. Increments.
4. `CLAUDE_CODE_SESSION_ID=""` → `S3`. Legacy bare grammar; degrades safe.
5. **Negative control** — broken script path: `|| exit 1` fired, exit 7 propagated. A missing script
   cannot fail silently.
6. **Negative control** — run from a non-repo-root cwd: refused loudly, exit 1,
   *"no ./logs directory — run from the repository root"*.

## 4 · This session's own /prime is the last inline-block run

`S3-060` was allocated by the **inline block**, at session start, before this slice landed. The next
`/prime` in this checkout will be the first to allocate through the script in production. That is the
one property still unproven by anything other than the fixture above, and it is unprovable from
inside the session that changes it.

---

LIMITATIONS:
- **No production `/prime` has yet run through the call site.** Proven in a fixture under zsh with
  both negative controls, not in a live orientation. First real exercise is the next `/prime`.
- **`/risk-check`, `/qc-pass` and all subagent dispatch: operator-declined, NOT run.** Independent
  review of both the artifact and this integration is **outstanding**, not satisfied. The route is
  `challenged`; its post-implementation Codex review belongs to the **Prove** unit and has not
  happened. Nothing here should be read as having passed a gate.
- **`prime-marker.test.sh` is now permanently non-runnable and is still on disk.** Retiring it is
  prescribed by the record's next-action item 3 but was **not** in this session's instruction, so it
  is recorded as a `deferred` finding rather than deleted as a quiet extra edit. Its FATAL text
  self-documents the state for the next reader.
- **Slice 4's figures remain structural estimates.** Only Slice 2 is measured by execution. Eleven of
  thirteen orientation regions are still un-drafted, carrying plan-v4's ±15-line uncertainty — which
  exceeds Budget A's 4-line margin against the ≤430 waypoint.
- **The −8,837 chars/read figure counts characters, not tokens.** Direction certain; magnitude in
  tokens unmeasured.
- **The 29-consumer count is a point-in-time `find`.** Three sibling worktrees hold their own copies
  of `prime.md` on other branches (`ai-resources-2` at 830 lines, `-work-loop` and `-leverage-idea` at
  635); they receive this change only on merge, and until then those checkouts still run the inline
  block. That is normal branch behaviour, not a defect, but it means "29 consumers updated" is true
  of `main` only.
- **The governance gap is unresolved and now applies twice.** `docs/work-loop.md` still defines no
  path for amending a G1-approved package mid-Build. plan-v5 is the second amendment written under
  v4 § 6a's chosen-not-prescribed shape.
