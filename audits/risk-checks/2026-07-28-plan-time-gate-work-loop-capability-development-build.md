# Risk Check — 2026-07-28

## Change

Plan-time gate for the `/work-loop` + `capability-development` build, per `ai-resources/plans/2026-07-28-work-loop-consolidated-build-plan.md` rev. 3. One payload covering the whole design across all three build sessions.

WHAT IS PROPOSED
Build one operator-facing command `/work-loop` (Claude executes) backed by a Codex controller skill (independent cross-model review), a methodology skill, a contract doc and a record template. `/develop-capability` is NOT built; its methodology becomes a consumed skill.

CREATE (6 files, 5 load-bearing): C1 `docs/work-loop.md` (<=180 lines, the contract); C2 `.agents/skills/work-loop/SKILL.md` (~150 lines, Codex controller); C3 `.claude/commands/work-loop.md` (<=300 line target, Claude executor, model: opus, effort: high); C4 `skills/capability-development/SKILL.md` (350-500 lines, methodology, disable-model-invocation: true); C5 `templates/capability-record.md` (~75 lines); C6 the plan document itself (not a component).

MODIFY (6): `develop-ai-resource.md` (+~10 lines additive); `templates/README.md`; `new-project.md` (add work-loop to the CORE symlink set); `inbox/codex-second-opinion-brief.md` (git mv to archive); `docs/ai-resource-creation.md` (one sentence in rule #4); the superseded plan (banner).

APPEND (1): `logs/decisions.md` — an OP-11 complexity-budget exception.
SYMLINKS (2): S1 workspace-root; S2 `projects/global-macro-analysis/`.

NEW DURABLE STATE AUTHORITY: `projects/{p}/development/{slug}.md` — a new per-project file class with its own schema and a new sole writer (`/work-loop`). Plus a new temporary artifact class `logs/loop/*` committed by pathspec at write time and deleted together at stream close, recoverable from git via SHAs in the record's `## Pointers`.

NEW OPERATOR GATES: three on the "challenged" route only; one conditional on "reviewed"; zero on "solo". No new automated gate, no hook, no blocking check.

EXPLICITLY NOT DONE: no always-loaded content; NO `/prime` edit; NO workspace or project `CLAUDE.md` edit; no permission/hook/settings change; no new agent; no manifest; no registry/index/dashboard/telemetry; no automated route classification or checker.

REVERSIBILITY: strict reverse order only (1->2, 1->3, 1,3,4->5, 1->6, 4->5; 7 independent). Session B reverts whole without touching Session A.

=== PRE-DISPATCH PREMISE VERIFICATION ALREADY RUN — THESE ARE CORRECTIONS TO THE PLAN, NOT OPEN QUESTIONS ===

I executed the verification before dispatching you. 7 of 9 of the plan's §2 counts confirmed exact (91 commands, 42 agents, 27 projects, 25 with manifest, 26 with logs/, zero direct-route projects, workspace root 61 symlinks + 6 real files with no shared-manifest.json, projects/personal/ empty). Three things the plan states are WRONG, and I corrected them here:

(1) `global-macro-analysis` has **39** relative symlinks, NOT the plan's 51. Its 52 entries are 39 symlinks + 13 REAL project-local `kb-*.md` command files. Acceptance test A-DIST-3 asserts "51 siblings" and would fail as written.

(2) `ai-resources/docs/principles.md` DOES NOT EXIST. The plan §12 and `session-start.md` both cite it. The real file is in a different repository (`projects/repo-documentation/vault/principles/principles.md`).

(3) The plan §12 says "rule #7 says build no checker for a design principle." **Misattributed.** Rule #7 (`docs/ai-resource-creation.md:25-34`) is the COMPLEXITY BUDGET with prongs (a) and (b). The "build no checker" text is at :40 and belongs to **RR-05, the inflow rule** — which is the rule I believe this plan VIOLATES. See below.

Also: 80 skills not 81 (immaterial). And an unrelated live worktree exists at `ai-resources/.claude/worktrees/develop-capability` on branch `session/2026-07-28-develop-capability` at the same SHA as main.

=== THE THREE THINGS I MOST WANT YOU TO ADJUDICATE — DO NOT LET ME TALK PAST THEM ===

**A. RR-05 — I think this plan ships a command with no invocation path, which the rule forbids outright.**
`docs/ai-resource-creation.md:36-40` states: *"A proposed new command must state which existing command it replaces, or why a separate command is genuinely necessary — and must name its invocation path (the registered pipeline, cadence, or hook that will call it). **A command whose only trigger is the operator remembering it exists is not shipped; it is wired or deferred.**"*
I verified rev.3 ships NO wiring: §9.4 (line 272) excludes both a `/prime` edit and a workspace `CLAUDE.md` edit; §12 (line 390) excludes the workspace routing rule outright. An earlier revision (rev.2) DID ship workspace `CLAUDE.md` routing and rev.3 removed it. The plan's §7.2 acknowledges only a narrower issue — "a reviewed capability with no mission binding is invisible at session start unless the operator runs `/work-loop`. Accepted." — which addresses *capability visibility*, NOT the command's *invocation path*. Is this an RR-05 violation? If so, does it change the verdict, and is the remedy to restore one wiring point or to defer?

**B. The complexity budget fails BOTH prongs, and the OP-11 precedent is stronger than this case.**
Rule #7 requires clearing at least one prong. Prong (a) net-simplification: this adds 5 components and removes 0 — fails. Prong (b) evidenced-failure requires cited written evidence (friction-log / defect-log / coaching-log / incident-log entry, or a pattern seen >=2 times): I grepped `logs/friction-log.md` and `logs/coaching-log.md` for work-loop / cross-model and found NOTHING — fails. The plan itself concedes both ("the premise remains operator-stated rather than evidenced"; "neither half resting on a logged failure").
The closest precedent, `/lean-repo` (`.claude/commands/lean-repo.md:15`), also failed prong (a) but shipped under OP-11 **justified by prong (b) with cited evidence**. This plan clears NEITHER prong. Is an OP-11 exception still available when both prongs fail, or does OP-11 presuppose at least one prong plus a recorded rationale? Your Dimension 6 is named at `docs/ai-resource-creation.md:44` as the enforcer of this gate at land-time — so this is your call, not mine.

**C. The strongest available evidence may point the other way.**
The superseded plan cited `projects/axcion-systems-builder/CLAUDE.md` as prong-(b) evidence. I read it. It says: *"A Management OS was built and never run; a Strategy OS was built and partly unused... The one lesson carried forward: **building ahead of a real, felt need is what failed.**"* That reads to me as evidence AGAINST building a 5-component system on an unevidenced premise — the same shape as the two failures it records. Am I reading that correctly, or is there a defensible reading where it supports the build?

=== OTHER SELF-DECLARED WEAKNESSES THE PLAN RECORDS — weigh them, do not let me bury them ===
- §2: UNVERIFIED whether Codex selects the new skill from a plain request without being named (test A-CX-1). On failure the plan forbids editing AGENTS.md without separate approval — so the activation mechanism has no approved fallback.
- §6.4: crash atomicity — git commits are atomic, the write sequence leading to one is not. Mitigated by an ordering rule + deterministic reconciliation, NOT closed.
- §13: C3's <=300-line target is explicitly "a design signal, not a relocation target," and moving orchestration into C4 is prohibited. So the size ceiling may simply be exceeded.

=== OPERATOR CONTEXT ===
The operator has approved the session plan and directed that all Session-A structural changes stay UNCOMMITTED until A-CX-1 passes, functional tests pass, and an end-time `/risk-check` clears the complete executed set — only then do commits land in order, followed by post-commit history verification. So this plan-time gate is genuinely pre-execution: nothing is on disk yet.

QUESTION FOR THE GATE: is this proportionate to build now, and are the three §10.1 preconditions (this gate, `/blindspot-scan`, an operator-approved pilot defect) sufficient control given that the complexity budget fails both prongs and the premise is unevidenced?

## Referenced files

- ai-resources/plans/2026-07-28-work-loop-consolidated-build-plan.md — exists
- ai-resources/docs/ai-resource-creation.md — exists
- ai-resources/docs/audit-discipline.md — exists
- ai-resources/.claude/commands/lean-repo.md — exists
- ai-resources/logs/decisions.md — exists
- ai-resources/docs/work-loop.md — not yet present (C1)
- ai-resources/.agents/skills/work-loop/SKILL.md — not yet present (C2)
- ai-resources/.claude/commands/work-loop.md — not yet present (C3)
- ai-resources/skills/capability-development/SKILL.md — not yet present (C4)
- ai-resources/templates/capability-record.md — not yet present (C5)
- .claude/commands/work-loop.md (workspace root) — not yet present (S1 symlink)
- projects/global-macro-analysis/.claude/commands/work-loop.md — not yet present (S2 symlink)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The design is unusually disciplined and self-aware (its own §13 concedes the complexity budget fails, the premise is unevidenced, and reach is "26 of 27 projects"), but independent re-derivation confirms a real, currently-uncorrected factual error feeding an acceptance test, an unaddressed stale worktree carrying an earlier abandoned draft of the same components, a genuine RR-05 invocation-path gap, and an OP-11 exception that — as currently justified — rests on zero cited evidence and one contradicted citation; none of this is disqualifying on its own, but all of it must be fixed or explicitly acknowledged before Session A lands.

## Consumer Inventory

Search terms used: `work-loop`, `capability-development`, `capability-record`, `develop-capability`, `codex-second-opinion-brief`, `logs/loop`, plus the specific MODIFY/APPEND/SYMLINK targets named in the plan. Grepped across `ai-resources/` and the workspace root (`command grep -rniI --exclude-dir=.git`, an absolute-path form immune to the dot-rooted `grep` shadow per `docs/audit-discipline.md` § Absence-claims).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/develop-ai-resource.md` | co-edits | yes (E1 — boundary bullet + upstream-brief clause) |
| `ai-resources/templates/README.md` | documents | yes (E2 — register capability-record.md) |
| `ai-resources/.claude/commands/new-project.md` | co-edits | yes (E3 — CORE symlink set, confirmed at line 397) |
| `ai-resources/inbox/codex-second-opinion-brief.md` | co-edits | yes (E4 — git mv to archive; confirmed present, 16118 bytes, unarchived) |
| `ai-resources/docs/ai-resource-creation.md` | co-edits | yes (E5 — one sentence in rule #4) |
| `ai-resources/plans/2026-07-28-develop-capability-build-plan.md` | documents | yes (E6 — superseded banner; confirmed it already carries a banner pointing to v2, so E6 re-points it to the new plan) |
| `ai-resources/logs/decisions.md` | documents | yes (L1 — new OP-11 append) |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` mechanism -> 25 manifest-carrying projects | invokes | no (automatic on next SessionStart; confirmed `work-loop` is absent from `EXCLUDE_COMMANDS`, so it WILL propagate, including to retired projects `management-os`/`strategic-os` which still carry `shared-manifest.json`) |
| `.claude/commands/work-loop.md` (workspace root, S1) | invokes | n/a — new symlink |
| `projects/global-macro-analysis/.claude/commands/work-loop.md` (S2) | invokes | n/a — new symlink |
| `ai-resources/.claude/worktrees/develop-capability/skills/capability-development/SKILL.md` + `.../templates/capability-record.md` | co-edits (unaddressed) | **not named in the plan at all — flagged, see Blast Radius and Hidden Coupling** |
| `ai-resources/plans/2026-07-28-develop-capability-build-plan-v2.md`, `-v3.md`, `-v3.1.md` | documents | no, but recommended — E6 only re-banners the base file; these 3 intermediate drafts (the last, v3.1, still reads "awaiting operator approval") are left dangling |
| `ai-resources/AGENTS.md` | parses (contingent) | no — untouched unless A-CX-1 fails and the operator separately approves an amendment |
| ~20 audit/log files mentioning `codex-second-opinion-brief.md` as a pending inbox item (`maintenance-observations.md`, `logs/inbox-triage-2026-05-27.md`, several `audits/working/fix-repo-issues-*.md`, etc.) | documents (historical, point-in-time) | no — per the 2026-07-25 decisions.md precedent, point-in-time records are not rewritten to avoid falsifying what was true when written |

**Total: 7 must-change consumers (E1–E6, L1) + 1 automatic-propagation class (25 projects) + 2 new symlinks + 4 items the plan itself does not name (stale worktree, 3 dangling draft files, contingent AGENTS.md, ~20 historical mentions).** This is not an isolated change — the plan's own §9.3 states reach as "26 of 27 projects," which this inventory confirms mechanically via `auto-sync-shared.sh`.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added — confirmed by direct read of workspace CLAUDE.md and `ai-resources/CLAUDE.md` (neither references `/work-loop`) and by the plan's own §9.4 ("No `/prime` edit... **No workspace `CLAUDE.md` edit**"), independently verified at plan lines 270–272.
- No hook registered — confirmed no `hooks` addition in the CREATE/MODIFY/APPEND lists, and `.claude/settings.json`'s existing `PreToolUse`/`SessionStart` hook list (read directly) is untouched by this plan.
- C3 (`/work-loop`, `model: opus`, `effort: high`) is operator-invoked only, pay-as-used — not spawned per session or per tool call.
- C4 (`capability-development` skill, 350–500 lines) carries `disable-model-invocation: true` (plan §9.1) — it cannot auto-load from a broad description match; it is reachable only via `/work-loop`'s explicit dispatch.
- C2 (Codex controller skill) auto-activates only inside a Codex session deliberately rooted in `ai-resources` (the plan's own "required Codex control room" framing, §8) — not a broad, always-on trigger surface comparable to a Claude-Code skill description match across all sessions.

### Dimension 2: Permissions Surface
**Risk:** Low

- `ai-resources/.claude/settings.json` (read directly) already runs `defaultMode: bypassPermissions` with `Bash(*)`, `Agent`, `Skill`, `Edit(**/.claude/**)`, `Write(**/.claude/**)` already allowed — the repo is already broadly permissive by design (consistent with operator's standing "safety via git/risk-check/audits, not prompts" philosophy).
- No `settings.json`/`settings.local.json` edit anywhere in the CREATE/MODIFY/APPEND/SYMLINK lists — confirmed absent from all nine plan sections read.
- New symlinks (S1, S2) are plain filesystem symlinks under `.claude/commands/`, inside an already-allowed write path — no new capability class.
- No new external API, MCP server, or cross-repo write capability introduced.

### Dimension 3: Blast Radius
**Risk:** High

- The Step 1.5 inventory found **7 consumers requiring modification** (E1–E6, L1) — above the 5-caller High threshold on its own.
- Two of the seven are genuinely shared governance/infrastructure files: `new-project.md` (E3, scaffolds every future direct-route project) and `docs/ai-resource-creation.md` (E5, the repo's own resource-creation rulebook) — this is "shared infra touched in a way that affects multiple workflows," an explicit High trigger.
- The `auto-sync-shared.sh` mechanism (read directly, `EXCLUDE_COMMANDS` confirmed not to list `work-loop`) will silently propagate the new command to **25 of 27 projects** on their next `SessionStart`, with no manual step — including two retired projects (`management-os`, `strategic-os`) that still carry `shared-manifest.json`.
- The inventory surfaced a consumer the plan does not name anywhere: **`ai-resources/.claude/worktrees/develop-capability`**, a live sibling worktree (same commit SHA as main, branch `session/2026-07-28-develop-capability`) carrying untracked files at the exact paths of C4 and C5 (`skills/capability-development/SKILL.md`, 328 lines, and `templates/capability-record.md`, 118 lines) — content from the earlier, abandoned `/develop-capability`-as-separate-command design (the SKILL.md still says "Read by `/develop-capability`," not `/work-loop`). This is a real, unaddressed blast-radius gap per the rule "if the Step 1.5 inventory surfaced a consumer not anticipated by CHANGE_DESCRIPTION, that gap is itself a blast-radius finding."
- Secondary gap: E6 only re-banners the single base draft file; three further intermediate drafts (`-v2.md`, `-v3.md`, `-v3.1.md`) are left un-bannered, and `-v3.1.md` still literally reads "awaiting `/qc-pass` and `/contract-check`, then operator approval" — a misleading trail for a future reader who follows the supersession chain.
- Mitigated by construction: the plan's own session/commit sequencing (§10.2–10.3), the A-DIST-1/2/3 and A-HAND-1/2 acceptance tests, and the fact that every edit is additive (no existing command's behavior changes) — this is why the risk is "High by reach," not "High by breakage," matching the plan's own self-description.

### Dimension 4: Reversibility
**Risk:** Medium

- `git revert` is documented and achievable, but only in a specific, non-arbitrary order across up to 7 commits (§10.4's dependency graph: 1→2, 1→3, 1,3,4→5, 1→6, 4→5, 7 independent) — reverting commit 1 alone without 2/3/5/6 breaks the remainder. This is more than a single-file clean revert, but the plan documents the order explicitly and names safe partial-revert combinations, which substantially de-risks it.
- `projects/{p}/development/{slug}.md` records are explicitly "Never deleted — a rejected capability keeps its record" (plan §6.1). A code-level revert after real capability usage would leave readable-but-orphaned records referencing a now-reverted command — the classic "revert leaves stale entries that carry forward" pattern this dimension is calibrated against.
- `logs/decisions.md` (L1) append is a normal, previously-used append pattern in this repo (many precedent entries read directly) — cleanly `git revert`-able barring later unrelated appends on top.
- Two symlinks (S1, S2) are trivially removable.
- Nothing pushes state beyond the local repo (no external write, no `git push` implied).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The plan's own §2 names an **unverified** dependency: whether Codex selects the new `work-loop` skill from a plain-language request without being named (test A-CX-1). This is an implicit dependency on a third-party product's own skill-discovery behavior, explicitly untested, with — per the plan's own §10.2 stop rule — **no approved fallback** (editing `AGENTS.md` requires separate operator approval on failure). This is the dimension's clearest finding.
- Crash atomicity (§6.4): "git commits are atomic; the write sequence leading to one is not." Mitigated by an explicit ordering rule plus a 6-row deterministic reconciliation table (§7.0) — a well-specified, not a silent, risk.
- The undocumented stale worktree (see Dimension 3) is also a hidden-coupling fact: nothing in the plan accounts for a parallel, uncommitted, same-path draft of C4/C5 already existing in a sibling worktree — a future session `cd`-ing into that worktree would see stale content and could act on it believing it current.
- No functional overlap found with an existing mechanism: `/qc-pass`, `/risk-check`, `/develop-ai-resource` boundaries are explicitly and consistently drawn (§3, §3.1) and cross-checked against `develop-ai-resource.md:13-17` directly — accurate as cited.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read directly) and `docs/ai-resource-creation.md` rule #7 (read directly).

- **Complexity budget (rule #7, operationalizing AP-7/DR-7/OP-12) — both prongs fail, independently confirmed.** Prong (a): the plan itself states "five components... none removed" (line 411) — 5 net-additive load-bearing files (C1–C5), 0 removed. Prong (b): independently re-derived via `command grep -niI "work-loop\|capability-development\|develop-capability" logs/defect-log.md logs/incident-log.md` and `"work-loop"` / `"cross-model"` against `logs/friction-log.md` and `logs/coaching-log.md` — **zero hits** in every one of the four named logs. The plan's own §13 concedes this plainly: "neither half resting on a logged failure," "the premise remains operator-stated rather than evidenced" (line 419). My re-derivation confirms the caller's Adjudication Point B exactly.
- **RR-05, the inflow rule (`docs/ai-resource-creation.md:36-40`), sharpens the same gate — a genuine, confirmed gap.** Independently verified by reading plan §9.4 (lines 270–272) and §12 (lines 385–398): no `/prime` edit, no workspace `CLAUDE.md` edit, and §12's exclusion table explicitly defers both, naming what would justify reinstating them later. §7.2's "unbound reviewed capability invisible at session start" residual addresses *visibility of an already-open thread*, not *invocation of new work* — there genuinely is no registered pipeline, cadence, or hook that calls `/work-loop`; the only trigger for starting new work is the operator remembering to type it. This matches RR-05's forbidden shape ("A command whose only trigger is the operator remembering it exists is not shipped; it is wired or deferred") more closely than the plan's own residual-risk framing acknowledges.
- **The OP-11 exception, as currently drafted, has weaker support than every cited precedent — but it is being made loudly, which is the operative test.** `docs/ai-resource-creation.md:44` states failing the gate is survivable via "a loudly-recorded principle exception (OP-11)... never an in-line 'it's fine actually' assertion," and the risk-check protocol's own Dimension-6 instructions exempt a High score specifically when the addition ships as "a loudly-recorded OP-11 exception in `logs/decisions.md`." The plan commits to exactly this (commit 7 / L1). Two things the operator should weigh when approving that entry: (1) unlike `/lean-repo` (evidenced sprawl cited in a `logs/decisions.md` 2026-07-04 entry) and unlike the 2026-07-23 (S1-0e1) direct-route precedent (a measured ~5,600 tokens/session cost), this exception cites **no evidence of any kind**, formal or informal; (2) the one candidate evidentiary anchor that exists in this design's own lineage — `projects/axcion-systems-builder/CLAUDE.md:13` — was cited in the now-superseded drafting plan (`plans/2026-07-28-develop-capability-build-plan-v3.md:97,342`, confirmed by direct grep) as clearing prong (b): *"a failure pattern seen ≥2 times with cited written evidence."* Independently reading that file (confirmed verbatim): *"A Management OS was built and never run; a Strategy OS was built and partly unused... The one lesson carried forward: **building ahead of a real, felt need is what failed.**"* This is a caution against speculative building, not evidence of an operational failure mode `/work-loop` fixes — using it as prong-(b) support inverts its meaning. **The good news, independently confirmed:** rev.3 (the plan actually being gated) does not repeat this error — `command grep -n "principles\|axcion-systems-builder\|felt need" plans/2026-07-28-work-loop-consolidated-build-plan.md` returns zero hits. Rev.3 already dropped the flawed citation and switched to the honest "operator-stated, not evidenced" framing. This is why the finding is Medium rather than High: the loud-acknowledgment test is met, and the plan already self-corrected the one attempt to fake-clear the gate — but the L1 entry, when written, should say plainly that no evidence exists and that the nearest candidate evidence actually argues the other way, not merely that the premise is "unevidenced."
- No OP-10 (system-boundary) concern — Codex is invoked as a reviewer, not governed as part of the Claude Code system; no OP-5 (advisory-to-enforcement) drift — the design stays fully advisory (gates stop and report, nothing auto-corrects); no OP-12 (closure-before-detection) concern — this is not a detection/audit mechanism.

### Dimension 7: Problem Reality
**Risk:** Medium

- **Defect — observed or inferred?** Mixed, both independently checked. (1) RR-05 no-wiring claim: OBSERVED — I read plan lines 270–272 and 385–398 myself and confirmed no `/prime`/CLAUDE.md wiring exists. (2) The 51-vs-39 `global-macro-analysis` symlink count: OBSERVED — `find projects/global-macro-analysis/.claude/commands/ -maxdepth 1 -type l | wc -l` → 39; `-type f | wc -l` → 13 (the `kb-*.md` files). The plan's own §2 (line 26) and acceptance test A-DIST-3 (line 373) both still assert "51... siblings" in the document that would drive Session A's actual build — this is a live, currently-uncorrected inaccuracy in the "final" build authority, not merely a stale historical reference.
- **Consequence — traced or assumed?** RR-05's consequence (no automatic invocation path exists for new work) is traced with high confidence — confirmed no hook, cadence, or other command calls `/work-loop`; `/prime` is unmodified. The 51-vs-39 miscount's consequence (A-DIST-3 failing as literally written, or at minimum misleading the implementing session) is plausible and specific but not literally reproduced — nothing has been built yet at plan-time, so this is inferred rather than executed. This is the Medium-defining gap.
- **Re-derivation vs. change description:** Two of the caller's three "already-verified" corrections were independently confirmed exactly (39 symlinks not 51; the rule #7/RR-05 misattribution, confirmed by direct read of `docs/ai-resource-creation.md:25-44`). The third contains a minor inaccuracy of its own: the caller states "the plan §12 and `session-start.md` both cite [`principles.md`]" — `command grep -n "principles" plans/2026-07-28-work-loop-consolidated-build-plan.md` returns **zero hits**; only `session-start.md:375` cites it. The plan itself never does. This is immaterial to the verdict (the underlying fact — `docs/principles.md` does not exist in this repo — is independently confirmed via `find . -iname "principles.md"`, which locates the real file at `projects/repo-documentation/vault/principles/principles.md`), but it is a genuine discrepancy between the change description and re-derived fact, recorded per the standing rule that re-derivation wins. Separately, Adjudication Point C's citation-and-consequence question was traced fully: the quote is accurate, its use as prong-(b) evidence in the superseded drafting plan does not hold up, and rev.3 (what is actually being gated) does not rely on it — confirmed by direct grep returning zero hits for that citation in the plan under review.

## Mitigations

- **Dimension 3 (Blast Radius — High).** Before Session A's first commit: (1) explicitly reconcile the stale `ai-resources/.claude/worktrees/develop-capability` worktree — either delete its untracked `skills/capability-development/` and `templates/capability-record.md`, or confirm they contribute nothing to C4/C5's actual text (they reference the abandoned `/develop-capability` design, not `/work-loop`) and remove the worktree once its branch is no longer needed; (2) extend E6 to also banner `plans/2026-07-28-develop-capability-build-plan-v2.md`, `-v3.md`, and `-v3.1.md` with a one-line pointer to the new consolidated plan, so the supersession trail does not dead-end at `-v3.1.md`'s "awaiting operator approval"; (3) land strictly in the documented session/commit order (§10.2–10.3) with the end-time `/risk-check` before each session's first commit, exactly as the plan already specifies.
- **Dimension 4 (Reversibility — Medium).** Before relying on a partial revert, re-read §10.4's dependency graph in full rather than reverting any single commit in isolation; if a `development/{slug}.md` record exists at revert time, explicitly mark it superseded/closed in the same revert rather than leaving it dangling against a reverted command.
- **Dimension 5 (Hidden Coupling — Medium).** Run A-CX-1 exactly as scheduled (after commit 2, before commit 3, in a fresh Codex task) before any further build depends on Codex auto-activation; do not treat a "probably fine" assumption as sufficient given the plan's own admission of no approved fallback.
- **Dimension 6 (Principle Alignment — Medium).** When writing the L1 `logs/decisions.md` OP-11 entry (commit 7), state plainly that (a) neither complexity-budget prong is cleared, (b) no friction-log/defect-log/coaching-log/incident-log evidence exists for this specific need, and (c) the nearest candidate evidence in the design's own lineage (`axcion-systems-builder/CLAUDE.md:13`) argues against, not for, an unevidenced 5-component build — do not let the entry imply stronger support than exists. Separately, before or shortly after landing, name one concrete, low-cost wiring point (e.g., a one-line `/prime` Step-1d style pointer, or an explicit named revisit trigger with a date) that would close the RR-05 gap if `/work-loop` goes unused — the plan already names the qualitative trigger ("if it bites twice") but not a bounded one.
- **Dimension 7 (Problem Reality — Medium).** Correct plan §2 (line 26) and acceptance test A-DIST-3 (line 373) from "51" to "39 relative symlinks (+13 real project-local `kb-*.md` command files)" before Session A executes A-DIST-3, so the test's literal pass condition matches the actual filesystem.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
