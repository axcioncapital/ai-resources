# Risk Check — 2026-06-16

## Change

OP-0 blocking gate for the axcion-website /new-project Stage 4 implementation. Evaluate the project's harness layer going live BEFORE it is installed. The structural change is three coupled additions, all under projects/axcion-website/:

(1) A new project-local commit-time boundary-leakage hook at projects/axcion-website/.claude/hooks/boundary-leakage-check.sh, registered as a PreToolUse hook — it rejects commits that import a `source-of-truth/` path into built website source, enforces manifest `allowed_sources` coverage, and scans against a prohibited-language register.
(2) A new project settings.json at projects/axcion-website/.claude/settings.json derived from ai-resources/templates/project-settings.json.template — permissive allow-list with `defaultMode: bypassPermissions`, the two standard SessionStart hooks, and the boundary hook registered as PreToolUse.
(3) Three `--add-dir` mounts of upstream projects for read-by-reference (no copy): projects/marketing-positioning/, projects/corporate-identity/, projects/axcion-brand-book/.

The spec (implementation-spec.md OP-0) requires confirming three specific things, which you MUST address explicitly in the report (under the Permissions and Blast-radius dimensions, and call them out by letter):
(a) the three mounts grant READ access only to the three named upstream projects and do not widen WRITE scope into them;
(b) `defaultMode: bypassPermissions` combined with the mounts does not create a path by which this execution session can WRITE into marketing-positioning/, corporate-identity/, or axcion-brand-book/;
(c) the boundary-leakage hook itself is not bypassable by the permission mode (a PreToolUse hook fires regardless of permission allow/deny).

Scope boundary (AD-1): zero ai-resources/ or workspace-level changes; all paths are project-local. PC-1 resolved as nested-git-repo.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/hooks/boundary-leakage-check.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/settings.json — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-settings.json.template — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/implementation-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The harness layer is correctly scoped as project-local and the boundary hook design is sound, but confirmations (a) and (b) do NOT hold as written — `--add-dir` is a read-write working-directory mount, so `defaultMode: bypassPermissions` + the `Write`/`Edit`/`Bash(*)` allow-list opens an unintended write path into the three upstream projects, which is mitigable by hardening the settings.json deny-list before the mounts go live.

## Consumer Inventory

Search terms: `boundary-leakage-check`, `boundary-leakage`, `axcion-website/.claude/settings.json`, the three mount basenames (`marketing-positioning`, `corporate-identity`, `axcion-brand-book`), and the contract markers `--add-dir` / `bypassPermissions` / `source-of-truth/`. Both new files are `not yet present`, so their *file* consumers are zero; the inventory below covers the **contracts** they introduce (the `boundary-leakage-check.sh` path token, the settings.json mount + hook registration) and the upstream projects the mounts target.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-website/pipeline/architecture.md | documents (§2.2, §2.3, §3 mod table, AD-1, AD-2, AD-5 reference the hook path, settings.json, and the three mounts) | no |
| projects/axcion-website/pipeline/implementation-spec.md | documents (OP-0/OP-2/OP-3 name the hook path, settings.json, and mounts; OP-2 registers the hook as PreToolUse) | no |
| projects/axcion-website/pipeline/project-plan.md | documents (W0.4/W0.6 scaffold + extend the hook; §5 gap-analysis item 5; §6 sufficiency criteria reference the hook path) | no |
| projects/axcion-website/pipeline/technical-spec-content-model-and-boundary.md | parses + documents (§7.8 owns the boundary contract the hook enforces; §4.2 tree names the hook; the manifest + import rule the hook reads) | no |
| projects/axcion-website/pipeline/technical-spec-lead-intake-and-reliability.md | documents (§10.4 names hook as harness-owned; §10.x unmanifested-route flagging relies on hook) | no |
| projects/axcion-website/pipeline/technical-spec-design-system.md | documents (§10.2 names hook + settings.json as harness-owned) | no |
| ai-resources/templates/project-settings.json.template | imports (settings.json is *derived from* this template via jq-merge; the template is the source of `defaultMode: bypassPermissions` + allow-list + 2 SessionStart hooks) | no |
| ai-resources/templates/README.md | documents (consumer contract: `/new-project`, `/deploy-workflow` consume the template; jq-merge gated on non-empty `.permissions.allow`) | no |
| projects/marketing-positioning/ (nested git repo, own .claude/ + .gitignore) | co-edits (mount TARGET — read-by-reference intent; verified as a write-reachable target under the proposed settings) | no |
| projects/corporate-identity/ (nested git repo, own .claude/ + .gitignore) | co-edits (mount TARGET — same) | no |
| projects/axcion-brand-book/ (nested git repo, own .claude/ + .gitignore) | co-edits (mount TARGET — same) | no |

Total: 11 consumers, 0 must-change. The hook + settings.json files are new (no file-level consumers). The pipeline docs are documentation references that already describe the intended state — none requires modification for the change to work. The three mount targets are runtime read-access targets, not files that change. **Blast-radius caveat:** the three mount targets appear in the inventory under `co-edits` not because the change intends to edit them, but because the permission analysis (below) finds them *write-reachable* — an inventory finding the CHANGE_DESCRIPTION's "read-by-reference (no copy)" framing did not anticipate.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change adds zero content to any always-loaded CLAUDE.md — AD-1 / decisions.md #3 confirm "zero ai-resources/ or workspace-level changes; all paths are project-local" (decisions.md:7). The project CLAUDE.md extension (OP-1) is a separate operation, not part of this OP-0 gate.
- The settings.json registers two SessionStart hooks — but both are inherited verbatim from the template (`auto-sync-shared`, `check-permission-sanity.sh`), already running in every project session (project-settings.json.template:33–53). No new per-session cost beyond the existing baseline.
- The boundary hook is a PreToolUse hook, but it matches only `Bash(git commit ...)`-class calls touching `apps/website/src/` (architecture.md:66) — it fires at commit time, not on every tool call, so per-tool-call cost is negligible (commits are infrequent relative to reads/edits).
- The three `--add-dir` mounts add directory-tree visibility at session start; they do not auto-load file content into context (content is read by reference on demand — architecture.md:147 "read at content-author / token-derivation time, never copied"). No `@import` chain introduced.

### Dimension 2: Permissions Surface
**Risk:** High

- **The settings.json template is broadly permissive and is the source for this project's settings.** project-settings.json.template:3–21 declares `defaultMode: bypassPermissions` plus `allow: ["Bash(*)", "Read", "Edit", "Write", "MultiEdit", ..., "Edit(**/.claude/**)", "Write(**/.claude/**)", "Bash(rm *)"]`. This is the established repo-normal posture (Memory: "Repo intentionally permissive; safety via git/risk-check/audits, not prompts"), and all three mount targets already run `bypassPermissions` themselves (verified: `grep defaultMode` on each of the three projects' settings.json returns `bypassPermissions`). So the *mode itself* is not new.
- **Confirmation (c) — HOLDS.** A PreToolUse hook in Claude Code fires on the matched tool call regardless of the permission decision. `bypassPermissions` auto-*allows* tool calls; it does not *skip hook execution*. The hook is registered in settings.json `hooks.PreToolUse` (OP-2, implementation-spec.md:93) and runs as a gate on the matched `git commit` call before the call proceeds. A commit cannot route around the hook by virtue of the permission mode. PreToolUse hooks in settings.json are an established repo pattern (verified: present in `ai-resources/.claude/settings.json`, `research-workflow`, and three other project settings). **(c) is satisfied.**
- **Confirmation (a) — DOES NOT HOLD.** `--add-dir` is a Claude Code session-launch *working-directory addition*, not a read-only mount. A directory added via `--add-dir` becomes part of the session's writable working set: the same `Read` / `Edit` / `Write` / `Bash(*)` permissions that apply to the project root apply to the added directory. Claude Code has no read-only variant of `--add-dir`. Therefore the three mounts grant **read AND write** reachability into `marketing-positioning/`, `corporate-identity/`, and `axcion-brand-book/` — not read-only as (a) asserts. **(a) fails as written.**
- **Confirmation (b) — DOES NOT HOLD.** Combine (a) with `defaultMode: bypassPermissions` + the `Write` / `Edit` / `Write(**/.claude/**)` / `Bash(*)` / `Bash(rm *)` allow entries (template lines 5–21): the execution session can `Write`, `Edit`, or `Bash`-mutate any file under the three upstream projects with zero permission prompt. Nothing in the template's `deny` list (project-settings.json.template:23–30) scopes writes away from the mounted dirs — the deny entries cover `Bash(rm -rf *)`, `Bash(sudo *)`, and four archive/deprecated *Read* globs only. The boundary-leakage hook (c) does NOT close this: it matches commits in the *website* repo touching `apps/website/src/`, and does not guard `Write`/`Edit`/`Bash` into the upstream projects at all. **(b) fails — there is an unintended write path into the three upstream projects.** This is the High driver and, per the OP-0 brief, drives the verdict away from GO.
- Mitigating context (does not downgrade the finding, but bounds it): the three targets are independent nested git repos with their own `.git` (verified). An unintended write would land in a separate repo's working tree and surface in *that* repo's `git status` — recoverable, not silently propagated into the website repo. The risk is an accidental cross-project mutation during the build session, not a permanent capability escalation of the workspace.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Consumer count (from Step 1.5 inventory): 11 consumers, 0 must-change.** No pipeline doc or template requires modification for the change to function — the six pipeline docs already *describe* the intended end-state (the hook path, the mounts, the settings derivation), so landing the change makes the docs accurate rather than stale.
- **Contract introduced — boundary-hook parse contract.** The hook reads two contracts at commit time: `source-of-truth/manifest.yaml` (`allowed_sources` coverage) and `messaging/prohibited-language.yaml` (architecture.md:66). These files are scaffolded by OP-11 / OP-25 (implementation-spec.md:184, 318) — at W0.4 the manifest is empty and the hook scaffold exits 0 on empty content (implementation-spec.md:103). The contract is backwards-compatible by construction (empty-tree passes). Cross-referencing the `parses` row: technical-spec-content-model-and-boundary.md §7.8 owns this contract and names the hook as its enforcer — the dependency is documented at the change site, not implicit.
- **(a)/(b) blast-radius callout (per OP-0 brief):** the permission finding (Dimension 2) means the change's blast radius is **wider than the CHANGE_DESCRIPTION states** — "read-by-reference (no copy)" implies the three upstream projects are read-only consumers, but the inventory + permission analysis show them as *write-reachable* targets. This is a blast-radius gap the change description did not anticipate (flagged in the inventory caveat). It does not raise the count of files that *must* change, but it widens the set of state the session can *touch* from one project to four.
- **Shared infrastructure:** the change consumes (does not modify) `ai-resources/templates/project-settings.json.template` via jq-merge. The template-consumer contract (templates/README.md:18–35) is honored — deriving a project settings.json from the template is exactly consumer #1 (`/new-project`) and consumer #2 (`/deploy-workflow`) behavior; no template mutation occurs. No workspace shared infra is written (AD-1).
- Medium rather than Low because the effective state-touch surface spans four nested repos (website + three mounts), even though must-change count is 0.

### Dimension 4: Reversibility
**Risk:** Low

- The two new files (`settings.json`, `boundary-leakage-check.sh`) are sibling-file creations under `projects/axcion-website/.claude/`. PC-1 is resolved as nested-git-repo, so once the website repo exists these are tracked files a `git revert` / file delete removes cleanly within that repo's tree.
- No append-only log mutation is part of this OP-0 gate. OP-0 itself writes no file (implementation-spec.md:70 "governance gate (no file written by this op)"); the verdict is recorded in `pipeline/decisions.md` or `logs/decisions.md` (implementation-spec.md:74) — a single decision-row append, trivially reversible.
- The `--add-dir` mounts live in settings.json; removing the three entries (or deleting settings.json) fully revokes the mount. No state propagates beyond the local working trees — no push, no external API write, no Notion write is part of this gate.
- Minor caveat (keeps it Low, not zero-cost): the boundary hook is automation that fires between landing and any revert. But it is *advisory-by-rejection* (it blocks bad commits, takes no autonomous mutating action), so a hook firing during the window cannot create state that a revert must then unwind.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency — hook install path under nested-repo resolution.** PC-1 (implementation-spec.md:48) notes that if the execution repo is a nested git repo, "the boundary-leakage hook (OP-3) installs into the *execution repo's* `.git/hooks/` via the `.claude/hooks/` source; confirm hook reachability before relying on it." The CHANGE_DESCRIPTION states PC-1 is resolved as nested-git-repo, but the website project is **not yet a git repo** (verified: no `.git` under `projects/axcion-website`; it is created at W0.4). The hook's effectiveness is coupled to (i) the W0.4 `git init` happening and (ii) the PreToolUse-hook-in-settings.json mechanism actually intercepting `git commit` — two distinct enforcement surfaces (a Claude Code PreToolUse hook vs. a git `.git/hooks/pre-commit`) that the docs use somewhat interchangeably. This coupling is documented (PC-1) so it is not silent, but it is load-bearing and unverified at gate time.
- **Functional-overlap check — none harmful.** The boundary hook (commit-time, PreToolUse) and the build-time manifest/import checks in `validate.sh` (architecture.md:72, AD-2) both enforce the boundary, but this is *intentional defense-in-depth* (AD-2: commit-time enforcement, not build-time-only), not an accidental two-systems-fighting overlap. Documented at the change site.
- **Coupling driving (b):** the unintended write path (Dimension 2) is itself a hidden coupling — `--add-dir`'s write semantics are not visible from the settings.json `permissions` block alone; an operator reading the allow-list would not see "and also any mounted dir." This is the implicit-dependency-on-an-undocumented-runtime-behavior pattern. It pushes this dimension to Medium and reinforces the Dimension 2 High.
- Medium rather than High because each coupling is either documented (PC-1, AD-2) or already surfaced under another dimension; none is a silent auto-fire creating unexpected mutation.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active). Inline checks applied against it.
- **DR-1 / DR-3 (placement) — ALIGNED.** All three additions are project-local under `projects/axcion-website/`, the correct tier for single-project resources. AD-1 (decisions.md #3) explicitly *rejects* promoting the hook/scripts to `ai-resources/`: "promoting hook/scripts to shared ai-resources tooling is premature before a second web project exists" (decisions.md:7). The change places resources in the right tier and right home (hook under `.claude/hooks/`, settings under `.claude/`).
- **DR-7 / AP-7 / OP-9 (speculative abstraction) — ALIGNED, actively served.** The Step 1.5 inventory shows the contract has a *present, confirmed consumer* (the website build itself, W0.4 onward) — not an absent Phase-2 consumer. AD-1 explicitly refuses to generalize before a second consumer exists. This is the textbook *correct* application of DR-7, not a violation.
- **OP-12 (closure before detection) — ALIGNED.** The boundary-leakage hook is new *detection*, but it ships *with* its closure channel: rejection at commit time (non-zero exit blocks the commit — implementation-spec.md:104). It does not generate findings into a backlog that nothing closes; the finding *is* the rejection. Detection ships behind a working closure channel, exactly as OP-12 requires.
- **OP-5 (advisory vs enforcement) — note, not a violation.** The hook is genuinely an *enforcement* mechanism (it auto-rejects, does not merely advise-and-stop). But this is a deliberate, recorded per-component decision: AD-2 (decisions.md:8, "commit-time enforcement, not via author discipline") makes the enforcement authority explicit and operator-confirmed. OP-5 requires enforcement to be an explicit per-component decision — it is. Not a silent upgrade.
- **DR-8 — ALIGNED.** This very OP-0 gate IS the required `/risk-check` for a gated structural change class (new hook + permissions + new settings). The change is following the principle, not violating it.
- **OP-10 (system boundary) — clear.** The three mounts read Axcíon Claude Code project repos (all inside the Claude Code system boundary); no cross-tool (GPT/Perplexity/Notion) coordination is introduced. No boundary expansion.

## Mitigations

- **Dimension 2 (High) — close the unintended write path before OP-2 lands the mounts.** Before the settings.json goes live, add explicit deny rules that scope writes away from the three mounted upstream projects, e.g. `"Write(**/projects/marketing-positioning/**)"`, `"Edit(**/projects/marketing-positioning/**)"` (and the two siblings), and a `Bash` guard if feasible — so that even under `defaultMode: bypassPermissions` the session cannot mutate the upstream repos. `deny` rules take precedence over `allow` in Claude Code, so this closes (b) while preserving the read-by-reference intent of (a). Verify by attempting a `Write` to a path under each mounted project and confirming it is denied. This reduces Dimension 2 to Low and makes confirmations (a)/(b) hold as the spec intends. **Record the deny-list addition in `pipeline/decisions.md` as the OP-0 runtime mitigation (implementation-spec.md:74).**
- **Dimension 2 / 5 supporting — verify (c) empirically at Gate 1, not by inspection alone.** Run the W0.6 acceptance test early in scaffold form: a test `git commit` that stages a `source-of-truth/` path into `apps/website/src/` must be REJECTED (non-zero exit) under `bypassPermissions`. This confirms the PreToolUse-hook-fires-regardless-of-permission-mode property holds in *this* settings.json, closing any residual doubt on (c).
- **Dimension 5 (Medium) — confirm hook reachability after the W0.4 `git init`.** Because the website repo does not yet exist as a git repo, verify after W0.4 that the boundary hook actually intercepts `git commit` (whether via the settings.json PreToolUse registration or a `.git/hooks/pre-commit` install per PC-1) before any commit that could carry a boundary leak. Do not rely on the hook until this reachability check passes (PC-1, implementation-spec.md:48).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the four read pipeline/template files, verbatim quotes from the settings template and decisions.md, grep counts and filesystem checks confirming nested-git status and `bypassPermissions` parity across the three mount targets, and principle IDs from `principles-base.md`). The two referenced files tagged `not yet present` (`settings.json`, `boundary-leakage-check.sh`) were NOT read; their evaluation is based on the described intent in CHANGE_DESCRIPTION and the design in architecture.md / implementation-spec.md, noted where load-bearing (Dimensions 2, 5). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory on disk: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-16-op-0-axcion-website-harness.md_

**Routing:** All three additions are project-local under `projects/axcion-website/.claude/` — correct tier (`principles.md § DR-1/§ DR-3`; AD-1 refuses ai-resources promotion, textbook `§ DR-7`). settings.json derived from the canonical template via jq-merge, no shared-infra write (`system-doc.md § 4.4`). Routing is not where the load is.

**Concur with PROCEED-WITH-CAUTION — yes.** `--add-dir` is a read-write mount; `bypassPermissions` + `Bash(*)`/`Write`/`Edit` allow opens an unintended write path into the three upstream repos. (c) holds; (a)/(b) do not, as written. Grounded in the actual template (`project-settings.json.template:3–30`).

**Do NOT concur with the mitigation as written.** The risk the six-dimension review under-sized: **a `Write`/`Edit` deny-list does NOT constrain `Bash(*)`.** The workspace's own `permission-template.md` confirms the deny floor is `rm -rf`/`sudo` only and `Bash(*)` covers arbitrary shell — so a heredoc/redirect/`cp`/`git -C` writes into a mounted repo through the `Bash` allow the deny never touches. The review flagged "a `Bash` guard if feasible" but that is the majority of the write surface, not an optional extra. And a `Bash`-path deny under `bypassPermissions` fights the intentionally-permissive posture head-on (Memory: safety via git/risk-check/audits, not prompts) — you cannot get reliable read-only out of deny + `bypassPermissions` + `Bash(*)`.

**The cleaner primitive: do not mount.** The three upstream projects already live under the same `projects/` parent; a workspace-path read reaches them with zero new write surface. The citation convention already mandates workspace paths, not mount paths (`architecture.md §4.4`), so the mounts are redundant for read and harmful for write. **Drop the `--add-dir` entries** — this dissolves (a)/(b) at the source. Fallback only if the build runs as an isolated nested repo with no workspace read path: a checkpoint-refreshed project-local `inputs/` snapshot (flag the "never copied" §10 tension — operator decides).

**Recommended path:** (1) drop the mounts, read by workspace path; (2) verify the launch context has workspace root on its read path; (3) empirically verify (c); (4) pin the hook's actual mechanism — PreToolUse-in-settings.json vs `.git/hooks/pre-commit` are not equivalent and the docs use them interchangeably (`principles.md § OP-3` — silent ambiguity), confirm interception after W0.4 `git init`; (5) harden the `Bash` path only if mounts are retained against this advice. Note: the boundary hook closes none of the (b) exposure — orthogonal problem; don't let its soundness create false comfort about the mounts.

**Verdict-vs-second-opinion reconciliation:** the System Owner CONCURS with the PROCEED-WITH-CAUTION verdict token but DISAGREES with the report's recommended mitigation (deny-list hardening). The cheaper, structurally cleaner resolution is to drop the three `--add-dir` mounts entirely and read the upstream projects by workspace path. This disagreement is surfaced to the operator per `/risk-check` Step 17e — the risk-check does not auto-resolve it.
