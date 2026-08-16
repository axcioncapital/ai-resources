---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 6 — Tracer bullet 4: isolate Work Loop execution and recovery from the legacy session-state system while preserving that system for non-Work-Loop sessions.

Named reason for the loop: this is the next ordered slice of the frozen multi-unit migration; it changes several stateful entry and recovery surfaces whose interaction must be bounded and independently assessed before deployment work begins.

## Brief

Unit 5 / Tracer bullet 3 is accepted at commits `bd04704f` and `e28925e`: lifecycle consumers now share the canonical validator, ownership is task-only, and this task completed its first self-hosted handoff. Tracer bullet 4 is the next frozen-plan step: detach Work Loop execution and recovery from legacy session state while leaving that legacy system unchanged for non-Work-Loop sessions.

**Required outcome:** Remove Work Loop reads and writes of legacy session notes, plans, markers, manifests, scratchpads, and hook-derived state. Legacy stateful commands must refuse before writing when a valid open Work Loop task owns the checkout; active-task fresh-thread handoff must reopen the same checkout as Local from exact durable paths; validator-backed state must outrank compact or conversational summaries.

**Authority and constraints:**

- The frozen plan governs: Fixed decisions 6, 8, 11, 12, and 14; Capability F; Safe ordering step 7; and Tracer bullet 4.
- The canonical core and accepted Unit 5 runtime govern lifecycle and ownership. Reuse their validator/owner contract; add no private parser, fallback, or second state mechanism.
- Preserve the legacy session system for non-Work-Loop sessions. Do not wire, redesign, delete, or retire `check-foreign-staging.sh`.
- Admissions remain paused. Deployment, Tracer bullets 5–8, merge, push, and landing remain outside this unit.

**Verify first:**

1. Reconfirm the exact checkout/task, HEAD `e28925e`, `ACTIVE_CLAUDE`, unique repository-depth ownership, and free shared leases. Stop on ambiguity or a competing actor.
2. In the dispatcher and its test, verify the plan's named legacy coupling: `prime-session-entry.sh`, `session-notes.md`, `.session-marker`, identity initialization, and dependent allowlist/dirty-report special cases.
3. In `/prime`, `/session-start`, `/session-plan`, and `/wrap-session`, locate the first legacy-state write and confirm whether a valid-open-owner check precedes it.
4. In `.agents/skills/handoff-thread/SKILL.md` and the directly referenced active Work Loop compaction/recovery guidance, verify the plan's handoff, summary-authority, and unwired-hook premises. Bound the search to active instructions; do not scan historical records.

If a load-bearing premise is false, return the exact inspected surface and stop rather than widening the unit.

**Implement the frozen tracer:**

- Remove dispatcher legacy-session initialization and only the dependent allowlist, dirty-report, diagnostic, and test special cases.
- Put one narrow read-only owner/validator preflight before the first legacy write in each of the four named commands. A valid active or blocked Work Loop task retains the checkout and routes to its exact task or Reorient; malformed evidence stops; no open owner preserves existing command behavior.
- Add only the active-Work-Loop branch to fresh-thread handoff: same bound checkout as Local, exact task/plan/next-action paths as navigation, and no copied state snapshot. Preserve generic handoff behavior.
- Correct only active Work Loop compaction/recovery text needed to make the exact task path and validator authoritative, and remove only Work Loop claims that the unwired hook supplies a state or commit boundary.
- Update directly owning tests or one focused existing-style proof helper if no owner exists. Do not create a general command-test framework.
- Commit one coherent Tracer 4 slice including the handback. Leave `logs/friction-log.md` untouched and outside the commit.

**Proportionate evidence:**

- Show the dispatcher legacy coupling failing before and absent after, with one run/fixture proving no legacy state path changes and the full dispatcher suite green.
- Prove the shared command rule with the smallest discriminating fixtures: an open task refuses before the first write, a blocked task retains ownership and surfaces its blocker, malformed owner/state evidence stops, and no owner preserves prior behavior. Separately show mechanically that all four named commands apply that same preflight before their first write; do not run a lifecycle-by-command cross-product.
- Show one active-task and one non-Work-Loop handoff fixture proving the new branch is narrow and does not duplicate state.
- Show one conflicting-summary recovery case in which the exact task path and validator win, plus a bounded active-instruction scan showing no remaining Work Loop guarantee attributed to the unwired hook.
- Report exact counts and exits for tests directly changed by this unit and the canonical state/owner regression suites. Do not add unrelated regression suites merely because they exist.
- Report the final commit and exact path list, demonstrating no excluded subsystem or friction-log change and this record validating as `ACTIVE_CODEX`.

**Completion condition:** Commit the bounded Tracer 4 implementation and return the evidence above in `## Latest result`, with `status: active` and `turn: codex`. State that admissions remain paused, non-Work-Loop legacy sessions remain functional, nothing was deployed or landed, and Tracer 5 has not started.

**Stop conditions:** Stop if the preflight cannot be read-only and precede the first write; the handoff branch cannot target the bound checkout without copying state; implementation would require a private parser, new state machinery, hook wiring, legacy-system redesign, excluded scope, or unavailable/red required evidence.

## Latest result

Inspected (2026-08-16):

- Claim (1): HOLDS — checkout `ai-resources-durable-state` on `session/2026-08-14-durable-state`; `git rev-parse HEAD` = `e28925e737b30ec4b6b5ea95e776bb365dd3fe95`; `logs/work-loop/.owner` holds the single line `work-loop-v2-durable-state-system`; validator prints `ACTIVE_CLAUDE` exit 0; `work-loop-owner.sh check --depth repo` prints `PROCEED` across the 17 registered worktrees; `.git/work-loop-dispatch-locks` holds no `task-*.lock` or `checkout-*.lock`, only a historical refusal record from 2026-08-15 — both leases free.
- Claim (2): HOLDS, with one correction to the brief's navigation — searched `dispatch.sh` and `dispatch.test.sh` for `prime-session-entry`, `session-notes`, `session-marker`, `session_identity`. All six named couplings were present in **`dispatch.sh` only**: allowlist append (line 465), `allowlisted_dirty()` exclusion (1968), exit-32 table entry (188–198), `init_session_identity()` (2538–2594), dry-run text (2666), pre-launch invocation (2675). `dispatch.test.sh` carried **no** legacy special case — the grep returned nothing. This is the reason the suite could not prove the removal on its own (see below).
- Claim (3): HOLDS — searched all four command files for `work-loop-owner`, `work-loop-state`, `ACTIVE_CLAUDE`, `.owner`; no match in any. No valid-open-owner check existed anywhere. First state writes located: `/prime` Step 0's `--rebase --autostash` pull (moves HEAD, can stash an uncommitted record) ahead of Step 8h's marker allocation; `/session-start` Step 3's `**Mandate:**` line; `/session-plan` Step 7's plan file; `/wrap-session` Step 0.5's continuity scratchpad.
- Claim (4): HOLDS — `handoff-thread/SKILL.md` line 25–27 defaulted every Git project to a worktree with `startingState: { type: "working-tree" }`, and carried no Work Loop branch of any kind.
- Claim (5): HOLDS — searched the bounded active surface (`AGENTS.md`, `docs/compaction-protocol.md`, the `work-loop-v2`, `reorient` and `handoff-thread` skills, `.claude/commands/work-loop-v2.md`, `dispatch.sh`) for hook and legacy-state claims. The only Work Loop claim that the staging hook protects anything was `dispatch.sh` 2517–2537. `reorient` was already validator-based and needed no change. `compaction-protocol.md` had the Work Loop exception but did not name the validator or state what happens when the pointer is absent.
- Control on claim (5): `.claude/hooks/check-foreign-staging.sh` exists (46775 bytes, executable) and is registered in **no** settings layer — searched `.claude/settings.json`, the workspace `.claude/settings.json` and the user `~/.claude/settings.json`; no match in any. The premise the removal rests on is verified, not assumed.

Result: Tracer bullet 4 implemented in full. The dispatcher no longer initializes or special-cases legacy session state; the four named legacy commands gate on a shared read-only owner/validator preflight before their first write; fresh-thread handoff has an active-Work-Loop branch that reopens the bound checkout as Local carrying paths rather than state; and the active compaction guidance now makes the validator and the exact task path authoritative.

Evidence:

- **Dispatcher, failing first.** The pre-change dispatcher was extracted from HEAD `e28925e` and the suite run against it via `DISPATCH_BIN`: `pass=633 fail=6`, exit 1. It allocated marker `2026-08-16 1`, invoked the stub allocator once, appended `- Files in scope: …` to `logs/session-notes.md`, wrote `logs/.session-marker`, printed an `identity:` line, and filtered `logs/session-notes.md` out of partial-effect accounting. Post-change the same suite is `pass=639 fail=0`, exit 0. The two new cases (48, 49) are the whole of that delta; the pre-existing 632 passed identically before and after, which is why they could not stand as this unit's evidence.
- **Dispatcher, no legacy path changed.** Case 48 runs a full hop in a sandbox that deliberately **carries** an executable `prime-session-entry.sh` — the dangerous shape, since the old code skipped its init only when the allocator was absent. After the hop: the allocator was never invoked, `logs/session-notes.md` is byte-identical, no `logs/.session-marker` exists, and the run log carries no `identity:` line. Case 49 is the complement: an uncommitted `session-notes.md` inside an explicit allowlist is now **reported** as a partial effect rather than hidden.
- **The shared command rule.** `logs/scripts/work-loop-session-preflight.sh` delegates to `work-loop-owner.sh` and `work-loop-state.sh` and parses no lifecycle itself. Discriminating fixtures, all asserting a read-only fingerprint of `logs/work-loop/` before and after: `ACTIVE_CLAUDE` → exit 3, route `/work-loop-v2 {task}`; `ACTIVE_CODEX` → exit 3, route names Codex; `BLOCKED_OPERATOR` → exit 3, declaration **retained**, route sends the operator to `## Blocker`, reason says "stopped, not finished"; no declaration → exit 0, behaviour unchanged, nothing created; `CLOSED` under a surviving declaration → exit 0 and the stale declaration is **left in place**, never cleared from a legacy command; retired two-field `.owner` → exit 4; declaration with no record → exit 4; illegal `active`/`operator` pair → exit 4 attributed to the validator; declaration with the validator missing → exit 4 (the asymmetry against the no-declaration case is deliberate and asserted); outside a Git repository → exit 0.
- **The four commands, mechanically.** Rather than a lifecycle-by-command cross-product, one check per command asserts the preflight call is present and that its line number precedes the file's first-write marker: `/prime` above `prime-sync.sh`, `/session-start` above Step 0, `/session-plan` above Step 0, `/wrap-session` above the Step 0 lockfile touch.
- **Handoff.** Case 15 (active task) returns STOP naming the exact bound task, creates no second record, and mutates nothing — so the skill takes the Local branch and can cite the record's path. Case 16 (non-Work-Loop checkout) returns PROCEED, so the generic worktree default applies untouched; a separate assertion confirms `startingState: { type: "working-tree" }` still exists in the skill.
- **Conflicting summary.** Case 17 uses a record whose `## Latest result` states in prose that the task is complete, closed, reduced and safe to start a new session over — under `active`/`claude` frontmatter. The preflight still returns STOP with the exact task route. Classification comes from the validator, not from the part a summary would echo.
- **Bounded hook scan.** Case 14 asserts that every active-surface mention of `check-foreign-staging` is accompanied by an explicit denial that it guards anything, that `init_session_identity` no longer exists, and — as a control — that the hook is registered in no settings layer. An earlier keyword-based version of this check fired on the retirement note itself and was replaced: a denial and an assertion share their vocabulary.
- **Suite counts, all exit 0.** Directly changed by this unit: dispatcher `639/0` (was `632/0`; pre-change against the new cases `633/6`, exit 1), new preflight harness `60/0`. Canonical regression: state `96/0`, owner `103/0`. Part B's falsifiability was measured by pointing `REPO_ROOT` at a tree built with `git archive HEAD`: `12` failures pre-change, `0` after — and the two assertions that pass in both runs are the controls for what the change must **not** break.

Commit: one coherent slice, `f3eec25d`, exactly these 11 paths — `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `.../dispatch.test.sh`, `logs/scripts/work-loop-session-preflight.sh` (new), `logs/scripts/work-loop-session-preflight.test.sh` (new), `.claude/commands/prime.md`, `.claude/commands/session-start.md`, `.claude/commands/session-plan.md`, `.claude/commands/wrap-session.md`, `.agents/skills/handoff-thread/SKILL.md`, `docs/compaction-protocol.md`, and this record. No excluded subsystem is touched: no lifecycle-validator, owner-helper or lease change; no hook wiring; no legacy session redesign; no deployment or packaging. `logs/friction-log.md` is modified in the working tree by a hook and is **not** in the commit.

Admissions remain paused. The legacy session system is unchanged and still works for non-Work-Loop sessions — the preflight returns PROCEED and alters nothing whenever no valid open Work Loop task owns the checkout. Nothing was deployed, merged, pushed or landed. Tracer 5 has not started.

Accepted limitations, carried forward and not newly introduced: dispatcher cases remain simulated rather than live product transport; interactive enforcement is instruction-borne while courier enforcement is exit-code-borne, and Part B is a mechanical check over instruction text — it proves the gate is present and correctly positioned, not that a model obeyed it.

Deferrals recorded, not implemented:

1. `dispatch.sh` retains three comment-only mentions of the legacy paths (lines 1948, 1951, 2511) inside the RETIRED block and the `allowlisted_dirty()` note. They are documentation of why the coupling went away and carry no live reference; removing them would delete the reasoning that prevents its reintroduction. Flagged because a purely string-based reading of the plan's verification bullet would count them.
2. `logs/innovation-registry.md` gained an auto-`detected` row for `session-start.md` from a hook reacting to this unit's edit. Outside Tracer 4; left uncommitted for the ordinary innovation-triage path.
3. `/prime`'s Step 0 sync is a repository write (`--rebase --autostash`) that precedes its session-state writes. The preflight was placed above it for that reason, but the general question of whether orientation should pull before establishing ownership is broader than this unit.

## Blocker

None.

## Next action

Codex: assess Tracer bullet 4. The load-bearing judgments are whether the preflight's fail-closed asymmetry is right (absent declaration proceeds, absent validator under a declaration stops), whether a mechanical instruction check is proportionate evidence for the four command gates given interactive enforcement is instruction-borne, and whether the three recorded deferrals are correctly deferred rather than in scope. Then close, continue to Tracer bullet 5, or correct once.
