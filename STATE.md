# STATE.md: loop log

Where things stand. A fresh session reads **Resume here** and the current milestone block, and can continue with no chat history. Newest milestone block at the top. If a decision changes, add a new entry; never edit an old one.

**Keep it navigable.** When a milestone closes, collapse its deliverable entries into a 3–5 line summary under **Milestone history**. Move long narratives to `docs/` (for example `docs/runs/<date>-<topic>.md`) and link them. `scripts/check_docs.sh` warns when this file grows past 60 KB.

---

## Resume here (updated {{DATE}}; build 0.0.0)

- **Now:** the project was created from the seed. Next: `/kickoff`.
- **Next action:** {{one concrete action, with the exact command if there is one}}
- **Waiting on the owner:** {{count and ids, or "nothing"}}
- **Machine:** {{where this runs, and anything a new machine must redo; see docs/ENVIRONMENT.md}}

---

## Current milestone: M0: Toolchain and walking skeleton

**Status:** not started
**Exit criteria:** see `ROADMAP.md` → M0.

### Deliverables

<!-- One entry per deliverable, in this shape. Write "Done when" BEFORE writing code.

#### <Deliverable name>
- Status: not started | in progress | done | done, pending human check | blocked
- Done when: <the check: verifier levels and test ids that must pass>
- Attempts: <n>
  - Attempt 1: <what was tried> → <verifier result>
- Notes: <what was built, where, non-obvious choices>
- Owner: none | <queue id or iteration item waiting on the owner>
-->

---

## Decisions log

Dated. One line for what, one for why. Never edit an old entry; reverse a decision with a new one.

- **{{DATE}} · Seed** — Project created from `iturbe/project-setup`. **Why:** a common starting point for agentic development.

---

## Dead ends

Approaches that failed for a reason that will still be true next session. Record platform reasons in `docs/PLATFORM_CONSTRAINTS.md` too, so no later session retries them.

- (none yet)

---

## Milestone history

Closed milestones, 3–5 lines each: what shipped, the final build, what was carried forward.

- (none yet)
