# Risk Check — 2026-06-04

## Change

Consolidate the duplicated "Session Boundaries" rule — currently byte-identical across 16 CLAUDE.md files — into a new single-source doc `ai-resources/docs/session-boundaries.md`, and replace each of the 16 in-file sections with a thin one-line behavioural cue plus a pointer to that doc (Option A: "## Session Boundaries\nPrefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`."). Affected files: 14 projects/*/CLAUDE.md (## Session Boundaries heading), ai-resources/CLAUDE.md (## Session Boundaries heading), and workspace-root CLAUDE.md (bullet under Working Principles, with an extra context-pressure sentence that folds into the source doc). The /risk-check Dimension-3/5 review already identified a 17th file — ai-resources/templates/project-claude-md/session-boundaries.md (the /new-project + /permission-sweep template fragment, generative source of truth) — which MUST be added to the change set or the consolidation self-reverts on next /new-project; treat that as part of the approved change set now. Cross-cutting edit to always-loaded content. Central technical risk: the full rule stops auto-loading every turn; only a thin cue + pointer remain (pointer target does NOT auto-load). Operator override of F6 is explicit and will be recorded.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-boundaries.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/session-boundaries.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — exists (representative of the 14 project files; all 14 carry a byte-identical ## Session Boundaries section)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/slot-1-decisions.md — exists (the F6 decision record)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A behaviourally-sound consolidation whose elevated risk sits in one already-surfaced dependency (the `/new-project` template fragment, now folded into the change set) plus a documented, loudly-acknowledged override of recorded decision F6 — the override is principle-consistent and will be recorded back, so Principle Alignment scores Medium, not High.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change *reduces* always-loaded token cost. The current section is a 2-sentence paragraph (~55 words) loaded every turn in each affected CLAUDE.md; Option A replaces it with a one-line cue + pointer (~20 words). Evidence: `templates/project-claude-md/session-boundaries.md:1-3` carries the full paragraph verbatim (the same wording the 14 project files inherit); Option A wording in CHANGE_DESCRIPTION is one sentence + pointer.
- The new doc `ai-resources/docs/session-boundaries.md` is NOT an `@import` and is not auto-loaded — CHANGE_DESCRIPTION states "the pointer target does NOT auto-load." No per-turn or per-tool-call cost added.
- No hook, subagent brief, or skill description is touched. Grep for `session-boundaries.md` references confirms no existing auto-load chain is introduced.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` entry is added, removed, or widened. The change touches only Markdown body content in CLAUDE.md files plus one template fragment, and creates one new doc — no `settings.json` / `settings.local.json` edit is described.
- No new tool family, Bash pattern, Write path, or external/cross-repo capability is granted. Writing the new doc lands inside `ai-resources/docs/` (dir confirmed present), an already-writable location.

### Dimension 3: Blast Radius
**Risk:** Medium

- **17 always-loaded / generative files edited across two git repos.** 14 project files (`## Session Boundaries` heading, byte-identical paragraph), `ai-resources/CLAUDE.md` (heading present), workspace-root `CLAUDE.md` (bullet under Working Principles), plus the 17th file — `ai-resources/templates/project-claude-md/session-boundaries.md`. Repo boundary: workspace root and `ai-resources` are two distinct git toplevels (`ai-resources/.git` is a real dir, not a submodule gitlink).
- **The one caller that REQUIRES modification is now inside the change set.** `ai-resources/templates/project-claude-md/session-boundaries.md` is the documented single source of truth that `/new-project` and `/permission-sweep` emit into project CLAUDE.md files. Confirmed it currently holds the OLD full paragraph (`templates/project-claude-md/session-boundaries.md:1-3`, verbatim match to the project-file paragraph). The change description now explicitly folds this 17th file into the approved set ("MUST be added to the change set or the consolidation self-reverts on next /new-project"). With it included, no caller is left broken → Medium, not High.
- **`/new-project` idempotent-append guard is safe.** The append loop keys on the literal heading `## Session Boundaries`. Converted files retain that heading, so re-running `/new-project` on an existing project sees the heading and skips — no double-append.
- **Find-replace must anchor on the paragraph, not heading-to-EOF.** The 14 project files have differing trailing sections (some have Model Selection or Input File Handling after the Session-Boundaries block), so a heading-to-EOF block replace would corrupt adjacent sections. The rule paragraph itself is uniform.

### Dimension 4: Reversibility
**Risk:** Medium

- The in-file edits are clean `git revert` material — Markdown body edits in tracked files. But they span **two repos**: workspace-root + 14 project files revert in the parent repo; `ai-resources/CLAUDE.md` + the new doc + the template fragment revert in the ai-resources repo. A full rollback needs a revert in each repo (one extra step), not a single revert.
- The new file `ai-resources/docs/session-boundaries.md` is a sibling addition; `git revert` of its add-commit removes it cleanly if committed atomically; if bundled with unrelated edits, a manual `git rm` is the cleanup step.
- The recorded-override write back into `slot-1-decisions.md` (per OP-11) is an append/edit to a decision record; a `git revert` of the doc edits would also need to revert that record entry to avoid a stale "override applied" note pointing at reverted content. No external push, no automation fires between landing and revert. Net: revert works but needs coordinated action across two repos plus the decision-record entry → Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **The previously-hidden template-fragment dependency is now surfaced and folded in.** What made this High in the prior pass — the undocumented `/new-project` + `/permission-sweep` generative source — is named in CHANGE_DESCRIPTION and added to the change set. Once converted, the fleet stays consistent rather than split. The coupling is no longer silent → drops to Medium.
- **Cross-repo pointer-path resolution remains an implicit dependency.** The pointer `ai-resources/docs/session-boundaries.md` is workspace-root-relative. For a reader in a *project* session (cwd `projects/{name}/`), the path resolves only via the established "resolve from workspace root / `--add-dir`" convention the repo already uses throughout its CLAUDE.md files. It is survivable (this is the same convention used by every other `ai-resources/docs/...` pointer in these files) but it is an implicit dependency on the parent workspace being on the path. If a project session is opened without the parent workspace, the pointer dangles.
- One residual implicit dependency (cross-repo workspace-root-relative pointer), documented convention but not stated at the change site → Medium.

### Dimension 6: Principle Alignment
**Risk:** Medium

- **This change OVERRIDES a recorded prior decision (F6), and the override is loud + will be recorded — so it scores Medium with a note, not High.** F6 is recorded in `projects/strategic-os/ai-strategy/slot-1-decisions.md:39` with verdict **"CONVERT — but NOT a blanket find-replace"** and the caution "convert only where content is reference-not-behavioural; keep verbatim where it must load every turn." The proposed change is exactly the blanket conversion F6 cautioned against. Per the override rubric, a principle/decision override that is loudly acknowledged by the operator AND recorded back into the decision register (here, the executing session will write the override into `slot-1-decisions.md` per OP-11) is a *deliberate, surfaced revision of intent* — not silent drift — and is scored Medium/Low, not High.

- **OP-11 is the governing principle and it SANCTIONS the override mechanism.** `principles.md:165` (OP-11) states: "When practice diverges from written principles … the divergence must be surfaced explicitly. Either the practice is corrected to match the principle, or the principle is revised to reflect a deliberate evolution of intent. Silent drift in either direction violates OP-3." The override is a deliberate revision of F6's earlier judgment, surfaced loudly and recorded — this is precisely the OP-11-compliant path, not a violation of it. The risk is Medium (a decision is being revised) rather than Low only because the revision must actually be written back; if the executing session skips the `slot-1-decisions.md` record, the change silently contradicts a recorded verdict — the OP-3 anti-pattern. That write-back is the load-bearing condition.

- **The change SERVES the consolidation axis of OP-12.** `principles.md:175` (OP-12, "Closure before detection") includes the clause "prefer closure and consolidation over new building." The same E10 row in `slot-1-decisions.md:27` cites OP-12 to justify a fold of duplicated content into a canonical doc. Consolidating 16 verbatim copies into one source doc is the same move — duplication-collapse is principle-aligned. (Note: CHANGE_DESCRIPTION labels OP-12 "consolidation over duplication"; the canonical OP-12 title is "Closure before detection." The consolidation clause is genuinely inside OP-12, so the intent is sound, but the label is a loose paraphrase — flagged so the recorded override cites OP-12 by its canonical wording, not the paraphrase.)

- **F6's DR-5 invocation is WEAKER than it appears — which materially de-risks the override.** F6 leaned on DR-5's recognized exception for "deliberate cross-level CLAUDE.md duplication." But the canonical DR-5 exception (`principles.md:246`) requires the duplication to be **self-identifying**: "the repetition is made explicit (the file notes it mirrors the workspace rule) rather than silent duplication." The Session-Boundaries copies do NOT carry any "this mirrors the workspace rule" self-identification (unlike the Input File Handling / Commit Rules blocks, which do — see `principles.md:529`). So the 16 copies are *silent* duplication, which DR-5 does NOT protect — DR-5's main body forbids "verbatim duplication of workspace-level rules (short pointers are acceptable)" (`principles.md:242`). The override therefore moves the system from a DR-5-noncompliant state (silent verbatim duplication) toward a DR-5-compliant one (short pointer). This is alignment-positive, not a principle breach.

- **Residual tension — the every-turn-loading concern — is the legitimate Medium-keeping factor.** F6's surviving valid point is that Session Boundaries is a *behavioural* every-turn rule, and a pointer does not auto-load. Option A preserves the behavioural cue ("Prefer `/clear` over dirty context when switching tasks") in-file, every turn — only the elaboration moves to the pointer target. So the load-bearing behavioural trigger is retained; what stops auto-loading is the *rationale* sentence, not the directive. This substantially (not fully) preserves the every-turn property. Because the directive survives in-file, the override does not hollow out the rule — it thins it. The residual risk (a session that needs the full rationale must open the pointer) is real but bounded, which is what keeps this Medium rather than Low.

## Mitigations

- **Dimension 6 (Principle Alignment) — record the override back per OP-11, with canonical citations.** The executing session MUST write the F6 override into `projects/strategic-os/ai-strategy/slot-1-decisions.md` (revise the F6 row from "CONVERT — but NOT a blanket find-replace" to the new blanket-conversion verdict, dated 2026-06-04, with a one-line rationale). Cite OP-12 by its canonical wording ("Closure before detection" — consolidation clause) and note that DR-5's recognized exception did not apply because the copies were silent (not self-identifying) duplication. Without this write-back, the change silently contradicts a recorded verdict — the OP-3 anti-pattern OP-11 exists to prevent. This is the load-bearing mitigation that holds Dimension 6 at Medium.
- **Dimension 6 — preserve the behavioural directive in every Option-A stub.** Ensure each converted in-file stub retains the imperative cue ("Prefer `/clear` over dirty context when switching tasks"), not just the pointer — this is what keeps the every-turn behavioural property F6 correctly cared about. A stub that is pointer-only would re-open F6's valid objection.
- **Dimension 3 (Blast Radius) + Dimension 5 (Hidden Coupling) — keep the 17th file in the change set.** `ai-resources/templates/project-claude-md/session-boundaries.md` must be converted to the same Option-A cue+pointer wording in the same change so `/new-project` and `/permission-sweep` emit the consolidated form for all future projects. Dropping it self-reverts the consolidation on the next `/new-project`.
- **Dimension 5 (Hidden Coupling) — make the pointer self-explaining for project sessions.** State in the new doc's first line (and optionally in each stub) that the path is workspace-root-relative, so a project-session reader without the parent workspace on the path gets a documented pointer rather than a silent dangling reference.
- **Dimension 3 (Blast Radius) — anchor find-replace on the paragraph, not heading-to-EOF.** The 14 project files have differing trailing sections; a heading-to-EOF block replace would corrupt adjacent sections. Edit the bounded paragraph in each file.
- **Dimension 4 (Reversibility) — two-repo + decision-record commit hygiene.** Commit the workspace-repo edits (root + 14 project files) and the ai-resources-repo edits (ai-resources/CLAUDE.md + new doc + template fragment) as two atomic, separately-revertable commits, one per repo; include the `slot-1-decisions.md` override write in the same logical change so a rollback reverts the record alongside the content.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to `slot-1-decisions.md:39`, `principles.md:165/175/242/246/529`, `templates/project-claude-md/session-boundaries.md:1-3`, grep counts, and two-repo git-toplevel checks; verbatim quotes from CHANGE_DESCRIPTION and referenced files). The contribution of the `not yet present` file (`ai-resources/docs/session-boundaries.md`) is evaluated from described intent only, as required. The OP-12 label discrepancy was verified against canonical `principles.md` rather than accepted from the paraphrase. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory) was **unavailable**: `/consult` is configured `disable-model-invocation` (operator-only) and cannot be invoked from inside `/risk-check`. Per `/risk-check` Step 17d, the second opinion being unavailable does NOT change the verdict and does NOT block — the risk-check-reviewer's PROCEED-WITH-CAUTION verdict stands as the gate result._

The one architectural question a second opinion would most usefully address — whether the cross-repo pointer (`ai-resources/docs/session-boundaries.md`, written into project `CLAUDE.md` files that live in the parent workspace repo) actually resolves for a project-session reader — is an empirically checkable fact rather than a judgment call. The executing session will verify it directly against the repo's existing `ai-resources/...`-pointer convention before landing, and apply the Dimension-5 mitigation (make the pointer workspace-root-relative-explicit). The operator may run `/consult` manually if an independent architectural opinion is still wanted.
