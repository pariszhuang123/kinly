SET search_path = pgtap, public, auth, extensions;

-- pgTAP tests for notifications daily migration
BEGIN;
SELECT plan(29);

CREATE TEMP TABLE tmp_users (
  label   text PRIMARY KEY,
  user_id uuid,
  email   text
);

CREATE TEMP TABLE tmp_tokens (
  label     text PRIMARY KEY,
  token_id  uuid,
  user_id   uuid
);

-- Stub today_has_content so we can deterministically include/exclude users
CREATE OR REPLACE FUNCTION public.today_has_content(
  p_user_id    uuid,
  p_timezone   text,
  p_local_date date
) RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT p_user_id <> '20000000-0000-4000-9000-000000000002'::uuid;
$$;

-- Seed auth users (profiles auto-created via trigger)
INSERT INTO tmp_users (label, user_id, email) VALUES
  ('eligible',        '20000000-0000-4000-9000-000000000001', 'eligible-notify@example.com'),
  ('no_content',      '20000000-0000-4000-9000-000000000002', 'no-content-notify@example.com'),
  ('expired_token',   '20000000-0000-4000-9000-000000000003', 'expired-notify@example.com'),
  ('reserve_target',  '20000000-0000-4000-9000-000000000004', 'reserve-notify@example.com'),
  ('success_target',  '20000000-0000-4000-9000-000000000005', 'success-notify@example.com'),
  ('failure_target',  '20000000-0000-4000-9000-000000000006', 'failure-notify@example.com');

INSERT INTO auth.users (id, instance_id, email, raw_user_meta_data, raw_app_meta_data, aud, role, encrypted_password)
SELECT
  user_id,
  '00000000-0000-0000-0000-000000000000'::uuid,
  email,
  '{}'::jsonb,
  '{"provider":"email"}'::jsonb,
  'authenticated',
  'authenticated',
  'secret'
FROM tmp_users
ON CONFLICT (id) DO NOTHING;

-- 1) Tables exist
SELECT has_table(
  'public',
  'notification_preferences',
  'notification_preferences table exists'
);

SELECT has_table(
  'public',
  'device_tokens',
  'device_tokens table exists'
);

SELECT has_table(
  'public',
  'notification_sends',
  'notification_sends table exists'
);

-- 2) Columns sanity
SELECT has_column(
  'public',
  'notification_preferences',
  'preferred_hour',
  'preferred_hour column exists on notification_preferences'
);

SELECT has_column(
  'public',
  'device_tokens',
  'token',
  'token column exists on device_tokens'
);

SELECT has_column(
  'public',
  'device_tokens',
  'status',
  'status column exists on device_tokens'
);

SELECT has_column(
  'public',
  'notification_sends',
  'local_date',
  'local_date column exists on notification_sends'
);

SELECT has_column(
  'public',
  'notification_sends',
  'status',
  'status column exists on notification_sends'
);

-- 3) Unique per user per local_date when sent
SELECT ok(
  (
    SELECT COUNT(*)
    FROM pg_indexes
    WHERE schemaname = 'public'
      AND indexname = 'uq_notification_sends_user_date'
  ) = 1,
  'unique index for sent per day exists'
);

-- 4) RLS enabled on prefs/tokens
SELECT ok(
  (
    SELECT relrowsecurity
    FROM pg_class
    WHERE relname = 'notification_preferences'
  ) = true,
  'RLS enabled on notification_preferences'
);

SELECT ok(
  (
    SELECT relrowsecurity
    FROM pg_class
    WHERE relname = 'device_tokens'
  ) = true,
  'RLS enabled on device_tokens'
);

-- 5) Helper functions exist
SELECT has_function(
  'public',
  'today_has_content',
  ARRAY['uuid','text','date']
);

SELECT has_function(
  'public',
  'notifications_daily_candidates',
  ARRAY['integer','integer']
);

-- Seed preferences + tokens for candidate selection (current hour)
WITH now_parts AS (
  SELECT
    date_part('hour', timezone('UTC', now()))::int AS current_hour,
    timezone('UTC', now())::date                     AS current_date
)
INSERT INTO public.notification_preferences (
  user_id,
  wants_daily,
  preferred_hour,
  timezone,
  locale,
  os_permission,
  last_os_sync_at,
  last_sent_local_date,
  created_at,
  updated_at
)
SELECT
  u.user_id,
  TRUE,
  np.current_hour,
  'UTC',
  'en',
  'allowed',
  now(),
  np.current_date - INTERVAL '1 day',
  now(),
  now()
FROM tmp_users u
CROSS JOIN now_parts np
WHERE u.label IN ('eligible', 'no_content', 'expired_token', 'success_target', 'failure_target');

-- Keep success/failure users out of candidate list while still allowing status updates
UPDATE public.notification_preferences
SET wants_daily = FALSE, os_permission = 'blocked'
WHERE user_id IN (
  '20000000-0000-4000-9000-000000000005',
  '20000000-0000-4000-9000-000000000006'
);

INSERT INTO public.device_tokens (id, user_id, token, provider, platform, status, last_seen_at, created_at, updated_at)
VALUES
  ('30000000-0000-4000-9000-000000000001', '20000000-0000-4000-9000-000000000001', 'eligible-token', 'fcm', 'ios', 'active', now(), now(), now()),
  ('30000000-0000-4000-9000-000000000002', '20000000-0000-4000-9000-000000000002', 'no-content-token', 'fcm', 'ios', 'active', now(), now(), now()),
  ('30000000-0000-4000-9000-000000000003', '20000000-0000-4000-9000-000000000003', 'expired-token', 'fcm', 'ios', 'expired', now(), now(), now()),
  ('30000000-0000-4000-9000-000000000004', '20000000-0000-4000-9000-000000000006', 'failure-token', 'fcm', 'android', 'active', now(), now(), now()),
  ('30000000-0000-4000-9000-000000000005', '20000000-0000-4000-9000-000000000005', 'success-token', 'fcm', 'android', 'active', now(), now(), now());

INSERT INTO tmp_tokens (label, token_id, user_id) VALUES
  ('eligible', '30000000-0000-4000-9000-000000000001', '20000000-0000-4000-9000-000000000001'),
  ('no_content', '30000000-0000-4000-9000-000000000002', '20000000-0000-4000-9000-000000000002'),
  ('expired', '30000000-0000-4000-9000-000000000003', '20000000-0000-4000-9000-000000000003'),
  ('failure', '30000000-0000-4000-9000-000000000004', '20000000-0000-4000-9000-000000000006'),
  ('success', '30000000-0000-4000-9000-000000000005', '20000000-0000-4000-9000-000000000005');

-- Candidate selection filters for wants_daily + allowed + current hour + content present + active token
SET LOCAL ROLE service_role;
WITH candidates AS (
  SELECT * FROM public.notifications_daily_candidates(10, 0)
)
SELECT is(
  (SELECT COUNT(*)::int FROM candidates),
  1,
  'Only eligible users with active tokens are returned'
);

WITH candidates AS (
  SELECT * FROM public.notifications_daily_candidates(10, 0)
)
SELECT is(
  (SELECT user_id::text FROM candidates LIMIT 1),
  '20000000-0000-4000-9000-000000000001',
  'Eligible user returned'
);

WITH candidates AS (
  SELECT * FROM public.notifications_daily_candidates(10, 0)
)
SELECT is(
  (SELECT token_id::text FROM candidates LIMIT 1),
  '30000000-0000-4000-9000-000000000001',
  'Returns active token id'
);

WITH candidates AS (
  SELECT * FROM public.notifications_daily_candidates(10, 0)
)
SELECT is(
  (SELECT local_date::text FROM candidates LIMIT 1),
  (timezone('UTC', now())::date)::text,
  'local_date matches timezone(current_date)'
);

-- Reserve send is idempotent per user+date and stores job_run_id
WITH reserved AS (
  SELECT public.notifications_reserve_send(
    '20000000-0000-4000-9000-000000000004',
    timezone('UTC', now())::date,
    'job-run-1'
  ) AS send_id
),
second_attempt AS (
  SELECT public.notifications_reserve_send(
    '20000000-0000-4000-9000-000000000004',
    timezone('UTC', now())::date,
    'job-run-1'
  ) AS send_id
)
SELECT ok(
  (SELECT send_id IS NOT NULL FROM reserved),
  'First reservation returns a send id'
);

SELECT is(
  (SELECT send_id FROM second_attempt),
  NULL,
  'Second reservation for same user/date returns null'
);

SELECT is(
  (
    SELECT COUNT(*)::int
    FROM public.notification_sends
    WHERE user_id = '20000000-0000-4000-9000-000000000004'
      AND local_date = timezone('UTC', now())::date
  ),
  1,
  'Only one send row persisted per user/date'
);

SELECT is(
  (
    SELECT job_run_id
    FROM public.notification_sends
    WHERE user_id = '20000000-0000-4000-9000-000000000004'
      AND local_date = timezone('UTC', now())::date
  ),
  'job-run-1',
  'job_run_id stored on reservation'
);

-- Mark send success updates status + prefs.last_sent_local_date
WITH reserved AS (
  SELECT public.notifications_reserve_send(
    '20000000-0000-4000-9000-000000000005',
    timezone('UTC', now())::date,
    'job-success'
  ) AS send_id
)
SELECT public.notifications_mark_send_success(
  (SELECT send_id FROM reserved),
  '20000000-0000-4000-9000-000000000005',
  timezone('UTC', now())::date
);

SELECT is(
  (
    SELECT status
    FROM public.notification_sends
    WHERE user_id = '20000000-0000-4000-9000-000000000005'
  ),
  'sent',
  'mark_send_success sets status=sent'
);

SELECT ok(
  (
    SELECT sent_at IS NOT NULL
    FROM public.notification_sends
    WHERE user_id = '20000000-0000-4000-9000-000000000005'
  ),
  'mark_send_success stamps sent_at'
);

SELECT is(
  (
    SELECT last_sent_local_date
    FROM public.notification_preferences
    WHERE user_id = '20000000-0000-4000-9000-000000000005'
  ),
  timezone('UTC', now())::date,
  'Preferences last_sent_local_date updated on success'
);

-- Failed send captures error + failed_at; token status can be updated to expired
WITH reserved AS (
  SELECT public.notifications_reserve_send(
    '20000000-0000-4000-9000-000000000006',
    timezone('UTC', now())::date,
    'job-fail'
  ) AS send_id
)
SELECT public.notifications_update_send_status(
  (SELECT send_id FROM reserved),
  'failed',
  'token_expired'
);

SELECT is(
  (
    SELECT status
    FROM public.notification_sends
    WHERE user_id = '20000000-0000-4000-9000-000000000006'
  ),
  'failed',
  'Failed send stores status'
);

SELECT is(
  (
    SELECT error
    FROM public.notification_sends
    WHERE user_id = '20000000-0000-4000-9000-000000000006'
  ),
  'token_expired',
  'Failed send stores error text'
);

SELECT ok(
  (
    SELECT failed_at IS NOT NULL
    FROM public.notification_sends
    WHERE user_id = '20000000-0000-4000-9000-000000000006'
  ),
  'Failed send stamps failed_at'
);

SELECT public.notifications_mark_token_status(
  (SELECT token_id FROM tmp_tokens WHERE label = 'failure'),
  'expired'
);

SELECT is(
  (
    SELECT status
    FROM public.device_tokens
    WHERE id = (SELECT token_id FROM tmp_tokens WHERE label = 'failure')
  ),
  'expired',
  'mark_token_status updates token status'
);

RESET ROLE;

-- Authenticated role cannot call backend-only RPCs
SET LOCAL ROLE authenticated;
SELECT throws_like(
  $$ SELECT public.notifications_daily_candidates(10, 0); $$,
  '%permission denied%',
  'authenticated role cannot call notifications_daily_candidates'
);
RESET ROLE;

SELECT finish();
ROLLBACK;
