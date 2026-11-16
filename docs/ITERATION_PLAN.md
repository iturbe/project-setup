# {{PROJECT_NAME}} Iteration Plan V{{N}} (Repo Copy)

*(Iteration mode. In queue mode use `docs/HUMAN_QUEUE.md` instead and delete this file at kickoff.)*

Updated {{DATE}}, **build {{VERSION}}**. Each iteration ends with one document for the owner that covers testing, open questions and next steps. The owner's reply opens the next iteration.

**Rules for the agent**
- Write a new version each iteration (v1, v2, …). Never edit an older one. Archive the previous one as `docs/iterations/ITERATION_PLAN_v{{N-1}}.md` and carry its open items into the new one, so the owner only ever needs the latest.
- If the owner reads it elsewhere (Google Docs, an artifact), generate that copy from this file, read it back, and link it from `STATE.md` → Resume Here. This file stays the source.
- Type checklist numbers as text, so they survive a copy-paste (Google Docs restarts auto-numbered lists).
- Record each answer in `STATE.md` (per deliverable, and in the Decisions log for design choices), then start the next iteration from those answers.

**How to reply (owner):** paste the short list from section 3 into chat, with your notes after each `Decision:`.

---

## 1. Where things stand

The conclusion first: what is ready, what is blocked, what is waiting on you. Be honest about what was verified: "built and checked on paper" is not "seen working".

- {{…}}

## 2. What was just built and needs human testing

- {{feature}}: {{what changed, where to find it, which build}}.

## 3. Checklist

**3a. Details.** One item per thing to check or decide, with exactly what to look for or what the options are (recommended option first).

1. {{Where to go, what to do, what you should see.}}
2. {{…}}

**3b. Short list.** Matches 3a one to one. 2–6 words each, ending with an empty `Decision:`.

1\. {{short label}} · Decision:
2\. {{short label}} · Decision:

Open design questions (feel, look, scope) go here too, *before* anything subjective is implemented.

## 4. Closing Points to Keep in Mind

Reminders, warnings, platform limits, things that may surprise you.

- {{…}}

## 5. Future Loop Suggestions

What is next on the roadmap, where to drive next, and other improvements worth building, with a recommendation.

- **Recommended next:** {{…}}
