# Risk Check — 2026-05-25

## Change

End-time risk-check on the executed Phase 5 changes (already committed for WU1 + WU2; WU3 staged-but-uncommitted). Reviewing the full Phase 5 change set as it actually landed, mitigations folded in.

**Actual change set:**

WU1 (committed `578be08`): New skill `.claude/skills/verification-playbook/SKILL.md` — three depth modes, forecast calibration, recursion-guarded, emits `verification_result` with `payload.source: "skill"` using the canonical envelope. M1 (canonical name) and M3 (skill side of source field) landed.

WU2 (committed `dde1078`): Edited `.claude/skills/session-governor/SKILL.md` — Phase B step 9 now invokes `verification-playbook` with the resolved depth, structured return routes steps 10–13. Step 11 (first-occurrence re-invoke) is real with `active_unit.retry_count` (cap=1, matching v3 spec's "first-occurrence path"). Step 12 retagged `STUB [PHASE-6/7]:`. Marker Family Legend + Stub Marker Index updated — no live PHASE-5 markers remain. Edited `.claude/skills/session-reporter/SKILL.md` Verified-field instructions (M4) for Phase 5 mode set + `payload.source` discriminator, kept legacy `stub-trivial` compatibility.

WU3 (staged, this commit): Filled `.claude/hooks/subagent-stop.sh` Phase 1 stub — M2 file-existence guard at top, reads `current-state.json`, only emits when `active_unit.state == "in_progress"`, command-type only (recursion guard), emits `verification_result` with `payload.source: "hook"` using canonical envelope, atomic jq→tmp→mv write pattern mirroring precompact.sh. Registered `SubagentStop` block in `.claude/settings.json` as command type (confirmed zero `agent`-type matches). M3 schema half: documented the two-writer contract and `payload.source` discriminator in `harness/schemas/session-log-schema.md` `verification_result` entry. M5: flipped `blueprint.md § 3.4` hook table row `subagent-stop.sh` from `Stub (harness Phase 5)` to `Active`. Bonus: fixed a path typo (`harness/state/` → `harness/session/`) in verification-playbook SKILL.md.

**Dry-run results all passed:** bash syntax OK; recursion-guard grep returns 0 `agent`-type matches; positive-path dry-run emits well-formed event with `payload.source: "hook"`, mode count-only, passed true; M2 guard exits 0 when current-state.json absent; in-place hook against current `active_unit.state: "committed"` correctly exits without writing.

**Mitigations applied:** M1 (skill name canonical) ✓; M2 (hook M2 guard) ✓; M3 (source discriminator both sides + schema) ✓; M4 (reporter literal updated) ✓; M5 (blueprint flipped) ✓; M6 (DR-9 enumeration goes in commit message — drafted but not yet committed).

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/verification-playbook/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-reporter/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/subagent-stop.sh` — exists (filled in WU3)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/session-log-schema.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/blueprint/blueprint.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/references/harness-rules.md` — exists (line 9 canonical name contract)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/logs/session-plan.md` — exists (M1–M6 mitigation table reference)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-25-phase-5-of-the-agent-harness-the-verification-layer-build.md` — exists (the plan-time report this end-time check follows up on; PROCEED-WITH-CAUTION + 4 mitigations + 2 system-owner additions)

## Verdict

GO

**Summary:** All six binding mitigations from the plan-time risk-check landed as specified and dry-run verification confirms the recursion guard, M2 file-existence guard, and `payload.source` discriminator all behave correctly — the High Hidden-Coupling and three Medium dimensions from plan-time are demonstrably reduced to Low/Low-Medium by inspection of the actual code.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The `verification-playbook` skill is governor-invoked, not always-loaded. Evidence: `verification-playbook/SKILL.md:1-13` frontmatter — no auto-load trigger; SKILL.md description binds invocation to "Called by the session-governor at Phase B step 9". Pay-as-used per harness work unit, not per turn.
- `SubagentStop` hook fires on every sub-agent stop workspace-wide (`settings.json:75-86`), but the M2 guard at `subagent-stop.sh:33` (`[ -f "$STATE_FILE" ] || exit 0`) makes every non-harness session a sub-second early-exit. Dry-run confirms: when `current-state.json` is absent the hook exits 0 with no output. The token slice charged per non-harness sub-agent stop reduces to the wrapper invocation itself.
- The secondary guard at `subagent-stop.sh:51` (`[ "$ACTIVE_UNIT_STATE" != "in_progress" ] && exit 0`) further narrows the hook's real emission surface to harness sessions whose governor is actively mid-verification — `/qc-pass`, `/triage`, etc. that spawn sub-agents during a harness session also no-op cleanly.
- Plan-time Medium → end-time Low. The plan-time risk-check (`2026-05-25-phase-5-...md:92`) already flagged that the M2 guard would effectively drop this dimension to Low; the code confirms it.
- No `@import` added to any always-loaded file. Workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` untouched by Phase 5.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries added or modified. `settings.json:3-25` allow list and `:27-33` deny list both unchanged versus pre-Phase-5; the only `settings.json` diff is the new `SubagentStop` hook registration at `:75-86`.
- The hook's shell operations (`jq`, `mktemp`, `mv`, `rm`, `test -f`, `date`) are within the existing `Bash(*)` allow at `settings.json:17`; the file writes (`mv` of tmp to `harness/session/session-log.json`) are within the existing `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` allow at `settings.json:22`.
- Hook type is `command` (`settings.json:79`), not `agent` — recursion guard honored per `harness-rules.md:39`. Grep for `"agent"` in `settings.json` returns zero matches (verified).

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly (WU1 + WU2 + WU3 combined): 7. New: `.claude/skills/verification-playbook/SKILL.md`. Edited: `.claude/skills/session-governor/SKILL.md`, `.claude/skills/session-reporter/SKILL.md`, `.claude/hooks/subagent-stop.sh`, `.claude/settings.json`, `harness/schemas/session-log-schema.md`, `projects/repo-documentation/vault/blueprint/blueprint.md`.
- Callers of `verification-playbook`: 1 live caller (`session-governor/SKILL.md:246` step 9 invocation) + 1 load-list registration (`harness-rules.md:9`) + 2 cross-reference docs (`session-reporter/SKILL.md:97`, `session-log-schema.md:26,33`). All four are consistent with the canonical name. `grep` for the skill name returns 28 hits across 6 files; all non-historical hits use `verification-playbook` (M1 honored end-to-end).
- Callers of `subagent-stop.sh`: 1 live caller (the Claude Code runtime hook dispatcher, via `settings.json:80`). The hook does not call out to any other harness component — it only appends to `session-log.json` via atomic file write.
- `verification_result` event contract: backwards-compatible. Schema at `session-log-schema.md:24-34` documents the two-writer contract with `payload.source` discriminator and explicitly preserves legacy `stub-trivial` compatibility ("readers should treat the absence of `payload.source` as legacy-stub-trivial"). Existing log entries at `harness/session/session-log.json:58,163,280` (pre-Phase-5 trivial entries) remain readable.
- Governor stub markers cleaned: 0 live `PHASE-5 REPLACE:` or `STUB [PHASE-5]:` tokens remain in `session-governor/SKILL.md` — both legacy markers retained only as struck-through prose at lines 55-56 for historical greppability, with the body fully filled. The step-12 second-occurrence path is correctly retagged `STUB [PHASE-6/7]:` (verified at `session-governor/SKILL.md:275`).

### Dimension 4: Reversibility
**Risk:** Medium

- `git revert 578be08` cleanly removes the new `verification-playbook/SKILL.md` (single new file in a new directory).
- `git revert dde1078` cleanly restores the governor + reporter to their pre-Phase-5 form (in-place edits, no sibling files generated).
- WU3 (when committed) is a single multi-file commit: revert restores the `subagent-stop.sh` stub, removes the `SubagentStop` hook block from `settings.json`, removes the M3 schema documentation, and restores the blueprint hook-table row. All seven files in WU3 are tracked by git and have no out-of-tree state.
- **Standard harness reversibility wart, unchanged from plan-time:** once Phase 5 lands, every subsequent harness session appends real `verification_result` rows to `harness/session/session-log.json` and writes per-session reports under `harness/reports/`. A `git revert` of Phase 5 does not roll back log/report entries already accumulated. This is the same characteristic flagged by the prior Checkpoint B risk-check; known, not novel. Reason this dimension stays Medium, not Low.
- The cross-session hook-registration concern from plan-time is reduced: with the M2 guard verified working (dry-run confirmed), stale `verification_result` entries in non-harness session logs are not possible — the hook exits before any append.

### Dimension 5: Hidden Coupling
**Risk:** Low

- **M1 (skill-name canonical):** verified. `harness-rules.md:9` lists `.claude/skills/verification-playbook/` (Phase 5); the actual skill at `.claude/skills/verification-playbook/SKILL.md:2` declares `name: verification-playbook`. Two-end contract honored. No reference to the rejected `unit-verifier` name remains in any live file (only in the plan-time risk-check archive).
- **M2 (hook auto-fire scoping):** verified. `subagent-stop.sh:33` carries the file-existence guard verbatim from the plan-time mitigation text. Dry-run confirms exit-0 behavior when `current-state.json` is absent. Mirrors the harness-entry-trigger discipline already applied to `session-start.sh`.
- **M3 (two-writer `payload.source` discriminator):** verified on both sides and in the schema.
  - Skill side: `verification-playbook/SKILL.md:152` event payload includes `"source": "skill"`; documented at `:180-182` as required.
  - Hook side: `subagent-stop.sh:66` emits `source: "hook"`.
  - Schema: `session-log-schema.md:24-34` documents the two-writer contract, names both writers, prescribes the `payload.source` discriminator with `"hook"` vs `"skill"` as the only valid values, and preserves backward compat for pre-Phase-5 entries with no `source` field.
- **Recursion-guard discipline:** verified. Hook is registered as `"type": "command"` at `settings.json:79`. `grep` for `"agent"` in `settings.json` returns zero matches. `subagent-stop.sh:22-23` comment header explicitly documents the constraint.
- **Verification-playbook recursion guard:** the skill explicitly states (`verification-playbook/SKILL.md:45-54`) that it "must therefore use only file reads and local computation — no `Agent` tool calls". Documented contract, not just an assumption.
- **Active-state secondary guard (beyond plan-time scope):** `subagent-stop.sh:47-53` adds a second guard — the hook only emits when `active_unit.state == "in_progress"`. This means `/qc-pass`/`/triage` sub-agents spawned during a harness session (when the active unit is at `committed` or other states) also no-op cleanly. Not in the plan-time mitigation set; an end-time improvement that further reduces hidden-coupling risk.
- **Plan-time High → end-time Low.** Every named hidden-coupling concern from the plan-time report has a concrete code-level mitigation that the actual files show; none of the original High signals remain.

## Mitigations

(Omitted — verdict is GO; all six binding mitigations from the plan-time risk-check already landed in the code under review. M6 — DR-9 top-3 enumeration in the WU3 commit message — is the only remaining mitigation action and is internal to the commit creation itself, not a structural risk on the change set.)

## Recommended redesign

(Omitted — verdict is GO.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from the seven referenced files, grep counts across `.claude/`, `harness/`, and `ai-resources/`, dry-run results quoted from the CHANGE_DESCRIPTION, and back-references to the plan-time risk-check at `ai-resources/audits/risk-checks/2026-05-25-phase-5-of-the-agent-harness-the-verification-layer-build.md`. No `not yet present` files were referenced; no INCOMPLETE dimensions. No training-data fallback was used on fetch/read failures.
