# Example: Shockwave Playground

*A second Fortnite island: one hub, five movement mini-games built on infinite shockwave grenades. Version 0.1 was core mechanics only, so the owner and friends could decide which modes deserved a full build. Written after Battle Drill, and started by importing what Battle Drill had proved.*

**What it contributed:** the autonomy policy ("minimum oversight"), the human queue with typed items, robot runs that assert outcomes in the world, measurement sessions, a release-mode script, a project-to-project lessons import, and exported agent memory.

## Autonomy policy

> - **Never wait idle.** When a deliverable needs Alonso, write the item to `docs/HUMAN_QUEUE.md`, mark the deliverable `done, pending human check` (if everything automatable passed) or `blocked`, and move to the next deliverable that doesn't depend on it.
> - **Batch.** Alonso clears the queue in one sitting. Aim for one sitting per milestone, at most two. Group items by where he needs to be (VM editor, VM game client, PS5, browser).
> - **Decide within the design.** If something is ambiguous but small (a number, a layout detail, a label), pick the option most consistent with `docs/DESIGN.md`, log it as a decision in `STATE.md`, and keep going. Ask only when the choice changes what a mode *is*.

Generalized in `AGENTS.md` → Autonomy policy.

## A queue item

> ### Q08 · PUBLISH (preview) · UEFN on the Shadow PC, then Switch 2 / PS5 · ~15 min plus the friends session · blocks: M8 playtest
> Build: set by Claude when Q06 passes (0.0.19 or later)
> Do:    1. In UEFN: **Project → Publish Project → Continue**; copy the **Private Link Code** (`1234-5678-9012`). "Memory Usage: Not Yet Calculated" is expected and doesn't block it.
>        2. Tell Claude "published <code>".
>        3. On the Switch 2 or PS5: **Discover → Island Code**, enter the code; check the bottom-left footer shows the build Claude names.
> Check: [ ] private code works on a console and shows the right build
>        [ ] friends could join (say which route worked: party invite, or Creator Portal playtest)
> Reply: the code, which join route worked, pass/fail per line.

Exact labels, the build to expect, what "normal" looks like, and a reply format. Template: `docs/HUMAN_QUEUE.md`.

## Measurement sessions

> Some numbers (shockwave launch height, jump height, ball travel) can only come from a human throwing grenades. When you need them, add a MEASURE item to the queue that tells Alonso exactly what to do in a session, and write a Verse `measure_device` that logs `SP: MEASURE <name> <value>` lines […]. After he runs it, parse the log yourself and update the tunables. He does the throwing; you do the numbers.

## Robot runs that check the world

> **Rule:** never put an effectful call inside `not` […]. Robots must assert the outcome in the world (position, state), not just that the call ran.

A robot run ended with lines like `DROBOT jump ok=1 stand=1 floor=1` and `END ok=1`. Generalized in `docs/playbook/VERIFICATION.md`.

## An AutoTest report

> # AutoTest PASS — build 0.0.3 — 20261014-125803
> pass=41 fail=0
>
> | Result | ID | Detail |
> |---|---|---|
> | PASS | MM01-start-from-hub | Hub -> Loading -> Countdown -> Round with the right requests |
> | PASS | AS02-grounded-hit-scores-zero | grounded shooter scores nothing and gets the message |

## Importing from a sibling project (M0 deliverable 1)

> **1. Import from Battle Drill** — […] read its `STATE.md`, `docs/AUTOMATION_MATRIX.md`, `docs/UEFN_CONSTRAINTS.md` (verified + dead ends) and `docs/ENVIRONMENT.md`; copy every verified fact and dead end into this repo's `docs/UEFN_CONSTRAINTS.md` and `LESSONS_LEARNED.md` with "(from Battle Drill, <date>)" […].

The seed generalizes this: `LESSONS_LEARNED.md` → **Inherited**, and `/kickoff` asks whether a sibling project exists to import from.

## Agent memory, exported to the repo

> Copies of Claude Code's memory notes for this project (written 2026-10-23, before leaving the AWS EC2 VM). They hold what isn't already in the repo: how Alonso likes to work and where things live.

Two of those notes became `docs/OWNER.md`:

> Each test run is one queue item: build number, where it runs and how to start it, numbered steps grouped by mode, and a checklist whose lines match the step numbers. […] **Why:** Alonso said "be very clear on what things i need to do in each test run so i don't miss them" (2026-10-14) […].

> Whenever a play session is needed, say explicitly who plays it (Alonso, or the Verse robot with nobody touching anything) and where […].

## Pre-approved permissions

Its `.claude/settings.json` allowed reads, edits, git basics and Python, and denied `git push --force`, `git reset --hard` and `rm -rf`. The seed's settings extend that with hooks.
