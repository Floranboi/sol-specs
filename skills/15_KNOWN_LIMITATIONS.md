# 15 — Known Limitations

**Purpose:** Rank surprises and deferred choices before implementation begins.

**Confidence note:** current workspace state is verified on 2026-11-23; implementation risks are inferred.

## Ranked limitations

1. **No implementation exists.** The API, Android, web, schema, routes, tests, and build commands cannot be verified. Likelihood: certain. Impact: every concrete workflow is incomplete.
2. **Business requirements are placeholders.** Platform, stack, team, code name, short code, feature names, access rules, and MVP features remain unspecified.
3. **Live schema and migrations are absent.** Database decisions are design guidance, not an implemented constraint set.
4. **No commit history exists.** Incident and change evidence cannot be reconstructed; all failure stories are inferred.
5. **Authentication details are unresolved.** Google Sign-In, callbacks, session shape, account UUID mapping, and revocation are not defined.
6. **Tag examples are placeholders.** Next release identifiers exist, but no actual tags or first commits are available.
7. **No performance baseline or hard limit exists.** Sync scale and accepted latency are unknown.
8. **Privacy controls are stated but not specified.** Retention periods, aggregation thresholds, location safeguards, and resale consent need concrete policy.

## Redesign candidates

- Replace row-level last-write-wins with field or operation history only if conflict evidence shows whole-row loss is unacceptable.
- Add server foreign keys or domain integrity only for data that is always fully available and ordered.
- Add delta sync or server queues only after measured full-pull cost and tombstone volume justify it.
