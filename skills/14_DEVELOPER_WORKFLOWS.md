# 14 — Developer Workflows

**Purpose:** Provide verified setup and change recipes from the current repository state.

**Confidence note:** setup is unverified because no manifests or source exist. Process rules are verified on 2026-11-23.

## Setup

1. Clone the ecosystem repositories and open the parent workspace.
2. Read `AGENTS.md` files and `sol-specs/git-guidelines.md`.
3. The implementation repositories currently contain no setup manifests. Before running an app, create and document the real package/build configuration, environment variable names, database migration command, test command, and local seed.

## Add a synchronized table

1. Choose a server/postgres and client SQLite mirror; mint UUID externally.
2. Add `id`, `uuid`, `created_by`, timestamps, and `archived_at` as applicable.
3. Index every sync and parent UUID lookup.
4. Add server migration, backfill, and re-entrant client migration.
5. Update push/pull allowlists and dirty/tombstone tests. Guard: 04 #1–#6.

## Change an enum or lockstep set

1. Update server enum/check and migration.
2. Update SQLite `TEXT + CHECK` and UI validation.
3. Test old payload compatibility and unknown values.
4. Retest sync and add a migration test. Guard: 04 #7.

## Release a build

1. Unit test on `main`.
2. Promote reviewed code to `beta`, run system tests.
3. Promote to `release`, publish the exact bundle, and tag the candidate.
4. Run alpha/beta/RC gates and deploy only the final approved candidate.

Guard: 04 #8–#9 and 10.

At the end of any surprising task, add what you learned to `INBOX.md`.
