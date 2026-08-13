---
task: work-loop-v2-compaction-survivability-repair
turn: codex
---

## Objective and scope

Make Work Loop v2 reliably recover its authoritative task after Codex compaction in every intended Work-Loop-enabled project, without adding parallel state, weakening actor boundaries, or duplicating recovery authority. The task exits only when the instruction layer is review-clean, the approved deployment scope is installed, and one representative project-repository compaction proves recovery or a safe stop.

In scope across the task: the instruction-layer correction following commit `df35ddd`; deployment only to verified Work-Loop-enabled projects and future eligible scaffolds; the operator-approved user-level compact-hook carrier; proportionate operational proof. Excluded: distributing these skills to every project, a five-compaction endurance exercise, broad Work Loop redesign, a second recovery artifact, and approving or rewriting the executable core without a later explicit operator decision.

## Lane and unit

Standard. Discovery mode. Unit 3 — establish the exact applicable skill-size standard and the smallest compliant remedy for `work-loop-v2/SKILL.md`.

Named reason for the loop: the repair crosses sessions and repositories, needs bounding before deployment, and requires independent assessment of Claude's evidence before changes propagate to project environments.

Why this unit, why now: Unit 2 established that deployment can proceed without approving the draft executable core in full, and the operator has now approved both project-repository deployment and future-project scaffolding. The instruction layer still has one review finding that `work-loop-v2/SKILL.md` exceeds the applicable size limit; resolving its exact standard and minimum safe boundary is necessary before calling that layer review-clean.

Governing authority: the repository's applicable skill-authoring standards, but only where their approval or governing status is established; the operator's instruction to use Work Loop v2 for this task; the accepted Unit 1 review finding that the current Work Loop skill is over 500 lines. The operator's `approved clauses only` decision remains binding: unapproved executable-core text does not become authority through this unit.

Codex framing decision: this unit is standards discovery only. Any skill split or other instruction edit, deployment edits, the user-level settings write, project changes, operational proof, the `runs no git` accuracy defect, unexplained project skill links, and the deferred hook-pointer duplication concern are held outside because each has a different deliverable.

## Brief

Required outcome: determine whether an applicable governing standard actually limits this skill's size and, if so, return the smallest safe remediation boundary that preserves Work Loop behavior and single ownership of each rule. Do not implement or edit instruction files in this unit.

Check against the repository:

1. Locate the exact standard behind the accepted review's `>500 lines` finding. Bound the search to repository/agent instructions, the skill-builder instructions and references they directly route to, and the accepted review evidence or directly cited standards source. Establish whether the rule is governing, advisory, or unsupported; a filename or convention alone does not grant authority.
2. Measure the current complete `work-loop-v2/SKILL.md` and identify its major semantic sections and internal links. Determine which content is essential at invocation and which content, if any, the governing standard permits moving to a directly referenced file.
3. Identify the smallest remediation boundary that would satisfy the established standard while preserving: the Reorient gate near the top; the executable-core resolver and single semantic owner; routing and admission behavior; the Claude/Codex seam and actor boundaries; exact protocol tokens; and all currently required links between sections. Do not prescribe a mechanism beyond what the governing standard settles—return alternatives if the smallest safe boundary is genuinely ambiguous.
4. Check for consumers or tests that depend on section headings, anchors, exact paths, line-local extraction, or the current single-file layout. Every absence claim must name the searched surface and pattern.

Required evidence capable of failure:

- Cite the exact governing or advisory size language and why it applies—or conclude that the accepted review finding lacks a governing basis.
- Report the measured current line count and a concise section/dependency map sufficient to evaluate the proposed boundary.
- State one clear conclusion: `a compliance edit is required` with the minimum safe boundary, or `no compliance edit is justified` with the evidence that defeats the finding.
- Name any compatibility risk or unresolved dependency that must constrain a later implementation unit.
- Confirm no repository file changed except this state file; report automatic friction-log telemetry separately and keep it excluded from the commit.
- Set `turn: codex` and commit the discovery handback. Do not push.

Completion condition: Claude returns enough evidence for Codex to accept or reject the size finding and, if accepted, frame one bounded implementation unit without rediscovering the standard.

Stop and hand back if the standard's applicability or a load-bearing extraction dependency cannot be established from the bounded sources. Stop for the operator only if the smallest safe remedy requires a policy or scope choice rather than technical judgment. A false premise is a valid result; report it instead of forcing a split.

## Latest result

Discovery unit. The findings below are the inspection record (core § 3 step 4, § 6 rules 3 and 5).

### Claim 1 — the standard behind the `>500 lines` finding

**Three numeric size rules exist in the bounded surface. None of them is a governing standard for this file, and the one the review cited is the weakest of the three.**

| Rule | Source | Binds this file? | Status |
|---|---|---|---|
| **500 lines** | `skills/ai-resource-builder/references/skill-architecture.md` L17, routed from `skills/ai-resource-builder/SKILL.md` L32 | **Not established** | Claude skill-library convention |
| **300 lines** | `.claude/hooks/check-skill-size.sh` L12 `THRESHOLD=300` | Yes, path-agnostic | **Explicitly advisory** |
| **340 lines** | `logs/scripts/work-loop-v2-slice-1.test.sh` L1149–1150 | **Yes, by exact path** | Executable, **currently red** |

**The 500-line rule is the review's cited basis and it does not reach this file.** Its exact language is `skill-architecture.md` L17: *"Keep SKILL.md body under 500 lines (YAML frontmatter counts). When approaching the limit, split into reference files and link from SKILL.md with guidance on when to read them."* It is reached only through `ai-resource-builder`, whose own trigger scopes it to *"building a new skill or prompt from scratch"* and improving one. Searched both `skills/ai-resource-builder/SKILL.md` and `skills/ai-resource-builder/references/skill-architecture.md` for `\.agents|agents/skills|Codex` — **no match in either file.** Workspace `CLAUDE.md` scopes the library it governs to *"`ai-resources/skills/` is the canonical skill library"*; the file under review is `.agents/skills/work-loop-v2/SKILL.md`, the Codex surface, which that sentence does not name.

**The standard that does claim this file sets no number.** `plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md` L4 states its scope explicitly: *"Who this is for: Claude, in any session that drafts or revises the Work Loop artifacts: the Claude Code command, **the Codex resource**, or the executable core."* That is this file. Searched it for `500|340|300|line limit|lines` — its only size discipline is qualitative: § 1 *"attention is the budget"*, § 9 *"Length is the disease v1 died of, not the cure"*, § 10 *"The artifact got shorter, or at least no longer, in the final revision pass."* Its one delegation is bounded and does not carry a size budget — L151: *"Where the repository's `skill-creator` conventions apply, follow them **for structure and frontmatter**."*

**The 300-line check disclaims its own force.** `check-skill-size.sh` L2–3: *"Informational pre-commit warning… **Non-blocking** — emits warnings only and exits 0."* Its caller confirms this — `.claude/hooks/pre-commit` L127 comments *"Informational skill-size check (non-blocking, exit 0 even on warnings)"* and invokes it as `"$size_check" || true`.

**The 340-line ceiling is the one rule that binds this exact file and can actually fail — and it disclaims operator authority in the same breath.** `work-loop-v2-slice-1.test.sh` L251 sets `SKILL_F=".agents/skills/work-loop-v2/SKILL.md"`, L980 sets `RIDX_F="${WL2_ROUTER_FILE:-$SKILL_F}"`, and L1149–1150 asserts `[ "$(wc -l < '$RIDX_F')" -le 340 ]`. Its own comment, L1143–1148: *"Ceiling raised 320 -> 340 by the mode-contract unit. It is an implementation guard against the index turning into a catalogue, **not operator authority**… The guard is kept and re-based, not deleted."*

### Claim 2 — measurement and section map

`wc -l .agents/skills/work-loop-v2/SKILL.md` → **617 lines.** For scale, the same file was **116 lines** at the MVP candidate review (`step-6-candidate-review.md` L53) and **120** at finding-C adjudication. It has grown roughly fivefold since acceptance.

| Block | Lines | Count | Movable? |
|---|---|---|---|
| Frontmatter, title, **Reorient gate (L19–23)** | L1–25 | 25 | No — brief requires the gate stay near the top |
| **Core-resolution marked region** | L26–132 | 107 | **No — hard dependency, see Claim 4** |
| The seam, checkout binding, courier mode | L133–305 | 173 | Behavior, not lookup |
| Routing preamble, repo-problem ref, mode classification, intake-result contract | L306–365 | 60 | Partly |
| **The five route indexes + non-route classes + collision block** | L366–465 | 100 | **Yes — this is the lookup content** |
| Admission, brief-writing, assessing, closing, never-do, scope | L466–617 | 152 | Behavior, not lookup |

### Claim 3 — the smallest safe remediation boundary

Preserving everything the brief names, the only genuinely index-shaped content is **L366–465 (100 lines)** — five `### The index —` sections, `### The index — names that are not routes`, and `### Naming a colliding capability`. It is consulted when routing an intake, not on every invocation, and it is precisely what the harness comment calls *"the index turning into a catalogue"*. `skill-architecture.md`'s own remedy shape applies: a `references/` file inside the skill folder, linked with guidance on when to read it.

**The arithmetic does not resolve cleanly, so alternatives are returned rather than a single prescription:**

- **Boundary A — index only.** Move L366–465 → `references/routing-index.md`. 617 − 100 = **517**. This preserves every named behavior, but **satisfies none of the three numbers** — it is still 17 over the advisory 500 and 177 over the binding 340.
- **Boundary B — index plus two adjacent lookup blocks.** Add `### What an intake result contains` (L353–365, 13) and `### Repository-problem reference` (L329–338, 10). 617 − 123 = **494**. Clears the advisory 500 with 6 lines of headroom. Still 154 over the binding 340.
- **Boundary C — reach 340.** Requires moving ≥277 lines, which cannot be done from lookup content alone: after the index and both adjacent blocks there is no lookup left, so it would have to take behavior — the courier-mode block (L212–305, 94) or the brief-writing sub-sections (L488–549, 62). That is a restructure of the Work Loop's behavioral text, not a compliance edit, and it would put the seam and courier rules behind a second read.

**The repository has already handled this exact situation once, and not by splitting.** The same guard was re-based 320 → 340 by the unit that grew the file, deliberately and with its reasoning written down (L1143–1148). That is a recorded precedent for re-basing the ceiling with justification, and it is a real option beside splitting.

### Claim 4 — consumers and dependencies

- **HARD — marker-based extraction with byte-identical mirror parity.** `logs/scripts/work-loop-v2-core-resolver.test.sh` L56 extracts by marker (`awk '/work-loop-v2-core-resolution:start/{f=1;next} /work-loop-v2-core-resolution:end/{f=0} f'`), L114–115 runs it over **both** `.claude/commands/work-loop-v2.md` and this SKILL.md, and L116 asserts *"check 4 — deployed resolver blocks are byte-identical"* via `cmp -s`. **L26–132 cannot move, cannot be reflowed, and cannot be edited on one side only.** `core-resolver-worktree-fix-plan-v0.1.md` L118 states the same maintenance rule: *"Edit one, then copy the marked region into the other — do not retype it."*
- **BLOCKING ON EXTRACTION — the acceptance harness greps the index in place.** `work-loop-v2-slice-1.test.sh` carries 41 references to `$SKILL_F`/`$RIDX_F`, of which at least 28 `ridx` assertions test index content directly: *"the index holds 51 entries, none classified twice"* (L1033), *"all 25 indexed Matt names resolve under ~/.claude/skills/"* (L1037), *"all 26 indexed Axcíon commands resolve under .claude/commands/"* (L1040), *"exactly the 12 Claude-side-only skills carry the marker"* (L1051), and the three collision-block checks (L1071–1075). **Moving the index breaks these in the same commit unless they are repointed.** A repointing seam already exists and is documented as such — L978–980: *"`WL2_ROUTER_FILE` lets a mutated copy be substituted"* — so `RIDX_F` can be aimed at the extracted file, but that is an edit to the harness and must be part of the same unit.
- **NON-BLOCKING.** `.claude/hooks/pre-commit` validates folder naming, frontmatter presence/fields, and prohibited files on any staged `SKILL.md` (L53 `grep "SKILL.md$"`, path-agnostic). It prohibits `README.md`, `CHANGELOG.md`, `INSTALLATION_GUIDE.md`, `QUICK_REFERENCE.md` inside a skill folder — **`references/` is not prohibited.** `check-skill-size.sh` would warn at 300 and not block.
- **Deployment interaction — extraction travels.** The project installations are directory-level symlinks (`work-loop-v2 -> ../../../../ai-resources/.agents/skills/work-loop-v2`), so a new `references/` subdirectory inside the skill folder reaches the three projects with no manifest change. This does not conflict with the approved deployment.
- **Absence claim.** Searched the repository excluding `.git` and `logs/` for `work-loop-v2/SKILL.md`: every hit is prose in `plans/` referencing the file or historical line counts. Searched `logs/scripts/` for `core-resolution`: one hit, the resolver test above. **No consumer performs line-numbered extraction** (no `sed -n 'N,Mp'` or `awk NR` against this file); the only structural extraction is by marker.

Result: the size finding is **misattributed but not baseless.** The `>500 lines` basis does not govern a Codex-side skill, and the standard that does govern this file sets no number. A different rule does bind it, can fail, and is currently red: the 340-line ceiling in the repository's own acceptance harness, breached by 277 lines at 617.

Evidence: the determination could have read the other way at each step and did so unevenly — the Work Loop standard was searched for a number and returned none, `ai-resource-builder` was searched for Codex scope and returned no match, while the harness search returned a concrete binding path (`SKILL_F` L251) and a failing arithmetic comparison. The 340 breach is falsifiable by `wc -l`: at ≤340 the assertion passes. The harness was **not executed** — running it would write fixture state, which this unit's brief forbids — so the breach is reported as arithmetic against the assertion's own literal, not as an observed test run.

**Conclusion: a compliance edit is required, but on a corrected basis and with the boundary left open.**

The `>500` finding should be accepted in substance and rejected in citation. The binding rule is the 340-line harness ceiling, not the 500-line skill-library budget. The minimum safe boundary that preserves every behavior the brief names is **Boundary B — move L366–465 plus L353–365 and L329–338 (123 lines) to `references/` inside the skill folder, taking the file to 494** — which clears the advisory numbers but still leaves the binding ceiling red. Closing that gap requires an operator-owned choice between re-basing the ceiling with written justification (the recorded precedent) and restructuring behavioral text (which the brief's preservation list resists). That choice is policy, not technical judgment.

Compatibility risks that must constrain the later implementation unit: (i) L26–132 is immovable and byte-parity-locked to the Claude command; (ii) the ≥28 `ridx` harness assertions must be repointed via `WL2_ROUTER_FILE` in the same commit or the acceptance harness goes red; (iii) the Reorient gate must stay above the resolver block near the top.

Repository state: **this unit wrote exactly one file, this state file.** No instruction file, script, setting, project file or user-level file was written; the harness was not run. `logs/friction-log.md` is excluded from the commit and was not edited by this unit — as Unit 2 established, hook telemetry appends one write-activity line per Write/Edit, so its hash moved from `1888b75d…92999ccf` without any deliberate change.

Deferrals noticed and not done: (i) the file's growth from 116 to 617 lines since MVP acceptance suggests the guard has been absorbing additions rather than constraining them, which is a trend worth a decision rather than another re-base; (ii) Unit 2's `runs no git` accuracy defect and the two unexplained project skill links remain open and outside this unit.

## Blocker

None blocking the handback. One item needs an operator decision before an implementation unit can be framed to completion: no extraction that preserves the brief's protected behaviors reaches the binding 340-line ceiling, so the ceiling must either be re-based with justification or behavioral text must move.

## Next action

Codex: accept or reject the corrected basis for the size finding, then frame the implementation unit around Boundary B — or stop for the operator on the 340-versus-restructure choice named in the conclusion. The harness repointing via `WL2_ROUTER_FILE` must be inside whichever unit moves the index.
