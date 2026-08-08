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

Inspected (2026-08-08). Read-only throughout. No `sudo`, no account action, no installation, no
authentication, no signal against any real UID, and no repository file other than this one. The only
temporary material was one scratch copy of the C5 script, syntax-checked with `bash -n` and removed.

- Claim (1): HOLDS — re-read this file, the governing plan and the named evidence. Stages B and C are
  authorized and D/E are not (`## Objective and scope`, `## Lane and unit`). No Stage B/C host action
  has been executed: `id -u wlactor` and `id -u wlactor-airesources` both return "no such user", and
  `dscl . -list /Users UniqueID` filtered to uid ≥ 500 still returns exactly `patrik.lindeberg 501` and
  `com.malwarebytes.mbam.nobody 1000`. The plan still lists 1a and 1f as the two Phase 2 blockers with
  Phase 2 `BLOCKED`.
- Claim (2): HOLDS with one premise deliberately left as an operator check. `/usr/sbin/sysadminctl`,
  `/usr/bin/dscl`, `/usr/sbin/dseditgroup`, `/usr/bin/dsmemberutil` and `/usr/bin/id` are all present.
  `sysadminctl` usage shows `-addUser <name> [-fullName] [-UID] [-GID] [-shell] [-password] [-hint]
  [-home] [-admin] [-roleAccount] …` and `-deleteUser <name> [-secure || -keepHome]`. Both candidate
  names are free (checked by `id`, `dscl . -read /Users/<name>` → `eDSRecordNotFound`, and `ls -ld
  /Users/<name>` → no such file). Non-admin status is provable read-only: `dseditgroup -o checkmember
  -m patrik.lindeberg admin` returns "yes patrik.lindeberg is a member of admin", so the same command
  against the actor must return "no". **Left as an operator check:** the local usage does not state
  what `-deleteUser` does to the home when neither `-secure` nor `-keepHome` is given, so the runbook
  mandates `-keepHome` and removes the home separately under guards. Nothing here is promoted to fact.
- Claim (3): HOLDS, and it confirms the gap Codex named. `/etc/paths` contains `/usr/local/bin`,
  `/System/Cryptexes/App/usr/bin`, `/usr/bin`, `/bin`, `/usr/sbin`, `/sbin`; `/etc/paths.d` adds
  cryptex paths and `/opt/homebrew/bin`. **None of them is `$HOME/.local/bin`**, so a fresh actor
  login shell has no `claude` command and cannot run `claude install` unaided. The operator's own
  install is `~/.local/bin/claude` → `~/.local/share/claude/versions/2.1.220`, i.e. a per-user native
  install, and `claude install [target]` / `claude update` / `claude doctor` are supported commands.
  The selected bootstrap is therefore **one invocation of the operator's existing binary under the
  actor's identity and HOME**, which is one-time and leaves no steady-state dependency — verified by
  the runbook's own post-check that `/Users/<actor>/.local/bin/claude` exists afterwards. Nothing was
  downloaded or installed.
- Claim (4): HOLDS — `claude auth login|logout|status`, `claude setup-token`, `codex login [status]`,
  `codex logout` and `codex doctor` are the supported interfaces. Non-secret success output is known
  from this host: `claude auth status` emits JSON including `"loggedIn": true` and `"authMethod"`, and
  `codex login status` emits `Logged in using ChatGPT`. A positive "no actor GUI session" check exists
  and needs no privilege: `stat -f '%Su' /dev/console` returns the console owner (`patrik.lindeberg`
  now), `who` lists console sessions, and `pgrep -U <actor-uid>` returning exit 1 proves the actor owns
  no processes at all — a live GUI session always owns some. Hiding the account is safe only **after**
  the attended login, because hiding removes the login route that attended setup may need.
- Claim (5): HOLDS — ordering is settled in the fixture below. The empty-UID premise is made truthful
  by checking it *before* the fixture is created (`pgrep -U` must exit 1), and the signal is gated on a
  second census that must equal the fixture's exact expected member set. An unexpected actor process
  aborts the probe and is never treated as cleanup permission.
- Claim (6): HOLDS — the fixture is returned inline below, reusing the proven escape shape from
  `runs/probes/escaped-descendants-2026-08-07.sh` lines 107–116 (double fork → `setsid` → double fork →
  report pid → `closerange(0,1024)` → `execv("/bin/sleep")`). `/usr/bin/python3` (3.9.6, root-owned,
  mode 755) and `/bin/sleep` (root-owned, 755) are both outside the operator's home, so the actor can
  execute them. `bash -n` returned exit 0 on a temporary copy, which was then removed.
- Claim (7): HOLDS — `git --no-optional-locks -C <checkout> status --porcelain` runs and exits 0 on
  this host, so Git's supported read-only mode is available and C6 needs no index write. `git` is
  `/usr/bin/git`, outside the operator's home. C6 proves traversal, repository recognition and
  `safe.directory` only; the commit test correctly belongs to D5, because the checkout is `755`/`644`
  under uid 501 and the actor has no write access before D2. No credential-helper output is collected.
- Claim (8): HOLDS — every persistent Stage B/C change is paired with a checked rollback below,
  including the case where `claude auth logout` cannot reach a locked keychain.

### Command-support table

| Purpose | Command | Support basis |
|---|---|---|
| create account | `sysadminctl -addUser … -shell /bin/zsh` | local `sysadminctl` usage output |
| delete account | `sysadminctl -deleteUser <name> -keepHome` | local usage output; `-keepHome` chosen so home handling is explicit |
| prove non-admin | `dseditgroup -o checkmember -m <name> admin` | run read-only against the operator; returns a yes/no sentence |
| resolve / reverse-resolve uid | `id -u <name>` / `id -un <uid>` | local, run this unit |
| account absence | `dscl . -read /Users/<name> RecordName` → `eDSRecordNotFound` | local, run this unit |
| Claude bootstrap | `<operator-claude> install` under the actor's HOME | `claude install [target]` in local `--help`; operator's own install is per-user |
| Claude login / status | `claude auth login`, `claude auth status` | local `claude auth --help`; status output observed |
| Codex login / status | `codex login`, `codex login status` | local `codex login --help`; status output observed |
| GUI session detection | `stat -f '%Su' /dev/console`, `who`, `pgrep -U <uid>` | all run read-only this unit |
| select / signal by uid | `pgrep -U <uid>`, `pkill -TERM\|-KILL -U <uid>` | `pkill.1` DESCRIPTION; pattern-free selector measured in Unit 2 via `-g` |
| read-only Git status | `git --no-optional-locks -C <path> status --porcelain` | run read-only this unit, exit 0 |

**One caution carried forward:** `pkill.1`'s SYNOPSIS prints `pattern ...` outside the optional
brackets while its own DESCRIPTION says "If any `pattern` operands are specified". The measurement in
Unit 2 settles it in favour of the DESCRIPTION. C5 is the check that confirms it for `-U`.

### The runbook

Account name for this checkout: **`wlactor-airesources`** (free, checked above). Checkout:
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`.

**Password handling, before anything else.** No command below contains a password literal. `sudo`
prompts for the administrator password itself and does not echo it or place it in `argv`. For account
creation, `sysadminctl -addUser` is run **without** `-password`, so it prompts interactively; if it
does **not** prompt, abort and create the account in System Settings → Users & Groups instead, then
resume at P4. Never paste a password into a command, this file, or the evidence you bring back.

| # | Command | Kind | Pass | Fail → stop |
|---|---|---|---|---|
| P1 | `id -u wlactor-airesources` | `[READ-ONLY]` | "no such user" | any uid printed → name collision, pick another name |
| P2 | `ls -ld /Users/wlactor-airesources` | `[READ-ONLY]` | "No such file or directory" | path exists → stop, do not reuse it |
| P3 | `dscl . -read /Users/wlactor-airesources RecordName` | `[READ-ONLY]` | `eDSRecordNotFound` | a record exists → stop |
| P4 | `stat -f '%Su' /dev/console` | `[READ-ONLY]` | `patrik.lindeberg` | anything else → an unexpected GUI session owns the console |
| **B1** | `sudo sysadminctl -addUser wlactor-airesources -fullName "Work Loop Actor (ai-resources)" -shell /bin/zsh` | `[ADMIN]` | account created | any error → stop, nothing else has changed |
| B2 | `id -u wlactor-airesources` | `[READ-ONLY]` | a uid ≥ 500 | non-numeric or < 500 → stop and roll back |
| B3 | `dseditgroup -o checkmember -m wlactor-airesources admin` | `[READ-ONLY]` | "no … is not a member" | "yes" → **stop and roll back**, the account is an admin |
| B4 | `pgrep -U $(id -u wlactor-airesources); echo $?` | `[READ-ONLY]` | exit `1` | exit `0` → the UID is occupied; exit ≥2 → cannot look, stop |
| **C1a** | `sudo -u wlactor-airesources -H /Users/patrik.lindeberg/.local/bin/claude install` | `[ATTENDED]` | completes | error → stop, roll back |
| C1b | `ls -l /Users/wlactor-airesources/.local/bin/claude` | `[READ-ONLY]` | exists | missing → bootstrap did not install into the actor's home; stop |
| C1c | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth login` | `[ATTENDED]` | login completes | if it needs a browser it cannot reach, log into the actor's desktop session and do C1c/C2 there |
| C2 | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex login` | `[ATTENDED]` | login completes | error → stop, roll back |
| **G** | **If you used the actor's desktop session: log fully out of it. Not fast user switching — log out.** | `[ATTENDED]` | — | — |
| G1 | `stat -f '%Su' /dev/console` | `[READ-ONLY]` | **not** the actor | actor owns the console → C3 would pass for the wrong reason; log out and repeat |
| G2 | `who` | `[READ-ONLY]` | no actor row | actor row present → same, log out |
| G3 | `pgrep -U $(id -u wlactor-airesources); echo $?` | `[READ-ONLY]` | exit `1` | exit `0` → a session survives; exit ≥2 → cannot look, stop |
| **C3** | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth status` | `[READ-ONLY]` | JSON with `"loggedIn": true` | **anything else → STOP AND ROLL BACK.** This is the decisive check |
| C4 | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex login status` | `[READ-ONLY]` | `Logged in using ChatGPT` | anything else → stop, preserve output, offer rollback |
| **C5** | the fixture below, run as the operator | `[SIGNAL]` | `C5 PASS` | any other verdict → stop, preserve output, offer rollback |
| C6a | `sudo -u wlactor-airesources -H git config --global user.name "Patrik Lindeberg"` | `[ATTENDED]` | — | — |
| C6b | `sudo -u wlactor-airesources -H git config --global user.email "<the address in ~/.gitconfig>"` | `[ATTENDED]` | — | — |
| C6c | `sudo -u wlactor-airesources -H git config --global --add safe.directory "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"` | `[ATTENDED]` | — | — |
| C6d | `sudo -u wlactor-airesources -H git --no-optional-locks -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" status --porcelain` | `[READ-ONLY]` | exits 0 and prints a status | "dubious ownership" → C6c did not take; permission denied → traversal is blocked; either way stop |
| H | `sudo dscl . -create /Users/wlactor-airesources IsHidden 1` | `[ADMIN]` | hidden | run **only** after C1–C6; hiding earlier removes the login route setup needs |

### C5 — the fixture, inline and syntax-checked

Run as the operator (uid 501), attended. `bash -n` returned exit 0 on a temporary copy of exactly this
content; the copy was removed and no part of it was executed in this unit.

```bash
#!/bin/bash
# C5 — actor-UID termination boundary probe.
# RUN AS THE OPERATOR (uid 501), attended. Creates ONE actor-owned fully detached
# daemon and ONE uid-501 bystander, proves the boundary before signalling it, then
# runs the exact TERM/grace/KILL/census sequence.
#
# It signals a UID only after five identity guards and one exact-census guard pass.
set -u

ACTOR_NAME="${1:?usage: c5.sh <actor-account-name> <checkout-path>}"
CHECKOUT="${2:?usage: c5.sh <actor-account-name> <checkout-path>}"
GRACE=3

DAEMON=""
BYSTANDER=""

say() { printf '%s\n' "$*"; }

# Kill one recorded actor pid, but ONLY if it still belongs to the actor.
# Guards against pid reuse handing us someone else's process.
kill_actor_pid() {
  local p="$1" owner
  [ -n "$p" ] || return 0
  owner="$(ps -o uid= -p "$p" 2>/dev/null | tr -d ' ')"
  [ "$owner" = "${ACTOR_UID:-x}" ] || return 0
  sudo -u "$ACTOR_NAME" /bin/kill -KILL "$p" 2>/dev/null
}

cleanup() {
  [ -n "$BYSTANDER" ] && kill "$BYSTANDER" 2>/dev/null
  kill_actor_pid "$DAEMON"
  return 0
}
trap cleanup EXIT INT TERM

# ---------------------------------------------------------------- guard 1: uid
ACTOR_UID="$(id -u "$ACTOR_NAME" 2>/dev/null)"
case "${ACTOR_UID:-}" in
  ''|*[!0-9]*) say "REFUSE: '$ACTOR_NAME' does not resolve to a numeric uid"; exit 2 ;;
esac
[ "$ACTOR_UID" -ne 0 ]          || { say "REFUSE: target uid is root";                exit 2; }
[ "$ACTOR_UID" -ne "$(id -u)" ] || { say "REFUSE: target uid is the caller";          exit 2; }
[ "$ACTOR_UID" -ge 500 ]        || { say "REFUSE: uid $ACTOR_UID is a system uid";    exit 2; }
BACK="$(id -un "$ACTOR_UID" 2>/dev/null)"
[ "${BACK:-}" = "$ACTOR_NAME" ] || { say "REFUSE: uid $ACTOR_UID maps to '${BACK:-<none>}', not '$ACTOR_NAME'"; exit 2; }
say "guard 1 OK: $ACTOR_NAME = uid $ACTOR_UID, not root, not caller, maps back"

# ------------------------------------------------- guard 2: boundary is empty
PRE="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; PRE_RC=$?
case "$PRE_RC" in
  1) say "guard 2 OK: actor boundary is empty (pgrep exit 1)" ;;
  0) say "REFUSE: actor uid already has processes; this probe never cleans up a boundary it did not create:"; say "$PRE"; exit 2 ;;
  *) say "REFUSE: pgrep exit $PRE_RC — cannot prove the boundary is empty, so nothing is signalled"; exit 2 ;;
esac

# ------------------------------------------------------------------- fixture
# The proven escape shape, reused from runs/probes/escaped-descendants-2026-08-07.sh:
# double fork -> setsid -> double fork -> report pid -> closerange -> exec a system binary.
# The pid is written to stdout BEFORE the descriptors go, because writing needs one.
DAEMON="$(sudo -u "$ACTOR_NAME" /usr/bin/python3 -c '
import os,sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
sys.stdout.write(str(os.getpid()) + "\n"); sys.stdout.flush()
os.closerange(0, 1024)
os.execv("/bin/sleep", ["sleep", "300"])
')"
case "${DAEMON:-}" in
  ''|*[!0-9]*) say "REFUSE: daemon did not report a numeric pid"; exit 2 ;;
esac

( cd "$CHECKOUT" && exec /bin/sleep 300 ) &
BYSTANDER=$!
sleep 1

# ------------------------------------- guard 3: the fixture is what we think
D_UID="$(ps -o uid=  -p "$DAEMON" 2>/dev/null | tr -d ' ')"
D_PPID="$(ps -o ppid= -p "$DAEMON" 2>/dev/null | tr -d ' ')"
D_PGID="$(ps -o pgid= -p "$DAEMON" 2>/dev/null | tr -d ' ')"
say "daemon pid=$DAEMON uid=$D_UID ppid=$D_PPID pgid=$D_PGID"
say "bystander pid=$BYSTANDER uid=$(id -u) cwd=<checkout>"
[ "$D_UID"  = "$ACTOR_UID" ] || { say "REFUSE: daemon uid $D_UID is not the actor uid"; exit 2; }
[ "$D_PPID" = "1" ]          || { say "REFUSE: daemon ppid $D_PPID != 1 — it did not fully detach"; exit 2; }
[ "$D_PGID" = "$DAEMON" ]    || { say "REFUSE: daemon is not in its own process group"; exit 2; }
FDS="$(sudo -u "$ACTOR_NAME" /usr/sbin/lsof -p "$DAEMON" -a -d 0-1024 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')"
say "inherited descriptors held by the daemon: ${FDS:-<could not inspect>}"

# ------------------------------- guard 4: census matches the expected set EXACTLY
CENSUS="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; C_RC=$?
[ "$C_RC" -eq 0 ] || { say "REFUSE: census exit $C_RC before signalling"; exit 2; }
ACTUAL="$(printf '%s\n' $CENSUS | sort -n | tr '\n' ' ')"
[ "$ACTUAL" = "$DAEMON " ] || { say "REFUSE: actor boundary holds unexpected processes [$ACTUAL]; expected exactly [$DAEMON]"; exit 2; }
say "guard 4 OK: boundary holds exactly the fixture daemon"

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
ps -p "$DAEMON"    >/dev/null 2>&1 && D_STATE=ALIVE || D_STATE=GONE
ps -p "$BYSTANDER" >/dev/null 2>&1 && B_STATE=ALIVE || B_STATE=GONE
say "detached daemon : $D_STATE   (must be GONE)"
say "uid-501 bystander: $B_STATE  (must be ALIVE)"

RC=1
if [ "$F_RC" -eq 1 ] && [ "$D_STATE" = GONE ] && [ "$B_STATE" = ALIVE ]; then
  say "C5 PASS — the actor UID boundary terminated a fully detached descendant and did not overreach"
  RC=0
elif [ "$F_RC" -ge 2 ]; then
  say "C5 FAIL-CLOSED — the census could not run; an inability to look is not a clean boundary"
else
  say "C5 FAIL — daemon=$D_STATE bystander=$B_STATE final-census-exit=$F_RC"
fi
exit "$RC"
```

### Static signal audit

Every signalling call in the fixture, and what bounds its target. There are four, and no fifth.

| Line | Call | What proves the target is safe |
|---|---|---|
| `kill_actor_pid` | `sudo -u <actor> /bin/kill -KILL "$p"` | `$p` is a pid this script recorded, **and** `ps -o uid=` must still show it owned by `$ACTOR_UID` — this is the pid-reuse guard |
| `cleanup` | `kill "$BYSTANDER"` | `$BYSTANDER` is this script's own child, owned by uid 501, signalled by its own owner |
| TERM | `sudo -u <actor> pkill -TERM -U "$ACTOR_UID"` | guards 1–4: numeric uid, not root, not the caller, ≥ 500, reverse-maps to the intended name, boundary was empty before the fixture, and the census equals exactly `[$DAEMON]` |
| KILL | `sudo -u <actor> pkill -KILL -U "$ACTOR_UID"` | same guards; only reached when TERM left survivors and the census could be read |

Because both `pkill` calls run **as the actor**, `man 2 kill`'s EPERM rule makes signalling uid 501 or
root impossible regardless of what the guards did. The guards protect against the actor's *own*
unexpected processes; the kernel protects everyone else.

### Fail-capability matrix

Every row is a way this runbook can return "no". None of them continues setup.

| # | Failure | Detected by | Result |
|---|---|---|---|
| 1 | existing-name collision | P1–P3 | stop before B1; nothing created |
| 2 | malformed / non-numeric uid | C5 guard 1 | refuse, exit 2 |
| 3 | uid is root | C5 guard 1 | refuse, exit 2 |
| 4 | uid is the operator | C5 guard 1 | refuse, exit 2 |
| 5 | uid no longer maps to the intended account | C5 guard 1 reverse-map | refuse, exit 2 |
| 6 | actor UID already occupied | B4 and C5 guard 2 | refuse; never treated as cleanup permission |
| 7 | account was created as an admin | B3 | stop and roll back |
| 8 | Claude bootstrap did not install into the actor's home | C1b | stop and roll back |
| 9 | incomplete GUI logout | G1, G2, G3 | stop; C3 would otherwise pass for the wrong reason |
| 10 | locked keychain / Claude not authenticated | C3 | **stop and roll back** — the decisive failure |
| 11 | Codex status not logged in | C4 | stop, preserve output, offer rollback |
| 12 | C5 daemon survives | final census / `ps -p $DAEMON` | `C5 FAIL` |
| 13 | C5 bystander dies | `ps -p $BYSTANDER` | `C5 FAIL` — overreach |
| 14 | `pgrep`/`pkill` exit ≥ 2 | every census site | `C5 FAIL-CLOSED`; an inability to look is never a pass |
| 15 | read-only Git fails | C6d | stop; traversal or `safe.directory` is wrong |
| 16 | rollback itself fails | R4, R5 | report exactly what remains; do not claim a clean host |

### The three outcomes, unambiguously

**C3 fails.** Stop at once. Run rollback R1–R5. Nothing outside the actor's own account was ever
touched — no ACL, no `sudoers`, no change to the operator's home — so the host returns to its prior
state. Report the exact C3 output, redacted per the template.

**C3 passes but C4, C5 or C6 fails.** Stop. Do **not** proceed to D. Preserve the exact non-secret
output of the failing check plus the checks that passed before it. Rollback R1–R5 is available and is
offered, not forced — the operator may prefer to keep the account to retry the failing check.

**All Stage C checks pass.** Stop with **D and E still forbidden**. What is proved is exactly: a
non-admin actor account can authenticate Claude and Codex on its own credentials, can read this
checkout across the ownership boundary, and its UID is a working termination boundary against a fully
detached descendant without touching a bystander. What is **not** proved: anything about writing or
committing (needs D2), the narrow privilege rule (D4), the dispatcher integration (Unit 3+), or Phase
1a itself — **1a remains open even if every C check passes.** Recommendation: the account **remains**,
hidden by step H, holding no `sudoers` rule, no ACL and no write access to the checkout. Deleting it
would discard the only evidence-bearing artifact and force B and C to be repeated. That the account
persists is itself a new operator decision, not something Stage C authorizes.

### Rollback

| # | Command | Kind | Checked by |
|---|---|---|---|
| R1 | `pgrep -U $(id -u wlactor-airesources)` — census before removing anything | `[READ-ONLY]` | exit 1 expected; exit 0 → list and terminate those pids first via the fixture's guarded path |
| R2 | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth logout` | `[ROLLBACK]` | if it fails because the keychain is locked, that is expected — record it and continue; R4 removes the account and its keychain with it |
| R3 | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex logout` | `[ROLLBACK]` | file-based, so this should succeed; R4 removes `~/.codex` regardless |
| R4 | `sudo sysadminctl -deleteUser wlactor-airesources -keepHome` | `[ROLLBACK]` | `-keepHome` is explicit so home handling is never implicit |
| R5 | `id -u wlactor-airesources` → "no such user"; `dscl . -read /Users/wlactor-airesources RecordName` → `eDSRecordNotFound` | `[READ-ONLY]` | both must hold; if either does not, report it rather than retrying blind |
| R6 | the home at `/Users/wlactor-airesources` remains after R4. Remove it **by hand** only after confirming with `ls -ld` that it is a directory, not a symlink, and that R5 passed | `[ADMIN]` | deliberately not scripted — no unguarded recursive deletion appears in this runbook |

**No rollback step deletes or repurposes a pre-existing account.** Every one names
`wlactor-airesources` literally, and R5 proves the account it removed is the one it meant to remove.

### Operator evidence template

Bring back only this. No passwords, tokens, credential files, Keychain contents or browser data.

```
B2  uid                       : <number>
B3  admin membership          : <the yes/no sentence>
B4  pre-launch census exit    : <0|1|>=2>
C1b actor claude present      : <yes|no>
G1  console owner             : <name>
G3  actor process census exit : <0|1|>=2>
C3  claude auth status        : loggedIn=<true|false>  authMethod=<value>   [REDACT email and orgId]
C4  codex login status        : <the one-line output>
C5  full stdout of the fixture (it contains no secrets)
C6d git status exit           : <0|non-zero>  first line: <text or "clean">
Anything that stopped early   : which step, and its exact non-secret output
```

### Result and evidence

Result: the runbook is complete and internally checked. Preflight, Stage B, C1–C6, the GUI-logout
gate, the C5 fixture, the three outcomes, rollback and an evidence template are all present, and every
command is backed by a local interface this unit actually ran read-only. Three premises that only a
live run can settle — `sysadminctl -deleteUser` home behaviour, whether `claude install` installs into
the invoking user's home, and whether `-password` prompts — are left as visible operator checks with
explicit abort paths rather than promoted to fact. Nothing was executed: no `sudo`, no account action,
no login, no signal.

Evidence: `bash -n` returned exit 0 on a temporary copy of the exact C5 content above, and the copy was
removed (`[ -f ] → GONE`). The static signal audit lists four signalling calls and the guard bounding
each; a fifth would have shown up in the `grep` over the same file, and none did. The fail-capability
matrix has sixteen rows, each terminating in a stop rather than continued setup — so a reader can
check the claim "this can return no" against specific mechanisms instead of taking it on assurance.
The read-only host facts behind the tables were each produced by a command run in this unit: `id`,
`dscl`, `dseditgroup`, `stat -f '%Su' /dev/console`, `who`, `/etc/paths`, `ls -l` on
`/usr/bin/python3`, `/bin/sleep`, `/usr/sbin/lsof`, and `git --no-optional-locks … status`.

The runbook being well formed proves nothing about the route. Only the operator's later run supplies
the missing host evidence, and **Phase 1a stays open even if every Stage C check passes.**

## Blocker

None for this unit. The dedicated route remains blocked on the operator's later execution of C3, C4,
C5 and C6, which this unit must not and did not manufacture.

## Next action

Codex: assess the runbook against the brief's eight claims and its required evidence — in particular
whether the C5 guards bound the signal tightly enough, whether the three runtime-dependent premises are
correctly left as operator checks rather than asserted, and whether the fail-capability matrix would
actually stop a bad run rather than merely describe one.

Then the operator executes Stages B and C. D and E stay forbidden, and 1a stays open regardless of the
Stage C outcome.
