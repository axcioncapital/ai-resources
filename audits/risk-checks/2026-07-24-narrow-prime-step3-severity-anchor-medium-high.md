# Risk Check — 2026-07-24

## Change

PROPOSED CHANGE: Narrow the /prime Step 3 severity anchor in ai-resources/.claude/commands/prime.md so it no longer matches `medium-high`, and add a one-line count of medium-high entries to the existing python count block.

EXACT DIFF (3 edits, all within Step 3, prime.md:238-269):

1. Line 245 — remove `medium-high|` (12 chars) from the alternation:
   BEFORE: Bash(grep -nE -B6 "^-? ?\*\*Severity:\*\* *\*{0,2}(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md)
   AFTER:  Bash(grep -nE -B6 "^-? ?\*\*Severity:\*\* *\*{0,2}(high|HIGH|critical|urgent)" logs/improvement-log.md)

2. Lines 247-254 — extend the EXISTING python count block to also count medium-high entries and print `MEDIUM-HIGH: {u} entries not shown — see /open-items` when u>0. Same count-don't-show shape as the existing UNCLASSIFIED line. Reuses the same single open() and header walk already there — no new file read.

3. Lines 257-268 — documentation: add a paragraph stating why medium-high is counted not shown, and reword the filter rule at :267-268 so it names `medium-high` explicitly.

PROBLEM REALITY (measured by execution today, 2026-07-24, in the ai-resources checkout):
- Live Step 3 emit: 319 lines / 71,710 chars / 40 hits.
- Per-tier `grep -cE`: critical=0, high=12, medium-high=29.
- Emit with medium-high removed (modified grep actually run): 95 lines / 22,294 chars / 12 hits — ~70% reduction.
- So ~224 of 319 emitted lines are medium-high entries.
- THE CORE DEFECT IS A CONTRADICTION, NOT COST: the step's own filter at prime.md:267-268 says "Include an item only if it carries a HIGH-severity marker (`HIGH`, `urgent`, `critical`, or `do-now`)" and "Exclude anything marked `LOW` or `MED`". `medium-high` is named by NEITHER rule. So the anchor fetches ~224 lines that the filter arguably discards. Cost saving is a consequence of resolving the contradiction, not the sole justification.

FALSIFICATION TESTS ALREADY RUN BY EXECUTION (please re-run rather than trust):
- `printf -- '- **Severity:** medium-high — test\n' | grep -cE '<new anchor>'` → 0 (bare `high` does NOT wrongly match medium-high).
- `printf -- '- **Severity:** **high** — test\n' | grep -cE '<new anchor>'` → 1 (bolded value still matches — the 2026-07-19 `\*{0,2}` widening preserved).
- `printf -- '**Severity:** high — test\n' | grep -cE '<new anchor>'` → 1 (un-dashed variant still matches — the 2026-07-18 `-? ?` widening preserved).
- LOAD-BEARING EXCLUSION re-verified: `sed -n '13p' logs/improvement-log.md | grep -cE '<new anchor>'` → 0. improvement-log.md:13 is the log's own schema-vocabulary declaration line and must never match.

EDIT 2 TESTED IN ITS SHIPPING SHAPE (this is the check the 2026-07-19 S2-04b gate found missing — that session gated a design it had never run as shipped):
Expected values were declared BEFORE the run. Declared: UNCLASSIFIED=0, MEDIUM-HIGH=29. Actual output:
  UNCLASSIFIED: 1 of 134 entries carry no Severity field
  MEDIUM-HIGH: 29 entries not shown — see /open-items
The UNCLASSIFIED=1 mismatch was investigated: it is the pre-existing 2026-07-21 "PowerPoint production capability" entry, which carries no Severity field. Verified pre-existing by diffing against the pre-triage blob (`git show fc977a2^:logs/improvement-log.md`) — count was already 1 before today's work, and today's commit did not touch that entry. So the code is correct and the expectation was wrong.

CONSUMER INVENTORY (re-measured today with `find . -name prime.md -path "*/.claude/commands/*"` plus a per-path `[ -L ]` test from the workspace root — the backlog entry's "25 consumers / 23 symlinks" figure is STALE, do not inherit it either):
- 31 total consumers = 28 symlinks + 3 real files.
- Of the 3 real files, ONLY ai-resources/.claude/commands/prime.md carries the Step 3 anchor (7 `Severity` hits). The other two — workflows/research-workflow/.claude/commands/prime.md and projects/axcion-sector-intelligence/.claude/commands/prime.md — have 0 hits; they are stubs, inert with respect to this change.
- So 28 symlinked consumers auto-propagate; 2 real-file copies are unaffected.

PRIOR GATE HISTORY ON THIS EXACT SURFACE — weigh it; this is the THIRD attempt:
- 2026-07-19 (S2-04b) RECONSIDER: Usage Cost High + Blast Radius High. Design embedded a 172-line / 7,396-char parser into prime.md. Killed because it measured runtime output but never its own static weight; total cost rose in 13 of 19 project logs.
- 2026-07-19 (S6-e72) RECONSIDER: Blast Radius High + Hidden Coupling High, on a design adding a new unhardened Status-field parsing surface.
- The present change differs in kind: it REMOVES 12 characters from an existing regex and adds ~4 lines to an existing block. Static weight DECREASES. No new parsing surface. But I am the third session in this area and may share the earlier blind spots — RE-DERIVE, do not accept my framing.

OPERATOR DECISION ALREADY TAKEN: presented with three options (narrow-and-count / keep-and-fix-the-filter-text / show-compactly) plus measured impact for each, the operator chose narrow-and-count.

RESIDUAL CONCERN I SPECIFICALLY WANT SCORED (do not soften it): 29 medium-high entries that currently reach the task menu will stop reaching it. If the correct reading is that the ANCHOR was right and the FILTER TEXT was stale, this change silently removes real work from the operator's primary orientation channel, and a count line is a weaker signal than a menu item. The sibling entry at improvement-log.md:127 documents that a zero-hit scan is indistinguishable from "nothing urgent," and this change moves 29 items toward that failure mode. Score explicitly whether the count line is sufficient mitigation, and whether the anchor-vs-filter contradiction is genuinely resolved in the right direction. Note also: today's session, running the CURRENT anchor, surfaced medium-high entries onto the menu tagged `[urgent]` — i.e. live behaviour follows the anchor, not the filter text.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

RECONSIDER

**Summary:** The regex/count edit is technically clean and static weight genuinely decreases, but the change resolves a real internal (anchor-vs-prose) contradiction in prime.md by silently overturning a deliberate, dated, cross-file design contract — documented in `session-feedback-collector.md` and `wrap-session.md` — that `medium-high` is the intended second tier reaching the `/prime` task menu, and the claimed "correct direction" of the fix is contradicted by that evidence.

## Consumer Inventory

Two distinct consumer classes were re-derived: (A) file-level copies of `prime.md` that run Step 3's scan, and (B) documentation/contract-level consumers that state, as current guidance, what severity tiers reach the `/prime` task menu. CHANGE_DESCRIPTION's own inventory covers only class (A). Class (B) was found independently in this pass and is the material gap driving Blast Radius / Hidden Coupling below.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/prime.md (canonical) | invokes (carries the Step 3 anchor, 7 Severity hits) | yes — this is the edit target |
| 28× symlinked `.claude/commands/prime.md` across project repos | invokes (auto-propagate via symlink) | no — compatible, inherit the edit automatically |
| workflows/research-workflow/.claude/commands/prime.md (real file) | invokes (stub, 0 Severity hits) | no — inert w.r.t. this change |
| projects/axcion-sector-intelligence/.claude/commands/prime.md (real file) | invokes (stub, 0 Severity hits) | no — inert w.r.t. this change |
| logs/improvement-log.md:13 (schema/vocabulary declaration) | documents (asserts current anchor behaviour: "surfaces only `high` / `medium-high` / `critical` / `urgent` hits as task-menu candidates") | **yes — becomes an inaccurate self-description of the scan's own behaviour if unedited** |
| .claude/agents/session-feedback-collector.md:108-146 | documents (writer-facing contract: "`high` / `medium-high` → reaches the `/prime` task menu. Use for anything that should be *worked on*... If a finding deserves action, it needs `medium-high` or above") | **yes — actively misleads future finding-authors if unedited; a "medium-high" write would silently become unreachable, the exact failure mode this file exists to prevent** |
| .claude/commands/wrap-session.md:296-304 | documents (identical claim: "Only `high` and `medium-high` reach the `/prime` task menu... That is legitimate triage — but *choose* it, do not back into it.") | **yes — same defect as above** |
| logs/decisions-archive-2026-07.md:498, various audits/risk-checks/2026-07-19-*.md, improvement-log-archive.md (multiple), session-notes.md (multiple) | documents (historical records of the anchor pattern / prior gate outcomes) | no — archival, not live guidance |
| prompts/codex-prime-step3-scan-cost-consultation.md | documents (point-in-time external-consult prompt) | no — historical artifact |

Total: **35 distinct consumers found** (31 file-level + 4 documentation-level with the schema note counted once), of which **3 are must-change but NOT covered by the proposed 3-edit plan** (`logs/improvement-log.md:13`, `session-feedback-collector.md`, `wrap-session.md`) — none of these are touched by the described diff, which only edits `prime.md`. This gap was not in CHANGE_DESCRIPTION's own inventory (which asked only "who has a copy of prime.md," not "who documents what medium-high means").

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Runtime emitted content drops substantially: 41 hits / 327 lines / 72,250 chars (re-derived live total, see Dimension 7) → 12 hits / 95 lines / 22,294 chars with the modified anchor — a genuine reduction, not merely a claimed one.
- Static addition to `prime.md` is small: ~4-line extension to the existing python count block plus one documentation paragraph — well under the ~150-token High threshold, and the file is invoked per `/prime` call, not per tool call or per turn.
- No new hook, no new `@import`, no new subagent spawn.

### Dimension 2: Permissions Surface
**Risk:** Low

- Pure regex/text edit inside an existing, already-authorized `Bash(grep ...)` call and an existing python heredoc. No new tool family, no new Write/Read path, no settings.json change.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory above: 28 symlinked `prime.md` copies auto-propagate compatibly (no issue), and 2 real-file stubs are inert (0 Severity hits) — CHANGE_DESCRIPTION's own re-derived figures here check out.
- The material finding: **`session-feedback-collector.md` and `wrap-session.md` are must-change consumers of the contract this edit silently reverses, and neither is in the 3-edit plan.** Both files currently instruct future finding-authors, in force, that "`medium-high` → reaches the `/prime` task menu" and "if a finding deserves action, it needs `medium-high` or above." After this change ships, an author following that documented guidance to the letter will write `medium-high` on a finding they intend to reach the menu, and it will not — the exact "structurally invisible" failure mode `wrap-session.md:296` names as "this repo's most expensive recurring failure."
- This is a contract change that is **not backwards-compatible** for those two callers (per the Dimension 3 rubric, that alone is sufficient for High), and it is undetected by CHANGE_DESCRIPTION's own consumer inventory because that inventory searched for "who runs prime.md," not "who documents the severity-routing contract."

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit (`prime.md` only, per the stated 3-edit plan). Clean `git revert` fully restores prior behaviour with no sibling files, no data/log mutation, and no state pushed beyond the local repo.

### Dimension 5: Hidden Coupling
**Risk:** High

- The change treats `prime.md`'s own internal prose (lines 267-268) as the sole authority on what the Step 3 filter should admit, without accounting for the parallel, actively-maintained definition of the same concern that lives in `session-feedback-collector.md` and `wrap-session.md`. Two systems purport to define "what severity reaches the `/prime` menu" — the change resolves the conflict unilaterally inside `prime.md` and leaves the other definition standing, unreconciled and now wrong.
- This is functional overlap with an existing mechanism (per the Dimension 5 High criteria): the severity-routing contract is currently asserted in three places (`improvement-log.md:13`, `session-feedback-collector.md`, `wrap-session.md`), and the change edits only one of the three without checking the other two — an implicit dependency the change does not name.

### Dimension 6: Principle Alignment
**Risk:** High

- Principles-base read at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/principles-base.md`. Relevant IDs: **OP-11** ("Surfacing tacit principles is a recurring obligation... practice-vs-principle divergence must be surfaced and resolved loudly... never silent drift") and **OP-3** ("Any principle revision... must be loud and deliberate (pairs with OP-11)").
- The severity-routing design — `medium-high` as a deliberately-chosen second tier that reaches the `/prime` task menu, distinct from `medium`/`low` which are recorded but deferred — is an explicit, dated, cross-file policy (`session-feedback-collector.md`, `wrap-session.md`), not an accident. This change revises that policy (collapses two menu-reaching tiers to one) but frames itself purely as "resolving an internal contradiction" in `prime.md`'s own prose, never as a policy revision, and does not touch either of the two files that state the policy, nor does it add a recorded `decisions.md` entry documenting the revision as such.
- This is a clear, unacknowledged principle violation, not a mere tension: **the redesign in the change's own edit 3 ("reword the filter rule... so it names `medium-high` explicitly") locks in the exclusion as if it were merely a documentation correction, when the weight of cross-file evidence says the exclusion is the actual policy change.** Per the special-handling rule, this forces the verdict regardless of the other dimensions' scores. Which remedy path applies: **rescope** — see Recommended redesign below.

### Dimension 7: Problem Reality
**Risk:** High

- **Defect — observed or inferred?** Observed, and correctly stated as far as it goes: I independently re-ran `grep -nE -B6` with and without `medium-high` and confirm the internal prime.md contradiction is real — the prose filter at :267-268 names neither `medium-high` in its include list nor in its exclude list. That half of the claim is accurate.
- **Consequence — traced or assumed?** The claimed consequence — "the correct resolution is to narrow the anchor to match the filter text, because the anchor over-fetches relative to the filter" — is **contradicted by evidence found this pass**, not merely unproven. Three files assert the opposite resolution as deliberate, dated policy:
  - `logs/improvement-log.md:13` (2026-07-18, S6-ac5): "`/prime` Step 3's orientation scan anchors on `^-? ?\*\*Severity:\*\*` and surfaces only `high` / `medium-high` / `critical` / `urgent` hits as task-menu candidates."
  - `.claude/agents/session-feedback-collector.md:138-142`: "`high` / `medium-high` → reaches the `/prime` task menu. Use for anything that should be *worked on*... If a finding deserves action, it needs `medium-high` or above — anything less is a decision to defer it indefinitely."
  - `.claude/commands/wrap-session.md:304`: "Only `high` and `medium-high` reach the `/prime` task menu; `medium` / `low` are recorded but surface only via `/open-items`. That is legitimate triage — but *choose* it, do not back into it." (Note the second sentence is a direct, prior warning against exactly the failure mode this change risks: narrowing menu-reach as an incidental side effect of a "contradiction fix" rather than as a chosen, stated triage decision.)
  - Given this, the change's own explicitly-requested "residual concern" question — "is the contradiction genuinely resolved in the right direction?" — is answered **no**: the weight of dated, cross-file, machine-consumer documentation says the anchor (which includes `medium-high`) is the correct half of the pair, and the prose filter at :267-268 (which never named `medium-high`) is the stale half. The fix direction in the proposed change is backwards.
  - On the residual concern's second question — is the count line sufficient mitigation? — **no.** The change's own cited sibling entry (originally at improvement-log.md:127; re-derived today at line 119 due to an intervening commit — see re-derivation note below) states plainly that a silent zero/near-zero signal "is indistinguishable from 'nothing urgent.'" A count line is exactly that class of weaker signal, replacing 29 live menu-eligible items with one line an operator can pass over.
- **Re-derivation vs. the change description:**
  - `medium-high` count: re-derived as **29** — matches CHANGE_DESCRIPTION exactly.
  - `UNCLASSIFIED` count: re-derived as **1 of 134** — matches CHANGE_DESCRIPTION exactly (this part of the change description is solid, and its own self-correcting investigation of the mismatch is sound methodology).
  - Total live-anchor hit count: CHANGE_DESCRIPTION states "40 hits" for the current (unmodified) anchor; my independent `grep -cE` (no `-B6`) returns **41** (12 high + 29 medium-high + 0 critical + 0 urgent = 41, self-consistent with the tier breakdown CHANGE_DESCRIPTION itself gives, which also sums to 41, not 40). Likely cause: a same-day commit (`2dbd599`, "session: 2026-07-24 (S1-7fe) wrap") added one new `medium-high` entry to `improvement-log.md` between the change description's measurement and this re-derivation — itself, notably, an entry about "a multi-clause defect claim was closed on partial verification... twice in one session." Minor and explainable, but it is a real discrepancy between the stated figures and what is on disk now, and per the rule the re-derivation stands as authoritative.
  - The sibling-entry citation "improvement-log.md:127" is now at line 119 in the live file (shifted by the same commit); content match confirmed, line number does not.
  - No discrepancy found in the consumer-inventory total (31) — matches exactly.
- **Assessment:** the internal-contradiction defect is real and observed; the claimed correct-direction resolution is contradicted by cross-file evidence found this pass. Per the framework this is High, not Medium — it is not merely "consequence inferred," it is "consequence found to point the other way."

## Recommended redesign

- **Rescope, do not narrow the anchor.** Keep `medium-high` in the Step 3 grep alternation — it matches the dated, cross-file, machine-consumer contract in `session-feedback-collector.md` and `wrap-session.md`. Instead, fix the actually-stale half: reword `prime.md`'s own prose filter at :267-268 to explicitly list `medium-high` alongside `HIGH` / `urgent` / `critical` / `do-now` in the include rule. This resolves the same internal contradiction CHANGE_DESCRIPTION correctly identified, in the direction the rest of the system already documents.
- **If cost reduction is still wanted, attack it without collapsing the severity tier.** Two lower-risk levers are already visible in this repo's own history: (a) a log-hygiene triage pass on the 29 `medium-high` entries (the same technique the operator's own S1-7fe session used today on 30 HIGH entries, which found several already resolved/stale) — this shrinks the emit by closing entries that no longer earn the tier, not by hiding ones that still do; (b) the "show-compactly" option from the three originally presented to the operator — compact/dedupe `medium-high` items into fewer menu lines rather than a count line, so they remain reachable.
- **If, after weighing this, the operator still wants `medium-high` to stop reaching the task menu, that is a legitimate call — but it must be made loud (OP-11), not silent.** Ship it as an explicit policy revision: update `session-feedback-collector.md` and `wrap-session.md`'s writer guidance in the same commit (so future authors are told the true, narrower threshold), and record the revision and its rationale in `logs/decisions.md` rather than folding it into a "fix a contradiction" framing.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
