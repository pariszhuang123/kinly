SET search_path = pgtap, public, auth, extensions;

BEGIN;
SET ROLE postgres;

SELECT plan(5);

-- Seed defaults required by handle_new_user()
INSERT INTO public.avatars (id, storage_path, category, name)
VALUES ('00000000-0000-4000-8000-000000000999', 'avatars/default.png', 'animal', 'Test Avatar')
ON CONFLICT (id) DO NOTHING;

-- Seed minimal user + home
INSERT INTO auth.users (id, instance_id, email, raw_user_meta_data, raw_app_meta_data, aud, role, encrypted_password)
VALUES (
  '00000000-0000-4000-8000-000000000701',
  '00000000-0000-0000-0000-000000000000',
  'paywall-webhook@example.com',
  '{}'::jsonb,
  '{"provider":"email"}'::jsonb,
  'authenticated',
  'authenticated',
  'secret'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.homes (id, owner_user_id)
VALUES (
  '00000000-0000-4000-8000-000000000702',
  '00000000-0000-4000-8000-000000000701'
)
ON CONFLICT (id) DO NOTHING;

-- Ensure baseline entitlement exists (free)
INSERT INTO public.home_entitlements (home_id, plan, expires_at)
VALUES ('00000000-0000-4000-8000-000000000702', 'free', NULL)
ON CONFLICT (home_id) DO NOTHING;

SELECT lives_ok(
  $$
  SELECT public.paywall_record_subscription(
    '00000000-0000-4000-8000-000000000701'::uuid,
    '00000000-0000-4000-8000-000000000702'::uuid,
    'play_store'::public.subscription_store,
    '00000000-0000-4000-8000-000000000701',
    'kinly_premium',
    'com.example.kinly.premium.monthly',
    'active'::public.subscription_status,
    now() + interval '30 days',
    now() - interval '1 day',
    now(),
    'test-txn-1',
    now(),
    'sandbox',
    '{"event":{"type":"INITIAL_PURCHASE"}}'::jsonb,
    NULL
  );
  $$,
  'paywall_record_subscription succeeds'
);

SELECT is(
  (SELECT COUNT(*) FROM public.user_subscriptions WHERE user_id = '00000000-0000-4000-8000-000000000701'::uuid AND rc_entitlement_id = 'kinly_premium'),
  1::bigint,
  'user_subscriptions row upserted'
);

SELECT is(
  (SELECT COUNT(*) FROM public.revenuecat_webhook_events WHERE rc_app_user_id = '00000000-0000-4000-8000-000000000701' AND entitlement_id = 'kinly_premium'),
  1::bigint,
  'revenuecat_webhook_events row inserted'
);

SELECT is(
  (SELECT plan FROM public.home_entitlements WHERE home_id = '00000000-0000-4000-8000-000000000702'::uuid),
  'premium',
  'home_entitlements promoted to premium'
);

SELECT ok(
  (SELECT expires_at IS NULL OR expires_at > now() FROM public.home_entitlements WHERE home_id = '00000000-0000-4000-8000-000000000702'::uuid),
  'home_entitlements expires_at is in the future (or NULL)'
);

SELECT * FROM finish();
ROLLBACK;
