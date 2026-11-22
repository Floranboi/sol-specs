# 16 — Engineering Principles

**Purpose:** Preserve the few decisions that explain recurring patterns.

**Confidence note:** principles below are directly evidenced by `db-design-choices.md` or the git guidelines. Repository implementation evidence is absent.

## 1. Keep global identity offline-safe

Mint UUIDs for rows and relationships. Never expose server surrogate IDs as shared identity. This avoids client collision and out-of-order sync failures. Evidence: `db-design-choices.md` §§2–3.

## 2. Synchronize state, not a separate hidden queue

Use dirty checks over `updated_at`/`synchronized_at` and tombstones over physical deletes. This prevents a queue from drifting out of sync with rows. Evidence: `db-design-choices.md` §6.

## 3. Never let a client become the authority for its own actor

Stamp `created_by` and action actors from the authenticated session and exclude them from payload allowlists. Otherwise a client can falsely claim ownership or approval. Evidence: `db-design-choices.md` §4.

## 4. Apply additive migrations before dependent code

Server migrations precede client deployment; client migration chains re-enter safely and preserve real data. Removing a field comes after old clients stop using it. Evidence: `db-design-choices.md` §9.

## 5. Gate promotions explicitly

Release acceptance advances in reviewed stages; no branch name or candidate presence substitutes for the designated test gate or production approval. Evidence: `sol-specs/git-guidelines.md`, Part 2.

Trust the code over any document, including this one.
