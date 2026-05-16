# Risk Check — 2026-05-16

## Change

Wire an automatic chain on Phase-3 session-start invocation: when operator types /session-start (after /prime), the chain auto-runs /session-plan → /qc-pass on the resulting session-plan.md → /scope. No operator confirmation between steps; the mandate captured at /session-start Step 2 is the only operator input until /scope completes.

Implementation approach (NOT a SessionStart hooks.SessionStart entry in settings.json — Claude Code hooks fire on lifecycle events as shell scripts and cannot invoke slash commands; injecting an instruction via stdout into Claude's context every session would fire even for ad-hoc sessions where the chain is unwanted):

(1) Edit ai-resources/.claude/commands/session-start.md: add new Step 5 after current Step 4 (Mandate written). Step 5 instructs Claude to auto-invoke /session-plan immediately, skipping the "Next: Run /session-plan to plan..." pointer message. Add operator opt-out: if mandate text or $ARGUMENTS contains the literal token "no-chain", skip the auto-chain.

(2) Edit ai-resources/.claude/commands/session-plan.md: replace current Step 8 (operator-triggered /qc-pass notice) with a new Step 8 that auto-invokes /qc-pass on the just-written session-plan.md. Add new Step 9 that auto-invokes /scope after /qc-pass returns the verdict. /qc-pass findings are surfaced for operator review but do not block the chain — operator dispositions findings after /scope completes.

Files touched: 2 command files. No settings.json edit. No new hook script. No SessionStart hook wiring. Reversible by reverting the two command file edits.

Affects every Phase-3 session that uses /session-start (the documented entry point per /prime's "Next" pointer). Operator can opt out via "no-chain" token. Plan-item flagged this as "shared-state automation + new hook wiring" but the actual implementation is command-spec edits only — no shared-state writes beyond what /session-plan + /qc-pass + /scope already produce individually, no hook wiring at all. Source: friday-act 2026-05-16 journal-improvements plan #1.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Implementation is command-spec only (no hooks, no settings, no shared-state writes beyond what the three commands already produce), but the chain creates a new contract where /session-plan auto-invokes /qc-pass + /scope — which mutates the long-documented "operator-triggered /qc-pass" contract that other docs and rituals still describe, and broadens the pay-as-used cost of every Phase-3 session by binding three commands (one Opus) to a single trigger.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Change is not always-loaded — both files are slash-command bodies, loaded only when the command is invoked. No CLAUDE.md edit, no @import, no SessionStart hook wiring. Verified: `session-start.md` is under `.claude/commands/` and is not @-imported by any CLAUDE.md (CHANGE_DESCRIPTION explicit: "No settings.json edit. No new hook script.").
- However, /session-start is the documented entry point for every Phase-3 session — `docs/operator-maintenance-cadence.md:47` lists `/session-start State mandate in 2–5 sentences` as the canonical Phase-3 opener; `docs/weekly-session-guide.md:74` and `:106` confirm this is the standard ritual. The chain therefore binds three commands to one trigger across every harness session.
- /session-plan declares `model: opus` and `effort: high` in frontmatter (`session-plan.md:1-4`). Auto-invoking it from /session-start means every Phase-3 session pays the Opus cost of /session-plan unconditionally, where today the operator can decline (`docs/session-rituals.md:12` lists /session-plan as *(optional)* — "Run for non-trivial sessions; skip for quick edits").
- /qc-pass (sonnet, spawns qc-reviewer subagent per `qc-pass.md:13-23`) and /scope (sonnet) add two further command-body loads + one subagent spawn per session.
- Opt-out via `no-chain` token mitigates but requires operator to remember the token; default path is "pay all three commands."

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edit per CHANGE_DESCRIPTION ("No settings.json edit. No new hook script. No SessionStart hook wiring.").
- No new tool patterns introduced — /session-plan, /qc-pass, /scope already exist and already run with current permissions. Chaining them does not grant any capability that ad-hoc invocation would not.
- No `allow`/`ask`/`deny` changes.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touches: 2 (`session-start.md`, `session-plan.md`).
- Grep across `ai-resources/.claude/commands/` and `ai-resources/docs/` for `session-start|/session-plan|/qc-pass|/scope` returned 20 files with 61 hits.
- Documents that describe the current ritual (and would describe an *operator-triggered* /session-plan / /qc-pass / /scope flow) and may go stale after this change:
  - `ai-resources/docs/session-rituals.md:12` — calls /session-plan *(optional)*; chain makes it mandatory absent opt-out.
  - `ai-resources/docs/session-rituals.md:73` — "`/qc-pass` — Run a quality check on work just produced. Default after every creation or improvement." Compatible in spirit, but now /qc-pass auto-fires on session-plan.md (an artifact this line doesn't anticipate).
  - `ai-resources/docs/weekly-session-guide.md:44, 58, 74, 79, 106, 159, 160, 164` — describes manual sequencing.
  - `ai-resources/docs/operator-maintenance-cadence.md:47` — Phase-3 cheatsheet shows /session-start as the first step; does not reference auto-chain.
  - `ai-resources/.claude/commands/prime.md:84` — "**Next:** Run `/session-start` to capture the session mandate, then `/session-plan` to plan model tier…" This pointer still says "then `/session-plan`" as a separate operator step.
  - `ai-resources/.claude/commands/session-plan.md:176-182` (current Step 8) — explicitly says "Do not invoke `/qc-pass` automatically." Change reverses this exact rule.
- /session-plan's Step 8 contract reversal is the most consequential blast: any other command or doc that depends on the "do not auto-invoke" semantics needs review.
- /qc-pass contract: it expects the caller to identify the artifact, prepare a handoff with operator request + scope, and "Wait for direction" at Step 5 (`qc-pass.md:13-27`). Auto-invoking from /session-plan means the operator's "wait for direction" gate is now followed by /scope instead of operator action — a behavioral change to /qc-pass's documented loop, even though /qc-pass.md itself is not edited.
- No code-level callers break (the chained commands keep working in their original direct-invocation form), but the documentation contract is non-trivially affected.

### Dimension 4: Reversibility
**Risk:** Low

- Two file edits; `git revert` restores both bodies cleanly per CHANGE_DESCRIPTION ("Reversible by reverting the two command file edits.").
- No settings cached state, no hook to unregister, no symlink to remove.
- Side-effect files produced during the chain (`logs/session-plan.md`, qc-pass subagent notes) are produced by the same commands today and already have established cleanup posture. A revert would not leave orphan state in `logs/session-notes.md` (the `**Mandate:**` line is written at Step 3, before the new Step 5, so revert does not affect that artifact).
- Operator muscle-memory cost is minor: after revert, the operator returns to manual sequencing exactly as documented today.

### Dimension 5: Hidden Coupling
**Risk:** High

- New implicit contract: `/session-plan` auto-invokes `/qc-pass` on `logs/session-plan.md`, and `/qc-pass` is then followed by `/scope`. This contract is undocumented in `qc-pass.md` and `scope.md`. The qc-pass handoff requires four items (artifact path, operator request, scope line, mechanical-mode hint) per `qc-pass.md:15-21`; the auto-invocation point in session-plan.md must construct these itself. The change description does not specify how `INTENT` from /session-plan maps to "the original operator request" in the qc-pass handoff — risk of degraded QC if the chained handoff omits operator context.
- Functional overlap: `/scope` (per `scope.md`) "produce a scope summary of the conversation so far" with five fields including "Decisions you are making… and what you will default to." `/session-plan` Step 7 already writes Intent / Class / Model / Source / Autonomy posture / Stop points / Risk — substantially overlapping the five `/scope` fields. Chaining both means the session produces two scope-like artifacts back-to-back; downstream consumers (operator review, later /risk-check, log-sweep) may not know which is authoritative.
- Silent firing for unintended contexts: `/session-start` is invoked manually by operator, so the chain does not auto-fire from a Claude Code lifecycle event — good. But CHANGE_DESCRIPTION says "Affects every Phase-3 session that uses /session-start." Some Phase-3 sessions today skip /session-plan (per `docs/session-rituals.md:12` — *(optional)*); after the change, opting out requires remembering the `no-chain` token. Operators who do not know about `no-chain` (or forget it on a trivial-edit session) will silently pay the full chain. The opt-out token is undocumented in the public-facing ritual docs (per the change description; this would need to be added but is not listed in the change scope).
- /qc-pass findings "are surfaced for operator review but do not block the chain — operator dispositions findings after /scope completes." This breaks the documented QC posture in `docs/qc-independence.md:15` — "Whenever a QC subagent … returns findings": the current loop expects the operator (or QC → Triage Auto-Loop) to disposition findings before continuing. Auto-running /scope between QC return and disposition is a new mode the qc-independence doc does not cover.
- /session-plan's Step 8 reversal ("Do not invoke `/qc-pass` automatically." → "auto-invoke /qc-pass") is a direct contradiction. Any operator-facing doc or onboarding artifact that quotes the current rule (verified above in `prime.md:84`, `session-rituals.md`, `weekly-session-guide.md`) becomes inconsistent until docs are updated — but doc updates are not listed in the change scope.

## Mitigations

- **Dimension 5 (Hidden Coupling) mitigation A — chain-handoff schema:** Before landing, specify in `session-plan.md` Step 8 exactly how the four `/qc-pass` handoff items (artifact path, original operator request, scope line, mechanical-mode hint) are constructed from /session-plan's `INTENT`, `CLASS`, and the session-plan.md path. Without this, the chained QC handoff is underspecified and findings quality may degrade.
- **Dimension 5 (Hidden Coupling) mitigation B — clarify /scope vs /session-plan overlap:** In the new Step 9 spec, explicitly state which artifact (session-plan.md or /scope output) is authoritative for downstream consumers, OR re-justify why both must be produced in the chain. Today /scope produces conversational scope; /session-plan writes a structured plan file. The chain should declare the relationship, not let operators (and later /risk-check) guess.
- **Dimension 5 (Hidden Coupling) mitigation C — doc-update batch:** Land the command edits together with corrective edits to (i) `prime.md:84` (Next pointer — remove the "then `/session-plan`" cue since it now runs automatically, or replace with "then optionally `no-chain`"); (ii) `docs/session-rituals.md:12` (/session-plan is no longer optional under the default chain); (iii) `docs/weekly-session-guide.md` and `docs/operator-maintenance-cadence.md:47` to surface the chain and the `no-chain` opt-out token. Without doc updates, the doc set contradicts the runtime behavior.
- **Dimension 5 (Hidden Coupling) mitigation D — QC-findings disposition posture:** Reconcile with `docs/qc-independence.md` § QC → Triage Auto-Loop. Either (i) the chain pauses if /qc-pass returns findings (matching the documented "wait for direction" posture in `qc-pass.md:27`), or (ii) the qc-independence doc is updated to explicitly carve out the session-plan auto-chain as a non-blocking context. Do not ship the chain with the rule reversal undocumented.
- **Dimension 1 (Usage Cost) mitigation — keep optional posture:** Default the chain to OFF unless operator opts in (`chain` token), instead of ON-by-default with `no-chain` opt-out. This preserves the `/session-plan` *(optional)* posture in `session-rituals.md:12` and avoids unconditional Opus spend on every Phase-3 session. If the design intent is on-by-default, document the cost trade-off in `weekly-session-guide.md` so the operator can see it.
- **Dimension 3 (Blast Radius) mitigation — Step 8 reversal callout:** Add an inline comment in the new `session-plan.md` Step 8 explicitly noting that this reverses the prior "Do not invoke `/qc-pass` automatically" rule, with a one-line rationale. This prevents future audits from reverting the new behavior on the assumption it drifted from the documented rule.

## Evidence-Grounding Note

All risk levels grounded in direct evidence — file/line references (e.g., `session-plan.md:176-182`, `prime.md:84`, `qc-pass.md:13-27`, `session-rituals.md:12`), grep counts (20 files, 61 hits for chain commands across `ai-resources/.claude/commands/` and `ai-resources/docs/`), and verbatim quotes from referenced files and CHANGE_DESCRIPTION. No training-data fallback was used.
