# Risk Check — 2026-06-27

## Change

Proposed structural change: create a new shared Obsidian CRM vault at workspace-root `knowledge-base/crm-vault/` (sibling to `pe-kb-vault`), containing a new vault-scoped `CLAUDE.md` (~15 lines, new always-loaded content that loads when a session operates in the vault), an entity schema + linking-convention reference doc, a Dataview-enabled `.obsidian/` config, an entity-per-folder layout (people/firms/deals/funds/_templates/00-meta), and two `status: scratch` fabricated example records used only for schema validation. This is W1 of the Client-Comms Knowledge System MVP (Block A), built from an approved plan + tech-spec. No existing files are modified in W1 (the IC-suite rewire, the new `/profile-gen` command, the cross-project symlink, and the settings.json/CLAUDE.md edits are all later work units W3/W4, NOT part of this change). Scope of THIS risk-check: the new vault + its always-loaded CLAUDE.md only. Evaluate before commit.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/knowledge-base/crm-vault/CLAUDE.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/knowledge-base/crm-vault/00-meta/entity-schema.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/knowledge-base/crm-vault/00-meta/linking-convention.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/knowledge-base/crm-vault/people/_example-schema-validation.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/knowledge-base/crm-vault/firms/_example-firm.md — exists

## Verdict

GO

**Summary:** A self-contained, additive new vault with a project/vault-local CLAUDE.md, zero existing-file edits, zero current operational consumers, and a clean sibling precedent (`pe-kb-vault`) — the only notable nuance is that rollback lives in the separate `knowledge-base` git repo, not the main repo, and that nuance is Low/Medium at worst.

## Consumer Inventory

Search terms derived from referenced basenames and contract markers: `crm-vault`, `profile-gen`, `entity-schema`, `linking-convention`. Grep run across the full repo and workspace (excluding `.git`, the vault itself, and this risk-checks dir).

**No operational consumer found.** Every hit for `crm-vault` / `profile-gen` / `entity-schema` / `linking-convention` outside the vault is a **planning or log document**, not a live component. No `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `skills/`, `settings*.json`, or any `CLAUDE.md` references the vault, the `/profile-gen` token, or the schema contract. The IC suite in `projects/interpersonal-communication-copy/.claude/` returned **zero** hits for `crm-vault` or `profile-gen`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/interpersonal-communication-copy/logs/session-notes.md | documents (planning) | no |
| projects/interpersonal-communication-copy/logs/session-plan-2026-06-27-S1.md | documents (planning) | no |
| projects/project-planning/logs/decisions.md | documents (planning) | no |
| projects/project-planning/logs/session-notes.md | documents (planning) | no |
| projects/project-planning/logs/scratchpads/2026-06-26-13-58-scratchpad.md | documents (planning) | no |
| projects/project-planning/Project Plans/client-comms-knowledge-system/*.md (plan, tech-spec, context-packs, QC verdicts — 9 files) | documents (planning) | no |

Total: ~14 consumers, **0 must-change** — all are planning/log prose, none is an operational component. The new vault is the *producer* of a contract (`entity` frontmatter schema, `status` semantics, `[[wikilinks]]` slug convention, filter-then-read read-path); its **operational** consumers (`/ic-consult`, `/meeting-prep`, `interpersonal-consultant` skill, `/profile-gen`) do **not yet exist as wired references** — they are explicitly W3/W4, out of scope for this change. Per the change's own framing this is correct: the contract ships ahead of its consumers within an approved plan, and W1 wires nothing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new `CLAUDE.md` is **vault-scoped**, not workspace-root: it lives at `knowledge-base/crm-vault/CLAUDE.md` and loads only when a session's cwd is inside that vault. It does not add to the always-on workspace or IC-project CLAUDE.md (evidence: file is 17 lines / ~250 words; sibling precedent `knowledge-base/pe-kb-vault/CLAUDE.md` is the established pattern for per-vault CLAUDE.md).
- The "always-loaded" cost applies only inside CRM-vault sessions, which are a narrow, deliberate context (operator working the CRM) — not every session. No SessionStart/Stop/PreToolUse hook is registered by this change; the `.obsidian/` config is plugin metadata read by Obsidian, not by Claude per turn.
- No `@import` chain, no frequently-spawned subagent, no broad-trigger skill is added by W1. The `00-meta/` schema + linking docs are pay-as-read references (loaded only when authoring/consuming records), not always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- W1 makes **no settings.json change** — the change description explicitly defers all `settings.json`/CLAUDE.md edits to W3/W4 ("the settings.json/CLAUDE.md edits are all later work units"). No grep hit places `crm-vault` in any `settings*.json`.
- The change introduces no new tool-invocation pattern, no Bash/Write/external-API capability, no deny-rule removal, and no permission scope-escalation. It is file creation within an existing workspace-root directory (`knowledge-base/`) that already hosts a sibling vault.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: **0 must-change consumers.** The ~14 references are all planning/log prose; none is an operational component that breaks or needs editing when this vault lands.
- No existing file is modified by W1 (verified against the change description and the inventory — the IC rewire, `/profile-gen`, the symlink, and config edits are all W3/W4). The vault is created alongside `pe-kb-vault`, not on top of anything.
- The change *introduces* a contract (entity frontmatter schema, `status: provisional|confirmed|stub|scratch` consumer-filter semantics, `[[firms/slug]]` wikilink + slug rule, filter-then-read read-path). That contract has **no operational caller yet** — so there is nothing downstream to break. When W3/W4 wire the consumers, a contract change at *that* point would carry blast radius; W1 alone does not.
- Internal link integrity is self-contained and validated: `people/_example-schema-validation.md` → `[[firms/_example-firm]]` resolves to `firms/_example-firm.md`, which back-links `[[people/_example-schema-validation]]` (both `status: scratch`, ignored by future consumers).

### Dimension 4: Reversibility
**Risk:** Low

- `knowledge-base/` is its **own separate git repository** (it has its own `.git`, and a `.gitmodules` declaring `pe-kb-vault` as a submodule). `crm-vault/` is currently **untracked** there (`git status` in `knowledge-base` shows `?? crm-vault/`) and is **not** tracked by the main `Axcion AI Repo`. Implication: rollback is `rm -rf knowledge-base/crm-vault/` (or `git clean` in the `knowledge-base` repo) — a single-directory delete with no entanglement, since nothing else references it. This is cleaner than a `git revert`, not messier.
- W1 mutates **no append-only log or shared-state file** (the two `scratch` example records are deletable on sight; the schema/linking docs and CLAUDE.md are fresh files). No state propagates beyond the local repo — no push, no external write, no Notion sync (People records are explicitly local-markdown-only per the vault's GDPR rule).
- One minor nuance keeps this from being trivially zero-cost: the operator must roll back in the *correct* repo (`knowledge-base`, not the IC project or main repo). Because `crm-vault` is untracked and isolated, a stray `git revert` in the wrong repo is a no-op, not a corruption — so the nuance is informational, not a real reversibility hazard. Net: Low.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The single-vault constraint is **explicitly documented at the change site**, not implicit: `CLAUDE.md` line 11 ("Single vault. All four entity types live here so `[[wikilinks]]` + Dataview joins resolve. Never split them across vaults.") and `linking-convention.md` line 11 (load-bearing single-vault note). The Dataview-vs-filter-then-read two-layer contract is documented (`linking-convention.md` lines 16-22) and the programmatic path is stated to be **plugin-independent** — so the consumers do not silently depend on the Dataview plugin being installed.
- The tier framework is carried verbatim from the IC KB (`entity-schema.md` line 21 cites `knowledge-base/07-practice-layer → 00-meta/tier-framework.md`). This is a documented dependency on an existing convention, not a silent one; and W1 only *restates* the tiers in-vault, it does not depend on a live cross-vault read at W1 time.
- No auto-firing behavior, no hook ordering, no cross-session side effect. The documented broken-symlink / cross-user-path-skew history is explicitly tied to the **W4 cross-project symlink**, which is NOT part of this change — W1 creates no symlink (verified: vault tree contains only regular files and dirs, no symlinks).
- The IC-framework `Related:` cross-vault refs are explicitly flagged as possibly-non-resolving and told to live in prose, not hard joins (`linking-convention.md` line 37) — the one genuine cross-vault coupling risk is already called out and defused at the change site.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`) — checks below cite frozen IDs from it.
- **DR-1 / DR-3 (placement) — aligned.** A shared entity CRM that multiple surfaces will consume is correctly placed at the workspace-root `knowledge-base/` tier as a sibling to `pe-kb-vault`, mirroring the established vault precedent. It is a vault (data substrate), not a skill/command/agent miscast — right home, right tier.
- **OP-9 / DR-7 / AP-7 (speculative abstraction) — tension noted but not a violation.** The inventory shows the contract ships with **zero current operational consumers**, which is the canonical speculative-abstraction signal. Two facts keep this Low rather than Medium/High: (a) it is built from an **approved plan + tech-spec** with named, committed consumers (`/ic-consult`, `/meeting-prep`, `/profile-gen` in W3/W4) — i.e. the second consumer is *confirmed and scheduled*, not hypothetical "hooks for later"; and (b) W1 deliberately builds **only People to full depth** and keeps Firm/Deal/Fund as resolvable stubs, explicitly refusing to design them now (`entity-schema.md` line 12: "Do not design them to full depth now"). That restraint is DR-7 being honored, not violated. The data substrate must exist before its consumers can read it; creating it first is sequencing, not speculation.
- **OP-12 (closure before detection) — not engaged.** This change adds no detection/scan/finding-generator; it is a data substrate. N/A.
- **OP-5 (advisory vs enforcement) — aligned.** The vault's hard rule keeps behavioral notes **advisory and non-manipulative** (`CLAUDE.md` line 7; `entity-schema.md` line 22). Nothing here moves toward enforcement/auto-action.
- **OP-10 (system boundary) — aligned.** The vault is local Claude-Code-read markdown; it does not govern GPT/Perplexity/NotebookLM/Notion behavior. The GDPR local-only rule actively keeps records *out* of cloud/Notion sync, narrowing scope rather than expanding it.
- **OP-11 / OP-3 (loud revision) — N/A.** No principle is revised by this change.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from the five referenced files and the two sibling/principle docs, the git-tracking state of `knowledge-base/` and `crm-vault/` (`?? crm-vault/`, separate `.git` + `.gitmodules`), the vault file tree (`find`), and grep counts/classification across the repo and workspace for `crm-vault` / `profile-gen` / `entity-schema` / `linking-convention`. No training-data fallback was used.
