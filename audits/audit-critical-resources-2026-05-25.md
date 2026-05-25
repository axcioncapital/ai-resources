# Critical Resource Audit — 2026-05-25

## Audit Summary

- Resources audited: 1
  - .claude/commands/session-start.md — command
- Total findings: Blocking: 0 / Substantive: 1 / Minor: 5
- Currency check status: succeeded
- `--full-repo-context`: off

## Per-Resource Findings

### session-start.md
**Type:** command
**Path:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md

#### Dimension 1: Brokenness

- **Boundary note disambiguates three "session-start" mechanisms — all three exist on disk.** — Severity: Minor
  - Affected: reader comprehension; no functional break.
  - Evidence: `session-start.sh` referenced exists at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/session-start.sh` (verified). `mandate-parser` skill referenced exists at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md` (verified). Both are workspace-level resources, not in `ai-resources/skills/`. The resource does not specify their paths but their existence (and shape) matches the description.
- **`logs/session-notes.md` reference is valid.** — Severity: clean
  - Evidence: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md` present (verified via directory listing).
- **`/prime` and `/session-plan` slash-command references are valid.** — Severity: clean
  - Evidence: `.claude/commands/prime.md` (13,906 bytes) and `.claude/commands/session-plan.md` (10,279 bytes) both present in the same directory.
- **Parse-contract cross-reference to `wrap-session.md` Step 6a is valid.** — Severity: clean
  - Evidence: `wrap-session.md:40` reads "extract the three sub-bullets (`- Out of scope:`, `- Files in scope:`, `- Stop if:`) and classify each value: `(none stated)` → **omitted**; `(inferred)` → **inferred**" — bullet labels and markers match this command's Step 3 contract exactly.
- **Frontmatter is well-formed and minimal.** — Severity: clean
  - Evidence: lines 1–3 declare only `model: sonnet`. `sonnet` is a valid `/model` shortcut per the official docs.

Inspected: outbound slash-command refs (`/prime`, `/session-start`, `/session-plan`), file refs (`logs/session-notes.md`, `harness/session/startup-state.json`, `harness/session/mandate.json`), skill/script refs (`session-start.sh`, `mandate-parser`), parse-contract dependency on `wrap-session.md` Step 6a, frontmatter validity.

#### Dimension 2: Currency

- **`model: sonnet` frontmatter is a valid override per current docs.** — Severity: clean
  - Doc reference: https://code.claude.com/docs/en/skills (Frontmatter reference table — `model` field "Accepts the same values as `/model`, or `inherit` to keep the active model"). The command file uses the unified skills/commands frontmatter (per the Note at top of doc: "Custom commands have been merged into skills. A file at `.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way").
- **No `description` field declared in frontmatter — doc recommends one.** — Severity: Minor
  - Affected: skill listing visibility; Claude's auto-invocation decision. For a `disable-model-invocation: true`-style operator-only command this is acceptable; this resource does not declare `disable-model-invocation: true` though, so the absence of `description` means Claude has no signal to auto-load. Likely intentional (operator-only invocation) but not asserted.
  - Doc reference: https://code.claude.com/docs/en/skills (Frontmatter reference — "Only `description` is recommended so Claude knows when to use the skill"). May be an intentional ai-resources convention — verify against `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` and existing sibling commands before treating as drift.
- **No `disable-model-invocation` declared despite the command being clearly operator-invoked.** — Severity: Minor
  - Affected: Claude could theoretically auto-invoke a side-effectful command that writes to `logs/session-notes.md`.
  - Doc reference: https://code.claude.com/docs/en/skills (Control who invokes a skill — "Use this for workflows with side effects or that you want to control timing, like `/commit`, `/deploy`"). This command writes to a log file and asks an operator question — a textbook case the doc cites. May be an intentional ai-resources convention; verify against sibling commands.
- **Resource size well under the heuristic cap.** — Severity: clean
  - Evidence: 107 lines (well under the 300-line repo heuristic and the docs' 500-line guidance for SKILL.md).

#### Dimension 3: Architectural Fit

- **Scope is single and clear.** — Severity: clean
  - Evidence: line 5 — "Capture a lightweight session mandate for Phase 3 harness-style sessions." Boundary note (lines 9–12) explicitly contrasts this with the two adjacent mechanisms.
- **Trigger specificity is acceptable but indirect.** — Severity: Minor
  - Affected: discoverability for Claude auto-invocation (moot if operator-only by design).
  - Evidence: no `description` or `when_to_use` — only an inline body sentence ("Capture a lightweight session mandate for Phase 3 harness-style sessions. ... Run after `/prime`"). For operator-only commands this is acceptable; if Claude is ever expected to suggest it, trigger phrases are absent.
- **Placement is appropriate.** — Severity: clean
  - Evidence: command lives in `ai-resources/.claude/commands/`, syncs into workspace `.claude/commands/` via the canonical sync-shared-resources hook (referenced in the 2026-05-20 risk-check). This is the standard repo placement.
- **Abstraction level is appropriate.** — Severity: clean
  - Evidence: command does one bounded thing (write a Mandate line); deeper harness-mandate logic lives in `mandate-parser` skill (boundary note line 12).
- **Type classification (passed as `command`) matches observed structure.** — Severity: clean

#### Dimension 4: Token / Efficiency

- **107 lines total — comfortably under any cap.** — Severity: clean
  - Evidence: `wc -l` = 107.
- **No `@`-imports or auto-load patterns.** — Severity: clean
- **No detected redundancy with sibling commands.** — Severity: clean (inferred — only checked names of siblings, not full content)
  - Note: a deep redundancy check against `prime.md`, `session-plan.md`, and `wrap-session.md` was not run beyond filename inspection. Inferred-risk only.
- **Instruction density is appropriate.** — Severity: clean
  - Evidence: parser rules (lines 64–68) and revert note (line 14) are tight; could not be obviously compressed without losing the parse contract.

#### Dimension 5: Guardrail Integrity

- **Precondition check is graceful (does not block on missing `/prime`).** — Severity: clean
  - Evidence: lines 22–24 — "If no today-dated header is found: emit one warning line … then continue. Do NOT block."
- **Re-ask path for ambiguous single-letter responses is well specified.** — Severity: clean
  - Evidence: lines 65–66 — explicit pattern match and re-ask script.
- **`(none stated)` and `(inferred)` markers are explicit, defined, and contract-bound.** — Severity: clean
  - Evidence: lines 41 (`files_inferred = true`), 57 ("(none stated) fields will be recorded as omitted"), 80 (parse-contract callout pinning labels and markers).
- **Stop condition is implicit.** — Severity: Minor
  - Affected: edge case where operator never confirms after the re-ask.
  - Evidence: line 66 — "Accept the re-response and proceed regardless." This is a clear *forward* stop ("proceed"), but there is no explicit halt for a non-response (operator types nothing). For a one-prompt human interaction this is acceptable; documenting it would be tighter.
- **No fallback for `logs/session-notes.md` being absent or unreadable.** — Severity: Substantive
  - Affected: Step 0 reads it, Step 3 reads/writes it. If the file is missing (new project, permissions issue, dirty state), behavior is unspecified — Step 3 says "append to the file" but does not say "create the file if absent."
  - Evidence: lines 22 ("Read `logs/session-notes.md` (last 10 lines)") and 86 ("Read `logs/session-notes.md` (last 10 lines) to locate today's session header") and 88–96 (no create-if-missing branch). The `(none stated)` discipline elsewhere shows the author cares about explicit fallbacks; this gap stands out.
- **No assumption-filling warning when `$ARGUMENTS` is empty AND operator's verbal reply is sparse.** — Severity: Minor
  - Affected: a one-sentence verbal mandate could yield empty `out_of_scope`, `exit_condition`, `files_in_scope`, `stop_if` — and the resource would silently fill `(none stated)` / `(inferred)` for all four. This is by design (lines 41–42), but the operator-facing echo (lines 47–55) might not flag how much was inferred.
  - Evidence: line 57 — "`(none stated)` fields will be recorded as omitted — only correct if actively wrong." This is appropriate guardrail framing; the residual concern (echo doesn't visibly count inferred fields) is minor.

#### Dimension 6: Cross-Resource Consistency (local)

- `/prime` at line 24 (Step 0) — "Note: /prime may not have run yet today. Proceeding."
- `/prime` at line 107 — "Run after `/prime`" (boundary note line 11).
- `/session-plan` at line 107 (Next pointer) — "Run `/session-plan` to plan model tier, source material, autonomy posture, and structural risk for the session."
- `session-start.sh` at line 10 (boundary note) — "script — run by the `mandate-parser` skill at harness entry (its Step 1); writes `harness/session/startup-state.json`".
- `mandate-parser` at lines 10, 12 (boundary note) — skill referenced as the harness-mandate counterpart.
- `harness/session/startup-state.json` at line 10 — referenced as output of `session-start.sh`.
- `harness/session/mandate.json` at line 12 — referenced as output of `mandate-parser` skill.
- `logs/session-notes.md` at lines 11, 14, 22, 86, 88, 96, 103 — write target for the mandate line; multiple read/append touches.
- `wrap-session.md` Step 6a at line 80 — explicit downstream parse contract: depends on bullet labels and `(inferred)` / `(none stated)` markers written here.

#### Dimension 7: Epistemic Hygiene

Not applicable — resource does not shape downstream AI output. The command captures operator-stated mandate fields verbatim (or `(none stated)` / `(inferred)` markers) and writes them to a log file. It does not generate analytical prose, synthesis, or reasoning; it transcribes. The downstream consumer (`wrap-session.md` Step 6a) is a different audit boundary.

## Cross-Resource Findings

Only one resource was audited in this run, so no cross-resource comparison is possible. Trigger overlaps, broken inter-resource references, contradictions, and composition gaps all require ≥2 nominated resources to evaluate. To assess interaction risk between `/session-start` and its named counterparts (`/prime`, `/session-plan`, `wrap-session.md`, the workspace-level `mandate-parser` skill), re-run with those resources included in the nomination list.

### Trigger Overlaps
No trigger overlaps detected (single-resource run).

### Broken Inter-Resource References
No broken inter-resource references detected (single-resource run).

### Contradictions
No contradictions detected (single-resource run).

### Composition Gaps
No composition gaps detected (single-resource run).

## Unverified / Incomplete Checks

All checks completed.

Note: one inferred-risk item is documented in Dimension 4 — a deep redundancy check against sibling commands (`prime.md`, `session-plan.md`, `wrap-session.md`) was not performed beyond filename inspection. This is a scope choice, not an incomplete dimension.
