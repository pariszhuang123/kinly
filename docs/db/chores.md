# Chores DB Notes (v1)

Source migrations:
- `supabase/migrations/20251114090000_chores_tables.sql`
- `supabase/migrations/20251115022237_chore_related_rpc.sql`
- `supabase/migrations/20251115004227_payment_related_tables.sql`
- `supabase/migrations/20251115044115_payment_related_rpc.sql`

## Tables
- `public.home_entitlements`
  - `home_id` (PK/FK `homes.id`), `plan` (`free|premium`), `expires_at`, timestamps.
  - Derived cache summarising `user_subscriptions` rows that currently fund the home.
- `public.user_subscriptions`
  - Snapshot of RevenueCat entitlements per user. Columns include `store`, `rc_entitlement_id`, `product_id`, `status` (`active|cancelled|expired|inactive`), optional `home_id`, purchase/sync timestamps, and latest store transaction ids.
  - Triggers keep `home_entitlements` up to date when rows insert/update/delete or when subscriptions attach/detach from homes.
- `public.home_usage_counters`
  - `home_id` (PK/FK), `active_chores`, `chore_photos`, `updated_at`.
  - Maintained by RPCs via `_home_usage_increment` so paywall checks never scan `chores`.
- `public.chores`
  - FK: `home_id -> homes.id`, `created_by_user_id -> profiles.id`, optional `assignee_user_id -> profiles.id`.
  - Columns: `start_date`, `recurrence` (`recurrence_interval` enum), `recurrence_cursor`, `next_occurrence`, `expectation_photo_path`, `how_to_video_url`, `notes`, `state` (`chore_state` enum), timestamps.
  - Constraints:
    - `chk_chore_name_length` ensures 1..140 chars.
    - `chk_chore_active_has_assignee` enforces an assignee when `state='active'`.
    - `chk_chore_draft_without_assignee` requires drafts to stay unassigned.
    - `chk_chore_expectation_path` requires Storage paths under `households/`.
  - Index: `idx_chores_home_next_occurrence` (home, due date desc fallback).

- `public.chore_events`
  - Append-only audit log keyed by `chore_id`.
  - `event_type` (`chore_event_type` enum): create/activate/update/complete/cancel.
  - `payload` stores diffs/metadata (JSONB).
  - Indexes on `(chore_id, occurred_at DESC)` and `(home_id, occurred_at DESC)`.

## Enums
- `recurrence_interval`: `none|daily|weekly|every_2_weeks|monthly|every_2_months|annual`.
- `chore_state`: `draft|active|completed|cancelled`.
- `chore_event_type`: `create|activate|update|complete|cancel`.

## Helper functions
- Entitlements: `_home_is_premium(home_id)` selects from `home_entitlements`, `home_entitlements_refresh(home_id)` recomputes the cache, and helper RPCs `_home_attach_subscription_to_home/_home_detach_subscription_to_home` keep `user_subscriptions.home_id` aligned with memberships.
- Quotas: `_home_assert_within_free_limits(home_id, active_delta, photo_delta)` reads cached counters and raises `PAYWALL_LIMIT_ACTIVE_CHORES` / `PAYWALL_LIMIT_CHORE_PHOTOS` when free-tier caps would be exceeded. `_home_usage_increment(home_id, active_delta, photo_delta)` atomically adjusts cached values (create/update/cancel/complete flows call it).
- Membership helpers: `is_home_member`, `is_home_owner`, `_assert_home_member`.
- Scheduling helpers: `_chore_interval`, `_chore_roll_forward`, `_chore_compute_schedule`.
- Event helper: `_chore_emit_event`.
- Storage helper: `_storage_home_from_path` extracts `{homeId}` prefix from Storage key for RLS.

## RPCs (exposed to Flutter)
| Function | Description |
| --- | --- |
| `chores_create(home_id, name, ...)` | Inserts a chore, computes initial schedule, emits `create`, enforces paywall counters. |
| `chores_get_for_home(home_id, chore_id)` | Returns the chore DTO plus eligible assignees. |
| `home_assignees_list(home_id)` | Lists active members + avatars for assignment pickers. |
| `chores_update(chore_id, ...)` | Updates metadata, sets state `active`, emits `activate/update`, adjusts photo counters. |
| `chore_complete(chore_id)` | Completes current occurrence. One-off -> state completed + counter decrement. Recurring -> roll-forward + trigger emits `complete`. |
| `chores_cancel(chore_id)` | Cancels draft/active chores and decrements counters. |
| `chores_list_for_home(home_id)` | Returns actionable chores ordered by creation time (placeholder until next-occurrence view). |

All RPCs are `SECURITY DEFINER`, use `_assert_home_member`, and call `api_error/api_assert` for consistent error shapes (consumed by `SupabaseErrorMapper.mapChore`). They also keep `home_usage_counters` in sync (create/cancel/one-off complete adjust `active_chores`; photo add/remove adjusts `chore_photos`). Free-tier violations surface as `PAYWALL_LIMIT_ACTIVE_CHORES` or `PAYWALL_LIMIT_CHORE_PHOTOS`.

## Storage
- Bucket `households` created (private).
- Policies (`storage.objects`) ensure path prefix matches a home the caller belongs to (insert/select/update/delete).
- Expectation photos stored at `households/{homeId}/chores/{choreId}/expectation.jpg`; DB stores the path only.

Free tier limits enforced inside `chores_create`/`chores_update`: max 20 active chores and 15 expectation photos per home. Errors bubble up as `PAYWALL_LIMIT_ACTIVE_CHORES` / `PAYWALL_LIMIT_CHORE_PHOTOS`, backed by the cached values in `home_usage_counters`.
