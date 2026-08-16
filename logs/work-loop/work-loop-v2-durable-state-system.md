---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 7 — Tracer bullet 5: make Work Loop deployment complete or visibly unavailable.

Named reason for the loop: this is the next ordered slice of the frozen multi-unit migration; it crosses command entry, recovery, deployment, synchronization, and template boundaries whose completeness must be independently assessed before operational proof begins.

## Brief

Unit 6 / Tracer bullet 4 is accepted at implementation commit `f3eec25d` and handback commit `f7d5adaa`: Work Loop execution and recovery no longer depend on legacy session state, while non-Work-Loop legacy sessions retain their prior path. Tracer bullet 5 is next because a checkout must not expose `/work-loop-v2` while silently lacking part of the durable recovery bundle.

**Required outcome:** A checkout exposing `/work-loop-v2` must either carry the complete five-component capability or fail early with a diagnostic naming the missing prerequisite. The components are the state validator, owner helper, Reorient skill, compact-recovery hook including the registration needed for it to fire, and the live `.owner` ignore rule; absence of the command makes the capability not applicable.

**Authority and constraints:**

- The frozen plan governs: Fixed decisions 5–7, 11, 14, and 15; Capability G; Safe ordering step 7; and Tracer bullet 5.
- The accepted validator, owner, Reorient, compact-recovery, and entry contracts govern their own semantics. Reuse them; add no fallback parser, alternate state reader, registry, or second deployment-state system.
- Preserve project-specific settings and ignore content by checking or adding the required entries, not replacing whole files. Where deployment uses copied canonical helpers, drift must be visible and the required copies byte-identical.
- Admissions remain paused. Tracer bullets 6–8, deployment to existing projects without operator selection, general template redesign, unrelated workflow synchronization, merge, push, landing, and production deployment remain outside this unit.

**Verify first:**

1. Reconfirm the exact checkout/task, HEAD `f7d5adaa`, `ACTIVE_CLAUDE`, unique repository-depth ownership, and free shared leases. Stop on ambiguity or a competing actor.
2. In `.claude/commands/sync-workflow.md`, `.claude/commands/deploy-workflow.md`, `.claude/hooks/auto-sync-shared.sh`, and the current research-workflow deployment sources, verify the frozen plan's starting claims: only owner-plus-ignore is declared today; the research template has an owner-helper copy but no validator; and generic synchronization can expose the command without the rest of the bundle.
3. In `.claude/commands/work-loop-v2.md`, verify where execution can currently begin before the complete five-component readiness contract has been established.
4. In `.codex/hooks.json`, `.codex/hooks/work-loop-reorient.sh`, `.agents/skills/reorient/SKILL.md`, and the relevant project/template settings and manifests, establish the exact deployable form and activation requirement of Reorient and compact recovery. Bound this inspection to active canonical and research-template deployment surfaces; do not inventory existing projects.

If a load-bearing premise is false, return the exact inspected surface and stop rather than widening or redesigning the unit.

**Implement the frozen tracer:**

- Make the canonical deploy/sync contract treat the five components as one capability at reporting, dry-run remediation, and readiness validation.
- Bring the relevant current deployable template/copies into that complete contract, and prevent the generic command-sync path from presenting a partial Work Loop capability as ready.
- Add early `/work-loop-v2` readiness diagnostics so a missing or mismatched prerequisite stops before task execution and names the component. A checkout without the command remains N/A.
- Preserve existing project content and generic non-Work-Loop synchronization behavior. Use the smallest existing-style focused proof surface; do not create a general deployment framework.
- Commit one coherent Tracer 5 slice including the handback. Leave hook-written `logs/friction-log.md` and `logs/innovation-registry.md` uncommitted and outside the commit.

**Proportionate evidence:**

- Show a pre-change failing case in which a Work Loop-enabled deployment is incomplete but the existing readiness/sync path does not report the full deficiency.
- Show one complete deployment fixture passing and five derived fixtures, each missing exactly one component, failing with that component named. Show a no-command fixture reporting N/A rather than broken.
- Show that a partial checkout cannot begin `/work-loop-v2`, while the complete fixture reaches the existing validator/ownership seam rather than being rejected by the new readiness check.
- Show byte identity for canonical and deployed validator/owner-helper copies wherever the chosen deployment model requires copies.
- Show sync and deploy dry-runs proposing the exact missing additions while preserving unrelated project-specific settings and `.gitignore` content; no real project is deployed.
- Report exact counts and exits for the focused proof and directly affected regression suites. Report the final commit and exact path list, demonstrating that no existing project, excluded subsystem, friction log, or innovation registry entered the commit and that this record validates as `ACTIVE_CODEX`.

**Completion condition:** Commit the bounded Tracer 5 implementation and return the evidence above in `## Latest result`, with `status: active` and `turn: codex`. State that admissions remain paused, no existing project was deployed, nothing was merged, pushed, or landed, and Tracer 6 has not started.

**Stop conditions:** Stop if the five-component boundary cannot be made exact; readiness would require a private lifecycle parser or a second state/deployment registry; project-specific settings or ignore files would have to be replaced; the generic sync path cannot avoid partial exposure without broader redesign; or required fail-capable evidence is unavailable or red.

Capability subset: baseline only — read and inspect repository state, run local tests, edit active canonical deployment/sync/entry surfaces and directly relevant template copies, and make the local coherent commit. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

## Latest result

Inspected (2026-08-16):

- Claim (1): HOLDS — checkout `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-durable-state`, branch `session/2026-08-14-durable-state`, HEAD `f7d5adaa`. `work-loop-state.sh validate` printed `ACTIVE_CLAUDE` (exit 0); `work-loop-owner.sh check --depth repo` printed `PROCEED` over the 17 registered worktrees; `logs/work-loop/.owner` holds `work-loop-v2-durable-state-system` and no other checkout declares it. No competing actor.
- Claim (2a): HOLDS — searched `.claude/commands/sync-workflow.md` for its Work Loop checks; Step 4b named exactly two, `test -x logs/scripts/work-loop-owner.sh` and `git check-ignore logs/work-loop/.owner`, and searching the whole file for `work-loop-state`, `reorient` and `codex` returned no match.
- Claim (2b): HOLDS — searched `workflows/research-workflow/` for the bundle; `logs/scripts/work-loop-owner.sh` present and `.gitignore` carries `logs/work-loop/.owner`, while `work-loop-state.sh`, `.agents/`, `.codex/` and any `skills.shared` key were all absent. The owner-helper copy was additionally the pre-Tracer-3 version (158 diff lines against canonical; it still documented and accepted the retired `{task-id} {date}` shape).
- Claim (2c): HOLDS — searched `.claude/hooks/auto-sync-shared.sh` for what limits the command sweep; `EXCLUDE_COMMANDS` (line 84) does not list `work-loop-v2`, and the research template's `commands.local` does not either, so the sweep symlinks the command into every project unconditionally. Executed against a sandbox project it symlinked 114 commands including `work-loop-v2.md` and reported `Auto-synced 114 new shared file(s)` with no other signal.
- Claim (3): HOLDS — searched `.claude/commands/work-loop-v2.md` for any readiness gate ahead of execution; the first repository action after the core resolver was Step 1's `work-loop-state.sh validate` (line 150), with `work-loop-owner.sh check` at line 172 and no earlier check of any kind.
- Claim (4): HOLDS — `.codex/hooks/work-loop-reorient.sh` is present and is registered in `.codex/hooks.json` as a `SessionStart` entry with matcher `compact`; `.agents/skills/reorient/SKILL.md` is present and tracked. Activation therefore needs both the script and that registration — a script alone never fires. Inspection was bounded to the canonical checkout and the research template; no existing project was inventoried for this record.

Result: Tracer bullet 5 is implemented. Deployment completeness is now one named capability of five components, checked by one canonical helper, at three surfaces (Work Loop entry, `/sync-workflow`, `/deploy-workflow`) plus the generic SessionStart sweep, and the research template carries the copies that make a deployed project READY.

- New `logs/scripts/work-loop-capability.sh` — read-only, five components (`state-validator`, `owner-helper`, `reorient-skill`, `compact-recovery-hook`, `owner-ignore-rule`), verdicts `READY` (0) / `NOT_APPLICABLE` (2) / `INCOMPLETE` (3) with one `missing:`/`drifted:` line per component. Optional `--canonical` adds byte comparison of the copied components. It holds no registry, reads no task record, and never repairs.
- `.claude/commands/work-loop-v2.md` — new Step 0 ahead of Admission, Step 1 and Step 1.5; `INCOMPLETE` stops before any state file is opened, and a check that cannot run stops the same way the validator and owner helper do.
- `.claude/commands/sync-workflow.md` — Step 4b now delegates all five to the helper and carries a one-remedy-per-component table; every remedy adds or appends, none replaces a project file. `.claude/commands/deploy-workflow.md` — deploys the two non-file components (manifest opt-in, hook registration) and re-checks at Step 11.
- `.claude/hooks/auto-sync-shared.sh` — after the sweep exposes the command it consults the helper and emits `WORK LOOP INCOMPLETE: ... missing or drifted on: <names>`. Fail-open and still exit 0.
- `workflows/research-workflow/` — added `logs/scripts/work-loop-state.sh` and `.codex/hooks/work-loop-reorient.sh`, refreshed the stale `work-loop-owner.sh`, all three byte-identical to canonical; manifest gained `skills.shared: ["reorient"]`. `.gitignore` and every other template file are unchanged.

Evidence:

- Pre-change failing case — a checkout built from the current template plus the command: the old two-item Step 4b reported `work-loop-owner.sh: PRESENT` and `.gitignore rule: PRESENT`, i.e. ready, while the five-component check returned `INCOMPLETE` (exit 3) naming 4 of 5 — `state-validator` missing, `owner-helper` drifted, `reorient-skill` missing, `compact-recovery-hook` missing.
- Fixtures — `logs/scripts/work-loop-capability.test.sh`, **59 passed, 0 failed** (exit 0). One complete fixture `READY`; five derived fixtures, each removing exactly one component, each `INCOMPLETE` naming that component with exactly one finding line (attribution, not just failure); an unregistered hook and a wrong-matcher registration both `INCOMPLETE`; a no-command fixture `NOT_APPLICABLE` (exit 2) with nothing reported missing; a command-only fixture `INCOMPLETE` naming all five; a symlinked command counted as exposure; byte identity `READY`, a one-line edit to the deployed owner helper `drifted: owner-helper`; a git-clean tree byte-unchanged across a run (read-only); three `BAD_USAGE` cases.
- Falsifiability — Case 0 replaces the checker with a stub that always prints `READY`; the suite asserts A2 would then have failed. Part B was **18 failures before** the wiring and **0 after**, on the same assertions.
- Entry seam — on a partial fixture Step 0 returned exit 3 naming `state-validator` and `reorient-skill`, and Steps 1 and 1.5 were never reached. On the complete fixture Step 0 returned exit 0, then `work-loop-state.sh` printed `ACTIVE_CLAUDE` and `work-loop-owner.sh --depth repo` printed `PROCEED` — the readiness check does not reject a complete checkout.
- Byte identity — `cmp -s` canonical vs template: identical for `logs/scripts/work-loop-state.sh`, `logs/scripts/work-loop-owner.sh`, `.codex/hooks/work-loop-reorient.sh`.
- Generic sweep, executed — an incomplete sandbox project produced `WORK LOOP INCOMPLETE: ... on: compact-recovery-hook owner-helper owner-ignore-rule reorient-skill state-validator` alongside the ordinary sync message; completing the bundle from the template made the warning disappear and the helper report `READY` against the template; a project not carrying the command produced no Work Loop warning and `NOT_APPLICABLE`. Hook exit 0 in every case; no real project was deployed, and unrelated symlink/drift behaviour was unchanged.
- Regression — `work-loop-capability` 59/0, `work-loop-state` 96/0, `work-loop-owner` 103/0, `work-loop-session-preflight` 60/0, `work-loop-v2-slice-1` 308/0, `work-loop-v2-core-resolver` 4/0. All exit 0, none regressed from the pre-change baselines (96/0, 103/0, 60/0, 308/0). `bash -n` clean on all changed shell.
- Accepted limitation — Part B is a mechanical check over instruction text: it proves the readiness call is present and positioned above the state and ownership reads, not that a model obeyed it. Interactive enforcement stays instruction-borne, the same limitation the ownership helper and the session preflight carry.
- Commit `{FINAL_COMMIT}` — exact paths: `.claude/commands/deploy-workflow.md`, `.claude/commands/sync-workflow.md`, `.claude/commands/work-loop-v2.md`, `.claude/hooks/auto-sync-shared.sh`, `logs/scripts/work-loop-capability.sh`, `logs/scripts/work-loop-capability.test.sh`, `logs/work-loop/work-loop-v2-durable-state-system.md`, `workflows/research-workflow/.claude/shared-manifest.json`, `workflows/research-workflow/.codex/hooks/work-loop-reorient.sh`, `workflows/research-workflow/logs/scripts/work-loop-owner.sh`, `workflows/research-workflow/logs/scripts/work-loop-state.sh`. No existing project, no excluded subsystem, and neither `logs/friction-log.md` nor `logs/innovation-registry.md` entered it; both remain uncommitted. This record validates `ACTIVE_CODEX`.

Deferrals — recorded, not done:

1. Existing projects in the workspace already carry `/work-loop-v2` from the sweep without the complete bundle. Remediating them is deploying to existing projects, which Tracer 5's scope boundary excludes without operator selection. The sweep's new warning now makes each one visible at its next session start, which is the intended route.
2. `.codex/hooks.json` in this repository registers every hook by an absolute path into the main `ai-resources` checkout rather than the running worktree, so a worktree's Codex hooks execute the main checkout's scripts. Noticed while establishing the compact hook's activation requirement; it is a pre-existing property of the whole hook file, not of the Work Loop component, and changing it would touch five unrelated hooks.
3. `/sync-workflow` Step 7 still applies approved changes by copying canonical files over project ones. The three new remedies that must append rather than replace are stated in Step 4b, but Step 7's generic language was left alone — rewriting it is broader than this unit.

Admissions remain paused. No existing project was deployed, nothing was merged, pushed or landed, and Tracer bullet 6 has not started.

## Blocker

None.

## Next action

Codex: assess Tracer bullet 5 against the frozen plan — the five-component boundary, the three checking surfaces plus the sweep, the template copies, and whether the fixture evidence and the stated instruction-borne limitation are proportionate. Then close, continue to Tracer bullet 6, correct once, or stop.
