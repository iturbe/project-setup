---
name: next
description: Run one micro-loop on the next deliverable (or the one named). Define done in STATE.md, research, and implement the smallest change. Then verify up the ladder with scripts/verify.sh, queue human checks, record, bump the build version and commit. Enforces 5 attempts and the 3-strike no-progress rule. Use when the user says "next", "keep going", "build the next thing", or names a deliverable to work on.
argument-hint: "[deliverable name]"
---

# One Micro-Loop

Deliverable: $ARGUMENTS (if empty, the first open, unblocked deliverable of the active milestone in `STATE.md`).

1. **Define done.** In the deliverable's `STATE.md` entry, write `Done when:` (verifier levels and test IDs) and set `Status: in progress`, before writing any code. Without a check you can write, the deliverable is not ready: rewrite it into something checkable, or queue a DECIDE item and pick another deliverable.
2. **Research.** Read the lessons and `docs/PLATFORM_CONSTRAINTS.md` for this area. Look up every API in the installed docs, stubs or type definitions, not memory. If an unverified platform assumption is load-bearing, run `/spike` first.
3. **Implement** the smallest change that could pass. New logic goes in the pure core; adapters stay thin; numbers go in the tunables file; user-facing text goes in the text table.
4. **Verify:** run `scripts/verify.sh`. Read its own exit code; never pipe it through `tail`. Make sure it built *your* files (check the path or version it prints).
5. **On failure:** record the attempt in `STATE.md` (`Attempt n: what was tried → result`), then fix and go back to step 4.
   - **5 attempts** → stop. Mark `blocked`, add a lesson (`/lesson`), queue what the owner can do, and move on.
   - **The same error or an unchanged result 3 times in a row** → stop now, even with attempts left.
   - **Never weaken, skip or delete a test** to pass. A test changes only when its requirement changed, logged as a decision.
6. **Human checks:** anything visual, spatial, or about feel goes to the human channel (`/queue`, or the pending iteration plan). Status becomes `done, pending human check`. Do not wait.
7. **Record:** finish the `STATE.md` entry, tick `ROADMAP.md`, update `docs/PROJECT_SPEC.md` if behavior or architecture changed, bump the patch of `BuildVersion`, and append to `log.md`.
8. **Commit** with the docs, gated on the verifier: `scripts/verify.sh && git commit -m "<milestone>: <deliverable> (build <version>)"`.
9. **Continue** with the next deliverable unless the owner asked for only one, or a hard stop applies.

For long unattended runs, use subagents for broad searches, and the `reviewer` agent before declaring a milestone closed.
