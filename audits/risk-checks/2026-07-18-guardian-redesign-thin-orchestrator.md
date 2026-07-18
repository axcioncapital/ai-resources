# Risk Check — 2026-07-18

## Change

Plan-time gate, RE-INVOKED after a redesign. Context: a prior version of this change (new command + new agent + CLAUDE.md nudge, orchestrating three existing agents by bypassing their commands, plus a new agent claiming to cover "cumulative drift" and "value-add" dimensions nothing else covered) was risk-checked and returned RECONSIDER — Dimension 6 (Principle Alignment, High: complexity-budget violation, zero consumers, no OP-11 record) and Dimension 7 (Problem Reality, High: the "no existing reviewer covers this" premise was contradicted by `/contract-check` and `/reconcile`, which already operate against `context/mandate-rubric.md`). That finding was independently re-verified by reading `contract-check.md`, `reconcile.md`, `reconcile-reviewer.md` in full, AND by actually running `/reconcile` against a real draft (`parts/part-2-service/drafts/free-service-launch-operating-plan-draft-05.md`) — confirmed `reconcile-reviewer` already scores all 9 `mandate-rubric.md` dimensions (including evidence calibration) and runs a genericness/substitution check, with real grounded findings.

REDESIGNED CHANGE (this is what needs a fresh risk-check): add exactly ONE new project-local command, `projects/buy-side-service-plan/.claude/commands/guardian.md` (frontmatter: `friction-log: true`, `model: sonnet`). It does ZERO new judgment/review of its own — it is a pure sequencing + logging orchestrator. Its flow: (1) resolve a target `parts/` section/draft the same way `/content-review` does; (2) invoke `/content-review {target}` via the Skill tool — completely unmodified behavior, including its existing PASS→auto-promote-to-approved/ and CONDITIONAL-PASS/REVISE→auto-triage-loop logic; (3) invoke `/challenge {target}` and `/service-design-review {target}` via the Skill tool, unmodified, either order (matching the existing rule); (4) invoke `/reconcile {target-or-promoted-path}` via the Skill tool, unmodified — this step is explicitly advisory-only, its verdict never blocks or reverses the promotion that already happened in step 2; (5) append ONE line to a new file `logs/guardian-log.md` (date, target, the four verdicts, the reconcile report path) — `logs/guardian-log.md` is the only new state this command writes; `/reconcile` continues to write its own full report to its own existing `logs/reconcile-reports/` as it already does standalone; (6) present a short chat summary. No agent bypass, no duplicate invocation path — all four underlying commands are invoked through their own existing canonical entry points with completely unmodified behavior.

Paired edit: `reference/stage-instructions.md` § Strategic Evaluation (lines 174-182) — replace the existing informal instruction ("Before approval, these should go through three review layers: 1. QC review first (`/review`)... 2. Strategic evaluation (`/challenge`)... 3. Service design review (`/service-design-review`)... All three must be addressed before moving content to approved/. `/challenge` and `/service-design-review` can run in either order after `/review` passes.") with a version naming `/guardian` as the single entry point that sequences the same three required layers (fixing a confirmed pre-existing staleness bug in the same edit: the current text says `/review`, but the actual QC dispatcher for `parts/` content is `/content-review` — `/review` is an unrelated Stage-4/legacy chapter reviewer for a different pipeline) plus the new advisory `/reconcile` step. The three-layer requirement itself is UNCHANGED (same three commands, same "must be addressed before approved/" bar) — only how they're invoked and recorded changes. `/reconcile`'s advisory-only status is stated explicitly. The CLAUDE.md nudge from the original design is DROPPED ENTIRELY in this redesign — no CLAUDE.md edit at all, because `/guardian` being named directly in `stage-instructions.md`'s mandatory pre-approval instruction is itself a real, non-memory-dependent invocation path (Claude already reads this file at the relevant stage per its own frontmatter), so a proactive nudge is no longer load-bearing.

Verified premises (already checked, do not re-verify): `.claude/commands/content-review.md`, `challenge.md`, `service-design-review.md` all exist project-locally and unchanged; `.claude/commands/reconcile.md` and `.claude/agents/reconcile-reviewer.md` exist (reconcile is a symlinked canonical resource, already working in this project — just ran it successfully); `reference/stage-instructions.md` lines 174, 178, 182 confirmed to contain exactly the text quoted above (staleness bug at line 178 confirmed real); `logs/guardian-log.md` does not yet exist; `.claude/commands/guardian.md` does not yet exist; nothing else has been built yet (still plan-time, nothing implemented).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/guardian.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/content-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/challenge.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/service-design-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/reconcile.md — exists (symlink to canonical)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/agents/reconcile-reviewer.md — exists (symlink to canonical)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/logs/guardian-log.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/logs/reconcile-reports/2026-07-18-free-service-launch-operating-plan-draft-05.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The redesign genuinely cures the two prior High findings (no functional overlap, no fabricated coverage claim) and is well-contained (no permission widening, no ongoing token cost), but it introduces a new command whose core orchestration/logging value-add has no cited failure-mode evidence (only the paired text-fix has evidence), leaves an identical staleness bug uncorrected in a second file the inventory surfaced, and creates one small but real append-only-log reversibility gap.

## Consumer Inventory

Search terms used: `guardian` (new command token — zero real hits, one unrelated noise match for an unrelated "brand-guardian.md" agent in a different system, confirmed by direct grep and read of the matching line); `content-review`, `challenge`, `service-design-review`, `reconcile` (existing commands `/guardian` will invoke); the exact text block at `reference/stage-instructions.md` lines 174-182 (the paired-edit target). Grep run across `projects/buy-side-service-plan/` and cross-checked against `ai-resources/` for the `guardian` token.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `reference/stage-instructions.md` (lines 174-182) | co-edit | yes — this IS the paired edit |
| `.claude/commands/content-review.md` | invokes (called by `/guardian` step 2, unmodified) | no |
| `.claude/commands/challenge.md` | invokes (called by `/guardian` step 3, unmodified) | no |
| `.claude/commands/service-design-review.md` | invokes (called by `/guardian` step 3, unmodified) | no |
| `.claude/commands/reconcile.md` (symlink) | invokes (called by `/guardian` step 4, unmodified) | no |
| `.claude/agents/reconcile-reviewer.md` (symlink) | invokes (indirect, via `/reconcile`) | no |
| `.claude/commands/draft-section.md` (Phase 3, lines 51-53) | documents (offers `/content-review` and `/challenge` individually as review options; does not mention `/service-design-review` or, post-change, `/guardian`) | no (still functions, but becomes a stale/alternate path once `/guardian` is canonical) |
| `.claude/commands/apply-kb-update.md` (Step 6, lines 96-100) | documents (prints a 3-step "next steps" sequence: `/review`, `/challenge`, `/service-design-review`) | no (still prints and functions), but **carries the identical staleness bug** (`/review` instead of `/content-review`) the paired edit fixes only in `stage-instructions.md`, and does not mention `/guardian` at all |
| `CLAUDE.md` line 51 / `AGENTS.md` line 51 | documents (generic phrase "strategic evaluation (QC → challenge → service-design-review)", no specific command syntax) | no — remains accurate without edit |
| `logs/guardian-log.md` (not yet present) | — (new artifact; the contract this command introduces) | n/a — zero current consumers of this file; nothing else in the repo reads or parses it |

**Total: 9 distinct file consumers found (excluding the not-yet-present target and its own new log), 1 must-change** (the paired-edit target itself, which is the intended change). One unanticipated consumer surfaced by the inventory (`apply-kb-update.md`) carries the same confirmed defect the change fixes elsewhere and is left untouched — see Dimension 3.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `guardian.md` is a project-local, on-demand command (invoked by name), not registered as a hook and not `@import`-ed into any always-loaded file — pay-as-used. Confirmed via `ls .claude/commands/` — no SessionStart/PreToolUse/Stop hook entries reference `guardian` in `.claude/settings.json` (read in full; only existing hooks are friction-log-auto.sh, log-write-activity.sh, detect-innovation.sh, check-claim-ids.sh, and the checkpoint/archive/sync SessionStart chain — none of which are new or modified by this change).
- `friction-log: true` opts into the project's existing PreToolUse-on-Skill friction hook — an already-established, opt-in pattern shared by `content-review.md`, `challenge.md`, `service-design-review.md`, `review.md` (all confirmed via direct read); not a new mechanism.
- `model: sonnet` is declared per-command frontmatter, consistent with `CLAUDE.md` line 43's own stated convention ("Orchestrator/dispatch commands... declare `model: sonnet` in frontmatter where cost matters") — `/guardian` is precisely that class of command.
- The paired edit touches `reference/stage-instructions.md`, which is explicitly NOT always-loaded — its own header states: "Not needed for every turn" (read directly, line 1 area). No content is added to workspace or project `CLAUDE.md`.

### Dimension 2: Permissions Surface
**Risk:** Low

- `.claude/settings.json` (read in full) already grants, unrestricted: `"Skill"`, `"Write"`, `"Edit"`, `"Bash(*)"`, `"Agent"`, with `"defaultMode": "bypassPermissions"`. `/guardian`'s three actions — invoking four existing commands via the Skill tool, writing one line to a new file, presenting a chat summary — all fall entirely within permissions already granted; nothing new is requested.
- No `allow`/`deny` entries need to change. No scope escalation (still project-local, no cross-repo or external-API capability introduced).

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Consumer Inventory: 9 distinct file consumers, only 1 must-change (the paired-edit target itself). No caller of `content-review`/`challenge`/`service-design-review`/`reconcile` needs modification — they remain independently invokable exactly as before.
- **The inventory surfaced a real, unanticipated gap `CHANGE_DESCRIPTION` did not name:** `.claude/commands/apply-kb-update.md` lines 96-100 print an identical "next steps" instruction — `1. /review {section} {draft-NN}` / `2. /challenge...` / `3. /service-design-review...` — carrying the exact same staleness bug (`/review` instead of `/content-review`) that the paired edit fixes only in `stage-instructions.md`. This file is not touched by the change and will continue to point operators at the wrong command, with no mention of the new `/guardian` entry point either.
- `.claude/commands/draft-section.md` Phase 3 (lines 51-53, read in full) independently offers `/content-review` and `/challenge` as ad hoc, individually-invoked next steps — a second, un-updated menu that will now sit alongside the newly-canonical `/guardian` sequence without referencing it.
- The paired-edit target (`reference/stage-instructions.md` § Strategic Evaluation) gates every Part 2 / Working Hypotheses approval in this project — narrow but real shared-infra reach; a wording error there (as the staleness bug shows) propagates to every future approval cycle until caught.
- Nothing breaks (backwards-compatible; all four invoked commands are unmodified), which keeps this out of High, but the confirmed presence of the same defect in a second, unaddressed file, plus the not-updated alternate menu in `draft-section.md`, is more than a single-isolated-file, no-contract-change Low.

### Dimension 4: Reversibility
**Risk:** Medium

- `guardian.md` itself: a single new file — `git revert` (or delete) fully removes it, no sibling files created by the command definition itself.
- **Confirmed via direct read of `.claude/hooks/detect-innovation.sh`:** this PostToolUse hook fires unconditionally on any Write matching `.claude/commands/[^/]+$` (or `agents/`, `hooks/`) and appends a `| {date} | command | .claude/commands/guardian.md | detected | — |` row to `logs/innovation-registry.md` at creation time (dedup by path). A plain `git revert` of `guardian.md` does **not** remove this row — exactly the canonical example the Reversibility rubric names ("modifies data/log files... where revert leaves stale entries that carry forward").
- `logs/guardian-log.md` is a brand-new, dedicated append-only log (confirmed via the Consumer Inventory to have zero current readers) — cleanup on revert is simple (delete the whole file, since nothing else depends on it), but is still one extra manual step beyond a code revert.
- Checked (and ruled out as a risk): the PostToolUse auto-commit hook only fires for paths matching `/(preparation|execution|analysis|report|parts)/` (confirmed via the hook's own regex in `.claude/settings.json`) — `logs/guardian-log.md` does not match, so its writes are not auto-committed. Also checked `.claude/hooks/log-write-activity.sh` — it only appends to `logs/friction-log.md` while a friction session is active, which is standard, uniform behavior for every friction-logged command in this project already, not a `/guardian`-specific new burden.
- No state propagates beyond the local repo (no push, no external API).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- `/guardian`'s dependency on `content-review.md`'s exact internal behavior (PASS→auto-promote-to-`approved/`, CONDITIONAL/REVISE→auto-triage-loop) and on `/reconcile`'s advisory-only, non-blocking status is **explicitly named in `CHANGE_DESCRIPTION`** — not hidden.
- One real implicit dependency: `/guardian` assumes operators/sessions will discover the new canonical review sequence via `reference/stage-instructions.md` § Strategic Evaluation. But `.claude/commands/draft-section.md` — the command that most directly precedes this stage in the actual drafting workflow (Phase 3, "Offer next steps") — is not updated to mention `/guardian` at all, and still surfaces `/content-review` and `/challenge` as its own menu. A session following `draft-section.md`'s own printed next-steps would never learn `/guardian` exists.
- New contract: `logs/guardian-log.md`'s one-line format (date, target, four verdicts, reconcile report path) is described in `CHANGE_DESCRIPTION` and will presumably be specified in `guardian.md`'s own body once written — documented at the change site, not silently assumed. No downstream parser currently consumes it (confirmed zero consumers in the inventory), so this does not yet rise to an undocumented contract a caller depends on.
- No auto-firing risk — `/guardian` is manually invoked, not hook-triggered.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read: `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` was not read directly this pass (not among the paths the caller pointed at); this dimension is grounded instead in `ai-resources/docs/ai-resource-creation.md` Rule #7 (the complexity-budget gate, cited explicitly by the caller as the applicable test) and the workspace `CLAUDE.md` § Design Judgment Principles / § AI Resource Creation, both read in full in Step 1.

- **Rule #7 complexity-budget gate (AP-7/DR-7 speculative-abstraction, operationalized), applied as the concrete pass/fail test:**
  - **Prong (a) net-simplification:** fails. `/guardian` is net-additive — it replaces no existing command; all four commands it wraps remain independently invokable, unmodified. `CHANGE_DESCRIPTION` does not claim to remove anything.
  - **Prong (b) evidenced-failure:** partially satisfied, but not for the component that most needs it. Searched `logs/friction-log.md`, `logs/coaching-log.md`, and the last 300 lines of `logs/session-notes.md` for evidence of a recurring "operator forgets/skips a review layer" or "verdicts untracked/lost" pattern — **none found** (only unrelated edit-timestamp lines in friction-log.md; `session-notes.md`'s only relevant entry describes a completed, un-dropped three-layer review). The one piece of cited, independently-confirmed evidence — the `/review` staleness bug at `stage-instructions.md:178` — is real (see Dimension 7) but it justifies the **paired text edit**, not the **new command**: the staleness bug could be fixed by changing `/review` to `/content-review` in the existing prose, with no new command required at all.
  - **Inflow rule (RR-05):** half-satisfied. `CHANGE_DESCRIPTION` does name a real, non-memory-dependent invocation path (`stage-instructions.md` § Strategic Evaluation, read at the relevant stage per its own frontmatter — this cures the prior version's "zero consumers" finding). It does **not**, however, state which existing command `/guardian` replaces, nor articulate — with cited evidence — why a separate command is "genuinely necessary" beyond convenience.
  - No `logs/decisions.md` entry records an OP-11 exception for this addition (checked: grepped `decisions.md` for `guardian`/`OP-11`/`complexity budget` — zero hits).
- This is a real tension, not a clean violation of the kind the dimension's canonical High examples describe (it is not speculative for an absent consumer — it has a confirmed one; it is not an enforcement upgrade — both `content-review`'s auto-promote and `reconcile`'s advisory-only status are unmodified pre-existing behavior; it is not boundary expansion; it adds zero new detection). The prior version's two clear High-severity defects (functional overlap with `/contract-check`/`/reconcile`, and zero consumers) are both genuinely cured in this redesign. What remains is: net-additive, with prong-(b) evidence that supports only the paired text-fix, not the orchestrator's own value-add, and no recorded OP-11 exception.
- **Placement (DR-1/DR-3):** correctly placed. Per `ai-resource-creation.md` Rule #1, a command "tightly coupled to that project's pipeline and not intended for reuse" may live project-local — `/guardian` sequences four project-local/project-symlinked commands and is not a reuse candidate. Consistent with how `/reconcile` itself was placed project-local first (its own frontmatter cites Rule 5/DR-7).

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Observed directly, not inherited. Read `reference/stage-instructions.md` lines 174-182 in full: line 178 literally reads `1. QC review first (`/review`) — catch compliance and quality issues.` Read `.claude/commands/review.md` in full: it is confirmed to be the Stage-4/legacy chapter reviewer — it resolves targets to `/report/chapters/chapter-$ARGUMENTS.md`, requires an architecture spec, style reference, and section directive from the (archived) research-workflow pipeline, and its own Step 1.4 is a hard "Blocking-input check" that STOPs if those are missing. Read `.claude/commands/content-review.md` in full: confirmed it is the actual dispatcher for `parts/*/drafts` content (resolves "section and draft" args, uses the `qc-reviewer-buy-side` agent). The staleness claim is directly verified, not asserted.
- **Consequence — traced or assumed?** Traced, not merely inferred. Because `/review` requires the Stage-4 pipeline's architecture/style-reference/section-directive inputs (none of which exist for `parts/` content), its own Step 1.4 blocking-input check would fire immediately if an operator literally ran `/review` against a Part 2 draft — a loud, early stop, not silent wrong analysis. Corroborating evidence that this has not caused real operational harm in practice: `logs/session-notes.md` (last 300 lines) describes a completed three-layer review pass as "QC ×9... `/challenge` ×3... `/service-design-review` ×2" — i.e., whoever ran it used the correct command from context/memory rather than the stale text, consistent with the defect being real but low-severity in observed practice.
- **Re-derivation vs. the change description:** One discrepancy, in the direction of *more* evidence, not contradiction. `CHANGE_DESCRIPTION` names the staleness bug only in `stage-instructions.md`. Independent re-derivation (Consumer Inventory grep) found the identical bug also present in `.claude/commands/apply-kb-update.md` (line 97: `1. /review {section} {draft-NN}`), uncited by the caller and unaddressed by the paired edit. This strengthens rather than undermines the defect claim, but exposes an incompleteness in the fix's scope — captured as a Dimension 3 finding, not a Dimension 7 contradiction.
- The new command's own core justification (sequencing convenience + a consolidated verdict log) is a **capability addition**, not a defect claim — `CHANGE_DESCRIPTION` never asserts the four-command manual sequence is currently broken, only that it is manual. **Not defect-justified — no premise to verify.** Risk: Low (folded into the overall Low; the defect-justified portion of the change — the paired text fix — is independently confirmed Low per above).

## Mitigations

- **Dimension 3 (Blast Radius):** Before or in the same change, also fix the identical `/review` staleness bug in `.claude/commands/apply-kb-update.md` (line 97) — update it to `/content-review` and add a one-line pointer to `/guardian` as the consolidated alternative, so the inventory's unanticipated-consumer gap is closed rather than left standing.
- **Dimension 4 (Reversibility):** If `/guardian` is later reverted or removed, manually delete its "detected" row from `logs/innovation-registry.md` (auto-added by `detect-innovation.sh` on file creation) and delete `logs/guardian-log.md` — a plain `git revert` of `guardian.md` alone will not touch either.
- **Dimension 5 (Hidden Coupling):** Update `.claude/commands/draft-section.md` Phase 3 "Offer next steps" (lines 51-53) to name `/guardian` as the recommended single entry point (or at minimum mention it alongside the existing `/content-review`/`/challenge` options), so operators following that more immediately-visible menu don't miss the newly-canonical review path.
- **Dimension 6 (Principle Alignment):** Log a one-line OP-11 exception in `logs/decisions.md` at land-time, citing this risk-check report and stating plainly: `/guardian` is added despite lacking friction-log/defect-log-cited evidence for its core sequencing/logging value-add (only the paired staleness-bug text-fix has such evidence); justified by zero new judgment, a confirmed real invocation path, full single-file reversibility, and sonnet-tier cost. This converts the complexity-budget gap from silent drift into a loud, recorded decision — the dimension's own prescribed remedy for a component that does not cleanly clear prong (a) or (b).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
