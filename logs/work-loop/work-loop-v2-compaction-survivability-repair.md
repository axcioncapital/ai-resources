---
task: work-loop-v2-compaction-survivability-repair
turn: codex
---

## Objective and scope

Make Work Loop v2 reliably recover its authoritative task after Codex compaction in every intended Work-Loop-enabled project, without adding parallel state, weakening actor boundaries, or duplicating recovery authority. The task exits only when the instruction layer is review-clean, the approved deployment scope is installed, and one representative project-repository compaction proves recovery or a safe stop.

In scope across the task: the instruction-layer correction following commit `df35ddd`; deployment only to verified Work-Loop-enabled projects and future eligible scaffolds; the operator-approved user-level compact-hook carrier; proportionate operational proof. Excluded: distributing these skills to every project, a five-compaction endurance exercise, broad Work Loop redesign, a second recovery artifact, and approving or rewriting the executable core without a later explicit operator decision.

## Lane and unit

Standard. Implementation mode. Unit 4 — extract the routing index into one referenced resource and align its acceptance harness without moving Work Loop behavior.

Named reason for the loop: the repair crosses sessions and repositories, needs bounding before deployment, and requires independent assessment of Claude's evidence before changes propagate to project environments.

Why this unit, why now: Unit 3 established that the original `>500 lines` citation was inapplicable but that the routing-index guard is genuinely mis-aimed because the index still lives inside the main skill. Extracting only that lookup content resolves the accepted finding while preserving the behavioral contract needed before deployment.

Governing authority: the accepted Unit 3 discovery and correction; the Work Loop writing standard's qualitative attention and leanness requirements; the existing harness comment that the ceiling protects the routing index rather than expressing operator authority. The operator's `approved clauses only` decision remains binding, and this unit must not alter or promote executable-core content.

Codex framing decision: this unit contains one structural deliverable—the routing-index extraction and the harness alignment required to keep that extraction verified. Deployment edits, user-level settings, project changes, operational proof, the `runs no git` accuracy defect, unexplained project skill links, and the deferred hook-pointer duplication concern remain outside because each has a different deliverable.

Pre-implementation risk review, completed by Codex before opening the unit:

1. **Authority:** moving lookup text must not change actor boundaries, protocol tokens, admission, or executable-core authority.
2. **Behavior:** the skill must explicitly load the reference when routing requires the index; otherwise extraction silently removes routing capability.
3. **Dependencies:** the marked resolver block is byte-parity locked and must remain untouched; index inventory checks must follow the new file while behavior/frontmatter checks remain on the skill.
4. **Compatibility:** project installations are directory-level links, so the reference should travel with the skill; Claude must verify that claim before relying on it.
5. **Guard integrity:** repointing must not create 237 lines of meaningless headroom; the index ceiling must be recalibrated tightly enough to preserve its stated purpose.
6. **Reversibility and scope:** one reference file plus the minimum skill and harness edits is locally reversible; no project or user setting belongs in this unit.
7. **Validation:** evidence must show the pre-change failing size condition, post-change relevant harness success, resolver parity, correct index inventory, and no unintended behavior-section movement.

## Brief

Required outcome: move only the route-index lookup material identified as Boundary A into one directly referenced file inside the `work-loop-v2` skill directory, make the main skill load it at the routing decision point, and update the acceptance harness so each check reads the artifact whose behavior it verifies.

Check against the repository:

1. Verify the Unit 3 line boundaries and consumers against current files before editing. If the index boundary or harness-variable account has drifted, stop and hand back rather than improvise.
2. Preserve in `SKILL.md` all routing behavior, the intake-result contract, repository-problem reference, mode rules, admission, seam, Reorient gate, exact protocol tokens, and the complete marked resolver block. Move only the route inventories, non-route classifications, and collision table identified by Boundary A.
3. Add an explicit instruction at the routing index read point that requires reading the complete referenced file when selecting an owner. Keep one semantic owner for each route entry; do not leave a second inventory copy in the main skill.
4. Align the harness: index inventory and collision checks follow the extracted index; the thirteen frontmatter, routing-behavior, admission, and intake-contract checks identified by Unit 3 remain bound to `SKILL.md`. Recalibrate the index ceiling with narrow justified headroom based on the resulting file, rather than retaining 340 automatically.
5. Verify the reference travels through the existing directory-level project skill links, but make no project, manifest, template, user-level, or deployment edit.

Required evidence capable of failure:

- Record the failing pre-change condition using the literal line arithmetic against the existing guard before editing; do not construct a fixture solely to prove it.
- Run the relevant Work Loop acceptance harness after the edit and report its exit and check summary. If it writes fixtures, use its established safe invocation/cleanup behavior and report any residue.
- Run the resolver parity test and report success, proving the protected marked block was not disturbed.
- Report before/after line counts for the skill and extracted index, the new ceiling and headroom, and evidence that every expected route entry still appears exactly once.
- Show that behavior/frontmatter checks still target `SKILL.md` and index checks target the reference; evidence must distinguish the two paths.
- Confirm changed paths are limited to the skill, its one routing reference, the acceptance harness, and this state file. Report automatic `logs/friction-log.md` telemetry separately and exclude it from the commit.
- Set `turn: codex` and commit the discovery handback. Do not push.

Completion condition: the routing lookup has one owner, routing behavior remains in the main skill, the correctly targeted guard and relevant harness pass, resolver parity remains intact, and the bounded implementation is committed for Codex assessment.

Stop and hand back if Boundary A or the harness-variable split is false, if safe harness execution cannot be established, or if the change requires moving behavioral text or touching the resolver block. Stop for the operator only if a consequential scope or policy choice emerges. A false premise is a valid result; report it rather than broadening the extraction.

## Latest result

Implementation unit. Every premise held; the extraction was implemented as briefed.

```
Inspected (2026-08-13):
- Claim (1) Boundary A has not drifted: HOLDS — `wc -l .agents/skills/work-loop-v2/SKILL.md` = 617,
  exactly Unit 3's figure. `sed -n '366,465p'` = 100 lines, opening at
  `### The index — Axcíon commands that may own a request (16)` (L366) and closing at the blank line
  before `## Admission — Direct Work or the loop` (L466). The range carries the five `### The index —`
  sections, `### The index — names that are not routes`, `### Naming a colliding capability` and
  `### When the owner is Claude-side only`; the last of these is inside Unit 3's line range though its
  prose enumeration omitted it, and the harness account below only reconciles when it is included.
- Claim (2) the harness-variable split is real: HOLDS — searched harness L1000–1160 for `SKILL_F`;
  no match, so every assertion in the `ridx` region read `$RIDX_F`. `routing_res()` (L859) reads
  `$SKILL_F` and was already unaffected. Counted the checks reading `$RIDX_F` while testing content
  Boundary A leaves in the skill: 2 `desc_line`, 3 reading `^## Routing` (`route_step`,
  `never acquires one`, the single-`## Routing` clause of the continue check), 1 `Direct Work`,
  and 7 `result_block` — 13, matching Unit 3 exactly.
- Claim (3) the guard was red before the edit: HOLDS — harness L980 `RIDX_F="${WL2_ROUTER_FILE:-$SKILL_F}"`
  and L1150 `[ "$(wc -l < '$RIDX_F')" -le 340 ]`, against a 617-line file: 617 > 340, breach 277.
  Confirmed by running the harness unmodified, not by arithmetic alone.
- Claim (4) the resolver block is parity-locked and must not move: HOLDS — markers at SKILL.md L26/L132
  and `.claude/commands/work-loop-v2.md` L14/L120; `work-loop-v2-core-resolver.test.sh` L114–116 `cmp -s`
  asserts byte identity. Boundary A starts at L366, so the block was never in scope.
- Claim (5) the reference travels through directory-level project links: HOLDS — all three project
  links are directory symlinks to `.../ai-resources/.agents/skills/work-loop-v2`, and the pre-existing
  `references/repository-problem-resolution-sop.md` resolves through each of them today. Qualified
  below: that proves the mechanism, not this branch's file.
```

Result: the route inventories now have one owner. `references/routing-index.md` (107 lines) holds
Boundary A verbatim; `SKILL.md` fell 617 → 526 and carries a `### The routing index` pointer plus an
amended routing step 2, both requiring the referenced file be read complete before an owner is named.
Zero route bullets remain in `SKILL.md` (`grep -c '^- \`'` = 0) and the index holds 51 entries with no
duplicate head token, so no second inventory copy exists. The harness now reads each artifact whose
behavior it verifies: `RIDX_F` defaults to the extracted index, and the thirteen frontmatter,
routing-behavior, admission and intake-contract checks were rebound to `$SKILL_F`. The ceiling was
re-based 340 → 116, keeping the 9-line headroom the previous re-base used rather than inheriting 237
lines of meaningless slack.

Evidence:

- **Pre-change, unmodified harness:** exit 1, `passed: 292 failed: 3` — `FAIL ridx the skill stays
  under its 340-line ceiling`, plus two `3.1a` failures. **Post-change:** exit 1, `passed: 293
  failed: 2`. The ceiling check is green and no check regressed.
- **The two remaining failures are pre-existing and outside this unit** — `3.1a no state file was
  opened for the direct request` and `3.1a every task-state file present is one this build created
  deliberately`. Both are red identically in the pre-change run; they count the task-state files in
  `logs/work-loop/`, which this unit did not touch.
- **The two paths are distinguishable, proved in both directions.** Pointing `WL2_ROUTER_FILE` at an
  index copy with one route entry deleted turns exactly four index checks red (`the 16 Axcíon primary
  commands`, `51 entries none classified twice`, `all 26 indexed Axcíon commands resolve`, `51 entries
  none of them excluded names`) and leaves all thirteen rebound checks green. Mutating `SKILL.md`
  itself (`never acquires one` → `never gains one`) turns exactly one rebound check red — `ridx only
  an admitted Work Loop unit acquires a mode` — and leaves every index check green. `SKILL.md` was
  restored from backup and verified by SHA-256 as byte-identical.
- **The re-based ceiling can still fail:** the index padded to 117 lines returns `FAIL ridx the
  routing index stays under its 116-line ceiling`. At 107 it passes, so headroom is 9.
- **Resolver parity intact:** `work-loop-v2-core-resolver.test.sh` → `4 passed, 0 failed`, including
  `check 4 — deployed resolver blocks are byte-identical`.
- **Harness residue:** none. It writes only `mktemp` temporaries and removes them; the three mutated
  copies used above were written to the session scratchpad, never into the repository.
- **Changed paths:** `.agents/skills/work-loop-v2/SKILL.md`,
  `.agents/skills/work-loop-v2/references/routing-index.md` (new),
  `logs/scripts/work-loop-v2-slice-1.test.sh`, and this state file. No project, manifest, template,
  user-level or deployment file was touched. `logs/friction-log.md` moved by automatic hook telemetry
  only and is excluded from the commit.

Qualification on claim (5), stated rather than smoothed over: the project links resolve into the
canonical `ai-resources` checkout (branch `main`), not into this worktree (branch
`session/2026-08-13-compaction-survivability`), so `references/routing-index.md` is **not** visible
from the three projects yet. What is verified is the mechanism — the links are directory-level, and an
existing `references/` file reaches all three today — so the new file travels with no manifest change
once this branch reaches that checkout. No deployment step was performed, as the brief requires.

Deferrals noticed and not done:

1. After the repoint, no executable check constrains `SKILL.md`'s own length. It sits at 526 under the
   advisory non-blocking 300-line hook warning and the non-governing 500-line convention only. Unit 3
   flagged a second ceiling bound to `$SKILL_F` as optional; the brief scoped this unit's
   recalibration to the index ceiling, so it was not added.
2. `SKILL.md` growing 116 → 617 → 526 since MVP acceptance is still a trend rather than a one-off, as
   Unit 3 recorded. Re-basing a guard is not a decision about that trend.
3. Unit 2's `runs no git` text-accuracy defect and the two unexplained project skill links remain open
   and outside this unit, as the brief requires.

## Blocker

None.

## Next action

Codex: assess the bounded routing-index extraction and harness alignment. Judge whether the index has
one owner, whether the rebound harness reads the right artifact per check, whether the 116-line ceiling
is calibrated defensibly, and whether the qualified claim-(5) travel evidence is sufficient without a
deployment step. Then decide close, continue, correct once, or stop.
