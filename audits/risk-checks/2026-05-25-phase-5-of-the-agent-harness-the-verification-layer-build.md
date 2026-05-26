# Risk Check — 2026-05-25

## Change

Proposed structural change: Phase 5 of the Agent Harness — the Verification Layer build.

**What changes:**
1. Create new skill `.claude/skills/unit-verifier/SKILL.md` — governor-inline verification skill called by the session-governor; implements three depth modes (count-only / spot-check / full), 3–4 claim spot-checks against the filesystem, forecast calibration tracking, and emits `verification_result` events to `session-log.json`. Declared `model: sonnet`.
2. Edit `.claude/skills/session-governor/SKILL.md` at two stub locations:
   - Step 9 (`PHASE-5 REPLACE:`) — swap the trivial `test -f` verification function for an invocation of `unit-verifier`. Same gate point (before `in_progress → verified` state transition), same event contract (`verification_result`).
   - Steps 11–13 (`STUB [PHASE-5]:`) — fill step 11 (first-occurrence correctable re-invoke path). Re-stub steps 12–13 (second-occurrence hardening + uncorrectable handling) for Phase 6.
   - Update the Stub Marker Index (line ~53 + line ~639) to reflect what's now filled.
3. Edit existing `.claude/hooks/subagent-stop.sh` (Phase 1 stub at `exit 0`) — implement lightweight shell checks: read active unit's `outputs` from `current-state.json`, run `test -f` + `wc -w` on each, append `verification_result` event to `session-log.json`. Stays command type (recursion guard).
4. Register `SubagentStop` in `.claude/settings.json` — currently absent. Hook type: `command` (NEVER `agent` — hard rule, recursion guard).
5. Update `harness/prep/harness-roadmap.md` — mark Phase 5 ✅; confirm `Stop`-hook veto stays in Build Follow-Ups, not Phase 5 scope.

**Why:** Phase 5 of the harness build per the project plan v3 (operator-signed-off 2026-05-21). Enforces DP-2 ("Verify, don't trust") — the governor cannot advance a unit to `verified` until the filesystem confirms the sub-agent's claims. This is the reliability lock-in for autonomous sessions; without it the governor trusts sub-agent self-reports, which the spec calls out as the load-bearing failure mode.

**Why now:** Phase 4 (Session Reporter v1) was completed 2026-05-22 (commits `88c84b2`, `266cfd1`, `5dec307`). Phase 5 is the next sequential phase per the roadmap; Phase 6 (Failure Mode Detector) explicitly depends on verification output as its defect signal.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/unit-verifier/SKILL.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/subagent-stop.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/prep/harness-roadmap.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/logs/session-plan.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The Phase 5 build is well-scoped against an approved project plan and inside an already-permissive settings envelope, but it introduces a `SubagentStop` hook that auto-fires in every non-harness session and a skill-name divergence from the load-list in `harness-rules.md` — both are concrete mitigations the operator must apply during the change.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The new `unit-verifier` skill is governor-invoked, not auto-loaded — it is pay-as-used per harness work unit, not per turn. Evidence: `session-plan.md:17,57` ("Governor-inline `unit-verifier` skill. Called by the governor"). No `@import` is added to any always-loaded file; workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` are untouched by the change as described.
- The governor SKILL.md edit (step 9 + steps 11–13) does not add an always-loaded path. The skill loads only when invoked, once per harness session. Evidence: `session-governor/SKILL.md:8` ("Run once per harness session, after mandate-parser has written `mandate.json`").
- **The `SubagentStop` hook is the cost driver and the reason this dimension is not Low.** Once registered in `.claude/settings.json` `hooks.SubagentStop`, the hook fires on EVERY sub-agent stop in EVERY session — not only harness sessions. The hook script reads `harness/session/current-state.json` and appends `verification_result` to `harness/session/session-log.json`. In a non-harness session those files either don't exist or belong to a prior unrelated harness run, so the hook will either silently no-op (best case) or pollute stale harness state (worst case). Each fire spends a small but non-zero token slice (hook output streamed to context per the existing `PreCompact`/`PostCompact` pattern at `settings.json:51–74`). The current hook stub is `exit 0` (`subagent-stop.sh:6`) and is NOT registered — Phase 5 both registers and activates it.
- The `unit-verifier` skill spot-checks (3–4 grep verifications per unit) run per work unit during a harness session — this is bounded per-session cost, not per-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new `allow` / `ask` / `deny` entries are described in the change. The settings.json edit named in the change (item 4) is a `hooks.SubagentStop` registration, not a permissions edit.
- The shell operations the new hook will perform (`test -f`, `wc -w`, `grep`, file appends inside the repo) are within the existing envelope: `settings.json:17` already grants `Bash(*)`; `settings.json:21–22` already grants `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)`. The deny list at `settings.json:27–33` (Bash `rm -rf`, `sudo`, `git reset --hard`, `git checkout`, `git push`) is not narrowed.
- Hook registration adds a new auto-firing trigger (a capability widening in a literal sense — code now executes that previously didn't), but the executed shell commands themselves are pre-authorized. Categorized as Low for the permissions surface specifically; the auto-firing concern is captured under Hidden Coupling (Dim 5).

### Dimension 3: Blast Radius
**Risk:** Medium

- **Files touched directly: 5.** New: `.claude/skills/unit-verifier/SKILL.md`. Edited: `.claude/skills/session-governor/SKILL.md` (two stub locations + Stub Marker Index), `.claude/hooks/subagent-stop.sh`, `.claude/settings.json`, `harness/prep/harness-roadmap.md`.
- **Callers of `session-governor` (the most heavily-referenced edited file).** `grep -rn "session-governor" .claude/ ai-resources/ harness/` returns 17 hits across 9 files. Live (non-historical) callers: 4 — `.claude/references/harness-rules.md:7` (load-list registration), `.claude/skills/mandate-parser/SKILL.md:29` (handoff to governor), `.claude/skills/session-reporter/SKILL.md:7` (governor triggers reporter), `.claude/commands/session-report.md:9` (governor triggers reporter). The remaining 5 are historical risk-check audits in `ai-resources/audits/risk-checks/` — records, not callers.
- **Callers of `subagent-stop.sh`.** Currently zero (it is a Phase 1 stub never registered in `settings.json`). After registration, the live caller is the Claude Code runtime hook dispatcher.
- **`verification_result` event payload contract — backwards-compatible.** The session-reporter reads `verification_result` events at `.claude/skills/session-reporter/SKILL.md:92,96–99`: it special-cases `passed: false` and lists `mode: "stub-trivial"` honestly. Phase 5 changes the `mode` value (`"count-only" | "spot-check" | "full"` per `session-plan.md:22–24`) and adds a `checks_run` field per WU2 spec (`session-plan.md:57`). The reporter's logic at line 96–99 lists whatever `mode` string it finds — the rename is backwards-compatible. No caller code change required.
- **Schema authority.** `harness/schemas/session-log-schema.md:24` defines `verification_result` as an event type with no payload schema specified — Phase 5's payload additions (`mode`, `checks_run`) are within the schema's documented flexibility. No schema file is edited by Phase 5.
- **Governor SKILL.md stub markers replaced cleanly.** `grep "PHASE-5 REPLACE:"` currently returns 2 hits in the governor SKILL.md (line 56 in marker legend, line 249 in step 9 body); `grep "STUB \[PHASE-5\]"` returns 4 hits (line 53 legend, line 260 step 11–13 body, line 639 index, plus line 54). Phase 5 replaces the body occurrences and updates the legend/index entries — all locations are pre-named in the change description.
- **Roadmap edit is single-purpose** (mark Phase 5 ✅; confirm `Stop`-hook veto deferral). The roadmap is documentation, not a caller.

### Dimension 4: Reversibility
**Risk:** Medium

- The new `unit-verifier/SKILL.md` is a single new file in a new directory — `git revert` removes it cleanly.
- The `settings.json` `SubagentStop` registration reverts cleanly with `git revert` (single-JSON edit, no cached operator state because the hook didn't exist before).
- **Governor SKILL.md edit is in-place replacement, not stub-fill.** The `PHASE-5 REPLACE:` block at step 9 is "a real code path (not a stub) that Phase 5 will swap for richer logic" (`session-governor/SKILL.md:56`). Reverting Phase 5 restores the trivial `test -f` verification — that path still works, so revert is functionally clean. Multi-step nature comes from also having to revert step 11 fill and the Stub Marker Index updates; all are in the same file, so a single git revert handles it.
- **`subagent-stop.sh` reverts cleanly** — single-file edit on a 6-line stub. `git revert` restores `exit 0`.
- **Append-only log mutations carry forward (the standard harness reversibility wart).** Each harness-session run after Phase 5 lands appends real `verification_result` payloads to `harness/session/session-log.json` and the per-session reports under `harness/reports/`. A `git revert` of the Phase 5 code change does not roll back log entries already accumulated in any subsequent sessions. This is the same reversibility characteristic flagged in the prior Checkpoint B risk-check (`ai-resources/audits/risk-checks/2026-05-21-checkpoint-b-...md:58`) — known, not novel.
- **Cross-session side-effect from hook registration.** Once `SubagentStop` is registered in `settings.json`, it auto-fires on every sub-agent stop in every workspace session until unregistered. A git revert of `settings.json` unregisters it, but any session opened in the meantime will have triggered the hook. Not a state mutation (the hook writes only to harness log files), so revert is recoverable but multi-step: revert the change AND clean stale `verification_result` entries that leaked into non-harness session log files (if any). Medium, not High, because cleanup is one targeted grep-and-trim.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Skill-name divergence from the harness-rules load-list.** `.claude/references/harness-rules.md:9` registers `.claude/skills/verification-playbook/` as the Phase 5 skill. The CHANGE_DESCRIPTION names the new skill `.claude/skills/unit-verifier/`. The two project-plan files (`projects/project-planning/Project Plans/agent-harness/tech-spec-v1.md:62,277,1011` and `tech-spec-v2.md:64,279,1014`) also use `verification-playbook`. The preflight report (`projects/project-planning/Project Plans/agent-harness/harness-preflight-report.md:97`) and the April session-notes archive (`logs/session-notes-archive-2026-04.md:203`) both use `verification-playbook`. **Net result:** if Phase 5 lands as described, `harness-rules.md:9` will point to a path that does not exist, and the canonical load-list will be silently wrong. Either the new skill must be named `verification-playbook` (to honor the load-list), or `harness-rules.md:9` and the tech-spec references must be updated in the same change. CHANGE_DESCRIPTION does not name this update.
- **`SubagentStop` auto-fires in every session, including non-harness sessions.** The hook script (per item 3) reads `harness/session/current-state.json` and appends to `harness/session/session-log.json`. In a non-harness session, those files may not exist, or may belong to a stale prior harness run. The hook will either silently no-op (best case if it guards on file existence) or write `verification_result` events into stale harness state (worst case). No file-existence guard is named in the change. This is the SubagentStop analogue of the Indicator-2 false-fire surfaced in the Checkpoint B risk-check (`ai-resources/audits/risk-checks/2026-05-21-checkpoint-b-...md:66`) — a hook keyed on harness state that fires in non-harness contexts.
- **`session-reporter` special-cases the `"stub-trivial"` literal.** `.claude/skills/session-reporter/SKILL.md:96–98` says: "the governor's verification is the trivial `test -f` existence check, `mode: \"stub-trivial\"` — report it honestly as that, do not overstate." After Phase 5, `mode` becomes `"count-only" | "spot-check" | "full"` and the literal `"stub-trivial"` never appears again. The reporter logic still works (it lists whatever mode it sees), but the documented "report it honestly as stub-trivial" guidance becomes obsolete prose. Not a functional break — but the session-reporter SKILL.md should be updated to reflect post-Phase-5 modes, and the change description does not name this update. Documentation drift, not behavioral coupling.
- **Recursion-guard discipline is load-bearing and named in the change.** Item 4 says "Hook type: `command` (NEVER `agent` — hard rule, recursion guard)." Evidence: `harness-rules.md:39` ("`SubagentStop` hooks must be command or prompt type only — never agent type"), `project-plan-v3.md:174` ("Verify that `SubagentStop` supports command and prompt hook types. This is load-bearing — the recursion guard depends on it"), `project-plan-v3.md:414` ("Grep the hook config and the setup doc for `agent` as a `SubagentStop` hook type; there must be zero matches"). The change description honors this discipline correctly — flagged here as a real coupling that's been properly addressed, not as a defect.
- **Two writers to `session-log.json` for the `verification_result` event type.** After Phase 5: the `SubagentStop` hook (lightweight shell checks) appends `verification_result` events, AND the governor (via `unit-verifier`) appends `verification_result` events. Both fire around the same gate point (sub-agent stop → governor verification → state transition). The session-reporter consumes both indistinguishably (`session-reporter/SKILL.md:92,96`). Two writers to the same event type, fired close in time, with no `source` discriminator in the event payload — readers cannot tell hook-emitted from skill-emitted entries apart. CHANGE_DESCRIPTION does not name a discriminator field. Existing event payload examples (`session-governor/SKILL.md:251` — `{ passed: true, mode: "stub-trivial" }`) carry no `source` field; nothing in `session-log-schema.md` requires one.

### Verdict aggregation

Two Medium (Usage Cost, Blast Radius, Reversibility — three actually) + one High (Hidden Coupling) + one Low (Permissions). The High dimension has identifiable mitigations the operator can apply during the change — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.

## Mitigations

- **Dimension 5 (skill-name divergence):** EITHER name the new skill `verification-playbook` to match `harness-rules.md:9` and the two tech-spec files (preserves the load-list contract with zero downstream edits), OR update `harness-rules.md:9` to `.claude/skills/unit-verifier/` in the same commit as WU1, and add an inline note in `harness-roadmap.md` explaining the rename. Do NOT land WU1 with the load-list pointing at a non-existent skill.
- **Dimension 5 (hook auto-fires in non-harness sessions):** add an explicit existence guard at the top of `subagent-stop.sh`: `[ -f "$CLAUDE_PROJECT_DIR/harness/session/current-state.json" ] || exit 0`. This scopes the hook's real work to active harness sessions only, mirroring the harness-entry-trigger discipline already applied to `session-start.sh` (per `harness-roadmap.md:32` Phase 2 completion note — "crash detection engages only on real harness sessions, not on every workspace session"). Without this guard, the hook either no-ops noisily or writes into stale harness state on every non-harness sub-agent stop.
- **Dimension 5 (two writers to `verification_result`):** add a `source` field to the `verification_result` payload — `"hook"` for `subagent-stop.sh` emissions, `"skill"` for `unit-verifier` emissions. Allows the session-reporter and any future failure-mode detector (Phase 6) to disambiguate hook vs. skill checks. Document the field in the `unit-verifier` SKILL.md and in the hook script comment header; no schema file edit needed (the schema does not constrain payloads).
- **Dimension 1 (usage cost from always-firing hook):** the guard mitigation above also addresses the per-non-harness-session token cost — when the hook exits at the guard, no output is appended to context. Combined with the guard, this dimension effectively drops to Low.
- **Dimension 3 (session-reporter prose drift, optional):** update `.claude/skills/session-reporter/SKILL.md:96–98` to list the Phase 5 modes (`count-only | spot-check | full`) rather than the now-obsolete `stub-trivial`. Documentation hygiene, not a behavioral blocker.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). The `unit-verifier/SKILL.md` is tagged "not yet present" and was therefore not read; its risk contribution is evaluated against the intent described in CHANGE_DESCRIPTION and the inlined Phase 5 spec in `harness/logs/session-plan.md`. No training-data fallback was used.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Function B — Pre-change Advisory: Phase 5 Verification Layer Build

## Routing Position

Placement is correct. The change lands in workspace-root `.claude/` (skills, hooks, settings.json), which is the right tier for harness components per DR-1 / DR-3 (`principles.md § DR-1`, `principles.md § DR-3`) — the harness is a single-project concern that is not reusable across projects, so it is not a candidate for `ai-resources/`. Existing pattern (session-governor, session-reporter, mandate-parser, precompact.sh, postcompact.sh, subagent-stop.sh) confirms this is the established harness home. No routing dispute.

Worth naming explicitly: the harness is described-in-scope but governed-separately per `system-doc.md § 1.1` and `principles.md § 1`. That means the Phase 1 principles do not bind harness *internals* — they bind the workspace surface the harness touches (settings.json, hooks, the workspace .claude/ tree). Mitigations below are sized against that surface, not against the harness state machine itself.

## Architectural Commentary

**We concur with the PROCEED-WITH-CAUTION verdict.** The dimension profile (Hidden Coupling: High; Blast Radius / Reversibility / Usage Cost: Medium) is consistent with what the proposed change actually does — it registers a SubagentStop hook that fires in every workspace session and introduces a second writer to an existing event-type contract. Those are textbook hidden-coupling and blast-radius signals.

The four mitigations are the right path. Specifically:

1. **Skill-name divergence (mitigation 1) is a hard fix, not a stylistic preference.** `harness-rules.md:9` is a two-end contract — the harness load-list literal `verification-playbook` is matched by the operator's `Load @.claude/references/harness-rules.md` instruction. Shipping a skill named `unit-verifier` without updating the contract violates `risk-topology.md § 5 Signals that elevate a change to structural risk` ("Change modifies a string literal matched by another component (two-end contract)") and `principles.md § OP-3` (loud failure over silent continuation — a divergent name is silent drift). Either side of the fix is acceptable; both-sides-in-one-commit is the right shape. The risk-check report's framing is correct.

2. **File-existence guard on `subagent-stop.sh` (mitigation 2) is the right scoping mechanism.** Registering a SubagentStop hook in workspace-root `settings.json` brings the hook into every session in the workspace, including non-harness sessions (which is most sessions). `risk-topology.md § 1 Critical` calls out `settings.json` (workspace root) as load-bearing system-wide; an unscoped hook here means the hook's full body runs against the wrong context on every non-harness session. The proposed guard (`[ -f "$CLAUDE_PROJECT_DIR/harness/session/current-state.json" ] || exit 0`) reduces the hook's effective surface to harness sessions only — this is the correct scoping primitive given the workspace-wide registration.

3. **Source field on `verification_result` payloads (mitigation 3) is required, not optional.** Two writers (hook + skill) into the same event type without a discriminator is a two-end contract waiting to fail (`risk-topology.md § 5`). The session-reporter already reads `verification_result` events; future Phase 6 work explicitly depends on disambiguating hook-origin vs skill-origin verifications. Without the source field, downstream consumers must infer the writer from timing or shape, which is exactly the silent-drift class `principles.md § OP-3` and `principles.md § AP-1` prohibit. This is structural, not cosmetic.

4. **`session-reporter/SKILL.md:96–98` literal update (mitigation 4) is correctly flagged as optional but worth doing.** A stale literal in a SKILL.md is the same two-end-contract failure mode in miniature — the cost to fix in the same commit is trivial; the cost to leave is a future audit finding. Roll it in.

## Downstream Impact

- **All workspace sessions touched by the SubagentStop registration.** Per `risk-topology.md § 2 Shared infrastructure → projects (reverse map)`, workspace `settings.json` changes affect "All 7 projects." Mitigation 2 (file-existence guard) reduces the *behavioral* blast radius to harness sessions only, but the *registration* still loads on every session. This is acceptable given the guard, but is the load-bearing reason the dimension review put Blast Radius at Medium.
- **`session-reporter` event consumption.** Already reads `verification_result`; mitigation 3 (source field) is what keeps that contract stable when the second writer appears.
- **Future Phase 6 detector.** Depends on the disambiguation mitigation 3 introduces. If mitigation 3 is skipped now, Phase 6 inherits the cleanup.
- **`harness-rules.md` load-list (`harness-rules.md:9`).** This is the two-end contract on the skill-name side. Mitigation 1 closes it.

No cross-project blast-radius beyond the workspace-wide hook registration — the change does not touch `ai-resources/`, CLAUDE.md, or any shared canonical command (`risk-topology.md § 2`).

## Risks the Dimension Review Did Not Surface

Two worth naming:

**1. The change advances Phase 5 from `Stub (harness Phase 5)` to live, per `blueprint.md § 3.4 Hook Configuration`.** The blueprint currently lists `subagent-stop.sh` as `Stub (harness Phase 5)`. Filling the stub plus registering the hook moves the live hook count and shifts the workspace's hook-firing surface. `blueprint.md` is described as "Isolated file — Phase 2 W2.1 rewrites this file on scan cadence" — so it will eventually self-correct, but the roadmap update (marking Phase 5 ✅) and the blueprint hook-table update should be in the same commit boundary to avoid documented-state-vs-live-state drift. The mitigation list does not flag this. We recommend adding it as a fifth mitigation: update `blueprint.md § 3.4` to flip `subagent-stop.sh` from `Stub (harness Phase 5)` to `Active` in the same commit as the hook fill.

**2. `principles.md § DR-9` (top-3 command analysis) applies to the SubagentStop hook registration.** DR-9 requires that before applying a permission/config change derived from any audit recommendation, the operator lists the top-3 commands most affected and confirms the change does not block or degrade their normal behavior. This is a settings.json change with workspace-wide registration scope — DR-9 applies even though the hook is guarded. The risk-check report's mitigation 2 (guard) makes DR-9 a formality rather than a blocker, but the rule still requires the top-3 enumeration. Recommend explicitly listing the three commands or session-shapes most affected by a SubagentStop firing (likely: any session that spawns subagents — `/qc-pass`, `/triage`, `/repo-dd`) and confirming the file-existence guard makes them no-ops. This belongs in the commit message per `principles.md § QS-7`.

## Position

The PROCEED-WITH-CAUTION verdict is correct. The four mitigations are the right path and are sufficient if applied. We add one fifth mitigation (blueprint hook-table update in the same commit) and one process step (explicit DR-9 top-3 enumeration in the commit message). Proceed with the build once both are folded in.
