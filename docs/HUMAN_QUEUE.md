# Human queue

Everything that needs the owner, in one place. *(Queue mode. In iteration mode use `docs/ITERATION_PLAN.md` instead and delete this file at kickoff.)*

The agent keeps the queue sorted, blocking items first, and removes items once their answers are applied. **Owner:** do the items top to bottom, write pass/fail under each, then tell the agent "queue done".

**Item types**

| Type | Meaning |
|---|---|
| `SETUP` | A one-time environment step (install, sign in, toggle a setting) |
| `TEST` | A test run: numbered steps and a matching checklist. New features fold into the pending test run rather than getting items of their own |
| `MEASURE` | The owner plays or uses the thing while the agent reads the log and does the numbers |
| `FEEL` | A judgment: fun, clarity, look, difficulty |
| `DECIDE` | A question, with the agent's recommended answer first |
| `PUBLISH` | Anything that publishes, submits or spends. Always the owner's |

**Item format**

```
### Q<nn> · <TYPE> · <where: machine/device/site> · ~<minutes> min · blocks: <deliverable or "nothing">
Build: <version the owner should see, and where it shows>
Who:   <the owner | the robot, with nobody touching anything>
Do:    1. <exact action or click path, one per line; name menus and buttons exactly as on screen>
       2. ...
Check: [ ] 1. <observable yes/no thing, numbered to match the step>
       [ ] 2. ...
Reply: write pass/fail per line under the item, plus anything odd.
```

For `DECIDE`:

```
### Q<nn> · DECIDE · anywhere · ~2 min · blocks: <deliverable>
Question: <one sentence>
Options:  A. <recommended> — <consequence>
          B. <alternative> — <consequence>
Reply:    the letter, or your own words.
```

---

## Open items

(none yet)

---

## Answered (applied; keep the last few for context, then delete)

(none yet)
