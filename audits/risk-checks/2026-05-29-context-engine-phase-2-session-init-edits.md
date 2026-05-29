# Risk Check — 2026-05-29

## Change

Context Engine MVP Phase 2 — two edits to load-bearing session-init commands.

EDIT 1: ai-resources/.claude/commands/session-start.md
- Insert NEW Step 2.4 ("Context discovery (engine pre-step)") between existing Step 2 (parse + confirm) and existing Step 2.5 (self-check). Existing Step 2.5 self-check stays at 2.5, unchanged. Step 2.4 invokes the context-discovery agent (Opus, 60s timeout, fails-soft) with parsed work_scope + cwd-project + INVOCATION_MODE=auto-session-start. Skip conditions: work_scope <5 words, meta-commands (/prime, /open-items), no CLAUDE.md at cwd. On success, REPLACES (inferred) files_in_scope with concrete list; SETS allowed_inputs/required_outputs if absent; re-emits Step 2 confirmation with engine-enriched fields. Failure is silent — proceeds with original parsed mandate.
- Extend Step 3 mandate-line schema with one new bullet: "- Context pack: {pack_path}" (written only when Step 2.4 produced a pack). Pre-flight verified all 3 downstream readers (canonical wrap-session.md Step 7a, workspace-root wrap-session.md Step 2b, drift-check.md Step 5) use fixed-list extraction and silently ignore unknown bullets — no downstream edits required.

EDIT 2: ai-resources/.claude/commands/prime.md
- Parity edit for Step 8c auto-mode (which inlines mandate-write and bypasses /session-start entirely). New Step 8c.4.5 invokes the same context-discovery agent with INVOCATION_MODE=auto-prime. Same skip conditions. Same fail-soft behavior. Step 8c.6 approval gate gets new "**Context pack:** {pack_path}" line when present. Step 8c.7 mandate-write appends "- Context pack: {pack_path}" bullet.

Both commands gain the engine as an OPTIONAL pre-step — never a hard gate. Failures are silent and recoverable. The engine writes only to output/context-packs/{slug}/pack.md (never to logs/, so no mtime-marker corruption per /session-start Step 0.5).

Phase 1 (schema doc + context-discovery agent + /build-context manual command) already committed (7dc5e6e). Plan at ~/.claude/plans/starry-pondering-gem.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/context-discovery.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/build-context.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/context-pack-schema.md — exists
- /Users/patrik.lindeberg/.claude/plans/starry-pondering-gem.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Two non-skipable, load-bearing session-init commands gain an optional fail-soft pre-step plus a backwards-compatible mandate-bullet extension; coupling to the agent, parse contract, and concurrent-session marker mechanism warrants paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Both edits add inline-text steps to two commands that are loaded into every session that uses `/prime` or `/session-start` — `prime.md` runs at every session start by Patrik's convention (workspace CLAUDE.md § General Session Rules: "Pull the latest from GitHub at the start of each session"). The added Step 2.4 in `session-start.md` is ~25 lines of guidance text; the added Step 8c.4.5 / 8c.6 / 8c.7 changes in `prime.md` are ~15 lines collectively (per plan Deliverable 4–5 lines 107–169 in `~/.claude/plans/starry-pondering-gem.md`). Estimated additive cost ~40 lines / ~300–400 tokens per loaded session — above the 150-token Medium threshold but bounded.
- Per-session runtime cost: the context-discovery agent is Opus-tier with a 30-file Read ceiling per `ai-resources/.claude/agents/context-discovery.md` line 30 ("Do not Read more than 30 files total across all Steps"). When the skip conditions do NOT fire — i.e., a real work_scope in a project with a CLAUDE.md — the agent fires once per session-init. Plan calls this out as expected (~/.claude/plans/starry-pondering-gem.md line 78: "this agent fires once per session-init, not per-unit").
- Skip conditions are explicit and cheap to evaluate (work_scope <5 words, meta-command match, no CLAUDE.md at cwd — change description). On workspace-root sessions and meta-command sessions the cost is zero.
- The 60s timeout in the spec keeps a stuck agent from indefinitely blocking session-init — fails-soft to the original parsed mandate (change description). Cost upper bound is bounded.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json edit in this Phase 2 batch. Plan explicitly drops the SessionStart hook deliverable (~/.claude/plans/starry-pondering-gem.md lines 22–24, 171–173, 186) — "no settings.json edit, no new bash script."
- The context-discovery agent declares only Read / Glob / Grep / Write in its frontmatter (`ai-resources/.claude/agents/context-discovery.md` lines 6–9). Write is scoped to `output/context-packs/{slug}/pack.md` per `ai-resources/docs/context-pack-schema.md` § 1.
- Agent respects existing `Read(archive/**)` and `Read(**/deprecated/**)` deny rules per the agent's own Read Scope section (`ai-resources/.claude/agents/context-discovery.md` line 28).
- No new tool family invoked; no new external API; no cross-repo writes.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 2 (`session-start.md`, `prime.md`).
- Grep across `ai-resources/.claude/`, `ai-resources/skills/`, `ai-resources/docs/`, and workspace `.claude/` for references to `session-start.md` or `prime.md` returns: `monday-prep.md`, `contract-check.md`, `drift-check.md`, `wrap-session.md` (canonical), `wrap-session.md` (workspace-root), `session-rituals.md`, `session-marker.md`, plus the targets themselves (8 distinct files reference them by name).
- Grep for `**Mandate:**` parsing across `ai-resources/.claude/`, `ai-resources/skills/`, `ai-resources/docs/`, workspace `.claude/` returns 8 files: `monday-prep.md`, `contract-check.md`, `drift-check.md`, `session-start.md`, `wrap-session.md` (canonical), `prime.md`, `session-rituals.md`, workspace-root `wrap-session.md`.
- The change description asserts pre-flight verified the 3 explicit downstream readers of the mandate-line bullet schema (canonical `wrap-session.md` Step 7a, workspace-root `wrap-session.md` Step 2b, `drift-check.md` Step 5) use fixed-list extraction and silently ignore unknown bullets. Verified by reading:
  - Canonical `wrap-session.md` Step 7a (lines 255–256): extracts the five named sub-bullets (`- Out of scope:`, `- Files in scope:`, `- Stop if:`, `- Allowed inputs:`, `- Required outputs:`) — fixed-list, ignores unknown.
  - Workspace-root `wrap-session.md` Step 2b (lines 207–217): extracts `OUT_OF_SCOPE`, `FILES_IN_SCOPE`, `ALLOWED_INPUTS`, `REQUIRED_OUTPUTS` from named sub-bullets — fixed-list, ignores unknown.
  - `drift-check.md` Step 5 (line 26): "Read that block; capture its mandate content as MANDATE — the `**Mandate:**` line plus any `Out of scope` / `Files in scope` / `Stop if` / `Allowed inputs` / `Required outputs` lines that follow it" — explicit fixed-list, unknown lines pass through into MANDATE as context (not rejected).
- BUT two additional `Mandate:`-reading consumers exist that the change description does NOT mention: `monday-prep.md` and `contract-check.md`. These were not enumerated in the plan's pre-flight check. Risk that one of them does strict-schema rejection or unexpected behavior on the new bullet has not been verified by the change. This pushes blast radius to Medium rather than Low.
- The change is additive (new bullet, never removed), conditional (only written when pack exists), and pre-flight-verified backwards-compatible for 3 of 5 known consumers — no other caller requires modification according to the verified set.
- Two commands edited; both are session-init entrypoints — every session that runs `/prime` or `/session-start` exercises the new code path. The blast radius in terms of session-invocation coverage is wide (every session), but the change's behavior surface is narrow (fail-soft, never hard-gates).

### Dimension 4: Reversibility
**Risk:** Medium

- Both edits are single-file in-place text additions inside two `.md` command files. `git revert` removes the inserted Step 2.4, Step 3 bullet, Step 8c.4.5, Step 8c.6 line, Step 8c.7 bullet — clean.
- However: between the Phase 2 land and a hypothetical revert, real sessions will have executed the engine path and written `- Context pack: {pack_path}` bullets into `logs/session-notes.md` mandate blocks. These bullets are append-only log mutations. A revert of the command files does NOT remove those bullets from already-written session notes; downstream readers (the 3 verified + 2 unverified) will continue to encounter them. Fixed-list parsers tolerate this, but the log artifact is permanent.
- Context packs at `output/context-packs/{slug}/pack.md` similarly persist after a command-file revert. Per `ai-resources/docs/context-pack-schema.md` § 1 line 23, "Per-project `output/` git-tracking is heterogeneous" — some are gitignored, some are tracked. For tracked projects, revert leaves the pack files in the working tree, requiring manual cleanup; for gitignored projects, revert leaves them on disk untracked. Multi-step manual rollback.
- The change does NOT push state beyond the local repo (no external write, no API POST). No automation registered (hook dropped per plan lines 171–173). Within-git revert is fully scoped.
- Net: clean code revert, but residual log/pack artifacts require manual cleanup if revert occurs. One-to-two extra cleanup steps — Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The change relies on the `context-discovery` agent's 60-second timeout behavior. The agent file at `ai-resources/.claude/agents/context-discovery.md` does not declare a 60s timeout anywhere in its body — the timeout must be enforced by the caller (the `session-start.md` Step 2.4 and `prime.md` Step 8c.4.5 invocations). Risk: if the caller invokes via the Agent tool without an explicit timeout argument, the 60s ceiling is aspirational, not enforced. The agent itself can run up to its 30-file Read budget which on Opus could take longer than 60s.
- The change couples to the `(inferred)` marker convention in `session-start.md` Step 3 (line 219: `(inferred) — if files_inferred = true`). Step 2.4 replaces files_in_scope only when files_inferred = true. This is an established contract (documented at the change site per change description), but it depends on the Step 2 parse setting files_inferred correctly. Step 2 (lines 86–88) sets `files_inferred = true` when "not stated by the operator". If a future Step 2 edit changes the inferred-marker semantics, Step 2.4's replace-behavior breaks silently. Documented coupling — one implicit dependency.
- The change description claims the engine writes only to `output/context-packs/{slug}/pack.md` and "never to logs/, so no mtime-marker corruption per /session-start Step 0.5". Verified: `ai-resources/docs/context-pack-schema.md` § 1 line 14 confirms the path. `session-start.md` Step 0.5 (lines 26–71) reads `logs/session-notes.md` mtime and `logs/.prime-mtime`; the engine touching neither is correctly non-interacting.
- The Step 2.4 re-emits the Step 2 confirmation block with engine-enriched fields. This implicitly couples to Step 2's rendering conventions (lines 93–170): semantic marker set, rendering rules, table-vs-bullet thresholds. If Step 2's rendering rules drift, Step 2.4's re-emit must follow. Coupling is bounded by the fact that Step 2.4 calls back into Step 2's rendering, not a parallel rendering — single source of truth.
- The change couples to the agent's return-shape contract: `{pack_path, files_in_scope, allowed_inputs, required_outputs, sufficient_to_plan, sufficient_to_implement, missing_context_count}` per plan line 122–123. The agent file (`ai-resources/.claude/agents/context-discovery.md` Step 9 lines 154–181) declares a different return shape — a markdown summary block with `**Pack:** {path}`, `**files_in_scope** ({count}):`, etc. Step 2.4 and Step 8c.4.5 will need to parse the agent's markdown summary to extract the fields, not consume a structured JSON. This is a load-bearing parse contract not documented in either the agent or the change description. Risk: brittle parser at two call sites.
- Concurrent-session marker mechanism (`logs/.session-marker`, `logs/.prime-mtime`) is referenced by both `session-start.md` Step 0.5 / Step 3 and `prime.md` Step 8a.3.a / 8b.3.a / 8c.3. The new Step 2.4 sits between Step 2 (parse) and Step 2.5 (self-check), AFTER Step 0.5's mtime guard ran. The new step does not touch the marker or mtime — verified safe per change description. But the new Step 8c.4.5 in `prime.md` sits between Step 8c.4 (mandate derivation) and Step 8c.5 (plan derivation) — also AFTER Step 8c.3's marker/mtime write. Order is correct, but the placement is implicit; if a future reorder of Step 8c moves the marker-write later, Step 8c.4.5 could fire before the marker exists. Implicit ordering dependency.
- Two `Mandate:`-line consumers (`monday-prep.md`, `contract-check.md`) were not enumerated in the change's pre-flight verification list. If either does strict-schema rejection, the new `- Context pack:` bullet could cause silent or loud failures in those consumers. Hidden coupling (or hidden absence-of-coupling — depends on the actual parsers).

## Mitigations

- **Dimension 3 (blast radius — unverified additional consumers):** Before landing Phase 2, read `ai-resources/.claude/commands/monday-prep.md` and `ai-resources/.claude/commands/contract-check.md` for any `Mandate:` line parsing. Confirm both use fixed-list extraction or full-block pass-through (resilient to unknown bullets) — same posture as the 3 already-verified readers. If either does strict-schema rejection, add it to the Phase 2 edit set. Pre-flight finding extends the change-description's Pre-flight A check from 3 readers to 5.
- **Dimension 5 (hidden coupling — agent return-shape parse contract):** Before landing Phase 2, explicitly document the parse contract that Step 2.4 and Step 8c.4.5 use to extract `pack_path`, `files_in_scope`, `allowed_inputs`, `required_outputs` from the agent's markdown summary block. Add the contract either to the new step's text in the command file, to the agent's Step 9 section, or to `ai-resources/docs/context-pack-schema.md`. Without this, both call sites carry an undocumented parser that future agent-summary edits could silently break.
- **Dimension 5 (hidden coupling — 60s timeout enforcement):** Verify that the Agent-tool invocation pattern used by Step 2.4 and Step 8c.4.5 supports an explicit timeout argument, and that the new step's text names that argument. If timeout is operator-tier (only `tool_timeout_ms` etc.), document the actual failure mode (e.g., "agent will run until 30-file Read budget exhausted; no enforceable wall-clock cap"). Either fix or document — do not leave the 60s claim as an unfounded contract assertion in the new step.
- **Dimension 4 (reversibility — residual log/pack artifacts):** Document the revert plan in the Phase 2 commit message or in `logs/decisions.md`: if revert occurs, (a) `output/context-packs/` directories may need manual cleanup per project, and (b) `- Context pack:` bullets in past `logs/session-notes.md` mandate blocks are harmless (fixed-list parsers ignore them) and can be left in place. Lowers operator surprise during a hypothetical Phase 2 rollback.

## Recommended redesign

(Verdict is PROCEED-WITH-CAUTION; no redesign required. Mitigations above are sufficient.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). No training-data fallback was used on fetch/read failures. Specifically:
- Token estimate (D1) derived from line counts in `~/.claude/plans/starry-pondering-gem.md` lines 107–169.
- Skip-condition existence (D1) quoted from change description.
- Permissions claims (D2) verified against `ai-resources/.claude/agents/context-discovery.md` lines 6–9 and 28.
- Downstream-reader resilience (D3) verified against `ai-resources/.claude/commands/wrap-session.md` lines 255–256, workspace-root `wrap-session.md` lines 207–217, `ai-resources/.claude/commands/drift-check.md` line 26.
- Additional `Mandate:` consumers (D3) discovered via grep returning 8 files, of which 2 (`monday-prep.md`, `contract-check.md`) were not enumerated in the change's pre-flight check.
- Reversibility claims (D4) anchored in `ai-resources/docs/context-pack-schema.md` § 1 line 23.
- Hidden coupling — agent return-shape (D5) verified by comparing plan line 122–123 to agent file lines 154–181.
- Marker/mtime non-interaction (D5) verified against `session-start.md` lines 26–71.
