# Risk Check — 2026-05-25

## Change

Plan-time gate on SF1 fix to /session-start command: replace the duplicate Read of logs/session-notes.md in Step 3 with a reference to the Step 0 read result already in context. Single-sentence edit in .claude/commands/session-start.md. Plan file: logs/session-plan-pass2.md.

Edit text (per additional context):
- OLD (Step 3, line 86): "Read `logs/session-notes.md` (last 10 lines) to locate today's session header."
- NEW: "Using the `logs/session-notes.md` content already read in Step 0, locate today's session header."

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-pass2.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The mechanical edit is trivial and revert-clean, but the staleness window introduced between Step 0 and Step 3 — bridged by an operator-interactive Step 1/Step 2 — creates a hidden-coupling risk in a known-concurrent-write file.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edit removes one Read call per /session-start invocation (the duplicate read of `logs/session-notes.md` last-10-lines in Step 3). Evidence: `.claude/commands/session-start.md` line 86 (current text). Net token cost per session goes down, not up.
- No change to any always-loaded file (workspace CLAUDE.md or repo CLAUDE.md). No hook registration. No `@import`. No subagent brief expansion.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `settings.local.json` changes are part of the edit (single-sentence edit in `session-start.md` only — per CHANGE_DESCRIPTION).
- No new tool invocation pattern introduced; the Edit step in Step 3 (line 87–96) is unchanged.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 1 (`.claude/commands/session-start.md`).
- Parse contract is preserved. `session-start.md` lines 80–84 document a contract with `wrap-session.md` Step 7a on bullet labels (`- Out of scope:`, `- Files in scope:`, `- Stop if:`), the `(inferred)` marker, and `(none stated)`. The proposed edit changes only an internal Read instruction; it does not touch the mandate line format, bullet labels, or markers.
- Grep enumeration of `session-notes` references that interact with `/session-start`'s write semantics: 
  - `wrap-session.md` line 48 (Step 7a — reads today's mandate block; cites session-start.md as format origin) — unaffected by the Step 3 read change.
  - `session-plan.md` lines 13, 39, 47, 198 — reads session-notes for `## {DATE}` headers and Next Steps; runs after `/session-start`, not concurrently.
  - `drift-check.md` lines 18, 26, 28, 30, 48, 53 — reads bottom-most session block; runs mid-session, not concurrent with `/session-start` Step 0→3 window in normal flow.
  - `friday-checkup.md`, `friction-log.md`, `note.md`, `open-items.md`, `monday-prep.md`, `log-sweep.md` — all read session-notes; none are part of the `/session-start` call chain.
- Total: 0 callers require modification. No contract change.

### Dimension 4: Reversibility
**Risk:** Low

- Single-sentence edit in one file. `git revert` of the commit fully restores the prior text — no sibling files, no log mutations, no settings change.
- No external state propagation. No automation registered.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Staleness window:** Step 0's Read happens before Step 1 (operator prompt) and Step 2 (operator confirmation). Step 2 explicitly waits for one operator response (line 63: "Wait for one response"). The operator can take arbitrary time. During that window, a concurrent session can write to `logs/session-notes.md` — and concurrent writes to session-notes.md are an established pattern in this repo. Evidence: `logs/session-notes.md` line 9 (2026-05-22 entry): "Concurrent session: a separate `/friday-act execution` session is clearing the ungated plans … both sessions append to session-notes.md." Also: `wrap-session.md` Step 0 (line 11) installs a `touch /tmp/claude-wrap-session-done` lockfile expressly "preventing a file-modification race on `logs/session-notes.md`" — confirming the file is treated as a concurrent-write target across the repo.
- **Consequence if staleness fires:** Step 3 uses the stale Step 0 view to "locate today's session header." Today's header almost certainly still exists (concurrent sessions append, not delete), so locating it should still succeed. The downstream Edit (line 87) appends after that header — Edit operates on the live file, not the in-context snapshot, so the actual append target is the live file. Practical impact is small but non-zero: if a concurrent session has added today's header content between Step 0 and Step 3, the in-context reasoning may believe the header is absent when in fact it is present (or vice versa), potentially mis-routing between the "header exists / append after" branch (line 88) and the "header absent / append full block" branch (line 89–96).
- **Undocumented new contract:** The edit introduces an implicit assumption ("Step 0's read result is still valid at Step 3") that is not stated as a precondition anywhere in the file. The two-step decoupling becomes silent — a future reader won't know the cached view can be stale.
- **Severity bound:** Medium, not High. The duplicate Read in the current text is itself a stale-by-the-time-Edit-fires snapshot (Step 3 reads, then writes via Edit — Edit operates on live disk content). So the proposed change does not introduce a new failure mode that did not already exist; it widens an existing window. The duplicate Read narrows the window to "Step 3 Read → Step 3 Edit" (milliseconds); the proposed edit widens it to "Step 0 Read → Step 3 Edit" (seconds-to-minutes, gated on operator response).

## Mitigations

- **Dimension 5 (Hidden Coupling):** Add one sentence to Step 3 stating the precondition explicitly — e.g., after the new Read-reference sentence, add: "(Note: if a concurrent session may have written to `logs/session-notes.md` during Step 1/Step 2, the in-context view is stale; re-read before locating the header.)" This documents the implicit assumption at the change site and gives the model a clear escape hatch when concurrent activity is suspected. Alternatively: keep the new behavior as default but add a one-line guard — "If Step 2 took >30s or an external write to session-notes.md is suspected, re-read." The mitigation is cheap (one sentence) and turns Medium into Low.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `session-start.md` lines 22, 63, 86, 80–84, 87–96; `session-notes.md` line 9 (concurrent-session reference); `wrap-session.md` line 11 (race-prevention lockfile); cross-command grep on `session-notes` (8 commands enumerated). No training-data fallback used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

### Routing position

The change lands in the right place. `session-start.md` is the canonical home for the `/session-start` command at `ai-resources/.claude/commands/` (DR-3 — Component type determines home; commands canonical home). The single-sentence Step 3 edit is correctly scoped to the canonical file, which auto-syncs to all projects via `auto-sync-shared.sh`. No structural relocation is needed — this is an in-place edit to a load-bearing canonical command.

Risk-class classification is correct: per `risk-topology.md § 3`, this is a "Canonical command/agent edit" (blast radius = all projects invoking it) AND it falls under the operator's restated tripwire — "edits that reorder operations against shared state." Both gate to `/risk-check` plan-time + end-time (DR-8).

### Architectural commentary on top of the routing position

**Concur with PROCEED-WITH-CAUTION.** The dimension review correctly identified the hidden coupling on dimension 5: the duplicate Read is not redundancy, it's a freshness guarantee. The current text co-locates the Read and the Edit inside Step 3, which bounds the staleness window to milliseconds. The proposed edit moves the Read to Step 0 — across an operator-interactive boundary that can stretch to minutes. The risk-check report's framing ("does not introduce a new failure mode but widens an existing one") is the architecturally honest read.

**On the mitigation:** the recommended one-sentence precondition note is the right minimum, but a slightly stronger variant should land. A passive "Step 0 read may be stale" precondition documents the gap but does not close it — it shifts the burden to whoever later reads Step 3 to remember the implication. A **conditional re-read guard** ("if Step 2 took >30s OR concurrent session is suspected, re-read `logs/session-notes.md` before locating today's header") is mechanically closer to what the current code achieves, and costs the same one-sentence budget. It also generalizes cleanly into the design pattern for the remaining 5 SF1 edits — which matters per the next section (`principles.md § OP-3` — loud failure over silent continuation; a silent stale read is exactly the failure mode OP-3 forbids).

### Downstream impact

Two impacts the dimension review correctly named, and two it did not:

**Named correctly:**

1. **Concurrent-write surface on `logs/session-notes.md`.** The 2026-05-22 incident (`logs/session-notes.md` line 9) and the `/wrap-session` lockfile installation (`wrap-session.md` line 11) establish that this file IS a known concurrent-write target. `risk-topology.md § 1` lists the canonical session-start.md edit as a structural-risk class, and `principles.md § DR-10` (no directory wildcards for git add during concurrent sessions) confirms the operator has flagged this exact file as concurrent-sensitive. The mitigation must address this, not just acknowledge it.

2. **Parse contract on Step 3.** The Step 3 `**Parse contract:**` note (`session-start.md` line 80) declares that `wrap-session.md` Step 7a depends on the exact bullet labels written by Step 3 — this is a two-end contract per `risk-topology.md § 5` ("Change modifies a string literal matched by another component"). The proposed edit doesn't touch the write itself, but a careless edit at this site could; the mitigation sentence should be added in a way that doesn't accidentally rephrase the parse-contract block.

**Missed by the dimension review:**

3. **Step 0 of `/session-start` is precondition-checking, not state-capture.** The current Step 0 reads the last 10 lines to look for a today-dated header — its purpose is the warning logic ("Note: /prime may not have run yet today"). The current Step 3 read serves a different purpose: locating the header to append the mandate line. Collapsing these two reads conflates two semantically distinct operations into one cached read result. This is an **architectural smell** independent of the staleness window: the same data is now being read for two different decisions, and a future edit to either decision risks the other one silently. This is `principles.md § AP-7` (speculative abstraction) inverted — *de*-duplication that creates implicit coupling between two unrelated operations. Worth surfacing because this is the design-pattern question for the other 5 SF1 edits.

4. **SF1 is a design-pattern bet across 6 workflows.** The operator's note that this edit "may set the design pattern for the others" makes the mitigation choice a Schelling point, not a one-off. If a passive precondition note lands here, the other 5 edits will copy it. If a conditional re-read guard lands here, the other 5 will inherit a more robust pattern. `principles.md § DR-7` (generalize only when a second confirmed consumer exists) cuts the other way too — 6 confirmed consumers IS a second-confirmed-consumer signal, so the pattern question is in scope, not speculative.

### Clear position

The right call is: **PROCEED-WITH-CAUTION verdict stands. Land the edit with a stronger mitigation than the dimension review recommended — a conditional re-read guard, not a passive precondition note.** Specifically:

- Replace the duplicate Read in Step 3 with a reference to the Step 0 read result, AS PROPOSED.
- Add a one-sentence guard at the same site: "If Step 2 took longer than ~30s or a concurrent session may have written to `logs/session-notes.md`, re-read the last 10 lines before locating today's header." This is the cheap mechanical insurance that turns the dimension 5 Medium back to Low while preserving the token saving on the common path.
- Before applying the same pattern to the other 5 SF1 edits, confirm the guard generalizes — different commands have different Step-0-to-write windows and concurrent-write surfaces. The architectural call for SF1 #2–#6 is "audit the staleness window per command, apply the guard pattern where the window crosses an operator-interactive step, skip the guard where the window is tight."

The architecturally cleaner alternative — moving the Step 0 read to a memoized helper that both the warning logic and the header-locate logic call — is correct but out of scope for a one-sentence edit. Flag it as a future refactor if the SF1 sweep surfaces 2+ more sites with the same shape (`principles.md § DR-7`).

The dimension review's "Cheap one-sentence mitigation turns Medium to Low" framing is correct in cost but understated in design value: this is not just mitigating risk, it's setting the SF1 design pattern. Spend the sentence on the version that generalizes.

**Files cited (absolute paths for follow-up):**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` (lines 20–22, 70–96 — Step 0 read, Step 3 read, parse contract)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/principles/principles.md` (OP-3, AP-7, DR-7, DR-8, DR-10)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/risk-topology.md` (§ 1 load-bearing, § 3 canonical command/agent edit, § 5 two-end contracts)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/system-doc.md` (§ 4.5 feedback loops — session-notes.md write path)
