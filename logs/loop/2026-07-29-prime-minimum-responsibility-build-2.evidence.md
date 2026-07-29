EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-build-2
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: c07c9fa
NEXT: Claude — produce the measured package amendment, then resume S2 and wire the artifact

Status: in-progress

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
