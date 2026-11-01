# The human in the loop

The owner's time is the scarcest resource in the project. Everything here is about using less of it, more effectively.

## Two modes (chosen at kickoff)

| | **Queue mode** (Shockwave Playground) | **Iteration mode** (Battle Drill) |
|---|---|---|
| Channel | `docs/HUMAN_QUEUE.md`, a living list | `docs/ITERATION_PLAN.md`, a new version per iteration |
| Rhythm | Continuous. The agent never waits; the owner clears the queue when convenient | Batched. The agent builds a batch, verifies, hands over one document; the reply opens the next iteration |
| Best for | Minimum oversight, long autonomous runs, many small checks | Projects where each test sitting is expensive (publish + console), or design is still moving |
| Owner's reply | pass/fail under each item, then "queue done" | the short list pasted into chat, with notes after each `Decision:` |

Both modes share the same rules below. A project can switch modes as a logged decision.

## Rules for every item

1. **Batch.** Aim for one sitting per milestone (two at most). Group items by where the owner needs to be: which machine, which device, which website.
2. **Blocking first.** Sort by what unblocks the most work.
3. **Exact steps.** One action per numbered line. Name menus, buttons and on-screen labels exactly as they appear. Assume a first-time user of the tool.
4. **Matching checklist.** Each check is numbered to match its step, and phrased so yes or no is unambiguous.
5. **Build number.** Say which build to expect and where it shows.
6. **Who and where.** Say who runs it (the owner, or the robot with nobody touching anything) and on which device.
7. **Numbers over impressions.** "How many seconds did it take?", "Did the wall stop you, yes or no?"
8. **Recommendation first.** Every `DECIDE` item leads with the recommended option and its consequence.
9. **Fold, don't scatter.** New features join the pending test run rather than getting their own item.
10. **Apply answers first.** At the next session start, apply the owner's answers before any new work, record them in `STATE.md`, and clear the items.

## Quick in-session gate

For a check you need right now in an interactive session (wire five dropdowns, glance at one screen), print it as its own block and wait:

```
HUMAN GATE — <deliverable> (build <version>)
Do:    1. <exact click path or action>
       2. ...
Check: [ ] 1. <observable thing, unambiguous yes/no>
       [ ] 2. ...
Reply with pass or fail per line, plus anything odd you noticed.
```

Don't continue with work that depends on it. Anything that needs a publish, a console, or more than a few minutes goes in the channel instead.

## Decision rounds

When many questions pile up (content projects especially), run them as a round:
1. Stage 15–30 questions, grouped by how much each settles (foundations first: one answer can settle ten later questions).
2. The owner answers in any order and skips freely. In Timeline Writer, answers saved as they went in the app, which beat chat.
3. Apply the answers: mechanical ones apply themselves; answers in words get the records edited.
4. Record each answer as a ruling that every later step respects. Never ask it again.

## Design questions before subjective work

Ask open design questions (look, feel, ambiance, scope) **before** implementing anything subjective. In Battle Drill this moved from "build, then ask" to "ask in the iteration plan, then build" after whole iterations were spent on guesses.

## Pivots get a decision record

For a product pivot (Tesseract's move from four paid theme packs to one "Pro" unlock with a 5-game trial), write a decision record first (why, the options, the operational checklist), confirm it answer by answer with the owner, and only then build.

## What is always the owner's

Credentials, 2FA and sudo; vendor project creation and settings; anything inside a running client or on a physical device; publishing, submissions and account settings; spending beyond the budget; scope; taste and feel; canon in creative work. See `docs/OWNER.md`.
