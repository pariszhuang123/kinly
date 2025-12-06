SET search_path = pgtap, public, auth, extensions;

-- pgTAP tests for notifications daily migration
BEGIN;
SELECT plan(13);

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

SELECT finish();
ROLLBACK;
