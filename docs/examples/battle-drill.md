# Example: Battle Drill

*A Fortnite creator island built in UEFN with Verse. It teaches squads of 2–4 players real small-unit tactics in missions of five minutes or less. The owner was new to UEFN and Verse; Claude did all the code and most of the editor work through Epic's MCP server, and the owner tested on a PS5.*

**What it contributed:** the loop protocol (macro = milestone, micro = deliverable, 5 attempts, 3-strike no-progress rule), the L0–L3 verifier ladder, the in-game AutoTest contract, the iteration hand-off document, design invariants with reasons, and a lessons file with dated corrections.

## The micro-loop, as written in its CLAUDE.md

> 1. **Define done.** Write the deliverable's checkable termination condition into its `STATE.md` entry before writing code: which verifier levels apply and which AutoTest IDs must pass. If you cannot write a check, the deliverable is not ready; rewrite it or escalate.
> 2. **Research.** Look up every Verse API you intend to use in the project's generated digest files. […]
> 3. **Implement** the smallest change that could satisfy the check.
> 4. **Verify L1** (compile). Fix and repeat until clean.
> 5. **Verify L2** (AutoTest) once L1 is clean, if the deliverable has automated tests.
> 6. **Human gate (L3)** if the deliverable has anything visual, spatial or experiential. Print the checklist and wait.
> 7. **Record.** Update the `STATE.md` entry, tick the `ROADMAP.md` checkbox, update `project_spec.md`, bump the build version, commit.

Generalized in `AGENTS.md` → Loop protocol.

## A STATE.md deliverable entry

> #### I9-1. Fix and Flank: squad-wide fix
> - Status: **done, pending PS5 check** (L1 clean; F10 desk-checked)
> - Done when: L1 clean; `F10-squad-wide-fix` expects "Flank Unsupported SelfFix Unsupported".
> - Attempts: 1. `flank_tracker.SquadWideFix` and `FixerFor` (prefers a fixer other than the attacker; any live fix on any guard within the decay); `FixSquadWide` true and `FixDecayDefaultSeconds` 6.0 in `bd_tunables.verse`; wired in `MakeRun`. Facing is not part of the rule (Alonso's theory); the old per-guard rule explains the "sometimes" […].

Note the honest status: "done, pending PS5 check", and "desk-checked", not "tested".

## The AutoTest contract

> ```
> AUTOTEST: BEGIN build=<version> count=<n>
> AUTOTEST: PASS <ID> <short detail>
> AUTOTEST: FAIL <ID> <expected> | <actual>
> AUTOTEST: END pass=<n> fail=<n>
> ```
> IDs are stable and unique (`T01-fix-decay`, `T07-score-grade`). `AutoTestEnabled` is `false` in anything that gets published; check before every publish gate. Because no input can be sent to the client, scenarios test logic by feeding synthetic events into pure classes. This is why the architecture rule below exists.

It reached `AUTOTEST: END pass=104 fail=0` once the project moved to a machine where the game client could run. Generalized in `docs/playbook/VERIFICATION.md`.

## The iteration hand-off ("Build Plan vN")

> **Every iteration ends with a new Google Doc, "Battle Drill Build Plan vN".** Use the next number, and never edit an older version […]
> 1. **Where things stand.** The conclusion first: what is ready, what is blocked, what is waiting on Alonso.
> 2. **What was just built and needs human testing.**
> 3. **Checklist.** […] Then a second numbered list that matches it one-to-one: 2–6 word entries, each ending with an empty `Decision: `. Type its numbers as text, so they survive a copy-paste.
> 4. **Closing points to keep in mind.**
> 5. **Future loop suggestions.**

A checklist item and its short-list line, from Build Plan v9:

> 21. **Exercise area.** Walk well out of an arena: do you see "OUT OF THE EXERCISE AREA: go back to the marked ground"? Decision: is that enough, or should I try a glowing wall you can walk through […]?
>
> 1. Publish 0.10.0 and HUD line: Decision:

And its honesty about verification:

> **Nothing has been played** (the build PC is a virtual machine), so every "works" below means "built and checked on paper", not "seen".

Generalized in `docs/ITERATION_PLAN.md`.

## Design invariants with reasons

> - **No chests, anywhere, ever.** Players get gear from a loadout at mission start and from drops off eliminated enemies.
> - The wrong approach must visibly fail and the right one must visibly work. If a frontal rush succeeds, the mission is broken.
> - **No menus after launch.** […] On-screen UI is passive only […]. The reason is immersion. Added by Alonso on 2026-10-10.

## A lesson with a correction

> - **Rule:** Don't try to run Fortnite, UEFN play sessions, AutoTest (L2) or the memory calculation on a virtual machine. Easy Anti-Cheat refuses with "Cannot run under Virtual Machine." […]
>   **Because:** 2026-10-09: repairs, reinstalls and reboots all failed. […]
>   **Correction (2026-10-13):** not every VM is refused. The QXL/KVM VM was; an **AWS EC2 g6f.2xlarge** (NVIDIA L4 vGPU) runs the client under Easy Anti-Cheat, and L2 works there. […] test with one `StartSession` rather than assuming.

The lesson stays, corrected, so nobody repeats either mistake.

## A dead end, recorded so nobody retries it

> ### F1. Verse device references cannot be wired through MCP — **dead end**
> - **Tried:** `DeviceToolset.SetDeviceProperty` and `ObjectTools.set_properties` […]
> - **Result:** every attempt: "`<path>` is not valid guard_spawner_device". […]
> - **Consequence:** device references are set by hand […]. The design therefore **minimizes references** […] and every mission **degrades gracefully** when a reference is missing.

A later spike found Verse tags *could* be assigned, and the rule moved to "discover devices by tag". See `docs/playbook/ARCHITECTURE_PATTERNS.md` §8.

## What to avoid (learned here)

- `STATE.md` grew to about 100 KB of iteration narrative. Every session paid to read it. The seed now collapses closed milestones and warns on size.
- Several resume blocks stacked up ("Earlier resume block …"). Keep one **Resume here**; move history down.
