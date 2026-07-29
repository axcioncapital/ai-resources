# Risk Check — 2026-07-19

## Change

Retroactive end-of-session risk-check for W1.5 (change class: new commands/skills). This session shipped, already committed as 25de7cf: (1) workflow/article-workflow.md — a new 10-step, two-mode article-production workflow document (prose, no runtime behavior); (2) three new project-local skills under .claude/skills/ — article-production, internal-knowledge-synthesis, article-review-gate — each a SKILL.md with explicit model: opus frontmatter, invoked by the operator/session (not auto-firing, no hook wiring); (3) workflow/avoid-set-check.sh — a standalone bash script that greps a draft file against a firm-canon banned-vocabulary list and exits non-zero (exit 1) only on hard-band hits, exit 0 otherwise — it is invoked manually at workflow step 8 by whoever is running review; it is not wired into any git hook, CI, or automated trigger, and it never blocks or auto-rejects — it only prints findings and sets an exit code the human reviewer reads. No hooks, permissions, symlinks, or CLAUDE.md files were touched (verified: git show --stat 25de7cf contains no hooks/settings.json/CLAUDE.md paths). No shared/cross-project state was modified — everything lives inside projects/axcion-content-programme. avoid-set-check.sh is referenced nowhere except its own file (verified via repo-wide grep) — confirming manual-only invocation, no automated wiring. All three SKILL.md files carry model: opus frontmatter (verified). This risk-check is being run AFTER commit as the wrap-session end-time backstop (per wrap-session.md Step 12b), because the operator explicitly waived the plan-time /blindspot-scan and pre-commit /risk-check gates during execution ("let's just start executing, no gates"). No independent /qc-pass has reviewed the actual content of these artifacts (the workflow doc's 10 steps, the three skills' method content, or the script's term-list accuracy) — only mechanical/structural verification was performed (sufficiency-criteria checks, fixture tests on the script). Assess the risk of what was shipped, including whether the absence of independent content QC is itself a material risk given W1.6 (the next work unit) will rely on this machinery for real article production.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/skills/article-production/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/skills/internal-knowledge-synthesis/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/skills/article-review-gate/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/avoid-set-check.sh — exists

## Verdict

GO

**Summary:** Six of seven dimensions score Low — the change is a self-contained, project-local addition with zero cross-project footprint, zero permission change, a clean single-commit revert path, and a well-documented (not hidden) internal coupling; Dimension 6 scores Medium because a mandatory-by-default QC gate was skipped, which is a loudly recorded operator override rather than a silent violation, but leaves a residual, still-open risk the report names explicitly.

## Consumer Inventory

Search terms derived from the five referenced files' basenames/component names (`article-workflow`, `article-production`, `internal-knowledge-synthesis`, `article-review-gate`, `avoid-set-check`) were grepped across the project repo (`projects/axcion-content-programme`), `ai-resources/`, and the workspace root, per Step 1.5. Command used: `grep -rniI --exclude-dir=.git "<term>" <path>`, run separately against the project repo and against `ai-resources` + workspace root (excluding the project itself).

**Outside the project repo:** zero live consumers. The only hit outside `axcion-content-programme` is a dated, historical `/risk-check` report (`ai-resources/audits/risk-checks/2026-07-18-plan-time-gate-create-reference-research-procedure-md-in.md`), which predicted `workflow/article-workflow.md` as a *future* consumer of a different file before it existed — that prediction is now resolved (the file exists) and the historical report needs no update. This confirms the change description's "no shared/cross-project state was modified" claim.

**Inside the project repo**, all 14 distinct hits are `documents`-type references (prose mentions in spec, roadmap, pipeline, and log files) or `co-edits` (log files updated in the same commit) — none are `invokes`/`parses` dependencies external to the five changed files themselves. The five changed files also reference each other internally (the workflow doc names all three skills by step; `article-review-gate/SKILL.md` invokes `avoid-set-check.sh`) — this is the change's own designed three-way ownership split, not an external consumer.

| Consumer path | Reference type | Must change? |
|---|---|---|
| CLAUDE.md (project) | documents | no |
| .claude/commands/select-articles.md | documents | no |
| roadmap/article-priorities.md | documents | no |
| reference/editorial-standards.md | parses (reciprocal ownership-split pointer) | no |
| pipeline/project-plan.md | documents (spec) | no |
| pipeline/architecture.md | documents (spec) | no |
| pipeline/implementation-log.md | documents (historical build log) | no |
| pipeline/implementation-spec.md | documents (spec) | no |
| pipeline/test-results.md | documents (historical test log) | no |
| output/context-packs/skill-20260719-c4f1a/pack.md | documents (dispatch mandate) | no |
| logs/session-notes.md | co-edits | no |
| logs/decisions.md | co-edits | no |
| logs/improvement-log.md | co-edits (closes a finding) | no |
| logs/2026-07-19-project-next-steps.md | documents | no |

Total: 14 consumers, 0 must-change. All confined to one project; zero cross-project or shared-infrastructure consumers found. Note on the change description's claim "avoid-set-check.sh is referenced nowhere except its own file": this overstates the finding — the grep shows it IS referenced in `workflow/article-workflow.md` and `.claude/skills/article-review-gate/SKILL.md` (its two intended, designed invocation points) plus three log files documenting it. The underlying claim that matters — no hook, CI, or `settings.json` reference — is independently confirmed true (see Dimension 7).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file (workspace or project CLAUDE.md) was touched — confirmed via `git show --stat 25de7cf`, no `CLAUDE.md` path in the diff.
- No hook was added or registered — confirmed via the same stat output (no `.claude/hooks/*` or `settings.json` path) and via direct listing of `.claude/settings.json`, which shows only the pre-existing two `SessionStart` hooks (`auto-sync-shared.sh`, `check-permission-sanity.sh`), both pre-dating this change.
- Three `SKILL.md` files added, each `model: opus`, `effort: high` — but each carries a narrow, project- and step-scoped `TRIGGER`/`SKIP` pair (e.g. `article-production/SKILL.md:9`: "TRIGGER when: producing an article draft under workflow steps 1, 4, 5, 6, or 7"). These are pay-as-used, invoked only when the matching workflow step is active in this one project — not broadly pattern-matching trigger language that would auto-load across unrelated sessions.
- `avoid-set-check.sh` has zero token cost of its own — it is a bash script invoked manually, not a Claude-facing resource.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`deny`/`ask` entry was added, removed, or narrowed — confirmed via `git show --stat 25de7cf` (no `settings.json` path) and via direct read of `.claude/settings.json` (unchanged, `defaultMode: bypassPermissions`, `Bash(*)` already broadly allowed pre-existing).
- Running `bash workflow/avoid-set-check.sh <file>` requires no new grant: the project's settings already carry `"Bash(*)"` under `allow`, pre-dating this change — the script uses no capability the project didn't already have.
- No external API, MCP, or cross-repo write capability is introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: **14 consumers found inside the project, 0 must-change; 0 consumers found outside the project.**
- The raw mention-count (14) exceeds the heuristic's ">5" trigger point on a literal count, but the *composition* drives the score down: 100% of the 14 are `documents`/`co-edits` type — prose mentions in the project's own pipeline-spec, roadmap, and log files, none of which functionally depend on the shipped artifacts' exact shape. None require modification to keep working. The pipeline-spec subset (`implementation-log.md`, `test-results.md`) are point-in-time historical build records ("W1.5 absent — PASS") that remain accurate as history and are not live dependents.
- Direct file footprint of the commit itself: 8 files (3 `SKILL.md`, `workflow/article-workflow.md`, `workflow/avoid-set-check.sh`, plus 3 log files — `logs/decisions.md` +3 lines, `logs/improvement-log.md` 1 status line, `logs/session-notes.md` +12 lines).
- No contract change to an existing caller's schema — this is new machinery with no prior consumer to break.
- Shared infrastructure touched: only the project's own `logs/` (routine wrap-session log append, the expected mechanism, not a novel touch).

### Dimension 4: Reversibility
**Risk:** Low

- Single commit (`25de7cf`), 8 files, all additions or routine log appends. `git revert 25de7cf` cleanly restores prior state, including correctly re-opening the `improvement-log.md` finding it closes (the revert of the *fix* correctly re-exposes the *problem* — not a stale-carry-forward case).
- Confirmed via direct filesystem check: `articles/drafts/` and `articles/published/` both contain only `.gitkeep` — W1.6 has not started, so no downstream artifact (a real draft, a source-pack entry) yet depends on this machinery. A revert today strands nothing.
- Confirmed via `git rev-list --count origin/main..HEAD`: **5 unpushed commits**, including `25de7cf`. Nothing has propagated beyond the local repo — no push, no external write.
- No automation was added that could fire between now and a potential revert (the script is manual-invocation-only, confirmed under Dimension 7).

### Dimension 5: Hidden Coupling
**Risk:** Low

- `avoid-set-check.sh` mirrors (does not runtime-parse) the firm-canon term list — a deliberate, explicitly documented coupling, not a hidden one: the script's own header states "SOURCE OF TRUTH — do not edit the term lists from a draft session... When canon changes, change it there, then mirror it here," and the same tradeoff is recorded in `logs/decisions.md:26` and `logs/improvement-log.md:31` with its accepted cost named. A coupling this explicitly documented at three sites does not meet the dimension's "undocumented new contract" bar.
- The `bash workflow/avoid-set-check.sh <file>` invocation contract is named in three places (the script itself, `workflow/article-workflow.md:184-190`, `article-review-gate/SKILL.md:44-50`) — not a single undocumented site.
- The reviewer-independence rule ("Runs in a DIFFERENT session from drafting... must not acquire any [drafting context]," `article-review-gate/SKILL.md:7`) is a discipline-based, not mechanically enforced, constraint — but it aligns with (rather than fights) Claude Code's own default session-isolation model and the workspace's own `Session Boundaries` rule, so it is not a fragile or surprising dependency.
- Explicit non-overlap check: the workflow doc states the canonical `jargon-gloss` skill is "deliberately not adopted by this project" (`article-workflow.md:162`) — ruling out the most likely functional-overlap candidate rather than leaving it silently ambiguous.
- All files the workflow/skills assume exist do exist — verified directly: `reference/publication-gate.md`, `reference/editorial-standards.md`, `roadmap/article-priorities.md`, `roadmap/content-pillars.md`, `roadmap/article-roadmap.md`, `knowledge/reusable-knowledge-inventory.md`, `logs/lessons-log.md` all present. `knowledge/buyer-fit-source-pack.md` is absent, but the workflow doc names it "Reads / writes" at step 5 — i.e. created on first use, not a missing prerequisite.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read; available) and workspace CLAUDE.md § QC Independence Rule / § Blind-Spot Scan Gate.

- **QS-1 / QS-9 / OP-11 — QC-independence gate skipped, but loudly.** Workspace CLAUDE.md's QC Independence Rule marks an architectural `/risk-check`-class change as commit-blocked without independent QC ("Do not self-QC-and-commit"). This change (3 new skills + 1 new script, a listed change class) landed without an independent `/qc-pass` on content. However, this was not silent drift: `logs/session-notes.md:266` records "Operator directed skipping the plan's structural gates (`/blindspot-scan`, pre-commit `/risk-check`) — 'Let's just start executing, no gates,'" and the same session's own `### Risky actions` (line 270) and `### Findings Declined` (line 274) sections name the override, its cause, and the applied mitigation (mechanical sufficiency checks + fixture tests, explicitly distinguished from content QC) in place. This is the OP-11/OP-3 "loud, deliberate revision, never silent drift" pattern working as designed — not an unacknowledged violation. **The residual risk is not the override's legitimacy but its still-open state**: `logs/session-notes.md:282` itself names the unclosed follow-up — "Consider an independent `/qc-pass` on the W1.5 artifacts before W1.6 leans on them — no independent review has seen the workflow doc, the three skills, or the script yet." That follow-up has not yet run as of this report.
- **OP-9 / DR-7 / AP-7 — speculative abstraction: not triggered.** The Consumer Inventory shows zero external consumers, which would ordinarily be the speculative-abstraction signal — but here the "second confirmed consumer" test is better read as "a concrete, already-selected near-term use," and that exists: article one (*What Buyer Fit Means in Practice*) was approved at Checkpoint A gate 2 before W1.5 ran (`9b8143a`), and W1.6 — producing that article through this exact machinery — is the explicit next step (`logs/session-notes.md:281`). The build is also explicitly capped against over-building: "Three skills, not nine" (`article-workflow.md:245`), with pre-splitting beyond the three reserved for W1.7/W2.3 "against observed problems from real articles — never in advance" (`logs/decisions.md:25`). This is the opposite of "hooks for later."
- **ai-resource-creation.md rule #7 (complexity budget)** applies loosely here — the rule targets canonical commands/agents/mandatory gates; these are project-local skills, which rule #1 of the same doc explicitly permits to live outside the canonical pipeline when "tightly coupled to that project's pipeline." Prong (b) (evidenced-failure) is cleanly satisfied for `avoid-set-check.sh` alone (a real, dated, `logs/improvement-log.md:29-41` incident). The workflow doc and two of the three skills are not failure-evidenced — they are the pre-scoped, two-tier deliverable of the project's own architecture (`pipeline/architecture.md:13-16`, Tier 2 "deliberately not pre-built," authored at W1.5 "after W1.4 selects article one"). That prior architecture decision is itself a recorded, deliberate design choice — a defensible substitute for prong (b), not a clean pass, hence Medium rather than Low on this sub-point too.
- **OP-2 / OP-5** — no automation moved from advisory to enforcement: the script "flags; it does not decide" (its own header, and `article-review-gate/SKILL.md:50`), and no judgment call was automated away from the operator (the publication decision remains explicitly Patrik's, `article-workflow.md:199`).
- **OP-10** — no cross-tool boundary expansion; the change is Claude-Code-only.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Mixed, and graded separately per component. For `workflow/avoid-set-check.sh`: **observed**. `logs/improvement-log.md:29-43` records a real, dated incident — "the phrase 'buyer universe' was written twice" into `roadmap/article-roadmap.md`, "caught only because the session chose to re-run a manual grep sweep before committing," tagged "**Observed, not inferred**: the term was written, committed to a draft artifact, and removed before the final commit this session." I independently re-ran the shipped script against fixture text containing "buyer universe" and confirmed it fires (`[HARD] Access / marketplace framing`, exit code 1); against "lower-mid-market" and confirmed no false positive (exit code 0); against bare "mid-market" and confirmed it correctly fires the retired-term rule (exit code 1) — the claimed fixture behavior is independently reproduced, not merely asserted. For `workflow/article-workflow.md` and two of the three skills: **not a defect claim** — see below.
- **Consequence — traced or assumed?** Traced. The defect (an undetectable-by-habit banned term) directly produced the claimed failure mode (a real committed-then-caught near-miss the same day), and the shipped script's exit-code behavior against both a dirty and a clean fixture was independently reproduced by me, not taken on the change description's word.
- **Re-derivation vs. the change description:** One overstatement found and corrected in the Consumer Inventory section above — "avoid-set-check.sh is referenced nowhere except its own file" is false as literally stated (it is referenced, by design, in `article-workflow.md` and `article-review-gate/SKILL.md`); the claim that actually matters — no hook, CI, or `settings.json` wiring — is independently confirmed true (`grep -rniI "avoid-set-check" .claude/` returns only the one expected `SKILL.md` invocation line; no `.github/workflows` directory exists in the project). All other claims (no hooks/settings/CLAUDE.md touched; all three SKILL.md carry `model: opus`; no shared/cross-project state modified; wrap-session.md Step 12b exists and reads as described; the operator's "no gates" directive and its recording) were independently re-derived and confirmed accurate.
- **Not defect-justified — no premise to verify** for `workflow/article-workflow.md`, `article-production/SKILL.md`, and `internal-knowledge-synthesis/SKILL.md`: these are the operator-approved, pre-scoped W1.5 deliverable of the project's own architecture (a capability build against a specific, already-selected article), not a claimed fix to an observed defect. Risk: Low for this portion, per the "not defect-justified" rule.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
