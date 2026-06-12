# Risk Check — 2026-06-12

## Change

Mission promote-rw-canonical landing set (Phases 2–4 complete, pre-commit gate). Three structural change classes in one co-ordinated change set, all in ai-resources: (1) CANONICAL TEMPLATE — workflows/research-workflow/: merged reference/stage-instructions.md (project-ahead C1/C2/C3/C4/C7 + canonical C5 Step 2.1b preserved verbatim); .claude/commands/run-preparation.md (C1+C4 Step 3b QC + Step 3c Researchability Triage), run-execution.md (C2 register-hit gate + calibrated loop ceiling + D6 Check 4 wiring at Step 2.S3), run-cluster.md (C3 stage-entry gate), produce-prose-draft.md (C3 hard-blocker stage-5-paths check), run-report.md (C8 no-git standing constraints); reference/quality-standards.md (C5-mirror § Critical Finding Classification added), file-conventions.md (C7 report/compiled+produced paths); docs/required-reference-files.md (C3 stage-entry files 5/6 contract); SETUP.md (new § 5d stage-entry instantiation step + 2 example-residue generalizations). All placeholders preserved ({{PROJECT_TITLE}}, {{SECTION_SEQUENCE}}, {{RESEARCH_AREA_PHRASE}}, {{CLUSTER_BLOCK_THRESHOLD}}, {{SECTION_BLOCK_THRESHOLD}}); residue scans clean on every file. (2) SHARED HOOK — .claude/hooks/friction-log-auto.sh rewritten dual-mode (PreToolUse session-block creation unchanged; new PostToolUse branch appends tool-error friction events under ### Friction Events, conservative is_error-only trigger, recursion guard for friction-log.md/improvement-log.md, sanitized snippet) + .claude/settings.json new PostToolUse registration (matcher Bash|Write|Edit|Agent|Skill). Smoke-tested 5 cases (error append, success no-op, recursion guard, pre-branch no-op, session-block creation). Consumer projects hold plain copies of the hook — no auto-propagation. (3) SHARED SKILLS — skills/claim-permission-gate/SKILL.md (D4: values-present pre-flight check for reference/claim-permission.md, disclosed GENERIC-BAR regime replacing silent fallback; new Inputs row; extended step-5 regime report) and skills/supplementary-research-qc/SKILL.md (D6: new Check 4 sampled scarcity-verdict independence check, end-of-pass, 1–2 samples, fresh-context re-attempt via standard operator-Perplexity path; output block; scope-boundary carve-out). Both skills live-symlinked by positioning-research and research-pe-regime-shift-advisory-gap — changes are immediately live; both designed additive/non-breaking (D4 fires only when claim-permission.md absent/unfilled — converts silent fallback to disclosed; D6 fires only on confirmed-scarcity outcomes, sampled). DR-7 consumer map: template consumers (buy-side-service-plan, research-pe-regime-shift-advisory-gap) hold plain copies, absorb only via /sync-workflow — zero immediate impact; skill consumers get additive behavior; hook consumers hold copies — zero immediate impact. EXCLUDED from this change set (foreign stranded work, pre-existing dirty): workflows/research-workflow/reference/claim-permission.template.md (uncommitted triangulation-collapse delta from rolled-back 2026-06-09 attempt), logs/session-notes.md 7-line append, untracked session-plans. Commits will land in co-landing groups (A–E + Phase 4) with DR-7 notes; push gated to session end.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-preparation.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-execution.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-report.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/file-conventions.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/required-reference-files.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friction-log-auto.sh — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/claim-permission-gate/SKILL.md — exists (modified, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/supplementary-research-qc/SKILL.md — exists (modified, uncommitted)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A largely additive, backward-compatible canonical-template promotion plus two disclosure-improving skill edits, carrying one genuinely elevated dimension — the dual-mode shared hook, which is the only piece that auto-fires per tool call against live shared state and is immediately live in the canonical repo on commit.

## Consumer Inventory

Derived from the change targets: the two live-symlinked skills, the shared hook + its settings registration, the canonical workflow-template files (consumed by plain-copy projects via `/sync-workflow`), and the contract markers the change touches (`### Friction Events` heading, GENERIC-BAR regime line, stage-entry completeness gate, stage-5-paths hard-blocker). Greps run across the canonical repo and the workspace root one level up.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/settings.json` | invokes (PostToolUse `Bash\|Write\|Edit\|Agent\|Skill` + PreToolUse `Skill` registrations of the hook) | yes (co-edit — already present, lines 53-63 / 83-93) |
| `projects/positioning-research/reference/skills/claim-permission-gate` | imports (symlink → `ai-resources/skills/claim-permission-gate`) | no (additive skill change — live immediately, non-breaking) |
| `projects/positioning-research/reference/skills/supplementary-research-qc` | imports (symlink → `ai-resources/skills/supplementary-research-qc`) | no (additive) |
| `projects/research-pe-regime-shift-advisory-gap/reference/skills/claim-permission-gate` | imports (symlink) | no (additive) |
| `projects/research-pe-regime-shift-advisory-gap/reference/skills/supplementary-research-qc` | imports (symlink) | no (additive) |
| `knowledge-bases/pe-kb-vault/skills/supplementary-research-qc` | imports (symlink) | no (additive) — third symlink consumer NOT named in CHANGE_DESCRIPTION (blast-radius gap, see Dim 3) |
| `projects/positioning-research/.claude/settings.json` | invokes (its own plain copy of `friction-log-auto.sh`, line 43) | no (plain copy — no auto-propagation; absorbs only on manual re-copy) |
| `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json` | invokes (plain copy of the hook, line 43) | no (plain copy) |
| `projects/positioning-research/.claude/commands/note.md` | parses (depends on `### Friction Events` / `## Session —` / `#### Write Activity` headings; documents that the hook also writes a `**Trigger:**` line) | no (hook's new branch appends *under* the existing `### Friction Events` heading — heading contract preserved) |
| `projects/{positioning-research,research-pe-regime-shift-advisory-gap}/.claude/commands/run-execution.md` | invokes (plain copies of the template command; call `supplementary-research-qc` at Step 2.S3) | no (plain copy of template — absorbs C2/D6 wiring only via `/sync-workflow`) |
| `projects/{positioning-research,research-pe-regime-shift-advisory-gap}/.claude/commands/run-sufficiency.md` | invokes (delegate to `claim-permission-gate` Phase A) | no (symlinked skill is live; command body unchanged by this set) |
| `projects/{positioning-research,research-pe-regime-shift-advisory-gap}/reference/stage-instructions.md` (+ buy-side-service-plan) | co-edits (plain copies of the canonical template `stage-instructions.md`) | no (plain copy — drift absorbed via `/sync-workflow`, zero immediate impact) |
| `projects/buy-side-service-plan/reference/stage-instructions.md` | co-edits (plain copy of template) | no (plain copy) |
| `ai-resources/.claude/commands/sync-workflow.md` (+ 9 per-project copies) | invokes (the propagation channel template consumers use to absorb the template edits) | no (mechanism, not contract-breaking) |

**Total: 16 consumers, 1 must-change** (the settings.json hook registration — already in place per git working tree). The one must-change is a paired co-edit within the same change set, not an external caller left stranded. The `pe-kb-vault` symlink is a consumer the CHANGE_DESCRIPTION's DR-7 map did not enumerate. For the canonical template files (plain-copy consumers), the inventory covers the `/sync-workflow` propagation contract — those files have no live readers in other repos until a project runs `/sync-workflow`.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The change adds one PostToolUse hook branch that runs on a broad matcher — `Bash|Write|Edit|Agent|Skill` (`.claude/settings.json:84`). This fires on nearly every tool call in any ai-resources session, not once per session. That is the Medium calibration point for hooks (per-session vs per-tool-call).
- Mitigant lowering it from High: the hook's PostToolUse branch exits early and cheaply in the common case — `[ -f "$FRICTION_LOG" ] || exit 0` (`friction-log-auto.sh:25`) then `[ "$IS_ERROR" = "true" ] || exit 0` (line 29). No friction log present or no tool error → two `jq` reads and exit. Token cost to the model context is zero (hook output is not injected unless it appends); the cost is per-call shell spawn latency (`timeout: 5`), not context tokens.
- Skill edits are pay-as-used: both skills are invoked on demand inside `/run-sufficiency` and `/run-execution` Step 2.S3, not auto-loaded. The extended step-5 regime report and Check 4 add tokens only within those subagent invocations (`claim-permission-gate/SKILL.md:170`, `supplementary-research-qc/SKILL.md:80-90`), not to always-loaded context.
- No always-loaded CLAUDE.md content is added; no new `@import`; no SessionStart hook added.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`deny`/`ask` entry is added, removed, or widened. The settings.json diff is confined to the `hooks.PostToolUse` array (new registration at `.claude/settings.json:83-93`); the `permissions` block is untouched.
- The ai-resources settings already run `Bash(*)` allow and `defaultMode: bypassPermissions` (`.claude/settings.json:3-4, 34`), so the hook's shell execution (`sed -i`, `jq`, `grep`, `date`) introduces no capability not already authorized.
- No scope escalation (project → user), no cross-repo write capability, no external API. The hook writes only to the in-project `logs/friction-log.md` (`friction-log-auto.sh:13`).

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory: **16 consumers, 1 must-change.** The single must-change is the settings.json hook registration — a paired co-edit inside this same set (already present in the working tree at `.claude/settings.json:83-93`), not an external caller left broken.
- Two skills are **live-symlinked** by both research projects (`projects/positioning-research/reference/skills/`, `projects/research-pe-regime-shift-advisory-gap/reference/skills/`), so skill edits go live on commit with no propagation step. Both edits are additive and presence-gated: D4 fires only when `claim-permission.md` is absent/unfilled and converts a silent fallback to a disclosed GENERIC-BAR regime (`claim-permission-gate/SKILL.md:154`); D6's Check 4 fires only on confirmed-scarcity outcomes and skips silently otherwise (`supplementary-research-qc/SKILL.md:82`). No existing parser contract is broken — the permission-table output schema is explicitly preserved ("additive — no new column, so the schema and any positional parser are unaffected," `claim-permission-gate/SKILL.md:108`).
- Contract markers checked: the hook appends *under* the existing `### Friction Events` heading (`friction-log-auto.sh:46`), and `projects/positioning-research/.claude/commands/note.md:16` documents that three writers stay "detection-compatible because detection keys on `### Friction Events`" — the heading contract is preserved, not broken.
- Canonical template files (`stage-instructions.md`, `run-*.md`, `quality-standards.md`, `file-conventions.md`, `required-reference-files.md`, `SETUP.md`) are consumed by **plain copies** in 3 projects (positioning-research, regime-shift, buy-side-service-plan) verified as regular files, not symlinks. Template edits therefore have **zero immediate impact** on those projects until each runs `/sync-workflow` — a deliberate decoupling that bounds the blast radius.
- **Blast-radius gap:** the CHANGE_DESCRIPTION's DR-7 consumer map names positioning-research and regime-shift as skill consumers but omits a third live symlink — `knowledge-bases/pe-kb-vault/skills/supplementary-research-qc` → `ai-resources/skills/supplementary-research-qc`. The D6 Check 4 edit goes live in pe-kb-vault too. The edit is additive/presence-gated so impact is benign, but the consumer was not anticipated — call it out so the operator is aware the vault picks up the change.

### Dimension 4: Reversibility
**Risk:** Medium

- The template, skill, and settings edits are clean single-file `git revert` candidates within the ai-resources working tree — no sibling files or directories created that revert leaves behind.
- The Medium driver is the **shared hook against live state**: once `friction-log-auto.sh` is committed, the PostToolUse branch is immediately active for every ai-resources session. Between landing and any revert it can append `- HH:MM — [auto] {tool} error: ...` lines into `logs/friction-log.md` (`friction-log-auto.sh:50-51`). A `git revert` of the hook does **not** remove those already-appended log lines — it is an append-only data mutation that revert cannot cleanly undo (one extra manual cleanup step: hand-edit any auto-appended friction lines if the behavior is rolled back).
- Push is gated to session end per the change description and workspace `CLAUDE.md` → Push behavior, so no state propagates beyond the local repo before the operator's single wrap-time confirmation. This keeps reversibility at Medium rather than High (no external/pushed state to chase).
- Plain-copy decoupling helps reversibility: reverting the canonical template does not require touching the 3 consuming projects, since they have not yet absorbed via `/sync-workflow`.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The hook depends on a heading convention it does not own: it appends under `^### Friction Events` (`friction-log-auto.sh:46`) and the dedup/session-block logic keys on `^## Session —` (line 71). Three independent writers (`/friction-log`, `/note`, this hook) must keep these headings byte-stable. `projects/positioning-research/.claude/commands/note.md:16` documents this shared contract explicitly — so it is a documented coupling, not a silent one. Still a real cross-component dependency: a future rename of the heading in any one writer silently breaks the hook's append.
- The hook overlaps in concern with the existing `log-write-activity.sh` PostToolUse hook (both registered on Write/Edit, `.claude/settings.json:67-72`) — but they write different sections (`#### Write Activity` vs `### Friction Events`) and the friction branch is `is_error`-gated, so they do not contend for the same line. No double-write.
- Platform coupling: `sed -i ''` (BSD/macOS syntax, `friction-log-auto.sh:50`) and `date -j -f` (BSD, line 75) are macOS-specific. Consumer projects hold plain copies, so this is contained to a macOS host — but it is an implicit environment assumption worth noting.
- The skill edits introduce/extend contracts that ARE documented at the change site: the GENERIC-BAR regime is documented in both the skill (`claim-permission-gate/SKILL.md:52, 154`) and the canonical `required-reference-files.md:53-59` and `stage-instructions.md:99` — so the soft-fallback contract is named in three places, not hidden. Check 4's fresh-context re-attempt path is documented inline (`supplementary-research-qc/SKILL.md:87`).
- Net: one genuine cross-writer heading dependency + one platform assumption, both documented or contained — Medium, not High (no silent auto-firing in an unexpected context, no undocumented new contract callers must honor).

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read and applied: `projects/strategic-os/ai-strategy/principles-base.md` (41 active, frozen-ID).
- **DR-7 / OP-9 / AP-7 (generalize only on a second confirmed consumer; no speculative abstraction).** This is the strongest fit. Every shared change has ≥2 confirmed live consumers: the two skills are symlinked by two research projects (plus pe-kb-vault); the hook serves the canonical repo and is copied by both projects; the template promotion graduates project-ahead deltas (C1–C8) that already proved out in positioning-research. The change generalizes *from* confirmed consumers, not *for* an absent Phase-2 one. No "hooks for later." Aligned.
- **OP-12 (closure before detection).** The hook's new PostToolUse branch is new *detection* (it captures tool-error friction events) — but it ships **with** its closure channel: it writes the captured event directly into the `### Friction Events` ledger that `/improve` already reads (`projects/.../CLAUDE.md` Friction Logging section). It closes the long-standing gap where `### Friction Events` was created but never auto-populated (`friction-log-auto.sh:5-8`). Detection paired with closure — counts *for* the change, not against. Aligned.
- **OP-5 (advisory vs enforcement).** The hook only *records* (appends a log line); it does not detect-and-correct or block any tool call. The skills' new checks are advisory: D4 *discloses* a regime rather than silently defaulting; D6's Check 4 *routes back to re-extraction or confirms* a scarcity verdict — it surfaces, it does not auto-act on the operator's behalf. No advisory→enforcement upgrade. Aligned.
- **OP-2 / AP-4 (automate execution, gate judgment).** The change automates mechanical logging (execution), not a judgment call. The skill checks add judgment surfacing (regime disclosure, independence re-check) that routes back to the operator/pipeline rather than auto-deciding. No genuine judgment is silently automated; no routine execution is newly gated. Aligned.
- **DR-1 / DR-3 (placement).** All changes land in their canonical homes: hook in `ai-resources/.claude/hooks/`, skills in `ai-resources/skills/`, template files in `ai-resources/workflows/research-workflow/`. Correct tier (canonical) and correct home per type. Aligned.
- **OP-11 / OP-3 (loud revision, no silent drift).** No principle is being revised; nothing requires a loud-revision record. The GENERIC-BAR change explicitly *removes* a silent fallback in favor of a disclosed regime — it moves the system toward OP-3 (loud over silent), not away. Aligned.
- One scoping note in the change's favor: the foreign stranded `claim-permission.template.md` delta (rolled-back 2026-06-09 triangulation-collapse attempt) is explicitly EXCLUDED from the change set — keeping a contested chassis edit out of an unrelated promotion is the correct closure-over-entanglement call (consistent with the prior decision-log rationale at `research-pe-regime-shift-advisory-gap/logs/decisions-archive-2026-06.md:302`).

## Mitigations

- **Dimension 4 (Reversibility) — auto-appended log lines survive revert.** Before committing the hook, note in the commit message (or session-notes) that rolling back `friction-log-auto.sh` requires a manual pass over `logs/friction-log.md` to strip any `- HH:MM — [auto] ... error:` lines the active hook appended. Concretely: if the hook is reverted, grep `logs/friction-log.md` for `\[auto\] .* error:` and hand-remove. Keeps rollback to one known, bounded cleanup step rather than a surprise.
- **Dimension 3 (Blast Radius) — unenumerated third consumer.** Before landing, confirm the D6 Check 4 change is benign for `knowledge-bases/pe-kb-vault/skills/supplementary-research-qc` (it is additive/presence-gated, so expected no-op there) and add pe-kb-vault to the DR-7 consumer note in the commit so the vault's pickup is recorded, not silent.
- **Dimension 1 / 5 (per-tool-call hook + platform coupling) — preserve the early-exit and document the BSD assumption.** Keep the two-line early-exit guard (`[ -f "$FRICTION_LOG" ] || exit 0`; `is_error` gate) as the first operations in the PostToolUse branch so the broad `Bash|Write|Edit|Agent|Skill` matcher stays cheap; and add a one-line comment in the hook noting the `sed -i ''` / `date -j -f` BSD/macOS dependency so a future Linux-host consumer is warned before the plain copy fails silently.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the hook, settings.json, the two SKILL.md files, the canonical template docs; grep counts for consumer symlinks, plain copies, and contract markers; verbatim quotes from CHANGE_DESCRIPTION and referenced files; principle IDs from `projects/strategic-os/ai-strategy/principles-base.md`). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-risk-second-opinion-promote-rw-canonical.md

**Verdict concurrence:** Concur with PROCEED-WITH-CAUTION. The change spans four /risk-check gated classes at once (hook edit, settings.json registration, shared-skill edits, symlink consumers) — a cluster of compounding Mediums is a PROCEED-WITH-CAUTION signature, not a GO. Do not downgrade.

**Routing:** Clean — each piece lands in its correct canonical home with the correct distribution mechanism. The risk is runtime coupling, not placement.

**Mitigations:**
- (a) commit-note for manual revert strip — UPGRADE: land the manual-strip recipe as a documented step (closes repo-state.md § 2 Pending Step 8); commit message points to it.
- (b) add pe-kb-vault consumer + confirm D6 Check 4 no-op — CONCUR, REQUIRED; verify against the consumer's actual invocation path, not asserted.
- (c) guard-first + BSD/macOS portability comment — CONCUR.

**Missed risk:** Four gated classes as one atomic commit — scored per-piece, not for the interaction. Highest-leverage fix: split the dual-mode hook + settings.json registration into a separate, independently-revertible commit from the template and skills. Second: re-confirm recursion-safety of the new PostToolUse branch.

**Position:** Verdict stands. Land with (b)/(c), upgrade (a) to a documented rollback recipe, split the hook+settings commit, re-confirm recursion-safety.
