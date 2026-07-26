# Risk Check — 2026-07-26

## Change

Per-site correction of the €200M–€2B figure across 7 sites in `axcion-content-engine` (project directory name; referred to as `axcion-content-programme` in prose), uncommitted and on disk. Verified directly via `git diff` (not taken from the change description) against the five files it names:

- `reference/known-limits.md`:21 — "€200M–€2B **enterprise-value** band" → corrected to state Axcíon's own ~€5–25M deal-size band, with entry 12's own €200M–€2B **AUM** population named as a distinct quantity ("not deal size, and not enterprise value").
- `reference/known-limits.md`:58 (register row) — "€200M–€2B **EV**" → "€200M–€2B **AUM**".
- `reference/source-map.md`:36 — "€200M–€2B" (unlabeled) → "€200M–€2B **AUM**".
- `roadmap/content-pillars.md`:75 — "the €200M–€2B band" → "Axcíon's ~€5–25M deal-size lower-mid-market band" (this paragraph is about entry 21's mid-market evidence, not entry 12; no entry-12 clause needed or added).
- `roadmap/content-pillars.md`:128 — "the €200M–€2B band" → "the lower-mid-market's ~€5–25M deal-size band (nor at entry 12's separately-scoped €200M–€2B AUM population, which owns this ceiling)".
- `knowledge/reusable-knowledge-inventory.md`:94 (gap 3) — same pattern as `known-limits.md`:21, AUM vs. Axcíon-band distinguishing clause added.
- `roadmap/article-roadmap.md`:308 (standing constraint 2) — same pattern, distinguishing clause added, entry 12's AUM ceiling kept intact.

That is 7 edited sites across 5 files, confirmed by direct diff read — the count in the change description holds.

Two sites cited as deliberately left untouched — `article-roadmap.md`:89 ("Entry 12 is rated *confirmed-weak* and states plainly that no public source segments... at the €200M–€2B band") and `article-roadmap.md`:269 (deferred-topics table, "*Where Nordic Deal Volumes Land in 2027*... collides with the band-data ceiling — no public source segments the €200M–€2B band") — are confirmed by `git diff` to carry no changes. `article-roadmap.md`:269 does not name entry 12 explicitly and its phrasing pattern ("band-data ceiling", no unit label) superficially resembles the conflated pre-fix sites. Independent line-number reconciliation against the 2026-07-19 risk-check report and `logs/improvement-log.md` (both read directly) resolves this: the two-article insertion on 2026-07-20 shifted the file by a consistent ~+2 lines before the insertion point and ~+51 after it. Old `:87`→new `:89` (consistent with the +2 shift) and old `:220`→new `:269` (consistent with the +49/51 shift) both land exactly on the sites left untouched here. `logs/improvement-log.md`:104 records, from the 2026-07-19 gate that opened entry 12's own source document before it went missing: *"`roadmap/article-roadmap.md`:87 and :220 cite the figure as inventory **entry 12's own research population**... These transcribe the source faithfully."* This session's exclusion of the same two (line-shifted) sites is corroborated by that earlier, source-verified audit — not a fresh, independently re-checked judgment (see Dimension 5).

One overclaim in the change description does not hold under re-derivation: it groups `source-map.md`:36 with `known-limits.md`:21/:58 as "mislabelled 'enterprise-value'/'EV'". The pre-edit text at `source-map.md`:36 read `"Deal-quality or dispersion metrics at €200M–€2B"` — no unit label at all, neither "EV" nor "enterprise-value". It was unlabeled/ambiguous, not mislabeled as EV. The edit applied there (adding "AUM") is still correct and beneficial; only the change description's characterization is imprecise. Low-severity, does not affect the verdict (see Dimension 7).

The change explicitly excludes: `article-roadmap.md`:89/:269 (see above), the FROZEN `articles/drafts/what-buyer-fit-means-in-practice.md`:93, the sibling `positioning-research` project's own config, and any blanket find-and-replace. `logs/session-notes.md`'s appended entry (harness mandate line for session S4-3e5) is present in the working tree but is correctly out of scope for this review, per the caller's instruction.

## Referenced files

- `reference/known-limits.md` — exists, read directly
- `reference/source-map.md` — exists, read directly
- `roadmap/content-pillars.md` — exists, read directly
- `roadmap/article-roadmap.md` — exists, read directly
- `knowledge/reusable-knowledge-inventory.md` — exists, read directly
- `axcion-content-engine/CLAUDE.md` — exists, read directly (content also supplied in the session's system context)
- `projects/market-positioning/output/messaging-and-positioning-strategy.md` — exists, read directly (lines 85–94)
- `projects/market-positioning/output/voice-and-vocabulary-guide.md` — exists, read directly (lines 135–146)
- `ai-resources/audits/risk-checks/2026-07-19-correct-the-deal-size-lens-in-project-claude-md-project.md` — exists, read directly in full
- `projects/strategic-os/ai-strategy/principles-base.md` — exists, read directly (used for Dimension 6; reachable this time, unlike the 2026-07-19 gate)
- `logs/improvement-log.md` (project-local) — read directly for the follow-up entry that scoped this fix
- `logs/session-notes.md` (project-local) — read directly to confirm the session mandate and its named out-of-scope sites
- Workspace `CLAUDE.md` and project `CLAUDE.md` — both supplied in full in the session's system context; treated as read

## Verdict

**GO**

**Summary:** All seven dimensions score Low except Hidden Coupling (Medium). The defect is real and independently re-confirmed (both by this session and, previously, by the 2026-07-19 gate that opened entry 12's source document directly). The fix is per-site, preserves entry 12's own AUM figure, correctly widens beyond the improvement-log's explicit follow-up scope to also fix the inventory's gap 3 (a site the 2026-07-19 follow-up entry did not name but which `known-limits.md`'s own provenance note requires stay in sync), and is well-contained — no programmatic consumer of the corrected text exists, and no cross-project or cross-repo site was found referencing these figures by path. One minor overclaim (source-map.md:36's prior label) and one residual bookkeeping gap (`logs/improvement-log.md`'s 2026-07-19 follow-up entries are not yet flipped to resolved) are noted but do not change the verdict.

## Consumer Inventory

Search terms used: `€200M`, `200M–€2B`, `200M-€2B`, plus direct filename search for `known-limits.md`, `source-map.md`, `content-pillars.md`, `article-roadmap.md`, `reusable-knowledge-inventory.md`. Searched the full `axcion-content-engine` project tree and, per instructions, the workspace root one level up (`ai-resources/`, `CLAUDE.md`, and a path-reference grep across all sibling project directories for links into this project's five files).

| Consumer | Reference type | Must change? |
|---|---|---|
| ~30 project-local files (skills, commands, pipeline docs, research/preparation artifacts, `articles/drafts/how-private-capital-firms-screen.notes.md`, session logs) that reference `known-limits.md` / `source-map.md` / `content-pillars.md` / `article-roadmap.md` / `reusable-knowledge-inventory.md` by name | documents (pointer references — "read this file", "loaded by") | no — grepped each for the literal figure; none hardcode it (see below) |
| `research/preparation/answer-specs/buyer-fit/cluster-C1-specs.md`, `research/preparation/research-plans/buyer-fit-research-plan-v1.md`, `research/preparation/task-plans/buyer-fit-task-plan-v1.md`, `research/preparation/task-plans/buyer-fit-task-plan-draft.md`, `articles/drafts/how-private-capital-firms-screen.notes.md` | documents (these ones do reference the general band topic, confirmed by grep) | no — none of them contain the literal "€200M" figure themselves; they discuss the band constraint without hardcoding the number |
| `ai-resources/audits/risk-checks/2026-07-19-correct-the-deal-size-lens-in-project-claude-md-project.md` | documents (historical audit trail, cites old line numbers and old wording) | no — correctly left as a point-in-time record; not rewritten |
| `logs/improvement-log.md` (2026-07-19 entries, "Follow-up: the €200M–€2B figure must be corrected PER SITE") | documents (the tracking entry this change fulfills) | recommended, not blocking — entries are not yet flipped to resolved; a bookkeeping gap, not a risk to this change |
| Sibling project `projects/positioning-research/CLAUDE.md` (carries the same "€200M–€2B enterprise value" mislabel independently) | none — separate config, no path dependency on this project's files | no — out of scope by design, already named as such in the change description and in `improvement-log.md` |
| Workspace root (`ai-resources/`) and all sibling project directories | none found | no — grep for `axcion-content-engine/reference/known-limits\|source-map\|...` and the `axcion-content-programme` equivalent across the whole workspace returned only the 2026-07-19 audit report above; no other project or ai-resources file references these five files by path |
| `entry 12`'s own cited source, `projects/positioning-research/reference/inputs/pe-regime-shift-thesis-1.1-final.md` | would-be primary source, if it existed | **does not exist** — confirmed via direct `ls`/`find`; the change description's own note is accurate. Its absence means the "faithful citation" classification of `article-roadmap.md`:89/:269 rests on a now-unverifiable primary source, inherited via `improvement-log.md` from the 2026-07-19 gate (see Dimension 5) |

No consumer requires this change to be reworked. The change is functionally isolated — the risk in this review is about the correctness/completeness of the fix itself (Dimensions 5 and 7), not about breaking anything downstream.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- All edits are prose clarifications inside project-local reference/roadmap markdown, not always-loaded context. `known-limits.md`'s own header states it is loaded by three skills (`task-plan-creator`, `cluster-analysis-pass`, `research-extract-creator`) at specific workflow stages, not every turn — confirmed by reading the file's own "Authority" block (lines 5–9).
- Net token delta across all 7 sites is on the order of 150–250 words total (mostly the added AUM-vs-deal-size distinguishing clauses), well under any Medium threshold.
- Neither `content-pillars.md` nor `article-roadmap.md` is `@`-imported by the project `CLAUDE.md` (confirmed by reading the supplied CLAUDE.md content — it points to `reference/publication-gate.md` and `reference/editorial-standards.md` as settled policy, not these two).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` changes. No new tool grants, no hooks touched. All edits are plain-text content changes inside the existing project tree, via `Edit`/`Write` on files this project already owns and routinely edits.

### Dimension 3: Blast Radius
**Risk:** Low

- Consumer Inventory (above) found zero consumers that hardcode the corrected figure and would be affected by the wording change. The only cross-file coupling is documentary (files that point readers *at* the corrected files), and none quote the literal text being changed.
- The change does touch Checkpoint-A-approved output (`roadmap/article-roadmap.md`, `roadmap/content-pillars.md`) — confirmed by reading `article-roadmap.md`:359–372, the Approval section. But that section states explicitly what approval fixes: "the pillars, the fourteen articles, their categories, pillars, month bands, rollout objectives, named internal sources and expected modes." None of those are touched — only a factual-precision clarification inside an existing standing constraint's prose. No re-approval trigger.
- No cross-repo write (unlike the 2026-07-19 change this follows up on, which required a `project-planning` write) — confirmed the diff touches only files inside `axcion-content-engine`.

### Dimension 4: Reversibility
**Risk:** Low

- All 7 sites are uncommitted changes in a single repo (`git status --short` confirms). `git checkout -- <file>` or a single revert commit cleanly restores prior state for all of them together, with no cross-repo or cross-session coordination required.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The correctness of leaving `article-roadmap.md`:89 and `:269` untouched is **not independently re-verifiable today**. Their classification as "faithful citations of entry 12's own AUM scope" traces back through `logs/improvement-log.md`:104 to the 2026-07-19 `/risk-check` gate, which opened `pe-regime-shift-thesis-1.1-final.md` directly and read its self-declared scope. That source file is now confirmed missing (`ls`/`find` return nothing). This session inherited the classification via the log chain rather than re-deriving it from the primary source — a reasonable and correctly-flagged inheritance (the change description names the missing path as a known, out-of-scope defect), but it means a future session cannot re-verify these two sites against the original evidence if the classification is ever challenged again.
- `reference/known-limits.md`'s own provenance note (lines 13, read directly) states: "The inventory is the source of truth; if the two disagree, the inventory wins and this file is corrected." This change correctly extends the fix to `knowledge/reusable-knowledge-inventory.md`'s gap 3 even though `logs/improvement-log.md`'s 2026-07-19 follow-up entry (lines 99–111) only explicitly named `known-limits.md`:21/:58 and `source-map.md`:36 as "same mislabelling, live files" requiring correction — it did not name the inventory. Extending the fix there was the right call (an un-synced inventory/known-limits pair would have reproduced exactly the "internal three-way contradiction" the follow-up entry warns against), but it is enforced by convention only, not tooling — nothing catches a future edit to one side of this pair without the other.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read directly: `projects/strategic-os/ai-strategy/principles-base.md` (reachable this time; unlike the 2026-07-19 gate, no fallback needed).

- **AP-1 (silent conflict resolution → surface, don't resolve silently)** — satisfied. The change does the opposite of a blanket fix: it classifies each site as correct-vs-conflated and only touches the conflated ones, explicitly preserving the two faithful citations rather than silently normalizing all seven to one wording.
- **AP-2 (fabrication when evidence insufficient → mark the gap)** — satisfied. The change description explicitly flags that entry 12's cited source file no longer exists and states the AUM fact was corroborated from firm canon instead, rather than fabricating or silently asserting a now-unverifiable primary-source read.
- **OP-3 / OP-11 (loud failure / recorded revision, not silent drift)** — satisfied. `logs/session-notes.md`'s appended mandate entry and `logs/improvement-log.md`'s existing follow-up entry together form a recorded, traceable chain from finding to fix, not silent drift.
- **DR-8 (gated structural changes require `/risk-check` at plan-time and end-time)** — satisfied; this review is exactly that end-time gate, and `logs/session-notes.md`'s mandate explicitly conditions landing on a GO verdict here.
- **QS-4 (evidence and interpretation separated; no training-data fill)** — satisfied. The AUM-vs-deal-size distinction is grounded in cited firm canon (`messaging-and-positioning-strategy.md`:89, `voice-and-vocabulary-guide.md`:141 — both verified directly in this review) rather than assumed.
- No principle violation found.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not inferred.** Directly confirmed via `git diff`: the pre-edit text at `known-limits.md`:21 read "€200M–€2B enterprise-value band" and at `:58` read "€200M–€2B EV" — both mislabeling entry 12's self-declared AUM population as enterprise value. Directly confirmed via `messaging-and-positioning-strategy.md`:89 and `voice-and-vocabulary-guide.md`:141 that firm canon separates "€100M–€2B AUM" from "€5–25M deal sizes" as two distinct quantities, and that "lower-mid-market" is locked specifically because it "matches the real €5–25M band." The conflation defect (using €200M–€2B as a stand-in for Axcíon's own band at `content-pillars.md`:75/:128 and `article-roadmap.md`:308, pre-edit) is likewise directly confirmed by the pre-edit diff text.
- **Consequence, graded separately.** Before the fix, a future article-drafting session reading these standing constraints could have (a) believed entry 12's population is scoped in enterprise value rather than AUM — a unit-of-measure error that would misstate what entry 12's thesis actually covers — or (b) believed Axcíon's own ~€5–25M band's data ceiling is bounded by a €200M–€2B figure, an order-of-magnitude misattribution directly relevant to what an article is permitted to claim under the "own the ceiling, don't assert a figure" rule these documents exist to enforce. Both are live, editorially-consequential risks for a project whose next work is article drafting — not cosmetic.
- **Re-derivation vs. the change description — one minor discrepancy found.** `source-map.md`:36 is grouped with the "mislabelled 'enterprise-value'/'EV'" sites, but its pre-edit text carried no unit label at all ("€200M–€2B" alone) — it was ambiguous, not mislabeled as EV. This is a low-severity overclaim in the change description; the edit applied there is still correct and beneficial (it adds a clarifying "AUM" that was previously simply absent). Does not affect the verdict.
- **Re-derivation vs. the change description — no other discrepancy found.** The "7 sites" count, the "keeps entry 12's ceiling intact" claim, and the two-untouched-sites claim (`:89`, `:269`) all check out against direct reads, the latter via the line-number reconciliation and `improvement-log.md` corroboration detailed under Dimension 5.

## Mitigations

_Not applicable — verdict is GO, not PROCEED-WITH-CAUTION._

## Recommended redesign

_Not applicable — verdict is GO, not RECONSIDER._

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `git diff` output read in full against all 5 changed files, direct `Read` of the pre- and post-edit content of every cited line, direct `grep` across the project tree and workspace root for the literal figure and for path-based references to the five changed files, direct `ls`/`find` confirming entry 12's source file is missing, direct read of `logs/improvement-log.md` and `logs/session-notes.md` for the mandate and prior-audit chain, and direct read of `principles-base.md` (reachable this time) for Dimension 6. No training-data fallback was used. One re-derivation discrepancy against the change description was found (`source-map.md`:36's prior label) and is reported under Dimension 7 at Low severity; it does not change the verdict.
