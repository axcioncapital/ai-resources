# Risk Check — 2026-05-27

## Change

end-time gate on workspace CLAUDE.md addition: new "## Contract-Conformance Check" section.

Change summary: Added a 12-line section to workspace CLAUDE.md (workspace root, always-loaded across every session in this repo) between the existing "## QC Independence Rule" and "## Assumptions Gate" sections. The section explains the structural gap that /contract-check (just shipped in commit 11d079a) addresses — that /qc-pass is scope-bounded and misses cumulative drift — and lists four trigger conditions for invoking /contract-check. Modeled after the tone/length of neighboring rule sections. Single-file edit. No hook, no settings, no command, no agent changes.

Context: Operator asked for the reminder so they don't forget to invoke /contract-check in long sessions. QC pass returned GO. The section adds always-loaded content to a cross-cutting CLAUDE.md, which is a structural change class per audit-discipline.md — hence end-time risk-check.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — exists

## Verdict

GO

**Summary:** A 12-line always-loaded addition to workspace CLAUDE.md that names a real structural gap (`/qc-pass` scope-bounded), points to the existing `/contract-check` command for the fix, and matches the tone and length of neighboring rule sections — token cost is small and bounded, no permissions/blast/coupling impact, fully reversible by `git revert`.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new section spans 12 lines (CLAUDE.md:46–57) and totals 157 words (`awk 'NR>=46 && NR<=57' CLAUDE.md | wc -w` returned 157) — roughly ~210 tokens added to an always-loaded file. The full workspace CLAUDE.md is 1,896 words / 189 lines (`wc -l CLAUDE.md` returned 189), so the addition is roughly 8% growth.
- The Step 2 calibration band ("Medium = adds ~50–150 tokens to always-loaded files") would technically place this at the low end of Medium on token count alone, but the section is a pure prose addition with no `@import`, no hook registration, no auto-loading subagent, and no SessionStart/PreToolUse/Stop wiring — so the cost is one-time per session-load and bounded. The change description explicitly confirms: *"Single-file edit. No hook, no settings, no command, no agent changes."*
- No expansion of a frequently-spawned subagent brief; no broadly-pattern-matching skill description. The cost is just the prose itself.
- On the spectrum, this is a borderline Low/Medium token cost — graded Low because: (a) the prose summarises a genuine cross-cutting rule that wasn't previously documented in always-loaded scope (operator explicitly requested it to be in scope so it surfaces every session), (b) it replaces nothing but adds no auto-loading machinery, (c) the change description says "Modeled after the tone/length of neighboring rule sections" — comparable sections like § QC Independence Rule (lines 40–44, 5 lines), § Assumptions Gate (lines 59–61, 3 lines), § Decision-Point Posture (lines 106–108, 3 lines) confirm the new section is slightly longer than its neighbours but in the same band as § Working Principles (lines 67–73, 7 lines) and § Model Tier (lines 142–148, 7 lines).

### Dimension 2: Permissions Surface
**Risk:** Low

- The change description states: *"No hook, no settings, no command, no agent changes."* No `allow`, `ask`, or `deny` entries added or modified. No new tool invocation pattern introduced. No scope-escalation from project → user. No external API or cross-repo capability added.
- The addition is pure prose in a CLAUDE.md file — no executable surface.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 1 (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`).
- Grep for `Contract-Conformance` across `ai-resources/` (`.md` files): 0 hits — no existing code/docs reference the new heading, so no callers need updating.
- Grep for `contract-check` across `ai-resources/` (`.md` files): 23 hits across 2 active files — the command itself (`.claude/commands/contract-check.md`) and the prior plan-time risk-check (`audits/risk-checks/2026-05-27-new-slash-command-contract-check.md`). The new CLAUDE.md section references the command by name (`/contract-check`); the command already exists on disk (verified by Read in this evaluation), so the inbound link from CLAUDE.md to the command is satisfied.
- No contract changes: no subagent input schema, no report-section heading, no hook output shape, no slash-command invocation syntax, no frontmatter schema is altered by the addition.
- No shared infrastructure (logs, scripts, hooks) is touched. The change is text-only in one cross-cutting prose file.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit. `git status` confirms only `modified: CLAUDE.md` is the change of interest for this scope (other modified/untracked entries belong to unrelated work). A `git revert` of the commit that lands this section cleanly removes the 12 lines and restores the prior state.
- No sibling files created. No log/registry/innovation file appended. No `settings.json` change. No state pushed to external systems (Notion, GitHub remote). No hook/cron/automation added that could fire between landing and a hypothetical revert.
- Section sits between two stable neighbours (`## QC Independence Rule` and `## Assumptions Gate`); the surrounding markdown structure is unaffected, so a revert leaves no orphaned anchors or headings.

### Dimension 5: Hidden Coupling
**Risk:** Low

- One inbound dependency on `/contract-check` — the section names the command at CLAUDE.md:50 ("Run `/contract-check` to close this gap"). The command exists on disk at `ai-resources/.claude/commands/contract-check.md` (verified by Read — file present, 195 lines, `description` and `model: opus` frontmatter intact). The dependency is explicit, named, and pre-existing.
- The four trigger conditions named in the new section (CLAUDE.md:52–55) closely mirror the "Use it when:" list already present in the command itself (`contract-check.md:8–12`). Cross-checked: both name (a) two-pass cap moment, (b) long-running/post-compaction sessions, (c) checkpoint before commit / iterated artifact, (d) operator suspects drift but `/drift-check` returns ALIGNED. The CLAUDE.md prose is consistent with the command's documented invocation conditions — no contradiction surface introduced.
- One soft overlap with `/drift-check`: trigger (d) in the new CLAUDE.md section references `/drift-check`-ALIGNED as a precondition for invoking `/contract-check`. `/drift-check` exists on disk (verified by Read, 83 lines) and returns `ALIGNED | MINOR-DRIFT | MAJOR-DRIFT` — the prose's claim "returns ALIGNED" matches `drift-check.md:59`. No silent contract assumption.
- No silent auto-firing — `/contract-check` remains operator-invoked only, and the new CLAUDE.md section explicitly says "Run `/contract-check`" (operator-action verb, not an auto-fire mechanism).
- No functional overlap with existing CLAUDE.md sections: § QC Independence Rule (lines 40–44) covers `/qc-pass`; § Working Principles (lines 67–73) covers between-gate summaries and pointer to `/drift-check`; the new section adds a *different* lens (contract-conformance vs. trajectory drift vs. per-pass QC) and names that distinction explicitly. The taxonomy across QC / drift / contract-check is documented in the prose itself.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references — CLAUDE.md:46–57 verified by Read; contract-check.md:8–12 verified by Read; drift-check.md:59 verified by Read; grep counts across `ai-resources/` for `Contract-Conformance` and `contract-check`; `wc -l` / `wc -w` measurements of the new section and the full file; `git status` confirming single-file modification scope; verbatim quotes from CHANGE_DESCRIPTION). No training-data fallback was used.
