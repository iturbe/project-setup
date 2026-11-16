# AGENTS.md: {{PROJECT_NAME}}

The entry point for any coding agent (Claude Code, Codex, Cursor, or other). Read all of it at the start of every session. If this file and another document disagree, this file wins, and you fix the other document.

> **New project?** If the Project section below still shows placeholders in double curly braces, stop and run `/kickoff`. Without Claude Code, follow `.claude/skills/kickoff/SKILL.md` by hand. Do nothing else first.

## Project

{{PROJECT_ONE_PARAGRAPH: what this is, who it is for, what the current version must prove.}}

- **Owner:** `docs/OWNER.md` says who they are, how they like to work, and which devices they test on.
- **Human-loop mode:** `{{HUMAN_LOOP_MODE}}` (`queue` or `iteration`; see `docs/playbook/HUMAN_IN_THE_LOOP.md`).
- **Verifier:** `scripts/verify.sh`. It is the only source of truth for "it works".
- **Stack and platform:** {{STACK: language, framework, target platform/devices, key external services}}.

## Map: Which File Holds What

| File | Holds | Update it |
|---|---|---|
| `AGENTS.md` | These rules | Only with the owner's agreement; log the change in `STATE.md` |
| `STATE.md` | **Resume Here**, the current milestone, one entry per deliverable, decisions, dead ends | Continuously, as you work |
| `ROADMAP.md` | Milestones, deliverables, exit criteria, verification | Tick boxes; change scope only as a logged decision |
| `docs/PROJECT_SPEC.md` | What the product is and how it is built. Authoritative | In the same micro-loop as any change to behavior or architecture |
| `LESSONS_LEARNED.md` | Every non-obvious mistake, written as a rule | Whenever an attempt fails for a reason that was not obvious |
| `log.md` | One line per major update: date · what changed · what is still missing | After every major update, in the same commit |
| `docs/HUMAN_QUEUE.md` or `docs/ITERATION_PLAN.md` | Everything waiting on the owner (one of the two, per the mode) | Whenever you need them; clear items once answered |
| `docs/OPEN_QUESTIONS.md` | Direction questions and the owner's answers | When an answer arrives. Never ask an answered question again |
| `docs/PLATFORM_CONSTRAINTS.md` | What the platform and APIs can and cannot do: verified, unverified, dead ends | Whenever you verify or disprove something, or hit a limit |
| `docs/AUTOMATION_MATRIX.md` | Which tasks you do alone, which with a check, which the owner does | In M0, then whenever a tool proves reliable or unreliable |
| `docs/ENVIRONMENT.md` | Machines, tools, versions, the new-machine checklist | When a machine or tool changes |
| `docs/IDEAS_BACKLOG.md` | Unscheduled ideas | When ideas come up. Never build from it without a decision |
| `.agent-style/RULES.md` | The writing rules every document follows (agent-style v0.9.0; compact form at the end of this file) | Never by hand. Upgrade with `npx --yes agent-style@<version> enable agents-md` |
| `docs/playbook/` | How the work is done in general (loops, verification, the human loop, security, parallel agents) | Rarely. Feed general lessons back to the seed repo |

## Session Start Ritual

Do these in order, before any other work:

1. Read `STATE.md` → **Resume Here**, then the current milestone block.
2. Read `LESSONS_LEARNED.md` in full. Every line is a mistake someone already made once.
3. Read only the active milestone's section of `ROADMAP.md`.
4. Read the human channel (`docs/HUMAN_QUEUE.md` or the latest `docs/ITERATION_PLAN.md`). If the owner has answered anything, apply those answers first: update the deliverables, `STATE.md` and the constraints, then clear the items.
5. Run the pre-flight: `git status` is clean, or the last `STATE.md` entry explains the dirty files; the tools the verifier needs are present ({{PREFLIGHT_CHECKS}}). If a check fails, queue a SETUP item and work on something that does not need the failing piece. If nothing can proceed, stop and say so.
6. Say in one or two sentences which deliverable you are picking up and why. Then start its micro-loop.

## Session End (Hand-Off)

Before you stop, and always before a long autonomous run ends:

1. Update `STATE.md` → **Resume Here**: build version, what is done, what is next, what is waiting on the owner.
2. Add new lessons to `LESSONS_LEARNED.md`, and append a line to `log.md`.
3. Put pending human steps in the human channel.
4. Run `scripts/verify.sh` and `scripts/security_check.sh`, then commit and push.

A fresh session must be able to continue without the chat history. If it would need the chat, the hand-off is not done.

## Loop Protocol

**Macro-loop = one `ROADMAP.md` milestone.** Its goal is every deliverable plus every line under the milestone's Verification, automated and human. Do not start a later milestone while the current one is open, unless the autonomy policy below allows it or the owner asks (log the deviation).

**Micro-loop = one deliverable.** These steps, exactly:

1. **Define done.** Before writing code, write the deliverable's checkable condition into its `STATE.md` entry: which verifier levels apply and which test IDs must pass. If you cannot write a check, the deliverable is not ready: rewrite it or queue a question.
2. **Research.** Check `LESSONS_LEARNED.md` and `docs/PLATFORM_CONSTRAINTS.md`. Look up every API you plan to use in the real source of truth (installed docs, generated stubs, type definitions). Your memory of fast-moving APIs is unreliable.
3. **Implement** the smallest change that could satisfy the check.
4. **Verify** up the ladder (below) until the levels you named in step 1 pass.
5. **Human items** for anything visual, spatial, or about feel go to the human channel.
6. **Record:** update the `STATE.md` entry, tick `ROADMAP.md`, update `docs/PROJECT_SPEC.md`, bump the build version, commit.
7. Pick the next deliverable.

**Caps and exits**

- **5 attempts per deliverable.** One attempt is one implement-then-verify cycle. After the fifth failure, stop that deliverable, log what you tried, add a lesson, mark it `blocked`, and move on.
- **No-progress rule:** the same error text, or an unchanged test result, on 3 attempts in a row means stop now, even with attempts left.
- **Expensive checks** (device sessions, paid API calls, long builds): iterate on cheap levels until they are clean, then run the expensive one. {{EXPENSIVE_CHECK_BUDGET}}
- **Success is the verifier,** never your reading of the code. "It should work" is not a status. Without a verifier run, the best status is `done, pending human check`.

**Verifier ladder** (details: `docs/playbook/VERIFICATION.md`)

| Level | What | Passes when |
|---|---|---|
| L0 Static | Lint, type check, project lints for known bug classes | No violations |
| L1 Build | Compile or build | Zero errors, no new warnings |
| L2 Tests | `scripts/verify.sh`: unit tests on the pure core, plus any in-situ harness | Full suite green, and every ID named in step 1 passes |
| L3 Human | An item in the human channel | The owner marks each check pass or fail |

L0 to L2 decide "does it work", and L3 decides "is it right".

## Autonomy Policy

- **Never wait idle.** When a deliverable needs the owner, queue the item and mark the deliverable `done, pending human check` (if everything automatable passed) or `blocked`. Then move to the next deliverable that does not depend on it.
- **Batch.** The owner clears the human channel in one sitting. Group items by where they need to be (which machine, which device, which website).
- **Decide within the design.** If a choice is small (a number, a label, a layout detail), pick the option most consistent with `docs/PROJECT_SPEC.md`, log it as a decision, and keep going. Ask only when the choice changes what the product *is*.
- **Advance milestones** when every deliverable of the current one is `done` or `done, pending human check`, and no automated check fails. A milestone that depends on an unresolved spike must not start.
- **Write goals you can reach.** Never make "the owner did X" a done-condition for your own loop. List the owner's steps separately.
- **Blocked on the owner** (a key, an approval): say so once, clearly, queue it, and stop that thread. Do not loop.

## Hard Stops: Queue It, Never Work Around It

- A credential, sign-in prompt, 2FA, sudo, or permission dialog.
- Anything that publishes, submits for review, spends money beyond the agreed budget, sends messages to other people, or changes account settings.
- Deleting or overwriting data, content or files you did not create in this project.
- A requirement that contradicts itself or `docs/PROJECT_SPEC.md`.
- A platform limit that makes a deliverable impossible as written. Propose the nearest achievable alternative and continue with other work.
- Weakening, skipping or deleting a test to make the verifier pass. A test changes only when its requirement changed, and that change is logged as a decision.

## Rules That Never Bend

- **Keys:** never read, print or write a secret. Secrets live in `.env` (git-ignored). Check whether one is set by name only. If the owner pastes a key in chat, do not use it; tell them to revoke it.
- **Real data:** never test against the owner's real data. Use a throwaway copy, on another port, with an offline or fake provider where possible.
- **Before any push,** run `scripts/security_check.sh` and stop on a finding.
- **Only touch what you made.** Prefix everything you create in shared spaces (`{{PREFIX}}_`) so you can find it, re-create it, and clean it up safely.
- **Never send synthetic input to systems where it risks the owner's accounts** (anti-cheat, fraud detection). Test through code paths instead.
- **One agent per checkout.** Parallel agents each work in their own git worktree (`docs/playbook/PARALLEL_AGENTS.md`). Never `git stash`.

## Architecture Rule

**All core logic lives in plain code with no dependency on the UI, devices, network, or the world.** It takes plain values in and returns plain values out. Adapters are thin: they turn real-world events into core calls, and core outputs into effects. New logic goes in the core, so tests can exercise it without a human. Every tunable number is a named constant in one place. Text the user sees comes from one table, referenced by id. See `docs/playbook/ARCHITECTURE_PATTERNS.md`.

**A visible build version.** A `BuildVersion` constant is shown wherever the owner tests (a home screen, a debug corner, a log line at start). Bump its patch number on every change that reaches a device or a test session, so a bug report always names its build.

## Project-Specific Rules

{{PROJECT_RULES: platform rules, tool rules, naming prefixes, design invariants. Each invariant states why. Changing one is the owner's decision, logged in STATE.md. Kickoff fills this from the interview; keep it short and move detail to docs/.}}

## Git

- Commit after every deliverable that passes its verifier: `<milestone>: <deliverable> (build <version>)`. Commit the docs with the work, in the same commit, so the repository never says less than what is true.
- Gate commits on the verifier's own exit code (`scripts/verify.sh && git commit ...`), never on a pipe like `| tail`, which always succeeds.
- Never commit generated or cache folders, or `.env`. Never force-push. Push only if a remote exists.

<!-- BEGIN agent-style v0.9.0 -->
<!-- SPDX-License-Identifier: CC-BY-4.0 -->
<!-- Adapter: AGENTS.md cross-agent standard -->
<!-- Target path: <repo root>/AGENTS.md -->
<!-- Load class: single-file; install_mode: append-block -->

# agent-style v0.9.0 — AGENTS.md adapter

agent-style is a literature-backed English technical-prose writing ruleset for AI agents. This adapter is the compact rule payload that AGENTS.md-aware tools (Codex, Jules, Zed, Warp, Gemini CLI, VS Code, Aider via `.aider.conf.yml`, and others) load at session start.

## Self-Verification Handshake

When asked "is agent-style active?" or "what writing rules apply here?", answer: `agent-style v0.9.0 active: 21 rules (RULE-01..12 canonical + RULE-A..I field-observed); full bodies at .agent-style/RULES.md.`

## Load Statement

This adapter is loaded as the root `AGENTS.md` file at the repository root. AGENTS.md-aware tools do not auto-import a second file; the compact directives below are what reach context. Full rule bodies at `.agent-style/RULES.md` are a human-readable reference but are not auto-loaded by AGENTS.md consumers.

## The 21 Rules (Compact Directives)

Canonical rules (from Strunk & White 1959, Orwell 1946, Pinker 2014, Gopen & Swan 1990):

- **RULE-01 Curse of knowledge**: Name your intended reader; do not assume they share your tacit knowledge.
- **RULE-02 Passive voice**: Prefer active voice when the agent is known and worth naming.
- **RULE-03 Concrete language**: Prefer concrete, specific terms over abstract category words like "factors" or "aspects"; state a result's pattern and rounded magnitude, say in plain words whether a difference holds, and leave standard deviations, intervals, and full numbers to tables. Never call a difference within noise a gain. Do not stack figures in consecutive sentences, and keep a caption to what the display shows. Report differences in points or percent rather than raw decimals, keep one unit and sign across text, tables, and captions, and add a table when several figures matter and no display holds them.
- **RULE-04 Needless words**: Cut filler phrases like "in order to", "due to the fact that", "may potentially", and needless sentences that announce, restate the method, or repeat a finding. An abstract goes from the problem and its challenge to the approach and findings, and a conclusion stays short.
- **RULE-05 Dying metaphors**: Delete clichés like "pushes the boundaries", "paradigm shift", or "state of the art".
- **RULE-06 Plain English**: Prefer "use" over "leverage", "method" over "methodology", "feature" over "functionality".
- **RULE-07 Positive form**: Prefer "trivial" to "not important", "forgot" to "did not remember"; do not stage "X, not Y" antithesis ("not just X, but Y") for emphasis.
- **RULE-08 Claim calibration**: Calibrate verbs to evidence; do not write "proves" when the evidence is "suggests"; keep qualifiers that change the claim, and cut caveat tails that add nothing.
- **RULE-09 Parallel structure**: Express coordinate ideas in the same grammatical form.
- **RULE-10 Related words together**: Keep subject close to verb and modifier close to modified; split long parentheticals.
- **RULE-11 Stress position**: Place new or important information at the end of the sentence.
- **RULE-12 Long sentences**: Vary sentence length; split a sentence when the reader must hold more than one open clause to reach its point, and let a long sentence stay if it carries one connected thought.

Field-observed rules (maintainer observation of LLM output, 2022-2026):

- **RULE-A Bullet overuse**: Keep prose in paragraphs when ideas connect; bullets only for genuine lists; avoid forced 3-item triads; table cells hold numbers or short labels.
- **RULE-B Dash overuse**: Do not use em or en dashes as casual sentence punctuation; prefer commas, colons, parentheses, or a new sentence; keep semicolons rare.
- **RULE-C Same-starts**: Do not open two or more consecutive sentences with the same word.
- **RULE-D Transitions**: Do not open sentences with additive-only transitions ("Additionally", "Furthermore", "In addition"), and let "Moreover" or "Notably" open at most one sentence in a paragraph; keep words that mark a contrast, cause, or sequence the text already establishes ("However", "Thus", "First"), and never add a cause just to join sentences.
- **RULE-E Summary closers**: Do not end every paragraph with a sentence that restates its point.
- **RULE-F Term consistency**: Once you define a term or abbreviation, keep using it; do not alternate synonyms.
- **RULE-G Title case**: Use title case for section and subsection headings; articles and short prepositions stay lowercase. A full-sentence bold run-in lead takes sentence case.
- **RULE-H Citation discipline (critical)**: Support factual claims with verifiable citation or concrete evidence; never fabricate citations.
- **RULE-I Contractions**: Prefer "it is" / "does not" / "cannot" over "it's" / "doesn't" / "can't" in formal technical prose.

## Escape Hatch

*"Break any of these rules sooner than say anything outright barbarous."* — George Orwell, "Politics and the English Language" (1946), Rule 6. Most rules are defaults to apply with judgment. Depart when the sentence reads better for it, not to vary the pattern. A few are firm (do not invent citations, evidence, or numbers; no placeholders in finished text). Judge a draft by its overall pattern: one that obeys every default in every sentence reads as machine-made.

## House Style

The rules start from classic guides and are tuned to one author, Yue Zhao. A House Style section in `RULES.md` lists that author's habits, drawn from first-author ML papers written before AI writing tools: the moves of an abstract, introduction, results paragraph, and conclusion; about one sentence in four past 30 words, carrying parenthetical glosses; and sparing signposts. Where a style rule conflicts with a habit there, follow the habit, but never against the facts or the firm rules. Read that section in `RULES.md` before drafting a paper or proposal section.

## Full Rule Bodies (Canonical)

Full directive text, BAD/GOOD example pairs, and rationale per rule: see `.agent-style/RULES.md` in this project, or https://raw.githubusercontent.com/yzhao062/agent-style/v0.9.0/RULES.md for the pinned canonical source.
<!-- END agent-style -->
