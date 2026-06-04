# Risk Check — 2026-06-04

## Change

Plan-time gate for building "Expert Check" — a new workspace-wide advisory skill + agent in ai-resources. Design: (1) new skill ai-resources/skills/expert-check/SKILL.md — operator-invoked after a project step is drafted; (2) new agent ai-resources/.claude/agents/expert-check-reviewer.md (model: opus; tools Read/Glob/Grep) — fresh-context reviewer that reads relevant book summaries from a target KB under knowledge-bases/ (topic-matched), compares the drafted step's work against those principles, and returns an advisory findings list (divergence → cited principle → suggested reconciliation), or "no applicable reference" if nothing matches; (3) optional one-row edit to ai-resources/docs/repo-architecture.md documenting the skill↔knowledge-bases read coupling. Advisory only, never blocking; the book summary is a reference lens, not a binding spec. Built via /create-skill. Auto-symlink hook will distribute the new command/agent to all projects on next session start. KB targeting: command accepts a KB target, defaults to topic-matching across knowledge-bases/. Change classes triggered: new skill, new agent (new symlinks via auto-sync). Evaluate across usage cost, permissions surface, blast radius on other components, reversibility, hidden coupling.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/expert-check/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/expert-check-reviewer.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A genuinely-advisory, pay-as-used review component that is principle-aligned (closure-bearing, advisory, second consumer plausible), but the change description carries a load-bearing artifact-type confusion (a "skill" that an auto-sync hook is expected to distribute — hooks distribute commands/agents only, not skills) and rests on an undocumented, non-uniform KB "book summaries" contract; both must be resolved before build.

## Consumer Inventory

Search terms derived: `expert-check`, `expert check`, `expert-check-reviewer`, plus the contract markers the change depends on — `knowledge-bases/` read coupling, the auto-sync distribution path (commands/agents), and `/create-skill`. Greps run across `ai-resources/` and the workspace root.

- `grep -rniI "expert-check"` across `ai-resources` and workspace root → **0 hits.** Net-new namespace; no existing consumer.
- `grep -rniI "expert check"` → **0 hits.**

Because both referenced component files are `not yet present`, the inventory covers the *contracts* the change will introduce and the components those contracts touch:

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | imports (would symlink the new agent into all projects) | no (auto-picks up; no edit needed unless an exclusion is wanted) |
| 14 × `projects/<project>/.claude/agents/` (every project with a `shared-manifest.json`) | imports (receive the new agent symlink on next SessionStart) | no (auto-distributed; manifest opt-out optional) |
| `ai-resources/docs/repo-architecture.md` | documents (the proposed one-row edit; also its "Cross-repo coupling points" table would gain a new skill↔KB coupling) | yes (per the change's own item 3, and per repo-architecture.md §"When this file needs to change": a new cross-repo coupling point requires an update) |
| `knowledge-bases/pe-kb-vault/`, `knowledge-bases/marketing-communication/` | parses (the agent reads "book summaries" from these vaults — depends on a layout/marker contract that does not yet exist) | no (read-only), but the contract is unverified — see Dimension 5 |
| `/create-skill` pipeline (`ai-resources/.claude/commands/create-skill.md`) | invokes (the stated build mechanism) | no |

**Total: 5 distinct consumer classes, 1 must-change** (`repo-architecture.md`). The 14 project agent directories are a single auto-distribution mechanism counted as one class but represent a wide *physical* fan-out (14 symlinks created on next session start).

Inventory finding not anticipated by the change description: the agent file `expert-check-reviewer.md` does NOT match either baked-in exclusion (`EXCLUDE_AGENT_GLOBS="pipeline-stage-* session-guide-generator pipeline-review-*"` — auto-sync-shared.sh:47), so it WILL be symlinked into all 14 projects automatically. That is the intended behavior, but it means the agent ships everywhere even though its only stated trigger is "after a project step is drafted" — confirm that is wanted in every project, or add it to the exclusion list / a manifest opt-out.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The skill is operator-invoked ("operator-invoked after a project step is drafted" — CHANGE_DESCRIPTION), not auto-loaded; pay-as-used. No always-loaded CLAUDE.md content is added.
- The agent is `model: opus` with `tools Read/Glob/Grep` and fresh context. Opus + KB-summary reads make each *invocation* moderately expensive, but cost is incurred only on demand, not per session or per tool call.
- No SessionStart / PreToolUse / Stop hook is registered by this change (the auto-sync hook already exists; this change does not add a hook — auto-sync-shared.sh:127 already runs per session regardless).
- The optional one-row edit to `repo-architecture.md` adds to a load-on-demand doc (repo-architecture.md:3 — "When to read this file"), not an always-loaded file; negligible ongoing cost.
- Caveat (NOTE — not-yet-present file): exact agent brief size is unknown until `/create-skill` writes it. If the brief is kept lean (peer reviewer agents are bounded), cost stays Low. Flag to QC at build: keep the agent brief within the ≤30-line summary subagent contract (ai-resources/CLAUDE.md:35-41).

### Dimension 2: Permissions Surface
**Risk:** Low

- Agent tools are `Read/Glob/Grep` (CHANGE_DESCRIPTION) — read-only, no Write/Edit/Bash. No new capability beyond what the established reviewer agents already use (peers: `qc-reviewer`, `refinement-reviewer`, `risk-check-reviewer`, `triage-reviewer` — all read-only review agents).
- No `allow`/`ask`/`deny` change described; no `deny` rule removed; no scope escalation (project→user).
- KB reads target `knowledge-bases/` within the same workspace tree — no cross-repo *write*, no external API. (`knowledge-bases/` is a sibling under the workspace root and is already a git submodule per `.gitmodules`; read access is within established bounds.)
- INCOMPLETE sub-note: settings files for the new component were not inspected (component not yet present); but the change explicitly scopes tools to read-only, so the surface is bounded by description. Confirm at end-time risk-check that no Bash/Write entry crept into the agent frontmatter.

### Dimension 3: Blast Radius
**Risk:** Medium

Grounded in the Step 1.5 inventory: 5 consumer classes, 1 must-change.

- **Must-change (1):** `repo-architecture.md`. The change calls this "optional," but repo-architecture.md §"When this file needs to change" lists "A new cross-repo coupling point" and "A new canonical doc / load-bearing source of truth" as mandatory same-commit updates (repo-architecture.md:245-246). A skill↔knowledge-bases read coupling IS a new cross-repo coupling point (the "Cross-repo coupling points" table, repo-architecture.md:142-153, does not currently list any KB coupling). So the edit is required, not optional — downgrading it to optional is itself a small contract drift.
- **Wide auto-distribution (no edit, but real fan-out):** the new agent is symlinked into all 14 projects with a `shared-manifest.json` on next SessionStart (auto-sync-shared.sh:127; effect documented at repo-architecture.md:136). All 14 are compatible (additive symlink; rule 1 — existing files never overwritten, repo-architecture.md:130), so none must change — but the physical blast radius is 14 new symlinks.
- **No contract broken for existing callers:** zero existing references to `expert-check` (grep: 0 hits), so no `parses`/`invokes` consumer is disrupted. This is an additive change to existing components.
- **New parse-dependency introduced:** the agent will `parse` a "book summaries" layout in two structurally *different* KBs (`pe-kb-vault` has `raw/ wiki/ skills/ templates/`; `marketing-communication` has `research/ findings/ architecture/ decisions/`). There is no uniform book-summary contract across them — see Dimension 5. This raises blast radius from Low to Medium because the agent's output quality depends on a layout that varies per KB.

### Dimension 4: Reversibility
**Risk:** Medium

- Core artifacts revert cleanly: `git revert` removes `SKILL.md`, the agent `.md`, and the `repo-architecture.md` row within the ai-resources working tree (single-tree edits).
- **Extra cleanup step required:** the auto-sync hook will have created up to 14 symlinks in project `.claude/agents/` directories before any revert. `git revert` of the ai-resources commit does NOT remove those symlinks — they live in 14 separate project sub-repos and become dangling symlinks pointing at a now-deleted target. Cleanup is a known step (it is the standard cost of any new auto-synced agent), but it is a step beyond a single git revert — hence Medium, not Low.
- No append-only log mutation, no external write, no push-beyond-git is introduced by the build itself (commits accumulate locally; push is gated per workspace CLAUDE.md).
- No new automation that fires between landing and revert beyond the already-existing SessionStart auto-sync.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Undocumented new contract (primary concern):** the agent depends on "book summaries from a target KB under knowledge-bases/ (topic-matched)." Evidence shows the two live KBs do not share a uniform book-summary location or filename convention (`pe-kb-vault/raw|wiki|skills` vs `marketing-communication/research|findings|architecture`). The agent silently relies on a layout/sort/topic-match convention that (a) is not documented in any SKILL.md/command/CLAUDE.md at the KB side, and (b) differs per KB. If a KB's structure changes, the agent silently degrades to "no applicable reference" with no signal that the lens *should* have matched. This is the classic hidden-coupling failure mode.
- **Artifact-type confusion (load-bearing):** the change describes a "skill" but also states "Auto-symlink hook will distribute the new command/agent." The auto-sync hook distributes ONLY `.claude/commands/` and `.claude/agents/` (auto-sync-shared.sh has no `skill` handling — grep: 0 hits; repo-architecture.md:98 — skills are "Read by reference; never copied"). A skill at `skills/expert-check/SKILL.md` is therefore NOT distributed by the hook. Only the *agent* is. So the operator-facing invocation surface ("operator-invoked after a project step is drafted") is underspecified: a skill is auto-loaded by trigger-match, not "invoked"; if the intent is operator-invocation, the front door should be a slash *command* (which IS auto-synced), not a skill. This implicit mismatch between the named component type and the distribution mechanism must be resolved at /create-skill time or the component won't be reachable the way the description assumes.
- **Functional overlap to check (minor):** the new component is a fresh-context advisory reviewer that "compares drafted work against principles and returns a findings list." That posture overlaps in *shape* with `/qc-pass` (qc-reviewer) and `/refinement-pass` (refinement-reviewer). The distinction (Expert Check = external-book-principle conformance; qc = artifact-vs-scope; refinement = quality polish) is defensible, but the boundary must be stated in SKILL.md or two reviewers will both want to "review the drafted step." Document the seam explicitly.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded against `principles-base.md` (frozen-ID set, read in full).

- **OP-12 (closure before detection) — ALIGNED, counts FOR the change.** Expert Check is a detection capability (find divergences from book principles) that ships *with* its closure channel built in: the output is "divergence → cited principle → suggested reconciliation" (CHANGE_DESCRIPTION). It does not merely flag; it proposes the reconciliation. This is the OP-12-compliant shape.
- **OP-5 / advisory-vs-enforcement — ALIGNED.** "Advisory only, never blocking; the book summary is a reference lens, not a binding spec" (CHANGE_DESCRIPTION). It advises and stops; no auto-correction, no enforcement upgrade. Matches OP-5.
- **DR-7 / OP-9 / AP-7 (speculative abstraction) — TENSION, not violation.** The inventory shows zero current consumers and a contract spanning *all* KBs ("defaults to topic-matching across knowledge-bases/"). Building a generic cross-KB topic-matcher before a second confirmed consumer is the AP-7 shape. BUT there are two plausible real consumers today (the marketing-positioning project's drafted steps could check against `marketing-communication`; PE work against `pe-kb-vault`), so the generalization is *licensed-adjacent*, not purely speculative. The tension is the **"defaults to topic-matching across knowledge-bases/"** default — that is the speculative surface (building for KBs/topics that don't have a consumer yet). Mitigation: ship with an explicit KB *target required* (start specific — one KB per invocation), and add the cross-KB default only when a second confirmed consumer asks for it (DR-7). Named, not blocking.
- **DR-1 / DR-3 (placement) — ALIGNED.** Skill→`ai-resources/skills/`, agent→`ai-resources/.claude/agents/`, doc row→`docs/repo-architecture.md` are all correct canonical homes (repo-architecture.md:98-102). (The skill-vs-command *type* question in Dimension 5 is a coupling/reachability issue, not a placement-tier error.)
- **DR-2 / AP-5 (canonical pipeline) — ALIGNED.** Built via `/create-skill` (CHANGE_DESCRIPTION), the canonical pipeline; no improvisation.
- **OP-10 (system boundary) — not triggered.** Reading book summaries from an in-workspace KB is internal; it does not govern GPT/Perplexity/NotebookLM behavior.

No principle is *clearly violated*, so Dimension 6 is Medium (tension on DR-7/AP-7 via the cross-KB default), not High. No loud principle revision is required — the mitigation is to rescope the default, not to revise a guardrail.

## Mitigations

- **Dimension 5 (hidden coupling — artifact type):** Before `/create-skill` runs, decide and record the front-door type. If the component is operator-*invoked*, build a slash *command* (`ai-resources/.claude/commands/expert-check.md`) as the entry point — commands ARE auto-synced (auto-sync-shared.sh, repo-architecture.md:99) — with the skill (if any) as read-by-reference methodology. Do not rely on a `SKILL.md` to be "distributed by the auto-symlink hook"; the hook does not touch skills.
- **Dimension 5 (hidden coupling — KB contract):** Document the book-summary read contract explicitly in `SKILL.md` (which subdirectory/filename pattern counts as a "book summary," how topic-match resolves, what "no applicable reference" means) AND add the new skill↔knowledge-bases coupling row to the `repo-architecture.md` "Cross-repo coupling points" table (repo-architecture.md:142-153) — not just the one-row layout note. Confirm the contract resolves against BOTH live KB layouts (`pe-kb-vault`, `marketing-communication`), which differ structurally.
- **Dimension 5 (hidden coupling — overlap):** State the Expert-Check vs `/qc-pass` vs `/refinement-pass` boundary in `SKILL.md` so the three reviewers do not contend for the same "review the drafted step" trigger.
- **Dimension 3 (blast radius — must-change made optional):** Treat the `repo-architecture.md` edit as required, not optional — a new cross-repo coupling point mandates a same-commit update (repo-architecture.md:245-246). Land it in the same commit as the agent.
- **Dimension 3 / Dimension 6 (auto-distribution + DR-7 default):** Ship the agent with a *required* KB target (start specific, one KB per invocation); defer the "topic-match across all knowledge-bases/" default until a second confirmed consumer exists (DR-7). If the agent should NOT appear in every one of the 14 projects, add it to `EXCLUDE_AGENT_GLOBS` (auto-sync-shared.sh:47) or rely on per-project `shared-manifest.json` opt-out.
- **Dimension 4 (reversibility):** Record in the build commit message that revert requires a follow-up symlink cleanup across the 14 project `.claude/agents/` directories (the standard cost of any new auto-synced agent), so a future revert is not surprised by dangling symlinks.

## Recommended redesign

(Not required — verdict is PROCEED-WITH-CAUTION, not RECONSIDER. Section retained empty intentionally.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (repo-architecture.md:98-102, :130, :136, :142-153, :245-246; auto-sync-shared.sh:46-47, :127), grep counts (0 hits for `expert-check`; 14 `shared-manifest.json`; 33 auto-synced agents), directory listings of the two live KBs showing non-uniform layouts, and the frozen-ID `principles-base.md` (OP-5, OP-9, OP-10, OP-12, DR-1/2/3/7, AP-5/7). Not-yet-present files (`SKILL.md`, agent `.md`) were evaluated from the described intent and explicitly flagged as NOTE/INCOMPLETE sub-notes where exact content could not be inspected. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Obtained by spawning the `system-owner` agent directly (the `/consult` command was not resolvable as a Skill this session; substance is identical — Function B delegates to system-owner). Full advisory on disk: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-04-expert-check-plan-time-gate-second-opinion.md_

**Position:** Concur with PROCEED-WITH-CAUTION. Recommended path is right, with two changes — one mitigation is mis-classed as optional, and the dimension review missed a check.

**Routing.** Operator-invoked + must auto-distribute = a canonical **command**, not a skill. The auto-sync hook carries commands/agents only, never skills. Mitigation 1 is therefore a **build-blocker**, not a preference: a SKILL.md silently fails the "workspace-wide" promise on day one.

**Architectural notes.**
- Advisory-only / never-blocking is the correct authority level for new automation (OP-5). Keep it there.
- "Topic-matched book summaries" rests on a KB-layout uniformity the two live KBs don't guarantee — an agent reading against an undocumented contract will fabricate or mis-match (QS-4 / AP-2). Document + validate the read contract before build (mitigation 2, **blocking**).
- REQUIRED KB target, no all-KB default — DR-7, a hard rule (mitigation 5).
- State the Expert-Check / /qc-pass / /refinement-pass boundary (mitigation 4). Clean line: Expert-Check tests against *external KB principles*; /qc-pass tests against *the artifact's own criteria*.

**Downstream.** Blast radius and reversibility Medium both right; mitigation 3 (repo-architecture.md coupling row) and mitigation 6 (symlink cleanup on revert) are **required, not optional** (OP-11). One flag: the brief says 14 projects; the grounding base documents 7. Reconcile the count against live state before writing the revert note.

**Risk the dimension review missed — closure surface (OP-12).** None of the six dimensions tests whether this *detector* ships behind a working *closure* channel. Add a seventh pre-build check — name the closure path for an Expert-Check finding (route to /decide or /resolve, or disposition inline). Ad-hoc operator reconciliation is acceptable for an advisory component, but it must be stated, not assumed.

**Bottom line:** GO to build, conditioned on the seven items — items 1 and 2 blocking, item 7 the gap the dimension review left open.
