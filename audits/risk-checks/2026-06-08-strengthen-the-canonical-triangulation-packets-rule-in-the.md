# Risk Check — 2026-06-08

## Change

Strengthen the (canonical) "Triangulation-packets rule" in the research workflow's Source-Diversity Matrix. CURRENT rule: "N independent reports from the same source class count as ONE evidentiary role, not N." PROPOSED strengthening: extend the same collapse-to-one-role test to reports that share one UNDERLYING source/dataset/primary-release even when their source CLASSES differ (e.g., a trade-body summary and a specialist-press article both restating the same Bain/Preqin figure = ONE role, not two), tying it operationally to the per-claim `independence basis` field (independently-observed / same-underlying-dataset / same-press-release / unclear) added to research-extract-creator in commit f31bceb. This is fix-spec #23's deferred chassis half, PM-ruled in session S1 to belong in quality-standards.md (NOT claim-permission.md, which is unconsumed). SCOPE QUESTION the risk-check must weigh: the rule appears in FOUR files — project-local reference/quality-standards.md:137 + reference/claim-permission.template.md:35 (marked canonical), AND the canonical workflow copies ai-resources/workflows/research-workflow/reference/quality-standards.md + claim-permission.template.md. Option A: edit only the project-local quality-standards.md (mandate-literal, but leaves the canonical rule divergent across the other three copies). Option B: synchronized 4-file edit (the actual workflow-v2 template promotion; larger blast radius — affects all future projects instantiating the template). A back-validation pass over the live 1.1 extracts carrying interim independence-basis values follows whichever option lands. Consumers of the rule: claim-permission-gate SKILL (reads the matrix; downgrades claims sharing one underlying source below the >=2-channel SUPPORTED bar to PROXY-SUPPORTED) and cluster-memo-refiner Check 9.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/claim-permission.template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/claim-permission.template.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A behavior-changing edit to a `(canonical)`-marked gate rule with two live enforcers and ~12 in-flight extracts already carrying the field it activates — low usage/permission cost and clean technical reversibility, but Medium blast radius and a mandatory paired back-validation pass, with Option A (project-local-only) the recommended landing path to keep the canonical-promotion blast radius out of this change.

## Consumer Inventory

Search terms: `triangulation-packet`, `Source-Diversity Matrix`, `independence basis` / `same-underlying-dataset` / `same-press-release`, `claim-permission-gate`, `cluster-memo-refiner`, `research-extract-creator`. Grep run across `ai-resources/` and the workspace root. Active-tree consumers only (archive/, audits/, logs/, session-notes excluded — they document, do not enforce). The rule is a gate semantic, so "consumer" = anything that reads/applies the matrix or produces the field the strengthened rule consumes.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/skills/claim-permission-gate/SKILL.md` (lines 17-18, 49-50, 68-70, 145-148, 191) | parses (reads `## Source-Diversity Matrix` from `reference/quality-standards.md`, applies the diversity rule verbatim as "the only diversity check applied") | no (reads the rule generically; stronger rule auto-applies — but back-validation needed on extracts it already classed) |
| `ai-resources/skills/cluster-memo-refiner/SKILL.md` (line 228, Check 9) | parses (reads Source-Diversity Matrix + triangulation-packets rule from `reference/quality-standards.md`; line 228 hard-codes an example: "three independent KPMG quarterly reports count as ONE evidentiary role, not three") | yes-soft (line 228 example text restates the OLD same-class-only formulation; should be updated to reflect same-underlying-source, else the SKILL's inline example contradicts the strengthened rule) |
| `ai-resources/skills/research-extract-creator/SKILL.md` (line 117) | parses (forward-compatibility note explicitly names this edit as the activating trigger for the `independence basis` field; says interim values are unvalidated and "the activating edit MUST include a back-validation / migration pass") | yes-soft (the forward-compat note's "pending" language should be flipped to "active" once the rule lands; the note itself mandates the back-validation pass) |
| `ai-resources/skills/research-extract-creator/references/extract-template.md` | documents (carries the `independence basis` field definition the rule consumes) | no |
| `projects/.../reference/quality-standards.md:137` | co-edits (the edit target itself — project-local chassis the live enforcers actually read) | yes (the edit) |
| `projects/.../reference/claim-permission.template.md:35` | co-edits (carries the `(canonical)` rule text; Option B target) | Option A: no / Option B: yes |
| `ai-resources/workflows/research-workflow/reference/quality-standards.md:137` | co-edits (canonical template copy; Option B target) | Option A: no / Option B: yes |
| `ai-resources/workflows/research-workflow/reference/claim-permission.template.md:35` | co-edits (canonical template copy; Option B target) | Option A: no / Option B: yes |
| `projects/.../execution/research-extracts/1.1/*` (~12 extracts carrying `independence basis` values, grep-confirmed e.g. 1.1-Q10, 1.1-Q13) | parses (live data the strengthened rule will now bite on; were authored under the unvalidated interim regime) | yes-data (back-validation / migration pass required before the rule enforces against them) |
| `projects/.../analysis/cluster-memos/1.1/1.1-cluster-02-memo-refined.md` | parses (already-produced memo carrying independence-basis-derived classifications) | yes-data (re-check if back-validation changes upstream extract tags) |

Total: 10 distinct active consumers, 4 strictly must-change for Option A (the edit target + ~12 extracts + the dependent memo data + the two SKILL inline-example/forward-compat updates that should land in lockstep to avoid contradiction). Option B adds 3 more must-change files (the canonical template copies). The two LIVE enforcers (claim-permission-gate, cluster-memo-refiner) read the rule generically and do not require code changes — but their inline example text (cluster-memo-refiner:228) and the forward-compat note (research-extract-creator:117) restate the OLD rule and will contradict the new one if left stale.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The rule lives in `reference/quality-standards.md`, a project-deliverable reference doc loaded only by Stage-3 commands that explicitly read it (`/run-cluster`, `/run-sufficiency` via `claim-permission-gate` and `cluster-memo-refiner`) — not an always-loaded CLAUDE.md. No `@import`, no SessionStart/Stop/PreToolUse hook, no auto-load skill trigger. Evidence: `claim-permission-gate/SKILL.md:145-148` loads `quality-standards.md` on-demand at gate time only.
- The strengthening is a few sentences extending an existing rule clause at `:137` — not a new always-loaded block. No new file, no new subagent brief. Pay-as-used.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` change, no `allow`/`ask`/`deny` entry, no new tool family, no Bash/Write/external-API pattern. The change is content-only inside markdown reference docs. No grep hit for any permission token in the change description or referenced files.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Step 1.5 inventory: 10 distinct active consumers; 4 must-change for Option A, 7 for Option B. Drivers below.
- **Two live enforcers read the rule generically** (`claim-permission-gate/SKILL.md:50` — "the diversity rule is the only diversity check applied"; `cluster-memo-refiner` Check 9 line 228). They do not need code edits, which caps the radius — but the rule is a *behavior-changing* gate edit: claims that triangulated across different source classes restating one underlying Bain/Preqin figure now collapse to ONE role and can drop below the ≥2-channel SUPPORTED bar to PROXY-SUPPORTED. This re-classifies live claims. Evidence: claim-permission-gate `SUPPORTED` condition requires "≥2 source channels" (`quality-standards.md:124`).
- **Stale inline examples are a blast-radius finding the change description under-anticipated.** `cluster-memo-refiner/SKILL.md:228` and `research-extract-creator/SKILL.md:117` both restate the OLD same-class-only formulation. If only `quality-standards.md` is edited, these two SKILL files will contradict the strengthened rule (one says "three KPMG reports = one role" framed as same-class-only; the other calls consumption "pending"). They must land in lockstep — that is 2 extra must-change files the CHANGE_DESCRIPTION did not list.
- **~12 in-flight extracts** (grep-confirmed 1.1-Q10, 1.1-Q13, plus cluster-02 memo) carry interim `independence basis` values authored under the unvalidated regime. The rule now enforces against them. This is the back-validation surface, not optional — `research-extract-creator/SKILL.md:117` itself mandates it.
- **Option B contract change is backwards-compatible but wide:** editing the two canonical template copies promotes the rule to all future projects instantiating `research-workflow`. No current consumer breaks (the rule is strictly stronger, additive), but the radius extends to every future instantiation. Backwards-compatible contract change across >2 files → Medium, not High.
- Not High: no live caller *breaks*; the contract change is strictly additive/stronger, not incompatible; the enforcers read generically.

### Dimension 4: Reversibility
**Risk:** Medium

- **Option A (project-local only):** the `quality-standards.md:137` edit plus the two lockstep SKILL-text updates are clean `git revert` within one working tree. BUT the back-validation pass mutates ~12 extract files and at least one cluster memo — a `git revert` of the rule edit does NOT auto-restore those mutated extracts to their pre-validation state; they carry forward re-classified independence tags. That is the one extra cleanup dimension that makes this Medium, not Low. Mitigable by committing the rule edit and the back-validation pass as *separate* commits so the rule can be reverted independently of the data migration.
- **Option B (4-file canonical promotion):** revert still works via git (all four files are tracked markdown), but any future project instantiated from the template *between* landing and revert would carry the promoted rule — operator-memory / instantiation drift beyond pure git. Slightly higher than Option A but still git-recoverable; no external writes, no push-beyond-repo in the change itself.
- No external state (Notion/API/push) mutated by the change itself. Push is gated separately at `/wrap-session`.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Verified the load-bearing topology claim:** `claim-permission-gate/SKILL.md:17-18, 49-50, 145-148, 191` reads the Source-Diversity Matrix from `reference/quality-standards.md` (project-level), explicitly NOT from `claim-permission.md`. Grep confirms `claim-permission.md` does not exist in the project and is unconsumed for the diversity check. The PM ruling (decisions.md:261-263) holds. This means the edit MUST land in `quality-standards.md` to have any effect — editing only the `claim-permission.template.md` copy would enforce nothing. Correctly routed.
- **One real coupling the change names but must honor:** the rule operationally depends on the `independence basis` field (values independently-observed / same-underlying-dataset / same-press-release / unclear) added in commit f31bceb to `research-extract-creator`. The strengthened rule's collapse logic reads those exact enum values. If the field's value vocabulary drifts, the rule silently mis-fires. The contract is documented at `research-extract-creator/SKILL.md:117` (the forward-compat note) — so it is documented at the change site, which holds this at Medium rather than High.
- **Stale-example coupling (also a blast-radius item):** `cluster-memo-refiner:228` hard-codes a worked example of the OLD rule. Leaving it stale creates a silent contradiction between the enforced rule and the SKILL's own illustration — a reader/subagent could apply the weaker example. This is an undocumented-divergence risk unless the example is updated in lockstep.
- **Canonical-ordering boundary contract:** `quality-standards.md:116` and `claim-permission.template.md:5` declare that edits crossing the chassis/project-fillable boundary require a `/risk-check` re-fire. This change IS that re-fire, so the contract is honored — but note the rule sits at `:137` inside a "Project-fillable" subsection whose preamble points the per-claim table to `claim-permission.md`. The triangulation-packets *rule shape* is canonical chassis; the per-claim *table* is project-fillable. The edit strengthens the canonical rule clause, not the project table — correct placement, but the mixed canonical/fillable framing at `:135-137` is a latent ambiguity worth a one-line clarification.
- Not High: dependencies are named at the change site; no silent auto-firing in unexpected contexts (the gate runs only at Stage-3 commands); no functional overlap with a second mechanism.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (present).
- **OP-9 / DR-7 / AP-7 (speculative abstraction) — does NOT fire.** The strengthened rule has a *confirmed, already-landed consumer*: the `independence basis` field shipped in commit f31bceb and ~12 live extracts already carry it (grep-confirmed). This change *completes a half-built feature* whose second half was deliberately deferred (decisions.md:261), not generalization for an absent consumer. DR-7's "second confirmed consumer" test is satisfied by the field's existing producers and the two live enforcers. This is the opposite of "hooks for later."
- **OP-12 (closure before detection) — actively served.** The change does not add a new detection scan; it *closes* a finding the system already detects (claims that over-triangulate on one underlying source) by wiring the collapse into the existing gate. New behavior ships behind a working closure channel (claim-permission-gate downgrade path). Counts *for* the change.
- **OP-5 (advisory vs enforcement) — no silent upgrade.** The gate is already blocking/enforcing (`quality-standards.md:147-152`, "blocking, not advisory"). The change makes an existing enforcement rule stricter; it does not move an advisory mechanism into enforcement. No new enforcement authority granted.
- **OP-11 / OP-3 (loud revision, not drift) — satisfied.** The strengthening is loud and recorded: PM-ruled (decisions.md:261-263), logged in improvement-log.md:324, and gated through this very `/risk-check`. Not silent drift.
- **DR-1 / DR-3 (placement) — correct.** The rule lives where its live consumers read it (`reference/quality-standards.md`), routed away from the unconsumed `claim-permission.md` per the PM topology correction. Option B's canonical-template edit is the legitimate DR-1 canonical tier; Option A defers that consciously.
- No principle violated; the change serves OP-12 and respects OP-9/DR-7. Low.

## Mitigations

- **Blast radius (Medium):** Land the rule edit and the two stale-example/forward-compat updates in lockstep — `quality-standards.md:137`, `cluster-memo-refiner/SKILL.md:228` (update the KPMG example to a cross-class same-underlying-source illustration), and `research-extract-creator/SKILL.md:117` (flip "pending"→"active"). Do not edit `quality-standards.md` alone, or the two SKILL files will contradict the enforced rule.
- **Reversibility (Medium):** Commit the rule/SKILL edits and the back-validation extract-migration pass as two SEPARATE commits, so the rule can be `git revert`-ed independently of the ~12-extract data migration. The back-validation pass is mandatory (research-extract-creator:117), not optional — run it before the next Stage-3 gate executes against the 1.1 extracts.
- **Hidden coupling (Medium):** In the same edit, add a one-line note at `quality-standards.md:135-137` clarifying that the triangulation-packets *rule shape* is canonical chassis (consumed from this file) while the per-claim table remains project-fillable — closing the latent canonical/fillable ambiguity that could mislead a future editor toward `claim-permission.md`.

## Recommended path on the SCOPE QUESTION

Not a RECONSIDER, so this is advisory guidance rather than a required redesign. **Favor Option A (project-local `quality-standards.md` only), with the two lockstep SKILL-text fixes, this session; defer Option B to a dedicated template-promotion session.** Rationale: (1) Option A is mandate-literal and is the only edit the two LIVE enforcers actually read — it delivers the full behavioral effect for the active 1.1 project with the smaller, fully-git-reversible blast radius. (2) Option B's value (all future instantiations get the stronger rule) is real but its blast radius reaches every future project from the template — that is a canonical-promotion decision deserving its own `/risk-check` framing and a template-fitness pass, not a tail-end rider on a project-local fix. (3) Landing Option A leaves the canonical copies divergent — acknowledge this *loudly* (OP-11): log the divergence in `improvement-log.md` as an explicit deferred-promotion item with a back-pointer, so it is a recorded decision, not silent drift. If the operator wants single-session closure of the divergence, Option B is acceptable but must add the three canonical-copy edits to the lockstep set and re-run the back-validation reasoning for the template's stated consumers.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the four referenced files and the two consumer SKILLs, grep counts across `ai-resources/` and the workspace root, verbatim quotes from CHANGE_DESCRIPTION and the principles-base, and the PM-ruling decisions.md citations). The `claim-permission-gate`-reads-from-`quality-standards.md` topology claim was independently grep-verified before scoring Dimension 5. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-08-risk-check-second-opinion-triangulation-packets-rule.md

**1. Concur with PROCEED-WITH-CAUTION? — Yes.** The verdict is correctly placed. This is a canonical command/agent edit class (matrix read by two live enforcers across the workflow), so Medium blast radius + mandatory back-validation justify CAUTION over GO (risk-topology.md § 3). Principle-alignment Low holds on our base too: the change completes a half-built feature with confirmed live consumers, so AP-7 / DR-7 do not fire, and it serves OP-12 (closure through an existing channel). Verdict is binding — not to be downgraded (principles.md § DR-8).

**2. Option A vs. B — Option A, conditionally.** The four-copy divergence is NOT the worse debt — *provided* it is logged loudly. The two live enforcers read only the project-local `quality-standards.md`, so Option A delivers the full behavioral effect for 1.1. Option B promotes the rule to every future research-workflow instantiation — a canonical-tier contract change (principles.md § DR-1) that deserves its own risk envelope, not a tail-end rider. The deciding principle: an explicit `improvement-log.md` deferred-promotion entry turns the divergence into a recorded decision, not silent drift (OP-11 / OP-3). **Take the log away and Option A becomes an OP-11 violation — so it is Option A + mandatory log, or it is not Option A.**

**3. Risks the dimension review missed:**
- **Re-classification provenance is unscored.** The pass prescribes separate commits for revertability but says nothing about recording *why* each extract's `independence basis` was downgraded. That judgment must be auditable (QS-4) — leave a per-extract rationale, not a silently changed field.
- **No independent QC gate on the back-validation pass.** Re-tagging ~12 live extracts is partly a judgment task (same underlying Bain release vs. genuine independent observation?), and it feeds cluster memos and the thesis. It needs a `/qc-pass`, not a find-and-replace (QS-1 / QS-9 — edits do not self-certify). The dimension review treats it as mechanical; it is not.
- **Framing note:** the risk-check grounds Dimension 6 in a different principles corpus than the canonical vault; IDs align in meaning so the conclusion is sound, but its `DR-3` citation maps more precisely to DR-1 / DR-6 in the canonical base. Cosmetic — flagged so a later ID reconciliation does not read it as a contradiction.

**Position:** Option A this session + two lockstep SKILL fixes, committed separately from back-validation, with a mandatory deferred-promotion log entry. Add two requirements the review omitted: per-extract re-classification rationale (QS-4) and an independent `/qc-pass` on the re-classified set before it feeds the next Stage-3 gate (QS-1 / QS-9).
