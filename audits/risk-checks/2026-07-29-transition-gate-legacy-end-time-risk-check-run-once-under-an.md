# Risk Check — 2026-07-29

## Change

TRANSITION GATE — legacy end-time /risk-check, run once under an explicit policy transition (G1 binding condition, recorded in logs/loop/2026-07-29-review-layer-consolidation-build-1.brief.md). This is NOT a waiver: the current end-time gate is honoured on real executed changes before they commit.

SCOPE — WHAT IS EXECUTED AND ON DISK RIGHT NOW (this is what you review):
Slice S1 only, uncommitted in worktree ai-resources-2 on branch session/2026-07-29-2. Ten policy/doc files plus one autolog:
- docs/qc-independence.md — REWRITTEN. Replaces the QC Independence Rule with a three-row proportional "Independent Review Rule": small/mechanical = deterministic verification only; normal consequential = one Codex review; high-consequence/destructive = one risk-aware Codex review before implementation. REMOVED: "Post-edit QC is mandatory", the plan-QC requirement, the self-check-before-plan-QC step, the entire QC → Triage Auto-Loop (auto-spawn of triage-reviewer, two-pass cap, cap-exhaustion clause), and the QC-PENDING commit-block/deferred-session architecture. RETAINED: context isolation, mechanical-mode acceptance, materiality-floor pointer, halt-and-surface (rekeyed from a pass counter to "a material finding left unresolved"). ADDED: a Risk-aware review section carrying the seven risk dimensions plus the premise-verification precondition migrated out of audit-discipline.md.
- docs/audit-discipline.md — § Risk-check change classes now a CONSEQUENCE TEST selecting the risk-aware review row, not a trigger. DELETED: § When to fire (two-gate model), § Verdict semantics. REWRITTEN: § Invocation semantics (/risk-check is operator-invoked only; no plan-time or end-time gate exists), § Overlap with top-3 analysis. RETAINED: class list, 2026-07-03 class-boundary clarification, § Subagent Proportionality.
- docs/autonomy-rules.md — Rule #9 rekeyed from "gated by /risk-check" to "structural change classes are high-consequence, take the risk-aware review row"; still a pause trigger. Two dangling refs to the deleted auto-loop repaired (line 22 compensating-control clause, line 49 de-duplication clause).
- docs/protected-zones.md — Required-review column: nine cells changed from "/risk-check mandatory|if behavior-changing" to "Risk-aware review required|if behavior-changing". Zone list itself UNCHANGED. "What elevated review means" bullet rewritten: unresolved material finding blocks; /risk-check remains the operator-invoked fallback.
- docs/work-loop.md — line 65 rewritten (a risk class no longer fires a separate gate; it makes the unit's Codex review risk-aware). Route table independent-review column: reviewed = risk-aware when in a structural class; challenged = both reviews risk-aware. Routes, stops, gates, escalation semantics UNCHANGED.
- docs/repo-architecture.md — Q5 heading and body rewritten; the audit-discipline one-source-of-truth row corrected.
- docs/ai-resource-creation.md — line 19 blanket "pipelines include QC gates" replaced by the skill-evaluation-pass-is-the-engine framing plus the proportional rule; line 25 residue-loop cap decoupled from the deleted auto-loop; line 46 land-time enforcement claim corrected.
- skills/ai-resource-builder/SKILL.md — Step 6 renamed "Author's self-check" and explicitly declared authoring hygiene, not a review. Consumer-Inventory Gate and Misinterpretation Check RETAINED unchanged; their two downstream references corrected.
- docs/commit-discipline.md, docs/placement-verifier.md — dangling-reference repairs only, created by the deletions above. placement-verifier's own two deterministic path gates are UNCHANGED and now declared self-standing.
- logs/friction-log.md — write-activity autolog append. Not a policy edit.

NO file under .claude/ is touched by S1 — verified: git diff --name-only has zero .claude/ entries.

SCOPE — WHAT IS APPROVED BUT NOT YET EXECUTED (do NOT review as executed; none of it exists on disk):
S2 (automatic hook + embedded general-review removals: deletes .claude/hooks/auto-qc-nudge.sh and auto-resolve-nudge.sh, two settings.json hook entries, and the automatic review calls in wrap-session, qc-pass, promote-workflow, handoff SKILL, pm, cleanup-worktree, resolve-incident, friday-journal, friday-act, fix-project-issues, reconcile), S3 (specialist dispositions + safeguard verification), S4 (guidance restatements + logs/decisions.md entry). Plan: logs/loop/2026-07-29-review-layer-consolidation-shape.plan-v3.md § 3.

CHANGE CLASSES ENGAGED BY S1 AS EXECUTED: cross-cutting always-loaded/governing document edits only. Three of the edited files are themselves protected zones carrying "/risk-check mandatory" today (audit-discipline.md, autonomy-rules.md, qc-independence.md). NO hook edit, NO permission/settings.json edit, NO new command or skill, NO new symlink in S1 — those arrive in S2.

KNOWN STATE FOR YOUR PREMISE CHECK (re-derive, do not take on trust):
- Consumer counts re-derived with parent-symlink-aware find -L after S1: qc-pass 26, refinement-pass 26, refinement-deep 26, triage 26, resolve 26, contract-check 22, blindspot-scan 19, implementation-triage 26, risk-check 26, consult 28, reconcile 15, pm 22 — identical to the pre-change baseline. S1 touched no command file, so no count could move. NOTE: an ordinary `find` UNDER-counts by exactly 1 for every command, because projects/axcion-design-studio/.claude/commands is itself a directory symlink into ai-resources. Use `find -L`.
- PRE-EXISTING breakage found at baseline, NOT caused by this stream: seven broken command symlinks under projects/ — projects/project-planning/.claude/commands/{route-change.md, audit-critical-resources.md} point at canonical targets that no longer exist, and five more sit in the untracked projects/strategic-os/.backup-untracked/. Flag if you judge it in-scope; this stream did not create them and does not fix them.
- Two automatic /risk-check firings will SURVIVE this whole stream in excluded prime-owned files (prime.md:816 plan-time gate, session-plan.md:157 pointer). The brief forbids editing them. They are named sequenced follow-up, not oversight.
- Workspace-root CLAUDE.md (a DIFFERENT repo at /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md, out of scope) still carries the unconditional QC mandate at :57 and the auto-loop pointer at :129. Until that follows, workspace-rooted session behavior does not change.

WHAT I MOST WANT SCORED: whether S1 landing ALONE — governing policy relaxed while every automatic caller in .claude/ still exists and still fires until S2 lands — creates a real exposure window, and whether the ordering S1-then-S2 is the right one or should be inverted.

## Referenced files

- docs/qc-independence.md — exists (rewritten)
- docs/audit-discipline.md — exists (edited)
- docs/autonomy-rules.md — exists (edited)
- docs/protected-zones.md — exists (edited)
- docs/work-loop.md — exists (edited)
- docs/repo-architecture.md — exists (edited)
- docs/ai-resource-creation.md — exists (edited)
- skills/ai-resource-builder/SKILL.md — exists (edited)
- docs/commit-discipline.md — exists (edited, dangling-ref repair only)
- docs/placement-verifier.md — exists (edited, dangling-ref repair only)
- logs/friction-log.md — exists (autolog append)
- logs/loop/2026-07-29-review-layer-consolidation-shape.plan-v3.md — exists (the approved plan; committed)
- logs/loop/2026-07-29-review-layer-consolidation-build-1.brief.md — exists (G1 condition; committed)
- .claude/hooks/auto-qc-nudge.sh — exists, UNTOUCHED by S1 (S2 deletes it)
- .claude/hooks/auto-resolve-nudge.sh — exists, UNTOUCHED by S1 (S2 deletes it)
- .claude/settings.json — exists, UNTOUCHED by S1 (S2 edits two hook entries)
- .claude/commands/prime.md — exists, EXCLUDED from this stream entirely
- .claude/commands/session-plan.md — exists, EXCLUDED from this stream entirely
- WORKSPACE /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists, different repo, out of scope
- WORKSPACE projects/project-planning/.claude/commands/route-change.md — exists as a BROKEN symlink (pre-existing)
- WORKSPACE projects/project-planning/.claude/commands/audit-critical-resources.md — exists as a BROKEN symlink (pre-existing)

## Verdict

RECONSIDER

**Summary:** S1's enforcement mechanisms are unweakened (every automatic hook and commit-block untouched, all consumer counts confirmed identical to baseline) but S1's own consumer inventory is incomplete — six live command files now cite subsections of `audit-discipline.md` / `qc-independence.md` that S1 deleted, and none of them is scheduled for repair by any future slice (S2–S4) or the § 6 follow-up, which is a permanent gap, not a transition-window one.

## Consumer Inventory

Search terms derived from the 8 S1-edited docs' basenames plus the deleted-content markers named in the plan's own falsifier 8 (`second post-edit QC`, `triage + fix passes`, `QC-PENDING`, `two-gate`, `plan-time gate`) and the deleted section headings (`§ When to fire`, `§ Verdict semantics`, `§ QC → Triage Auto-Loop`). Grepped across `.claude/`, `docs/`, `skills/`, `workflows/` in `ai-resources` (the target checkout), per the plan's own stated instrument scope.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/placement.md:79` | parses (cites `audit-discipline.md § When to fire (two-gate model)` — heading deleted by S1) | **yes — not scheduled in any slice** |
| `.claude/commands/risk-check.md:24` | parses (cites `audit-discipline.md § When to fire` — heading deleted; also self-contradicts the fresh § Invocation semantics text) | **yes — not scheduled in any slice** |
| `.claude/commands/resolve-incident.md:83` | parses (cites `audit-discipline.md § Verdict semantics` — heading deleted) | yes — adjacent to S2's `:78` edit but not explicitly named; unconfirmed whether S2 repairs it |
| `.claude/commands/create-skill.md:58` | parses (Step 4 Auto-Fix governing rule cites workspace `CLAUDE.md § QC → Triage Auto-Loop`, itself a pointer into `qc-independence.md § QC → Triage Auto-Loop` — now deleted) | **yes — not scheduled in any slice; core build-pipeline command** |
| `.claude/commands/contract-check.md:11,206` | parses (cites `qc-independence.md § QC → Triage Auto-Loop` — deleted) | **yes — not scheduled in any slice** |
| `.claude/commands/graduate-resource.md:99,126` | parses (cites `qc-independence.md § QC → Triage Auto-Loop` — deleted, as the basis for its own 2-pass cap) | **yes — not scheduled in any slice** |
| `.claude/commands/wrap-session.md` (12b, 12c) | invokes (`/risk-check`, QC-PENDING commit-block) — untouched, still fires automatically | no — S2-scheduled, expected interim state |
| `.claude/commands/promote-workflow.md` | invokes (`/risk-check`, `/qc-pass`) — untouched | no — S2-scheduled |
| `.claude/commands/friday-journal.md`, `friday-act.md` | invokes (flag-then-fire chain) — untouched | no — S2-scheduled |
| `.claude/commands/resolve-incident.md:78` | invokes (`/risk-check`) — untouched | no — S2-scheduled |
| `.claude/commands/qc-pass.md` | documents (QC-PENDING escalation) — untouched | no — S2-scheduled |
| `skills/handoff/SKILL.md` | documents (QC-PENDING directive) — untouched | no — S2-scheduled |
| `.claude/commands/prime.md:816` | invokes (`/risk-check`, plan-time gate) — untouched | no — excluded from stream, disclosed as surviving |
| `.claude/commands/session-plan.md:157,159,211` | documents (two-gate pointer) — untouched | no — excluded from stream, disclosed as surviving |
| `docs/onboarding-daniel.md:378` | documents ("the QC→Triage loop") | no — S4-scheduled (Layer-4 guidance restatement) |
| `docs/spine-schemas.md:174` | documents (general cross-reference, no specific deleted heading cited) | no — compatible as written |
| `.claude/agents/context-discovery.md`, `lean-repo-auditor.md`, `pipeline-review-auditor.md`, `risk-check-reviewer.md` (this agent) | documents (cites retained `§ Risk-check change classes` list) | no — retained section, compatible |
| `.claude/commands/develop-ai-resource.md`, `fix-project-issues.md`, `lean-repo.md`, `leverage-idea.md`, `list-critical-resources.md`, `work-loop.md` | documents (cites retained class list / § Subagent Proportionality) | no — compatible |
| `skills/capability-development/SKILL.md` | documents (cites `docs/work-loop.md`) | no — compatible, routes/gates untouched |
| `workflows/research-workflow/docs/project-config-schema.md` | documents | no — compatible |
| `.claude/hooks/auto-qc-nudge.sh`, `auto-resolve-nudge.sh` | co-edit target for S2, unwired-but-live today | no change from S1; both fire, both advisory-only (`exit 0` always) |
| `.claude/settings.json:73,122` | co-edit target for S2 | no change from S1; both hook entries intact |

**Total: 6 consumers confirmed must-change and unscheduled by any slice** (`placement.md`, `risk-check.md`, `create-skill.md`, `contract-check.md`, `graduate-resource.md`, plus `resolve-incident.md` unconfirmed), **~9 consumers correctly deferred to S2/§6 as disclosed interim state**, **~20 consumers compatible/unaffected** because the sections they cite (`§ Risk-check change classes`, `§ Subagent Proportionality`, `docs/work-loop.md` routes/gates) were retained, not deleted.

This inventory is materially larger and different from the change description's own claim of a fully reconciled transition ("consumer counts... identical to the pre-change baseline") — that claim is true for the *symlink* consumer count (re-derived and confirmed, see Dimension 7), but the change description never inventoried *prose citations to now-deleted subsection headings*, which is a different and unaddressed consumer class the plan's own § 8 (scoped to `projects/` symlinks only) does not cover.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- All 8 edited docs (`docs/*.md`) and `skills/ai-resource-builder/SKILL.md` are load-on-demand, not always-loaded — none is a workspace or project `CLAUDE.md`. No new `@import` was added to any always-loaded file (confirmed: `git diff --name-only` contains zero `CLAUDE.md` entries).
- No hook was added or registered by S1 (`.claude/settings.json` diff is empty — `git diff --stat .claude/settings.json` returned nothing).
- `docs/qc-independence.md` grew from 34 to 67 lines and `docs/audit-discipline.md` shrank from 115 to 97 lines (`git show HEAD:<file> | wc -l` vs. `wc -l < <file>`) — net token cost is roughly flat across the pair, and both remain pay-as-read.
- `skills/ai-resource-builder/SKILL.md` Step 6 was reworded, not expanded; the skill's frontmatter (`model: opus`, broad trigger description) is unchanged by S1, so no new auto-load surface was created.

### Dimension 2: Permissions Surface
**Risk:** Low

- `.claude/settings.json` has zero diff (`git diff --stat .claude/settings.json` empty) — confirmed no `allow`/`ask`/`deny` entry touched.
- `git diff --name-only` contains zero `.claude/` paths of any kind — no permission-adjacent file was touched by S1.

### Dimension 3: Blast Radius
**Risk:** High

- Grounded directly in the Step 1.5 inventory: **6 confirmed must-change consumers, none scheduled for repair by any slice (S1–S4) or the § 6 follow-up** — `.claude/commands/placement.md:79`, `.claude/commands/risk-check.md:24`, `.claude/commands/create-skill.md:58`, `.claude/commands/contract-check.md:11,206`, `.claude/commands/graduate-resource.md:99,126`, and `resolve-incident.md:83` (lower confidence). This alone exceeds the "any caller requires modification to keep working" High threshold.
- `docs/audit-discipline.md` has 27 distinct referencing files (`grep -rln "audit-discipline.md" --include="*.md" .claude docs skills workflows`); `docs/qc-independence.md` has 18. Both are far past the 5-caller Medium ceiling on raw count alone.
- Two of the confirmed-broken consumers are **operationally significant, not incidental**: `.claude/commands/risk-check.md:24` — the command that dispatches this very review — now states "Two intended call sites per session (per `audit-discipline.md § When to fire`)" while the doc it cites now says the opposite ("operator-invoked only... no plan-time or end-time gate exists"), a live self-contradiction in the review apparatus itself. `.claude/commands/create-skill.md:58` — a core, frequently-invoked build-pipeline command — grounds its Step 4 Auto-Fix loop in a rule (`workspace CLAUDE.md § QC → Triage Auto-Loop` → `qc-independence.md § QC → Triage Auto-Loop`) whose target section S1 deleted.
- This is a genuine, previously-unaccounted-for blast radius, distinct from the disclosed and expected S2/§6 interim state (wrap-session.md 12b/12c, promote-workflow.md, friday-journal.md/friday-act.md, prime.md, session-plan.md — all correctly named in the change description as surviving until S2/§6 land).

### Dimension 4: Reversibility
**Risk:** Low

- S1 is 10 plain-text edits to git-tracked docs/skill files plus one append to `logs/friction-log.md` (write-activity autolog) — `git diff --name-only` confirms all 11 paths, no new files, no deletions.
- A single `git revert` of the S1 commit cleanly restores every file to its prior text, including the friction-log append (part of the same commit, no separate cleanup step).
- No external writes: no `git push`, no Notion/API call, no cross-repo write. No hook or automation was added that could fire between landing and a potential revert (Dimension 1/2 already confirm zero `.claude/` touch).
- S2–S4 are not yet executed, so a revert of S1 has zero cross-slice entanglement to unwind.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Functional overlap, live simultaneously.** `docs/audit-discipline.md § Invocation semantics` now asserts, unconditionally: *"No command, hook or policy fires it automatically, and there is no plan-time or end-time gate."* `docs/qc-independence.md` asserts: *"No general review fires automatically... No command, hook or policy spawns them on its own."* Both statements are **false at the exact moment S1 lands**, independently re-derived: `.claude/commands/wrap-session.md:225,227`, `resolve-incident.md:78`, `promote-workflow.md`, `friday-journal.md`/`friday-act.md`, `prime.md:816`, and `session-plan.md:157` all still contain live, automatic invocation logic (confirmed by direct grep and read, not inferred) — none of these command bodies is edited by S1, so their behavior is unchanged. Two systems (the freshly-rewritten policy prose and the untouched command bodies) now give **contradictory answers to the same question** — "does review fire automatically" — which is the textbook Hidden-Coupling overlap pattern.
- **Six undocumented broken contracts** (Dimension 3's consumer list) — implicit dependencies on subsection headings (`§ When to fire`, `§ Verdict semantics`, `§ QC → Triage Auto-Loop`) that S1 deleted without a forwarding note or an entry in any slice's edit list.
- **Mitigating factor, not a mitigation of the score:** the *enforcement* layer (hooks, commit-blocks) is unaffected — this is a documentation/self-consistency coupling failure, not a safety-control regression. Scored on the rubric's own terms ("functional overlap with existing mechanisms," "undocumented new contract... callers must honor") this is still High; the safety point is captured separately in the Dimension 7 discussion and the verdict summary.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present, read in full).

- **OP-9 / AP-7 / DR-7 (speculative abstraction)** — not implicated. This is a net-simplification: S1 is the keystone slice of a stream that deletes two hooks and multiple gate mechanisms (S2) and collapses a 12-slice ceremony into 4 (plan-v3 § 0, R2-F4 disposition). It clears `ai-resource-creation.md` rule #7 prong (a) — reduces load-bearing units while preserving capability via the new proportional review row. No new component is introduced (plan § 5: "Nothing is added to this set").
- **OP-11 / OP-3 (loud revision vs. silent drift)** — this is a legitimate, loud revision of the prior policy (functionally overlapping `DR-8`: "structural changes require `/risk-check` at plan-time and end-time... verdict is binding"), carried out through the `/work-loop` challenged route with two full Codex plan reviews and an explicit G1 operator sign-off (`logs/loop/2026-07-29-review-layer-consolidation-shape.plan-v3.md`, committed on disk) — not silent drift. **Tension, not violation:** the formal `logs/decisions.md` entry that OP-11 expects to carry the rationale is scheduled for **S4**, not yet landed as of S1. And `audit-discipline.md § Invocation semantics`'s unconditional claim ("there is no plan-time or end-time gate") is, as Dimension 5 shows, currently false and uncaveated in the doc text itself — a small, real instance of the pattern OP-3 warns against (a plausible-sounding assertion presented without the transition caveat that would make it accurate). This is a **process-completeness gap**, not a policy the operator hasn't sanctioned — the sanctioning is real and on record in the plan/brief; the doc text just doesn't say so yet.
- **OP-12 (closure before detection)** — this change performs consolidation, not new detection-without-closure; aligned, not in tension.
- **OP-2 / OP-5 (judgment gating / enforcement)** — the new three-row proportional rule keeps deterministic execution-time safeguards ("never removed" per the rule's own text) and reserves risk-aware review for high-consequence changes; this is a proportionality tuning within the repo's existing "Subagent Proportionality" doctrine (retained unchanged by S1), not a silent enforcement→advisory swap. The actual enforcement removal (QC-PENDING commit-block) is S2-scheduled, explicit, and named throughout the plan.

### Dimension 7: Problem Reality
**Risk:** Low

- **Not primarily defect-justified.** The change description frames S1 as executing a G1-approved architectural redesign (consolidating review ceremony) — not a claim that a specific mechanism is currently broken, unwired, or producing wrong output. This is an operator/system-directed policy revision gated through two full Codex plan reviews plus an explicit G1 sign-off, which is the correct mechanism for a judgment call of this kind, not a Dimension-7-gated defect claim.
- **Defect — observed or inferred?** N/A in the primary sense (not defect-justified). Where the change description does make falsifiable factual claims about current state, each was independently re-derived:
  - *"NO file under .claude/ is touched by S1"* — re-derived: `git diff --name-only | grep -c "^\.claude/"` → **0**. Confirmed true.
  - *"Consumer counts... identical to the pre-change baseline"* — re-derived with `find -L "<projects>" -name "<cmd>.md" -path "*/.claude/commands/*"` for all 12 named commands: `qc-pass 26, refinement-pass 26, refinement-deep 26, triage 26, resolve 26, contract-check 22, blindspot-scan 19, implementation-triage 26, risk-check 26, consult 28, reconcile 15, pm 22` — every count matched the claim exactly. Confirmed true.
  - *"Two automatic /risk-check firings will SURVIVE... prime.md:816... session-plan.md:157"* — re-derived by direct read: `prime.md:816` reads *"Run `/risk-check` if STRUCTURAL_RISK is true. This is the plan-time gate per workspace Autonomy Rules #9"*; `session-plan.md:157` reads *"Emit: 'Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).'"* Confirmed true.
  - *"Seven broken command symlinks under projects/... pre-existing"* — re-derived: `test -e` on the resolved target of both named symlinks (`route-change.md`, `audit-critical-resources.md`) returned MISSING for both, confirming broken symlinks pointing at canonical targets that no longer exist on `main`. Confirmed true (the other five, in an untracked backup directory, were not independently re-checked — lower confidence but not load-bearing for this change).
- **Consequence — traced or assumed?** N/A (not defect-justified; no consequence claim to trace).
- **Re-derivation vs. the change description:** None of the change description's affirmative claims were contradicted — every one re-derived and confirmed above. The gap found in this review (the 6 unscheduled dangling consumers, Dimensions 3 and 5) is not a *contradiction* of a claim the change description made; it is a claim the change description's own consumer inventory (plan-v3 § 8) never attempted to cover (§ 8 is scoped to `projects/` symlink counts only, not prose citations to subsection headings within `.claude/commands/`). This is scored under Dimensions 3/5, not here, per the instruction that Dimension 7 grades the stated premise, not defects the change introduces.
- **Not defect-justified — no premise to verify** beyond the specific factual claims above, all of which were independently confirmed. Risk: Low.

## Recommended redesign

RECONSIDER is driven by Dimensions 3 and 5 (Blast Radius, Hidden Coupling), not Dimension 6, so the remedy is re-scoping, not a principle-revision write-up. Both directions below are narrow and proportionate to the actual gap found — this is not a call to re-architect the stream:

- **Close the consumer-inventory gap before re-running this gate.** Fold the 6 confirmed dangling-reference repairs (`placement.md:79`, `risk-check.md:24`, `create-skill.md:58`, `contract-check.md:11,206`, `graduate-resource.md:99,126`, and `resolve-incident.md:83` if S2 does not already cover it) into S1 itself, or into an explicit S1.5 that lands before S1's commit — these are pure pointer corrections (retarget the citation to the surviving `§ Risk-check change classes` / new `§ Invocation semantics` / new proportional-rule language), not policy changes, so they carry none of S1's own review weight. Re-run the plan's own falsifier 8 (`grep -rn '...two-gate...' docs/ .claude/ skills/`) against the *actual* result before treating the transition as closed — the plan states this falsifier but the evidence here shows it was not fully executed or its hits were not fully dispositioned.
- **Add one transitional caveat sentence** to `docs/audit-discipline.md § Invocation semantics` and `docs/qc-independence.md § No general review fires automatically`, noting that S2's hook/command removals have not yet landed and naming the stream, so the doc does not assert a repo-wide invariant that is currently false (closes the Dimension 5 contradiction without waiting for S2–S4 to land).
- **On the explicit question asked:** the S1-then-S2 ordering is directionally correct and should **not** be inverted — enforcement mechanisms are unweakened during the interim (every hook and commit-block confirmed still live and firing), and inverting the order would remove automation before the docs define what replaces it, which is the worse failure mode. The exposure found here is a documentation-consistency gap, not a safety regression; it is real and should be closed before the transition-gate result is treated as final, but it does not argue for reordering the slices.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
