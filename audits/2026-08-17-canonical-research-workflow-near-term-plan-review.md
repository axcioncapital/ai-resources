# Independent Review — Canonical Research Workflow Near-Term Implementation Plan

**Date:** 2026-08-17  
**Artifact reviewed:** `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md`  
**Method:** repository-owned primary sources — live commands, workflow instructions, skills, deployment contracts, policy docs, logs, Git refs, and the three proposal inputs — plus current first-party Perplexity documentation for the one vendor premise that affects sequencing. No implementation files were changed.

## Current verdict after correction verification

**READY.** The corrected plan resolves every original P0/P1 blocker and every bounded correction from the verification pass. No implementation-plan blocker remains. Operator gates G1–G5, latest-main reconciliation, slice-specific preconditions, and the required pre-build risk-aware reviews remain real authorization/execution prerequisites; “ready” judges the plan, not approval of its proposals or permission to implement them.

### Correction-verification matrix

| Former blocker | Status | Verification |
|---|---|---|
| P0 — S3 architecture/genericness/deploy | **RESOLVED** | S3 is now an explicitly selected profile outside the generic template; generic deploy preserves template bytes, profile deploy instantiates the project file, specialization is conflict/manual, two consumers and G5 genericness/no-country authorization are prerequisites (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:103-108`). This now matches the per-project reference contract (`workflows/research-workflow/docs/required-reference-files.md:13-18,72-78`) and separates deterministic from judgment proof (`plan:105,138,146`). |
| P0 — reference/runtime propagation | **RESOLVED** | S0 inventories immutable references, instantiated references, and runtime files with conflict-aware fixtures; S2–S4 depend on it and existing-project propagation cannot precede it (`plan:39,54,85-90,101,108,115,130,153`). It now explicitly requires a risk-aware Codex review of cross-project write, overwrite, deletion, rollback, and conflict-classification behavior **before** implementation (`plan:87`), satisfying `docs/audit-discipline.md:56-75`. |
| P0 — S5 qualification/loading/semantics | **RESOLVED** | S5 no longer pre-decides a command, routes mechanism selection correctly through `/develop-ai-resource`, records all five complexity-budget answers, requires real non-RW loading/invocation tests and normal command sync if selected, and makes G1 settle the behavioral matrix (`plan:48,60,117-122,159`). If qualification selects a new command or skill, its structural risk-aware Codex review must clear before implementation; reuse/non-artifact outcomes retain proportionate review (`plan:120`). This agrees with `docs/ai-resource-creation.md:11-16,29-48`, `.claude/commands/develop-ai-resource.md:99-110`, and `docs/audit-discipline.md:56-75`. |
| P0 — S4 credential/confidentiality/spend/access truth | **RESOLVED** | S4 now fixes environment-only credential sourcing, explicit dispatch/spend and confidentiality gates, redaction, bounded retry/fail-closed/atomic/idempotent behavior, four distinct access states, direct-fetch/read proof, adversarial cases, all scarcity paths, and a risk-aware pre-build review (`plan:110-115,139,147,202`). This satisfies the risk class in `docs/qc-independence.md:9-20,33-39` and the prior observed hazards in `audits/risk-checks/2026-07-26-stand-up-live-perplexity-api-path-article-two-research.md:46-74,94-101`. |
| P1 — S1 scope/metric/proof | **RESOLVED** | S1 now uses July W4-H1–H4, inventories live seams, caps summaries, requires ≥80% payload-byte reduction, preserves a documented exception route, and uses semantic/schema regression rather than byte-identical AI prose (`plan:31,55,91-95,136,145,231`; source: `audits/token-audit-2026-07-03-ai-resources.md:253-291`). |
| P1 — authority and completion semantics | **RESOLVED** | G4 explicitly controls S2; `/mission update` is correctly limited; G5 requires successor/supersession; reject outcomes and closure-vs-DELIVERED are coherent (`plan:101,157-177,212-229`; `.claude/commands/mission.md:76-126`). S5 consistently requires G1 behavior approval plus G5 successor authority (`plan:122,130,163,169`). S2 now proves both branches of its outcome: unopened citations cannot affect claims/coverage, and a retrieval-tool negative cannot create or upgrade scarcity/non-existence without direct-access evidence (`plan:97-101`). |
| P1 — programme thresholds | **RESOLVED** | §6 now explicitly freezes the benchmark before **S1, S4, or S5** changes a measured path and binds the Deep relay baseline to pre-S1 capture (`plan:151`); S1 independently requires pre-edit fixture instrumentation (`plan:93`). DELIVERED depends on the numeric effort/quality thresholds (`plan:223-229`). No further timing correction is needed. |
| P1 — factual corrections | **RESOLVED** | Placeholder count is corrected (`plan:33`); command count is ref-bound and latest-main reconciliation required (`:29,89,231`); S6 names the external checkout commit and four suites (`:35,124-128`); `/mission` is corrected (`:163`); unsupported Sonar retirement timing is withdrawn and current endpoint behavior is build-time verified (`:113,201`). |

### Remaining implementation-plan blockers

**None.** The plan is ready for the operator's G-session. Implementation remains conditional on the recorded gate outcomes and each slice's stated prerequisites; this review does not approve a gate or authorize a repository change.

## Original verdict (superseded; preserved for audit history)

**NOT READY.** The plan has a sound high-level decomposition and handles proposal-vs-authority status better than the three source plans do individually, but four implementation contracts are presently unsatisfied: S3 contradicts the deployment model, S2–S4 cannot propagate through the named sync path, S5 has no valid zero-deployment command-loading path and is routed through the wrong build engine, and S4 omits the credential/confidentiality/spend controls required for billed external automation. These are correctable design gaps, not reasons to abandon the programme.

## What is good and should remain

1. **The plan does not silently promote proposals into authority.** Its baseline G4 rule and explicit G1/G2 collision with the active mission correctly separate technical readiness from authorization (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:78-80,138-148`; mission rejection list at `logs/missions/research-workflow-deploy-fitness.md:39-47`).
2. **The judgment rollout is correctly trial-first.** S6 preserves the judgment plan's explicit local-trial prerequisite and defers canonical rollout (`plans/canonical-research-workflow-judgment-and-insight-plan.md:331-343,443-455`; reviewed plan `:112-116`).
3. **The plan preserves core evidence disciplines.** Lead-vs-source separation, evidence/inference labeling, independent execution-tool assignment, and falsifiable before/after proof are all directionally aligned with the canonical workflow (`workflows/research-workflow/reference/stage-instructions.md:40-66,68-79`; `docs/cross-model-rules.md:3-13`).
4. **S5 is intentionally independent of S4.** The manual fallback means a G1 approval does not become hostage to an automation build (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:106-110`). Retain this dependency shape after correcting the invocation mechanism.

## Material findings

### P0 — S3's acceptance test is impossible under its stated boundary

The plan says S3 is “reference data only” and passes when a fresh scratch deploy yields a filled, usable source-class map “with no hand-authoring” (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:94-98`). The governing deployment contract says the opposite:

- `source-class-hierarchy.template.md` is instantiated **per project** with the project's taxonomy (`workflows/research-workflow/docs/required-reference-files.md:13-18`).
- All `reference/*.template.md` files are deferred and must survive deployment byte-identical; deploy never fills their internal placeholders (`.claude/commands/deploy-workflow.md:320-384,511-567`).
- The mapper reads the project-owned instantiated file and exits if it is missing or malformed (`skills/source-class-mapper/SKILL.md:12-18,35-48,101-116`).

Therefore a canonical template fill cannot simultaneously remain byte-identical and become an instantiated `reference/source-class-hierarchy.md` on fresh deploy without changing deployment mechanics. The proposed macro/sector/trend default also needs a genericness ruling: the active mission forbids canonical country choices and requires project-declared inputs rather than hard-coded pilot answers (`logs/missions/research-workflow-deploy-fitness.md:28-32,68-73`).

S3's proof classification is also too strong. Placeholder absence and non-empty output are deterministic; “domain-correct mapping” is Sonnet judgment over question intent and a taxonomy (`skills/source-class-mapper/SKILL.md:101-107,131-138`) and needs a labeled fixture set or reviewer rubric rather than being listed only as deterministic proof.

**Required correction:** choose and specify one architecture: (a) a generic canonical registry separate from the per-project template, consumed as a fallback; (b) a deploy-time profile that explicitly instantiates a domain registry; or (c) keep per-project authoring and narrow S3 to improving the template/guide. Name all affected consumers, update the deploy contract if necessary, split mechanical proof from mapping-quality evaluation, make the test match the chosen architecture, and make S3 completion conditional if G5 declines it.

### P0 — The stated integration path cannot carry S2, S3, or S4

The plan says deployed copies will be integrated through existing `/deploy-workflow` / `/sync-workflow` machinery (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:136`). Current `/sync-workflow` inventories only `.claude/commands`, `.claude/agents`, `.claude/hooks`, and `logs/scripts` (`.claude/commands/sync-workflow.md:30-54`). It does not see:

- `reference/stage-instructions.md` (S2),
- `reference/source-class-hierarchy.template.md` or a new reference guide (S3), or
- a new top-level `scripts/` runtime (S4).

This is a known, already-recorded defect: the reconciliation ruling states that `/sync-workflow` cannot see `reference/` and can report a project current while reference files are wrong (`audits/2026-08-13-workflow-sync-reconciliation-ruling.md:76-85`). Project runtime references are regular project-owned copies, not live canonical fallbacks (`workflows/research-workflow/docs/required-reference-files.md:72-78`).

**Required correction:** add a prerequisite integration slice that expands sync/deploy inventory with explicit template-vs-instantiated classification for `reference/` and the selected runtime directory, or state that S2–S4 are new-deploy-only and remove claims of existing-project propagation. The former is the useful route. Include conflict-aware sync tests because deployed reference files legitimately contain project specialization.

### P0 — S5's mechanism, loading path, and semantic contract are unsettled

The proposed `/research` command is said to run in any project with “zero project deployment” (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:106-110`). Repository rules state that `--add-dir` does not load shared commands; a command runs in a project only when its own `.claude/commands/` contains the synced symlink (`docs/ai-resource-creation.md:11-16`). Zero workflow deployment may be possible, but zero command installation/sync is not.

The plan also routes a command through `/develop-ai-resource` → `/create-skill`. `/develop-ai-resource` sends only new **skills** to `/create-skill`; it builds commands/scripts/hooks directly after mechanism qualification (`.claude/commands/develop-ai-resource.md:99-110`). In addition, every new command must answer the five complexity-budget questions, say what it replaces or why it must be separate, and name a wired invocation path rather than depend on operator memory (`docs/ai-resource-creation.md:29-48`). The plan does none of these explicitly.

Finally, G1 is not merely a vocabulary choice. Lean R2 is plan → batched retrieval → synthesis → one QC pass (`plans/lean-research-workflow/proposal.md:71-81`); judgment-plan Standard requires formal extraction, permission and sufficiency controls, and a House View for content/advice/recommendations (`plans/canonical-research-workflow-judgment-and-insight-plan.md:254-269`). The two proposals share an assignment-effort axis but not an equivalent operating contract.

**Required correction:** make G1 settle the actual Light/R1 and Standard/R2 control matrix, escalation rules, and House-View trigger—not just labels. Then let `/develop-ai-resource` choose command vs skill vs another mechanism; if a command remains, specify its shared-command sync/install path and clear the full complexity budget.

### P0 — S4 lacks the safety and truth contract for external automation

S4 creates a credentialed, billed, third-party egress path but specifies neither credential sourcing nor a spend/dispatch checkpoint, confidentiality screening, log redaction, retry/rate-limit behavior, or failure recovery (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:100-104`). The canonical `execution-agent` itself is silent on credential sourcing while requiring confidentiality boundaries and metadata logging (`workflows/research-workflow/.claude/agents/execution-agent.md:8-28`). A prior repository risk assessment of the same Perplexity-API shape found credential-contract ambiguity and ungated billed egress to be material and required explicit credential, routing, decision, and operator-checkpoint controls (`audits/risk-checks/2026-07-26-stand-up-live-perplexity-api-path-article-two-research.md:46-74,94-101`).

The proposed Source Access Log also overclaims “ground truth.” An API response citing a URL does not prove that URL was directly fetched, yielded usable content, or was actually read. The one negative test—an unfetchable URL emits `accessed: N`—does not distinguish redirects, paywalls, bot challenges, empty/partial bodies, or a citation merely surfaced by Perplexity. Nor does S4 prove its domain-resolution precheck guards every scarcity-emission route, including the existing Stage-2 supplementary and Stage-3 gap paths (`workflows/research-workflow/reference/stage-instructions.md:68-79,101-110`).

**Required correction:** specify one credential contract, an explicit pre-call spend/confidentiality gate, safe logging, bounded failure/retry behavior, and direct-fetch semantics. Define separate fields for `attempted`, `retrieved`, and `usable/opened`; never infer “opened” from a Perplexity citation. Add adversarial fixtures plus command-path tests proving every scarcity writer consumes the precheck/log. Treat the new runtime and shared log automation as high-consequence: one risk-aware Codex review occurs **before** implementation, not only a generic post-change review (`docs/qc-independence.md:9-20,33-39`; `docs/audit-discipline.md:56-75`).

### P1 — S1 uses an outdated/incomplete source and has no executable threshold

The May token audit estimates 10k–50k tokens but explicitly says there is no execution telemetry and return sizes are inferred (`audits/token-audit-2026-05-18-research-workflow.md:45-69,105-109`). A later July audit expands the live finding to four relay classes across `run-report`, `verify-chapter`/`execution-agent`, `run-analysis`, `run-synthesis`, `run-execution`, `run-cluster`, and `produce-architecture`; it also warns that some relays may be intentional and calls for one end-to-end chapter regression (`audits/token-audit-2026-07-03-ai-resources.md:253-272,282-291`). The plan instead describes only “Stage 3–4,” says no design is open, and treats an estimate as the expected reduction (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:82-86,192`). There is no fixture or harness in the canonical workflow that makes token usage or byte-identical AI output deterministic.

**Required correction:** ground S1 in the July audit, explicitly choose which of W4-H1–H4 are in scope, reconcile the documented context-isolation carve-out (`workflows/research-workflow/docs/required-reference-files.md:72-76`), and define a runnable structural metric (for example, bytes/tokens relayed through main-session payloads) with a numeric pass threshold. Use semantic/schema equivalence for AI-authored outputs rather than byte identity unless the fixture freezes model output.

### P1 — Authority mechanics contain two contradictions and one stale fact

1. G4 says approving the plan authorizes S2, while S2 says a separate canonization decision is needed if the 2026-08-14 ruling was project-scoped (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:80,88-92,145`). The repository log records the ruling as applied in one worktree and canonical propagation as still gated (`logs/improvement-log.md:3980-4001`). G4 must either explicitly authorize canonical propagation or S2 needs its own decision gate; both cannot remain true.
2. G5 says `/mission` has no update verb (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:146`). The current command exposes `update` (`.claude/commands/mission.md:1-4,25-31,76-126`). The important constraint is different: `update` may change only Open threads; Goal/scope/validation remain frozen. A successor decision or explicit supersession is therefore still needed for G1/G2, but the factual rationale must be corrected.
3. Completion requires S1–S3 regardless of gate result, even though S3 is gated by G5, while only S4/S5 are written conditionally (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:184-190`). A G5 “not adjacent” decision would make the programme permanently incomplete.

**Required correction:** bind each gate outcome to an explicit slice disposition and completion rule; state exactly what approval record supersedes the mission's rejection; correct `/mission` capability; and make rejected slices complete as recorded non-build decisions, consistently across S3–S5.

### P1 — Proof of the programme outcome is not measurable

The operating goal is “substantially more research output” with “substantially less operator and AI effort” at unchanged evidence standards (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:12-20`). Completion contains artifact/run counts but no baseline, target, or non-regression threshold for throughput, operator time/touchpoints, AI tokens/cost, turnaround, or evidence quality (`:182-190`). The current quality log has no data rows, so it cannot serve as a baseline (`workflows/research-workflow/logs/research-quality-log.md:1-13`). One R1 and one R2 run can prove operability, not “substantial” improvement.

**Required correction:** define a small pre/post benchmark set and numeric decision thresholds before implementation. At minimum measure elapsed time, operator active minutes/relay events, model/API cost or tokens, artifact count, load-bearing-claim source validity, evidence/inference violations, and unresolved gaps. Separate adoption evidence (“the route ran”) from outcome evidence (“it materially improved throughput without quality regression”).

### P1 — Several current-state facts need correction or reproducible binding

- The source-class template contains **22 placeholder occurrences / 21 distinct literal spellings**, not 16 (`workflows/research-workflow/reference/source-class-hierarchy.template.md:1-108`; direct `rg -o '\{\{[^}]+\}\}'` count). This does not change the diagnosis but weakens the “verified substrate” table.
- The plan's **30-command** count is correct for the reviewed checkout, but it is ref-sensitive rather than a safe repository-wide statement. Reproducible results: `git ls-tree -r --name-only HEAD workflows/research-workflow/.claude/commands | wc -l` → 30 at `HEAD` `52841b17`; the same command against local `main` → 30 at `22c0079d`; against the current local `origin/main` ref → 29 at `3e7789cd`. `git diff --name-status origin/main..HEAD -- workflows/research-workflow/.claude/commands` identifies the sole difference as added `inject-dependency.md`. Keep the checkout-bound claim, but do not generalize it to `origin/main` until refs are refreshed or reconciled.
- The plan says all substrate claims were inspected “in this checkout,” yet S6's project artifacts and test suites are outside this repository checkout and are cited only through the judgment proposal (`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md:22-35`). Bind S6 to an exact checkout/commit and name the four test commands/suite paths before it becomes executable.
- The claimed **2026-09-27 Sonar retirement is unsupported and contradicted by the current official documentation**: Perplexity's [API Quickstart](https://docs.perplexity.ai/docs/getting-started/quickstart) lists Agent, Search, Sonar, and Embeddings as active APIs; the [Sonar quickstart](https://docs.perplexity.ai/docs/sonar/quickstart) actively documents Chat Completions; and the official [changelog](https://docs.perplexity.ai/docs/resources/changelog) publishes no such retirement. Meanwhile, the [Agent API web-search documentation](https://docs.perplexity.ai/docs/agent-api/tools/web-search) does document domain, recency, and language filters. Remove the deadline rationale unless an authoritative deprecation notice is produced; retain execution verification for project-specific semantics. The separate “CustomGPT has no public API” assertion still lacks first-party support in the repository and must remain an external premise rather than schedule authority (`plans/research-retrieval-layer-improvement-plan.md:79-87,95-96,155-160`).

## Prioritized correction order

1. **Re-architect S3 and add the missing propagation prerequisite** for `reference/` plus the runtime directory; then update sequence and completion conditions.
2. **Resolve G1 semantically and re-qualify S5's mechanism** through `/develop-ai-resource`; specify how the resulting entry point loads in consuming projects and clear the new-component budget.
3. **Add S4's credential, confidentiality, spend, direct-fetch, and scarcity-path contract** and schedule its required risk-aware pre-implementation review.
4. **Re-scope S1 against the July audit** with an executable structural metric and representative semantic regression.
5. **Repair gate semantics and factual substrate claims:** explicit S2 authority, correct `/mission` behavior, conditional completion for every declined gate, placeholder count, exact S6 checkout/tests, and externally verified API premises.
6. **Add programme-level baseline and thresholds** so “substantially more / substantially less / unchanged quality” can be accepted or rejected on evidence.

After these corrections, the six-slice decomposition is likely suitable for implementation; before them, beginning S1 under G4 would commit the programme to a plan whose deployment, safety, and completion contracts are internally inconsistent.
