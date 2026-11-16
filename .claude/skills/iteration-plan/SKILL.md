---
name: iteration-plan
description: Write the end-of-iteration hand-off for the owner (iteration mode). Each version of docs/ITERATION_PLAN.md says where things stand and what needs human testing. It holds a detailed checklist with a matching short list ending in "Decision:", closing points and next-loop suggestions, and can also be published to Google Docs or as an artifact. Use when an iteration's batch is built and verified, or when the user asks for "the build plan", "the hand-off doc", or "what do I need to test".
argument-hint: "[version number]"
---

# Iteration Plan

1. **Archive** the current `docs/ITERATION_PLAN.md` as `docs/iterations/ITERATION_PLAN_v<N-1>.md`. Old versions stay unedited.
2. **Carry forward** every unanswered item from the old plan into the new one, so the owner only ever needs the latest.
3. **Write v<N>** from the template's sections, in this order:
   1. **Where things stand:** the conclusion first: ready, blocked, waiting on the owner. Say exactly what was verified and how ("compiled and unit-tested", "desk-checked", "seen on the device"). Never let "built" read as "works".
   2. **What was just built and needs human testing**, with the build number.
   3. **Checklist.** 3a holds the detailed numbered items: what to do, what to look for, and the options with a recommendation first. 3b is the short list: one line of 2–6 words per item, ending with an empty `Decision:`. Type the numbers as text (`1\.`). Put open design questions here, *before* building anything subjective.
   4. **Closing points to keep in mind:** reminders, platform limits, surprises.
   5. **Future loop suggestions:** what is next on the roadmap, and a recommendation.
4. **Publish outside the repo only if the owner reads it there** (check `docs/OWNER.md` and `STATE.md`). For Google Docs, load the `google-workspace` skill and upload it as HTML generated from this file; for an artifact, use the Artifact tool. Read it back, and confirm the numbering survived.
5. **Point to it:** update `STATE.md` → Resume Here (version and link), and append a line to `log.md`. Commit.
6. **Stop.** Tell the owner in two or three lines what is in it and how to reply: paste the short list with notes after each `Decision:`. Their reply opens the next iteration. Record every answer in `STATE.md` before starting new work.
