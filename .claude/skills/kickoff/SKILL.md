---
name: kickoff
description: Turn a fresh copy of the project-setup seed into a real project. Interviews the owner in batches, fills every {{placeholder}} in AGENTS.md, ROADMAP.md, STATE.md and docs/, picks the human-loop mode, writes M0 and the verifier, and makes the first commit. Use once, when AGENTS.md still contains unfilled double-brace placeholders, or when the user says "kickoff", "start a new project", or "set up this repo".
argument-hint: "[one-line idea]"
disable-model-invocation: true
---

# Kickoff

You are the initializer session. When you finish, any later session must be able to read `AGENTS.md` and `STATE.md` and continue without this chat. The idea, if given: $ARGUMENTS

## 0. Look before you ask

1. `grep -rnE '\{\{[^}]+\}\}' --include=*.md . | grep -v docs/examples` lists every placeholder you must fill.
2. Read `docs/OWNER.md` (the owner profile is prefilled; don't re-ask what it already answers) and skim `docs/playbook/README.md`.
3. If the repo already has code (the seed was dropped into an existing project), read its README, build files and tests first, and answer what you can from them.

## 1. Interview, in at most three batches

Use the AskUserQuestion tool when it is available (up to 4 questions per call, recommended option first, labelled "(Recommended)"). Otherwise ask in one numbered message per batch, so the owner can reply `1: … · 2: …`. Never ask what the files, the code or sensible defaults already answer.

**Batch A: what and why**
- The idea in one paragraph: what it is, who it is for, what the first version must prove.
- Type and stack: app (web, iOS, desktop), game or editor platform, CLI or library, content or creative vault, data or ML. Propose a stack if they have none.
- Target: where the owner will test it (device, browser, console, store build).
- The main end product for the next few months, and what is explicitly out of scope.

**Batch B: how we work**
- Human-loop mode: `queue` (never wait; a living `docs/HUMAN_QUEUE.md`) or `iteration` (batches ending in one `docs/ITERATION_PLAN.md`). Recommend `queue` when test sittings are cheap, `iteration` when each sitting needs a publish or a console.
- Budget for paid APIs and services, and whether there is a monthly cap.
- Which machine(s) this runs on, and anything the agent can't run there (a game client, a simulator, sudo).
- A sibling project to import lessons and constraints from? (Shockwave Playground imported from Battle Drill.)

**Batch C: rules** (only if A and B didn't already answer them)
- Two to six design invariants, each with its reason.
- The riskiest platform assumptions: these become M1 spikes.
- A naming prefix for everything the agent creates in shared spaces (e.g. `BD_`).

## 2. Fill the files

Replace every placeholder. Keep `AGENTS.md` under about 200 lines: push detail into `docs/PROJECT_SPEC.md` and keep only the binding rules in **Project-specific rules**.

| File | What to write |
|---|---|
| `AGENTS.md` | Project paragraph, stack, mode, pre-flight checks, expensive-check budget, prefix, project-specific rules (platform rules, naming, invariants with reasons) |
| `docs/PROJECT_SPEC.md` | What it is, out of scope, invariants table, architecture (pure core + adapters, named for this stack), layout, commands, test-id prefixes |
| `ROADMAP.md` | Goal; M0 adapted to the stack; M1 spikes from Batch C; M2 MVP with deliverables, exit criteria and verification (automated and human-verified) |
| `STATE.md` | Today's date; Resume here pointing at M0 deliverable 1; the M0 deliverable entries (status `not started`, with a draft "Done when"); a decision for each interview answer |
| `docs/OPEN_QUESTIONS.md` | The answers table; any direction question still open |
| `docs/OWNER.md` | Only what differs for this project |
| `docs/ENVIRONMENT.md`, `docs/AUTOMATION_MATRIX.md` | What you already know; the rest is M0's job |
| `scripts/verify.sh` | Replace the project section with the real L0 → L1 → L2 commands, pinned (see `docs/playbook/VERIFICATION.md`). If the project has no code yet, write the commands M0 will make pass, and leave M0 deliverable 3 to prove them |
| `log.md` | The first line: date · kickoff done · what is still missing |

**Human channel:** keep the file for the chosen mode and delete the other (`docs/HUMAN_QUEUE.md` or `docs/ITERATION_PLAN.md`), and fix the references to it in `AGENTS.md`'s map.

**Lessons:** under **Inherited** in `LESSONS_LEARNED.md`, delete the lessons that clearly don't apply to this stack. If there is a sibling project, import its verified constraints and dead ends into `docs/PLATFORM_CONSTRAINTS.md` and its lessons into `LESSONS_LEARNED.md`, marked "(from <project>, <date>)".

**Examples:** ask whether to keep `docs/examples/` (reference) or remove it (`scripts/init.sh --strip-examples`). Default: keep it.

**README.md:** replace the seed's README with a short project README: what it is, how to run it, how to verify, and a pointer to `AGENTS.md`.

## 3. Check and commit

1. `scripts/check_docs.sh --strict` must report no placeholders left (outside `docs/examples/`).
2. `git config user.email` must be a no-reply address. If it isn't, queue a SETUP item, and don't commit with a personal email.
3. `scripts/security_check.sh` must pass.
4. Commit: `M0: kickoff (build 0.0.0)`. Push if a remote exists.

## 4. Hand over

End with a short summary for the owner: the project in one sentence, the mode, the first three deliverables, anything already waiting on them (SETUP items), and the next command (`/start` or `/next`).
