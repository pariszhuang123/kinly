# Contracts Changelog

Tracks versioned contract changes and related ADRs.

## v2 — Homes Memberships/Invites Alignment
- Date: 2025-11-11
- Scope: `docs/contracts/homes_v2.md`
- Changes:
  - Replace `Member` with append-only `Membership` stints (validFrom/validTo/isCurrent).
  - Enforce: one current membership per user across homes; one current owner per home; no overlap per (user, home).
  - Invites: `code` is `CITEXT` with Crockford Base32 (6 chars) and added `usedCount`; removed `updatedAt`.
  - RLS: enabled on `homes`, `memberships`, and `invites`; anon/auth revoked on tables.
- Notes: Contracts now reflect migration `20251111225015_home_membership_invites_table.sql`. Repositories should pin to v2.

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
