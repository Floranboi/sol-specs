# 13 — Dependencies

**Purpose:** Record dependency decisions and traps; implementation dependencies are not yet chosen.

**Confidence note:** low. Repository files contain no manifests or dependency lists.

## Policy

No package policy is implemented. A dependency must be justified by a concrete capability and must not hide the UUID, sync, or migration invariants.

## Known dependency direction

- Supabase/Postgres is the intended central server storage/API platform.
- Web and Android are separate clients.
- SQLite is the documented client database format.
- Google Sign-In is required for authentication.

## Rejections

None documented as deliberate rejections. Do not add a third-party ORM or sync framework merely to save code if it bypasses the dirty/tombstone rules or actor allowlists.

## Upgrade traps

- SQLite migration behavior differs from Postgres `ADD COLUMN IF NOT EXISTS`.
- Timestamp precision must remain known across client and server.
- Authentication provider SDKs may hide session/account UUID mapping.
- Any dependency that sends or uses server integer `id` values for sync identity must be rejected or isolated.
