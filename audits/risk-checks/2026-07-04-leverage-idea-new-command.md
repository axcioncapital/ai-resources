# Risk Check — 2026-07-04

## Change

End-time gate (pre-commit) on an executed change set. Change class: new canonical command. Change set: (1) new file ai-resources/.claude/commands/leverage-idea.md — an Opus, advisory-only command that turns an idea dump into a distilled Idea Brief → one general-purpose investigator subagent (evidence + repo-surface, notes-to-disk ≤30-line-return contract) → 2–4 leverage options → WORTH-DOING/MARGINAL/NOT-WORTH-DOING verdict → implementation plan or PARK to improvement-log.md. Writes only to audits/working/ and (on PARK) appends to logs/improvement-log.md; applies no repo change; hands off to /request-skill, /create-skill, /tweak, /improve-skill, /implementation-triage but never auto-invokes them. (2) pending post-landing edit: append one `coexist` row for /leverage-idea to the System Owner's toolkit-relationship.md § 2 roster. Distribution: auto-sync-shared.sh symlinks it into every project on next session start. Build was pre-approved via SO advisory (WORTH-DOING) 2026-06-12; this is the pre-landing risk gate the plan's Gates section mandates.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/leverage-idea.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/toolkit-relationship.md — exists (pending edit)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists (distribution mechanism)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists (PARK write target)

## Verdict

GO

**Summary:** A well-scoped, advisory-only new command that conforms to existing contracts and actively serves the operating principles; the only elevated dimension is reversibility (Medium — dangling-symlink cleanup + a cross-sub-repo doc edit), which does not block a GO.

## Consumer Inventory

Search terms: `leverage-idea` (command token/name), `auto-sync-shared`, `toolkit-relationship`, `improvement-log`, plus the PARK-schema markers (`### YYYY-MM-DD —`, `**Status:** logged (pending)`, `**Review-cycle:**`) and the five handoff-command tokens. Grep run across `ai-resources/` and the workspace root. The new command file exists on disk; nothing in the repo *invokes* it at runtime yet — all `leverage-idea` hits outside the file itself are planning/design/decision records or the distribution/contract consumers below.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-ai-system-owner/references/toolkit-relationship.md | co-edits (pending `coexist` row in § 2 roster) | yes |
| ai-resources/.claude/hooks/auto-sync-shared.sh | imports (symlinks the command into every project on next SessionStart) | no |
| ai-resources/.claude/commands/resolve-improvement-log.md | parses (reads the PARK entry schema the command appends to improvement-log.md) | no |
| ai-resources/logs/improvement-log.md | co-edits (PARK write target — append-only on PARK outcome) | no |
| ai-resources/.claude/commands/request-skill.md | documents (advisory handoff bridge; never auto-invoked) | no |
| ai-resources/.claude/commands/create-skill.md | documents (advisory handoff bridge) | no |
| ai-resources/.claude/commands/tweak.md | documents (advisory handoff bridge) | no |
| ai-resources/.claude/commands/improve-skill.md | documents (advisory handoff bridge) | no |
| ai-resources/.claude/commands/implementation-triage.md | documents (handoff bridge + verdict-vocabulary reuse) | no |
| ai-resources/logs/decisions.md, plans/2026-06-12-leverage-idea-build-plan.md, logs/session-notes-archive-2026-06.md, logs/scratchpads/2026-06-12-18-22-scratchpad.md | documents (historical design/decision records) | no |

Total: 9 functional consumers + a group of historical records; 1 must-change (toolkit-relationship.md). All five handoff commands and both contract consumers (resolve-improvement-log parser, improvement-log write target) confirmed present and compatible. The distribution hook (auto-sync-shared.sh) is generic and picks up the new command with no modification.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pay-as-used slash command — adds nothing to any always-loaded workspace/project CLAUDE.md, registers no hook, adds no `@import`. Frontmatter `model: opus` (leverage-idea.md line 3) binds tier per-command; the model and its one subagent are spawned only when the operator types `/leverage-idea`.
- One general-purpose investigator subagent per invocation (leverage-idea.md Step 4, lines 53–91), honoring the ≤30-line-return / notes-to-disk contract (lines 84–90) — cost is incurred only on demand, not per session.
- Distribution symlinks the command into every project (auto-sync-shared.sh lines 82–96), but symlinked command files are not auto-loaded — they cost tokens only when invoked. No per-session cost from distribution.
- Only ongoing cost: the pending one-row addition to toolkit-relationship.md (~40 tokens), which the `system-owner` agent reads on every invocation (toolkit-relationship.md line 3: "Read by the agent on every invocation"). This is bounded to System Owner consultations, not every session, and is well under the ~50–150-token Medium threshold for always-loaded surfaces.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json change is in the change set. The description names no `allow`/`ask`/`deny` edit, no scope change, and no new tool family.
- The command's writes are confined to already-writable paths: `audits/working/` (analysis + subagent notes, Steps 3/9) and an append to `logs/improvement-log.md` on PARK (Step 8, lines 142–154) — both inside `ai-resources`, within established write patterns.
- Subagent dispatch via `Task` and read/grep tooling are already-authorized patterns for advisory commands in this repo; no new consequential capability (shell escalation, cross-repo write, external API) is introduced.
- Distribution symlinks rely on the existing auto-sync SessionStart hook already deployed in project settings — no new permission granted to create them.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files: 1 new file (leverage-idea.md) + 1 pending one-row edit (toolkit-relationship.md). Consumer inventory (Step 1.5): 9 functional consumers, **1 must-change** (toolkit-relationship.md § 2 roster row).
- The only contract the command *writes* is the PARK entry in improvement-log.md. It conforms to the existing schema `/resolve-improvement-log` parses — verified: the command's Step 8 header `### {DATE} — {short idea title}` + `**Status:** logged (pending)` + `**Review-cycle:**` (lines 145–154) matches the live file format (`### 2026-07-03 — …` at improvement-log.md line 20) and the parser's expectations (resolve-improvement-log.md lines 26, 59, 70). Backwards-compatible; no caller must change to keep working.
- Shared infra touched: auto-sync-shared.sh distributes the command to every project by symlink on next SessionStart. This is wide but non-breaking and automatic — the hook is skip-if-exists / idempotent (lines 88, 105) and the distributed file is inert until invoked. No project needs modification.
- The five handoff commands are referenced *outbound* as advisory bridges (Step 10 matrix, lines 198–204) and are never auto-invoked (line 196: "The bridge never auto-invokes") — they are dependencies the command names, not callers that must change; all five confirmed present.
- Minor placement note: the change description correctly targets **§ 2** (the "Workspace Commands — v1 Disposition" roster) for the new row; the build plan text (2026-06-12-leverage-idea-build-plan.md line 75) says "§ 5", which is the Maintenance Rule section, not the roster. Land the row in § 2 per the change description, not § 5.

### Dimension 4: Reversibility
**Risk:** Medium

- The new command file reverts cleanly with `git revert` in ai-resources.
- Two extra cleanup steps push this above Low: (a) the toolkit-relationship.md row lives in the separate `projects/axcion-ai-system-owner/` sub-repo with its own commit boundary — reverting the command in ai-resources does not touch it (prior risk-check 2026-05-29-delete-audit-critical-resources… line 95 documents this same cross-sub-repo boundary); (b) once any project has a SessionStart between landing and a revert, auto-sync-shared.sh will have created symlinks pointing at the command in every project — deleting the source file leaves those symlinks **dangling**, and git revert of ai-resources does not remove them. The identical pattern is documented in placement-rename-and-verifier-2026-05-28.md line 51 ("The old route-change.md symlinks in projects will become dangling").
- Cleanup after a revert therefore needs a `/fix-symlinks` (or manual dangling-symlink sweep) pass across projects plus a separate revert in the SO sub-repo — a multi-location manual step beyond a single `git revert`.
- Note: the PARK append to improvement-log.md is not a landing-time concern — it only fires on future *runs* of the command, so it does not affect reversibility of landing the command itself.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The one cross-component contract the command creates — the PARK entry shape that `/resolve-improvement-log` must parse — is explicitly named and verified at the change site (leverage-idea.md Step 8 line 156: "This shape matches the schema `/resolve-improvement-log` archives against"), and the concrete `Review-cycle:` trigger is enforced as a hard requirement (lines 148, 156), matching the parser's park-as-graveyard guard (resolve-improvement-log.md line 59). Not a silent contract.
- The distribution dependency on auto-sync-shared.sh is an ambient, established repo convention that every command relies on — not a new implicit dependency this change introduces.
- The toolkit-relationship § 5 maintenance coupling (a new command must get a roster row or the System Owner silently mis-grounds) is real but explicitly identified (SO advisory consult-2026-06-12 finding 2) and closed by the pending § 2 row. Residual: a stale-registry window exists until that row lands — land it in the same landing pass, not "later".
- Overlap with siblings is acknowledged and managed, not silent: the SO advisory confirmed no overlap-degradation across the five named commands (each a distinct lifecycle phase), the command carries explicit boundary sentences vs `/tech-consult` (lines 11) and siblings (line 13), and the Step 2 duplicate/triviality fast-path gates (lines 36–43) plus the Step 4 semantic-search brief (line 75) manage the dominant "router recommends a build that already exists" risk.
- Verdict vocabulary reuse from `/implementation-triage` is documented as reuse with the routing-not-ROI caveat (lines 118, 124), the same coexist-via-shared-shape relationship already recorded in toolkit-relationship.md § 2 (`/risk-check` row, line 31).

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base readable at projects/strategic-os/ai-strategy/principles-base.md — checks applied against it directly.
- **OP-12 (closure before detection) — actively served.** Every command output terminates in a closure channel: WORTH-DOING → implementation plan + one handoff bridge (Steps 7, 10); PARK → improvement-log entry with a mandatory concrete Review-cycle trigger (Step 8); duplicate/trivial → routed to the existing resource or `/tweak` (Step 2). The SO advisory conditioned its WORTH-DOING on exactly this (consult-2026-06-12 finding 3), and the command honors it. This is a detection/routing engine that ships behind a working closure channel — the OP-12-compliant shape.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — aligned.** The command serves a confirmed, recorded gap (decisions.md line 250: no existing pipeline takes a raw idea dump and routes it to the best attach point), not an absent future consumer. One general-purpose investigator, not a speculative fan-out. Not "hooks for later".
- **OP-10 (system boundary = Claude Code only) — respected, not expanded.** Scope is explicitly the Claude Code substrate, and the Step 5 cross-model check (line 112) routes an inherently non-Claude idea to its proper tool with an explicit tool assignment rather than defaulting it into a Claude build.
- **OP-5 (advisory vs enforcement) — aligned.** "Advisory only: it stops at the implementation plan and applies no change" (line 9); handoffs "never auto-invoke" (line 196). No enforcement upgrade.
- **OP-2 (automate execution, gate judgment) — aligned.** The Step 6 verdict is explicitly labeled a routing verdict, not a context-isolated ROI certification, and points to `/implementation-triage` for an independent read (line 124) — it does not automate a load-bearing judgment call and present it as certified.
- **DR-1 / DR-3 (placement) — correct.** New canonical command in `ai-resources/.claude/commands/` — the fixed home for a shared command. **DR-8** (risk-check at plan-time and end-time for new-command class) is being honored by this very gate.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: leverage-idea.md line/step references, verbatim quotes from the command body and CHANGE_DESCRIPTION, auto-sync-shared.sh and resolve-improvement-log.md line references, the live improvement-log.md header format, principle IDs cited from principles-base.md, and grep counts across `ai-resources/` and the workspace root for the Consumer Inventory. No training-data fallback was used on any read.
