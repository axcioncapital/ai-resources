# Risk Check — 2026-07-03

## Change

System Owner v2 build — stage S0 change set (plan-time gate, session S5 2026-07-03). Five changes: (1) refresh the two stale vault grounding docs projects/repo-documentation/vault/architecture/system-doc.md and projects/repo-documentation/vault/blueprint/blueprint.md (B14 input hardening — advance last_updated, clear drift markers and [PHASE-2-FILL] markers, correct stale counts; these are grounding docs the system-owner agent routes to per projects/axcion-ai-system-owner/references/grounding.md read map); (2) create projects/axcion-ai-system-redesign/inputs/ and place a copy of the SO v2 context pack there plus a Session-F re-reconcile checkpoint note (R1 redesign-collision mitigation wiring, cross-project write into a sibling repo); (3) new file projects/axcion-ai-system-owner/output/v2-baseline-2026-07-03.md (one-time numeric baseline for B15 metrics — additive); (4) new file projects/project-planning/output/system-owner-v2/per-unit-plan.md (resolves the 12 control-pack pieces into per-unit work plan — additive, sibling of the control pack); (5) status flip of the 2026-06-02 grounding-corpus entry in ai-resources/logs/improvement-log.md to resolved-with-evidence (in-place edit of a shared non-append log while a foreign session marker S4 is live in the checkout and the file already carries uncommitted status flips from an earlier session today). NO canonical command/agent edits this session — the originally-planned consult.md pre-consult grounding check was found already implemented agent-side (system-owner.md Phase 1.5 REQUIRED-halt, June rebuild) and the backlog item closes as already-resolved instead.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/system-doc.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/blueprint/blueprint.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/inputs/ — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/v2-baseline-2026-07-03.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/per-unit-plan.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/control-pack/execution-roadmap.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/control-pack/risk-assumptions-register.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/grounding.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Four of the five changes are low-risk additive or backwards-compatible content edits; the single elevated risk is change (5) — an in-place status flip of the shared `improvement-log.md` inside an ordinary build session while a foreign S4 marker is live and earlier uncommitted flips already sit in the file, which lands squarely on a documented lost-update surface and a maintenance-owned-mutation invariant.

## Consumer Inventory

Live consumers only. The ~120 `audits/**` hits for `system-doc.md` / `blueprint.md` are historical write-once records (risk-checks, DDs, log-sweeps) that name the docs as-of a past date; they are not runtime consumers and are excluded per the blast-radius definition.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/agents/system-owner.md | parses (reads system-doc.md + blueprint.md on every invocation via the grounding.md read map; Phase 1.5 REQUIRED-halt depends on them being present/readable) | no |
| ai-resources/.claude/agents/pipeline-review-auditor.md | imports (reads `vault/blueprint/blueprint.md` as grounding, line 40) | no |
| projects/axcion-ai-system-owner/references/grounding.md | documents (§1 table hardcodes system-doc.md=373 lines / blueprint.md=137 lines + token estimates) | no (soft co-edit if the refresh shifts line counts materially) |
| ai-resources/.claude/commands/resolve-improvement-log.md | parses (Step 3 tier-2 convention: `**Status:**` line must contain `resolved` + `YYYY-MM-DD` to classify+archive the flipped entry) | no |
| ai-resources/.claude/commands/friday-checkup.md | parses ([STALE] scan matches the `logged (pending)` compound token the flip removes) | no |
| /friday-act, /open-items, /prime scan, session-feedback-collector | parses/documents (read improvement-log.md entry state) | no |
| projects/project-planning/output/system-owner-v2/control-pack/risk-assumptions-register.md (R1) | documents (names "place the SO v2 control pack into the redesign's inputs/ + add a re-reconcile checkpoint to Session F" as the R1 mitigation wiring) | no |
| projects/axcion-ai-system-redesign — Session F workflow | invokes/consumes (the re-reconcile checkpoint note; future consumer — inputs/ dir not present yet) | no |
| ai-resources/logs/session-plan-2026-07-03-S5.md | documents (names per-unit-plan.md, v2-baseline, inputs/ wiring) | no |

Total: 9 distinct live consumers, 0 strictly must-change. Two `not yet present` targets (redesign `inputs/`, `v2-baseline`, `per-unit-plan`) have no consumers yet; the inventory covers the contracts they introduce (R1 mitigation input for the redesign; B15 baseline; the per-unit build plan). No live parser scans for `[PHASE-2-FILL]` (grep of `ai-resources/.claude` returned zero) — the W2.1 auto-updater that would consume that marker does not exist yet, so clearing the markers breaks nothing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file changes — no workspace/project CLAUDE.md edit, no new hook, no new `@import`. Grep of the change set shows no `.claude/settings*.json` or CLAUDE.md target.
- The two vault docs are grounding-loaded per system-owner invocation, but the refresh is net-neutral-to-shrinking: it clears `[PHASE-2-FILL]` blocks and drift markers and corrects counts (change description) — it does not expand the always-read surface. grounding.md §1 estimates system-doc.md ~7,000 tok / blueprint.md ~2,500 tok; the refresh does not push these up.
- New files (`v2-baseline`, `per-unit-plan`) are pay-as-used outputs, read only when a build/metrics session opens them. The redesign `inputs/` copy is read only by the redesign project on demand.

### Dimension 2: Permissions Surface
**Risk:** Low

- Zero settings changes: no `allow`/`ask`/`deny` edits, no scope move between settings layers. No file in the change set is a `settings.json`.
- Change (2) writes into a sibling git repo (`projects/axcion-ai-system-redesign/` has its own `.git`, `.gitignore`, `.claude`). Cross-repo writes are an established workspace pattern here — the control pack itself states the build "spans three repos" and commits per-repo (execution-roadmap.md § Gate cadence) — so this exercises an existing capability, not a new one. No permission entry is widened.
- No shell/external-API/MCP capability introduced. Under the workspace `bypassPermissions` floor no prompt fires regardless.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: ~6 across 3 repos — 2 vault-doc edits (repo-documentation), 1 in-place log edit (ai-resources), 3 new files (axcion-ai-system-owner, project-planning, axcion-ai-system-redesign).
- Consumer count (Step 1.5): 9 live consumers, 0 must-change. The vault-doc refresh is backwards-compatible — the live agent consumers (`system-owner.md`, `pipeline-review-auditor.md`) read whatever content is present and stay compatible; Phase 1.5's REQUIRED-halt cares only that the files read successfully, which the refresh preserves.
- Contract-conforming edit (parses rows): the improvement-log status flip must land in the exact tier-2 shape `resolve-improvement-log.md` Step 3 expects (`**Status:**` line contains `resolved`/`RESOLVED` + `YYYY-MM-DD`; a `resolved` token in prose does not qualify — improvement-log.md schema line 9). If the flip is written loosely it silently fails to archive; if written correctly it is compatible.
- Shared-infra driver: `improvement-log.md` is read by ≥5 maintenance workflows (`/resolve-improvement-log`, `/friday-checkup` [STALE], `/friday-act`, `/open-items`, `/prime`). The in-place flip touches this shared surface **while** a foreign S4 marker is live and earlier uncommitted flips already sit in the working tree — this is the sub-item that lifts the dimension to Medium (the vault/new-file side alone is Low). Not >5 must-change callers and no non-backwards-compatible contract break, so it stays Medium rather than High.
- Unanticipated-consumer check: the redesign project's own CLAUDE.md declares unit inputs live in `window-outputs/`, not `inputs/` — so creating `inputs/` is a *new artifact category* in that project (a `/placement` trigger by workspace rule). Not a blast-radius break, but a placement note the change description does not surface.

### Dimension 4: Reversibility
**Risk:** Medium

- Vault-doc edits and the two additive output files revert cleanly *within their own repos* (a commit revert deletes the new files, restores the doc text).
- Multi-repo rollback: the change spans 3 repos (repo-documentation, ai-resources, project-planning) plus a 4th for the redesign `inputs/` copy — a revert is per-repo, not a single `git revert`. One extra step per repo.
- The improvement-log in-place flip is the reversibility driver: the file "already carries uncommitted status flips from an earlier session today" (change description). A commit that stages the flip will bundle it with the earlier session's flips unless commit-boundary sequencing is applied (`commit-discipline.md` § Commit-boundary sequencing — "`git add` cannot split a file by intent"). If bundled, reverting this change also reverts the earlier session's flips (collateral) — a multi-step manual un-bundling, not a clean revert. Mitigable by sequencing the flip as its own commit; hence Medium, not High.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Maintenance-owned-mutation invariant (the dominant finding).** `commit-discipline.md` § Maintenance-owned in-place mutations states the rule explicitly: "in-place mutations belong to dedicated single-purpose sessions, never to ordinary work" — status flips of `improvement-log.md` happen "only inside a dedicated, single-purpose session — the maintenance cadence (`/friday-act`, `/resolve-improvement-log`) … and `/fix-repo-issues` plan execution." This S0 is a **build session**, not one of those dedicated paths. Change (5) performs exactly the in-place status flip the invariant reserves for maintenance-cadence sessions — bending a documented guardrail whose stated purpose is "a guardrail against future drift (a new command that 'helpfully' flips a status as a side-effect of ordinary mid-session work would violate it)."
- **Lands on the known lost-update surface.** The same doc's § Shared-log write-path integrity and § Maintenance-owned … table classify improvement-log in-place mutation as a "Lost-update surface … 'keep both' is semantically wrong." The change stacks the two aggravating conditions the rule warns about simultaneously: a live foreign S4 marker in the checkout *and* earlier uncommitted flips in the same file. Two in-place mutations racing on the same entries is the Failure-A/B collision class.
- **grounding.md line-count coupling.** grounding.md §1 hardcodes system-doc.md=373 / blueprint.md=137 lines (+ token estimates). The refresh clears marker blocks and corrects counts, which will shift line counts; grounding.md silently drifts from the docs it maps. Advisory (the counts are estimates, not load-bearing parse targets), but a real implicit two-end coupling.
- **Low-coupling items (for completeness):** clearing `[PHASE-2-FILL]` markers has no live parser (W2.1 absent — grep confirmed zero consumers in `ai-resources/.claude`), so it introduces no coupling. The vault refresh is otherwise self-contained.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-12 (closure before detection) — actively served.** The change *closes* the 2026-06-02 backlog entry rather than adding detection: the proposed pre-consult grounding check was found already built agent-side (`system-owner.md` Phase 1.5 REQUIRED-halt, lines 39–47), and the grounding corpus is being refreshed/made-present. Closing a finding with no new detection is the OP-12-positive direction (principles-base.md OP-12).
- **DR-7 / AP-7 (speculative abstraction) — clear.** The `inputs/` copy, `v2-baseline`, and `per-unit-plan` all serve *confirmed* consumers: the redesign is a real, scoped, active project with a Session F (risk-assumptions-register.md R1), and the v2 build is an approved 12-piece program. No building for an absent consumer; no "hooks for later."
- **OP-10 (system boundary) — clear.** No cross-tool (GPT/Perplexity/Notion/NotebookLM) coordination introduced.
- **DR-6 (inputs are read-only references) — mild tension, named.** DR-6's own note records that `strategic-os/inputs/` is write-denied to Claude on this exact convention. Change (2) has Claude *write* into a sibling project's `inputs/` dir. The semantic here is defensible (provisioning a read-only reference *for* the redesign to consume, operator-owned per R1's "Mitigation owner: operator") and the redesign carries no `inputs/` write-deny, so this is a tension to note, not a violation. Placement footnote: the redesign uses `window-outputs/` for unit inputs, so `inputs/` is a new dir there (`/placement` would fire).
- No frozen-ID principle is violated. The maintenance-owned-mutation issue (change 5) is a documented `commit-discipline.md` rule, not an OP/DR/QS/AP principle, so it is scored under Dimensions 3–5 rather than invented as a principle here.

## Mitigations

- **Dimension 5 (High) — required.** Take the `improvement-log.md` status flip (change 5) off the ordinary-work path. Preferred: **defer the flip to a dedicated `/resolve-improvement-log` (or `/friday-act`) session**, honoring the maintenance-owned-mutation invariant — the S0 build can proceed on changes (1)–(4) without it. If the flip must land in this session: (a) run the § Shared-log write-path integrity entry-count guard — `git show HEAD:logs/improvement-log.md | grep -c '^### '` vs the working count, and STOP-loud if the working count is lower; (b) stage `improvement-log.md` with an **explicit pathspec only** (no `git add -A`/dir wildcards — the check-foreign-staging tripwire and § Concurrent-session staging discipline require this while S4 is live); (c) run `git diff --cached logs/improvement-log.md` and confirm every staged hunk is yours, including that the earlier session's uncommitted flips are not swept in; (d) sequence the flip as its **own commit boundary** so a later revert can isolate it; (e) confirm no concurrent maintenance-cadence session is mutating the same file.
- **Dimension 3/4 (Medium) — recommended.** Commit per-repo with explicit pathspecs (three/four repos); after the vault refresh, check whether grounding.md §1's `373`/`137` line counts still hold and co-edit them if they shifted materially, so the grounding map does not silently drift.
- **Dimension 3 (Medium) — recommended.** Before creating `projects/axcion-ai-system-redesign/inputs/`, note that the redesign project's convention is `window-outputs/`; confirm `inputs/` is the intended home (a `/placement`-class decision) rather than `window-outputs/` or a `pipeline/` input slot.

## Recommended redesign

Not applicable (verdict is PROCEED-WITH-CAUTION).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (system-owner.md Phase 1.5 lines 39–47; grounding.md §1 line counts; improvement-log.md schema line 9; commit-discipline.md §§ Maintenance-owned in-place mutations / Shared-log write-path integrity / Commit-boundary sequencing), grep counts (zero live `[PHASE-2-FILL]` parsers in `ai-resources/.claude`; ~120 audit-only hits for the vault docs excluded as historical), verbatim quotes from CHANGE_DESCRIPTION and referenced files, and principle IDs from principles-base.md (OP-12, DR-7/AP-7, OP-10, DR-6). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-risk-check-second-opinion-a-proposed-structural-change.md

**Concur with PROCEED-WITH-CAUTION — yes.** The verdict is right because it isolates risk in the one in-place mutation (change 5) rather than blocking four genuinely additive changes. But the five-guard "land it now" path is **not equal-safety** — picking it soft-downgrades a binding verdict (DR-8).

**(a) Defer the flip — yes, strongly.** A status flip is an in-place mutation, not an append, so it falls outside risk-topology § 5's zero-risk append carve-out. The decisive flaw: because the target flip **cannot be hunk-split** from the two earlier abandoned-session flips, guard 2 (explicit pathspec) and guard 4 (own commit boundary) are **mutually unsatisfiable** — `git add` on the file necessarily commits all three. Add the live foreign S4 marker → `check-foreign-staging.sh` HARD-BLOCKS the commit (risk-topology § 1 High). The flip is book-keeping the S0 build has zero dependency on, so deferring costs nothing on the critical path. Route it to `/resolve-improvement-log` in a clean, marker-free session — its canonical owner (OP-12 closure-before-detection; DR-8 verdict not downgraded).

**(b) `inputs/` home — a real conflict; name it.** Redesign CLAUDE.md says `window-outputs/`; approved control pack R1 says `inputs/`. Surface it, don't silently pick (OP-3/AP-1). Follow R1 (`inputs/`) — it's the purpose-built, operator-approved directive — **and** record the exception in the redesign CLAUDE.md so convention and practice don't drift (DR-5/OP-11). The copy is DR-6-justified (approved plan = explicit request). Note: `strategic-os/inputs/` is read-only-reference by convention, so document the write-once-then-read-only lifecycle to keep `inputs/` semantically consistent workspace-wide.

**Risks the dimension review under-weighted:**
1. **Its own guard set is internally contradictory** (guards 2+4) — Hidden-coupling HIGH flags the lost-update surface but not that the containment can't contain it. Sharpest miss.
2. **Grounding-base self-reference:** system-doc.md + blueprint.md are the SO agent's *own* grounding base (grounding.md § 1) — refreshing mid-build changes what future consultations rest on. Run independent QC (QS-1); Principle-alignment "Low" under-weights it.
3. **blueprint.md is auto-rewritten by W2.1** — a manual refresh can be clobbered by the next doc-scanner run; the "Medium" reversibility score misses this involuntary-revert path.

**Position:** PROCEED with (1)–(4) as scoped; **defer (5)**. That keeps the whole S0 set clean without weakening the binding verdict.
