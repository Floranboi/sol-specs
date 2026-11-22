# 03 — Code Style

**Purpose:** Apply the repository's concrete conventions while implementation scaffolding is incomplete.

**Confidence note:** inferred mostly from specifications on 2026-11-23; no language or framework source was available.

## Comment philosophy

Explain why, especially for sync guards and migration decisions. The database document names the cost of dirty-checks, tombstones, denormalization, and legacy columns. Preserve those costs beside the guard. *Miss → a future edit can silently lose synchronization or data integrity.*

## Tooling

No compiler, formatter, package manager, or test runner is present. Do not invent commands. Before implementing, add and document the actual manifest and setup in 14.

## Naming and data

- Use UUID names for global relationships: `<entity>_uuid`.
- Keep server `id` and client `id` internal; never serialize either.
- Use `created_by`, `created_at`, `updated_at`, and `archived_at` with their documented meanings.
- Use `TEXT + CHECK` on SQLite and enums on Postgres for closed vocabularies.

## Error handling and logging

No implementation convention is available. Safety baseline:
- Return stable machine-readable API errors once routes exist; log request and row UUIDs, not secrets or payloads.
- Treat missing parent data as retryable consistency rather than a fatal sync failure.
- Acknowledge an empty change stamp already held by the server; otherwise clients retry forever.

## Commit conventions

Follow `sol-specs/git-guidelines.md`: `scope: Imperative summary`, 50 characters or fewer. Specification commits use `code-name-specs/<kind-or-feature>:`. AI agents must not be commit authors.
