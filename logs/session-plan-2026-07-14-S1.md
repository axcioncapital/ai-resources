# Session Plan — 2026-07-14

## Intent
Verify each of thread 5's three premises against the real files, then repair the evidence-adjudication rules that are actually broken — the four-class table's gap and overlap, the evidenced-negative vs absence-of-evidence wording, and the skill-vs-chassis class-name authority split — with no new permission class.

## Model
opus — match (session is Opus 4.8). The hard part is *deciding*: re-cutting a four-class partition so it admits every evidence shape exactly once, under an explicit no-new-class constraint. Judgment under ambiguity, not mechanical edit.

## Source Material
- `workflows/research-workflow/reference/quality-standards.md` — the chassis. `§ Claim-Permission Classes` (:180–231), `§ Evidence Scarcity Handling` (:72–78), `§ No-Source-Substitution Rule` (:84–100), `§ Research Stop Conditions` (:233–245).
- `workflows/research-workflow/reference/claim-permission.template.md` — the project-fillable threshold table. Empty of the numbers S11 cited.
- `skills/claim-permission-gate/SKILL.md` — the adjudicating skill (26 KB).
- `skills/cluster-memo-refiner/SKILL.md` — Check 9 (:239–242) duplicates the four class conditions verbatim.
- `skills/country-parity-checker/SKILL.md` — 1 incidental class mention; verify only.
- `workflows/research-workflow/.claude/commands/run-sufficiency.md` — 3 class mentions; verify only.
- `logs/missions/research-workflow-deploy-fitness.md` — thread 5 + the four S11-routed findings.
- Context pack: `output/context-packs/architecture-20260714-b4e7d/pack.md` (sufficient_to_plan: true; sufficient_to_implement: false, 3 missing-context items).

## Findings / Items to Address

**Premise verdicts established at session-start (by direct read, not by reading the audit):**

1. **Premise (c) — CORRECTED, not withdrawn.** S11's routed finding states the hole as *"2 sources in 1 class matches no class; SUPPORTED needs ≥3 sources/≥2 classes; PROXY-SUPPORTED needs 2 across ≥2 classes or 3+ in one class"* (mission file, § Findings surfaced by EXECUTION in S11). **Those thresholds exist in no file** — grepped against the canonical chassis, `claim-permission.template.md`, and *both* live projects' `quality-standards.md`. They came from S11's throwaway test fixture. This is the third consecutive thread whose audit-stated premise did not survive a read.

2. **…but a real defect sits underneath, differently shaped.** The actual chassis table (`quality-standards.md` :188–193) cuts the four classes on **mixed axes** — `SUPPORTED`/`NOT-SUPPORTED` by evidence *quantity*, `PROXY-SUPPORTED` by evidence *type*, `ILLUSTRATIVE-ONLY` by *rhetorical role*. A mixed-axis cut is not a partition, and it demonstrably is not one here:
   - **Gap:** direct, in-scope evidence from exactly **one** source channel that is *not* a named example (e.g. a single regulator statistic) fails `SUPPORTED` (needs ≥2 channels), is not `PROXY-SUPPORTED` (requires *proxy* evidence), is not `ILLUSTRATIVE-ONLY` (requires a named example / pattern instance), and is not `NOT-SUPPORTED` (evidence exists). Falls through all four.
   - **Overlap:** a pattern claim with 2 direct source channels satisfies `SUPPORTED` (direct, ≥2 channels) **and** `ILLUSTRATIVE-ONLY` (<3 same-pattern instances) simultaneously. Adjudication order decides the outcome, and no order is stated.

3. **Premise (b) — GENUINE AMBIGUITY, must be arbitrated, not "fixed".** `claim-permission-gate` Behavior step 2 (:157) says the classes are parsed from the project's `quality-standards.md` and *"These are the only valid class names"*; the `## Output` schema (:99, :107) then hard-codes the four literal names. **But** the chassis's own Canonical-ordering rule (:182) states the chassis *is* the source of truth for class **names**, with only **thresholds** project-fillable — and `When Not to Use` (:43) forbids hard-coding *thresholds*, which the skill does not do. Both readings are textually supported (context pack conflict #1). The session must **decide** which is authoritative and make the losing text conform.

4. **Premise (a) — VERIFIED TRUE.** Nothing in the chassis distinguishes *evidence that supports a negative conclusion* (a first-class finding; should be eligible for `SUPPORTED`) from *failure to find evidence* (establishes nothing; must stay cautious). `NOT-SUPPORTED` (:193) is defined as "No direct or proxy evidence at any source class", and § Research Stop Conditions Cond. 3/4 (all-source-classes-exhausted) routes there too — so an exhaustive search that *found* a well-evidenced negative lands in the same bucket as a search that found nothing. The class *name* actively invites the conflation.

5. **Lockstep — `cluster-memo-refiner` Check 9 (:239–242) restates all four class conditions verbatim** and therefore carries the identical gap and overlap. Fixing the chassis alone leaves the defect live in a second file. In scope. (Noted in passing, routed not fixed: those lines also carry project-specific language — `pan-Nordic`, `in-lens` — inside a *canonical* skill, which is RR-02-shaped contamination.)

6. **Check 9 also declares a THIRD, unreconciled ladder** (:188–190): `illustrative` / `directional` / `pattern candidate`, keyed on same-pattern transaction counts. It maps onto the four permission classes nowhere. Assess whether closing the partition requires reconciling it, or whether it is an orthogonal annotation.

7. **ROUTED, NOT FIXED — the phantom-consumer finding.** The chassis asserts verb-list enforcement (:195) and orphan-citation enforcement (:211) happen in `evidence-to-report-writer`, `chapter-prose-reviewer`, `citation-converter`, `cluster-synthesis-drafter`. The context pack found **zero permission-class vocabulary in all four**. The enforcement the chassis claims is enforced *nowhere* — the identical failure class as threads 1 and 2 (a declared contract nothing honours). This is thread-7-shaped work and scope creep is this mission's named primary failure mode. **Write it to the mission file as a new routed finding; do not chase it.**

## Execution Sequence

1. **Arbitrate premise (b) — decide before editing.** Read the chassis Canonical-ordering rule and the skill's three conflicting sites end-to-end. Decide: are class *names* canonical-global (chassis wins → skill's Output schema is correct, Behavior step 2's wording is misleading and gets fixed) or project-variable (skill wins → the chassis rule and the skill's Output schema both change)? **Verification:** the decision is written with the citation that settles it, and every one of the ~5 sites then says the same thing.
   *Prior:* chassis likely wins — it declares itself source-of-truth for names, and both live projects carry byte-identical class names, so no project has ever exercised name-variance.

2. **Re-cut the four-class table onto a single axis, no new class.** Design the partition so each of the failing cases lands in exactly one class. Working hypothesis: grade on **evidence strength** alone (quantity + independence + directness), and demote `ILLUSTRATIVE-ONLY`'s rhetorical-role condition ("<3 same-pattern instances") from a *class condition* to a *prose-framing constraint* carried alongside the class — which is what it actually is. **Verification (blocking):** run all four adversarial cases through the redrafted table and show each resolves to exactly one class — (i) 1 direct channel, not a named example; (ii) 2 direct channels on a pattern claim; (iii) 1 direct channel, named example; (iv) exhaustive-search evidenced negative. Red before, green after. If this cannot be done without a fifth class → **STOP and surface** (mandate's stated stop condition).

3. **Separate evidenced-negative from absence-of-evidence.** Add explicit wording — in the chassis and in the skill's Bias Countering — that (a) evidence *supporting* a negative conclusion is graded on the same evidence ladder as any positive claim and may reach `SUPPORTED`; (b) *failure to find* evidence establishes nothing and stays cautious. Check whether `NOT-SUPPORTED`'s name and definition can be disambiguated without renaming the class (renaming is a breaking change to two live projects and to every downstream exact-string match). **Verification:** an evidenced-negative claim worked through the rules reaches `SUPPORTED`; a no-evidence-found claim reaches `NOT-SUPPORTED`; the two paths are textually distinct.

4. **Apply the lockstep edit to `cluster-memo-refiner` Check 9** so its class conditions match the re-cut table exactly. **Verification:** diff the two class-condition blocks — they must agree word-for-word on conditions, and Check 9 must not reintroduce a fourth axis.

5. **Verify-only sweep of `country-parity-checker` (1 hit) and `run-sufficiency` (3 hits)** — confirm neither restates the class conditions. Edit only if a restatement is found. **Verification:** grep result recorded either way.

6. **Add a lockstep contract cross-reference** binding the chassis table, `claim-permission-gate`, and `cluster-memo-refiner` Check 9 — the same guard thread 1 shipped, so the three cannot drift independently again. This is the structural fix; without it the duplication just re-diverges.

7. **`/risk-check` (plan-time + pre-commit).** Mandatory: see § Risk.

8. **Tick thread 5 in the mission file** citing the corrected premise and the result; append routed finding #7 (phantom consumers) and #6 (third ladder) to the mission's routed-findings section. Commit.

## Scope Alternatives

- **Min:** items 1, 3, 5 only — arbitrate the authority split and fix the evidenced-negative wording; leave the class table's gap/overlap open. **Rejected:** the gap/overlap is the substantive defect; skipping it makes the thread cosmetic.
- **Recommended (this plan):** items 1–8. Closes both verified defects, applies the lockstep guard, routes what it does not fix.
- **Max:** additionally wire the four phantom consumers so the chassis's asserted verb-list and orphan-citation enforcement actually runs. **Rejected:** that is a fourth defect of a different shape and thread-7-sized; it gets routed to the mission file, not absorbed here. Scope creep is this mission's stated primary failure mode.

## Autonomy Posture
Gated.

**Stop points:**
- Item 2, if the partition cannot be closed without a fifth permission class — the mandate's explicit stop condition. Surface; do not proceed.
- `/risk-check` verdict of RECONSIDER or NO-GO.
- Any point where the fix would require editing the two live projects' own `reference/` copies — out of scope; surface instead.

## Risk

**Run `/risk-check` after this plan is approved (plan-time gate). Run it again before commit (end-time gate).** Structural, on three independent grounds:

1. **The chassis says so.** `quality-standards.md` :182 — *"Future edits that cross this boundary in either direction require `/risk-check` re-fire."* Re-cutting the Conditions column is exactly such an edit. This is not a judgment call; it is a written instruction in the file being edited.
2. **Live blast radius.** Two deployed projects (`research-pe-regime-shift-advisory-gap`, `positioning-research`) symlink these canonical skills and have **completed Stage 3 for section 1.1** — permission tables already written to disk under the *current* class semantics. Any re-cut takes live effect on merge to `main`, and already-adjudicated claims were graded under the old rules. The risk-check must establish whether existing tables need back-validation (the same obligation the § Source-Diversity Matrix cross-class collapse clause already imposes).
3. **Exact-string coupling.** The four class names are exact-string-matched by downstream consumers. Any change to *names* (as opposed to *conditions*) is a breaking change — which is why item 3 explicitly seeks to disambiguate `NOT-SUPPORTED` without renaming it.

**Context-pack missing-context item, unresolved and load-bearing:** *no rule states whether editing the Conditions column crosses the canonical-immutable boundary.* The chassis fixes names/verbs/gate-semantics as canonical and thresholds as project-fillable — the **Conditions column is neither**, and its status is undefined. Resolve this in item 1 and record the decision; it is the precise question `/risk-check` must arbitrate.

**Environment-fit check:** N/A — the work product is documentation and skill instructions, not executable or launcher tooling.
