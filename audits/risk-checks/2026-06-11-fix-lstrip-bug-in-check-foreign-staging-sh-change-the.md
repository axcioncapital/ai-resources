# Risk Check — 2026-06-11

## Change

Fix lstrip("./") bug in check-foreign-staging.sh: change the Python footprint-token normalizer from `lstrip("./")` (which strips ALL leading dots and slashes — including the leading dot in .claude/ paths, making .claude/commands/*.md undeclarable as a footprint entry) to `re.sub(r'^\./', '', tok)` (strips only a ./ prefix, not a bare leading dot). This restores the ability to declare .claude/ files in the session footprint. File: ai-resources/.claude/hooks/check-foreign-staging.sh, line 247 of the Python PYEOF block. One-line change in one file. The hook is a PreToolUse(Bash) guard used across all projects in this workspace.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A correct, low-cost bug fix to a single line of a user-level PreToolUse(Bash) guard that fires on every project, but it leaves an identical `lstrip("./")` bug untouched at line 284 — a sibling fix the operator must apply in the same pass or the `.claude/`-footprint defect persists on the `cd X && git add .` path.

## Consumer Inventory

Search terms: `check-foreign-staging` (basename), `foreign-staging` / `staging-tripwire` (contract markers), `lstrip` (the bug token), `Files in scope` (the footprint contract the hook parses). Searched across `ai-resources/` and the workspace root.

The hook is registered at **user level** — `~/.claude/settings.json:61` invokes it by absolute path for `matcher: "Bash"` under `PreToolUse`. It therefore fires for every project session in the workspace, not just `ai-resources`. The token normalizer at line 247 is internal to the hook; its real "consumers" are (a) the wiring point in settings, and (b) every session mandate that declares a `- Files in scope:` footprint containing a `.claude/` path — those footprints are the input the buggy line mis-parses.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/.claude/settings.json | invokes (PreToolUse Bash, absolute path, user level) | no |
| ai-resources/.claude/hooks/check-foreign-staging.sh L284 (`lstrip("./")` on `subdir`) | co-edits (identical bug, same `.claude/` failure mode) | yes (see Blast Radius) |
| ai-resources/docs/commit-discipline.md | documents (two-end contract registration) | no |
| ai-resources/docs/session-marker.md | documents (footprint/marker mechanics) | no |
| ai-resources/docs/parallel-sessions-playbook.md | documents | no |
| ai-resources/.claude/hooks/detect-concurrent-session.sh | documents (mirrors the live-foreign-session oracle; does not call this hook) | no |
| projects/*/.claude/hooks/detect-concurrent-session.sh (positioning-research, research-pe-regime-shift) | documents (sibling oracle copies; do not call this hook) | no |
| ai-resources/audits/2026-06-10-concurrent-session-coverage-audit.md + audits/risk-checks/* | documents (prior audit/risk-check records) | no |
| Every session mandate declaring `- Files in scope: .claude/...` (e.g. session-notes.md, session-plan-*.md) | parses (footprint input the buggy line normalizes) | no |

Total: 9 distinct consumer rows, 1 must-change (the L284 sibling). The producers of `.claude/`-path footprints are unbounded in count (any future session), which is why the fix matters — but none of them must change; they are the beneficiaries of the fix.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added; the change edits one line inside an existing `PYEOF` Python block — no net token addition to any CLAUDE.md or `@import` chain.
- The hook already runs per gated Bash call (it is an existing PreToolUse(Bash) guard, `~/.claude/settings.json:61`); this change does not add a new hook or change its firing frequency. The cheap gated-verb early exit at L97–98 is untouched, so non-git Bash calls still exit before any cost.
- `re.sub` vs `lstrip` is a negligible per-call cost difference, and `re` is already imported (L66).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched; no settings.json permission block edited. The change is confined to the hook script body.
- The hook reads only and writes nothing (L54 CONTRACT comment: "Reads only; writes nothing"); the fix does not introduce any new tool invocation, Write path, or external call.
- No scope/layer change — the hook stays registered exactly where it is (user level, absolute path).

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory: 9 rows, **1 must-change**. The driver is the **sibling `lstrip("./")` at line 284** (`subdir = mcd.group(1)...lstrip("./").rstrip("/")`), which normalizes the subdir token on the `cd X && git add .` path. It has the *identical* defect: a `.claude/`-rooted subdir (`cd .claude && git add .`) loses its leading dot and will mis-scope candidate matching. The change description targets only L247 and does not mention L284 — this gap is itself a blast-radius finding: fixing L247 alone leaves the `.claude/` footprint defect live on the subdir-add path.
- Single file touched directly; the only `invokes` consumer (`~/.claude/settings.json`) is unaffected by a body-internal edit and does not need modification.
- No contract change: the `- Files in scope:` footprint format the hook parses is unchanged, and the exit-code contract (exit 0 / exit 2) is unchanged. Backwards-compatible — footprints that worked before still work; `.claude/` footprints that silently failed now match.
- Shared infra: the hook is shared across all projects (user-level wiring), so the *benefit* propagates workspace-wide; but the edit itself is isolated to one file. The doc/audit references are read-only records and do not need updating for the fix to work.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file, single-line (or two-line if L284 is included) source edit. `git revert` in the `ai-resources` repo fully restores prior state — no sibling files created, no directory added.
- No data/log mutation: the hook writes nothing, so there is no append-only log entry or stale state to clean up after a revert.
- No state propagates beyond git: no push (push is gated to wrap), no external write, no settings cache. The hook is re-read from disk on each invocation, so a revert takes effect on the next gated Bash call with no restart needed.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Implicit dependency on the **footprint declaration convention** (`- Files in scope:` bullets containing repo-root-relative paths). The fix is correct *because* git emits `.claude/commands/x.md` (with leading dot) and footprints are declared the same way; `lstrip("./")` desynced the two. This convention is documented (`docs/session-marker.md`, `docs/commit-discipline.md`), so the coupling is established and named, not silent — but the fix's correctness hinges on it.
- **Functional-overlap / duplicated-logic coupling:** the same normalization idiom (`...lstrip("./").rstrip("/")`) appears at L247 (footprint tokens) *and* L284 (subdir token). They are two copies of one normalization rule. Fixing one without the other leaves the two paths inconsistent — the classic "two systems handle the same concern, now divergently" hazard. This is the main reason the dimension is Medium rather than Low.
- `re.sub(r'^\./', '', tok)` strips only a literal `./` prefix. Note one behavior change vs `lstrip("./")`: `lstrip` also removed any trailing-of-leading mix like `.//` or a bare leading `/` (absolute-ish token). Footprints are conventionally repo-root-relative without a leading slash, so this is the intended narrowing — but if any existing footprint was written with a bare leading `.` or `/` it would now normalize differently. No such footprint was found in the searched session-notes/plans, so the risk is latent, not active.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active). The change is a defect repair on an existing, in-use guard — it does not generalize, add a hook, or build for an absent consumer, so **OP-9 / AP-7 / DR-7** (speculative abstraction) are not engaged.
- **OP-12 (closure before detection):** the change adds no new detection; it *fixes* an existing detector that was failing to recognize legitimately-declared `.claude/` files. It improves closure of an existing channel rather than adding ungated detection — aligned, counts for the change.
- **OP-5 (advisory vs enforcement):** unchanged. The hook stays an advisory tripwire (exit 2 → model-facing stderr, no operator permission prompt; L14–18). No silent enforcement upgrade.
- **OP-11 (loud revision):** no principle is being revised; nothing to record as a deliberate evolution.
- **DR-8:** this risk-check at plan-time is the gate DR-8 requires for a hook change — the change is following the gate, not bypassing it.

## Mitigations

- **Dimension 3 / Dimension 5 (must-fix sibling):** In the same edit pass, apply the identical fix to line 284 — replace `lstrip("./")` with `re.sub(r'^\./', '', ...)` for the `subdir` token — so the `cd X && git add .` path normalizes `.claude/`-rooted subdirs correctly. Leaving L284 on `lstrip` keeps the original defect live on the subdir-add path and leaves two copies of the normalizer divergent. (Optional structural improvement, per the workspace "structural fix as default" rule: factor the normalization into one small helper, e.g. `def _norm_tok(t): return re.sub(r'^\./', '', t.strip().strip('`').strip()).rstrip('/')`, and call it from both L247 and L284 so the rule cannot drift again — but a paired two-line fix is acceptable if the helper is out of scope.)
- **Dimension 5 (verify the narrowing is intended):** Before landing, confirm no existing session footprint relies on the old broad `lstrip` behavior (bare leading `.` or `/` in a `- Files in scope:` path). A repo-wide grep of `session-notes.md` / `session-plan-*.md` for footprint paths starting with `.` (other than `.claude`) or `/` is sufficient; none were found in the searched set, so this is a confirmatory check, not a blocker.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Concur — PROCEED-WITH-CAUTION, both-sites fix.** We concur on both the verdict and the path.

**Verdict (concur).** This is a hook edit, a gated change class regardless of size (DR-8; risk-topology.md § 3 — fires on every project's `PreToolUse(Bash)`). That blast radius keeps it above GO. It is not RECONSIDER-shaped: a narrow, reversible correction of a clearly-wrong normalizer, not a redesign.

**Path (concur).** Fix L247 and L284 in the same pass. A guard correct on `git add <file>` but broken on `cd X && git add .` is *input-dependent-wrong* — harder to trust and debug than uniformly wrong. Both move together or the divergence (Dimension 5, correctly flagged) persists.

**Risk the dimension review missed:** `lstrip("./")` is a **character-class strip, not a prefix strip** — it removes any leading run of `.` and `/` in any order, so the defect is wider than "dot-stripping `.claude/` paths." `../sibling/x` → `sibling/x`, `/abs/path` → `abs/path` are also silently mangled (OP-3 — name the real defect, not one symptom). This *strengthens* the fix and confirms `re.sub(r'^\./', '', tok)` is the correct replacement (strips exactly one literal `./`).

**Four additions before commit:**
1. Fix-or-confirm-absent the project-local copy at `projects/positioning-research/.claude/hooks/` — same divergence risk across files.
2. Verify the **git-side** of the comparison normalizes with the same `^\./` rule (two-end contract, risk-topology.md § 5) — fixing only the footprint side can shift the mismatch, not close it.
3. Confirm `re` is imported — a `NameError` on a PreToolUse guard is a per-session regression.
4. Log the normalizer **de-duplication** (single `normalize_footprint_token()` helper) as a *separate* structural follow-up — do not bundle a refactor through a one-line risk-check'd fix (DR-7, OP-9 paired constraint).

**Independent QC is mandatory before commit** (DR-8, QS-1). The QS-2(b) line-count skip does **not** apply — the skip requires "correct form validated elsewhere in the repo," and the correct regex is not yet validated anywhere.

_Full advisory: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-11-fix-lstrip-dot-bug-check-foreign-staging.md_

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the hook source (L247 bug site, L284 sibling bug, L54 read-only contract, L66 `re` already imported, L97–98 early exit, L14–18 advisory authority), the user-level wiring at `~/.claude/settings.json:61`, the principles-base frozen-ID index, and grep counts across `ai-resources/` and the workspace root. No training-data fallback was used.
