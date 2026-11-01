---
name: spike
description: Settle one risky platform or API assumption with the smallest possible experiment, and record the result in docs/PLATFORM_CONSTRAINTS.md as verified, disproved (with the nearest alternative) or still unverified. Use before building on an unproven capability, when docs and memory disagree, or when the user says "spike", "check whether X is possible", or "test that assumption".
argument-hint: "<the assumption to test>"
---

# Spike

Assumption: $ARGUMENTS

1. **Write the question** as one yes/no sentence, and the observation that would answer it. Add it to `docs/PLATFORM_CONSTRAINTS.md` → Unverified if it isn't there.
2. **Check what is known:** `docs/PLATFORM_CONSTRAINTS.md` (verified and dead ends), `LESSONS_LEARNED.md`, `docs/AUTOMATION_MATRIX.md`. Don't redo a dead end unless the platform version changed.
3. **Build the smallest experiment** that produces the observation: a scratch file, a test, one tool call, a probe that logs `<PREFIX>: SPIKE <id> <value>`. Keep it out of the product code, or behind a flag.
4. **Run it.** If it needs a human (a device, a game client, a judgment), queue a MEASURE or TEST item with exact steps and what to report, and move on.
5. **Record the result** with the date, the platform version and the evidence (the exact output or error):
   - **Verified** → move it to Verified; update the design and the automation matrix if it unlocks something.
   - **Disproved** → move it to Dead ends with the nearest workable alternative, and add a lesson if it cost an attempt.
   - **Inconclusive** → leave it under Unverified with what was learned and what would settle it.
6. **Report in two lines:** the answer, and what it changes in the plan. If it changes what the product *is*, queue a DECIDE item.

Remember the two-strikes rule: a tool that fails twice with the same error is unreliable for this task. Record it and route around it.
