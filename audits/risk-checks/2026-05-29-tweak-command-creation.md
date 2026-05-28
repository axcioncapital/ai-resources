# Risk Check — 2026-05-29

## Change

Adding a new slash command `/tweak` at `ai-resources/.claude/commands/tweak.md`. The command applies cosmetic one-line fixes to existing commands and skills via a fresh-context general-purpose subagent.

**Flow:**
1. Parse args — `<target-name> "<feedback string>"`. Resolve target across `.claude/commands/`, `skills/`, `.claude/agents/`.
2. Scope gate — STOP if feedback contains "rewrite"/"restructure"/"reorganize", names multiple sections, proposes new step/section, changes trigger/exclusion/output-format claims, OR targets any YAML frontmatter field. Routes blocked cases to `/improve-skill`.
3. Spawn `general-purpose` subagent with fresh context. Pass: full target file contents + operator feedback string. Subagent applies minimal inline edit + re-reads + returns unified diff + one-sentence match confirmation, OR returns `ESCALATE: <reason>` if scope exceeded.
4. Handle return — show diff to operator, or STOP on ESCALATE.
5. Diff-confirm gate — present `Apply this edit? (y / n)` prompt. `n` → discard, no commit. `y` → proceed.
6. Commit + push — stage the explicit file path, commit with `update: {target-name} — {one-line from feedback}`, push autonomously per standing rule.
7. Append one line to `ai-resources/logs/maintenance-observations.md` — format: `- 2026-MM-DD — /tweak {target-name} — {one-line feedback} — commit {short-sha}`.

**What this change does NOT do:**
- No new agent definition under `.claude/agents/` (uses existing `general-purpose`).
- No permission changes — no `settings.json` edits.
- No CLAUDE.md edits.
- No new symlinks (auto-symlink to projects happens via existing `auto-sync-shared.sh` SessionStart hook on next session — no new symlink topology).
- No project-level deployment beyond the auto-sync above.

**Context — this is the plan-time gate.** Proposal approved by operator after `/clarify` → `/decide` → `/consult` passes. System Owner returned "ship with named changes" verdict and three load-bearing changes are already incorporated:
- [SO-CHANGE-1] diff-confirm gate (Step 5 above) grounded in OP-2, OP-5, risk-topology § 1
- [SO-CHANGE-2] frontmatter block (Step 2 above) grounded in DR-3, DR-8
- [SO-CHANGE-3] maintenance-observations append (Step 7 above) grounded in system-doc.md § 4.5, OP-3

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/tweak.md` — not yet present
- `/Users/patrik.lindeberg/.claude/plans/create-a-implementation-proposal-cozy-cascade.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve-skill.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/update-claude-md.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/maintenance-observations.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The command shape is well-scoped and the System Owner mitigations close the auto-apply blast-radius hole, but Step 7 appends an undocumented schema variant into a file whose downstream consumers parse a different shape — this hidden-coupling risk must be paired with a schema fix before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new command is pay-as-used — no SessionStart hook, no auto-load, no `@import` chain. Operator invokes via slash command only. Evidence: change description Step 1 ("Parse args") — explicit operator-invoked entry, no event registration. No CLAUDE.md edit per "What this change does NOT do" bullet.
- The auto-symlink distribution via `auto-sync-shared.sh` does symlink the file into every project's `.claude/commands/`, but a slash-command file is loaded only when invoked, not on session start. Evidence: `ai-resources/.claude/hooks/auto-sync-shared.sh:82-96` emits symlinks but does not load file contents.
- File size will land around 75 lines per the proposal ("Total length: ~75 lines", `create-a-implementation-proposal-cozy-cascade.md:180`), well below the existing `improve-skill.md` (158 lines) it supplements. No always-loaded surface touched.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edit per "What this change does NOT do" bullet 2 ("No permission changes — no `settings.json` edits.").
- The command's runtime needs (Read, Edit, Bash for git stage/commit/push, Task to spawn `general-purpose`) are all already authorized by the existing ai-resources / workspace settings layer — confirmed by the fact that 65 sibling commands operate under the same envelope. Evidence: `ls .claude/commands/` returned 66 entries; existing commands like `/improve-skill` already perform the same Bash + Edit + Task pattern.
- No new deny-rule narrowing. No scope escalation (project → user).

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 1 new file (`ai-resources/.claude/commands/tweak.md`).
- Auto-distribution surface: every project that hosts a `.claude/shared-manifest.json` will receive a symlink on next SessionStart via `auto-sync-shared.sh:82-96`. Evidence: hook walks `ai-resources/.claude/commands/*.md` unconditionally except `EXCLUDE_COMMANDS = "new-project deploy-workflow run-sufficiency"` (line 46) — `tweak` is not on that exclude list.
- Downstream callers of `maintenance-observations.md` enumerated (grep `maintenance-observations` across `.claude/commands/` and `docs/`): **7 consumers** —
  - `friday-act.md:138, 298, 374, 401, 409` (writes session blocks; reads for axis-target carry-forward)
  - `so-monthly.md:22` (reads the file as monthly-cycle input)
  - `monday-prep.md:91, 171` (runs `tail -30` to extract last week's autonomy targets; runs `wc -l` for log-health threshold)
  - `session-plan.md:106` (cross-references for known-debt tracking)
  - `log-sweep.md:201` (treats the file as Cat A2 with `split-log.sh ... bottom`, KEEP=10 sessions)
  - `docs/weekly-cadence.md:31, 49` (reads autonomy axes)
  - `docs/repo-architecture.md:61, 215` (declares the file's writer as `/friday-act` only)
- The Step 7 append introduces a new writer (`/tweak`) and a new schema (single-bullet line, no session-block header) into a file whose current consumers assume `## YYYY-MM-DD — Friday Act` session blocks. This is a contract change for 7 consumers, but the change is additive (bullets between session blocks) rather than format-breaking. Three consumers (`log-sweep`, `monday-prep`, `docs/repo-architecture`) require update to remain accurate — see Dimension 5.

### Dimension 4: Reversibility
**Risk:** Medium

- The new file itself is single-file; `git revert` cleans it up cleanly.
- The auto-symlinks created across N projects are not in git — `auto-sync-shared.sh` creates project-side symlinks at next SessionStart. Reverting the command file does NOT remove already-created symlinks; they become broken symlinks that `[ -e "$target" ] || [ -L "$target" ] && continue` (auto-sync-shared.sh:88) treats as "already present, skip" forever. Evidence: hook idempotency guard checks `-L` (symlink exists) before recreating. Cleanup requires manual `find projects -name 'tweak.md' -type l -delete` after revert.
- Step 7 appends are append-only mutations to `maintenance-observations.md`. Each successful `/tweak` invocation between landing and revert leaves a bullet-line residue. `git revert` of the command file does not retroactively remove those lines — they require a separate cleanup commit.
- Step 6 pushes autonomously. Once pushed, the canonical-side file lives in origin. Revert is still a `git revert` + push, but the change has propagated.
- Operator muscle memory: low — new command, no displacement of existing workflow.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Schema mismatch with `log-sweep.md:201`.** `maintenance-observations.md` is registered as Cat A2 with `split-log.sh ... bottom`, KEEP=10. `split-log.sh` archives by `## ` headers (session blocks). The Step 7 bullets land between session blocks with no header of their own. After `log-sweep` runs, bullets attached to an archived session block get archived along with it (silent data loss for `/tweak` audit trail); bullets between the bottom-10 sessions and the file head accumulate indefinitely and may be archived to the wrong session. Evidence: `log-sweep.md:201` "KEEP values: 10 for ... maintenance-observations"; `friday-act.md:298` confirms current writer creates header-3-or-deeper structured session blocks (e.g., `## 2026-05-08 — Friday Act`).
- **Schema mismatch with `monday-prep.md:91`.** `tail -30 "$AI_RESOURCES/logs/maintenance-observations.md"` extracts "the most recent autonomy-axis targets" assuming a session-block tail. If `/tweak` is invoked frequently mid-week, the tail-30 window will contain `/tweak` bullets rather than the Friday axis block, breaking the autonomy-axis extraction. Evidence: `monday-prep.md:94` "extract the most recent autonomy-axis targets and print them for the operator" — the parsing assumption holds only when the file tail is Friday-Act content.
- **`docs/repo-architecture.md:215` documentation drift.** The architecture doc declares `maintenance-observations.md` is written by `/friday-act` (single writer). Adding `/tweak` as a second writer without updating this entry creates a load-bearing documentation falsehood that `/placement` and `/audit-claude-md` rely on. Evidence: `docs/repo-architecture.md:215` "Repo-health observations from `/friday-act`" — single-writer claim.
- **Auto-symlink + frontmatter assumption.** The proposed file declares `model: sonnet` frontmatter (proposal line 61). The auto-sync hook does not enforce or validate frontmatter — it just symlinks. This is consistent with how other shared commands behave (no coupling issue), but the frontmatter binds `/tweak` to Sonnet whenever invoked in a project that has bypass-permission mode, including downstream tweaks to project-local copies of canonical files. Evidence: workspace `CLAUDE.md` § Model Tier permits per-command `model:` frontmatter. Low-coupling sub-finding, not load-bearing.
- **Ambiguous-target collision with `improve`.** Step 2 resolves `<target-name>` across three surfaces (`.claude/commands/`, `skills/`, `.claude/agents/`). The proposal's own verification test 6 (`create-a-implementation-proposal-cozy-cascade.md:254`) flags `/tweak improve "..."` as a multi-match case requiring operator clarification. Documented in proposal; mitigated by the STOP. Acceptable.
- **Overlap with `/improve-skill`.** The scope gate (Step 2) and ESCALATE return path are the two routing layers between `/tweak` and `/improve-skill`. The proposal's risk #2 ("scope-gate evasion") held this at two layers, which is sufficient by the System Owner verdict (`create-a-implementation-proposal-cozy-cascade.md:212`). Acceptable.

## Mitigations

- **Dimension 5 (High → Medium): Pick one schema fix before Step 7 lands.** Either (a) emit a dedicated `## YYYY-MM-DD — /tweak invocations` section that aggregates bullets per day, so `split-log.sh` archives them as one unit and `monday-prep`'s `tail -30` still hits the latest Friday block when no tweaks land on Mondays, OR (b) redirect `/tweak`'s audit append to a sibling file (`logs/tweak-log.md`) and add it to `log-sweep.md`'s Cat A2 list with its own KEEP value. Decision recorded in `tweak.md` Step 7 with the chosen target. Recommended: (a) — keeps the maintenance-observations Friday-cadence integration intact but namespaces the writer.
- **Dimension 5 (High → Medium): Update `docs/repo-architecture.md:215` in the same commit as `tweak.md` lands.** Change the writer column from "`/friday-act`" to "`/friday-act`, `/tweak`" (or the chosen redirect target if mitigation (b) is picked). Per `repo-architecture.md` "When this file needs to change" section line 240, "A new cross-repo coupling point" requires same-commit update.
- **Dimension 5 (High → Medium): Update `monday-prep.md:91, 94` parsing window if (a) is chosen.** Change the autonomy-axis extraction from `tail -30` to a header-anchored grep (e.g., `awk '/^## .* — Friday Act/{p=1} p' | tail -n +1`) so `/tweak` bullets between Friday blocks do not push the axis block out of the parsing window. Skip this mitigation if (b) is chosen.
- **Dimension 3 (Medium → Low, optional): Add `tweak` to `EXCLUDE_COMMANDS` in `auto-sync-shared.sh:46` if project-side `/tweak` invocations are not intended.** The proposal states "No project-level deployment beyond the auto-sync above" — but auto-sync IS project-level deployment for shared commands. If the intent is canonical-only, baked-in exclude is one line; if cross-project invocation is intended (operator inside a project can `/tweak` a canonical file via the symlink), leave as-is. Recommended: leave as-is — `/tweak` invoked from a project session edits the canonical file through the symlink, which is the desired behavior. State the choice explicitly in commit message.
- **Dimension 4 (Medium → Low, optional): On revert, document the cleanup sequence in the commit message of the revert.** Specifically: (1) revert `tweak.md`, (2) run `find projects -name 'tweak.md' -type l -delete`, (3) decide whether to retain or strip accumulated bullets from `maintenance-observations.md` (or `tweak-log.md`). This is documentation discipline, not a code change.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from `create-a-implementation-proposal-cozy-cascade.md` or referenced files). Specifically: 7-consumer grep count for `maintenance-observations`, hook idempotency guard at `auto-sync-shared.sh:88`, schema-writer declaration at `repo-architecture.md:215`, `tail -30` parsing assumption at `monday-prep.md:91`, KEEP=10 Cat A2 treatment at `log-sweep.md:201`, 158-line `improve-skill.md` comparison baseline. No training-data fallback used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Function B — Pre-change advisory

## Concurrence with PROCEED-WITH-CAUTION

We concur. The risk-check verdict is correctly calibrated. The Step 7 append shape — single bullet lines between `## ` session-block headers — is a documented contract violation against three live consumers (`split-log.sh` via `log-sweep.md:201`, `monday-prep.md:91` `tail -30`, `docs/repo-architecture.md:215` single-writer claim), and all three pieces of evidence verify in-file.

Dimension 5 = High is the right read. The mitigations are necessary, not optional; landing the command without them creates silent data loss (split-log archives tweak bullets attached to the preceding Friday-Act block) and silent parse drift (monday-prep tail-30 stops seeing the latest autonomy block once tweak frequency rises). Cited: `risk-topology.md § 5 Signals that elevate to structural risk` — "Change modifies a string literal matched by another component (two-end contract)."

## The original SO-CHANGE-3 was too coarse

SO-CHANGE-3 was grounded in `system-doc.md § 4.5` (loops close at Friday review) + OP-3 (loud-not-silent). That grounding is correct in spirit — the audit trail must be visible somewhere — but it conflated two distinct things: *a `/tweak` invocation audit record* and *a `/friday-act` repo-health observation*. They share a possible file but not a contract. The first consult routed a new writer into an existing single-writer file without checking the file's downstream parse contract — which is the defect Dimension 5 surfaced.

## Recommended mitigation: (b), not (a)

The right answer is mitigation (b) — `/tweak` writes to a new `logs/tweak-log.md`, registered in `log-sweep.md` Cat A2 with its own KEEP, and added as a new row in `docs/repo-architecture.md` Q6 log table.

Grounding:

1. **`repo-architecture.md § Q6 log table` is the canonical pattern.** Each writer × purpose pair gets its own log file. The Q6 table currently enumerates 13 logs, each with one declared writer and one purpose. `/tweak`'s audit trail is a distinct purpose (per-invocation record of cosmetic edits) from `/friday-act`'s purpose (per-Friday repo-health observations). One file = one purpose = one writer is the documented rule, not a preference. (`repo-architecture.md § Q6`, `system-doc.md § 4.2 — operational logs`)

2. **DR-7 / AP-7 — no shared infrastructure without a confirmed second consumer.** Mitigation (a) reuses `maintenance-observations.md` for an audit-trail purpose it was not designed for. There is one writer-purpose pairing today (Friday-Act observations); adding `/tweak` invocations creates a second purpose carried on the same file. That is shared interface without a confirmed downstream consumer that needs the sharing — exactly the speculative-shortcut pattern DR-7 and AP-7 prohibit. (`principles.md § DR-7`, `principles.md § AP-7`)

3. **OP-3 — semantic overloading is silent coupling.** Under (a), `maintenance-observations.md` would carry two block-shape contracts (`## YYYY-MM-DD — Friday Act` and `## YYYY-MM-DD — /tweak invocations`), distinguished only by the header text suffix. Every future consumer of this file must learn the suffix discriminator. That is the hidden coupling OP-3 says to surface, not encode by convention. (`principles.md § OP-3`)

4. **Smaller blast radius.** (b) changes 3 files in the same commit: new `logs/tweak-log.md`, `log-sweep.md` Cat A2 row, `docs/repo-architecture.md` Q6 row. (a) requires the same `repo-architecture.md` row change PLUS a `monday-prep.md:91` parse-window rewrite PLUS unverified re-checks of `so-monthly.md:22` and `session-plan.md:106` semantics (see "missed risks" below). (b) is the cheaper change with the cleaner contract. (`risk-topology.md § 3 — Risk Classification by Change Type`: new command/agent edit class; minimize surface)

The reviewer recommended (a). We disagree with the recommendation while concurring with the underlying risk classification — and we name the disagreement explicitly per OP-3.

## Risks the dimension review did not surface

1. **`so-monthly.md:22` ingestion under (a).** The reviewer enumerated this consumer in Dimension 3 but did not carry it into Dimension 5. `so-monthly` reads `maintenance-observations.md` as a monthly-cycle input. Under (a), monthly-review synthesis would ingest `/tweak`-invocation bullets as if they were Friday-Act repo-health observations. Under (b), unaffected. (`grounding.md § 2 Function G read map` — `so-monthly` brief includes this file)

2. **`session-plan.md:106` known-debt tracking under (a).** Same shape. The cross-reference treats `maintenance-observations.md` blocks as known-debt entries. Under (a), tweak bullets enter that ledger silently. Under (b), unaffected.

3. **Semantic-overload risk distinct from schema-mismatch risk.** The reviewer surfaced the schema mismatch (the parser-visible defect). The deeper risk — two semantic contracts in one file distinguished only by header-suffix string — is unsurfaced and is the OP-3 violation that survives the parse-window fix.

4. **DR-7 / AP-7 angle.** The reviewer treated the file-choice as a schema question. It is also a generalization-discipline question — and the principles answer is: no shared interface without a confirmed second consumer.

## Position

The right answer is: mitigation (b). Land `/tweak` with Step 7 writing to `ai-resources/logs/tweak-log.md`, in the same commit add the Q6 log-table row in `docs/repo-architecture.md` and the Cat A2 row in `log-sweep.md` (with KEEP=10 as a default, adjustable at first Friday review). `maintenance-observations.md` keeps its `/friday-act`-only single-writer contract intact. No `monday-prep` parsing change required, no `so-monthly`/`session-plan` consumer re-check required.

If the operator prefers (a) for one-file-locality reasons, that is an operator override of a documented principle (DR-7 + OP-3 + Q6 log-table pattern). The trade-off is: simpler file layout today; semantic overloading and four-consumer parse-contract recheck risk forward. The System Owner names the conflict and stops there.
