---
name: start
description: Run the session start ritual from AGENTS.md - read STATE.md's Resume here block, LESSONS_LEARNED.md, the active milestone and the human channel, apply any owner answers, run the pre-flight, and pick the next deliverable. Use at the beginning of a working session, after a context reset, or when the user says "start", "resume", "pick up where we left off" or "what's next".
---

# Start a session

1. **Placeholders?** If `AGENTS.md` still contains unfilled double-brace placeholders, stop and tell the owner to run `/kickoff`.
2. **Read**, in this order:
   - `STATE.md` → **Resume here**, then the current milestone block.
   - `LESSONS_LEARNED.md`, in full.
   - The active milestone's section of `ROADMAP.md`, and nothing more of it.
   - The last ten lines of `log.md`.
   - The human channel (`docs/HUMAN_QUEUE.md` or the latest `docs/ITERATION_PLAN.md`).
3. **Apply owner answers first.** For each answered item: update the deliverable's status in `STATE.md`, record design answers in the Decisions log, update `docs/PLATFORM_CONSTRAINTS.md` if a platform fact was settled, tick `ROADMAP.md` where a human-verified line passed, and clear the item. If something failed, add or reopen a deliverable for the fix.
4. **Pre-flight:** run the checks in `AGENTS.md` → Session start ritual, step 5, and `docs/ENVIRONMENT.md` → Pre-flight. On a failure, queue a SETUP item (`/queue`) and continue with work that doesn't need the failing piece. If nothing can proceed, stop and say exactly what the owner must do.
5. **Pick a deliverable:** the first one in the active milestone that is not done and not blocked on the owner. If none is left, check the milestone's exit criteria and the autonomy policy for advancing.
6. **Say it** in one or two sentences: which deliverable, and why. Then run its micro-loop (`/next`).

Don't re-read files that the SessionStart hook already printed. Don't ask the owner anything that `docs/OPEN_QUESTIONS.md` or `STATE.md` already answers.
