UNIT: 2026-07-29-prime-lean-down-frame
STREAM: 2026-07-29-prime-lean-down
PHASE: frame
REPO: ai-resources
BASE: 816003b6cdf8243de59e690fd5a105cfaea0db60
NEXT: Claude (Shape unit, a later invocation)

EVIDENCE

## Route

`challenged`. Criterion: the stream restructures shared-state operations — the allocator
writes `logs/.session-marker`, the per-id marker `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`,
and the cross-checkout claim directory under the git common dir. `docs/audit-discipline.md:65`
names this in-class explicitly: "INCLUDES reordering or restructuring of existing shared-state
ops (e.g., changing when an archive step runs relative to a log append), not only new automation."

The `reviewed` trigger also fires (a shared `ai-resources` resource symlinked into 27 consumers).
Ambiguity resolves upward, so the route is challenged. `/risk-check` still fires at its own two
gates on its own schedule; this route does not absorb or reschedule it.

## Premise verification

All six premises confirmed. None rejected.

### P1 — prime.md is 830 lines; Steps 7–8 occupy 348–830

Run: `wc -l -c .claude/commands/prime.md` → `830   97915`.
Run: `grep -nE '^[0-9]+[a-z]*\. \*\*' .claude/commands/prime.md` → step 7 begins at line 348;
`8m` at 357, `8k` at 366, `8a` at 513, `8b` at 563, `8c` at 595, file ends at 830.

Confirmed exactly: 830 lines, 97,915 bytes, Steps 7–8 = lines 348–830 = **483 lines, 58% of the file**.

Note recorded for Shape, not a rejection: the file carries only one markdown heading
(`## Prime — {date}` at line 312, part of an output template). Steps are prose-numbered at
column 0. Any future edit that keys on `^## Step` finds nothing.

### P2 — 8k embeds the allocator; docs/session-marker.md owns its contract

Read: `.claude/commands/prime.md:366-509`. Sub-step 8k embeds one fenced `bash` block at
lines 370–509.

Measured composition of the block (lines 371–508, dedented):
- total: 138 lines
- comment-only (`^#`): **88 lines (64%)**
- blank: 1
- executable: **49 lines**

Read: `docs/session-marker.md:65-137` (§ Marker allocation — the WRITE path). The doc states
the same rule the block implements — "`N` = 1 + the MAX of four sources — then CLAIM `N`
atomically" — as a four-row table naming sources (a) `logs/.session-marker`, (b) session-notes
working tree, (c) session-notes all refs, (d) the shared claim dir — plus § Why (c) exists,
§ Why (d) exists, and § Known gap. The doc is 375 lines.

Confirmed: the contract has a documented owner, and the 88 comment lines in prime.md restate
its rationale (the four sources, the 2026-07-13 S6 and S11 incidents, the fail-safe invariant,
the zsh NOMATCH lesson, the known gap) a second time inside the command.

### P3 — the test exercises the embedded behavior; no standalone helper exists

Read: `logs/scripts/prime-allocator.test.sh:17-40`. The suite resolves
`ALLOC_SRC=.../.claude/commands/prime.md` and awk-extracts the first fenced ```bash block whose
body matches the literal `Allocate N = 1`, dedents it with `sed -e 's/^         //'`, and writes
it to a temp file that every test then runs under zsh.

Its header states the reason (lines 8–16): the suite previously read a copy from a dead
session's scratchpad and "reported '12 passed, 0 failed' while testing an allocator that
contained the OLD broken seed". It now extracts from prime.md "so the thing under test is the
thing that runs. Do not reintroduce a copy."

Run: `grep -rn 'axcion-session-markers' --include='*.sh' --include='*.md' .` → the only
executable carrying the allocator fingerprint is `.claude/commands/prime.md:450`. The other hits
are the test harness (fixture setup), `docs/session-marker.md:76`, and 4 audit/log records.
Run: `find . -name '*.sh' -not -path './.git/*'` → 30 shell scripts; none is an allocator.

**Positive control.** The negative ("no standalone helper") rests on a search that demonstrably
fires: the same grep returned prime.md:450, the test, and the doc. An empty result from a silent
pattern was not accepted as evidence.

Confirmed: allocation has no executable owner. The single copy that runs is embedded in a
markdown command file, and the only regression suite reaches it by scraping that file.

### P4 — auto mode duplicates session-start context discovery, scope checks, run-manifest writes

Run: `grep -nE '^#+ *Step' .claude/commands/session-start.md` → `### Step 2.4 — Context
discovery (engine pre-step)` at L207, `### Step 2.5 — Self-check before writing` at L266,
`### Step 3.5 — Write the run-manifest start-stub (W3.2 R3)` at L348. (First grep shape returned
nothing because the headers are `### Step 2.4 —`, not `2.4.`; corrected pattern fires and is
what is cited here.)

Read: `.claude/commands/prime.md:648-803`. The duplication is declared by the file itself:
- 8c.4 — "Derive mandate fields inline (matches `/session-start` Step 2 logic without the confirmation prompt)"
- 8c.4.5 — "Mirrors `/session-start` Step 2.4 but runs inline without re-emit"
- 8c.5 — "Derive plan fields inline (matches `/session-plan` Step 2 + 5–7 logic without the per-stage prompts)"
- 8c.6.5 — "Apply `/session-start` Step 2.5 check 3 verbatim before the write"
- 8c.7 — "Format identical to `/session-start` Step 3 exact bullet structure"
- 8c.7.5 — "Mirrors `/session-start` Step 3.5; keep the two in sync"

Confirmed. "Keep the two in sync" is a maintenance obligation stated in the file, which is the
duplication in its own words.

### P5 — auto mode has real recorded use; the single approval gate must remain available

Run: `grep -rniE 'auto[- ]mode|auto multi-item|typed .auto.|/prime auto' logs/` (filtered to
exclude `auto-sync`, `auto-commit`, `auto-detect`, `auto-bind`, `automation`, etc.).

Dated uses:
- `logs/decisions.md` under `## 2026-07-19 (S5-dd5)` — "Decided by: Claude under the operator's
  `1,3,4 auto` authorization and `go` at the single auto-mode approval gate"
- `logs/decisions-archive-2026-07.md:871` — "Decided by: Claude (S2-21e), under operator-approved
  auto mode (`go`)"; :837 and :863 record two further auto-mode sessions
- `logs/coaching-data.md:238` — "single /prime auto-mode gate covered 4 items"; :266, :270, :294
  record three more
- `logs/decisions-archive-2026-06.md:178,194,208,424,436` — five more, June 2026

Read: `prime.md:696` — 8c.6 is "the only operator-facing pause in auto mode, regardless of how
many items were picked." One deliberate exception exists at 8c.2.5 (cross-repo mission guard),
flagged in the file as load-bearing because the 8c.3 header write precedes the gate.

Confirmed as to use. The clause "must remain available" is a **constraint the brief imposes**,
not a factual claim — recorded as a Shape constraint, not verified as a fact.

### P6 — project copies predominantly consume the canonical file through symlinks

Run: per-path `test -L` / `readlink` over every `prime.md` in the workspace
(`find . -name 'prime.md' -not -path '*/.git/*'`), then `diff -q` on each real file.

30 instances total: **27 symlinks, 3 real files.**
- Symlinks resolve to `ai-resources/.claude/commands/prime.md` (24 under `projects/`, plus
  workspace root, `harness/`, `knowledge-bases/pe-kb-vault/`, `archive/nordic-pe-macro-landscape-H1-2026/`).
- `projects/axcion-design-studio/.claude/commands/prime.md` — 830 lines, `diff -q` reports
  **no differences**: a full byte-copy fork of the canonical file.
- `projects/axcion-sector-intelligence/.claude/commands/prime.md` — 33 lines, a minimal variant
  with no allocator.
- `ai-resources/workflows/research-workflow/.claude/commands/prime.md` — 33 lines, same variant.

Confirmed as stated. The qualification that matters for Shape is in § Findings below.

## Frame's question — closed

**What is the need?** Real, and confirmed by measurement — but narrower in unit 1 than the
brief's headline figure implies. 97,915 bytes is the whole file. The allocator block this unit
targets is 138 of 830 lines (17%). The bulk of the file is Steps 7–8 at 483 lines (58%), of
which auto mode alone is 236 lines (8c, lines 595–830) — and the brief's own scope line forbids
changing auto semantics. So the honest statement of unit 1's reach is: it removes one embedded
implementation and ~88 lines of restated rationale, not a lean-down of the 97kB.

The duplication premise for auto mode (P4) is confirmed but **deliberately out of scope for this
unit** by the brief's own scope line. It is a real finding with a real owner and should be
carried, not silently dropped.

**Who owns it?** `/work-loop` — this stays inside the execution boundary.

Not `/develop-ai-resource`: the boundary routes out when "a **new** durable AI artifact must be
authored, or an existing one materially expanded" (`develop-ai-resource.md:13-17`, read — the
authority text covers new durable resources and skill-class improvement). Giving the allocator an
executable owner authors no new skill, command or agent. It applies a pattern this repo already
runs: `logs/scripts/run-manifest.sh` is a shared helper called by `/prime`, `/session-start` and
`/wrap-session` (verified: `grep -rln 'run-manifest.sh' .claude/commands/*.md` returns exactly
those three), whose own header reads "Schema authority: `ai-resources/docs/spine-schemas.md` § 1.
Do NOT fork or restate the schema here — this script implements it, it does not define it."
That is precisely the shape the brief asks for — one executable owner, contract owned by a doc —
already established and in service.

Not `/scope-project`: a legitimate owner exists. `ai-resources` owns `prime.md` and every
consumer resolves to it.

**Is it in scope at all?** Yes, with three constraints Shape must plan around. One is
load-bearing.

## Findings

**F1 — LOAD-BEARING. The regression suite is coupled to the embedded block's file position and
literal text.** `prime-allocator.test.sh` scrapes the allocator out of prime.md by matching a
fenced ```bash block containing `Allocate N = 1`, then dedents by exactly nine spaces
(`sed -e 's/^         //'`). If Build moves the allocator to a script without repointing the
suite in the same commit, the extractor hits its own FATAL path (lines 35–40, `exit 2`) and the
brief's first falsification criterion — "any allocator test regresses" — trips by construction,
telling us nothing about the allocator. Repointing `ALLOC_SRC` at the new script is *consistent*
with the suite's stated intent ("the thing under test is the thing that runs"), not a violation
of it — but it must be planned, not discovered. Baseline before any change, run this unit:
`bash logs/scripts/prime-allocator.test.sh` → **19 passed, 0 failed, ALL PASS.**

**F2 — one consumer will not track the change, and it is the full fork.**
`projects/axcion-design-studio/.claude/commands/prime.md` is byte-identical to canonical but is a
real file, not a symlink. After a canonical lean-down it keeps running the embedded allocator.
This is not hypothetical: prime.md:398-403 documents it as "⚠ KNOWN GAP, ACCEPTED (operator call,
2026-07-13 S13) — a checkout running an OLD copy of this block neither writes claims nor reads
them", and records that the gap produced four real collisions in two days. A shared script
resolved by walk-up (the pattern `run-manifest.sh` already uses at prime.md:787-793) would let
that fork execute current allocation logic instead of frozen logic, which **narrows** the known
gap. That is an argument for the change — but it is a lifecycle decision for G3, and it must be
stated, not arrive as a side effect. The two 33-line variants carry no allocator and are
unaffected.

**F3 — the second scope clause is confirmed and quantified.** "Remove duplicate runtime
explanation already owned by docs/tests" targets a measured 88 comment lines (64% of the block)
whose content is independently owned by `docs/session-marker.md` § Marker allocation / § Known
gap and executably owned by the 19-assertion test suite. Removal is defensible. The risk to
name at G1 is that several of those comments are **anti-regression warnings addressed to a future
editor** ("Do NOT 'simplify' this back to a glob"; "Any future edit that scans first and consults
the marker file second reintroduces exactly that destructive regression"). Those must land in the
script that holds the code, not be deleted on the grounds that a doc mentions them — a warning
separated from the line it guards has already failed.

**F4 — carried, not actioned.** The auto-mode duplication (P4) is confirmed and out of this
unit's scope by the brief. Disposition `deferred`; reopening trigger: a subsequent unit of this
stream that is explicitly briefed for auto mode, or a defect caused by 8c.7.5 and
`/session-start` Step 3.5 falling out of sync.

## Adjudication

None. The Frame unit on the challenged route carries no review (`docs/work-loop.md` § The
challenged route — Frame, Build and Land carry none). No findings from an external reviewer to
adjudicate.

LIMITATIONS:
- Only the marker **write** path was surveyed. `docs/session-marker.md` § Marker resolution owns
  a separate read path with its own consumers; this unit did not enumerate them, because the
  brief scopes allocation. If Shape changes marker *format* rather than only its implementation
  owner, that survey becomes required and has not been done.
- The P3 sweep keyed on the `axcion-session-markers` fingerprint. A hypothetical consumer that
  allocates without touching the claim dir would not appear. Judged low risk — the claim dir is
  load-bearing to the current algorithm — but not disproved.
- P4 was confirmed from the file's own self-declaration plus verifying the three cited
  `/session-start` steps exist. The two implementations were **not** diffed, so how much is
  genuinely identical versus already drifted is unmeasured. That measurement belongs to whichever
  unit is briefed for auto mode, not this one.
- The 19/0 baseline was run once, on this machine, in this checkout, `bash` invoking `zsh`
  subshells per the suite's design. Not run from a worktree, and not run against a checkout on a
  branch predating the current allocator — the scenario prime.md:398-403 names as the known gap.
- "Auto mode's single approval gate must remain available" is a constraint, not a verifiable
  claim. Recorded as a Shape constraint; nothing was proved about it.
- No edit was made to any object under work. This unit wrote only its own `logs/loop/` artifacts.

Status: complete
