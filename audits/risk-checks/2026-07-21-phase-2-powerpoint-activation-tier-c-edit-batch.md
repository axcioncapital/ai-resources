# Risk Check — 2026-07-21

## Change

Phase 2 (PowerPoint) activation for the Axcíon Design Studio — a batch of tier-C edits proposed in `projects/axcion-design-studio/30_reference-lenses/phase2-powerpoint/tier-c-edit-proposal.md`. NOTHING HAS BEEN APPLIED; this is a plan-time gate on a drafted proposal.

Context: Phase 2 was DORMANT. The operator activated it by explicit instruction (the activation plan's §10 second trigger — no qualifying inbound brief exists). A Step 0 revalidation ran first and passed: all four checks MATCH (`projects/axcion-design-studio/30_reference-lenses/phase2-powerpoint/activation-step0-revalidation.md`).

WAVE 1 — doctrine activation:
- Edit 1 — `00_mandate/design-studio-mandate.md` (PROTECTED, CP-1 tier-C gate). Four sub-edits: (1a) rewrite §1 Mandate into two modes, and widen the Studio's remit so that in deck mode it DRAFTS SLIDE-LEVEL CONTENT (slide sequence, conclusion-led headlines, per-slide copy) from the Pitch Engine brief — the activation plan calls this "a mandate change, not a resolved conflict"; (1b) retitle §2 "Scope (Phase 1)" → "Scope", move the PowerPoint bullet out of Out-of-scope, add a Phase 2 in-scope block; (1c) add two new critics for deck mode — `pptx-bridge` and `copy-fidelity` — taking deck mode to 1 creator + 4 critics; (1d) mode-qualify §4 and §5 headings.
- Edit 2 — `CLAUDE.md` (PROTECTED, always-loaded project context). Flip the Phase 2 line from DORMANT to "ACTIVE, building", explicitly stating the chain is NOT yet built and pointing at the hand-build escape hatch.
- Edit 3 — `.claude/skills/visual-design-spec/SKILL.md` (PROTECTED). Update the phase note so decks route to a future `deck-design-spec` skill rather than this one.
- Edit 4 — `10_brand-system/README.md` (PROTECTED). Add a deck-grammar pointer table (pointers only; the file's rule is no brand-book content may be copied).
- Edit 5 — `30_reference-lenses/phase2-powerpoint/phase2-activation-plan.md` (NOT protected — `30_reference-lenses/` is explicitly a free workspace). Correct a factual error: §9 claims the Studio's confidential-storage path "Mirrors the Pitch Engine's own storage answer", but `projects/axcion-pitch-engine/standards/case-location.md` reads "Status: OPEN — the location is not yet decided" with an unfilled {AUTHOR:} placeholder.

WAVE 2 — the missing control (separable):
- Edit 6 — add a new pre-commit hook to `axcion-design-studio` mirroring `projects/axcion-pitch-engine/.claude/hooks/check-case-boundary.sh` (verified to exist, 6496 bytes, with MARKER_RE and SKIP_RE), blocking staged markdown carrying a `Restricted`/`Highly restricted` marker. This repo currently has NO `.claude/hooks/` directory and NO `.git/hooks/pre-commit` (verified). Registration would be an untracked symlink at `.git/hooks/pre-commit`, so a fresh clone ships without it; it is `--no-verify`-overridable; removal requires two steps or a dangling symlink breaks every later commit.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/30_reference-lenses/phase2-powerpoint/tier-c-edit-proposal.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/30_reference-lenses/phase2-powerpoint/activation-step0-revalidation.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/30_reference-lenses/phase2-powerpoint/phase2-activation-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/00_mandate/design-studio-mandate.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/00_mandate/source-of-truth-hierarchy.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/10_brand-system/README.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/pipeline/architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/pipeline/technical-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/20_criteria/conversion-clarity-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/next-up.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/audits/lean-repo-2026-07-05-playbook-fit.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/.claude/hooks/check-case-boundary.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/standards/case-location.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/standards/confidentiality-rule.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-pitch-engine/CLAUDE.md — exists

## Verdict

RECONSIDER

**Summary:** The batch is well-sourced and mostly low-risk on its own edits, but Edit 1c lands two new deck-mode critics against a `pipeline/`-governed CLOSED four-role contract without performing the pack amendment that contract itself requires — an unresolved, self-flagged-but-not-executed principle violation that forces reconsideration regardless of how the other dimensions score.

## Consumer Inventory

Search terms derived from the change: `visual-design-spec`, `layout-architect`/`brand-guardian`/`visual-red-team`/`implementation-bridge` (existing roster), `pptx-bridge`/`copy-fidelity`/`deck-design-spec` (new contract the change introduces), `four-role`/`1 creator + 3 critics`/`three critics`/`CLOSED contract` (the governance marker Edit 1c collides with), `check-case-boundary.sh` (Wave 2's mirrored pattern). Grepped across `projects/axcion-design-studio/`, `projects/axcion-pitch-engine/`, `projects/axcion-website/`, `projects/axcion-brand-book/`, `projects/axcion-copy-factory/`, and the workspace root.

`pptx-bridge` / `copy-fidelity` / `deck-design-spec` have **zero existing consumers** outside the activation-plan family itself (`phase2-activation-plan.md`, `tier-c-edit-proposal.md`, project `logs/session-notes.md` as a forward-reference record) — confirmed by grep, 0 hits elsewhere in the repo or cross-repo. The four-role/three-critics contract Edit 1c collides with, by contrast, has a large, pre-existing consumer set:

| Consumer path | Reference type | Must change? |
|---|---|---|
| `pipeline/architecture.md` (DD-A4) | documents (defines the CLOSED four-role contract) | yes |
| `pipeline/technical-spec.md` (DD-1) | documents (defines the CLOSED four-role contract) | yes |
| `pipeline/project-plan.md` (5+ hits, e.g. line 13, 194, 290) | documents (CLOSED deliverable shape) | yes |
| `pipeline/context-pack.md` (line 18–19) | documents ("four-role shape... UNCHANGED and remains closed") | yes |
| `logs/next-up.md` (line 41) | documents (guardrail: "any change to critic count or roles is a pack amendment... parked `conversion-critic` stays parked") | yes |
| `logs/improvement-log.md` (lines 13–23) | documents (parked entry prescribing the exact process — `/risk-check` + `/contract-check`, ~10 stale consumers — for this class of change) | yes |
| `20_criteria/conversion-clarity-review.md` (line 9) | documents (ties the parked 4th critic's fate to "a formal pack amendment") | yes |
| `web-refinement-playbook.md` (line 12) | documents ("four-role shape is a CLOSED contract... no 4th critic without a pack amendment") | yes |
| `CLAUDE.md` (project, line 3) | documents (own opening line: "four-role team (1 creator + 3 critics)") — not touched by Edit 2, which only edits the PowerPoint bullet | yes |
| `AGENTS.md` (line 21) | documents (roster description) | yes (per improvement-log.md's own prior mapping) |
| `logs/decisions.md` (lines 245, 279, 309, 320) | documents (records critic count/shape as "explicitly not loosened") | yes (needs a new decision entry) |
| `pipeline/implementation-spec.md` (lines 190–191, 317) | documents (four-role team, Phase 1 scope) | no (historical Phase-1 record) |
| `pipeline/claude-design-setup.md`, `pipeline/wireframe-stage-plan.md`, `pipeline/visual-system-integration-plan.md`, `pipeline/create-skill-brief.md` | documents (web-mode/Phase-1-specific stage docs) | no |
| `audits/lean-repo-2026-07-05-playbook-fit.md` | documents (dated audit snapshot) | no |
| `20_criteria/section-design-principles.md` (line 9), `.claude/skills/visual-design-spec/SKILL.md` (lines 5, 102) | documents (descriptive, web-mode-scoped) | no |
| `work/homepage/**` artifacts (page-brief.md, visual-design-spec.md, qc-report.md, sections/our-methodology/*) | documents (historical run records, accurate for web mode as-is) | no |

**Total: ~24 distinct files reference the four-role/critic-count contract; 11 are must-change or must-gain-a-new-decision-entry to stay internally consistent once Edit 1c lands.** None of the 11 must-change files is touched by the tier-C proposal — Wave 1 edits only `00_mandate/`, `CLAUDE.md`, `visual-design-spec/SKILL.md`, and `10_brand-system/README.md`; `pipeline/` (the audit's own named "authority of record for any structural change to the chain") is untouched. This gap is itself a blast-radius finding the proposal's own §1c note partially anticipates but does not close (it flags the coupling for `/risk-check`, it does not perform the amendment).

For Wave 2 (Edit 6, the hook — `not yet present`): the file it mirrors, `check-case-boundary.sh`, has no consumers in `axcion-design-studio` yet by definition (nothing enforces the confidentiality rule there today); its cross-repo sibling in `axcion-pitch-engine` is referenced by that project's own `CLAUDE.md` and `standards/confidentiality-rule.md` as the enforcement mechanism.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Edit 2 rewrites the always-loaded project `CLAUDE.md`'s PowerPoint line. Measured directly: current text = 52 words / 399 chars; proposed text = 113 words / 902 chars — a net addition of ≈126 tokens (chars/4) to a file that loads every turn of every session in this project. This sits inside the Medium band (50–150 tokens) but near its upper edge.
- Edit 1 (mandate) and Edit 3 (SKILL.md phase note) are not always-loaded — `00_mandate/design-studio-mandate.md` and the skill are read on demand, so their growth costs nothing per-turn.
- The two new critics (`pptx-bridge`, `copy-fidelity`) are net-new subagents but are not dispatched by anything yet (`deck-design-spec` does not exist) — zero ongoing dispatch cost until Phase 2's chain actually runs.
- Edit 6's git pre-commit hook runs outside Claude's context (invoked by `git commit` itself) and is silent on success (exit 0, no output) — negligible token cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json`/`settings.local.json` changes are proposed anywhere in this batch.
- `projects/axcion-design-studio/.claude/settings.json` already carries `defaultMode: bypassPermissions`, broad `allow` (`Bash(*)`, `Read`, `Edit`, `Write`, …), and explicit `Edit(**/.claude/**)`/`Write(**/.claude/**)` entries (confirmed by direct read) — so writing the new hook script under `.claude/hooks/` and creating the `.git/hooks/pre-commit` symlink via `Bash(*)` both already fall inside the existing permissive posture. No new capability class (external API, new cross-repo write target) is introduced.
- The `deny` list (`Bash(rm -rf *)`, `Bash(sudo *)`, brand-book write-deny) is untouched.

### Dimension 3: Blast Radius
**Risk:** High

- Grounded directly in the Step 1.5 inventory: ~24 files reference the four-role/critic-count contract; 11 are must-change to stay consistent with Edit 1c, and **zero of the 11** are touched by the proposed batch. This exceeds the rubric's "High — >5 dependent callers" threshold on its own.
- Edit 1c is a contract change (agent roster / critic count) that the repo's own prior audit (`audits/lean-repo-2026-07-05-playbook-fit.md:11`) names as requiring `pipeline/` to be the "authority of record" — a structural-change class, not a documentation tweak. The proposal amends the mandate/CLAUDE.md/SKILL.md/README layer but leaves the `pipeline/` layer (the actual authority) silent, so the change is not backwards-compatible with what `pipeline/`, `next-up.md`, `improvement-log.md`, `conversion-clarity-review.md`, and `web-refinement-playbook.md` currently assert.
- The Step 1.5 inventory surfaced a consumer the change description does not name: `CLAUDE.md`'s own opening line (line 3, "four-role team (1 creator + 3 critics)") is not touched by Edit 2, which only edits the PowerPoint bullet further down — a self-inconsistency inside the same file the batch is editing.
- Edit 6 also touches shared infrastructure in the sense that a pre-commit hook fires on every future commit in this repo (all workflows, all future sessions) — a smaller, separately-scoped instance of "shared infra touched in a way that affects multiple workflows."

### Dimension 4: Reversibility
**Risk:** High

- Wave 1's doctrine edits (Edits 1–5) are ordinary text edits to git-tracked files — `git revert` fully restores prior text with no residue. In isolation, Wave 1 alone would be Low–Medium.
- Wave 2 (Edit 6) is the driver of the High score: the hook script is git-tracked and revertible, but the registration mechanism is an **untracked symlink** at `.git/hooks/pre-commit`. Per the proposal's own text (verified against the mirrored script's header) — "a `git revert` alone leaves a dangling symlink git still executes, failing every subsequent commit." Removal requires two steps (`git rm` the script **and** `rm` the symlink), not one. This is exactly the rubric's "High — multi-step manual rollback required" case, and the failure mode (every later commit breaks) is worse than a no-op if missed.
- The mirror asymmetry also applies forward: a fresh clone of `axcion-design-studio` ships with **no guard at all** until the symlink is manually re-installed — an operator-memory dependency with no automated onboarding step proposed.

### Dimension 5: Hidden Coupling
**Risk:** High

- Edit 1c creates two doctrine sources that both claim authority over the same governed fact (critic count) and will disagree the moment Edit 1c lands: the mandate (`00_mandate/design-studio-mandate.md`, edited to say deck mode "adds two critics") vs. `pipeline/architecture.md` DD-A4 (untouched, still reading "the committed four-role shape... CLOSED... reopening needs a pack amendment," with no mode-scoping language). This is the rubric's "functional overlap with existing mechanisms... two systems will both try to handle the same concern" — here, two doctrine layers both governing "how many critics."
- Edit 4's new deck-grammar pointer table names `pptx-bridge` as a "Primary reader" for several brand chapters — an agent that does not exist yet (created only via a future `/create-skill` + manual agent authoring, per `pipeline/architecture.md` DD-A3's established pattern). A forward reference to a non-existent consumer, self-acknowledged as expected-until-build in the plan, but still an implicit dependency a future reader must resolve correctly.
- Edit 2's "ACTIVE, building" framing depends on future sessions correctly parsing a nuanced state (activated-but-unbuilt) rather than misreading "ACTIVE" as "proceed" — the exact word-collision root cause named in `logs/friction-log.md`'s 2026-07-08 incident (root cause #1). The proposal already adds explicit mitigating language ("The chain is **not yet built**..."), which meaningfully reduces but does not eliminate this coupling to careful reading rather than a hard technical gate.

### Dimension 6: Principle Alignment
**Risk:** High

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read directly; principles-base was available, no fallback needed).

- **DR-1 / DR-3 (placement / structural-change process) — the central, unmitigated finding.** `pipeline/` is the repo's own named "authority of record for any structural change to the chain" (`audits/lean-repo-2026-07-05-playbook-fit.md:11`), and its own prior entry for this *exact class* of change (`logs/improvement-log.md:13-23`, the parked `conversion-critic` promotion) prescribes: "Gate the promotion via `/risk-check` + `/contract-check` — not a CLAUDE.md one-liner," plus reconciliation of the full stale-consumer set. Edit 1c adds two critics via the mandate file alone; `pipeline/architecture.md` DD-A4, `technical-spec.md` DD-1, `project-plan.md`, and `context-pack.md` are not amended anywhere in this batch. The tier-C proposal's own §1c note concedes this ("This edit is exactly such an amendment and should be recorded as one — flagged for `/risk-check` as a coupling") but does not perform the amendment — it defers the judgment call to this gate rather than executing it in the authoritative location.
- **"Deck mode is a separate chain" — judged a plausible-but-thin rationalization, not a settled reading.** `pipeline/architecture.md` DD-A1 and DD-A7 do reserve that decks *might* need "a materially different chain" later — but that is a forward-looking architectural allowance, not a present ratification that the existing 1-creator-+-N-critics dispatch model is exempt from DD-A4's CLOSED shape merely because N changes for a second surface type. No document in `pipeline/` currently states that critic-count is scoped per-chain rather than per-Studio. The proposal's own hedged phrasing ("flagged... as a coupling" rather than "resolved because decks are a separate chain") reads as itself uncertain about this distinction.
- **Coherence check requested by the dispatch: parking `conversion-critic` while admitting `pptx-bridge`/`copy-fidelity` is not coherent as currently structured.** `20_criteria/conversion-clarity-review.md:9` and `logs/next-up.md:41` both hold a *web-mode* 4th critic parked specifically because the four-role shape is CLOSED pending a pack amendment. This batch adds two *deck-mode* critics without that amendment. If "different chain, different rule" is not itself a ratified `pipeline/` decision, then the same governance test is being applied unequally to two proposals of the same underlying kind (raising critic count beyond the closed three/four baseline).
- **OP-9 / DR-7 / AP-7 (speculative abstraction) — secondary, more mitigated tension.** The mandate widening, two new critics, and ~20–35 session build are activated with zero current consumer (no qualifying Pitch Engine brief exists; the trigger used is explicit operator instruction, the plan's own "second trigger"). This is *not* silent drift — it is recorded across three linked documents (activation plan, Step 0 revalidation, tier-C proposal) and paired with a genuine escape hatch (hand-build the first deck; system completion is explicitly not a precondition). This softens but does not remove the tension named by OP-9/DR-7/AP-7: infrastructure is being generalized (a second critic pair, a widened mandate) ahead of any real deck to test it against.
- **OP-5 (advisory vs. enforcement)** is not implicated — nothing in this batch moves an advisory mechanism toward auto-enforcement.
- Per the Dimension 6 special-handling rule: this is a High that does **not** meet the "loudly acknowledged, explicit recorded revision" bar in the authoritative venue (`pipeline/`) — the tension is flagged, not resolved — so it cannot be scored down to Medium.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Two categories of claim, both independently re-derived, not accepted on the caller's word:
  1. Edit 5's claim (activation-plan §9's "mirrors the Pitch Engine's own storage answer" is false) — directly re-read `projects/axcion-pitch-engine/standards/case-location.md`: confirmed live text is "**Status: OPEN — the location is not yet decided**" with an unfilled `{AUTHOR:}` placeholder. Defect observed directly.
  2. The CENTRAL RISK section's contract-collision claims — directly re-read `pipeline/architecture.md` (DD-A4), `pipeline/technical-spec.md` (DD-1), `logs/next-up.md:41`, `logs/improvement-log.md:17,23`, `20_criteria/conversion-clarity-review.md:9`, and `audits/lean-repo-2026-07-05-playbook-fit.md:11` — every quoted line in `CHANGE_DESCRIPTION` matches the live file verbatim (line numbers and wording both confirmed). Wave 2's factual claims (hook script exists, 6496 bytes; no `.claude/hooks/` dir; no `.git/hooks/pre-commit` in `axcion-design-studio`) were independently re-verified with `wc -c` and `ls` — both confirmed exactly as stated.
- **Consequence — traced or assumed?** Traced, not assumed. I independently grepped `pipeline/` and the doctrine tree and confirmed none of the 11 must-change consumer files are touched by the proposed edits — the collision is a directly observed omission (the amendment pipeline/ requires simply is not in this batch), not an inferred hypothetical failure.
- **Re-derivation vs. the change description:** None — all claims re-derived and confirmed. Every quote, byte count, file-existence check, and line-number citation in `CHANGE_DESCRIPTION` matched the live repository state exactly.
- **Not defect-justified — no premise to verify** for the overarching activation decision itself: Phase 2's activation is operator-directed (the plan's own "second trigger... explicit operator activation," not a discovered defect), so the base decision to activate carries no defect claim to verify. Risk: Low. The defect-justified sub-claims above (Edit 5, the contract-collision) were each verified rather than assumed, which is what keeps this dimension Low rather than High despite the change touching a live governance dispute — the dispute is real and accurately sourced, not invented.

## Recommended redesign

Dimension 6 is High and the principle tension (DR-1/DR-3, the CLOSED four-role contract) is flagged but not loudly, formally resolved in the authoritative venue (`pipeline/`) — per the Dimension 6 special-handling rule, this alone forces `RECONSIDER` and has no technical mitigation. Two paths, either is viable:

- **Rescope (preferred).** Split Edit 1c out of Wave 1. Land Edits 1a (minus the critic-count sentence)/1b/1d, Edit 2, Edit 3, Edit 4, and Edit 5 now — none of them touch the CLOSED four-role contract and each is individually Low–Medium risk. Defer the two new critics and the "four critics in deck mode" mandate language until a formal pack amendment lands in `pipeline/` (updating DD-A4 in `architecture.md`, DD-1 in `technical-spec.md`, `project-plan.md`, and `context-pack.md` to explicitly scope the CLOSED shape to the web-mode chain and ratify deck mode's own critic count as a separate, named architectural decision), reconciling the 11 must-change consumer files identified above in the same pass — via `/risk-check` + `/contract-check`, exactly as `logs/improvement-log.md`'s own 2026-07-05 entry prescribes for this class of change.
- **Or: make the revision loud (OP-11).** If the operator wants Edit 1c today, record an explicit, recorded decision in `pipeline/decisions.md` (or the equivalent authoritative pipeline record) that deck mode is a deliberately separate chain exempted from DD-A4's CLOSED shape — and reconcile the same 11 consumer files in that pass, not later. A mandate-file-only edit with the tension merely flagged in a footnote does not meet the "explicit, recorded evolution" bar this repo's own principles require.

Independent of the Dimension 6 path chosen: before landing Wave 2 (Edit 6), add the two-step removal runbook (`git rm` the script **and** `rm .git/hooks/pre-commit`) to `CLAUDE.md` or `logs/decisions.md` so a future revert does not leave a dangling symlink breaking every subsequent commit — this addresses the Dimension 4 High independent of the Dimension 6 gate.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
