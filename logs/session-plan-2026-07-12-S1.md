# Session Plan — 2026-07-12

## Intent
Implement W3.2 roadmap item R3 (durable run-manifest + slim wrap note) per its SO-cleared packet — start-stub at mandate confirmation on every session-entry path, running `files_changed` updates, close-and-schema-validate at wrap with a loud abort on mismatch, and the wrap note cut from 11 sections to 5.

## Model
opus — match (deciding: schema design + core-command rewiring under a two-end contract with future consumers).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md` — the packet (authority for scope, gates, verification plan, rollback)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md` — R1 kernel doc; §1 run-manifest schema, §4 verification levels, §5 failure taxonomy
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — close+validate insert; wrap-note slimming
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — start-stub write at Step 3
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — start-stub write in auto-mode (Step 8c.7)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` — workspace-root mirror (independent non-symlink copy)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/foreign-session-guard.sh` — the extraction pattern to follow (single source, called by both wrap copies)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — risk-check change classes
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — marker resolution contract (the manifest is marker-scoped)

## Findings / Items to Address

1. **Start-stub is absent on every lane** (packet §3, §2.5; red-team case 6) — no durable per-session record exists at the moment state is produced, so a crashed/compacted session is unrecoverable from disk. Fix: write `logs/runs/{date}-{marker}.json` at mandate confirmation.
2. **`files_changed` must be running, not wrap-only** (packet §3; spine-schemas §1 "Load-bearing fields") — partial-edit recovery currently reads a plan file the standard lane does not reliably write. Fix: append-update the manifest at named checkpoints.
3. **Close-time validation must abort loudly** (packet §3, §8.3; spine-schemas §1 "Write discipline") — a silent pass is explicitly disallowed. Fix: schema-validate at wrap; non-zero exit + loud message on mismatch.
4. **Wrap note is 11 sections; target is 5** (packet §3, §4.3) — the retired sections' load-bearing content moves into the manifest. Current sections in `wrap-session.md` Step 4: Summary, Files Created, Files Modified, Decisions Made, Outcome, Session Value Audit, Risky actions, Session Assessment, Next Steps, Open Questions (+ the note title) = 11 blocks.
5. **Two write points, not one** — the mandate is written in two places: `/session-start` Step 3 (standard chain) and `/prime` Step 8c.7 (auto mode's inline mandate). Both must write the start-stub or auto-mode sessions stay invisible.
6. **Packet §7 flags a conscious gate decision** — R3 edits a core command and introduces shared durable state. The packet leaves `/risk-check` to the execution session's judgment. Decision: **run it** (structural class: automation with shared-state effects). Record the verdict back into packet §7.
7. **R1 prerequisite is satisfied** — `docs/spine-schemas.md` exists and is `verified` in the register, so R3 is unblocked (packet Prerequisites).

## Execution Sequence

1. **`/risk-check` (plan-time gate).** Structural class: automation with shared-state effects + core-command edits. Verify: verdict recorded; on RECONSIDER/NO-GO, stop per the mandate's `Stop if`.
2. **`/blindspot-scan` (post-plan, pre-implementation).** Fires per the narrow trigger — the plan creates net-new runnable infrastructure (a script that auto-writes shared durable state on every session). Verify: verdict surfaced; PAUSE-AND-FIX findings resolved before step 3.
3. **Write `logs/scripts/run-manifest.sh`** with four subcommands — `start` (stub), `update` (running `files_changed` + checkpoint fields), `close` (finalize), `validate` (schema check, loud non-zero abort). Follow the `foreign-session-guard.sh` pattern: one source, callable from any checkout via ancestor walk-up; writes only under `logs/runs/`. Verify: `bash -n` parses; each subcommand runs standalone.
4. **Functional test suite (verification floor: level 1 + 2, mandatory for executable surfaces per spine-schemas §4).** Exercise: start → update → close → validate on a happy path; then the **negative test** — a deliberately malformed manifest must produce a loud abort and non-zero exit, never a silent pass. Also test empty/missing-file and absent-marker states. Verify: all cases pass; negative test genuinely fails loudly.
5. **Wire `/session-start` Step 3** — start-stub write immediately after the mandate line lands. Verify: re-read the edited step; the write is unconditional on the standard chain.
6. **Wire `/prime` Step 8c.7** — same start-stub write in auto mode's inline mandate. Verify: auto-mode path writes a stub too (closes the fast/auto-lane blind spot).
7. **Wire `/wrap-session`** — insert close+validate before the commit step; slim the wrap note 11 → 5 sections. Verify: the 5 retained sections are named; retired sections' load-bearing content is confirmed present in the manifest schema (no data loss).
8. **Mirror the wrap edits into the workspace-root `wrap-session.md`** (independent non-symlink copy). Verify: grep both copies for the close+validate step and the 5-section note.
9. **Real-session end-to-end proof** — this session's own wrap writes and closes `logs/runs/2026-07-12-S1.json`. Verify: file exists, validates, carries running `files_changed`.
10. **Close the record** — R3 packet §7 gate table + §8 verification results → `verified`; remediation-register R3 row (MVP detail + Phase 0 index) → `verified`; check off the R1 and R3 threads in the mission file via `/mission`.
11. **`/qc-pass`** (independent) on the change set, then commit.

## Scope Alternatives

- **Min:** script + `/session-start` wiring + wrap close/validate; defer the wrap-note slimming (items 4, 7-partial). Leaves the packet's §3 "before/after" only half-delivered — the 11→5 cut is an explicit exit condition, so this under-delivers the mandate.
- **Recommended (this plan):** all four packet deliverables, both write points, both wrap copies, functional + negative tests, records closed. Matches the packet's §8 pass condition exactly.
- **Max:** additionally build the `logs/runs/` orphan-detection sweep and lane-classification (`fast|standard|complex`). **Rejected** — orphan detection and lane telemetry are M-D2/R4 scope (packet §10 non-goals). The manifest carries a `lane` field; populating it beyond a recorded default is out of scope until lanes exist.

## Autonomy Posture
Gated — structural class touched, but scope is bounded by the packet.

**Stop points:**
- `/risk-check` verdict RECONSIDER or NO-GO → stop and surface (per the mandate's `Stop if`).
- `/blindspot-scan` PAUSE-AND-FIX → resolve findings before implementation.
- Negative test does NOT abort loudly (i.e., a malformed manifest silently passes) → stop; that is the packet's central safety property, not a detail to patch past.
- Any wrap-note section proposed for retirement whose content has no home in the manifest schema → stop and surface rather than dropping operator-facing content.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).

Structural classes touched: **automation with shared-state effects** (a new script auto-writing `logs/runs/` on every session) and **core-command edits** (`/prime`, `/session-start`, `/wrap-session` — the three highest-traffic commands in the repo; a bug here degrades every future session). The tripwire also applies: the wrap edit *reorders* operations against shared state (validate-then-commit), which does not get the "existing-command refactor" exemption.

**Environment-fit:** PASS — `run-manifest.sh` is invoked by slash commands via the Bash tool inside a session, not by a terminal launcher, shell alias, or `.zshrc` function. It does not depend on how the operator starts Claude Code (VS Code extension), so the 2026-06-10 `cc-worktree.sh` inert-launcher failure mode does not apply.

**Blast radius note:** the manifest is *additive* (new files under `logs/runs/`), and rollback is `rm -rf logs/runs/` + `git revert` (packet §9). The risk is concentrated in the command edits, not the data.
