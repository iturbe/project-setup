---
name: handoff
description: End a session cleanly so a fresh one can continue without the chat. Update STATE.md's Resume Here block, record lessons, append to log.md and queue owner items. Then run the verifier and the security check, commit and push. Use before stopping, before a long autonomous run ends, before a machine move, or when the user says "wrap up", "hand off", "save progress" or "end the session".
---

# Hand-Off

1. **Resume Here** (`STATE.md`): the date and build, and what is done since the last hand-off. Then the exact next action with its command, and what is waiting on the owner (ids). Last, the machine, and anything a new machine must redo.
2. **Deliverable entries:** every entry touched this session has a current status and its attempts recorded. Nothing says `done` without a verifier run.
3. **Lessons:** anything that surprised you or cost an attempt goes to `LESSONS_LEARNED.md` (`/lesson`).
4. **Owner items:** everything waiting on the owner is in the human channel, sorted. In iteration mode, if the batch is complete, write the iteration plan (`/iteration-plan`).
5. **log.md:** one line: date · what changed · what is still missing.
6. **Size check:** if a milestone closed, collapse its entries into **Milestone history**. `scripts/check_docs.sh` warns when files grow too large.
7. **Verify and check:** `scripts/verify.sh` and `scripts/security_check.sh`. If the verifier fails, record it in Resume Here; do not hide it, and do not commit broken code over working code. Commit the docs, and stage the broken work on a branch.
8. **Commit and push:** `git add -A && git commit -m "<milestone>: hand-off (build <version>)" && git push`. In a cloud session the container is ephemeral; unpushed work is lost.
9. **Memory:** if you saved Claude memory notes this session, copy anything durable into the repo (`docs/OWNER.md`, lessons, or `docs/claude-memory/`).
10. **Tell the owner,** in three to five lines: what got done, what is waiting on them and roughly how long it takes, and what happens next.

Test: could a fresh session continue from the files alone? If it would need this chat, the hand-off is not done.
