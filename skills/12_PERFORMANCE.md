# 12 — Performance

**Purpose:** Identify expensive sync and indexing decisions before implementation.

**Confidence note:** mostly inherited design facts on 2026-11-23; no benchmarks or limits exist.

## Hard limits

None are measured or specified. Do not invent throughput, latency, or row-count targets.

## Hot paths

- Scoped push/push gating over dirty rows.
- Pull lookup by UUID and parent UUID.
- Live-row uniqueness and normal-read tombstone gates.
- Backfill and migration over existing server rows.

## Deliberate choices to leave alone

- Index every `*_uuid` relationship used for pulls.
- Prefer `WHERE` gates over queues for dirty rows.
- Keep server `id` indexes for size and arrival order, but treat UUID indexes as the real sync work.
- Use denormalized shortcuts only for measured read pain or partial-dataset correctness.

## Expensive operations

- Full-dataset pulls; delta sync is absent by design but would become necessary at scale.
- SQLite table rebuild migrations.
- Joining missing parents in partial datasets.
- Re-reading and comparing every local copy during conflict resolution.

## Profiling

No profiling tools or baselines exist. Record environment, row counts, network shape, migration size, and exact queries before claiming a regression.
