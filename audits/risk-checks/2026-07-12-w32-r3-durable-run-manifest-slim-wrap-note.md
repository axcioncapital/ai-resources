# Risk Check — 2026-07-12

## Change

W3.2 R3 execution. Structural change across 3 core commands + 1 new script + 1 mirrored copy.

(1) NEW `ai-resources/logs/scripts/run-manifest.sh` — four subcommands (start/update/close/validate) that auto-write durable shared state to a NEW `ai-resources/logs/runs/{date}-{marker}.json` on EVERY session, at mandate-confirmation, at checkpoints, and at wrap.
(2) EDIT `.claude/commands/session-start.md` Step 3 — call `run-manifest.sh start` right after the mandate line is written (standard chain, every session).
(3) EDIT `.claude/commands/prime.md` Step 8c.7 — same start-stub write in auto mode's inline mandate path.
(4) EDIT `.claude/commands/wrap-session.md` — insert a close+validate step before the commit step (schema validation that ABORTS LOUDLY, non-zero exit, on mismatch), AND slim the wrap-note template from 11 sections to 5 (candidate sections to retire: Files Created / Files Modified / Decisions Made / Outcome / Session Value Audit / Session Assessment / Risky actions — on the theory their load-bearing content lives in the manifest).
(5) MIRROR the two wrap edits into the independent non-symlink workspace-root `.claude/commands/wrap-session.md`.

Manifest schema is FIXED by the R1 kernel doc `ai-resources/docs/spine-schemas.md` §1 and is a two-end contract with future consumers R4 + M-D2 (PJ was dropped 2026-07-09). No permission, hook, or settings change. Rollback = delete `logs/runs/` + `git revert`.

Source packet (authority): `projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md`.

KEY RISK TO WEIGH — I want this interrogated hard, not rubber-stamped:
- These are the three highest-traffic commands in the repo. Every session runs /prime → /session-start → /wrap-session. A bug here degrades EVERY future session.
- The wrap edit REORDERS operations against shared state (validate-then-commit). Per the repo's own tripwire rule, an "existing-command refactor" framing does NOT exempt this.
- The wrap-note 11→5 slimming removes operator-facing sections that downstream consumers actively grep. Specifically verify (by grepping the repo, do not take my word):
  * `/friday-checkup`'s Weekly Session Value Review roll-up greps `### Session Value Audit — 80/20 Review` and its TYPE:/SCORE:/DECISION: labels.
  * The `session-feedback-collector` agent writes `### Session Assessment`.
  * `/wrap-session`'s OWN Steps 6.4 and 6.5 WRITE the very sections proposed for retirement.
  * `/contract-check`, `/drift-check`, and the coaching-data capture (Step 7a) may read the mandate block and note sections.
  Determine whether the 11→5 cut SILENTLY BREAKS these consumers, and if so, name exactly which sections are safe to retire vs. which must be retained because a live consumer depends on them. The packet asserts "the retired sections' load-bearing content already lives in the manifest" — TEST that assertion against the actual schema in spine-schemas.md §1 rather than accepting it.
- Also assess: what happens on a session where the start-stub was never written (fast lane, /clear, a session that skips /prime) and wrap then tries to close+validate a manifest that does not exist? Does the loud abort become a false-positive that blocks legitimate wraps?

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/runs/ — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/foreign-session-guard.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md — exists

## Verdict

RECONSIDER

**Summary:** The manifest write-points are low-risk additive infrastructure, but the wrap-note 11→5 slimming has confirmed live consumers that silently break, an unspecified false-positive-abort path on the highest-traffic command, and a packet claim ("load-bearing content already lives in the manifest") that the actual R1 schema disproves for at least three of the seven retirement candidates.

## Consumer Inventory

Search terms derived from the change: `run-manifest.sh` / `run-manifest` (new script basename), `logs/runs` (new dir), `spine-schemas` (schema authority), `### Session Value Audit`, `### Session Assessment`, `### Files Created`, `### Files Modified`, `### Decisions Made`, `### Risky actions` (the retirement-candidate section markers), and the mandate-block markers (`**Mandate:**`, `- Out of scope:`, etc., to distinguish mandate-block consumers from wrap-note-section consumers). Grepped across `ai-resources/` and the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/session-start.md` | co-edits (this IS edit target #2) | yes |
| `ai-resources/.claude/commands/prime.md` | co-edits (this IS edit target #3, Step 8c.7) | yes |
| `ai-resources/.claude/commands/wrap-session.md` (canonical) | co-edits (edit target #4) **+ parses** — its own Steps 6.4/6.5 write `### Outcome`, `### Session Value Audit — 80/20 Review`, `### Session Assessment` (lines 130, 165–166, 170–186) — the exact sections proposed for retirement | yes |
| `.claude/commands/wrap-session.md` (workspace-root, independent non-symlink mirror) | co-edits (edit target #5) — same internal write/retire conflict at Steps 4.4/4.5 (lines 151–200) | yes |
| `ai-resources/.claude/commands/friday-checkup.md` | parses — Step 14.5 "Weekly Session Value Review" greps `### Session Value Audit` blocks and the `TYPE:`/`SCORE:`/`DECISION:`/`RULE:` lines inside them (lines 335, 339) | yes |
| `ai-resources/.claude/agents/session-feedback-collector.md` | parses (reads `### Files Created` / `### Files Modified` / `### Decisions Made` / `### Risky actions` as input signal, line 33; reads `### Risky actions` again for the safety dimension, line 44) **+ invokes/writes** — its own output block is titled `### Session Assessment` (lines 109–112), itself one of the seven retirement candidates | yes |
| `ai-resources/.claude/commands/contract-check.md` | parses — but only the **mandate block** (`**Mandate:**` line + Out of scope/Files in scope/Stop if/Allowed inputs/Required outputs bullets, line 54), which is written by `/session-start` Step 3, NOT part of the 11-section wrap-note template | no |
| `ai-resources/.claude/commands/drift-check.md` | parses — same mandate-block-only dependency (line 26), not the wrap-note sections | no |
| `ai-resources/logs/scripts/foreign-session-guard.sh` | documents (the session plan for this change explicitly cites it as the pattern `run-manifest.sh` should follow — single source, ancestor-walk resolution); reads today-header + mandate-line counts, unaffected by wrap-note section retirement | no |
| `ai-resources/docs/spine-schemas.md` | imports — the schema authority the new script's close+validate step must read and validate against; pre-existing, SO-approved, not itself edited by this change | no |

**Total: 10 consumers found, 6 must-change** (4 are the edit targets themselves; 2 — `friday-checkup.md` and `session-feedback-collector.md` — are genuine downstream consumers not named as edit targets in the change description, and the change description does not currently propose editing them).

For the two `not yet present` targets (`run-manifest.sh`, `logs/runs/`), there are no consumers of the files themselves yet — the inventory above covers the contract (the wrap-note sections, the mandate block, the schema) the change wires into.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- No content is added to any always-loaded CLAUDE.md and no `@import` chain is introduced — confirmed by reading both workspace and ai-resources CLAUDE.md; neither references `run-manifest.sh` or manifests.
- However, the start-stub write (session-start.md Step 3, prime.md Step 8c.7) and the close+validate step (wrap-session.md, "before the commit step") are **not gated behind an opt-in flag** — the four existing opt-in passes are `+audit` / `+feedback` / `+coaching` / `+telemetry` (`wrap-session.md` lines 15–23); the commit step itself (line 225 onward) is core, unconditional. The new close+validate step sits ahead of that core step, so it runs on **every single wrap**, not just substantive ones — unlike the four heavier passes, which are opt-in specifically to avoid per-session overhead.
- This behaves like a per-session mandatory-stage cost (comparable to a SessionStart-tier hook, even though it is implemented as inline command steps rather than an actual `.claude/hooks/` registration) across the three highest-traffic commands. Four touch-points per session (start, update-at-checkpoints ×N, close, validate) add several extra Bash/Write calls to every session — not token-heavy per write, but a recurring per-session tax with no skip condition described for trivial sessions (contrast with the Step 0.5 scratchpad / Step 6.4/6.5 passes, which explicitly carve out a trivial-session skip).

### Dimension 2: Permissions Surface
**Risk:** Low

- The packet explicitly states "No permission, hook, or settings change" (packet lines 51–53, 87) and the change description repeats this.
- `run-manifest.sh` uses Bash + Write under `logs/runs/`, the same pattern already established by `foreign-session-guard.sh`, `check-archive.sh`, and `split-log.sh`, all of which already read/write within `logs/` — no new tool family, no new external capability, no cross-repo write beyond the existing two wrap-session copies (which already exist and are already git-tracked).
- No `allow`/`ask`/`deny` entries are touched (no `.claude/settings*.json` in the referenced-file list).

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory (Step 1.5, above): **10 consumers, 6 must-change.** Two of those six — `ai-resources/.claude/commands/friday-checkup.md` and `ai-resources/.claude/agents/session-feedback-collector.md` — are genuine downstream consumers **not listed as edit targets** in the change description. Per the High heuristic ("any caller requires modification to keep working"), this alone crosses the High threshold.
- The change touches all three of the repo's highest-traffic commands (`session-start.md`, `prime.md`, `wrap-session.md` ×2 copies) simultaneously — shared infra that every session runs through, affecting every workflow in the repo, not a bounded subsystem.
- Internal contradiction inside the change itself, confirmed by direct read: canonical `wrap-session.md` Steps 6.4 (lines 130, 165–166) and 6.5 (lines 170, 184) **write** `### Outcome`, `### Session Value Audit — 80/20 Review`, and `### Session Assessment` into the session note. The change description proposes retiring these same three sections from the "5-section" template, but does not list Steps 6.4/6.5 as edit targets. If those steps are left as-is, they keep writing sections the template no longer counts — the note either grows back past 5 sections whenever `+audit`/`+feedback` are used, or Steps 6.4/6.5 silently lose their landing spot. Either way this is an unresolved contract break inside the very files being edited, not a downstream surprise.
- The `/friday-checkup` gap is concrete and immediate: its Weekly Session Value Review (Step 14.5, `friday-checkup.md` lines 335–339) greps `### Session Value Audit` — if that section stops being written (or is written inconsistently per the bullet above), the weekly roll-up silently returns nothing, with no error, no abort — a quiet feature loss on a cadence the operator relies on.

### Dimension 4: Reversibility
**Risk:** High

- Code-level revert is clean: `git revert` restores `session-start.md`, `prime.md`, and both `wrap-session.md` copies exactly. The packet's own rollback plan (§9, lines 77–79) confirms this for the command edits.
- But the packet's own rollback plan also states manifests require a **separate manual step** — "delete `logs/runs/`" — because they are additive files a code-level revert does not touch. This alone is enough for at least Medium.
- The more serious reversibility gap: `logs/session-notes.md` is an append-only log. Every session that wraps while the 5-section template is live writes a **permanently thinner** note (missing whichever of Files Created/Files Modified/Decisions Made/Outcome/Session Value Audit/Session Assessment/Risky actions were retired). A later `git revert` restores the *template* but cannot retroactively backfill the missing sections for sessions that already ran under the slim version — this matches the High heuristic "append-only log mutation that a revert cannot cleanly undo."
- Compounding this: if the close+validate step's loud-abort fires as a false positive on a session with no start-stub (Dimension 5 below), the operator's most likely recovery path is an ad hoc manual workaround (hand-editing or deleting a manifest file to unblock the wrap) — an unplanned, undocumented manual-recovery pattern layered on top of the standard rollback.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Unspecified missing-manifest behavior.** The change description's own "KEY RISK" section asks exactly this question and the packet does not answer it: §4 ("Proposed smallest safe change") and §8 ("Verification plan") both describe the negative test as "a deliberately malformed manifest" — i.e., a schema-mismatch test — with no test case for "manifest absent entirely." A session that skips mandate confirmation (a genuinely supported path — e.g. `/wrap-session` explicitly supports trivial sessions that skip the optional passes, `wrap-session.md` line 144, 177) has no documented behavior at close+validate time. If "absent" is treated as "mismatch," every trivial/bare-`/wrap-session` invocation gets a loud, non-zero-exit abort blocking a legitimate wrap on the highest-traffic command in the repo — this is an implicit dependency (start-stub-was-written-this-session) that is not documented as a precondition anywhere in the three edited files as described.
- **Packet's core justification tested against the schema and found false for the highest-value section.** `spine-schemas.md` §1 (lines 11–44) lists the manifest's full field set: `run_id, project, date, marker, model, lane, mandate_ref, mission, context, resources, files_changed, decisions_refs, validation, evaluator_findings, overrides, cost, stop_reason, outcome, failure_class, incidents_refs`. Checked against the seven retirement candidates:
  - `Files Created`/`Files Modified` → partially covered by `files_changed` (paths only; no created/modified distinction, no per-file description).
  - `Decisions Made` → partially covered by `decisions_refs` (pointers only; no rationale/alternatives text — that already lives separately in `decisions.md`).
  - `Outcome` → partially covered by `outcome` (`DELIVERED|PARTIAL|ABANDONED`), but the manifest has **no field at all** for the `EXECUTION: OPTIMAL|ACCEPTABLE|SUBOPTIMAL` verdict or the "Better path" notes that `### Outcome` currently carries (`wrap-session.md` lines 156–161).
  - `### Session Value Audit — 80/20 Review` → **no manifest field exists** for `TYPE`/`VALUE`/`SCORE`/`GATE`/`OPPORTUNITY`/`DECISION`/`LESSON`/`RULE`. This is the exact section `/friday-checkup` greps (Dimension 3). The packet's claim ("the retired sections' load-bearing content already lives in the manifest") is **directly falsified** for this section by the R1 schema itself.
  - `### Session Assessment` → **no manifest field exists** for the safety/severity signal or friction-routing note the feedback collector produces.
  - `### Risky actions` → **no manifest field exists** for a general "irreversible/destructive/near-miss/skipped-gate" note; the closest fields (`incidents_refs`, `failure_class`) are populated only for classified incidents via the defect-log loop (§2, spine-schemas.md), a narrower and more formal trigger than "any risky action taken or nearly taken."
- **Functional overlap with existing crash/continuity mechanisms.** The repo already has two partial mechanisms for the same underlying concern (session-state recoverability after a crash/compaction): the continuity scratchpad (`wrap-session.md` Step 0.5, line 25, written at every non-trivial wrap and read by `/prime` Step 1b) and the per-id session-marker liveness signal (`wrap-session.md` Step 13, lines 243–249, read by `detect-concurrent-session.sh`). The new manifest is a third, more formal mechanism addressing overlapping ground (crash/orphan visibility) without an explicit statement of how it relates to, supersedes, or coexists with the other two.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read directly) and `ai-resources/docs/ai-resource-creation.md` rule #7 (read directly).

- **OP-9 / AP-7 / DR-7 tension (speculative abstraction).** The packet's own §6 names the manifest's future consumers as PJ, R4, and M-D2 (packet line 54) — none of which exist yet (CHANGE_DESCRIPTION itself notes "PJ was dropped 2026-07-09," leaving R4 + M-D2 as the still-future consumers). Per the Step 1.5 inventory, the manifest contract currently has **zero built consumers** beyond the write-points this change itself creates — the DR-7 test ("generalize only on a second confirmed consumer") is not clearly met by *automated* consumers today. This is mitigated, not eliminated, by: (a) the packet cites concrete evidence for a *present* failure mode — red-team case 6 ("fast lane leaves zero durable trace") and target-arch contradictions 4 & 5 (packet lines 17, 22) — which satisfies the evidenced-failure prong (b) of `ai-resource-creation.md` rule #7; (b) a human operator reading the manifest directly during a crash-recovery scenario is itself a present, if informal, consumer. Net: tension, not a clean violation — the packet's own §7 already flags this as a judgment call for the execution session ("if the execution session treats a core-command behaviour change as a structural class, run `/risk-check`" — packet lines 64–65), which is exactly what this check is doing. That flag is the loud, explicit acknowledgment OP-11 requires; it is not silent drift.
- **OP-5 tension (advisory vs. enforcement).** The close+validate step is explicitly designed to "abort loudly, non-zero exit, on mismatch" (packet §8, line 72) — this is enforcement (blocks the commit automatically) layered onto the highest-traffic command, not advisory (warn-and-continue). The packet states this design choice openly (not silent), which is the correct form per OP-3/OP-11, but it does not scope *when* enforcement applies (the missing-manifest case, Dimension 5) — an enforcement decision made loudly for the malformed-schema case, left unaddressed for the absent-manifest case. That gap is a tension worth resolving before landing, not a violation of the loud-revision requirement itself.
- **DR-8 compliance (positive finding).** This `/risk-check` invocation is itself DR-8 in action — the packet correctly deferred a plan-time `/risk-check` (scoped by the W3.2 Phase-0 gate to permission/settings changes) but flagged the judgment call for the execution session, and the execution session is now running it. No violation here; noted as a positive alignment signal, not folded into the Medium rating above.
- **DR-1/DR-3 placement** — `logs/scripts/run-manifest.sh` matches the established pattern of `foreign-session-guard.sh`/`check-archive.sh`/`split-log.sh`; no placement issue.

## Recommended redesign

- **Split the change.** Land items (1)–(3) — the new script and the two start-stub write-points — as an isolated, purely additive change first (new files, no edits to the wrap-note schema or its consumers). This gives the crash/compaction-recovery capability the packet's cited evidence actually calls for, with a much smaller blast radius (Dimension 3/4/5 collapse toward Low for this slice alone), and lets the manifest prove itself against real sessions before anything downstream depends on it.
- **Do not slim the wrap-note template in the same change as the manifest write-points.** Before retiring `### Session Value Audit` / `### Session Assessment` / `### Outcome` / `### Risky actions`, either (a) extend the R1 schema in `spine-schemas.md` §1 to actually carry the fields those sections provide (TYPE/VALUE/SCORE/GATE/OPPORTUNITY/DECISION/LESSON/RULE; a safety-severity field; an EXECUTION verdict) so the packet's "already lives in the manifest" claim becomes true rather than asserted, or (b) keep those four sections in the template and slim only the two that are genuinely redundant with `files_changed` (Files Created/Files Modified). Whichever path is chosen, update `friday-checkup.md`'s Weekly Session Value Review and `session-feedback-collector.md`'s read/write contract **in the same change**, since the Step 1.5 inventory confirms both are live, unlisted consumers — not as a follow-up.
- **Specify the missing-manifest case explicitly** before wiring close+validate into the core (non-opt-in) wrap path: a session with no start-stub should either skip validation with a one-line advisory note, or the abort condition should be scoped to "manifest present but malformed" only — never "manifest absent." This closes the false-positive-commit-block gap the change description itself flagged as the key open risk.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit not-yet-present flags for `run-manifest.sh` and `logs/runs/`). No training-data fallback was used on fetch/read failures.
