# Risk Check — 2026-07-18

## Change

PLAN-TIME GATE. Create reference/research-procedure.md in projects/axcion-content-programme — a project-local workflow-methodology reference defining article research sizing (workflow step 4), the manual execution procedure (step 5), the shared source-pack output shape, handling of private counterparty evidence, borrowed-vs-refused discipline from the canonical research-workflow, and the escalation path to a full research-workflow deployment. Paired edits: (a) append one entry to logs/decisions.md; (b) add one bullet to the project CLAUDE.md 'Settled policy lives in reference/' list, which currently enumerates only publication-gate.md and editorial-standards.md. The CLAUDE.md edit is why this gate fires. No commands, agents, hooks, skills, symlinks, or settings change. Architecture tension to weigh: architecture.md §6 Decision 8 deliberately capped reference/ at two documents, rejecting 'a fuller reference/ mirroring research-workflow's 17 files.'

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/research-procedure.md — not yet present (confirmed: `reference/` currently holds exactly 2 files, `editorial-standards.md` and `publication-gate.md`, via directory listing)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/CLAUDE.md — exists (bullet list confirmed at lines 53–55, exactly 2 reference bullets today)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/logs/decisions.md — exists (confirmed 1 entry; table columns Date | Decision | Rationale | Decided by)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/architecture.md — exists (Decision 8 confirmed at line 172; Decision 1 confirmed at line 165 — note: the input's claim "Decision 1 and Decision 10 at line 174" is only half right, see Dimension 7)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/editorial-standards.md — exists (§3, §10 read in full)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/ — exists (confirmed: its own `reference/` subdirectory holds 15 top-level entries, several of which are themselves directories — consistent with architecture.md's "17 files" characterization; canonical template not deployed)

## Verdict

RECONSIDER

**Summary:** The change is technically low-risk to land (small, git-reversible, no permissions/hooks/consumers today), but it does the project's own W1.5 design work early and outside its designated home, directly contradicting two ratified architecture decisions (Decision 2's "sized against the concrete article, never in advance" and Decision 8's two-file reference cap) and duplicating content that already exists, settled, in three other documents.

## Consumer Inventory

Search terms used: `research-procedure`, `research-procedure.md`, `reference/research-procedure` (the new contract); `reference/` (the directory list this change extends). Grepped across `ai-resources/`, the workspace root, and `projects/axcion-content-programme/` (`.claude/commands`, `.claude/agents`, `.claude/hooks`, `pipeline/`, `logs/`, `reference/`, `knowledge/`).

**The new file's own contract has zero current consumers** — `grep -rniI "research-procedure"` across the entire repo returns 0 hits. No command, agent, hook, or document anywhere references `research-procedure.md` today, and the intended future consumer (`workflow/article-workflow.md`, a W1.5 deliverable) does not exist yet — `workflow/` currently holds only `.gitkeep`.

The broader `reference/`-directory contract (what this change extends) has these consumers:

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/axcion-content-programme/CLAUDE.md` (lines 53–55) | documents (the "Settled policy lives in reference/" bullet list) | yes — this is paired edit (b) itself |
| `projects/axcion-content-programme/logs/decisions.md` | co-edits (project decision log) | yes — this is paired edit (a) itself |
| `projects/axcion-content-programme/pipeline/architecture.md` (Decision 8, line 172; §2.1 directory tree, line 44) | documents (states the ratified "two reference documents, not a reference system" cap and lists exactly 2 files) | **yes — NOT in the change's paired-edit list.** Landing a 3rd reference file without touching architecture.md leaves the canonical design record actively contradicting the repo state (a stale/misleading "why we capped it at two" decision sitting next to a 3rd file). This is a blast-radius gap the change description did not anticipate. |
| `projects/axcion-content-programme/reference/editorial-standards.md` §10 "Reuse before research" (lines 137–143) | overlapping content (already defines the step-4 research-sizing default rule and the mode-decision standard) | yes — the new document's "article research sizing (workflow step 4)" scope duplicates this section; without a cross-reference the two documents can state the sizing rule differently over time |
| `projects/axcion-content-programme/pipeline/architecture.md` Decision 1 (line 165) + §2.4 (lines 87–89) | overlapping content (already defines "the escalation path to a full research-workflow deployment": deployed at Checkpoint C, scoped to the article, justified at the checkpoint) | yes — the new document's "escalation path to a full research-workflow deployment" scope duplicates an already-ratified decision |
| `pipeline/implementation-spec.md`, `pipeline/test-results.md` (V-16/V-17), `pipeline/implementation-log.md` (Op 6/Op 7) | documents (Stage 3c/4/5 point-in-time records asserting "the two reference documents") | no — historical build/verification records, not live-consumed; become incomplete but not functionally broken |
| `.claude/commands/build-inventory.md`, `build-roadmap.md`, `select-articles.md`, `.claude/agents/knowledge-inventory-agent.md` | invokes/parses `reference/editorial-standards.md` specifically | no — none of the built W1.1–W1.4 commands need research-sizing content; unaffected |

**Total: 6 consumers found tied to the `reference/` contract this change extends, 4 must-change (2 of which — architecture.md and editorial-standards.md — are gaps the change description did not list); 0 consumers of the new file's own name/contract; 3 not-must-change (historical records and unrelated W1.1–W1.4 commands).**

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new file is a project-local reference document read on demand (parallel to `reference/editorial-standards.md`, `reference/publication-gate.md` — neither is `@import`ed into CLAUDE.md; both are read explicitly by workflow steps / commands, confirmed by grep showing no `@import` of `reference/*.md` in `CLAUDE.md`).
- The only always-loaded-file touch is paired edit (b): one bullet appended to project `CLAUDE.md`'s "Settled policy lives in `reference/`" list. Sizing against the existing bullets (`- reference/editorial-standards.md — audience, register, evidence rules, the four authority classes, the topics-to-avoid filter, the five category rules, the seams.` ≈ 35–40 tokens), a comparable bullet describing six content areas (research sizing, execution procedure, source-pack shape, private-evidence handling, borrowed-vs-refused discipline, escalation path) lands at roughly 45–60 tokens — under the ~50–150-token Medium threshold.
- No hook, no `@import` chain, no subagent brief expansion, no skill trigger-keyword change.

### Dimension 2: Permissions Surface
**Risk:** Low

- `CHANGE_DESCRIPTION` states explicitly: "No commands, agents, hooks, skills, symlinks, or settings change" — confirmed consistent with the described edits (one new file under `reference/`, one CLAUDE.md bullet, one decisions.md row).
- `.claude/settings.json` grants a blanket `"Write"` and `"Read"` allow (not path-scoped to `reference/*.md`), so no permission entry needs to change to create the new file — verified by reading `settings.json` directly.
- No new Bash pattern, no external API, no cross-repo write.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory above: 6 consumers tied to the `reference/` contract, 4 must-change — 2 of which (`architecture.md` Decision 8 / §2.1, and `editorial-standards.md` §10) are **not** in the change's own 2-item paired-edit list. That is a real gap: the change as described will leave the canonical architecture record (Decision 8: "two reference documents, not a reference system") contradicted by the repo state, and will leave two documents (`editorial-standards.md` §10 and the new file) independently stating research-sizing guidance with no cross-reference.
- The new file's own contract (the literal string `research-procedure`) has 0 current consumers — in isolation this would be Low, but the broader "what else in the repo asserts things about `reference/`'s shape and content" surface is not isolated, and 2 of 4 must-change consumers were missed by the plan.
- Nothing breaks functionally (no command reads the new file at runtime today), so this stops short of High.

### Dimension 4: Reversibility
**Risk:** Low

- All three touches (new file, CLAUDE.md bullet, one decisions.md row) are ordinary git-tracked edits inside a single commit; `git revert` on that commit cleanly restores the prior 2-file `reference/` state, the prior CLAUDE.md text, and the prior 1-row decisions.md — no external writes, no push, no cached permission state, no automation that could fire between landing and a potential revert.
- No forward dependency exists yet that a revert would strand: `workflow/article-workflow.md` (the only plausible future consumer) does not exist, so nothing would be left referencing a since-deleted file.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Functional overlap with an already-ratified mechanism.** The new document's stated scope — "the escalation path to a full research-workflow deployment" — restates content `architecture.md` Decision 1 (line 165) and §2.4 (lines 87–89) already settle: "Not deployed now. Deployed at Checkpoint C, scoped to what the approved research-mode article actually needs, with any deployment beyond that justified at the checkpoint." Two documents will now independently describe the same escalation path, with no cross-reference specified, and no mechanism to keep them in sync if Decision 1 is later revised.
- **Functional overlap with the project's own designated future artifact.** `project-plan.md` §W1.5 (lines 240–257) explicitly assigns "determine how much external research the article requires" (step 4) and "gather and evaluate external evidence" (step 5) to `workflow/article-workflow.md`, authored at W1.5. The new file pre-defines this same content in a different location before that artifact exists — creating two candidate homes for the same procedural content (the new `reference/research-procedure.md` now, and `workflow/article-workflow.md` later), an unresolved duplication the change description does not address.
- **Unpinned coupling to an actively-maintained external template.** "Borrowed-vs-refused discipline from the canonical research-workflow" implies drawing on `ai-resources/workflows/research-workflow/reference/` (15 entries, including a 71 KB `quality-standards.md` last modified 2026-07-14 — actively maintained), but the change does not name which specific files or sections are borrowed. If the canonical template's reference content changes later, this project's document can drift silently with no stated sync mechanism.
- This is a self-contained finding independent of Dimension 6 — even setting the principle question aside, the change creates a second, unsynced description of the escalation path and of workflow steps 4/5.

### Dimension 6: Principle Alignment
**Risk:** High

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.

- **DR-7 / OP-9 / AP-7 — speculative abstraction.** The Consumer Inventory shows zero current consumers of the new file's contract, and its intended future consumer (`workflow/article-workflow.md`) is not yet authored — it is a W1.5 deliverable, and the project is currently at W1.1-complete / W1.2-not-started (confirmed: `knowledge/reusable-knowledge-inventory.md` exists at 25,894 bytes; `roadmap/` and `workflow/` hold only `.gitkeep`). Building the content of workflow steps 4/5 before W1.2–W1.4 have even run, and before article one is selected, is generalizing for an absent consumer.
- **Direct conflict with architecture.md Decision 2** (line 166): "the skill set is sized against the concrete first article (unknown until W1.4)... skill decomposition is decided against observed workflow problems from real articles — never in advance." This reasoning was written for the workflow doc and skills specifically, and this change does exactly what Decision 2 forbids — defines workflow-step content in advance, before the concrete article exists to size it against.
- **Direct conflict with architecture.md Decision 8** (line 172) and `project-plan.md` line 257 ("Minimal repository structure... Nothing else — no extensive reference-file system"). Decision 8 explicitly rejected "a fuller `reference/` mirroring `research-workflow`'s 17 files" and held the count at two ("Authority classes are folded into `editorial-standards.md`... rather than given a third file"). Adding a third file that explicitly imports discipline from that same rejected template is the alternative Decision 8 considered and rejected, not a new option outside its scope.
- **DR-3 — placement.** The settled, project-specific placement decision for workflow-step-4/5 content is `workflow/article-workflow.md`, authored at W1.5 (stated in `project-plan.md`, `architecture.md`, and the project CLAUDE.md's own "The 10 workflow steps belong in `workflow/article-workflow.md` — never in this file"). `reference/` is reserved for already-settled, control-pack-derived policy (Decision 8's design intent), not for pre-drafting undecided workflow-step content.
- **OP-11 loud-revision test.** The change does propose a paired `logs/decisions.md` entry, which is the correct *mechanism* for a deliberate exception (per `ai-resource-creation.md` rule #7: "a loud, recorded principle exception... logged in `logs/decisions.md` with its rationale"). But as described, the entry's content does not exist yet, and the change description itself frames the conflict as an open "tension to weigh" rather than a resolved, argued exception. Per rule #7, a genuine exception should answer: what recurring failure this prevents, how likely/frequent, what it costs, whether it could fire conditionally instead, and whether an existing document (`editorial-standards.md` §10, or `architecture.md` §2.4) already covers ~80% of it (it does, per Dimension 5). None of that reasoning is present. This does not yet clear the bar for "loud, explicit acknowledgment" — it is a flagged tension, not a recorded decision.
- Because the revision is not yet loud/explicit in the sense the framework requires, this scores High rather than the "acknowledged revision → Medium" carve-out.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Not applicable in the strict sense: `CHANGE_DESCRIPTION` does not assert that anything is currently broken, missing-and-causing-friction, unwired, stale, or failing. It is framed entirely as adding new, prospective content ("Create... defining..."), not as repairing an observed defect. No article has been produced (confirmed: `articles/` structure not yet exercised, `workflow/` empty), so there is no actual research-sizing friction on record to observe.
- **Consequence — traced or assumed?** N/A — no consequence is claimed to justify urgency.
- **Re-derivation vs. the change description:** Two claims re-derived and confirmed exactly: (1) `reference/` holds exactly 2 files today (`editorial-standards.md`, `publication-gate.md`) — confirmed via directory listing; (2) `logs/decisions.md` holds exactly 1 entry with the stated column schema — confirmed via direct read. One minor discrepancy found: the input's citation "Decision 1 and Decision 10 at line 174 also relevant" is only half accurate — Decision 10 is at line 174, but Decision 1 is at line 165, not 174 (confirmed via `grep -n "^| [0-9]* |"` against `architecture.md`). This is a trivial line-number slip in the file-reference annotation, not in `CHANGE_DESCRIPTION` itself, and does not bear on the verdict.
- **Not defect-justified — no premise to verify.** Risk: Low. (The substantive concern — that this content is being built before its designed trigger condition, W1.4's article selection — is a speculative-abstraction/placement question, fully addressed under Dimension 6, not a defect claim under Dimension 7.)

## Recommended redesign

Dimension 6 is High and the accompanying decisions.md entry does not yet constitute a loud, argued OP-11 exception — per the framework this forces RECONSIDER on its own, reinforced here by two High dimensions (5 and 6) together. Two paths, either is viable:

- **Rescope (preferred).** Do not create `reference/research-procedure.md` now. Fold its intended content into `workflow/article-workflow.md` at W1.5, sized against the actual selected article, where `project-plan.md` and `architecture.md` already designate it to live — this resolves the Dimension 5 duplication (one home, not two) and the Dimension 6 conflict (no longer contradicts Decision 2 or Decision 8) in one move. If any of the content (e.g., private-counterparty-evidence handling) is genuinely settled policy independent of the concrete article, it can be added to `editorial-standards.md` §3/§10 by extension rather than a new file — consistent with Decision 8's "fold in, don't add a file" pattern.
- **Or: make the exception loud and complete (OP-11), not just flagged.** If there is a real, argued reason to pre-stage this now (state it), amend `architecture.md` Decision 8 in the same commit (not just append a bare `logs/decisions.md` row) to record that the two-file cap is being revised, answer the five questions from `ai-resource-creation.md` rule #7 (recurring failure prevented, frequency, cost, conditional-fire alternative, and explicitly address why `editorial-standards.md` §10 and Decision 1/§2.4 do not already cover ~80% of the content), and cross-reference the new file from both `editorial-standards.md` §10 and architecture.md §2.4 so the three documents do not drift apart.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit re-derivation checks). No training-data fallback was used on fetch/read failures.
