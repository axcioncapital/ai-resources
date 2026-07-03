---
model: sonnet
---

Run an independent refinement pass on the work you just produced.

## Why a subagent?

You produced the work — you're anchored to your own phrasing and structure. The refinement reviewer runs as a separate agent with fresh eyes, no knowledge of your drafting process.

## Steps

1. **Identify the artifact.** State in one line what you are refining.

2. **Prepare the handoff.** Gather:
   - One-line description of the artifact
   - The file path(s) of the artifact, or the content if it hasn't been written to file yet
   - The intended audience (e.g., "another Claude instance", "a human operator", "a technical team")

3. **Launch the `refinement-reviewer` subagent.** Pass it the three items above. Do NOT pass conversation history, your reasoning, or creation context.

3a. **Project-session spawn fallback (added 2026-07-03).** If the `refinement-reviewer` agent *type* fails to resolve at spawn (project session — `--add-dir` registers files, not agent types), do not abort: resolve `ai-resources/` by ancestor walk-up, read `{AI_RES}/.claude/agents/refinement-reviewer.md`, strip the YAML frontmatter, and launch a `general-purpose` subagent with that body inlined plus the same three items — **explicitly re-asserting `model: opus` on the spawn** (the fallback must not silently drop the reviewer to the session model). Note `(fallback: general-purpose, opus re-asserted)` next to the refinement verdict.

4. **Present the results.** Show the subagent's review to the operator exactly as returned. Do not filter or soften findings.

5. **Wait for direction.** The operator decides which refinements to apply.
