# Risk Check — 2026-07-12

## Change

Wire `run-manifest.sh update --decision-ref` into the wrap-time manifest-close step of BOTH paired copies of wrap-session.md (canonical ai-resources Step 12d + workspace-root mirror Step 4.7), so the run-manifest's `decisions_refs` field is populated whenever a session records decisions. Currently the field is never written and is empty on every ordinary session, which blocks W3.2 R3 Pass 2. Scope: (a) add a `--decision-ref` pass to the existing `close` invocation, one flag per decision recorded this session; (b) define a derivable ref format — `logs/decisions.md#<YYYY-MM-DD>-<S{N}>` (date + session marker) — because no anchor convention currently exists (S1 hand-authored its ref and it resolves to no real header); (c) mirror verbatim to the root copy per the PAIRED CONTRACT. Constraints: the manifest close is governed by an explicit ADVISORY RULE ('do not harden this into a gate') — the new write must degrade silently on an absent/unwritable manifest exactly as `--file` does, and must never block a wrap or a commit. Not in scope: R3 Pass 2 itself (the wrap-note cut), and changing wrap Step 5's 'skip decisions.md if routine' rule.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/runs/2026-07-12-S1.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The wiring itself is narrow, additive, and advisory-safe, but the ref-format contract has a real, evidenced collision defect and the change closes only one of two prerequisites R3 Pass 2 actually needs — both fixable before landing, neither a reason to stop the wiring outright.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/wrap-session.md` Step 12d | invokes (the edit target — existing `close` block) | yes |
| `.claude/commands/wrap-session.md` (workspace-root) Step 4.7 | co-edits (PAIRED CONTRACT — verbatim port of Step 12d) | yes |
| `ai-resources/logs/scripts/run-manifest.sh` | invokes (already supports `--decision-ref`, L88; append+dedupe L247–249, L302–304) | no |
| `ai-resources/docs/spine-schemas.md` § 1 | documents (defines `decisions_refs` field — schema unchanged) | no |
| `ai-resources/logs/decisions.md` | parses (its header shapes are the ground truth the new ref-derivation logic depends on) | no (but drives the Dimension 5 finding below) |
| `ai-resources/logs/improvement-log.md` 2026-07-12 entry ("`wrap-session` never writes `decisions_refs`") | documents (the backlog item this change closes) | yes — must be marked applied |
| `ai-resources/logs/missions/w32-migration-execution.md` | documents (R3 Pass 2 blocked status + reopen criteria) | yes — must record the wiring and retain the second (routine-decisions) reopen condition |
| `projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md` | documents (R3 row) | yes |
| `projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md` | documents (Pass 2 reopen criteria / known limits) | yes |

Total: 9 consumers, 6 must-change (both `wrap-session.md` copies + 4 bookkeeping/record docs). `run-manifest.sh`, `spine-schemas.md`, and `decisions.md` are read/relied-upon but not edited by this change. No consumer of the populated `decisions_refs` field exists yet in running code (R4 / M-D2 / PJ are unbuilt) — the only named future consumer is R3 Pass 2, itself on HOLD (`logs/decisions.md` 2026-07-12 S4) pending a second, unrelated sub-prerequisite (see Dimension 6).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file (CLAUDE.md) is touched — confirmed by reading both workspace and ai-resources `CLAUDE.md`; neither mentions `run-manifest.sh` or manifests.
- The edit adds a handful of lines (one `--decision-ref` flag block + a short format note) to an existing Bash invocation inside `wrap-session.md` Step 12d/4.7 — a command already invoked once per session, not per-turn or per-tool-call.
- No new hook, no new `@import`, no new subagent spawn.

### Dimension 2: Permissions Surface
**Risk:** Low

- `run-manifest.sh` already implements `--decision-ref` (L88) and the append/dedupe logic (L247–249, L302–304) — the script itself needs **no change**, so no new tool-invocation pattern is introduced.
- The Bash pattern (`bash "$RM" close --outcome ... --file ... `) already exists in both copies; this adds more flags to an already-authorized call, not a new capability.
- No settings.json, permission, or scope change of any kind.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Step 1.5 inventory: 9 consumers, 6 must-change. Of those, only 2 are the actual code/behavior edit (`wrap-session.md` canonical + workspace-root mirror); the remaining 4 must-change consumers are bookkeeping records (`improvement-log.md`, mission thread, remediation-register, R3 packet) that the plan itself already accounts for.
- `wrap-session.md` is described in its own text as "the highest-traffic command in the repo" (`wrap-session.md` :250, decisions.md 2026-07-12 "the highest-traffic command in the repo") — editing it, even narrowly, touches shared infrastructure every session hits at wrap. That single fact pushes this above Low despite the low direct-caller count.
- The contract change (adding a flag to an already-optional, already-advisory call) is backward-compatible by design — sessions with no decisions simply omit the flag, per the change description's own scope. No caller is broken by the addition.
- No consumer outside the anticipated set was surfaced by the inventory — the blast radius is exactly what the change description states, not wider.

### Dimension 4: Reversibility
**Risk:** Medium

- The command-body edit itself is cleanly `git revert`-able in both copies — a single commit undoes the text change.
- However, once live, every subsequent wrap will write `decisions_refs` entries into new `logs/runs/{date}-{marker}.json` files. These are new data artifacts, not touched by a revert of the command text — reverting the wiring does not retroactively strip already-written `decisions_refs` values from manifests closed while the new code was live. If the ref format is later found wrong (a real risk — see Dimension 5), correcting it requires either a manual pass over already-written manifest JSON files or accepting the inconsistency as a permanent historical artifact.
- This is the "one extra cleanup step" shape (append-only artifact accumulation), not a multi-step external rollback — Medium, not High.

### Dimension 5: Hidden Coupling
**Risk:** High

Three separate implicit dependencies the new ref-format contract relies on, and all three are independently confirmed broken or fragile against live evidence:

- **Header-level inconsistency (confirmed).** `grep '^## \|^### ' logs/decisions.md` shows most entries as `## YYYY-MM-DD (S{N}) — title` (e.g. line 286, 312) but at least two are `### YYYY-MM-DD — title` with no session marker at all (line 37: `### 2026-07-03 (S6)`; line 212: `### 2026-07-10 — /new-project settings-path fix...`). A ref-derivation rule keyed on "date + session marker" has no marker to key off for those entries, and is silently inconsistent about heading level.
- **Same-day, same-marker collision (new finding — not present in any prior log or the session plan I read).** `logs/decisions.md` currently has **two separate `##` headers both dated `2026-07-12 (S4)`** — "R3 Pass 2: HOLD…" (line 286) and "§ Model Tier carve-out…" (line 312). Under the proposed format `logs/decisions.md#<date>-<S{N}>`, both collapse to the identical ref `logs/decisions.md#2026-07-12-S4` — the format cannot disambiguate two distinct decisions made in the same session on the same day. This is a real, evidenced defect in the format as specified, not a hypothetical.
- **S1's own precedent is already broken.** `logs/runs/2026-07-12-S1.json` carries `"decisions_refs": ["logs/decisions.md#2026-07-12-r3-pass1"]` — no header in `decisions.md` slugifies to that string; it was hand-authored and is already an orphan ref. The new mechanized format is meant to fix this, but does not (per the two points above) fully succeed.
- **Archival staleness (known, separately documented).** `improvement-log.md` 2026-06-27 ("Canonical-doc citations to `logs/decisions.md YYYY-MM-DD` go stale at monthly archival") already documents that any `logs/decisions.md#...` reference becomes silently wrong once the cited month rotates to `decisions-archive-YYYY-MM.md`. Every manifest ref this change writes will go stale on the same schedule. This is accepted and explicitly logged as a known limit in the session plan (`session-plan-2026-07-12-S5.md` Finding 4) rather than solved — a legitimate scoping call, but it does compound the header-collision finding: the format is fragile on two independent axes, not one.

No consumer reads `decisions_refs` yet, so none of this breaks a running system today — but it writes a durable, silently-wrong record into every future manifest until corrected, which is exactly the shape Dimension 5 exists to catch.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/principles-base.md` (present and used).

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — tension, not a clear violation.** `decisions_refs` is an already-SO-approved R1 schema field (`spine-schemas.md` §1, Pass 1 shipped and QC'd 2026-07-12) — this change is *wiring*, not new abstraction. But its only named consumer is R3 Pass 2, and Pass 2 is currently on **HOLD** (`logs/decisions.md` 2026-07-12 S4) — moreover, per Dimension-6-adjacent evidence below, Pass 2 needs a *second*, unrelated fix (the routine-decisions gap) before this wiring alone would reopen it. Populating a field whose sole intended reader is a blocked, not-yet-sufficient downstream change is a real DR-7 tension: it is not "hooks for an absent consumer" (Pass 2 is a named, planned, already-scoped step, not speculative), but it is also not "a confirmed second consumer" in the strict sense R4/M-D2/PJ would provide. Score Medium, not High: the packet-level design decision (extend Pass 1, not the kernel; split into two passes) was already SO-reviewed and risk-checked once (`audits/risk-checks/2026-07-12-w32-r3-durable-run-manifest-slim-wrap-note.md` → RECONSIDER → redesigned), so this specific wiring sits inside an already-legitimated design, not a fresh speculative build.
- **OP-3 (loud failure over silent continuation) / false-completeness (spine-schemas.md §5 failure class 5) — the live risk is in *reporting*, not in the code.** The change description itself correctly scopes out "R3 Pass 2 itself" and "changing wrap Step 5's rule," which is the right posture. The principle is satisfied **only if** the completion is reported the same way: as *one of two* Pass-2 prerequisites closed, not as "the R3 Pass 2 prerequisite, now met." See the explicit answer to this question below the dimensions.
- **OP-5 (advisory vs. enforcement) — satisfied.** The change explicitly must preserve the ADVISORY RULE (never block, degrade silently on absent/unwritable manifest) — this is stated as a hard constraint in the change description itself, and `run-manifest.sh`'s `update`/`close` logic has no failure branch tied to `decisions_refs` content (confirmed by reading the script: appending an empty or malformed ref does not trigger `validate`'s error paths, which check `failure_class`/enum fields, not `decisions_refs` contents). Low tension here — cite as a positive alignment, not a finding against the change.
- **DR-1/DR-3 (placement)** — no placement issue; the edit lands inside the two already-canonical wrap-session.md copies at their already-established manifest-close steps.

## Mitigations

- **Dimension 5 (Hidden Coupling, High) — required before landing.** Fix the same-day/same-marker collision by construction: either (a) append a per-session decision-sequence suffix to the ref (`#2026-07-12-S4-1`, `#2026-07-12-S4-2`, ...), or (b) change Step 5 so that a session recording multiple decisions appends them as sub-bullets under one `##` header per (date, marker) rather than multiple headers — eliminating the collision at the source. Pick (a) if Step 5's behavior must stay untouched (it is explicitly out of scope per the change description); (a) is the lower-blast-radius fix. Also add one line to `spine-schemas.md` §1 or the R3 packet documenting that the ref is a lookup key, not a resolvable markdown anchor, and that it tolerates the existing `##`/`###` header-level inconsistency (or note the two outlier headers as a small one-time content fix, since normalizing them is cheap and low-risk).
- **Dimension 6 (Principle Alignment, Medium) — required framing, not a code change.** In the commit message, session note, and mission-thread update, state plainly that this wiring closes only the "field is never written" prerequisite — the routine-decisions gap (wrap Step 5's "skip if all decisions were routine" clause means those decisions live only in the wrap note's `### Decisions Made` block, which Pass 2 deletes) remains fully open and unaddressed. Do not write or imply "R3 Pass 2 prerequisite met." The `logs/missions/w32-migration-execution.md` reopen-criteria line must continue to name **both** conditions, not just this one.
- **Dimension 3/4 (Blast Radius / Reversibility, Medium) — standard care, not a new action.** Land both `wrap-session.md` copies in the same commit (already required by the PAIRED CONTRACT); run the plan's own Step 3 diff-check between the two close blocks before commit.
- **Implementation-fidelity note (not one of the six dimensions, but load-bearing — see the answer below).** Ensure the wrap-session.md instructions omit the `--decision-ref` flag entirely when no decisions were recorded, rather than passing an empty string — an empty-string ref would silently pollute `decisions_refs` with a garbage entry, corrupting exactly the payload signal the R3 Pass 2 reopen test depends on (`decisions_refs` non-empty *and meaningful* when decisions were made).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
