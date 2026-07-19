# Risk Check — 2026-07-19

**Adaptation note:** this gate covers TWO independent structural changes bundled under one plan-time gate (session S6-e72), per explicit caller instruction ("Score BOTH changes across the seven dimensions"). Item 1 (harness hermeticity) is explicitly excluded from scoring per the caller's own scope line and is not evaluated below. The report therefore carries two Consumer Inventories, two Dimension blocks, and two Verdicts — one per change — followed by a combined summary.

## Change

Plan-time gate on two structural-class changes in session S6-e72, mission repo-health-backlog-2026-07. Plan: logs/session-plan-2026-07-19-S6-e72.md (read it first — it carries the full findings).

SCOPE OF THIS GATE: items 2 and 4 only. Item 1 (making logs/scripts/test-destructive-liveness.sh hermetic) is deliberately excluded — it edits a manually-run test script with no automatic invocation, no consumers, and full reversibility; its control is a falsification gate, not a risk review. Do not score item 1.

CHANGE 2 (marker teardown): diagnose why per-session markers survive a clean wrap despite two wired controls, and land the fix ONLY if the cause sits in an in-repo file (.claude/hooks/detect-concurrent-session.sh or .claude/commands/wrap-session.md). If the cause sits in the unversioned ~/.claude/hooks/cleanup-session-marker.sh, record the diagnosis and STOP.

CHANGE 4 (prime Step 3 emit redesign): change what the /prime Step 3 improvement-log scan EMITS — parse entries and emit compact unresolved-HIGH summaries — so its output fits the 40-line budget. Currently 343 lines.

[Full verified-facts block, mandate cap, and "what I need from you" questions carried verbatim in the input — see re-derivation results throughout this report; not reproduced a second time here to avoid duplicating ~120 lines of already-quoted text.]

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-07-19-S6-e72.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/close-worktree-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/.claude/hooks/cleanup-session-marker.sh — exists
- /Users/patrik.lindeberg/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists

## Verdict

- **Change 2 (marker teardown diagnosis + conditional in-repo fix): PROCEED-WITH-CAUTION**
- **Change 4 (prime Step 3 emit redesign): RECONSIDER**

**Summary:** Change 2's diagnostic-first, mandate-capped design is sound and well-verified, but the deletion path inside `detect-concurrent-session.sh` needs a tighter, named safeguard before any fix touches it. Change 4 fixes a real, independently-confirmed 8.6x budget overrun, but the redesign as scoped stacks a >20-consumer symlink blast radius on top of a genuinely under-specified new parsing surface (mechanical Status-field exclusion, which has no precedent the way the Severity field's anchor does) — two Highs, which this framework does not let mitigations paper over.

---

## Consumer Inventory — Change 4 (prime.md)

Search method: `find -L` semantics used deliberately (per caller instruction) to distinguish symlink from real-file consumers across the workspace root, `ai-resources`, and every `projects/*/` — not a repo-local grep. Search terms: basename `prime.md`; contract marker `prime.md:223`'s severity/backtick anchor.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `/Claude Code/Axcion AI Repo/.claude/commands/prime.md` (workspace-root) | invokes (symlink → canonical) | no — auto-propagates |
| 22 × `projects/*/​.claude/commands/prime.md` (buy-side-service-plan, axcion-content-programme, axcion-ai-system-owner, global-macro-analysis, axcion-copy-factory, corporate-identity, marketing-positioning, obsidian-pe-kb, axcion-website, axcion-brand-book, interpersonal-communication, repo-documentation, axcion-systems-builder, research-pe-regime-shift-advisory-gap, nordic-pe-screening-project, management-os, positioning-research, project-planning, strategic-os, axcion-ai-system-redesign, ai-development-lab, axcion-communication-system) | invokes (symlink → canonical, confirmed via `[ -L ]`) | no — auto-propagates |
| `projects/axcion-sector-intelligence/.claude/commands/prime.md` | **REAL FILE, not a symlink** — 33 lines vs canonical's 764 (confirmed by direct `diff`/`wc -l`); read in full: it is a deliberately independent, minimal research-workflow variant with no Step 3 severity scan, no marker allocation, no mission binding at all | no — out of scope; shares no logic with the changed Step 3 code |

**Total: 24 consumer locations found, 0 must-change.** This is the exact scope trap the caller named: `[ -f ]` cannot distinguish the 22 auto-propagating symlinks from the 1 genuinely independent real file, and getting that wrong in either direction would misstate blast radius. The real-file case turned out to be a non-issue for this specific change (different template, not a stale copy needing sync) — but the count itself (>20 propagating consumers, all inheriting a single canonical file with no modification of their own) is the primary driver of Dimension 3 below, and matches the plan's and mission's own self-description ("prime.md is distributed to every project by symlink").

## Consumer Inventory — Change 2 (marker-teardown contract)

Search method: grep for the literal token `session-marker-` across `.claude/commands`, `.claude/hooks`, `docs`, `logs/scripts` (ai-resources), plus an explicit check of the workspace-root and per-project `wrap-session.md` distribution (the file most likely to carry a fix).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/hooks/detect-concurrent-session.sh` | co-edits (candidate fix target #1 — reads + prunes markers) | conditional — yes, only if diagnosis routes here |
| `.claude/commands/wrap-session.md` (canonical) | co-edits (candidate fix target #2 — Step 13 self-teardown, Step 3.5 attribution) | conditional — yes, only if diagnosis routes here |
| `/.claude/commands/wrap-session.md` (workspace-root, **independent 296-line copy, confirmed NOT a symlink**) | co-edits (documented "MIRROR NOTE" sibling — "port this teardown there too... on the next sync") | conditional — yes, only if the wrap-session.md route is chosen, and NOT currently listed in the session plan's Stage 2 steps |
| `~/.claude/hooks/cleanup-session-marker.sh` (unversioned) | co-edits — but **edit forbidden by the mandate cap**; this is the diagnosis target, not an edit target | no (diagnosis-only path if root cause lands here) |
| `.claude/commands/prime.md` | invokes (writes markers Step 8k, reads Step 1a) | no |
| `.claude/commands/session-start.md` | parses | no |
| `.claude/commands/session-plan.md` | parses | no |
| `.claude/commands/clarify.md` | parses | no |
| `.claude/commands/concurrent-session-check.md` | parses | no |
| `.claude/commands/close-worktree-session.md` | parses (liveness read, Step 3) | no |
| `.claude/hooks/check-foreign-staging.sh` | parses (commit-time guard) | no |
| `.claude/hooks/check-destructive-liveness.sh` | parses | no |
| `docs/session-marker.md` | documents (canonical contract registry) | no |
| `docs/commit-discipline.md` | documents | no |
| `logs/scripts/foreign-session-guard.sh` | parses | no |
| `logs/scripts/run-manifest.sh` / `run-manifest.test.sh` | parses | no |
| `logs/scripts/check-decision-refs.sh` | parses | no |

**Total: 17 consumers found. 2 are the sanctioned in-repo fix-target candidates (must-change conditional on diagnosis outcome); 1 additional non-symlinked mirror copy must also change if the wrap-session.md route is chosen and full propagation is intended — not currently scheduled in the plan's Stage 2.** The remaining 14 read the marker *file format* only (path + `"YYYY-MM-DD SN"` content), which the mandate-capped fix (teardown *timing*, not schema) is not expected to touch — so they are compatible by construction, not by verification. `positioning-research` and `axcion-sector-intelligence`'s `wrap-session.md` copies (33 lines each, confirmed identical-length independent files) are the same out-of-scope research-workflow variant found for `prime.md` — not additional propagation risk.

---

## Dimensions — Change 2 (marker teardown)

### Dimension 1: Usage Cost
**Risk:** Low

- Both candidate fix targets are already-registered, once-per-session hooks/commands (`detect-concurrent-session.sh` fires once at SessionStart, `~/.claude/settings.json:78`; `wrap-session.md` runs once at wrap, on demand). No new registration, no new always-loaded content, no new `@import`.
- The diagnosis-only (STOP) path costs nothing beyond a log entry.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new tool/capability grant is plausible within the mandate-capped scope: `Bash(*)` and `Write(**)` (`~/.claude/settings.json:10,13`) already cover any edit to the two named in-repo files.
- The mandate cap explicitly excludes the one route that WOULD widen the permission surface (thread 3's hook-installer, which needs a settings.json merge/backup capability) — and that route has already scored High/High on `/risk-check` twice per `logs/missions/repo-health-backlog-2026-07.md:97`, confirming the cap is doing real work, not just paperwork.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Consumer Inventory above: 17 files reference the marker-file contract; only 2 are candidate co-edit targets, conditional on which branch the diagnosis lands on; 14 are read-only, format-compatible consumers unaffected by a timing-only fix.
- The one **unanticipated** consumer this inventory surfaced: the workspace-root `wrap-session.md` (independent 296-line copy, not a symlink) is not named anywhere in the session plan's Stage 2 execution steps, yet the file's own existing "MIRROR NOTE" doctrine already obligates porting any Step-13-area change there. This is a genuine gap between the plan as written and the file's own documented propagation contract.

### Dimension 4: Reversibility
**Risk:** High

- `git check-ignore -v logs/.session-marker-e72a98aa-...` confirms per-id marker files are **gitignored** (`.gitignore:36`), not tracked. A `git revert` of a code change to `detect-concurrent-session.sh` does **not** restore a marker file the bad code deleted — that state is gone outside git's reach.
- The mandate cap permits (does not forbid) a fix that touches `detect-concurrent-session.sh`'s prune/deletion condition (`:182`, `rm -f` on markers the script judges provably dead). The caller's own question (c) names this exact path. If a fix loosens the current, deliberately conservative gate (`GROUNDED=1 AND FOREIGN_HERE=0` before pruning; "Prune NOTHING in this mode" at the degrade branch, `:187-192`, verified by direct read), it could delete a genuinely-live session's marker — and this hook fires at **every SessionStart, machine-wide** (`~/.claude/settings.json:78`, a single global registration), so a bad change would fire repeatedly, on every project, before anyone notices.
- This matches the Reversibility heuristic's High triggers directly: "automation... that could fire between the change landing and a potential revert" and "state has propagated beyond git."

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The liveness contract is a three-way dependency (per-id marker + `lsof`-grounded process check + `FOREIGN_HERE` count) spanning two files that must agree; a fix in one risks silently changing what `check-foreign-staging.sh` (a different consumer, different purpose — commit-blocking) sees.
- This coupling is **not hidden in the "undocumented" sense** — it is unusually heavily commented in both `detect-concurrent-session.sh` (its own header names all 4 consumers) and `cleanup-session-marker.sh` (same). The residual risk is that the diagnosis session, focused on the SessionEnd-delivery question, does not re-check the other three named consumers before landing a fix — a discipline gap, not an invisibility gap.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-9 / AP-7 (no speculative abstraction) / DR-7:** the mandate cap is a textbook-correct application — it explicitly refuses to open thread 3's unbuilt hook-installer (a second, larger, unconfirmed-scope problem) and confines the session to a diagnosis-bounded, already-observed defect. This is the opposite of speculative building.
- **Non-negotiable "verify by execution, not by reading"** (`logs/missions/repo-health-backlog-2026-07.md:62`): Stage 2's steps 1–3 (birth-time check, lsof/prune-path reachability, empirical SessionEnd-delivery observation) are all execution-based, matching the mission's own governing discipline.
- No OP-12 concern (this closes an existing detection gap rather than adding new unclosed detection); no OP-5 enforcement creep (nothing here moves an advisory mechanism to auto-correct beyond what already exists).
- Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present; used directly, no fallback needed).

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** OBSERVED, independently, this session:
  - `grep -nE "SessionEnd|cleanup-session-marker" ~/.claude/settings.json` → `:141` (`"SessionEnd": [`), `:146` (`bash "$HOME/.claude/hooks/cleanup-session-marker.sh"`); `grep -nE "detect-concurrent-session" ~/.claude/settings.json` → `:78`. Both wired, exactly as claimed.
  - `wc -l ~/.claude/hooks/cleanup-session-marker.log` → 1 line, content `2026-07-19T13:41:18 NOOP marker-absent .../axcion-communication-system/logs/.session-marker-db74b21c-... (payload keys: cwd,hook_event_name,prompt_id,reason,session_id,transcript_path)` — matches the change description verbatim.
  - `ls logs/.session-marker-*` in ai-resources → 4 files: 3 dated 2026-07-18 (`S11-637`, `S8-a1b`, `S9-f53`) plus this session's own live `S6-e72` marker. The three stale markers match the claim exactly.
  - `grep -n "^## 2026-07-19" logs/session-notes.md` → S1 through S6, confirming five prior sessions (S1–S5) ran today before this one.
  - **One additional fact I re-derived beyond what was asked:** `stat -f "%SB"` on `cleanup-session-marker.log` returns the exact same timestamp as its one content line (`Jul 19 13:41:18 2026`) — meaning that line is the log's first-ever write. The hook has been user-level-registered since 2026-07-13 (`~/.claude/hooks/cleanup-session-marker.sh` header, "Operator decision, 2026-07-13"), so if SessionEnd had been firing normally across the ~6 days and dozens of sessions since, the log would already hold many lines, not start today. This *strengthens* the leading hypothesis without proving it — exactly the caveat the change description itself applies.
- **Consequence — traced or assumed?** The **defect** (markers surviving) is traced directly to observable state (files on disk, empty log). The **cause** (SessionEnd non-delivery) is explicitly and correctly labeled a hypothesis by the caller, not asserted as fact, and the plan's own Stage 2 exists specifically to establish it by execution before any fix lands. That is the right discipline, not a gap — scored on what is asked of me now (a plan-time gate before the diagnosis), not on a diagnosis I have not yet run.
- **Re-derivation vs. the change description:** None — all nine facts under Change 2 re-derived and confirmed, including the exact log line, exact settings.json line numbers, and exact stale-marker set.

---

## Dimensions — Change 4 (prime Step 3 emit redesign)

### Dimension 1: Usage Cost
**Risk:** Low

- The change's entire purpose is a net **reduction** in per-session token cost (343 lines → <40, an 8.6x cut), not an addition. No new always-loaded file content, no new hook, no new subagent spawn frequency change.

### Dimension 2: Permissions Surface
**Risk:** Low

- Whatever the redesign's implementation shape (inline `python3 -c`, additional `grep`/`awk`), it stays within the Bash-call category `/prime` Step 3 already uses today (the existing third scan is already an inline `python3 -c` block, `prime.md:208-216`). No new tool family, no new capability.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory: **24 consumer locations**, of which 23 auto-propagate a single canonical file via symlink (workspace root + 22 projects), confirmed by `[ -L ]`, not by the weaker `[ -f ]` test the caller specifically warned against.
- This is explicitly self-identified as a risk-check-triggering class by both the session plan ("Item 4 touches the file every project loads at orientation. A regression here degrades every session's task menu," `session-plan-2026-07-19-S6-e72.md:85`) and the mission thread ("prime.md is distributed to every project by symlink," `repo-health-backlog-2026-07.md:158`). >5 auto-propagating callers touching shared infra every session loads at orientation is a direct High per the stated heuristic.
- Mitigating structural note (does not change the level, but matters for the redesign note below): because there is exactly ONE canonical file and 23 pure symlinks, a bad edit and its `git revert` both land everywhere simultaneously and atomically — there is no partial-propagation failure mode the way there was for Change 2's wrap-session.md mirror copy.

### Dimension 4: Reversibility
**Risk:** Medium

- Mechanically, `git revert` on a single canonical file is clean and instant, and — per the Blast Radius note above — fixes all 23 propagating consumers in one shot (a structural strength, not a weakness).
- The residual risk is the **exposure window**: because the file is read at the start of essentially every session across every project, a regression (e.g., a phantom urgent item, per Dimension 5 below) would actively mislead operator attention machine-wide for every session primed before the bad edit is caught and reverted. This is a soft, operational cost rather than a data-loss or external-write cost, which is why it lands at Medium rather than High.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Sub-risk A — preserving the already-documented Severity/backtick exclusion.** Re-derived by direct execution, not by trusting the citation: `grep -nE "^-? ?\*\*Severity:\*\* *\*{0,2}(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md | grep "^13:"` → no match (exit 1) — confirming `logs/improvement-log.md:13` (the schema's own vocabulary-declaration line, containing `` `low` | `medium` | `medium-high` | `high` | `critical` ``) is correctly excluded today, exactly as `prime.md:223` (re-read and confirmed at that exact, corrected line number) documents. This exclusion is real, load-bearing, and — importantly — **already well-documented at the change site**, which argues against automatically defaulting to High on this sub-risk alone.
- **Sub-risk B — the redesign requires a NEW, undocumented parsing surface.** The acceptance bar ("compact **unresolved**-HIGH summaries," and the mission's own validation contract, "no hit... on an entry whose status is applied / resolved / declined," `repo-health-backlog-2026-07.md:54`) requires mechanically classifying the `Status:` field — something `/prime` Step 3 today deliberately does NOT do in code (`prime.md:227-229` hands that filtering to the model's own in-context reading, not a parser). The Severity field needed **two separate anchor-widening iterations** to get right (`prime.md:221` "Widened 2026-07-18," `:223` "Widened 2026-07-19") after shipping with silent gaps both times. A first-time mechanical Status-field parser has no equivalent hardening history and no anchor-comment analogue documenting its edge cases — this is a genuinely new and unproven parsing surface, not a restatement of an already-solved problem.
- Two distinct, real coupling risks compounding on one shared-infra, >20-consumer file is what pushes this to High rather than Medium.

### Dimension 6: Principle Alignment
**Risk:** Low

- Not speculative (OP-9/AP-7/DR-7): the 343-line measurement is a directly re-derived, current, real cost against a frozen validation-contract budget — not a hypothetical future consumer.
- Arguably strengthens OP-12 alignment (closure before detection): this shrinks an existing detection channel's *output* to make it more actionable, rather than adding new unclosed detection.
- No placement issue (DR-1/DR-3): the edit stays inside the file's existing canonical home.
- Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present; used directly).

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** OBSERVED, re-run independently this session, not trusted from the brief:
  - `grep -nE -B6 "^-? ?\*\*Severity:\*\* *\*{0,2}(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md | wc -l` → **343**, exact match to the claim.
  - `grep -nE "30 of 8[0-9]|of 87|of 88" .claude/commands/prime.md` → zero matches (exit 1), confirming the caller's own self-correction of thread 15's mis-citation.
  - `logs/improvement-log.md:13` read directly: contains BOTH the backtick-delimited schema declaration AND the "30 of 88" historical note on the same line — confirming fact 5's claim exactly.
- **Consequence — traced or assumed?** TRACED, not assumed: Step 3's grep runs inline as part of every `/prime` invocation and its raw output enters context directly (`prime.md:203-216`) — there is no indirection between "the scan returns 343 lines" and "343 lines of text enter this session's context," so the token-cost consequence is mechanical, not inferred.
- **Re-derivation vs. the change description:** One minor, non-material discrepancy: thread 15's "the Severity backfill created 21 new medium-high entries" is not independently reproducible without a historical snapshot; my own count (`grep -cnE` for medium-high hits) returns **33 current medium-high hits**, a related but not identical figure. This does not affect the core 343-line/8.6x-budget finding, which is exact and confirmed. Everything else — including two previously-corrected mis-citations in the brief itself (`:219` not `:217`; `:223` not `:206-221`) — was independently re-verified and found accurate.

---

## Mitigations — Change 2 (PROCEED-WITH-CAUTION)

- **[Dimension 4, High — mandatory.]** Before landing any change to `detect-concurrent-session.sh`'s prune/deletion-trigger condition (the `GROUNDED`/`FOREIGN_HERE` gate around the `:182` `rm -f`), apply the same falsification-gate discipline the plan already requires for item 1: construct a scenario where liveness is genuinely ungrounded (`lsof` unavailable or inconclusive) and prove the fix still does **not** delete the marker in that case. Ship only after that negative-case test passes — the positive case (correctly pruning a truly-dead marker) is necessary but not sufficient, since marker files are gitignored and a bad deletion is not git-revertible.
- **[Dimension 3, Medium.]** If the fix lands in `wrap-session.md`, explicitly port it to the workspace-root independent copy (`/.claude/commands/wrap-session.md`, confirmed non-symlink, 296 lines) per that file's own existing MIRROR NOTE — and verify by `[ -L ]`/`find`, not assertion, that no other non-symlinked copy was missed (the mirror note itself does not currently enumerate `positioning-research` or `axcion-sector-intelligence`, though those two turned out to be an unrelated, out-of-scope template).
- **[Dimension 5, Medium.]** Before closing item 2, explicitly re-check `check-foreign-staging.sh` and `concurrent-session-check.md` (both independent readers of the same marker set, for different purposes) against whatever teardown-timing fix is chosen — neither is named in the session plan's Stage 2 steps.

## Recommended redesign — Change 4 (RECONSIDER)

- **Split the redesign into two separately-verified increments rather than one combined change.** (1) First, a pure downstream compaction pass built as a *reformatting layer over the existing, unmodified `-B6` grep output* (reuse today's severity regex exactly as-is; do not re-implement severity matching) — this keeps the already-solved, already-documented exclusion intact by construction rather than by care. (2) Separately, harden the new Status-field exclusion the same way the Severity field was hardened: enumerate the actual live Status-field format variants in `logs/improvement-log.md` by grep first, build the parser against that fixture, and add a named falsification test — an entry with a `resolved`/`applied`/`declined`/`verified` status must provably NOT appear in the compact output — before landing.
- **Because the blast radius is >20 auto-propagating consumers, require the landing gate to check more than line count.** Stage 3 step 4's current bar ("confirm under 40 lines with no hit on an applied/resolved/declined entry") is necessary but not sufficient — an under-40-line output that still leaks the schema-declaration line as a phantom entry would still pass a naive line-count check. Add an explicit assertion that `logs/improvement-log.md:13`'s content (or a planted synthetic-fixture equivalent) never appears in Step 3's final emitted output, and show that check's PASS output as part of the evidence before this specific thread is closed.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts re-run independently this session, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit conditional/INCOMPLETE flags where the eventual fix shape is genuinely undetermined at plan-time). No training-data fallback was used on fetch/read failures; the one file too large to `Read` in full (`logs/improvement-log.md`, 396.5KB) was queried via targeted `grep`/`sed` instead, and the `principles-base.md` fallback path was not needed (file present and read directly).
