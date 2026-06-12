# Risk Check — 2026-06-12

## Change

Executed change set for session 2026-06-12 S11: (1) Edited canonical command ai-resources/.claude/commands/resolve-repo-problem.md — three additions, all applied: top note rewritten into a routing rule (triage front door → /resolve-incident fix-path handoff; supersedes the 2026-05-28 note); new MANUAL Step 3a emitting a `Fix path: /resolve-incident "..."` bridge line when the subagent's recommended option is Quick patch or Structural fix (suppressed on Defer), citing NOTES_PATH and appending ` [risk-check class]` when flagged; new AUTO step F emitting the same bridge as final chat line when step C's fix is actionable, inline diagnosis only (no notes path — AUTO writes none), flag read from step C, offer-only. The `### Improvement-log entry schema` heading and improvement-log field names verified byte-identical/unchanged post-edit; resolve-incident.md not edited. (2) New file projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-merge-resolve-repo-problem-resolve-incident.md — SO advisory persisted per /consult Step 5a recovery (provenance header included; plan mode had blocked the agent's own write). (3) New risk-check report audits/risk-checks/2026-06-12-bridge-resolve-repo-problem-to-resolve-incident.md (plan-time gate output, verdict GO). Plan-time /risk-check returned GO; post-edit independent QC returned GO (both this session). This is the end-time batch gate before commit.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-repo-problem.md — exists (edited)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-incident.md — exists (not edited; consumer of the schema anchor)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-merge-resolve-repo-problem-resolve-incident.md — exists (new)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-06-12-bridge-resolve-repo-problem-to-resolve-incident.md — exists (new, plan-time report)

## Verdict

GO

**Summary:** The executed change matches the GO-verdict plan exactly — a chat-output-only routing/bridge edit to one canonical command, with the single parse-anchor a sibling command depends on (`### Improvement-log entry schema`) verified intact and the MANUAL/AUTO NOTES_PATH distinction implemented correctly; no permission, hook, log-schema, or contract change, 0 must-change consumers.

## Consumer Inventory

The edited target is `resolve-repo-problem.md`. Two contract surfaces matter: (a) the command's *invocation* by operators/docs, and (b) the `### Improvement-log entry schema` heading that `resolve-incident.md` Step 31 anchors to (verbatim-shape contract at `resolve-incident.md` lines 199). Verified against the executed file: the change touches neither — it adds the routing-rule note (line 6), MANUAL Step 3a (lines 78–90), and AUTO step F (lines 112–118), and leaves the schema heading (line 122) and field names (lines 127–135) intact. Live consumers from repo+workspace grep on `resolve-repo-problem` (excluding logs/scratchpads/snapshots/audits/archives, which only *mention* the name in history):

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/resolve-incident.md | parses (Step 31 anchors to `### Improvement-log entry schema` heading in resolve-repo-problem.md) | no — heading + field names verified byte-identical post-edit |
| ai-resources/.claude/commands/resolve-incident.md | documents (description + Step 6 name `/resolve-repo-problem` as the triage-only sibling) | no — sibling relationship unchanged |
| ai-resources/.claude/commands/friday-checkup.md | parses (matches `Category: session-issue` + `Status: logged (pending)` entries this command writes) | no — improvement-log entry shape untouched |
| ai-resources/.claude/commands/fix-repo-issues.md | documents (names `/resolve-repo-problem` to draw a batch-planning boundary) | no — boundary unchanged |
| ai-resources/docs/protected-zones.md | documents (`.claude/commands/*.md` shared zone; improvement-log schema two-end contract) | no — schema block not edited |
| ai-resources/docs/commit-discipline.md | documents (names the command in commit-boundary prose) | no |
| projects/{ai-development-lab, axcion-brand-book, interpersonal-communication, marketing-positioning, nordic-pe-screening-project, positioning-research, project-planning, repo-documentation, research-pe-regime-shift-advisory-gap, strategic-os}/.claude/commands/resolve-repo-problem.md | imports (relative/absolute symlink to canonical file — all 10 confirmed via `readlink`) | no — symlinks resolve to the edited canonical; no per-project change |

Total: 6 distinct live ai-resources consumer surfaces + 10 project symlinks = 16 consumers, **0 must-change**. (Historical mentions in `logs/`, `scratchpads/`, `audits/`, `repo-snapshot.md`, `archive/`, and the SO consultation are records, not contracts — excluded from must-change scoring.) The `### Improvement-log entry schema` heading is the single most consumer-sensitive surface; the executed file preserves it byte-for-byte.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change edits a command body (`ai-resources/.claude/commands/resolve-repo-problem.md`), not an always-loaded file. Command `.md` files load only on invocation, not every turn — no per-turn token cost.
- No hook registered. The executed additions (lines 6, 78–90, 112–118) are prose/bridge lines inside the command; no SessionStart/Stop/PreToolUse/UserPromptSubmit registration appears.
- Net body growth is a rewritten note plus two short bridge steps in a command already ~145 lines — pay-as-used, fires only when `/resolve-repo-problem` runs.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json edit, no allow/ask/deny change. The change set names only `resolve-repo-problem.md` as the edited harness file; the two new files are an SO advisory and a risk-check report under `output/`/`audits/`.
- No new tool-invocation pattern. The bridge is an operator-facing chat line — MANUAL Step 3a line 90 ("do not invoke `/resolve-incident`") and AUTO step F line 118 ("may *offer* the fix via this bridge, never perform it") both confirm offer-only; no new Bash/Write/external-API capability.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Consumer Inventory: 16 consumer surfaces (6 ai-resources + 10 symlinks), **0 must-change**. No caller requires modification to keep working.
- One file edited directly (`resolve-repo-problem.md`); `resolve-incident.md` confirmed not edited.
- The one parse-contract — `resolve-incident.md` Step 31 anchoring to `### Improvement-log entry schema` — is verified preserved in the executed file (heading at line 122, fields at 127–135 unchanged). This neutralizes the exact "prose edit removes a heading used as a parser target" elevation signal the SO advisory flagged.
- `friday-checkup.md`'s matcher on `Category: session-issue` + `Status: logged (pending)` is unaffected — the entry shape this command writes (lines 126–136) is unchanged.
- Auto-sync via symlink confirmed for all 10 projects (`readlink` output). The edit propagates instantly, but as additive chat output with no contract change it carries no breakage. No inventory consumer was unanticipated by the change description.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file prose edit. `git checkout HEAD -- ai-resources/.claude/commands/resolve-repo-problem.md` (or `git revert` of the landing commit) fully restores prior state in the same working tree — no generated artifacts that revert would leave behind.
- The two new files (SO advisory, plan-time risk-check report) are append-only records, not state mutations; leaving them after a revert of the command edit causes no functional drift (they document the decision). No log-data mutation: the change writes nothing to improvement-log.md / incident-log.md at edit time — it only changes what the command *emits to chat* at future runtime.
- No state propagates beyond git: push is gated to wrap, no external write, no hook/cron/symlink added. Existing symlinks are unchanged and reflect a revert immediately.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The bridge's one cross-component dependency — `resolve-incident.md` as the named fix path — is explicit in the executed text (the `Fix path: /resolve-incident "..."` line, lines 85 and 115), not implicit. This is the documented `instruct-operator` mechanism; no silent contract introduced.
- The AUTO/MANUAL NOTES_PATH split — the one coupling trap the SO review pass flagged as blocking (AP-2 fabricated reference) — is implemented correctly in the executed file: MANUAL Step 3a cites `{NOTES_PATH}` (line 85, and MANUAL does write that file at line 37); AUTO step F carries "inline diagnosis text only — never cite a notes path" (line 118), because AUTO writes no working-notes file (line 108). Verified, not just described.
- Emission condition is bound to the enumerated recommended option — emit on Quick patch / Structural fix, suppress on Defer (lines 81–82) — not an undecidable "executable in-session" judgment, removing silent-misfire risk.
- No functional overlap: the bridge routes *to* `/resolve-incident` rather than duplicating its fix machinery, preserving the advisory-vs-enforcement separation.

### Dimension 6: Principle Alignment
**Risk:** Low

- Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read cleanly; full frozen IDs available).
- **DR-7 / AP-7 / OP-9 (speculative abstraction):** the change *avoids* the violation. The rejected alternative (merge the two commands into a shared-core abstraction) was the n=2 speculative-generalization move; the executed change routes-not-merges and adds no consumer-less contract — it points at an *existing* command. Aligned.
- **OP-5 / OP-2 / OP-3 (advisory vs enforcement; gate judgment; loud over silent):** the bridge is offer-only (lines 90, 118), preserving the operator's explicit re-invoke as the gate-preserving turn rather than sliding AUTO mode from detection into auto-fix. The fix-by-default shape (which would skip `/resolve-incident`'s `/risk-check` gate) was rejected outright. Actively serves these principles.
- **DR-8 (risk-check forwarding):** the executed bridge forwards the `/risk-check`-class flag (` [risk-check class]` appended, lines 88 and 118), so a downstream fix enters with the structural-class signal intact.
- **DR-1 / DR-3 (placement):** in-place edit to an existing canonical command; no new resource, no tier change. The two new files sit in their canonical homes (`output/consultations/`, `audits/risk-checks/`). No placement question.
- **OP-12 (closure before detection):** the change adds no new detection; it improves *closure routing* of already-detected faults toward the fix pipeline. Counts for the change.
- This is the `/risk-check` change class "canonical command edit" (DR-8; `protected-zones.md`), so end-time gating it is itself principle-compliant.

## Mitigations

(Verdict is GO — no mitigations required. Two landing-commit checks the executed state already satisfies, carried forward only for the commit diff:)

- The `### Improvement-log entry schema` heading text is byte-identical (verified at line 122) — keep it so in the staged diff; `resolve-incident.md` Step 31 anchors to it.
- The AUTO-mode bridge cites no NOTES_PATH and the MANUAL bridge does (verified at lines 115 vs 85) — the two modes differ here by design; preserve the distinction.

## Recommended redesign

(Not applicable — verdict is GO.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence from the executed files: `resolve-repo-problem.md` read in full (note at line 6; MANUAL Step 3a lines 78–90; AUTO step F lines 112–118; schema heading line 122, fields 127–135; NOTES_PATH set line 37); `resolve-incident.md` Step 31 (line 199) and Step 2; the SO advisory and plan-time risk-check report read in full; principle IDs cited from the readable `principles-base.md`; consumer inventory built by repo+workspace grep on `resolve-repo-problem`; all 10 project symlinks resolved via `readlink`. No training-data fallback was used.
