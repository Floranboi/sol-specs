# 10 — Deployment

**Purpose:** Release code through the ecosystem's maturity gates without mismatched builds or mutable tags.

**Confidence note:** verified against `sol-specs/git-guidelines.md` on 2026-11-23. No CI or deployment scripts exist.

## Release order

`main` → `beta` → `release` → production approval.

1. Developers unit test on `main`.
2. Promote the reviewed build to `beta` for QA/system testing.
3. Promote only accepted code to `release` and publish the bundle.
4. Independent testers evaluate alpha, beta, and release-candidate iterations.
5. The final approver deploys the exact approved candidate.

## Tags and build IDs

Product prefixes: `WCN`, `BCN`, `ACN`, `SCN`. Format: `<prefix>.0X.Y.00Z`, with labels `a`, `b`, or `rc` only for candidates. Tags are immutable, annotated, and point to the exact commits/builds on `release`.

Never create an ongoing-week tag, move a tag, retag an earlier week, or use `main`/`beta` for candidate tags.

## Post-production defects

Use a dedicated maintenance lifecycle, increment `Y`, reset `00Z` to `001`, retain `0X` unless approved requirements create a new major cycle, and carry fixes upstream after review.

## Release checklist

- Development complete and unit-tested.
- QA accepted `beta` build.
- Published `release` bundle matches the candidate tag.
- Independent test stage and defects resolved.
- Final candidate approved and exact commit deployed.
- Promotion corrections merged/cherry-picked back upstream.
