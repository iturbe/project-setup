# Example: Tesseract

*A SwiftUI iOS app (iPhone and iPad) for Ultimate Tic-Tac-Toe, with no external dependencies. Built milestone by milestone from MVP to an App Store launch, then AI opponents, themes, Game Center and a "Pro" unlock.*

**What it contributed:** a CLAUDE.md that maps the general loop playbook onto one repo, an exact pinned verifier, a toolchain pre-flight that asks the owner for sudo, milestones with "Human-verified" lists, the always-visible dev version, and a pivot handled as a confirmed decision record.

## The verifier, pinned

> ```sh
> xcodebuild -project TesseractV2.xcodeproj -scheme TesseractV2 \
>   -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' build
> xcodebuild test -project TesseractV2.xcodeproj -scheme TesseractV2 \
>   -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' \
>   -only-testing:TesseractV2Tests
> ```
> Both must succeed with zero failures. This is deterministic and is the only source of truth for "does it work" — never mark a deliverable done off your own read of the diff or a visual guess.
>
> The `OS=18.6` pin matters: without it xcodebuild requests `OS:latest`, and the iPhone 16 simulator on this machine only exists under the iOS 18.6 runtime […].

## Pre-flight that respects hard stops

> **Pre-flight, once per session:** confirm `xcode-select -p` points at the full Xcode app, not the Command Line Tools […]. If it doesn't, stop and ask the user to run the `sudo xcode-select -s` command themselves — don't try to work around it.

## A milestone with automated and human verification

> ## MVP — "Correct, complete, and doesn't lose your stuff"
> […]
> **Exit criteria:** a friend can play a full game, background the app mid-game, come back, finish, and see a proper ending — with no state lost and no dead settings.
>
> *Automated (loop verifier — build + test must be green):*
> - New passing tests exist for: local win detection, global win detection, local draw detection, global draw detection, active-board redirection, and the free-move rule […]
>
> *Human-verified (manual check before closing this milestone):*
> - Win-line strike-through renders correctly across all five themes
> - `useInnerHighlight` either works as intended or is removed from Settings — no dead toggle remains

Template: `ROADMAP.md`.

## The dev version

> every code change, however small, must bump the patch digit of `BuildInfo.devVersion` […] It exists purely so the user can always tell exactly which build is on a given device when reporting a bug, especially across two devices during multi-device testing (Game Center matches, etc.). `HomeView` shows it persistently […].

## The architecture rule

> MVVM with a strict layering rule: **all game logic lives in plain value types (structs/enums) under `TesseractV2/Models/` with no SwiftUI imports**; SwiftUI observation happens only at the view-model layer. Keep new game logic in the value-type core so it stays unit-testable without UI.

By v4 the suite had 204 tests.

## A pivot as a decision record (`post_v2_revision.md`)

> *Written 2026-08-08 […]. Confirmed with the user the same day. This is a planning/decision record — **nothing in this document has been implemented yet**. It supersedes the "sell 4 theme packs + the editor separately" monetization model […].*

It also corrected an assumption before anyone acted on it:

> **Correction to one assumption:** signing into the *same* Apple ID on two devices won't meaningfully test the async match feature. […] **Two distinct Game Center identities are needed.**

## Concurrent sessions

> **2026-08-20 — Concurrent-session file changes handled by re-reading fresh, not by coordinating/locking.** […] Cost: several wasted `xcodebuild test` invocations that failed at the simulator-launch level from resource contention, not real failures — worth knowing the difference before assuming a break.

Later projects solved this with one worktree per agent (`docs/playbook/PARALLEL_AGENTS.md`).
