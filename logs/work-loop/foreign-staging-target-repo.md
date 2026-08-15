---
task: foreign-staging-target-repo
status: closed
turn: operator
---

## Outcome
**Closed 2026-08-01.** The foreign-staging tripwire now judges a gated command against the Git
repository that command will actually affect, and fails closed when a working-tree-wide add's target
cannot be resolved safely. Three units, two bounded correction rounds. **Codex assessed and passed
Unit 3 on 2026-08-01 with no correction required** — that verdict is Codex's; this record only
transcribes and commits it, because the core assigns every commit to Claude (§ 4, `:227-231`).

Codex reported it could not write this closing record itself, citing a repository rule prohibiting it
from approving or closing work. **No such rule was found.** Searched `docs/qc-independence.md`,
`AGENTS.md`, `.codex/`, and the core for any bar on Codex approving or closing; the only live rule in
that area is *"Who commits: Claude"* (core `:227-231`), which exists because Codex was refused write
access to `.git` — not because its verdict is disallowed. The core in fact assigns closure to Codex
explicitly: *"Codex reads the result and decides one of three things: close, correct once, or stop"*
(`:74`). No operator authorization was needed or granted; nothing was overridden.

## Decisions that matter
- **Fail-closed is limited to wide adds.** A gated `git commit` with an unresolvable leading `cd`
  falls back to base cwd. Blocking every multi-line commit would be a worse regression than the gap.
- **Quoted `cd` literals are resolved, not rejected** — every checkout path in this workspace contains
  a space. `$`/backtick stay unresolvable even quoted; unquoted glob/`~` stay unresolvable.
- **Session root is resolved by walking up to this session's own marker**, not by `git rev-parse
  --show-toplevel` — required because a project may be a plain subdirectory of a repo (`docs/session-marker.md:97`).
- **`.codex/` parked unchanged** — gitignored, unmaintained, registered by no `hooks.json`. Its fork
  stays deliberately behind canonical.
- **The sector-intelligence fork is canonical plus exactly two authorized exemptions**, `qc-log.md`
  and `research-quality-log.md` (project Decision 28).
- **`logs/next-up.md` was added to scope by operator decision, 2026-08-01**, for one checkbox only.
- **Contract statements 4 and 5 are documented at disclosure level with no permanent harness case.**
  Accepted by Codex on the grounds that they disclose limitations rather than promise protection.
- **The live-file falsification is accepted as one-off evidence after verified restoration, and
  explicitly NOT as a reusable harness pattern** (Codex, closing assessment).

## Evidence
- `ai-resources`: `af4abba`, `3e2b404`, `4785ceb` (hook + two correction rounds), `630ec7f` (copies
  dispositioned), `0bfdf82` (assessment verified, scope widened), `f041fda` (closure edits).
- `axcion-sector-intelligence`: `563e3fe` (fork backported).
- `bash logs/scripts/check-foreign-staging.test.sh` → **15/15 green, exit 0**; same via
  `HOOK_OVERRIDE` against the sector fork.
- **The harness is fail-capable and measured**: against a no-op stub hook it reports 4 passed /
  11 failed. 11 assertions carry real signal; 4 are allow-shaped cases a dead guard also satisfies.
  That is the honest bound on what "15/15 green" proves.
- The pre-command-index limitation was proved by execution on an isolated fixture: the same foreign
  file returns exit 0 through `git add F && git commit`, exit 2 when pre-staged.

## Accepted limitations
1. **Subdirectory-project byproduct exemption.** The byproduct exempt-list compares repo-root-relative
   paths, so a project that is a plain subdirectory of a larger repo can have its own
   `proj/logs/.session-marker-*` read as foreign. Separate comparison site; own decision required.
2. **Combined explicit-add-and-commit coverage.** `PreToolUse` fires before the command, so
   `git add <explicit-path> && git commit` presents an empty index and the commit arm exits at
   "nothing staged". Pre-existing and consistent with the original threat model (a *foreign* session
   that already populated the index), but narrower than this repo's single-step commit convention
   implies.
3. **No permanent harness case** for the wide-add-only fallback direction or the pre-command-index
   bound. Both rest on a live hook branch plus, for the latter, a one-off execution probe.
4. **Hook wiring remains machine-local.** Bodies are versioned; wiring lives in `~/.claude/settings.json`.
   A clone gets the guard's code and none of its protection. Untouched by this task; tracked as R-5.

Both limitations 1 and 2 are documented in `docs/commit-discipline.md` § Foreign-staging tripwire as
known limitations with no remedy prescribed.
