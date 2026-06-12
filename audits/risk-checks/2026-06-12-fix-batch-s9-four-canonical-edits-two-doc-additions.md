# Risk Check — 2026-06-12

## Change

Fix batch S9 — four canonical edits + two doc additions, all single-file reversible: (1) session-feedback-collector.md agent — add Edit+Bash to toolset, mandate append-only writes (Edit-append or Bash heredoc), forbid whole-file Write of shared logs (fixes 2 destructive-overwrite + 1 no-write incidents); (2) risk-check.md Step 17b/17d — re-point second-opinion dispatch from /consult-via-Skill-tool (blocked by disable-model-invocation, no-ops every run) to direct system-owner agent dispatch via Agent tool; (3) consult.md Step 5 — add post-return existence check on the SO advisory file path, persist returned summary if missing; (4) resolve-improvement-log.md — widen Resolved classification to also accept the de facto `resolved YYYY-MM-DD` convention alongside strict applied+Verified; (5) docs/commit-discipline.md — add wrap-owns-session-notes rule (mid-session commits never stage session-notes.md); (6) session-plan.md — add environment-fit check clause for launch-gated tooling. Session plan: logs/session-plan-2026-06-12-S9.md

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-06-12-S9.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Five of the six fixes are low-risk single-file, reversible edits; but Item 2 (re-point risk-check Step 17b away from `/consult`) rests on a stated premise — that consult.md carries `disable-model-invocation` — that is **factually false against current file state** (the flag was reverted 2026-06-10), so Item 2 risks fixing a non-bug while bypassing `/consult`'s gates and silently desyncing two other callers; Item 4 has a documented contract coupling (improvement-log preamble L9) that must change in lockstep.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/wrap-session.md (Step 6.5) | invokes (session-feedback-collector by name, paths only) | no |
| .claude/commands/wrap-session.md (workspace-root copy, Step 4.5) | invokes (independent non-symlink copy of the wrap; same agent via --add-dir) | no |
| ai-resources/docs/agent-tier-table.md | documents (collector tier entry) | no |
| ai-resources/docs/commit-discipline.md (§ Shared-log write-path integrity, § Maintenance-owned mutations) | documents (collector named as an append writer of the shared logs) | no (but see Hidden Coupling — Item 1 hardens what this doc already describes) |
| ai-resources/docs/session-feedback-dimensions.md | documents (rubric the collector reads) | no |
| ai-resources/logs/improvement-log.md (preamble L9) | parses (documents the strict `Status: applied`+`Verified:` resolved-classification contract that Item 4 widens) | **yes** (lockstep doc update or it goes stale) |
| ai-resources/.claude/commands/resolve-incident.md | invokes (`/consult` by name as a second-opinion step — Item 2 surface) | no (but desync risk — see below) |
| ai-resources/.claude/agents/project-manager.md / pm.md (Fallback 5d) | invokes (`/consult` by name) | no (but desync risk) |
| ai-resources/.claude/commands/friday-act.md | invokes (`/risk-check` by command name; does NOT parse Step 17 internals) | no |
| ai-resources/.claude/commands/risk-check.md (Step 17b/17d) | co-edits (Item 2 edits this file directly; Step 17c persists `/consult` output verbatim) | yes (this is the edit target) |
| ai-resources/.claude/agents/system-owner.md | invokes/imports (the agent Item 2 would dispatch directly; already Task-tool reachable via consult Step 4) | no |
| docs that reference resolve-improvement-log (friday-act, friday-checkup, fix-repo-issues, weekly-cadence, improve, repo-architecture) | documents (name the command; none restate the classification-rule wording) | no |

Total: 12 distinct consumer rows; **2 must-change** (improvement-log.md preamble L9 for Item 4; risk-check.md Step 17b/17d as the Item 2 edit target itself). Two further consumers (`resolve-incident.md`, `pm.md`) are not strictly must-change but carry a desync risk if Item 2 lands — see Dimension 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. None of the six edits modify workspace or project `CLAUDE.md`, and none add an `@import` to an always-loaded file — verified: edit targets are one agent, three commands, and one doc (`docs/commit-discipline.md` is read-on-demand per its own "When to read this file" header, L3).
- No new hook registered. No SessionStart / Stop / PreToolUse / UserPromptSubmit hook is added — the change set is command/agent/doc edits only (CHANGE_DESCRIPTION; session-plan S9 Items 1–6).
- Item 1 adds `Edit` + `Bash` to an agent (`session-feedback-collector`) that is spawned once per wrap, gated behind a preflight toggle (wrap-session.md L21, L394) and a trivial-session skip — pay-as-used, not per-turn.
- Items 5–6 add a few lines of prose to read-on-demand surfaces (`commit-discipline.md`, `session-plan.md`); neither is always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` `allow` / `ask` / `deny` edit anywhere in the batch — the change set does not touch any settings layer (CHANGE_DESCRIPTION; S9 plan Execution Sequence omits settings files).
- Item 1 widens an **agent's** declared `tools:` frontmatter (`Read, Glob, Grep, Write` → adds `Edit`, `Bash`) — this is a per-agent capability declaration, not a workspace permission grant. `Bash` is the one new capability family for this agent; it is scoped to the agent's own append-only contract (Edit-append or Bash heredoc) and bounded to two named write targets (`friction-log.md`, `improvement-log.md`) per the agent body (session-feedback-collector.md L103, L130). The collector already runs `git show HEAD:...` Bash in Constraint E (L76–81) conceptually but cannot execute it without Bash — so this addition makes an already-documented operation executable rather than introducing a novel capability.
- Net surface change is one narrow tool-family addition to a single, narrowly-scoped, once-per-wrap agent. Calibrates to Low (within-pattern: the repo already grants Bash to many subagents).

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Step 1.5 inventory: **12 consumer rows, 2 must-change.** Most edits are isolated single-file changes with compatible consumers.
- **Item 1 (collector):** callers invoke the agent by name and pass paths only — neither wrap-session copy specifies the agent's toolset (ai-resources wrap Step 6.5 L395–398; workspace-root copy is an independent non-symlink per the MIRROR NOTE L389–392). Adding tools to the agent frontmatter requires **no** lockstep wrap-session edit. Blast radius for Item 1: 1 file, 0 must-change callers.
- **Item 4 (resolve-improvement-log classification):** the improvement-log.md preamble (L9) explicitly documents the contract being changed — verbatim: *"Both `Status: applied` AND `Verified:` are required for `/resolve-improvement-log` to classify an entry as resolved."* Widening the rule in the command without updating this preamble line leaves a documented-vs-actual contract mismatch. This is the must-change consumer that drives Medium. (Note: the S9 plan deliberately does NOT touch improvement-log.md because S8 holds it uncommitted — so the lockstep doc fix is *blocked this session*; see Reversibility + Mitigations.)
- **Item 2 (risk-check Step 17b/17d):** `friday-act.md` and ~30 other files reference `/risk-check`, but the grep confirms they reference the **command name**, not Step 17 internals (friday-act L170/267/274 annotate `risk_check_required`; none parse the dispatch step). So the Step 17b dispatch mechanism has no external parser — re-pointing it is internally contained. Blast radius for Item 2 within risk-check.md is contained; the risk is *correctness*, not breadth (see Dimensions 5/6).
- Items 3, 5, 6 are single-file additive edits with no must-change consumer.

### Dimension 4: Reversibility
**Risk:** Low

- All six are single-file content edits to version-controlled command/agent/doc files; a `git revert` of the S9 commit restores prior state cleanly with no sibling files, no log mutations, no external writes (CHANGE_DESCRIPTION: "all single-file reversible"; S9 plan Scope Alternatives).
- No data/log file is mutated by the batch itself — the S9 plan explicitly defers all improvement-log status flips (S9 plan Autonomy Posture L49: "Improvement-log status flips explicitly deferred (S8 owns the file uncommitted)").
- No push, no external API write, no automation that could fire between landing and revert (no hook added — see Dimension 1).
- One caveat that does **not** raise the score: Item 4's lockstep preamble fix (improvement-log.md L9) is deferred to a later session because S8 holds that file uncommitted — so the *command* edit lands now and the *doc* fix lands later. That is a sequencing gap (tracked under Mitigations), not a reversibility hazard: reverting the command edit is still clean.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Item 2 rests on a stale premise — verified false against current file state.** CHANGE_DESCRIPTION states consult.md is "blocked by disable-model-invocation, no-ops every run." Direct read of consult.md frontmatter (L1–5) shows **no `disable-model-invocation` flag** — only a cautionary comment (L7–12) that says verbatim: *"DO NOT add `disable-model-invocation: true` here … the flag removes /consult from the model-invocable set and silently breaks all three. (Regression: added 2026-05-29 in 51b69dc, **reverted 2026-06-10**.)"* So as of today `/consult` **is** model-invocable and Step 17b works. The bug Item 2 fixes was already fixed by the 2026-06-10 revert. Acting on the stale premise would change working behavior.
- **Re-pointing Step 17b to direct agent dispatch bypasses three `/consult` gates the current path provides:** Step 0 read-first gate (consult.md L28–35), Step 2 change-shape classification + Step 3 routing-context read of `repo-architecture.md` (L52–69), and the agent's Phase-5 output contract that consult Step 4 enforces (L91). risk-check's Step 17b prompt template names the SO function but does not replicate the change-shape routing — so direct dispatch silently drops routing context the SO agent currently receives.
- **Desync of co-callers:** `resolve-incident.md` and `pm.md` (Fallback 5d) also auto-invoke `/consult` by name (confirmed by the consult.md comment L8 and the inventory grep). If Item 2 re-points only risk-check.md to direct agent dispatch, the second-opinion dispatch path forks: two callers go through `/consult`, one goes direct. The cautionary comment exists precisely to keep these three callers on one path; Item 2 breaks that invariant without touching the comment.
- **Item 4 introduces an undocumented widening unless the preamble is updated in lockstep** (improvement-log.md L9, quoted in Dimension 3) — a classic documented-contract-vs-actual-behavior drift.
- **Item 1 overlaps benignly with existing mechanism (not a coupling defect):** `commit-discipline.md` § Shared-log write-path integrity (L29–45) and the agent's Constraint E (L74–83) already describe the append-only discipline Item 1 hardens; Item 1 makes the agent *able* to honor what the docs already mandate. This is alignment, not conflict — noted for completeness.

### Dimension 6: Principle Alignment
**Risk:** Medium

- **Items 1, 3, 4, 5, 6 align with the principles.** Item 1 closes a recurring data-loss failure (OP-12 closure-before-detection: it closes an open friction class rather than adding new detection; 3 incidents in 3 sessions per S9 plan L17). Item 4 fixes a classification rule that "matches zero real entries" — pure correctness. Items 5–6 are documented-discipline additions (advisory, no enforcement). None expand the system boundary (OP-10) or build for an absent consumer (OP-9/DR-7/AP-7).
- **Item 2 creates principle tension, not a clear violation (hence Medium, not High).** It edits a command on a premise that the file's own provenance comment (consult.md L7–12) records as already resolved — i.e., it risks re-litigating a 2026-06-10 decision without acknowledging it. This brushes OP-11 (loud, deliberate principle/decision revision, never silent drift): the prior decision to *keep* `/consult` model-invocable for risk-check's second opinion is documented; reversing the dispatch architecture on the opposite assumption should be a *loud, recorded* call, not an incremental fix slipped into a batch. It does not clearly violate a frozen principle, so it scores Medium — but the mitigation is to re-ground or rescope Item 2 before landing, not to patch it.
- Principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`); cited IDs OP-9, OP-10, OP-11, OP-12, DR-7, AP-7.

## Mitigations

- **Item 2 (Hidden Coupling High → re-ground or drop before landing):** Re-read consult.md frontmatter live and confirm whether `disable-model-invocation` is present. It is **not** (verified this run, L1–5), so the stated bug does not exist in current state. Either **(a) drop Item 2** from the S9 batch (the 2026-06-10 revert already restored the working path), or **(b) if a genuine residual issue remains**, rescope Item 2 to keep `/consult` as the dispatch path (preserving its read-first gate, change-shape routing, and the three-caller invariant the consult.md comment protects) and document the change loudly per OP-11. Do not land the re-point-to-direct-agent-dispatch edit on the as-written premise.
- **Item 2 (co-caller desync):** If any Item 2 edit lands, update or delete the consult.md cautionary comment (L7–12) in the same commit so the three-caller invariant it documents stays true; otherwise the comment becomes a false statement about the dispatch architecture.
- **Item 4 (Blast Radius / Hidden Coupling — must-change consumer is blocked this session):** The lockstep fix to improvement-log.md preamble L9 (strict-rule wording) cannot land in S9 because S8 holds that file uncommitted. Land the command edit now ONLY if you record a follow-up to update L9 in the next session that owns improvement-log.md — and add a one-line `<!-- -->` note in resolve-improvement-log.md Step 3 pointing at the pending preamble sync, so the documented-vs-actual gap is visible until closed. If you cannot guarantee the follow-up, defer Item 4 entirely until the same session can touch both files.
- **Item 1 (verify executable capability):** After adding `Bash` + `Edit`, confirm the agent's append-only contract forbids whole-file `Write` of the two shared logs explicitly in its body (the current L103/L130 still describe `Write` as a fallback) — otherwise the new `Edit` path coexists with the old destructive `Write` path that caused the incidents.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: consult.md L1–12 (no active flag; provenance comment), improvement-log.md L9 (resolved-classification contract), wrap-session.md L389–398 (collector invocation, paths-only, non-symlink copies), friday-act.md L170/267/274 (command-name reference, not Step-17 parse), session-feedback-collector.md L74–83/L103/L130 (Constraint E + Write fallback), risk-check.md L115–134 (Step 17b/17c/17d dispatch), system-owner.md L1–11 (Task-reachable agent), and principles-base.md (OP-9/10/11/12, DR-7, AP-7). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-s9-fix-batch-second-opinion.md (existence verified post-return)

**Verdict:** Concur with PROCEED-WITH-CAUTION. Calibration correct; the three mitigations are the right path. Two missed risks surfaced — both bounded, neither flips the verdict.

- (a) Item 2 dropped — CORRECT, highest-value move (editing risk-check.md on a verified-false premise would be OP-3/AP-2 at the infra level; relieves the larger Hidden-coupling-High driver).
- (b) Item 4 pending-sync note — CORRECT under DR-10. Condition: the note must record WHY the two ends are intentionally divergent (classifier widened, preamble lagging), not a bare "update later" (AP-9 / risk-topology § 5).
- (c) Item 1 forbids whole-file Write at L103/L130 — CORRECT and load-bearing. Logs are a safe zone only for appends (risk-topology § 5).

Missed risks:
1. Item-1 mandate must be CATEGORICAL ("never whole-file Write a shared log"), not preferential ("prefer append") — execution automation with no confirmation gate (OP-2/OP-5).
2. Item 5 doc-ahead-of-mechanism: confirm /wrap-session Step 3.5 already enforces session-notes wrap-ownership before landing the doc; if not, add a follow-up note like Item 4.

Note: Item 3's persist-if-missing must persist the RETURNED SUMMARY only (DR-6) — never synthesize the full advisory it didn't receive (AP-2).

Position: Land as scoped. Fold both checks into the end-time /risk-check pass before commit.

## End-time disposition (2026-06-12 S9, pre-commit)

Executed set = plan-time-gated set MINUS Item 2 (dropped per mitigation — premise verified false; no edit to risk-check.md exists in the batch). No scope additions. All mitigations verified applied:
- (a) Item 2 dropped — confirmed by QC (no risk-check.md edit in batch).
- (b) Item 4 why-divergent schema-sync note present in resolve-improvement-log.md Step 3.
- (c) Item 1 categorical append-only mandate present at both body sites (write-formats paragraph + Rules section); Write removed from toolset.
- SO missed-risk 1 (categorical not preferential) — verified by QC.
- SO missed-risk 2 (doc-ahead check) — verified: wrap-session Step 3.5 guard + check-foreign-staging tripwire both pre-exist; the commit-discipline rule is doc-catching-up.
Independent /qc-pass: GO (zero findings). Second full reviewer pass not spawned — unchanged scope, drift = one risk-reducing drop; this disposition documents the end-time gate per the two-gate model.
