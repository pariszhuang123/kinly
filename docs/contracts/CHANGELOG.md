# Contracts Changelog

Tracks versioned contract changes and related ADRs.

## v1 — Expenses MVP
- Date: 2025-11-20
- Scope: `docs/contracts/expenses_v1.md`
- Changes:
  - Define `Expense`, `ExpenseSplit`, and `ExpenseSummaryDto` entities plus enums.
  - Document lifecycle (draft → active → cancelled), debtor-only payments, derived summary fields, and access patterns.
  - 2025-11-21: Capture Supabase requirements: tables, grants, and RPCs (`expenses.create`, `expenses.edit`, `expenses.markSharePaid`, `expenses.cancel`, `expenses.getCurrentOwed`, `expenses.getCreatedByMe`). Tables remain RPC-only with RLS disabled + GRANT revokes per ADR-0003 (`docs/adr/ADR-0003-expenses-rpc-only-access.md`).
  - 2025-11-22: Allow creators to participate in equal/custom splits (creator rows are filtered before persisting `expense_splits`, and at least one non-creator debtor is required).
- Notes: Home members can author expenses; drafts stay private; Today/Explore surfaces consume the summary RPCs.

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
