# Risk Check — 2026-05-27

## Change

Proposed change: FX-D2 — reconcile 3 divergent project hooks against ai-resources canonical hooks. Specifically, the 3 file pairs are:
- projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/detect-innovation.sh ↔ ai-resources/.claude/hooks/detect-innovation.sh
- projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/friction-log-auto.sh ↔ ai-resources/.claude/hooks/friction-log-auto.sh
- projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/log-write-activity.sh ↔ ai-resources/.claude/hooks/log-write-activity.sh

Source finding: audits/workflow-audit/00-findings-summary.md F-MASTER-15. Plan: plans/fix-phase-plan-v1.md Work Unit 5, FX-D2.

Goal: post-edit `diff` between project hooks and ai-resources/.claude/hooks/ returns no divergence on the 3 named files. Reconciliation direction (project → canonical, canonical → project, or merge) will be determined per file by comparing mtimes + content; this risk-check evaluates the change class, not a specific reconciliation direction.

Class: structural (hook edits — listed in ai-resources/docs/audit-discipline.md § Risk-check change classes).

Context for risk evaluation:
- Hooks are auto-invoked by the Claude Code harness on tool events (PostToolUse, SessionStart, etc.) — behavior changes are session-wide and silent.
- Per-file diff direction depends on which side is newer + which content represents intended behavior; some hooks may reflect project-specific customization that should NOT be backported to canonical.
- Concurrent session is editing Cluster C / FX-C1 (workflow command files) — different file set, no overlap with hooks.
- Project also has a related repo-level rule in CLAUDE.md § Friction Logging about hook attribution (added in commit 751a78e) — relevant when reconciling friction-log-auto.sh and log-write-activity.sh.
- Two other Cluster D items running in same session: FX-D3 (symlink swap for session-plan.md — separate scope) and FX-D4 (cosmetic skill edit — separate scope). Risk-check is FX-D2-specific.

Reversibility: file edits in both repos are git-tracked; revert via git.
Blast radius: 3 hook files in 2 repos; all sessions that load either repo's .claude/hooks would see new behavior.
Permissions: no permission entries added/changed.
Hidden coupling: hooks coordinate with other hooks via shared log files (logs/friction-log.md, logs/usage-log.md); reconciliation must preserve coordinated behavior.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/detect-innovation.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/friction-log-auto.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/log-write-activity.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-innovation.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friction-log-auto.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/log-write-activity.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/00-findings-summary.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fix-phase-plan-v1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Reconciling these 3 hooks is safe in the abstract — files are git-tracked and revertible — but the **canonical versions are structurally incompatible with the active project's live friction-log format and project-specific session-plan attribution rule**, so a naive "canonical wins" reconciliation will silently break the project's logging pipeline and contradict CLAUDE.md § Friction Logging. Two High-risk dimensions require paired mitigations before the change lands.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- All three hooks are already registered and firing per tool event today; reconciliation does not add a new hook or expand the matcher set. Per-event token impact is zero — hook bodies do not write into the model context window.
- Project `settings.json` PostToolUse Write/Edit matchers register `log-write-activity.sh` + `detect-innovation.sh` (project settings, lines for `PostToolUse → Write/Edit`); user-level `~/.claude/settings.json` registers the canonical `detect-innovation.sh` for Write/Edit globally. Reconciliation does not change the count of invocations.
- `friction-log-auto.sh` runs only on `PreToolUse → Skill`, gated to commands with `friction-log: true` frontmatter — invocation frequency is unchanged by content reconciliation.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change description states explicitly: "no permission entries added/changed."
- Inspection of `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` and `ai-resources/.claude/settings.json` confirms reconciliation is content-only on shell scripts; no `permissions.allow` / `deny` keys are touched.
- Hooks already have execute permission on disk via the existing harness invocations; no new `Bash(...)` patterns are introduced — hook bodies use `jq`, `grep`, `sed`, `date`, `printf` already executed by the live registrations.

### Dimension 3: Blast Radius
**Risk:** High

Enumeration of dependent surfaces (grep + direct inspection):

- **Project settings.json** registers the project copies at 4 invocation sites: `PostToolUse/Write → log-write-activity.sh` + `detect-innovation.sh`; `PostToolUse/Edit → log-write-activity.sh` + `detect-innovation.sh`; `PreToolUse/Skill → friction-log-auto.sh`. Source: `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` lines under `hooks.PostToolUse` and `hooks.PreToolUse`.
- **User-level `~/.claude/settings.json`** registers the *canonical* `detect-innovation.sh` (absolute path into `ai-resources/.claude/hooks/`) for `PostToolUse/Write` and `PostToolUse/Edit` — globally, for every project. This means edits to canonical `detect-innovation.sh` propagate to every session on this machine, including non-Nordic-PE projects.
- **ai-resources/.claude/settings.json** registers canonical `log-write-activity.sh` (no detect-innovation here) for `PostToolUse/Write|Edit` — affects ai-resources-rooted sessions.
- **CLAUDE.md § Friction Logging contract.** `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md:62` documents the exact behavior of the project hooks: `friction-log-auto.sh only creates the session-header block; log-write-activity.sh only appends one-line filename entries to friction-log.md`. This contract is verifiable today against the project hook bodies and would be **silently violated** by canonical replacement (see Hidden Coupling).
- **Active friction-log.md format coupling.** `logs/friction-log.md` (currently 100+ session blocks) uses the project hook format: `### Session: 2026-05-15 21:00 — Trigger: /run-report` with `#### Write Activity` body entries `- HH:MM — path`. Canonical `friction-log-auto.sh` emits `## Session — TIMESTAMP` (H2, em-dash) and canonical `log-write-activity.sh` emits `` - `YYYY-MM-DD HH:MM` — TOOL: `path` `` (different prefix, full datestamp, tool field, code-fenced path). Format swap mid-log would split the log into two incompatible halves and break the project-specific dedup grep in `friction-log-auto.sh` (`grep -n "^### Session:"` would find zero canonical sessions; `grep -o 'Session — ...'` in the canonical version would find zero project sessions — dedup degrades silently in both directions).
- **detect-innovation.sh divergence is small but meaningful.** Canonical adds `case "$FILE_PATH" in */ai-resources/.claude/*) exit 0;; */workflows/*/.claude/*) exit 0;; esac` (lines 30–33) to skip canonical-resource writes from being misclassified as project innovation. The project copy lacks this guard — meaning under the project copy, every write into `ai-resources/.claude/commands/*.md` or `workflows/*/.claude/commands/*.md` registers a new "innovation" row. The active `logs/innovation-registry.md` already shows multiple `triaged:graduate` / `triaged:already-canonical` rows pointing to canonical paths (e.g., `auto-sync-shared.sh`, `run-sufficiency.md`, `intake-reports.md`) — direct evidence the project copy is firing on canonical paths today. This is a substantive behavioral difference, not cosmetic.
- **SessionStart drift-detector.** `ai-resources/.claude/hooks/check-template-drift.sh` (registered by project settings.json SessionStart, lines invoking `check-template-drift.sh`) walks `commands`, `agents`, `hooks` subdirs and compares project vs canonical. It currently flags these 3 hooks as divergent every session start. Reconciliation will silence that nudge — which is the intended effect but also confirms the change is visible at session boundaries.
- **Dependent caller count: ≥5 surfaces** (project settings.json × 4 hook registrations, user settings.json × 1 canonical hook registration, ai-resources settings.json × 2 canonical hook registrations, CLAUDE.md text contract × 1, friction-log.md data format × 1, innovation-registry.md data format × 1, check-template-drift.sh runtime check × 1). Each is sensitive to one or more of the three files.

The contract change is **not backwards-compatible** for friction-log/log-write-activity (different output formats); detect-innovation is forward-compatible (the canonical guard only narrows behavior, never broadens). Cross-repo blast (user-level settings.json) means edits to canonical detect-innovation.sh affect every project on this machine.

### Dimension 4: Reversibility
**Risk:** Medium

- All 6 hook files are git-tracked in their respective repos; content revert is `git revert` clean within each repo.
- However, two side effects survive `git revert`:
  - **friction-log.md data:** any sessions started under the new (canonical) format leave persistent `## Session — ...` blocks in `logs/friction-log.md` that won't match the reverted project-version dedup grep — operator would need to either manually edit the log to restore format consistency, or accept a one-time format break.
  - **innovation-registry.md data:** if the canonical guard is backported into the project copy, any canonical-path innovation rows already logged (visible today in `logs/innovation-registry.md`) remain; revert restores the noisier behavior but leaves the cleaner-history rows already present.
- No cross-repo push state: change is local until operator pushes. Revert before push is fully clean.
- Two-repo revert (project + ai-resources) requires two `git revert` invocations and two commits — minor operational overhead, not a blocker.

### Dimension 5: Hidden Coupling
**Risk:** High

Multiple implicit dependencies surface that aren't visible from inspecting any single hook in isolation:

- **Session-header format is an implicit contract between `friction-log-auto.sh` (writer) and `log-write-activity.sh` (reader/appender).** Project `log-write-activity.sh` line 26 greps for `^#### Write Activity` and uses `sed -i ''` to insert in-place above the line. Canonical `log-write-activity.sh` line 27 also greps for `#### Write Activity` but **appends to end of file** via `echo ... >> "$FRICTION_LOG"`. Mixing project-version `friction-log-auto.sh` with canonical `log-write-activity.sh` (or vice versa) produces a working but visually inconsistent log; mixing canonical writer with project reader (`sed -i ''` inserting under `#### Write Activity`) would work but with the canonical's full-timestamp entries appearing in the wrong chronological position. **Both hooks must be reconciled to the same side** — half-and-half breaks coordination.
- **Project CLAUDE.md § Friction Logging asserts a project-specific factual claim about hook behavior** (`projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md:62`): `friction-log-auto.sh only creates the session-header block; log-write-activity.sh only appends one-line filename entries`. This sentence is currently true of the project copies. The canonical `log-write-activity.sh` appends `TOOL_NAME: REL_PATH` (two fields, not one), and `friction-log-auto.sh` writes `Session — TIMESTAMP` + `**Trigger:** /SKILL_NAME` (two-line header, not one). Canonical-wins reconciliation **silently invalidates the CLAUDE.md assertion** — the rule will still be loaded every session but will no longer describe what the hooks actually do, and the hook-attribution diagnosis in commit 751a78e becomes stale.
- **`detect-innovation.sh` and `innovation-registry.md` schema.** Both versions emit a 6-column markdown table row. Identical schema, so the data layer is compatible across the merge. Confirmed by inspecting line 46 of project version and line 55 of canonical version.
- **PROJECT_DIR resolution differs.** Project `detect-innovation.sh` line 7: `PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"` (computes from script path). Canonical line 10: `PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"` (falls back to cwd). Functionally equivalent when `CLAUDE_PROJECT_DIR` is set (always, in live sessions); divergent only if a hook is invoked outside the harness. Low impact unless an operator invokes a hook manually for debugging.
- **mtime evidence: project copies are NEWER, not older.** Project `detect-innovation.sh` mtime `2026-05-12 15:14`; canonical `2026-04-27 14:18`. Project `friction-log-auto.sh` `2026-05-12 15:14`; canonical `2026-04-27 17:33`. Project `log-write-activity.sh` `2026-05-12 15:14`; canonical `2026-04-27 17:34`. The change-description's "Reconciliation direction (project → canonical, canonical → project, or merge) will be determined per file by comparing mtimes + content" implies an mtime-newer-wins heuristic. Mtime alone would point at the project copies as authoritative for all three — but **content inspection shows the canonical `detect-innovation.sh` has a strictly better guard (the ai-resources/workflows skip)** that the project copy is missing. So the mtime heuristic and the content-quality heuristic disagree on at least one file. The plan needs to acknowledge per-file direction explicitly rather than apply a single rule.
- **User-level `~/.claude/settings.json` couples ALL projects to canonical `detect-innovation.sh`.** Any edit to canonical `detect-innovation.sh` will fire for every project on this machine starting next session. The risk-check inputs do not describe this coupling; it is invisible from the project-level audit perspective alone.

## Mitigations

- **(Blast radius mitigation.) Pre-flight side-by-side diff for each of the 3 file pairs; operator selects reconciliation direction per file.** Run `diff -u project canonical` for each pair, show all 3 diffs in chat with file mtimes and a one-line "what would change if canonical wins" / "what would change if project wins" summary. Operator picks direction per file. Do NOT apply a blanket "mtime newer wins" or "canonical wins" heuristic — the three files require independent decisions.
- **(Blast radius mitigation.) For `friction-log-auto.sh` + `log-write-activity.sh`, reconcile as a pair, not independently.** The session-header format and the write-activity-append format are coupled. If one is changed, the other must change in the same direction. Document this pairing in the FX-D2 work-unit notes before editing.
- **(Hidden coupling mitigation.) Verify the project's CLAUDE.md § Friction Logging text against the post-reconciliation hook behavior, and update CLAUDE.md if needed.** Specifically: if canonical-wins is selected for the friction-log pair, the line "`log-write-activity.sh only appends one-line filename entries`" in `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md:62` becomes false (canonical appends two fields). Either rewrite the CLAUDE.md line to match canonical behavior, or pick project-wins to preserve the documented contract. Update CLAUDE.md in the same commit as the hook reconciliation to keep the contract and the implementation in sync.
- **(Hidden coupling mitigation.) For `detect-innovation.sh`, backport the canonical `ai-resources/.claude/*` and `workflows/*/.claude/*` skip guard into whichever copy ends up the surviving version.** Inspecting `logs/innovation-registry.md` shows the missing guard is causing canonical-path entries to be logged today as project innovations — the guard is a substantive improvement, not cosmetic. If project-wins is selected for the other two files (to preserve friction-log format), explicitly merge the guard from canonical into project (cherry-pick the relevant `case` block). Do not pick wholesale on mtime alone.
- **(Reversibility mitigation.) Land the reconciliation in two single-purpose commits — one per repo (project, ai-resources) — so revert can be done independently per repo if a side effect surfaces later.** Tag each commit message with `FX-D2` and name the specific files touched. This preserves the option to revert only one repo without entangling unrelated cluster work.
- **(Cross-machine coupling mitigation — advisory.) If canonical `detect-innovation.sh` is edited, flag in the commit message that user-level `~/.claude/settings.json` registers this hook globally and the change will fire for every project on this machine starting next session.** No code action required; this is a visibility note so the operator can mentally verify no other active project depends on the prior behavior.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (project hook line numbers; canonical hook line numbers; settings.json hook registrations; project CLAUDE.md line 62), mtime comparisons via `stat`, content diffs read directly from disk, grep counts on `logs/friction-log.md` and `logs/innovation-registry.md`, and verbatim quotes from the CHANGE_DESCRIPTION and referenced files. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — FX-D2 Hook Reconciliation

## Concurrence on the verdict

We concur with **PROCEED-WITH-CAUTION**. Stronger framing actually applies: the verdict understates the risk on two of the five dimensions, and the recommended mitigation path is close to correct but missing one item.

The change is governed by `risk-topology.md § 3` (Hook edit → blast radius "All sessions firing that hook" → `/risk-check` plan + end-time required). All three files in scope are hook edits, and `detect-innovation.sh` registered in the user-level `~/.claude/settings.json` propagates globally — Blast radius is correctly flagged High (`risk-topology.md § 1` "system-wide effect if broken"), and Hidden coupling is correctly High (`principles.md § AP-6` Audit recommendations applied without impact analysis: the friction-log format coupling between two of the three hooks is exactly the runtime-behavior pattern audits cannot model statically).

## Architectural commentary on the routing baseline

The routing baseline you passed is correct: hooks are not auto-distributed (verified at `system-doc.md § 4.3` "Hooks are not auto-distributed — declared explicitly in the relevant settings.json") and divergence between `ai-resources/.claude/hooks/` and `projects/<project>/.claude/hooks/` is tolerated by design. The architectural implication that the risk-check report did not draw out explicitly: **there is no canonical-wins default to fall back on for hooks.** Unlike commands and agents (which auto-sync via symlink at SessionStart per `system-doc.md § 4.4`), divergence in hooks is the steady state, not the exception. "Reconcile against canonical" is therefore not a routine drift-fix — it is a per-file design decision about whether the project's variant should give way, persist as a deliberate fork, or merge.

This reframes the change: FX-D2 is not three drift-fixes. It is three independent design decisions packaged under one work-unit label. Mitigation #1 (per-file diff + per-file direction) is therefore non-optional, not a careful-mode preference (`principles.md § DR-9` top-3 analysis applied at file granularity, not bundle granularity).

## Downstream impact assessment

**friction-log-auto.sh + log-write-activity.sh (canonical→project would silently invalidate a CLAUDE.md rule).** This is the highest-impact concern in the report and we concur fully. Commit 751a78e (added two commits ago) documents the hook attribution rule in project CLAUDE.md § Friction Logging, naming the project-version behavior as authoritative for friction-event classification. A naive canonical-wins reconciliation would:

1. Break OP-3 (`principles.md § OP-3` Loud failure over silent continuation) — the format split would be silent rather than surfaced.
2. Trigger AP-1 (`principles.md § AP-1` Silent conflict resolution) — two inputs (project CLAUDE.md hook attribution rule vs. canonical hook behavior) conflict; canonical-wins resolves it silently rather than naming the conflict.
3. Violate `risk-topology.md § 3` Cross-cutting CLAUDE.md edit semantics — invalidating an always-loaded CLAUDE.md rule via a hook edit is a CLAUDE.md edit by side effect, and side-effect CLAUDE.md edits are exactly the class `/risk-check` exists to prevent.

Mitigation #3 (verify/update project CLAUDE.md in the same commit) is therefore not optional polish — it is the only way to keep the change from triggering AP-1.

**detect-innovation.sh — global propagation via user-level settings.json.** Mitigation #6 correctly flags this. Architectural amplification: `risk-topology.md § 1` Critical tier lists `settings.json (workspace root)` as system-wide-effect-if-broken; the user-level settings.json sits one tier above and propagates to *every project on this machine*, not just this workspace. Editing the canonical `detect-innovation.sh` is therefore a structural change with blast radius beyond the Axcíon workspace boundary entirely. The backport recommendation (#4) is correct on quality grounds (`principles.md § OP-1` compounding — the canonical skip-guard is the substantive improvement), but the operator should know that edits here have machine-wide reach, not workspace-wide.

## Risk the dimension review missed

**The work-unit boundary itself is the risk.** Bundling three independent hook reconciliations under a single FX-D2 label creates a pressure toward batch resolution (one decision direction, one commit, one revert unit) when the architecture demands the opposite (per-file decision, two commits already in the mitigation list, separate revert paths). Mitigation #5 partially addresses this (two single-purpose commits, one per repo), but the per-file direction decision (mitigation #1) and the paired-hook coupling (mitigation #2) mean the three files actually decompose into:

- One paired decision (friction-log-auto + log-write-activity, formats coupled, must move together)
- One independent decision (detect-innovation, canonical backport)

That is two decisions, not three, and not one. The work-unit framing in `plans/fix-phase-plan-v1.md` Work Unit 5 should reflect this decomposition before execution — otherwise the operator is asked to approve "FX-D2" as a single line item when the underlying structure is two sub-decisions with different mitigation profiles. This is the pattern `principles.md § AP-7` warns against in the opposite direction (here, false consolidation rather than false generalization), and `principles.md § OP-3` requires surfacing.

## Position

The right answer is: accept PROCEED-WITH-CAUTION, apply all six mitigations as listed, and **add a seventh** — re-frame the work-unit before execution so that FX-D2 is approved as two sub-decisions (FX-D2a paired-hook-reconciliation, FX-D2b detect-innovation-backport), each with its own diff, its own commit, and its own revert path. Mitigation #5's "two commits, one per repo" reads as a git-mechanics split; the seventh mitigation is a decision-structure split. Both are needed.

Caveat: the friction-log format incompatibility is the load-bearing claim in the original report. I am taking it on the report's authority — we did not read the three hook files in this consultation. If the incompatibility is wrong, several of the recommendations above collapse to "this is routine drift, canonical-wins is fine." If the operator wants that verified, the bounded next step is a per-file diff before commit, which mitigation #1 already requires.
