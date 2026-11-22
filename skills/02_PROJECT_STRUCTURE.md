# 02 — Project Structure

**Purpose:** Explain the ecosystem tree and where new implementation work belongs.

**Confidence note:** verified against the workspace tree on 2026-11-23. No source manifests were present.

## Annotated tree

- `sol-api/` — API and Supabase integration; no implementation files yet.
- `sol-android/` — Android application; no implementation files yet.
- `sol-web/` — web application; no implementation files yet.
- `sol-specs/` — requirements, research instructions, git/release rules, and skills.
- `sol-specs/skills/` — operator knowledge generated from verified evidence.
- `db-design-choices.md` — canonical offline-first database rationale.
- `handoff.md` — handoff procedure and document format.

## Where code goes

- Web-only behavior: `sol-web/`.
- Android-only behavior: `sol-android/`.
- Shared transport, authentication, server-side authorization, and sync: `sol-api/`.
- Schema contract mirrored across clients and server: update database skill and specs together.
- Cross-repository release rules: `sol-specs/git-guidelines.md` and 10/14 skills.

## Must not go here

Do not put API implementation, Android source, or web source in `sol-specs/`. Do not duplicate database policy in implementation comments where `db-design-choices.md` is the canonical explanation.

## Naming

- Product scopes use established `code-name-*` repository names.
- Skills use `NN_TOPIC.md` and append rather than renumber.
- Tables and UUID relationship columns use the names documented in 07.
