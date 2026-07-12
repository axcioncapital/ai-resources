# Risk Check — 2026-07-06

## Change

Phase C of the workflow-viability fix plan, audit lean-repo-2026-07-05-playbook-fit.md §8: go Claude-only on the .codex mirror, completing a 2026-07-02 operator decision (logs/decisions.md:137: "The Codex mirror is de-scoped — edit only .claude/") that a later session (commit 5204f4d, 2026-07-05) accidentally reversed by re-syncing .codex/agents/*.toml and rewriting AGENTS.md to say "change one, change the other" — without recording that as a policy reversal. Operator has now explicitly confirmed Claude-only as the direction. Concrete edits: (1) DELETE .codex/agents/*.toml (4 files: brand-guardian.toml, implementation-bridge.toml, layout-architect.toml, visual-red-team.toml) — untracked mirror content, the 4 canonical .claude/agents/*.md files are untouched. (2) Rewrite AGENTS.md's "Codex-native agents" section to remove "change one, change the other" and instead instruct a Codex agent to read .claude/agents/*.md directly (same read-and-substitute pattern AGENTS.md already uses for CLAUDE.md) — no second copy to sync. (3) Add a new logs/decisions.md entry recording that the 2026-07-02 de-scope decision is now actually executed, and naming the 2026-07-05 5204f4d commit as undocumented drift that is now corrected. (4) Correct a factual error in logs/improvement-log.md:21, which claims a ".agents/skills/visual-design-spec/SKILL.md" duplicate exists — verified false, .agents/ does not exist anywhere in this repo; add a one-line factual correction, leaving the rest of that (unrelated, already-parked) improvement-log entry about conversion-critic promotion untouched. (5) Add one fencing line to .claude/skills/visual-design-spec/SKILL.md stating the 4-critic chain is a whole-surface/new-surface/departure-only pass, never a per-section default (CLAUDE.md already states this in its Section Design Sessions "Chain fit" clause, so no CLAUDE.md edit is needed or planned). Explicitly NOT touched: the 4 canonical .claude/agents/*.md files; the four-role critic count/shape (CLOSED contract per pipeline/architecture.md DD-A4); any of the ~10 files listed in improvement-log.md's conversion-critic-promotion entry (out of scope, unrelated deferred item).

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.codex/agents/brand-guardian.toml`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.codex/agents/implementation-bridge.toml`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.codex/agents/layout-architect.toml`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.codex/agents/visual-red-team.toml`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/AGENTS.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/decisions.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/improvement-log.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md`

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The change is well-isolated and correctly aligned with OP-10/OP-11, but it contains one factual error (the .codex mirror is git-tracked, not "untracked," as of commit `5204f4d`) and one procedural violation (editing `improvement-log.md:21` in place, inside an ordinary work session, breaches this repo's own "in-place mutations belong to dedicated single-purpose sessions" rule) — both are cheaply fixable before landing.

## Consumer Inventory

| Item | Consumer | Type | Must change? | Evidence |
|---|---|---|---|---|
| `.codex/agents/*.toml` (4 files) | `AGENTS.md` §"Codex-native agents" | Live prose reference | Yes — rewritten by this change | `AGENTS.md:19-22` |
| `.codex/agents/*.toml` | Programmatic consumer (script/hook/settings) | — | **None found** | `grep` across `.claude/hooks/`, all `settings*.json`, and the impeccable skill's `pin.mjs`/`hook-admin.mjs` (which reference a *generic* `.codex/hooks.json` pattern in the unrelated `axcion-website` project, not this project's `.codex/agents/*.toml`) returned zero hits on the 4 toml filenames workspace-wide |
| `.codex/agents/*.toml` | Historical logs/audits: `logs/session-notes.md:270,408,416,420,423,449,455`; `logs/next-up.md:17`; `logs/decisions.md:137,141,237`; `logs/improvement-log.md:21`; `audits/lean-repo-2026-07-05-playbook-fit.md:9,15,36,88,134,185,202,206` | Historical record / already-recommended fix | No — these describe past state and the audit explicitly *recommends* this exact deletion (`audits/lean-repo-...:134`: "Delete `.codex/agents`; pick Claude-only; reconcile AGENTS.md + improvement-log:21") | quoted lines above |
| `.codex/agents/*.toml` | `pipeline/wireframe-stage-plan.md:88` | Prose, documents the de-scope | No — already says "Out of scope... NOT maintained... regenerable later if a real Codex port is ever a deliberate, recorded scope decision" — consistent with, not contradicted by, this change | `pipeline/wireframe-stage-plan.md:88` |
| `AGENTS.md` "change one, change the other" wording | `AGENTS.md` itself | Self | Yes — being rewritten | `AGENTS.md:22` |
| `AGENTS.md` wording | Logs citing the 3-way contradiction (`session-notes.md:428,455`; `next-up.md:17`; `lean-repo-...:15,88`) | Historical record | No — describe a now-resolved contradiction | quoted lines above |
| "No per-section critic pass" concept | `CLAUDE.md` § Section Design Sessions, "Chain fit" clause | Existing doctrine | No — rule already lives there ("there is no per-section critic pass") | project `CLAUDE.md`, confirmed verbatim |
| "No per-section critic pass" concept | `.claude/skills/visual-design-spec/SKILL.md` | Target of the new fencing line | Yes — this change adds a restatement, not a new rule | change description item 5 |
| Canonical `.claude/agents/*.md` (4 files) | `visual-design-spec` skill dispatch (Step 1 / Step 2) | Live, load-bearing | No — untouched; confirmed to exist and operate independently of the `.codex` mirror | `.claude/agents/{brand-guardian,implementation-bridge,layout-architect,visual-red-team}.md` read directly; `SKILL.md` dispatch section names only these paths, never `.codex/` |
| `improvement-log.md:21` dual-harness-duplicate claim | `audits/lean-repo-2026-07-05-playbook-fit.md` (cites the claim and recommends correcting it) | Historical record recommending the fix | No — corrected per its own recommendation | quoted above |
| `logs/next-up.md:17` open checklist item | Describes this exact `.codex`/`AGENTS.md`/`improvement-log:21` contradiction as unresolved, tells a future session to "pick the policy... and reconcile" | Will go stale once this change lands | **Not addressed by the change scope** — minor completeness gap | `logs/next-up.md:17` |

**Total: ~11 consumer references found across 8 files; 2 must-change (AGENTS.md self-edit, SKILL.md target of the new line); 0 programmatic consumers of the `.toml` files; 1 stale-TODO follow-up (`next-up.md:17`) left outside the change's stated scope.**

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low
- `AGENTS.md` is the only file in this change plausibly always-loaded (by a Codex agent, on the same convention `CLAUDE.md` uses for Claude). This repo carries no Codex-side loader config to confirm that behavior directly — flagged as an unverified-from-repo assumption, not a training-data claim about Codex internals.
- Materiality is negligible regardless: the "Codex-native agents" section being rewritten is 6 lines (`AGENTS.md:19-24`); the replacement (pointing at `.claude/agents/*.md` directly, per the change description) is the same order of magnitude. No meaningful token-size delta either way.
- `logs/decisions.md` and `logs/improvement-log.md` are session logs, not always-loaded context files. `.claude/skills/visual-design-spec/SKILL.md` loads only when the skill is invoked (per its own frontmatter — model-invocation is description-triggered, not always-on).

### Dimension 2: Permissions Surface
**Risk:** Low
- No `settings.json`/`settings.local.json` file in this project references `.codex` or any of the 4 toml filenames (`grep` confirmed zero hits).
- No hook under `.claude/hooks/` (none exist in this project) or the `impeccable` skill's hook-admin scripts targets this project's `.codex/agents/` path — the only `.codex` hits in those scripts are a generic, unrelated harness-support pattern (`'.codex/hooks.json'`) in the separate `axcion-website` project.
- The 4-file deletion and the two doc edits (`AGENTS.md`, `SKILL.md`) touch no permission-governing file.

### Dimension 3: Blast Radius
**Risk:** Low
- **Deleting `.codex/agents/*.toml` is truly isolated.** No script, hook, or settings file in this project or workspace parses these files programmatically (Step 1.5 grep, confirmed above). The only consumers are prose: `AGENTS.md` (being rewritten in this same change) and historical logs/audits describing the contradiction this change resolves.
- **Rewriting `AGENTS.md`'s Codex-agent-loading instructions is behaviorally consistent**, not novel: `AGENTS.md` already carries a "Reading CLAUDE.md as a Codex agent" section instructing substitution ("Claude" → "you," skip Claude-only mechanics). Extending the same read-and-substitute pattern to `.claude/agents/*.md` is the same technique applied to a second file class, not an unproven new mechanism.
- The `visual-design-spec` skill and all 4 critic/creator agent dispatches read exclusively from `.claude/agents/*.md` (confirmed by reading `SKILL.md`'s dispatch contract and the 4 canonical agent files) — none reference `.codex/`. Deleting the mirror cannot break the live chain.
- `pipeline/wireframe-stage-plan.md:88` — the only `pipeline/*.md` file mentioning the `.codex` mirror — already treats it as out-of-scope/unmaintained; no pipeline doc has a hard dependency on `.codex/` existing.
- Minor gap (not blast radius from the edit itself, but a completeness note): `logs/next-up.md:17` carries an open checklist item describing this exact unresolved contradiction. The change description does not include striking or updating it, so it will read as a stale, already-completed TODO after this change lands.

### Dimension 4: Reversibility
**Risk:** Medium
- **Factual correction needed before landing:** the change description characterizes `.codex/agents/*.toml` as "untracked mirror content." This is **false as currently stated** — `git ls-files -- .codex/ AGENTS.md` confirms all 4 toml files and `AGENTS.md` are tracked, added in commit `5204f4d` ("fix(codex): reconcile Codex layer with Claude Code as single-source pointer," 2026-07-05). The "untracked" framing is stale language inherited from the *original* 2026-07-02 decision (`decisions.md:141`, written before these files existed in git) and was not re-verified against current repo state. Practical effect: reversibility is actually **better** than described (a straight `git revert`/`git checkout <prior-commit> -- .codex/ AGENTS.md` fully restores the pre-deletion state, since the files are tracked) — but the new `decisions.md` entry (item 3 of the change) must not repeat the "untracked" claim, or the decision record itself will carry a factual error into the permanent log.
- **`improvement-log.md:21` in-place edit is a discipline violation, not merely a convention nicety.** `logs/improvement-log.md:3` states "Append-only" in its own header. `ai-resources/docs/commit-discipline.md` § "Maintenance-owned in-place mutations" makes this concrete and load-bearing, not just descriptive: it names exactly three sanctioned in-place mutators for `improvement-log.md`/`friction-log.md` — `/friday-act` (status flips), `/resolve-improvement-log` (archiving), and `/fix-repo-issues` plan execution (which itself mandates a *fresh, dedicated* session) — and states the rule plainly: **"in-place mutations belong to dedicated single-purpose sessions, never to ordinary work... An ordinary work session appends only; it never reaches into an existing entry to change its status or move it out."** Item 4 of this change — editing an existing line inside an existing entry, during an ordinary multi-file Phase-C work session that is not one of the three sanctioned paths — falls outside that rule as written, regardless of how trivial the correction is. The rule's own text anticipates and rejects exactly this rationalization: it exists as "a guardrail against future drift (a new command that 'helpfully' flips a status as a side-effect of ordinary mid-session work would violate it)."
- `logs/decisions.md` is confirmed append-only *in practice* (`commit-discipline.md:72`: "no in-place status-flip writer exists for it") — item 3 (a new dated entry) is fully consistent with that convention. No issue there.
- Net effect on reversibility: the deletion + `AGENTS.md`/`SKILL.md` edits are cleanly git-revertible (Low on their own). The `improvement-log.md:21` in-place edit is git-revertible too, but it establishes a precedent of bypassing the file's own sanctioned-mutator path — the risk is procedural/precedent, not "can't undo the git commit." This is what pulls the dimension to Medium.

### Dimension 5: Hidden Coupling
**Risk:** Low
- No in-repo hidden coupling found: nothing implicitly assumes `.codex/agents/*.toml` exists beyond the two prose consumers already accounted for.
- **Residual unknown (flagged, not resolved):** an external Codex-side configuration living outside this repo could in principle point at the exact `.codex/agents/*.toml` paths. This review cannot see outside the repo and cannot rule that out. Materiality is low: the Codex mirror was already explicitly de-scoped by the 2026-07-02 operator decision (`decisions.md:137`) — i.e., using Codex against this project is not a live, sanctioned use case today, so an external dependency on these exact files would itself be a violation of the already-approved de-scope, not a legitimate blocker to executing it now.
- `AGENTS.md`'s rewrite correctly **generalizes an existing, already-used contract** (the CLAUDE.md read-and-substitute pattern) rather than inventing a new untested one — see Dimension 3.

### Dimension 6: Principle Alignment
**Risk:** Medium
- **OP-10 (system boundary — Codex is out of scope by deliberate design):** correctly aligned. Going Claude-only retreats from an over-extended boundary, consistent with the *original* 2026-07-02 decision's own OP-10 citation (`decisions.md:141`: "standing hand-maintenance of two broken transforms across the cross-tool boundary the system deliberately walls off (OP-10)"). Grounded in `ai-resources/docs/commit-discipline.md` and cross-checked against `strategic-os/ai-strategy/principles-base.md:48` ("System boundary is Claude Code only... governing cross-tool behavior is a scope expansion needing explicit decision"). Low risk on this sub-point.
- **OP-11 (loud revision, never silent drift):** correctly aligned. Item 3 explicitly names commit `5204f4d` as undocumented drift and corrects it loudly via a new `decisions.md` entry — this is precisely what `decisions.md`'s own 2026-07-05 entry ("Process lesson") flagged as missing ("a gate can propagate a stale-log assumption... cross-check log-derived mitigations against the most recent decision record"). Per `principles-base.md:49`: "practice-vs-principle divergence must be surfaced and resolved loudly... never silent drift." Low risk on this sub-point — contingent on the decisions.md entry being corrected per Dimension 4's factual-accuracy note (an entry that repeats a false "untracked" claim while claiming to "loudly correct the record" undercuts its own OP-11 purpose).
- **`improvement-log.md:21` in-place edit vs. its own "Append-only" convention:** this is a genuine violation, not just a style question. `commit-discipline.md`'s "Maintenance-owned in-place mutations" section makes the append-only convention an operative rule with named sanctioned mutators, and this change's item 4 is not dispatched through any of them. Rated Medium (not High) because: the edit is a single factual correction rather than a status flip with collision stakes, the content risk is negligible, and the fix is cheap (see Mitigations).

## Mitigations

1. **Do not edit `logs/improvement-log.md:21` in place.** Append a new, clearly-dated correction line at the end of the file (or at the end of that entry, without altering existing lines) instead — e.g. "**Correction (2026-07-06):** the `.agents/skills/visual-design-spec/SKILL.md` duplicate named above does not exist; `.agents/` is absent from this repo (verified via `find`). The remainder of this entry (conversion-critic promotion, out of scope) is unaffected." This satisfies the same goal (the record is no longer wrong) without breaching the file's own "Append-only" header or the `commit-discipline.md` sanctioned-mutator rule. If an in-place fix is still preferred, defer it to a dedicated maintenance session (`/resolve-improvement-log` or the next `/friday-act` cycle) rather than this ordinary Phase-C work session.
2. **Correct the "untracked" framing before it enters `logs/decisions.md`.** The new decisions.md entry (item 3) should state that `.codex/agents/*.toml` and `AGENTS.md` are git-tracked, added in commit `5204f4d` (2026-07-05) — not "untracked mirror content." Carrying the stale "untracked" characterization from the pre-5204f4d decision into a *new*, OP-11-motivated correction entry would itself introduce a fresh factual error into the permanent record this change is trying to clean up.
3. **Optional but recommended:** update or strike `logs/next-up.md:17` once this change lands, so its "pick the policy and reconcile" instruction doesn't linger as a stale duplicate of now-completed work for a future session to trip over.

## Evidence-Grounding Note

All risk levels grounded in direct evidence. No training-data fallback was used on fetch/read failures.
