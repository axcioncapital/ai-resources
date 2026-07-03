# Risk Check — 2026-07-03

## Change

Rewrite of `ai-resources/.claude/commands/prime.md` (Critical-tier canonical session-orientation command; the workspace-root copy `/.claude/commands/prime.md` is a symlink to it — confirmed `lrwxr-xr-x`, so no lockstep edit needed). Three coupled changes, all at the display/menu-generation layer only:

(1) **Same-repo mission filter.** Step 5 builds a `[mission:<id>]` menu candidate ONLY for missions whose `repo == CWD_REPO`; Step 6's `◎ Active mission(s)` brief line lists same-repo missions only. Step 1d's multi-repo mission scan (collects missions from CWD_REPO + ai-resources + all sibling project repos) is left UNTOUCHED, and the Step 8a sub-step-a0 / Step 8c sub-step-2.5 cross-repo mission guards are left UNTOUCHED as defense-in-depth. The now-dead cross-repo render clause at line 187 (`[mission: <id> — in <repo-basename>]`) is removed since the filter means no cross-repo mission can reach that render.

(2) **Always-show model.** Step 4 model-alignment check changes from mismatch-only to always carried to Step 6: plain `Model: {session model}` on match, `⚠ Model: you are on {x}; this project recommends {y} → /model {y}` on mismatch. Step 4 line ~169 gains a note that model-alignment is the one check always carried (others stay abnormal-only).

(3) **Brief trim.** Delete these Step 6 display lines: Last-session summary line, unfinished-carryover paragraph, `⚠ Needs a fix` urgent-duplicate line (the urgent item still appears as a top-ranked `[urgent]` menu entry — only the duplicate prose line is cut), `Today's session count` info line, `↩ Resumable scratchpad` line, and the static `/mission create` tip line. KEEP all `⚠` warning lines (working tree, pull/autostash, both concurrent-session lines, phase-READMEs) AND the QC-PENDING commit-block advisory — the latter is made EXPLICIT in the template (it was previously only implied by Step 6's general framing). Lockstep prose-consistency fixes land in the same edit: Step 1a lines ~92/99 (retire the "Step 6 emits session-count" prose but keep SIBLING_COUNT's computation, which still gates the shared-file advisory), Step 1b line ~136 (reword the generic scratchpad-display clause ONLY — explicitly NOT line 137's QC-PENDING advisory), Step 6 intro line ~193 (drop "the summary," from the displayed-text list), and delete the now-dangling first-session fallback at line ~229.

Design intent: reduce brief verbosity + stop surfacing cross-project missions the operator can't act on from the current checkout, while preserving all safety warnings and all downstream data-collection steps (carryover menu feed, scratchpad menu feed, SIBLING_COUNT gating). Explicitly NOT changed: Step 8m interactive mission-binding prompt still lists all missions (pre-existing asymmetry, out of scope this pass).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/prime.md — exists (symlink to the above; confirmed `lrwxr-xr-x -> ../../ai-resources/.claude/commands/prime.md`)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md — exists

## Verdict

GO

**Summary:** A display-layer-only trim + same-repo mission filter on a single symlink-fronted command file; no external component parses the brief output, no disk contract is touched, and every removed line's safety/actionable content is preserved elsewhere — the only elevated dimension is Hidden Coupling (Medium), driven by two minor new intra-file consistency gaps.

## Consumer Inventory

Search terms derived from the change: brief stems `Active mission`, `Resumable scratchpad`, `Last session`, `session count`, `Needs a fix`, `mission create`; contract markers `[mission:` tag, `repo-basename` render clause, brief icons `◎`/`↩`; component `/prime` / `prime.md`. Greps run across `{AI_RESOURCES}/.claude`, `docs`, `skills`, and the workspace root (`{AI_RESOURCES}/..`), positive-controlled against `.session-marker` (13 hits — grep confirmed working after an initial word-split-on-spaces false-empty was corrected).

**Key finding — the changed surfaces have zero external consumers.** `/prime`'s Step 6 brief is ephemeral operator-facing chat text; it is never written to disk, so no command/agent/hook/doc can parse it. Grep for the brief icons (`◎ Active`, `↩ Resumable`, `↩ Unfinished`), the `[mission:` tag render form, and `repo-basename` returned **no hits outside `prime.md`**. The ~45 files that name `/prime` reference it by invocation or consume its **disk contracts** (marker files, session-notes headers, mandate-line, plan-file glob) — none of which this change touches.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/prime.md` Step 8m (mission binding) | parses `[mission:<id>]` menu-item tag (same file) | no — same-repo `[mission:<id>]` items still bind; only cross-repo candidates are now absent from the menu |
| `.claude/commands/prime.md` Step 8a-a0 / 8c-2.5 (cross-repo guards) | co-edits (same file) | no — explicitly left as defense-in-depth; still fire if a cross-repo mission ever reaches a pick |
| `.claude/commands/prime.md` Step 1d (ACTIVE_MISSIONS scan) | co-edits (same file) | no — explicitly untouched; still scans all repos |
| `/.claude/commands/prime.md` (workspace-root copy) | imports (symlink) | no — symlink auto-follows the canonical edit |
| `docs/backlog-reconciliation.md` | documents (Step 1a git-cross-check is its reference impl) | no — change touches Step 1a SIBLING_COUNT prose (~92/99), NOT the synced scan/classify logic (lines 62-88) |
| `docs/session-marker.md` | documents (`/prime` writer-steps + plan-filename refs) | no — change touches no marker write, header format, or plan-filename scheme |
| `session-start.md`, `session-plan.md`, `wrap-session.md` (×2), `drift-check.md`, `contract-check.md`, `open-items.md`, `concurrent-session-check.md`, `decide.md`, `fix-repo-issues-scanner.md` | invokes / parses disk contracts (marker, header, mandate-line, plan glob) | no — all consumed contracts are untouched |
| `.claude/hooks/backup-session-plan.sh`, `detect-concurrent-session.sh`, `check-foreign-staging.sh` | parses marker files / plan filenames | no — marker + filename schemes untouched |
| `.claude/commands/mission.md` | shares Step 1a repo-enumeration + `Mission: <id>` bullet convention | no — enumeration and bullet convention untouched |

**Total: consumers of the *changed lines* (Step 6 brief display) = 0 external parsers; broader `/prime` consumers = ~13 disk-contract consumers, all consuming untouched contracts; 0 must-change.** The `session count` / `Needs a fix` / `mission create` grep hits in `session-guide*`, `research-prompt-creator`, and `evaluation-framework.md` are unrelated keyword collisions (research-workflow session counts, skill-QC "every issue needs a fix"), not consumers of `/prime`'s brief.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/prime` is a pay-as-invoked command (`model: sonnet`, run once at session start), not always-loaded content — it is in no CLAUDE.md `@import` chain and registers no hook. Evidence: `prime.md` lines 1-3 frontmatter (`model: sonnet`, no auto-load); it is invoked on demand.
- The change is net-neutral-to-negative on the command file's own token size (removes a render clause + several template lines and a fallback; adds one Step 4 note + one explicit QC-PENDING template line). No always-loaded surface is touched.
- Runtime effect is a *shorter* brief (trim + same-repo mission filter), reducing per-invocation output tokens. Step 1d's multi-repo scan is untouched, so orientation-time compute cost is unchanged (evidence: change description "Step 1d's multi-repo mission scan … is left UNTOUCHED").

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is edited; no `allow`/`ask`/`deny` entry is added, removed, or narrowed. The change is confined to instruction prose in one command `.md`.
- No new tool family or invocation pattern is introduced — `/prime` already uses Bash (git/grep), Read, and Write within established patterns; the display-layer trim invokes no new capability.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: **one** (`prime.md`); the workspace-root copy is a symlink (`lrwxr-xr-x -> ../../ai-resources/.claude/commands/prime.md`), so it auto-follows — no lockstep edit (confirmed via `ls -la`).
- Consumer Inventory (Step 1.5): **0 external consumers of the changed lines**, **0 must-change**. The Step 6 brief is ephemeral chat — grep for its icons/stems/tag returned no hits outside `prime.md`.
- No contract that callers depend on is changed: the marker-write steps (8a/8b/8c), session-notes header format, mandate-line parse contract, and plan-filename scheme are all untouched, so the ~13 disk-contract consumers (`session-start`, `wrap-session` ×2, `drift-check`, `open-items`, the three hooks, etc.) are unaffected.
- Adjacency check cleared: `docs/backlog-reconciliation.md` treats `/prime` Step 1a's git-cross-check (lines 62-88) as its reference implementation and requires lockstep sync — but the change edits Step 1a's SIBLING_COUNT / session-count *prose* at ~92/99, not that scan/classify logic. No `backlog-reconciliation.md` update is triggered.
- Note: `prime.md` is Critical-tier and runs every session, so the *internal* coordination is non-trivial (edit sites span Steps 4, 5, 6, 1a×2, 1b, 187, 229, 193) — but that is an execution-correctness concern (captured under Hidden Coupling), not external reach. Nothing outside the one file breaks.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit tracked in git; `git revert` fully restores prior state. The symlink auto-follows the revert (no separate cleanup).
- No data/log mutation: the change edits command *instructions*, not `session-notes.md`, `improvement-log.md`, or any append-only log. `/prime` "never edits `session-notes.md`" (prime.md line 88) — unchanged.
- No state propagates beyond git (no push, no external write, no automation registered). No operator muscle-memory dependency is introduced (no new command/flag/token — the brief is display-only).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New consistency gap #1 (brief ↔ Step 8m).** After the same-repo filter, the Step 6 `◎ Active mission(s)` line and the Step 5 menu show same-repo missions only, but Step 8m's interactive binding prompt (prime.md line 242) still lists **all** `ACTIVE_MISSIONS`. So on a free-text (8b) dispatch the operator can be offered, in 8m, a cross-repo mission never shown in the brief. The change declares this out-of-scope ("Step 8m interactive mission-binding prompt still lists all missions … out of scope this pass"), but the trim *widens* the pre-existing asymmetry. Advisory, non-blocking (operator can answer `none`), no wrong-repo write (the 8m binding only records the `- Mission:` bullet; the cross-repo *setup* guards at 8a-a0/8c-2.5 remain).
- **New consistency gap #2 (scratchpad visibility now depends on a menu slot).** Removing the standalone `↩ Resumable scratchpad` line means a *non*-QC-PENDING scratchpad is surfaced only if its `## Resume With` line wins one of the 6 capped menu slots (prime.md line 136: "strong candidate for menu item 1"; ranking = carryover tier, line 182). A menu full of higher-ranked `[urgent]` items could bury it. Safety-critical QC-PENDING scratchpads are **unaffected** — the explicit commit-block advisory (KEPT, line 137) plus QC-PENDING menu-item-1 precedence (line 131) surface them independently of the cap.
- **Dead-code removal depends on filter correctness.** Line 187's cross-repo render clause is removed as dead only because Step 5 now filters to same-repo. If the filter ever mis-classifies (missing `repo` field, comparison edge case), a cross-repo mission would render as a plain `[mission: <id>]` tag without the "— in <repo>" annotation — but the 8a-a0/8c-2.5 guards (explicitly retained) still stop it before any write. Degrade-safe.
- **Couplings the change correctly handled (evidence of careful analysis, not risk):** deleting the Last-session line correctly drives deletion of the now-dangling first-session fallback (line 229); deleting the summary line correctly drives the Step 6-intro edit (line 193 "drop 'the summary,'"); retiring the session-count *display* correctly **keeps** the SIBLING_COUNT *computation*, which still gates the concurrent-session shared-file `⚠` advisory (lines 101-107). Each dual-use is named at the change site.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`, as-of 2026-06-01).
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** the change *removes* a code path (line 187 render clause) and adds no hook, generalization, or infrastructure for an absent consumer — it is a trim, the opposite of speculative building. Aligned.
- **OP-12 (closure before detection):** adds no new detection/scan/flag; it filters and trims existing display. Aligned (does not add detection ahead of closure).
- **OP-5 (advisory vs enforcement):** `/prime` stays advisory; the filter hides non-actionable cross-repo missions, it does not auto-act or enforce. All `⚠` warning lines and the QC-PENDING commit-block are explicitly preserved — no safety surface is silently upgraded or dropped. Aligned.
- **OP-10 (system boundary):** no cross-tool reach; the same-repo filter actually narrows cross-repo surfacing. Aligned.
- **DR-1 / DR-3 (placement):** file stays in its canonical home (`ai-resources/.claude/commands/`). Aligned.
- **Consistency with the command's own stated principle:** prime.md lines 7-9 mandate "Show only what the operator needs to choose the next task; everything else stays silent unless it needs attention." The trim serves this directly, and — verified line-by-line — every removed line is either non-safety informational (last-session summary, session count, `/mission create` tip) or has its actionable/safety content preserved elsewhere (carryover → still a `[carryover]` menu item; urgent duplicate → still a top `[urgent]` menu entry; scratchpad → still a menu candidate + QC-PENDING advisory retained). No principle is revised, so no OP-11 loud-revision obligation is triggered.

## Recommended redesign

Not applicable — verdict is GO.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: full read of `prime.md` (593 lines), `session-marker.md`, `mission.md`, and `principles-base.md`; `ls -la` confirmation of the symlink; and repo+workspace greps (positive-controlled against `.session-marker` = 13 hits after correcting an initial path-word-split false-empty). No training-data fallback was used. Two minor Hidden-Coupling findings are advisory (verdict remains GO under the one-Medium rule); they are surfaced for operator awareness, not as blocking mitigations.
