# Risk Check — 2026-05-22

## Change

Plan-time gate for the Phase 4 — Session Reporter v1 harness build session (plan: harness/logs/session-plan.md). Proposed structural change set, three work units:

1. Schema edit — add an `attention_budget` object (`max_interruptions`, `escalations_used`) to `harness/schemas/current-state-schema.md`, syncing the schema to what the B2 governor edit already persists in `current-state.json`. Documentation-only; the governor is sole writer.

2. New command/skill — build "Session Reporter v1": a `/session-report` command (or skill) that produces a structured markdown + JSON session report, writes a `session_completed` event into `harness/session/session-log.json`, and flips `harness/learning/learnings.json` `session_status` to a terminal value. Closes Checkpoint B findings F1 (crash-detection false-fire) and F5 (session_status stuck at in_progress). May add a `session_completed` event type to `harness/schemas/session-log-schema.md`. Interacts with the existing `.claude/hooks/stop.sh` Stop hook as the reporter's trigger mechanism.

3. Hook registration — wire the existing-but-unwired `.claude/hooks/precompact.sh` and `postcompact.sh` stub scripts to emit a `compaction_event` to `session-log.json`, and register both as `PreCompact`/`PostCompact` hooks in `.claude/settings.json`.

Evaluate the combined change set across the five risk dimensions before execution begins.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/logs/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/current-state-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/session/session-log.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/learning/learnings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/session-log-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/stop.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/precompact.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/postcompact.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The schema-sync and compaction-hook wiring are low-to-medium risk and well-scoped, but Work Unit 2 (the Session Reporter) has a High blast-radius/hidden-coupling problem — a `/session-report` command writing `learnings.json` would violate the harness's documented single-writer discipline and create a new event-shape contract that an existing crash-detection hook silently parses — so the change can proceed only with the paired mitigations below applied during the build.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Work Unit 3 registers two new hooks — `PreCompact` and `PostCompact` — in `.claude/settings.json`. These are not per-tool-call hooks; they fire only when `/compact` runs (manual) or auto-compaction triggers, which is at most a few times per session. Per-session-or-rarer firing is Medium territory, not High. Evidence: `.claude/settings.json` lines 38–51 currently register only one `SessionStart` hook; the change adds two compaction-triggered entries.
- The hook bodies append one `compaction_event` row to `session-log.json` per fire. Each fire is a small bash append with a short timeout (the existing `SessionStart` hook uses `timeout: 10` — `.claude/settings.json` line 46); token cost to the agent session is near-zero (hooks run as shell, not model turns).
- Work Unit 2 builds a new `/session-report` command or skill. If built as an **on-demand command** (operator types `/session-report`, or the governor invokes it at Phase D), it is pay-as-used — Low cost. If built as a **skill with broad trigger keywords** it could auto-load in unrelated sessions — but the change description scopes it to the harness Phase D closeout, a narrow trigger. No always-loaded CLAUDE.md content is added; no `@import` chain is introduced. Evidence: change description WU2 says the reporter is triggered via `.claude/hooks/stop.sh`, i.e. demand-driven, not always-loaded.
- Net: the hook registration is the cost driver. One Medium, no High.

### Dimension 2: Permissions Surface
**Risk:** Low

- The only `settings.json` edit is adding `hooks.PreCompact` and `hooks.PostCompact` blocks. This is a hook-registration edit, not a `permissions.allow` / `ask` / `deny` edit. No capability is granted that was not already available. Evidence: `.claude/settings.json` lines 2–34 — `permissions.allow` already contains `Bash(*)`, `Write(**/.claude/**)`, and `Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)`; the hook scripts run within that already-granted surface.
- No `deny` rule is removed or narrowed. The `deny` list (`.claude/settings.json` lines 27–33) is untouched by the described change.
- No scope escalation (project → user). All edits are to the repo-level `.claude/settings.json`.
- Note: this repo is intentionally permissive (`defaultMode: bypassPermissions`, `Bash(*)` allowed) — safety is enforced via git, `/risk-check`, and audits, not permission prompts. Adding hook bodies does not widen an already-wide surface.

### Dimension 3: Blast Radius
**Risk:** High

Enumeration (grep across the repo, excluding `node_modules`):

- `session-log.json` is referenced by 16 files. The writers/readers that matter: `.claude/hooks/session-start.sh` (reads it for crash detection), `.claude/skills/mandate-parser/SKILL.md` (reads it for crash recovery), `.claude/skills/session-governor/SKILL.md` (appends to it), `harness/schemas/session-log-schema.md` (defines its shape), `harness/schemas/write-ownership.md` (declares "All components" as writers).
- `session_completed` is referenced by 5 files. The load-bearing consumer is `.claude/hooks/session-start.sh` line 39: `if ! grep -q '"session_completed"' "$SESSION_LOG"` — crash-detection Indicator 2. The mandate-parser also looks for `session_completed` in a report `.json` companion (`mandate-parser/SKILL.md` line 96: "Look for a JSON companion (`.json`) that lacks a `session_completed: true` field").
- `learnings.json` is referenced by 14 files. Write ownership is **singular**: `harness/schemas/write-ownership.md` line 12 — "`learnings.json` | Governor nudge | During session"; `learnings-schema.md` line 9 — "Write ownership: Governor nudge sub-behavior only (governor-sequenced, never concurrent)."
- `attention_budget` is referenced by 5 files; the only runtime writer is the governor (`session-governor/SKILL.md` line 174 persists `"attention_budget": { "max_interruptions": 2, "escalations_used": 0 }`).
- `compaction_event` is referenced by 7 files including both stub hooks, the governor SKILL, and `session-log-schema.md` line 31 (already defines `compaction_event` as a log entry type — "logged when manual or auto compaction occurs").

Findings:

- **WU1 (schema-sync) is Low blast radius in isolation.** `current-state-schema.md` is documentation; the governor is the sole writer of `current-state.json` (`write-ownership.md` line 17). Adding the `attention_budget` field description aligns the schema with what the governor already persists — no caller needs modification.
- **WU3 (compaction hooks) is Low-to-Medium.** `session-log-schema.md` line 31 *already* lists `compaction_event` as a defined entry type, so the hooks emit an event the schema already anticipates — no schema contract change. The two hooks are currently `exit 0` no-ops (`precompact.sh` / `postcompact.sh` lines 1–6), so wiring real bodies cannot break a path that currently does nothing.
- **WU2 (Session Reporter) is the High driver.** Two contract problems: (a) the change description says the `/session-report` command "flips `learnings.json` `session_status` to a terminal value" — but `learnings.json` write ownership is documented as **Governor nudge only, never concurrent** (`write-ownership.md` line 12, `learnings-schema.md` line 9). A separate `/session-report` command writing this file introduces a **second writer**, violating single-writer discipline. The governor SKILL itself scopes the `session_status` update as a Phase D / Phase 4 *governor* behavior (`session-governor/SKILL.md` line 575: "the `session_status` → `completed` update on learning entries" is a Phase 4 item in the governor's Stub Marker Index). (b) The reporter writes a `session_completed` event whose shape is silently parsed by `session-start.sh` line 39 — a hook with no schema-validation, just a `grep -q '"session_completed"'`. Any caller (the hook, the mandate-parser report-companion check) that depends on the exact marker string is affected and must agree on the shape.
- More than 5 dependent components touch the affected files; at least one (`learnings.json` writer ownership) requires a design decision to keep the documented contract intact. High.

### Dimension 4: Reversibility
**Risk:** Medium

- WU1 (`current-state-schema.md` edit) and WU3 (`settings.json` hook registration + hook-script bodies) are clean `git revert` candidates — single-file or few-file edits, fully restored within the working tree.
- WU2 creates **sibling files**: a new `.claude/commands/session-report.md` (or a `.claude/skills/session-report/` directory) that `git revert` of the commit *does* remove if it is part of the same commit — but the session-plan (`session-plan.md` line 37) says "commit each of the three items as a separate work unit," so reverting WU2 alone is a clean per-unit revert. Medium, not Low, because the reporter is a new component, not an edit.
- **Append-only log mutation is the Medium driver.** The reporter writes a `session_completed` event into `session-log.json`, and WU3's hooks append `compaction_event` rows. `session-log.json` is append-only (`write-ownership.md` line 16, `session-log-schema.md` line 7). If the reporter or a hook is later reverted, any `session_completed` / `compaction_event` rows already written into a live `session-log.json` are **not removed by `git revert`** — they are data, not code, and a revert of the code leaves stale event rows that carry forward. The next session's crash-detection (`session-start.sh` Indicator 2) reads those rows. A revert therefore needs one extra manual step: inspect `session-log.json` and remove or neutralize any event rows the reverted component wrote.
- No state propagates beyond the local repo — no `git push`, no external API write (push is operator-gated per Autonomy Rule #2; the plan confirms this at `session-plan.md` line 51).
- WU3 adds automation (two registered hooks) that *can fire between landing and a revert* — a `/compact` between the hook landing and a decision to revert would write a `compaction_event` row. This is the same append-only-residue concern, contained.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Single-writer-discipline coupling (the primary High driver).** The reporter writing `learnings.json` `session_status` couples a new component to a file whose schema explicitly forbids a second writer (`learnings-schema.md` line 9: "Governor nudge sub-behavior only ... never concurrent"; `write-ownership.md` line 5: "No file has concurrent writers"). The change description does not name this constraint — it states the reporter "flips `learnings.json` `session_status`" as if it were a free write. This is an undocumented contract violation latent in the change as described.
- **`session_completed` marker is an undocumented parse contract.** `session-start.sh` line 39 detects session completion with a bare `grep -q '"session_completed"'` against the raw JSON text. The reporter must emit an event whose serialized form contains exactly that substring. This coupling is not documented at the change site — `session-log-schema.md` lists the *event types* (line 31 area) but the change description says the `session_completed` type "may" be added to that schema ("May add a `session_completed` event type"). If the reporter ships and the schema is not updated, the hook's parse contract is honored only by the reporter's implementation detail, not by any written spec. The word "may" is the tell — the contract documentation is optional in the change as described, which is exactly the Medium-to-High hidden-coupling pattern.
- **Dual `session_completed` location.** `mandate-parser/SKILL.md` line 96 looks for `session_completed: true` in a **report `.json` companion file**, while `session-start.sh` line 39 looks for `"session_completed"` as an **event in `session-log.json`**. These are two different locations and two different shapes for the same concept. The reporter must satisfy both, or one of the two crash-detection paths will not see completion. The change description names only the `session-log.json` event — the report-companion field is an implicit second dependency the reporter must also honor.
- **Stop-hook trigger coupling is unresolved.** The change description says the reporter "Interacts with the existing `.claude/hooks/stop.sh` Stop hook as the reporter's trigger mechanism." `stop.sh` is currently a stub (`exit 0`, lines 1–6) whose own comment reserves "reporter + stop veto" for Phase 4. The session-plan explicitly defers the exact `Stop`-hook veto scope to the first execution gate (`session-plan.md` line 31, Finding #5; line 49). The reporter's trigger contract with `stop.sh` is therefore not pinned down in the change as described — a deferred-but-named coupling.
- Multiple implicit dependencies plus a contract whose documentation is optional ("may add"). High.

## Mitigations

- **Dimension 3 / Dimension 5 (learnings.json writer):** Before building WU2, resolve the writer-ownership question explicitly. The recommended resolution: make the `session_status` terminal flip a **governor Phase D action** (the governor is already the sole documented `learnings.json` writer and its own SKILL.md line 575 scopes this update as Phase 4 governor work), and have the `/session-report` command produce only the markdown + JSON report and the `session_completed` event in `session-log.json` (where "All components" are authorized writers per `write-ownership.md` line 16). If instead the operator wants the reporter to own the `learnings.json` write, update `write-ownership.md` line 12 and `learnings-schema.md` line 9 in the **same work unit** to name the reporter as the writer — do not leave the schema and the code disagreeing. Either path keeps single-writer discipline intact; pick one before execution, do not leave it implicit.
- **Dimension 5 (session_completed parse contract):** Make the `session_completed` event-type addition to `session-log-schema.md` mandatory in WU2, not optional — change the plan's "may add" to "must add." Document the exact payload shape the reporter emits, and confirm it serializes to contain the literal substring `"session_completed"` that `session-start.sh` line 39 greps for. Add a one-line note in `session-log-schema.md` that crash-detection Indicator 2 depends on this marker, so a future schema editor does not rename it.
- **Dimension 5 (dual completion location):** During the WU2 first execution gate, decide explicitly whether the reporter writes `session_completed` to (a) the `session-log.json` event log only, (b) the report `.json` companion only, or (c) both — and reconcile with `mandate-parser/SKILL.md` line 96, which reads the report-companion field. If only one location is written, update the other crash-detection path so it does not false-negative. Record the decision in the reporter's command/skill `.md` so the contract is documented at the change site.
- **Dimension 3 / Dimension 4 (append-only log residue):** Build and test WU2 and WU3 against a **traced/test `session-log.json`**, not the live one, until verified — the session-plan already calls for a "test/traced session-log" (`session-plan.md` line 35). If any unit is reverted after writing to a live `session-log.json`, the revert procedure must include a manual pass to remove the stale `session_completed` / `compaction_event` rows the reverted component wrote, because `git revert` does not touch log data. Note this cleanup step in the commit message of each of the three work units.
- **Dimension 1 (hook firing):** Keep the `PreCompact` / `PostCompact` hook bodies minimal — a single `compaction_event` append with a short timeout (mirror the existing `SessionStart` hook's `timeout: 10` and `exit 0` fail-open pattern, `.claude/settings.json` lines 44–47), so a slow or failing hook never blocks compaction.

## Recommended redesign

_Not applicable — verdict is PROCEED-WITH-CAUTION._

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. All nine referenced files were tagged `exists` and were read; no `not yet present` file was referenced, so no dimension rests on described-intent-only evaluation.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — Risk-Check Second Opinion: Session Reporter v1 Plan-Time Gate

## Verdict: We concur with PROCEED-WITH-CAUTION — with one correction and one added risk

The risk-check-reviewer reached the right verdict and identified the right binding constraint. We endorse the gate. But the recommended path needs one correction, and the dimension review missed a coupling risk that changes which mitigation is correct.

## Routing position

The brief's routing baseline is sound and we concur with all three placements:

- **Work Unit 1 (schema edit)** — `harness/schemas/current-state-schema.md` is a harness runtime-state schema. Documentation-class edit; not a structural-change class on its own.
- **Work Unit 2 (Session Reporter)** — a harness component, so its home follows existing harness-skill placement (workspace `.claude/skills/` or `.claude/commands/`), **not** `ai-resources/`. This is correct and worth stating plainly: DR-1's "could this serve more than one project" test resolves to *no* — the reporter is bound to the harness session lifecycle, which is a single concern (`system-doc.md § 4.2` — `harness/` is "governed separately"). Placing it in `ai-resources/` would be a DR-1 violation, not a convenience.
- **Work Unit 3 (compaction hooks)** — hook registration in `settings.json` is squarely a gated change class (`risk-topology.md § 3` — "Hook edit → all sessions firing that hook → `/risk-check` plan + end-time").

All three units are correctly inside the `/risk-check` two-gate scope (`principles.md § DR-8`). The gate firing is correct.

## Architectural commentary

**The binding constraint is real and correctly named.** We read `harness/schemas/write-ownership.md` directly. It states without qualification: "The harness enforces single-writer discipline across all session-scoped and persistent state files. Each file has exactly one writer at any given moment... **No file has concurrent writers.**" The ownership table assigns `learnings.json` to exactly one writer — "Governor nudge" — and `learnings-schema.md` repeats it: "Write ownership: Governor nudge sub-behavior only (governor-sequenced, never concurrent)."

A `/session-report` command writing `learnings.json` would introduce a **second writer** to a file the harness's own schema declares single-writer. That is not a style violation — it breaks an explicitly documented invariant. This maps directly to `risk-topology.md § 5` ("Signals that elevate a change to structural risk" — "Change modifies a string literal matched by another component (two-end contract)") and to the `friday-checkup` precedent in `risk-topology.md § 3` ("source-label strings are two-end contracts"). The High hidden-coupling rating is correctly assigned.

**The recommended path is the right one — with a correction.** The five paired mitigations are sound. The key mitigation — *make the `session_status` transition a governor Phase D action rather than a `/session-report` write* — is the architecturally correct choice, and it should be the **primary** path, not the either/or alternative the brief frames it as. Reason: the brief's fallback ("or else update `write-ownership.md` + `learnings-schema.md` in the same unit") would *legalize* a second writer by amending the schema. That trades a coupling violation for a weakened invariant. Single-writer discipline is load-bearing precisely because it makes the harness's concurrency reasoning tractable; widening the writer set to two is a permanent structural cost to close one Checkpoint B finding. `principles.md § DR-7` applies inversely here — we do not *add* surface (a second writer) when an existing component (the governor) already owns the write path. Routing the `session_status` transition through the governor keeps the writer count at one and closes F5 with no invariant change.

**State the position plainly:** the right answer is — `/session-report` produces the markdown + JSON report and writes the `session_completed` event to `session-log.json` (which `write-ownership.md` explicitly permits — `session-log.json` writer is "All components", append-only); the governor's terminal phase performs the `learnings.json` transition. `/session-report` does not touch `learnings.json`. The schema-amendment fallback should be dropped from the plan, not held as an equal option.

## Downstream impact

- **Work Units 1 and 3** are correctly rated low-to-medium. Work Unit 1 is documentation-class (`risk-topology.md § 3` — "Component registry edit → no runtime effect"). Work Unit 3's hook registration is medium because hooks fire on all sessions, but the `compaction_event` emission is additive and the stubs already exist (`blueprint.md § 3.4` lists `precompact.sh`/`postcompact.sh` as "Stub (harness Phase 3)"). The blast radius is real but bounded — and per DR-9, the hook registration should still get the top-3 affected-component check before it lands.
- **Work Unit 2 is the High-blast-radius unit** and the mitigation correctly contains it.

## The risk the dimension review missed

**The `session_status` field is per-entry, not file-level.** The brief describes Work Unit 2 as flipping "`harness/learning/learnings.json` `session_status` to a terminal value" — phrased as a single file-level flag. The actual schema (`learnings-schema.md`) shows `learnings.json` is "an array of entries," and `session_status` is a **field on each entry** — `"session_status": "in_progress | recovered | completed | invalidated"`. There is no file-level `session_status`.

This matters for two reasons the five-dimension review did not surface:

1. **The mitigation's mechanics change.** "Flip `session_status` to a terminal value" is not one write — it is an *update-in-place across every entry in the array* (or at minimum every entry for the current `session_id`). `write-ownership.md` lists the `learnings.json` write pattern as **"Append (one entry per committed unit)"** — append-only. A terminal-status transition is an **update-in-place**, which is not a pattern the file is documented to support. Whoever performs the transition — `/session-report` or the governor — is introducing a new *write pattern*, not just a new writer. The mitigation must specify update-in-place semantics, or the build will hit an undocumented-pattern wall at implementation time.

2. **There is a documented consolidation contract this collides with.** `learnings-schema.md` states: "Entries whose `session_status` was never updated from `in_progress` to `completed` can be identified and reviewed by the **next session's consolidation pass**." So a *second* consumer already depends on `session_status` — the next session's consolidation pass reads it to detect orphaned sessions. If Work Unit 2's transition logic is wrong (transitions some entries but not others, or races the governor's nudge appends for late-committed units), it doesn't just fail loudly — it produces *silently* mis-consolidated learning state on the following session. That is a hidden-coupling path (Dimension 5) the review rated High but did not enumerate this specific edge of.

**Recommended addition to the mitigation set (a sixth item):** the plan must specify (a) that the `learnings.json` transition is update-in-place over the session's entries, scoped by `session_id`; (b) the ordering guarantee that the transition runs *after* the governor's final per-unit nudge append, so no committed unit's entry is left at `in_progress`; and (c) that the v1 nudge stub's null entries (`learnings-schema.md § v1 Nudge-Extraction Stub`) are included in the transition. This is also why mitigation key-item routing-through-the-governor is not just *preferable* but *necessary* — only the governor knows when its last nudge append has completed. A `/session-report` command firing at session close cannot know it isn't racing a still-pending nudge. The ordering guarantee is unenforceable from outside the governor.

## Bottom line

- Concur with PROCEED-WITH-CAUTION. The gate is correct; do not downgrade it (`principles.md § DR-8` — verdict is binding).
- The five paired mitigations are sound, but the key mitigation should be the **sole** path: route the `learnings.json` transition through the governor's terminal phase. Drop the schema-amendment fallback — it legalizes a second writer and permanently weakens an invariant to close one finding.
- Add a **sixth mitigation**: specify update-in-place semantics scoped by `session_id`, the after-last-nudge ordering guarantee, and null-stub-entry inclusion. The five-dimension review treated `session_status` as a file-level flag; it is a per-entry field with an append-only documented write pattern and a downstream consolidation-pass consumer. That gap is the real shape of the Dimension 5 High rating.
- Work Units 1 and 3 proceed as scoped; apply the DR-9 top-3 check on the Work Unit 3 hook registration before it lands.

**Files load-bearing to this advisory:**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/write-ownership.md` — single-writer discipline; `learnings.json` writer = "Governor nudge"; append-only write pattern.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/learnings-schema.md` — `session_status` is a per-entry field; consolidation-pass dependency; v1 nudge stub writes null entries.

One scope note for the operator: this advisory rests partly on two harness schema files read in-line. Per `grounding.md`, `harness/` internals are "governed separately" and are not part of the System Owner grounding base — I read them because the verdict's central claim turns on them. The architectural judgment (concur with the gate, route through the governor, add the sixth mitigation) is grounded in the vault principles; the harness-internal mechanics (update-in-place, ordering) should still be confirmed by whoever owns the harness schema before the build.
