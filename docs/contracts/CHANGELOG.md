# Contracts Changelog

Tracks versioned contract changes and related ADRs.

## CODEX-L10N-001 -- Codex i18n Hygiene
- Date: 2025-12-24
- Scope: `docs/contracts/codex_i18n_hygiene.md`
- Changes:
  - Define canonical EN source (`lib/l10n/intl_en.arb`) and enforce no unused keys or invalid references.
  - Add `tool/l10n_integrity_check.dart` with optional non-EN drift enforcement.
  - Wire the new check into CI and AGENTS merge checklist.

## v1 — Expenses MVP
- Date: 2025-11-20
- Scope: `docs/contracts/expenses_v1.md`
- Changes:
  - Define `Expense`, `ExpenseSplit`, and `ExpenseSummaryDto` entities plus enums.
  - Document lifecycle (draft → active → cancelled), debtor-only payments, derived summary fields, and access patterns.
  - 2025-11-21: Capture Supabase requirements: tables, grants, and RPCs (`expenses.create`, `expenses.edit`, `expenses.markSharePaid`, `expenses.cancel`, `expenses.getCurrentOwed`, `expenses.getCreatedByMe`). Tables remain RPC-only with RLS disabled + GRANT revokes per ADR-0003 (`docs/adr/ADR-0003-expenses-rpc-only-access.md`).
  - 2025-11-22: Allow creators to participate in equal/custom splits (creator rows persisted but auto-marked `paid`; at least one non-creator debtor required; each active expense involves two unique members).
  - 2025-12-22: Add “Who paid me” recipient view state (`expense_splits.recipient_viewed_at`) and RPCs for Today + drilldown (`expenses.getCurrentPaidToMeDebtors`, `expenses.getCurrentPaidToMeByDebtorDetails`, `expenses.markPaidReceivedViewedForDebtor`). Existing paid splits remain unseen (no backfill) to surface badges during testing; creator auto-paid splits are excluded from paid-to-me responses.
  - 2025-12-23: Paid-to-me RPCs return debtor avatar + owner flag (`homes.owner_user_id` match) in both list and drilldown payloads.
  - 2025-12-27: Fold recurring activation into `expenses.create`/`expenses.edit`, add `expense_plans` + `expense_plan_debtors`, introduce `expense_status=converted` and `expense_plan_status`, add `expenses.payMyDue` bulk payment, make active expenses immutable, store `fully_paid_at` for idempotent quota decrements, and update `docs/contracts/share_recurring_v1.md`.
- Notes: Home members can author expenses; drafts stay private; Today/Explore surfaces consume the summary RPCs.

## v2 — Homes Memberships/Invites Alignment
- Date: 2025-11-11
- Scope: `docs/contracts/homes_v2.md`
- Changes:
  - Replace `Member` with append-only `Membership` stints (validFrom/validTo/isCurrent).
  - Enforce: one current membership per user across homes; one current owner per home; no overlap per (user, home).
  - Invites: `code` is `CITEXT` with Crockford Base32 (6 chars) and added `usedCount`; removed `updatedAt`.
  - RLS: enabled on `homes`, `memberships`, and `invites`; anon/auth revoked on tables.
- Notes: Contracts reflect migration `20251111225015_home_membership_invites_table.sql`. Repositories should pin to v2.

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
