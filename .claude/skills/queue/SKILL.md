---
name: queue
description: Add an item for the owner to the human channel (docs/HUMAN_QUEUE.md in queue mode, or the pending docs/ITERATION_PLAN.md in iteration mode). Use the project's exact format: a type (SETUP, TEST, MEASURE, FEEL, DECIDE or PUBLISH), numbered steps, a matching checklist, the build, who runs it and where. Use whenever work needs the owner (credentials, a device, a judgment, a decision, a publish), so the agent can keep working instead of waiting.
argument-hint: "<TYPE> <what is needed>"
---

# Queue an Item for the Owner

Request: $ARGUMENTS

1. **Find the channel:** `AGENTS.md` → Human-loop mode. Queue mode → `docs/HUMAN_QUEUE.md`. Iteration mode → the checklist of the pending `docs/ITERATION_PLAN.md` (both the detailed item and its short-list line with `Decision:`).
2. **Fold before adding.** If a TEST item is already pending, add the new steps to it rather than creating another. Do not duplicate a question that `docs/OPEN_QUESTIONS.md` already answers.
3. **Write the item** in the format at the top of the channel file:
   - the next free id (`Q<nn>`), the TYPE, where (machine, device, website), minutes, and what it blocks;
   - the build to expect, and where it shows on screen;
   - who runs it: the owner, or the robot with nobody touching anything;
   - one action per numbered step, with menus, buttons and labels named exactly as on screen, written for a first-time user of that tool;
   - checks numbered to match the steps, phrased as observable yes/no, asking for numbers where possible;
   - for DECIDE: the recommended option first, each option with its consequence.
4. **Sort:** blocking items first, then group by where the owner needs to be.
5. **Link it.** Put the id in the deliverable's `STATE.md` entry (`Owner: Q<nn>`) and set its status (`done, pending human check` or `blocked`). Update the open count in **Resume Here**.
6. **Keep working** on something that does not depend on it. If the item blocks progress, mention it once in your end-of-turn summary, with roughly how long the queue takes to clear.
