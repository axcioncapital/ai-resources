# Risk Check — 2026-05-26

## Change

Plan 2 — Add Step 0.5 to /session-start: live concurrent-session mtime guard. Capture session-notes.md mtime; compare to logs/.prime-mtime (marker written by /prime Step 8a after its today's-header append); if session-notes.md mtime > marker mtime, emit warning with 2-option pause prompt (proceed-anyway / stop-and-resolve). Fallback when marker absent: 120s delta-since-now heuristic. Coordinated edits: (1) /session-start Step 0.5 (new) — mtime check + own/foreign distinction via marker + pause prompt; (2) /prime Step 8a — after today's-header append, write session-notes.md mtime to logs/.prime-mtime; add one-line advisory note pointing to /session-start Step 0.5; (3) .gitignore — add logs/.prime-mtime. Design choice: option (b) marker file (selected over read-back content match and tail-content authorship for determinism + no cross-process state passing). Targets: ai-resources/.claude/commands/prime.md, ai-resources/.claude/commands/session-start.md, ai-resources/.gitignore. Full plan: ai-resources/plans/concurrent-session-live-detection.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/concurrent-session-live-detection.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists (file being mtime-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/.prime-mtime — not yet present (marker file to be created at runtime by /prime)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A targeted two-command edit with a viable marker-based design; medium blast radius (two universally-loaded commands) and one hidden-coupling concern (chain-internal write race between /prime Step 8a's header append, marker write, and /session-start Step 0.5 read) require explicit mitigation but do not rise to RECONSIDER.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- /prime and /session-start are operator-invoked commands, not always-loaded files; they do not register `SessionStart` / `PreToolUse` / `Stop` hooks. Evidence: both files carry only `model: sonnet` frontmatter and no hook registration (prime.md lines 1–3; session-start.md lines 1–3).
- Per-invocation marginal cost is one `stat` + one Read of `logs/.prime-mtime` (a single-line file) inside /session-start, and one Write of an mtime stamp inside /prime — both pay-as-used per session, not per turn or per tool call. Quoted from plan: "Usage cost: Negligible (one `stat` per `/session-start`)" (concurrent-session-live-detection.md line 99).
- Step 0.5 prose addition to session-start.md is bounded (~25–40 lines of instructions per the plan's pseudocode block, lines 50–84); /prime advisory note is one line. Neither file is `@import`ed by an always-loaded CLAUDE.md (workspace CLAUDE.md and ai-resources/CLAUDE.md do not @import command files; grep'd: no `@.claude/commands/prime.md` or `@.claude/commands/session-start.md` references).

### Dimension 2: Permissions Surface
**Risk:** Low

- No new tool families introduced. The change uses `stat`, `date`, `Read`, `Write` — all standard tools already authorized in the repo's permission posture (prime.md already calls `Bash(stat ...)` patterns indirectly via mtime checks in Step 1b, lines 67–68).
- No `allow`/`ask`/`deny` rule changes named in the plan. Quoted: "Permissions surface: No change — `stat` and `date` standard tools" (concurrent-session-live-detection.md line 98).
- Marker file `logs/.prime-mtime` lives inside an already-writable path; the .gitignore addition is a normal source-controlled config change, not a permission expansion.

### Dimension 3: Blast Radius
**Risk:** Medium

- Two universally-loaded operator commands are touched: `/prime` (the session-orientation entry point) and `/session-start` (the mandate-capture step). Both are invoked at the top of nearly every working session.
- Grep enumeration of callers and references inside `.claude/`:
  - `/session-start` referenced in 5 command files: `wrap-session.md`, `drift-check.md`, `new-project.md`, `session-start.md`, `prime.md` (grep result).
  - `/prime` referenced in 7 command files: `session-plan.md`, `wrap-session.md`, `drift-check.md`, `session-start.md`, `prime.md`, `new-project.md`, `repo-dd.md` (grep result).
  - No agent or skill file references either command name (`.claude/agents/` and `skills/` not in the hit list).
- Existing contract dependencies: `wrap-session.md` Step 7a parses the `**Mandate:**` line that /session-start writes (session-start.md lines 139, 152–157). The change does NOT alter that parse contract — Step 0.5 is purely a precondition guard before Step 1, so the downstream Mandate-line format is untouched.
- `/prime` Step 8a.3.a (prime.md line 149) already writes today's header to `logs/session-notes.md`; the plan adds a marker-file write immediately after. This is additive — no caller of /prime depends on the absence of `logs/.prime-mtime`.
- A second same-day-header writer (`/prime` Step 8b, line 158) ALSO appends today's header in a single-session free-text path but is NOT in scope for the plan's marker write. This is a partial-coverage concern, called out under Hidden Coupling below.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are clean `git revert` targets: insertion of Step 0.5 block in session-start.md, one-line advisory + marker-write line in prime.md, one-line .gitignore addition. The plan confirms: "Reversibility: Full — Step 0.5 is a single inserted block" (concurrent-session-live-detection.md line 97).
- Marker file `logs/.prime-mtime` is gitignored by design; if the feature is reverted, any stale marker on disk has no consumer and causes no harm (it's just an orphan file). Operator may delete it with `rm logs/.prime-mtime` as a one-line cleanup, but the revert itself does not require it.
- No append-only log mutations, no external writes (Notion, push), no automation that fires between landing and revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Chain-internal ordering contract.** The marker write in /prime Step 8a.3.a must occur AFTER the today's-header append to `session-notes.md`, not before. Otherwise the marker's recorded mtime predates the session-notes.md mtime and /session-start Step 0.5 will read `session-notes-mtime > marker-mtime` as a foreign write, firing a false positive on the chain's own normal flow. The change description does state "after its today's-header append" — so the contract is acknowledged — but it is implicit in the prose and not enforced by the structure of /prime's existing Step 8a (which currently ends at line 156 with the pause output, with no marker-write seam).
- **Coverage gap on /prime Step 8b (free-text intent).** /prime has TWO header-write paths: Step 8a.3.a (task-number selection, line 149) and Step 8b.1 (free-text intent, line 158). The change description names only "Step 8a" for the marker write. If the operator answers /prime's task prompt with free-text (Step 8b), no marker is written, /session-start is then invoked manually by the operator (per session-start.md's "Run after `/prime`" — line 11), and Step 0.5 falls back to the 120s delta heuristic — which is a heuristic, not a deterministic check. Verbatim: "Fallback when marker absent: 120s delta-since-now heuristic" (CHANGE_DESCRIPTION). This is acceptable as a fallback but the asymmetry between the two /prime paths is not surfaced.
- **Functional overlap with /session-plan Step 0 collision detection.** /session-plan Step 0 (session-plan.md line 11) already implements a 6-hour-window intent-comparison collision check for `session-plan.md`. The new Step 0.5 covers a different file (`session-notes.md`) with a different mechanism (mtime + marker), so there is no double-fire on the same event, but two adjacent guards now protect adjacent files — the operator will need to understand which fires when. The plan notes this overlap explicitly (concurrent-session-live-detection.md lines 20–22) and bounds scope correctly: "Out of scope ... Any change to `/session-plan` Step 0" (line 119).
- **New contract is documented at the change site.** The marker file `logs/.prime-mtime` is a new cross-command contract (writer: /prime; reader: /session-start). The plan acknowledges it must be documented in both files and adds an advisory note in /prime Step 8a pointing to /session-start Step 0.5. This grounds the contract at the change site, lowering coupling risk from High to Medium.

## Mitigations

- **Dimension 3 (Blast Radius) — Medium.** Before landing, confirm the Step 0.5 insertion does NOT alter the line-anchor parsing assumptions of wrap-session.md Step 7a or drift-check.md Step 5. Specifically, Step 0.5 must execute BEFORE Step 3's mandate-write (which is the parsed line) — keep Step 3 untouched. Verify by reading session-start.md after the edit and confirming lines 139–157 (the parse-contract block) are byte-identical to pre-edit state.
- **Dimension 5 (Hidden Coupling) — Medium, mitigation A.** In /prime Step 8a.3.a, write the marker file ONLY AFTER the today's-header append completes successfully. If the header-append Edit/Write fails for any reason, do not write the marker — otherwise Step 0.5 will read a forward-dated marker against an unchanged session-notes.md and misclassify a follow-up write as own-session. Encode this as a sequenced bash block or as explicit ordering prose in Step 8a.3.a.
- **Dimension 5 (Hidden Coupling) — Medium, mitigation B.** Either extend the marker write to /prime Step 8b.1 (free-text intent path) as well, OR explicitly document in /session-start Step 0.5 that the 120s fallback is expected in the Step 8b path and the operator should treat marker-absence as "non-chain entry" rather than treating it as an error condition. Pick one. Mitigation B is the lower-risk default (no extra code paths); the choice should be stated in the implementation session's first commit message.
- **Dimension 5 (Hidden Coupling) — Medium, mitigation C.** After the edit, run a single live test of the normal single-session chain (/prime → operator picks task within 30s → /session-start). Confirm Step 0.5 does NOT fire — this validates the own-write distinction works in practice, not just in design. The plan's acceptance criterion 5 (concurrent-session-live-detection.md line 112) already names this test; the mitigation here is to elevate it from "should test" to "must run before commit".

## Evidence-Grounding Note

All risk levels grounded in direct evidence: line citations from session-start.md (lines 11, 22, 139, 152–157), prime.md (lines 1–3, 67–68, 149, 158), .gitignore (full file read, 35 lines), concurrent-session-live-detection.md (lines 20–22, 88, 97–99, 112, 119), and grep counts across `.claude/commands/` (5 callers of /session-start, 7 of /prime; zero callers in `.claude/agents/` or `skills/`). The `logs/.prime-mtime` file's contribution to risk is evaluated from CHANGE_DESCRIPTION intent only, as the file is tagged `not yet present`. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — Plan 2 (concurrent-session mtime guard)

## Routing position

The change lives where it belongs: edits to two universally-loaded canonical commands at `ai-resources/.claude/commands/` (`/prime`, `/session-start`) plus a `.gitignore` entry for the new marker file `logs/.prime-mtime`. This matches `repo-architecture.md` § "Canonical homes by artifact type" (slash commands → `ai-resources/.claude/commands/<name>.md`) and the workspace-root tier rules in `principles.md § DR-1, DR-3`. The marker file lands under `logs/` (workspace-level), which is also the right home per `repo-architecture.md` (workspace-level logs at workspace root `logs/`). No routing objection.

## Concurrence with PROCEED-WITH-CAUTION verdict

We concur. The verdict is correct, and the dimension breakdown (Blast Medium, Hidden Coupling Medium, others Low) reflects the change's real shape. The reasoning track:

- The change touches two universally-loaded commands — by the table in `risk-topology.md § 3` this is the "canonical command/agent edit" class with "all projects invoking it" blast radius. `principles.md § DR-8` makes `/risk-check` mandatory; PROCEED-WITH-CAUTION (vs. GO) is the right tier given the two-end contract being added (marker file as cross-process state passing between `/prime` and `/session-start`).
- The change introduces a **new two-end contract** (marker file written by `/prime`, read by `/session-start`). `risk-topology.md § 5 — Signals that elevate a change to structural risk` flags two-end contracts explicitly: "Change modifies a string literal matched by another component (two-end contract)." A marker-file path is the same shape of dependency.
- Reversibility is genuinely Low — the inserted block is a single self-contained Step 0.5 plus a small Step 8a coordination edit, no migration, no schema change.

## On the recommended mitigation path

Mitigations 1, 2, and 4 are right. We concur fully:

- **Mitigation 1 (byte-identical preservation of session-start.md lines 139–157):** This is non-negotiable. Those lines are the **Mandate-line parse contract** read by three downstream consumers (`/wrap-session` Step 7a, workspace-root `wrap-session.md` Step 2b, `/drift-check` Step 5 — confirmed by reading `session-start.md` lines 139–157 directly). `risk-topology.md § 5` calls this out as a structural-risk signal ("Change modifies a string literal matched by another component"). Step 0.5 inserts *before* Step 1, so it should not touch Step 3 — but the post-edit verification is required, not optional. (`principles.md § QS-3`.)
- **Mitigation 2 (marker write after successful append, not before):** Correct. A forward-dated marker (written before the append succeeds) would produce false negatives — the guard would think the session's own write was already accounted for when in fact it hadn't happened. Sequence is `append → confirm append succeeded → stat the file → write the marker = same mtime`.
- **Mitigation 4 (single-session chain live test, acceptance criterion 5):** Correct. This is the false-positive test. Acceptance criterion 5 is the operative one — own-write distinction has to work in practice before commit. (`principles.md § QS-3` again.)

**On mitigation 3, the recommendation is firmer than "either":**

The right answer is **extend the marker write to Step 8b.1**, not "document the 120s-fallback path explicitly" as an equal alternative.

Reasoning, grounded:

- Verified directly: `/prime` Step 8b.1 contains identical today's-header append logic to Step 8a.3.a. Both code paths write `## YYYY-MM-DD` to `logs/session-notes.md`. The only difference is what happens next — Step 8a invokes `/session-start` immediately; Step 8b tells the operator to invoke `/session-start` separately via the "Next:" instruction.
- If the marker is written only in Step 8a, then any Step 8b chain falls through to the 120s heuristic fallback in `/session-start` Step 0.5. That heuristic was specifically introduced as a **fallback for marker-absent cases** (e.g., first-ever run, marker deleted), not as the normal operating mode for a major code path.
- The "document the 120s-fallback explicitly" option silently makes Step 8b a permanent second-class citizen — every Step 8b session runs without the deterministic marker check the design chose for determinism reasons. That is exactly the failure mode `principles.md § OP-3 (loud failure over silent continuation)` and `§ AP-1 (silent conflict resolution)` warn about: a free-text-intent session would carry a less reliable guard than a task-selected-by-number session, with no surfaced reason.
- It also conflicts with the design intent stated in the plan itself: "option (b) marker file (selected over read-back content match and tail-content authorship for determinism + no cross-process state passing)." If determinism is the reason marker file won over the alternatives, then leaving the largest sibling path on the non-deterministic fallback re-introduces what the design rejected.

**Position:** Extend the marker write to Step 8b.1 immediately after its today's-header append (mirroring 8a.3.a). The 120s fallback then becomes what it should be — a fallback for genuinely marker-absent edge cases (first run, deleted marker), not the operating mode for one of two primary paths.

## Risks the dimension review missed

Three.

1. **Marker staleness across days / abandoned chains.** A `/prime` invocation that never reaches `/session-start` (operator picks task 1, then gets pulled away, never returns; or operator picks a task but plan mode is active, so 8a.2 stops without reaching 8a.3.a) leaves a stale `logs/.prime-mtime`. The next day, a `/session-start` invocation in a *different* unrelated session would see "marker exists, foreign-write check passes if file mtime ≤ marker mtime" — silently suppressing a real concurrent-session detection. **Mitigation:** Step 0.5 should treat marker files older than ~24h (or older than today) as absent, falling through to the 120s heuristic. This is a small addition to the Step 0.5 logic; cite as design constraint at implementation time. Grounded in `principles.md § AP-10` only by inversion — the marker is not an "impossible scenario"; it is a likely real one given abandoned-chain telemetry from the past month's prime-no-handoff sessions. Operator can confirm whether abandoned chains happen at non-trivial rate. [CITATION NEEDED — abandoned-chain frequency, recommend reading `logs/usage-log.md` or asking operator.]

2. **Marker file is workspace-level, but `/prime` and `/session-start` run from project sessions.** Verified by reading `/prime`: it writes to `/logs/session-notes.md` (workspace root). The marker is also workspace-level (`logs/.prime-mtime`). Both project-scoped sessions and workspace-scoped sessions converge on the same workspace `logs/` directory — so the marker contract is shared across all sessions, not per-project. This is correct (because session-notes.md is also workspace-level), but it means two concurrent sessions in *different projects* hitting `/prime` near-simultaneously will each write the marker, and the second one's marker write clobbers the first. The downstream `/session-start` reads the most recent marker — which may not correspond to the same session's `/prime`. **This is a real correctness gap the dimension review did not surface.** Tied to `risk-topology.md § 2 — Shared infrastructure → projects (reverse map)`: workspace-root `logs/` is shared across all 7 projects. Mitigation: marker should include the writing process's PID or a session-identifier — turning the file from a simple mtime stamp into a structured `{pid|session_id}:{mtime}` line, and `/session-start` Step 0.5 checks both fields. Without this, the marker is a single global cell that pretends to be per-chain state.

3. **The marker introduces a new permanently-load-bearing file under `logs/`.** `risk-topology.md § 1 — Load-Bearing Components` enumerates what is system-wide-effect load-bearing. Adding a gitignored marker file at `logs/.prime-mtime` puts a new dependency under workspace `logs/` that *cross-cutting* commands now silently rely on. If a future operator cleanup or hook ever sweeps `logs/` (the `logs/` directory is touched by multiple hooks per `blueprint.md § 3.4`), the marker could be removed without anyone noticing — and `/session-start` would silently degrade to the 120s heuristic with no warning. **Mitigation:** the marker's purpose should be documented in `risk-topology.md § 1 (High — workstream-wide)` at the same commit, so it's recognized as load-bearing. Also: `/session-start` Step 0.5 should explicitly log when it falls through to the heuristic fallback ("marker absent — using 120s heuristic"), so silent degradation becomes loud (`principles.md § OP-3`).

## Summary

- Concur with PROCEED-WITH-CAUTION.
- Mitigations 1, 2, 4: correct as written.
- Mitigation 3: the right answer is **extend marker write to Step 8b.1**, not the documented-fallback alternative. The "either/or" framing understates the determinism cost.
- Three additional risks the dimension review did not surface: (a) stale marker across abandoned chains needs a freshness window; (b) marker is workspace-global but multiple projects can race on it — needs a session-identifier field, not just mtime; (c) the new marker is itself load-bearing and should be added to `risk-topology.md § 1` in the same commit, with loud-fallback logging in Step 0.5.

The change is worth doing — it closes a real concurrent-session gap that Wave C did not cover, the failure mode is documented with live evidence (2026-05-26 brand-book session), and the mitigation path is tractable. Proceed with the corrected mitigation 3 and the three additional risks folded into the implementation brief.

## Implementation-time annotation (added by main session 2026-05-26)

**Fact correction to SO risk #2:** Verified directly via `grep` of `prime.md` — the bash commands at lines 50–60 use **relative** `logs/session-notes.md` paths (not workspace-absolute). `/prime` Step 0 resolves cwd's git root via `CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel)`, so log paths are cwd-relative. The "/" prefix in prose lines 30, 149, 158 is typographic, not a filesystem-absolute reference. Each project (and ai-resources, and workspace root) has its own `logs/session-notes.md` and would have its own `logs/.prime-mtime`. SO's "cross-project race on workspace-global marker" is therefore narrower than stated — the race is **intra-project** (two sessions in the same project running `/prime` concurrently), not cross-project. The 120s heuristic fallback partially covers this narrower race (provided Session A picks the task within 120s). Session-id machinery (SO risk #2 mitigation) would tighten this further but is **deferred** to a follow-up if the intra-project race actually fires in practice — minimal-infra-subset preference. Other SO risks (#1 freshness window, #3a risk-topology entry, #3b loud-fallback logging) accepted; landing in this commit. Mitigation 3 corrected (extend to Step 8b.1) accepted.
