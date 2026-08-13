# Risk Check — 2026-07-29

## Change

End-time gate, batched across every in-class change this session made. Materially expand the existing command `.claude/commands/leverage-idea.md` from an advisory plan-producer into a routing-and-handoff command, plus three consumer-contract co-edits. No new files are created. The executed change set is:

1. **Input domain widened.** The command previously accepted only ideas about workspace AI resources (the Claude Code substrate). It now classifies every idea into one of six domains (AI resource / operating capability / project or programme / technical need / domain-or-content decision / cross-tool) at a new Step 5a, and draws its lever menu from the classified domain.

2. **Routing rewritten (shared-state adjacent).** The Step 10 bridge matrix is replaced by an owner/route table. Previously only "New skill" routed to `/develop-ai-resource`; the row for "New command / agent / hook / other structural class" routed to `/risk-check` instead. Now every new-or-materially-expanded durable AI resource of any class routes to `/develop-ai-resource`, and `/risk-check` is named as a gate rather than an owner. New routes name `/work-loop`, `/scope-project`, `/tech-consult`, `/improve-skill`, `/tweak`, and named project owners.

3. **NEW AUTO-WRITE TO A TRACKED SHARED QUEUE.** On the new-AI-resource route the command now writes a Resource Brief to `{AI_RESOURCES}/inbox/{DATE}-{SLUG}.md` (with `-2`/`-3` uniqueness suffixing, never overwriting). Previously the command explicitly stated "The command itself never writes to `inbox/`" and embedded the brief for the operator to hand-copy. `inbox/` is a git-tracked intake queue drained by `/develop-ai-resource`'s archive convention.

4. **EXISTING SHARED-STATE OP RESTRUCTURED — path resolution.** `AI_RESOURCES` was hardcoded to the absolute path of the main worktree (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`). Four worktrees of this repository are live. It is now resolved from the session: (a) if the session sits inside an ai-resources worktree (detected by `git rev-parse --show-toplevel` plus the presence of both `skills/ai-resource-builder/SKILL.md` and a regular-file, non-symlink `.claude/commands/leverage-idea.md`), use that worktree; (b) otherwise walk up to the nearest ancestor holding both `ai-resources/` and `projects/` and use `{ancestor}/ai-resources`; (c) if neither resolves, stop with an error and explicitly do NOT fall back to a hardcoded path. **This changes which working tree the existing PARK append to `logs/improvement-log.md` writes into**, and which tree the Step 2 duplicate scan reads.

5. **Resolution moved earlier in the sequence.** The path resolution moved from Step 3 to Step 0.2, so it now precedes the Step 2 duplicate-gate scan (which previously used a relative `ai-resources/...` path and is now expressed in terms of the resolved `{AI_RESOURCES}`). This is a reordering of shared-state operations relative to one another.

6. **Subagent tier pinned.** The Step 4 `general-purpose` investigator dispatch now pins `model: opus`; previously unpinned, silently inheriting the session model. The investigator's brief was also widened to search `{WORKSPACE}/projects/` in addition to `{AI_RESOURCES}`, and to stop assuming the idea is an AI-resource idea.

7. **PARK entry category de-hardcoded.** The PARK template's `Category:` was the literal `command/skill (leverage-idea PARK)`; it is now `{the Step 5a domain} (leverage-idea PARK)`. The mandatory `Severity:` field and concrete `Review-cycle:` trigger are unchanged.

**Co-edits (consumer contracts kept accurate):**
- `.claude/commands/develop-ai-resource.md` line 9 — added "agent definition" to its authority enumeration, which previously omitted it while `docs/ai-resource-creation.md` placed agent definitions under that command.
- `docs/agent-tier-table.md` — moved `/leverage-idea` from the "spawns unpinned" roster row to the "pins the tier" row (that file's own maintenance rule requires this in the same commit as the retrofit), and updated the as-of date and both counts.
- `logs/improvement-log.md` — appended a "Partial — 1 of 6 done" note to the existing 2026-07-12 entry; the entry deliberately stays `logged (pending)` since five commands remain unretrofitted.

**Deliberately NOT changed (out of scope by the brief):** `projects/axcion-ai-system-owner/references/toolkit-relationship.md:55` still describes `/leverage-idea` as feeding `/request-skill` and producing build proposals. The brief forbids sibling-repo edits; this is a known stale reference left for a separate follow-up.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-leverage-idea/.claude/commands/leverage-idea.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-leverage-idea/.claude/commands/develop-ai-resource.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-leverage-idea/docs/agent-tier-table.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-leverage-idea/logs/improvement-log.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-leverage-idea/inbox/leverage-idea-lifecycle-routing.md` — exists (the governing brief)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/toolkit-relationship.md` — exists (known stale, deliberately untouched)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The five underlying defects are independently re-derived and confirmed real (not merely asserted), the change stays within its disclosed scope and adds no new component, but the actual consumer count exceeds the change's own accounting — a live-agent-read file (`toolkit-relationship.md`, read on every System Owner invocation) and three same-day capability-development build-plan documents now carry stale content, driving Blast Radius to High with a viable, named mitigation.

## Consumer Inventory

Search terms used: `leverage-idea` (basename + command token), `develop-ai-resource` (co-edited file), `agent-tier-table` (co-edited file), `improvement-log.md` 2026-07-12 entry, `inbox/` (the contract the new write taps into). Searched `{AI_RESOURCES}/.claude/commands/`, `.claude/agents/`, `docs/`, `skills/`, `workflows/`, `plans/`, `logs/decisions.md`, both CLAUDE.md files, and the workspace root (`find projects -name leverage-idea.md`), plus the sibling `axcion-ai-system-owner` project named in the brief. Grep instrument checked: `grep` is shadowed by `ugrep` in this shell (confirmed: `grep -rl "Severity" .` → 149 vs `command grep -rl` → 157 in this worktree), matching the documented gap in `docs/audit-discipline.md`. All searches below used absolute/explicit paths or globs outside gitignored directories, so the shadow does not affect these results — none returned zero hits, so the canary script was not required.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/develop-ai-resource.md` | invokes (new route target) / documents `/leverage-idea` at line 22 | no further (already co-edited this changeset for its own gap) |
| `docs/agent-tier-table.md` (compliance roster) | parses / documents — its own maintenance rule requires the roster move in the same commit as a retrofit | yes — done (co-edited) |
| `docs/ai-resource-creation.md:46` | documents (names `/leverage-idea` as applying the complexity-budget gate "at proposal-time") | no — already consistent with the new Step 6 language |
| `logs/improvement-log.md` (2026-07-12 entry) | co-edits (target of the "Partial — 1 of 6" append) | yes — done (co-edited) |
| `projects/axcion-ai-system-owner/references/toolkit-relationship.md:55` | documents — **read by the System Owner agent "on every invocation"** (file's own line 3); describes `/leverage-idea` as `coexist`, feeding only `/request-skill`, "different scope from architectural oversight" | yes — **not done**, deliberately deferred (cross-repo, out of brief's scope) |
| 14 symlinked project copies of `.claude/commands/leverage-idea.md` (`find projects -name leverage-idea.md -type l` → 14, re-derived) | invokes | no — auto-propagates via symlink; **currently point to the main worktree's unmodified file** (verified: `ai-resources` main worktree's `leverage-idea.md` is byte-identical to the pre-change base at commit `44062e4`), so none of the 14 see this change until it merges to `main` |
| `plans/2026-07-28-develop-capability-build-plan-{v2,v3,v3.1}.md` | documents — cite exact stale line numbers (`leverage-idea.md:9`, `:11-13`, `:128`, `:165`) and describe the pre-change behavior ("idea dumps about workspace AI resources... stops at a plan") as settled fact (F23, D9, D12) | no (historical point-in-time build-plan artifacts, not living specs) — **but this is an unanticipated consumer gap: not named anywhere in `CHANGE_DESCRIPTION`'s "known stale" disclosure, which names only `toolkit-relationship.md`** |
| `plans/2026-06-12-leverage-idea-build-plan.md` | documents (original build plan, already self-labeled "IMPLEMENTED & COMMITTED", pre-existing historical staleness) | no |

**Total: 8 consumer entries, 3 must-change (2 already resolved via co-edit in this same changeset; 1 outstanding and explicitly deferred).** One additional consumer class (the three `develop-capability-build-plan` documents) surfaced by this inventory was not named in `CHANGE_DESCRIPTION`.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No CLAUDE.md file (workspace or repo) appears in the diff — confirmed via `git diff HEAD --stat`: only `.claude/commands/develop-ai-resource.md`, `.claude/commands/leverage-idea.md`, `docs/agent-tier-table.md`, `logs/friction-log.md`, `logs/improvement-log.md` changed.
- No hook added or edited (no file under `.claude/hooks/` in the diff).
- No `@import` introduced.
- The Step 4 investigator subagent brief was widened (added a `WORKSPACE` search leg, removed the AI-resource-only assumption), but this subagent is spawned only when `/leverage-idea` itself is invoked — operator-cadenced, not per-turn or per-session-start — so the growth is pay-as-used, not ambient.
- `leverage-idea.md` itself grew (161 lines changed per `git diff --stat`), but commands are read only at invocation time (`/leverage-idea`), never always-loaded — growth here has no ongoing per-turn cost.
- `docs/agent-tier-table.md` and `logs/improvement-log.md` are read on-demand / once-per-session by existing mechanisms (`/prime`'s severity scan) that are unaffected by one additional line.

### Dimension 2: Permissions Surface
**Risk:** Low

- `git diff` shows no touch to any `settings.json` / `settings.local.json`.
- `.claude/settings.json` in this worktree already grants unscoped `"Write"`, `"Edit"`, `"Bash(*)"` under `"defaultMode": "bypassPermissions"` — the new `Write` target (`{AI_RESOURCES}/inbox/{DATE}-{SLUG}.md`) requires no new grant; it is already covered by the existing blanket `Write` allow.
- No external API, MCP, or cross-repo write capability introduced — the inbox write stays inside `{AI_RESOURCES}`, the same repo the command already reads and writes (`audits/working/`, `logs/improvement-log.md`).
- No `deny` rule removed or narrowed.

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory (above) found **8 distinct consumer entries**, exceeding the ">5 dependent callers" High threshold.
- One caller — `projects/axcion-ai-system-owner/references/toolkit-relationship.md` — **requires modification to stay accurate and is not being modified.** Its own line 3 states it is "Read by the agent on every invocation," and it currently describes `/leverage-idea` as `coexist` scope, feeding only `/request-skill` on a new-skill recommendation. Post-change, `/leverage-idea` feeds six different owners and no longer names `/request-skill` as a destination at all in its routing table (confirmed via diff — the new Step 10 table's rows are `/develop-ai-resource`, `/work-loop`, `/scope-project`, `/tech-consult`, `/improve-skill`, `/tweak`, named project owners). Every future System-Owner consultation will ground on this now-inaccurate row.
- **Unanticipated consumer gap:** `plans/2026-07-28-develop-capability-build-plan-v2.md`, `-v3.md`, and `-v3.1.md` — same-day-adjacent capability-development build-plan documents — cite specific line numbers in `leverage-idea.md` (`:9`, `:11-13`, `:128`, `:165`) that have shifted, and assert the pre-change behavior ("stops at a plan," "idea dumps about workspace AI resources") as a stable fact in findings F23, D9, D12. `CHANGE_DESCRIPTION`'s own "known stale" disclosure names only `toolkit-relationship.md` — it does not name these three documents. This is exactly the kind of gap Step 1.5 exists to surface.
- Mitigating context: of the 3 "must-change" consumers, 2 are already resolved in this same changeset (`docs/agent-tier-table.md`, `logs/improvement-log.md`); the 14 symlinked project copies require no per-project action and, moreover, currently point at the **unmodified** main-worktree file (verified byte-identical to pre-change base) — so today's actual live blast radius is zero and becomes 14 only at merge to `main`, which is the normal worktree/branch model and not a defect in the change.
- No backwards-incompatible machine-parsed contract break found: the PARK template's `Category:` field change (hardcoded string → `{domain}`) has no consumer that parses that literal string (checked — only the file that emits it references it); `Severity:`/`Status:` fields consumed by `/prime` and `/resolve-improvement-log` are untouched.

### Dimension 4: Reversibility
**Risk:** Medium

- The diff is 4 tracked `.md` file edits (plus an auto-appended `logs/friction-log.md` write-activity block, not part of the substantive change) — `git revert`/`git checkout` on these files cleanly restores prior state; no new files or directories were created (confirmed: 0 new files in the diff).
- `logs/improvement-log.md` is a named red-flag file class for this dimension (append-only log), but the specific append here is a single narrative bullet added to an *existing pending* entry, not a status flip or a new entry — reverting it removes exactly that line and leaves the entry accurately describing the pre-retrofit state (0 of 6 done), so there is no orphaned/stale-entry problem of the kind this dimension usually flags.
- The change does not itself write to `inbox/` at land time — the new write only fires at future `/leverage-idea` invocations, so landing (or reverting) this change does not by itself create or need to unwind any inbox state.
- No push, external write, or cron/hook automation introduced that could fire between landing and a potential revert.
- Residual nuance: the governing brief `inbox/leverage-idea-lifecycle-routing.md` is still sitting in `inbox/` (not yet archived by `/develop-ai-resource` Step 4); if that archival with its disposition note happens after this gate clears and the change is later reverted, the archival itself would not auto-revert — a one-step manual note would be needed. This is what keeps the dimension at Medium rather than Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One new contract, documented at the change site.** The `{AI_RESOURCES}/inbox/{DATE}-{SLUG}.md` write is a new durable contract, but it is explicitly documented in the command body (Step 7) and deliberately reuses the `/request-skill` brief shape and the existing `inbox/` → `/develop-ai-resource` archive convention (already consumed by `monday-prep.md`, `open-items.md`, `contract-check.md`, `weekly-cadence.md`, `reconcile-backlog.md` — none of which assume a specific naming pattern beyond "a `.md` file directly under `inbox/`," so the new `{DATE}-{SLUG}.md` naming is compatible with all of them).
- **Path-resolution heuristic is self-documented and cites its precedent.** Branch (a)'s dual test (regular-file `leverage-idea.md` + presence of `skills/ai-resource-builder/SKILL.md`) and branch (b)'s ancestor walk-up are both explicitly cross-referenced to the existing `auto-sync-shared.sh`/`/reconcile` idiom rather than inventing a silent parallel mechanism. Independently spot-verified: from `ai-resources-leverage-idea` both conditions hold (regular file + SKILL.md present); from a symlink-consuming project (`projects/buy-side-service-plan`) the regular-file test correctly fails (its `leverage-idea.md` is a symlink), so it falls through to branch (b) as intended — the discrimination control holds under independent re-test, not just the caller's word for it.
- **Implicit dependency on sibling commands' current contracts.** The new routing table names `/work-loop`, `/scope-project`, `/tech-consult`, `/improve-skill` as receiving commands with a described payload shape ("a unit brief naming the capability and its owning project," etc.). These commands exist and are committed in `main` today (verified `/work-loop` present in the main worktree), but `docs/work-loop.md` and the capability-development build-plan documents show heavy same-day construction activity elsewhere in the repo. The routing table's payload descriptions are generic prose rather than a rigid schema, which bounds the risk, but the coupling is real: if `/work-loop`'s actual input shape moves before this lands, the described payload becomes inaccurate without this file having changed.
- No auto-firing, no hook-ordering interaction, and no functional overlap with an existing mechanism — the command explicitly disambiguates itself from `/implementation-triage` and `/risk-check` rather than silently duplicating either.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read successfully).

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not violated.** This is a material expansion of an existing, currently-used command (14 live symlinked consumers), not new-component creation for an absent consumer. The brief's own exclusions explicitly forbid adding "a command, agent, mandatory gate, tracker or other durable component," and the diff confirms zero new files. The complexity-budget gate (`docs/ai-resource-creation.md` rule #7) applies only to *new* components and is correctly not the operative test here.
- **OP-10 (system boundary) — not touched.** The "Cross-tool" domain lever only *names* the tool assignment per the existing workspace cross-model rules; it does not add any new governance of GPT/Perplexity/Notion/NotebookLM behavior.
- **OP-12 (closure before detection) — not applicable.** This is a routing/handoff command, not a new detection/audit mechanism.
- **OP-5 (advisory vs. enforcement) — respected, arguably strengthened.** The change repeatedly reaffirms "applies no other change," "the handoff never auto-invokes," and adds an explicit completion criterion ("Stop here — handing over is not executing"). The prior version could dead-end at a plan with no named owner; the new version makes the advisory/handoff boundary more, not less, explicit and testable.
- **OP-2 (automate execution, gate judgment) — respected.** Decision-point posture is preserved (operator still makes the call on the payload); the complexity-budget cap still routes a new-component option to an explicit OP-11 waiver rather than auto-approving it.
- **OP-11 (loud revision, never silent drift) — satisfied.** The `toolkit-relationship.md` staleness is disclosed loudly and explicitly in `CHANGE_DESCRIPTION` itself ("known stale reference... will need updating wherever this work lands"), not discovered as a surprise — this is the loud-acknowledgment path, not silent drift, even though the underlying file is not yet fixed.
- **DR-1 / DR-3 (placement) — respected.** All edits stay in their existing canonical homes (command in `.claude/commands/`, doc in `docs/`, log entry in `logs/`); no tier or home change.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not merely asserted, for all five items (D1–D5), independently re-derived (not inherited from the brief):**
  - D1 (bridge matrix bypasses qualification owner) — confirmed by reading the actual removed lines in `git diff HEAD -- .claude/commands/leverage-idea.md`: the old Step 10 table's only `/develop-ai-resource` row was "New skill"; the "New command / agent / hook / other structural class" row read exactly "Plan's Gates name the `/risk-check` class; the bridge repeats it."
  - D2 (gitignored analysis file as sole next-action address) — independently re-ran `git check-ignore -v audits/working/` → exit 0 at `.gitignore:28`, and the positive control `git check-ignore -v docs/work-loop.md` → exit 1. Both exactly match the figures asserted in `CHANGE_DESCRIPTION`'s premise-verification note.
  - D3 (AI-resource-only lever menu) — confirmed via diff: the old Step 5 offered exactly five levers, all AI-resource-shaped ("Extend an existing resource," "New command + agent," "New CLAUDE.md rule or doc," "New hook," "Park").
  - D4 (hardcoded path across 4 live worktrees) — confirmed via diff (`AI_RESOURCES = "/Users/.../ai-resources"` literal) and independently re-ran `git worktree list` → 4 worktrees (`ai-resources`, `ai-resources-2`, `ai-resources-leverage-idea`, `ai-resources-work-loop`), matching the claimed count exactly.
  - D5 (unpinned dispatch) — confirmed via diff and cross-checked against the pre-change content of `docs/agent-tier-table.md` (visible in the same diff), which listed `leverage-idea` in the "not yet retrofitted" roster before this change.
- **Consequence — traced, not merely consistent-looking, for all five:** D1's consequence (structural resources skip qualification) follows directly from `/risk-check` being a risk-evaluation gate, not a build-qualification engine (independently confirmed by reading `develop-ai-resource.md` and `toolkit-relationship.md`'s own mechanism table). D4's consequence (writes land in the wrong worktree) was independently spot-verified: the 14 symlinked projects point to the **main** worktree specifically (confirmed byte-identical to pre-change base), so a session invoked directly from a non-main worktree with the old hardcode would misdirect the Step 2 scan and Step 8 PARK append — a reproducible, not merely plausible, failure mode. The path-resolver's own discrimination control (branch (a) correctly failing for a symlink-consuming project) was independently re-tested against `projects/buy-side-service-plan` and held.
- **Re-derivation vs. the change description:** None — every count, path, and quoted line checked (the 14-symlink count, the 4-worktree count, the `.gitignore:28` line, the exact old-file line content, the discrimination-control behavior) matched `CHANGE_DESCRIPTION`'s own premise-verification claims exactly. No contradiction found.
- This dimension is not "not defect-justified" — the change is explicitly defect-justified (D1–D5), and every defect clears the observed-and-traced bar.

## Mitigations

- **Dimension 3 (High):** Update `projects/axcion-ai-system-owner/references/toolkit-relationship.md` § 2's `/leverage-idea` row in a same-repo follow-up session before the next System-Owner consultation runs — that file is read on every invocation, and its current `coexist`/"feeds `/request-skill`" description is now materially wrong. Replace with a short summary of the six-domain routing table and the new `/develop-ai-resource` ownership for all new-resource classes.
- **Dimension 3 (High):** Add a one-line "stale as of 2026-07-29 — `/leverage-idea`'s shape changed materially, line citations below no longer resolve" note next to the `leverage-idea.md` line citations in `plans/2026-07-28-develop-capability-build-plan-v3.1.md` (and its `v2`/`v3` predecessors) at findings F23, D9, and D12, so a future reader of those build-plan artifacts is not misled by stale line numbers.
- **Dimension 5 (Medium, optional):** Before relying on the described "unit brief naming the capability and its owning project" payload shape in a live `/work-loop` handoff, read `/work-loop`'s current input-handling section once to confirm the shape still matches, given the adjacent same-day capability-development construction activity.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
