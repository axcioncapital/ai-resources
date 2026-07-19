# Risk Check — 2026-07-19

## Change

PROPOSED CHANGE — mission-contract subsystem, `/mission` command. This RE-GATES a design that already returned RECONSIDER once. The re-score of the redesign STALLED at 600s and returned no verdict, so RECONSIDER stands unchallenged and nothing was built. Score the design below and answer questions (a), (b), (c) EXPLICITLY — the prior gate's stall left them unanswered and they are the reason this is back in front of you.

## What is proposed

Two changes to `ai-resources/.claude/commands/mission.md` (86 lines, `model: sonnet`):

**A. `check` reads the validation contract before ticking (currently it does not).** Today `check` (Step 5, mission.md:66-72) reads only `## Open threads`, matches a substring case-insensitively, flips `- [ ]` to `- [x]`, and per `:71` changes "nothing else" — it never opens `## Validation contract`. Proposed:
1. `check` parses `## Validation contract` SEPARATELY from `## Open threads`, printing acceptance assertions enumerated 1..N. The separate parse is required, not stylistic: acceptance assertions are THEMSELVES `- [ ]` checkboxes (repo-health-backlog-2026-07.md:54-59), so a whole-file checkbox scan would collide with the thread list.
2. `check` requires `--assertion <N|none>`. `<N>` must resolve against the PARSED contract — a closed set validated against actual file content. This is the proposed distinction from the previously-rejected free-text `--evidence` field: it cannot be satisfied with arbitrary noise.
3. `none` is permitted but requires `--why "<reason>"`. Some threads genuinely serve no single assertion (thread 14 is a live instance); forcing a false mapping would manufacture the very wrong-tick the change exists to prevent.
4. The assertion choice (or `none` + why) and the evidence string are recorded under the ticked thread — visible to the next reader, to `/prime` Step 1d, and to `/drift-check`.
5. DECLARED RESIDUAL (recorded, not hidden): `check` still does NOT execute the cited evidence command. Executing arbitrary argument text is its own hazard, and session S11-637 established in this repo that a child process does not inherit the session's shell shadowing — so an executed check could report "clean" against a demonstrably blind shell.

**B. New `update <id>` verb.** `mission.md:4` exposes `create|list|read|check|close` while `:12` forbids hand-editing `## Open threads`. Revising a thread list is therefore unsanctioned — and has been done by hand twice. `update` would revise the thread list with a frozen-section byte-identity guard (Goal / In-scope-Out-of-scope / Validation contract must remain byte-identical). NOTE: the PRIOR GATE ALREADY CLEARED this verb — "well-justified and not the concern", with both hand-edit precedents re-verified by direct quote. Re-score it only if the changed context below alters that judgment.

## Why the PREVIOUS design was rejected — do not re-propose it

The prior design required a `--evidence` argument holding a command or a `file:line`. Rejected at Principle alignment HIGH because the check was PRESENCE-ONLY: it never re-ran the command nor re-opened the line, so an author fills the field with whatever satisfies the parser. That is functionally "another checklist", forbidden by this mission's own non-negotiable (repo-health-backlog-2026-07.md:63 — "No new gate to solve a discipline problem... the countermeasure that has worked here is an adversary told to distrust the author, not another checklist") and by thread 12's own text.

## THREE QUESTIONS YOU MUST ANSWER EXPLICITLY

(a) Does the closed-set `--assertion` escape the "another checklist" finding, or is `none` an escape hatch every ticker takes, making the mechanism optional in practice? THIS IS THE CRUX — if `none` + `--why` is the path of least resistance, the closed set buys nothing and this is the 8th "inert safeguard".
(b) Is recording the mapping AT TICK TIME an acceptable substitute for a declared thread→assertion schema field, or does it merely relocate the same unverified claim?
(c) Is the rejected alternative — a declared assertion field in the mission-contract schema — the honest fix this substitution is avoiding? The prior rejection rested on a file count that was WRONG; see verified fact 2 and score (c) against the corrected scope.

## VERIFIED FACTS — as submitted by the calling session (re-derived independently below; NOT accepted on inheritance — see Dimension 7)

1. CONSUMER INVENTORY. `mission.md` is carried by 19 paths: 18 symlinks + 1 real canonical file.
2. MISSION-CONTRACT COUNT IS 2 LIVE, NOT 5 (claimed). `git ls-files logs/missions templates/mission-contract.md` → 3 files in the active dir, 3 under `archive/`, 1 stray non-contract file. The third "active" file, `promote-rw-canonical.md`, is a tombstone stub. Claimed: exactly two live mission contracts. Claimed: score (c) against 3 files, not 6.
3. THREAD 12'S ASSERTION IS INFERABLE THOUGH UNDECLARED — acceptance assertion 5 (repo-health-backlog-2026-07.md:58) matches thread 12's own subject.
4. THE LIVE CONTRADICTION STILL HOLDS, line numbers corrected — threads 1 and 2 sit `[x]` at :95/:96; acceptance assertion 1 (:54) is unmet (222-line/~48KB scan against a <40-line budget).
5. THE STATUS-LESS-FILE EDGE CASE DISSOLVES — `promote-rw-canonical.md` is a tombstone stub, invisible by design; no verb behaviour need be defined.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/research-workflow-deploy-fitness.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/mission-contract.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists (carried redesign at lines 40-63)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-18-mission-check-evidence-citation-and-update-verb.md — exists (the standing RECONSIDER)

## Verdict

RECONSIDER

**Summary:** Two independent High findings, either one alone sufficient to force RECONSIDER — the closed-set `--assertion` mechanism is a credible 8th instance of the repo's "inert safeguard" pattern because it validates that a cited assertion *exists*, never that it is *true*, and `none`+`--why` is the path of least resistance for exactly the cases that matter (Dimension 6, unacknowledged); and the change description's own central "corrected" fact — that the schema-migration surface is 3 files, not 6 — is itself wrong: an independent workspace-wide re-derivation finds 4 active mission-contract files (not 2), because the caller's instrument (`git ls-files`, run inside a single repo) cannot see mission files that live in *other* project repos (Dimension 7).

## Consumer Inventory

Search method: `find … -path "*/commands/*" -type l` / `-type f` for `mission.md`; `git ls-files logs/missions templates/mission-contract.md` (ai-resources repo only, then independently repeated workspace-wide via `find`+`grep` across `projects/*`); `command grep -rliI --exclude-dir=.git "mission\.md"` and `"Validation contract"` across `ai-resources` and the workspace root (`..`); direct reads of `prime.md` (Step 1d, 8m), `drift-check.md`, `session-start.md`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` (Step 1d, 8m) | parses (`status: active`, `## Open threads` unchecked `- [ ]` lines; `MISSION_ID` pass-through) | no |
| `ai-resources/.claude/commands/drift-check.md` (Step 7a) | parses (`## Goal`, `## In scope/Out of scope`, `## Validation contract`) | no |
| `ai-resources/.claude/commands/session-start.md` | parses (`{mission:<id>}` token — pass-through only, never reads the mission file body) | no |
| `ai-resources/docs/session-marker.md` | documents (writer/reader contract for `logs/missions/`) | no |
| `ai-resources/docs/repo-architecture.md` | documents (already stale — omits the shipped `check` verb) | no |
| `ai-resources/templates/mission-contract.md` | documents / schema source | no (yes, if Question-(c) schema-field redesign adopted) |
| 18 symlink copies of `mission.md` (`projects/*/.claude/commands/mission.md`, `knowledge-bases/pe-kb-vault/...`, one `.backup-untracked` copy) | invokes | no |
| `ai-resources/logs/missions/repo-health-backlog-2026-07.md` | co-edits (thread 12's own filed remedy) | no |
| `ai-resources/logs/missions/research-workflow-deploy-fitness.md` | co-edits (S10 hand-edit precedent) | no |
| `ai-resources/logs/missions/promote-rw-canonical.md` (tombstone stub, no `status:` line) | co-edits (correctly invisible by design) | no |
| `projects/nordic-pe-screening-project/logs/missions/axcion-industry-focus.md` (`status: active`) | co-edits (active mission contract — **absent from the change description's corrected consumer count**) | no today — **yes** if Question-(c) schema-field redesign is adopted |
| `projects/project-planning/logs/missions/book-summary-system.md` (`status: active`) | co-edits (active mission contract — **absent from the change description's corrected consumer count**) | no today — **yes** if Question-(c) schema-field redesign is adopted |

Total: 29 consumers (18 symlinks + 11 named files), 0 must-change under the literal `check`/`update` proposal (the on-disk file format stays backwards-compatible). **2 of the 11 named files are consumers the change description's own re-derivation (VERIFIED FACT 2) missed** — `axcion-industry-focus.md` (`projects/nordic-pe-screening-project`) and `book-summary-system.md` (`projects/project-planning`) are both live, `status: active` mission contracts with full `## Validation contract` sections, confirmed by direct grep and read, in git repos separate from `ai-resources`. They would become must-change consumers under the Question-(c) schema-field alternative the change asks us to score. This gap is itself the Dimension 7 finding below.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `mission.md` is a command file (`model: sonnet`), invoked on demand only — not a CLAUDE.md, not a hook, not an always-loaded skill trigger.
- No `@import`, no new SessionStart/PreToolUse hook registration, no skill-description broadening.
- Printing the parsed `## Validation contract` assertions (proposed item 1) adds output tokens only on invocation of `check`, not per session.

### Dimension 2: Permissions Surface
**Risk:** Low

- `mission.md:5` frontmatter already declares `allowed-tools: Bash, Read, Write, Edit`. Both proposed verbs stay inside this set — `update` reuses Read/Write/Edit against the exact file class the command already targets; `check --assertion` adds a required CLI argument, not a new tool capability.
- No settings.json change, no new tool family, no widened glob, no external API.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Consumer Inventory: 29 consumers found, 0 must-change under the literal on-disk format (unchanged `##` section names, unchanged frontmatter shape) — this alone would read Low.
- Scored Medium because (i) the inventory surfaces a real contract change: `mission.md:71`'s explicit invariant ("Change nothing else — not the thread's text, not its ordering, not any other line in the file") must be loosened to permit recording the assertion/evidence text under the tick — an existing documented invariant is being narrowed, not merely extended (same finding as the 2026-07-18 gate, unchanged by this redesign); and (ii) the inventory found 2 consumers (`axcion-industry-focus.md`, `book-summary-system.md`) the change description's own scoping analysis missed — not a functional break today, but material to correctly sizing Question (c)'s alternative (see Dimension 7).
- `repo-architecture.md` already undercounts `/mission`'s writers (omits the shipped `check` verb); adding `update` widens this doc gap further — a doc-drift finding this change should close in passing, not a functional risk.

### Dimension 4: Reversibility
**Risk:** Medium

- `git revert` on `mission.md` alone cleanly restores the command's prior behavior — unchanged from the 2026-07-18 assessment, since the redesign is still a single-file command edit.
- Once `check --assertion`/`update` are used operationally, they write into **data files** (`logs/missions/*.md`): assertion/evidence text recorded alongside ticks, and revised `## Open threads` sections. A revert of `mission.md` does not retroactively undo those data mutations; cleanup requires a second, manual pass over any mission files touched in the interim — the append-only-log-mutation pattern the framework calls out explicitly.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Undocumented recording format, unresolved from the prior gate.** The proposal states the assertion choice and evidence string are "recorded under the ticked thread" but does not specify the exact shape (inline suffix, a sub-bullet, a new field) — the same gap the 2026-07-18 report flagged and which this redesign carries forward unchanged. Confirmed by direct read that `prime.md` Step 1d scopes its scan to unchecked `- [ ]` lines only and `mission.md` item 19 scopes `check`'s own read to `## Open threads` (the Validation-contract read is a separate, later pass per item 1 of the proposal) — so no functional break is confirmed today, but the format remains a genuinely undocumented contract at the point this gate runs.
- **New invariant on `update`.** The byte-identity guard depends on `Edit` never perturbing bytes outside `## Open threads` (trailing whitespace, line endings) — an implicit dependency not previously load-bearing for this command. Unchanged from the prior gate's finding.
- **Zero current consumers of the new `--assertion <N|none>` / `--why` argument contract.** `command grep` across `ai-resources` and the workspace root finds these tokens only in planning/logging artifacts that *describe this very change* (`logs/session-plan-2026-07-19-S1-e58.md`, `logs/scratchpads/2026-07-19-00-30-scratchpad.md`, `logs/session-notes.md`, `logs/improvement-log.md`) — no other command, agent, or doc parses or depends on this argument shape. Self-contained (the same command both defines and reads it), so this is not scored as an independent Hidden Coupling violation, but it is the evidentiary basis for the Dimension 6 speculative-abstraction check below.

### Dimension 6: Principle Alignment
**Risk:** High

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read; available) and the mission's own non-negotiable (`repo-health-backlog-2026-07.md:63`): *"No new gate to solve a discipline problem… the countermeasure that has worked here is an adversary told to distrust the author, not another checklist."*

- **`update <id>` remains well-aligned — DR-7 satisfied, re-verified.** The generalization is licensed by an already-manifested need (the hand-edit happened twice), independently re-confirmed by direct quote in this session: `repo-health-backlog-2026-07.md:87-91` and `research-workflow-deploy-fitness.md:11-18`. VERIFIED FACT 2's correction (or its Dimension-7 refutation below) does not touch this judgment — the "second confirmed consumer" bar concerns hand-edit precedents, not mission-file count. Carries forward the prior gate's clearance unchanged.
- **The closed-set `--assertion` mechanism is a High violation — Question (a), adversarially tested.** The closed set validates only that the cited assertion number `N` **exists** in the parsed `## Validation contract`; it never validates that assertion `N` is **true**. Proposal item 5 admits this directly: `check` "still does NOT execute the cited evidence command." Applied to the mission's own live counter-example (threads 1 and 2, `[x]` at :95/:96, both plausibly serving assertion 1 at :54, which is objectively unmet — measured 222 lines against a <40-line budget): an author citing `--assertion 1` with any evidence string that merely *looks* supportive would pass the closed-set check exactly as easily as the rejected free-text `--evidence` field would have. The closed set closes only the "cite a nonexistent assertion number" / "cite unparseable noise" failure mode — a real but narrow improvement — not the failure mode the mission was convened to fix.
- **`none` is the path of least resistance for exactly the cases that matter — confirms the crux of Question (a).** Choosing `--assertion none --why "<plausible reason>"` requires no cross-check against the parsed contract at all. An author facing an inconvenient truth (a thread that *does* map to a currently-failing assertion) has a strictly lower-friction path through `none` than through honestly citing the failing assertion number. The mechanism is therefore optional in practice for the highest-risk case, which is the caller's own stated forcing condition for scoring this the "8th inert safeguard."
- **Maps to AP-4 (rubber-stamp approvals — gate genuine judgment only) and the mission's own non-negotiable.** A closed-set-but-unverified `--assertion` field is a rubber-stamp confirmation dressed as a genuine gate — a narrower, harder-to-abuse-by-accident cousin of the rejected design, not a different kind of mechanism.
- **Not loudly acknowledged (OP-11 test fails).** Proposal item 5 discloses the *execution-verification* residual as a conscious, reasoned scoping decision (citing S11-637's shell-shadowing hazard) — that specific limitation is loud and acceptable. But the deeper gap identified above — that the closed set does not verify truth at all, and `none` bypasses the requirement entirely — is not stated as an accepted, deliberate tradeoff anywhere in the proposal. Instead it is posed back to this gate as an open question ("THIS IS THE CRUX"), which is good-faith but does not itself constitute the loud, recorded exception OP-11 requires. Per the framework's own rule: a High that is not loudly acknowledged as a deliberate revision forces RECONSIDER, not a mitigated PROCEED-WITH-CAUTION.
- **Material, not hypothetical.** The "inert safeguard" class is this repo's most-repeated failure type (7 logged instances per the change description, itself corroborated by `logs/improvement-log.md`'s own recurring entries on the theme, e.g. the search-canary and shell-shadowing entries read in this session). A design that narrows but does not close the class is a credible 8th instance, exactly as the change description itself frames the stakes.

### Dimension 7: Problem Reality
**Risk:** High

- **Defect — observed, not asserted, for the core premise.** Independently re-confirmed by direct read, not inherited: `check` never reads `## Validation contract` today (`mission.md` items 17-21 read only `## Open threads`); no `update` verb exists (`mission.md:27-28`); threads 1 and 2 sit `[x]` at repo-health-backlog-2026-07.md:95/:96 while acceptance assertion 1 (:54) is unmet (thread 15's own text: "Measured live: 222 lines / 47,753 chars" against a stated <40-line budget). All of this holds up on independent re-read and is Low-risk in isolation.
- **Consequence — traced, not assumed, for the core premise.** The false-tick consequence is documented inside the same file the caller cites, not inferred: thread 12's own text (repo-health-backlog-2026-07.md:140) states the false tick explicitly and calls it "the generator" of the mission's stale-record problem.
- **Re-derivation vs. the change description — MAJOR CONTRADICTION on VERIFIED FACT 2, which drives Question (c).** The change description instructs: *"Score (c) against 3, not 6"* — i.e., that the true mission-contract migration surface is 2 live contracts + 1 template = 3 files, correcting a prior "5 mission files + template = 6" figure it calls WRONG. **Independently re-derived, this correction is itself wrong.** The instrument used (`git ls-files logs/missions templates/mission-contract.md`) is scoped to a single git repo (`ai-resources`) and is structurally blind to mission-contract files that live in *other* project repos — exactly the single-repo/single-directory absence-claim error this repo's own `docs/audit-discipline.md` warns about under the shadowed-search-instrument family. A workspace-wide search (`find … -iname "*axcion-industry-focus*"`, `*book-summary-system*"`, confirmed as separate git repos via `git -C <dir> rev-parse --show-toplevel`, and confirmed as genuine `status: active` mission contracts with full `## Validation contract` sections via direct grep and read) finds **two more active mission-contract files**: `projects/nordic-pe-screening-project/logs/missions/axcion-industry-focus.md` and `projects/project-planning/logs/missions/book-summary-system.md`. The true count is **4 active mission contracts** (not 2) **+ 1 template = 5** (or **+ 1 tombstone stub = 6**, matching almost exactly the original "5 mission files + template" figure the change description asks us to discard as wrong). `/mission`'s own Step 11 repo-enumeration logic (`REPO_ROOT`, `AI_RESOURCES`, and each git repo under `WORKSPACE_ROOT/projects/*/`) confirms this is precisely the scope the command itself operates over — a single-repo `git ls-files` is the wrong instrument for this claim by the command's own design.
- **Minor, immaterial discrepancy also found:** the change description calls `promote-rw-canonical.md` a "6-line TOMBSTONE STUB"; independently re-read and `wc -l`'d, it is 5 lines. Does not affect any scored dimension.
- **Consequence of the contradiction.** VERIFIED FACT 2 is presented as the load-bearing correction that should flip Question (c)'s ROI comparison in favor of the tick-time closed-set design over a declared schema field. Because the correction is itself wrong, the ROI comparison it was meant to settle is unsettled — and the corrected number (≈5) is close enough to the "invasive" figure (6) the change description asks us to discard that it does not obviously favor the substitution the way claimed. This is a load-bearing count, feeding a scored dimension, that a caller's own re-derivation got wrong — exactly the pattern this gate exists to catch rather than inherit.

## Answers to the Three Questions

**(a) Does the closed-set `--assertion` escape the "another checklist" finding, or is `none` the escape hatch?**
**No, it does not escape it, and yes, `none` is the escape hatch.** The closed set validates that the cited assertion number exists in the parsed contract; it never validates that the assertion is true, and item 5 admits the evidence is never executed or re-opened. Against the mission's own live counter-example (threads 1/2 ticked while assertion 1 is unmet), an author can satisfy the gate either by citing a real assertion number with unverified evidence, or — with even less friction — by writing `--assertion none --why "<plausible reason>"`, which requires no contact with the parsed contract at all. The mechanism is a real, narrow improvement over the rejected free-text field (it blocks garbage/nonexistent assertion numbers) but is not a different kind of mechanism on the axis that matters. **This is a credible 8th instance of the inert-safeguard class.**

**(b) Is recording the mapping at tick time an acceptable substitute for a declared schema field, or does it relocate the same unverified claim?**
**It relocates the claim, and to a worse moment.** VERIFIED FACT 3 (independently confirmed) shows the thread→assertion mapping is often inferable from context at the point a thread is *filed* — the author who writes the thread has full context and no pressure to close anything out. Recording the same mapping retroactively at *tick* time asks whoever runs `check` — under the incentive of getting the tick to go through — to supply the identical class of unverified claim, at a moment structurally worse for accuracy, not better.

**(c) Is the declared assertion-field schema change the honest fix this substitution is avoiding?**
**On the corrected facts, yes — leaning toward the schema-field alternative being the more honest fix**, though this is a judgment call, not a certainty. The change description's own instruction to score (c) against "3, not 6" rests on a wrong re-derivation (Dimension 7, above); the true migration surface is closer to 5-6 files, essentially the same order of magnitude the change description was trying to discount away. At that scope, a declared `Assertion: N` field authored once per thread at filing time — validated against the parsed contract the same way the closed set already validates content — is not meaningfully more invasive than building and maintaining the tick-time closed-set mechanism, and it fixes the mapping at the structurally more reliable moment identified in (b). See Recommended redesign.

## Recommended redesign

Dimension 6 is High and not loudly acknowledged (the proposal poses the crux back to this gate rather than recording a deliberate OP-11 exception), and Dimension 7 is High on an independently-contradicted load-bearing fact — per the framework, either forces RECONSIDER on its own, and neither has a technical mitigation. Two things must happen before this is re-gated:

- **Rescope `check`, per answer (c).** Move the thread→assertion mapping to a declared field authored at thread-filing time (in `## Open threads`, e.g. `Assertion: 5` alongside the checkbox, or a per-thread sub-line), validated against the parsed `## Validation contract` the same way the closed set already validates content — rather than asked-for and typed at tick time under closing-out pressure. `check` then reads the declared field (or a declared `Assertion: none — <reason>`) rather than requiring it as a CLI argument. This keeps the "closed set, not free text" improvement, removes the tick-time incentive problem identified in (b), and is not meaningfully larger in scope than the tick-time design once the corrected consumer count (≈5-6 files) is used, per (c).
- **Re-derive the workspace-wide active-mission-contract count before any re-score.** Do not scope the instrument to a single repo's `git ls-files`; use `/mission`'s own Step 11 repo-enumeration (`REPO_ROOT`, `AI_RESOURCES`, each git repo under `projects/*/`) or an equivalent workspace-wide search, and re-answer Question (c) against that number, not against the figure this change description supplied.
- **`update <id>` may proceed independently.** It is implicated in neither High finding and remains well-justified on its own re-verified evidence; it can land separately from the `check` redesign if forward progress on that half is wanted while `check` is reworked.
- **If the tick-time closed-set design is kept as-is instead of rescoped**, the alternative path is to make the tradeoff loud rather than rescoping: record an explicit, bounded exception in `logs/decisions.md` stating plainly that the mechanism is presence-only with respect to truth, that `none` is an acknowledged escape hatch, and why that residual risk is accepted for this command specifically (OP-11) — which would convert the Dimension 6 finding from an unacknowledged violation to an acknowledged, bounded exception on re-gate.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit re-derivation results). No training-data fallback was used on fetch/read failures. The VERIFIED FACTS block supplied by the calling session was treated as a claim to re-derive, not a fact to inherit, per Dimension 7's mandate — one of the five (fact 2) did not survive re-derivation and is recorded above as a High finding, not silently corrected in place.
