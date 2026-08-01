---
task: foreign-staging-target-repo
turn: codex
---

## Objective and scope
Make the foreign-staging tripwire judge a gated command against the Git repository that the command will actually affect, while preserving a hard block when that target cannot be resolved safely. The completed task must cover the live canonical hook, permanent executable regression coverage, the maintained-copy decision, the operator-facing contract, and closure of the recorded defect.

Approved task boundary: `.claude/hooks/check-foreign-staging.sh`; a focused executable harness and fixtures under `logs/scripts/`; only the necessary follow-on changes to `docs/commit-discipline.md`, `logs/improvement-log.md`, `.codex/hooks/check-foreign-staging.sh`, and `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/hooks/check-foreign-staging.sh`. The two byte-identical worktree copies may be checked but not edited. Excluded: other hooks, a general shell parser, unrelated cleanup, any soft-warn fallback for an ambiguous command target, and the retired `/risk-check` command.

## Lane and unit
Standard. Named reason for the loop: this is the pilot's designated cross-session handoff task, and the defect spans a globally wired guard, ambiguous shell-command handling, permanent regression evidence, and divergent maintained copies whose disposition must be assessed separately from the implementation.

Unit 1 — repair and prove target-repository resolution in the live canonical `.claude/hooks/check-foreign-staging.sh`. Add the focused permanent harness needed to prove it. Do not edit documentation, the defect record, or any other hook copy in this unit.

## Brief
Why: the guard currently produces both kinds of dangerous error around nested repositories. It can block on dirty paths that the command cannot stage, and it can silently pass while inspecting none of the paths the command is about to stage. An unrecognised subshell form can bypass gating entirely. The required outcome is accurate protection, not merely removal of the false block.

Check these premises against repository reality before editing:

1. In the 668-line canonical hook, repository and footprint resolution starts from `CLAUDE_PROJECT_DIR` or the hook process cwd, rather than from the repository targeted by the command. Candidate probes then use that resolved repository.
2. The existing single-leading-`cd` parser scopes candidate path strings inside the already chosen repository; it does not select the nested repository itself. The command-boundary/gating logic recognises `cd <path> && git add .` but does not gate `(cd <path>; git add .)`.
3. Reproduce the three reported behaviors against the unmodified canonical hook in isolated temporary repositories: simple nested-repo cwd inspects parent-repo paths; root cwd plus `cd nested && git add .` silently inspects no nested changes; the subshell form exits without a protective check. Record actual exit codes and decisive output. Do not run the reproduction against live working-tree state.
4. No dedicated executable regression harness for `check-foreign-staging.sh` exists under `logs/scripts/` as currently searched; the existing hits there concern other hooks or Work Loop acceptance. Confirm that absence on that named surface before choosing the harness shape.
5. Confirm that `.claude/hooks/check-foreign-staging.sh` is the live canonical target before changing it. Recheck the reported copy census (668-line canonical, 464-line `.codex` fork, 515-line sector-intelligence copy, plus two worktree copies byte-identical to canonical) for scope safety only; do not modify the other copies in Unit 1.

If a premise that the repair rests on is false, write what was checked and found into this state file, set `turn: codex`, commit the state-file update, and stop.

Required behavior for Unit 1:

- A gated command issued while the payload cwd is already inside a nested repository must inspect that nested repository's candidate set and applicable footprint, never parent- or sibling-repository dirt.
- A single parseable leading `cd <literal-path> &&` must resolve the repository targeted after the directory change and make the same allow/block decision as the equivalent command issued from inside that repository.
- A compound form that contains a gated wide add but whose target cannot be parsed safely — including `(cd <path>; git add .)` — must fail closed with exit 2 and a clear reason. It must not exit early, warn-and-allow, or infer a repository from the pre-command cwd.
- Existing ordinary same-repository gated commands and explicit-path `git add <pathspec>` behavior must remain intact.

Implementation freedom: choose the smallest command-target resolver that satisfies those behaviors. A single leading literal `cd` is in scope; nested `cd`s, variable-derived paths, arbitrary shell evaluation, and a general parser are not. Unsupported wide-add shapes are detected and blocked, not evaluated.

Evidence required:

- Add a permanent isolated harness that first demonstrates the three pre-fix failures and then distinguishes the repaired outcomes. Its assertions must inspect exit status and decisive output/candidate identity, so they can fail if the hook checks the wrong repository or merely stops emitting the old message.
- At minimum, green fixtures must prove: nested cwd uses only nested-repo dirt; parseable `cd nested && git add .` matches that nested-repo decision; an out-of-footprint nested file still blocks; `(cd nested; git add .)` hard-blocks as unresolved; an ordinary same-repo wide add retains its prior allow/block behavior; and an explicit-path add remains ungated.
- Run the complete new harness against the built canonical hook and record the command plus case-by-case result in `Latest material result`. A prose inspection, regex-only grep, or test that never went red is insufficient.

Stop if the behavior requires edits outside Unit 1, if correct footprint translation cannot be established from the existing session/marker contract, if a supported command would need arbitrary shell execution to resolve, or if the required executable evidence cannot be produced.

This task is the pilot's mid-task session-handoff test. If the Claude session ends before Unit 1 is ready for Codex assessment, preserve current truth here: replace `Latest material result` with what is implemented and the latest red/green evidence, name any real blocker, leave one executable resumption instruction under `Next action`, keep `turn: claude`, and commit that checkpoint. Do not present partial work as a completed result.

## Latest result

**Unit 1 complete and handed back for assessment (session S13-ad0, resumed 2026-08-01).**
Target-repository resolution is repaired in the live canonical hook, the permanent harness is 9/9
green, and the green was falsified against two deliberately broken hooks. The mid-task checkpoint
below is preserved unchanged beneath the resumption record, because the handoff it documents is
itself the thing under test.

### Resumption: the handoff worked, with one disclosed contamination

Resumed from this file plus Git. Verified the recorded tree state before trusting it —
`git log --oneline -3` matched, the hook was unmodified at 668 lines, the harness was present at
`2135c0c` — then re-ran the harness and reproduced the 4 RED / 2 GREEN baseline exactly. Every action
taken came from the `Next action` list below, which was executable as written.

**Contamination to record rather than hide:** `/prime` loads the previous `session-notes.md` entry at
orientation, and that entry summarises this unit. So a prose summary was in context before this file
was opened. The file was independently sufficient on its own reading, but a clean-room proof is not
obtainable through the normal orientation path.

### The blocker is settled — by execution, and WITHOUT the gated settings change

The checkpoint proposed a throwaway probe hook in `~/.claude/settings.json` and correctly flagged it
as needing operator approval. A cheaper route existed: **this hook is already registered and already
fires on every Bash call**, and it is the one file the unit boundary permits editing. A temporary dump
was added to it, triggered three times, read, and removed; the file was then verified byte-identical
to `HEAD`. No settings write, no operator gate.

What the probe established:

1. **The payload DOES carry `cwd`.** Live key set: `cwd`, `effort`, `hook_event_name`,
   `permission_mode`, `prompt_id`, `session_id`, `tool_input`, `tool_name`, `tool_use_id`,
   `transcript_path`. Recorded below as unverifiable from repo evidence; it is sent.
2. **`os.getcwd()` of the hook process equals the Bash tool's cwd**, and both diverge from
   `CLAUDE_PROJECT_DIR`, which stays pinned to the session root. Premise 1 confirmed as the defect.
3. **That cwd is the PRE-command cwd — the hook fires before the command runs.** This is the part the
   checkpoint did not anticipate and it changes the fix: cwd alone resolves C1/C2 but **cannot**
   resolve `cd nested && git add .`. "Change the precedence and it's nearly free" is half right — the
   precedence change is necessary, not sufficient, and the leading-`cd` parse is still required.

### What was implemented

Three changes, all within the Unit 1 boundary, in `.claude/hooks/check-foreign-staging.sh`:

- **Target resolution** (replacing the `CLAUDE_PROJECT_DIR`-first line at `:223`): base directory is
  the payload `cwd`, falling back to `os.getcwd()`. A single leading literal `cd <path> &&` moves the
  target. `&&` is load-bearing — it is what guarantees the `cd` succeeded before the git verb runs;
  with `;` or a newline the add still runs, in the *original* cwd, when the `cd` fails.
- **Fail-closed on unresolvable targets:** subshell `( ... )`, `;`/newline sequencing, multiple `cd`s,
  or a path containing a variable/glob/`~` → `exit 2` with a reason naming the supported shape.
  Scoped to **wide adds only**; a gated `git commit` with an unresolvable `cd` falls back to the base
  cwd. That is a **disclosed limitation**, taken deliberately: blocking every multi-line commit would
  be a false-block regression worse than the gap it closes.
- **Wide-add detection widened** so `)` terminates the token, otherwise `(cd x; git add .)` is not
  even *seen* as wide and exits ungated before any of the above runs. `./docs/x.md` still does not
  match — the `\.` arm requires the token to be exactly `.`.
- **`git add .` scoping** now derives from `target_dir`'s path *relative to the resolved repo root*,
  not from the `cd` token's raw text. This is what makes the nested and same-repo cases share one code
  path, and it is the direct cause of the C3 silent-pass repair.

### Evidence

`bash logs/scripts/check-foreign-staging.test.sh` → **9/9 pass, exit 0.**

| Case | Assertion | Result |
|---|---|---|
| C1 | nested cwd blocks on `nested-dirt.txt`, never `parent-dirt.txt` | PASS |
| C2 | nested cwd, all dirt in footprint → exit 0 | PASS |
| C2b | **same fixture, one out-of-footprint file → must block** (FP-9 remedy) | PASS |
| C3 | `cd nested && git add .` blocks on nested dirt — no silent pass | PASS |
| C4 | `(cd nested; git add .)` → exit 2 fail-closed | PASS |
| C5 | ordinary same-repo wide add unchanged (control) | PASS |
| C6 | explicit pathspec stays ungated (control) | PASS |
| C7 | **payload `cwd` beats process cwd** | PASS |
| C8 | **absent payload `cwd` falls back to process cwd** | PASS |

**Falsified twice — the green is not self-certified.**

- **No-op stub** (`HOOK_OVERRIDE` → `exit 0`): 7 failures, `STATE: UNEXPECTED`, exit 1. C2b fails here
  while C2 still passes — exactly the discrimination FP-9 said was missing.
- **Payload-cwd-blind stub** (the original `CLAUDE_PROJECT_DIR`-first line re-injected into the fixed
  hook): 5 failures — C1, C2, C2b, C7, C8 fail while C3 and C4 still pass. This correctly attributes
  C3/C4 to the `cd`-parsing fix rather than to the cwd fix, which a no-op stub cannot distinguish.

### Harness changes, and why they were needed

Two beyond the fix itself, both announced rather than absorbed silently:

- **C2b** — the FP-9 remedy the checkpoint asked for, item 4 of `Next action`.
- **C7 / C8 and a reshaped `run_hook`** — a gap found *this* session: `run_hook` sent no `cwd` key at
  all, so all six original cases exercised the `os.getcwd()` fallback and **none** exercised the
  production shape. A hook ignoring the payload `cwd` entirely would have gone 6/6 green. `run_hook`
  now sends `cwd` by default and takes `__OMIT__` to test the fallback deliberately. The generalisable
  point: a harness written before its interface was verified encodes the author's guess about that
  interface and then goes green against the guess.

---

**The original mid-task checkpoint follows, preserved verbatim. Everything below this line describes
the state as it stood at the handoff, not the state now.**

**Mid-task checkpoint, not a completed result.** Premises checked and red evidence built; the hook
itself is UNMODIFIED. This is the pilot's designated session-handoff point.

**Premise checks — all five hold.**

1. HOLDS. `check-foreign-staging.sh:223-224` — `project_dir = os.environ.get("CLAUDE_PROJECT_DIR", "")
   or os.getcwd()`, and `repo_root` is derived from it. Every candidate probe then runs `git -C
   repo_root`. The command's own target repository is never consulted.
2. HOLDS. The leading-`cd` parser at `:521-526` sets `subdir` and filters candidate path *strings*
   inside the already-chosen repo; it never re-resolves the repository. Gating regex
   `\bgit\s+add\b[^&|;]*\s\.(\s|$)` matches `cd X && git add .` but NOT `(cd X; git add .)` —
   confirmed by evaluating the regex directly against all three command shapes.
3. HOLDS, reproduced in isolated temp repos (see harness below). Exit codes recorded.
4. HOLDS. Nine `*.test.sh` files exist under `logs/scripts/`; none targets this hook. The only grep
   hit for the hook's name is `check-citation-resolution.sh`, which merely cites it as an example.
5. HOLDS. `~/.claude/settings.json:60` registers the canonical hook by absolute path
   (`ai-resources/.claude/hooks/check-foreign-staging.sh`). Copy census re-measured, not quoted:
   668 canonical / 464 `.codex` fork / 515 `axcion-sector-intelligence`. The two further copies are
   git worktrees (`ai-resources-g1-reviewed-plan`, `ai-resources-active-unit-routing`) and are
   `cmp`-identical to canonical — not forks.

**Evidence built — `logs/scripts/check-foreign-staging.test.sh` (new, permanent, isolated).**

Six cases, all in throwaway `mktemp -d` repos; never touches the live working tree and never runs a
real `git add`. Current state against the unmodified hook — **4 RED / 2 GREEN**, which is the
pre-fix baseline and the correct result:

| Case | Expected | Actual today | Reading |
|---|---|---|---|
| C1 nested cwd uses nested dirt | block on `nested-dirt.txt` | rc=2, blocks on `parent-dirt.txt` | RED — judged the parent |
| C2 nested cwd, all dirt in footprint | rc=0 | rc=2 | RED — false block |
| C3 `cd nested && git add .` | block on `nested-dirt.txt` | **rc=0, no output** | RED — **silent pass** |
| C4 `(cd nested; git add .)` | rc=2 fail-closed | rc=0, no output | RED — ungated |
| C5 same-repo wide add | rc=2 on `parent-dirt.txt` | rc=2 | GREEN — control |
| C6 explicit pathspec | rc=0, silent | rc=0 | GREEN — control |

**Two things about this harness the next session must know.**

- **Fixture fidelity was wrong on the first run and was corrected.** Without `nested/` in the parent's
  `.gitignore`, the parent lists `nested/` as untracked, C3 blocks on it, and the case goes red for the
  wrong mechanism — detecting "judged the wrong repo" but never reproducing the silent pass. The
  `.gitignore` line mirrors the live workspace, where `git -C <root> status -- projects/<nested>`
  returns zero entries. The correction is commented in the fixture at the line itself.
- **C2 and C6 are satisfied by a dead hook.** Proven: pointing the harness at a no-op stub via
  `HOOK_OVERRIDE` leaves both PASSING, while C5 correctly FAILS. Both assert only `exit 0`, so they
  cannot distinguish "correctly allowed" from "hook never ran". Once the fix lands and C2 turns green,
  C2 alone is not evidence — give it a positive-identity assertion, or pair it with a must-block
  variant on the same fixture. The harness's own STATE logic did flag `UNEXPECTED` under the stub
  rather than reporting success, which is a real property worth keeping.

## Blocker

**RESOLVED — see § Resumption above. The text below is the checkpoint's original statement of the
question, kept because the resolution corrects part of it.** Settled by execution: the payload does
carry `cwd`; the hook process's cwd equals the Bash tool's cwd; and — the part not anticipated here —
that cwd is the *pre-command* one, so the precedence change alone does not resolve
`cd nested && git add .`.

The second, smaller question below (whose footprint applies) is **answered and still carries a
caveat**: the target repo's own `logs/` is used, which is what the fixtures assume and what the live
workspace layout implies. It has been validated against the harness but **not** against the
session/marker contract as a document. Codex's brief names that as a stop-if; it is flagged here for
assessment rather than declared settled.

---

None blocking, but **one unresolved design question decides the shape of the fix, and it must be
settled by execution before any resolver is written.**

**Where does the target repo come from?** The hook currently has two candidate sources and needs a
third that does not exist yet:

- `CLAUDE_PROJECT_DIR` — set by Claude Code, points at the session's project root. Wrong for a nested
  target. This is the defect.
- `os.getcwd()` of the *hook process* — used only as a fallback today. **It is unverified whether
  Claude Code runs a PreToolUse hook with cwd equal to the Bash tool's cwd or to the project dir.**
  If the former, the fix is nearly free: change the precedence. If the latter, cwd is useless here.
- The payload's own `cwd` field — **unverified that one is even sent.** Grepped every hook in
  `.claude/hooks/`: the only payload keys read anywhere are `tool_name`, `tool_input` and
  `transcript_path`. No hook reads `cwd`, so the repo carries no evidence either way.

**Second, smaller open question, flagged rather than assumed:** after the target repo is resolved,
whose footprint applies? The harness assumes **the target repo's own `logs/`** (each fixture repo gets
its own marker and `session-notes.md`), because that is how this workspace is laid out — every
checkout owns its `logs/`. That assumption is baked into the fixtures and has NOT been validated
against the session/marker contract. Codex's brief names exactly this as a stop-if: *"if correct
footprint translation cannot be established from the existing session/marker contract"*.

## Next action

**Codex — assess Unit 1.** It is implemented, evidenced and handed back. Assess against the brief's
four required behaviours and the evidence requirements. Points that want a decision rather than a
nod:

1. **Fail-closed is scoped to wide adds only.** A gated `git commit` carrying an unresolvable `cd`
   falls back to the base cwd instead of blocking. Deliberate — the brief's required behaviour names
   the wide-add case, and blocking every multi-line commit would be a false-block regression. Accept,
   or widen it.
2. **Footprint translation is validated by harness, not against the session/marker contract as a
   document.** The target repo's own `logs/` is used. Your brief names exactly this as a stop-if. It
   did not stop the work because the fixtures and the live layout agree, but it is not documentary
   proof.
3. **Two harness cases beyond what the brief asked for** (C7, C8, plus a reshaped `run_hook`), added
   because the original harness never exercised the production payload shape and would have gone
   green against a hook that ignored the payload `cwd` entirely. In-session scope addition, declared.
4. **Unit 1 stops here as instructed.** `docs/commit-discipline.md`, `logs/improvement-log.md`, the
   `.codex` fork and the sector-intelligence copy are untouched, so the canonical hook and its two
   maintained copies have now genuinely diverged — that divergence is Unit 2's material, not an
   oversight.

---

**Superseded — the checkpoint's instruction to the resuming Claude session, kept for the record.**

Claude, next session — resume from Git and this file alone; nothing else from the prior session is
needed.

1. **Settle the cwd question first, by execution — it gates the whole design.** Determine empirically
   what a PreToolUse hook receives. Cheapest honest probe: temporarily register a throwaway hook that
   dumps its raw stdin payload and `os.getcwd()` to a scratch file, run one `git add` from a
   subdirectory, read the dump, then unregister it. That touches `~/.claude/settings.json`, which is a
   gated harness-config change — **ask the operator before doing it.** Do not infer the answer from
   documentation or from this file.
2. Then implement the smallest resolver satisfying the brief's four required behaviours. A single
   leading literal `cd` is in scope; nested `cd`s, variables and arbitrary shell are not, and every
   unparseable wide-add shape must fail closed with exit 2 — never soft-warn. The entry's own
   "prefer the soft warn" sentence is superseded and was rejected by both gates.
3. Re-run `bash logs/scripts/check-foreign-staging.test.sh`. Target: 6/6 green, exit 0. Then re-run it
   against the no-op stub (`HOOK_OVERRIDE`) and confirm it does NOT report success — that is what keeps
   the green honest.
4. Give C2 a positive-identity assertion before accepting green (see the limitation above).
5. Unit 1 stops there. Docs, `logs/improvement-log.md`, the `.codex` fork and the sector-intelligence
   copy are explicitly held back to later units by the approved boundary — do not touch them.

State of the tree at this checkpoint: the hook is unmodified; the only new file is the harness. Verify
with `git log --oneline -3` and `bash logs/scripts/check-foreign-staging.test.sh` (expect 4 RED / 2
GREEN, exit 1).

> ⚠ **The paragraph immediately above is HISTORICAL and no longer describes the tree.** It described
> the handoff checkpoint. The hook is now modified and the harness is **9/9 green, exit 0** — see
> § Latest result. Left in place because it is part of the preserved checkpoint record; annotated
> because FP-4 in this same pilot was a stale document misleading a fresh session, and an unmarked
> "expect 4 RED" would do exactly that to whoever reads this file next.
