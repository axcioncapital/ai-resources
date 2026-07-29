UNIT: 2026-07-29-review-layer-consolidation-shape
STREAM: 2026-07-29-review-layer-consolidation
PHASE: shape
REPO: ai-resources
BASE: 2cb245e0399bcadc66ac64c1cb011208e5180753
NEXT: Operator — G1 (scope and package)

PLAN v3 — G1 PACKAGE

Supersedes `…-shape.plan-v2.md`. Immutable; v1 and v2 are retained unedited.
Written after Codex review-2 (verdict REVISE, final broad review round). All four material
findings **accepted**; none rejected. Two bounded scope-of-claim corrections are recorded in § 0
with citations — they narrow what this stream may *claim*, not what it does.

---

## 0. Adjudication of review-2

| Finding | Disposition | Basis |
|---|---|---|
| **R2-F1** — `/risk-check` still preserved as an automatic parallel review layer | **ACCEPTED in full.** v2's "KEEP unchanged" is reversed. | The mandate is explicit and v2's counter-argument does not survive it. v2 leaned on `docs/work-loop.md:65` (*"The route never absorbs, replaces or reschedules it"*) — but that line is **an in-repo policy this stream may edit**, not an external constraint, so it was circular. The seven dimensions are a review *brief*, not a capability only a separate command has. Frame's own premise already excluded it from the protected set: *"Protected deterministic and execution-time controls contain no judgment reviewer"* — `/risk-check` spawns `risk-check-reviewer`, a model. Removing it therefore does not trip the brief's protected-safeguard falsifier. § 2. |
| **R2-F2** — authoritative policies excluded from the edit set | **ACCEPTED in full**, including QC-PENDING removal. v2's retention argument is withdrawn. | Verified at every cited location. `audit-discipline.md:56-101` still defines the classes, the two-gate model and *"There is no auto-firing hook — this is a discipline enforced by this file"*. `ai-resource-creation.md:19` still states *"These pipelines include QC gates — skipping them means skipping quality assurance"*; `:25` pins its residue loop to *"capped at 2 passes — same discipline as `docs/qc-independence.md` § QC → Triage Auto-Loop"*, machinery this plan deletes; `:46` claims *"`/risk-check` (via `risk-check-reviewer` Dimension 6) enforces this gate at land-time"*, which becomes false. `ai-resource-builder/SKILL.md:337` Step 6 is a blanket main-agent QC scan. On QC-PENDING: v2 argued `prime.md`'s consumption compelled retention — the review is right that this is a **migration concern, not authority**. Corrected. |
| **R2-F3** — "remove all automatic `/qc-pass` invocation" did not match the end state | **ACCEPTED in full.** | All three retentions confirmed: `cleanup-worktree.md:64,93` (two QC passes + triage between, `:155` refusing operator skip); `promote-workflow.md:189` (*"Run `/qc-pass` on each item's evidence artifact"*); v2's B1 rule 3 (*"Outside `/work-loop`, one `/qc-pass`"*). The overstated claim is deleted and the test *"no automatic general QC where Codex has reviewed or will review the same change"* is applied uniformly. § 3, § 4. |
| **R2-F4** — the package reproduces the ceremony it removes | **ACCEPTED in full.** | Twelve slices → **four**, in the shape the review prescribed. § 3. |

### Correction 1 (within acceptance of R2-F1) — two automatic `/risk-check` firings are unreachable from this stream

The brief excludes `.claude/commands/prime.md`, `session-start.md` and `session-plan.md`. Two of the
thirteen `/risk-check` sites are inside them and are **live automatic invocations**, not stale prose:

- `prime.md:816` — *"Run `/risk-check` if STRUCTURAL_RISK is true. This is the plan-time gate."*
- `session-plan.md:157` — emits *"Run `/risk-check` after the plan is approved… Run it again before commit."*

Consequence for the package: this stream removes every automatic firing **it is permitted to touch**
and no more. Until the sequenced follow-up in § 6 lands, the plan-time gate still fires from `/prime`.
**No evidence line, commit message or summary may state that automatic `/risk-check` invocation has
been removed repo-wide.** The permitted claim is stated verbatim in § 9 falsifier 3.

### Correction 2 (within acceptance of R2-F2) — QC-PENDING has eight live consumers, three of them unreachable

Removing the requirement is accepted. Naming the blast radius is required to do it safely:

| Consumer | Reachable here? |
|---|---|
| `docs/qc-independence.md:12` (the definition) | yes — S1 |
| `.claude/commands/wrap-session.md:227` (12c commit guard) | yes — S2 |
| `.claude/commands/qc-pass.md:26` | yes — S2 |
| `.claude/commands/promote-workflow.md:283` | yes — S2 |
| `skills/handoff/SKILL.md:75, 78, 177-194, 215-218` | yes — S2 |
| `docs/session-marker.md:248` (historical rationale only) | yes — left unchanged, it narrates a past incident |
| `.claude/commands/prime.md:168, 171, 173, 174, 322` | **no — excluded** |
| workspace `CLAUDE.md:57` | **no — different repo** |

`prime.md` keeps live QC-PENDING detection logic after this change. It becomes inert rather than
wrong: nothing will write the marker any more, so its detection never fires. That is a tolerable
end state for the interval, and it is the first item of § 6.

---

## 1. The target operating rule

One independent review per change, proportional to consequence. This is the flow the corrected
package must produce, stated as the review required:

| Change | Flow |
|---|---|
| **Small or mechanical** | Claude edit → deterministic verification → finish. No model review. |
| **Normal consequential** | Claude implementation → deterministic evidence → **one Codex review** → fix material findings → finish. |
| **High-consequence or destructive** | **Risk-aware Codex review** → operator decision where necessary → implementation → deterministic execution-time safeguard. |

Three properties hold across all three rows:

1. **No general Claude QC runs automatically, anywhere.** `/qc-pass` survives on disk in exactly two
   roles: the operator types it, or Codex is unreachable and it is the explicitly chosen fallback.
2. **`/risk-check` is not a second reviewer.** Its seven dimensions become part of the Codex review
   brief for the third row. The command survives on the same two terms as `/qc-pass`.
3. **A second review round happens only after a material finding forced a redesign** — never on a
   wish for more assurance, never on a pass counter.

Deterministic and execution-time safeguards are untouched in all three rows. So are specialist
evaluators that produce a command's own primary output (§ 5).

---

## 2. `/risk-check` — automatic invocation removed

Thirteen sites, all inspected. Nine are reachable and change; two are excluded (Correction 1); two
need no edit.

| Site | What it is | Disposition |
|---|---|---|
| `docs/audit-discipline.md:56-101` | The two-gate rule, class list, verdict + invocation semantics | **Rewrite** — S1 |
| `docs/autonomy-rules.md:19` | Autonomy Rule #9, the pause trigger | **Rewrite** — S1 |
| `docs/protected-zones.md:13-24, 29` | Six rows carrying *"`/risk-check` mandatory"* | **Rewrite the Required-review column** to risk-aware Codex review — S1 |
| `docs/repo-architecture.md:217` | Q5 routing question | **Rewrite** — S1 |
| `docs/ai-resource-creation.md:46` | *"`/risk-check` … enforces this gate at land-time"* | **Rewrite** — S1 |
| `docs/work-loop.md:65` + route table | *"never absorbs, replaces or reschedules it"* | **Rewrite** — the reviewed and challenged routes' Codex brief becomes risk-aware — S1 |
| `.claude/commands/wrap-session.md:225` | 12b end-time gate — automatic | **Remove** — S2 (after the transition run, § 7) |
| `.claude/commands/resolve-incident.md:78` | `RISK = High` OR `PROTECTED = yes` → invoke | **Remove** — S2 |
| `.claude/commands/friday-journal.md:167, 184, 248` → `friday-act.md:279, 488` | Flag-then-fire chain across two commands | **Remove both ends together** — S2 |
| `.claude/commands/promote-workflow.md` P5.1, `:282` | *"No edit lands without `/risk-check` GO"* | **Remove** — S2 |
| `.claude/commands/prime.md:816` | Plan-time gate | **Excluded — survives.** § 6 item 1 |
| `.claude/commands/session-plan.md:157, 159, 211` | Two-gate pointer | **Excluded — survives.** § 6 item 1 |
| `.claude/commands/implementation-triage.md:63`, `archive-project.md:370` | Prose comparison; a design-time note | **No edit** — neither invokes at runtime |

**Is a manual specialist path retained?** The review permits one *only if* a concrete non-Codex
invocation route **and** a distinct consequential use are both evidenced. The candidate was
`/friday-act:279`, which is genuinely non-Codex. It fails the second test: under § 1 a consequential
`/friday-act` fix gets one risk-aware Codex review, which covers the same seven dimensions on the
same change. **No distinct use survives, so no specialist path is retained.** `/risk-check` ends in
the same position as `/qc-pass` — on disk, operator-invoked, deletion deferred on consumer grounds
(26 consumers, § 8).

---

## 3. The edit set — four slices

One commit per slice, one work-loop Build unit per slice. Files are assigned to exactly one slice.

### S1 — Governing review/risk policy and proportionality

Governing documents only; no command files. This slice is the keystone: it is what makes the
removals in S2 correct rather than arbitrary.

| File | Change |
|---|---|
| `docs/qc-independence.md` | **Rewrite as the § 1 rule.** Removes: *"Post-edit QC is mandatory"* (`:8`), the plan-QC requirement (`:10`), the self-check-before-plan-QC step (`:11`), the whole QC-PENDING architecture (`:12`), the entire `## QC → Triage Auto-Loop` section (`:14-34`) including auto-spawn, the two-pass cap, and the cap-exhaustion clause that depends verbatim on *"the second post-edit QC"* and *"how many triage + fix passes ran"*. **Retained, rewritten to stand alone:** context isolation (`:7`), mechanical-mode acceptance (`:9`, now the "small or mechanical" row), the materiality floor pointer (`:16`), and halt-and-surface — rekeyed to *"a material finding left unresolved"* instead of a pass counter. |
| `docs/audit-discipline.md` | § Risk-check change classes → the classes survive **as the consequence test that selects § 1 row three**, not as a gate that fires a command. § When to fire (`:73-81`) deleted. § Verdict semantics (`:84-88`) deleted. § Invocation semantics (`:90-92`) rewritten. The 2026-07-03 class-boundary clarification (`:67`) and the premise-verification precondition (`:82`) are **retained** — the latter migrates to the Codex review brief, since reasoning from an unverified premise is the failure it names. § Subagent Proportionality (`:103`) retained. |
| `docs/autonomy-rules.md:19` | Rule #9 rewritten: a structural change class means the change takes § 1 row three, not that a command fires. Rule count and the other nine untouched. |
| `docs/work-loop.md` | `:65` rewritten; the route table's **Independent review** column made risk-aware for `reviewed` and `challenged`. Routes, stops, gates and escalation semantics untouched. |
| `docs/protected-zones.md` | Required-review column: six *"`/risk-check` mandatory"* cells → risk-aware Codex review. The zone list itself is unchanged — protection is not weakened, its discharge route changes. |
| `docs/repo-architecture.md:217` | Q5 rewritten to route to § 1 row three. |
| `docs/ai-resource-creation.md` | `:19` blanket *"pipelines include QC gates"* → the proportional rule. `:25` residue-loop cap decoupled from the deleted auto-loop (the residue check itself survives — § 5). `:46` land-time enforcement claim corrected. |
| `skills/ai-resource-builder/SKILL.md` | Step 6 *Quality Check* (`:337`) → deterministic authoring checks only, the "small or mechanical" row. The Consumer-Inventory Gate (`:~365`) and Misinterpretation Check are **retained unchanged** — both are mechanical, and `:375` already says the inventory gate belongs *before* the gate, not at it. `:389`'s reference to `/qc-pass` as a downstream pass is corrected. |

### S2 — Automatic hooks and embedded general-review removals

| File | Change |
|---|---|
| `.claude/hooks/auto-qc-nudge.sh` | **delete** (verified present, 1394 b) |
| `.claude/hooks/auto-resolve-nudge.sh` | **delete** (verified present, 786 b) |
| `.claude/settings.json` | remove the two hook entries at `:73` and `:122`. **No `allow`/`ask`/`deny` entry touched.** |
| `wrap-session.md` | `:225` 12b end-time `/risk-check` gate removed; `:227` 12c QC-PENDING commit guard removed |
| `qc-pass.md:26` | QC-PENDING escalation removed; the command keeps its two surviving roles |
| `skills/handoff/SKILL.md` | QC-PENDING directive removed (`:75, 78, 177-194`); `:215-218` marker-teardown rationale retained — it is about session markers, not QC |
| `pm.md` | internal QC pass removed (`:88, 94, 130-150, 162, 167`); `:162` already concedes `/consult` answers harder questions with none |
| `cleanup-worktree.md` + `skills/worktree-cleanup-investigator/references/execution-protocol.md` §§ 3, 4, 6 | **QC → triage → QC collapses to one risk-aware Codex review of the plan**, with `/qc-pass` as the named Codex-unavailable fallback. `:155`'s refusal is rewritten to defend *the single review*, not the chain. Bias counter 3 (`:46`, `:62`) is rekeyed off the second pass. **Untouched:** Step 13 gate-coverage cross-check, Step 13b Section 7 population, Section 4 hard gates and named confirmation phrases, bias counters 1/2/4, `check-destructive-liveness.sh`, post-commit filesystem verification, `execution-protocol.md` §§ 7-10. |
| `promote-workflow.md` | P1 (`:181-194`) — per-item `/qc-pass` → **deterministic evidence qualification** (cited artifact exists on disk, cited lines resolve, item meets the materiality floor). QC-fail-defers-never-drops is preserved as evidence-fail-defers. P5.1 `/risk-check` and P5.2 independent `/qc-pass` (`:248`) removed; `:282-283` rewritten. **Untouched:** the P4 anti-clobber contract (`:128`), P6 deterministic verification, the P5.4 push gate. |
| `resolve-incident.md` | `:78` `/risk-check` removed; `:114-119` `/consult` second opinion → operator-invoked. `status: escalated` stop retained. |
| `friday-journal.md` | Step 5.5 `qc-reviewer` (`:155-176`, `:323`) removed — it is unskippable-from-inside today. Risk-class flagging (`:167, 184, 248`) removed with its `/friday-act` consumer. **Untouched:** Step 5.4 mechanical pre-check, 5.6 drop-check, 5.7 deterministic risk-class scan. |
| `friday-act.md` | `:279` risk-check firing removed; sub-step 16k (`:284-290`, note `:489`) → operator-invoked; `:488` gate note rewritten |
| `fix-project-issues.md:141` | per-edit `/qc-pass` restatement removed. Step 1 gating re-derivation, Step 2 gated-item stop, `system-owner` dispatch (`:93-115`) untouched. |
| `reconcile.md` | Step 3's automatic `/contract-check` (`:56-61`) removed — the file itself calls it *"corroborating evidence only, never a hard dependency"* (`:61`). `reconcile-reviewer` (`:65`) **kept** (§ 5). |

### S3 — Specialist dispositions and protected-safeguard verification

| File | Change |
|---|---|
| `docs/reconcile-report-template.md` | `CONTRACT_CHECK_RESULT` field removed (S2's paired consumer) |
| `refinement-deep.md`, `resolve.md` | **Retirement deferred** on consumer grounds. Both become operator-invoked-only in fact once S2 removes their automatic callers; neither is deleted. One status line each. |

Its substance is verification, not edits: every surviving evaluator in § 5 confirmed against the live
file, and every protected safeguard proven byte-identical (§ 9 falsifier 5). A thin edit set here is
the correct outcome — most specialist decisions are decisions *not* to change something.

### S4 — Consumer/migration evidence, guidance, decision record

- **Layer-4 guidance** restated from the old rule: `docs/session-rituals.md`, `weekly-cadence.md`,
  `weekly-session-guide.md`, `friday-cadence-runbook.md`, `operator-maintenance-cadence.md`,
  `onboarding-daniel.md`, `onboarding-daniel-cheatsheet.md`, `monday-prep.md:266-267`.
  Not touched: `docs/materiality-bar.md` (the finding floor survives intact).
- **One append-only entry in `logs/decisions.md`** recording: the `/risk-check` reversal from v2's
  KEEP and why; both deletion deferrals on consumer grounds with the 26-consumer count and the
  whole-directory symlink; the eight real separate project files (six diverged) that canonical edits
  cannot reach; `positioning-research`'s locally wired nudge hooks; and the § 6 follow-up.
  **An entry in an existing log — not a registry, layer or gate.**

---

## 4. What is removed, stated exactly

Nine automatic `/qc-pass`-family sites and nine reachable automatic `/risk-check` sites. After S1-S4,
**no general Claude QC and no risk-reviewer subagent fires automatically from any file this stream is
permitted to edit.** Two automatic `/risk-check` firings survive in excluded prime-owned files
(Correction 1). That is the whole claim; § 9 falsifier 3 fails any broader one.

---

## 5. Surviving evaluators — invocation route and unique output

The review requires each to be stated. The test each passes: **it produces the command's own primary
output, so removing it removes the command's purpose — it is not a review of work Codex reviews.**

| Evaluator | Invocation route | Unique output |
|---|---|---|
| `scope-qc-evaluator` | `/scope-project` Stage 5 (`scope-project.md:68`) — the stage *is* the delegation | The five-way readiness verdict and three-way decision ledger the stage exists to emit |
| `reconcile-reviewer` | `/reconcile` (`reconcile.md:65`) | Mandate-compliance score, resource-activation audit, genericness check, root-cause class |
| skill-evaluation subagent | `/create-skill:37`, `/improve-skill:49`, `/migrate-skill:52` | The `evaluation-framework.md` behavioral analysis and convention gate against a drafted skill |
| generalization-residue check | `/graduate-resource` Step 5.5 (`ai-resource-creation.md:25`) | Grep-scan for source-project residue in a generalized file — mechanical detection, not judgment |
| `new-project` Architecture Gate | `new-project.md:433, 440` | One advisory ROI call at a real decision gate, once per pipeline, already non-blocking |
| audit/scan engines | `repo-dd-auditor`, `token-audit-auditor`, `lean-repo-auditor`, `diagnostics-scanner`, `system-owner` in `/fix-project-issues` | Each *is* its command's analysis |

Nothing is added to this set. No component is created to replace anything removed.

---

## 6. Sequenced follow-up — explicitly owned, not a decision-log footnote

The end state in § 1 is **not reached** when S1-S4 land. Two follow-ups complete it, in this order:

1. **Prime-owned files** (`ai-resources`, blocked by this stream's brief, not by the Prime stream's
   content): `prime.md:816` plan-time `/risk-check` firing; `prime.md:168, 171, 173, 174, 322`
   QC-PENDING detection; `session-plan.md:157, 159, 211` two-gate pointer. Owner: whichever unit next
   holds prime-owned files. Until it lands, the plan-time gate still fires.
2. **Workspace root** (`REPO: workspace-root` — a different repository, outside this stream by the
   brief): `CLAUDE.md:57` (the unconditional QC mandate and the QC-PENDING commit-block), `:61`
   (Subagent Proportionality pointer), `:65, 69` (contract-check triggers keyed on *"two or more
   rounds of `/qc-pass` → `/resolve` → re-QC"*, which cannot occur after S1), `:121` (Autonomy pause
   trigger #9), `:129` (auto-loop pointer). Until it lands, the workspace rule still says to run
   `/qc-pass` after every substantive artifact, and **behavior in workspace-rooted sessions does not
   change**.

Both are named as work with an owner and an order, not as observations.

---

## 7. Transition safeguard — the current gate is run once, not waived

`/risk-check`'s end-time gate is binding **at the moment this change commits**: the change set
includes hook deletions, `settings.json` edits and cross-cutting edits to three files
`protected-zones.md` itself marks *"`/risk-check` mandatory"* (`audit-discipline.md`,
`autonomy-rules.md`, `qc-independence.md`).

- **End-time gate: run once**, after S4's edits exist and before the S1 commit lands. Payload
  describes the executed change set across all four slices. PROCEED-WITH-CAUTION → apply mitigations
  before commit; RECONSIDER → redesign before commit.
- **Plan-time gate: not run, and not silently skipped.** Its stated purpose is *"catches design risk
  before tokens are spent on execution"* (`audit-discipline.md:75`). Two full Codex plan reviews have
  served that purpose on this exact design. Recorded here so the decision is visible rather than
  absent.

After the S1 commit lands, future work follows § 1. This is the last `/risk-check` this stream runs.

---

## 8. Consumer inventory (carried from v2 § 1 — review-2 closed it as FIXED)

Method: `find -L projects -name '{cmd}.md' -path '*/.claude/commands/*'`, plus
`find projects -maxdepth 3 -path '*/.claude/commands' -type l`.

Exactly one directory-level symlink exists and it is whole-directory:
`projects/axcion-design-studio/.claude/commands -> ../../../ai-resources/.claude/commands`. That
project consumes **every** canonical command, so any canonical deletion breaks it immediately.

`qc-pass` 26 · `refinement-pass` 26 · `refinement-deep` 26 · `triage` 26 · `resolve` 26 ·
`contract-check` 22 · `blindspot-scan` 19 · `implementation-triage` 26 · `risk-check` 26 ·
`consult` 28 · `reconcile` 15 · `pm` 22. Eight are real separate files (inode-verified, not `diff`);
six of those have diverged from canonical, and canonical edits reach none of the eight.

All symlinks resolve into `ai-resources/` on `main`. This worktree is `ai-resources-2` on
`session/2026-07-29-2`. **Nothing here reaches a consumer before merge.**

---

## 9. What would falsify this plan

1. **A broken consumer of either shape.** Both predicates return empty, both shown to fire first:
   ```
   find -L projects -path '*/.claude/commands/*.md' ! -exec test -e {} \; -print
   find projects -maxdepth 3 -path '*/.claude/commands' -type l ! -exec test -e {} \; -print
   ```
   Positive control on **both** shapes — a scratch broken file-symlink and a scratch broken
   directory-symlink. A control on one shape only does not clear this criterion.
2. **A count regression.** § 8's counts re-derived with `find -L` after the change must be identical.
3. **An overclaim.** Any evidence line, commit message or summary stating that automatic
   `/risk-check` or `/qc-pass` invocation is removed *repo-wide* or *workspace-wide*, or that the § 1
   end state is reached. The permitted claim is § 4's, bounded by Correction 1 and § 6.
4. **Replacement machinery.** `git diff --name-status {BASE}..HEAD` shows any `A` outside
   `logs/loop/2026-07-29-review-layer-consolidation-*`. No new command, agent, hook, registry,
   wrapper, gate or maintenance programme.
5. **A weakened protected safeguard.** Non-empty `git diff {BASE}..HEAD --` over the six protected
   hooks; or changed text in `cleanup-worktree.md` Section 4 / Section 7 / Steps 13, 13b, or
   `execution-protocol.md` §§ 7-10, or `friday-journal.md` Steps 5.4 / 5.6 / 5.7, or
   `promote-workflow.md` P4 / P6 / P5.4; or any `allow`/`ask`/`deny` entry changed.
6. **An excluded file touched.** `prime.md`, `session-start.md`, `session-plan.md`,
   `docs/backlog-reconciliation.md`, `.claude/commands/work-loop.md`, `workflows/research-workflow/**`,
   any `*prime-minimum-responsibility*` path.
7. **A deferred deletion happened.** Any canonical `.claude/commands/*.md` or `.claude/agents/*.md`
   deleted. Only S2's two hook scripts may be deleted.
8. **A dangling reference to removed machinery**, outside `logs/loop/` and outside the § 6 files:
   ```
   grep -rn 'second post-edit QC\|triage + fix passes\|QC-PENDING\|two-gate\|plan-time gate' docs/ .claude/ skills/
   ```
9. **The transition gate was skipped.** No `/risk-check` verdict recorded for the executed change set
   before the S1 commit.

---

## 10. Limitations

- **The end state is not delivered by this stream alone.** § 6 items 1 and 2 are required. Behavior
  in workspace-rooted sessions does not change until item 2 lands.
- **`docs/work-loop.md` is edited by a unit running inside the loop it defines.** The brief excludes
  `.claude/commands/work-loop.md` but not this file, and R2-F1 mandates the risk-aware Codex brief.
  The edit is confined to the review brief's content and `:65`; routes, stops, gates and escalation
  semantics are untouched.
- **`/cleanup-worktree` and `/promote-workflow` move a review across models.** Their single surviving
  review is a Codex review, which means an operator running them outside a Codex session uses the
  named `/qc-pass` fallback. This is a real workflow cost, accepted rather than hidden.
- **`prime.md` retains inert QC-PENDING detection** for the interval — nothing will write the marker,
  so it never fires. Wrong-looking, not dangerous.
- **No token baseline.** Savings are stated as passes and prompts removed, never as a figure.
- **Eight real separate project files keep today's behavior**, six already diverged. Not fixable from
  this repository.
- **§ 8 covers `projects/` only.** `knowledge-bases/`, `harness/` and `workflows/` were not swept;
  Prove extends the `find -L` sweep to those roots before any deletion is ever scheduled.
- **`workflows/research-workflow/` excluded** per settled scope; no claim is made about it.
