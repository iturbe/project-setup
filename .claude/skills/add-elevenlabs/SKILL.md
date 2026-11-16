---
name: add-elevenlabs
description: Add ElevenLabs (text to speech, voices, voice agents) to a project with the official onboarding CLI. Gets the API key to the place that needs it without the agent ever seeing it. Use when the owner says "add ElevenLabs", "set up the ElevenLabs key", "add voices", or a deliverable needs ElevenLabs.
---

# Add ElevenLabs

## The Prompt

The owner's prompt, which worked on 2026-11-16 (IVE Supply Lab):

> Add ElevenLabs to my project: run `npx -y @elevenlabs/cli@latest onboard init` and follow what it prints.

Run it from the project root. The CLI is unpinned (`@latest`) on purpose, because its onboarding steps change with the product, so read its output every time rather than assuming the steps below.

## Steps

1. **Run `onboard init`.** It prints one JSON object. Read `next`, `say`, `run`, `rules` and `details.env_file`.
2. **Adopt its `rules` for the session.** They match `AGENTS.md`, which wins if they ever differ. On 2026-11-16 they were:
   - never open, print or cat the env file (verify it with `onboard check`);
   - never ask for the key in chat, or accept one pasted there;
   - never put the key in code (the SDK reads `ELEVENLABS_API_KEY`);
   - write no code until a reply's `next` is `write_code` or `load_key`;
   - keep downloads in a temp folder, outside the project;
   - make no speech until the owner agrees to a test.
3. **If `next` is `ask_user`,** pass `say` to the owner in your own message, wait for the answer, then run the command in `run` (for example `onboard check --env-path .env.local`).
4. **Check git.** Run `git status`: the env file the CLI named (`.env.local`) must be ignored. Then run `scripts/security_check.sh`.
5. **Put the key where the code runs.** Pick the row for this machine:

   | Where the code runs | How the key gets there |
   | --- | --- |
   | The owner's computer, with a browser | The CLI's approval page hands the key over; nothing else is needed |
   | A Claude Code cloud container | The browser cannot reach it (the CLI says so). Save the key through the environment's credential form (`request_credential`): host `api.elevenlabs.io`, header `xi-api-key`, no prefix. On the shared Default environment, first create a personal environment for the project, so the key stays with it |
   | A deployed service (Railway, Fly, and so on) | The owner adds `ELEVENLABS_API_KEY` to the service's variables. Queue it as a SETUP item; the agent never types the value |

   In a cloud container the proxy injects the key, so no variable holds it. Run code that reads the variable with `ELEVENLABS_API_KEY=proxy-injected`, and the proxy replaces the placeholder in the header.
6. **Verify for free.** `GET https://api.elevenlabs.io/v1/history?page_size=3` returns 200 when the key works, and listing the history costs no credits. Record the result in `docs/PLATFORM_CONSTRAINTS.md`.
7. **State the cost before any paid call.** Text to speech costs about $0.20 to $0.30 per 1,000 characters (confirm on the account), and generation tools make two takes by default. Never repeat a generation call to retry, because each call is charged.

## Verified Facts (2026-11-16)

These came from the IVE Supply Lab project. Recheck any that a deliverable depends on.

- On that account the default text-to-speech model was `eleven_v4`. One live call (`POST /v1/text-to-speech/{voice_id}`, `mp3_44100_128`) took about 1.7 seconds for a 60-character line and cost about $0.02.
- Clips generated through the ElevenLabs MCP connector (its Flows) appear in `GET /v1/history` with a null top-level `voice_id` and `text`. The line sits in a one-entry `dialogue` list (`text`, `voice_id`), so code that matches history items by voice and text must read it there.
- `GET /v1/history/{id}/audio` downloads a clip at no cost. Committing the MP3s to the repository lets a public site play them with no key at all.
- The Default network of a cloud container blocks `api.elevenlabs.io` and `elevenlabsusercontent.com`. The credential form opens `api.elevenlabs.io` for the environment it is saved on.
- Safari (iPhone included) often refuses to play audio from a server that ignores byte-range requests. A static server must answer `Range` with 206.
- A label that says "ElevenLabs" must match what plays. When the clip cannot load and the page falls back to the browser voice, the label has to say so.
