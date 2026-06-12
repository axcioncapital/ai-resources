# Setup: Two Concurrent-Session Safety Hooks (one-time, per machine)

> **For:** Daniel
> **From:** Patrik
> **Time needed:** ~5 minutes
> **You do this once, on your own machine.**

---

## Why you're doing this

Patrik and you both run Claude Code against the same shared workspace, sometimes at the same time. When two sessions touch the same files, one session can accidentally sweep the other's work into a commit — silently. We built two small safety scripts ("hooks") that catch this:

- **`check-foreign-staging.sh`** — blocks a commit if it's about to include files that belong to another live session. (Hard stop.)
- **`detect-concurrent-session.sh`** — warns you at session start if another Claude Code session is already running on your machine. (Soft nudge.)

These scripts already run on Patrik's machine. They live in the shared `ai-resources` repo, so the **code** is on your machine too (you have the repo). But each machine has to **register** the hooks in its own personal Claude Code settings file. That registration is machine-local — it does not travel through git. **Until you do this, you have zero concurrent-session protection.**

There is no risk in doing this: the hooks are advisory safety nets. The worst case is a warning you can ignore.

---

## The easy way (recommended): let Claude Code do it

1. Open Claude Code in your **`ai-resources`** folder (the shared resource repo).
2. Paste the prompt below **exactly** and send it. It tells Claude to find the right path on your machine and add the two registrations without disturbing anything else in your settings.

```
Please register two safety hooks in my user-level Claude Code settings (~/.claude/settings.json), one time, on this machine.

Steps:
1. Resolve the absolute path to THIS ai-resources checkout (the git root of the current folder). Call it AIRES.
2. Confirm both hook scripts exist:
   - AIRES/.claude/hooks/check-foreign-staging.sh
   - AIRES/.claude/hooks/detect-concurrent-session.sh
3. Open ~/.claude/settings.json. MERGE (do not overwrite) these two registrations into the existing "hooks" object. If a "hooks", "PreToolUse", or "SessionStart" key already exists, ADD to its array — never replace or delete anything that is already there:

   PreToolUse, matcher "Bash":
     { "type": "command",
       "command": "bash \"AIRES/.claude/hooks/check-foreign-staging.sh\"",
       "timeout": 5,
       "statusMessage": "Foreign-staging tripwire..." }

   SessionStart (no matcher):
     { "type": "command",
       "command": "bash \"AIRES/.claude/hooks/detect-concurrent-session.sh\"",
       "timeout": 5,
       "statusMessage": "Checking for concurrent sessions..." }

   Substitute the real resolved AIRES absolute path into both "command" strings.
4. If a registration for either of these two scripts is already present, do nothing for that one (do not add a duplicate).
5. Show me the final "hooks" block so I can confirm, and tell me whether each hook was newly added or already present.
```

3. Read back the final block Claude shows you. You should see **both** script paths, each pointing at your own machine's `ai-resources` folder. Done.

That's it. You don't need the rest of this file unless you'd rather do it by hand.

---

## The manual way (if you prefer to edit the file yourself)

1. Find the absolute path to your `ai-resources` folder. In a terminal, `cd` into it and run `pwd`. Copy what it prints — call it your **AIRES path**. (On a standard setup it will look like `/Users/<your-username>/Claude Code/Axcion AI Repo/ai-resources`.)

2. Open your personal settings file: `~/.claude/settings.json`.

3. Find the `"hooks"` section (if there's no `"hooks"` key at all, you'll add one). Inside it, you need a `"PreToolUse"` entry and a `"SessionStart"` entry. **Add to whatever is already there — don't delete your existing hooks.** The two pieces to add:

   **Under `PreToolUse`** (an array of matcher-blocks). Add a block with matcher `"Bash"`:

   ```json
   {
     "matcher": "Bash",
     "hooks": [
       {
         "type": "command",
         "command": "bash \"<AIRES>/.claude/hooks/check-foreign-staging.sh\"",
         "timeout": 5,
         "statusMessage": "Foreign-staging tripwire..."
       }
     ]
   }
   ```

   **Under `SessionStart`** (an array; no matcher needed):

   ```json
   {
     "hooks": [
       {
         "type": "command",
         "command": "bash \"<AIRES>/.claude/hooks/detect-concurrent-session.sh\"",
         "timeout": 5,
         "statusMessage": "Checking for concurrent sessions..."
       }
     ]
   }
   ```

4. Replace **both** `<AIRES>` placeholders with your real AIRES path from step 1. Keep the surrounding quotes exactly as shown — the path has spaces in it, so the inner `\"` quotes matter.

5. Save. Make sure the file is still valid JSON (commas between items, no trailing comma after the last one). If you're unsure, paste the file to Claude Code and ask it to check the JSON is valid.

### What a complete example looks like

If your AIRES path were `/Users/daniel/Claude Code/Axcion AI Repo/ai-resources`, the relevant part of your settings would read:

```json
"hooks": {
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "bash \"/Users/daniel/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh\"",
          "timeout": 5,
          "statusMessage": "Foreign-staging tripwire..."
        }
      ]
    }
  ],
  "SessionStart": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash \"/Users/daniel/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh\"",
          "timeout": 5,
          "statusMessage": "Checking for concurrent sessions..."
        }
      ]
    }
  ]
}
```

(Your username and folder location may differ — use what `pwd` gave you.)

---

## How to know it worked

- **`detect-concurrent-session.sh`** fires the next time you start a Claude Code session. If you have a second session open at the same time, you'll see a one-line note about concurrent sessions. If you only have one session, you see nothing — that's correct.
- **`check-foreign-staging.sh`** only acts at commit time, and only when there's actually a foreign file about to be swept in. Day to day you won't notice it. That silence is the point.

You don't need to test them by forcing a collision. If the registration is in your settings file and points at real script paths, they're live.

---

## Notes

- **One requirement:** the scripts use `python3` and `pgrep`, which come standard on macOS. Nothing to install.
- **These are safety nets, not enforcement.** They never override Claude; they surface a warning or stop a risky commit so you can decide. If one ever fires in a way that seems wrong, leave the commit alone and message Patrik.
- **You only do this once per machine.** If you later move or rename your `ai-resources` folder, the paths in your settings will need updating — ping Patrik if that happens.
