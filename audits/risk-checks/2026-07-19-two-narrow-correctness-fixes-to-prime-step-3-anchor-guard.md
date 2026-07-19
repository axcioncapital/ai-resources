# Risk Check — 2026-07-19

## Change

PROPOSED CHANGE: Two narrow correctness fixes to `/prime` Step 3 in `ai-resources/.claude/commands/prime.md`. This is NOT the emit-side parser redesign that this same gate returned RECONSIDER on earlier today (2026-07-19, `audits/risk-checks/2026-07-19-proposed-change-replace-prime-step-3-s-improvement-log-scan.md`). That design is abandoned; do not treat its verdict as either approval or rejection of this different, much smaller change. Score this change on its own merits.

⚠ INSTRUCTION TO THE REVIEWER — RE-DERIVE, DO NOT INHERIT. Every number below was measured by me this session and each states its instrument and the instrument's scope. Verify them independently rather than accepting them; this repo has logged 8+ instances of plausible-but-wrong counts reaching gate briefs, including one in THIS mission where a repo-scoped instrument answered a workspace-scoped question and was written into a gate brief as an emphatic correction. If any figure below is wrong, say so — that is a more valuable output than a verdict built on my arithmetic.

THE TWO CHANGES, both tested standalone before this brief (prime.md is currently UNTOUCHED — `git diff --stat -- .claude/commands/prime.md` is empty):

(1) Widen the severity anchor to admit bolded severity values.
  FROM: ^-? ?\*\*Severity:\*\* *(high|HIGH|medium-high|critical|urgent)
  TO:   ^-? ?\*\*Severity:\*\* *\*{0,2}(high|HIGH|medium-high|critical|urgent)
  Delta: +7 chars on one line.
  Problem it fixes: two genuine HIGH entries write `- **Severity:** **high**` (bolded value) and are invisible to the current anchor, so they never reach the task menu. Instrument: `command grep -nE '^-? ?\*\*Severity:\*\* *\*\*' logs/improvement-log.md` → returns exactly `:797` and `:1172`. Repo-scoped instrument, repo-scoped claim; scopes match.
  Measured result: OLD anchor matches 33 entries; NEW matches 35. Diff of matched line-numbers shows the newly-matched set is EXACTLY {797, 1172} — no other entry changes state.
  ⚠ FALSIFIABILITY TEST, declared before running and the case that could genuinely have failed: `logs/improvement-log.md:13` is the log's own schema block and contains the literal text `- **Severity:** `low` | `medium` | `medium-high` | `high` | `critical``. A carelessly-widened anchor would match this VOCABULARY DECLARATION and inject a phantom urgent item into the task menu of every consumer. Tested: the candidate anchor does NOT match line 13 (the value is backtick-delimited, so `\*{0,2}` matches zero asterisks and then fails on the backtick). This hazard was NOT named in the prior session's handoff notes; I found it by censusing every distinct severity spelling in the file.

(2) Guard the inline python3 unclassified-count scan against a missing log.
  FROM: `import re` / `L=open('logs/improvement-log.md',...)`  (unguarded)
  TO:   `import re,os` / `p='logs/improvement-log.md'` / `if os.path.exists(p):` + 4 lines indented under it
  Delta: +45 chars.
  Problem it fixes: the unguarded `open()` raises FileNotFoundError and emits a Python traceback into session context at orientation in every consumer directory that has no `logs/improvement-log.md`.
  Instrument and scope: I enumerated EVERY directory carrying a `.claude/commands` tree (workspace-scoped instrument for a workspace-scoped claim, not a repo-local grep) and tested `[ -f "$d/logs/improvement-log.md" ]`. Result: 9 of 27 consumer dirs lack it — axcion-ai-system-owner, axcion-communication-system, axcion-sector-intelligence, axcion-systems-builder, corporate-identity, management-os, repo-documentation, harness, pe-kb-vault. ⚠ The prior session's scratchpad claimed "10 of 28." I did NOT carry that forward — I re-derived and got 9 of 27. Please check which is right.
  Four test cases run, each with the expected value declared BEFORE execution: (i) unguarded + log missing → traceback (defect reproduced); (ii) guarded + log missing → exit 0, silent, no output; (iii) guarded + log present (fixture) → "UNCLASSIFIED: 1 of 2", byte-identical to unguarded; (iv) guarded + the real ai-resources log → 0 unclassified, prints nothing, identical to current live behaviour. No regression in either direction.

STATIC COST (the dimension that killed the previous design — measured, not asserted): total +52 chars against prime.md's current 84,111, i.e. +0.0618%. The rejected redesign added +7,396 chars; this is 142x smaller. Both figures measured by python len() on the exact before/after strings.

BLAST RADIUS — I am stating this against my own interest rather than letting you discover it. prime.md is distributed by symlink and reaches a large consumer set, so this dimension is High by the rubric's >5-callers threshold regardless of how small the change is. My inventory: 26 paths resolve to the canonical file (22 projects + workspace root + harness/ + knowledge-bases/pe-kb-vault/ + archive/nordic-pe-macro-landscape-H1-2026/). ⚠ TWO CORRECTIONS TO THE PRIOR GATE'S FIGURE, both against my own earlier claim: (a) the prior risk-check stated 25 direct symlink consumers — I measure 26, because it counted symlinks per-file and missed `axcion-design-studio`, whose `.claude/commands` DIRECTORY is a symlink; (b) my own first instrument for this was `[ -L "$d/.claude/commands/prime.md"` which is INVALID — it resolves through a directory symlink then tests the final component, so a symlinked command-dir containing a real file reports "REAL FILE". I re-derived with `readlink -f` per path. This is the same `[ -f ]`-follows-symlinks failure already logged in this workspace as research-workflow thread F-13, reproduced by me and caught by the operator. Please re-derive the consumer count yourself; I have been wrong on it once already today. Genuinely unaffected: axcion-sector-intelligence (independent 33-line stub with no Step 3 at all) and the research-workflow template stub. Also note two paths under `.claude/worktrees/agent-a0eea7b56ea3bbb85/` resolve into that worktree's own stale ai-resources checkout — thread 3's known unversioned-checkout gap; out of scope here, and no "fixed everywhere" claim may be made.

REVERSIBILITY: single-file, two-hunk edit; `git revert` restores exactly. No new file, no new script, no hook, no wiring, no permission surface, no settings change, no symlink change.

ALTERNATIVES the gate should weigh against this proposal, stated because a gate that never sees the cheapest option cannot properly judge the more expensive one:
  (i) DO NOTHING. Two genuine HIGH backlog entries stay invisible to the orientation menu indefinitely, and 9 of 27 consumer dirs keep emitting a Python traceback at every session start.
  (ii) DELETE Step 3 entirely. Cheapest possible fix and never scored. The urgent-item channel already returns zero in most project logs (a separate logged defect), so its value is genuinely questionable. My view: probably loses, because it removes a working channel from the populated logs instead of repairing the schema gap — but it deserves comparison, not silent omission.
  (iii) FIX ONLY (1) OR ONLY (2). They are independent defects in the same 31-line block; splitting them doubles the gate cost for the same edit surface.
  (iv) WAIT and fold both into the later externalization redesign. This is what the external reviewer (Codex) recommended, to avoid building something that will be replaced. My concern: that redesign needs its own gate, this mission's gate has now returned RECONSIDER twice, and if it returns a third the two live defects stay unfixed indefinitely.

EXPLICITLY OUT OF SCOPE, and the mandate's stop condition forbids drifting into any of it: the externalization redesign (moving the parser to logs/scripts/); the six-candidate output cap; the cross-project Severity schema migration (a /friday-act task); any change to the -B6 window (forbidden by prime.md:217).

STOP CONDITION ON THIS GATE: on RECONSIDER or NO-GO I record the verdict, build nothing, and do not argue it down or route around it. That is the signed mandate at logs/session-notes.md:430-439, and it has been honoured on the two preceding RECONSIDERs in this mission.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-19-proposed-change-replace-prime-step-3-s-improvement-log-scan.md — exists (prior, different, RECONSIDER'd design — read for context only, not scored)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both fixes are real, small, backward-compatible, and independently reproduced byte-for-byte in this gate (including the falsifiability test and all four guard test cases); the only dimensions that don't clear Low are the file's unavoidable structural blast radius (>25 live consumers, mitigable because propagation is atomic and zero callers need modification) and two count-precision gaps in the change description's own arithmetic (a documentation-convention gap and a consumer-count discrepancy that does not touch the core defect claims).

## Consumer Inventory

Search terms derived from the change: `prime.md` (basename), the severity-anchor regex fragment `^-? ?\*\*Severity:\*\*`, the guard target `logs/improvement-log.md`, and `Step 3` scoped to this specific scan block (lines 199–228).

| Consumer path | Reference type | Must change? |
|---|---|---|
| 26 symlinked `.claude/commands/prime.md` paths — workspace root, `harness/`, `knowledge-bases/pe-kb-vault/`, `archive/nordic-pe-macro-landscape-H1-2026/`, and 22 `projects/*/` dirs (including `axcion-design-studio`, whose `.claude/commands` is a *directory* symlink — missed by a plain `find .` walk and by a `[ -L file ]` test; both confirmed independently, see Dimension 3) | invokes | no — auto-propagate atomically via symlink, zero separate edits |
| `projects/axcion-sector-intelligence/.claude/commands/prime.md` (real file, 33 lines) | documents (stale divergent stub) | no — confirmed by direct grep: 0 hits for `Severity`/`improvement-log`; no Step 3 content at all |
| `ai-resources/workflows/research-workflow/.claude/commands/prime.md` (real file, 33 lines) | documents (stale divergent stub) | no — same confirmation, 0/0 hits |
| `projects/axcion-communication-system/.claude/commands/` (4 custom commands: `drill.md`, `gate-selftest.md`, `ledger-check.md`, `review.md`) | n/a | no — **not a consumer at all**; this directory has no `prime.md`, real or symlinked. Confirmed by direct `ls`. Included in the change description's "9 of 27 lacking the log" list even though the fix cannot reach this directory (see Dimension 7). |
| `.claude/worktrees/agent-a0eea7b56ea3bbb85/.claude/commands/prime.md` and `…/harness/.claude/commands/prime.md` | co-edits (stale, out of scope) | no — confirmed by direct `diff`: both differ from the canonical file already (pre-existing drift, unrelated to this change); the change description correctly places this out of scope |
| `ai-resources/docs/backlog-reconciliation.md` | documents Step 1a only | no — grepped directly; references only the Step 1a git cross-check, never Step 3/`Severity`/`improvement-log.md`. Checked explicitly to rule out a lockstep-pair coupling; none found |
| `logs/improvement-log.md` (data source) | parsed-by (not a caller of the change's contract) | n/a — the file the change reads; noted for completeness, not counted in the consumer total |

**Total: 26 real, live symlinked consumers (must-change = no, all — atomic propagation); 2 inert stub copies (confirmed zero Step-3 content, unaffected); 2 stale worktree copies (already diverged, correctly out of scope); 1 directory wrongly counted by the change description as a consumer (`axcion-communication-system` has no `prime.md` at all).** This is not an isolated change — every active project's session-start orientation reads the canonical file — even though the mechanical edit surface is a single two-hunk diff in one file.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `prime.md` is a command file (read once per `/prime` invocation, not an always-loaded CLAUDE.md and not a PreToolUse hook), so the calibration points for Medium/High (always-loaded-file growth, per-tool-call hooks, broad-match skills) do not apply to this file class at all.
- Measured delta: +52 chars total against a 84,111-char file (python `len()`, confirmed independently — see below), ≈13 tokens. Two orders of magnitude below the Medium threshold (~50–150 tokens) even if this were an always-loaded file.
- Independently re-measured: `python3 -c "print(len(open('.claude/commands/prime.md',encoding='utf-8').read()))"` → `84111` — exact match to the change description's figure (note: `wc -c` reports 84,945 bytes on this UTF‑8 file; the description's char-count figure is the correct comparator and was verified against `len()`, not `wc -c`).
- Re-derived the two per-hunk deltas directly by diffing the exact before/after regex and code-block strings: anchor hunk = **+7 chars** (confirmed exactly); guard hunk = **+45 chars** (confirmed exactly); total = **+52 chars**, matching the change description's figure exactly.
- No new `@import`, no new hook, no new subagent brief, no skill trigger touched.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new `allow`/`ask`/`deny` entries required. `ai-resources/.claude/settings.json` already grants unscoped `"Bash(*)"` with `"defaultMode": "bypassPermissions"` (confirmed by direct read) — the existing Step 3 already runs `python3 -c "…"` under this same grant; the change edits the code *inside* the existing invocation, it does not change the invocation form or add a new tool class.
- No scope escalation (project → user), no new external capability, no MCP/API surface touched, no symlink change.

### Dimension 3: Blast Radius
**Risk:** High — mitigable

- **Grounded directly in the Step 1.5 inventory:** 26 live symlinked consumers (>5, the explicit High threshold on caller count), reaching every active project's session-start orientation. Independently re-derived via `find -L . -path '*/.claude/commands/prime.md'` (31 raw hits) minus 1 canonical, minus 2 stale worktree copies, minus 2 inert 33-line stubs = 26 real consumers — matches the change description's figure exactly, including its correction of the prior gate's "25."
- **Both of the change description's self-flagged instrument bugs were independently reproduced.** (a) A plain `find . -path '*/.claude/commands/prime.md'` (no `-L`) returns only 29 hits and silently misses `axcion-design-studio` — confirmed: its `.claude/commands` entry is a *directory* symlink (`lrwxr-xr-x … commands -> ../../../ai-resources/.claude/commands`), and default `find` does not descend into symlinked directories. (b) Confirmed the shell-test bug independently is real: a `[ -L "$d/.claude/commands/prime.md" ]` test resolves through the directory symlink and stats the final regular file, reporting "not a symlink" for a consumer that in fact fully inherits the canonical content — an instrument that would have undercounted by exactly one, exactly as claimed.
- **Mitigating factor, also grounded in the inventory:** must-change = no for all 26 (symlinks propagate the single canonical edit atomically); the 2 real-file stub consumers are confirmed to carry zero Step-3 content and cannot regress; the 2 worktree copies are already diverged and explicitly out of scope.
- Because ">5 dependent callers" and "shared infra touched in a way that affects multiple workflows" are both independently met, this is scored High on the honest reading of the rubric, notwithstanding the mitigating propagation mechanics — consistent with how this same file was scored on the prior (much larger) proposal today.
- **Viable mitigation:** before/immediately after landing, run one live `/prime` in a real consumer directory from each population — one with `logs/improvement-log.md` present (to confirm the two previously-invisible HIGH lines now surface with no new false positives) and one from the confirmed-missing-log set, e.g. `harness/` (to confirm the guard degrades silently in a real directory, not only in the synthetic fixture used in this gate). This closes the one residual gap the fixture-based testing (Dimension 7) does not cover: the byte-identical form actually embedded in `prime.md`, exercised in a real checkout.

### Dimension 4: Reversibility
**Risk:** Low

- Independently confirmed: `git diff --stat -- .claude/commands/prime.md` and `git status --short -- .claude/commands/prime.md` both return empty — prime.md is genuinely untouched at gate time, exactly as claimed.
- Single canonical-file, two-hunk edit. `git revert` restores all 26 symlinked consumers atomically and instantly — no per-consumer cleanup (filesystem symlinks, not copies).
- No `settings.json` change, no new file, no new script, no hook, no external write.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Downstream reasoning is unaffected.** Step 5's menu-building filter is model-level free-text reasoning over the returned `-B6` lines ("Include only if HIGH-severity marker… Exclude LOW/MED/resolved"), not a machine parser expecting an unbolded value — confirmed by direct read of prime.md:224–228. A bolded `**high**` value is read the same way a plain `high` is. No functional coupling risk from the anchor widening itself.
- **The guard fix applies an already-established convention rather than inventing one.** Step 2's prose (prime.md:197) already documents "An absent or empty `next-up.md` is normal, not an error" for a different missing-file case. This fix extends the same graceful-degradation pattern to `improvement-log.md`'s python scan — a documented convention, not a new one.
- **One genuine gap: the anchor widening breaks the file's own established self-documentation precedent.** prime.md:219 reads: "Widened 2026-07-18; the old `^- ` anchor silently skipped them" — a prose note logging the *previous* anchor widening (the un-dashed-variant tolerance) immediately adjacent to the anchor itself. The proposed diff, as stated in the change description, touches only the regex line — it does not add a matching note for *this* widening (the bolded-value tolerance). A future maintainer reading line 219 alone would believe the anchor tolerates only the un-dashed variant, not bolded values — an implicit dependency on a convention the change doesn't honor. This is the Medium heuristic's "one implicit dependency on an established repo convention" case exactly.
- **Mitigation (see Mitigations section):** land one additional prose line at prime.md:219 in the same commit, mirroring the existing sentence's form (e.g., "Further widened 2026-07-19 to tolerate a bolded value (`**high**`); two live entries used this form and were previously invisible.").

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read directly, frozen-ID index).

- **OP-9/AP-7/DR-7 (speculative abstraction) — not triggered.** This is a bug fix to an actively-firing, universally-invoked scan (26 live consumers run this code today); no new command/agent/gate/component is created, so the DR-9 creation complexity-budget gate does not apply.
- **OP-12 (closure before detection) — not in tension, arguably serves it.** This change adds no *new* detection channel. It repairs an *existing* detection channel's reach to correctly cover cases it was always intended to cover — confirmed by `logs/improvement-log.md:13`'s own schema note: "This field has a machine consumer... An entry with no Severity line is unreachable, invisible to the one channel that converts findings into shipped work." Fixing a false-negative in an existing, intended-scope detector is closure-aligned, not a new detection build.
- **OP-5 (advisory vs. enforcement) — untouched.** `/prime` remains advisory (surfaces to a task menu; the operator picks). No shift toward auto-action.
- **OP-2 (automate execution, gate judgment) — untouched.** No judgment call is being automated or re-gated; this is a correctness fix to existing automated execution.
- **OP-10 (system boundary) — not touched.** No cross-tool coordination involved.
- **OP-11 (loud revision) — the code change itself is fine (it's a bug fix, not a principle revision); the one related gap is the documentation-convention lapse captured under Dimension 5, not a principle violation.**

### Dimension 7: Problem Reality
**Risk:** Medium

- **Defect 1 (bolded-severity anchor gap) — observed, not inferred, and consequence traced exactly.** Independently ran both anchors against the live file: OLD anchor `command grep -cnE '^-? ?\*\*Severity:\*\* *(high|HIGH|medium-high|critical|urgent)' logs/improvement-log.md` → **33**; NEW anchor → **35** — exact match to the change description. Computed the diff of matched line numbers directly (`comm -13` on sorted line-number sets): the newly-matched set is exactly **{797, 1172}**, matching the claim precisely. Read both lines directly: both read `- **Severity:** **high** — …`, genuine HIGH-tier content. Ran the falsifiability test myself: tested line 13 (the schema's own backtick-delimited vocabulary declaration) against the new anchor directly — no match (exit 1) — confirming the widened anchor does not create a phantom urgent item from the schema block. **All of this is directly reproduced, not inherited.**
- **Defect 2 (unguarded `open()`) — observed and reproduced by execution, four-for-four on the declared test cases.** Read prime.md:208–213 directly: the existing `python3 -c` block calls `open('logs/improvement-log.md', ...)` with no guard. Reproduced independently: (i) unguarded + missing file → `FileNotFoundError` traceback, exit 1 — reproduced exactly; (ii) guarded (`import re,os` / `if os.path.exists(p):` form) + missing file → silent, exit 0 — reproduced exactly; (iii) guarded + a 2-entry fixture with one unclassified entry → `UNCLASSIFIED: 1 of 2 entries carry no Severity field`, byte-identical to the unguarded form run against the same fixture — reproduced exactly; (iv) guarded run against the real `ai-resources/logs/improvement-log.md` → silent, exit 0, identical to the unguarded form's current live output (0 unclassified today) — reproduced exactly. No regression in either direction, confirmed by direct execution rather than by reading the diff.
- **Consequence — traced, not assumed, on both defects.** Neither defect's consequence rests on an inferred-but-unverified claim; both were independently reproduced by direct execution/grep in this gate.
- **Re-derivation vs. the change description — one material discrepancy found, on the guard-fix's stated blast area (the "9 of 27" figure), and it does not survive re-derivation.** The change description already flags this figure as uncertain ("please check which is right" against a prior "10 of 28" claim). Independent re-derivation, scoped correctly this time to *only the 26 directories where prime.md actually resolves to the canonical Step-3 code* (the same population Dimension 3 established — not "every directory with any `.claude/commands` tree"), finds **7 of 26** lack `logs/improvement-log.md`: `harness`, `knowledge-bases/pe-kb-vault`, `projects/axcion-ai-system-owner`, `projects/axcion-systems-builder`, `projects/corporate-identity`, `projects/management-os`, `projects/repo-documentation`. This is 7 of 5 named dirs shared with the change description's list of 9, minus 2 the change description wrongly includes: `axcion-communication-system` (confirmed by direct `ls`: this directory has no `prime.md` at all — the guard code never runs there, so whether it has the log is irrelevant to this defect) and `axcion-sector-intelligence` (confirmed: its `prime.md` is the 33-line stub with zero Step-3 content — same reasoning). **The correct, re-derived figure is 7 of 26, not 9 of 27** — the underlying defect and its traceback consequence are unaffected (still real, still reproduced, still affects 7 real directories), but the change description's own count of *how many directories it fixes* has now been wrong on three successive attempts within this same session (10/28 → 9/27 → the correct 7/26), which is itself the kind of repeated-miscount pattern this dimension exists to catch, even though it doesn't undermine the core defect claim. Scored Medium rather than Low for this reason — the defect and consequence are real and traced, but a repeatedly-wrong magnitude claim should not be allowed to propagate into a permanent log entry uncorrected.
- **Not defect-justified items:** none — every material claim in this change description is a defect-repair claim, and both defects were checked and confirmed real with traced consequences; only the blast-area *count* of defect 2 needed correction.

## Mitigations

- **Dimension 3 (Blast Radius, High):** before or immediately after landing, run one live `/prime` Step 3 in a real consumer directory from each population — one with `logs/improvement-log.md` present, and one from the confirmed-missing-log set (e.g. `harness/`) — to confirm the byte-identical form actually embedded in `prime.md` behaves as tested here (new anchor surfaces the two previously-invisible HIGH lines with no new false positives; guard degrades silently in a real, not only synthetic, missing-log directory).
- **Dimension 5 (Hidden Coupling, Medium):** land one additional prose line at prime.md:219, in the same commit as the regex change, documenting the new bolded-value tolerance — mirroring the existing sentence's form ("Widened 2026-07-18…") so the anchor's documented tolerance stays in sync with its actual behavior.
- **Dimension 7 (Problem Reality, Medium):** when recording this fix (improvement-log entry, mission thread, or decisions.md), use the re-derived figure **7 of 26** consumer directories lacking `logs/improvement-log.md`, not "9 of 27" — and drop `axcion-communication-system` and `axcion-sector-intelligence` from the "affected" list, since neither runs this code path at all.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, executed reproductions, or explicit finding notes). No training-data fallback was used on fetch/read failures. Every count, path, and testing claim in the change description was independently re-executed against the live filesystem in this session; one material discrepancy was found (Dimension 7, the guard-fix blast-area count) and is recorded above with the corrected figure; it does not weaken either core defect's reality or traced consequence.
