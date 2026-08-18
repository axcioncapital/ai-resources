---
task: canonical-rw-lightweight-l3
status: active
turn: codex
---

## Objective and scope

Deliver the lightweight Research Workflow lane (L3) from the approved canonical near-term plan: one shared entry capability with Light, Standard and Deep behaviour; preserved per-claim evidence and evidence-versus-inference discipline; one-way escalation so a load-bearing claim cannot remain on an under-controlled route; and Deep handoff to the existing deployed Research Workflow. The task exit condition is accepted L3 core behaviour and its plan-required deterministic and representative proof, stopping cleanly at the Standard-route House View seam unless and until L2 publishes its stable authority contract.

Scope is the lightweight-RW lane only. Excluded: inventing or finalising the Standard-route House View adapter before L2's stable contract; any separate House View or judgment mechanism; changes to the deep pipeline; retrieval runtimes or APIs; source profiles or products; propagation infrastructure; official-statistics ingestion; Content Programme integration; broad rollout; merge; and push.

## Lane and unit

Standard. Implementation mode. Unit 1 — shared entry Light vertical slice.

Named reason for the loop: L3 spans several independently useful implementation units, its scope must be bounded away from the live L1/L2 lane and removed programmes, and its evidence must be assessed by someone other than the implementer before it counts as accepted.

## Brief

L3 core is ready now because the operator-approved plan explicitly allows it to run concurrently with L1/L2, and this checkout is the separately created lightweight-RW lane. This first unit establishes the smallest useful vertical slice: a shared entry that classifies all three routes, performs real Light behaviour, prevents an unsafe Light result, and hands Deep to the existing workflow; full Standard behaviour remains a later unit and its House View adapter remains gated on L2.

**Required outcome:** Build one working Light vertical slice behind a shared research entry capability. The entry accepts an incoming question or brief and an optional explicit route preference, conservatively classifies Light, Standard or Deep from expected output, consequence and scope, defaults ambiguity to Standard, and lets safety-driven escalation override a requested lighter route. Light must dispatch actual behaviour rather than only print a route label: from fixed or locally supplied evidence it produces a compact research note whose material claims map to sources and dates, whose inferences are visibly distinguished from evidence, and whose gaps are explicit. If inspection exposes a load-bearing claim, external/publication consequence, thesis-grade judgment, or scope beyond Light control, the route must escalate one way before a Light answer is treated as complete.

The same entry must recognize Standard and Deep in this unit. Standard may end at an explicit, honest not-yet-implemented boundary for the next unit; it must not fabricate Standard output or introduce any House View trigger, adapter, approval, or judgment content. Deep must hand off to the existing deployed Research Workflow entry with the prerequisites and next action made usable; it must not redesign or copy the deep pipeline.

**Governing sources and dispositions:**

- The operator's 2026-08-18 request governs this lane boundary, the required components, the L2 dependency, and the no-merge/no-push constraint.
- `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md` is governing authority only as content approved at commit `8bf9d0d96ca7796621035e3f83b50c9dfc8055ec`. Apply §§ 1, 3, 5 L3, 6, 7 and 8. Its approval supersedes the deploy-fitness mission's research-tier prohibition for L3 only; no other mission thread is reopened.
- `plans/lean-research-workflow/proposal.md` is non-governing background. Its `/research` name, three route heuristics and lightweight-note idea are candidate implementation guidance, not requirements when live repository evidence supports a smaller or safer mechanism.
- `workflows/research-workflow/` is verify-first repository reality for the Deep handoff. It is a handoff target, not an edit surface in this unit.

**Check against the repository before acting:**

1. Verify from Git that approved plan commit `8bf9d0d96ca7796621035e3f83b50c9dfc8055ec` is an ancestor of this checkout's HEAD and that this is branch `session/2026-08-18-lightweight-rw`. If either is false, stop and hand back.
2. Search `.claude/commands/`, `skills/` and directly relevant command registries for an existing shared entry with the L3 responsibility; the preparation pass found no `.claude/commands/research.md`, but that is a claim to re-check, not authority to create a duplicate.
3. Inspect the real shared-command loading convention using at least one non-RW project shape or a faithful local fixture. Establish how a new entry can be loaded without adding propagation machinery or changing a live consumer.
4. Inspect `workflows/research-workflow/CLAUDE.md.template`, `SETUP.md`, and `.claude/commands/run-preparation.md` to establish the existing Deep entry and its prerequisites. Do not infer the handoff from the five-stage label alone.
5. Before editing any existing canonical file, enumerate its live symlink consumers and verify their state. This unit is deliberately framed to use new L3-owned surfaces; if an existing canonical edit is actually necessary, stop and hand back with the exact file and reason rather than taking live effect silently.

**Codex framing decisions:** Keep this unit to one vertical slice and new L3-owned entry/support/test surfaces. Treat explicit route words as preferences constrained by evidence and consequence, never as permission to downgrade control. Hold full Standard execution, cross-route representative use, the L2 House View seam, catalog/deployment propagation, and any deep-pipeline changes outside this unit so the first result has one dominant deliverable and one proportionate evidence set.

**Required evidence:**

1. Show the pre-change failing case or absence for the shared entry.
2. Add a deterministic invocation-path test that can fail and uses the real entry surface in a non-RW fixture. It must prove: the surface loads; representative Light, Standard and Deep inputs classify correctly; ambiguity becomes Standard; a requested Light case containing a load-bearing or higher-consequence claim escalates rather than completes as Light; the Light path produces the evidence/source/date, inference and gap structure; Standard stops honestly at its bounded next-unit seam; and Deep resolves to the existing deployed workflow entry rather than merely printing `Deep`.
3. Run the new test before and after implementation where practical, quoting the failing and passing result. If one combined test cannot show the behavioural distinction honestly, use the smallest additional fixture needed and explain why.
4. Report changed paths and confirm that no existing Research Workflow pipeline file, L1/L2 judgment surface, live project, propagation surface or out-of-scope programme changed.
5. Report any limitations that the later Standard unit must inherit; do not solve them here.

**Completion condition:** One shared entry can be loaded through a representative non-RW invocation path, correctly routes all three classes, performs a complete evidence-controlled Light path, escalates unsafe Light work one way, and gives a usable Deep handoff, with deterministic regression protection. Standard remains explicitly unfinished and contains no House View mechanism.

**Stop conditions:** Stop and hand back if a premise above is false; the entry cannot work without a retrieval runtime, API, new external capability or propagation system; a working Deep handoff requires changing the deep pipeline; any House View or judgment contract must be invented; an existing canonical edit would take live effect in a consumer whose state cannot be verified; or the required test cannot distinguish dispatch behaviour from label printing.

Capability subset: baseline only — read/search/history inspection, local edits inside new L3-owned shared-entry/support/test paths plus this state file, local tests, and a local commit by Claude. Baseline deny set must be passed in full if a carrier is used. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Network, external tools, live consumer writes, merge and push are not selected.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git rev-parse --abbrev-ref HEAD` returns `session/2026-08-18-lightweight-rw`; `git merge-base --is-ancestor 8bf9d0d96ca7796621035e3f83b50c9dfc8055ec HEAD` exits 0, and that commit is `update: research-workflow — replace 12-slice plan with lean four-outcome two-lane plan`. HEAD is `e7f9f682`.
- Claim (2): HOLDS — no existing shared entry with the L3 responsibility. Searched `.claude/commands/` (89 files) for names matching `research|route|light|deep|standard` — no match; `.claude/commands/research.md` absent. Searched `.claude/commands/`, `skills/` and `workflows/` for `lightweight research` — no match. Searched both trees for a route classifier (`light[^a-z]{0,3}(standard|route)|route classif|classif.*(light|deep) route`) — three hits, all unrelated on inspection: `answer-spec-generator` and `answer-spec-qc` use `light|standard|strict` as a *strictness* setting, and `capability-development` cites a different contract's route classification in `docs/work-loop.md`. Nothing to duplicate.
- Claim (3): HOLDS — the loading convention is symlink-from-canonical, and it does not reach this lane. `.claude/hooks/auto-sync-shared.sh` walks ancestors for a directory literally named `ai-resources` holding `.claude/commands` (lines 46–52), then symlinks `$AI_RESOURCES/.claude/commands/*.md` into each project. Verified against a real non-RW project shape: `projects/ai-development-lab/.claude/commands/` holds symlinks resolving to `/Users/.../Axcion AI Repo/ai-resources/.claude/commands/...`. Searched `projects/` for `ai-resources-lightweight-rw` — no match. A new command added to this lane therefore takes no live effect in any consumer, and no propagation machinery was needed or added.
- Claim (4): HOLDS — the Deep entry is `/run-preparation`. `workflows/research-workflow/.claude/commands/run-preparation.md` exists and executes the Stage 1 preparation pipeline, reading a task plan draft supplied via `@` reference and pausing for operator approval at the Task Plan (Step 1b) and Research Plan (Step 3b). `SETUP.md` step 9 names the prerequisite artifact `preparation/task-plans/[section]-task-plan-draft.md` and step 11 confirms `/run-preparation` as the first command run. `CLAUDE.md.template` line 54 confirms the five-stage pipeline. The handoff was established from these files, not from the stage label.
- Claim (5): HOLDS — no existing canonical file was edited, so no live symlink consumer was touched. `git diff --name-only` reports no modification to any file this unit authored against; the only two tracked files showing as modified are hook side-effects (see Limitations 6). All three unit surfaces are new paths.

Result: Unit 1 is implemented. Three new L3-owned surfaces, no existing file edited.

- `.claude/commands/research-route.md` — the shared entry. Reads the request and any stated route preference; assesses six named signals (`output`, `consequence`, `scope`, `load_bearing_claim`, `thesis_judgment`, `preference`), each admitting an explicit `unclear`; resolves a route floor from a delimited `route-rules` block; and dispatches. Escalation is one-way by construction: a preference may raise the route above the floor and can never lower it below. Light produces a note with `[EVIDENCE]` items carrying `Source:` and `Date:`, `[INFERENCE]` kept separate, and explicit `Gaps:`, plus a mid-note escalation rule if a load-bearing claim, external consequence, thesis judgment or out-of-scope need surfaces after work has started. Standard stops at an explicit not-yet-implemented boundary and forbids fabricated output. Deep hands off to `/run-preparation` with its prerequisite draft path, or to `SETUP.md` steps 1–9 where no project is deployed.
- `logs/scripts/research-route-classify.sh` — resolves signals to a route by **parsing the rules out of the entry file it is pointed at**. It holds no copy of them, so the executable check and the instruction a human reads cannot drift apart, and the entry stays complete on its own for a project that has only the command file.
- `logs/scripts/research-route-l3-unit-1.test.sh` — the deterministic harness.

Named entry `/research-route`, not the proposal's `/research`: a built-in Claude Code skill already occupies `research`. The brief records the proposal as non-governing background, so this is a naming choice, not a scope change.

Evidence:

1. **Pre-change failing case.** `bash logs/scripts/research-route-l3-unit-1.test.sh` run before any surface existed: `0 passed, 14 failed`, exit 1 — A1 `symlink does not resolve to a readable file`, A2–A10 `classifier absent`, A11–A13 `no '## Light'/'## Standard'/'## Deep' section in the entry`, A14 `entry absent, so the absence claim is untested`.
2. **Post-change.** Same command, same fixture: `14 passed, 0 failed`, exit 0.
3. **The harness caught two real defects between those runs**, which is what shows it is not tautological. A11 failed because the section extractor was terminated by the Light note template's own `## Answer` / `## Evidence` headings — fixed by skipping fenced blocks. A14 failed because a blunt "House View never appears" assertion rejected the entry's own *prohibition* of House View — refined to require that every House-View mention carries a negation, so a line defining a trigger or adapter still fails.
4. **Mutation proof that the behavioural assertions bind to the entry's real content.** Deleting the single line `FLOOR standard load_bearing_claim=yes` from a scratchpad copy of the entry and re-running the A6 signal set: the real entry returns `route: standard / preference-overridden: yes / floor-set-by: load_bearing_claim=yes`; the mutated copy returns `route: light / preference-overridden: no / floor-set-by: base`. The one-way escalation assertion fails when the rule it names is removed.
5. **What the harness proves, split honestly.** A1–A10 are behavioural: the entry loads through a fixture non-RW project whose `.claude/commands/` symlink has the shape the sweep produces, and representative signal sets resolve — Light for a bounded internal note; Standard for an analysis; Deep for a broad report; Standard for any `unclear`; Standard over a requested Light when a load-bearing claim, external consequence or thesis judgment is present; Deep over a requested Light; Deep when a preference raises it. A11–A14 are structural conformance checks over instruction prose — the entry is a Claude Code command, so no automated check can execute its note production. That distinction is stated in the harness header rather than blurred.
6. **Changed paths.** New: `.claude/commands/research-route.md`, `logs/scripts/research-route-classify.sh`, `logs/scripts/research-route-l3-unit-1.test.sh`. Plus this state file. **Confirmed unchanged:** no file under `workflows/research-workflow/`; no L1/L2 judgment surface; no live project; no propagation surface (`.claude/hooks/auto-sync-shared.sh` untouched); no out-of-scope programme. `git diff --name-only` before commit listed only `logs/friction-log.md` and `logs/innovation-registry.md`, both written by session hooks rather than by this unit, and both left out of the commit.

Limitations the later Standard unit inherits — not solved here:

1. **The entry is not reachable from any deployed project.** It exists only in this lane checkout, and the sweep syncs from the canonical `ai-resources` directory. Making it reachable is deployment/propagation work, which the brief excludes.
2. **Signal assessment is Claude's judgment and is not deterministically testable.** Only the signals-to-route mapping is machine-checked. A wrong signal read yields a wrong route with no automated catch. The `unclear`-defaults-to-Standard rule is the mitigation, not a fix.
3. **The Light note's content quality is unverified by automation** — A11 checks that the entry *requires* the four structural elements, not that a produced note honours them.
4. **The name `/research-route`** is now load-bearing for the Standard unit and any later documentation.
5. **The Standard route returns an honest stop only.** The House View seam stays closed pending L2's stable authority contract, as the brief requires.
6. **Observed, out of scope:** `logs/friction-log.md` was appended to by the `log-write-activity.sh` hook during this unit, despite the workspace-wide freeze that hook is documented to carry a guard for. The write succeeded rather than failing, so the freeze is not holding in this checkout. Not fixed here — it is outside `## Objective and scope`, and the modified file was excluded from the commit.

## Blocker

None.

## Next action

Codex: assess Unit 1 — shared entry Light vertical slice, against the brief's completion condition. Decide close, continue to the Standard unit, correct once, or stop. Two deferrals are recorded above for the closure record if the task later closes: propagation/deployment of `/research-route` beyond this lane (Limitation 1), and the friction-log freeze not holding in this checkout (Limitation 6).
