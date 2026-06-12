# Risk Check — 2026-06-12

## Change

Edit canonical command ai-resources/.claude/commands/resolve-repo-problem.md (auto-synced to all projects): add a "Fix path: /resolve-incident" bridge line emitted at end of MANUAL Step 3 (when recommended option is Quick patch or Structural fix, suppressed on Defer; cites NOTES_PATH; forwards any /risk-check-class flag) and at end of AUTO step E (inline diagnosis only, no NOTES_PATH; flag threads from step C; offer-only, never performs the fix), plus rewrite the 2026-05-28 top note into the routing rule (triage front door → fix path handoff). Chat-output-only additions; the `### Improvement-log entry schema` heading and improvement-log field names are untouched; resolve-incident.md not edited. SO Function B advisory + ENDORSE-WITH-CHANGES review pass and independent QC (REVISE findings applied) already completed this session; full advisory at projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-merge-resolve-repo-problem-resolve-incident.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-repo-problem.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-incident.md — exists (NOT edited by this change; bridge target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-merge-resolve-repo-problem-resolve-incident.md — exists

## Verdict

GO

**Summary:** A chat-output-only routing/bridge edit to one canonical command that adds no log-schema, permission, hook, or contract change; the one heading-anchor contract a downstream command depends on is explicitly preserved, and the SO advisory's three review changes are already baked into the described plan.

## Consumer Inventory

The change target is `resolve-repo-problem.md`. Two contract surfaces matter: (a) the command's *invocation* by operators/docs, and (b) the `### Improvement-log entry schema` heading that `resolve-incident.md` Step 31 anchors to. The change touches neither contract — it adds chat-output bridge lines and rewrites a prose note. Live consumers (commands/agents/hooks/docs in `ai-resources/`, excluding logs/scratchpads/snapshots which merely *mention* the command name in history):

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/resolve-incident.md | parses (Step 31 anchors to `### Improvement-log entry schema` heading in resolve-repo-problem.md) | no — heading + field names explicitly untouched |
| ai-resources/.claude/commands/resolve-incident.md | documents (description + Step 6 name `/resolve-repo-problem` as the triage-only sibling) | no — sibling relationship unchanged |
| ai-resources/.claude/commands/friday-checkup.md | parses (Step at line 311 matches `Category: session-issue` + `Status: logged (pending)` entries written by this command) | no — improvement-log entry shape untouched |
| ai-resources/.claude/commands/fix-repo-issues.md | documents (lines 17, 289 name `/resolve-repo-problem` to draw a boundary vs batch-planning) | no — boundary unchanged |
| ai-resources/.claude/commands/consult.md | documents (line 8 names resolve-incident.md as a designed `/consult` caller) | no — consult path untouched |
| ai-resources/docs/protected-zones.md | documents (`.claude/commands/*.md` shared zone; improvement-log schema-block two-end contract naming both commands) | no — schema block not edited; command is doc-edit class |
| ai-resources/docs/repo-architecture.md | documents (names `audits/incidents/`, `logs/incident-log.md` as `/resolve-incident`-written) | no — bridge is chat-output-only, writes nothing |
| ai-resources/docs/commit-discipline.md | documents (names the command in commit-boundary prose) | no |
| ai-resources/templates/README.md | documents (names the command) | no |
| projects/*/.claude/commands/resolve-repo-problem.md (symlinks) | imports (relative symlink to canonical file — confirmed e.g. project-planning) | no — symlink resolves to edited canonical; no per-project change |

Total: 10 distinct live-consumer surfaces, 0 must-change. (Historical mentions in `logs/`, `scratchpads/`, `repo-snapshot.md`, `archive/`, and the SO consultation are records, not contracts — excluded from must-change scoring.) The `### Improvement-log entry schema` heading — the one parse-anchor a sibling command depends on (`resolve-incident.md` Step 31, with a verbatim-shape contract comment) — is the single most consumer-sensitive surface, and the change description explicitly states it is untouched.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change edits a command body, not an always-loaded file. Command `.md` files load only on invocation (`/resolve-repo-problem`), not every turn — no per-turn token cost. Evidence: target is `ai-resources/.claude/commands/resolve-repo-problem.md`, a slash-command definition, not a CLAUDE.md or `@import` target.
- No hook is registered. The change is described as "Chat-output-only additions" — no SessionStart/Stop/PreToolUse/UserPromptSubmit registration.
- The additions are a few bridge lines plus a note rewrite inside a command already 122 lines long; pay-as-used, fires only when the command runs.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json edit, no allow/ask/deny change. The change is confined to one command's prose. Evidence: CHANGE_DESCRIPTION names only `resolve-repo-problem.md` as edited and is "Chat-output-only."
- No new tool-invocation pattern. The bridge is an operator-facing chat prompt ("offer-only, never performs the fix"), not a new Bash/Write/external-API capability. Confirmed by the SO advisory: "slash commands can't invoke each other, so the bridge is an operator-facing prompt, not a programmatic call."

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Consumer Inventory: 10 distinct live-consumer surfaces, **0 must-change**. No caller requires modification to keep working.
- Single file touched directly (`resolve-repo-problem.md`); `resolve-incident.md` explicitly not edited.
- The one parse-contract in the inventory — `resolve-incident.md` Step 31 anchoring to `### Improvement-log entry schema` (lines 100, 199 carry the verbatim-shape contract) — is preserved: CHANGE_DESCRIPTION states "the `### Improvement-log entry schema` heading and improvement-log field names are untouched."
- The `friday-checkup.md` line-311 matcher on `Category: session-issue` + `Status: logged (pending)` is unaffected — the entry shape the command writes is not changed.
- Auto-sync via relative symlink is confirmed (e.g. `projects/project-planning/.claude/commands/resolve-repo-problem.md -> ../../../../ai-resources/.claude/commands/resolve-repo-problem.md`). The edit propagates to every project the instant the canonical file changes — but since the change is additive chat output with no contract change, propagation carries no breakage. No inventory consumer was unanticipated by CHANGE_DESCRIPTION.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file prose edit. `git revert` (or `git checkout HEAD -- ai-resources/.claude/commands/resolve-repo-problem.md`) fully restores prior state in the same working tree — no sibling files, no generated artifacts.
- No data/log mutation. The change writes nothing to improvement-log.md, incident-log.md, or any append-only file at edit time; it only changes what the command *emits to chat* at future runtime.
- No state propagates beyond git: no push at change time (push is gated to wrap), no external write, no hook/cron/symlink added. The existing symlinks are unchanged; revert of the canonical file is immediately reflected through them.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The bridge's one cross-component dependency — `resolve-incident.md` as the named fix path — is explicit in the change, not implicit. The operator-facing handoff names the target command in chat; no silent contract is introduced. This is the documented `instruct-operator` mechanism per the SO advisory.
- The AUTO-mode bridge correctly avoids the one coupling trap the review pass flagged: it carries "inline diagnosis only, no NOTES_PATH" — AUTO mode writes no working-notes file, so citing one would be a dangling reference (AP-2). CHANGE_DESCRIPTION confirms the AUTO bridge omits NOTES_PATH. The MANUAL bridge cites NOTES_PATH, which AUTO does write (MANUAL Step 1 sets `NOTES_PATH`; line 37).
- The emission condition is bound to the enumerated recommended option (emit on Quick patch / Structural fix, suppress on Defer) rather than an undecidable "executable in-session" judgment — removing the silent-misfire risk a fuzzy condition would create.
- No functional overlap is introduced: the bridge routes *to* `/resolve-incident` rather than duplicating its fix machinery, preserving the advisory-vs-enforcement separation rather than blurring it.

### Dimension 6: Principle Alignment
**Risk:** Low

- Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read cleanly; full IDs available).
- **DR-7 / AP-7 / OP-9 (speculative abstraction):** the change *avoids* the violation. The rejected alternative (merge the two commands into a shared-core abstraction) was the speculative-generalization-at-n=2 move; the SO advisory explicitly routes-not-merges. The bridge adds no abstraction and no consumer-less contract — it points at an *existing* command. Aligned.
- **OP-5 / OP-2 / OP-3 (advisory vs enforcement; gate judgment; loud over silent):** the bridge is "offer-only, never performs the fix." It preserves the operator's explicit re-invoke as the gate-preserving turn rather than sliding AUTO mode from detection into auto-fix. This actively serves OP-5/OP-2 rather than eroding them — the fix-by-default shape (which would skip `/resolve-incident`'s `/risk-check` gate, an OP-3/DR-8 violation) was rejected outright.
- **DR-8 (risk-check forwarding):** the bridge "forwards any /risk-check-class flag," so `/resolve-incident` and the operator enter a downstream fix with the structural-class signal intact — aligned with DR-8 rather than dropping it.
- **DR-1 / DR-3 (placement):** no new resource, no tier change — an in-place edit to an existing canonical command. No placement question.
- **OP-12 (closure before detection):** the change adds no new detection; it improves *closure routing* of already-detected faults toward the fix pipeline. Counts for the change.
- This is the `/risk-check` change class "canonical command edit" (DR-8; `protected-zones.md` line 16), so gating it is itself principle-compliant.

## Mitigations

(Verdict is GO — no mitigations required. Two advisory notes the operator already has covered, carried forward only for the landing commit:)

- Keep the `### Improvement-log entry schema` heading text byte-identical — `resolve-incident.md` Step 31 and its verbatim-shape contract comment anchor to it. CHANGE_DESCRIPTION confirms this is the plan; verify in the diff before commit.
- Confirm the AUTO-mode bridge cites no NOTES_PATH (AUTO writes no notes file) and the MANUAL bridge does cite it — the two modes differ here by design.

## Recommended redesign

(Not applicable — verdict is GO.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: command bodies read at the cited line numbers (`resolve-repo-problem.md` lines 37, 80, 92, 100, 199; `resolve-incident.md` Steps 2/31; `friday-checkup.md` line 311; `protected-zones.md` line 16), the symlink resolution verified by `ls -la`, the consumer inventory built by repo-wide + workspace-wide grep, and principle IDs cited from the readable `principles-base.md`. No training-data fallback was used.
