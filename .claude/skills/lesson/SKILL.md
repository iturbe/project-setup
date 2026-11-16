---
name: lesson
description: Record a lesson in LESSONS_LEARNED.md as a dated rule (and in docs/PLATFORM_CONSTRAINTS.md if it is about the platform), or correct an existing lesson without deleting it. Use whenever an attempt failed for a reason the docs did not make obvious, or something surprised you. Also use it when the owner corrects the agent's approach, or the user says "remember this", "add a lesson" or "do not do that again".
argument-hint: "<what happened>"
---

# Record a Lesson

What happened: $ARGUMENTS

1. **Is it worth a lesson?** Yes if it cost an attempt, would cost the next session one, or the owner corrected the approach. No if it is already a rule in `AGENTS.md` or `LESSONS_LEARNED.md` (then the rule was ignored: follow it, and do not duplicate it).
2. **Write one line** under **This project**, newest first:
   `- **<YYYY-MM-DD> · <area>.** <what happened, concretely>. **Rule:** <what to do from now on, imperative and checkable>.`
   A rule says what to *do* ("Gate commits on the verifier's exit code"), not just what went wrong.
3. **If it corrects an older lesson,** do not delete it: add `**Correction (<date>):** …` under it, and log the change in `STATE.md` → Decisions log.
4. **If it is about the platform,** also update `docs/PLATFORM_CONSTRAINTS.md` (verified, dead end, or a limit with its number).
5. **If a tool proved unreliable,** mark it in `docs/AUTOMATION_MATRIX.md`.
6. **If the same class of bug has now happened twice,** propose a lint or a test that catches it, and add it to L0 or L2.
7. **If it would help any project,** say so in your summary, so the owner can copy it to the seed repo's **Inherited** section.
