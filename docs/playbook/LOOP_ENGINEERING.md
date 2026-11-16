# Loop Engineering Playbook

> Read this before any long, multi-step or unattended task. It explains how to structure an agent loop, not how to answer a single prompt. `AGENTS.md` maps it onto the project; where they differ, `AGENTS.md` wins.

*Carried from Battle Drill and Tesseract (identical copies), extended with what those projects and Shockwave Playground and Timeline Writer learned, and with outside research (`RESEARCH_NOTES.md`).*

## 1. What a loop is

A loop is a repeating cycle (act, observe, decide, repeat) that continues until a **defined termination condition** is met. Treat every long task as a system you design, not a message you answer.

```
state = read_state_files()              # STATE.md, LESSONS_LEARNED.md, the active milestone
for attempt in range(MAX_ATTEMPTS):     # hard cap: never loop forever
    plan    = reason(state)              # think before acting
    result  = execute(smallest_change)   # touch the real environment
    verdict = verifier()                 # deterministic where possible
    state   = record(state, plan, result, verdict)   # write it down, in files
    if verdict.passed:
        return done(state)
    if no_progress(state) or budget_exhausted():
        return escalate(state)
return escalate(state)
```

Every design decision is about one line of this skeleton: what counts as `verifier`, how `record` keeps context small, how `no_progress` is detected, and which tools `execute` may use.

## 2. Before Starting a Loop, Define These Five Things

1. **A goal with a testable termination condition.** "Tests pass" is a goal. "Improve the code" is not. If you cannot write a check for done, rewrite the goal until you can. **The goal must be reachable by the agent alone.** "The owner approved it" is the owner's step, listed separately.
2. **Real tools that touch the real environment:** files, terminal, test runner, build, version control. Feedback is only as honest as what produced it.
3. **A context plan.** Long loops overflow the window. Decide up front what gets written to files (`STATE.md`, `log.md`, run reports) instead of kept in context.
4. **Termination and escalation:** a success exit, a failure exit, a hard cap, and a no-progress check.
5. **Error handling that separates recoverable from fatal.** A failing test is signal. A missing credential, a destructive action or an ambiguous spec is a hard stop that goes to the human.

If any of the five is missing, the loop is not ready to run unattended.

## 3. Pick the Simplest Pattern That Fits

| Pattern | What it does | Use when |
|---|---|---|
| **ReAct** | Reason → act → observe → repeat | The default. Almost every loop is this with guards added |
| **Reflexion** | Failed attempts become written lessons that later attempts read back | The same class of failure keeps recurring. `LESSONS_LEARNED.md` is this pattern made durable |
| **Plan-and-Execute** | A planner splits the goal into ordered steps; an executor runs them | The task is long and multi-stage, and a flat loop drifts. `ROADMAP.md` + `STATE.md` are the plan |
| **Evaluator-Optimizer** | One pass generates, a second scores against explicit criteria | Clear acceptance criteria, variable quality (prose, prompts, presets) |
| **Orchestrator-Workers** | An orchestrator delegates sub-tasks to workers with clean context windows | The work splits into independent pieces that would bloat one context. Each worker gets its own worktree |
| **Initializer + incremental** | A first session sets up the environment, the feature list and the progress file; every later session makes one increment and leaves a clean hand-off | Multi-session projects. This seed is that pattern: `/kickoff` is the initializer, `/next` the increment |

Default bias: **a single loop with a deterministic verifier beats an elaborate multi-agent system that is hard to debug.**

## 4. The Three Hard Parts

### Context Management

The context window is finite working memory; left unmanaged, quality degrades quietly as it fills ("context rot"). Countermeasures:
- **Externalize state** to files the loop reads back on demand: `STATE.md` for status, `LESSONS_LEARNED.md` for rules, `log.md` for history, `docs/runs/` for long narratives.
- **Read narrowly:** only the active milestone's section, only the matching spec section.
- **Isolate sub-tasks** in subagents that return conclusions, not file dumps.
- **Keep the always-loaded files short.** `AGENTS.md` under about 200 lines; detail moves into skills and docs that load only when needed.
- **Collapse history** when a milestone closes.

### Termination and No-Progress Detection

The most expensive bug is a loop that never stops. Stack independent exits:
- a verifier confirming the goal is met;
- a hard cap (5 attempts per deliverable);
- a budget (wall-clock, tokens, paid calls, device sessions);
- no-progress detection: the same error or an unchanged result 3 times in a row means stop and escalate;
- a blocked-on-human exit: say it once, queue it, move on.

### Verification As the Reward Signal

- **Deterministic verification** (tests, compilers, type checkers, linters) is the gold standard. Prefer it wherever it exists, and build it where it does not (an in-situ harness; see `VERIFICATION.md`).
- **LLM-as-judge** is for what cannot be checked mechanically (tone, look, prose quality). Its verdict is advisory for anything high-stakes; a human gate decides.
- **Never trust the agent's own report of "done."** Trust the verifier, and make sure the verifier is looking at the right files.

## 5. Known Failure Modes

| Failure | What it looks like | Fix |
|---|---|---|
| Context overflow or rot | Quality silently degrades as the transcript grows | Externalize, prune, isolate in subagents |
| No-progress loop | The same failing action, over and over | No-progress detection + hard cap |
| Reward hacking | Optimizing the proxy, not the intent (deleting the failing test) | Hard stop on weakening tests; a human gate on risky actions |
| Hallucinated success | "Done" without a real verifier run | The verifier is the only source of truth |
| Verifier on the wrong target | "0 errors" while building a stale copy | Print what was built; compare with what you edited |
| Compounding errors | An early mistake snowballs | Verify early and often, not just at the end |
| One-shot overreach | Too much at once; context runs out mid-change, the tree is left broken | The smallest change that could pass; commit each green step |
| Waiting forever | Looping on a key or an approval | Blocked-on-human exit; reachable goals only |
| Cost blowup | Long loops quietly burn tokens or paid calls | Budget guards, caps, cost shown before paid calls |
| Parallel agents collide | One agent's uncommitted work overwritten | One worktree per agent; never stash |

## 6. Nested Loops

- **Macro-loop:** one milestone, whose goal is its acceptance criteria. It takes days to weeks.
- **Micro-loop:** one deliverable. Goal = its own checkable condition. Minutes to hours.
- **Iteration (optional):** a batch of micro-loops ending in one hand-off to the owner, whose reply opens the next iteration (`HUMAN_IN_THE_LOOP.md`).

The macro verifier is a superset (full suite, full build, milestone checklist), while the micro verifier is narrower and faster (the specific test). The persistent state file survives across micro-loops so the project does not re-try dead ends after every context reset.

## 7. Projects with More Than One Loop

Creative and content projects often run several loops that feed each other. Timeline Writer ran three:

```
  1. World loop (the author):     gather → triage → decide → apply → commit
  2. Generation loop (models):    brief → run → review → stage/discard → measure → tune
  3. Build loop (code):           pick → spec → test → build → verify → ship → learn
```

Each loop has a cadence, invariants it never breaks, and signals that show whether it is working (open decisions trending down, staged-run acceptance rate, health findings at zero). Friction in one loop tells the next what to build: answers that take long to apply point at a missing tool. Keep a short list of manual steps and make it shorter each milestone.

## 8. When *not* to build a loop

For one-off tasks, an interactive session is faster and safer. Build a loop when work is repetitive, long-running or benefits from running unattended, and only once you can state a real, checkable success condition. A loop never removes the human from owning the goal and judging whether "done" is actually right.
