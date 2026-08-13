# Risk Check — 2026-07-20

## Change

A single git pre-commit hook (check-case-boundary.sh, one check, blocking, --no-verify-escapable) newly installed in a new project repo with zero pre-existing external consumers.

**End-time gate** (architecture §5.3b; `decisions.md` #9, binding). This evaluates what was actually built by Stage 4 — the script and the symlink on disk in `projects/axcion-pitch-engine/` — not the proposed design the plan-time `/risk-check` (`decisions.md` #12) evaluated. Executed inline by the Stage 4 implementer agent following the `risk-check-reviewer` methodology (`ai-resources/.claude/agents/risk-check-reviewer.md`); no subagent spawn was available in this agent's toolset (Read/Write/Edit/Bash only, no Task/Agent tool). This is the lightest form that satisfies the gate for a single script in one new, unpushed repo (workspace CLAUDE.md § Subagent Proportionality).

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/.claude/hooks/check-case-boundary.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/.git/hooks/pre-commit` — exists (symlink)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/pipeline/implementation-spec.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-20-axcion-pitch-engine-check-case-boundary-dual-layer-hook.md` — exists (plan-time report, prior gate)

## Verdict

GO

**Summary:** The built artifact is strictly simpler than the design the plan-time gate evaluated — a single git-native pre-commit hook with zero Claude Code registration, zero external consumers, byte-verified `settings.json`, and a behaviourally-verified block/escape cycle; all seven dimensions score Low.

## Consumer Inventory

Search terms: `check-case-boundary` (script basename/contract marker), `axcion-pitch-engine` (project name). Grepped across `ai-resources` and the workspace root using absolute-path forms (`command grep -r <term> /abs/path`), which `search-canary.sh` classifies as **not blind** — confirmed by running the canary: `SEARCH_CANARY=blind` was reported only for the dot-rooted (`.`) test case; this inventory used absolute paths throughout, so the blind mode does not apply here.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/audits/risk-checks/2026-07-20-axcion-pitch-engine-check-case-boundary-dual-layer-hook.md` | documents | no |

Total: 1 consumer, 0 must-change. The one hit is the plan-time risk-check report itself — it describes the design, does not invoke the script. A repo-wide grep for `check-case-boundary` outside `projects/axcion-pitch-engine/` and that one report returns zero hits: no `ai-resources/` command, agent, skill, hook, or `settings.json` references it. `.claude/settings.json` in the built repo is a byte-identical, unmodified copy of the canonical template (`diff` empty, verified) — it contains no reference to the hook. The hook's only registration is the untracked `.git/hooks/pre-commit` symlink inside the new repo's own `.git/`, which by construction has no consumers outside that repo.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added. `CLAUDE.md`'s `## Operating Constraint` section documents the guard in prose but adds no hook registration, no `@import`, no per-turn mechanism — `grep -c 'model' CLAUDE.md` shows the only two hits are the Model Selection prohibition prose, not a loaded directive.
- No SessionStart / PreToolUse / PostToolUse hook registered anywhere. `grep -c '"model"\|PostToolUse'` on the built `.claude/settings.json` returns 0 for both (verified). The guard fires exactly once per `git commit` invocation — a pay-as-used event, not a per-session or per-tool-call cost.
- `.claude/settings.json` is byte-identical to `ai-resources/templates/project-settings.json.template` (`diff` — no output, verified on disk) — no added SessionStart hooks beyond the canonical two already in the template.

### Dimension 2: Permissions Surface
**Risk:** Low

- Zero permission changes. The built `settings.json`'s `permissions` block is untouched from the canonical template (byte-diff confirms).
- The hook is invoked by git itself (`.git/hooks/pre-commit`), not by the Claude Code permission system — no `allow`/`ask`/`deny` entry was needed or added.
- The script's own Bash surface is narrow and read-only against git state: `git rev-parse`, `git diff --cached`, `git show :path`. No `rm`, no `mv`, no writes to any file. Confirmed by reading the full 144-line script body.

### Dimension 3: Blast Radius
**Risk:** Low

- Consumer inventory (Step 1.5, above): 1 consumer found, 0 must-change. The one hit is a documentation reference in the plan-time risk-check report, not a functional dependency.
- The change touches exactly 4 new files plus 1 workspace-root `.gitignore` line-append in a repo that has never been pushed and has no other collaborators (verified: `gh repo view axcioncapital/axcion-pitch-engine` → "Could not resolve to a Repository," confirmed 2026-07-20 in this session).
- No contract change to any existing component — the script, the symlink, and the repo are all new. Nothing that previously worked depends on any file this change touches.
- Shared infra: the workspace-root `.gitignore` was appended with one line (`projects/axcion-pitch-engine/`), the same low-risk pattern already used for the 20 preceding sibling project entries in the same block — verified: `grep -n 'axcion-pitch-engine' .gitignore` returns exactly one match, inside the correct "Nested project repos" block.

### Dimension 4: Reversibility
**Risk:** Low

- The tracked script (`check-case-boundary.sh`) reverts cleanly via `git rm` / `git revert` — ordinary git history, once the initial commit lands.
- The untracked symlink (`.git/hooks/pre-commit`) requires a second, documented manual step to remove (`rm .git/hooks/pre-commit`) — this asymmetry is not a defect discovered here; it was already identified and mitigated at plan-time (`decisions.md` #14) by writing the two-step removal procedure into `CLAUDE.md § Operating Constraint`, verified present in the built file (`grep -c 'no-verify' CLAUDE.md` ≥ 1, and the "Removing the guard takes two steps" paragraph is present at line 25 of the built `CLAUDE.md`).
- Nothing has propagated beyond the local repo: no push occurred (constraint verified — repo remains local-only), no external API write, no Notion write.
- This dimension would score Medium on a component with undocumented asymmetric reversibility; here the asymmetry is disclosed in the one human-readable place a future operator will look, which is why it clears to Low rather than Medium.

### Dimension 5: Hidden Coupling
**Risk:** Low

- No implicit dependency on another component's specific behavior. The script's only external call is to `git` itself (`command -v git`, `git rev-parse`, `git diff --cached`, `git show`) — standard, stable git plumbing, not a fragile convention.
- The one new contract the script introduces — `MARKER_RE`, the confidentiality-marker regex — is explicitly documented at the change site (in-script comments, lines verified present: "Check A — classification-marker leak" block) and in `CLAUDE.md § Operating Constraint`. It is not a silent convention.
- No functional overlap with an existing mechanism: `.claude/settings.json` has no hook registration of any kind for this project (verified: 0 `PostToolUse` hits), so there is no second system also reacting to the same event.
- The regex's forward dependency is explicitly flagged, not hidden: `decisions.md` #19 (G1) records that S1.1 has not yet defined the confidentiality-marker syntax this regex assumes, and that S1.1 must either emit a matching form or update `MARKER_RE`. A disclosed forward dependency, tracked in the decisions log, is the Low-scoring case — an undisclosed one would not be.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-12 (Closure before detection).** The hook is detection with a working closure channel: it does not merely flag, it `exit 1`s and blocks the commit — the closure is the block itself, and `--no-verify` is the documented override channel. No open-ended detection without closure.
- **OP-9/AP-7/DR-7 (Speculative abstraction).** The design was explicitly *narrowed* at the plan-time gate, not expanded: the `PostToolUse` advisory layer was dropped (`decisions.md` #13) precisely because it was detection without a closure channel and added registration surface with no second confirmed consumer. What was built has zero Claude Code hook registrations — the minimal form, not a speculative one. Check B (CRM naming) was cut for the identical reason (`decisions.md` #8) and was correctly not built here (verified: `grep -c 'CRM' check-case-boundary.sh` → 0 hits for any product-naming check logic).
- **OP-11 (Loud revision, never silent drift).** The weaker evidentiary basis for the guard (mandate + review, not incident) is stated plainly and loudly in both `CLAUDE.md § Operating Constraint` ("Why the guard exists, stated honestly...not on any logged incident") and in the script's own header comment block ("NOT justified by an incident"). This is exactly the OP-11 pattern the principle calls for — not a violation.
- **DR-1/DR-3 (Placement).** The script lives at `.claude/hooks/`, the conventional location for a project-local hook (matches the `axcion-website` precedent, `boundary-leakage-check.sh`, at the same relative path). Correctly placed.
- Principles-base at `projects/strategic-os/ai-strategy/principles-base.md` was not re-read in full for this end-time pass (already consulted at plan-time, `decisions.md` #12/#15); the inline checks above, cross-referenced against the specific decisions-log rows they correspond to, are sufficient given the scope-line's narrow claim and that the design was simplified (not expanded) since the plan-time pass.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Not defect-justified — this change adds a preventive control for an irreversible risk (accidental commit of confidential case material into the reusable engine's git history), not a fix for an observed failure. `decisions.md` #15 states this explicitly: "no logged incident of a confidentiality-boundary breach in this project exists." Risk: Low per the reviewer rubric's own rule for non-defect-justified changes.
- **Consequence — traced or assumed?** N/A — no defect claim to trace.
- **Re-derivation vs. the change description:** The scope line's claim of "zero pre-existing external consumers" was independently re-derived via the Consumer Inventory grep above (1 hit, a documentation reference, 0 must-change) — confirmed, not merely accepted. The scope line's claim that the hook is "blocking" and "--no-verify-escapable" was independently re-derived by executing the installed hook end-to-end in the real target repo: a staged fixture carrying `**Confidentiality:** Restricted` caused `git commit` to abort with exit 1 and the block message; the identical commit retried with `git commit --no-verify` succeeded (exit 0). Both throwaway commits used for this end-to-end test were fully erased afterward (`git update-ref -d refs/heads/main`, `git read-tree --empty`) before this report was written, confirmed by `git log --oneline` reporting no commits and `git status --short` showing no residual scratch files. None of the change description's claims were contradicted by re-derivation.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references read from the actually-built files, `diff`/`grep -c` command output reproduced in this session, and a live end-to-end `git commit` / `git commit --no-verify` execution against the installed hook in the target repo. No training-data fallback was used on any read or search failure. The Dimension 3/5 consumer-inventory grep was re-run in the explicit `command grep -r <term> /abs/path` form after the `search-canary.sh` instrument check reported the dot-rooted form blind, per Step 1.5's instrument-check requirement.
