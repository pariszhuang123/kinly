# Expenses Contracts v1

Status: Draft (in-flight alignment)

Scope: Defines the household shared expenses lifecycle for the Home-only MVP so UI, BLoC, repositories, and Supabase schema share one contract.

## Domain overview
- Any active home member can author expenses. The author (payer) is the only person who can edit or cancel that expense.
- Expenses start as a **draft** (quick capture) and become **active** once the creator defines how the cost is split. Drafts are visible only to the creator; active expenses are visible to the entire home.
- The split can be `equal` (integer division in cents across selected members; remainder flows to the last entry) or `custom` (explicit cents per debtor). Drafts keep `splitType = NULL`.
- Splits live in `expense_splits`. Each row is “debtor X owes Y cents to the creator for this expense.” Payment tracking is per split; there is no top-level “paid” flag. When the creator allocates a share to themselves it is stored as a split row marked `paid` immediately so edit flows can round-trip their portion without affecting “who still owes” calculations.
- Each debtor can mark their own share as paid (idempotent; no partial payments). Once any share is paid, the amount and split structure become immutable.
- The Today surface shows only "what I owe" grouped by payer. Explore + Share lists expenses authored by the caller with derived progress like "2 of 3 shares paid," and those counters include the creator's auto-paid share so "1 of 3" appears as soon as the payer covers their portion.
- Fully paid is a derived view: `allPaid = (totalShares > 0 AND paidShares = totalShares)`. UI can hide settled expenses using this flag without mutating status.
- Lifecycle illustration: `docs/diagrams/expenses/expense_lifecycle.md`.

## Entities

### Expense
- `id` (`uuid`) — primary key.
- `homeId` (`uuid`) — FK `homes.id`.
- `createdByUserId` (`uuid`) — FK `profiles.id`; payer/author.
- `status` (`ExpenseStatus`) — `draft | active | cancelled`.
- `splitType` (`ExpenseSplitType|null`) — `equal | custom | null` (draft).
- `amountCents` (`bigint`) — total amount in integer cents (> 0).
- `description` (`text`) — required, trimmed length 1–280.
- `notes` (`text|null`) — optional.
- `createdAt` (`timestamptz`) — creation timestamp (also used as expense date in v1).
- `updatedAt` (`timestamptz`) — last modification timestamp.

### ExpenseSplit
- `expenseId` (`uuid`) — FK `expenses.id`.
- `debtorUserId` (`uuid`) — FK `profiles.id`; must be a current member of the same home at split time.
- `amountCents` (`bigint`) — per-person share in cents (> 0).
- `status` (`ExpenseShareStatus`) — `unpaid | paid`.
- `markedPaidAt` (`timestamptz|null`) — when the debtor marked their share paid.
- `recipientViewedAt` (`timestamptz|null`) — when the creator viewed a paid split; `NULL` means unseen.
- Composite PK: `(expenseId, debtorUserId)`.

### ExpenseSummaryDto
Projection for list views (Explore → Share, repository caches).
- `id: uuid`
- `homeId: uuid`
- `createdByUserId: uuid`
- `status: ExpenseStatus`
- `splitType: ExpenseSplitType|null`
- `amountCents: bigint`
- `description: text`
- `createdAt: timestamptz`
- `totalShares: int`
- `paidShares: int` (counts the creator's auto-paid split plus any other member shares that have been marked paid)
- `paidAmountCents: bigint` (sum of all paid splits, including the creator's auto-paid amount when present)
- `allPaid: boolean` — `totalShares > 0 AND paidShares = totalShares`.

## Enums

### ExpenseStatus
`draft | active | cancelled`
- `draft` — quick capture; creator-only.
- `active` — visible to the home; split defined.
- `cancelled` — creator invalidated the expense; splits remain for audit but are hidden from Today.

### ExpenseSplitType
`equal | custom`
- `equal` — equal division across selected members (remainder to the last entry).
- `custom` — explicit cents per debtor; sum must equal `amountCents`.

### ExpenseShareStatus
`unpaid | paid`
- `unpaid` — debtor still owes the share.
- `paid` — debtor declared payment (declarative only; Kinly does not reconcile bank data).

## Contracts JSON

```contracts-json
{
  "domain": "expenses",
  "version": "v1",
  "entities": {
    "Expense": {
      "id": "uuid",
      "homeId": "uuid",
      "createdByUserId": "uuid",
      "status": "ExpenseStatus",
      "splitType": "ExpenseSplitType|null",
      "amountCents": "bigint",
      "description": "text",
      "notes": "text|null",
      "createdAt": "timestamptz",
      "updatedAt": "timestamptz"
    },
    "ExpenseSplit": {
      "expenseId": "uuid",
      "debtorUserId": "uuid",
      "amountCents": "bigint",
      "status": "ExpenseShareStatus",
      "markedPaidAt": "timestamptz|null"
    },
    "ExpenseSummaryDto": {
      "id": "uuid",
      "homeId": "uuid",
      "createdByUserId": "uuid",
      "status": "ExpenseStatus",
      "splitType": "ExpenseSplitType|null",
      "amountCents": "bigint",
      "description": "text",
      "createdAt": "timestamptz",
      "totalShares": "int",
      "paidShares": "int",
      "paidAmountCents": "bigint",
      "allPaid": "boolean"
    }
  },
  "enums": {
    "ExpenseStatus": [
      "draft",
      "active",
      "cancelled"
    ],
    "ExpenseSplitType": [
      "equal",
      "custom"
    ],
    "ExpenseShareStatus": [
      "unpaid",
      "paid"
    ]
  },
  "functions": {
    "expenses.create": {
      "type": "rpc",
      "caller": "member",
      "impl": "public.expenses_create",
      "args": {
        "p_home_id": "uuid",
        "p_amount_cents": "bigint",
        "p_description": "text",
        "p_notes": "text|null",
        "p_split_mode": "ExpenseSplitType|null",
        "p_member_ids": "uuid[]|null",
        "p_splits": "jsonb|null"
      },
      "returns": "Expense"
    },
    "expenses.edit": {
      "type": "rpc",
      "caller": "member",
      "impl": "public.expenses_edit",
      "args": {
        "p_expense_id": "uuid",
        "p_amount_cents": "bigint",
        "p_description": "text",
        "p_notes": "text|null",
        "p_split_mode": "ExpenseSplitType|null",
        "p_member_ids": "uuid[]|null",
        "p_splits": "jsonb|null"
      },
      "returns": "Expense"
    },
    "expenses.markSharePaid": {
      "type": "rpc",
      "caller": "member",
      "impl": "public.expenses_mark_share_paid",
      "args": {
        "p_expense_id": "uuid"
      },
      "returns": "ExpenseSplit"
    },
    "expenses.cancel": {
      "type": "rpc",
      "caller": "member",
      "impl": "public.expenses_cancel",
      "args": {
        "p_expense_id": "uuid"
      },
      "returns": "Expense"
    },
    "expenses.getCurrentOwed": {
      "type": "rpc",
      "caller": "member",
      "impl": "public.expenses_get_current_owed",
      "args": {
        "p_home_id": "uuid"
      },
      "returns": "jsonb"
    },
    "expenses.getCreatedByMe": {
      "type": "rpc",
      "caller": "member",
      "impl": "public.expenses_get_created_by_me",
      "args": {
        "p_home_id": "uuid"
      },
      "returns": "jsonb"
    }
  },
  "rls": [
    {
      "table": "public.expenses",
      "rule": "RLS disabled; anon/auth/ service roles have no grants. All read/write access flows through SECURITY DEFINER RPCs."
    },
    {
      "table": "public.expense_splits",
      "rule": "RLS disabled; anon/auth have no grants. Splits are only visible/mutated inside SECURITY DEFINER RPCs."
    }
  ]
}
```

## Validation and business rules
- **Home membership**: all calls assert the caller is a current member of `homeId`. Creating or editing requires the home to be `is_active = true`.
- **Creator-only edits**: only `createdByUserId` can update or cancel an expense. Drafts remain private to the creator.
- **Draft vs. active**: `p_split_mode IS NULL` creates or keeps a draft. Passing `equal/custom` promotes the record to `status='active'` and `splitType=p_split_mode`. Once active, it never reverts to draft.
- **Amounts**: `amountCents` must be positive and ≤ 9,000,000,000,000 (safety cap). Description must be 1–280 chars after trim; notes ≤ 2,000 chars.
- **Equal split**: `p_member_ids` must include at least two unique active members, and at least one of them must be someone other than the creator. The creator may be included to record their portion; when present their split row is persisted with `status='paid'` so only other members appear in owed summaries. Server performs integer division in cents; remainder flows to the last entry in the provided order.
- **Custom split**: `p_splits` is a non-empty JSON array of `{ "user_id": uuid, "amount_cents": bigint }`. All debtors must be active members of the home. Entries for the creator are allowed (to represent the creator's share) and are stored with `status='paid'` during insert. Sum of `amount_cents` must equal `amountCents`, at least one non-creator debtor must be present, and the array must represent at least two unique members.
- **Editing drafts**: `expenses.edit` requires `p_split_mode` when the existing status is `draft` so edits promote to `active`.
- **Editing active expenses**: If any split is `status='paid'`, only `description` and `notes` can change; amount/split structure updates raise `EXPENSE_LOCKED_AFTER_PAYMENT`. When no split is paid, the creator can rebuild the split (equal/custom) as long as validations pass. Changing the amount on an active expense without providing split details raises `SPLIT_REQUIRED`.
- **Mark paid**: only the debtor for a split can mark it paid, and only when `status='active'`. Action is idempotent.
- **Cancel**: only creators can cancel, and only when no splits have been paid. Cancelling drafts or actives sets `status='cancelled'` and keeps splits for audit.
- **Summary RPCs**: `expenses.getCurrentOwed` returns owed items for `auth.uid()` grouped by payer; `expenses.getCreatedByMe` lists the caller's authored expenses with derived totals, and `paidShares/paidAmountCents` count the creator's auto-paid split so the progress bar reflects their own contribution.

## RPC endpoints

- ### `expenses.create`
  - Caller: authenticated member of `p_home_id`.
  - Args: see JSON block above.
  - Behavior: inserts a new expense tied to the caller. `p_split_mode=NULL` writes a draft with no splits; `equal/custom` writes `status='active'` plus split rows (validated via `_expenses_prepare_split_buffer`).
  - Errors: `INVALID_HOME`, `INVALID_AMOUNT`, `INVALID_DESCRIPTION`, `INVALID_NOTES`, `NOT_HOME_MEMBER`, `HOME_INACTIVE`, `INVALID_SPLIT`, `SPLIT_MEMBERS_REQUIRED`, `INVALID_DEBTOR`, `SPLIT_SUM_MISMATCH`.

- ### `expenses.edit`
  - Caller: creator of the expense.
  - Args: `{ p_expense_id, p_amount_cents, p_description, p_notes, p_split_mode?, p_member_ids?, p_splits? }`.
  - Behavior: loads and locks the expense. Drafts must provide `p_split_mode` and become active. Active rows with no paid splits can rebuild amount/split; once any split is paid, only description/notes change.
  - Errors: `NOT_FOUND`, `NOT_CREATOR`, `INVALID_STATE`, `SPLIT_REQUIRED`, `EXPENSE_LOCKED_AFTER_PAYMENT`, plus validation errors listed under `expenses.create`.

- ### `expenses.markSharePaid`
  - Caller: debtor of the split (must be an active member of the expense home).
  - Args: `{ p_expense_id }`.
  - Behavior: ensures parent expense is active, finds the caller’s split, and sets `status='paid', markedPaidAt=now()` if not already paid. Returns the split row (idempotent).

- ### `expenses.cancel`
  - Caller: creator of the expense.
  - Args: `{ p_expense_id }`.
  - Behavior: validates caller, enforces the “no paid splits” guard, and sets `status='cancelled', updatedAt=now()`. Splits remain for audit but are ignored by Today.

- ### `expenses.getCurrentOwed`
  - Caller: member of `p_home_id`.
  - Args: `{ p_home_id }`.
- Behavior: returns JSON `[ { payerUserId, payerDisplay, payerAvatarUrl, totalOwedCents, items: [ { expenseId, description, amountCents } ] } ]` filtered to active expenses and unpaid splits where `debtor_user_id = auth.uid()`. `payerDisplay` is the payer's `username` (falling back to `full_name` then `email`).

- ### `expenses.getCreatedByMe`
  - Caller: member of `p_home_id`.
  - Args: `{ p_home_id }`.
  - Behavior: returns JSON array of ExpenseSummaryDto projections for expenses created by the caller in the home. Includes `totalShares`, `paidShares`, `paidAmountCents`, `allPaid`, and `fullyPaidAt` for UI grouping; does **not** include debtor identities.

## RLS and access
- `expenses`: RLS disabled. Tables are locked to clients via `REVOKE ALL ON public.expenses FROM anon, authenticated`. All reads/writes occur inside SECURITY DEFINER RPCs that re-check membership, ownership, and lifecycle rules.
- `expense_splits`: mirrored posture—RLS disabled and grants revoked. RPCs own inserts/updates/deletes and enforce the “debtor-only payment” rule.

## Decisions
1. **Split RPCs**: `expenses.create` and `expenses.edit` replace the single `expenses.save` entry point so migrations can evolve create-time vs. edit-time guards independently.
2. **Per-split locking**: payments lock the amount/split to avoid reconciliation confusion. Creators can still tweak descriptions/notes post-payment.
3. **Debtor-only payments**: empowers each member to acknowledge payment without letting creators “check off” unpaid shares.
4. **Derived metrics**: summary RPCs expose `totalShares/paidShares/paidAmountCents/allPaid` so UI can express "2 of 3 paid" without additional client math, and those counters include the creator's auto-paid share for clearer progress messaging.
5. **RPC-only access**: With RLS disabled and grants revoked, expenses tables stay invisible to clients unless they call the approved SECURITY DEFINER RPCs.

## Who paid me (Today + drilldown) v1.1 — Draft
- Goal: when a debtor marks their split paid, the creator can see “Who paid me” in Today (avatars + totals), open a debtor list, drill into that debtor’s paid items, and mark those items as viewed.
- Scope: active expenses only; payer is always `expenses.created_by_user_id`; debtors mark their own split as paid; no partial payments or bank verification.
- Data model: `expense_splits.recipientViewedAt` (`timestamptz|null`) tracks whether the creator has seen a paid split; transitions to `NULL` when a split becomes paid; only the creator sets it via a dedicated RPC. Existing paid splits stay unseen (no backfill) so badges surface during testing.
- Summary/list RPC (JSON):
  - `expenses.getCurrentPaidToMeDebtors(p_home_id)` → `[ { debtorUserId, debtorUsername, totalPaidCents, unseenCount, latestPaidAt } ]` ordered by most recent payment. Creator auto-paid splits are excluded (`debtor_user_id != created_by_user_id`). UI slices to top 3 + overflow for Today.
- Drilldown RPC (JSON):
  - `expenses.getCurrentPaidToMeByDebtorDetails(p_home_id, p_debtor_user_id)` → `[ { expenseId, description, notes, amountCents, markedPaidAt } ]` ordered by newest payment. Creator auto-paid splits are excluded.
- View-state RPC:
  - `expenses.markPaidReceivedViewedForDebtor(p_home_id, p_debtor_user_id)` → integer count of paid splits that were marked viewed (sets `recipientViewedAt=now()` for unseen items). Called when opening debtor detail.
- UX contract: Today tile is hidden when `totalPaidCents == 0`; tile shows up to three debtor avatars with overflow `+N` and aggregates `totalPaidCents`. Debtor detail marks only that debtor’s unseen items as viewed.
