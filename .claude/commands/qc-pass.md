---
model: sonnet
---

Stop and run an independent QC pass on the work you just produced or proposed.

## Why a subagent?

You produced the work — you cannot objectively evaluate it. The QC reviewer runs as a separate agent with no access to your conversation, ensuring independent assessment per the QC Independence Rule.

## Steps

1. **Identify the artifact.** State in one line what you are QC'ing (a plan, a drafted file, an edit, a set of changes).

2. **Prepare the handoff.** Gather:
   - One-line description of the artifact
   - The file path(s) of the artifact, or the content if it hasn't been written to file yet
   - The original operator request (what was asked for — quote or paraphrase)
   - **Scope / artifact purpose** — one line stating what this artifact is supposed to be or do. Derive from the artifact itself + the last operator turn. This is distinct from the request: the request says "what the operator asked," scope says "what the artifact's job is." If you cannot derive confidently, state your best guess and mark it `(derived — please confirm)`.
     - **Plan-mandated-additions carve-out.** If the artifact intentionally adds, modifies, or removes content because the approved plan or mandate explicitly called for it (e.g., contradiction fixes, required new sections), say so in the scope line — e.g. "preserve existing content verbatim *except* the plan-mandated edits to X." A bare "preserve verbatim" handoff makes the reviewer read every authorized change as a violation and issue a false REVISE. Verbatim-purity applies to content the operator did NOT authorize, not to additions the plan required.

3. **Launch the `qc-reviewer` subagent.** Pass it the four items above. Do NOT pass conversation history, your reasoning, or creation context. If the artifact is a substitution-shaped edit to a repo-infrastructure file (settings, command/agent definitions, SKILL.md, CLAUDE.md, hooks, prompts, analogous infra) — e.g., a string/typo fix, value edit, permission entry, path/key rename, reference update, or small wording correction — add `mechanical-mode: suggested` to the handoff. Do NOT add the hint when the artifact is a new file, introduces new sections/steps/rules, or involves structural reorganization or multi-paragraph prose rewrites. When in doubt, omit the hint and let the reviewer decide.

3b. **Project-session spawn fallback (added 2026-07-03).** If the `qc-reviewer` agent *type* fails to resolve at spawn (distinct from 3a's credit failure) — the known failure mode when this command runs from a project session, because `--add-dir` grants file access but does not register agent types — do not abort and do not fall back to self-QC. Resolve `ai-resources/` by ancestor walk-up, read `{AI_RES}/.claude/agents/qc-reviewer.md`, strip the YAML frontmatter, and launch a `general-purpose` subagent with that definition body inlined as its instructions plus the same handoff items — **explicitly re-asserting `model: opus` on the spawn** (`general-purpose` does not inherit the definition's tier; the fallback must not silently degrade the reviewer to the session model). Note `(fallback: general-purpose, opus re-asserted)` next to the QC verdict.

3a. **If the dispatch fails with "Usage credits required for 1M context".** The subagent cannot spawn — the 1M-context gate, common in a long `[1m]` session whose conversation already exceeds 200k tokens (a `/model` downgrade can no longer fit it). Do NOT silently proceed. Apply `ai-resources/docs/qc-independence.md` § When the reviewer cannot be reached: run inline self-review against the same rubric, **surface the degradation in chat**, and record the result as `unassessed` — never as passed. There is no commit-block and no deferred-session requirement; an `unassessed` record is visible, and the operator decides whether that is acceptable for this change. Prevention is better: switch to a standard-context model via `/model` before the review, not after it fails.

4. **Present the results.** Show the subagent's review to the operator exactly as returned. Do not filter or soften findings.

4a. **Confirm scope visibility.** The subagent's output includes the scope line it QC'd against in the header. If the operator disagrees with the scope as stated, they will re-invoke /qc-pass with a corrected scope; do not attempt to self-correct.

5. **Wait for direction.** The operator decides whether to act on findings.
