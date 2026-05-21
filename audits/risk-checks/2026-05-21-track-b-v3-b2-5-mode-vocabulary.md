# Risk Check — 2026-05-21

## Change

Track B v3 amendment B2 — 5-mode vocabulary + Confidence×Impact grid. Proposed structural change: replace the harness's binary "genuine blocker / proceed" model with a graded one — five modes Stop / Pause / Park / Narrow / Escalate, plus a Confidence×Impact grid that decides when to escalate (escalate on uncertainty × impact, not uncertainty alone). The change is specified in `project-plan-v3.md` (Phase 1 harness CLAUDE.md-rules section) THIS session — v3 is a plan document. The structural risk: the operational definition of "genuine blocker" is encoded in built, shipped components — the `mandate-parser` SKILL.md (Step 5 "Missing fields and non-countable exit conditions are genuine blockers", Step 6 "If a field remains MISSING after the gate: this is a genuine blocker", and the Edge Cases note "Ambiguous mandates that survive /clarify with operator confirmation do NOT constitute genuine blockers") and `.claude/references/harness-rules.md` (the canonical blocker definition + hard rules). v3 REFRAMES "genuine blocker" as the Stop/Escalate subset of the five modes — it is explicitly NOT discarded; existing blocker behaviour is preserved as a subset. The actual built-component edits are DEFERRED to a follow-on Track B phase 2 and consist of: (1) `.claude/references/harness-rules.md` — reframe the blocker definition to the 5-mode model; (2) `.claude/skills/mandate-parser/SKILL.md` — Steps 5/6 + the edge-case note; (3) `harness/schemas/state-machine.md` — add a pointer to the 5-mode model in the rollback rules. This is a definitional change to a shipped skill and a shipped reference doc, not a plain plan-document edit. This is a plan-time risk gate per the implementation plan §7. The harness is currently at Phase 2 complete (mandate-parser shipped); the governor (Phase 3+) is not yet built.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/references/harness-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/state-machine.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/agent-harness/project-plan-v3.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The plan-document amendment itself is low-cost and reversible, but the deferred B2 phase-2 work re-defines a canonical contract ("genuine blocker") encoded across three shipped harness components and referenced by ~10 files, and the v3 plan currently lacks the consolidated "Track B Amendment Record" section that should specify that contract — the missing spec is the load-bearing gap.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The plan-document edit itself (project-plan-v3.md) carries zero ongoing token cost — it is not an always-loaded file; it is read only during agent-harness planning sessions. Evidence: not referenced by any `@import` in workspace or repo CLAUDE.md (workspace CLAUDE.md and `ai-resources/CLAUDE.md` read in full — no import of plan documents).
- The deferred phase-2 edit to `.claude/references/harness-rules.md` is load-on-demand, not always-loaded. Evidence: harness-rules.md lines 3–16 "loaded on demand by harness skills … Do NOT load when doing unrelated work in the repo — these rules cost context and are irrelevant outside harness sessions." Replacing the ~3-line blocker definition (lines 57–59) with a 5-mode model + a Confidence×Impact grid will expand that file; a grid plus five mode definitions plausibly adds 150–400 tokens to a file loaded once per harness session.
- The deferred edit to `mandate-parser/SKILL.md` expands Steps 5/6 and the edge-case note; mandate-parser is invoked once per harness session (Phase A startup), so the added tokens are a per-harness-session cost, not a per-turn cost. Evidence: SKILL.md description "Must be run at the start of every harness session."
- Net: no per-turn or per-tool-call cost; the cost is per-harness-session and bounded. Medium because the 5-mode model + grid is materially larger than the 3-line definition it replaces, and harness-rules.md is loaded by 6 skills + 2 commands (file lines 5–14).
- Note: this dimension is evaluated on the *described intent* of the phase-2 edits — those files are not yet edited. The exact token delta cannot be measured until the phase-2 wording exists.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` `allow` / `ask` / `deny` entry is added, removed, or widened. The change is confined to markdown content in a plan document and (deferred) three harness markdown files. Evidence: REFERENCED_FILE_PATHS contains no `settings.json` / `settings.local.json`; CHANGE_DESCRIPTION describes only definitional/vocabulary edits.
- No new tool family, Bash pattern, Write path, or external API is introduced. The 5-mode model is a reasoning vocabulary, not a capability grant.
- The new "Escalate" mode increases operator-facing interaction surface conceptually (a graded escalation path) but does not change which tools or paths the agent may touch.

### Dimension 3: Blast Radius
**Risk:** High

- The change re-defines a *canonical contract*: harness-rules.md § "Operational definition of 'genuine blocker'" (lines 55–59) is quoted as the single authoritative definition, and Development Guidance §4 of v3 lists "The operational definition of 'genuine blocker' (from inputs/01 §Component 1)" among the items Claude Code has NO latitude on (project-plan-v3.md line 97). Reframing it touches a non-latitude design constraint.
- Enumeration — `grep -rln "genuine blocker"` across the repo (md/json/yaml/sh) returns 6 files: `.claude/references/harness-rules.md`, `.claude/skills/mandate-parser/SKILL.md`, `harness/schemas/state-machine.md`, `harness/schemas/mandate-history-schema.md`, `harness/reports/2026-05-20-chatgpt-design-ideas-implementation-plan.md`, `logs/session-plan.md`.
- The change description names only 3 of those 6 as deferred edit targets. `harness/schemas/mandate-history-schema.md` is NOT in the named edit set — line 43 uses "genuine blockers" inside the canonical `stop_rule` example text ("only on genuine blockers you cannot proceed without my input"). If the vocabulary is reframed, this example drifts out of sync with the new model unless also updated. This is an unnamed fourth affected file.
- Enumeration — `grep -rln "harness-rules.md"` returns 7 files referencing the reference doc: `CLAUDE.md`, `.claude/skills/mandate-parser/SKILL.md`, `harness/README.md`, plus reports/logs. Workspace CLAUDE.md § "Agent Harness" instructs loading `@.claude/references/harness-rules.md` for harness work — every harness session reads the reframed definition.
- Enumeration — `grep -rln "mandate-parser"` returns 12 files; `grep -rln "state-machine.md"` returns 6 files. mandate-parser is shipped (Phase 2 complete per CHANGE_DESCRIPTION) — editing Steps 5/6 changes the behavior of a live, exercised skill, not a draft.
- Contract-shape concern: mandate-parser Step 6 (line 169) and the Edge Cases block (lines 292–298) emit a literal operator-facing string `MANDATE UNRESOLVED — GENUINE BLOCKER`. If "genuine blocker" is reframed as a *subset* (Stop/Escalate) of five modes, any downstream consumer or operator habit keyed to that exact string/heading must be reconciled. The state-machine.md rollback rules (lines 24–27) also use "escalates as a genuine blocker" / "logs as genuine blocker" — wording that will need to map cleanly onto the new Escalate mode.
- The CHANGE_DESCRIPTION asserts "existing blocker behaviour is preserved as a subset" — i.e., backwards-compatible by intent. But >5 dependent files reference the term and at least one (mandate-history-schema.md) is outside the named edit set, so at least one caller requires modification to stay consistent. That meets the High threshold.

### Dimension 4: Reversibility
**Risk:** Medium

- The v3 plan-document amendment is a single-file edit to a versioned plan (`project-plan-v3.md`) — `git revert` restores it cleanly within the working tree. The repo convention also keeps prior versions as siblings (v2 retained alongside v3 per workspace CLAUDE.md "create a new version file rather than overwriting"), so the prior model is not lost.
- The deferred phase-2 edits are three (effectively four, incl. mandate-history-schema.md) markdown-file content edits. A `git revert` of the phase-2 commit restores the prior wording mechanically — no data/log mutation, no external write, no automation fires.
- Medium, not Low, because reverting *after* phase-2 lands is a multi-file coordinated revert, and a partial revert (e.g., reverting harness-rules.md but not mandate-parser/SKILL.md) would leave the canonical definition and its consumer skill disagreeing — a worse state than either before or after. Revert must be all-or-nothing across the phase-2 file set.
- No state propagates beyond git: no push, no Notion write, no hook registration. The `mandate-parser` is invoked manually at harness-session start, not by an auto-firing hook (SKILL.md line 42 / Step 1: `session-start.sh` is "not wired as a SessionStart hook"), so no automation fires between a phase-2 landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Missing specification.** v3's Changelog references a section "Track B Amendment Record" with a subsection "Deferred schema/skill application phase" three times (project-plan-v3.md lines 16, 21, 29: "§ 'Track B Amendment Record' at the end gives the consolidated per-item view"; "enumerated in § 'Track B Amendment Record → Deferred schema/skill application phase'"). That section does NOT exist — the document's section list ends at "Appendix A" (line 674) and the file is 689 lines. The B2 amendment's authoritative spec — the consolidated definition of the five modes and the Confidence×Impact grid — is therefore promised but absent. CHANGE_DESCRIPTION says B2 is "specified in project-plan-v3.md (Phase 1 harness CLAUDE.md-rules section)," but Phase 1's content spec (lines 217–227) still describes the OLD binary model ("Blocker vs. non-blocker philosophy (DP-8) with the operational definition of 'genuine blocker' quoted verbatim", line 220) with no 5-mode content. The phase-2 edits would be implemented against a spec that is not on disk.
- **Undocumented new contract.** The Confidence×Impact grid is a new decision contract ("escalate on uncertainty × impact, not uncertainty alone"). harness-rules.md currently states the inverse rule explicitly — line 59: "Uncertainty about optimal approach … NOT genuine blockers." The Park / Narrow / Escalate modes have no operational definition anywhere in the four referenced files. The governor (Phase 3+, not yet built per CHANGE_DESCRIPTION) is the component that will consume modes like Park ("blocked-item queue, the Park destination" per v3 Changelog B3) — a not-yet-built consumer that must honor an undocumented contract.
- **Functional overlap.** Two judgment systems would coexist: harness-rules.md § "Judgment rules" already has "Log, don't stop (DP-8)" (line 49) and "Constraint priority order (DP-9)" (line 50) governing when to stop vs. log. The 5-mode model (Stop/Pause/Park/Narrow/Escalate) overlaps DP-8's binary log-or-stop split. Without the missing amendment-record section to reconcile them, the phase-2 editor must decide whether the 5 modes replace, subsume, or sit beside DP-8 — an unresolved overlap.
- **State-machine pointer.** The described edit (3) adds "a pointer to the 5-mode model in the rollback rules" of state-machine.md. state-machine.md is transcribed verbatim from v7 §Canonical Work-Unit State Machine (file line 1: "Transcribed from inputs/01-context-pack-v7.md"). Inserting a pointer to a model that post-dates v7 breaks the "verbatim transcription" provenance of that file unless the insertion is clearly marked as a post-v7 amendment.
- Multiple implicit dependencies + an undocumented new contract + functional overlap with an existing mechanism → High.

## Mitigations

- **Dimension 3 (Blast Radius):** Before the phase-2 commit, run `grep -rln "genuine blocker"` and reconcile ALL hits, not the 3 named files — explicitly add `harness/schemas/mandate-history-schema.md` line 43 to the phase-2 edit set (or document why its `stop_rule` example stays as-is). Land all phase-2 file edits in a single atomic commit so the canonical definition and its consumers never disagree at any commit boundary.
- **Dimension 3 (Blast Radius):** Treat the operator-facing literal `MANDATE UNRESOLVED — GENUINE BLOCKER` (mandate-parser SKILL.md line 294) as a contract string — in phase 2, decide and document whether that heading text is kept (for operator-habit stability) or migrated to the new vocabulary, and apply the same decision to state-machine.md's "escalates as a genuine blocker" wording.
- **Dimension 5 (Hidden Coupling):** Before phase-2 work begins, write the missing "Track B Amendment Record → Deferred schema/skill application phase" section into project-plan-v3.md (or a clearly-named successor version). That section must give the operational definition of all five modes, the Confidence×Impact grid cells, and an explicit statement of how the 5-mode model relates to DP-8 ("Log, don't stop") — replace, subsume, or coexist. The phase-2 edits must not be implemented until this spec is on disk.
- **Dimension 5 (Hidden Coupling):** In the amendment-record section, state explicitly which not-yet-built consumers (the Phase 3+ governor, the B3 blocked-item queue) must honor the Park / Escalate contract, so the governor build picks the contract up rather than re-inventing it.
- **Dimension 5 (Hidden Coupling):** When adding the pointer to state-machine.md, mark it as a post-v7 amendment (e.g., an explicit "Amendment (Track B v3): …" note) so the file's verbatim-transcription provenance is not silently broken.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit notes that deferred-file dimensions are evaluated on described intent). No training-data fallback was used on fetch/read failures. The four referenced files tagged `exists` were all read in full; the missing "Track B Amendment Record" section was confirmed absent by enumerating all section headers in project-plan-v3.md.
