# Models, media and costs

For projects that call model or media APIs at runtime (Timeline Writer, Aztlan, Battle Drill's voice and image work). Check prices and model ids against the provider's current docs; they change faster than this file.

## Choosing a model

- **Start cheap, raise only when the output shows it's needed.** Small fast models at low effort for exploring; the strongest models at high effort for keepers and the hardest pieces (long chapters, tight continuity).
- Change one thing at a time (preset text, model, effort) and compare on the same briefs.
- Keep an **eval set** (about 15 briefs with rubrics) and re-run it when a preset, model or default changes. Tune on half, judge on the other half, so a preset isn't overfitted to its examples.
- Prefer one clear ask with the relevant context attached: "a legend told by a temple elder to children" beats "write about the volcano".

## Costs

- **Estimate before every paid call** and show it; record the real cost after, on the run's file.
- **Calibrate on the first real run.** Timeline Writer's first run cost 45% more than estimated: its text ran about 2.5 characters per token (diacritics, Markdown), not 4, and the first run writes the prompt cache at a premium.
- **Cache stable context.** When every run shares the same large context (a world bible, canon), prompt caching makes iteration cheap after the first run.
- **Batch** non-urgent generation where the provider offers batch pricing.
- **A monthly cap, enforced server-side.** A run that would exceed it is refused with the reason. Media renders count toward it.
- Recover interrupted runs: on startup, mark runs still "running" as failed, with a **Run again** button.

## Verifying a paid integration without spending

- Point the SDK at a local capture server with a placeholder key to check the shape of the request. It catches parameter mistakes early; it doesn't prove the real service accepts them.
- An **offline provider** returns canned output for tests and UI work.
- First real calls run against a throwaway copy of the data, on another port, with their own media folder.

## Media (voice, image, video)

- **Test by ear and eye before building on a theory.** In Timeline Writer, pronunciation respellings made the voice *worse* (it slowed down on each replaced name); a newer voice model saying native names as spelled was better. Casting tests recorded the owner's feedback word for word, with ratings and a verdict.
- **Side-by-side bake-offs** before choosing a provider or style: the same few shots through 3 providers.
- **Check plan requirements early.** Battle Drill's scripted image generation failed with `402 paid_plan_required`; the images came from a connector instead.
- Large binary assets go through Git LFS (`.gitattributes`), and superseded sets aren't committed.
