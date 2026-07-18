# Risk Check — 2026-07-18

## Change

Fix the cross-midnight failure in `ai-resources/logs/scripts/run-manifest.sh` (mission `repo-health-backlog-2026-07`, thread 8), plus midnight cases in `logs/scripts/run-manifest.test.sh`.

--- GIVEN STATE: already derived and VERIFIED BY EXECUTION by the caller this session. Spot-check and EXTEND; do not rebuild from scratch. (Caller telemetry 2026-07-18 S7-bb5 recorded a prior reviewer burning ~40-60k re-deriving an inventory the caller already held — do not repeat that.) ---

DEFECT, REPRODUCED IN A SANDBOX (not read off the file). Start-stub pinned to 2026-07-17, then `close` run on 2026-07-18:
  (a) `close --outcome X` with no flags -> EXIT=2, "could not resolve the session marker". The stub `2026-07-17-S9-abc.json` remains on disk with `outcome=None` permanently.
  (b) `close --marker "S9-abc"` without `--date` -> writes a SECOND manifest `2026-07-18-S9-abc.json` while the real one stays null-outcome. One session, two records, neither correct.
  (c) The (b) path prints "no start-stub existed (session skipped mandate confirmation)" — but a stub DID exist, under yesterday's date. The error names the wrong cause.

ROOT CAUSE, three lines: `:156` re-derives DATE from `date` per invocation; `:166-168` accept a marker line only if prefixed with that freshly-derived date; `:172` dies otherwise. Nothing carries the session's own start date forward.

FOURTH FINDING (caller-verified this session, NOT in the mission thread — please assess whether it changes severity): there are TWO distinct failure paths and only one is documented.
  - `run-manifest.sh:249` — prints NOTICE, writes nothing, exits 0. This is the session-identity guard path, and `wrap-session.md` (~:245) documents exactly this as a routine, supported state.
  - `run-manifest.sh:172` — `die()`, EXIT 2. This is the midnight path. `wrap-session.md` does NOT describe it.
  Consequence: the midnight case produces a hard exit-2 mid-wrap that the wrap instructions do not cover, and the documented remedy ("run /prime at session start so a per-id marker exists") is INEFFECTIVE here — in the midnight case a per-id marker DOES exist, it is merely dated yesterday.

TEST GAP: `grep -niE "midnight|cross-day|yesterday|date.*roll"` over `run-manifest.test.sh` returns nothing. Harness is 291 lines, `ck()`/`ckv()` idiom, PASS/FAIL counters, exits non-zero on any FAIL.

PROPOSED FIX:
  1. Carry the session's start date forward: resolve DATE from the per-session-id marker's own date when that marker identifies this session, so `close` targets the stub that `start` actually wrote.
  2. Correct the misleading message in (c) — when a stub exists under a different date, say so.
  3. Add midnight cases to the test harness, written to FAIL against the current script first.

===== THE HAZARD I MOST WANT YOU TO ATTACK =====

`run-manifest.sh:175-194` carries a session-identity cross-check added 2026-07-18 — EARLIER THE SAME DAY — in response to a live incident (session S4-8c3, recorded in `logs/improvement-log.md`): the shared `logs/.session-marker` can hold ANOTHER session's marker at the same date, so `close` would silently overwrite that session's record. The guard's stated test is "presence of THIS session's own per-id marker", not name resemblance.

The naive version of my fix — simply dropping the today-only requirement — re-opens exactly that hole.

My stated design constraint: relax the date match ONLY via the per-session-id marker `logs/.session-marker-$CLAUDE_CODE_SESSION_ID`, which by construction belongs to this session. The shared-file path keeps its today-only rule unchanged.

Attack this specifically. Is that constraint sufficient, or does it still leave an attributable-overwrite path? Consider at minimum:
  - a stale/orphaned per-id marker left by a crashed session;
  - a per-id marker surviving across MULTIPLE days (not just one midnight), e.g. a session idle for three days — should the relaxation be unbounded, or bounded to N days, and what breaks at the boundary?
  - whether `CLAUDE_CODE_SESSION_ID` being unset (older CLI) degrades safely under the new logic;
  - interaction with `detect-concurrent-session.sh`, which as of 2026-07-18 prunes per-id markers on process liveness — can it delete a marker that `close` still needs, and what happens then?

If the constraint is insufficient, say so plainly and give the redesign. I would rather get RECONSIDER now than ship a regression into a guard whose ink is one day dry.

===== CONSUMERS: caller's list — VERIFY AND EXTEND =====
  - `/session-start` Step 3.5 invokes `run-manifest.sh start`.
  - `/prime` Step 8c.7.5 (auto mode) invokes `run-manifest.sh start`.
  - `/wrap-session` invokes `run-manifest.sh close`.
  - `run-manifest.sh` is a SINGLE REAL FILE at `ai-resources/logs/scripts/run-manifest.sh` — caller ran a `find` across the workspace and confirmed ZERO symlinks to it; other checkouts reach it by ancestor walk-up, not by symlink. (Caller used `[ -L ]` per-path, not `[ -f ]`, because `-f` follows symlinks and cannot see the distinction.)
  - Per `principles.md § OP-5`, NOTHING READS the manifests yet, so a regression degrades telemetry rather than blocking work. Weigh this in Blast Radius and Reversibility — but note the counter-consideration that an exit-2 mid-wrap DOES interrupt the operator even though nothing reads the output.
  - `logs/scripts/run-manifest.test.sh` is the existing test harness.

===== OUT OF SCOPE (mandate-bound — flag if the fix cannot respect this) =====
  - The session-marker FILE GRAMMAR and `docs/session-marker.md`'s contract.
  - `/wrap-session` step ordering.
  If your recommended design requires touching either, say so explicitly — that is a stop condition for this session and routes to a different mission thread with its own gate.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.test.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The defect is real and fully reproduced by independent execution (not just re-read), the proposed design constraint (relax date-trust only through the per-id marker) is structurally sufficient against the S4-8c3 overwrite class, but the fix as scoped leaves an unrecorded divergence from `docs/session-marker.md`'s documented canonical resolution pattern, an unbounded trust window the sibling defect's own original proposal explicitly recommended bounding, a stale self-referential code comment, and a real consumer (the workspace-root paired `wrap-session.md`) the caller's own list omitted — all fixable with small, named, in-scope additions rather than a redesign.

## Consumer Inventory

Search terms used: `run-manifest.sh` / `run-manifest` (script + component basename), `.session-marker` / `.session-marker-*` (marker filename convention), `CLAUDE_CODE_SESSION_ID` (env-var contract), `{date}-{marker}.json` (manifest filename convention), `close`/`start` subcommand tokens. Searched `ai-resources/` and the workspace root (one level up), per Step 1.5.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/session-start.md` (Step 3.5) | invokes (`run-manifest.sh start`) | no |
| `ai-resources/.claude/commands/prime.md` (Step 8c.7.5, auto mode) | invokes (`run-manifest.sh start`) | no |
| `ai-resources/.claude/commands/wrap-session.md` (canonical, Step 12d) | invokes (`run-manifest.sh close`) | no |
| `/.claude/commands/wrap-session.md` (workspace-root paired copy, Step 4.7) | invokes (`run-manifest.sh close`) — **PAIRED CONTRACT, omitted from the caller's own CONSUMERS list** | no |
| `ai-resources/logs/scripts/run-manifest.test.sh` | parses/tests the script's behavioral contract | **yes** |
| `ai-resources/docs/spine-schemas.md` § 1 | documents the run-manifest JSON schema (field names unaffected by this fix) | no |
| `ai-resources/docs/session-marker.md` | documents the canonical marker-resolution pattern for ALL consumers; does **not** currently list `run-manifest.sh` in its "Two-end contract registry"; the fix's per-id date relaxation diverges from this doc's stated "canonical pattern every consumer uses" | no (mechanically) — flagged, see Dimensions 5/6; caller declared this file's contract OUT OF SCOPE |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | shares the same per-id-marker files (liveness-grounded pruning); no code dependency, but the HAZARD explicitly asks about this interaction | no |
| `ai-resources/.claude/hooks/check-foreign-staging.sh` (:492) | parses the manifest **filename** convention (`{date}-{marker}.json`) written by `run-manifest.sh`; unaffected because the fix changes the DATE *value*, not the filename *shape* | no |
| `ai-resources/logs/scripts/check-decision-refs.sh` (:83-101) | precedent — already reads date+marker unconditionally from the per-id/shared marker file for its own **read-only, advisory, never-writes** use case; the original improvement-log entry names this script as "the pattern to mirror" | no |
| `ai-resources/logs/missions/repo-health-backlog-2026-07.md` (thread 8) | documents the open thread; this session's own mandate (`logs/session-notes.md:335`) requires ticking it via `/mission update` | **yes** |
| `ai-resources/logs/improvement-log.md` (2026-07-13 entry, "run-manifest.sh marker oracle breaks across midnight") | documents the logged defect (`Status: logged (pending)`); must be flipped/closed citing what shipped, per CLAUDE.md's "close the log entry when the fix lands" rule | **yes** |

Total: 12 consumers, 3 must-change (test harness + 2 bookkeeping records). Zero runtime callers require a code edit of their own — confirmed by direct execution: `find` across the whole workspace (`ai-resources` + all `projects/`) for `run-manifest.sh` / `run-manifest.test.sh`, checked with `[ -L ]` per path, returns exactly two real files and zero symlinks, matching the caller's claim. This is why editing the single script transparently fixes all four ancestor-walk-up call sites (session-start, prime, both wrap-session copies) without touching any of them.

**Gap found in the caller's own inventory:** the workspace-root paired copy of `wrap-session.md` (Step 4.7) also calls `run-manifest.sh close` and is explicitly a "PAIRED CONTRACT" with the canonical copy (per `docs/session-marker.md` § Two-end contract registry and the file's own header). The caller's CONSUMERS section named only "`/wrap-session` invokes `close`" (singular), not both copies. No edit is required there (the script absorbs the fix), but the omission itself is evidence that a consumer sweep bounded to the caller's stated list would have been incomplete — see Dimension 3.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content is added to any always-loaded file — confirmed by reading workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` (already loaded for this check); neither references `run-manifest.sh`.
- No new hook is registered; the script is invoked at the same four existing call sites (`session-start.md` Step 3.5, `prime.md` Step 8c.7.5, both `wrap-session.md` copies), at the same frequency as today (once per session-start, once per wrap).
- No `@import` chain, no subagent brief expansion, no new skill.
- The test-harness addition (`run-manifest.test.sh`) runs only when the suite is invoked manually/at QC time, not per session.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new `allow`/`ask` entry, no `deny` rule touched.
- The fix stays within the tool/path patterns `run-manifest.sh` already uses today: `Bash`, reading `logs/.session-marker*`, writing under `logs/runs/`. No new external capability, no cross-repo write beyond the two already-existing, already-git-tracked `wrap-session.md` copies (neither of which this fix needs to edit).
- No scope escalation (project → user), no new MCP/API surface.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: `logs/scripts/run-manifest.sh` (the fix) + `logs/scripts/run-manifest.test.sh` (new midnight cases) — 2 files.
- Per the Step 1.5 inventory: **12 consumers found, 3 must-change** (`run-manifest.test.sh`, the mission-thread checkbox, the improvement-log entry) — none of the 3 are functional breakage, all are expected bookkeeping closure for a thread this session's own mandate commits to finishing.
- The 4 runtime callers (session-start.md, prime.md, both wrap-session.md copies) are all compatible with no edit, because `run-manifest.sh` is confirmed (by direct `find` + `[ -L ]`, not by trusting the caller's claim) to be a single real file reached by ancestor walk-up — a genuinely backwards-compatible contract change from every caller's point of view.
- **The caller's own consumer list under-scoped by one real file**: it named "`/wrap-session` invokes `close`" without distinguishing that there are two independent, non-symlinked copies (canonical `ai-resources/.claude/commands/wrap-session.md` Step 12d and the workspace-root paired copy at Step 4.7), a pairing this repo has a documented history of drifting on (`docs/session-marker.md` § Two-end contract registry flags this exact pair as "PAIRED CONTRACT — edit both in lockstep" for other changes). This fix needs no edit to either copy's *text* (the shared script absorbs it silently), so the omission causes no live defect here — but it is exactly the kind of gap Step 1.5 exists to catch before it matters on a future change to this same surface.
- No contract (schema, filename shape, CLI flags) changes — `spine-schemas.md` § 1 and `check-foreign-staging.sh`'s filename regex are both unaffected, confirmed by inspection.

### Dimension 4: Reversibility
**Risk:** Medium

- The core code change (2 files: script + test) is a clean, single-repo `git revert` — no data migration, no backfill of historical `logs/runs/*.json` files (the fix only changes future invocations' behavior).
- No push, no external write, no new hook/cron/symlink — everything stays local to `ai-resources`.
- **The one extra cleanup step:** this session's own mandate (`logs/session-notes.md:335`) requires ticking mission thread 8 via `/mission update` and flipping the `logs/improvement-log.md` entry to closed, citing what shipped. A later `git revert` of the code would leave those two bookkeeping records asserting "fixed" while the code is reverted — a stale-closure state that needs a manual follow-up entry (re-open the thread, unflip the log line), not something `git revert` does for free. This is the textbook "one extra cleanup step" Medium case, not a High (no propagation beyond git, no operator muscle-memory on a new flag/command).

### Dimension 5: Hidden Coupling
**Risk:** Medium

**Answering the HAZARD directly:** the stated design constraint — relax the date match only via the per-session-id marker `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, leave the shared-file path's today-only rule untouched — **is structurally sufficient** to avoid re-opening the S4-8c3 attributable-overwrite hole. Walking each named sub-case:

- **Stale/orphaned marker from a crashed session:** not a live threat to this design. Per-id lookup is keyed on an exact filename match against *this* session's own `CLAUDE_CODE_SESSION_ID` (verified "distinct across sessions" per `docs/session-marker.md` § Harness-var dependency); a crashed session's per-id file lives under a *different* filename that this session's resolution loop never reads. It is inert dead weight, not an attribution vector, regardless of this fix.
- **Per-id marker surviving multiple days:** confirmed by direct read of `docs/session-marker.md` § Concurrent-session detection that `detect-concurrent-session.sh`'s automatic prune is **liveness-gated, not date-gated** ("foreign markers ... ANY date ... present with ZERO foreign CLI processes ... are provably dead"). So bounding-by-age would not change this specific interaction either way — pruning already depends on process liveness, not marker age. The manifest filename itself (`{date}-{marker}.json`, where `{marker}` carries the session's own id-3 suffix) is collision-safe by construction across any span of days, confirmed by re-reading `run-manifest.sh:175-194`'s own rationale.
- **`CLAUDE_CODE_SESSION_ID` unset (older CLI):** the per-id candidate path becomes `.session-marker-__unset__` (never populated), so resolution falls to the shared file unchanged, still today-gated per the design constraint — old-CLI behavior is preserved byte-for-byte. Confirmed by reading `run-manifest.sh:161` and the guard's own carve-out #2 at `:205-206`.
- **Interaction with `detect-concurrent-session.sh`'s liveness prune:** in the low-probability case where the hook falsely prunes a still-alive session's per-id marker (a documented, pre-existing limitation — "a session whose cwd differs from its CLI process cwd is invisible to the cwd signal"), the affected session's `close` would fall through to the shared file exactly as it does **today**, hitting either the existing `die()` (no shared marker) or the existing 2026-07-18 identity guard (a same-dated but foreign-owned shared marker) — both already-safe, advisory, non-corrupting outcomes. This is a pre-existing edge case, not one this fix introduces or worsens.

**What the design does NOT yet make explicit, and should (the actual finding driving Medium, not the HAZARD's named sub-cases, all of which check out):**

- `docs/session-marker.md`'s own canonical marker-resolution snippet (§ Marker resolution) requires the per-id oracle to ALSO be today-dated (`[ "${CONTENT%% *}" = "$TODAY" ] && MARKER=...`) before it is trusted — the doc calls a non-today per-id file "stale" and routes it to the loud fallback. The proposed fix deliberately diverges from that documented "canonical pattern every consumer uses" for this one reader, and the caller's own OUT-OF-SCOPE clause keeps `docs/session-marker.md` untouched this session. That leaves a real, discoverable inconsistency: the doc will keep telling future maintainers that per-id trust is today-gated everywhere, while `run-manifest.sh` alone will not be.
- `run-manifest.sh`'s own header (lines 145-153) currently asserts it resolves date/marker "from the SAME ORACLE `/prime` and `/wrap-session` already use (`docs/session-marker.md` § Marker resolution)" — after this fix, that claim becomes inaccurate on the specific point of staleness tolerance, and the comment is not called out for revision anywhere in the change description.
- The improvement-log entry that is the origin of this thread (`logs/improvement-log.md:507`, 2026-07-13) explicitly recommended "keep the existing stale-marker refusal for a marker older than ~1 day so a genuinely abandoned marker is still caught." The proposed design does not commit to any bound — the walk-throughs above show the practical risk of leaving it unbounded is low (per-id files are self-attributable by construction), but the original logged proposal's bound is not addressed one way or the other, which is a gap given it is the authoritative source thread 8 is closing.
- `logs/scripts/check-decision-refs.sh` (an already-shipped sibling, read-only/advisory) implements a *fully unconditional* version of this same pattern with no staleness bound at all — but it never writes anything, so a wrong resolution there degrades to a wrong report, never a corrupted file. `run-manifest.sh`'s `start`/`close` do write, so this sibling is *not* a safe precedent to mirror verbatim, despite the improvement-log's suggestion to do so — the caller's own design (bounding the relaxation to the per-id file only, keeping the shared-file guard) already shows awareness of this and is more conservative than the sibling. This is a positive, not a negative — but it should be stated explicitly at the change site so a future maintainer doesn't "simplify" run-manifest.sh toward the sibling's fully-unconditional shape.

None of the above is a live functional break (no other component's behavior depends on run-manifest.sh's specific staleness definition), which is why this stays Medium rather than High — but it is a real, nameable practice-vs-documentation divergence that should not land silently.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read directly; present on disk) plus the workspace/ai-resources `CLAUDE.md` (already loaded).

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** This is a targeted correction to an already-shipped, already-wired script with four confirmed existing consumers; no new component, no generalization for an absent consumer. The test-harness addition is direct regression coverage for the exact defect being fixed. Good alignment.
- **OP-12 (closure before detection) — actively served, not violated.** The change closes a logged, reproduced defect rather than adding new scanning/detection without closure. Positive alignment.
- **OP-5 (advisory vs. enforcement) — preserved.** The script's ADVISORY RULE (absent = routine, malformed = loud) is untouched; if anything, the fix *reduces* how often the non-blocking `die()` path fires by correctly resolving cross-midnight sessions that today incorrectly hit it. No enforcement upgrade.
- **OP-10 (system boundary) — not implicated.** No cross-tool coordination involved.
- **OP-11 / OP-3 (loud revision, never silent drift) — the live tension.** As detailed in Dimension 5, the fix quietly revises how one reader (`run-manifest.sh`) interprets marker staleness relative to the documented canonical pattern in `docs/session-marker.md`, without recording that revision anywhere. OP-11 exists precisely to require that a practice-vs-principle (here, practice-vs-documented-contract) divergence be "surfaced and resolved loudly... never silent drift." This is a genuine tension, not a clear violation: the divergence can be made loud cheaply — a one-line addition to `docs/session-marker.md`'s registry naming `run-manifest.sh` as a consumer with a stated, bounded divergence, plus an updated header comment in the script itself — and neither action touches the marker FILE GRAMMAR or the lifecycle contract (allocation, teardown) that the caller's OUT-OF-SCOPE clause actually protects. Scored Medium, not High, because a lightweight, in-scope path to satisfying OP-11 exists and is named below as a mitigation; it is not yet taken.
- **DR-1 / DR-3 (placement) — no issue.** No new component, no new file category.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not inferred.** Independently reproduced by direct execution in a sandbox (not read off the file, not trusted from the caller's transcript): built a start-stub at `--date 2026-07-17 --marker S9-abc`, wrote a matching per-id session marker dated `2026-07-17 S9-abc`, then ran `close` on the real current date (`2026-07-18`, confirmed via `date '+%Y-%m-%d'`):
  - `close --outcome X` with no flags → `run-manifest.sh: could not resolve the session marker (no --marker, and no today-dated marker file...)`, `EXIT=2`. Re-read the original stub afterward: `outcome` still `None`. Matches claim (a) exactly, including the verbatim error text.
  - `close --marker "S9-abc"` (no `--date`) → printed `no start-stub existed (session skipped mandate confirmation) — wrote a wrap-time stub instead`, exit 0, and created a **second** file `2026-07-18-S9-abc.json` with `outcome=DELIVERED` while `2026-07-17-S9-abc.json` stayed at `outcome=None`. Matches claims (b) and (c) exactly, including the misleading cause text (a stub demonstrably existed, one day earlier).
  - The FOURTH FINDING (undocumented `die()`/exit-2 path) was independently confirmed: `grep -n -i "exit 2\|midnight\|could not resolve the session marker" ai-resources/.claude/commands/wrap-session.md` returns zero hits, while the NOTICE/exit-0 path is documented at three separate points (~:243-245).
  - The TEST GAP claim was independently re-run: `grep -niE "midnight|cross-day|yesterday|date.*roll" logs/scripts/run-manifest.test.sh` returns nothing (exit 1, no matches).
  - The "single real file, zero symlinks" claim was independently re-derived via `find` + `[ -L ]` across the whole workspace (not trusted from the caller's transcript) — confirmed.
- **Consequence — traced, not assumed.** The exact consequence (permanent null-outcome stub; a second, wrongly-dated manifest; a misleading error message) was directly observed in the JSON files before and after each command, not inferred from the code. The "nothing reads the manifests yet, so this degrades telemetry rather than blocking work" framing is independently confirmed (`session-start.md:373`: "Nothing reads the manifest yet... a failure here is advisory by construction"), and the caller's own added counter-consideration (an exit-2 mid-wrap still interrupts the operator) is also independently confirmed as real (see Dimension 5's FOURTH FINDING treatment) — the claimed severity is calibrated, not overstated in either direction.
- **Re-derivation vs. the change description:** None — every count, path, and quoted line was independently re-derived (by direct execution or direct read) and confirmed. The mission-thread doc (`repo-health-backlog-2026-07.md:85`) cites the `die()` call at `:171`; the live script has it at `:172` — a trivial one-line drift in an *upstream* document, not an error introduced by this CHANGE_DESCRIPTION, which itself correctly cites `:172`.
- Corroborating independent evidence found in this session's own working files (not required for the verdict, but consistent): `audits/working/verify-cluster-B-2026-07-18.md` § B3 ("CONFIRMED"), `logs/session-plan-2026-07-18-S9-f53.md`, and `logs/improvement-log.md`'s 2026-07-13 entry (`Status: logged (pending)`) all independently describe the identical failure shape.

## Mitigations

- **Dimension 3/5 (missed consumer + documentation currency):** before commit, note explicitly (in the commit message or `decisions.md`) that the workspace-root paired `wrap-session.md` copy (Step 4.7) needs no code edit because the fix lives entirely in the single shared script — this closes the caller's own consumer-list gap by record rather than by silence, and gives the next session a citable reason not to re-open it.
- **Dimension 5/6 (OP-11 loud revision):** add a one-line entry to `docs/session-marker.md` § Two-end contract registry naming `run-manifest.sh` as a marker consumer with a stated, deliberate divergence (per-id oracle trusted across days for this reader only, shared-file path unchanged) — this is a narrow, additive documentation note, not a change to the FILE GRAMMAR or lifecycle contract, so it does not cross the session's own OUT-OF-SCOPE line. If the operator prefers to keep `docs/session-marker.md` fully untouched this session, defer this note as an explicit, named follow-up (not a silent drop) and record the deferral in `logs/decisions.md`.
- **Dimension 5 (stale comment):** update `run-manifest.sh`'s own header rationale (lines ~145-153) so it no longer unconditionally claims to use "the same oracle" as the canonical `docs/session-marker.md` pattern — add the one-line qualifier that this reader's staleness tolerance deliberately differs, and why (own-session date-carry-forward vs. other-consumers' this-moment attribution).
- **Dimension 5/6 (unbounded trust window):** explicitly decide, and record the decision, on whether to bound the per-id marker's trust window (the origin improvement-log entry recommended ~1 day; the structural analysis above suggests the practical risk is low even unbounded, given per-id files are self-attributable by construction) — either bound it (e.g., 7 days, generous enough for a long-idle session, tight enough to still catch a genuinely-ancient abandoned marker) or state explicitly why unbounded is accepted. Either answer is fine; leaving it unexamined is not.
- **Dimension 4 (reversibility):** if this fix is later reverted, re-open mission thread 8 and un-flip the `logs/improvement-log.md` entry in the same follow-up action — cross-reference the code commit hash in both records so the paired bookkeeping revert is discoverable rather than silently stale.
- **Test coverage (supports Dimension 5's HAZARD answer):** extend the planned midnight test cases beyond a single next-day rollover to include (a) a multi-day-idle per-id marker (2-3 days old) closing correctly, (b) the per-id marker absent (simulating a `detect-concurrent-session.sh` prune) falling through to the existing, unchanged shared-file/`die()`/identity-guard behavior rather than a new code path, and (c) `CLAUDE_CODE_SESSION_ID` unset degrading to today's exact pre-fix behavior.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: live command execution in an isolated sandbox (start/close reproduction of all three claimed symptoms, JSON re-read before/after), direct `grep`/`find` re-derivation of every count and claim in `CHANGE_DESCRIPTION` (test-gap grep, documentation-gap grep, symlink census), direct reads of `run-manifest.sh`, `run-manifest.test.sh`, `docs/session-marker.md`, `docs/spine-schemas.md`, `check-decision-refs.sh`, `wrap-session.md` (both copies), `session-start.md`, `prime.md`, `logs/missions/repo-health-backlog-2026-07.md`, `logs/improvement-log.md`, and `projects/strategic-os/ai-strategy/principles-base.md`. No claim in `CHANGE_DESCRIPTION` was accepted on trust — every factual assertion was independently re-verified against live filesystem/execution state, and one real gap (the omitted workspace-root `wrap-session.md` consumer) was found beyond what the caller supplied. No training-data fallback was used on fetch/read failures.
