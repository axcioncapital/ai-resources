# Risk Check — 2026-07-20

## Change

Add a new project-local hook to the axcion-pitch-engine project — check-case-boundary.sh, one shell script with TWO registrations:
(1) a PostToolUse hook registered in the project's .claude/settings.json, matcher Write|Edit, which warns to stderr and always exits 0;
(2) a git pre-commit hook, installed by symlinking projects/axcion-pitch-engine/.git/hooks/pre-commit to ../../.claude/hooks/check-case-boundary.sh, which iterates `git diff --cached --name-only` and exits 1 to BLOCK the commit when a staged file carries a "Restricted" or "Highly restricted" confidentiality marker. Bypassable with `git commit --no-verify` by design.

The script runs only one check (Check A, classification-marker leak). A second check (Check B, CRM product naming) was CUT at the Architecture Gate because it has no defined true positive until an open decision is answered.

Context: this is the ONLY executable component in a new project scaffold being built by /new-project. The project is axcion-pitch-engine, a commercial-meeting preparation capability whose plan names over-build as its dominant risk (its predecessor plan was rejected for being "a governance programme wrapped around a manual meeting-preparation capability"). No input planning document asks for this hook — that objection was raised at the Architecture Gate, survived it, and is not dissolved by the amendment. The justification rests on a confidentiality asymmetry: violating the engine/case boundary is expensive and irreversible (confidential recipient data in a pushed git history), while checking it is nearly free.

The two-layer design was adopted at the Architecture Gate after /implementation-triage found the original single-layer PostToolUse design inverted its own harm model — it named the harm at the commit boundary, then rejected the commit-boundary control as "too late."

⚠ CORRECTION APPLIED DURING PRE-DISPATCH PREMISE VERIFICATION — this supersedes the framing above:
The structural precedent, projects/axcion-website/.claude/hooks/boundary-leakage-check.sh (326 lines, symlinked live at projects/axcion-website/.git/hooks/pre-commit — verified by `ls -l` and by reading the script's GIT_DIR branch and its `exit 1` at line 323), is a **PreToolUse + pre-commit** hook, NOT PostToolUse + pre-commit. Its own line 3 says so. An earlier framing claimed it "runs exactly this design"; that was wrong. The donor's advisory layer is therefore STRICTLY STRONGER than the one proposed here — PreToolUse can reject a write before it happens; PostToolUse can only warn after the file exists. The precedent validates the two-layer principle and the git-blocking layer. It does NOT validate PostToolUse as the correct choice for layer one. Do not treat it as precedent for that choice.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/pipeline/architecture.md — exists (see §2.4 hook design, §5.3b why this gate is required, §5.4 cwd risk, §6 rows D1/D1′ decision history)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/.claude/hooks/check-case-boundary.sh — not yet present (this is what the change would create)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/.claude/settings.json — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/hooks/boundary-leakage-check.sh — exists (structural precedent, 326 lines)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.git/hooks/pre-commit — exists (live relative symlink to the above)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists (line 1590 carries the "a guard whose only escape is a bypass trains the bypass" lesson; the surrounding entry is the check-foreign-staging.sh wrong-repo defect, 2026-07-19)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists (the guard whose defect motivates question (a))

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The hook is a well-deliberated, tightly-scoped, single-project addition with zero external consumers and no permission widening, but it carries three real Medium-level costs — an asymmetric-cleanup reversibility gap, a functionally-overlapping advisory layer of unproven marginal value, and a complexity-budget gate that is cleared on operator-mandate grounds rather than on cited incident evidence — none of which is severe enough alone to force RECONSIDER, but together they warrant explicit mitigation before landing.

## Consumer Inventory

Search terms used: `check-case-boundary` (the new component's basename/contract marker), `boundary-leakage-check` (structural precedent, to separate its own consumers from consumers of the new file), `check-claim-ids` (shape-donor precedent), `axcion-pitch-engine` (project-name mentions). Grepped across `ai-resources` and the workspace root per Step 1.5 (absolute-path form — confirmed not blind by `search-canary.sh`, which reported `SEARCH_CANARY=blind` only for dot-rooted walks; this inventory used absolute paths throughout, which the canary itself classifies "not blind").

**Zero external consumers found.** A repo-wide grep for `check-case-boundary` returns exactly one hit outside the not-yet-created files themselves: `projects/axcion-pitch-engine/pipeline/architecture.md` (which specifies the contract, it does not invoke it). No `ai-resources/` command, agent, skill, or hook references it. This is an isolated, brand-new component — the file has no consumers yet; the table below covers the contract (two hook registrations) it will introduce.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/axcion-pitch-engine/.claude/settings.json` (not yet present) | invokes (registers the PostToolUse hook) | yes — co-created in the same change |
| `projects/axcion-pitch-engine/.git/hooks/pre-commit` (not yet present, relative symlink) | invokes (pre-commit mode) | yes — co-created in the same change |
| `projects/axcion-pitch-engine/pipeline/architecture.md` | documents (full design spec, §2.4/§3/§5.3b/§5.4/§6) | no |
| `projects/axcion-pitch-engine/pipeline/decisions.md` | documents (Architecture Gate rows 6–9: D1/D1′, Check B cut, risk-check requirement) | no |

**Total: 4 consumers, 2 must-change.** Both must-change consumers are being created *by* the same change, not pre-existing callers that need adaptation — so this is a self-contained new subsystem, not a change that ripples into independently-owned files. No `ai-resources/` canonical component is touched, extended, or re-pointed (confirmed by the zero-hit grep and by architecture.md §3's own explicit claim: "No modification to any `ai-resources/` component").

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added — no CLAUDE.md line, no `@import`, no SessionStart hook. `check-case-boundary.sh` is invoked only by `PostToolUse` on `Write|Edit` inside the axcion-pitch-engine project (architecture.md §2.4: "Matcher: `Write|Edit`... All path scoping happens inside the script body"), and only when the session's project directory is `projects/axcion-pitch-engine/` (§5.4).
- Identical registration shape (PostToolUse-matcher-Write, `jq` the path, `grep`, tiered stderr warning, `exit 0`) already runs in this workspace via `check-claim-ids.sh`, confirmed live in `ai-resources/workflows/research-workflow/.claude/settings.json` (read directly) and deployed to 4 live projects (`decisions.md` #10, corrected count verified by `find`). This is an established, low-cost pattern, not a novel cost surface.
- The git pre-commit layer costs zero Claude Code session tokens — it runs outside any Claude session entirely (fires from `git commit` itself, even from a bare terminal), so its cost is pure shell execution time at commit, not context/token load.
- Not yet present — evaluated against architecture.md's documented intent (§2.4), which is specific enough (exact matcher, exact exit-code contract, skip-list, dual-mode detection) to score with confidence.

### Dimension 2: Permissions Surface
**Risk:** Low

- Architecture.md states explicitly: "No new permissions are required — the hook is invoked by the hooks system, not by a tool call" (§2.2), and §5.3 "Permission conflicts: None. The canonical template is used unmodified."
- The project's `settings.json` is built verbatim from `ai-resources/templates/project-settings.json.template` (read directly — confirms `defaultMode: bypassPermissions`, broad `allow` including `Bash(*)`, no `PostToolUse` block in the template today), consistent with this workspace's established permissive-config posture (safety via git/risk-check/audits, not prompts).
- The git pre-commit block operates entirely **outside** the Claude Code permission system — it is a git-level enforcement mechanism (a symlink git itself reads), not an `allow`/`deny`/`ask` entry. Its risk is real but belongs to Blast Radius / Reversibility / Hidden Coupling below, not to this dimension; noting the distinction explicitly so the blocking behavior is not silently missed by a narrow "no permission entries changed" reading.

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Step 1.5 inventory: 4 consumers total, 2 must-change — and both must-change consumers (`settings.json`, the `.git/hooks/pre-commit` symlink) are created *by* this same change, not independent callers that must be adapted. Zero external, pre-existing consumers were found.
- No contract change to any existing component — `check-case-boundary.sh` is new, and the `check-claim-ids.sh` shape donor is read-only ("a donor read for its shape, not a dependency" — architecture.md §3), untouched by this change.
- No shared/canonical infrastructure is touched: no `ai-resources/` hook, command, skill, or always-loaded CLAUDE.md is modified.
- **Judgment (a), addressed here and carried into Dimension 4:** the classic caller-count blast radius is genuinely Low, but the operator's question points at a different vector — once installed, the git pre-commit layer is a mandatory single gate through which *every future commit to this one repo* must pass. A false positive would block 100% of commit attempts to axcion-pitch-engine, mirroring the shape (not the mechanism) of the `check-foreign-staging.sh` wrong-repo defect (`improvement-log.md:1586-1614`, verified by direct read: severity medium-high, "it hard-blocks (exit 2) a legitimate commit, and the block is unclearable by the remedy the hook itself prescribes"). That risk is real but is a *reversibility/false-positive-recovery* question, not a *caller-count* question — it is scored substantively in Dimension 4, not double-counted here.

### Dimension 4: Reversibility
**Risk:** Medium

- The tracked source file (`.claude/hooks/check-case-boundary.sh`) reverts cleanly via `git revert`/`git rm` — normal git history.
- **The untracked half does not.** `.git/hooks/` is not tracked by git (a general git fact, and explicitly confirmed by architecture.md §3: "Note `.git/hooks/` is **not** tracked by git, so this install does not travel with a clone — a fresh clone needs it re-run"). Consequence, stated precisely: reverting the tracked script does **not** remove the `.git/hooks/pre-commit` symlink — it leaves a dangling symlink pointing at a now-deleted file. Removing it fully requires a second, manual, non-git step (`rm .git/hooks/pre-commit`) that a plain `git revert` will not perform. This matches the "Medium" heuristic exactly: revert works but requires one extra cleanup step.
- The same untracked property runs in reverse too: a fresh clone of this repo ships with **no guard at all** until the symlink is manually re-installed (architecture.md §5.4 names this as an accepted, non-absolute limit, not a defect). So the control's on/off state is not reliably git-tracked in either direction — install and uninstall both depend on a manual step outside version control. This is a genuine structural property of the design (shared with the `axcion-website` precedent, not unique to this change), not a hidden one — but it is real and worth a named mitigation (below).
- Once installed, the hook is live automation that could fire (block a legitimate commit) at any point between landing and a later decision to revert — the interim cost of a false positive is borne before anyone notices the need to walk it back.
- No push, no external-API write, no state beyond the local repo — this keeps the dimension at Medium rather than High.
- Not yet present — evaluated against architecture.md's documented intent, which explicitly names both halves of this limitation (§3 table, §5.4 update), so the risk is loudly surfaced in the source document, not hidden from it.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Ordering dependency, named but not enforced in-script.** The pre-commit install requires `git init` to have already run, or `.git/hooks/` does not exist (architecture.md §3: "Ordering is load-bearing: `git init` must run first"). This dependency is documented in architecture.md, not in the script itself (which does not yet exist) — a reader of the script in isolation would not see it.
- **Judgment (d), scored here.** The two registrations of the same script both implement Check A (classification-marker detection) — one warns, one blocks. This is a *documented, precedented* two-layer model (verified live in `axcion-website`), not an accidental collision of two independent mechanisms — so it is not "hidden" in the pejorative sense the rubric targets. But the specific choice of `PostToolUse` (rather than `PreToolUse`) for layer one is **not** validated by that precedent — the donor's own layer one is `PreToolUse` (confirmed: `boundary-leakage-check.sh:3`, "PreToolUse + pre-commit boundary-leakage enforcement"), which can reject a write before it lands. `PostToolUse` can only warn *after* the file already carries the restricted marker on disk. Given the binding git layer already exists, already covers the identical check, and already prints the offending paths clearly (architecture.md §2.4: "print the offending paths and `exit 1`"), the marginal value of the `PostToolUse` warn is real but thin: earlier in-session feedback, available only when the session's cwd is already the project directory (§5.4 — the same condition under which the advisory rules already load). This is functional overlap between the two registrations, not a violation, but it is an unproven design choice the architecture document itself flags as open ("That question is live and is put to `/risk-check` explicitly") — hence Medium, not Low.
- Dual-mode stdin-JSON detection (the mechanism that lets one script serve two registrations) is a real implicit contract, but it is explicitly specified in architecture.md §2.4 ("the one thing the implementation spec must not get wrong") and the donor demonstrates the identical idiom is normally documented inline in the script's own header comments (`boundary-leakage-check.sh:33-43`) — so the intent is to document it at the change site, not to leave it implicit. Scored as a named, not-hidden risk.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read directly) and `ai-resources/docs/ai-resource-creation.md` rule #7 (read directly).

- **OP-12 (closure before detection) — positively served, not violated.** The architecture's own reasoning for adding the git-blocking layer is explicitly OP-12-shaped: the original PostToolUse-only design was "detection without closure," and the git layer supplies the missing closure channel (architecture.md §2.4 amendment note; `decisions.md` #7). Cutting Check B (`decisions.md` #8) for having "no defined true positive" is the same OP-12 reasoning applied to avoid shipping detection with zero present benefit. Both are principle-compliant moves.
- **OP-5 (advisory vs. enforcement) — not violated.** The git layer blocks (`exit 1`) but does not auto-correct the flagged content; it stops and requires a human decision (fix, or `--no-verify`). That is "advises and stops" behavior in OP-5's own terms, not "detects and auto-corrects." Worth stating explicitly since the operator's framing ("BLOCK the commit") could otherwise read as an enforcement upgrade — it is not.
- **Rule #7 complexity-budget gate — the real tension.** This is a net-new component (fails prong (a): no existing load-bearing unit is removed or held). Prong (b) requires "cited written evidence: a friction-log/defect-log/coaching-log/incident-log entry, or a pattern seen ≥2 times" — and no such incident citation exists; nothing has ever actually leaked into this repo's git history (the project has no commits yet). The justification is a forward-looking risk-asymmetry argument tied to an operator-approved, LOCKED control-pack requirement (`cp-02`: "Client- and relationship-specific data must never be committed casually to the engine's reusable Git history" — architecture.md §2.3), not a cited-incident evidence trail. Read strictly, this fails both named prongs.
- **But this is not silent drift — it is unusually loud.** `pipeline/decisions.md` rows 6–9 (read directly) record: a System-Owner (Opus) Architecture Gate review that judged the design "genuinely restrained and every component traceable to a LOCKED requirement"; the two-layer amendment with rationale; the Check B cut with rationale; and an explicit, binding requirement for `/risk-check` at plan-time **and** end-time — which is the very gate producing this report. Rule #7's own escape clause is "a loud, recorded principle exception (OP-11) — a deliberate decision logged in `logs/decisions.md` with its rationale, never an in-line 'it's fine actually' assertion." The project's decision log satisfies the spirit of that clause (recorded, reasoned, reviewed) but does not use OP-11's own language, and the justification is an operator mandate rather than a cited incident — a real, nameable gap between "well-deliberated" and "formally cleared by rule #7's letter." That gap is the Medium.
- **DR-8 compliance** — confirmed: architecture.md §5.3b explicitly requires plan-time and end-time `/risk-check`, consistent with DR-8's structural-change-class requirement; this session's dispatch is the plan-time instance of that requirement executing correctly.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** The change is **not primarily defect-justified** — the decision to build this hook follows an operator-approved, LOCKED control-pack requirement (`cp-02`) and a System-Owner Architecture Gate review, not a claim that something is currently broken. Where the change description does make specific, checkable factual claims, each was independently re-derived and observed, not inherited:
  - The corrected precedent claim (donor is `PreToolUse` + pre-commit, not `PostToolUse` + pre-commit) — **observed**: `boundary-leakage-check.sh:3` reads "PreToolUse + pre-commit boundary-leakage enforcement for axcion-website," confirming the correction and refuting the superseded "runs exactly this design" framing.
  - The donor's `exit 1` location and total length — **observed**: direct read confirms `exit 1` at line 323 and the file ending at line 326, both exact matches to the change description's citation.
  - The live-symlink claim — **observed**: `ls -l projects/axcion-website/.git/hooks/pre-commit` confirms a live relative symlink to `../../.claude/hooks/boundary-leakage-check.sh`.
  - The `check-foreign-staging.sh` precedent (severity, "unclearable by the remedy," "a guard whose only escape is a bypass trains the bypass") — **observed**: direct read of `improvement-log.md:1586-1614` confirms severity medium-high and an exact-text match to the quoted lesson at line 1590.
  - `.git/hooks/` not being tracked by git — a general, independently-true git fact, consistent with architecture.md's own explicit statement and with the untracked, working-tree-only nature of the verified symlink above.
- **Consequence — traced or assumed?** Not applicable in the classic sense (no defect is being fixed), but the *risk* consequences cited in the judgment questions were traced, not assumed: the check-foreign-staging.sh block was traced to an actual unclearable failure (verified in the log entry itself, including the "worked around, not fixed" resolution and the second-gate RECONSIDER outcome), and the reversibility gap (Dimension 4) was traced to the specific git mechanic (untracked `.git/hooks/`) rather than asserted generically.
- **Re-derivation vs. the change description:** None — all claims re-derived and confirmed, including the one claim the input document itself had already flagged and corrected (the original "runs exactly this design" over-claim), which my independent read confirms was rightly corrected.
- **Not defect-justified for the core build decision — no premise to verify there.** Risk: Low.

## Mitigations

- **Dimension 4 (Reversibility):** Before or during Stage 4, add one explicit line to the project's `## Operating Constraint` section of `CLAUDE.md`: "Full removal requires two steps, not one: `git rm .claude/hooks/check-case-boundary.sh` (tracked) **and** `rm .git/hooks/pre-commit` (untracked symlink, not removed by git revert)." This closes the dangling-symlink gap named above and prevents a future session from believing a `git revert` fully disabled the guard.
- **Dimension 5 (Hidden Coupling):** Resolve judgment (d) explicitly before Stage 4 builds the script rather than shipping both layers by default. Recommended default: **drop the `PostToolUse` registration** and rely solely on the git pre-commit layer, since the corrected precedent does not validate `PostToolUse` as the right mechanism for layer one and the git layer already prints offending paths clearly. If the `PostToolUse` layer is kept anyway (e.g., for in-session early feedback), add an inline header comment mirroring the donor's own documentation style (`boundary-leakage-check.sh:33-43`) stating plainly that this layer is advisory-only, does not reject, and is not validated by the axcion-website precedent for this specific role — so a future reader does not mistake it for a rejecting control.
- **Dimension 6 (Principle Alignment):** Add one explicit sentence to `pipeline/decisions.md` row 7 or a new row, naming the rule #7 gap in its own terms: "This component fails ai-resource-creation.md rule #7 prong (b) on a strict reading (no cited incident-log entry); it is introduced as a loud, recorded OP-11 exception on the strength of the `cp-02` LOCKED control-pack mandate and the System-Owner Architecture Gate review, not a cited failure history." This converts an implicit (if well-deliberated) justification into an explicit OP-11-labeled one, which is the only difference between "well-argued" and "formally cleared" under the gate's own letter.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
