UNIT: 2026-07-29-prime-minimum-responsibility-frame
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: frame
REPO: ai-resources
BASE: dcc876aab0e4a2a4e53777b7c6ea6d8b44774577
NEXT: operator (then Claude, Shape)

EVIDENCE

Status: complete

ROUTE: challenged — (1) `docs/audit-discipline.md:65` shared-state-op restructuring across 28
symlinked consumers; (2) "already failed to converge twice" (`prime-lean-down` → rejected-premise;
`prime-allocator-extraction` → G1 declined).

---

## 1 · Premise verification

Seven premises; eight verdicts (P5 splits into two clauses that resolve differently).

| # | Premise | Verdict | What was run → what was observed |
|---|---|---|---|
| P1 | 830 lines; auto mode 236 | **confirmed** | `wc -l` → 830. Step-boundary arithmetic: 8c = 595–830 = 236 (28.4%). All 18 spans sum to exactly 830 (asserted in the script, not eyeballed). |
| P2 | 8k + 8a/8b make `/prime` a session-state writer | **confirmed** | Opened `prime.md:497` (writes `logs/.session-marker` + per-id marker), `:530/:572/:627` (appends the `## {date} — Session {MARKER}` header to `session-notes.md`), `:537/:581/:640` (writes `logs/.prime-mtime`), `:782` (writes the run-manifest start-stub). Four distinct durable-state surfaces. |
| P3 | Auto mode duplicates `/session-start` + `/session-plan` | **confirmed** | Eight self-declared duplication sites: `:648`, `:656`, `:690`, `:756`, `:765`, `:782`, `:807`, `:818`. `:782` says outright *"keep the two in sync"* — a maintenance obligation the file imposes on itself. |
| P4 | Model alignment precedes task selection; `/session-plan` owns task tiering; `new-project` no longer emits the section | **confirmed** (all three clauses) | Step 4 @277 runs before the menu @289 and the operator's pick @348. `session-plan.md:86-93` owns `RECOMMENDED_MODEL`. `new-project.md` has **no** step 11a; all four surviving mentions are prohibitions (`:155`, `:359`, `:642`, `:694`). |
| P5a | `/open-items` is the broader backlog surface; `/prime` defers to it | **confirmed** | `open-items.md` scans friction-log, improvement-log, `inbox/`, next-up and every `session-plan-*` glob with tiering — against `/prime` Step 3's two files. `prime.md:341` already emits `Full backlog & inbox: /open-items`. |
| P5b | `/open-items` **owns** backlog reconciliation | **rejected** | `docs/backlog-reconciliation.md:3` names *itself* "the single definition of the reconcile-at-read primitive", with four co-equal consumers; `:65` names **`/prime` Step 1a as the reference implementation**. `/open-items` is a consumer, not the owner. |
| P6 | Concurrency hooks + `/session-start` own stronger live-session checks | **confirmed** | `prime.md:146` concedes *"the hook is the authority on liveness"* and calls its own scan *"today-scoped and heuristic"*. `session-start.md:26-58` owns the mtime foreign-write guard. Its shared-dir advisory carries the **identical** provenance tag `(C.2, 2026-06-05; extended id-15, 2026-06-05)` as `prime.md:138` — the same check written twice in two commands. |
| P7 | `/develop-ai-resource` requires smallest mechanism, clear ownership, reference-not-copy, removal of non-contributing material | **confirmed** | `develop-ai-resource.md:79`, `:139`, `:149`. All four criteria present verbatim. |

**P5b is rejected and judged NOT load-bearing — stated rather than glossed.** Its operative
direction (P5a) holds and is what the classification uses. Only the ownership wording is wrong, and
the correction changes exactly one row: **Step 1a becomes `retain`, not `delegate`**, because
deleting it would remove the primitive's own reference implementation and break
`docs/backlog-reconciliation.md:65`'s citation. The Frame's question survives intact. Recorded here
so the operator can overrule the judgement rather than discover it.

**One count correction, made against myself.** My first consumer census used `stat -f %i`, which on
macOS returns the *symlink's* inode, not the target's — it reported 30 distinct files and 1
canonical. Re-run with `stat -L -f %i`: **29 paths resolve to the canonical inode** (28 symlinks +
canonical) and **2 are genuinely distinct** 33-line variants carrying no allocator
(`workflows/research-workflow`, `axcion-sector-intelligence`). Positive control:
`strategic-os/.claude/commands/prime.md` → inode `13363220`, identical to canonical. This is the
same instrument-scope error class the repo has logged repeatedly; it is recorded rather than
silently corrected.

---

## 2 · Responsibility inventory — every step, measured

Spans computed from step anchors and asserted to sum to 830. Not estimated.

| Step | Lines | Count | % | Responsibility |
|---|---|---|---|---|
| preamble | 1–12 | 12 | 1.4 | Frontmatter, principle, output + execution discipline |
| 0 | 13–70 | 58 | 7.0 | Pull latest (behind-check, rebase strategy, 5 result cases) |
| 1 | 71–94 | 24 | 2.9 | Read session-notes; log-trio pre-fetch; telemetry-gap nudge |
| 1a | 95–163 | 69 | 8.3 | Git cross-check of Next Steps **+** sibling/concurrency detection |
| 1b | 164–175 | 12 | 1.4 | Resumable scratchpad detection |
| 1c | 176–214 | 39 | 4.7 | Project plan position |
| 1d | 215–233 | 19 | 2.3 | Active-mission scan |
| 2 | 234–237 | 4 | 0.5 | `next-up.md` |
| 3 | 238–276 | 39 | 4.7 | Urgent-item bounded scan |
| 4 | 277–288 | 12 | 1.4 | Exception checks incl. model alignment |
| 5 | 289–308 | 20 | 2.4 | Build the numbered menu |
| 6 | 309–347 | 39 | 4.7 | Output the brief |
| 7 | 348–356 | 9 | 1.1 | Classify the operator's reply |
| 8m | 357–365 | 9 | 1.1 | Mission binding |
| **8k** | 366–512 | **147** | **17.7** | **Marker allocation** |
| 8a | 513–562 | 50 | 6.0 | Numbered dispatch |
| 8b | 563–594 | 32 | 3.9 | Free-text dispatch |
| **8c** | 595–830 | **236** | **28.4** | **Auto mode** |

`8k` measures **147** at the step boundary; the closed stream reported **138** at the code-fence
boundary (`prime.md:370` ```` ```bash ```` → `:509` ```` ``` ````, = 140 lines inclusive). Three
numbers, three different objects: step span 147, fence-inclusive 140, the closed stream's 138.
The disagreement is explained rather than resolved to a single figure — per the method rule this
repo adopted 2026-07-29, a count that matches neither enumeration must not be reported as if it
matched both.

**Two blocks are 46.1% of the file.** `8k` + `8c` = 383 of 830 lines.

---

## 3 · Classification — retain · delegate · qualify separately · remove

| Step | Class | Owner it goes to | Now → target | Basis |
|---|---|---|---|---|
| preamble | **retain** | — | 12 → 10 | `/prime`'s own contract |
| 0 | **retain, slimmed** | rationale → `docs/` | 58 → 12 | Behind-check + pull is ~10 mechanical lines; ~45 are incident narrative (the 2026-07-14 S5→S8 story) that belongs in a reference doc |
| 1 | **retain** | — | 24 → 18 | Core orientation source |
| 1a | **retain** (git half) · **delegate** (concurrency half) | hook + `/concurrent-session-check` | 69 → 22 | **P5b correction: the git cross-check is the primitive's reference implementation and must stay.** The `SIBLING_COUNT` / `LIVE_FOREIGN_HERE` / shared-dir half duplicates `session-start.md:58` verbatim and is conceded weaker than the hook (P6) |
| 1b | **retain** | — | 12 → 10 | Small, orientation-specific |
| 1c | **qualify separately** | `/project-next-steps` | 39 → 12 | The step *already states* it reuses that command's Step 2 cascade — cite instead of restate |
| 1d | **retain, slimmed** | `/mission` for mechanics | 19 → 10 | Menu candidates are orientation; the contract mechanics are `/mission`'s |
| 2 | **retain** | — | 4 → 4 | Already minimal |
| 3 | **retain, slimmed** | `/open-items` for depth | 39 → 20 | P5a: `/prime` already defers for full backlog. The bounded-scan *discipline* (the 2026-07-13 ~50–60k/session fix) must stay; its ~19 lines of anti-regression rationale move to a doc |
| 4 | **retain** + **remove** stale prose | — | 12 → 10 | See finding F2 |
| 5 | **retain** | — | 20 → 18 | The menu is `/prime`'s reason to exist |
| 6 | **retain, slimmed** | — | 39 → 30 | The brief template is core; some branch prose compresses |
| 7 | **retain** | — | 9 → 9 | Number/free-text selection — named unloseable by the brief |
| 8m | **retain** | — | 9 → 8 | Small, dispatch-local |
| **8k** | **delegate** | new script + `docs/session-marker.md` | **147 → 12** | 88 of 147 lines are comment-only rationale. **Requires `/develop-ai-resource` — see F3** |
| 8a+8b | **retain, consolidated** | — | 82 → 30 | The marker→header→mtime sequence is written **three times** (8a, 8b, 8c). Write once |
| **8c** | **delegate** | `/session-start` + `/session-plan` | **236 → 45** | All eight P3 duplication sites. Retain only: item resolution, done-condition check, cross-repo mission guard, the single approval gate |

Nothing classified **remove** outright except the stale prose in F2 — the responsibilities are real;
it is their *ownership* that is misplaced.

---

## 4 · The ≤300-line test

```
retain as-is / lightly slimmed   preamble+1+1b+2+4+5+6+7+8m   141 → 117
retain, slimmed (cite not restate) 0+1a+1c+1d+3               224 →  76
delegate                          8k + 8a/8b + 8c             465 →  87
                                                              ---------
                                                        830 →  ~280
```

**Verdict: ≤300 is achievable — at roughly 280, with ~20 lines of headroom. It is tight, and it is
load-bearing on one decision.**

Sensitivity, stated because a target met only on optimistic assumptions is not met:

- **If 8c is genuinely delegated (→ ~45): total ~280. Target met.**
- If 8c is merely trimmed by half (→ ~118): total **~353. Target missed.**
- If only the allocator is extracted — the closed stream's package — the file goes
  `830 − 147 + 12 = ~695`. **Target missed by 395 lines.**

That last line is the arithmetic vindication of the G1 decline, derived here independently rather
than assumed from the operator's reasoning: the allocator boundary could never have reached a thin
`/prime`, because it is 17.7% of a file that needs to lose 66%.

**All four unloseable properties survive** — the short orientation menu (Step 5, retained), number
and free-text selection (Step 7, retained untouched), required `/session-start` synchronisation
(8a/8b consolidated, the `{gate:post-plan}` token chain preserved — `session-start.md:399` confirms
it is load-bearing), and safe dispatch (8m + the cross-repo mission guard retained).

**Falsification criteria, checked against this result:**

| Criterion | Status |
|---|---|
| "merely extracts the allocator" | **Not falsified** — the allocator is one of three levers and is shown *insufficient* (695 > 300) |
| "leaves copied `/session-start`/`/session-plan` logic inside `/prime`" | **Not falsified** — all eight P3 sites are classified `delegate` |
| "obtains the cut by moving prose into another always-loaded prompt" | **Not falsified** — verified: the *only* `@`-import in either CLAUDE.md is the conditional `@.claude/references/harness-rules.md` (`../CLAUDE.md:206`). `docs/*.md` are cited by path and read on demand. **Constraint recorded: moving prose into `harness-rules.md` WOULD falsify** |
| "inventing an unqualified durable resource" | **At risk — see F3.** The 8k lever needs a new script, which cannot be authored inside this loop |

---

## 5 · Findings

**F1 — SCOPE CONFLICT, load-bearing, needs an operator decision before Build.**
`.claude/commands/work-loop.md:247` states: *"Never edits `/prime`, workspace `CLAUDE.md`,
permissions, hooks or settings."* The object under work of this entire stream **is** `prime.md`.
The contract disagrees: `docs/work-loop.md` § Execution boundary says `/work-loop` implements
*"settled corrections to existing commands, skills, scripts and hooks"*, and `docs/work-loop.md:260`
explicitly contemplates *"reconsider a `/prime` step as its own separable change"* as legitimate.
The command file's own conflict rule resolves it — *"Where this file and the contract disagree, the
contract wins and the disagreement is a defect to report"* — so the stream may proceed on the
contract's authority. **But this is too load-bearing to settle by citation alone**: under the other
reading, every Build unit of this stream is prohibited and the stream is unbuildable. Recorded as
disposition `operator`, surfacing at **G1**, not as a new stop here (per the route's exactly-three
rule). **Note: the closed allocator-extraction stream planned to edit `prime.md` and neither of its
two Codex review rounds caught this** — a real blind spot that has already survived independent
review twice.

**F2 — `/prime` Step 4 carries prose describing a writer that no longer exists.**
`prime.md:281` reads *"This is the **normal** shape of the section as `/new-project` step 11a now
writes it, not an edge case."* Step 11a was deleted 2026-07-27 and `new-project.md:694` states the
*absent*-section case is *"the normal and expected state"* — the opposite branch. `/prime` calls the
wrong branch normal, citing a deleted step. Non-contributing material under P7's fourth criterion;
classified `remove`. Small, but it is direct evidence that the file's prose has drifted from its
collaborators.

**F3 — the 8k lever requires routing out, and this is a scheduling constraint on Shape, not a
blocker.** Delegating the allocator needs a **new** script — a new durable AI artifact. Workspace
`CLAUDE.md` § AI Resource Creation requires qualification through `/develop-ai-resource`, and
`docs/work-loop.md` § Execution boundary independently requires the same route. Because the script
is **one component of a live stream** and not the whole need, that section is explicit: the stream
stays open, the unit closes on its ordinary outcome (**not** `routed-out`), and the artifact's
disposition returns through the record. Shape must plan this hand-off explicitly, with both
`**Capability:**` and `**Settled upstream:**` labels — either alone is a malformed handoff that
`/develop-ai-resource` Step 1.0 rejects as a provenance error.

**F4 — the same check is written twice across two commands, and both copies are live.** The
shared-dir advisory carries the identical provenance tag `(C.2, 2026-06-05; extended id-15,
2026-06-05)` at `prime.md:138` and `session-start.md:58`. Independent corroboration of P3's pattern
outside auto mode: the duplication is not confined to 8c.

---

## 6 · Frame's question, answered

**What is the minimum responsibility `/prime` must retain?** Orient (read session state, surface
exceptions), present a short ranked menu, take a selection by number or free text, and dispatch
safely into `/session-start`. Everything else it currently does is either owned elsewhere already or
is rationale that belongs in a reference doc.

**Who owns the rest?** `/session-start` + `/session-plan` (mandate, context, plan, manifest,
execution), a new qualified script + `docs/session-marker.md` (marker allocation), the
SessionStart hook + `/concurrent-session-check` (liveness), `/open-items` (backlog depth),
`/project-next-steps` (plan position), `/mission` (mission mechanics).

**Is it in scope at all?** Yes on the contract's authority — with **F1 unresolved and routed to
G1**. Two of the three levers are ordinary in-scope edits; the third (8k) routes out as a component.

LIMITATIONS:
- **The ~280 figure is a design estimate, not a measurement.** Nothing was edited, so no target
  count was verified by execution. Shape must convert each target into a falsifiable per-step
  budget; Prove measures against those. Treat ~280 as "the target is reachable", never as "the
  target is met".
- **The 8c → ~45 estimate is the single largest uncertainty and carries the whole verdict.** It
  assumes `/session-start` and `/session-plan` can absorb auto mode's mandate/context/plan/manifest
  work through the existing `{gate:post-plan}` token chain. The token chain was verified to exist
  (`session-start.md:88`, `:399`; `session-plan.md` Step 8) but **was not exercised**, and auto
  mode's single-approval-gate semantics differ from 8a's pause. If that absorption fails, the
  target is missed by ~70 lines.
- **No independent review ran on this Frame.** The challenged route assigns reviews to Shape (the
  plan) and Prove (the result); Frame carries none by construction. So this classification has had
  no adversarial pass, and F1 in particular is a conflict I identified and then judged — the same
  hand doing both.
- **P5b was rejected and I ruled it non-load-bearing myself.** That judgement was not independently
  tested.
- **Per-step target budgets are apportioned, not derived.** They rest on reading each step's prose
  and estimating what compresses; no step was rewritten to check.
- **The two 33-line `prime.md` variants were counted and excluded, not read.** They carry no
  allocator, but whether a leaned canonical `/prime` stays compatible with them is unexamined.
