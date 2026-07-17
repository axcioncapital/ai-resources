# Risk Check — 2026-07-17

## Change

Three canonical instruction edits (auto-mode bundle S2-21e), plan-time gate. All additive, high reversibility (git-tracked command/agent/skill/doc files).

(1) usage-log writer PREPEND→APPEND. `.claude/commands/usage-analysis.md` Step 4.2 (line 58) and `skills/session-usage-analyzer/SKILL.md` lines 118 & 122 instruct inserting the new entry / the TREND maintenance summary directly below the `<!-- entries below -->` marker (a prepend). The reader (`/prime` Step 1, `tail -n 30 logs/usage-log.md`) reads the tail, and `logs/scripts/check-usage-log-format.sh` already enforces append-at-tail. Change all three writer instructions to APPEND at the end of the file (the tail). No reader change.

(2) Pre-dispatch premise-verification step in two gate commands. `.claude/commands/risk-check.md` — new numbered step immediately before Step 3's `risk-check-reviewer` spawn (~line 84-86). `.claude/commands/consult.md` — mirror step immediately before Step 4's `system-owner` delegate (~line 88-90). The step: before dispatching the reviewer, run every script the payload cites, open every line it cites, re-derive every count; any failing claim becomes a correction to the change description before the subagent sees it. Plus a short gate-scope note in `docs/audit-discipline.md` § When to fire. Explicitly NOT a new command — a step in the existing gate-dispatch path.

(3) Harden `system-owner` (the last unhardened reviewer; it fabricated a 27x count this week). Add a premise-check clause to `.claude/agents/system-owner.md` Phase 5 output contract (~line 99-107): every count, path, and quoted line must cite the command that produced it; an uncited claim is marked a guess and may not carry a conclusion; state the primitive used, not just the number (`[ -f ]` follows symlinks; a filename glob cannot see a report named after its subject). Mirror the `risk-check-reviewer.md` "your re-derivation wins" wording + its converse. Add a one-line pointer in `.claude/commands/consult.md` Step 4 dispatch brief. Mirrors the clause shipped to risk-check-reviewer.md and qc-reviewer.md in commit c3c0334.

Blast-radius note for the consumer inventory: risk-check.md, consult.md, and system-owner.md fan out across many checkouts (symlinked commands / shared agent). Changes are strictly additive (more verification per dispatch, ~5k cost) — no behavior is removed.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-2/.claude/commands/usage-analysis.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-2/skills/session-usage-analyzer/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-2/.claude/commands/risk-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-2/.claude/commands/consult.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-2/docs/audit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-2/.claude/agents/system-owner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-2/logs/scripts/check-usage-log-format.sh — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** All three sub-changes are exceptionally well-grounded (every cited defect independently re-derived and confirmed, including a fresh re-count of the fabricated-count evidence), additive, and cleanly reversible, but the combined bundle touches shared gate/agent infrastructure with a genuinely wide — and partly under-stated — consumer footprint, so it clears with mitigations rather than a clean GO.

## Consumer Inventory

Search terms derived from the change: `usage-analysis.md`, `session-usage-analyzer`, `<!-- entries below -->` marker, `risk-check.md`, `consult.md`, `system-owner`, `audit-discipline.md`, `check-usage-log-format.sh`. Grepped across `ai-resources-2` and the workspace root (`command grep -rniI --exclude-dir=.git`), plus `find .. -lname` for symlink fan-out. 24 distinct consumer rows found (6 are the co-edited files themselves; 18 are downstream).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/usage-analysis.md` | co-edits | yes |
| `skills/session-usage-analyzer/SKILL.md` | co-edits | yes |
| `.claude/commands/risk-check.md` | co-edits | yes |
| `.claude/commands/consult.md` | co-edits | yes |
| `docs/audit-discipline.md` | co-edits | yes |
| `.claude/agents/system-owner.md` | co-edits | yes |
| `.claude/commands/prime.md` (Step 1, `tail -n 30 logs/usage-log.md`) | parses | no |
| `.claude/commands/wrap-session.md` (Step 12 — runs the full `/usage-analysis` flow + Step 12's `check-usage-log-format.sh` guard) | invokes | no |
| `logs/scripts/check-usage-log-format.sh` (enforces append-at-tail; unaffected — already expects the new behavior) | parses | no |
| `.claude/agents/risk-check-reviewer.md` (receives the pre-verified `CHANGE_DESCRIPTION` payload) | parses | no |
| `.claude/commands/friday-act.md` (invokes `/risk-check` inline) | invokes | no |
| `.claude/commands/resolve-incident.md` (invokes `/risk-check` AND `/consult`) | invokes | no |
| `.claude/commands/resolve-repo-problem.md` (invokes `/risk-check` inline) | invokes | no |
| `.claude/commands/pm.md` (Fallback 5d redirects to `/consult`) | invokes | no |
| `.claude/commands/architecture-review.md` (dispatches `system-owner` Function C) | invokes | no |
| `.claude/commands/implementation-triage.md` (dispatches `system-owner` Function D) | invokes | no |
| `.claude/commands/systems-review.md` (dispatches `system-owner` Function E) | invokes | no |
| `.claude/commands/friday-so.md` (dispatches `system-owner` Function F) | invokes | no |
| `.claude/commands/so-monthly.md` (dispatches `system-owner` Function G) | invokes | no |
| Symlinked project checkouts of `usage-analysis.md` (24 found via `find .. -lname "*usage-analysis.md"`) | imports | no |
| Symlinked project checkouts of `session-usage-analyzer/SKILL.md` (5 found) | imports | no |
| Symlinked project checkouts of `risk-check.md` (25 found) | imports | no |
| Symlinked project checkouts of `consult.md` (43 found) | imports | no |
| Symlinked project checkouts of `system-owner.md` (25 found) | imports | no |

**Total: 24 consumers, 6 must-change** (the 6 files the change itself edits, treated as co-edits since the bundle lands them together). All 18 downstream consumers are `must-change? = no` — every effect confirmed additive/backwards-compatible on inspection.

**Load-bearing scope note (verified, not asserted).** This checkout (`ai-resources-2`) is a **git worktree** of canonical `ai-resources` (`git rev-parse --git-common-dir` → `.../ai-resources/.git`). Every symlink fan-out found above resolves to the **canonical `ai-resources`** tree, not to this worktree (confirmed via `readlink` on a sample). So none of the 24/5/25/43/25 symlinked consumers see this change until the branch merges to canonical `ai-resources` — current blast radius, pre-merge, is contained to the 6 co-edited files and the 13 named same-checkout consumers above.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Items 1 and 2 are pay-as-used: `usage-analysis.md`/`SKILL.md` writer-direction edits carry no recurring cost, and the `risk-check.md`/`consult.md` pre-dispatch step only spends tokens when those gates are actually invoked (2x/session at most per the two-gate model in `docs/audit-discipline.md:36-43`) — Low in isolation.
- Item 3 adds prose to `.claude/agents/system-owner.md`'s Phase 5 output contract (~line 99-107) — a subagent brief re-read in full on **every** dispatch, not an always-loaded CLAUDE.md file, but the dimension's own trigger question applies directly: "Does it expand a subagent brief... that will be spawned frequently?" — yes. Confirmed 6 distinct callers dispatch `system-owner` (`/consult` Functions A/B, plus `architecture-review.md`, `implementation-triage.md`, `systems-review.md`, `friday-so.md`, `so-monthly.md` for Functions C-G), so the addition (~100-160 tokens estimated from the clause text quoted in `CHANGE_DESCRIPTION`: the citation rule + primitive rule + mirrored "your re-derivation wins" wording) is paid on every one of those dispatches going forward, permanently.
- Net effect sits at the low end of Medium: a modest, bounded, one-time text addition to a frequently-spawned brief — not an always-loaded CLAUDE.md bloat, not a PreToolUse hook, not a broad-trigger skill.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json`, `allow`/`ask`/`deny`, or tool-grant changes anywhere in the bundle.
- All edits are prose changes to command/agent/doc `.md` files already within this session's normal Write scope; no new capability (shell access, external write, cross-repo write) is introduced.

### Dimension 3: Blast Radius
**Risk:** High

- Consumer Inventory (Step 1.5, above): **24 total consumers, 6 must-change** (the co-edited files), with **13 additional same-checkout consumers** confirmed compatible (`prime.md`, `wrap-session.md`, `check-usage-log-format.sh`, `risk-check-reviewer.md`, `friday-act.md`, `resolve-incident.md`, `resolve-repo-problem.md`, `pm.md`, `architecture-review.md`, `implementation-triage.md`, `systems-review.md`, `friday-so.md`, `so-monthly.md`) — well over the ">5 dependent callers" High threshold on its own.
- Shared infra is directly touched: `system-owner.md` is read in full by **six** distinct commands (`/consult` A/B plus Functions C-G's five callers), and `risk-check.md`/`consult.md` are the canonical gate-dispatch path for the whole workspace's structural-change discipline — squarely "shared infra touched in a way that affects multiple workflows," an independent High trigger.
- **Unanticipated-consumer gap named by this scan, not by the change description:** `CHANGE_DESCRIPTION` frames item 3's blast radius as "Phase 5 output contract (~line 99-107)" plus "a one-line pointer in `consult.md` Step 4" — i.e., scoped to `/consult`. But `system-owner.md` is a single agent-definition file read whole on every dispatch regardless of which Function (A-G) the calling command selects, so the new premise-check clause is silently in-context for `architecture-review.md`, `implementation-triage.md`, `systems-review.md`, `friday-so.md`, and `so-monthly.md` too — five callers the change description does not name.
- Mitigating factor (see Reversibility): this is a worktree session, so none of this blast radius is live until merge to canonical `ai-resources` — the High score describes the eventual, not the immediate, footprint, consistent with how this repo's own `/risk-check` (Step 2 item 5) already treats worktree sessions as a known, handled case.
- All 18 non-co-edit consumers are additive/backwards-compatible on inspection — no caller requires modification. The High score is driven by consumer *count* and *shared-infra reach*, not by any broken contract.

### Dimension 4: Reversibility
**Risk:** Low

- All six edits are prose changes to existing, git-tracked files — no new files, no new directories, no log/data mutation, no hook/cron/symlink added. `git revert` on the commit(s) fully restores prior state.
- Confirmed via `git rev-parse --git-common-dir`: this checkout is a worktree of canonical `ai-resources`, and the fan-out symlinks (Dimension 3) all resolve to the canonical tree, not this worktree — so a revert here, pre-merge, has zero effect on any of the ~24-43 downstream checkouts. Reversibility is if anything cleaner than the single-checkout case.
- No push, no external write, no operator-muscle-memory concern (no new command/flag is introduced — items 2 and 3 are explicitly steps inside existing commands, not new ones).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency 1 (system-owner's shared-file-read behavior).** As noted under Dimension 3, the item-3 clause is textually scoped to the Function A/B output contract but is *behaviorally* global because Task-tool subagent dispatch re-reads the whole agent-definition file every time, regardless of function. This dependency is real but discoverable at the change site itself (anyone reading `system-owner.md` end-to-end sees it applies everywhere) — not a silently-firing surprise.
- **Implicit dependency 2 (risk-check.md's step-numbering convention).** `risk-check.md` already uses a lettered-continuation convention (`12a`, `17a`, `17b`, `17c`) to insert later additions without renumbering the file's sequential items — because at least one existing step (item `12a`) contains an internal cross-reference to "Step 10." `CHANGE_DESCRIPTION` specifies the insertion by **line range** ("~line 84-86"), not by this existing numbering convention, so an implementer who globally renumbers items 11+ instead of adding a lettered sub-step (e.g., `10a`) risks breaking `risk-check.md`'s own internal step references. Cheap to avoid (follow the established pattern) but not called out in the change description.
- Both dependencies are traceable at the change site and cheap to verify by read-back — neither causes silent auto-firing, functional overlap, or an undocumented external contract, so this stays at Medium rather than High.
- No functional overlap found: the new pre-dispatch premise step (item 2) is explicitly the *input*-side complement to `risk-check-reviewer.md`'s existing Dimension 7 / `qc-reviewer.md`'s existing Premise Check (both *output*-side), per `logs/improvement-log.md:1092` ("this grades a gate's **input**; [Dimension 7] grades its **output**"). Confirmed non-duplicative by design, not merely asserted.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** All three sub-changes respond to directly-observed, already-manifested defects (see Dimension 7) rather than a hypothetical future consumer. The complexity-budget gate does not apply in the "net-additive component" sense either: `CHANGE_DESCRIPTION` explicitly states item 2 is "NOT a new command — a step in the existing gate-dispatch path," and item 3 is a clause added to an existing agent's existing output contract — no new command, agent, gate, or always-loaded doc is created.
- **OP-12 (closure before detection) — actively served.** Item 2's premise-verification step doesn't just detect a false claim; the change description states failing claims "become a correction to the change description before the subagent sees it" — detection paired with in-line closure. Item 3's clause similarly closes what it detects: an uncited claim "may not carry a conclusion," which structurally blocks a fabricated count from driving a downstream verdict, rather than merely flagging it.
- **OP-5 (advisory vs enforcement) — no silent upgrade.** The new step is a required step inside an already-mandatory gate-dispatch flow (not a new blocking gate layered on top), and its action is a correction/self-check, not a new auto-block.
- **OP-11 / OP-3 (loud revision) — satisfied by construction.** Nothing here is silent: both root causes are pre-recorded, dated `OPEN` entries in `logs/improvement-log.md` (2026-07-14 lines 1092 and 1105; 2026-07-15 line 1162), authored and status-tracked before this session began.
- **DR-1 / DR-3 (placement) — correct.** Extends existing infrastructure (existing commands, existing agent, existing doc) rather than creating new files, matching the doc's own placement discipline.
- Principles-base at `projects/strategic-os/ai-strategy/principles-base.md` was not read this pass (workspace/repo CLAUDE.md IDs — OP/AP/DR — were available and sufficient to ground every citation above); noting this as the fallback basis per the dimension's own instructions.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not asserted, for all three items.**
  - Item 1: directly re-read `usage-analysis.md:58` ("insert the new entry directly below the `<!-- entries below -->` marker (above all existing entries)") and `SKILL.md:118`/`:122` (both instruct inserting the TREND entry "at the top of the log after the marker" / "below the `<!-- entries below -->` marker") — confirmed prepend instructions verbatim. Directly re-read `check-usage-log-format.sh` and `prime.md:89` (`tail -n 30 logs/usage-log.md`) — confirmed the reader/guard both assume append-at-tail.
  - Item 2: the cited line ranges — `risk-check.md` Step 3 header at line 84, spawn step (item 11) at line 86; `consult.md` Step 4 header at line 88, delegate brief at line 90 — all independently re-read and confirmed accurate.
  - Item 3: independently grepped `system-owner.md` for any existing citation/premise-check language and found none (only an unrelated grounding-absence rule at line 183) — confirms the "unhardened" claim. Independently found the fabrication evidence via my own grep (not via the change description) in `logs/usage-log.md:892`: `/consult` claimed **13** risk-check reports; **re-derived myself today via `ls audits/risk-checks/*.md | wc -l` → 355** (vs. the log's own contemporaneous count of 351 three days ago — consistent, small drift from time passing, not a contradiction).
- **Consequence — traced, not assumed, for all three items.**
  - Item 1: `logs/improvement-log.md:1162` documents an actual, already-occurred incident (the 2026-07-14 "S2" entry was prepended, sat ~900 lines above the reader's window, and required a manual byte-verified relocation) — not a hypothetical failure mode.
  - Item 2: `logs/improvement-log.md:1092` documents two measured, executed catches (the `warn-settings-change.sh` fail-open reproduced by piping a real payload → exit 0; the `risk-check.md:93` hard-abort found by direct read) that cost ~360k tokens of gate reasoning to surface after the fact — a traced, not inferred, cost.
  - Item 3: `logs/usage-log.md:892` and `logs/improvement-log.md:1105` trace the 27x fabrication to four specific downstream conclusions in the same `/consult` output, all of which "collapse" once the correct count is substituted — a traced consequence, not a hypothetical one.
- **Re-derivation vs. the change description:** One discrepancy found. `CHANGE_DESCRIPTION` calls `system-owner` "the last unhardened reviewer." My own grep of every other reviewer-shaped agent (`expert-check-reviewer.md`, `reconcile-reviewer.md`, `refinement-reviewer.md`, `triage-reviewer.md`, `scope-qc-evaluator.md`) found **none** of them carry this clause either — so `system-owner` is not literally the last unhardened reviewer in the repo. This framing is inherited verbatim from `logs/improvement-log.md:1105`'s own title ("...is the ONE reviewer left unhardened"), which scopes to the three agents touched by the `c3c0334` incident (risk-check-reviewer and qc-reviewer hardened; system-owner, the third, left out), not to every reviewer-class agent workspace-wide. This is a pre-existing overstatement in the source log, carried forward rather than invented by this change description, and it does not affect the core defect (system-owner genuinely lacks the clause and genuinely fabricated a 27x count) or its justification — noted for accuracy, not verdict-changing.
- All other counts, paths, and quoted lines in `CHANGE_DESCRIPTION` were re-derived and confirmed. No other discrepancy found.

## Mitigations

- **(Blast Radius — High)** After editing, read back `risk-check.md`, `consult.md`, and `system-owner.md` in full and confirm: (a) `risk-check.md`'s Step 4 structural validation — which hard-counts "seven `### Dimension N` subsections" and the item numbers it references internally (e.g., item `12a`'s "Step 10" cross-reference) — still resolves correctly, by inserting the new pre-dispatch step as a lettered sub-step (e.g., `10a`) rather than renumbering items 11+; (b) the same lettered-insertion approach for `consult.md`'s mirror step; (c) `system-owner.md`'s Functions C-G output-shape sections (their own separate templates) are untouched by the Phase 5 A/B-contract edit.
- **(Blast Radius / Hidden Coupling — High/Medium)** Smoke-test one live dispatch of `/consult` (Function A) after landing the edit, to confirm the new premise-check clause doesn't alter or break the existing ≤30-line summary contract or the path-back-line format its five sibling commands (`architecture-review.md`, `implementation-triage.md`, `systems-review.md`, `friday-so.md`, `so-monthly.md`) also depend on.
- **(Hidden Coupling — Medium)** Add a one-line comment at the new `system-owner.md` clause (matching the file's existing inline-comment convention, e.g. `consult.md`'s "DO NOT add..." header comment) noting that the clause applies to every dispatching function (A-G), not only A/B — makes the already-real wider blast radius self-documenting at the change site instead of only discoverable by inspection.
- **(Usage Cost — Medium)** Keep the `system-owner.md` addition to the minimum wording needed (the citation rule + primitive rule); consider a short cross-reference to `risk-check-reviewer.md`'s existing "your re-derivation wins" clause rather than restating it in full, since this text is now paid on every one of six dispatch paths permanently.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
