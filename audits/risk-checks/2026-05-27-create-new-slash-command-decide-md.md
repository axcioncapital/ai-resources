# Risk Check — 2026-05-27

## Change

Create a new slash command at `ai-resources/.claude/commands/decide.md` (operator-named, renamed from `decision-resolver` in inbox brief). Behavior: operator-invoked command that auto-detects the most recent decision list from context (looking for `## QC Review` blocks, `/scope` "decisions I am making on your behalf" sections, `/clarify` operator-question blocks, or numbered lists in the last Claude turn — asks when ambiguous), runs evidence-grounded pre-research against project files per question, and outputs a 3-bucket result: self-resolved (resolution + reasoning + file refs), recommendable (recommendation + evidence + gap + operator's verbatim original framing), or operator-only (question + project context + why no evidence-grounded answer is possible). Anti-narrowing markers required for every Recommendable item. Soft per-question token guidance (not hard cap). Prior-decision check against tail-read of `logs/session-notes.md` + `logs/session-plan.md` + conversation history before treating items as open. Frontmatter: `model: opus`. Composition partners: `/resolve`, `/scope`, `/clarify`. Source brief: `inbox/decision-resolver.md`. Session plan: `logs/session-plan-pass2.md`.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/decide.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/inbox/decision-resolver.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-pass2.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The command itself is in-pattern (small operator-invoked slash command, pay-as-used, comparable to recently-shipped `/contract-check`), but a structural conflict between CHANGE_DESCRIPTION and session-plan-pass2.md on the output target (slash command vs SKILL.md) and ambiguity on auto-detection vs operator-paste must be resolved before write.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The target file is not in any always-loaded path. `.claude/commands/*.md` files are pay-as-used — loaded only when the operator types the slash command. No CLAUDE.md edit, no `@import` chain, no SessionStart/Stop hook, no PreToolUse hook. Evidence: target path `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/decide.md` (not yet present) is in the same family as 60+ existing commands in that directory; the workspace and ai-resources `CLAUDE.md` files do not auto-load command bodies.
- Frontmatter declared `model: opus`. Per workspace CLAUDE.md § Model Tier, this is the only permitted out-of-session tier-binding mechanism. No `model` default added to settings.json. No drift from rule.
- Command is operator-invoked only — CHANGE_DESCRIPTION: "operator-invoked command that auto-detects..." Not auto-fired from hooks. No per-session or per-tool-call token cost.
- Body size unknown (file not yet present), but comparable commands range from 13 lines (`scope.md`) to 194 lines (`contract-check.md`, shipped today). Even at the upper end, pay-as-used tokens are immaterial against always-loaded budget.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION names no settings.json edit. No `permissions.allow`, `permissions.ask`, or `permissions.deny` entry mentioned. No new Bash patterns, Write paths, or MCP servers introduced. The command reads project files (already authorized via existing Read patterns) and writes nothing new.
- Composition partners `/resolve`, `/scope`, `/clarify` are existing in-repo commands — no external API or cross-repo write surface.

### Dimension 3: Blast Radius
**Risk:** Medium

- Single new file at `.claude/commands/decide.md`. Zero existing callers reference `/decide` or `decide.md` (grep across `skills/`, `.claude/`, `docs/`: matches are unrelated English-language uses of "decide" in operator-decision contexts — not invocations of the slash command).
- However, CHANGE_DESCRIPTION introduces a contract that overlaps with three existing commands. Evidence: `inbox/decision-resolver.md` § Composition with existing tools (lines 43–47) — `/resolve`, `/scope`, `/clarify` are listed as upstream composition partners. None of those three command files (`resolve.md` 41 lines, `scope.md` 13 lines, `clarify.md` 13 lines) currently document a `/decide` downstream contract. If the operator wants the composition contract to be discoverable from the upstream side, those three files would need minor reference adds (3 callers, all backwards-compatible — they continue to function with no change).
- Auto-detection markers (`## QC Review` block, `/scope` "decisions I am making on your behalf" sections, `/clarify` operator-question blocks) couple to the *output format* of three other commands. Verified `resolve.md` produces `## QC Review` block (it scans for one in Step 1); `scope.md` produces "Decisions you are making" not "decisions I am making on your behalf" (line 11 reads `5. **Decisions you are making**`) — the exact wording in CHANGE_DESCRIPTION does not match the source. This is a contract mismatch that will silently fail auto-detection if the command searches for the verbatim string in CHANGE_DESCRIPTION. Counts: 1 silent failure surface (scope.md output wording), 0 broken callers.
- The brief (§ Composition, line 53) explicitly says: "`/create-skill` should reconfirm this architectural choice — if the design pass reveals tighter overlap than the brief identifies, an extension may still be the right call." This means the brief itself flags Dimension 3 risk as material. Session-plan-pass2.md Finding 8 records this as a stop-point gate.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file create. `git revert` (or `git rm` pre-commit) fully restores prior state with no residue. No log-mutation side effect — the change adds no entry to `improvement-log.md`, `innovation-registry.md`, `session-notes.md` body, or any other append-only artifact.
- No symlinks created. No hook registration. No settings.json mutation.
- The brief at `inbox/decision-resolver.md` will be moved to `inbox/archive/decision-resolver.md` per session-plan-pass2.md Step 10 — that move is one `git mv` revert step, well-bounded.
- No external state propagated (no push gated in this change; push is a separate operator step per workspace Autonomy Rule #2).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Target-path conflict between CHANGE_DESCRIPTION and the named session plan.** CHANGE_DESCRIPTION says: "Create a new slash command at `ai-resources/.claude/commands/decide.md`." But `logs/session-plan-pass2.md` line 13 reads verbatim: "`/decide` will be a **SKILL.md** at `skills/decide/SKILL.md`, not a slash command at `.claude/commands/decide.md`." The same plan, line 36: "Verification: proposal names the output target as `skills/decide/SKILL.md`." This is a load-bearing contradiction — the change-description and the plan disagree on file type. A risk-check that grounds against either source produces different findings. Until resolved, no write should proceed.
- **Auto-detection contract relies on undocumented format markers across three external commands.** CHANGE_DESCRIPTION lists `## QC Review` blocks, `/scope` "decisions I am making on your behalf" sections, `/clarify` operator-question blocks. Verified: `scope.md` line 11 outputs "**Decisions you are making**" — not "decisions I am making on your behalf." The CHANGE_DESCRIPTION uses the brief's `inbox/decision-resolver.md` wording (line 21) which itself mismatches the live command. This is a silent-coupling failure mode — `/decide` will fail to auto-detect from `/scope` output because the literal string it searches for never appears. Anti-narrowing failure case (the exact pattern this command exists to prevent): the brief silently rewrote `/scope`'s output marker without verifying against the source. None of the upstream commands document a `/decide`-consumable contract.
- **Prior-decision check couples to log-tail format.** CHANGE_DESCRIPTION: "Prior-decision check against tail-read of `logs/session-notes.md` + `logs/session-plan.md` + conversation history before treating items as open." `logs/session-notes.md` is 483 lines, uses append-to-end format per workspace memory `feedback_session_notes_append_direction`. The current `logs/session-plan.md` (43 lines) is for a different mandate (friction-log fix), not the `/decide` build — the active plan for THIS work is `session-plan-pass2.md`. The command does not name `session-plan-pass2.md` as a search target, so if the operator runs `/decide` mid-session on a pass2 session, the prior-decision check reads a stale file. This couples to a convention (pass2 routing) that exists but is not in CHANGE_DESCRIPTION's named inputs.
- **Functional overlap with `/recommend`.** `/recommend` (25 lines) is "use your own judgment on all open questions and proceed." `/decide` is the inverse posture (explicit per-item evidence + anti-narrowing). The brief at `inbox/decision-resolver.md` § Exclusions correctly distinguishes these. The risk is operator confusion at invocation time (which one to use). Not severe (the two have opposite shapes), but the names are semantically close enough that the boundary needs to be discoverable from each command's body. Currently `/recommend.md` does not name `/decide` as the opposite-posture alternative.
- **Brief explicitly flags an alternative design (extend `/resolve` instead).** `inbox/decision-resolver.md` line 53: "`/create-skill` should reconfirm this architectural choice — if the design pass reveals tighter overlap than the brief identifies, an extension may still be the right call." Session-plan-pass2.md Finding 8 (line 33) makes this a stop-point gate. The current CHANGE_DESCRIPTION assumes the new-command shape was confirmed by `/create-skill` Step 1, but no Step 1 output is supplied as evidence to this risk-check.

### INCOMPLETE
None of the five dimensions is fully INCOMPLETE, but Dimension 5 is partially grounded against a CHANGE_DESCRIPTION that contradicts the cited session plan. The High verdict is grounded against verifiable evidence (verbatim quote from session-plan-pass2.md line 13; verbatim quote from scope.md line 11) regardless of which resolution the operator picks for the target-path conflict.

## Mitigations

- **Dimension 5 (target-path conflict):** Resolve the slash-command-vs-SKILL.md disagreement explicitly before writing any file. Either (a) update `session-plan-pass2.md` Finding 8 to record that the architectural reconfirm at `/create-skill` Step 1 concluded the slash-command shape is correct (with one-line rationale referencing the comparable `/contract-check` that shipped today as a slash command, not a SKILL.md), or (b) update CHANGE_DESCRIPTION to target `skills/decide/SKILL.md` per the plan. Do not write the file under both interpretations or under an ambiguous interpretation — pick one path and record the choice.
- **Dimension 5 (auto-detection marker mismatch):** Before writing the command body, re-verify the exact verbatim output strings produced by `/resolve` (`## QC Review`), `/scope` (`5. **Decisions you are making**` per scope.md line 11), and `/clarify` (currently emits assumptions + clarifying questions, no specific output marker). Use the actual live wording in the auto-detection logic, not the wording from `inbox/decision-resolver.md` line 21. Cite the source command + line for each marker in the new command body so a future audit can trace the coupling.
- **Dimension 5 (prior-decision check log scope):** Extend the prior-decision check target list to include `logs/session-plan-pass2.md` (and any `session-plan-pass{N}.md` siblings if present), per the Wave C `session-plan-pass2.md` routing convention documented in `docs/repo-architecture.md` Q6 (per session-notes.md 2026-05-26 wrap, Wave C SO mitigation M-1).
- **Dimension 3 (silent contract overlap with `/resolve`, `/scope`, `/clarify`, `/recommend`):** Add one-line cross-references in the bodies of `/resolve.md`, `/scope.md`, `/clarify.md`, and `/recommend.md` naming `/decide` as the downstream composition partner (or in `/recommend`'s case, the opposite-posture alternative). These edits are byte-minimal and backwards-compatible, but they make the contract discoverable from both sides. Confirm scope by running an end-time `/risk-check` on the four upstream edits as a batch.

## Recommended redesign

(Omitted — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: verbatim quotes from `inbox/decision-resolver.md` (lines 21, 53), `logs/session-plan-pass2.md` (lines 13, 33, 36), `.claude/commands/scope.md` (line 11), `.claude/commands/resolve.md` (Step 1), workspace CLAUDE.md § Model Tier; line counts from `wc -l` on `.claude/commands/*.md`; ls confirmation that `decide.md` and `skills/decide/` do not currently exist; grep confirmation that no existing repo content invokes `/decide`. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — `/decide` slash command (operator-named)

## Routing position (architectural baseline)

If `/decide` ships as a slash command, the routing baseline is unambiguous: `ai-resources/.claude/commands/decide.md` is the canonical home for operator-invoked, on-demand commands that produce specific output (`repo-architecture.md` § Canonical homes, § Q2; `system-doc.md` § 4.2). Spawn shape: main-session, no subagent — same family as `/recommend`, `/route-change`, `/contract-check` (`repo-architecture.md` § Q3, third row). Gate: plan-time `/risk-check` (which has fired) plus end-time before commit (`risk-topology.md` § 3 — "New canonical command/agent"; `principles.md` § DR-8).

But the routing position is contested upstream by the session plan. See below — that is the load-bearing issue.

## Architectural commentary

**The PROCEED-WITH-CAUTION verdict is correct, but the framing understates Dimension 5.** The risk-check report names the slash-command-vs-SKILL.md conflict as "a structural conflict that must be resolved before write." The right reading is sharper: this is an **OP-3 / AP-1 violation already in progress** — two load-bearing documents (CHANGE_DESCRIPTION and session-plan-pass2.md line 13) state opposite intents, and the session is one write away from silent resolution of that conflict (`principles.md` § OP-3 — loud failure over silent continuation; § AP-1 — silent conflict resolution). The risk-check called the right verdict; we should treat the resolution as **architectural, not clerical**.

**Concur with PROCEED-WITH-CAUTION. Concur with all four mitigations. Add a fifth, and flag one design concern none of the dimensions caught.**

## Position on each of the four mitigations

1. **Resolve the target-path conflict before any write.** Concur, with strengthening: the resolution is not a coin flip. The slash-command shape is the correct architectural choice. Evidence: (a) the brief at `inbox/decision-resolver.md` lines 8, 16–25, 43–47 describes operator-invoked, on-demand, command-shaped behavior — that is exactly the slash-command pattern per `repo-architecture.md` § Q2; (b) composition partners `/resolve`, `/scope`, `/clarify`, `/recommend` are all slash commands at `.claude/commands/`, not SKILL.md skills — the composition graph is homogeneous; (c) `/contract-check` shipped today as a slash command for behavior of comparable complexity. session-plan-pass2.md's rationale ("`/create-skill` produces `skills/{name}/SKILL.md` as its canonical output") is a procedural argument, not an architectural one — it conflates *which pipeline created the artifact* with *which canonical home the artifact belongs in*. The pipeline is fine; the output target named in the plan is wrong. The right action is to update session-plan-pass2.md Finding 8 to record that the slash-command shape is reconfirmed (`repo-architecture.md` § Canonical homes — Slash command row; `principles.md` § DR-3 — component type determines home).

2. **Re-verify auto-detection markers against live source.** Concur. The risk-check found the `/scope` mismatch ("Decisions you are making" vs. brief's "decisions I am making on your behalf"); I verified the same and add: `/clarify` produces no fixed output marker at all — it emits assumptions and clarifying questions in free-form prose (verified in `clarify.md`). The CHANGE_DESCRIPTION names "operator-question blocks" as a `/clarify` marker, but there is no literal block delimiter to search for. The auto-detection logic must either (a) operate on `/clarify`-shaped prose with looser heuristics (and document that), or (b) drop `/clarify` from the auto-detection set and require operator-paste for that path. Picking one and recording it makes the contract honest (`principles.md` § QS-6 — trigger conditions stated and unambiguous; § OP-6 — transfer the mental model, not just the instruction).

3. **Extend the prior-decision check to `session-plan-pass{N}.md` siblings.** Concur. This is straightforward and the convention is already documented (`repo-architecture.md` § Q6, `logs/session-plan-pass2.md` row).

4. **Add cross-references in `/resolve`, `/scope`, `/clarify`, `/recommend`.** Concur, with one constraint: the four upstream edits are byte-minimal but they are still edits to canonical commands. Per `risk-topology.md` § 3 ("Canonical command/agent edit" → all projects invoking it; `/risk-check` required), they are best landed as a single end-time `/risk-check` batch — which the mitigation already names. Apply `principles.md` § DR-9 top-3 analysis on the batch before commit, even though the edits are additive. The four edits should also state the composition direction explicitly: `/recommend` is named as the *opposite-posture alternative*, not a composition partner (per the brief's § Exclusions — "Does NOT replace `/recommend`" — these are inverse postures, not composing tools).

## Risk the dimension review missed

**The deferred ROI re-check at `/create-skill` Step 1 is not actually a stop-point if the operator runs the change-description-as-written.**

- `inbox/decision-resolver.md` line 53: "`/create-skill` should reconfirm this architectural choice — if the design pass reveals tighter overlap than the brief identifies, an extension may still be the right call."
- `session-plan-pass2.md` Step 1 (line 36): "**[STOP POINT: review Step 1 proposal before proceeding.]** Verification: proposal names the output target as `skills/decide/SKILL.md` and explicitly addresses Finding 8."
- The CHANGE_DESCRIPTION supplied to the risk-check **pre-commits the slash-command shape and bypasses Finding 8's architectural reconfirm.** The risk-check verdict at Dimension 5 noted this in passing ("no Step 1 output is supplied as evidence to this risk-check") but did not name the deeper issue: a plan-time risk-check on a CHANGE_DESCRIPTION that contradicts its own session plan means **the architectural reconfirm gate was skipped, not resolved.** This is an `principles.md` § OP-2 boundary case — execution autonomy does not extend to load-bearing architectural choices that an active session-plan gate has flagged.

The right answer: before the file is written, the operator (or `/create-skill` Step 1) emits a one-paragraph architectural reconfirm that names the slash-command shape as the chosen target, cites the brief and `repo-architecture.md` § Q2/Q3 as evidence, and explicitly resolves Finding 8. Then session-plan-pass2.md line 13 is updated to match (`principles.md` § OP-3 — surface conflicts, do not smooth them; § AP-11 — fix the drafter, not the symptom). Without this step the contradiction is buried, not resolved.

## Position (declarative)

**The right answer is:**

1. Concur with PROCEED-WITH-CAUTION.
2. Concur with all four mitigations as stated.
3. **Add a fifth mitigation (gating on the others):** before any of the four are executed, produce a one-paragraph architectural reconfirm record that names the slash-command shape as the chosen target with cited rationale, and update `session-plan-pass2.md` line 13 (and Step 1 verification at line 36) to match. This converts the silent contradiction into a recorded decision — which is what OP-3 requires.
4. With those five in place, the change is fit to proceed. The remaining risk profile is what the dimension review described: Low / Low / Medium / Low / High, with the High at Dimension 5 reducing to Medium once the target-path and marker-string conflicts are recorded resolutions rather than open ambiguities.

Files referenced in this advisory:
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-27-create-new-slash-command-decide-md.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/inbox/decision-resolver.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-pass2.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/clarify.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/recommend.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md`
