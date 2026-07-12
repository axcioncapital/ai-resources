# Risk Check — 2026-07-12

## Change

Register the canonical ai-resources agent set into `projects/axcion-design-studio/.claude/agents/` by creating **relative symlinks** into the canonical library, mirroring the pattern already used by the 19 sibling projects:

```
ln -s ../../../../ai-resources/.claude/agents/<agent>.md \
      projects/axcion-design-studio/.claude/agents/<agent>.md
```

Proposed: symlink all 42 canonical agents. Retain the 4 existing project-local agent files (`brand-guardian.md`, `implementation-bridge.md`, `layout-architect.md`, `visual-red-team.md`) — no name collisions with canonical agents.

Stated rationale: `ai-resources/logs/friction-log.md` 2026-07-02 entry — `risk-check-reviewer` subagent spawn fails in `axcion-design-studio` sessions because the project's `.claude/agents/` carries only its 4 local agents.

## Referenced files

- `ai-resources/logs/friction-log.md` — exists (read directly; entries at lines 251, 258–260)
- `ai-resources/logs/improvement-log.md` — exists (read directly; entry at lines 97–102)
- `projects/axcion-design-studio/.claude/agents/` — exists (4 regular files, no symlinks)
- `projects/axcion-design-studio/.claude/commands/` — exists (single directory-level symlink → `ai-resources/.claude/commands`, not 89 individual files as the change description assumed)
- `ai-resources/.claude/agents/` (canonical library, 42 files) — exists

## Verdict

RECONSIDER

**Summary:** The change is a manual, one-time patch that duplicates a pre-existing automated mechanism (`auto-sync-shared.sh` + `.claude/shared-manifest.json`) which already solves this exact problem with built-in exclusion logic — hand-symlinking all 42 agents bypasses that logic (exposing 10 agents the mechanism explicitly keeps out of downstream projects) and does not fix the root cause (missing manifest), so every future canonical agent addition will again fail to reach this project silently.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/risk-check.md` | invokes `risk-check-reviewer` | no — already has a documented project-session fallback (line 78, added 2026-07-03: falls back to `general-purpose` with the definition inlined, tier re-asserted) |
| `ai-resources/.claude/commands/qc-pass.md` | invokes `qc-reviewer` | no — same fallback pattern (line 24, added 2026-07-03) |
| `ai-resources/.claude/commands/refinement-pass.md` | invokes `refinement-reviewer` | no — same fallback pattern (line 22, added 2026-07-03) |
| `ai-resources/.claude/commands/triage.md` | invokes `triage-reviewer` | no — genuinely lacks a fallback (grep for "fails to resolve" / "general-purpose" returns 0 hits); this is the one command still exposed today |
| `ai-resources/.claude/commands/blindspot-scan.md` | documents (no subagent dispatch found — runs inline in main session) | no — not actually affected by the agent-registration gap |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` (committed 2026-04-07, `db52e14`) | functional overlap — pre-existing per-file agent+command sync mechanism gated on `.claude/shared-manifest.json`, with a baked-in `EXCLUDE_AGENT_GLOBS` list | no (idempotent — skips existing targets) but this is the load-bearing finding, see Dimension 5 |
| `projects/axcion-design-studio/.claude/settings.json` | co-edits candidate — already wires the `auto-sync-shared.sh` SessionStart hook; the hook is dormant only because the manifest is absent | no for the proposed change; yes for the recommended redesign |
| `projects/axcion-design-studio/CLAUDE.md` (lines 71–72) | documents the 4 local agents' roles | no |
| 17 of 20 sibling projects carrying `.claude/shared-manifest.json` (verified: `ai-development-lab`, `axcion-brand-book`, `axcion-copy-factory`, `strategic-os`, etc.) | documents the established registration pattern (manifest + hook, not manual `ln -s`) | no |
| 10 canonical agents matched by `EXCLUDE_AGENT_GLOBS` (`pipeline-stage-3a/3b/3c/4/5`, `session-guide-generator`, `pipeline-review-auditor`, `scope-architecture-agent`, `scope-qc-evaluator`, `scope-synthesis-agent`) | the literal "all 42" scope of the change directly conflicts with this convention | n/a — these are the targets that would be wrongly exposed |

Total: 10 distinct consumer rows, 0 strictly "must-change" (the proposed change is additive-only and breaks no existing caller), but one High-signal functional-overlap finding (`auto-sync-shared.sh`) and one direct convention violation (10 agents that should stay excluded). `axcion-website` and `global-macro-analysis` also lack `shared-manifest.json` — this is not unique to design-studio, which somewhat undercuts the change's own "design-studio is an outlier" framing (see Dimension 6).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Adding 42 symlinks under `.claude/agents/` adds no always-loaded content — subagents are dispatched on-demand via the Agent tool by name, never auto-loaded (unlike skills, which pattern-match descriptions).
- No hook registration, no `@import`, no CLAUDE.md token growth. Consistent with the 19 sibling projects, which already carry 15–37 agent symlinks each with no reported usage-cost issue (verified via `find -type l` counts across `projects/*/`).

### Dimension 2: Permissions Surface
**Risk:** Low

- `projects/axcion-design-studio/.claude/settings.json` already grants `"Agent"`, `"Bash(*)"`, `Write(**/.claude/**)`, `Edit(**/.claude/**)` in its `allow` list — symlink creation under `.claude/agents/` is fully covered by existing permissions; no new entry required.
- No scope escalation, no cross-repo write, no external API.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Consumer Inventory: 10 rows, 0 must-change callers — no existing caller breaks or requires editing to keep working.
- However, the literal proposed scope (all 42) conflicts with the `EXCLUDE_AGENT_GLOBS` convention baked into `auto-sync-shared.sh` (`pipeline-stage-*`, `session-guide-generator`, `pipeline-review-*`, `scope-*` — 10 of the 42 canonical agents, verified by globbing the canonical list against the hook's exclusion patterns). None of the 19 sibling projects expose these 10 (their agent counts — 15 to 37 — are consistent with 42 minus 10 minus any additional project-local declarations). Landing the change as scoped introduces an inconsistency the rest of the fleet does not have.
- Isolated to `axcion-design-studio`'s own directory; does not touch `ai-resources/` or other projects. This keeps the dimension out of High.

### Dimension 4: Reversibility
**Risk:** Low

- Pure symlink creation, no data/log mutation, no append-only state, no push beyond the local repo. `git revert` (or a plain `rm` of the 42 new symlink files) fully restores prior state with zero residue.

### Dimension 5: Hidden Coupling
**Risk:** High

- A pre-existing SessionStart hook, `ai-resources/.claude/hooks/auto-sync-shared.sh` (committed 2026-04-07, `db52e14` — predates `axcion-design-studio`'s own init commit `ac35a29`), already performs exactly this job: it walks `ai-resources/.claude/{commands,agents}/`, symlinks every file not already present into the project, respects a baked-in exclusion list, and respects a project's declared local overrides via `.claude/shared-manifest.json` (`agents.local` / `commands.local`). It is already wired into `axcion-design-studio/.claude/settings.json`'s `SessionStart` hooks. It is dormant for this project for exactly one reason: `[ -f "$MANIFEST" ] || exit 0` (line 29) — `axcion-design-studio` has no `.claude/shared-manifest.json` on disk (confirmed absent; note `pipeline/repo-snapshot.md:288` claims it exists, which is itself stale).
- The proposed change silently duplicates this mechanism by hand rather than activating it — this is the rubric's explicit High criterion ("functional overlap with existing mechanisms").
- It does not honor the mechanism's own exclusion contract (`EXCLUDE_AGENT_GLOBS`), so it would knowingly place 10 agents the hook's own header comment calls "ai-resources-meta — never belong inside a downstream project" into a downstream project.
- It leaves the root cause (missing manifest) unaddressed: any canonical agent added to `ai-resources/.claude/agents/` **after** this change lands still will not reach `axcion-design-studio`, because the hook still bails at line 29 on every future session start. The fix looks complete today and silently regresses on the next canonical-agent addition — a genuine hidden-coupling / silent-drift hazard, not a one-time gap.

### Dimension 6: Principle Alignment
**Risk:** High

- Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.
- **DR-3** — "Component type determines home; home conventions are fixed." The fixed convention for how a project acquires canonical agents is the manifest + `auto-sync-shared.sh` pair (used by 17/20 sibling projects, predates this project). The change proposes a parallel, hand-authored path that produces a similar end-state through a different, non-canonical mechanism, without acknowledging the existing one exists.
- **OP-11 / OP-3** — "Surfacing/revising principles/conventions is a recurring obligation... loud, deliberate — never silent drift." The change description frames `axcion-design-studio` as uniquely an "outlier in registration style" and proposes hand-symlinking as if no structural alternative exists — it does not surface that the manifest-based mechanism is already present, wired, and simply missing one file. Adopting a different mechanism without naming and rejecting the existing one is exactly the un-loud divergence OP-11/OP-3 warn against.
- Cross-reference with workspace `CLAUDE.md` § "Structural fix as default style; ROI decides scope" (not principles-base but binding workspace doctrine): "the default is structural (self-maintaining going forward)... A short-term patch is a deliberate, logged exception." A one-time batch of 42 hand-written symlinks is a patch — it does not self-maintain against future canonical-agent additions — while the structural fix (add the manifest, 4 lines, matching 17 existing precedents) is directly available, lower-effort, and was not logged as a deliberately-rejected alternative.
- This is a clear, unacknowledged deviation from an established, fixed-home convention — not a merely-in-tension case — so it scores High rather than Medium, and per the special-handling rule for Dimension 6, it cannot be paired down with a technical mitigation.

## Recommended redesign

Per the Dimension 6 special-handling rule (High + unacknowledged): rescope to avoid the violation, rather than making it a loud OP-11 exception — the structural alternative is strictly better on every dimension and no principle actually needs revising.

- Add `projects/axcion-design-studio/.claude/shared-manifest.json` declaring the 4 existing project-local agents under `agents.local` (schema per `projects/axcion-brand-book/.claude/shared-manifest.json`: `{"agents": {"local": ["brand-guardian", "implementation-bridge", "layout-architect", "visual-red-team"]}}`; `commands.local` can stay empty/omitted since no design-studio-local commands were found). This activates the already-wired `auto-sync-shared.sh` SessionStart hook, which will symlink the correct 32 non-excluded canonical agents (honoring `EXCLUDE_AGENT_GLOBS`) on next session start, and will keep doing so automatically for every future canonical agent addition — closing the gap structurally rather than as a one-time patch. If synchronous registration is wanted now rather than at next session start, invoke the hook once directly (`CLAUDE_PROJECT_DIR=... ai-resources/.claude/hooks/auto-sync-shared.sh`) after adding the manifest.
- While in that area: `axcion-website` and `global-macro-analysis` have the same missing-manifest gap (verified) — worth a Friday-cadence follow-up so the same silent-registration-failure class does not resurface elsewhere; out of scope for this specific fix.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, inode/mtime verification, or explicit consumer-inventory findings). No training-data fallback was used on fetch/read failures. Key verifications: `auto-sync-shared.sh` read in full (lines 1–158); `EXCLUDE_AGENT_GLOBS` matched against the live 42-file canonical agent list; `projects/axcion-design-studio/.claude/commands` confirmed via `readlink`/inode comparison to be a live directory-level symlink to canonical (not stale copies, contra the change description's premise); fallback coverage in `risk-check.md`, `qc-pass.md`, `refinement-pass.md`, `triage.md`, `blindspot-scan.md` confirmed by direct grep/read of each file.
