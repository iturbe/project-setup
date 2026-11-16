# Verification

How "does it work" gets an objective answer. The loop is only as good as its verifier.

## The Ladder

| Level | What | Typical command | Passes when |
|---|---|---|---|
| L0 Static | Lint, type check, project lints for known bug classes | inside `scripts/verify.sh` | No violations |
| L1 Build | Compile, bundle, package | inside `scripts/verify.sh` | Zero errors, no new warnings |
| L2 Tests | Unit tests on the pure core; integration tests; an in-situ harness on the real target | `scripts/verify.sh` (+ a session script for in-situ) | Full suite green, every ID in the definition of done passes |
| L3 Human | A checklist in the human channel | the queue or the iteration plan | The owner marks each line pass or fail |

- Run the cheap levels first and iterate on them until they are clean. Then pay for the expensive ones (device sessions, simulators, paid calls). Battle Drill and Shockwave capped play sessions at 2 per attempt.
- L0 to L2 answer "does it work". Only L3 answers "is it right" (look, feel, fun, clarity).

## `scripts/verify.sh`: One Command

Every project has exactly one verifier command, so every agent and every session runs the same check. It:
- runs L0 → L1 → L2 in order and stops at the first failure;
- exits non-zero on any failure (never pipes its result through `tail` or `grep`);
- pins versions and destinations explicitly (Tesseract had to pin `OS=18.6` because "latest" resolved to a runtime that was not installed);
- prints what it built (path, version), so you can tell it is looking at your files.

Examples from earlier projects:

```bash
# Tesseract (iOS, Swift)
xcodebuild -project TesseractV2.xcodeproj -scheme TesseractV2 \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' build
xcodebuild test -project TesseractV2.xcodeproj -scheme TesseractV2 \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' -only-testing:TesseractV2Tests

# Timeline Writer (Python, uv)
uv run ruff check . && uv run pytest -q

# Shockwave Playground (UEFN, Verse, through the editor's MCP server)
python tools/verse_lint.py && python tools/build_verse.py && python tools/run_session.py --until "AUTOTEST: END"
```

## Prove the Verifier Catches Failures

In M0, break something on purpose and confirm the verifier reports it with the right error text, then fix it. A verifier that has never failed is unproven.

## In-Situ Harness: When the Agent Cannot Drive the Target

Some targets cannot be driven by the agent: a game client with anti-cheat, a physical device, a store build. Battle Drill and Shockwave solved this with a harness that runs **inside** the target and prints a fixed contract to a log the agent can read:

```
AUTOTEST: BEGIN build=<version> count=<n>
AUTOTEST: PASS <ID> <short detail>
AUTOTEST: FAIL <ID> <expected> | <actual>
AUTOTEST: END pass=<n> fail=<n>
```

- IDs are stable, unique and prefixed by area (`MM03-round-timeout`, `AS02-grounded-hit-scores-zero`).
- The harness is switched by a flag that must be **off** in anything published, and a release-guard test (`RG01`) enforces it.
- Missing `END` is a failure (Battle Drill lost its last lines to log throttling until it paced output at 0.1 s per line).
- A small parser turns the log into a report (`reports/autotest_<stamp>_build-<v>.md`) with one row per test.

Because no input can be sent to the target, scenarios feed synthetic events into the pure core. **This is why the architecture rule exists** (`ARCHITECTURE_PATTERNS.md`).

## Robot Runs

A step further: code inside the target moves a real player or user through the flow (teleports, triggers, waits) and **asserts the outcome in the world**: position, state, score. Shockwave's robot printed `DROBOT jump ok=1 stand=1 floor=1` and `END ok=1`. By contrast, a robot that only checks "the call ran" will pass while the feature is broken.

## Measurement Sessions

Some numbers can only come from a human using the real thing (jump heights, launch distances, reading speed). Do not guess them:
1. Write a measurement probe that logs `<PREFIX>: MEASURE <name> <value>` lines.
2. Queue a `MEASURE` item: exactly what to do, how many times, "just play naturally" where that matters.
3. Parse the log yourself and update the tunables from the numbers. The human does the doing; the agent does the numbers.

## Telemetry for Tuning

Log every interesting event during human sessions (where they aimed, where they landed, how long a step took). After the session, turn the log into numbers (`tools/parse_landings.py` in Shockwave) and tune from them. Ask the owner for numbers and yes/no, not impressions.

## Visual Checks Before a Human Sitting

Capture a screenshot (an overhead view, a spawn's-eye view, a phone-width browser) and look at it before asking the owner to test. Shockwave's first sitting was "a barren area where nothing happens" because the stations were invisible floor rectangles.

## Browser UIs

Check every UI change in a real browser against a throwaway copy of the data, at desktop and phone widths, with no console errors (Timeline Writer's definition of done). Playwright and Chromium are usually available in cloud sessions.

## Acceptance As Data (Optional)

For long autonomous runs, keep acceptance items in a machine-readable list (`docs/acceptance.json`: id, description, steps, `passes: false`). Agents may only flip `passes`; they never delete or rewrite items. JSON is harder to quietly corrupt than prose. The ROADMAP checkboxes play the same role for most projects.

## What a verifier cannot certify

Theme rendering, animation feel, layout on a specific device, accessibility contrast, whether a tutorial actually teaches a newcomer. These are L3 items, listed per milestone under **Human-verified** in `ROADMAP.md`. A milestone is not done on green tests alone if any of its deliverables are visual or experiential.
