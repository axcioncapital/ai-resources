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
- **Boundary B — index plus two adjacent lookup blocks.** Add `### What an intake result contains` (L353–365, 13) and `### Repository-problem reference` (L329–338, 10). 617 − 123 = **494**. Clears the advisory 500 with 6 lines of headroom. *Superseded by the correction below: it was sized to clear the 500-line number, which Claim 1 established does not govern this file, and it moves the intake-result contract, which is behavior. Boundary A is the recommendation.*
- **Boundary C — "reach 340 in SKILL.md" was the wrong target and is withdrawn.** See the correction below: the 340 guard does not measure SKILL.md by design. It measures `$RIDX_F`, the routing index.

### Correction — the 340 guard measures the routing index, not the skill

**The frozen finding reproduces, and it defeats the operator choice this unit previously reported.** The guard is not a ceiling on the skill that happens to be aimed at `SKILL_F`; it is a ceiling on the *routing index* that currently falls on `SKILL_F` only because the index still lives there.

*Evidence, by direct inspection.* The harness already carries the split, stated in its own comment at L978–979: *"`WL2_ROUTER_FILE` lets a mutated copy be substituted, which is how the five required failing cases are demonstrated. **Existing checks keep reading `$SKILL_F`.**"* And the two families are bound to different variables in code:

- `routing_res()` at **L859** reads **`$SKILL_F`** — the routing *behavior* checks are already anchored to the skill and are unaffected by any repoint.
- `idx()` (L1002), `marked_idx()` (L1045) and `collide()` (L1070) read **`$RIDX_F`** — the index *inventory* checks follow the variable.

Across the whole `ridx` region (L1000–1160) every file reference is `$RIDX_F`; there are **zero** direct `$SKILL_F` references in that region — searched L1000–1160 for both names. So repointing `RIDX_F` at an extracted `references/routing-index.md` carries the index assertions to the file that then holds the index, and the 340 assertion at L1150 (`wc -l < '$RIDX_F'`) measures the artifact its own comment names: *"a guard against the index turning into a catalogue."*

**With Boundary A the arithmetic is comfortable.** The extracted index (L366–465, 100 lines, plus a title and read-me-when line ≈ 103) sits **237 lines under the 340 ceiling**, and `SKILL.md` falls to **517**.

**But the repoint is not a one-line change, and this is the part that constrains the implementation unit.** Thirteen `ridx` checks currently read `$RIDX_F` while testing content that stays in `SKILL.md` under Boundary A. They must be rebound to `$SKILL_F` in the same commit or they go red:

| Checks | Reads | Content stays in SKILL.md because |
|---|---|---|
| L1134, L1136 (`desc_line()`, L1132) | `awk 'NR<=6 && /^description:/'` | The YAML **frontmatter description is Codex's activation trigger**. A `references/` file has no frontmatter, so these two cannot follow the index under any boundary. |
| L1119, L1123, L1129 (`route_step()`, L1117) | `awk '/^## Routing/…'` | The `## Routing a request` H2 and its steps are routing **behavior**, which the brief's preservation list keeps in place. L1129 also asserts exactly one `^## Routing` heading exists. |
| L1125 | `grep -qi 'Direct Work'` | Admission language, protected by the same list. |
| L1088, the four-part loop at L1090–1091, L1093, L1095 (`result_block()`, L1087) | `awk '/^### What an intake result contains/…'` | L353–365 is the intake-result **contract** — behavior, not lookup — so Boundary A deliberately leaves it. |

**One consequence Codex must weigh, stated plainly.** After the repoint, **no executable check constrains `SKILL.md`'s own length**; it would sit at 517 under the advisory 300-line warning and the non-governing 500-line convention only. And a 340 ceiling over a ~103-line index leaves 237 lines of headroom, which defeats the guard's stated purpose — the harness comment justifies its number by noting *"340 leaves 9 lines of headroom, so the next addition still has to justify itself rather than sliding under an open-ended limit."* Preserving that intent means re-basing the number **down** to fit the index (roughly 115–120), and optionally adding a second ceiling bound to `$SKILL_F`. Both are technical calibration inside the implementation unit, not policy.

### Claim 4 — consumers and dependencies

- **HARD — marker-based extraction with byte-identical mirror parity.** `logs/scripts/work-loop-v2-core-resolver.test.sh` L56 extracts by marker (`awk '/work-loop-v2-core-resolution:start/{f=1;next} /work-loop-v2-core-resolution:end/{f=0} f'`), L114–115 runs it over **both** `.claude/commands/work-loop-v2.md` and this SKILL.md, and L116 asserts *"check 4 — deployed resolver blocks are byte-identical"* via `cmp -s`. **L26–132 cannot move, cannot be reflowed, and cannot be edited on one side only.** `core-resolver-worktree-fix-plan-v0.1.md` L118 states the same maintenance rule: *"Edit one, then copy the marked region into the other — do not retype it."*
- **BLOCKING ON EXTRACTION — the acceptance harness greps the index in place.** `work-loop-v2-slice-1.test.sh` carries 41 references to `$SKILL_F`/`$RIDX_F`, of which at least 28 `ridx` assertions test index content directly: *"the index holds 51 entries, none classified twice"* (L1033), *"all 25 indexed Matt names resolve under ~/.claude/skills/"* (L1037), *"all 26 indexed Axcíon commands resolve under .claude/commands/"* (L1040), *"exactly the 12 Claude-side-only skills carry the marker"* (L1051), and the three collision-block checks (L1071–1075). **Moving the index breaks these in the same commit unless they are repointed.** A repointing seam already exists and is documented as such — L978–980: *"`WL2_ROUTER_FILE` lets a mutated copy be substituted"* — so `RIDX_F` can be aimed at the extracted file, but that is an edit to the harness and must be part of the same unit.
- **NON-BLOCKING.** `.claude/hooks/pre-commit` validates folder naming, frontmatter presence/fields, and prohibited files on any staged `SKILL.md` (L53 `grep "SKILL.md$"`, path-agnostic). It prohibits `README.md`, `CHANGELOG.md`, `INSTALLATION_GUIDE.md`, `QUICK_REFERENCE.md` inside a skill folder — **`references/` is not prohibited.** `check-skill-size.sh` would warn at 300 and not block.
- **Deployment interaction — extraction travels.** The project installations are directory-level symlinks (`work-loop-v2 -> ../../../../ai-resources/.agents/skills/work-loop-v2`), so a new `references/` subdirectory inside the skill folder reaches the three projects with no manifest change. This does not conflict with the approved deployment.
- **Absence claim.** Searched the repository excluding `.git` and `logs/` for `work-loop-v2/SKILL.md`: every hit is prose in `plans/` referencing the file or historical line counts. Searched `logs/scripts/` for `core-resolution`: one hit, the resolver test above. **No consumer performs line-numbered extraction** (no `sed -n 'N,Mp'` or `awk NR` against this file); the only structural extraction is by marker.

Result: the size finding is **misattributed but not baseless.** The `>500 lines` basis does not govern a Codex-side skill, and the standard that does govern this file sets no number. A different rule does bind it, can fail, and is currently red: the 340-line ceiling in the repository's own acceptance harness, breached by 277 lines at 617.

Evidence: the determination could have read the other way at each step and did so unevenly — the Work Loop standard was searched for a number and returned none, `ai-resource-builder` was searched for Codex scope and returned no match, while the harness search returned a concrete binding path (`SKILL_F` L251) and a failing arithmetic comparison. The 340 breach is falsifiable by `wc -l`: at ≤340 the assertion passes. The harness was **not executed** — running it would write fixture state, which this unit's brief forbids — so the breach is reported as arithmetic against the assertion's own literal, not as an observed test run.

**Conclusion (revised by the correction): a compliance edit is required, on a corrected basis, and no operator choice is involved.**

The `>500` finding is accepted in substance and rejected in citation. The binding rule is the 340-line harness ceiling, not the 500-line skill-library budget.

The minimum safe boundary is **Boundary A — move the route indexes at L366–465 (100 lines) to `references/routing-index.md` inside the skill folder, and repoint the harness's default `RIDX_F` to that file.** This is bounded and technical throughout: the guard then measures the routing index it says it protects (≈103 lines against its ceiling), `SKILL.md` falls to 517, every index assertion follows the content it tests, and **no behavioral text moves** — so the brief's preservation list is satisfied in full.

**The previously reported 340-versus-restructure operator choice was false and is withdrawn.** It rested on reading the 340 ceiling as a limit on `SKILL.md`. The ceiling is bound to `$RIDX_F`, not to `$SKILL_F`, and the harness comment at L978–979 states the separation outright. Nothing here requires the operator.

Compatibility risks that must constrain the later implementation unit: (i) L26–132 is immovable and byte-parity-locked to the Claude command; (ii) the repoint is **not** a single-variable change — the thirteen checks tabulated above must be rebound to `$SKILL_F` in the same commit, and the two `desc_line` checks can never follow the index because a `references/` file carries no frontmatter; (iii) the Reorient gate must stay above the resolver block near the top; (iv) re-basing the ceiling down to fit the index (≈115–120) is needed to preserve the guard's stated headroom discipline, otherwise the repoint buys compliance at the cost of the guard's purpose.

Internal-contradiction check on this correction: the withdrawn Boundary C and the withdrawn operator choice are marked as withdrawn in place rather than deleted, so no earlier sentence still asserts a 340 limit on `SKILL.md`. Claim 1's table entry for the 340 rule reads *"Yes, by exact path"* — that remains true as the repository stands today, because `RIDX_F` currently defaults to `$SKILL_F`; it is the repoint that changes which artifact it binds, and the correction says so explicitly. Claim 2's map and Claim 4's dependency findings are untouched by this correction and still hold.

Repository state: **this unit wrote exactly one file, this state file.** No instruction file, script, setting, project file or user-level file was written; the harness was not run. `logs/friction-log.md` is excluded from the commit and was not edited by this unit — as Unit 2 established, hook telemetry appends one write-activity line per Write/Edit, so its hash moved from `1888b75d…92999ccf` without any deliberate change.

Deferrals noticed and not done: (i) the file's growth from 116 to 617 lines since MVP acceptance suggests the guard has been absorbing additions rather than constraining them, which is a trend worth a decision rather than another re-base; (ii) Unit 2's `runs no git` accuracy defect and the two unexplained project skill links remain open and outside this unit.

## Blocker

None. The frozen finding is resolved: the operator choice was false and is withdrawn, and the remedy is bounded and technical.

## Next action

Codex: closure check on the frozen finding only — is the `RIDX_F` reconciliation resolved, and did the correction introduce an internal contradiction? The correction reproduced the finding by inspection (`routing_res()` at L859 reads `$SKILL_F`; the index helpers read `$RIDX_F`; zero `$SKILL_F` references in L1000–1160), revised the conclusion to Boundary A with the repoint, withdrew the false operator choice in place, and recorded the thirteen checks that must rebind to `$SKILL_F` in the same commit. Nothing beyond this state file was changed and no harness was run.
