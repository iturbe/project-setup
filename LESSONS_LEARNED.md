# Lessons learned

Read this in full at the start of every session. Every line is a rule that some project paid for once. Add one whenever an attempt fails for a reason that wasn't obvious from the docs.

**Format:** `- **<date> · <area>** — <what happened>. **Rule:** <what to do from now on>.`

- Platform lessons also go in `docs/PLATFORM_CONSTRAINTS.md`.
- If a lesson turns out wrong, don't delete it: add `**Correction (<date>):** …` under it, and log it in `STATE.md`.
- Keep it short. A long story goes in `docs/`, and only the rule goes here.
- Lessons that would help any project belong upstream too. Copy them to the seed repo's `LESSONS_LEARNED.md` under **Inherited**.

---

## This project

- (none yet)

---

## Inherited from earlier projects

Generalized from Battle Drill (BD), Shockwave Playground (SP), Timeline Writer (TW), Tesseract (TS) and the Aztlan vault (AZ), 2026-07 to 2026-11. Delete any that clearly don't apply to this project at kickoff.

### Verification and "done"

- **2026-10 · Done (BD, SP)** — Agents reported "done" off their own reading of the code, and builds broke on the device. **Rule:** only a verifier run makes something done. Without one, the best status is `done, pending human check`.
- **2026-10-14 · Robots (SP)** — A test robot "passed" because it checked that a call ran, not where the player ended up. **Rule:** automated checks assert the outcome in the world (position, state, file contents), never just that a function was called.
- **2026-10-14 · Test the way it's called (SP)** — Core tests passed while the real adapter's call pattern rolled back state every time. **Rule:** at least one test calls the core exactly the way the adapter does.
- **2026-10-29 · Wrong target (SP)** — The build reported "0 errors" while compiling an old copy of the project, so the edits were never read. **Rule:** make sure the verifier is looking at *your* files: print the path or version it built, and compare.
- **2026-10-31 · Pipes hide failures (TW)** — A commit went in with a failing test because it was chained after `pytest | tail`, and `tail` always succeeds. **Rule:** gate on the verifier's own exit code (`scripts/verify.sh && git commit …`).
- **2026-10-31 · Flaky (TW)** — A test failed only sometimes, from a background thread rewriting a file mid-read. **Rule:** run the suite 3 times before calling a race fixed; make every file write atomic (temp file, then rename).
- **2026-10-10 · Desk-check (BD)** — On a machine that couldn't run the tests, expected strings were checked by hand. **Rule:** when a level can't run, desk-check and say so in `STATE.md` ("desk-checked, not run"). Never imply it ran.
- **2026-10-14 · Recurring bug classes (SP)** — The same language trap (an effectful call inside a check that rolls back) bit twice. **Rule:** the second time a bug class appears, write a lint for it and add it to L0.

### Tools and platforms

- **2026-10-08 · API memory (BD, SP)** — Remembered identifiers for a fast-moving API were often wrong. **Rule:** look up every identifier in the installed docs, generated stubs or type definitions before using it. If it isn't there, it doesn't exist.
- **2026-10-09 · Read back (BD)** — A tool reported success but left the value unchanged (a placement, a settings flag, a list write). **Rule:** after every write through a tool you don't control, read the value back and compare.
- **2026-10-10 · Two strikes (BD)** — Attempts piled up on a tool that couldn't do the job. **Rule:** a tool call that fails twice with the same error is unreliable for this task: stop, mark it in `docs/AUTOMATION_MATRIX.md`, and route around it (another tool, or a human checklist).
- **2026-10-09 · One call in flight (BD)** — Parallel calls to an editor that processes requests one at a time gained nothing, and a write plus a build sent together reset the connection. **Rule:** dependent calls go one at a time; batch many operations into one script that runs them in order.
- **2026-10-10 · Oversized replies (BD)** — An unfiltered "list everything" call returned megabytes and dropped the connection. **Rule:** filter at the source and return a slice; never call a no-argument list tool directly to see its schema.
- **2026-10-11 · Validation is stricter later (BD)** — The editor accepted assets that publishing rejected. **Rule:** walk the whole path to the target (publish, store upload, deploy) in M0, and again before calling anything release-ready.
- **2026-10-15 · The build reads the disk (SP)** — Launching a session recompiled half-finished files on disk and broke the owner's launch. **Rule:** never leave the working tree in a state that doesn't build. Stage multi-file work elsewhere until it builds.
- **2026-11-01 · Wrong directory (project-setup)** — A test script began with `cd <scratch copy>` after a failed `rsync`; the `cd` failed, and every later command (placeholder rewrites, a commit) ran in the real repository. **Rule:** scripts that mutate files start with `set -e`, check `pwd` before the first write, and use tools you have confirmed exist (`cp -a`, not an assumed `rsync`).
- **2026-10-29 · Silent background jobs (SP)** — A background command waited on stdin forever, and the editor got the blame. **Rule:** when a background job prints nothing, read the command first (is anything waiting on input?) before suspecting the tool.
- **2026-08 · Environment pins (TS)** — Builds failed because the tool picked the "latest" runtime, which wasn't installed, and because CLI tools pointed at the wrong toolchain. **Rule:** pin destinations and versions explicitly in `scripts/verify.sh`, and check the toolchain in the pre-flight. If the fix needs sudo, ask the owner.
- **2026-08 · Paths (TS)** — The repo path contained spaces and a curly apostrophe. **Rule:** always quote paths in shell commands.
- **2026-10-31 · YAML (TW)** — An option key `yes` turned into `true`. **Rule:** in YAML, never use yes/no/on/off as keys or bare values.
- **2026-10-31 · Caching (TW)** — The app showed old pages after an update. **Rule:** local dev servers send `Cache-Control: no-cache`.

### Machines and environments

- **2026-10-09 · Prove the client runs (BD, SP)** — The first cloud machine couldn't run the target at all (anti-cheat refused the VM). **Rule:** treat "the target runs on this machine" as unproven until M0 shows it. Don't work around platform protections.
- **2026-10-29 · One project per folder (SP)** — A tool's own sync put one project inside another repo. **Rule:** one repository per folder; git is the only source of truth; get the project with `git clone`, never through a tool's own sync.
- **2026-10-23 · Machine moves (BD, SP)** — Scratchpad scripts and agent memory were nearly lost in a machine move. **Rule:** everything needed to continue lives in the repo. Keep a new-machine checklist in `docs/ENVIRONMENT.md`.
- **2026-08-20 · Shared simulators (TS)** — Two sessions' test runs contended for one simulator and failed at launch, not in the tests. **Rule:** one verifier run per device or port at a time; a launch-level failure is not a test failure, so rerun alone before debugging.

### Working with the owner

- **2026-10-14 · Spell out test runs (SP)** — The owner did most of a test sitting, but some checks were lost. **Rule:** every test run gives the build number, where it runs, numbered steps, and a checklist whose lines match the step numbers. Name on-screen labels exactly. Ask for numbers and yes/no, not impressions.
- **2026-10-14 · Say who runs it, and where (SP)** — The owner routed a robot check to their console because they assumed they were the player. **Rule:** for every session, say who plays (the owner, or the robot with nobody touching anything) and on which device.
- **2026-10-14 · Make it visible (SP)** — A human sitting showed "a barren area where nothing happens": log lines don't show on a console. **Rule:** everything a human must find gets a visible marker, and every action gets on-screen feedback. Check the layout with a screenshot before queueing the sitting.
- **2026-10-30 · Batch questions (TW)** — Decision rounds answered in one sitting worked better than questions scattered through chat. **Rule:** ask in a batch, with your recommended answer first; save answers as they come; never ask an answered question again (`docs/OPEN_QUESTIONS.md`).
- **2026-10-31 · Reachable goals (TW)** — A goal that needed "run a real model" and "push" looped while the agent waited on a key and an approval. **Rule:** write goals the agent can reach alone, and list the owner's steps separately.
- **2026-10 · Subjective first (BD)** — Building feel-dependent features before asking cost whole iterations. **Rule:** ask open design questions (ambiance, feel, scope) *before* implementing anything subjective.
- **2026-08 · Confirm pivots (TS)** — A monetization pivot was written up as a decision record and confirmed answer by answer before any code. **Rule:** for any product pivot, write the decision record first, get each answer confirmed, then build.

### Data, content and safety

- **2026-10-31 · Throwaway copies (TW)** — UI and API tests ran on a throwaway copy on another port, and the real data was never touched. **Rule:** test against a copy (`rsync -a --exclude .git`, then `git init`), with an offline or fake provider.
- **2026-10-31 · Bulk changes (TW)** — A bulk merge would have turned a label into a bullet of its own, and a rename pass would have rewritten retired records. **Rule:** run any bulk change on a copy of all the data first, check no line is lost or invented, and exclude reference and retired records by default.
- **2026-10-31 · IDs (TW)** — A retired id could have been handed out again because retired records weren't scanned. **Rule:** ids are never reused; retired records count, and a test guards it.
- **2026-10-10 · Only what you made (BD)** — **Rule:** only delete or move content you created in this project (it carries the project prefix). Template or owner content is listed as a human step if it must change.

### Security and git

- **2026-10-31 · Identity (TW)** — Commits carried the owner's personal email, and every later push was flagged. **Rule:** set the commit email to a GitHub no-reply address before the first commit of any new repository.
- **2026-10-31 · .gitignore first (TW)** — A repository that "never leaves this computer" had no `.gitignore` for `.env`. **Rule:** every repository gets a `.gitignore` with `.env` before its first push.
- **2026-10-31 · Fake keys look real (TW)** — The security check stopped a push on a test's fake credential. **Rule:** build fake keys at runtime in tests (`"sk-ant-" + "x" * 20`), never as one literal.
- **2026-10-31 · Parallel agents (TW)** — Two agents in one checkout overwrote each other's uncommitted work. **Rule:** one git worktree per agent; never `git stash` (the stash is shared across worktrees); merge only on the owner's word into a clean main checkout.
- **2026-10-31 · Cost estimates (TW)** — The first real model run cost 45% more than estimated: the text ran about 2.5 characters per token, not 4, and the first run writes the prompt cache at a premium. **Rule:** calibrate estimates on the first real run; state the cost before any paid call; enforce a monthly cap in code.
