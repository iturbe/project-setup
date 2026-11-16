# Docs Discipline

The repository is the project's memory. Agents lose their context; files do not. These rules keep the files true and readable.

## The repository never says less than what is true

- Commit the docs with the work, in the same commit: `STATE.md`, `ROADMAP.md` ticks, `docs/PROJECT_SPEC.md`, `log.md`, lessons.
- After every major update: a line in `log.md` (date · what changed · what is still missing).
- If behavior or architecture changed, `docs/PROJECT_SPEC.md` changes in the same micro-loop.

## One Home for Each Kind of Fact

| Kind of fact | Its one home |
|---|---|
| Rules for agents | `AGENTS.md` (short), skills and playbook (detail) |
| Where things stand right now | `STATE.md` → Resume Here |
| What was done, when | `log.md`, git history |
| What the product is | `docs/PROJECT_SPEC.md` |
| What to build next | `ROADMAP.md` |
| What the platform can do | `docs/PLATFORM_CONSTRAINTS.md` |
| Mistakes not to repeat | `LESSONS_LEARNED.md` |
| What needs the owner | the human channel |
| The owner's answers | `docs/OPEN_QUESTIONS.md`, `STATE.md` decisions log |

Do not duplicate; link. When two files disagree, `AGENTS.md` wins, then `docs/PROJECT_SPEC.md`; fix the loser.

## History is append-only

- Decisions: never edit an old entry; add a new one that reverses it.
- Lessons: never delete a lesson; add a dated **Correction** under it.
- Iteration plans: never edit an old version; write the next one.
- Superseded documents keep a banner at the top saying what replaced them (Battle Drill's `BUILD_PLAN.md`: "Superseded for steps 9 onward…").

## Keep the Always-Read Files Small

- `AGENTS.md` under about 200 lines. Instruction-following drops as it grows.
- `STATE.md`: collapse closed milestones to 3–5 lines; move narratives to `docs/runs/`. Battle Drill's grew to 100 KB, which every session paid for.
- `LESSONS_LEARNED.md`: rules only; stories go elsewhere.
- `scripts/check_docs.sh` warns on size and leftover placeholders.

## Write for a Reader with No Context

- Conclusion first.
- Exact names: files with paths, commands in code blocks, buttons as labeled on screen.
- Dates as `YYYY-MM-DD`, never "yesterday" or "last week".
- Say what is verified and what is not ("built and checked on paper" is not "seen working").
- Plain language, short sentences. Define jargon once.

## Hand-Off Documents Outside the Repo

If the owner reads a plan in Google Docs or an artifact, generate it from the repo copy and keep that copy as the source. Battle Drill's `docs/TOMORROW.md` mirrored each "Build Plan vN". Read the generated copy back after creating it. Type list numbers as text, because Google Docs restarts auto-numbered lists under each heading.
