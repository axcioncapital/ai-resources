UNIT: 2026-07-29-review-layer-consolidation-frame
STREAM: 2026-07-29-review-layer-consolidation
PHASE: frame
REPO: ai-resources
BASE: aa0e26621689ea35b724733506b084b8218cc016
NEXT: Codex — brief the Shape unit

Status: complete

EVIDENCE

## Route

`challenged`. Criteria that fired: the stream retires or removes active resources (nine
reviewer commands assessed for retirement; embedded reviewer stacks removed from eight
workflows), and it touches `/risk-check` structural change classes as listed at
`docs/audit-discipline.md:60-65` — hook edits, cross-cutting `CLAUDE.md`, and restructuring
of shared-state automation. The `reviewed` thresholds (≥5 files, shared symlinked resources)
are also exceeded; ambiguity resolves upward per `docs/work-loop.md` § Route triggers.

Frame carries no gate and no review. G1 arms at the end of the Shape unit.

## Premise verification

### P1 — Live non-prime workflows still invoke overlapping reviewers automatically. CONFIRMED

Run: `grep -rl "/{token}" --include='*.md' .claude/commands .claude/agents skills docs
templates workflows .agents` for each of `qc-pass`, `refinement-pass`, `refinement-deep`,
`triage`, `resolve`, `contract-check`, `blindspot-scan`, `implementation-triage`,
`risk-check`, `consult`, `reconcile`; then line-level `grep -nE` across 18 workflow command
files.

Positive control: the same primitive returned 0 files for `/zzz-nonexistent-command` and 49
live files for `/qc-pass`. The negative results below are therefore checks that can fire.

Observed — automatic (not operator-triggered) reviewer invocations:

| Site | Line(s) | What fires automatically |
|---|---|---|
| `.claude/commands/pm.md` | 88, 137, 146, 162 | Internal `qc-reviewer` pass on every PM ruling, pass cap 2. Documented divergence from `/consult`, which has none. |
| `.claude/commands/friday-act.md` | 284–285, 489 | "Plan-file QC (**automatic**)" — invokes `/qc-pass` on written plan files before announcing them; findings corrected via the QC → Triage auto-loop. |
| `.claude/commands/promote-workflow.md` | 37, 185, 189, 248, 282 | P5 gates: `/risk-check` then an independent `/qc-pass` per item. "No edit lands without `/risk-check` GO; no commit lands without independent QC." |
| `.claude/commands/fix-project-issues.md` | 93–115, 141 | `system-owner` subagent dispatch as a `/consult`-equivalent, plus `/qc-pass` after **every** substantive artifact edit. |
| `.claude/commands/new-project.md` | 433, 440 | Architecture Gate invokes `/implementation-triage` via the Skill tool between Stage 3b and 3c. |
| `.claude/commands/resolve-incident.md` | 78, 114–119 | `/risk-check` on High/protected, plus a `/consult` Function B second opinion recorded verbatim. |
| `.claude/commands/cleanup-worktree.md` + `skills/worktree-cleanup-investigator/references/execution-protocol.md` | 66, 77, 104 / 106, 132, 185 | Three sequential subagents on one plan: `qc-reviewer` → `triage-reviewer` → second `qc-reviewer`. |
| `.claude/hooks/auto-qc-nudge.sh` | 1–25 | PostToolUse(Write\|Edit): nudges `/qc-pass` on any written file ≥50 lines, once per path per session. No operator involved. |
| `.claude/hooks/auto-resolve-nudge.sh` | 1–20 | Stop hook: emits a `systemMessage` telling the session to run `/resolve` whenever the QC nudge fired earlier in the session. |

Weaker / already-conditional sites, recorded for completeness: `scope-project.md:70,72`
(`/implementation-triage` and `/blindspot-scan` both marked **optional** and gate-placed);
`monday-prep.md:266-267` (operator guidance prose: "/qc-pass after every creation or
improvement", "/triage before approving any suggestion set");
`fix-repo-issues.md:285` (plan-file QC explicitly **not** auto-triggered).

Reviewer agents on disk (10): `qc-reviewer`, `refinement-reviewer`, `triage-reviewer`,
`risk-check-reviewer`, `reconcile-reviewer`, `scope-qc-evaluator`, `expert-check-reviewer`,
`innovation-triage-auditor`, `system-owner`, `project-manager`.

### P2 — /work-loop already makes Codex the reviewer and handles finding adjudication. CONFIRMED

Run: read `docs/work-loop.md` in full (261 lines).

Observed: § Route → depth → stops, line 74 — reviewed route is "One Codex review of the
result. `/qc-pass` only as fallback, when Codex cannot reach the object." Line 75 —
challenged is "Codex before implementation and after, **in separate units**." § Block
formats, line 202 — six dispositions (`fixed` · `deferred` · `rejected` · `already-true` ·
`out-of-scope` · `operator`) followed by "`/resolve` and `/triage` do not fire — adjudication
is the loop's own step 7."

### P3 — Deterministic checks and irreversible-action confirmations are distinct safeguards. CONFIRMED

Run: `ls .claude/hooks/`; read `.claude/hooks/pre-commit:1-30` and
`.claude/hooks/check-destructive-liveness.sh:1-20`; observed this unit's own brief commit
emit `Running skill validation... No SKILL.md files in this commit. Skipping skill
validation.` and the `[staging-tripwire]` PreToolUse message.

Observed, two layers that contain no model-judgment reviewer:

- **Deterministic** — `pre-commit` (unresolved-conflict-marker block; append-order guard via
  `logs/scripts/check-append-order.sh`; skill validation), `check-skill-size.sh`,
  `check-template-drift.sh`, `check-permission-sanity.sh`, `check-foreign-staging.sh`.
- **Irreversible-action confirmation** — `check-destructive-liveness.sh`, a PreToolUse(Bash)
  liveness probe run immediately before `git worktree remove` / `git branch -D`; and the
  wrap-time push confirmation (workspace `CLAUDE.md` § Push behavior).

`check-destructive-liveness.sh:14-20` states the distinction directly and from evidence:
"`/risk-check` is likewise the wrong home: it runs at PLAN time, reads the repo at rest, and
a session can go live between the gate and the act... Liveness must be probed at EXECUTION
time, by the executor, immediately before the command. That is a PreToolUse hook, and nothing
else." The same block records that a prose gate stating the identical rule already existed
and did not fire. These safeguards are therefore a different class from the reviewer stack
and are correctly listed as Protected in the brief.

## Frame's question: what is the need, who owns it, is it in scope

The need is real and its shape is now measured: automatic reviewer stacking is implemented at
**four independent layers**, and only two of them are owned by this repository.

**Layer 1 — unconditional policy. OUT OF SCOPE for this stream.**
Workspace `CLAUDE.md` lines 57, 65–79 and 129 carry the rules that make stacking mandatory:
QC Independence Rule ("Run `/qc-pass` after producing or editing any substantive artifact or
plan, before approval or commit. **Never skip QC as an efficiency call.**"), the
Contract-Conformance Check trigger list, the Blind-Spot Scan Gate ("Run `/blindspot-scan`
**automatically** — never wait for the operator to ask"), and the QC → Triage Auto-Loop
pointer.

Verified out of `REPO: ai-resources`: `git rev-parse --show-toplevel` at that path returns
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` with remote `workspace-root.git`, and
`git ls-files --error-unmatch ../CLAUDE.md` from this repo returns
`fatal: '../CLAUDE.md' is outside repository`. It is a **different git repository**. It is
additionally named in `.claude/commands/work-loop.md` § What this command never does.

Consequence for the brief: the falsification condition "non-plan Codex-reviewed work still
stacks a general reviewer" **cannot be fully discharged by edits inside `ai-resources`**.
The unconditional rule survives every in-repo edit. This requires a separate operator-owned
change in `workspace-root`, or a re-issued brief declaring `REPO: workspace-root`. Shape must
plan around it explicitly rather than assume it away.

**Layer 2 — mechanical hooks. IN SCOPE, with a contract defect to report.**
`.claude/hooks/auto-qc-nudge.sh` and `.claude/hooks/auto-resolve-nudge.sh` live inside
`ai-resources`. `docs/work-loop.md` § Execution boundary, line 44, states `/work-loop`
implements "settled corrections to existing commands, skills, scripts **and hooks**".
`.claude/commands/work-loop.md` § What this command never does states "Never edits `/prime`,
workspace `CLAUDE.md`, permissions, **hooks** or settings."

These disagree. The command file's own precedence rule — "Where this file and the contract
disagree, the contract wins and the disagreement is a defect to report" — resolves it in
favour of the contract: hook edits are in scope. **Reported here as a defect in
`.claude/commands/work-loop.md`.** (Same class as the conflict already recorded in the open
`2026-07-29-prime-minimum-responsibility-shape` brief, lines 23–24, about `/prime`. The
prohibition list and the execution boundary have now collided twice.)

**Layer 3 — embedded reviewer stacks in workflow commands. IN SCOPE.**
The eight sites tabulated under P1, all under `.claude/commands/` and
`skills/worktree-cleanup-investigator/`.

**Layer 4 — in-repo authoritative docs and operator guidance. IN SCOPE.**
`docs/qc-independence.md` (34 lines — cited by workspace `CLAUDE.md` as the "full
methodology", so the majority of the QC policy body is genuinely editable here),
`docs/audit-discipline.md`, `docs/session-rituals.md`, `docs/weekly-cadence.md`,
`docs/weekly-session-guide.md`, `docs/friday-cadence-runbook.md`,
`docs/operator-maintenance-cadence.md`, `docs/onboarding-daniel.md`,
`docs/onboarding-daniel-cheatsheet.md`, `docs/materiality-bar.md`.

**Ownership answer.** The stream has a legitimate owner here for layers 2–4. Layer 1 belongs
to a different repository and to the operator. No routing to `/scope-project` or
`/develop-ai-resource` is warranted — nothing new must be authored, and no new enduring
programme is implied.

## Exclusion check

Files written by this unit: `logs/loop/2026-07-29-review-layer-consolidation-frame.brief.md`,
`logs/loop/2026-07-29-review-layer-consolidation-frame.evidence.md`. No prime-owned file
(`.claude/commands/prime.md`, `/session-start`, `/session-plan`,
`docs/backlog-reconciliation.md`, any `*prime-minimum-responsibility*` artifact) was read into
a write path or modified. Verified by the staged pathspec of each commit in this unit.

## Deferrals recorded

- **`/qc-pass` and `/risk-check` final retirement — deferred** until the
  `2026-07-29-prime-minimum-responsibility` stream lands, per the brief. Their commands and
  agents stay on disk. No registry, compatibility layer or new gate was created to represent
  this deferral; this evidence entry and the record in `logs/decisions.md` are the whole
  representation.

LIMITATIONS:

- **Scope of the consumer search was this repository only.** Project directories under
  `<workspace>/projects/` were not scanned. Symlinked copies resolve to the canonical files
  edited here and so are covered; a project holding a *forked* (non-symlink) copy of a
  reviewer command would not be caught. Not checked, and it should be checked at Shape before
  any command is retired.
- **Cost was taken as given, not measured.** The brief asserts the stack "adds cost"; no
  token measurement was run against `logs/usage-log.md` to size it. Acceptable for Frame —
  the need does not turn on the magnitude — but it means no baseline exists to judge the
  saving at Prove. Shape should either establish one or state that the claim is
  structural rather than quantitative.
- **`workflows/research-workflow/` was searched but not assessed.** It carries its own
  `.claude/commands/qc-pass.md` and four `/risk-check` references. Whether it is in scope is
  a Shape question; the brief's scope list does not name it.
- **Layer-1 dependency is unresolved by design.** Frame states the boundary; it does not
  resolve it. If the operator does not land the workspace-`CLAUDE.md` change, the stream can
  still remove layers 2–4 but must not claim the falsification condition is met.
