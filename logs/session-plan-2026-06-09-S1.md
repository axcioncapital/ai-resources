# Session Plan — 2026-06-09

## Intent
refresh-project-state Session 2 — land + wire + validate: satisfy the three GO-gates, scaffold the vault `project-state/` area, apply the operator-approved §15 governance amendment, extend `/kb-integrity`, graduate the 3 dev artifacts, wire the OS `state-retrieval-agent`, then validate via dry-run + full run against §13 acceptance.

## Model
opus — match (active: `claude-opus-4-8[1m]`). Deciding-heavy: structural permission design (G1/G2), governance wording, the G3 atomic-rollback structural-vs-accept decision, and the end-time `/risk-check` judgment.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/docs/project-state-workflow-spec.md` — §13 acceptance, §14 gated build order + GO-gates, §15 amendment wording (the Session 2 spine)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-06-09-refresh-project-state-vault-governance-amendment.md` — full risk-check (PROCEED-WITH-CAUTION) + system-owner commentary; the GO-gate source
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/CLAUDE.md` — governance to amend (Rule 2 line ~56, Query-mode line ~33)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/.claude/commands/kb-query.md` — 3rd canonical-only site (line ~23 + description line)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/.claude/commands/kb-integrity.md` — extend Check D to `project-state/`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/templates/finding-note.md` + `findings/_index.md` — shape templates for the new `project-state` template + index
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/refresh-project-state/.claude/` — 3 dev artifacts to graduate (command + 2 agents)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/.claude/agents/state-retrieval-agent.md` — OS agent to wire (inclusion list)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural-class reference for the end-time `/risk-check`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — canonical settings shapes for G1/G2 deny + folder-scoped Write

## Findings / Items to Address
1. **G1 — structural Read-deny (spec §14 GO-gate, line 190).** Each target project's `.claude/settings.json` must DENY `Read` of `*deal-*` / `*client-*` / `*confidential*`. The snapshot agent's in-prompt §4.3 block is not sufficient alone — confidentiality must be structural. **Decision needed:** enumerate target projects + confirm deny-pattern shape against `permission-template.md`.
2. **G2 — folder-scoped Write (spec §14 GO-gate, line 191).** Graduate the workflow with `Write(knowledge-bases/strategic-os/project-state/**)` + staging dir only. NO `Write(vault/**)` wildcard.
3. **G3 — atomic-rollback test (spec §14 GO-gate, line 192 + §13 criterion-4, line 173).** The §13 forced-failure rollback test must pass (no index drift) before first full run. **Decision needed (structural-fix-as-default):** disposition (a) accept crash-mid-rollback as `/kb-integrity` Check D-recoverable and document, OR (b) write-temp-then-rename structural fix. Workspace default leans (b); confirm at stop point.
4. **Scaffold vault `project-state/` (spec §14 step d, §5.1).** Create `project-state/` folder + `templates/project-state-note.md` + `project-state/_index.md`, matching `findings/_index.md` shape.
5. **§15 amendment — 3 sites + identity sentence (spec §15, operator-approved 2026-06-09).** Add Governance Rule 5 (machine-maintained folder); add `auto` tier to Rule 2; amend canonical-only restriction at all 3 sites (vault `CLAUDE.md` Rule 2 + Query-mode section + `kb-query.md` line ~23 + description); add the vault-identity two-store sentence; add `auto`-note frontmatter fields. Exact wording is in spec §15 lines 206–226.
6. **Extend `/kb-integrity` Check D (spec §14 GO-gate lockstep item, line 193).** Cover `project-state/` (or document the exemption).
7. **Graduate 3 dev artifacts (spec §14 step e).** `ai-resources/workflows/refresh-project-state/.claude/{commands,agents}/` → `ai-resources/.claude/{commands,agents}/`; strip the DEV banners; symlink per workspace graduation rules.
8. **Wire OS `state-retrieval-agent` (spec §14 step f, §6.1).** Add the vault `project-state/` source to its inclusion list. No `settings.json` read-path entry needed (OS already has `Read(*)` + workspace root in `additionalDirectories`).
9. **Validate (spec §14 step g + §13).** End-time `/risk-check` on the executed change set → dry-run ONE project → verify scrub + atomic write → full run across all projects → check §13 criteria 1–6.

## Execution Sequence
1. **GO-gate design (G1/G2/G3) — no writes yet.** Enumerate CLAUDE.md-bearing target projects; draft the G1 deny patterns + G2 folder-scoped Write against `permission-template.md`; settle the G3 disposition (a vs b). **Verify:** all three gates have a concrete, written design. → **STOP POINT 1** (operator reviews permission shapes + G3 disposition before anything lands).
2. **Scaffold vault `project-state/`** (folder + template + index). **Verify:** `project-state/_index.md` matches `findings/_index.md` shape; template conforms to §4 schema.
3. **Apply §15 amendment** to all 3 sites + identity sentence + frontmatter fields. **Verify:** grep each site shows the `auto` allowance; no canonical-only statement remains un-amended.
4. **Apply G1 deny rules** to each target project's settings + **G2 folder-scoped Write** to the graduated workflow's settings. **Verify:** each settings.json parses; deny patterns present; no `Write(vault/**)` wildcard.
5. **Extend `/kb-integrity` Check D** to `project-state/`. **Verify:** Check D references `project-state/`.
6. **Implement G3 disposition** (structural temp-rename if (b), or documented acceptance if (a)) + run the forced-failure rollback test. **Verify:** test passes, no index drift.
7. **Graduate 3 dev artifacts** + strip banners + symlink. **Verify:** canonical files exist, banners gone, symlinks resolve.
8. **Wire OS `state-retrieval-agent`.** **Verify:** inclusion list names the vault `project-state/` source.
9. **End-time `/risk-check`** on the full executed change set. **Verify:** GO. → **STOP POINT 2** (if not GO, pause).
10. **Dry-run ONE project** → verify scrub + atomic write. → **STOP POINT 3** (operator confirms before the first full run — the "do not rush" directive). Then **full run** → check §13 criteria 1–6. **Verify:** every snapshot carries `confidentiality-scrub: applied`; index updates atomic; OS can read.

## Scope Alternatives
- **Min:** GO-gates + amendment + scaffold + graduate + wire, dry-run on ONE project only; defer the full cross-project run to a follow-up (keeps the riskiest step — first run across all projects — isolated).
- **Recommended:** Full sequence 1–10 including the full run, gated at the three stop points. The §13 acceptance needs the full run to close.
- **Max:** Recommended + a `/contract-check` near wrap (multi-step structural session iterated against the spec mandate) before commit.

## Autonomy Posture
Gated — multiple structural change classes (permission edits across several project settings, governance `CLAUDE.md` edit, new commands/agents via graduation, automation with shared-state effects).

**Stop points:**
- **STOP POINT 1** — after GO-gate design (G1 deny patterns, G2 Write scope, G3 disposition a vs b), before any shared-state write lands.
- **STOP POINT 2** — if the end-time `/risk-check` returns anything other than GO.
- **STOP POINT 3** — after the ONE-project dry-run, before the first full run across all projects (operator-chosen "do not rush" boundary).

## Risk
Run `/risk-check` after this plan is approved is NOT required separately — the plan-time gate already ran in Session 1 (verdict PROCEED-WITH-CAUTION, system-owner concurred, three GO-gates extracted). The **end-time `/risk-check`** on the executed change set is mandatory before commit (Execution step 9 / STOP POINT 2). Structural classes confirmed present: permissions, new commands/agents, cross-cutting governance edit, shared-state automation — full class list `ai-resources/docs/audit-discipline.md`.
