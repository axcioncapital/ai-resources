# Session Plan — 2026-08-01

## Intent
Investigate Codex-side resource packaging by inspection of primary sources, and commit a short cited findings note.

## Model
opus — match (active session model is Opus 5, 1M context; the hard part is judging what counts as inspected fact vs. inference, not executing a defined process).

## Source Material

Governing docs (authority order per `plans/work-loop-v2-mvp/README.md`):
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/README.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` (AUTHORITATIVE — scope)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md` (Step 1 definition, lines 59–67)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md` (how the note is written)

Codex install surfaces — all verified present on this machine 2026-08-01:
- `/usr/local/bin/codex` — Codex CLI binary, on PATH
- `~/.codex/config.toml` — Codex configuration
- `~/.codex/skills/` — 22 entries; the user-level Codex resource directory
- `~/.codex/plugins/`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/` — repo-side Codex resources, 5 present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop/SKILL.md` — the existing v1 Codex-side resource, i.e. a working installed example
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/AGENTS.md` — repo-level Codex instruction file; 8+ sibling copies exist under `projects/`

Comparison reference (v1 shared contract, read-only, not under change):
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop.md`

## Findings / Items to Address

The Playbook (`pocock-lifecycle-work-loop-mvp-v0.4.md:59–67`) defines Step 1 as four questions answered **by inspection**, plus one prohibition. Each becomes a section of the note:

1. **How is a Codex-side resource installed?** — Where does a resource have to live to be found: `~/.codex/skills/` (user level) vs. repo-level `.agents/skills/` vs. `AGENTS.md`. Determine which of these Codex actually reads, and by what precedence. Source anchor: Playbook `:63`.
2. **How is it invoked?** — By name, by slash command, by model choice, or by instruction-file reference. Determine what triggers loading. Source anchor: Playbook `:63`.
3. **How does it read and write repository files?** — Which working directory it resolves against, whether writes are direct or sandboxed, and whether committing is available to it. This is the question the whole v2 transport seam depends on (Step 2 prototypes exactly this round trip). Source anchor: Playbook `:63`, and Proposal § on the repository-based transport.
4. **Format or size constraints?** — Frontmatter schema, required fields, file naming, any length limit. Source anchor: Playbook `:63`.
5. **Prohibition (must be honoured, not investigated):** do not investigate Claude Code command conventions — the repository answers repository questions at implementation time. Source anchor: Playbook `:65`.
6. **Exit standard:** "the note exists and nothing about the Codex side is guessed" — Playbook `:67`. Anything not establishable by inspection is written as a named open gap for the operator to confirm inside the Codex app, never as an assertion.

## Execution Sequence

1. **Read the two governing docs that bound this step** — Playbook `:59–67` (already read) and the Proposal's scope sections, to confirm nothing in Step 1 has been misread. *Verify:* the four questions and the prohibition above match the Playbook verbatim.
2. **Read the skill-writing standard** — it is binding on how this note is written. *Verify:* the note's shape is chosen from that standard, not invented.
3. **Inspect the installed v1 Codex resource** — `.agents/skills/work-loop/SKILL.md` frontmatter and body, plus the four sibling resources in `.agents/skills/`, and `AGENTS.md`. This is working installed evidence, not documentation. *Verify:* frontmatter fields recorded verbatim; commonality across the 5 resources noted rather than generalised from one.
4. **Inspect the user-level surface** — `~/.codex/skills/` structure and `~/.codex/config.toml`. *Verify:* record what the config actually declares about resource discovery; quote it. Do not infer precedence between user-level and repo-level from folder existence alone.
5. **Probe the CLI for authoritative answers** — `codex --help` and any resource/skill subcommand help it exposes. *Verify:* every claim traced to command output, quoted in the note.
6. **Consult Codex primary documentation** for anything steps 3–5 leave genuinely undetermined, especially file I/O and commit behaviour. *Verify:* cited by URL and date-accessed; documentation never overrides what was observed locally — where they disagree, the note records both.
7. **Write the note** to `plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md`: one section per question, each claim carrying its source, plus an explicit `## Open gaps` section for anything only answerable from inside the Codex app. *Verify:* every claim has a source; no section is answered from recall.
8. **Commit.** *Verify:* the file is on disk and committed. Do not push (batched to wrap).

## Scope Alternatives

- **Recommended (this plan):** answer all four questions to the depth local inspection allows, name the residue as open gaps, commit one note.
- **Narrower:** question 3 (repository file I/O) only, since Step 2's transport prototype depends on it alone. Rejected — the Playbook makes all four the exit condition, and the other three are cheap once the surfaces are open.
- **Wider:** run a live Codex invocation to observe read/write behaviour empirically. Deliberately deferred — that is Step 2's prototype, and doing it here would collapse two steps and start building.

## Autonomy Posture

Full autonomy. The work is additive (one new file), the scope is fixed by the Playbook, and the exit condition is observable.

**Stop points:**
- If inspection contradicts a premise the Proposal's transport design rests on (e.g. Codex cannot write repository files the way the round trip assumes), surface it and stop — do not redesign the transport. That is a Proposal-level change and the Proposal is authoritative.
- If a question is answerable only from inside the Codex app UI, record it under `## Open gaps` and continue with the rest. Not a halt.

## Risk

No structural change classes apparent — the session creates one plan-artifact markdown file under `plans/` and changes no command, skill, agent, hook, symlink, settings file or CLAUDE.md. Re-size the review if scope changes.

Environment-fit check: not applicable — the work product is a document, not an executable or launcher.

Standing hazard for this session specifically: the failure mode most logged in this repo is asserting a repo or tool fact from recall instead of checking it. This session's entire output is such facts, so every claim in the note is either quoted from an inspected artifact or filed as an open gap.
