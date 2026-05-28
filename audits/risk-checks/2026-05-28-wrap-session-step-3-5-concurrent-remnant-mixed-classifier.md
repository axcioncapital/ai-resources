# Risk Check — 2026-05-28

## Change

Proposed change: Patch `/wrap-session` Step 3.5 foreign-guard with a CONCURRENT / REMNANT / MIXED classifier per `logs/improvement-log.md` :249 (id-32 source). Edit both the canonical `ai-resources/.claude/commands/wrap-session.md` AND the workspace-root paired copy `~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` per existing PAIRED CONTRACT.

**Change scope:**

1. **After the existing FOREIGN computation** (current line 99 canonical / line 60 workspace-root), inject a date-classifier bash block BEFORE the `FOREIGN >= 1` branch. The classifier uses awk to walk each `^## YYYY-MM-DD` header, tracks the current date as awk-state, and emits per-mandate the enclosing date — producing `WT_TODAY_MANDATES`, `WT_PRIOR_MANDATES`, `HEAD_TODAY_MANDATES`, `HEAD_PRIOR_MANDATES` counts. Then `EXTRA_TODAY_MANDATES = WT_TODAY - HEAD_TODAY - PRIME_RAN` (subtract own contribution) and `EXTRA_PRIOR_MANDATES = WT_PRIOR - HEAD_PRIOR`. Classify: both extras → MIXED; only today extras → CONCURRENT; only prior extras → REMNANT; neither (FOREIGN by header-count only) → UNKNOWN.

2. **Branch the STOP message** by FOREIGN_CLASS:
   - CONCURRENT: existing message verbatim ("switch to the other terminal and run `/wrap-session` there first").
   - REMNANT: NEW message — "{N} prior-day orphan mandate(s) detected. Likely a prior session ran `/prime` + `/session-start` but never invoked `/wrap-session`. Options: (a) commit the orphan as a standalone wrap-recovery commit before proceeding here; (b) abandon — manually clean the orphan from `logs/session-notes.md` if it's no longer wanted. I will NOT proceed automatically."
   - MIXED: NEW message — "Both today-dated and prior-day extras detected — concurrent session AND prior-day orphan. Resolve in order: (1) prior-day orphan first (commit-recovery or abandon); (2) then concurrent-session conflict (switch to other terminal). I will NOT proceed automatically."
   - UNKNOWN: existing message (header-count-only signal is rare; safe default is CONCURRENT-shape).

3. **Update the GUARD echo** to include `FOREIGN_CLASS={value}` for diagnostic transparency.

4. **Update the PAIRED CONTRACT comment block** at the top of Step 3.5 to mention the classifier addition.

5. **Update `ai-resources/logs/improvement-log.md` :249** entry status from `logged (pending)` to `applied 2026-05-28` with `Verified:` line + risk-check report ref.

**Concurrent-session context:** Wave 2 sibling session already wrapped (commit `f598ee1`). No active concurrent session expected during this edit. Will re-read both `wrap-session.md` copies from disk right before applying.

**Phase scoping:** Step 3.5 classifier only. No changes to Step 4 (note append), Step 5 (decisions log), or other Step 3.5 invariants. Edge-case `FOREIGN < 0` path unchanged.

**Why this change:** prior-day orphan mandates (e.g., yesterday's session that ran `/prime` + `/session-start` but skipped `/wrap-session`) currently trigger the same STOP message as concurrent sessions, steering the operator toward the wrong remediation. The classifier produces correct remediation per actual fault class.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A targeted patch to a well-bounded Bash detector with clear pre/post invariants; the only elevated risk is the awk classifier's correctness against the established `^## YYYY-MM-DD` / `^**Mandate:**` parse contract, which one paired mitigation (live-rehearsal on the current working tree before commit) reduces to Low.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change lands in `/wrap-session` Step 3.5, which is invoked on demand at session end — not auto-loaded into every session context. Evidence: command is fired by operator (`/wrap-session`), not by SessionStart/PreToolUse hooks (verified via grep of `.claude/hooks/` — only `check-stop-reminders.sh:24` and `detect-innovation.sh:58` mention wrap-session and they only emit reminder text, not auto-invoke).
- Added body is one bash block (awk classifier ~20-30 lines) inside an already-loaded command body; the per-invocation token delta is small and only paid when the operator actually runs `/wrap-session`. The classifier runs in `bash`, not as additional Read/Grep tool calls.
- No `@import`, no new always-loaded file, no new subagent spawn pattern, no new hook registration.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change uses only Bash with `awk`, `grep`, `git show`, `date`, `cat` — all already invoked elsewhere in the same Step 3.5 bash block (e.g., canonical line 62 `grep -c`, line 64 `git show HEAD:logs/session-notes.md`, line 81 `date -j`). No new tool family is introduced.
- No `.claude/settings.json` or `.claude/settings.local.json` changes implied by the change description.
- No deny-rule removal, no scope escalation, no cross-repo or external API access introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Two files directly modified (canonical + workspace-root paired copy), per the explicit PAIRED CONTRACT block at canonical lines 41-45 and workspace-root lines 13-17. The contract is already documented at both sites.
- Inbound references to `wrap-session` across `ai-resources/.claude/commands/` and `ai-resources/docs/`: 30+ mentions (grep above), but the vast majority are operator-facing reminders ("run `/wrap-session` when done") that are unaffected by an internal Step 3.5 change. Load-bearing parse-contract dependencies: `session-start.md:200-201` declares `wrap-session.md` Step 7a and workspace-root Step 2b as parse consumers of the `**Mandate:**` line / sub-bullet schema — Step 3.5 is upstream of Step 7a in execution order and does not change the schema, so Step 7a parser is unaffected.
- The classifier consumes the same two on-disk conventions already consumed by the existing Step 3.5 detector (`^## YYYY-MM-DD` header from Step 4 / Step 2; `^**Mandate:**` line from `/session-start` Step 3). No new contract is introduced — the classifier is a downstream consumer of existing producer-side contracts.
- The improvement-log entry update at `:249` is an append-style status edit (`logged (pending)` → `applied 2026-05-28` + `Verified:`), conventional and not a contract change.
- Blast count: 2 files modified directly + 1 log-entry status flip; 0 callers require modification to keep working.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are tracked-file modifications; `git revert` on the commit fully restores prior state. No new files, no sibling directories, no symlinks, no settings.json mutations.
- The improvement-log status flip is technically an append-only-log mutation, but the entry already exists at `:249` — the change rewrites two lines in place (Status + new Verified bullet). `git revert` cleanly restores `logged (pending)`.
- No external writes (no push, no Notion, no API POST). No hook or automation registered that could fire between commit and revert.
- Operator muscle-memory impact: the STOP message branches are seen only when the guard actually fires — a rare edge — so revert has near-zero "operator-remembered new workflow" footprint.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The classifier relies on the `^## YYYY-MM-DD` header convention being emitted ONLY by `/wrap-session` Step 4 / Step 2 and by `/prime` (canonical line 11 wrap-session.md, header reuse rule referenced at canonical line 51). Evidence: PAIRED CONTRACT block at canonical lines 41-45 already names header + mandate as the two load-bearing format dependencies, and explicitly flags "Non-conforming writes → FALSE NEGATIVE → foreign content silently clobbered." The classifier inherits the same dependency surface — it does not introduce a new contract, but it does increase the surface that depends on the header date being a parseable YYYY-MM-DD (awk state-tracking assumes the header line itself encodes the date). If a future writer emits `## 2026-05-28 — title` (which is the documented Step 4 format, canonical line 132), the awk regex must accept the trailing ` — {title}` segment; if it emits `## YYYY-MM-DD` bare (which Step 2 workspace-root permits, line 87 example `2026-04-06 — Added context management hooks`), it must also accept that. Both shapes must be handled.
- Functional overlap with `/session-start` Step 0.5 mtime guard (referenced at canonical line 43): both guards may fire on the same incident from different sides. The classifier here does not change that overlap, but the new REMNANT path is a brand-new remediation branch the operator has not seen before — the operator's mental model of "what wrap-session does when it stops me" widens. This is documented coupling (new behavior is named in the STOP message itself), so it is Medium not High.
- The classifier subtracts `PRIME_RAN` from `EXTRA_TODAY_MANDATES` but not from `EXTRA_PRIOR_MANDATES`. This is correct under the assumption that `PRIME_RAN` accounts only for today's own contribution (consistent with the marker mtime logic at canonical lines 81-87). If a future `/prime` ever appends a prior-day-dated mandate (it does not today, but the assumption is not enforced anywhere), the classifier would misclassify. The assumption should be named in the new PAIRED CONTRACT comment update (mitigation below).
- No silent auto-firing in unexpected contexts; the classifier only runs as part of the existing Step 3.5 detector path.

## Mitigations

- **Dimension 3 (Medium) — paired-file sync.** Apply the classifier edit to BOTH files in the same commit; re-read both files from disk immediately before edit (already named in the change description); spot-check after write that the `GUARD: ... FOREIGN_CLASS=` echo string appears in both copies. The PAIRED CONTRACT block at canonical lines 41-45 and workspace-root lines 13-17 must both be updated with the classifier addition.
- **Dimension 5 (Medium) — header-regex coverage and contract documentation.** (a) In the awk classifier, anchor the header match as `^## ([0-9]{4}-[0-9]{2}-[0-9]{2})` capturing only the date prefix — this handles both bare `## 2026-05-28` (workspace-root Step 2 example) and `## 2026-05-28 — title` (canonical Step 4 format) without rework. (b) Live-rehearse the classifier against the *current* `logs/session-notes.md` working tree before commit: run the awk block manually, verify `EXTRA_TODAY_MANDATES`, `EXTRA_PRIOR_MANDATES`, and `FOREIGN_CLASS` produce expected values for at least one constructed case per branch (CONCURRENT, REMNANT, MIXED) — synthetic test files in `/tmp` are acceptable. (c) In the updated PAIRED CONTRACT comment block, add an explicit line: "Classifier assumes `PRIME_RAN` corresponds only to a today-dated mandate; if `/prime` is ever changed to append a prior-day-dated mandate, update the EXTRA_PRIOR_MANDATES formula."

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
