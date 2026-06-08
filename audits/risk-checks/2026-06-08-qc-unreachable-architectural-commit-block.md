# Risk Check — 2026-06-08

## Change

Plan-time gate. Change set: add a commit-blocking gate for architectural changes when independent QC is unreachable (1M-credit gate + >200k context, so /qc-pass cannot spawn the qc-reviewer subagent and a /model downgrade cannot fit the conversation). Edits:
(1) ai-resources/docs/qc-independence.md — extend the "Subagent-unavailable fallback" bullet (line 12) with an architectural-change escalation sub-clause: when QC is unreachable AND the artifact is an architectural change (defined by pointer to audit-discipline.md § Risk-check change classes), the soft self-QC-and-provisionally-commit path does NOT apply; the gate is commit-blocking; defer via /handoff QC-PENDING -> /clear -> fresh session -> /prime -> /qc-pass -> commit. Also elevate the preventive /model switch as the primary path for architectural changes. Non-architectural artifacts unchanged.
(2) ai-resources/.claude/commands/qc-pass.md — add a short failure-handling note to Step 3 keyed on the "Usage credits required for 1M context" error, routing to the qc-independence.md fallback (architectural -> escalate; otherwise -> soft fallback).
(3) ai-resources/skills/handoff/SKILL.md — add a QC-PENDING convention to continuity mode: a **QC-PENDING:** marker line after **Saved at:**, a mandatory first line in ## Resume With instructing independent /qc-pass before commit, and a matching ## Operator Directives entry. Touches the continuity-mode output template and Step C1.
(4) Axcion AI Repo/CLAUDE.md (workspace root) — one-line pointer in § QC Independence Rule: architectural changes whose independent QC is unreachable are commit-blocked; defer via /handoff to a fresh session; full mechanics in qc-independence.md. Pointer only, no duplication.
(5) ai-resources/.claude/commands/wrap-session.md — insert a new Step 12c (QC-PENDING commit guard) between Step 12b (end-time risk-check gate, line 437) and the staging/commit step (line 439): before staging, check whether the session produced/modified any risk-check-change-class artifact that did not receive a passing independent QC this session; if found, do not stage/commit it, write/refresh a QC-PENDING continuity scratchpad via /handoff, surface a chat warning, and commit only the QC-clean remainder.
(6) ai-resources/logs/improvement-log.md — add one parked entry recording a PreToolUse commit-block hook NOT built at v1; parked via Review-cycle field with concrete trigger = recurrence logged in friction-log.md.

"Architectural change" is defined by pointer to audit-discipline.md § Risk-check change classes (no new definition invented). Resume path is /handoff -> /clear -> /prime -> /qc-pass -> commit. Design was validated by a prior system-owner advisory.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/handoff/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists (referenced-by-pointer source of the change-class definition)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped, doc-and-instruction-level guard with no hook, no permission change, and clean revert — but it introduces a new commit-blocking enforcement step in `/wrap-session` and a new `## Resume With` first-line contract that `/prime` parses, so it needs two paired mitigations before landing.

## Consumer Inventory

Search terms: `qc-independence` (basename of edited doc), `Subagent-unavailable` (the bullet being extended), `QC-PENDING` (new marker), `Resume With` / scratchpad (the `/prime`-parsed continuity contract the change extends), `/handoff` (invoked by the new wrap-session guard and the resume path), and the wrap-session Step 12b/12c anchor. Grep run across `ai-resources` and the workspace root.

Functional consumers (the ones that execute against the touched contracts — registry/audit/scratchpad mentions of `qc-independence` are documentation echoes, not behavioral dependencies, so they are excluded from must-change scoring):

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/wrap-session.md | co-edits | yes |
| ai-resources/skills/handoff/SKILL.md | co-edits | yes |
| ai-resources/docs/qc-independence.md | co-edits | yes |
| ai-resources/.claude/commands/qc-pass.md | co-edits | yes |
| Axcion AI Repo/CLAUDE.md (workspace root) | co-edits | yes |
| ai-resources/logs/improvement-log.md | co-edits | yes |
| ai-resources/.claude/commands/prime.md | parses | yes (de facto) |
| ai-resources/.claude/commands/handoff.md | invokes | no (thin pointer to SKILL.md, line 16) |
| ai-resources/.claude/commands/save-session.md | invokes | no (deprecated alias) |
| ai-resources/docs/audit-discipline.md § Risk-check change classes | imports (definition source) | no (referenced read-only by pointer) |

Total: 10 distinct consumers; 7 must-change. Six are the change's own edit targets (co-edits). The seventh is **`prime.md`**, NOT named in CHANGE_DESCRIPTION — this is a blast-radius finding (see Dimension 3): `/prime` Step 1b reads the scratchpad's `## Resume With` section and "take[s] the first content line" as the resume candidate (prime.md line 98, line 122). The change makes that first line a fixed QC-instruction string, which collides with `/prime`'s assumption that the first line is the substantive next action.

`QC-PENDING` is a brand-new marker — grep returned zero pre-existing consumers, so the inventory for that token covers only the contract the change introduces.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Edit (4) adds one pointer line to an always-loaded file (workspace root `CLAUDE.md`, § QC Independence Rule). Described as "Pointer only, no duplication" — one line is well under the ~50-token Medium threshold.
- All other edits land in pay-as-used files: `qc-independence.md` and `audit-discipline.md` are read-on-demand ("When to read this file" gated, qc-independence.md line 3); `qc-pass.md`, `wrap-session.md`, `handoff/SKILL.md` load only when their command/skill runs; `improvement-log.md` is a log.
- No hook registered, no `@import` added, no subagent brief expanded. Edit (6) explicitly parks the PreToolUse hook rather than building it — the highest per-call-cost option is deferred.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edit anywhere in the change set. None of the six edit targets is a settings file; no `allow`/`ask`/`deny` entry added, narrowed, or removed.
- No new tool-invocation pattern authorized. The new wrap-session guard *restricts* what gets staged (commits only the QC-clean remainder); it grants no new capability.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory: 10 consumers, 7 must-change. Six are the change's own declared edit targets (expected). The risk driver is the **one unanticipated consumer**: `prime.md`.
- **Unanticipated-consumer finding (`prime.md`).** `/prime` Step 1b reads `## Resume With` and takes "the first content line" as a resume candidate (prime.md:98) and a menu-item-1 candidate (prime.md:101, prime.md:122). Edit (3) makes the *mandatory first line* a fixed "run independent /qc-pass before commit" instruction. After the change, `/prime` will surface the QC instruction as the resume action rather than the substantive task — which is arguably *correct* for a QC-PENDING handoff, but it is an interaction CHANGE_DESCRIPTION does not mention and `/prime` was not updated to recognize. This is a backwards-compatible-but-silent contract shift, not a break.
- **Contract change — `## Resume With` template.** The continuity-mode output template in `handoff/SKILL.md` (lines 71–111) is the single source for the scratchpad shape; `handoff.md` (line 16) and the deprecated `save-session.md` are thin pointers, so they inherit the change without separate edits. Good — the contract lives in one place.
- **Shared-infra touch.** `wrap-session.md` is shared infra invoked at every planned session end. Inserting a commit-blocking Step 12c between 12b (line 437) and the staging step (line 439) changes the commit path for *every* session, not just architectural-change sessions. The guard self-scopes (only blocks risk-check-class artifacts lacking a passing QC), so most sessions pass through untouched — but the new branch executes on every wrap.
- No caller is *broken* by the change; the `prime` interaction and the wrap-path insertion are the reasons this is Medium rather than Low.

### Dimension 4: Reversibility
**Risk:** Low

- Edits (1)–(5) are text edits to five tracked files; `git revert` restores them fully within the working tree.
- Edit (6) appends one parked entry to `improvement-log.md`. This is the one append-only-log mutation, but it is a *parked* (inert) entry, not state that propagates downstream — a revert that leaves it carries no behavioral cost, and removing it is a one-line edit. Below the Medium "stale log entry carries forward" bar because nothing consumes a parked entry until a friday-checkup park-drain, which would simply not find it.
- No `settings.json` cached state, no hook to unregister, no symlink, no push or external write in the change set. Clean rollback.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New cross-file contract: the `QC-PENDING:` marker.** Edit (3) introduces a `**QC-PENDING:**` marker line and a fixed `## Resume With` first line; edit (5) makes `/wrap-session` *write* that scratchpad, and the resume path expects a *fresh* `/prime` + `/qc-pass` to *honor* it. The producer (`handoff` SKILL + `wrap-session`) and the consumer (the human-driven resume path) are coupled by a convention. The convention is documented at the change sites (SKILL.md template + qc-independence.md), which keeps this at Medium rather than High — but note that **nothing automatically enforces the marker on resume**: a fresh session that runs `/prime` will surface the QC line (via Step 1b) but there is no mechanical block stopping the operator from committing without running `/qc-pass`. The guard is advisory at the resume end and only enforcing at the wrap end.
- **Implicit dependency on `/prime` Step 1b sort behavior.** The QC-PENDING handoff only resurfaces if `/prime` selects that scratchpad as newest-by-mtime (prime.md:96) and its date ≥ last session-notes entry (prime.md:98). If a later trivial session writes a newer scratchpad, the QC-PENDING one is superseded and skipped silently (prime.md:99) — the pending-QC signal can be lost. This is an undocumented coupling between the new guard and the existing scratchpad-supersession rule.
- **Overlap with the existing soft-fallback path.** qc-independence.md line 12 already defines a "provisionally cleared" soft path. The change forks behavior on the artifact being "architectural" (by pointer to audit-discipline.md change classes). Two paths now key off the same 1M-credit failure; the split point is the change-class definition, which is stable and referenced (not re-invented), so the overlap is controlled — but it is a second mechanism reacting to the same trigger.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index).

- **OP-12 (closure before detection) — served, not violated.** The change adds *enforcement of an existing gate* (independent QC), not a new detection capability. It closes a known hole (architectural changes slipping through on a soft self-QC-only path) and pairs the block with a working closure channel (the `/handoff -> /clear -> /prime -> /qc-pass -> commit` resume path). New detection that does not close is the OP-12 failure; this is the opposite.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — respected.** Edit (6) explicitly *parks* the PreToolUse commit-block hook rather than building it, with a concrete re-trigger (recurrence in friction-log). The change builds only the doc/instruction layer for a consumer that exists today (the real, observed 1M-credit + >200k-context failure mode, documented in the archived 2026-06-05 S17 entry). No "hook for Phase 2."
- **OP-5 (advisory vs enforcement) — a genuine enforcement upgrade, but bounded and acknowledged.** The change does move one mechanism from advisory toward enforcement: `/wrap-session` Step 12c will *block the commit* of an un-QC'd architectural artifact, where today the soft fallback "provisionally clears" it. Per OP-5 this is a per-component enforcement decision — and CHANGE_DESCRIPTION makes it loudly and on purpose ("the gate is commit-blocking"), and notes the design "was validated by a prior system-owner advisory." Because the enforcement upgrade is explicit and recorded rather than silent drift, this is a deliberate, acknowledged decision (OP-11-consistent), so it scores Low, not High. The scope is narrow: enforcement applies only to risk-check-change-class artifacts with no passing QC, leaving non-architectural work on the unchanged soft path.
- **OP-2 (automate execution, gate judgment) — consistent.** The judgment (is this artifact safe to commit without independent QC?) stays gated; the change does not auto-approve it, it defers it to a fresh QC pass. No routine execution is newly gated.
- **DR-1 / DR-3 (placement) — correct tiers.** Mechanics live in `docs/qc-independence.md` (canonical doc), the convention in the `handoff` SKILL, the guard in the `wrap-session` command, the cross-cutting rule as a one-line pointer in workspace `CLAUDE.md`, and the parked hook in `improvement-log.md`. Each fragment sits in its canonical home; no methodology is dumped into always-loaded CLAUDE.md (pointer only).

## Mitigations

- **Dimension 3 / Dimension 5 (the `prime` interaction):** Before landing edit (3), update `/prime` Step 1b — or, at minimum, the QC-PENDING scratchpad template — so the QC-PENDING signal is recognized as such rather than mistaken for the substantive next action. Concretely: have the `## Resume With` block lead with the `**QC-PENDING:**` marker (already in edit 3) AND ensure `/prime` Step 1b surfaces the marker, not just "the first content line," when present. This closes the unanticipated `prime.md` consumer gap surfaced in the inventory. (Pairs the Medium Blast Radius down by making the one unanticipated consumer an intentional, updated one.)
- **Dimension 5 (pending-QC signal loss on scratchpad supersession):** Add one sentence to the qc-independence.md sub-clause (edit 1) or the SKILL.md QC-PENDING convention (edit 3) stating that a QC-PENDING scratchpad must NOT be silently superseded by a later trivial scratchpad — e.g., the resume path completes (QC runs, commit lands) before the next wrap writes a newer scratchpad, or the QC-PENDING marker is carried forward. This documents the otherwise-implicit coupling to `/prime`'s mtime-newest supersession rule (prime.md:96–99) so the pending-QC block cannot be lost by a later session.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references: qc-independence.md:12, audit-discipline.md:19–32, prime.md:96–101/122, wrap-session.md:437/439, handoff/SKILL.md:71–111, handoff.md:16, save-session.md:5; grep counts for `QC-PENDING` = zero pre-existing consumers; principle IDs from principles-base.md). No training-data fallback was used.
