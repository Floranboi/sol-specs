# 04 — Change Rules

**Purpose:** Prevent cross-module drift for schema, sync, and release changes.

**Confidence note:** verified against `db-design-choices.md` and `git-guidelines.md` on 2026-11-23.

## Lockstep sets

1. **Every table on server and client** — same table name and column names, except server/client `id` and client `synchronized_at`. *Miss → sync mapping drifts and push/pull omits data.*
2. **Every local mutation** — bump `updated_at`; only sync writes `synchronized_at`. *Miss → row silently appears clean or dirty forever; see 06 and 07 §6.*
3. **Every push allowlist** — exclude `id`, `created_by`, and other server-stamped actor fields. *Miss → client impersonation or identity corruption.*
4. **Every soft-delete read** — gate live reads with `archived_at IS NULL`; include tombstones in pulls. *Miss → deletes do not propagate or deleted rows reappear.*
5. **Every live uniqueness rule** — mirror Postgres partial indexes to client constraints where possible. *Miss → duplicate live links or notes appear on different clients.*
6. **Every schema migration** — server migration, client re-entrant migration, backfill, index, and fresh-install path. *Miss → old clients crash or upgraded clients lose existing rows.*
7. **Every enum** — Postgres enum/check, SQLite `TEXT + CHECK`, UI validation. *Miss → old clients send values the server rejects.*
8. **Every release tag** — exact commit, prefix, `0X.Y.00Z`, Friday cutoff, and immutability. *Miss → deployed code cannot be proven from release history.*
9. **Every promotion** — same reviewed change set across `main`, `beta`, `release`, and upstream development corrections. *Miss → QA, integration, and production test different code.*

## High-risk areas

- Timestamp precision and same-second delete ties.
- Dirty-row pull handling.
- Table rebuild migrations.
- Denormalized or snapshot columns.
- Account attribution and authorization.
