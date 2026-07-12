# Risk Check — 2026-07-06

## Change

Reconcile the mobile-hierarchy rule across three files in axcion-design-studio, part of Phase B of the workflow-viability fix plan (audit lean-repo-2026-07-05-playbook-fit.md §8). (1) work/homepage/page-brief.md — add one clause to the existing "Mobile preserves the same hierarchy as desktop" rule requiring every section concept to state a deliberate mobile answer (faithful stack or reflow), never a silent stack; this is the identical reconciliation text already provisionally on file in two other places. (2) 20_criteria/section-design-principles.md (PROTECTED, CP-1) — move one bullet in its "Deferred" section from "Conflicts with existing doctrine" to a resolved note, cross-referencing the page-brief.md update; no other content in this DRAFT file changes, and this session is NOT ratifying or folding the file's two principles (that decision is being deferred — the file's own self-declared ratify-to-wire trigger, homepage 4/4 sections approved + For Investors through one Studio chain run, has not fired: only 2/4 homepage sections are approved and For Investors hasn't entered the chain). (3) web-refinement-playbook.md (not protected, subordinate reference) — mark its governance-header mobile note as resolved rather than provisional. Net effect: three files land on one mobile rule; the DRAFT ratification question is explicitly left open, not silently dropped.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/work/homepage/page-brief.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/20_criteria/section-design-principles.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/web-refinement-playbook.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The three-file text edit is well-scoped and correctly declines to ratify the DRAFT principles, but it (a) touches a CP-1-protected file whose own project artifacts (next-up.md, the active session plan) require explicit operator sign-off before the edit — not just a risk-check GO — and (b) would leave a literal internal cross-reference inside `section-design-principles.md` pointing at a sub-heading label the edit proposes to retire.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `work/homepage/visual-design-spec.md:388` | Quotes page-brief.md's current mobile-hierarchy phrase verbatim to justify a design decision | No — quoted substring ("mobile preserves the same hierarchy as desktop") survives; new clause is additive |
| `work/homepage/figma-build-brief.md:95` | Cites page-brief.md's mobile rule; documents AudienceSplit mobile behaviour ("buy-side lane first; hierarchy otherwise preserved") | No — the documented behaviour already reads as a deliberate, named choice, not a silent stack, so it appears compliant with the new clause without edits |
| `20_criteria/section-design-principles.md:62` | Internal cross-reference: Principle 2's "How to apply" note points by name to "the Deferred 'Conflicts with existing doctrine' item below" | **Yes / at risk** — see Dimension 5 |
| `projects/axcion-design-studio/CLAUDE.md:45` | Pointer to section-design-principles.md, notes its DRAFT/provisional status | No — DRAFT status is untouched by this edit |
| `logs/next-up.md:18` | Backlog item describing this exact Phase B task: "ratify it or fold its two principles... Also settle the mobile wording... as one reconciliation line" | Should-update (bookkeeping) — the mobile-wording sub-task closes; the ratify-or-fold decision stays open and should stay listed |
| `logs/session-plan-2026-07-06-S1.md` | Active session plan; states Phase B executes "On `/risk-check` GO + **operator CP-1 sign-off**"; Autonomy Posture: "B ... pause[s] at structural gate" | No file edit needed, but this is a hard external precondition this risk-check does not itself satisfy |
| `ai-resources/logs/improvement-log.md:25-26` | Parked-idea entry naming the same reconciliation text as already "on file" and naming `section-design-principles.md` as the future extension target if principle #12 is ever adopted | No |
| `logs/decisions.md:191-209` | Historical OP-11 waiver entry documenting the DRAFT doc's creation | No |
| `ai-resources/audits/risk-checks/2026-07-05-section-design-principles-draft-doctrine-doc.md` | Historical risk-check on the DRAFT doc's creation | No |
| `ai-resources/audits/working/2026-07-05-idea-ai-web-design-operating-principles.md` | Historical analysis behind the DRAFT doc | No |
| `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-05-risk-check-second-opinion-section-design-principles-doctrine.md` | Historical second-opinion consult | No |
| `audits/lean-repo-2026-07-05-playbook-fit.md` (§3.3, §8 Phase B) | Source audit that raised this exact reconciliation as a fix item | No — audits are point-in-time, not living docs |
| `20_criteria/conversion-clarity-review.md` | Sibling DRAFT file in the same protected directory, carries the same "DRAFT — pending operator ratification" marker, unrelated content (CRO clarity dimensions, not mobile) | No |
| `work/homepage/audit-notes.md`, `work/for-investors/audit-notes.md` | Generic references to `web-refinement-playbook.md`'s phase structure | No |

**Total: 14 consumers found, 1 must-change (in-file cross-reference), 1 hard external precondition (operator CP-1 sign-off) not itself a file edit.**

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low
- None of the three target files are always-loaded context. `section-design-principles.md` itself states "nothing reads this file automatically" (line 3); `CLAUDE.md` (project) references it only as a judgment-applied pointer, not an auto-load (`CLAUDE.md:45`, "provisional, not wired into the chain, applied by operator/creator judgment").
- `page-brief.md` and `web-refinement-playbook.md` are read-on-demand project reference docs, not CLAUDE.md content.
- No new field, no new file, no growth in a hot-loaded path.

### Dimension 2: Permissions Surface
**Risk:** Low
- None of the three files are `.claude/settings.json`, hooks, or agent/skill permission definitions.
- `source-of-truth-hierarchy.md` §3 confirms `20_criteria/` is content-protected (CP-1), not a permissions-surface file — its protection is an editorial gate, not a settings/hooks change.

### Dimension 3: Blast Radius
**Risk:** Low
- 14 consumers found (Consumer Inventory above); only 1 (`section-design-principles.md:62`, an in-file cross-reference) is a must-change, and it is inside the very file being edited — not an external caller.
- The two live downstream quoters of page-brief.md's mobile rule (`visual-design-spec.md:388`, `figma-build-brief.md:95`) both quote a substring the change preserves verbatim; neither breaks.
- No cross-project consumers found — the mobile-hierarchy rule is scoped entirely to `axcion-design-studio`.

### Dimension 4: Reversibility
**Risk:** Low
- All three edits are plain markdown edits in a git-tracked repo — clean `git revert`/`git diff` reversibility.
- None of the three files are append-only logs (`decisions.md`, `session-notes.md`) where a mutation would be harder to reverse cleanly; `page-brief.md`, `section-design-principles.md`, and `web-refinement-playbook.md` are all living reference documents edited in place by design.

### Dimension 5: Hidden Coupling
**Risk:** Medium
- **Protected-file discipline confirmed, no narrow-edit carve-out.** `source-of-truth-hierarchy.md` §2-3 lists `20_criteria/` as protected with no exception for small or "already-resolved" edits: "Editing it changes what the Red Team checks on every pass" / "Write: Protected (CP-1 only)." The file's own header independently states: "**Status: DRAFT — pending operator ratification**" and frames any use "before ratification" as advisory-only — but the protection rule governs *edits*, not just ratification, so moving even one bullet is a CP-1-tier edit regardless of how narrow its content is.
- **This exact gate is already named in this project's own artifacts, not invented by this risk-check.** `logs/next-up.md:18`: "Touches PROTECTED doctrine → needs CP-1 operator approval." `logs/session-plan-2026-07-06-S1.md`, Phase B: "On `/risk-check` GO + **operator CP-1 sign-off**: ratify... and write the reconciled mobile line" and "Autonomy Posture: Gated — ... B and C pause at their structural gates." This risk-check's GO/CAUTION/RECONSIDER verdict is one of the two named preconditions, not a substitute for the other (explicit operator sign-off).
- **A live internal cross-reference names the exact label being retired.** `section-design-principles.md:62` (Principle 2, "How to apply"): "'Its likely mobile behaviour is understood' defers to `page-brief.md`'s mobile rule and does not require a mobile *transformation* — understanding the behaviour is the bar (**see the Deferred "Conflicts with existing doctrine" item below**)." The change proposes moving the very bullet this line names — "**Conflicts with existing doctrine:**" (`section-design-principles.md:71`) — to "a resolved note." The change description caps this file's edit at "no other content in this DRAFT file changes," which as stated would leave line 62's pointer naming a label that no longer describes the item it points to. This is a genuine, concrete coupling the change description's own scope boundary does not account for.
- Positive finding: the change does **not** touch the file's DRAFT status marker (line 1-3) or either of the two live Principles' substantive text, and does not touch the ratify-to-wire trigger (line 5) — the coupling risk is confined to the one cross-reference above, not a broader doctrine leak.

### Dimension 6: Principle Alignment
**Risk:** Medium
- **OP-11 ("Loud revision, never silent drift") — substance clears.** The change explicitly declines to ratify or fold the two live Principles and states this openly rather than letting the edit imply otherwise ("this session is NOT ratifying or folding the file's two principles... that decision is being deferred"). This matches workspace `CLAUDE.md` § Design Judgment Principles ("Conflicts must be surfaced, not silently resolved") and the OP-11 standard as defined in `projects/strategic-os/ai-strategy/principles-base.md:33`: "a guardrail *can* be revised — but only as an explicit, recorded evolution, never silent drift." The item being resolved (the wording conflict for parked, not-yet-imported principle #12, "mobile transformation not stack" — distinct from the two live Principles, Preservation pass and Stop conditions) is not the item the ratify-to-wire trigger gates, so this is not premature closure of the gated ratification question.
- **Autonomy-rule alignment — process incomplete as scoped.** Workspace `CLAUDE.md` § Autonomy Rules item 9: "Structural change classes gated by `/risk-check` — follow `ai-resources/docs/audit-discipline.md` § Risk-check change classes" is a listed pause condition, and this project's own session plan couples that gate to **operator CP-1 sign-off**, not risk-check clearance alone. The change description handed to this review does not state that sign-off has been obtained; per the source-of-truth-hierarchy this is a precondition to execution, not an optional nicety.
- **Loud-revision discharge is not yet on record.** This project's established pattern for CP-1/doctrine-adjacent decisions is a dated `logs/decisions.md` entry (e.g., the 2026-07-05 OP-11 waiver entry, the web-refinement-playbook decision entry) naming what changed, what didn't, and why. No such entry is described as part of this change — without it, the "loud" half of OP-11 is only partially discharged (surfaced in this risk-check's inputs, but not yet recorded in the project's own decision log where the pattern lives).

## Mitigations

- **Obtain and record explicit operator CP-1 sign-off before landing the `section-design-principles.md` edit.** This risk-check's verdict is one of the two preconditions this project's own session plan names for Phase B; it does not substitute for the other.
- **Resolve the line-62 cross-reference before or as part of this edit.** Either (a) keep the retired bullet's location and enough of its literal label text that "the Deferred 'Conflicts with existing doctrine' item below" still resolves sensibly for a reader, or (b) treat the four-word cross-reference at line 62 as in-scope for this edit despite the "no other content in this DRAFT file changes" framing — it is a direct dependency of the bullet being changed, not unrelated content.
- **Log the resolution in `logs/decisions.md`** in the same pattern already used for this file's OP-11 waiver and the web-refinement-playbook decision: what was resolved (principle-#12 mobile wording), what was explicitly not decided (ratify/fold of the two live Principles), and a pointer to this risk-check report.
- **Update `logs/next-up.md:18`** after landing, to reflect that the mobile-wording sub-task is closed while the ratify-or-fold decision remains open — prevents the backlog line from re-litigating an already-closed sub-item at the next `/friday-checkup` or session-plan pass.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes). No training-data fallback was used on fetch/read failures.
