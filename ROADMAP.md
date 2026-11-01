# {{PROJECT_NAME}} roadmap

**Goal:** {{the outcome that makes this project worth doing, in one or two sentences, with the first proof point}}.

One macro-loop per milestone (`AGENTS.md` → Loop protocol). Progress, attempts and escalations live in `STATE.md`, not here. Each milestone ends in something usable on its own, so work can stop at any milestone boundary without leaving things half-done.

**Order and dependencies**

| Milestone | Depends on | Why this order |
|---|---|---|
| M0 Toolchain and walking skeleton | — | Nothing is safe to plan until the edit → build → test → target path works once |
| M1 Spikes | M0 | Each spike can change the design; resolve them before building on them |
| M2 MVP | M0, M1 | {{the smallest version the owner would actually use}} |
| M3 {{next}} | M2 | {{why}} |

**What would reorder this:** {{the events that would change the plan, for example a collaborator joining, a budget change, a platform limit}}.

---

## M0: Toolchain and walking skeleton

Prove the agent can go from an edit to a built, tested result on the real target without the owner touching anything, and walk the whole path to the target once (device, store, deployment), so the last step is not a surprise.

**Deliverables**

- [ ] **1. Environment report:** OS, hardware, toolchain versions, agent version, target devices → `docs/ENVIRONMENT.md`.
- [ ] **2. Project skeleton:** the empty app or project builds; layout recorded in `docs/PROJECT_SPEC.md`; `.gitignore` corrected against the real tree.
- [ ] **3. Verifier round-trip:** `scripts/verify.sh` runs the build and the tests. Prove it catches a failure: introduce a deliberate error, confirm the error text comes back, fix it.
- [ ] **4. Test harness:** two trivial tests on the pure core; one made to fail on purpose and reported as failed. For targets the agent can't drive directly, an in-situ harness that prints the result contract (`docs/playbook/VERIFICATION.md`).
- [ ] **5. Automation matrix:** for each kind of task, whether the agent does it alone, with a human check, or the owner does it from a checklist → `docs/AUTOMATION_MATRIX.md`.
- [ ] **6. Walking skeleton to the target:** the near-empty build reaches the place the owner will test it (device, TestFlight, private publish, staging URL).
- [ ] **7. Repo hygiene and security:** `scripts/security_check.sh` passes; `.env` ignored; commit identity is a no-reply address; first push done.

**Exit criteria:** the agent goes from an edit to a verified build without help; every assumption M1 depends on is listed; the skeleton has reached the target once.

**Verification**

*Automated:*
- `scripts/verify.sh` exits 0, and exits non-zero on the deliberate failure.
- `scripts/security_check.sh` exits 0.

*Human-verified:*
- The skeleton opens on the target ({{device or URL}}).
- The owner has read and approved `docs/AUTOMATION_MATRIX.md`.

---

## M1: Spikes

One smallest-possible experiment per risky assumption. Each result goes to `docs/PLATFORM_CONSTRAINTS.md` as verified, disproved (with the nearest alternative), or still unverified. Use `/spike`.

**Deliverables**

- [ ] **S1 {{assumption}}:** {{the question, and the observation that answers it}}.
- [ ] **S2 {{assumption}}:** {{…}}.

**Exit criteria:** every spike is resolved, or replaced with a workable alternative logged as a decision.

---

## M2: MVP: {{name}}

{{One paragraph: what the owner can do at the end of this milestone that they can't do today.}}

**Deliverables**

- [ ] **1. {{deliverable}}:** {{what, and the observable result}}.
- [ ] **2. {{deliverable}}:** {{…}}.

**Exit criteria:** {{a scenario a real user can walk through end to end}}.

**Verification**

*Automated:*
- Full suite green; new tests exist for {{the core rules}}.

*Human-verified:*
- {{each visual, spatial or experiential check, phrased so yes or no is unambiguous}}.

---

## Later (unscheduled)

Pull items into a milestone only as a logged decision. Ideas live in `docs/IDEAS_BACKLOG.md`.
