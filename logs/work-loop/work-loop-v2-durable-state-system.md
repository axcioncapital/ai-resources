---
task: work-loop-v2-durable-state-system
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 1 — Tracer bullet 1: prove the canonical state validator behind an inactive seam.

Named reason for the loop: this is a high-risk, multi-unit lifecycle-state migration whose scope must remain bounded and whose implementation requires independent assessment before it can progress.

## Brief

This unit starts implementation at the frozen plan's safest preparation seam: establish one read-only source of lifecycle classification before any live consumer or tracked record changes. It is first because later migration and atomic cutover depend on a validator whose legal and illegal outcomes are already proven. Current position on 2026-08-14: the plan review is complete and frozen at commit `3b351a37`; no implementation unit has yet been accepted, and this checkout is opening Tracer 1 under the old runtime.

**Required outcome:** Given an exact checkout and task ID, the new validator emits exactly one accepted one-word classification for valid new-contract state or exits nonzero with a specific invariant diagnostic, while producing no writes and leaving every existing runtime consumer on old semantics.

**Governing authority:**

- Current operator decision, 2026-08-14: begin implementation through Work Loop v2.
- Frozen plan: `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`, status `FROZEN — approved for sequential implementation`, content at commit `3b351a37`.
- Accepted architecture bound in that plan to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/reports/work-loop-v2-session-state-system-investigation-2026-08-14.md`, SHA-256 `6c72333a25d5cc93eb0ba8d2b4022cb9b67b3a4daa8c79dc05ae7740df37fc08`.
- Axcíon Standard Implementation Workflow bound in that plan to `/Users/patrik.lindeberg/.codex/attachments/b361d6ee-12ce-4bac-9bc5-edaa70d623af/pasted-text.txt`, SHA-256 `b425966ec1d78caa086fa5f09c422374d90aa2581ab26984ecaae208bbb76f65`.
- Work Loop v2 executable core for the active old-runtime handoff: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`.

**Check against the repository before acting:**

1. Verify this exact task file belongs to this checkout and task ID, the checkout is uniquely bound to it under the current owner contract, and repository-depth ownership/actor checks permit entry. If identity, binding, or live-writer evidence is ambiguous, change nothing and hand back the evidence.
2. Verify the frozen plan and both content hashes above. A mismatch is an authority conflict and stops the unit.
3. Verify `logs/scripts/work-loop-state.sh` is absent and identify the bounded existing state-parsing consumers named by the plan's Repository Delta; do not turn that confirmation into consumer edits.
4. Verify the current Bash/test conventions directly in `logs/scripts/` and the existing Work Loop tests before selecting implementation details.
5. Prove the plan's preparation-compatibility claim against one representative current consumer: adding `status` to a representative valid record must not break that still-live old consumer. Keep this proof isolated from tracked-record migration.

**Unit boundary:** Implement only Capability A and Tracer bullet 1: the smallest read-only canonical validator and focused legal/illegal fixture suite covering task identity and path bounds, symlinks, frontmatter, the four legal status-turn pairs, exact active/blocked and closed body contracts, optional `## Brief`, unsupported headings, and specific failure diagnostics. Use the repository's existing Bash baseline and conventions.

**Codex framing decision:** Hold record migration, `.owner` format changes, executable-core authority changes, consumer integration, owner-helper changes, Reorient, couriers, legacy session commands, deployment, shared-lease work, and all later tracer bullets outside this unit. This preserves the plan's inactive-seam ordering and prevents a partial runtime cutover.

**Required evidence:**

- failing-first evidence that the validator command or its required behaviour was absent before implementation;
- focused suite output showing exactly `ACTIVE_CLAUDE`, `ACTIVE_CODEX`, `BLOCKED_OPERATOR`, and `CLOSED` for legal fixtures;
- fail-capable negative controls for every invalid dimension in this unit, each returning nonzero with a diagnostic identifying the violated invariant;
- proof that a symlinked state path is rejected;
- before/after evidence that validator execution leaves the fixture checkout byte-identical;
- proof that one representative old consumer still handles a status-augmented valid record;
- direct-execution and proportional shell-portability/regression evidence;
- a scoped diff showing no runtime consumer, tracked task record other than this handoff, owner representation, executable-core contract, courier, recovery, legacy-session, or deployment behaviour changed.

**Completion condition:** Implement and commit one coherent Tracer 1 slice, then replace the latest result with the actual outcome and evidence, set `turn: codex`, and hand back for independent assessment. The unit is complete only when the validator suite is green, every requested classification and rejection is capable of failing, the validator has no write path, and no runtime consumer has switched.

**Stop conditions:** Stop and hand back without broadening if a governing hash or task binding fails, a fixed plan premise is false, compatibility with a status-augmented record fails, the validator cannot remain read-only and consumer-independent, required evidence cannot be produced, or the change would cross this unit's boundary. Challenge a false premise explicitly rather than improvising a fallback parser or second state system.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — `logs/work-loop/work-loop-v2-durable-state-system.md` carries `task: work-loop-v2-durable-state-system`, matching its filename and the resolved id; `bash logs/scripts/work-loop-owner.sh check --checkout /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-durable-state --task work-loop-v2-durable-state-system --depth repo` returned `verdict: PROCEED` (exit 0), reason "this checkout already declares task 'work-loop-v2-durable-state-system'". `logs/work-loop/.owner` reads `work-loop-v2-durable-state-system 2026-08-14`. No other checkout claims the task and no live-writer ambiguity was reported.
- Claim (2): HOLDS — `shasum -a 256` on `reports/work-loop-v2-session-state-system-investigation-2026-08-14.md` returned `6c72333a…37fc08` and on `~/.codex/attachments/b361d6ee-…/pasted-text.txt` returned `b425966e…bbb76f65`; both match the brief exactly. The plan's line 5 reads `**Status:** FROZEN — approved for sequential implementation`, and `git diff 3b351a37 -- plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md` is empty, so the working-tree plan is byte-identical to the frozen content.
- Claim (3): HOLDS — `ls logs/scripts/work-loop-state.sh` returned "No such file or directory" before implementation, and the file is absent from `git ls-files`. Searched `.` with `grep -rln 'logs/work-loop' --include='*.sh'` and `grep -rn 'fm_value|validate_state'`; the state-parsing consumers found are exactly the ones the plan's Repository Delta names — `logs/scripts/work-loop-owner.sh` (`task_is_closed`), `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (`fm_value`, `validate_state`), `scripts/axcion-harness-v0.2/carry-turn.sh`, `.codex/hooks/work-loop-reorient.sh`, plus the instruction-borne Claude command and Codex skill. No consumer was edited.
- Claim (4): HOLDS — read `logs/scripts/work-loop-owner.sh` (413 lines) and `logs/scripts/work-loop-owner.test.sh` (696 lines) in full for the conventions actually in use: `set -uo pipefail`, `die()` printing `STOP [code] message` to stderr, numbered exit taxonomy, `mktemp -d` sandbox with an `EXIT` trap, `ok()`/`bad()` counters, a "Case 0" falsifiability proof, and `pwd -P` canonicalisation for the macOS `$TMPDIR` symlink. `bash --version` reports GNU bash 3.2.57, so no Bash 4 syntax was used. Baselines before any change: `work-loop-owner.test.sh` 92 passed / 0 failed, `work-loop-v2-slice-1.test.sh` 308 passed / 0 failed.
- Claim (5): HOLDS — read the two live parsers: `task_is_closed()` in `work-loop-owner.sh` scans frontmatter lines for `^turn:[[:space:]]*operator` and `fm_value()` in `dispatch.sh` matches a supplied key prefix; neither enumerates the key set, so an added `status:` line is ignored by both. Proved empirically rather than left at inspection — suite cases P1, P3 and P5 add `status:` to an old-shape record inside a real git checkout and assert `work-loop-owner.sh check` returns a byte-identical verdict before and after (both `PROCEED`, exit 0), that its closed-detection path is undisturbed, and that `dispatch.sh --status` still reports `turn=codex task=p-open`. Kept isolated from tracked-record migration: the fixtures are temporary, and no tracked record gained `status`.

Result: Tracer bullet 1 is implemented. `logs/scripts/work-loop-state.sh` (new, executable) is the read-only Capability A validator — `validate --checkout PATH --task ID` emits exactly one of `ACTIVE_CLAUDE`, `ACTIVE_CODEX`, `BLOCKED_OPERATOR`, `CLOSED` on stdout, or exits nonzero with a diagnostic naming the violated invariant (10 usage, 11 checkout, 12 task id, 13 state path, 14 identity, 15 frontmatter, 16 body). It implements the accepted architecture's nine numbered checks and nothing beyond them. `logs/scripts/work-loop-state.test.sh` (new) is the acceptance matrix. The seam is inactive: no runtime consumer was changed or wired to it.

Two real defects were found by the suite and fixed before hand-back, both in the first implementation: the heading set-difference passed a newline-separated list through `awk -v`, which cannot carry an embedded newline, so every heading diagnostic came out as an awk parse error (replaced with `grep -vxF`); and the inactive-seam assertion searched every `.md`, so it fired on a hook-written write-activity log and on a Work Loop v1 file whose name merely ends in `work-loop-state.sh` (narrowed to runtime surfaces with an anchored path).

Evidence:

- **Failing-first.** Before implementation `ls logs/scripts/work-loop-state.sh` returned "No such file or directory". The suite's own falsifiability proof re-runs it against an absent validator: `STATE_BIN=/nonexistent/... bash logs/scripts/work-loop-state.test.sh` → **8 passed, 52 failed**; the same suite against the real validator → **61 passed, 0 failed**. The 8 that still pass are the usage/argument cases that a missing file also rejects.
- **Legal matrix.** L1–L5 assert the four accepted classifications plus the optional `## Brief`; L6/L7 assert success prints exactly one line and writes nothing to stderr.
- **Negative controls, each fail-capable.** Every illegal fixture is derived from a legal base by exactly one mutation, and the base is asserted green in the same run (F0, B0, C0, I7). 33 rejection cases cover identity mismatch, traversing and illegal task ids, missing checkout, missing/unreadable file, symlinked state path, symlinked `logs/work-loop`, absent and unterminated frontmatter, unsupported and duplicated keys, missing keys, unknown `status`/`turn` values, non-`key: value` lines, all three illegal status-turn pairs, missing and out-of-order headings, unsupported headings, empty `Latest result`/`Next action`, and a `blocked` record whose `Blocker` is empty or `None.`. Each asserts the exit code, that stdout stayed empty, and that stderr names the invariant.
- **Symlink rejection is about the link, not the content.** I6 rejects a symlink whose target is a valid record (exit 13); I7 then validates the same bytes at a real path (`ACTIVE_CLAUDE`). I8 rejects a symlinked `logs/work-loop` directory, which the per-file test cannot see.
- **Read-only.** R1 takes a SHA-256 manifest of a fixture checkout, runs the validator across a valid, a closed, a malformed and an absent task, and asserts the manifest is unchanged. R2 proves the manifest is fail-capable by appending one byte and asserting it is noticed. The validator contains no redirection, `mv`, `cp`, `rm`, `mkdir` or `touch` against the checkout.
- **Compatibility.** P1–P5 as recorded under claim (5).
- **Inactive seam.** R3 searches `*.sh` plus `.claude/`, `.agents/` and `.codex/` for an anchored `/work-loop-state.sh` and asserts no caller exists.
- **Execution and portability.** X1–X8: executable bit, direct shebang execution, four `BAD_USAGE` argument cases, `bash -n` under Bash 3.2, and a checkout path containing a space (the ordinary case in this workspace).
- **Regression.** After the change, `work-loop-owner.test.sh` 92 passed / 0 failed and `work-loop-v2-slice-1.test.sh` 308 passed / 0 failed — both identical to the pre-change baseline.
- **Scoped diff.** `git status --porcelain` shows only the two new files and this state file. `git diff --stat` over tracked files shows one entry, `logs/friction-log.md`, which a repository hook appended with a write-activity trail while this unit ran. It was not authored by this unit and was **not staged** — staging was by explicit pathspec. No runtime consumer, no other tracked task record, no owner representation, no executable-core contract, no courier, recovery, legacy-session or deployment behaviour changed.

## Blocker

None.

## Next action

Codex: closure check on the frozen finding only — are the dangling-option cases now resolved, and did the correction break something.

Reproduced first (2026-08-14), before any change: `bash logs/scripts/work-loop-state.sh validate --checkout` and `validate --task` (each with the value-taking flag as the last argument) both ran a background process that was still alive after a 3-second watchdog wait and had to be `kill -9`ed — no output, no exit, matching the frozen finding exactly. Root cause confirmed: Bash's `shift 2` past the end of the positional list is a silent no-op rather than an error, so `$1` never changed and the `case`/`while` loop spun.

Correction made: `logs/scripts/work-loop-state.sh`, the `--checkout`/`--task` arms of the argument loop. Before consuming `$2`, each arm now checks `[ "$#" -ge 2 ]` and calls `die 10 "--checkout requires a value"` / `die 10 "--task requires a value"` if not — the smallest guard that closes the gap without touching any other branch. `${2:-}` reverted to plain `$2`, since the guard makes the value's presence certain by the time it is read.

Verified by direct reproduction: both dangling-option invocations now exit 10 with the stated message in under a second, run in the foreground with no backgrounding needed. Two focused regression cases were added to `logs/scripts/work-loop-state.test.sh` (X9, X10), each run under an internal 5-second watchdog so a future regression fails the suite instead of hanging the test process; a case that got the message right but the harness's status-vs-diagnostic parsing wrong was caught and fixed inside this same correction before being counted as evidence.

Evidence:

- Full validator suite: **63 passed, 0 failed** (61 from the unit plus X9/X10 from this correction).
- Falsifiability preserved: the same suite against an absent validator is **8 passed, 54 failed** (up from 52, because X9/X10's failure mode is also fail-capable against an absent binary).
- Regression, unchanged from the unit's own evidence: `work-loop-owner.test.sh` **92 passed, 0 failed**; `work-loop-v2-slice-1.test.sh` **308 passed, 0 failed**.
- `bash -n` on both `work-loop-state.sh` and `work-loop-state.test.sh`: clean.
- Scoped diff: `git status --porcelain` shows exactly `logs/scripts/work-loop-state.sh`, `logs/scripts/work-loop-state.test.sh`, this state file, and `logs/friction-log.md` (the recorded hook-noise deferral, unchanged from the unit, not staged). Nothing else in the repository moved.

Nothing beyond the frozen finding was touched: the deliberate emptiness limit and the unordered exact frontmatter key set were left exactly as accepted, and the `logs/friction-log.md` deferral was not acted on.
