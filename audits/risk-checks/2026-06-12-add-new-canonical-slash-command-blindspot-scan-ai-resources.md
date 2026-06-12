# Risk Check — 2026-06-12

## Change

Add new canonical slash command /blindspot-scan (ai-resources/.claude/commands/blindspot-scan.md — advisory, inline, no subagent, modifies no files; auto-symlinks to all projects) plus one conditional non-blocking nudge line in each of the two wrap-session.md copies (ai-resources + workspace root) suggesting /blindspot-scan before commit when the session touched commands/skills/hooks/CLAUDE.md or multi-file changes. Approved plan: /Users/patrik.lindeberg/.claude/plans/investigate-a-use-case-spicy-micali.md

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/blindspot-scan.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/.claude/plans/investigate-a-use-case-spicy-micali.md — exists

## Verdict

GO

**Summary:** A pay-as-used advisory command (no subagent, no file writes, no permission change) plus two one-line conditional nudges; the design pre-cleared the one structural trap (OP-12 closure-before-detection) by naming a finding-closure home, so all six dimensions land Low.

## Consumer Inventory

The new command file (`blindspot-scan.md`) is `not yet present`, so it has no consumers yet. The inventory below covers (a) the contract the new command introduces — the `/blindspot-scan` invocation token — and (b) the two wrap-session copies the change edits. Search terms: `blindspot-scan`, `/blindspot-scan`, plus the two `wrap-session.md` basenames (already named in the change).

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/wrap-session.md | invokes (adds conditional nudge line before Step 12b end-time risk-check) | yes |
| /.claude/commands/wrap-session.md (workspace root) | invokes (adds conditional nudge line before Step 6 push gate / after Step 4.5) | yes |
| projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-blindspot-scan-15-ideas.md | documents (design provenance) | no |
| projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-blindspot-scan-final-pass.md | documents (design provenance) | no |
| ai-resources/.claude/hooks/auto-sync-shared.sh | imports (auto-symlinks every `ai-resources/.claude/commands/*.md` into ~15 project `.claude/commands/`; no edit needed — picks up the new file automatically) | no |

**Total: 5 consumers, 2 must-change** (both wrap-session copies — already the explicit scope of the change). The two consult files are read-only documentation. `auto-sync-shared.sh` is the propagation mechanism: it requires no edit but will silently create ~15 project symlinks on next session start (verified: `auto-sync-shared.sh:4,13,82` — "when you add a new command to ai-resources, every project picks it" up via the `commands/*.md` walk). No consumer surfaced outside what `CHANGE_DESCRIPTION` anticipated — the description already discloses the auto-symlink fan-out.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new command is pay-as-used: operator-invoked, runs inline only when called. No always-loaded cost. Plan line 23: "NO wiring into … CLAUDE.md trigger section (always-loaded token cost — revisit post-v1)." The design explicitly declined the always-load path.
- Posture matches existing advisory siblings `/drift-check` and `/contract-check` (both `model: opus`, advisory, invoked on demand) — verified frontmatter, `drift-check.md:1-3`, `contract-check.md:1-3`. No new ongoing cost beyond those established peers.
- The two wrap-session edits add **one conditional line each**, not an always-loaded block — and only inside a command body that already loads only when `/wrap-session` runs. Net add to the per-wrap load is one line per copy. Plan line 24: "one conditional, non-blocking nudge."
- The command body itself is loaded in full per `/blindspot-scan` invocation (a recurring per-run cost flagged by the SO at `consult-...-15-ideas.md:45`, DR-5 economics) — but that cost is borne only on explicit invocation, not per session, so it is Low under this dimension's "pay-as-used" calibration. Note: body length is `not yet present`, so the exact per-run token cost is judged from the design intent (3 checks + phase inference + 6-item checklist + output contract), which the SO weight rule kept lean.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission change. Plan line 27: "No new agent, no log, no registry, no settings change, no doc edits." The command modifies no files (plan line 29: "advisory only, modifies no files").
- The command's actions are read-only verification — `git status --short`, `git log --name-only`, greps, file reads (plan lines 45–49). These fall within already-established read-only Bash/grep patterns the advisory siblings use; no new tool family, no `deny` narrowing, no scope escalation.

### Dimension 3: Blast Radius
**Risk:** Low

- Consumer inventory: **5 consumers, 2 must-change** — both must-change consumers are the two wrap-session copies that the change itself edits (the inventory introduces no surprise caller).
- New file is isolated; 0 pre-existing callers of the `/blindspot-scan` token other than the design docs. No contract that other components `parse` is altered — the change adds a command and two advisory lines; it changes no report-section heading, hook output shape, or frontmatter schema that anything downstream reads.
- Auto-symlink fan-out to ~15 project command dirs (verified via `auto-sync-shared.sh:82` walk + 15 project command dirs found) is **additive and compatible** — each project gains a new optional command; nothing existing breaks. The plan discloses this explicitly (build-sequence step 2: "auto-symlinks into every project's `.claude/commands/` on next session start").
- The two wrap-session copies are independent paired files that must stay in sync (their own MIRROR NOTE / PAIRED CONTRACT comments confirm this discipline, e.g. `ai-resources/.claude/commands/wrap-session.md:362-364`). Editing one without the other would create paired-copy drift — but that is a known, documented co-edit obligation the change already commits to (both copies in scope), not an unmodelled caller.

### Dimension 4: Reversibility
**Risk:** Low

- The command is a single new file; `git revert` (or `rm`) fully removes it. The two wrap-session edits are one-line additions reverted cleanly by git.
- The command modifies no files when run (plan line 29), so invoking it between landing and a potential revert leaves no residue to clean up — distinct from a log-appending or state-mutating command.
- One minor cleanup beyond git: the auto-symlinks created in ~15 project dirs are **not** removed by reverting the canonical file. They become broken symlinks until `/fix-symlinks` runs. This is a one-step, well-tooled cleanup (`fix-symlinks.md` exists) and the symlinks are untracked per-project artifacts, not committed state — so it stays Low (borderline Low/Medium; the existing `/fix-symlinks` tooling and the fact that broken command symlinks are inert, not harmful, keep it Low). No external/pushed state.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The command's new contract (the `VERDICT:` output shape, the routing table) is documented at the change site — in the command body itself (plan lines 44, 51). No undocumented marker other components must honor.
- Check A depends on an existing convention — grepping the **invariant stem** of changed identifiers, anchored to `skills/ai-resource-builder/SKILL.md § Consumer-Inventory Gate` (plan line 47). This is one explicit, documented dependency on an established repo rule, not a silent assumption.
- The marker-glob read (`logs/session-plan-*${MARKER}.md`) is guarded: plan line 45 "tolerate marker absence — read-only auxiliary consumer per `docs/session-marker.md`." The coupling to the session-marker subsystem is read-only and degrade-tolerant, not load-bearing.
- No auto-firing: the command never runs itself; the wrap-session nudge is a suggestion to the operator, non-blocking (plan line 23 "non-blocking"). No hook ordering or silent cross-session side effect introduced.
- No functional overlap that double-handles a concern: the design routes every non-owned finding type to the existing review family rather than re-implementing it (plan line 44 routing table; SO confirmed "clean partition," `consult-...-final-pass.md:9`).

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`); checks applied against the frozen-ID set.
- **OP-12 (closure before detection)** — the single load-bearing principle risk for a detection command. A pure-detection scanner that only emits a verdict would count *against* the candidate (`consult-...-final-pass.md:19` flagged exactly this). The design **closes the gap**: plan line 52 names a finding-closure home — fired findings record into the session-plan file or a `maintenance-observations.md` block, routing into existing `/resolve` / `/friday-act` loops. Detection ships behind a working closure channel. OP-12 satisfied, not violated.
- **OP-9 / AP-7 / DR-7 (speculative abstraction).** The command itself targets confirmed recurring incidents (plan line 10 cites multiple logged friction/improvement entries: stale-dependents, cc-worktree usage-fit miss, un-buildable SessionStart-hook premise) — not an absent consumer. The design also *encodes* DR-7/AP-7 into the command's own output contract as the proportionality rule (`consult-...-15-ideas.md:35`), making it self-limiting. Scope was actively trimmed from 6 categories to 3 (plan line 15), with v2 features deferred — the opposite of speculative expansion.
- **OP-5 (advisory vs enforcement).** The command advises and stops (verdict only, modifies no files); the wrap-session nudge is non-blocking. No advisory→enforcement upgrade. Aligned.
- **OP-10 (system boundary).** No cross-tool reach; the command operates on Claude Code repo state only. Aligned.
- **DR-1 / DR-3 (placement).** Canonical home `ai-resources/.claude/commands/blindspot-scan.md` for a reusable command — correct tier and home (SO confirmed, `consult-...-15-ideas.md:5`). Aligned.
- **DR-8 (risk-check gating).** The change correctly treats itself as a two-gate `/risk-check` class (this report is the plan-time gate; the plan schedules the end-time gate at build step 5). Aligned.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION, the approved plan, the two wrap-session copies, principles-base.md, and the auto-sync-shared.sh hook). The new command file is `not yet present`; its contribution to Dimension 1 (body length) is judged from the described design intent, noted inline. No training-data fallback was used on any read.
