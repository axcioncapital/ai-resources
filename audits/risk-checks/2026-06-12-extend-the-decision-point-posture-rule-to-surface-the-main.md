# Risk Check — 2026-06-12

## Change

Extend the Decision-Point Posture rule to surface the main rejected alternative for direction-setting/structural decisions. TWO files, ONE change set (paraphrase mirror pair, not a literal-string contract):

1. Workspace-root CLAUDE.md (L127), Decision-Point Posture section. Replace "State the choice made in one line inline." with "State the choice made in one line inline — and, for direction-setting or structural decisions, add the main alternative rejected in one more line."

2. ai-resources/docs/autonomy-rules.md (L30), Decision-Point Posture entry. Replace "State the choice in one line." with "State the choice in one line — and, for direction-setting or structural decisions, add the main alternative rejected in one more line."

Additive only: routine picks stay one line; only direction-setting/structural decisions also name the rejected alternative. No blocking gate, no new section, no "preview" framing, no Recommendation/Rationale-on-every-decision field. This is the LAND-MINIMAL residue of a rejected "Decision Preview Gate" proposal; already cleared by /consult, a System Owner pass (EXECUTES-LAND-MINIMAL), and /qc-pass (GO). Plan-time gate.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md — exists

## Verdict

GO

**Summary:** A two-line additive wording change to a paraphrased mirror-pair rule, with no literal-string contract, no callers requiring modification, clean git revert, and active alignment with the loud-decision principle (OP-3) — every dimension Low.

## Consumer Inventory

Search terms: `Decision-Point Posture` (heading), `decision-point` / `decision point` (phrase), `State the choice` (edited string), `rejected alternative` / `alternative rejected` (introduced concept). Grepped across `ai-resources/` and the workspace root one level up.

The vast majority of grep hits are logs, audit artifacts, prior risk-checks, and project-local drafts that *mention* "decision point" in historical or generic prose — these are not operational consumers of the rule and are excluded. The rule has exactly two **live-loaded definition sites** (the two files being edited). The operational consumers are the commands that reference the rule's *intent* to govern their own pick-and-proceed behavior.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md (L125–127) | co-edits (definition site 1) | yes |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md (L28–32) | co-edits (definition site 2) | yes |
| ai-resources/.claude/commands/explain.md (L25) | documents (cites "Autonomy Rules / Decision-Point Posture" to label silent decisions) | no |
| ai-resources/.claude/commands/contract-check.md (L79) | documents (cites Decision-Point Posture for emit-one-notice-and-continue) | no |
| ai-resources/.claude/commands/session-plan.md (L222) | documents (cites Decision-Point Posture for skip-QC-default) | no |
| ai-resources/.claude/commands/session-start.md (L269) | documents (cites Decision-Point Posture for downstream-catcher posture) | no |
| ai-resources/.claude/commands/fix-repo-issues.md (L173) | documents (cites repo decision-point posture for default-no-questions) | no |

Total: 7 consumers, 2 must-change (the two co-edited definition sites that constitute the change itself). The 5 command consumers all reference the rule's *behavioral intent* (pick recommended option, do not seek confirmation, surface the choice) — none parses the literal sentence "State the choice in one line," so the paraphrased wording extension does not break any of them. The change description's own framing ("paraphrase mirror pair, not a literal-string contract") is confirmed by the inventory: no consumer depends on the exact string.

No consumer was found that the change description failed to anticipate. `explain.md` (L25) is the consumer most adjacent to the new behavior — it already harvests "silent decisions" into a "What I decided" section; the new rejected-alternative line *complements* it (more decision context to surface) and creates no conflict.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Both edits land in always-loaded files (workspace CLAUDE.md is loaded every turn; autonomy-rules.md is a read-on-trigger doc, not always-loaded per its own header L3: "When to read this file: Before pausing or proceeding…"). Only the workspace CLAUDE.md edit carries per-turn token cost.
- The added text is a single appended clause: "— and, for direction-setting or structural decisions, add the main alternative rejected in one more line." That is ~18 words / roughly 25–30 tokens added to the always-loaded workspace CLAUDE.md (Decision-Point Posture, L127). Well under the ~50-token Medium threshold.
- No hook registered, no `@import` added, no subagent brief expanded, no skill with broad triggers. Pure in-place wording extension of an existing always-loaded sentence.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` touched. The change edits two markdown prose files only (verified: targets are CLAUDE.md L127 and autonomy-rules.md L30, both prose rule text).
- No `allow`/`ask` entry added, no `deny` rule removed or narrowed, no new tool-invocation pattern, no scope escalation. The change grants no new capability — it adds a reporting expectation to an already-permitted behavior (Claude already states its decision inline).

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: 7 consumers total, 2 must-change. The 2 must-change rows are the two co-edited definition sites that *are* the change — not downstream breakage.
- The 5 command consumers (`explain.md`, `contract-check.md`, `session-plan.md`, `session-start.md`, `fix-repo-issues.md`) all reference the rule by intent, not by literal string (verified at the cited lines). None parses "State the choice…", so none requires modification.
- No contract is changed in a parse-breaking way: there is no marker, heading, schema, or output token that callers parse. The change description explicitly disclaims a literal-string contract; the inventory confirms it (zero `parses` rows).
- The behavioral surface widens only additively: direction-setting/structural decisions now also name the rejected alternative. Routine picks are unchanged ("routine picks stay one line"). No caller's existing behavior is invalidated.
- Both edits sit below 5 dependent callers requiring change (zero do), no non-backwards-compatible contract change → Low.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are single-line, in-place prose replacements in two tracked files. `git revert` (or a manual re-edit) fully restores the prior wording within the same working tree.
- No sibling files or directories created (the risk-check report itself is a separate audit artifact, not part of the change). No data/log mutation, no append-only log entry, no `settings.json` cached state. No state propagates beyond git — no push required to land, no external write, no automation fires.
- Worst-case rollback is a one-step git revert with no manual cleanup. The only "muscle-memory" residue is that Claude may have named a rejected alternative in a few decisions before revert — harmless and self-correcting, not a stateful artifact.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change is self-contained: it adds a reporting clause to a rule whose meaning is fully stated at the change site. It introduces no parse marker, no filename convention, no YAML key, no output-format contract that callers must honor.
- The two definition sites are a deliberate, recognized duplication (workspace CLAUDE.md = always-loaded summary; autonomy-rules.md = read-on-trigger detail) — the DR-5 intentional-duplication exception. The mirror pair is paraphrased, not byte-identical, which the change description states explicitly. There is no hidden assumption that the two strings match character-for-character; the inventory found no consumer that joins them.
- No auto-firing in unexpected contexts: the rule is advisory text read by the main session, not a hook or trigger. No functional overlap with an existing mechanism — `explain.md`'s "What I decided" section consumes decision context but does not duplicate or contend with the rule.
- One mild implicit dependency: the term "direction-setting or structural decisions" is a judgment boundary the model must interpret consistently across both files. It rests on the established repo convention of "structural change classes" (autonomy-rules.md L19, `/risk-check` change classes) — a documented convention, not a silent one. This is at most a single established-convention dependency, which keeps the dimension Low (and is the kind the QC → Triage downstream loop catches if mis-scoped).

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read successfully at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).
- **OP-3 (loud failure / loud decisions) and OP-11 (surface, don't drift):** the change actively *serves* these. Naming the rejected alternative makes a load-bearing decision more visible rather than letting the road-not-taken stay silent — this is the loud-decision direction, not against it.
- **OP-9 / DR-7 / AP-7 (speculative abstraction):** not triggered. The change builds no infrastructure, no hook, and no generalization for an absent consumer. It extends an existing rule's reporting expectation; it does not generalize a mechanism ahead of a second consumer. The Step 1.5 inventory shows the change adds no new contract with zero consumers — it adds no contract at all.
- **OP-5 (advisory vs enforcement):** not triggered. The change stays firmly advisory — "additive only… No blocking gate." It explicitly does NOT move the rule toward enforcement; it is described as the LAND-MINIMAL residue of a *rejected* "Decision Preview Gate" (the enforcement-flavored version was already discarded upstream). This is the advisory-preserving choice.
- **OP-2 / AP-4 (automate execution, gate judgment / no rubber-stamp):** not triggered. No judgment gate is added or removed; pick-and-proceed autonomy is preserved ("routine picks stay one line", no confirmation introduced).
- **DR-1 / DR-3 (placement):** correct. The rule lives in workspace CLAUDE.md (always-loaded summary) + autonomy-rules.md (canonical detail doc) — its existing, correct homes. No tier or home is changed.
- **OP-10 (system boundary):** not touched — the change is internal to Claude Code's decision-reporting, no cross-tool reach.
- Net: the change is consistent with, and on OP-3/OP-11 actively advances, the operating principles. Low.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: verbatim target strings confirmed at CLAUDE.md L127 and autonomy-rules.md L30 (read directly); consumer inventory built from grep across `ai-resources/` and the workspace root with each operational consumer's cited line read or quoted; principle checks cite frozen IDs from the principles-base index (read successfully). No training-data fallback was used on any read.
