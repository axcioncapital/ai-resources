# Risk Check — 2026-07-13

## Change

RE-GATE after RECONSIDER — the redesigned executed set (session 2026-07-12 S5). Purpose: make the run-manifest's `decisions_refs` field actually populate at wrap, the blocking prerequisite for W3.2 R3 Pass 2. Current on-disk state: (1) NEW `logs/scripts/decision_ref_slug.py` — THE single definition of the anchor-slug algorithm, self-testing. (2) `logs/scripts/run-manifest.sh` MODIFIED — new `--decision-ref-from-header` flag takes a decisions.md header line VERBATIM and derives the slug in code (no hand-derivation); plus a new symlink-safe self-location block (`SCRIPT_DIR`) replacing `dirname "$0"`. (3) NEW `logs/scripts/check-decision-refs.sh` — validates a manifest's decisions_refs resolve to real headers across decisions.md + all monthly archives; imports slug() from the module; symlink-safe self-location; guarded ImportError and guarded file-read (errors='replace' + OSError catch). (4) BOTH paired wrap-session.md copies call `--decision-ref-from-header` and additionally call check-decision-refs.sh at wrap, wrapped in `|| true`, report-only. (5) `docs/spine-schemas.md` § 1 documents the code rather than defining a prose recipe; the `-2`/`-3` de-dup step was deleted. (6) `logs/scripts/run-manifest.test.sh` EXTENDED 24 -> 35 assertions, adding coverage of the new flag, the ADVISORY paths, and a symlink-invocation regression test. (7) Records updated (decisions.md x2 S5 entries, improvement-log.md, missions/w32-migration-execution.md, redesign repo's remediation-register.md + packets/R3-run-manifest.md). NOT IN SCOPE: R3 Pass 2 itself; wrap Step 5's skip-if-routine rule.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/decision_ref_slug.py — exists (NEW)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-decision-refs.sh — exists (NEW)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh — exists (MODIFIED)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.test.sh — exists (EXTENDED 24->35)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists (MODIFIED, Step 12d)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists (MODIFIED, Step 4.7, PAIRED CONTRACT mirror)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md — exists (MODIFIED, § 1)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists (2 new S5 entries)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/runs/2026-07-12-S5.json — exists (live manifest, decisions_refs populated with 2 resolving refs)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/w32-migration-execution.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md — exists
- Prior reports read as baseline: `audits/risk-checks/2026-07-12-endtime-decision-ref-wiring-executed-set.md` (RECONSIDER), `audits/risk-checks/2026-07-12-wire-decision-ref-into-wrap-session-manifest-close.md` (PROCEED-WITH-CAUTION, plan-time)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both confirmed silent-failure paths from the prior RECONSIDER (symlink path resolution, unguarded non-UTF-8 read) are genuinely fixed and independently re-verified here by direct execution — including a nested-symlink-with-spaces-in-path test the shipped suite did not itself cover — so Hidden Coupling drops from High to Medium; Blast Radius remains High on its own numeric/structural grounds (14 consumers, 12 must-change, spanning 3 uncommitted repos), but that residual risk has a viable, already-largely-executed mitigation (synchronized cross-repo landing, independently confirmed consistent here), so one High dimension with a viable mitigation keeps this at PROCEED-WITH-CAUTION rather than RECONSIDER.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/wrap-session.md` Step 12d | invokes (edit target — `close` + new checker call) | yes |
| `.claude/commands/wrap-session.md` (workspace-root) Step 4.7 | co-edits (PAIRED CONTRACT — verbatim port, verified) | yes |
| `ai-resources/logs/scripts/run-manifest.sh` | invokes `decision_ref_slug.py` via a now symlink-safe `SCRIPT_DIR` block; this file itself was modified (plan-time excluded it from scope) | yes |
| `ai-resources/logs/scripts/decision_ref_slug.py` | new — THE definition, consumed by run-manifest.sh and check-decision-refs.sh | n/a (new artifact) |
| `ai-resources/logs/scripts/check-decision-refs.sh` | new — imports `slug()` from decision_ref_slug.py; invoked by wrap-session.md L263/239 | n/a (new artifact) |
| `ai-resources/logs/scripts/run-manifest.test.sh` | parses/tests `run-manifest.sh`'s behavioral contract | yes — **gap closed**: 24→35 assertions, symlink regression + checker-degradation tests added and re-run here (35/35 pass, independently) |
| `ai-resources/docs/spine-schemas.md` § 1 | documents (defines the `decisions_refs` ref-format contract; now documents code, not a prose recipe) | yes |
| `ai-resources/logs/decisions.md` | parses (ground-truth headers the slug is derived from) + documents (2 new S5 entries) | yes |
| `ai-resources/logs/improvement-log.md` | documents (backlog item marked applied, framed as 1-of-2 — verified) | yes |
| `ai-resources/logs/missions/w32-migration-execution.md` | documents (two-condition reopen criteria — verified) | yes |
| `projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md` | documents (R3 row, cross-repo — verified consistent) | yes |
| `projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md` | documents (Pass 2 reopen criteria, cross-repo — verified consistent) | yes |
| `ai-resources/logs/session-notes.md` | documents (session note) | yes |
| `ai-resources/logs/session-plan-2026-07-12-S5.md` | documents (session plan) | yes (new, consistent) |

Total: 14 consumers, 12 must-change (2 rows are freshly-created artifacts). Unchanged from the prior RECONSIDER's count — the redesign fixed defects, it did not shrink scope. A broader repo grep (`decision_ref_slug\|check-decision-refs\|decision-ref-from-header\|decisions_refs`) surfaces four additional historical hits (`R1-spine-schemas.md`, `case-6-chat-history-recovery.md`, `W2.3-reliability-safety-eval-spine.md`, `W3.1-red-team-findings.md`) — all pre-existing design docs that mention the schema conceptually and predate this change; none require edits and none is a surprise consumer. No unanticipated consumer was found. Cross-repo footprint reconfirmed: `git status --short` shows uncommitted changes in all three repos (`ai-resources`, workspace root, `axcion-ai-system-redesign`) — none pushed, none yet committed.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file (CLAUDE.md) touched — confirmed unchanged from plan-time/end-time findings.
- Additions live inside the existing once-per-session Step 12d/4.7 — one more Bash call (`check-decision-refs.sh`) added to an already-existing wrap step, not a new hook or per-turn cost.
- Re-ran the checker directly against the live manifest: output is 4 lines for 2 refs — short and proportional (`REFCHECK: 2/2 refs resolve (265 headers indexed across 4 file(s))`).
- No new `@import`, subagent spawn, or skill trigger.

### Dimension 2: Permissions Surface
**Risk:** Low

- `git status --short` in all three repos confirms no `.claude/settings.json` / `.claude/settings.local.json` in the changed-file list — no permission-surface edit.
- Both new scripts use only already-authorized patterns (`bash <script>`, `python3 <script>`/`python3 -`), already exercised extensively by the pre-existing `run-manifest.sh`.
- No new Write path, external API, or cross-tool capability.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory: **14 consumers, 12 must-change** — unchanged from the prior RECONSIDER's count, over the ">5 dependent callers" High threshold by a clear margin. The redesign fixed the defects inside this footprint; it did not, and could not without dropping records, reduce the footprint itself.
- `run-manifest.sh` remains a must-change file that plan-time explicitly scoped out ("explicitly NO change to run-manifest.sh") — the executed set still crosses that boundary; it is now a well-tested crossing rather than an untested one, but the boundary crossing itself is unchanged.
- **Regression-suite gap from the prior RECONSIDER is closed, verified by direct execution:** re-ran `run-manifest.test.sh` independently — `RESULT: 35 passed, 0 failed`. `grep -n "decision-ref" logs/scripts/run-manifest.test.sh` now returns multiple matches (previously zero). This specific driver of the prior High is resolved.
- Cross-repo footprint unchanged: uncommitted changes sit in three separate git roots (`ai-resources`, workspace root, `axcion-ai-system-redesign`) — reconfirmed via `git status --short` in each, none committed or pushed. Verified every touched bookkeeping record (`decisions.md` x2, `improvement-log.md`, `missions/w32-migration-execution.md`, `remediation-register.md`, `packets/R3-run-manifest.md`) is internally consistent right now — no drift found between repos.
- Net: the numeric/structural driver of High (>5 must-change consumers spanning 3 repos) persists; the test-coverage-gap driver that compounded it in the prior report is resolved. See Mitigations — this dimension's residual risk (temporarily-inconsistent cross-repo state, not incorrect code) has a concrete, largely-already-executed mitigation.

### Dimension 4: Reversibility
**Risk:** Medium

- Nothing is committed yet in any of the three repos (`git status --short` confirms modified/untracked, not committed) — today, reversal is discarding uncommitted changes, clean in all three trees.
- Once committed, the code-side files are cleanly `git revert`-able.
- `logs/runs/2026-07-12-S5.json` is a new durable data artifact; a revert of the code does not retroactively rewrite already-closed manifests. `logs/runs/2026-07-12-S1.json`'s hand-authored ref remains a confirmed orphan today (re-ran the checker against it here: `0/1 refs resolve`, exit 1) — correctly left alone, and a standing example of the append-only-residue shape this dimension flags.
- Unchanged from the prior report: Medium, not High — one extra cleanup step (a coordinated multi-repo commit sequence), not an external push/API-write.

### Dimension 5: Hidden Coupling
**Risk:** Medium

Both confirmed silent-failure paths from the prior RECONSIDER were independently re-tested here, not taken on the session's word, and both are fixed:

- **A1 (symlink path resolution) — confirmed FIXED, tested beyond the shipped regression case.** Reconstructed the pre-fix script (`dirname "$0"` instead of the `SCRIPT_DIR` self-location loop) and re-ran the exact symlink-invocation scenario: the ref silently dropped (`MANIFEST: could not derive a slug... ref DROPPED`), reproducing the original defect on the old code. Against the current code, the shipped regression test passes (`invoked THROUGH A SYMLINK, the slug module still resolves`), and I additionally tested a **nested two-level symlink through a directory path containing spaces** (this repo's own absolute path has spaces: `.../Claude Code/Axcion AI Repo/...`) — the ref resolved correctly (`['logs/decisions.md#2026-07-12-s5-a-short-test-header']`). The fix is not merely passing its own test; it is robust to the harder cases the test didn't itself construct.
- **A2 (unguarded read path) — confirmed FIXED.** Manually constructed a `decisions.md`-shaped file with an embedded non-UTF-8 byte (`\xff\xfe`) and ran `check-decision-refs.sh` against it directly: no traceback, both surrounding headers indexed correctly, the ref resolved cleanly. Separately tested a genuinely unreadable file (`chmod 000`): the script printed a loud, correctly-worded advisory (`could not read logs/decisions.md (PermissionError)`) and reported the affected ref as ORPHAN rather than crashing — `PermissionError` is a subclass of `OSError`, so the catch is the right class and is not narrower than needed.
- **New, minor finding not present in the prior report: a stale comment.** `check-decision-refs.sh` line 26 reads "change the slug() function below in lockstep" — but this file defines no local `slug()` function; it is imported at line 73 (`from decision_ref_slug import slug`). The comment describes an earlier, pre-redesign architecture (a local slug definition) that the actual code no longer has. This is not a functional defect — every behavior test above passed — but it is a real, if narrow, coupling-adjacent risk: a future editor who trusts only the comment and goes looking for "the slug() function below" in this file could reintroduce a second local implementation, recreating exactly the three-implementations-of-one-algorithm problem this whole change exists to eliminate. Cheap, one-line fix; not a blocker.
- **The `|| true` advisory boundary re-verified.** Ran the literal call-site fragment (`[ -n "$RM" ] && bash "$(dirname "$RM")/check-decision-refs.sh" "<orphan-manifest>" || true`) directly: internal exit 1 (orphan detected and printed), outer exit 0. The checker cannot block a wrap by this path.
- Net: both High-severity findings from the prior gate are closed on independent, hands-on verification (not the session's self-report). One new but minor documentation-drift finding remains. Medium, not High.

### Dimension 6: Principle Alignment
**Risk:** Medium

- **OP-12 (closure before detection) — unchanged from the prior report, still a named, bounded tension, not a violation.** `check-decision-refs.sh` is new detection with no automated closure channel (an orphan ref is surfaced, not auto-repaired). It is explicitly, permanently advisory by design (its own header: "ADVISORY, NEVER A GATE... Do not 'harden' this"), and it exists to supply payload evidence for an already-recorded S4 gate decision, not a freestanding new scan. Score Medium, as before.
- **OP-3 / false-closure — re-verified, no violation found, no regression.** Checked every touched record again independently (`decisions.md` x2 new S5 entries, `improvement-log.md`, `missions/w32-migration-execution.md`, `remediation-register.md`, `packets/R3-run-manifest.md`) — all consistently frame this as closing prerequisite **P1 of 2**, explicitly naming P2 as open ("Do not read this `applied` stamp as 'Pass 2 is now go'", "Do not read P1's closure as Pass 2 being go"). No instance of false closure found in any record.
- **OP-9/AP-7/DR-7 (speculative abstraction) / complexity-budget gate — passed, unchanged.** Two new files added; prong (a) net-simplification and prong (b) cited evidence both satisfied (three prior slug implementations collapse to one; "three of three hand-authored refs were orphans" is on-disk evidence in the module's own docstring and `spine-schemas.md`).
- **OP-5 (advisory vs. enforcement) — preserved, re-verified.** Directly executed the call-site's `|| true` fragment against an orphan-triggering manifest: outer exit 0 regardless of the checker's internal exit code. The manifest-close advisory rule is untouched.
- **Placement (DR-1/DR-3)** — clean; both new scripts sit beside the file they extend (`logs/scripts/`).

Net: no clean High-severity principle violation; the one real tension (OP-12) is loudly named at the change site rather than silently drifting. Medium, unchanged from the prior report.

## Mitigations

- **Dimension 3 (Blast Radius, High) — required before landing.** The residual risk is not incorrect code (all 12 must-change consumers were independently verified consistent here) but **temporarily-inconsistent cross-repo state** if the three repos are committed out of sequence or in separate sessions. Land all three repos' changes in the same wave: commit `ai-resources` (code + docs + `decisions.md` + `improvement-log.md` + mission thread), the workspace-root `wrap-session.md` mirror, and the two `axcion-ai-system-redesign` bookkeeping files together, in immediate succession, before ending the session — do not defer any of the four bookkeeping records to a later session. Immediately before committing, re-run `check-decision-refs.sh` against the live manifest one final time as the last pre-commit check (already confirmed here: `2/2 refs resolve`).
- **Dimension 5 (Hidden Coupling, Medium) — cheap, recommended before commit, not blocking.** Fix the stale comment at `check-decision-refs.sh` line 26 ("change the slug() function below in lockstep") to reflect the actual import-based delegation (e.g., "the slug definition is imported from `decision_ref_slug.py`, above — change it there, never here").
- **Commit-split question (from the prior RECONSIDER), answered.** The prior report's recommended split (wiring in one commit, `check-decision-refs.sh` + its wrap-time call in a separate commit with its own revert boundary) was motivated entirely by two then-unfixed, confirmed silent-failure paths. Both are now fixed and independently re-verified by direct execution here, including harder cases (nested symlinks, spaces-in-path, permission-denied files) than the shipped test itself constructs. The split is therefore **no longer a required mitigation** — it is optional ceremony at this point, not a risk-reduction step, since there is no longer a known defect to firewall behind a separate revert boundary. If the session already intends to land it as two commits, that is a reasonable, low-cost choice, but this review does not require it.

## Evidence-Grounding Note

All risk levels grounded in direct, independently-executed evidence, not the session's self-report: the full 35-assertion regression suite was re-run here (35/35 pass); the symlink defect was reproduced on a reconstructed pre-fix copy of `run-manifest.sh` and confirmed fixed on the current copy, including a nested-symlink/spaces-in-path case beyond the shipped test; the non-UTF-8 read guard was tested with a real non-UTF-8 byte and with a genuinely permission-denied file; the live manifest (`2026-07-12-S5.json`) was independently checked (2/2 resolve) and the S1 orphan was independently reconfirmed as still orphaned (0/1, exit 1); the `|| true` advisory boundary was directly executed against an orphan-triggering case (outer exit 0); every touched bookkeeping record across all three repos was read and cross-checked for false-closure language; `git status --short` was run in all three repos. No training-data fallback was used on fetch/read failures.
