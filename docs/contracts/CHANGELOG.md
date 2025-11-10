# Contracts Changelog

Tracks versioned contract changes and related ADRs.

## v1 — Home MVP
- Date: 2025-11-03
- Scope: `docs/contracts/homes_v1.md`
- Highlights: Permanent invite codes (revokable; invalid on home deactivation).
- ADR: `docs/adr/ADR-0002-invites-permanent-codes.md`
- Notes: Repositories/BLoC pin to v1. Breaking changes must create `homes_v2.md` and a new ADR.

## v1 — Users/Avatars Alignment
- Date: 2025-11-10
- Scope: `docs/contracts/users_v1.md`
- Changes:
  - Align registry and users_v1 contracts with migrations:
    - Add `Avatar` entity (id, storagePath, category, name, createdAt).
    - Update `UserProfile` (id, email, fullName, avatarId, createdAt, deactivated_at).
  - RLS documented:
    - `public.profiles`: self-select only; client writes revoked.
    - `public.avatars`: SELECT for authenticated users.
  - `users.selfDelete` effects text updated to remove future-state fields.
- Notes: Extractor and registry in sync; validator passing.
