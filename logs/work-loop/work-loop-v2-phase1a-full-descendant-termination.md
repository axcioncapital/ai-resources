---
task: work-loop-v2-phase1a-full-descendant-termination
turn: codex
---

## Objective and scope

Close Phase 1 item 1a literally: every controlled dispatcher stop must terminate and verify the
actor's full descendant tree, including a descendant that calls `setsid`, double-forks, closes every
inherited descriptor and `exec`s another program. A stop must not signal an unrelated process and
must never claim success when termination or verification is incomplete.

The operator preserved this guarantee on 2026-08-08. The operator has now authorized **Stages B and
C only**: a temporary, non-admin actor account and the bounded feasibility checks for actor-owned
Claude/Codex authentication, UID-scoped termination and read-only Git access. Stages D and E are not
authorized: no operator-home permission or ACL change, `sudoers`, permanent launch wrapper,
dispatcher implementation or permanent production setup may occur.

The task closes only after the guarantee is implemented and supported by fail-capable simulated
regression evidence plus effective live Darwin evidence. Phase 1f and every Phase 2 action remain
outside this task; Phase 2 stays forbidden.

## Lane and unit

Standard. Discovery mode. Unit 3 — produce one complete, guarded, operator-executable Stage B/C
runbook and C5 fixture without running either.

Named reason for the loop: the next action creates an OS account, authenticates two paid tools and
tests a UID-wide signal boundary. Its procedure must be independently checked before the operator
executes it, and the result must survive the session because it gates the later dispatcher design.

Plan justification: the governing unattended-operation plan still blocks Phase 2 on 1a and 1f.
Accepted Unit 2 evidence found a coherent dedicated-identity route but left three live questions for
Stages B/C. The operator has authorized those stages, so the smallest justified unit is to make their
operator procedure exact and safe; running the procedure and interpreting its live result come next.

Codex framing decision: this remains discovery because it prepares and checks a host probe rather
than operating the host or implementing the dispatcher. This unit may change only this state file.
No probe file under `runs/` is authorized in this unit; if code is needed, return it inline in the
runbook after syntax-checking a self-cleaning temporary copy.

## Brief

The dedicated-identity route now turns on three facts that only a real account can settle. Before the
operator creates that account, convert the draft chat instructions into one complete runbook whose
guards make a wrong account, an occupied UID, an unlocked GUI session or an over-broad signal a
visible stop. This unit writes and validates that runbook; it does not execute it.

### Governing sources and dispositions

- **Current operator decision:** Stages B and C are authorized; D and E are not. This governs the
  host-action boundary and supersedes this file's former `turn: operator` decision request.
- **Governing plan:**
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, especially the status block, Phase 1
  item 1a, the two remaining Phase 2 blockers and the Phase 2 prohibition.
- **Accepted Unit 2 result:** the corrected dedicated-identity discovery committed by Claude at
  `cd88efa`, together with Codex's accepted closure check previously recorded in this file. Verify
  the live repository before relying on the commit or its content. The settled design is one
  non-admin actor identity per checkout, an eventual actor-UID lock, actor-owned Claude/Codex
  authentication and a later UID-scoped termination boundary. Unit 2 did not prove that boundary.
- **Existing detached-process fixture and evidence:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probes/escaped-descendants-2026-08-07.sh`,
  `runs/probe-escaped-descendants-2026-08-07.md`, and the matching cases in `dispatch.test.sh`.
  Reuse their already-proved escape shape where suitable; do not invent a weaker stand-in.
- **Current dispatcher and safety behavior:** `dispatch.sh`, `dispatch.test.sh`, spike `README.md`,
  the interruption record and Phase 0 evidence. They govern bystander protection, stop semantics,
  retry prohibition, lock behavior, exit-code honesty and the effective detached shape.
- **Workflow contract:** `.agents/skills/work-loop-v2/SKILL.md` and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. This is a discovery unit: change
  nothing except this state file, return the evidence and hand back.
- **Non-governing draft:** Claude's chat procedure beginning with `sudo sysadminctl -addUser
  wlactor`. Treat it as candidate material to verify, not as an approved command sequence. In
  particular, it did not establish how a fresh actor invokes `claude install`, and it omitted C5.

### Required outcome

Return one ordered runbook that the operator can execute without inventing a command or safety step.
It must cover preflight, Stage B, every Stage C check, the full C5 fixture, pass/fail interpretation,
evidence to bring back, and rollback. Commands must be backed by local help/manual behavior or an
explicitly cited primary source, and every runtime-dependent premise must remain a visible operator
check rather than being promoted to fact.

The runbook must make these outcomes unambiguous:

1. **C3 fails:** stop immediately and safely remove the temporary boundary.
2. **C3 passes but C4, C5 or C6 fails:** stop, preserve the exact non-secret evidence, and offer a
   complete rollback; do not proceed to D.
3. **All Stage C checks pass:** stop with D and E still forbidden, report exactly what was proved,
   and state whether the temporary account remains or is rolled back pending a new operator decision.

Do not call the dedicated route viable merely because the commands are well formed. Only the later
operator run can supply the missing host evidence, and 1a remains open even if every C check passes.

### Claims to verify before writing the runbook

1. **Current state and scope.** Re-read the current state, plan and named evidence. Confirm that the
   operator authorized B/C only, that no Stage B/C host action is recorded as already executed, and
   that Phase 2 remains forbidden.
2. **Account preflight and rollback.** Inspect local `sysadminctl`, `dscl`, `id` and relevant manual
   behavior read-only. Establish a collision-safe account name for this checkout, a guard that
   refuses if the name, UID or home path already belongs to anything, how the password is entered
   without appearing in argv, history, the state file or captured evidence, how non-admin status is
   proved, and what account deletion does to the home. The rollback must never delete or repurpose a
   pre-existing account and must not use an unguarded recursive deletion.
3. **Claude bootstrap.** Verify the live install layout and a fresh login shell's executable search
   path. The current operator binary is under `/Users/patrik.lindeberg/.local/bin`; a new actor has no
   demonstrated `claude` command with which to run `claude install`. Select and justify a supported,
   one-time bootstrap that installs into the actor's own home without copying credentials or making
   the operator-home binary a steady-state dependency. Do not download or install anything now.
4. **Attended login versus the decisive non-GUI check.** Establish the exact supported Claude and
   Codex login/status commands and their non-secret success/failure output. The runbook must allow an
   attended actor login if required, then require a **full actor GUI logout**, not fast user
   switching, and positively check that no actor GUI session remains before C3. Resolve when hiding
   the account is safe; do not hide or disable the only login route before the attended setup that
   needs it.
5. **C5 target derivation and ordering.** Determine an ordering that makes the empty-UID premise
   truthful. Before any UID-wide signal, enumerate the actor UID and refuse to signal if any process
   exists other than the fixture's exact expected members and the signalling command's documented
   exclusions. Never treat an unexpected actor process as cleanup permission.
6. **C5 fixture.** Return the full executable fixture inline, or an exact safe invocation of an
   existing script if it already provides the required boundary. It must create an actor-owned fully
   detached daemon that performs `setsid`, double-forks, closes inherited descriptors and execs a
   normal system binary; create a uid-501 bystander; prove the target has the expected actor UID and
   escape properties before signalling; run the exact TERM/grace/KILL/empty-census sequence; prove
   the daemon is gone and the bystander remains alive; distinguish exit 0, 1 and `>=2`; and clean up
   every fixture process on every exit. It must refuse root, uid 501, an empty/malformed UID, a UID
   that no longer maps to the intended account, and any unbounded or unexpected target census.
7. **Read-only C6.** Verify the minimum Git configuration needed for the actor to read this checkout
   across the ownership boundary. C6 may prove traversal, repository recognition and
   `safe.directory`; it must not claim write or commit ability before D2. Avoid optional index writes
   where Git provides a supported read-only mode, and do not collect credential-helper output.
8. **Rollback and residue.** Pair every persistent Stage B/C change with a checked rollback. Include
   a final process census, authentication logout where supported, account deletion, account/home
   absence checks and treatment of a logout command that cannot reach a locked keychain. State what
   remains after a successful C run and what the operator must decide before anything else happens.

### Required evidence

Evidence must be capable of rejecting the proposed runbook.

- A command-support table citing the local help/manual or primary source for account creation and
  deletion, password handling, actor-owned Claude bootstrap, Claude/Codex login and status, GUI
  logout/session detection, `pkill -U`/`pgrep -U`, and read-only Git status behavior.
- A stage table with every command marked `[READ-ONLY]`, `[ADMIN]`, `[ATTENDED]`, `[SIGNAL]` or
  `[ROLLBACK]`, plus its pass result, fail result, stop point and captured evidence. Secret values and
  passwords must never be captured.
- The exact C5 shell content syntax-checked with `bash -n` using only a temporary, self-cleaning file.
  Also provide a static signal audit listing every `kill`, `pkill` or equivalent invocation and the
  guard that proves its target. Do not execute any UID-wide signal in this unit.
- A fail-capability matrix showing at least: existing-name collision; malformed, root, operator or
  mismatched UID; occupied actor UID; failed Claude bootstrap; incomplete GUI logout; locked
  keychain; failed Codex status; C5 daemon survivor; C5 bystander death; `pkill`/`pgrep` exit `>=2`;
  read-only Git failure; rollback failure. Each must lead to a visible stop, not continued setup.
- A concise operator evidence template containing only the outputs needed for Codex assessment after
  the real run. It must not ask for passwords, tokens, credential files, Keychain contents or browser
  data.

### Scope and stop conditions

Allowed repository path: this state file only.

Allowed work: read the named repository sources; inspect local binary paths, versions, `--help`,
manual pages and non-secret file/account metadata; consult official primary documentation only where
the local interface is insufficient; create and remove self-cleaning temporary material solely to
syntax-check the proposed C5 code.

Forbidden in this unit: `sudo`; account creation, deletion, hiding or repurposing; password prompts;
Claude/Codex installation, authentication or logout; Keychain or TCC mutation; any signal against a
real UID or process; ACL, mode, owner, operator-home, `sudoers`, wrapper, dispatcher, test or README
changes; any repository artifact besides this state file; Phase 1f; Phase 2; push, merge or deployment.

Stop and hand back rather than improvise if a safe bootstrap cannot be established; account rollback
semantics remain ambiguous; the C5 target cannot be bounded strongly enough to protect uid 501 and
pre-existing actor processes; complete evidence would require a secret; the runbook needs D/E
authority; a governing premise is false; or the required evidence cannot be produced without running
the authorized host actions prematurely.

Unit completion: Claude changes and commits only this state file, replaces `## Latest result` with
the verified runbook and evidence, leaves 1a open, sets `turn: codex`, and stops. Do not execute the
runbook, create another artifact or push.

## Latest result

**One bounded correction round, frozen to findings 1–4.** Read-only throughout. No `sudo`, no account
action, no installation, no authentication, no signal against any real UID, and no repository file
other than this one. The only temporary material was one scratch copy of the corrected C5 script,
syntax-checked with `bash -n` and removed.

### Reproduction of the frozen findings

Each finding was reproduced by inspection before anything was corrected.

- **Finding 1: REPRODUCES.** Read `runs/probe-escaped-descendants-2026-08-07.md` line 35: the
  detached daemon is recorded as **pid 60086, ppid 1, pgid 60085**. The previous fixture asserted
  `[ "$D_PGID" = "$DAEMON" ]`, which is `60085 = 60086` — false on the repository's own measured
  shape, so the guard would have aborted a correct probe. The descriptor check printed `FDS` and
  proceeded: `say "inherited descriptors held by the daemon: ${FDS:-<could not inspect>}"` with no
  test after it. `trap cleanup EXIT INT TERM` ran cleanup on `INT`/`TERM` and then returned into the
  signal sequence. And the fixture created exactly one actor-owned process, while Unit 2's accepted
  later check (read at `git show cd88efa`, "The exact later check") requires "a fixture of at least
  three actor-owned processes that includes one fully detached daemon … with a uid-501 process
  sharing the same checkout as the bystander control".
- **Finding 2: REPRODUCES.** The previous runbook's password paragraph said `sysadminctl -addUser` is
  run "without `-password`, so it prompts interactively; if it does not prompt, abort" — an
  unestablished premise. P1's fail column said "pick another name" while B1, B2, B3, B4, C1a–C6d and
  R1–R6 all hard-coded `wlactor-airesources`. R1 routed unexpected actor processes "through the
  fixture's guarded path", but the fixture refuses any census other than its own exact expected set.
  R6 said "remove it **by hand**". The C3-failure paragraph said "the host returns to its prior
  state" while R4 used `-keepHome`, which leaves the home behind.
- **Finding 3: REPRODUCES.** The previous C3 pass criterion was `claude auth status` returning
  `"loggedIn": true`, and its support basis was output observed under the **already logged-in
  operator**. That is metadata about a stored credential, not proof that the credential can be
  unlocked and used after a full actor GUI logout. The same gap applies to C4: `codex login status`
  reads `~/.codex/auth.json`, so it reports a file, not a working session.
- **Finding 4: REPRODUCES.** Step H (`sudo dscl . -create /Users/… IsHidden 1`) was in the stage
  table, and the all-pass paragraph read "Recommendation: the account **remains**, hidden by step H"
  immediately before "That the account persists is itself a new operator decision". C6a and C6b wrote
  `git config --global user.name` / `user.email` — commit identity, which belongs to D5 — and C6b
  carried the placeholder `<the address in ~/.gitconfig>` for the operator to fill in.

### What the corrections rest on — inspected this round

- `/usr/sbin/sysadminctl` usage output, read this round, ends with: **"Pass '-' instead of password in
  commands above to request prompt."** So `-password -` is the locally documented way to make the
  password interactive. `man -w sysadminctl` returns "No manual entry for sysadminctl", so the
  **default** `-deleteUser` home behaviour remains unestablished — the corrected rollback never relies
  on it, passing `-keepHome` explicitly and then removing the home under guards.
- `claude auth status --help` offers only `--json` (default) and `--text`; there is no
  "verify the credential works" mode. `claude --help` documents `--bare` as skipping "keychain reads"
  with "OAuth and keychain are never read" — direct local evidence that normal mode depends on a
  keychain read, which is exactly what a GUI logout can break while cached metadata still reads
  logged-in. `claude -p` is the supported non-interactive round-trip.
- `codex exec --help` documents `-s, --sandbox read-only`, `--skip-git-repo-check` and `-C, --cd`, so
  an effective Codex check can be run with no repository and no write capability.
- `git -c safe.directory="<checkout>" --no-optional-locks -C "<checkout>" status --porcelain` was run
  read-only this round and exited 0, so C6 needs **no** persistent `git config` write at all.

### Command-support table

| Purpose | Command | Support basis |
|---|---|---|
| create account | `sysadminctl -addUser … -password - -shell /bin/zsh` | local `sysadminctl` usage output, including its "Pass '-' … to request prompt" line |
| delete account | `sysadminctl -deleteUser <name> -keepHome` | local usage output; `-keepHome` is explicit so home handling is never the undocumented default |
| prove non-admin | `dseditgroup -o checkmember -m <name> admin` | run read-only against the operator; returns a yes/no sentence |
| resolve / reverse-resolve uid | `id -u <name>` / `id -un <uid>` | local, run in Unit 3 |
| account absence | `dscl . -read /Users/<name> RecordName` → `eDSRecordNotFound` | local, run in Unit 3 |
| Claude bootstrap | `<operator-claude> install` under the actor's HOME | `claude install [target]` in local `--help`; the operator's own install is per-user under `~/.local/bin` |
| Claude login / status | `claude auth login`, `claude auth status [--json|--text]` | local `claude auth --help`, read this round |
| Claude **effective** auth | `claude -p '<prompt>'` | local `claude --help`: `-p/--print` = "Print response and exit"; `--bare` documents that normal mode reads OAuth/keychain |
| Codex login / status | `codex login`, `codex login status` | local `codex login --help`, read this round |
| Codex **effective** auth | `codex exec --sandbox read-only --skip-git-repo-check -C /tmp '<prompt>'` | local `codex exec --help`, read this round |
| GUI session detection | `stat -f '%Su' /dev/console`, `who`, `pgrep -U <uid>` | all run read-only in Unit 3 |
| select / signal by uid | `pgrep -U <uid>`, `pkill -TERM\|-KILL -U <uid>` | `pkill.1` DESCRIPTION; pattern-free selector measured in Unit 2 via `-g` |
| read-only Git status | `git -c safe.directory=<path> --no-optional-locks -C <path> status --porcelain` | run read-only this round, exit 0 |

**One caution carried forward:** `pkill.1`'s SYNOPSIS prints `pattern ...` outside the optional
brackets while its own DESCRIPTION says "If any `pattern` operands are specified". The measurement in
Unit 2 settles it in favour of the DESCRIPTION. C5 is the check that confirms it for `-U`.

### The runbook

Account name for this checkout: **`wlactor-airesources`**, used literally in every command below.
Checkout: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`.

**Password handling, before anything else.** No command below contains a password literal.
`sudo` prompts for the administrator password itself and never places it in `argv`. Account creation
passes `-password -`, which the local usage output documents as the request-a-prompt form. Never paste
a password into a command, this file, or the evidence you bring back.

**If preflight finds a collision, stop.** Do not invent a second account name. A different name would
invalidate every check below and has not been preflighted. Report the collision and hand back.

| # | Command | Kind | Pass | Fail → stop |
|---|---|---|---|---|
| P1 | `id -u wlactor-airesources` | `[READ-ONLY]` | "no such user" | any uid printed → **STOP**, name collision, hand back |
| P2 | `ls -ld /Users/wlactor-airesources` | `[READ-ONLY]` | "No such file or directory" | path exists → **STOP**, do not reuse it |
| P3 | `dscl . -read /Users/wlactor-airesources RecordName` | `[READ-ONLY]` | `eDSRecordNotFound` | a record exists → **STOP** |
| P4 | `stat -f '%Su' /dev/console` | `[READ-ONLY]` | `patrik.lindeberg` | anything else → an unexpected GUI session owns the console |
| **B1** | `sudo sysadminctl -addUser wlactor-airesources -fullName "Work Loop Actor (ai-resources)" -shell /bin/zsh -password -` | `[ADMIN]` | prompts for the new account's password, then creates it | no prompt, or any error → stop; nothing else has changed |
| B2 | `id -u wlactor-airesources` | `[READ-ONLY]` | a uid ≥ 500 | non-numeric or < 500 → stop and roll back |
| B3 | `dseditgroup -o checkmember -m wlactor-airesources admin` | `[READ-ONLY]` | "no … is not a member" | "yes" → **stop and roll back**, the account is an admin |
| B4 | `pgrep -U $(id -u wlactor-airesources); echo $?` | `[READ-ONLY]` | exit `1` | exit `0` → the UID is occupied; exit ≥2 → cannot look, stop |
| **C1a** | `sudo -u wlactor-airesources -H /Users/patrik.lindeberg/.local/bin/claude install` | `[ATTENDED]` | completes | error → stop, roll back |
| C1b | `ls -l /Users/wlactor-airesources/.local/bin/claude` | `[READ-ONLY]` | exists | missing → the bootstrap did not install into the actor's home; stop |
| C1c | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth login` | `[ATTENDED]` | login completes | if it needs a browser it cannot reach, log into the actor's desktop session and do C1c/C2 there |
| C2 | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex login` | `[ATTENDED]` | login completes | error → stop, roll back |
| **G** | **If you used the actor's desktop session: log fully out of it. Not fast user switching — log out.** | `[ATTENDED]` | — | — |
| G1 | `stat -f '%Su' /dev/console` | `[READ-ONLY]` | **not** the actor | actor owns the console → C3 would pass for the wrong reason; log out and repeat |
| G2 | `who` | `[READ-ONLY]` | no actor row | actor row present → same, log out |
| G3 | `pgrep -U $(id -u wlactor-airesources); echo $?` | `[READ-ONLY]` | exit `1` | exit `0` → a session survives; exit ≥2 → cannot look, stop |
| C3a | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth status --json` | `[READ-ONLY]` | JSON with `"loggedIn": true` | anything else → stop and roll back |
| **C3b** | `cd /tmp && sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude -p 'Reply with exactly one word: alive'` | `[READ-ONLY]` | the reply text `alive`, exit 0 | any auth/keychain error, empty output or non-zero exit → **STOP AND ROLL BACK.** This, not C3a, is the decisive check |
| C4a | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex login status` | `[READ-ONLY]` | `Logged in using ChatGPT` | anything else → stop, preserve output, offer rollback |
| **C4b** | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex exec --sandbox read-only --skip-git-repo-check -C /tmp 'Reply with exactly one word: alive'` | `[READ-ONLY]` | a completed run whose reply is `alive`, exit 0 | auth error or non-zero exit → stop, preserve output, offer rollback |
| **C5** | the fixture below, run as the operator | `[SIGNAL]` | `C5 PASS` | any other verdict → stop, preserve output, offer rollback |
| C6a | `sudo -u wlactor-airesources -H git --no-optional-locks -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" status --porcelain; echo $?` | `[READ-ONLY]` | a **non-zero** exit naming "dubious ownership" — this is the expected refusal | exit 0 → the ownership boundary is not what the design assumes; record it and continue to C6b |
| C6b | `sudo -u wlactor-airesources -H git -c safe.directory="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" --no-optional-locks -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" status --porcelain; echo $?` | `[READ-ONLY]` | exits 0 and prints a status | "dubious ownership" persists → `safe.directory` is not the fix; permission denied → traversal is blocked; either way stop |

**Why C3b and C4b exist.** C3a and C4a read stored metadata. `claude auth status` has no
verify-the-credential mode (`--help`: only `--json` and `--text`), and `codex login status` reads
`~/.codex/auth.json`. A credential can be recorded and still be unusable once the actor's GUI session
is gone — `claude --help` documents `--bare` as the mode where "OAuth and keychain are never read",
which is the local evidence that normal mode depends on a keychain read. C3b and C4b are round-trips:
they fail if the credential cannot be unlocked and used. **Do not pass `--bare`** to C3b; it would
bypass the exact credential path under test. Both run with cwd `/tmp` and no repository, C4b under
`--sandbox read-only`, so neither can touch the checkout. Both consume a small amount of the actor's
own quota; that is the cost of an effective check and it is stated rather than hidden.

**Why C6 no longer writes anything.** `git -c safe.directory=…` supplies the setting for one
invocation, and it was verified read-only this round (exit 0). Persisting it with `git config
--global`, and configuring a commit identity at all, belong to D2/D5 and are not authorized here.
C6's authorized claim is exactly: traversal, repository recognition, and that `safe.directory` is the
setting the boundary needs.

**The runbook ends at C6b.** There is no hide step and no retain step. D and E remain forbidden.

### C5 — the fixture, inline and syntax-checked

Run as the operator (uid 501), attended. It creates **three** actor-owned processes — matching Unit
2's accepted later check — plus one uid-501 bystander whose working directory is the checkout.
`bash -n` returned exit 0 on a temporary copy of exactly this content; the copy was removed and no
part of it was executed in this unit.

```bash
#!/bin/bash
# C5 — actor-UID termination boundary probe.
# RUN AS THE OPERATOR (uid 501), attended. Creates THREE actor-owned processes —
# an ordinary child, a setsid child, and a fully detached daemon — plus ONE
# uid-501 bystander whose cwd is the checkout. It proves the boundary before
# signalling it, then runs the exact TERM/grace/KILL/census sequence.
#
# The three-process fixture is Unit 2's accepted later check, not a reduction of it.
# It signals a UID only after five identity guards, one empty-boundary guard,
# per-process shape assertions and one exact-census guard have passed.
set -u

ACTOR_NAME="${1:?usage: c5.sh <actor-account-name> <checkout-path>}"
CHECKOUT="${2:?usage: c5.sh <actor-account-name> <checkout-path>}"
GRACE=3
LIFE=600

A=""; B=""; D=""; BYSTANDER=""
ACTOR_UID=""

say() { printf '%s\n' "$*"; }
refuse() { say "REFUSE: $*"; exit 2; }

# Kill one recorded actor pid, but ONLY if it still belongs to the actor.
# Guards against pid reuse handing us someone else's process.
kill_actor_pid() {
  local p="$1" owner
  [ -n "$p" ] || return 0
  owner="$(ps -o uid= -p "$p" 2>/dev/null | tr -d ' ')"
  [ "$owner" = "${ACTOR_UID:-x}" ] || return 0
  sudo -u "$ACTOR_NAME" /bin/kill -KILL "$p" 2>/dev/null
  return 0
}

cleanup() {
  [ -n "$BYSTANDER" ] && kill "$BYSTANDER" 2>/dev/null
  kill_actor_pid "$D"
  kill_actor_pid "$B"
  kill_actor_pid "$A"
  return 0
}
trap cleanup EXIT
trap 'say "INTERRUPTED — cleaning up, and this is NOT a pass"; exit 2' INT TERM

OP_UID="$(id -u)"
OP_PGID="$(ps -o pgid= -p $$ 2>/dev/null | tr -d ' ')"

# Refresh the sudo credential once, attended, so the launcher below cannot
# stall on a hidden password prompt.
sudo -v || refuse "sudo credential could not be refreshed"

# ---------------------------------------------------------------- guard 1: uid
ACTOR_UID="$(id -u "$ACTOR_NAME" 2>/dev/null)"
case "${ACTOR_UID:-}" in
  ''|*[!0-9]*) refuse "'$ACTOR_NAME' does not resolve to a numeric uid" ;;
esac
[ "$ACTOR_UID" -ne 0 ]         || refuse "target uid is root"
[ "$ACTOR_UID" -ne "$OP_UID" ] || refuse "target uid is the caller"
[ "$ACTOR_UID" -ge 500 ]       || refuse "uid $ACTOR_UID is a system uid"
BACK="$(id -un "$ACTOR_UID" 2>/dev/null)"
[ "${BACK:-}" = "$ACTOR_NAME" ] || refuse "uid $ACTOR_UID maps to '${BACK:-<none>}', not '$ACTOR_NAME'"
say "guard 1 OK: $ACTOR_NAME = uid $ACTOR_UID, not root, not caller, >= 500, maps back"

# ------------------------------------------------- guard 2: boundary is empty
PRE="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; PRE_RC=$?
case "$PRE_RC" in
  1) say "guard 2 OK: actor boundary is empty (pgrep exit 1)" ;;
  0) say "actor uid already has processes:"; say "$PRE"
     refuse "this probe never cleans up a boundary it did not create" ;;
  *) refuse "pgrep exit $PRE_RC — cannot prove the boundary is empty, so nothing is signalled" ;;
esac

# ------------------------------------------------------------------- fixture
# One launcher, run as the actor, spawns all three and exits. A and B send their
# descriptors to /dev/null so they do not hold this command substitution open;
# the daemon reports its pid and then closes every descriptor itself.
# The escape shape is reused verbatim from
# runs/probes/escaped-descendants-2026-08-07.sh lines 107-116.
PIDS="$(sudo -u "$ACTOR_NAME" -H /bin/bash -c '
set -u
/bin/sleep '"$LIFE"' >/dev/null 2>&1 </dev/null &
A=$!
/usr/bin/python3 -c "
import os
os.setsid()
os.execv(\"/bin/sleep\", [\"sleep\", \"'"$LIFE"'\"])
" >/dev/null 2>&1 </dev/null &
B=$!
D=$(/usr/bin/python3 -c "
import os, sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
# the pid is written BEFORE the descriptors go, because writing it needs one
sys.stdout.write(str(os.getpid()) + \"\n\"); sys.stdout.flush()
os.closerange(0, 1024)
os.execv(\"/bin/sleep\", [\"sleep\", \"'"$LIFE"'\"])
" 2>/dev/null </dev/null)
printf "%s %s %s\n" "$A" "$B" "$D"
')"

set -- $PIDS
A="${1:-}"; B="${2:-}"; D="${3:-}"
for v in "$A" "$B" "$D"; do
  case "${v:-}" in ''|*[!0-9]*) refuse "fixture did not report three numeric pids: [$PIDS]" ;; esac
done

( cd "$CHECKOUT" && exec /bin/sleep "$LIFE" ) &
BYSTANDER=$!
sleep 1

# ------------------------------------- guard 3: the fixture is what we think
shape() { ps -o "$1=" -p "$2" 2>/dev/null | tr -d ' '; }

A_UID="$(shape uid "$A")";  A_PGID="$(shape pgid "$A")"
B_UID="$(shape uid "$B")";  B_PGID="$(shape pgid "$B")"
D_UID="$(shape uid "$D")";  D_PGID="$(shape pgid "$D")";  D_PPID="$(shape ppid "$D")"
say "operator  pgid=$OP_PGID uid=$OP_UID"
say "A ordinary  pid=$A uid=$A_UID pgid=$A_PGID"
say "B setsid    pid=$B uid=$B_UID pgid=$B_PGID"
say "D daemon    pid=$D uid=$D_UID pgid=$D_PGID ppid=$D_PPID"
say "bystander   pid=$BYSTANDER uid=$OP_UID cwd=<checkout>"

[ "$A_UID" = "$ACTOR_UID" ] || refuse "A uid $A_UID is not the actor uid"
[ "$B_UID" = "$ACTOR_UID" ] || refuse "B uid $B_UID is not the actor uid"
[ "$D_UID" = "$ACTOR_UID" ] || refuse "D uid $D_UID is not the actor uid"

# B took setsid, so it leads its own group. This is the measured shape
# (probe-escaped-descendants-2026-08-07.md: pid 60081, pgid 60081).
[ "$B_PGID" = "$B" ] || refuse "B pgid $B_PGID != $B — setsid did not take"

# D is the fully detached daemon. The measured shape is pid 60086 in pgid 60085:
# after setsid and the SECOND fork it inherits the intermediate child's group
# rather than leading one, so D_PGID == D is the WRONG assertion. What must hold
# is separation: D is outside the operator's group and outside the launcher's
# group, so neither `kill -- -PGID` handle can reach it, and its ancestry is gone.
[ "$D_PPID" = "1" ] || refuse "D ppid $D_PPID != 1 — the double fork did not orphan it"
case "${D_PGID:-}" in ''|*[!0-9]*) refuse "D pgid is not readable" ;; esac
[ "$D_PGID" != "$OP_PGID" ] || refuse "D shares the operator's process group $OP_PGID — it did not escape"
[ "$D_PGID" != "$A_PGID" ]  || refuse "D shares the launcher's process group $A_PGID — it did not escape"
if [ "$D_PGID" = "$D" ]; then
  say "note: D leads its own group ($D_PGID). The measured shape has it inheriting the"
  say "      intermediate child's group instead. Either satisfies the separation the test needs."
fi
say "guard 3a OK: D is orphaned (ppid 1) and its group $D_PGID is neither $OP_PGID nor $A_PGID"

# Descriptor assertion. Two lsof calls, because an empty result from ONE call
# cannot tell "holds no inherited descriptors" apart from "could not look".
SEEN="$(sudo -u "$ACTOR_NAME" /usr/sbin/lsof -p "$D" 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')"
case "${SEEN:-0}" in
  ''|0) refuse "lsof returned nothing at all for pid $D — descriptors cannot be inspected, so this is not a pass" ;;
esac
FDS="$(sudo -u "$ACTOR_NAME" /usr/sbin/lsof -p "$D" -a -d 0-1024 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')"
case "${FDS:-}" in ''|*[!0-9]*) refuse "descriptor count for pid $D is not readable" ;; esac
[ "$FDS" -eq 0 ] || refuse "D still holds $FDS inherited descriptors (0-1024) — not the fully detached shape"
say "guard 3b OK: lsof sees $SEEN rows for D and 0 of them are inherited descriptors 0-1024"

# ------------------------------- guard 4: census matches the expected set EXACTLY
CENSUS="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; C_RC=$?
[ "$C_RC" -eq 0 ] || refuse "census exit $C_RC before signalling"
ACTUAL="$(printf '%s\n' $CENSUS | sort -n | tr '\n' ' ')"
EXPECT="$(printf '%s\n' "$A" "$B" "$D" | sort -n | tr '\n' ' ')"
[ "$ACTUAL" = "$EXPECT" ] || refuse "actor boundary holds [$ACTUAL]; expected exactly [$EXPECT]"
say "guard 4 OK: boundary holds exactly the three fixture processes [$EXPECT]"

# ------------------------------------------------ the sequence under test
say "--- TERM ---"
sudo -u "$ACTOR_NAME" /usr/bin/pkill -TERM -U "$ACTOR_UID"; T_RC=$?
say "pkill -TERM -U $ACTOR_UID exit=$T_RC   (0 signalled | 1 none | >=2 ERROR)"
[ "$T_RC" -ge 2 ] && { say "STOP: pkill error, boundary state unknown"; exit 2; }
sleep "$GRACE"

MID="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; M_RC=$?
say "after grace: pgrep exit=$M_RC survivors=[$(printf '%s' "$MID" | tr '\n' ' ')]"
if [ "$M_RC" -eq 0 ]; then
  say "--- KILL ---"
  sudo -u "$ACTOR_NAME" /usr/bin/pkill -KILL -U "$ACTOR_UID"; K_RC=$?
  say "pkill -KILL -U $ACTOR_UID exit=$K_RC"
  [ "$K_RC" -ge 2 ] && { say "STOP: pkill error, boundary state unknown"; exit 2; }
  sleep 1
elif [ "$M_RC" -ge 2 ]; then
  say "STOP: census error after TERM — cannot tell, so this is NOT a pass"; exit 2
fi

# -------------------------------------------------------------- the verdict
FINAL="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; F_RC=$?
say "--- RESULT ---"
say "final census exit=$F_RC   (1 = boundary empty | 0 = survivors | >=2 = could not look)"
ps -p "$A" >/dev/null 2>&1 && A_STATE=ALIVE || A_STATE=GONE
ps -p "$B" >/dev/null 2>&1 && B_STATE=ALIVE || B_STATE=GONE
ps -p "$D" >/dev/null 2>&1 && D_STATE=ALIVE || D_STATE=GONE
ps -p "$BYSTANDER" >/dev/null 2>&1 && Y_STATE=ALIVE || Y_STATE=GONE
say "A ordinary child : $A_STATE   (must be GONE)"
say "B setsid child   : $B_STATE   (must be GONE)"
say "D detached daemon: $D_STATE   (must be GONE)"
say "uid-501 bystander: $Y_STATE   (must be ALIVE)"

RC=1
if [ "$F_RC" -eq 1 ] \
   && [ "$A_STATE" = GONE ] && [ "$B_STATE" = GONE ] && [ "$D_STATE" = GONE ] \
   && [ "$Y_STATE" = ALIVE ]; then
  say "C5 PASS — the actor UID boundary terminated all three actor-owned processes,"
  say "          including a fully detached descendant, and did not overreach"
  RC=0
elif [ "$F_RC" -ge 2 ]; then
  say "C5 FAIL-CLOSED — the census could not run; an inability to look is not a clean boundary"
else
  say "C5 FAIL — A=$A_STATE B=$B_STATE D=$D_STATE bystander=$Y_STATE final-census-exit=$F_RC"
fi
exit "$RC"
```

**One property stated rather than hidden.** The launcher exits after spawning, so A and B are
re-parented to pid 1 alongside D. That makes the fixture *harder*, not weaker: no live parent links
any of the three to the caller, so a UID sweep is the only handle left. Their shapes are still
distinguished and asserted separately — A ordinary, B its own session/group leader, D fully detached.

### Static signal audit

Every signalling call in the corrected fixture, and what bounds its target. There are four, and no
fifth: `grep -nE '\bkill\b|\bpkill\b'` over the exact content above returns nine lines, of which five
are comments or `say` strings and four are invocations.

| Site | Call | What proves the target is safe |
|---|---|---|
| `kill_actor_pid` | `sudo -u <actor> /bin/kill -KILL "$p"` | `$p` is a pid this script recorded, **and** `ps -o uid=` must still show it owned by `$ACTOR_UID` — the pid-reuse guard |
| `cleanup` | `kill "$BYSTANDER"` | `$BYSTANDER` is this script's own child, owned by uid 501, signalled by its own owner |
| TERM | `sudo -u <actor> pkill -TERM -U "$ACTOR_UID"` | guards 1–4: numeric uid, not root, not the caller, ≥ 500, reverse-maps to the intended name; the boundary was empty before the fixture; every fixture member's uid, shape and descriptors were asserted; and the census equals exactly `[A B D]` |
| KILL | `sudo -u <actor> pkill -KILL -U "$ACTOR_UID"` | the same guards; only reached when TERM left survivors **and** the census could be read |

Because both `pkill` calls run **as the actor**, `man 2 kill`'s EPERM rule makes signalling uid 501 or
root impossible regardless of what the guards did. The guards protect against the actor's *own*
unexpected processes; the kernel protects everyone else.

### Fail-capability matrix

Every row is a way this runbook can return "no". None of them continues setup.

| # | Failure | Detected by | Result |
|---|---|---|---|
| 1 | existing-name collision | P1–P3 | stop before B1; nothing created; **no second name is invented** |
| 2 | `-password -` does not prompt | B1 | stop; the account is not created blind |
| 3 | malformed / non-numeric uid | C5 guard 1 | refuse, exit 2 |
| 4 | uid is root | C5 guard 1 | refuse, exit 2 |
| 5 | uid is the operator | C5 guard 1 | refuse, exit 2 |
| 6 | uid no longer maps to the intended account | C5 guard 1 reverse-map | refuse, exit 2 |
| 7 | actor UID already occupied | B4 and C5 guard 2 | refuse; never treated as cleanup permission |
| 8 | account was created as an admin | B3 | stop and roll back |
| 9 | Claude bootstrap did not install into the actor's home | C1b | stop and roll back |
| 10 | incomplete GUI logout | G1, G2, G3 | stop; C3 would otherwise pass for the wrong reason |
| 11 | credential recorded but **not usable** without the GUI | **C3b** (C3a alone cannot see this) | **stop and roll back** — the decisive failure |
| 12 | Codex credential recorded but not usable | **C4b** | stop, preserve output, offer rollback |
| 13 | C5 daemon has not actually escaped (ppid ≠ 1, shares a group, still holds descriptors) | C5 guard 3a / 3b | refuse, exit 2 — the probe never signals a fixture it could not verify |
| 14 | C5 descriptors cannot be inspected at all | C5 guard 3b first `lsof` | refuse, exit 2 — inability to look is not a pass |
| 15 | C5 boundary holds anything other than exactly A, B, D | C5 guard 4 | refuse, exit 2 |
| 16 | any of the three actor processes survives | final census / `ps -p` | `C5 FAIL` |
| 17 | C5 bystander dies | `ps -p $BYSTANDER` | `C5 FAIL` — overreach |
| 18 | `pgrep`/`pkill` exit ≥ 2 | every census site | `C5 FAIL-CLOSED` |
| 19 | C5 interrupted mid-run | `INT`/`TERM` trap | cleans up and exits 2 — never resumes the signal sequence |
| 20 | the ownership boundary is not real | C6a exits 0 instead of refusing | recorded; the design assumption is wrong and Codex must know |
| 21 | read-only Git fails even with `safe.directory` | C6b | stop; traversal or the setting is wrong |
| 22 | rollback itself fails | R5, R7 | R7 reports exactly what remains; no clean-host claim |

### The three outcomes, unambiguously

**C3a or C3b fails.** Stop at once. Run rollback R1–R7. Nothing outside the actor's own account was
ever touched — no ACL, no `sudoers`, no change to the operator's home, and C6 wrote no Git config —
so a complete R1–R7 leaves the host as it was. If R6 was not run, the actor's home directory remains
at `/Users/wlactor-airesources` and that is stated as residue, not glossed. Report the exact C3
output, redacted per the template.

**C3 passes but C4, C5 or C6 fails.** Stop. Do **not** proceed to D. Preserve the exact non-secret
output of the failing check plus the checks that passed before it. Rollback R1–R7 is available and is
offered, not forced — the operator may prefer to keep the account to retry the failing check.

**All Stage C checks pass.** Stop with **D and E still forbidden**. What is proved is exactly: a
non-admin actor account can authenticate Claude and Codex on its own credentials **and use them with
no GUI session**, can read this checkout across the ownership boundary once `safe.directory` names it,
and its UID is a working termination boundary against three actor-owned processes including a fully
detached descendant, without touching a uid-501 bystander in the same checkout. What is **not**
proved: anything about writing or committing (needs D2/D5), the narrow privilege rule (D4), the
dispatcher integration (Unit 3+), or Phase 1a itself — **1a remains open even if every C check
passes.**

**The runbook makes no recommendation about the account's future.** It ends here, with one question
for the operator:

> Stage C is complete. Do you want the temporary account `wlactor-airesources` **retained as-is** —
> non-admin, no `sudoers` rule, no ACL, no write access to the checkout, not hidden — or **removed**
> via rollback R1–R7? Retaining it keeps the evidence-bearing artifact and avoids repeating Stages B
> and C. Removing it returns the host to its prior state. Either way, D and E stay forbidden until you
> authorize them separately.

Do not hide, disable, retain or delete the account before that answer.

### Rollback

Run in order. Every step names `wlactor-airesources` literally; none touches any other account.

| # | Command | Kind | Checked by |
|---|---|---|---|
| R1 | `ps -o pid,uid,ppid,pgid,command -p "$(pgrep -U $(id -u wlactor-airesources) \| tr '\n' ',' \| sed 's/,$//')" 2>/dev/null; pgrep -U $(id -u wlactor-airesources) >/dev/null; echo $?` | `[READ-ONLY]` | exit `1` expected. **Exit `0` → STOP and take the printed list to the operator.** This rollback never invents a sweep, and the C5 fixture is not a cleanup tool |
| R2 | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth logout` | `[ROLLBACK]` | may fail because the keychain is locked; that is expected — record the exact message and continue. R4 removes the account and its keychain with it |
| R3 | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex logout` | `[ROLLBACK]` | file-based, so it should succeed; R4 removes `~/.codex` regardless |
| R4 | `sudo sysadminctl -deleteUser wlactor-airesources -keepHome` | `[ROLLBACK]` | `-keepHome` is passed explicitly because the **default** home behaviour is not documented locally (`man -w sysadminctl` → no manual entry). Home removal is R6's job, under guards |
| R5 | `id -u wlactor-airesources` → "no such user"; `dscl . -read /Users/wlactor-airesources RecordName` → `eDSRecordNotFound` | `[READ-ONLY]` | both must hold. If either does not, **stop** and report; do not retry blind and do not run R6 |
| R6 | `H=/Users/wlactor-airesources; [ "$H" = /Users/wlactor-airesources ] && [ -d "$H" ] && [ ! -L "$H" ] && [ "$(dirname "$H")" = /Users ] && sudo /bin/rm -rf "$H"` | `[ADMIN]` | five guards, all literal: the path is exactly the actor home, it is a directory, it is not a symlink, its parent is `/Users`, and R5 already proved the account is gone. Run **only** after R5 passes |
| R7 | `ls -ld /Users/wlactor-airesources` → "No such file or directory"; `id -u wlactor-airesources` → "no such user" | `[READ-ONLY]` | if either still resolves, report exactly what remains. **Never claim a clean host on an unverified rollback** |

**No rollback step deletes or repurposes a pre-existing account**, and no step guesses. R5 proves the
account removed is the one it meant to remove before R6 touches any file, and R7 is the only source of
the "host is clean" claim.

### Operator evidence template

Bring back only this. No passwords, tokens, credential files, Keychain contents or browser data.

```
B1  password prompt appeared    : <yes|no>
B2  uid                         : <number>
B3  admin membership            : <the yes/no sentence>
B4  pre-launch census exit      : <0|1|>=2>
C1b actor claude present        : <yes|no>
G1  console owner               : <name>
G3  actor process census exit   : <0|1|>=2>
C3a claude auth status          : loggedIn=<true|false>  authMethod=<value>  [REDACT email and orgId]
C3b claude -p round-trip        : <the one-word reply, or the exact error>   exit=<code>
C4a codex login status          : <the one-line output>
C4b codex exec round-trip       : <the one-word reply, or the exact error>   exit=<code>
C5  full stdout of the fixture (it contains no secrets)
C6a git status WITHOUT safe.directory : exit=<code>  first line: <text>
C6b git status WITH safe.directory    : exit=<code>  first line: <text or "clean">
Anything that stopped early     : which step, and its exact non-secret output
Rollback, if run                : R1–R7 outcomes, and R7's residue result verbatim
```

### Result and evidence

Result: all four frozen findings are corrected in this file, and none was only partly resolved.
Finding 1 — the C5 fixture now asserts the measured escape shape (`D_PPID == 1`, `D_PGID` numeric and
distinct from both the operator's and the launcher's group) instead of the false `D_PGID == D`; the
descriptor check is now two `lsof` calls and a hard `refuse`; `INT`/`TERM` clean up and exit 2 instead
of returning into the signal sequence; and the fixture creates three actor-owned processes plus the
uid-501 bystander, which is Unit 2's accepted later check rather than a weakening of it. Finding 2 —
`-password -` replaces the unestablished "it will prompt" premise, preflight collision now stops
instead of asking the operator to pick a name, R1 stops and reports instead of routing processes
through the fixture, R6 is a five-guard literal-path command instead of "by hand", and the
C3-failure text now names the home as residue when R6 has not run. Finding 3 — C3b and C4b are added
as effective non-GUI round-trips, C3a/C4a are demoted to metadata in the text and in the matrix, and
`--bare` is explicitly excluded because it bypasses the credential path under test. Finding 4 —
step H is deleted, C6 writes nothing at all, and the all-pass path ends in the operator's exact
retain-or-rollback question with no recommendation attached.

Evidence: `bash -n` returned exit 0 on a temporary copy of the exact corrected C5 content above, and
the copy was then removed (`[ -f ] → GONE`). The static signal audit was re-run by `grep -nE
'\bkill\b|\bpkill\b'` over that same content: nine matching lines, four of them invocations, matching
the four-row table above — a fifth invocation would have appeared there. Finding 1's corrected
assertion is taken from the repository's measured record, not re-derived: `runs/
probe-escaped-descendants-2026-08-07.md` line 35 records the daemon as pid 60086 / ppid 1 / pgid
60085, which is what makes `D_PGID == D` false and separation the right test. Finding 2's password
form is the local `sysadminctl` usage line "Pass '-' instead of password in commands above to request
prompt", and the deletion-default gap is `man -w sysadminctl` → "No manual entry for sysadminctl".
Finding 3's split rests on `claude auth status --help` (only `--json`/`--text`, no verify mode),
`claude --help`'s `--bare` text ("OAuth and keychain are never read"), and `codex exec --help`
(`--sandbox read-only`, `--skip-git-repo-check`, `-C`). Finding 4's no-write C6 rests on `git -c
safe.directory=… --no-optional-locks -C … status --porcelain` run read-only this round, exit 0.

The evidence can fail: the `bash -n` result would have been non-zero on a syntax error, the `grep`
would have shown a fifth signalling site, and the measured pgid values either say 60086/60085 or they
do not. Nothing was executed: no `sudo`, no account action, no login, no signal.

The runbook being well formed still proves nothing about the route. Only the operator's later run
supplies the missing host evidence, and **Phase 1a stays open even if every Stage C check passes.**

### Newly noticed — candidate deferrals, not corrected here

Three things surfaced during this round. None is inside the frozen scope, so none was implemented.

1. **Codex has no actor-owned bootstrap.** The Claude bootstrap installs into the actor's own home
   (C1a/C1b), but every Codex command still runs `/Applications/ChatGPT.app/Contents/Resources/codex`
   — a permanent dependency on the operator's application bundle. That is acceptable for a temporary
   Stage C probe and is not acceptable as steady state. Not corrected: finding 3 asks only for an
   effective Codex check, and changing the Codex install layout is D/E territory.
2. **Every actor command in the runbook goes through the operator's `sudo`.** A real dispatcher
   cannot use the operator's sudo credential, so the run-as route for production is still unsolved.
   Not corrected: it is the D4 narrow-privilege question, which is unauthorized.
3. **C3b and C4b spend a little of the actor's own quota.** They are the only checks in the runbook
   with an external cost. Worth the operator knowing before they run it; not a defect, and not a
   reason to weaken the check back to metadata.

## Blocker

None for this unit. The dedicated route remains blocked on the operator's later execution of C3, C4,
C5 and C6, which this unit must not and did not manufacture.

## Next action

Codex: closure check on the four frozen findings only — are findings 1, 2, 3 and 4 resolved, and did
the correction break anything that previously worked? Anything newly noticed is a deferral, not a
second correction round. Three candidate deferrals are already recorded at the end of
`## Latest result`.
