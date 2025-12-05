SET search_path = pgtap, public, auth, extensions;

-- pgTAP tests for notifications daily migration
BEGIN;
SELECT plan(13);

-- 1) Tables exist
SELECT has_table('public', 'notification_preferences', 'notification_preferences table exists');
SELECT has_table('public', 'device_tokens', 'device_tokens table exists');
SELECT has_table('public', 'notification_sends', 'notification_sends table exists');

-- 2) Columns sanity
SELECT col_exists('public', 'notification_preferences', 'preferred_hour');
SELECT col_exists('public', 'device_tokens', 'token');
SELECT col_exists('public', 'device_tokens', 'status');
SELECT col_exists('public', 'notification_sends', 'local_date');
SELECT col_exists('public', 'notification_sends', 'status');

-- 3) Unique per user per local_date when sent
SELECT ok(
  (SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'uq_notification_sends_user_date_sent') = 1,
  'unique index for sent per day exists'
);

-- 4) RLS enabled on prefs/tokens
SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE relname = 'notification_preferences') = true,
  'RLS enabled on notification_preferences'
);
SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE relname = 'device_tokens') = true,
  'RLS enabled on device_tokens'
);

-- 5) Helper functions exist
SELECT has_function('public', 'today_has_content', ARRAY['uuid','text','date']);
SELECT has_function('public', 'notifications_daily_candidates', ARRAY['integer','integer']);

SELECT finish();
ROLLBACK;
