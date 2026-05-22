# Risk Check — 2026-05-22

## Change

Proposed change: Add a new "## `/goal` Command Scope" section to the workspace-level CLAUDE.md (/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md), inserted after the "Session Guardrails" section. Workspace-wide scope (this file is loaded as parent context in all project sessions).

Proposed section text:

## `/goal` Command Scope

`/goal` (Claude Code built-in) auto-continues a session until a small-model evaluator judges a completion condition met. Permitted **only** inside designated heavy read-and-report commands (`/token-audit`, `/repo-dd`, `/audit-repo`, `/analyze-workflow`) with a fully mechanical exit condition (countable from the transcript, not a quality judgment). Do NOT use `/goal` for sessions that land structural changes, hit a `/risk-check` class, cross an operator decision point or between-gate summary, run in plan mode, or could trigger a QC → Triage loop. `/goal` clearing is not a completion verdict — it does not substitute for `/qc-pass`, and its turn cap resets on `--resume`.

Rationale: `/goal` is a new Claude Code built-in (v2.1.139+, ~May 2026) that removes per-turn operator pauses; a Haiku evaluator decides session completion. A System Owner consultation returned an ADOPT-NARROW verdict — `/goal`'s auto-continue + transcript-only evaluator can bypass the workspace gate architecture (Autonomy Rules pause conditions, /risk-check change classes, /qc-pass, between-gate summaries, Completion Standard). The rule both authorizes the safe narrow use and prevents misuse. This is a cross-cutting always-loaded CLAUDE.md edit (~85 words added to always-loaded context).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists

## Verdict

RECONSIDER

**Summary:** The rule text contains an internal contradiction — it whitelists `/repo-dd` as a permitted `/goal` host, but `/repo-dd` opens with an `[Operator Gate]` and runs a triage-and-fix pipeline, both of which the rule's own exclusion list forbids; the whitelist also names commands whose downstream behavior the operator-loaded rule cannot bind, leaving a high hidden-coupling risk with no clean mitigation at the CLAUDE.md layer.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The change adds a new always-loaded section to the workspace-level `CLAUDE.md`, which `CHANGE_DESCRIPTION` itself states "is loaded as parent context in all project sessions." Workspace `CLAUDE.md` is currently 175 lines (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` lines 1–175) and is loaded every turn of every session.
- `CHANGE_DESCRIPTION` self-reports the addition at "~85 words added to always-loaded context." At a rough 1.3 tokens/word that is ~110 tokens of permanent per-session overhead — above the ~50–150 token Medium calibration band, below the >150 High threshold.
- The cost is unconditional: the rule governs a command (`/goal`) that, per the change's own scoping, is relevant only inside four heavy commands, yet the rule text is paid on every turn of every session including project sessions that never run those commands.
- Not High because the addition is a single bounded section with no `@import` chain and no hook registration.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` file is referenced or modified by this change — the only referenced file is `CLAUDE.md` (`REFERENCED_FILE_PATHS` lists one entry).
- The change adds no `allow` / `ask` entry and removes no `deny` rule. `/goal` is described as a "Claude Code built-in"; the change does not register or authorize a new tool family.
- The change is restrictive in intent — it narrows when an already-available built-in may be used. A behavioral restriction in CLAUDE.md does not widen the permission surface.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touch: 1 file (workspace `CLAUDE.md`). Enumeration of dependents below.
- Grep `"/goal"` across the workspace and `ai-resources/` (`*.md`, `*.sh`, `*.json`, excluding `audits/risk-checks/`): 0 matches. No existing command, hook, doc, or skill references `/goal` today — the rule introduces a wholly new term into always-loaded context.
- The four whitelisted commands all exist: `.claude/commands/token-audit.md`, `repo-dd.md`, `audit-repo.md`, `analyze-workflow.md` (confirmed present). The rule names them but does not edit them, so callers are not modified — however the rule asserts a contract those four command bodies do not currently document.
- The rule references multiple existing always-loaded constructs by name: Autonomy Rules pause conditions (`CLAUDE.md` lines 76–91), `/risk-check` change classes (lines 88, and `docs/audit-discipline.md` § Risk-check change classes lines 15–35), `/qc-pass` (line 44), between-gate summaries (line 60), QC → Triage Auto-Loop (lines 97–99), Completion Standard (lines 50–52). It is consistent with all of these as currently written, so no contract break — but it couples to six separate sections, any of which changing would require revisiting this rule.
- Medium not High because no caller file requires modification to keep working and no existing contract is broken; the elevated component is the breadth of named dependencies (6 CLAUDE.md sections + 4 command files).

### Dimension 4: Reversibility
**Risk:** Low

- The change is a single additive section in one tracked file (`CLAUDE.md`). `git revert` of the commit removes the section cleanly and fully restores the prior 175-line file.
- No sibling files or directories are created. No data/log file is mutated. No `settings.json` cached state is involved.
- No state propagates beyond the local repo: the change is text in a tracked markdown file, not a push, external write, or automation registration.
- One minor residual: once the rule is published, an operator may begin using `/goal` inside the whitelisted commands; a later revert removes the guardrail text but not the operator's acquired habit. This is muscle-memory drift, not a rollback blocker — it keeps the dimension at Low rather than Medium because the underlying `/goal` built-in is operator-invoked, not auto-fired by repo config.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Internal contradiction in the rule text.** The rule whitelists `/repo-dd` as a permitted `/goal` host. But `repo-dd.md` Step 1 is explicitly labelled `### Step 1: Scope Selection [Operator Gate]` and instructs "Ask the operator which scope to audit" (verbatim from `.claude/commands/repo-dd.md` head). The rule's own exclusion list forbids `/goal` for sessions that "cross an operator decision point." A command that opens with an operator gate cannot satisfy the rule's exclusion clause, so the rule simultaneously permits and forbids `/goal` for `/repo-dd`.
- **Whitelisted command runs a fix/triage pipeline the rule excludes.** `repo-dd.md` is described in its own header as "audit the workspace, compare to the previous audit, triage findings, and fix what's approved" and `grep` confirms it references `triage` / `risk-check` / `subagent`. The rule excludes sessions that "land structural changes" and that "could trigger a QC → Triage loop." `/repo-dd` in `deep`/`full` mode does both. The "fully mechanical exit condition" qualifier is not enough to rescue this — the command's scope inherently crosses the exclusion list.
- **The rule asserts a contract that the four command files do not carry.** A reader of `token-audit.md` / `repo-dd.md` / `audit-repo.md` / `analyze-workflow.md` sees nothing about `/goal` (grep: 0 `/goal` matches in any of the four). The "permitted only inside these commands" contract lives only in workspace `CLAUDE.md`, far from the command bodies it governs. An operator editing one of those commands later — or a subagent spawned by one of them — has no local signal that a `/goal` constraint applies. This is an undocumented-at-the-change-site contract.
- **Transcript-only evaluator vs. subagent-based commands.** All four whitelisted commands dispatch subagents (`audit-repo.md` verifies "8 agent files"; `repo-dd` references `subagent`). Per the repo's Subagent Contracts (`ai-resources/CLAUDE.md` lines 32–40), audit subagents "write full notes to disk and return only a short summary." A `/goal` Haiku evaluator judging completion "from the transcript" sees only the short summaries, not the disk notes — so the evaluator's "mechanical exit condition" is being computed against a deliberately lossy view. The rule does not name this interaction; it is a silent dependency on what the transcript contains.
- **`/goal` is undocumented anywhere in the repo.** Grep across workspace + `ai-resources/` returns 0 matches for `/goal`, `auto-continue`, or `Haiku evaluator` (outside this risk-check directory). The rule is the first and only mention. There is no `docs/` page, no command file, and no skill describing `/goal` behavior, version gating (`v2.1.139+`), or the `--resume` turn-cap reset the rule alludes to. The rule depends on operator knowledge that exists nowhere in the repo.
- High because there are multiple implicit dependencies (subagent-summary lossiness, six named CLAUDE.md sections, four command bodies) AND an outright internal contradiction (`/repo-dd` permitted-and-forbidden) AND a new contract documented only at a site remote from the commands it binds.

## Recommended redesign

- Drop the per-command whitelist from the always-loaded CLAUDE.md rule. Instead, make `/goal` permission opt-in *at each command*: add a one-line `/goal`-eligibility note to the frontmatter or header of only the command files that genuinely have no operator gate and no fix/triage stage (on current evidence `/token-audit` and `/audit-repo` are candidates; `/repo-dd` is not — it has an `[Operator Gate]` at Step 1 and a fix pipeline; re-inspect `/analyze-workflow` for the same). This puts the contract where the operator and any future editor will actually see it, and removes the always-loaded token cost.
- Replace the workspace-CLAUDE.md section with a much shorter pointer (one sentence: "`/goal` auto-continue is governed per-command — see the `/goal`-eligibility note in individual command files; never use it for sessions that land structural changes or cross a gate") and move the full rationale, version gating, and `--resume` caveat into a dedicated `ai-resources/docs/goal-command-policy.md`. This cuts the always-loaded cost from ~110 tokens toward ~25 and gives `/goal` a real documentation home, resolving the "undocumented anywhere" coupling.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. The behavior of the `/goal` Claude Code built-in itself is taken only as described in CHANGE_DESCRIPTION — it could not be verified against repo files because `/goal` has zero matches anywhere in the workspace or `ai-resources/`.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is RECONSIDER._

# Pre-Change Advisory — `/goal` Command Scope Rule (Implementation Shape)

## Routing position

Per the architecture map's "Canonical homes by artifact type" and the Q4 placement heuristic supplied in the routing context, the proposed change is **mis-routed at the placement layer, not the policy layer**. The change has three distinct content types, and the original design forced all three into one home:

| Content | What it actually is | Correct home |
|---|---|---|
| "Restrict `/goal` to a whitelist; forbid it for gated sessions" | A cross-project always-loaded behavioral rule | Workspace `CLAUDE.md` — but only the *one-sentence* form |
| Whitelist + mechanical exit conditions + version gating + `--resume` caveat | Multi-section methodology reference | `ai-resources/docs/goal-command-policy.md` (load-on-demand) |
| "This command is `/goal`-eligible" | Per-command eligibility fact | The command file itself |

The redesign in the risk-check report routes each of the three to its correct home. That **is** the architecture map's prescription — the redesign is not a workaround, it is the routed answer. The original ~85-word block conflated a methodology reference with a cross-project rule, which `DR-5` forbids directly: CLAUDE.md files hold cross-session rules only, not methodology (`principles.md § DR-5`). An 85-word whitelist with mechanical exit conditions and a version caveat is methodology.

## We concur with the RECONSIDER verdict

The verdict is correct and the central defect it names is real. Two points reinforce it from the grounding base:

1. **The internal contradiction is a hard `OP-3` violation waiting to ship.** The rule whitelists `/repo-dd` while `/repo-dd` opens with an `[Operator Gate]` and runs a triage-and-fix pipeline — both forbidden by the rule's own exclusion list. Landing a rule that contradicts itself is silent conflict resolution embedded in always-loaded context (`principles.md § OP-3`, `§ AP-1`). Every session would load a rule that cannot be coherently applied. RECONSIDER is the right gate output.

2. **The High hidden-coupling risk has no clean mitigation at the CLAUDE.md layer — and that is structural, not fixable by rewording.** A CLAUDE.md rule cannot bind the downstream behavior of four command files it does not own. If `/audit-repo` later adds a decision-point gate, the always-loaded whitelist silently goes stale, and nothing detects it — this is exactly the "two-end contract" / string-literal-coupling failure flagged in `risk-topology.md § 5` ("Signals that elevate a change to structural risk"). A whitelist in CLAUDE.md naming four commands is a four-way two-end contract with no enforcement of the other end.

## The recommended redesign is the right path — with two refinements

The redesign (a) per-command opt-in note + (b) one-sentence CLAUDE.md pointer + full policy in `docs/goal-command-policy.md` is correct and we endorse it. It resolves the contradiction by construction: an opt-in note lives in the eligible command file, so an ineligible command like `/repo-dd` simply never carries the note — there is no whitelist to fall out of sync. This satisfies `DR-3` (component type determines home), `DR-5` (CLAUDE.md is not a methodology home), and the `risk-topology.md § 4` placement constraints. It also collapses the always-loaded token cost from ~85 words to one sentence — material, since every line of CLAUDE.md costs tokens on every turn (`system-doc.md § 2.5`, Context window / Token usage constraints).

Two refinements before this lands:

- **The per-command opt-in note is itself a canonical command-file edit, which is a `/risk-check` change class.** Editing `/token-audit`, `/audit-repo`, and possibly `/analyze-workflow` under `ai-resources/.claude/commands/` touches auto-synced canonical commands — `risk-topology.md § 3` classes "Canonical command/agent edit" as `/risk-check`-gated, blast radius "all projects." The redesign is lower-risk than the original but it is **not** a zero-risk change. The re-check should treat the command-file edits as in scope, not just the CLAUDE.md pointer.

- **Re-inspecting `/analyze-workflow` is not optional — it is the same defect class the verdict caught.** The redesign already flags this. Make it a gate: `/analyze-workflow` is eligible only if it has no operator gate and no triage-and-fix pipeline. Confirm by reading the command file before adding the note. Adding the note without that read would re-commit the `/repo-dd` mistake at a different command (`principles.md § AP-6` — recommendations applied without checking what they actually affect; this is the per-command analogue of the `DR-9` top-3 check).

## The risk the dimension review missed

The five-dimension review scored hidden coupling High but **missed a sixth, more fundamental risk: the rule may be unenforceable in principle, because a `/goal` transcript-only evaluator cannot see what it is being asked to gate on.**

The routing context states it directly: all four whitelisted commands dispatch subagents that write notes to disk and return ≤30-line summaries per the Subagent Contracts. A `/goal` evaluator that judges "did the mechanical exit condition hold" reads **only the ≤30-line summaries**, not the subagent working notes. The "mechanical exit conditions" the rule depends on may live entirely in the on-disk notes the evaluator never sees.

This is a `model-limitation`-class problem, not an `instruction-quality` one (`principles.md § AP-9` failure-classification table). No amount of rule rewording fixes an evaluator that is structurally blind to its own exit signal. It directly threatens the OP-1/OP-9 ambition that automation must genuinely reduce operator burden — a `/goal` loop that exits on a signal it cannot actually observe produces *false* mechanical exits, which is worse than no automation (`principles.md § OP-1`, `§ AP-2` — a plausible-looking wrong result is worse than an explicit gap).

**Implication for the redesign:** the `docs/goal-command-policy.md` file must specify, per eligible command, *where the mechanical exit condition is observable from* — in the returned summary, or only in the on-disk notes. A command whose exit condition is only in the notes is **not** `/goal`-eligible regardless of whether it has an operator gate. This is a stricter eligibility test than "no gate, no triage pipeline," and it should be the first filter applied when re-inspecting `/token-audit`, `/audit-repo`, and `/analyze-workflow`.

## Clear position

The right answer is: **do not land the original ~85-word block. Adopt the redesign, with the eligibility test tightened to three conditions** — (1) no operator gate, (2) no triage-and-fix pipeline, (3) mechanical exit condition observable from the returned summary, not buried in on-disk subagent notes. Re-run `/risk-check` on the redesign treating the canonical command-file edits as in-scope `/risk-check` change classes (`risk-topology.md § 3`, `principles.md § DR-8`). The ADOPT-NARROW verdict on the rule's *intent* still stands; only the implementation shape changed, and the redesign is the correct shape.

One named conflict for the operator, not smoothed: the redesign trades a single always-loaded rule for a four-file change set (CLAUDE.md pointer + new doc + 2–3 command edits) that auto-syncs into every project. That is more surface area to land and a wider `/risk-check` blast radius than the original — but it is the *correct* surface area, because the original's smaller footprint was achieved only by mis-housing methodology in CLAUDE.md (`DR-5`) and accepting an unenforceable cross-file contract (`risk-topology.md § 5`). Smaller-but-wrong is not a real saving here.
