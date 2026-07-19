# Risk Check — 2026-07-19

## Change

Two grouped corrections in the `axcion-content-programme` project, both closing high-severity findings queued by session S4-ad9:

**Part 1 — correct the deal-size lens and propagate it.**
Project `CLAUDE.md` § Project Config line 91 declares `**Deal-size lens:** "lower-mid-market, €200M–€2B enterprise value"`. Firm canon contradicts this: `projects/marketing-positioning/output/messaging-and-positioning-strategy.md`:89 and :339 define the buyer as a Nordic fund of **€100M–€2B AUM** making **€5–25M deal sizes** (two distinct quantities, explicitly separated in the same sentence), and `projects/marketing-positioning/output/voice-and-vocabulary-guide.md`:141 locks the market tier "lower-mid-market" because it "matches the real **€5–25M band**" (decision #40 / R-2). Reconstruction: the €100M–€2B AUM range was taken, its low end mutated to €200M, and the result relabelled as target-company enterprise value. The true company band is ~€5–25M — an order of magnitude below the declared value.

The fix: rewrite the config field in canon's own vocabulary ("deal size", NOT "enterprise value" — asserting an unstated unit is the exact failure that produced the bug), then propagate the corrected band figure to five downstream sites that inherited the wrong range: `roadmap/article-roadmap.md`:87, :220, :257; `roadmap/content-pillars.md`:75, :128. All five sit inside Checkpoint-A-approved output. Each states the W1.1 gap-3 band ceiling as "€200M–€2B". Main session's assessment: this is a FACTUAL correction, because the constraint each site expresses is "no public source segments data at Axcíon's band," and that constraint holds MORE strongly at €5–25M.

`articles/drafts/what-buyer-fit-means-in-practice.md`:93 also carries the range but is FROZEN and hard out-of-scope.

**Part 2 — close the superseded simple-mode default at three `pipeline/` sites.**
W1.7 removed *"when an article idea could be served by either mode, default to simple mode"* from `reference/editorial-standards.md` §10 and `workflow/article-workflow.md`. It survives at `pipeline/project-plan.md`:127 and `pipeline/implementation-spec.md`:600, and `pipeline/architecture.md`:83 still describes the workflow as owning it. `editorial-standards.md`:9-12 places `project-plan.md` v4 at rank 2, above `editorial-standards.md` at rank 3 — a session resolving the conflict by the documented hierarchy takes the superseded rule from the higher authority.

Verified provenance split: `pipeline/project-plan.md`:127 is a genuine upstream input (byte-identical to `project-plan-v4.md`); `pipeline/architecture.md`:83 and `pipeline/implementation-spec.md`:600 are this project's own Stage 3b/3c artifacts, editable locally.

Fix: local supersession pointers at `architecture.md`:83 (plus the §2.4 "research-workflow not deployed" staleness) and `implementation-spec.md`:600; an upstream additive pointer at `project-plan-v4.md`:127 in the `project-planning` repo (cross-repo write); an open sub-decision on whether `project-plan.md` also gets a local pointer, flagged for this gate to weigh in on.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/roadmap/article-roadmap.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/roadmap/content-pillars.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/project-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/implementation-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/axcion-content-programme/project-plan-v4.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/logs/session-plan-2026-07-19-S5-8e9.md — exists (full plan and rationale)

## Verdict

RECONSIDER

**Summary:** Part 2 (the supersession pointers) is sound and low-risk; Part 1 rests on a premise — "all five downstream sites carry the same wrong figure and can be uniformly corrected" — that direct re-derivation shows is false for at least 2 of the 5 sites, where the cited figure is an independently-sourced, correctly-transcribed research-population scope, not an inherited config error, so applying the proposed fix there would introduce a new factual error into already-approved output.

## Consumer Inventory

Search terms used: `Deal-size lens`, `€200M`, `€2B`, `200M–€2B`, `default to simple mode`, `pipeline/project-plan.md`, `pipeline/architecture.md`, `pipeline/implementation-spec.md`. Searched `{AI_RESOURCES}`, the workspace root, and `projects/axcion-content-programme` + `projects/project-planning` directly.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `roadmap/article-roadmap.md`:87 | documents (cites entry 12's own self-declared AUM scope) | **no** — changing this would misrepresent the cited source (see Dimension 7) |
| `roadmap/article-roadmap.md`:220 | documents (same entry-12 citation) | **no** — same reason |
| `roadmap/article-roadmap.md`:257 (standing constraint 2) | documents (uses "€200M–€2B" as shorthand for Axcíon's own band) | yes — this site plausibly does need the canon figure |
| `roadmap/content-pillars.md`:75 | documents (same Axcíon-band shorthand usage) | yes, with care — see Dimension 7 |
| `roadmap/content-pillars.md`:128 | documents (same Axcíon-band shorthand usage) | yes, with care — see Dimension 7 |
| `knowledge/reusable-knowledge-inventory.md`:93 | documents (cites entry 12 directly, same AUM scope) | not in current plan scope — carries the same defect class, found by this gate, not the main session |
| `reference/known-limits.md`:21, :58 | documents (explicitly labelled "€200M–€2B enterprise-value band," citing "the regime-shift thesis") | not in current plan scope — **new finding**, mislabels entry 12's AUM scope as EV, same bug class as the config, untouched by this change |
| `reference/source-map.md`:36 | documents (routes to `known-limits.md` limit 1) | not in current plan scope — **new finding** |
| `reference/editorial-standards.md`:157 | documents (already carries a supersession pointer resolving the Part-2 conflict-order issue) | no — already correct, pre-existing |
| `articles/drafts/what-buyer-fit-means-in-practice.research-brief.md`:89 | documents (already locally corrected, explanatory note) | no — correct to leave |
| `articles/drafts/what-buyer-fit-means-in-practice.md`:93 | documents (frozen artifact) | no — explicitly out of scope |
| `logs/decisions.md` (open question row, S4-ad9 supersession row) | documents | yes — close the open question, record the corrected consumer analysis |
| `logs/improvement-log.md` (2 pending entries) | documents | yes — flip to resolved |
| `logs/session-notes.md`:452, :464 | documents (mandate reference) | no |
| `projects/positioning-research/CLAUDE.md`:29 | documents (sibling project, same "€200M–€2B enterprise value" mislabelling) | no — out of scope for this change, but same defect class, **new finding**, unscoped by CHANGE_DESCRIPTION |
| `pipeline/architecture.md`:83 (+ §2.4) | co-edits (own Stage-3b artifact) | yes |
| `pipeline/implementation-spec.md`:600 | co-edits (own Stage-3c artifact) | yes |
| `pipeline/project-plan.md`:127 | documents (byte-identical upstream copy) | **contested** — the change's own "open sub-decision"; recommendation below |
| `projects/project-planning/.../project-plan-v4.md`:127 | invokes/co-edits (upstream original, cross-repo write) | yes |
| `ai-resources/workflows/research-workflow/docs/project-config-schema.md`:50 | documents the `Deal-size lens` field contract | no — confirms **no programmatic consumer**: "operator-facing only — no consumer parser; cited in prose/tags" |
| `.claude/commands/build-roadmap.md`, `.claude/agents/knowledge-inventory-agent.md`, `workflow/article-workflow.md` | documents (read `pipeline/project-plan.md` for §W1.1–W1.3 content, not the simple-mode line specifically) | no |

**Total: 19 consumers found, 8 must-change** under the corrected scope (down from the 8 the change itself lists, because 2 of the 5 roadmap/pillar sites should not change and are replaced by 3 newly-found related-but-unscoped files that arguably should but currently aren't in plan). This is not an isolated change — it touches two git repositories and a Checkpoint-A-approved artifact set, and its true footprint is larger than the change description enumerates.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The only always-loaded-file edit is `CLAUDE.md` § Project Config line 91, a single-line value swap ("€200M–€2B enterprise value" → a canon-cited "deal size" phrase). Estimated delta is a few words, well under the ~50-token Medium threshold.
- No hooks, no subagent briefs, no skill triggers are touched by either part of the change.
- `ai-resources/workflows/research-workflow/docs/project-config-schema.md`:50 confirms the `Deal-size lens` field has **no programmatic consumer** — "operator-facing only — no consumer parser; cited in prose/tags" — so there is no runtime parsing cost either way.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json`/`settings.local.json` edits proposed.
- The cross-repo write into `project-planning` (Part 2) does not require a new grant: `projects/axcion-content-programme/.claude/settings.local.json` already carries `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` (verified by reading `pipeline/implementation-spec.md` Operation 4), which covers the whole workspace root including `project-planning`.
- The write pattern itself (editing a sibling project's tracked file from within this project's session) is unusual and is exactly why it is called out as a structural change class — but that consequence belongs to Reversibility/Blast Radius below, not to the settings surface.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory: **19 consumers found, 8 must-change** under the corrected scope, spanning two git repositories (`axcion-content-programme`, `project-planning`) and touching Checkpoint-A-approved editorial output (`roadmap/article-roadmap.md`, `roadmap/content-pillars.md`).
- The change's own scoping (5 roadmap/pillar sites + 3 `pipeline/` sites + 2 logs) is **incomplete**: this gate's independent grep surfaced 4 additional files carrying the same or a related defect class that the change does not touch — `knowledge/reusable-knowledge-inventory.md`:93, `reference/known-limits.md`:21/:58, `reference/source-map.md`:36, and a sibling project's config (`projects/positioning-research/CLAUDE.md`:29). The session's own planned re-grep verification step (session-plan.md step 6: "confirm the only survivors are the frozen draft, the research brief's explanatory note, and log/decision history") does **not** anticipate these four files as survivors — they will show up in that grep and were not accounted for in the plan, risking either uncontrolled scope creep mid-session or a false "all clear" if the check is applied loosely.
- Two of the five in-scope roadmap/pillar sites (`article-roadmap.md`:87, :220) are, on inspection, not downstream of the config error at all — they cite an independent, already-correct source (see Dimension 7). Applying the proposed fix there is itself a blast-radius event: it would corrupt a currently-correct citation inside Checkpoint-A-approved output.

### Dimension 4: Reversibility
**Risk:** Medium

- The `axcion-content-programme`-side edits (CLAUDE.md, roadmap files, `pipeline/architecture.md`, `pipeline/implementation-spec.md`, logs) are within one repo and `git revert` cleanly restores them.
- The cross-repo write into `project-planning` requires a coordinated revert across two repositories if the change needs undoing after both are pushed — workspace push is gated and batched at `/wrap-session`, so if both commits land in the same wrap, an operator wanting to undo the deal-size-lens propagation only (Part 1) but keep the pointer fix (Part 2) must revert selectively across two repos, not one.
- `logs/decisions.md` and `logs/improvement-log.md` are append/status-flip logs; reverting the substantive fix without also reverting the "resolved" status flip leaves a log entry claiming a fix that was rolled back — the standard log-revert asymmetry this dimension's heuristics flag as Medium.

### Dimension 5: Hidden Coupling
**Risk:** High

- `roadmap/article-roadmap.md`:87's claim ("Entry 12... states plainly that no public source segments... at the €200M–€2B band") is implicitly coupled to the exact scope wording of its cited source, `projects/positioning-research/reference/inputs/pe-regime-shift-thesis-1.1-final.md`:5, which self-declares "European mid-market private equity (**€200M–€2B AUM primary**)." This dependency is not documented anywhere in `article-roadmap.md` itself — a reader/editor has no way to know from the roadmap alone that the number must track the source's own stated population, on pain of misattribution.
- The other four sites (`article-roadmap.md`:220/:257, `content-pillars.md`:75/:128) use the same "€200M–€2B" token for a **different** referent — Axcíon's own "lower-mid-market" band — without the roadmap distinguishing the two usages anywhere. Two different quantities (a specific external research population's AUM scope, and Axcíon's own deal-size band) currently collapse onto one shared number, and the change's "figure-only, preserve constraint wording" execution plan (session-plan.md step 5) treats all five as one coupling when they are actually two.
- This is precisely why a uniform find-and-replace across the five sites is unsafe: it silently assumes a convention (one meaning per number) that does not hold.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read: `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` was not confirmed reachable within this gate's scope; workspace CLAUDE.md § Design Judgment Principles and § Autonomy Rules were read directly (already loaded) and used as the primary anchor, supplemented by the inline checks in Step 6.5.

- **OP-2 (automate execution, gate judgment) — tension.** The execution plan for Part 1 (session-plan.md step 5: "preserve the *constraint* wording exactly; change only the band figure") frames a genuinely evidentiary, per-site judgment call — does this instance of "€200M–€2B" denote a specific cited research population or Axcíon's own band? — as mechanical, figure-only substitution. Dimension 7 and Dimension 5 show that judgment is required per site, not assumed uniformly. This is the load-bearing finding this dimension surfaces: a decision that should be gated (verify each citation against its source before editing) was scoped as automatable execution.
- **OP-11 / OP-3 (loud revision, not silent drift) — handled correctly.** The "open sub-decision" on whether `pipeline/project-plan.md` gets a local pointer is explicitly surfaced in `session-plan.md` ("Surfaced rather than silently resolved") rather than silently decided. Good practice; no violation here.
- Advisory note on that surfaced sub-decision (not itself a risk to this gate's dimensions, but requested weigh-in): the "Recommended default" (apply the upstream fix, then also add a local pointer under the `publication-gate.md`:5 precedent) is in tension with `ai-resources/docs/file-write-discipline.md`:9's bright-line rule — "Never invoke Write, Edit, MultiEdit... against a file whose content originated outside the current session." `pipeline/project-plan.md` is confirmed byte-identical to the upstream `project-plan-v4.md` (md5 `49be58e5f7d53fe0563c613a363bd04f` on both). The cited precedent, `reference/publication-gate.md`:5, does not actually match: that file was authored fresh by this project's own pipeline (Stage 3c, "write the full content below verbatim" into a *new* file), not edited as an already-existing copy of an external file. Recommendation: apply the upstream fix only; do not add a local pointer to `pipeline/project-plan.md`. If the operator wants the local copy to carry the pointer too, that should be a deliberate, recorded exception to the file-write-discipline rule (OP-11 style), not an application of a precedent that does not hold.

### Dimension 7: Problem Reality
**Risk:** High

- **Defect — observed or inferred?** Mixed, and this is exactly where it matters. The core config defect (Part 1) **is** observed: I independently read `CLAUDE.md`:91 (`"lower-mid-market, €200M–€2B enterprise value"`), `messaging-and-positioning-strategy.md`:89/:339 (`€100M–€2B AUM, €5–25M deal sizes`), and `voice-and-vocabulary-guide.md`:141 (`matches the real €5–25M band`) — all three citations check out exactly as claimed. Part 2's defect is also observed: I confirmed via `sed`/`grep` that the superseded rule survives verbatim at `project-plan.md`:127, `implementation-spec.md`:600, and is described at `architecture.md`:83; and I confirmed via `md5`/`diff -q` that `project-plan.md` is byte-identical to upstream `project-plan-v4.md`, and via `find` that no `architecture.md`/`implementation-spec.md` exists anywhere in `project-planning` — the provenance-correction claim is accurate.
- **The consequence claim for Part 1's downstream propagation is where re-derivation contradicts the change description.** I opened the actual cited evidence source for the roadmap/pillar band-ceiling claims — `projects/positioning-research/reference/inputs/pe-regime-shift-thesis-1.1-final.md` (inventory entry 12) — and its own line 5 self-declares: *"Internal positioning thesis · European mid-market private equity (**€200M–€2B AUM primary**) · public sources only."* This is repeated dozens of times through the document as its explicit research-population scope (AUM, not deal size, not enterprise value). `article-roadmap.md`:87 and `:220` cite this exact source and this exact figure **correctly** — "Entry 12... states plainly that no public source segments... at the €200M–€2B band" is a faithful transcription of what entry 12 actually says. Changing those two citations to "€5–25M" — as the change proposes uniformly — would **misattribute entry 12's own stated scope** and introduce a new factual error into Checkpoint-A-approved output, the opposite of the change's stated goal.
- **The other three sites are different** — `article-roadmap.md`:257 (standing constraint 2) and `content-pillars.md`:75/:128 use "€200M–€2B" as shorthand for "lower-mid-market"/Axcíon's own band (e.g., content-pillars.md:75: "Any read down to the €200M–€2B band is an inference... may not silently re-label mid-market evidence as lower-mid-market"), which conflates the AUM-scoped research population with Axcíon's own deal-size band. These three plausibly do carry the error the change describes and plausibly should move toward the canon figure — but even here, "figure-only, constraint wording untouched" is too blunt: the fix needs to state explicitly that Axcíon's own band (~€5–25M deal size) is distinct from entry 12's AUM-scoped evidence ceiling (€200M–€2B AUM), or the roadmap will simply relocate the conflation rather than resolve it.
- **Additional unscoped survivors.** `reference/known-limits.md`:21 and `:58` explicitly label the same figure "€200M–€2B enterprise-value band" while citing "the regime-shift thesis" (entry 12) as its source — the identical AUM-vs-EV mislabelling found in the config, but in a live, deployed reference-chassis file the change does not touch. `reference/source-map.md`:36 routes to that same defect. A sibling project, `projects/positioning-research/CLAUDE.md`:29, independently carries `"Nordic mid-market private equity (≈€200M–€2B enterprise value)"` — the same error, in a different project, outside this change's stated scope, and not mentioned in `CHANGE_DESCRIPTION`. None of these were caught by the main session (specific concern #5 in the dispatch asked me to check for exactly this).
- **A minor, non-load-bearing citation error, noted for completeness.** The change description states the `project-planning/output/` symlink and `Project Plans/` resolve to "the same inode 11266366." Direct verification (`stat -f "%i" -L`) shows both resolve to inode **398423**, not 11266366. The underlying claim (same directory, one edit covers both paths) is confirmed true — this is an imprecise supporting citation, not a wrong conclusion, but it is exactly the kind of "plausible recollection, not observation" this dimension exists to catch, and this project's own `logs/decisions.md` (entry on the `lessons-log.md` propagation, 2026-07-19) names this failure mode as having already recurred twice in this project this week.
- **Re-derivation vs. the change description:** the claim "all five downstream sites… inherited the wrong range" and "propagate the corrected band figure to five downstream sites" is **contradicted** by direct re-derivation for 2 of the 5 sites (`article-roadmap.md`:87, :220), which cite an independent, correctly-scoped source and should not be changed as proposed. The claim "the only survivors [after the fix] are the frozen draft, the research brief's explanatory note, and log/decision history" is contradicted by 4 additional files this gate found carrying the same or a related defect class. The inode number cited for the `project-planning` symlink is wrong (though its supporting conclusion holds).

## Recommended redesign

- **Split Part 1 into a per-site verification pass before any edit.** For each of the five cited roadmap/pillar sites, open the specific evidentiary source it names (entry 12's thesis document for `article-roadmap.md`:87/:220; re-examine what `article-roadmap.md`:257 and `content-pillars.md`:75/:128 are actually asserting) and classify each site as either (a) a correct citation of entry-12's own AUM-scoped population — leave unchanged — or (b) a conflated use of that figure as a stand-in for Axcíon's own band — correct to the canon deal-size figure **and** add one clause distinguishing "Axcíon's own €5–25M deal-size band" from "entry 12's separately-scoped €200M–€2B AUM research population," so the fix does not relocate the conflation. On current reading: (a) applies to `article-roadmap.md`:87 and `:220` — do not touch; (b) applies to `article-roadmap.md`:257, `content-pillars.md`:75, `content-pillars.md`:128 — correct with the added distinguishing clause.
- **Widen the scope check before landing, or explicitly defer.** Either fold `reference/known-limits.md`:21/:58 and `reference/source-map.md`:36 into this same pass (they carry the identical mislabelling, sourced to the same document, and leaving them creates the internal three-way contradiction — entry 12 says AUM, roadmap would say deal-size, known-limits would still say enterprise-value), or explicitly log them as a separate, deferred, named follow-up rather than letting the session's own re-grep step silently pass over them as unanticipated "survivors." `projects/positioning-research/CLAUDE.md`:29 is genuinely out of this project's scope and should just be logged as an adjacent finding for that project's own maintenance track.
- Part 2 (the supersession pointers) does not need to be gated on the Part 1 rework — its provenance verification is independently sound and its risk profile is low. It can proceed on its own, including a ruling on the open sub-decision: apply the upstream `project-plan-v4.md`:127 pointer; do **not** add a local pointer to `pipeline/project-plan.md` (that file's content is byte-identical to a file that originated outside this session, and `file-write-discipline.md`:9 is a bright-line rule the cited precedent does not actually satisfy).
- Re-run `/risk-check` on the rescoped Part 1 once the per-site classification above is done; Part 2 does not require re-gating unless its own scope changes.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep/md5/diff/find command output, verbatim quotes from `CHANGE_DESCRIPTION` or referenced files, or explicit findings from independent re-derivation). No training-data fallback was used on fetch/read failures. The principles-base index path was not independently confirmed reachable; Dimension 6 relied on workspace CLAUDE.md and the inline Step 6.5 checks instead, as permitted by the gate's fallback instruction.
