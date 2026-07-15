---
model: sonnet
---

Evaluate a proposed structural change against seven risk dimensions before landing — usage cost, permissions, blast radius, reversibility, hidden coupling, principle alignment, and problem reality. Delegates to the `risk-check-reviewer` subagent (fresh context), which first builds an explicit consumer inventory (grep-based blast radius) before scoring; produces a structured report and a chat verdict: GO / PROCEED-WITH-CAUTION / RECONSIDER. Does NOT execute the change.

Input: `$ARGUMENTS` — free-text description of the proposed change, optionally referencing file paths.

Examples:
- `/risk-check edit .claude/hooks/friday-checkup-reminder.sh to add stale-state detection derived from audits/friday-checkup-*.md listing`
- `/risk-check add new slash command /placement and docs/repo-architecture.md`
- `/risk-check allow Bash(rg:*) in workspace settings.json`

Required-when-mandatory change classes (per `ai-resources/docs/audit-discipline.md` § Risk-check change classes):
- Hook edits (`.claude/hooks/*.sh`)
- Permission changes (`settings.json` `allow` / `ask` / `deny` edits)
- CLAUDE.md edits that are cross-cutting (workspace-level or project-level always-loaded)
- New commands or skills
- New symlinks
- Automation with shared-state effects (scripts that auto-write to logs, cross-repo writes, auto-commit)

For non-listed change classes, `/risk-check` is optional and operator-invoked as judgment dictates.

Two intended call sites per session (per `ai-resources/docs/audit-discipline.md` § When to fire):
- **Plan-time** — once after the plan is approved, if the plan touches any required class. `$ARGUMENTS` describes the *design*.
- **End-time** — once before commit, batched across every in-class change the session actually made. `$ARGUMENTS` describes the *executed* change set.

Sessions without an explicit plan run only the end-time gate. Mid-session per-change firing is **not** the intended pattern — it multiplies tokens without proportionate signal.

Invocation semantics: operator-typed, or inline-prompted by other commands (e.g., `/friday-act`). There is NO SessionStart / Stop / PreToolUse hook that auto-fires `/risk-check` — that would over-escalate on ordinary edits.

---

### Step 1: Input Validation

1. If `$ARGUMENTS` is empty, abort with:
   ```
   /risk-check requires a description of the proposed change.
   Example: /risk-check edit .claude/hooks/X.sh to add Y detection
   ```

2. Set `CHANGE_DESCRIPTION` = `$ARGUMENTS` verbatim.

---

### Step 2: Path Setup

3. Set `DATE` = today in `YYYY-MM-DD`.
4. Set `AI_RESOURCES` = absolute path to the canonical `ai-resources/` directory (resolve by ancestor walk-up or the known workspace path). Used for the agent-def lookup in Step 10.
5. Set `REPORT_DIR` by resolving it against the **current checkout**, not a hard-coded canonical path — so a worktree session's report lands in its own checkout rather than contaminating `main`. (`audits/risk-checks/` is `check-foreign-staging.sh`-exempt, so a report written into the wrong checkout would be committed there silently, with no tripwire — which is exactly the defect this resolves.) Three cases, all defined:
   ```bash
   CHECKOUT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
   CUR_COMMON="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
   AIRES_COMMON="$(git -C "{AI_RESOURCES}" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
   if [ -n "$CUR_COMMON" ] && [ "$CUR_COMMON" = "$AIRES_COMMON" ]; then
     # (a) an ai-resources checkout — main OR a git worktree of it (a worktree shares its main repo's
     #     git-common-dir). Write into THIS checkout so the report travels with the branch and never
     #     lands in a foreign checkout. Main-checkout behaviour is UNCHANGED: CHECKOUT_ROOT == AI_RESOURCES there.
     REPORT_DIR="$CHECKOUT_ROOT/audits/risk-checks/"
   else
     # (b) an ordinary project session invoking the symlinked /risk-check (its git-common-dir differs
     #     from ai-resources'), OR git is unavailable. Keep the canonical trail where dozens of
     #     project risk-check reports already live. Behaviour UNCHANGED for this common case.
     REPORT_DIR="{AI_RESOURCES}/audits/risk-checks/"
   fi
   ```
   The git-common-dir comparison is the exact "same repository?" test: a worktree shares its main repo's common dir (→ case a, writes into its own working tree), while a project repo — even one that happens to carry its own top-level `skills/` — has a different common dir (→ case b). Basename matching is deliberately **not** used: a worktree directory is not named `ai-resources`, so a basename test would misroute the very case this fixes. Create if missing (`mkdir -p "$REPORT_DIR"`).
6. Extract referenced file paths from `CHANGE_DESCRIPTION`. Strategy: find tokens that look like paths — contain a `/` and end in a recognized extension (`.md`, `.sh`, `.json`, `.yaml`, `.yml`, `.py`, `.ts`, `.js`) — plus bare filenames matching `CLAUDE.md` or `SKILL.md`.
   - For each candidate, resolve against `AI_RESOURCES` (relative) or accept as-is (absolute).
   - For each resolved path, record its existence status: `exists` or `not yet present`.
   - Unresolvable paths do NOT abort the command — `/risk-check` is often invoked pre-creation, so target files may not yet exist. Record them as `not yet present`.
7. Compute `SLUG` from `CHANGE_DESCRIPTION`:
   - Lowercase.
   - Replace runs of non-alphanumeric characters with a single `-`.
   - Strip leading and trailing `-`.
   - Truncate to 60 characters; if the truncation falls mid-word, trim back to the nearest preceding `-`.
   - If the result is empty, fall back to `change-{HHMMSS}` (current time).
8. Set `REPORT_PATH` = `{REPORT_DIR}/{DATE}-{SLUG}.md`.
9. If `REPORT_PATH` already exists from an earlier invocation with the same slug today, append `-2`, `-3`, etc. until unique.
10. Verify the subagent definition exists at `{AI_RESOURCES}/.claude/agents/risk-check-reviewer.md`. Abort if missing.

---

### Step 3: Spawn risk-check-reviewer Subagent

11. Spawn one `risk-check-reviewer` subagent with these inputs:
    - `CHANGE_DESCRIPTION` — verbatim
    - `REFERENCED_FILE_PATHS` — list, each entry `{absolute path} — {exists | not yet present}`
    - `REPORT_PATH` — absolute path where the subagent must write the full report
    - `DATE`
    - `AI_RESOURCES`

12. Subagent returns a ≤20-line summary ending with `REPORT: {absolute path}` as its last line.

12a. **Project-session spawn fallback (added 2026-07-03).** If the `risk-check-reviewer` agent *type* fails to resolve at spawn — the known failure mode when this command runs from a project session, because `--add-dir` grants file access but does not register agent types — do not abort. Resolve `ai-resources/` by ancestor walk-up (the `$AI_RES` idiom used in `new-project.md`), read `{AI_RESOURCES}/.claude/agents/risk-check-reviewer.md`, strip the YAML frontmatter, and spawn a `general-purpose` subagent with that definition body inlined at the top of the prompt followed by the same inputs as item 11 — **explicitly re-asserting the reviewer tier on the spawn (`model: sonnet`)**: `general-purpose` does not inherit the definition's `model:` frontmatter, and the fallback must pin the reviewer's declared tier rather than inherit the session model (which may be Opus — inheriting would silently raise cost). Note `(fallback: general-purpose, sonnet re-asserted)` in the Step 5 chat verdict line. Step 10's file-existence abort is unchanged — it guards a missing definition file; this fallback guards an unregistered agent *type*.

13. If the returned summary lacks the `REPORT:` last-line marker, re-invoke the subagent once with the same inputs. If the re-invocation also lacks the marker, abort with an error naming the malformed summary and do NOT proceed to validation.

---

### Step 4: Structural Validation

14. Read `REPORT_PATH` back and parse:
    - `VERDICT` — the token under `## Verdict` (must be exactly one of `GO`, `PROCEED-WITH-CAUTION`, `RECONSIDER`).
    - `NUM_HIGH` — count of `### Dimension N: ...` subsections whose body contains the line `**Risk:** High`.

15. Verify presence rules (structural):
    - `## Verdict` section present with a valid verdict token.
    - `## Consumer Inventory` section present (either an inventory table, or the explicit "No consumers found — isolated change." line).
    - `## Dimensions` section present with seven `### Dimension N: ...` subsections (1–7, in order).

16. Verify section-by-verdict rules (enforce the agent's Step 8 template OMIT contract so malformed reports cannot ship):

    - **If `VERDICT` = `GO`:**
      - `## Mitigations` must be either absent, OR present with no content bullets (a placeholder line like `_(Not required — verdict is GO.)_` is acceptable and treated as empty).
      - `## Recommended redesign` must be either absent, OR present with no content bullets (placeholder acceptable).

    - **If `VERDICT` = `PROCEED-WITH-CAUTION`:**
      - `## Mitigations` present with at least `max(1, NUM_HIGH)` content bullets. This enforces the agent's generation rule "at least one mitigation per High dimension." If `NUM_HIGH` is 0 (verdict triggered by two-or-more Mediums), at least one bullet total is still required.
      - `## Recommended redesign` must be either absent, OR present with no content bullets (placeholder acceptable).

    - **If `VERDICT` = `RECONSIDER`:**
      - `## Recommended redesign` present with at least one content bullet.
      - `## Mitigations` must be either absent, OR present with no content bullets (placeholder acceptable).

17. On any validation failure, re-invoke the subagent once with explicit instructions naming the specific violation (e.g., "mitigations section has 1 bullet but `NUM_HIGH`=2 — produce at least one per High dimension"; or "verdict is GO but Mitigations section has content — remove or replace with an empty placeholder"). If validation still fails on the re-invocation, abort with an error naming the violation — do NOT present a malformed report to the operator.

---

### Step 4a: System-Owner Second Opinion (offered on non-GO — not auto-fired)

17a. If `VERDICT` is `GO`, there is no second-opinion offer. Proceed to Step 5.

17b. If `VERDICT` is `PROCEED-WITH-CAUTION` or `RECONSIDER`, do **NOT** auto-invoke `/consult`. Auto-firing a full System-Owner pass on every non-GO verdict multiplied Opus cost on exactly the changes that had already run the heaviest review (the reviewer subagent). Instead, **offer** the second opinion as a ready-to-run command the operator invokes only when the change genuinely warrants an architectural cross-check. The risk-check-reviewer's verdict stands as the gate result either way; a second opinion, if run, is advisory and does not override it.

17c. Build the offer line — **construct it, do NOT execute it** — and carry it into the Step 5 summary:

   > For a System-Owner second opinion, run: `/consult Risk-check second opinion. A proposed structural change received a {VERDICT} verdict from the risk-check-reviewer. Change: {CHANGE_DESCRIPTION}. Dimension risks — {one line per dimension: "Dimension N ({name}): {Low|Medium|High}"}. Verdict summary: {the **Summary:** line under ## Verdict}. Do you concur with the {VERDICT} verdict, and is the recommended path (mitigations for PROCEED-WITH-CAUTION, redesign for RECONSIDER) the right one? Name any risk the dimension review missed.`

   `/risk-check` writes no `## Architectural Commentary` section to `REPORT_PATH`. If the operator runs the offered `/consult`, that command produces its own advisory output; whether to preserve it in the report is the operator's choice, not an automatic append.

---

### Step 5: Present Summary to Operator

18. Display in chat:
    - `Risk check — {DATE}`
    - `Change: {CHANGE_DESCRIPTION first line, truncated to ~100 chars}`
    - `Verdict: {GO | PROCEED-WITH-CAUTION | RECONSIDER}`
    - Consumer inventory headline, from the subagent summary: `Consumers: {N found, M must-change}` (or `none — isolated change`).
    - Per-dimension risk level, one line each, from the subagent summary:
      ```
      - Usage cost:          {Low | Medium | High}
      - Permissions:         {Low | Medium | High}
      - Blast radius:        {Low | Medium | High}
      - Reversibility:       {Low | Medium | High}
      - Hidden coupling:     {Low | Medium | High}
      - Principle alignment: {Low | Medium | High}
      - Problem reality:     {Low | Medium | High | INCOMPLETE}
      ```
    - If verdict is `PROCEED-WITH-CAUTION`: list the paired mitigations under `Required mitigations:`.
    - If verdict is `RECONSIDER`: include the recommended-redesign one-liner.
    - If verdict is non-GO: include the ready-to-run `/consult` offer line built in Step 4a under a `Second opinion (optional):` heading. Do not auto-run it — the operator decides whether to spend the extra pass.
    - `Full report: {REPORT_PATH}`

19. Append guidance based on verdict:
    - `GO` → "Proceed with the change as planned."
    - `PROCEED-WITH-CAUTION` → "Mitigations above are required. Confirm each is applied when you land the change."
    - `RECONSIDER` → "Address the findings before proceeding. Re-invoke /risk-check after redesign."

---

### Step 6: No Commit, No Execution

20. `/risk-check` is a pre-execution gate. It does NOT execute the change. It does NOT commit the report.

21. The report lands in the working tree under `audits/risk-checks/`. The operator (or downstream command such as `/friday-act`) decides the next action based on the verdict. If the operator wants the report preserved in git history, they stage and commit it alongside the change it gated (or as a standalone `audit: risk-check — {slug}` commit).
