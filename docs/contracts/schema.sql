


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";






CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






CREATE SCHEMA IF NOT EXISTS "pgtap";


ALTER SCHEMA "pgtap" OWNER TO "postgres";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "btree_gist" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "citext" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgtap" WITH SCHEMA "pgtap";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."chore_event_type" AS ENUM (
    'create',
    'activate',
    'update',
    'complete',
    'cancel'
);


ALTER TYPE "public"."chore_event_type" OWNER TO "postgres";


CREATE TYPE "public"."chore_state" AS ENUM (
    'draft',
    'active',
    'completed',
    'cancelled'
);


ALTER TYPE "public"."chore_state" OWNER TO "postgres";


CREATE TYPE "public"."expense_share_status" AS ENUM (
    'unpaid',
    'paid'
);


ALTER TYPE "public"."expense_share_status" OWNER TO "postgres";


CREATE TYPE "public"."expense_split_type" AS ENUM (
    'equal',
    'custom'
);


ALTER TYPE "public"."expense_split_type" OWNER TO "postgres";


CREATE TYPE "public"."expense_status" AS ENUM (
    'draft',
    'active',
    'cancelled'
);


ALTER TYPE "public"."expense_status" OWNER TO "postgres";


CREATE TYPE "public"."home_usage_metric" AS ENUM (
    'active_chores',
    'chore_photos',
    'active_members'
);


ALTER TYPE "public"."home_usage_metric" OWNER TO "postgres";


CREATE TYPE "public"."mood_scale" AS ENUM (
    'sunny',
    'partially_sunny',
    'cloudy',
    'rainy',
    'thunderstorm'
);


ALTER TYPE "public"."mood_scale" OWNER TO "postgres";


COMMENT ON TYPE "public"."mood_scale" IS 'Scale for household mood: sunny, partially_sunny, cloudy, rainy, thunderstorm.';



CREATE TYPE "public"."recurrence_interval" AS ENUM (
    'none',
    'daily',
    'weekly',
    'every_2_weeks',
    'monthly',
    'every_2_months',
    'annual'
);


ALTER TYPE "public"."recurrence_interval" OWNER TO "postgres";


CREATE TYPE "public"."subscription_status" AS ENUM (
    'active',
    'cancelled',
    'expired',
    'inactive'
);


ALTER TYPE "public"."subscription_status" OWNER TO "postgres";


CREATE TYPE "public"."subscription_store" AS ENUM (
    'app_store',
    'play_store',
    'stripe',
    'promotional'
);


ALTER TYPE "public"."subscription_store" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_assert_authenticated"() RETURNS "void"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    PERFORM public.api_error('UNAUTHORIZED', 'Authentication required', '28000');
  END IF;
END;
$$;


ALTER FUNCTION "public"."_assert_authenticated"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_assert_home_active"("p_home_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_is_active boolean;
BEGIN
  IF p_home_id IS NULL THEN
    PERFORM public.api_error(
      'INVALID_HOME',
      'Home id is required.',
      '22023'
    );
  END IF;

  SELECT h.is_active
  INTO v_is_active
  FROM public.homes h
  WHERE h.id = p_home_id;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'HOME_NOT_FOUND',
      'Home does not exist.',
      'P0002',
      jsonb_build_object('homeId', p_home_id)
    );
  ELSIF v_is_active IS DISTINCT FROM TRUE THEN
    PERFORM public.api_error(
      'HOME_INACTIVE',
      'This home is no longer active.',
      'P0004',
      jsonb_build_object('homeId', p_home_id)
    );
  END IF;
END;
$$;


ALTER FUNCTION "public"."_assert_home_active"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_assert_home_member"("p_home_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user uuid := auth.uid();
BEGIN
  -- Require authentication
  PERFORM public._assert_authenticated();

  -- Check whether this user is an active/current member of the home
  PERFORM 1
  FROM public.memberships hm
  WHERE hm.home_id   = p_home_id
    AND hm.user_id   = v_user
    AND hm.is_current = TRUE       -- 👈 replace hm.left_at IS NULL
  LIMIT 1;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_HOME_MEMBER',
      'You are not a member of this home.',
      '42501',
      jsonb_build_object('home_id', p_home_id)
    );
  END IF;

  RETURN;
END;
$$;


ALTER FUNCTION "public"."_assert_home_member"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_chores_base_for_home"("p_home_id" "uuid") RETURNS TABLE("id" "uuid", "home_id" "uuid", "assignee_user_id" "uuid", "created_by_user_id" "uuid", "name" "text", "state" "public"."chore_state", "current_due_date" "date", "created_at" timestamp with time zone, "assignee_full_name" "text", "assignee_avatar_storage_path" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user uuid := auth.uid();
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  RETURN QUERY
  SELECT
    c.id,
    c.home_id,
    c.assignee_user_id,
    c.created_by_user_id,
    c.name,
    c.state,
    COALESCE(c.next_occurrence, c.start_date) AS current_due_date,
    c.created_at,
    pa.full_name AS assignee_full_name,
    a.storage_path AS assignee_avatar_storage_path
  FROM public.chores c
  LEFT JOIN public.profiles pa
    ON pa.id = c.assignee_user_id
  LEFT JOIN public.avatars a
    ON a.id = pa.avatar_id
  WHERE
    c.home_id = p_home_id;
END;
$$;


ALTER FUNCTION "public"."_chores_base_for_home"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_current_user_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE
    SET "search_path" TO ''
    AS $$
  SELECT auth.uid();
$$;


ALTER FUNCTION "public"."_current_user_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_ensure_unique_avatar_for_home"("p_home_id" "uuid", "p_user_id" "uuid") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_avatar_before uuid;
  v_new_avatar uuid;
  v_plan text;
BEGIN
  PERFORM public._assert_authenticated();

  -- Lock profile row for this user
  SELECT p.avatar_id
    INTO v_avatar_before
  FROM public.profiles p
  WHERE p.id = p_user_id
    AND p.deactivated_at IS NULL
  FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'PROFILE_NOT_FOUND',
      'Active profile not found for current user.',
      '22000',
      jsonb_build_object('user_id', p_user_id)
    );
  END IF;

  -- Default plan to free if none found
  v_plan := public._home_effective_plan(p_home_id);
  IF v_plan IS NULL THEN
    v_plan := 'free';
  END IF;

  -- If current avatar is unique in this home, keep it
  IF v_avatar_before IS NOT NULL THEN
    PERFORM 1
    FROM public.memberships m
    JOIN public.profiles pr
      ON pr.id = m.user_id
    WHERE m.home_id = p_home_id
      AND m.is_current = TRUE
      AND pr.deactivated_at IS NULL
      AND pr.avatar_id = v_avatar_before
      AND pr.id <> p_user_id;

    IF NOT FOUND THEN
      RETURN v_avatar_before;
    END IF;
  END IF;

  -- Pick the first available avatar respecting plan and excluding other members
  WITH used_by_others AS (
    SELECT DISTINCT pr.avatar_id
    FROM public.memberships m
    JOIN public.profiles pr
      ON pr.id = m.user_id
    WHERE m.home_id = p_home_id
      AND m.is_current = TRUE
      AND pr.deactivated_at IS NULL
      AND pr.id <> p_user_id
  )
  SELECT a.id
    INTO v_new_avatar
  FROM public.avatars a
  LEFT JOIN used_by_others u
    ON u.avatar_id = a.id
  WHERE u.avatar_id IS NULL
    AND (v_plan <> 'free' OR a.category = 'animal')
  ORDER BY a.created_at ASC
  LIMIT 1;

  IF v_new_avatar IS NULL THEN
    PERFORM public.api_error(
      'NO_AVAILABLE_AVATAR',
      'No available avatars for this home.',
      'P0001',
      jsonb_build_object('home_id', p_home_id, 'plan', v_plan)
    );
  END IF;

  UPDATE public.profiles
     SET avatar_id = v_new_avatar,
         updated_at = now()
   WHERE id = p_user_id
     AND deactivated_at IS NULL;

  RETURN v_new_avatar;
END;
$$;


ALTER FUNCTION "public"."_ensure_unique_avatar_for_home"("p_home_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_expenses_prepare_split_buffer"("p_home_id" "uuid", "p_creator_id" "uuid", "p_amount_cents" bigint, "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[] DEFAULT NULL::"uuid"[], "p_splits" "jsonb" DEFAULT NULL::"jsonb") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_split_count         integer;
  v_split_sum           bigint;
  v_member_count        integer;
  v_non_creator_members integer;
BEGIN
  IF p_split_mode IS NULL THEN
    PERFORM public.api_error(
      'INVALID_SPLIT',
      'Split mode is required to build splits.',
      '22023'
    );
  END IF;

  -- Temp buffer for splits
  CREATE TEMP TABLE IF NOT EXISTS pg_temp.expense_split_buffer (
    debtor_user_id uuid,
    amount_cents   bigint
  ) ON COMMIT DROP;

  TRUNCATE pg_temp.expense_split_buffer;

  -- Build buffer from equal/custom
  IF p_split_mode = 'equal' THEN
    IF p_member_ids IS NULL OR array_length(p_member_ids, 1) IS NULL THEN
      PERFORM public.api_error(
        'SPLIT_MEMBERS_REQUIRED',
        'Provide at least one member for an equal split.',
        '22023'
      );
    END IF;

    INSERT INTO pg_temp.expense_split_buffer (debtor_user_id, amount_cents)
    SELECT
      member_id,
      (p_amount_cents / total_count)
        + CASE WHEN row_number = total_count
               THEN p_amount_cents % total_count
               ELSE 0
          END AS share
    FROM (
      SELECT member_id,
             ord_position,
             ROW_NUMBER() OVER (ORDER BY ord_position) AS row_number,
             COUNT(*) OVER () AS total_count
      FROM (
        -- Deduplicate member IDs while preserving original order
        SELECT member_id, ord_position
        FROM (
          SELECT raw.member_id,
                 raw.ord_position,
                 ROW_NUMBER() OVER (
                   PARTITION BY raw.member_id
                   ORDER BY raw.ord_position
                 ) AS dup_rank
          FROM unnest(p_member_ids)
            WITH ORDINALITY AS raw(member_id, ord_position)
          WHERE raw.member_id IS NOT NULL
        ) filtered
        WHERE dup_rank = 1
      ) deduped
    ) ordered;

  ELSIF p_split_mode = 'custom' THEN
    IF p_splits IS NULL OR jsonb_typeof(p_splits) <> 'array' THEN
      PERFORM public.api_error(
        'INVALID_SPLIT',
        'p_splits must be a JSON array.',
        '22023'
      );
    END IF;

    INSERT INTO pg_temp.expense_split_buffer (debtor_user_id, amount_cents)
    SELECT user_id, amount_cents
    FROM jsonb_to_recordset(p_splits) AS x(user_id uuid, amount_cents bigint);
  ELSE
    PERFORM public.api_error('INVALID_SPLIT', 'Unknown split type.', '22023');
  END IF;

  -- Validations
  SELECT COUNT(*) INTO v_split_count
  FROM pg_temp.expense_split_buffer;

  IF v_split_count < 2 THEN
    PERFORM public.api_error(
      'SPLIT_MEMBERS_REQUIRED',
      'Include at least two members in the split.',
      '22023'
    );
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_temp.expense_split_buffer
    WHERE debtor_user_id IS NULL
       OR amount_cents   IS NULL
       OR amount_cents  <= 0
  ) THEN
    PERFORM public.api_error(
      'INVALID_DEBTOR',
      'Each split requires a member and positive amount.',
      '22023'
    );
  END IF;

  -- Each debtor appears only once
  SELECT COUNT(DISTINCT debtor_user_id)
  INTO v_member_count
  FROM pg_temp.expense_split_buffer;

  IF v_member_count <> v_split_count THEN
    PERFORM public.api_error(
      'INVALID_DEBTOR',
      'Each debtor must appear only once.',
      '22023'
    );
  END IF;

  -- Sum must match for custom
  SELECT SUM(amount_cents)
  INTO v_split_sum
  FROM pg_temp.expense_split_buffer;

  IF p_split_mode = 'custom' AND v_split_sum <> p_amount_cents THEN
    PERFORM public.api_error(
      'SPLIT_SUM_MISMATCH',
      'Custom splits must add up to the total amount.',
      '22023',
      jsonb_build_object('amount', p_amount_cents, 'splitSum', v_split_sum)
    );
  END IF;

  -- At least one non-creator debtor must be present for activated expenses
  SELECT COUNT(*)
  INTO v_non_creator_members
  FROM pg_temp.expense_split_buffer
  WHERE debtor_user_id <> p_creator_id;

  IF v_non_creator_members = 0 THEN
    PERFORM public.api_error(
      'SPLIT_MEMBERS_REQUIRED',
      'Include at least one other member in the split.',
      '22023'
    );
  END IF;

  -- All debtors must be active members of this home
  SELECT COUNT(*)
  INTO v_member_count
  FROM pg_temp.expense_split_buffer s
  JOIN public.memberships m
    ON m.home_id    = p_home_id
   AND m.user_id    = s.debtor_user_id
   AND m.is_current = TRUE;

  IF v_member_count <> v_split_count THEN
    PERFORM public.api_error(
      'INVALID_DEBTOR',
      'All debtors must be active members of this home.',
      '42501'
    );
  END IF;
END;
$$;


ALTER FUNCTION "public"."_expenses_prepare_split_buffer"("p_home_id" "uuid", "p_creator_id" "uuid", "p_amount_cents" bigint, "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_gen_invite_code"() RETURNS "public"."citext"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
DECLARE
  alphabet text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  out_code text := '';
  i int; idx int;
BEGIN
  FOR i IN 1..6 LOOP
    idx := 1 + floor(random() * length(alphabet))::int;
    out_code := out_code || substr(alphabet, idx, 1);
  END LOOP;
  RETURN out_code::public.citext; -- schema-qualify the type too
END;
$$;


ALTER FUNCTION "public"."_gen_invite_code"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_gen_unique_username"("p_email" "text", "p_id" "uuid") RETURNS "public"."citext"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $_$
DECLARE
  base       public.citext;
  candidate  public.citext;
  n          int := 0;
  max_tries  int := 100000;
  prefix_len int;
BEGIN
  -- derive from email local-part (DOT-LESS); fallback to id
  base := lower(
            coalesce(
              nullif(replace(split_part(p_email, '@', 1), '.', ''), ''),
              'user_' || substr(p_id::text, 1, 8)
            )
          );

  -- keep only [a-z0-9._], trim edges
  base := regexp_replace(base, '[^a-z0-9._]', '', 'g');
  base := regexp_replace(base, '^[._]+|[._]+$', '', 'g');

  -- (optional) collapse repeated separators: '..' or '__' -> '_'
  base := regexp_replace(base, '[._]{2,}', '_', 'g');

  -- ensure min length 3 (fallback to uuid prefix)
  IF length(base) < 3 THEN
    base := 'user' || substr(p_id::text, 1, 8);
  END IF;

  -- cap to 30 (we’ll shorten further if we add suffix)
  base := left(base, 30);

  -- serialize attempts per-base (reduces races)
  PERFORM pg_try_advisory_xact_lock(hashtextextended(base::text, 0));

  -- try base, then base_1, base_2, ... (keep total <= 30)
  LOOP
    IF n = 0 THEN
      candidate := base;
    ELSE
      -- room for '_' + n
      prefix_len := greatest(1, 30 - 1 - length(n::text));
      candidate  := left(base, prefix_len) || '_' || n::text;
    END IF;

    -- must match the CHECK regex: start/end alnum
    IF candidate ~ '^[a-z0-9](?:[a-z0-9._]{1,28})[a-z0-9]$' THEN
      -- skip if reserved
      IF NOT EXISTS (
           SELECT 1 FROM public.reserved_usernames r
           WHERE r.name = candidate
         )
      THEN
        -- unique test (case-insensitive due to citext + unique index)
        PERFORM 1 FROM public.profiles WHERE username = candidate;
        IF NOT FOUND THEN
          RETURN candidate;
        END IF;
      END IF;
    END IF;

    n := n + 1;
    IF n > max_tries THEN
      RAISE EXCEPTION 'Could not generate unique username after % attempts (base=%)', max_tries, base;
    END IF;
  END LOOP;
END
$_$;


ALTER FUNCTION "public"."_gen_unique_username"("p_email" "text", "p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_home_assert_quota"("p_home_id" "uuid", "p_deltas" "jsonb") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_plan         text;
  v_is_premium   boolean;
  v_counters     public.home_usage_counters%ROWTYPE;

  v_metric_key   text;
  v_metric_enum  public.home_usage_metric;
  v_raw_value    jsonb;
  v_delta        integer;
  v_current      integer;
  v_new          integer;
  v_max          integer;
BEGIN
  --------------------------------------------------------------------
  -- 1) Determine plan (defaults to 'free' if missing)
  --------------------------------------------------------------------
  v_plan := public._home_effective_plan(p_home_id);

  --------------------------------------------------------------------
  -- 2) Premium homes skip all quota checks
  --------------------------------------------------------------------
  v_is_premium := public._home_is_premium(p_home_id);
  IF v_is_premium THEN
    RETURN;
  END IF;

  --------------------------------------------------------------------
  -- 3) No deltas → nothing to check
  --------------------------------------------------------------------
  IF p_deltas IS NULL OR jsonb_typeof(p_deltas) <> 'object' THEN
    RETURN;
  END IF;

  --------------------------------------------------------------------
  -- 4) Load counters row (may be NULL if not created yet)
  --------------------------------------------------------------------
  SELECT *
  INTO v_counters
  FROM public.home_usage_counters
  WHERE home_id = p_home_id;

  IF NOT FOUND THEN
    v_counters.active_chores  := 0;
    v_counters.chore_photos   := 0;
    v_counters.active_members := 0;
  END IF;

  --------------------------------------------------------------------
  -- 5) For each key:value in p_deltas, perform plan checks
  --------------------------------------------------------------------
  FOR v_metric_key, v_raw_value IN
    SELECT key, value
    FROM jsonb_each(p_deltas)
  LOOP
    ------------------------------------------------------------------
    -- 5a) Map JSON key → enum, ignore unknown metrics
    ------------------------------------------------------------------
    BEGIN
      v_metric_enum := v_metric_key::public.home_usage_metric;
    EXCEPTION WHEN invalid_text_representation THEN
      CONTINUE; -- unknown metric, ignore for quota
    END;

    ------------------------------------------------------------------
    -- 5b) Ensure numeric delta
    ------------------------------------------------------------------
    IF jsonb_typeof(v_raw_value) <> 'number' THEN
      PERFORM public.api_error(
        'INVALID_QUOTA_DELTA',
        'Quota delta must be numeric.',
        '22023',
        jsonb_build_object('metric', v_metric_key, 'value', v_raw_value)
      );
    END IF;

    v_delta := (v_raw_value #>> '{}')::integer;

    -- Ignore zero or negative deltas (quota only cares about increases)
    IF COALESCE(v_delta, 0) <= 0 THEN
      CONTINUE;
    END IF;

    ------------------------------------------------------------------
    -- 5c) Look up per-plan limit. Missing → unlimited
    ------------------------------------------------------------------
    SELECT max_value
    INTO v_max
    FROM public.home_plan_limits
    WHERE plan   = v_plan
      AND metric = v_metric_enum;

    IF v_max IS NULL THEN
      CONTINUE;  -- unlimited for this metric on this plan
    END IF;

    ------------------------------------------------------------------
    -- 5d) Map metric → current counter
    ------------------------------------------------------------------
    v_current := CASE v_metric_enum
      WHEN 'active_chores'  THEN COALESCE(v_counters.active_chores, 0)
      WHEN 'chore_photos'   THEN COALESCE(v_counters.chore_photos, 0)
      WHEN 'active_members' THEN COALESCE(v_counters.active_members, 0)
    END;

    v_new := GREATEST(0, v_current + v_delta);

    ------------------------------------------------------------------
    -- 5e) Enforce limit
    ------------------------------------------------------------------
    IF v_new > v_max THEN
      PERFORM public.api_error(
        'PAYWALL_LIMIT_' || upper(v_metric_key),
        format(
          'Free plan allows up to %s %s per home.',
          v_max,
          v_metric_key
        ),
        'P0001',
        jsonb_build_object(
          'limit_type', v_metric_key,
          'plan',       v_plan,
          'max',        v_max,
          'current',    v_current,
          'projected',  v_new
        )
      );
    END IF;
  END LOOP;

END;
$$;


ALTER FUNCTION "public"."_home_assert_quota"("p_home_id" "uuid", "p_deltas" "jsonb") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."_home_assert_quota"("p_home_id" "uuid", "p_deltas" "jsonb") IS 'Generic quota enforcement: checks deltas against per-plan limits in home_plan_limits and raises api_error when exceeding quotas.';



CREATE OR REPLACE FUNCTION "public"."_home_attach_subscription_to_home"("_user_id" "uuid", "_home_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
  -- Attach the user's live subscription (if any) that is currently unattached
  UPDATE public.user_subscriptions
  SET home_id    = _home_id,
      updated_at = now()
  WHERE user_id = _user_id
    AND home_id IS NULL
    AND status IN ('active', 'cancelled');

  -- We rely on the trigger to call home_entitlements_refresh(_home_id)
END;
$$;


ALTER FUNCTION "public"."_home_attach_subscription_to_home"("_user_id" "uuid", "_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_home_detach_subscription_to_home"("_home_id" "uuid", "_user_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
  UPDATE public.user_subscriptions
  SET home_id    = NULL,
      updated_at = now()
  WHERE user_id = _user_id
    AND home_id = _home_id
    AND status IN ('active', 'cancelled');

  -- trigger on user_subscriptions will call home_entitlements_refresh(v_home_id)
END;
$$;


ALTER FUNCTION "public"."_home_detach_subscription_to_home"("_home_id" "uuid", "_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_home_effective_plan"("p_home_id" "uuid") RETURNS "text"
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  SELECT COALESCE(
    (
      SELECT he.plan
      FROM public.home_entitlements he
      WHERE he.home_id = p_home_id
        AND (he.expires_at IS NULL OR he.expires_at > now())
      ORDER BY he.expires_at NULLS LAST, he.created_at DESC
      LIMIT 1
    ),
    'free'
  );
$$;


ALTER FUNCTION "public"."_home_effective_plan"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."_home_is_premium"("p_home_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  SELECT COALESCE(
    (
      SELECT plan = 'premium'
             AND (expires_at IS NULL OR expires_at > now())
      FROM public.home_entitlements
      WHERE home_id = p_home_id
    ),
    FALSE
  );
$$;


ALTER FUNCTION "public"."_home_is_premium"("p_home_id" "uuid") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."home_usage_counters" (
    "home_id" "uuid" NOT NULL,
    "active_chores" integer DEFAULT 0 NOT NULL,
    "chore_photos" integer DEFAULT 0 NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "active_members" integer DEFAULT 0 NOT NULL,
    CONSTRAINT "home_usage_counters_active_chores_check" CHECK (("active_chores" >= 0)),
    CONSTRAINT "home_usage_counters_active_members_check" CHECK (("active_members" >= 0)),
    CONSTRAINT "home_usage_counters_chore_photos_check" CHECK (("chore_photos" >= 0))
);


ALTER TABLE "public"."home_usage_counters" OWNER TO "postgres";


COMMENT ON TABLE "public"."home_usage_counters" IS 'Cached usage counters (active chores, expectation photos) for paywall checks.';



COMMENT ON COLUMN "public"."home_usage_counters"."active_chores" IS 'Non-cancelled chores that still count versus the free quota (e.g. completed recurring + scheduled/assigned, one-off completed removed).';



COMMENT ON COLUMN "public"."home_usage_counters"."chore_photos" IS 'Number of chores with expectation photos.';



COMMENT ON COLUMN "public"."home_usage_counters"."active_members" IS 'Number of current/active members in the home (owner + members).';



CREATE OR REPLACE FUNCTION "public"."_home_usage_apply_delta"("p_home_id" "uuid", "p_deltas" "jsonb") RETURNS "public"."home_usage_counters"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_row                 public.home_usage_counters;
  v_active_chores_delta integer := 0;
  v_chore_photos_delta  integer := 0;
  v_active_members_delta integer := 0;
BEGIN
  --------------------------------------------------------------------
  -- Ensure a row exists
  --------------------------------------------------------------------
  INSERT INTO public.home_usage_counters (home_id)
  VALUES (p_home_id)
  ON CONFLICT (home_id) DO NOTHING;

  --------------------------------------------------------------------
  -- Extract numeric deltas robustly (ignore non-numeric)
  --------------------------------------------------------------------
  IF p_deltas IS NOT NULL AND jsonb_typeof(p_deltas) = 'object' THEN
    IF jsonb_typeof(p_deltas->'active_chores') = 'number' THEN
      v_active_chores_delta := (p_deltas->>'active_chores')::integer;
    END IF;

    IF jsonb_typeof(p_deltas->'chore_photos') = 'number' THEN
      v_chore_photos_delta := (p_deltas->>'chore_photos')::integer;
    END IF;

    IF jsonb_typeof(p_deltas->'active_members') = 'number' THEN
      v_active_members_delta := (p_deltas->>'active_members')::integer;
    END IF;
  END IF;

  --------------------------------------------------------------------
  -- Apply each metric delta (extend as you add features)
  --------------------------------------------------------------------
  UPDATE public.home_usage_counters h
  SET
    active_chores = GREATEST(
      0,
      COALESCE(h.active_chores, 0) + v_active_chores_delta
    ),
    chore_photos = GREATEST(
      0,
      COALESCE(h.chore_photos, 0) + v_chore_photos_delta
    ),
    active_members = GREATEST(
      0,
      COALESCE(h.active_members, 0) + v_active_members_delta
    ),
    -- Add new quota metrics later, e.g.:
    -- polls_created = GREATEST(0, COALESCE(h.polls_created, 0) + v_polls_created_delta),
    -- ai_tasks_used = GREATEST(0, COALESCE(h.ai_tasks_used, 0) + v_ai_tasks_used_delta),
    updated_at = now()
  WHERE h.home_id = p_home_id
  RETURNING * INTO v_row;

  RETURN v_row;
END;
$$;


ALTER FUNCTION "public"."_home_usage_apply_delta"("p_home_id" "uuid", "p_deltas" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."api_assert"("p_condition" boolean, "p_code" "text", "p_msg" "text", "p_sqlstate" "text" DEFAULT 'P0001'::"text", "p_details" "jsonb" DEFAULT NULL::"jsonb", "p_hint" "text" DEFAULT NULL::"text") RETURNS "void"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
BEGIN
  IF NOT coalesce(p_condition, false) THEN
    PERFORM public.api_error(p_code, p_msg, p_sqlstate, p_details, p_hint);
  END IF;
END;
$$;


ALTER FUNCTION "public"."api_assert"("p_condition" boolean, "p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."api_error"("p_code" "text", "p_msg" "text", "p_sqlstate" "text" DEFAULT 'P0001'::"text", "p_details" "jsonb" DEFAULT NULL::"jsonb", "p_hint" "text" DEFAULT NULL::"text") RETURNS "void"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
DECLARE
  v_message text;
  v_detail  text;
BEGIN
  -- Build a structured JSON error message.
  v_message := pg_catalog.json_build_object(
    'code',    p_code,
    'message', p_msg,
    'details', COALESCE(p_details, '{}'::jsonb)
  )::text;

  -- DETAIL should never be NULL in RAISE ... USING
  v_detail := COALESCE(p_details::text, '');

  RAISE EXCEPTION USING
    MESSAGE = COALESCE(v_message, 'Unknown error'),
    ERRCODE = COALESCE(p_sqlstate, 'P0001'),
    DETAIL  = v_detail,
    HINT    = COALESCE(p_hint, '');
END;
$$;


ALTER FUNCTION "public"."api_error"("p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."avatars_list_for_home"("p_home_id" "uuid") RETURNS TABLE("id" "uuid", "storage_path" "text", "category" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_plan        text;
  v_self_user   uuid;
  v_self_avatar uuid;
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);

  v_self_user := auth.uid();

  -- current user's avatar (so we can still show it even if "in use")
  SELECT p.avatar_id
  INTO v_self_avatar
  FROM public.profiles p
  WHERE p.id = v_self_user
    AND p.deactivated_at IS NULL;

  -- ✅ Use shared helper for effective plan
  v_plan := public._home_effective_plan(p_home_id);

  IF v_plan IS NULL THEN
    v_plan := 'free';
  END IF;

  -- Avatars already used by *other* current members in this home
  RETURN QUERY
    WITH used_by_others AS (
      SELECT DISTINCT p.avatar_id
      FROM public.memberships m
      JOIN public.profiles p
        ON p.id = m.user_id
      WHERE m.home_id = p_home_id
        AND m.is_current = TRUE
        AND p.deactivated_at IS NULL
        AND p.id <> v_self_user
    )
    SELECT
      a.id,
      a.storage_path,
      a.category
    FROM public.avatars a
    LEFT JOIN used_by_others u
      ON u.avatar_id = a.id
    WHERE
      (
        -- plan gating
        v_plan <> 'free'
        OR (v_plan = 'free' AND a.category = 'animal')
      )
      AND (
        u.avatar_id IS NULL           -- not used by others
        OR a.id = v_self_avatar       -- always allow my current avatar
      )
    ORDER BY
      a.created_at ASC;
END;
$$;


ALTER FUNCTION "public"."avatars_list_for_home"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."check_app_version"("client_version" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql" STABLE STRICT SECURITY DEFINER
    SET "search_path" TO ''
    AS $_$
DECLARE
  v_in text := btrim(client_version);
  cv_major int;
  cv_minor int;
  cv_patch int;

  v record;
  hard_block boolean;
BEGIN
  IF v_in !~ '^\d+\.\d+\.\d+$' THEN
    RAISE EXCEPTION 'client_version must be "x.y.z" (digits only)'
      USING ERRCODE = '22023';
  END IF;

  -- safe to parse now
  cv_major := split_part(v_in, '.', 1)::int;
  cv_minor := split_part(v_in, '.', 2)::int;
  cv_patch := split_part(v_in, '.', 3)::int;

  SELECT version_number, min_supported_version, release_date, notes
    INTO v
    FROM public.app_version
   WHERE is_current IS TRUE
   LIMIT 1;

  IF v IS NULL THEN
    RETURN jsonb_build_object(
      'hardBlocked', false,
      'updateRecommended', false,
      'message', 'No server version configured'
    );
  END IF;

  hard_block :=
    (cv_major, cv_minor, cv_patch) <
    (split_part(v.min_supported_version,'.',1)::int,
     split_part(v.min_supported_version,'.',2)::int,
     split_part(v.min_supported_version,'.',3)::int);

  RETURN jsonb_build_object(
    'clientVersion',       v_in,
    'currentVersion',      v.version_number,
    'minSupportedVersion', v.min_supported_version,
    'hardBlocked',         hard_block,
    'updateRecommended',   (NOT hard_block) AND (
      (cv_major, cv_minor, cv_patch) <
      (split_part(v.version_number,'.',1)::int,
       split_part(v.version_number,'.',2)::int,
       split_part(v.version_number,'.',3)::int)
    ),
    'notes',               v.notes,
    'releasedAt',          v.release_date
  );
END;
$_$;


ALTER FUNCTION "public"."check_app_version"("client_version" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."chore_complete"("_chore_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_chore          public.chores%ROWTYPE;
  v_new_next_date  date;
  v_new_cursor     timestamptz;
  v_prev_next      date;
  v_steps_advanced integer := 0;
  v_user           uuid := auth.uid();  
BEGIN
  -- Ensure caller is authenticated
  PERFORM public._assert_authenticated();

  -- Lock the chore row so two clients can't complete at once
  SELECT *
  INTO v_chore
  FROM public.chores
  WHERE id = _chore_id
  FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'CHORE_NOT_FOUND',
      'Chore not found or not accessible.',
      'P0002',
      jsonb_build_object('chore_id', _chore_id)
    );
  END IF;

  -- Must belong to the same home (and user must be is_current)
  PERFORM public._assert_home_member(v_chore.home_id);

  -- Only current assignee can complete
  PERFORM public.api_assert(
    v_chore.assignee_user_id = v_user,
    'FORBIDDEN',
    'Only the current assignee can complete this chore.',
    '42501',
    jsonb_build_object('chore_id', _chore_id)
  );

  -- Optional: sanity guard on state
  PERFORM public.api_assert(
    v_chore.state = 'active',
    'INVALID_STATE',
    'Only active chores can be completed.',
    '22023',
    jsonb_build_object('chore_id', _chore_id, 'state', v_chore.state)
  );

  v_prev_next := v_chore.next_occurrence;

  -------------------------------------------------------------------
  -- Case 1: non-recurring chore → mark completed once and for all
  -------------------------------------------------------------------
  IF v_chore.recurrence = 'none' THEN
    UPDATE public.chores
    SET
      state           = 'completed',
      completed_at    = COALESCE(v_chore.completed_at, now()),
      next_occurrence = NULL,
      updated_at      = now()
    WHERE id = _chore_id;

    -- Decrement active counter
    PERFORM public._home_usage_apply_delta(
      v_chore.home_id,
      jsonb_build_object('active_chores', -1)
    );

    RETURN jsonb_build_object(
      'status',   'non_recurring_completed',
      'chore_id', _chore_id,
      'home_id',  v_chore.home_id,
      'state',    'completed'
    );
  END IF;

  -------------------------------------------------------------------
  -- Case 2: recurring chore → advance to first date AFTER today
  -------------------------------------------------------------------
  v_new_next_date := COALESCE(v_chore.next_occurrence, v_chore.start_date);
  v_new_cursor    := COALESCE(v_chore.recurrence_cursor, v_new_next_date::timestamptz);

  WHILE v_new_next_date <= current_date LOOP
    CASE v_chore.recurrence
      WHEN 'daily'          THEN v_new_next_date := v_new_next_date + INTERVAL '1 day';
      WHEN 'weekly'         THEN v_new_next_date := v_new_next_date + INTERVAL '7 days';
      WHEN 'every_2_weeks'  THEN v_new_next_date := v_new_next_date + INTERVAL '14 days';
      WHEN 'monthly'        THEN v_new_next_date := (v_new_next_date + INTERVAL '1 month')::date;
      WHEN 'every_2_months' THEN v_new_next_date := (v_new_next_date + INTERVAL '2 months')::date;
      WHEN 'annual'         THEN v_new_next_date := (v_new_next_date + INTERVAL '1 year')::date;
      ELSE
        EXIT;
    END CASE;

    v_new_cursor     := v_new_next_date::timestamptz;
    v_steps_advanced := v_steps_advanced + 1;
  END LOOP;

  -- If nothing moved forward, next_occurrence was already in the future
  IF v_steps_advanced = 0 THEN
    RETURN jsonb_build_object(
      'status',   'already_completed_for_cycle',
      'chore_id', _chore_id,
      'home_id',  v_chore.home_id,
      'state',    v_chore.state
    );
  END IF;

  UPDATE public.chores
  SET
    recurrence_cursor = v_new_cursor,
    next_occurrence   = v_new_next_date,
    completed_at      = now(),
    updated_at        = now()
  WHERE id = _chore_id;

  RETURN jsonb_build_object(
    'status',                   'recurring_completed',
    'chore_id',                 _chore_id,
    'home_id',                  v_chore.home_id,
    'recurrence',               v_chore.recurrence,
    'state',                    v_chore.state,
    'previous_next_occurrence', v_prev_next,
    'new_next_occurrence',      v_new_next_date,
    'steps_advanced',           v_steps_advanced
  );
END;
$$;


ALTER FUNCTION "public"."chore_complete"("_chore_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."chores_cancel"("p_chore_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user  uuid := auth.uid();
  v_chore public.chores;
BEGIN
  PERFORM public._assert_authenticated();

  -- Lock the chore row
  SELECT *
    INTO v_chore
    FROM public.chores
   WHERE id = p_chore_id
   FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'Chore not found.',
      'P0002',
      jsonb_build_object('chore_id', p_chore_id)
    );
  END IF;

  -- Must belong to this home
  PERFORM public._assert_home_member(v_chore.home_id);

  -- Only creator or current assignee can cancel
  PERFORM public.api_assert(
    v_chore.created_by_user_id = v_user
    OR v_chore.assignee_user_id = v_user,
    'FORBIDDEN',
    'Only the chore creator or current assignee can cancel.',
    '42501',
    jsonb_build_object('chore_id', p_chore_id)
  );

  -- Only draft/active chores can be cancelled
  PERFORM public.api_assert(
    v_chore.state IN ('draft', 'active'),
    'ALREADY_FINALIZED',
    'Only draft/active chores can be cancelled.',
    '22023'
  );

  -- Transition to cancelled
  UPDATE public.chores
     SET state            = 'cancelled',
         next_occurrence  = NULL,
         recurrence       = 'none',
         recurrence_cursor= NULL,
         updated_at       = now()
   WHERE id = p_chore_id
   RETURNING * INTO v_chore;

  -- Decrement active_chores by 1 (clamped at 0 in the helper)
  PERFORM public._home_usage_apply_delta(
    v_chore.home_id,
    jsonb_build_object('active_chores', -1)
  );

  RETURN jsonb_build_object('chore', to_jsonb(v_chore));
END;
$$;


ALTER FUNCTION "public"."chores_cancel"("p_chore_id" "uuid") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chores" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "home_id" "uuid" NOT NULL,
    "created_by_user_id" "uuid" NOT NULL,
    "assignee_user_id" "uuid",
    "name" "text" NOT NULL,
    "start_date" "date" DEFAULT CURRENT_DATE NOT NULL,
    "recurrence" "public"."recurrence_interval" DEFAULT 'none'::"public"."recurrence_interval" NOT NULL,
    "recurrence_cursor" timestamp with time zone,
    "next_occurrence" "date",
    "expectation_photo_path" "text",
    "how_to_video_url" "text",
    "notes" "text",
    "completed_at" timestamp with time zone,
    "state" "public"."chore_state" DEFAULT 'draft'::"public"."chore_state" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_chore_active_has_assignee" CHECK ((("state" <> 'active'::"public"."chore_state") OR ("assignee_user_id" IS NOT NULL))),
    CONSTRAINT "chk_chore_draft_without_assignee" CHECK ((("state" <> 'draft'::"public"."chore_state") OR ("assignee_user_id" IS NULL))),
    CONSTRAINT "chk_chore_expectation_path" CHECK ((("expectation_photo_path" IS NULL) OR (("expectation_photo_path" !~ '^[A-Za-z][A-Za-z0-9+.-]*://'::"text") AND ("expectation_photo_path" ~ '^flow/[a-z0-9_-]+/[A-Za-z0-9_./-]+$'::"text")))),
    CONSTRAINT "chk_chore_name_length" CHECK ((("char_length"("btrim"("name")) >= 1) AND ("char_length"("btrim"("name")) <= 140))),
    CONSTRAINT "chores_how_to_video_url_scheme" CHECK ((("how_to_video_url" IS NULL) OR ("how_to_video_url" ~* '^https?://'::"text")))
);


ALTER TABLE "public"."chores" OWNER TO "postgres";


COMMENT ON TABLE "public"."chores" IS 'Household chores authored within a home. Single-assignee, optional recurrence.';



COMMENT ON COLUMN "public"."chores"."home_id" IS 'FK to homes.id. Chore belongs to this home.';



COMMENT ON COLUMN "public"."chores"."created_by_user_id" IS 'Author of the chore.';



COMMENT ON COLUMN "public"."chores"."assignee_user_id" IS 'Responsible user when state=active.';



COMMENT ON COLUMN "public"."chores"."start_date" IS 'Initial due date.';



COMMENT ON COLUMN "public"."chores"."recurrence" IS 'none|daily|weekly|every_2_weeks|monthly|every_2_months|annual';



COMMENT ON COLUMN "public"."chores"."recurrence_cursor" IS 'Anchor timestamptz for recurrence.';



COMMENT ON COLUMN "public"."chores"."next_occurrence" IS 'Next actionable due date.';



COMMENT ON COLUMN "public"."chores"."expectation_photo_path" IS 'Supabase Storage object path (no bucket/host) for chore photos.';



COMMENT ON COLUMN "public"."chores"."completed_at" IS 'Time when first marked completed.';



COMMENT ON COLUMN "public"."chores"."state" IS 'draft|active|completed|cancelled.';



CREATE OR REPLACE FUNCTION "public"."chores_create"("p_home_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid" DEFAULT NULL::"uuid", "p_start_date" "date" DEFAULT CURRENT_DATE, "p_recurrence" "public"."recurrence_interval" DEFAULT 'none'::"public"."recurrence_interval", "p_how_to_video_url" "text" DEFAULT NULL::"text", "p_notes" "text" DEFAULT NULL::"text", "p_expectation_photo_path" "text" DEFAULT NULL::"text") RETURNS "public"."chores"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id      uuid := auth.uid();
  v_state        public.chore_state;
  v_usage_delta  integer := 1;  -- every new chore counts as +1
  v_photo_delta  integer := 0;  -- will be 1 if we create with a photo
  v_row          public.chores;
BEGIN
  PERFORM public._assert_authenticated();

  -- Ensure caller actually belongs to this home (and is_current)
  PERFORM public._assert_home_member(p_home_id);

  -- Validate required name
  IF COALESCE(btrim(p_name), '') = '' THEN
    PERFORM public.api_error(
      'INVALID_INPUT',
      'Chore name is required.',
      '22023',
      jsonb_build_object('field', 'name')
    );
  END IF;

  -- If assignee is provided, enforce they are a current member of this home
  IF p_assignee_user_id IS NOT NULL THEN
    PERFORM public.api_assert(
      EXISTS (
        SELECT 1
        FROM public.memberships m
        WHERE m.home_id = p_home_id
          AND m.user_id = p_assignee_user_id
          AND m.is_current
      ),
      'ASSIGNEE_NOT_CURRENT_MEMBER',
      'Assignee must be a current member of this home.',
      '42501',
      jsonb_build_object(
        'home_id',   p_home_id,
        'assignee',  p_assignee_user_id
      )
    );
    v_state := 'active';
  ELSE
    v_state := 'draft';
  END IF;

  -- Compute photo delta: only if we are creating with a photo
  IF p_expectation_photo_path IS NOT NULL THEN
    v_photo_delta := 1;
  END IF;

  -- Paywall check at SAVE time (quota helper)
  PERFORM public._home_assert_quota(
    p_home_id,
    jsonb_strip_nulls(
      jsonb_build_object(
        'active_chores', v_usage_delta,  -- +1 chore
        'chore_photos',  v_photo_delta   -- +1 photo if present
      )
    )
  );

  -- Insert chore
  INSERT INTO public.chores (
    home_id,
    created_by_user_id,
    assignee_user_id,
    name,
    start_date,
    recurrence,
    how_to_video_url,
    notes,
    expectation_photo_path,
    state
  )
  VALUES (
    p_home_id,
    v_user_id,
    p_assignee_user_id,
    p_name,
    COALESCE(p_start_date, current_date),
    COALESCE(p_recurrence, 'none'),
    p_how_to_video_url,
    p_notes,
    p_expectation_photo_path,
    v_state
  )
  RETURNING * INTO v_row;

  -- Update usage counters via JSON-based helper
  PERFORM public._home_usage_apply_delta(
    p_home_id,
    jsonb_strip_nulls(
      jsonb_build_object(
        'active_chores', v_usage_delta,
        'chore_photos',  v_photo_delta
      )
    )
  );

  RETURN v_row;
END;
$$;


ALTER FUNCTION "public"."chores_create"("p_home_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_how_to_video_url" "text", "p_notes" "text", "p_expectation_photo_path" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."chores_events_trigger"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_actor       uuid := auth.uid();
  v_event_type  public.chore_event_type;
  v_from_state  public.chore_state;
  v_to_state    public.chore_state;
  v_payload     jsonb := '{}'::jsonb;
BEGIN
  -- Require auth (or relax this if you have backend jobs without auth)
  PERFORM public._assert_authenticated();

  IF TG_OP = 'INSERT' THEN
    -- New chore created
    v_event_type := 'create';
    v_to_state   := NEW.state;

    v_payload := jsonb_build_object(
      'name',              NEW.name,
      'recurrence',        NEW.recurrence,
      'next_occurrence',   NEW.next_occurrence,
      'assignee_user_id',  NEW.assignee_user_id
    );

    INSERT INTO public.chore_events (
      chore_id,
      home_id,
      actor_user_id,
      event_type,
      from_state,
      to_state,
      payload
    )
    VALUES (
      NEW.id,
      NEW.home_id,
      v_actor,
      v_event_type,
      NULL,
      v_to_state,
      v_payload
    );

    RETURN NEW;

  ELSIF TG_OP = 'UPDATE' THEN
    -- Short-circuit if nothing interesting changed
    IF OLD.assignee_user_id      IS NOT DISTINCT FROM NEW.assignee_user_id
       AND OLD.recurrence        IS NOT DISTINCT FROM NEW.recurrence
       AND OLD.recurrence_cursor IS NOT DISTINCT FROM NEW.recurrence_cursor
       AND OLD.next_occurrence   IS NOT DISTINCT FROM NEW.next_occurrence
       AND OLD.state             IS NOT DISTINCT FROM NEW.state THEN
      RETURN NEW;
    END IF;

    v_from_state := OLD.state;
    v_to_state   := NEW.state;

    ----------------------------------------------------------------
    -- Priority:
    -- 1) Recurring completion inferred from next_occurrence moving
    -- 2) Non-recurring completion via state change
    -- 3) Cancel (draft/active -> cancelled)
    -- 4) Activate (draft -> active)
    -- 5) Assignee change (update with assignee payload)
    -- 6) Recurrence config change (update)
    -- 7) Generic state change update
    ----------------------------------------------------------------

    -- 1️⃣ Recurring completion inferred from next_occurrence advancing
    IF NEW.recurrence <> 'none'
       AND OLD.next_occurrence IS NOT NULL
       AND NEW.next_occurrence IS NOT NULL
       AND NEW.next_occurrence > OLD.next_occurrence THEN

      v_event_type := 'complete';
      v_payload := jsonb_build_object(
        'recurrence',             NEW.recurrence,
        'completed_date',         OLD.next_occurrence,
        'next_occurrence_before', OLD.next_occurrence,
        'next_occurrence_after',  NEW.next_occurrence,
        'cursor_before',          OLD.recurrence_cursor,
        'cursor_after',           NEW.recurrence_cursor
      );

    -- 2️⃣ Non-recurring completion: state -> completed, recurrence = none
    ELSIF OLD.state <> 'completed'
          AND NEW.state = 'completed'
          AND NEW.recurrence = 'none' THEN

      v_event_type := 'complete';
      v_payload := jsonb_build_object(
        'completed_state_from', OLD.state,
        'completed_state_to',   NEW.state
      );

    -- 3️⃣ Cancel: draft/active -> cancelled
    ELSIF OLD.state IN ('draft', 'active')
          AND NEW.state = 'cancelled' THEN

      v_event_type := 'cancel';
      v_payload := jsonb_build_object(
        'state_from',             OLD.state,
        'state_to',               NEW.state,
        'reason',                 'cancelled',
        -- capture schedule so RPC is free to clear it
        'recurrence_before',      OLD.recurrence,
        'next_occurrence_before', OLD.next_occurrence,
        'cursor_before',          OLD.recurrence_cursor,
        'assignee_user_id',       OLD.assignee_user_id
      );

    -- 4️⃣ Activate: draft -> active
    ELSIF OLD.state = 'draft'
          AND NEW.state = 'active' THEN

      v_event_type := 'activate';
      v_payload := jsonb_build_object(
        'state_from', OLD.state,
        'state_to',   NEW.state
      );

    -- 5️⃣ Assignee changes (still event_type = 'update')
    ELSIF OLD.assignee_user_id IS DISTINCT FROM NEW.assignee_user_id THEN
      v_event_type := 'update';
      v_payload := jsonb_build_object(
        'change_type', 'assignee',
        'assignee_event',
          CASE
            WHEN OLD.assignee_user_id IS NULL AND NEW.assignee_user_id IS NOT NULL THEN 'assign'
            WHEN OLD.assignee_user_id IS NOT NULL AND NEW.assignee_user_id IS NULL THEN 'unassign'
            ELSE 'reassign'
          END,
        'assignee_from', OLD.assignee_user_id,
        'assignee_to',   NEW.assignee_user_id
      );

    -- 6️⃣ Recurrence config changed (e.g. weekly → every_2_weeks)
    ELSIF OLD.recurrence IS DISTINCT FROM NEW.recurrence THEN
      v_event_type := 'update';
      v_payload := jsonb_build_object(
        'recurrence_from', OLD.recurrence,
        'recurrence_to',   NEW.recurrence
      );

    -- 7️⃣ Fallback: some other meaningful state change
    ELSIF OLD.state IS DISTINCT FROM NEW.state THEN
      v_event_type := 'update';
      v_payload := jsonb_build_object(
        'state_from', OLD.state,
        'state_to',   NEW.state
      );

    ELSE
      -- If we got here, something changed we don't currently care to log
      RETURN NEW;
    END IF;

    INSERT INTO public.chore_events (
      chore_id,
      home_id,
      actor_user_id,
      event_type,
      from_state,
      to_state,
      payload
    )
    VALUES (
      NEW.id,
      NEW.home_id,
      v_actor,
      v_event_type,
      v_from_state,
      v_to_state,
      v_payload
    );

    RETURN NEW;

  ELSIF TG_OP = 'DELETE' THEN
    -- Physical delete: treat as cancel with reason=deleted
    v_event_type := 'cancel';
    v_from_state := OLD.state;

    v_payload := jsonb_build_object(
      'reason', 'deleted',
      'state',  OLD.state
    );

    INSERT INTO public.chore_events (
      chore_id,
      home_id,
      actor_user_id,
      event_type,
      from_state,
      to_state,
      payload
    )
    VALUES (
      OLD.id,
      OLD.home_id,
      v_actor,
      v_event_type,
      v_from_state,
      NULL,
      v_payload
    );

    RETURN OLD;
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."chores_events_trigger"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."chores_get_for_home"("p_home_id" "uuid", "p_chore_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_chore      jsonb;
  v_assignees  jsonb;
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);

  -- 1️⃣ Chore + current assignee (if any)
SELECT jsonb_build_object(
  'id', c.id,
  'home_id', c.home_id,
  'created_by_user_id', c.created_by_user_id,
  'assignee_user_id', c.assignee_user_id,
  'name', c.name,
  'start_date', c.start_date,
  'recurrence', c.recurrence,
  'recurrence_cursor', c.recurrence_cursor,
  'next_occurrence', c.next_occurrence,
  'expectation_photo_path', c.expectation_photo_path,
  'how_to_video_url', c.how_to_video_url,
  'notes', c.notes,
  'state', c.state,
  'completed_at', c.completed_at,
  'created_at', c.created_at,
  'updated_at', c.updated_at,
  'assignee',
    CASE WHEN c.assignee_user_id IS NULL THEN NULL
         ELSE jsonb_build_object(
           'id', pa.id,
           'full_name', pa.full_name,
           'avatar_storage_path', a.storage_path)
    END
)
INTO v_chore
FROM public.chores c
LEFT JOIN public.profiles pa ON pa.id = c.assignee_user_id
LEFT JOIN public.avatars a ON a.id = pa.avatar_id
WHERE c.home_id = p_home_id
  AND c.id = p_chore_id;

  IF v_chore IS NULL THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'Chore not found for this home.',
      '22023',
      jsonb_build_object('home_id', p_home_id, 'chore_id', p_chore_id)
    );
  END IF;

  -- 2️⃣ All potential assignees in this home (these *should* have avatars)
  SELECT COALESCE(
           jsonb_agg(
             jsonb_build_object(
               'user_id',             m.user_id,
               'full_name',           p.full_name,
               'avatar_storage_path', a.storage_path
             )
             ORDER BY p.full_name
           ),
           '[]'::jsonb
         )
  INTO v_assignees
  FROM public.memberships m            
  JOIN public.profiles p
    ON p.id = m.user_id
  JOIN public.avatars a
    ON a.id = p.avatar_id
    WHERE m.home_id = p_home_id
      AND m.is_current = TRUE;                -- or your "active" condition

  RETURN jsonb_build_object(
    'chore',     v_chore,
    'assignees', v_assignees
  );
END;
$$;


ALTER FUNCTION "public"."chores_get_for_home"("p_home_id" "uuid", "p_chore_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."chores_list_for_home"("p_home_id" "uuid") RETURNS TABLE("id" "uuid", "home_id" "uuid", "assignee_user_id" "uuid", "name" "text", "start_date" "date", "assignee_full_name" "text", "assignee_avatar_storage_path" "text")
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  SELECT
    id,
    home_id,
    assignee_user_id,
    name,
    current_due_date AS start_date,
    assignee_full_name,
    assignee_avatar_storage_path
  FROM public._chores_base_for_home(p_home_id)
  WHERE
    state IN ('draft', 'active')
    AND (
      -- active: any member (already enforced by _assert_home_member)
      state = 'active'::public.chore_state
      -- draft: only creator can see
      OR (state = 'draft'::public.chore_state
          AND created_by_user_id = auth.uid())
    )
  ORDER BY
    current_due_date DESC,
    created_at      DESC;
$$;


ALTER FUNCTION "public"."chores_list_for_home"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."chores_reassign_on_member_leave"("v_home_id" "uuid", "v_user_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_owner_user_id uuid;
BEGIN
  -- Find current owner of the home
  SELECT m.user_id
    INTO v_owner_user_id
  FROM public.memberships m
  WHERE m.home_id = v_home_id
    AND m.role = 'owner'
    AND m.is_current = TRUE
  LIMIT 1;

  -- If no owner (e.g., home deactivated), do nothing
  IF v_owner_user_id IS NULL THEN
    RETURN;
  END IF;

  -- Reassign active chores from leaving member to owner
  UPDATE public.chores c
     SET assignee_user_id = v_owner_user_id,
         updated_at       = now()
   WHERE c.home_id = v_home_id
     AND c.assignee_user_id = v_user_id
     AND c.state IN ('draft', 'active');

END;
$$;


ALTER FUNCTION "public"."chores_reassign_on_member_leave"("v_home_id" "uuid", "v_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."chores_update"("p_chore_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval" DEFAULT NULL::"public"."recurrence_interval", "p_expectation_photo_path" "text" DEFAULT NULL::"text", "p_how_to_video_url" "text" DEFAULT NULL::"text", "p_notes" "text" DEFAULT NULL::"text") RETURNS "public"."chores"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id      uuid := auth.uid();
  v_existing     public.chores;
  v_new          public.chores;
  v_new_path     text;
  v_photo_delta  integer := 0;
BEGIN
  PERFORM public._assert_authenticated();

  -- Enforce that assignee is provided
  IF p_assignee_user_id IS NULL THEN
    PERFORM public.api_error(
      'INVALID_INPUT',
      'Assignee is required when updating a chore.',
      '22023',
      jsonb_build_object('field', 'assignee_user_id')
    );
  END IF;

  -- Validate name
  IF COALESCE(btrim(p_name), '') = '' THEN
    PERFORM public.api_error(
      'INVALID_INPUT',
      'Chore name is required.',
      '22023',
      jsonb_build_object('field', 'name')
    );
  END IF;

  -- Load existing chore (and lock it)
  SELECT *
  INTO v_existing
  FROM public.chores
  WHERE id = p_chore_id
  FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'Chore not found.',
      'P0002',
      jsonb_build_object('chore_id', p_chore_id)
    );
  END IF;

  -- Ensure caller is an active member of this home
  PERFORM public._assert_home_member(v_existing.home_id);

  -- Enforce "only creator or assignee can edit"
  IF v_existing.created_by_user_id IS DISTINCT FROM v_user_id
     AND (
       v_existing.assignee_user_id IS NULL
       OR v_existing.assignee_user_id IS DISTINCT FROM v_user_id
     )
  THEN
    PERFORM public.api_error(
      'FORBIDDEN',
      'Only the chore creator or current assignee can update this chore.',
      '42501',
      jsonb_build_object(
        'chore_id', p_chore_id,
        'home_id',  v_existing.home_id
      )
    );
  END IF;

  -- Assignee must be a current member of this home
  PERFORM public.api_assert(
    EXISTS (
      SELECT 1
      FROM public.memberships m
      WHERE m.home_id = v_existing.home_id
        AND m.user_id = p_assignee_user_id
        AND m.is_current
    ),
    'ASSIGNEE_NOT_CURRENT_MEMBER',
    'Assignee must be a current member of this home.',
    '42501',
    jsonb_build_object(
      'home_id',  v_existing.home_id,
      'assignee', p_assignee_user_id
    )
  );

  -- Work out what the *new* path will be after COALESCE
  v_new_path := COALESCE(p_expectation_photo_path, v_existing.expectation_photo_path);

  -- Compute photo delta (per-chore slot semantics)
  IF v_existing.expectation_photo_path IS NULL AND v_new_path IS NOT NULL THEN
    v_photo_delta := 1;   -- adding first photo to this chore
  ELSIF v_existing.expectation_photo_path IS NOT NULL AND v_new_path IS NULL THEN
    v_photo_delta := -1;  -- removing the only photo from this chore
  ELSE
    v_photo_delta := 0;   -- no slot change
  END IF;

  -- Paywall check if we're *adding* a photo slot
  IF v_photo_delta > 0 THEN
    PERFORM public._home_assert_quota(
      v_existing.home_id,
      jsonb_build_object(
        'chore_photos', v_photo_delta
      )
    );
  END IF;

  -- Update chore
  UPDATE public.chores
  SET
    name                   = p_name,
    assignee_user_id       = p_assignee_user_id,
    start_date             = p_start_date,
    recurrence             = COALESCE(p_recurrence, v_existing.recurrence),
    expectation_photo_path = v_new_path,
    how_to_video_url       = COALESCE(p_how_to_video_url, v_existing.how_to_video_url),
    notes                  = COALESCE(p_notes, v_existing.notes),
    state                  = 'active',
    updated_at             = now()
  WHERE id = p_chore_id
  RETURNING * INTO v_new;

  -- Update usage counters if the slot changed
  IF v_photo_delta <> 0 THEN
    PERFORM public._home_usage_apply_delta(
      v_new.home_id,
      jsonb_build_object('chore_photos', v_photo_delta)
    );
  END IF;

  RETURN v_new;
END;
$$;


ALTER FUNCTION "public"."chores_update"("p_chore_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_expectation_photo_path" "text", "p_how_to_video_url" "text", "p_notes" "text") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."expenses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "home_id" "uuid" NOT NULL,
    "created_by_user_id" "uuid" NOT NULL,
    "status" "public"."expense_status" DEFAULT 'draft'::"public"."expense_status" NOT NULL,
    "split_type" "public"."expense_split_type",
    "amount_cents" bigint NOT NULL,
    "description" "text" NOT NULL,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_expenses_active_split_required" CHECK ((("status" <> 'active'::"public"."expense_status") OR ("split_type" IS NOT NULL))),
    CONSTRAINT "chk_expenses_amount_positive" CHECK (("amount_cents" > 0)),
    CONSTRAINT "chk_expenses_description_length" CHECK (("char_length"("btrim"("description")) <= 280)),
    CONSTRAINT "chk_expenses_notes_length" CHECK ((("notes" IS NULL) OR ("char_length"("notes") <= 2000)))
);


ALTER TABLE "public"."expenses" OWNER TO "postgres";


COMMENT ON TABLE "public"."expenses" IS 'Top-level shared expense created inside a home.';



COMMENT ON COLUMN "public"."expenses"."home_id" IS 'FK to public.homes.id.';



COMMENT ON COLUMN "public"."expenses"."created_by_user_id" IS 'Expense creator / payer.';



COMMENT ON COLUMN "public"."expenses"."status" IS 'draft|active|cancelled.';



COMMENT ON COLUMN "public"."expenses"."split_type" IS 'equal|custom|null (no split).';



COMMENT ON COLUMN "public"."expenses"."amount_cents" IS 'Total amount in integer cents.';



COMMENT ON COLUMN "public"."expenses"."description" IS 'Required description (<=280 chars).';



COMMENT ON COLUMN "public"."expenses"."notes" IS 'Optional notes for creator + viewers.';



CREATE OR REPLACE FUNCTION "public"."expenses_cancel"("p_expense_id" "uuid") RETURNS "public"."expenses"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user           uuid;
  v_expense        public.expenses%ROWTYPE;
  v_home_is_active boolean;
  v_has_paid       boolean := FALSE;
BEGIN
  -- Auth
  PERFORM public._assert_authenticated();
  v_user := auth.uid();

  -- Input validation
  IF p_expense_id IS NULL THEN
    PERFORM public.api_error(
      'INVALID_EXPENSE',
      'Expense id is required.',
      '22023'
    );
  END IF;

  -- Load and lock the expense
  SELECT *
  INTO v_expense
  FROM public.expenses e
  WHERE e.id = p_expense_id
  FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'Expense not found.',
      'P0002',
      jsonb_build_object('expenseId', p_expense_id)
    );
  END IF;

  -- Creator-only
  IF v_expense.created_by_user_id <> v_user THEN
    PERFORM public.api_error(
      'NOT_CREATOR',
      'Only the creator can cancel this expense.',
      '42501',
      jsonb_build_object('expenseId', p_expense_id, 'userId', v_user)
    );
  END IF;

  -- Idempotent: already cancelled? just return
  IF v_expense.status = 'cancelled' THEN
    RETURN v_expense;
  END IF;

  -- Only draft/active can be cancelled (you can tighten this if you add more statuses later)
  IF v_expense.status NOT IN ('draft', 'active') THEN
    PERFORM public.api_error(
      'INVALID_STATE',
      'Only draft or active expenses can be cancelled.',
      'P0003'
    );
  END IF;

  -- Membership + home state
  PERFORM 1
  FROM public.memberships m
  WHERE m.home_id    = v_expense.home_id
    AND m.user_id    = v_user
    AND m.is_current = TRUE
  LIMIT 1;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_HOME_MEMBER',
      'You are not a member of this home.',
      '42501',
      jsonb_build_object('homeId', v_expense.home_id)
    );
  END IF;

  SELECT h.is_active
  INTO v_home_is_active
  FROM public.homes h
  WHERE h.id = v_expense.home_id
  FOR UPDATE;

  IF v_home_is_active IS DISTINCT FROM TRUE THEN
    PERFORM public.api_error(
      'HOME_INACTIVE',
      'This home is no longer active.',
      'P0004'
    );
  END IF;

  -- Lock splits rowset to avoid races with mark_share_paid
  PERFORM 1
  FROM public.expense_splits s
  WHERE s.expense_id = v_expense.id
  FOR UPDATE;

  -- Check whether any share is already paid
  SELECT EXISTS (
    SELECT 1
    FROM public.expense_splits s
    WHERE s.expense_id = v_expense.id
      AND s.status     = 'paid'
      AND s.debtor_user_id <> v_expense.created_by_user_id
  )
  INTO v_has_paid;

  IF v_has_paid THEN
    PERFORM public.api_error(
      'EXPENSE_LOCKED_AFTER_PAYMENT',
      'Expenses with paid shares cannot be cancelled.',
      'P0004',
      jsonb_build_object('expenseId', p_expense_id)
    );
  END IF;

  -- Perform cancel: keep splits for audit, just change expense status
  UPDATE public.expenses
  SET status     = 'cancelled',
      updated_at = now()
  WHERE id = v_expense.id
  RETURNING * INTO v_expense;

  RETURN v_expense;
END;
$$;


ALTER FUNCTION "public"."expenses_cancel"("p_expense_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."expenses_create"("p_home_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text" DEFAULT NULL::"text", "p_split_mode" "public"."expense_split_type" DEFAULT NULL::"public"."expense_split_type", "p_member_ids" "uuid"[] DEFAULT NULL::"uuid"[], "p_splits" "jsonb" DEFAULT NULL::"jsonb") RETURNS "public"."expenses"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user           uuid;
  v_home_id        uuid := p_home_id;
  v_home_is_active boolean;
  v_result         public.expenses%ROWTYPE;

  v_new_status     public.expense_status;
  v_target_split   public.expense_split_type;
  v_has_splits     boolean := FALSE;

  v_amount_cap constant bigint  := 900000000000;
  v_desc_max   constant integer := 280;
  v_notes_max  constant integer := 2000;
BEGIN
  -- Must be logged in
  PERFORM public._assert_authenticated();
  v_user := auth.uid();

  -- Basic required inputs
  IF v_home_id IS NULL THEN
    PERFORM public.api_error('INVALID_HOME', 'Home id is required.', '22023');
  END IF;

  IF p_amount_cents IS NULL
     OR p_amount_cents <= 0
     OR p_amount_cents > v_amount_cap THEN
    PERFORM public.api_error(
      'INVALID_AMOUNT',
      format('Amount must be between 1 and %s cents.', v_amount_cap),
      '22023'
    );
  END IF;

  IF btrim(COALESCE(p_description, '')) = '' THEN
    PERFORM public.api_error('INVALID_DESCRIPTION', 'Description is required.', '22023');
  END IF;

  IF char_length(btrim(p_description)) > v_desc_max THEN
    PERFORM public.api_error(
      'INVALID_DESCRIPTION',
      format('Description must be %s characters or fewer.', v_desc_max),
      '22023'
    );
  END IF;

  IF p_notes IS NOT NULL AND char_length(p_notes) > v_notes_max THEN
    PERFORM public.api_error(
      'INVALID_NOTES',
      format('Notes must be %s characters or fewer.', v_notes_max),
      '22023'
    );
  END IF;

  -- Decide if this is DRAFT or ACTIVE
  IF p_split_mode IS NULL THEN
    v_new_status   := 'draft';
    v_target_split := NULL;
    v_has_splits   := FALSE;
  ELSE
    v_new_status   := 'active';
    v_target_split := p_split_mode;
    v_has_splits   := TRUE;
  END IF;

  -- Membership + home state
  PERFORM 1
  FROM public.memberships m
  WHERE m.home_id    = v_home_id
    AND m.user_id    = v_user
    AND m.is_current = TRUE
  LIMIT 1;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_HOME_MEMBER',
      'You are not a member of this home.',
      '42501',
      jsonb_build_object('homeId', v_home_id)
    );
  END IF;

  SELECT h.is_active
  INTO v_home_is_active
  FROM public.homes h
  WHERE h.id = v_home_id
  FOR UPDATE;

  IF v_home_is_active IS DISTINCT FROM TRUE THEN
    PERFORM public.api_error('HOME_INACTIVE', 'This home is no longer active.', 'P0004');
  END IF;

  -- Prepare splits if ACTIVE
  IF v_has_splits THEN
    PERFORM public._expenses_prepare_split_buffer(
      v_home_id,
      v_user,
      p_amount_cents,
      v_target_split,
      p_member_ids,
      p_splits
    );
  END IF;

  -- Persist NEW expense
  INSERT INTO public.expenses (
    home_id,
    created_by_user_id,
    status,
    split_type,
    amount_cents,
    description,
    notes
  )
  VALUES (
    v_home_id,
    v_user,
    v_new_status,
    v_target_split,
    p_amount_cents,
    btrim(p_description),
    NULLIF(btrim(p_notes), '')
  )
  RETURNING * INTO v_result;

  -- Persist splits if ACTIVE
  IF v_has_splits THEN
    INSERT INTO public.expense_splits (
      expense_id,
      debtor_user_id,
      amount_cents,
      status,
      marked_paid_at
    )
    SELECT v_result.id,
           debtor_user_id,
           amount_cents,
           CASE
             WHEN debtor_user_id = v_user
               THEN 'paid'::public.expense_share_status
             ELSE 'unpaid'::public.expense_share_status
           END,
           CASE WHEN debtor_user_id = v_user THEN now() ELSE NULL END
    FROM pg_temp.expense_split_buffer;
  END IF;

  RETURN v_result;
END;
$$;


ALTER FUNCTION "public"."expenses_create"("p_home_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."expenses_edit"("p_expense_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text" DEFAULT NULL::"text", "p_split_mode" "public"."expense_split_type" DEFAULT NULL::"public"."expense_split_type", "p_member_ids" "uuid"[] DEFAULT NULL::"uuid"[], "p_splits" "jsonb" DEFAULT NULL::"jsonb") RETURNS "public"."expenses"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user           uuid;
  v_home_id        uuid;
  v_home_is_active boolean;

  v_existing       public.expenses%ROWTYPE;
  v_result         public.expenses%ROWTYPE;

  v_has_paid       boolean := FALSE;
  v_new_status     public.expense_status;
  v_target_split   public.expense_split_type;
  v_should_replace boolean := FALSE;

  v_amount_cap constant bigint  := 900000000000;
  v_desc_max   constant integer := 280;
  v_notes_max  constant integer := 2000;
BEGIN
  PERFORM public._assert_authenticated();
  v_user := auth.uid();

  IF p_expense_id IS NULL THEN
    PERFORM public.api_error('INVALID_EXPENSE', 'Expense id is required.', '22023');
  END IF;

  IF p_amount_cents IS NULL
     OR p_amount_cents <= 0
     OR p_amount_cents > v_amount_cap THEN
    PERFORM public.api_error(
      'INVALID_AMOUNT',
      format('Amount must be between 1 and %s cents.', v_amount_cap),
      '22023'
    );
  END IF;

  IF btrim(COALESCE(p_description, '')) = '' THEN
    PERFORM public.api_error('INVALID_DESCRIPTION', 'Description is required.', '22023');
  END IF;

  IF char_length(btrim(p_description)) > v_desc_max THEN
    PERFORM public.api_error(
      'INVALID_DESCRIPTION',
      format('Description must be %s characters or fewer.', v_desc_max),
      '22023'
    );
  END IF;

  IF p_notes IS NOT NULL AND char_length(p_notes) > v_notes_max THEN
    PERFORM public.api_error(
      'INVALID_NOTES',
      format('Notes must be %s characters or fewer.', v_notes_max),
      '22023'
    );
  END IF;

  -- Load existing expense and lock it
  SELECT *
  INTO v_existing
  FROM public.expenses e
  WHERE e.id = p_expense_id
  FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'Expense not found.',
      'P0002',
      jsonb_build_object('expenseId', p_expense_id)
    );
  END IF;

  v_home_id := v_existing.home_id;

  IF v_existing.created_by_user_id <> v_user THEN
    PERFORM public.api_error(
      'NOT_CREATOR',
      'Only the creator can modify this expense.',
      '42501'
    );
  END IF;

  IF v_existing.status = 'cancelled' THEN
    PERFORM public.api_error(
      'INVALID_STATE',
      'Cancelled expenses cannot be edited.',
      'P0003'
    );
  END IF;

  -- Lock splits rowset for this expense to avoid races
  PERFORM 1
  FROM public.expense_splits s
  WHERE s.expense_id = v_existing.id
  FOR UPDATE;

  -- Check if any share is paid
  SELECT EXISTS (
    SELECT 1
    FROM public.expense_splits s
    WHERE s.expense_id = v_existing.id
      AND s.status     = 'paid'
      AND s.debtor_user_id <> v_existing.created_by_user_id
  )
  INTO v_has_paid;

  -- Determine new status + split_type
  IF v_existing.status = 'draft' THEN
    -- New rule: editing a draft MUST choose a split and becomes active
    IF p_split_mode IS NULL THEN
      PERFORM public.api_error(
        'SPLIT_REQUIRED',
        'Draft edits must choose a split; editing will activate the expense.',
        '22023'
      );
    END IF;

    v_target_split   := p_split_mode;
    v_new_status     := 'active';
    v_should_replace := TRUE;

  ELSE
    -- Existing is active (cancelled already rejected)
    v_new_status := 'active';

    IF v_has_paid THEN
      -- Lock amount and split once any share is paid
      IF p_split_mode IS NOT NULL THEN
        PERFORM public.api_error(
          'EXPENSE_LOCKED_AFTER_PAYMENT',
          'Split settings cannot change after a payment.',
          'P0004'
        );
      END IF;

      IF p_amount_cents <> v_existing.amount_cents THEN
        PERFORM public.api_error(
          'EXPENSE_LOCKED_AFTER_PAYMENT',
          'Amount cannot change after a payment.',
          'P0004'
        );
      END IF;

      v_target_split   := v_existing.split_type;
      v_should_replace := FALSE;
    ELSE
      -- No paid shares yet on an active expense
      IF p_split_mode IS NULL THEN
        -- Keep current split_type
        IF p_amount_cents <> v_existing.amount_cents THEN
          PERFORM public.api_error(
            'SPLIT_REQUIRED',
            'Provide split details when changing the amount of an active expense.',
            '22023'
          );
        END IF;

        v_target_split   := v_existing.split_type;
        v_should_replace := FALSE;
      ELSE
        -- Update split_type and rebuild splits
        v_target_split   := p_split_mode;
        v_should_replace := TRUE;
      END IF;
    END IF;
  END IF;

  IF v_new_status = 'active' AND v_target_split IS NULL THEN
    PERFORM public.api_error(
      'INVALID_STATE',
      'Active expenses must keep a split.',
      'P0003'
    );
  END IF;

  -- Membership + home state
  PERFORM 1
  FROM public.memberships m
  WHERE m.home_id    = v_home_id
    AND m.user_id    = v_user
    AND m.is_current = TRUE
  LIMIT 1;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_HOME_MEMBER',
      'You are not a member of this home.',
      '42501',
      jsonb_build_object('homeId', v_home_id)
    );
  END IF;

  SELECT h.is_active
  INTO v_home_is_active
  FROM public.homes h
  WHERE h.id = v_home_id
  FOR UPDATE;

  IF v_home_is_active IS DISTINCT FROM TRUE THEN
    PERFORM public.api_error(
      'HOME_INACTIVE',
      'This home is no longer active.',
      'P0004'
    );
  END IF;

  -- Prepare split buffer if we need to rebuild splits
  IF v_should_replace THEN
    PERFORM public._expenses_prepare_split_buffer(
      v_home_id,
      v_user,
      p_amount_cents,
      v_target_split,
      p_member_ids,
      p_splits
    );
  END IF;

  -- Persist UPDATE
  UPDATE public.expenses
  SET amount_cents = p_amount_cents,
      description  = btrim(p_description),
      notes        = NULLIF(btrim(p_notes), ''),
      status       = v_new_status,
      split_type   = v_target_split,
      updated_at   = now()
  WHERE id = v_existing.id
  RETURNING * INTO v_result;

  -- Rebuild splits if required
  IF v_should_replace THEN
    DELETE FROM public.expense_splits
    WHERE expense_id = v_result.id;

    INSERT INTO public.expense_splits (
      expense_id,
      debtor_user_id,
      amount_cents,
      status,
      marked_paid_at
    )
    SELECT v_result.id,
           debtor_user_id,
           amount_cents,
           CASE
             WHEN debtor_user_id = v_user
               THEN 'paid'::public.expense_share_status
             ELSE 'unpaid'::public.expense_share_status
           END,
           CASE WHEN debtor_user_id = v_user THEN now() ELSE NULL END
    FROM pg_temp.expense_split_buffer;
  END IF;

  RETURN v_result;
END;
$$;


ALTER FUNCTION "public"."expenses_edit"("p_expense_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."expenses_get_created_by_me"("p_home_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user           uuid;
  v_result         jsonb;
  v_home_is_active boolean;
BEGIN
  PERFORM public._assert_authenticated();
  v_user := auth.uid();

  IF p_home_id IS NULL THEN
    PERFORM public.api_error(
      'INVALID_HOME',
      'Home id is required.',
      '22023'
    );
  END IF;

  -- Caller must be a current member of this home
  PERFORM 1
  FROM public.memberships m
  WHERE m.home_id    = p_home_id
    AND m.user_id    = v_user
    AND m.is_current = TRUE
  LIMIT 1;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_HOME_MEMBER',
      'You are not a member of this home.',
      '42501',
      jsonb_build_object('homeId', p_home_id, 'userId', v_user)
    );
  END IF;

  -- Home is fully frozen when inactive
  SELECT h.is_active
  INTO v_home_is_active
  FROM public.homes h
  WHERE h.id = p_home_id;

  IF v_home_is_active IS DISTINCT FROM TRUE THEN
    PERFORM public.api_error(
      'HOME_INACTIVE',
      'This home is no longer active.',
      'P0004'
    );
  END IF;

  /*
    Build list of live expenses created by the current user.

    Rules:
    - Include creator in the split stats so paidAmountCents / amountCents
      reflects:
        * 25/60 when only the creator has paid
        * 60/60 when everyone has paid.
    - Exclude expenses that:
        * are fully paid (all shares paid), AND
        * were created more than 14 days ago.
    - Sort by:
        1) payment status: unpaid → partial → fully paid
        2) createdAt: newest first
  */
  SELECT COALESCE(
           jsonb_agg(
             jsonb_build_object(
               'expenseId',        e.id,
               'homeId',           e.home_id,
               'createdByUserId',  e.created_by_user_id,
               'description',      e.description,
               'amountCents',      e.amount_cents,
               'status',           e.status,
               'splitType',        e.split_type,
               'createdAt',        e.created_at,
               'totalShares',      COALESCE(stats.total_shares, 0)::int,
               'paidShares',       COALESCE(stats.paid_shares, 0)::int,
               'paidAmountCents',  COALESCE(stats.paid_amount_cents, 0),
               'allPaid',
                 CASE
                   WHEN COALESCE(stats.total_shares, 0) = 0 THEN FALSE
                   ELSE COALESCE(stats.total_shares, 0) = COALESCE(stats.paid_shares, 0)
                 END,
               'fullyPaidAt',
                 CASE
                   WHEN COALESCE(stats.total_shares, 0) = 0 THEN NULL
                   WHEN COALESCE(stats.total_shares, 0) = COALESCE(stats.paid_shares, 0)
                     THEN stats.max_paid_at
                   ELSE NULL
                 END
             )
             ORDER BY
               -- payment status rank: 0 = unpaid, 1 = partial, 2 = fully paid
               CASE
                 WHEN COALESCE(stats.total_shares, 0) = 0 THEN 0                             -- treat as unpaid
                 WHEN COALESCE(stats.paid_shares, 0) = 0 THEN 0                             -- unpaid
                 WHEN COALESCE(stats.total_shares, 0) = COALESCE(stats.paid_shares, 0)
                   THEN 2                                                                   -- fully paid
                 ELSE 1                                                                     -- partially paid
               END,
               e.created_at DESC,
               e.id
           ),
           '[]'::jsonb
         )
  INTO v_result
  FROM public.expenses e
    LEFT JOIN LATERAL (
      SELECT
        COUNT(*) AS total_shares,
        COUNT(*) FILTER (WHERE s.status = 'paid') AS paid_shares,
        COALESCE(
          SUM(s.amount_cents) FILTER (WHERE s.status = 'paid'),
          0
        ) AS paid_amount_cents,
        MAX(s.marked_paid_at) FILTER (WHERE s.status = 'paid') AS max_paid_at
      FROM public.expense_splits s
      WHERE s.expense_id = e.id
      -- 👆 creator IS included here now
    ) stats ON TRUE
  WHERE e.home_id            = p_home_id
    AND e.created_by_user_id = v_user
    AND e.status IN ('draft', 'active')
    -- Filter out fully-paid expenses older than 14 days
    AND NOT (
      COALESCE(stats.total_shares, 0) > 0
      AND COALESCE(stats.total_shares, 0) = COALESCE(stats.paid_shares, 0)
      AND e.created_at < (CURRENT_TIMESTAMP - INTERVAL '14 days')
    );

  RETURN v_result;
END;
$$;


ALTER FUNCTION "public"."expenses_get_created_by_me"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."expenses_get_current_owed"("p_home_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user   uuid;
  v_result jsonb;
BEGIN
  PERFORM public._assert_authenticated();
  v_user := auth.uid();

  -- Membership + active checks (using shared helpers)
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  -- Build owed summary for the current user in this home
  SELECT COALESCE(
           jsonb_agg(
             jsonb_build_object(
               'payerUserId',     payer_user_id,
               'payerDisplay',    payer_display,
               'payerAvatarUrl',  payer_avatar_url,
               'totalOwedCents',  total_owed_cents,
               'items',           items
             )
             ORDER BY payer_display NULLS LAST, payer_user_id
           ),
           '[]'::jsonb
         )
  INTO v_result
  FROM (
    SELECT
      e.created_by_user_id           AS payer_user_id,
      COALESCE(p.full_name, p.email) AS payer_display,
      a.storage_path                 AS payer_avatar_url,  -- payer MUST have avatar
      SUM(s.amount_cents)            AS total_owed_cents,
      jsonb_agg(
        jsonb_build_object(
          'expenseId',   e.id,
          'description', e.description,
          'amountCents', s.amount_cents,
          'notes',       e.notes
        )
        ORDER BY e.created_at DESC, e.id
      ) AS items
    FROM public.expense_splits s
    JOIN public.expenses e
      ON e.id = s.expense_id
    JOIN public.profiles p
      ON p.id = e.created_by_user_id
    JOIN public.avatars a
      ON a.id = p.avatar_id          -- inner join enforces "payer has avatar"
    WHERE e.home_id        = p_home_id
      AND e.status         = 'active'
      AND s.debtor_user_id = v_user
      AND s.status         = 'unpaid'
    GROUP BY e.created_by_user_id, payer_display, payer_avatar_url
  ) owed;

  RETURN v_result;
END;
$$;


ALTER FUNCTION "public"."expenses_get_current_owed"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."expenses_get_for_edit"("p_expense_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user            uuid := auth.uid();
  v_expense         public.expenses%ROWTYPE;
  v_home_is_active  boolean;
  v_splits          jsonb := '[]'::jsonb;
  v_has_paid_splits boolean := FALSE;
  v_amount_locked   boolean := FALSE;
BEGIN
  -- Require authentication
  PERFORM public._assert_authenticated();

  IF p_expense_id IS NULL THEN
    PERFORM public.api_error(
      'INVALID_EXPENSE',
      'Expense id is required.',
      '22023'
    );
  END IF;

  /*
    Load the expense and ensure:
      - caller is a current member of the home
    This avoids leaking whether an expense exists in another home:
      - If not found here, the caller simply gets NOT_FOUND.
  */
  SELECT e.*
  INTO v_expense
  FROM public.expenses e
  JOIN public.homes h
    ON h.id = e.home_id
  WHERE e.id = p_expense_id
    AND EXISTS (
      SELECT 1
      FROM public.memberships m
      WHERE m.home_id    = e.home_id
        AND m.user_id    = v_user
        AND m.is_current = TRUE
    );

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'Expense not found.',
      'P0002',
      jsonb_build_object('expenseId', p_expense_id)
    );
  END IF;

  -- Load home active flag separately (after we know the expense is visible)
  SELECT h.is_active
  INTO v_home_is_active
  FROM public.homes h
  WHERE h.id = v_expense.home_id;

  -- Home must be active (frozen when inactive)
  IF v_home_is_active IS DISTINCT FROM TRUE THEN
    PERFORM public.api_error(
      'HOME_INACTIVE',
      'This home is no longer active.',
      'P0004',
      jsonb_build_object('homeId', v_expense.home_id)
    );
  END IF;

  -- Only creator can edit
  IF v_expense.created_by_user_id <> v_user THEN
    PERFORM public.api_error(
      'NOT_CREATOR',
      'Only the creator can edit this expense.',
      '42501',
      jsonb_build_object(
        'expenseId', p_expense_id,
        'userId',    v_user
      )
    );
  END IF;

  -- Enforce allowed edit states:
  -- 1) draft
  -- 2) active with NO paid splits
  IF v_expense.status NOT IN ('draft', 'active') THEN
    PERFORM public.api_error(
      'EDIT_NOT_ALLOWED',
      'Only draft or active expenses can be edited.',
      '42501',
      jsonb_build_object(
        'expenseId', p_expense_id,
        'status',    v_expense.status
      )
    );
  END IF;

  IF v_expense.status = 'active' THEN
    SELECT EXISTS (
    SELECT 1
    FROM public.expense_splits s
    WHERE s.expense_id = v_expense.id
      AND s.status     = 'paid'
      AND s.debtor_user_id <> v_expense.created_by_user_id
  )
  INTO v_has_paid_splits;
  END IF;

  v_amount_locked := v_expense.status = 'active' AND v_has_paid_splits;

  -- Build splits payload (for draft or active with no paid splits)
  SELECT COALESCE(
           jsonb_agg(
             jsonb_build_object(
               'expense_id',     s.expense_id,
               'debtor_user_id', s.debtor_user_id,
               'amount_cents',   s.amount_cents,
               'status',         s.status,
               'marked_paid_at', s.marked_paid_at
             )
             ORDER BY s.debtor_user_id
           ),
           '[]'::jsonb
         )
  INTO v_splits
  FROM public.expense_splits s
  WHERE s.expense_id = v_expense.id;

  RETURN jsonb_build_object(
    'id',                 v_expense.id,
    'home_id',            v_expense.home_id,
    'created_by_user_id', v_expense.created_by_user_id,
    'status',             v_expense.status,
    'split_type',         v_expense.split_type,
    'amount_cents',       v_expense.amount_cents,
    'description',        v_expense.description,
    'notes',              v_expense.notes,
    'created_at',         v_expense.created_at,
    'updated_at',         v_expense.updated_at,
    'amount_locked',      v_amount_locked,
    'splits',             v_splits
  );
END;
$$;


ALTER FUNCTION "public"."expenses_get_for_edit"("p_expense_id" "uuid") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."expense_splits" (
    "expense_id" "uuid" NOT NULL,
    "debtor_user_id" "uuid" NOT NULL,
    "amount_cents" bigint NOT NULL,
    "status" "public"."expense_share_status" DEFAULT 'unpaid'::"public"."expense_share_status" NOT NULL,
    "marked_paid_at" timestamp with time zone,
    CONSTRAINT "chk_expense_splits_amount_positive" CHECK (("amount_cents" > 0)),
    CONSTRAINT "chk_expense_splits_paid_timestamp_alignment" CHECK (((("status" = 'unpaid'::"public"."expense_share_status") AND ("marked_paid_at" IS NULL)) OR (("status" = 'paid'::"public"."expense_share_status") AND ("marked_paid_at" IS NOT NULL))))
);


ALTER TABLE "public"."expense_splits" OWNER TO "postgres";


COMMENT ON TABLE "public"."expense_splits" IS 'Per-person share of an expense (debtor owes the creator).';



COMMENT ON COLUMN "public"."expense_splits"."debtor_user_id" IS 'Member who owes this share.';



COMMENT ON COLUMN "public"."expense_splits"."amount_cents" IS 'Share amount in cents.';



COMMENT ON COLUMN "public"."expense_splits"."status" IS 'unpaid|paid.';



COMMENT ON COLUMN "public"."expense_splits"."marked_paid_at" IS 'Timestamp when debtor marked the share paid.';



CREATE OR REPLACE FUNCTION "public"."expenses_mark_share_paid"("p_expense_id" "uuid") RETURNS "public"."expense_splits"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user           uuid;
  v_expense        public.expenses%ROWTYPE;
  v_split          public.expense_splits%ROWTYPE;
  v_home_is_active boolean;
BEGIN
  -- Authentication
  PERFORM public._assert_authenticated();
  v_user := auth.uid();

  IF p_expense_id IS NULL THEN
    PERFORM public.api_error('INVALID_EXPENSE', 'Expense id is required.', '22023');
  END IF;

  -- Load and lock the expense
  SELECT *
  INTO v_expense
  FROM public.expenses e
  WHERE e.id = p_expense_id
  FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'Expense not found.',
      'P0002',
      jsonb_build_object('expenseId', p_expense_id)
    );
  END IF;

  IF v_expense.status <> 'active' THEN
    PERFORM public.api_error(
      'INVALID_STATE',
      'Only active expenses can be paid.',
      'P0003'
    );
  END IF;

  -- Membership + home state
  PERFORM 1
  FROM public.memberships m
  WHERE m.home_id    = v_expense.home_id
    AND m.user_id    = v_user
    AND m.is_current = TRUE
  LIMIT 1;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_HOME_MEMBER',
      'You are not a member of this home.',
      '42501',
      jsonb_build_object('homeId', v_expense.home_id)
    );
  END IF;

  SELECT h.is_active
  INTO v_home_is_active
  FROM public.homes h
  WHERE h.id = v_expense.home_id
  FOR UPDATE;

  IF v_home_is_active IS DISTINCT FROM TRUE THEN
    PERFORM public.api_error(
      'HOME_INACTIVE',
      'This home is no longer active.',
      'P0004'
    );
  END IF;

  -- Load and lock the caller's split
  SELECT *
  INTO v_split
  FROM public.expense_splits s
  WHERE s.expense_id     = v_expense.id
    AND s.debtor_user_id = v_user
  FOR UPDATE;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'NOT_FOUND',
      'You do not have a share on this expense.',
      'P0002',
      jsonb_build_object('expenseId', p_expense_id, 'userId', v_user)
    );
  END IF;

  -- Idempotent: if already paid, just return the row
  IF v_split.status = 'paid' THEN
    RETURN v_split;
  END IF;

  -- Mark as paid
  UPDATE public.expense_splits
  SET status         = 'paid',
      marked_paid_at = now()
  WHERE expense_id     = v_expense.id
    AND debtor_user_id = v_user
  RETURNING * INTO v_split;

  RETURN v_split;
END;
$$;


ALTER FUNCTION "public"."expenses_mark_share_paid"("p_expense_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."gratitude_wall_list"("p_home_id" "uuid", "p_limit" integer DEFAULT 20, "p_cursor_created_at" timestamp with time zone DEFAULT NULL::timestamp with time zone, "p_cursor_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("post_id" "uuid", "author_user_id" "uuid", "mood" "public"."mood_scale", "message" "text", "created_at" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_limit int := LEAST(COALESCE(p_limit, 20), 100);
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  RETURN QUERY
  SELECT p.id,
         p.author_user_id,
         p.mood,
         p.message,
         p.created_at
  FROM public.gratitude_wall_posts p
  WHERE p.home_id = p_home_id
    AND (
      p_cursor_created_at IS NULL
      OR (
        p.created_at < p_cursor_created_at
        OR (
          p_cursor_id IS NOT NULL
          AND p.created_at = p_cursor_created_at
          AND p.id < p_cursor_id
        )
      )
    )
  ORDER BY p.created_at DESC, p.id DESC
  LIMIT v_limit;
END;
$$;


ALTER FUNCTION "public"."gratitude_wall_list"("p_home_id" "uuid", "p_limit" integer, "p_cursor_created_at" timestamp with time zone, "p_cursor_id" "uuid") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."gratitude_wall_list"("p_home_id" "uuid", "p_limit" integer, "p_cursor_created_at" timestamp with time zone, "p_cursor_id" "uuid") IS 'List gratitude wall posts for a home, ordered newest to oldest, with cursor-based pagination. Parameters: p_home_id (home ID), p_limit (max rows, default 20, capped at 100), p_cursor_created_at (created_at of last seen post for pagination), p_cursor_id (ID of last seen post). Returns: post_id, author_user_id, mood, message, created_at.';



CREATE OR REPLACE FUNCTION "public"."gratitude_wall_mark_read"("p_home_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id uuid := auth.uid();
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  INSERT INTO public.gratitude_wall_reads (home_id, user_id, last_read_at)
  VALUES (p_home_id, v_user_id, now())
  ON CONFLICT (home_id, user_id)
  DO UPDATE SET last_read_at = EXCLUDED.last_read_at;

  -- If we got here without error, we consider it a success.
  RETURN TRUE;
END;
$$;


ALTER FUNCTION "public"."gratitude_wall_mark_read"("p_home_id" "uuid") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."gratitude_wall_mark_read"("p_home_id" "uuid") IS 'Mark the gratitude wall as read for the current user in the specified home. Inserts or updates the last_read_at timestamp in gratitude_wall_reads. Parameters: p_home_id (home ID). Returns: boolean (TRUE on success).';



CREATE OR REPLACE FUNCTION "public"."gratitude_wall_status"("p_home_id" "uuid") RETURNS TABLE("has_unread" boolean, "last_read_at" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id          uuid := auth.uid();
  v_latest_created_at timestamptz;
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  SELECT r.last_read_at
  INTO last_read_at
  FROM public.gratitude_wall_reads r
  WHERE r.home_id = p_home_id
    AND r.user_id = v_user_id
  LIMIT 1;

  SELECT p.created_at
  INTO v_latest_created_at
  FROM public.gratitude_wall_posts p
  WHERE p.home_id = p_home_id
    AND p.author_user_id <> v_user_id  
  ORDER BY p.created_at DESC, p.id DESC
  LIMIT 1;

  has_unread :=
    CASE
      WHEN v_latest_created_at IS NULL THEN FALSE
      WHEN last_read_at IS NULL THEN TRUE
      ELSE v_latest_created_at > last_read_at
    END;

  RETURN NEXT;
END;
$$;


ALTER FUNCTION "public"."gratitude_wall_status"("p_home_id" "uuid") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."gratitude_wall_status"("p_home_id" "uuid") IS 'Returns whether the current user has unread gratitude wall posts for the given home, and the last_read_at timestamp.';



CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  default_avatar uuid;
  v_username     public.citext;  -- 👈 qualify the type
BEGIN
  SELECT id INTO default_avatar
  FROM public.avatars
  ORDER BY created_at ASC
  LIMIT 1;

  IF default_avatar IS NULL THEN
    RAISE EXCEPTION 'handle_new_user: no default avatar found';
  END IF;

  v_username := public._gen_unique_username(NEW.email, NEW.id);

  INSERT INTO public.profiles (id, email, full_name, avatar_id, username)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NULL),
    default_avatar,
    v_username
  )
  ON CONFLICT (id) DO UPDATE
    SET
      email     = COALESCE(public.profiles.email, EXCLUDED.email),
      full_name = COALESCE(public.profiles.full_name, EXCLUDED.full_name),
      avatar_id = COALESCE(public.profiles.avatar_id, EXCLUDED.avatar_id),
      username  = COALESCE(public.profiles.username, EXCLUDED.username);

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."handle_new_user"() IS 'Trigger function to create a default profile row for each new auth user with a default avatar.';



CREATE OR REPLACE FUNCTION "public"."home_assignees_list"("p_home_id" "uuid") RETURNS TABLE("user_id" "uuid", "full_name" "text", "email" "text", "avatar_storage_path" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
  -- 1️⃣ Require auth
  PERFORM public._assert_authenticated();

  -- 2️⃣ Ensure caller actually belongs to this home
  PERFORM public._assert_home_member(p_home_id);

  -- 3️⃣ Return all *active* members of this home as potential assignees
  RETURN QUERY
  SELECT
    m.user_id,
    p.full_name,
    p.email,
    a.storage_path
  FROM public.memberships m
  JOIN public.profiles p
    ON p.id = m.user_id
  JOIN public.avatars a
    ON a.id = p.avatar_id
    WHERE m.home_id = p_home_id
      AND m.is_current = TRUE        -- or your "still in house" condition
  ORDER BY COALESCE(p.full_name, p.email);
END;
$$;


ALTER FUNCTION "public"."home_assignees_list"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."home_entitlements_refresh"("_home_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  -- Whether the home has ANY valid subscription right now
  v_has_valid  boolean;

  -- The maximum expiry across all subscriptions for this home
  v_latest_exp timestamptz;
BEGIN
  -------------------------------------------------------------------------
  -- 1. Aggregate subscription status for this home
  --
  -- We compute:
  --   - v_has_valid: does ANY subscription satisfy "currently premium?"
  --   - v_latest_exp: the furthest current_period_end_at we have on record
  --
  -- NOTE: This uses SELECT ... INTO (PL/pgSQL syntax).
  -------------------------------------------------------------------------
  SELECT
    EXISTS (
      SELECT 1
      FROM public.user_subscriptions us
      WHERE us.home_id = _home_id
        -- Subs we still treat as "funding" the home
        AND us.status IN ('active', 'cancelled')
        -- Valid if end date is in the future OR not provided yet
        AND (us.current_period_end_at IS NULL OR us.current_period_end_at > now())
    ) AS has_valid_subscription,

    -- Latest expiry (can be NULL if no expiry exists)
    MAX(us.current_period_end_at) AS latest_expiry

  INTO v_has_valid, v_latest_exp
  FROM public.user_subscriptions us
  WHERE us.home_id = _home_id;


  -------------------------------------------------------------------------
  -- 2. Upsert into home_entitlements (the source of truth for "is this
  --    home premium or free?")
  --
  -- We insert the newly computed "plan" and "expires_at" values.
  -- If the home already has a row, ON CONFLICT triggers an UPDATE.
  --
  -- IMPORTANT:
  --   - We MUST use EXCLUDED.plan instead of referencing PL/pgSQL vars
  --     inside the UPDATE clause.
  --
  -- WHY?
  --   - PL/pgSQL variables (v_has_valid, v_latest_exp) are NOT visible
  --     inside the SQL UPDATE engine.
  --   - Postgres exposes the pseudo-table EXCLUDED to represent the
  --     values we *attempted* to insert.
  --   - EXCLUDED is the ONLY legal way to access those values inside
  --     ON CONFLICT DO UPDATE.
  -------------------------------------------------------------------------
  INSERT INTO public.home_entitlements AS he (home_id, plan, expires_at)
  VALUES (
    _home_id,

    -- If any valid sub exists → premium, else free
    CASE WHEN v_has_valid THEN 'premium' ELSE 'free' END,

    -- Expiry is only meaningful if premium
    CASE WHEN v_has_valid THEN v_latest_exp ELSE NULL END
  )

  ON CONFLICT (home_id) DO UPDATE
  SET
    -- EXCLUDED.plan = the plan we *intended* to insert
    plan       = EXCLUDED.plan,

    -- EXCLUDED.expires_at = the expiry we *intended* to insert
    expires_at = EXCLUDED.expires_at,

    -- Always update updated_at timestamp
    updated_at = now();

END;
$$;


ALTER FUNCTION "public"."home_entitlements_refresh"("_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."home_mood_feedback_counters_inc"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_row       public.home_mood_feedback_counters%ROWTYPE;
  v_milestone integer;
  v_step      constant integer := 13; -- feedbacks per NPS milestone
BEGIN
  -- Ensure caller is authenticated; membership checks already happen in mood_submit
  PERFORM public._assert_authenticated();

  -- Upsert basic counters
  INSERT INTO public.home_mood_feedback_counters AS c (
    home_id,
    user_id,
    feedback_count,
    first_feedback_at,
    last_feedback_at
  )
  VALUES (
    NEW.home_id,
    NEW.user_id,
    1,
    NEW.created_at,
    NEW.created_at
  )
  ON CONFLICT (home_id, user_id)
  DO UPDATE
    SET feedback_count   = c.feedback_count + 1,
        last_feedback_at = NEW.created_at;

  -- Fetch updated row
  SELECT *
  INTO v_row
  FROM public.home_mood_feedback_counters
  WHERE home_id = NEW.home_id
    AND user_id = NEW.user_id;

  -- Compute current milestone and decide if NPS is required.
  -- Example: feedback_count = 13 -> milestone = 13
  --          feedback_count = 20 -> milestone = 13
  --          feedback_count = 26 -> milestone = 26
  IF v_row.feedback_count >= v_step THEN
    v_milestone := (v_row.feedback_count / v_step) * v_step;

    IF v_milestone > 0
       AND v_milestone > v_row.last_nps_feedback_count
    THEN
      UPDATE public.home_mood_feedback_counters
      SET nps_required = TRUE
      WHERE home_id = NEW.home_id
        AND user_id = NEW.user_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."home_mood_feedback_counters_inc"() OWNER TO "postgres";


COMMENT ON FUNCTION "public"."home_mood_feedback_counters_inc"() IS 'Trigger to maintain per-home per-user feedback counters and mark when NPS is required.';



CREATE OR REPLACE FUNCTION "public"."home_nps_get_status"("p_home_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_required boolean;
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  SELECT c.nps_required
  INTO v_required
  FROM public.home_mood_feedback_counters c
  WHERE c.home_id = p_home_id
    AND c.user_id = v_user_id;

  RETURN COALESCE(v_required, FALSE);
END;
$$;


ALTER FUNCTION "public"."home_nps_get_status"("p_home_id" "uuid") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."home_nps_get_status"("p_home_id" "uuid") IS 'Returns TRUE if an NPS response is currently required for this user in the given home, otherwise FALSE.';



CREATE TABLE IF NOT EXISTS "public"."home_nps" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "home_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "score" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "nps_feedback_count" integer NOT NULL,
    CONSTRAINT "home_nps_score_check" CHECK ((("score" >= 0) AND ("score" <= 10)))
);


ALTER TABLE "public"."home_nps" OWNER TO "postgres";


COMMENT ON TABLE "public"."home_nps" IS 'History of NPS responses per home and user, tied to feedback milestones.';



COMMENT ON COLUMN "public"."home_nps"."nps_feedback_count" IS 'Value of feedback_count at the time this NPS was submitted (e.g. 13, 26, 39...).';



CREATE OR REPLACE FUNCTION "public"."home_nps_submit"("p_home_id" "uuid", "p_score" integer) RETURNS "public"."home_nps"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id  uuid := auth.uid();
  v_counters public.home_mood_feedback_counters%ROWTYPE;
  v_row      public.home_nps%ROWTYPE;
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  -- Validate score
  PERFORM public.api_assert(
    p_score BETWEEN 0 AND 10,
    'INVALID_NPS_SCORE',
    'NPS score must be between 0 and 10.',
    '22023'
  );

  -- Get counters row
  SELECT *
  INTO v_counters
  FROM public.home_mood_feedback_counters
  WHERE home_id = p_home_id
    AND user_id = v_user_id;

  -- Must have some feedback history
  PERFORM public.api_assert(
    v_counters.home_id IS NOT NULL,
    'NPS_NOT_ELIGIBLE',
    'NPS cannot be submitted before any mood feedback.',
    '22023'
  );

  -- NPS must actually be required right now
  PERFORM public.api_assert(
    v_counters.nps_required IS TRUE,
    'NPS_NOT_REQUIRED',
    'NPS is not currently required.',
    '22023'
  );

  INSERT INTO public.home_nps (
    home_id,
    user_id,
    score,
    nps_feedback_count
  )
  VALUES (
    p_home_id,
    v_user_id,
    p_score,
    v_counters.feedback_count
  )
  RETURNING * INTO v_row;

  -- Update counters with latest NPS info and clear the requirement
  UPDATE public.home_mood_feedback_counters
  SET last_nps_at             = v_row.created_at,
      last_nps_score          = v_row.score,
      last_nps_feedback_count = v_row.nps_feedback_count,
      nps_required            = FALSE
  WHERE home_id = p_home_id
    AND user_id = v_user_id;

  RETURN v_row;
END;
$$;


ALTER FUNCTION "public"."home_nps_submit"("p_home_id" "uuid", "p_score" integer) OWNER TO "postgres";


COMMENT ON FUNCTION "public"."home_nps_submit"("p_home_id" "uuid", "p_score" integer) IS 'Submit an NPS response (0–10) for a home when NPS is required. Uses current feedback_count as nps_feedback_count, records the score, and clears nps_required in home_mood_feedback_counters.';



CREATE OR REPLACE FUNCTION "public"."homes_create_with_invite"() RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user uuid := auth.uid();
  v_home public.homes;
  v_inv  public.invites;
BEGIN
  PERFORM public._assert_authenticated();

  -- 1) Create home
  INSERT INTO public.homes (owner_user_id)
  VALUES (v_user)
  RETURNING * INTO v_home;

  -- 2) Create owner membership (first active member)
  INSERT INTO public.memberships (user_id, home_id, role)
  VALUES (v_user, v_home.id, 'owner');

  -- 3) Increment usage counters: active_members +1
  PERFORM public._home_usage_apply_delta(
    v_home.id,
    jsonb_build_object('active_members', 1)
  );

  -- 4) Set entitlements (default: free)
  INSERT INTO public.home_entitlements (home_id, plan, expires_at)
  VALUES (v_home.id, 'free', NULL);

  -- 5) Create first invite (one active per home enforced by partial index)
  INSERT INTO public.invites (home_id, code)
  VALUES (v_home.id, public._gen_invite_code())
  ON CONFLICT (home_id) WHERE revoked_at IS NULL DO NOTHING
  RETURNING * INTO v_inv;

  IF NOT FOUND THEN
    SELECT *
    INTO v_inv
    FROM public.invites
    WHERE home_id = v_home.id
      AND revoked_at IS NULL
    LIMIT 1;
  END IF;

  -- 6) Attach existing subscription to this home (if any)
  PERFORM public._home_attach_subscription_to_home(v_user, v_home.id);

  -- 7) Return result
  RETURN jsonb_build_object(
    'home', jsonb_build_object(
      'id',            v_home.id,
      'owner_user_id', v_home.owner_user_id,
      'created_at',    v_home.created_at
    ),
    'invite', jsonb_build_object(
      'id',         v_inv.id,
      'home_id',    v_inv.home_id,
      'code',       v_inv.code,
      'created_at', v_inv.created_at
    )
  );
END;
$$;


ALTER FUNCTION "public"."homes_create_with_invite"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."homes_join"("p_code" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user    uuid := auth.uid();
  v_home_id uuid;
  v_revoked boolean;
  v_active  boolean;
BEGIN
  PERFORM public._assert_authenticated();

  --------------------------------------------------------------------
  -- Combined lookup: home_id + invite state
  --------------------------------------------------------------------
  SELECT
    i.home_id,
    (i.revoked_at IS NOT NULL) AS revoked,
    h.is_active
  INTO
    v_home_id,
    v_revoked,
    v_active
  FROM public.invites i
  JOIN public.homes h ON h.id = i.home_id
  WHERE i.code = p_code::public.citext
  LIMIT 1;

  -- Code not found at all
  IF v_home_id IS NULL THEN
    PERFORM public.api_error(
      'INVALID_CODE',
      'Invite code not found. Please check and try again.',
      '22023',
      jsonb_build_object('code', p_code)
    );
  END IF;

  -- Invite revoked or home inactive
  IF v_revoked OR NOT v_active THEN
    PERFORM public.api_error(
      'INACTIVE_INVITE',
      'This invite or household is no longer active.',
      'P0001',
      jsonb_build_object('code', p_code)
    );
  END IF;

  --------------------------------------------------------------------
  -- Ensure caller has a unique avatar within this home (plan-gated)
  -- This now runs even if they are already a member of the home.
  --------------------------------------------------------------------
  PERFORM public._ensure_unique_avatar_for_home(v_home_id, v_user);

  -- Already current member of this same home
  IF EXISTS (
    SELECT 1
    FROM public.memberships m
    WHERE m.user_id = v_user
      AND m.home_id = v_home_id
      AND m.is_current = TRUE
  ) THEN
    RETURN jsonb_build_object(
      'status',  'success',
      'code',    'already_member',
      'message', 'You are already part of this household.',
      'home_id', v_home_id
    );
  END IF;

  -- Already in another active home (only one allowed)
  IF EXISTS (
    SELECT 1
    FROM public.memberships m
    WHERE m.user_id = v_user
      AND m.is_current = TRUE
      AND m.home_id <> v_home_id
  ) THEN
    PERFORM public.api_error(
      'ALREADY_IN_OTHER_HOME',
      'You are already a member of another household. Leave it first before joining a new one.',
      '42501'
    );
  END IF;

  --------------------------------------------------------------------
  -- Paywall: enforce active_members limit on this home
  --------------------------------------------------------------------
  PERFORM public._home_assert_quota(
    v_home_id,
    jsonb_build_object('active_members', 1)
  );

  -- Create new membership
  INSERT INTO public.memberships (user_id, home_id, role, valid_from, valid_to)
  VALUES (v_user, v_home_id, 'member', now(), NULL);

  -- Increment cached active_members
  PERFORM public._home_usage_apply_delta(
    v_home_id,
    jsonb_build_object('active_members', 1)
  );

  -- Increment invite analytics
  UPDATE public.invites
     SET used_count = used_count + 1
   WHERE home_id = v_home_id
     AND code = p_code::public.citext;

  -- Attach Subscription to home
  PERFORM public._home_attach_subscription_to_home(v_user, v_home_id);

  -- Success response
  RETURN jsonb_build_object(
    'status',  'success',
    'code',    'joined',
    'message', 'You have joined the household successfully!',
    'home_id', v_home_id
  );
END;
$$;


ALTER FUNCTION "public"."homes_join"("p_code" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."homes_leave"("p_home_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user            uuid := auth.uid();
  v_is_owner        boolean;
  v_other_members   integer;
  v_left_rows       integer;
  v_deactivated     boolean := false;
  v_role_before     text;
  v_members_left    integer;

  v_current_members integer;
  v_delta_members   integer;
BEGIN
  PERFORM public._assert_authenticated();

  -- Serialize with transfers/joins
  PERFORM 1
  FROM public.homes h
  WHERE h.id = p_home_id
  FOR UPDATE;

  -- Must be a current member
  PERFORM public.api_assert(
    EXISTS (
      SELECT 1
      FROM public.memberships m
      WHERE m.user_id = v_user
        AND m.home_id = p_home_id
        AND m.is_current
    ),
    'NOT_MEMBER',
    'You are not a current member of this home.',
    '42501',
    jsonb_build_object('home_id', p_home_id)
  );

  -- Capture role (for response)
  SELECT m.role
    INTO v_role_before
    FROM public.memberships m
   WHERE m.user_id = v_user
     AND m.home_id = p_home_id
     AND m.is_current
   LIMIT 1;

  -- If owner, only leave if last member
  SELECT EXISTS (
    SELECT 1
    FROM public.memberships m
    WHERE m.user_id = v_user
      AND m.home_id = p_home_id
      AND m.is_current
      AND m.role = 'owner'
  ) INTO v_is_owner;

  IF v_is_owner THEN
    SELECT COUNT(*) INTO v_other_members
      FROM public.memberships m
     WHERE m.home_id = p_home_id
       AND m.is_current
       AND m.user_id <> v_user;

    IF v_other_members > 0 THEN
      PERFORM public.api_error(
        'OWNER_MUST_TRANSFER_FIRST',
        'Owner must transfer ownership before leaving.',
        '42501',
        jsonb_build_object(
          'home_id',       p_home_id,
          'other_members', v_other_members
        )
      );
    END IF;
  END IF;

  -- End the stint
  UPDATE public.memberships m
     SET valid_to   = now(),
         updated_at = now()
   WHERE user_id = v_user
     AND home_id = p_home_id
     AND m.is_current
  RETURNING 1 INTO v_left_rows;

  IF v_left_rows IS NULL THEN
    PERFORM public.api_error(
      'STATE_CHANGED_RETRY',
      'Membership state changed; retry.',
      '40001'
    );
  END IF;

  -- Check remaining members (ground truth)
  SELECT COUNT(*) INTO v_members_left
    FROM public.memberships m
   WHERE m.home_id = p_home_id
     AND m.is_current;

  -- Keep usage counter in sync with ground truth
  SELECT COALESCE(active_members, 0)
    INTO v_current_members
    FROM public.home_usage_counters
   WHERE home_id = p_home_id;

  v_delta_members := v_members_left - v_current_members;

  IF v_delta_members <> 0 THEN
    PERFORM public._home_usage_apply_delta(
      p_home_id,
      jsonb_build_object('active_members', v_delta_members)
    );
  END IF;

  -- Deactivate home if no members remain
  IF v_members_left = 0 THEN
    UPDATE public.homes
       SET is_active      = FALSE,
           deactivated_at = now(),
           updated_at     = now()
     WHERE id = p_home_id;

    v_deactivated := true;
  END IF;

  -- Detach any existing live subscription from the home
  PERFORM public._home_detach_subscription_to_home(p_home_id, v_user);

  -- Reassign chores to owner if home still has members
  IF NOT v_deactivated THEN
    PERFORM public.chores_reassign_on_member_leave(p_home_id, v_user);
  END IF;

  RETURN jsonb_build_object(
    'ok', true,
    'code', CASE WHEN v_deactivated THEN 'HOME_DEACTIVATED' ELSE 'LEFT_OK' END,
    'message', CASE
                 WHEN v_deactivated THEN 'Left home; no members remain, home deactivated.'
                 ELSE 'Left home.'
               END,
    'data', jsonb_build_object(
      'home_id',          p_home_id,
      'role_before',      v_role_before,
      'members_remaining', v_members_left,
      'home_deactivated', v_deactivated
    )
  );
END;
$$;


ALTER FUNCTION "public"."homes_leave"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."homes_transfer_owner"("p_home_id" "uuid", "p_new_owner_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user              uuid := auth.uid();
  v_owner_row_ended   integer;
  v_new_owner_ended   integer;
BEGIN
  PERFORM public._assert_authenticated();

  --------------------------------------------------------------------
  -- 1️⃣ Validate new owner input
  --------------------------------------------------------------------
  PERFORM public.api_assert(
    p_new_owner_id IS NOT NULL AND p_new_owner_id <> v_user,
    'INVALID_NEW_OWNER',
    'Please choose a different member to transfer ownership to.',
    '22023',
    jsonb_build_object('home_id', p_home_id, 'new_owner_id', p_new_owner_id)
  );

  --------------------------------------------------------------------
  -- 2️⃣ Verify caller is current owner of an active home
  --------------------------------------------------------------------
  PERFORM public.api_assert(
    EXISTS (
      SELECT 1
      FROM public.memberships m
      JOIN public.homes h ON h.id = m.home_id
      WHERE m.user_id   = v_user
        AND m.home_id   = p_home_id
        AND m.role      = 'owner'
        AND m.is_current = TRUE
        AND h.is_active = TRUE
    ),
    'FORBIDDEN',
    'Only the current home owner can transfer ownership.',
    '42501',
    jsonb_build_object('home_id', p_home_id)
  );

  --------------------------------------------------------------------
  -- 3️⃣ Verify new owner is an active member of the same home
  --------------------------------------------------------------------
  PERFORM public.api_assert(
    EXISTS (
      SELECT 1
      FROM public.memberships m
      JOIN public.homes h ON h.id = m.home_id
      WHERE m.user_id    = p_new_owner_id
        AND m.home_id    = p_home_id
        AND m.is_current = TRUE
        AND h.is_active  = TRUE
    ),
    'NEW_OWNER_NOT_MEMBER',
    'The selected user must already be a current member of this household.',
    'P0001',
    jsonb_build_object('home_id', p_home_id, 'new_owner_id', p_new_owner_id)
  );

  --------------------------------------------------------------------
  -- 4️⃣ (Optional but recommended) serialize with leave/join
  --------------------------------------------------------------------
  PERFORM 1
  FROM public.homes h
  WHERE h.id = p_home_id
  FOR UPDATE;

  --------------------------------------------------------------------
  -- 5️⃣ End current owner stint (role = owner)
  --     We *do* close the owner stint for history...
  --------------------------------------------------------------------
  UPDATE public.memberships m
     SET valid_to   = now(),
         updated_at = now()
   WHERE m.user_id   = v_user
     AND m.home_id   = p_home_id
     AND m.role      = 'owner'
     AND m.is_current = TRUE
  RETURNING 1 INTO v_owner_row_ended;

  PERFORM public.api_assert(
    v_owner_row_ended = 1,
    'STATE_CHANGED_RETRY',
    'Ownership state changed during transfer; please retry.',
    '40001',
    jsonb_build_object('home_id', p_home_id, 'user_id', v_user)
  );

  --------------------------------------------------------------------
  -- 6️⃣ Insert new MEMBER stint for the old owner
  --     👉 This is the bit you were missing.
  --------------------------------------------------------------------
  INSERT INTO public.memberships (user_id, home_id, role, valid_from, valid_to)
  VALUES (v_user, p_home_id, 'member', now(), NULL);

  --------------------------------------------------------------------
  -- 7️⃣ End new owner’s current MEMBER stint
  --------------------------------------------------------------------
  UPDATE public.memberships m
     SET valid_to   = now(),
         updated_at = now()
   WHERE m.user_id    = p_new_owner_id
     AND m.home_id    = p_home_id
     AND m.is_current = TRUE
  RETURNING 1 INTO v_new_owner_ended;

  PERFORM public.api_assert(
    v_new_owner_ended = 1,
    'STATE_CHANGED_RETRY',
    'New owner membership state changed during transfer; please retry.',
    '40001',
    jsonb_build_object('home_id', p_home_id, 'new_owner_id', p_new_owner_id)
  );

  --------------------------------------------------------------------
  -- 8️⃣ Insert new OWNER stint for the new owner
  --------------------------------------------------------------------
  INSERT INTO public.memberships (user_id, home_id, role, valid_from, valid_to)
  VALUES (p_new_owner_id, p_home_id, 'owner', now(), NULL);

  --------------------------------------------------------------------
  -- 9️⃣ Return success response
  --------------------------------------------------------------------
  RETURN jsonb_build_object(
    'status',       'success',
    'code',         'ownership_transferred',
    'message',      'Ownership has been successfully transferred.',
    'home_id',      p_home_id,
    'new_owner_id', p_new_owner_id
  );
END;
$$;


ALTER FUNCTION "public"."homes_transfer_owner"("p_home_id" "uuid", "p_new_owner_id" "uuid") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."invites" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "home_id" "uuid" NOT NULL,
    "code" "public"."citext" NOT NULL,
    "revoked_at" timestamp with time zone,
    "used_count" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_invites_code_format" CHECK (("upper"(("code")::"text") ~ '^[A-HJ-NP-Z2-9]{6}$'::"text")),
    CONSTRAINT "chk_invites_revoked_after_created" CHECK ((("revoked_at" IS NULL) OR ("revoked_at" >= "created_at"))),
    CONSTRAINT "chk_invites_used_nonneg" CHECK (("used_count" >= 0))
);


ALTER TABLE "public"."invites" OWNER TO "postgres";


COMMENT ON TABLE "public"."invites" IS 'Permanent invitation codes for joining homes. Unlimited-use; owners can rotate by revoking.';



COMMENT ON COLUMN "public"."invites"."id" IS 'Primary key (UUID).';



COMMENT ON COLUMN "public"."invites"."home_id" IS 'FK to homes.id; identifies which home the code belongs to.';



COMMENT ON COLUMN "public"."invites"."code" IS '6-char, typeable invite (A–H J–N P–Z, 2–9). Case-insensitive; normalized to uppercase.';



COMMENT ON COLUMN "public"."invites"."revoked_at" IS 'UTC time when the invite was revoked by the owner; NULL means still active.';



COMMENT ON COLUMN "public"."invites"."used_count" IS 'Analytics counter for how many times the code has been used.';



COMMENT ON COLUMN "public"."invites"."created_at" IS 'UTC creation timestamp.';



CREATE OR REPLACE FUNCTION "public"."invites_get_active"("p_home_id" "uuid") RETURNS "public"."invites"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_inv public.invites;
BEGIN
  -- Ensure caller is authenticated + active member of this home
  PERFORM public._assert_home_member(p_home_id);

  -- Fetch the current active invite (no side-effects)
  SELECT *
    INTO v_inv
  FROM public.invites i
  WHERE i.home_id   = p_home_id
    AND i.revoked_at IS NULL
  ORDER BY i.created_at DESC, i.id DESC
  LIMIT 1;

  IF NOT FOUND THEN
    -- Use the same structured error pattern as your helpers
    PERFORM public.api_error(
      'INVITE_NOT_FOUND',
      'No active invite exists for this home.',
      'P0001',
      jsonb_build_object('home_id', p_home_id)
    );
  END IF;

  RETURN v_inv;
END;
$$;


ALTER FUNCTION "public"."invites_get_active"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."invites_revoke"("p_home_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user uuid := auth.uid();
  v_inv  public.invites;
BEGIN
  PERFORM public._assert_authenticated();

  -- 1️⃣ Must be the current owner
  PERFORM public.api_assert(EXISTS (
    SELECT 1
    FROM public.memberships m
    WHERE m.user_id = v_user
      AND m.home_id = p_home_id
      AND m.role = 'owner'
      AND m.is_current = TRUE
  ), 'FORBIDDEN', 'Only the current owner can revoke an invite.', '42501',
     jsonb_build_object('homeId', p_home_id));

  -- 2️⃣ Revoke any active invite(s)
  UPDATE public.invites i
     SET revoked_at = now()
   WHERE i.home_id = p_home_id
     AND i.revoked_at IS NULL
  RETURNING * INTO v_inv;

  -- 3️⃣ If no active invite existed, return a soft info response
  IF NOT FOUND THEN
    RETURN jsonb_build_object(
      'status',  'info',
      'code',    'no_active_invite',
      'message', 'No active invite was found to revoke.'
    );
  END IF;

  -- 4️⃣ Return structured success payload
  RETURN jsonb_build_object(
    'status',      'success',
    'code',        'invite_revoked',
    'message',     'The active invite has been revoked successfully.',
    'invite_id',   v_inv.id,
    'home_id',     v_inv.home_id,
    'revoked_at',  v_inv.revoked_at
  );
END;
$$;


ALTER FUNCTION "public"."invites_revoke"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."invites_rotate"("p_home_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user uuid := auth.uid();
  v_new  public.invites;
BEGIN
  PERFORM public._assert_authenticated();

  -- ensure caller is the current owner of an active home
  PERFORM public.api_assert(EXISTS (
    SELECT 1
    FROM public.memberships m
    JOIN public.homes h ON h.id = m.home_id
    WHERE m.user_id    = v_user
      AND m.home_id    = p_home_id
      AND m.role       = 'owner'
      AND m.is_current = TRUE
      AND h.is_active  = TRUE
  ), 'FORBIDDEN', 'Only the current owner of an active household can rotate invites.', '42501',
     jsonb_build_object('homeId', p_home_id));

  -- revoke existing active invites
  UPDATE public.invites
     SET revoked_at = now()
   WHERE home_id    = p_home_id
     AND revoked_at IS NULL;

  -- create a new invite; partial unique index enforces 1 active per home
  INSERT INTO public.invites (home_id, code)
  VALUES (p_home_id, public._gen_invite_code())
  ON CONFLICT (home_id) WHERE revoked_at IS NULL DO NOTHING
  RETURNING * INTO v_new;

  -- race-safe fallback if another txn inserted first
  IF v_new.id IS NULL THEN
    SELECT *
      INTO v_new
      FROM public.invites
     WHERE home_id = p_home_id
       AND revoked_at IS NULL
     ORDER BY created_at DESC
     LIMIT 1;
  END IF;

  RETURN jsonb_build_object(
    'status','success',
    'code','invite_rotated',
    'message','A new invite code has been generated successfully.',
    'invite_id',   v_new.id,
    'invite_code', v_new.code
  );
END;
$$;


ALTER FUNCTION "public"."invites_rotate"("p_home_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_home_owner"("p_home_id" "uuid", "p_user_id" "uuid" DEFAULT NULL::"uuid") RETURNS boolean
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.memberships m
    WHERE m.home_id = p_home_id
      AND m.user_id = COALESCE(p_user_id, auth.uid())
      AND m.is_current = TRUE
      AND m.role = 'owner'
  );
$$;


ALTER FUNCTION "public"."is_home_owner"("p_home_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."members_list_active_by_home"("p_home_id" "uuid", "p_exclude_self" boolean DEFAULT true) RETURNS TABLE("user_id" "uuid", "username" "public"."citext", "role" "text", "valid_from" timestamp with time zone, "avatar_url" "text", "can_transfer_to" boolean)
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  SELECT 
    m.user_id,
    p.username,
    m.role,
    m.valid_from,
    a.storage_path AS avatar_url,
    (m.role <> 'owner') AS can_transfer_to
  FROM public.memberships m
  JOIN public.profiles p ON p.id = m.user_id
  JOIN public.avatars  a ON a.id = p.avatar_id
  WHERE m.home_id = p_home_id
    AND m.is_current = TRUE
    AND (p_exclude_self IS FALSE OR m.user_id <> auth.uid())
  ORDER BY 
    CASE WHEN m.role = 'owner' THEN 0 ELSE 1 END,
    p.username;
$$;


ALTER FUNCTION "public"."members_list_active_by_home"("p_home_id" "uuid", "p_exclude_self" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."membership_me_current"() RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user uuid := auth.uid();
  v_row  public.memberships;
BEGIN
  PERFORM public._assert_authenticated();

  SELECT * INTO v_row
  FROM public.memberships m
  WHERE m.user_id = v_user
    AND m.is_current = TRUE
  LIMIT 1;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('ok', true, 'current', NULL);
  END IF;

  RETURN jsonb_build_object(
    'ok', true,
    'current', jsonb_build_object(
      'user_id', v_row.user_id,
      'home_id', v_row.home_id,
      'role',    v_row.role,
      'valid_from', v_row.valid_from
    )
  );
END;
$$;


ALTER FUNCTION "public"."membership_me_current"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mood_get_current_weekly"("p_home_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id       uuid := auth.uid();
  v_iso_week      int;
  v_iso_week_year int;
  v_exists        boolean;
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  SELECT extract('week' FROM timezone('UTC', now()))::int,
         extract('isoyear' FROM timezone('UTC', now()))::int
  INTO v_iso_week, v_iso_week_year;

  SELECT EXISTS (
    SELECT 1
    FROM public.home_mood_entries e
    WHERE e.user_id       = v_user_id
      AND e.iso_week_year = v_iso_week_year
      AND e.iso_week      = v_iso_week
  )
  INTO v_exists;

  RETURN v_exists;
END;
$$;


ALTER FUNCTION "public"."mood_get_current_weekly"("p_home_id" "uuid") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."mood_get_current_weekly"("p_home_id" "uuid") IS 'Returns TRUE if the user already submitted a mood entry for the current ISO week (in ANY home), otherwise FALSE. The p_home_id parameter is used only for membership and home-active checks.';



CREATE OR REPLACE FUNCTION "public"."mood_submit"("p_home_id" "uuid", "p_mood" "public"."mood_scale", "p_comment" "text" DEFAULT NULL::"text", "p_add_to_wall" boolean DEFAULT false) RETURNS TABLE("entry_id" "uuid", "gratitude_post_id" "uuid")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_user_id       uuid := auth.uid();
  v_iso_week      int;
  v_iso_week_year int;
  v_post_id       uuid;
  v_comment_trim  text;
BEGIN
  PERFORM public._assert_authenticated();
  PERFORM public._assert_home_member(p_home_id);
  PERFORM public._assert_home_active(p_home_id);

  PERFORM public.api_assert(
    p_home_id IS NOT NULL,
    'INVALID_HOME',
    'Home id is required.',
    '22023'
  );

  PERFORM public.api_assert(
    p_mood IS NOT NULL,
    'INVALID_MOOD',
    'Mood is required.',
    '22023'
  );

  SELECT extract('week' FROM timezone('UTC', now()))::int,
         extract('isoyear' FROM timezone('UTC', now()))::int
    INTO v_iso_week, v_iso_week_year;

    PERFORM public.api_assert(
    NOT EXISTS (
        SELECT 1
        FROM public.home_mood_entries e
        WHERE e.user_id       = v_user_id
        AND e.iso_week_year = v_iso_week_year
        AND e.iso_week      = v_iso_week
    ),
    'MOOD_ALREADY_SUBMITTED',
    'Mood already submitted for this ISO week (across all homes).',
    'P0001',
    jsonb_build_object('isoWeek', v_iso_week, 'isoYear', v_iso_week_year)
    );

  -- Normalise comment: trim whitespace, turn empty string into NULL, then cap length at 500
  v_comment_trim := NULLIF(btrim(p_comment), '');

  INSERT INTO public.home_mood_entries (
    home_id,
    user_id,
    mood,
    comment,
    iso_week_year,
    iso_week
  )
  VALUES (
    p_home_id,
    v_user_id,
    p_mood,
    CASE
      WHEN v_comment_trim IS NULL THEN NULL
      ELSE left(v_comment_trim, 500)
    END,
    v_iso_week_year,
    v_iso_week
  )
  RETURNING id INTO entry_id;

  IF COALESCE(p_add_to_wall, FALSE) AND p_mood IN ('sunny','partially_sunny') THEN
    INSERT INTO public.gratitude_wall_posts (
      home_id,
      author_user_id,
      mood,
      message
    )
    VALUES (
      p_home_id,
      v_user_id,
      p_mood,
      CASE
        WHEN v_comment_trim IS NULL THEN NULL
        ELSE left(v_comment_trim, 500)
      END
    )
    RETURNING id INTO v_post_id;

    UPDATE public.home_mood_entries
    SET gratitude_post_id = v_post_id
    WHERE id = entry_id;
  END IF;

  gratitude_post_id := v_post_id;
  RETURN NEXT;
END;
$$;


ALTER FUNCTION "public"."mood_submit"("p_home_id" "uuid", "p_mood" "public"."mood_scale", "p_comment" "text", "p_add_to_wall" boolean) OWNER TO "postgres";


COMMENT ON FUNCTION "public"."mood_submit"("p_home_id" "uuid", "p_mood" "public"."mood_scale", "p_comment" "text", "p_add_to_wall" boolean) IS 'Submit the current user''s weekly mood for a home. Enforces one entry per user per ISO week across all homes. Optionally creates a gratitude wall post when mood is positive (sunny/partially_sunny) and p_add_to_wall is true. Parameters: p_home_id (home ID), p_mood (mood_scale value), p_comment (optional text), p_add_to_wall (whether to post to gratitude wall). Returns: entry_id (mood entry ID), gratitude_post_id (ID of created gratitude wall post, or NULL).';



CREATE OR REPLACE FUNCTION "public"."profile_identity_update"("p_username" "public"."citext", "p_avatar_id" "uuid") RETURNS TABLE("username" "public"."citext", "avatar_id" "uuid", "avatar_storage_path" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $_$
DECLARE
  -- 3–30 chars, start/end alnum, middle may contain . or _
  v_re              text := '^[A-Za-z0-9][A-Za-z0-9._]{1,28}[A-Za-z0-9]$';
  v_user            uuid := auth.uid();
  v_home_id         uuid;
  v_plan            text;
  v_avatar_category text;
BEGIN
  PERFORM public._assert_authenticated();

  --------------------------------------------------------------------
  -- 1. Validate username shape
  --------------------------------------------------------------------
  IF p_username IS NULL OR p_username !~ v_re THEN
    PERFORM public.api_error(
      'INVALID_USERNAME',
      'Username must be 3–30 chars, start/end with letter/number, may contain . or _',
      '22000'
    );
  END IF;

  --------------------------------------------------------------------
  -- 2. Ensure avatar exists + get its category
  --------------------------------------------------------------------
  SELECT a.category
  INTO v_avatar_category
  FROM public.avatars a
  WHERE a.id = p_avatar_id;

  IF NOT FOUND THEN
    PERFORM public.api_error(
      'AVATAR_NOT_FOUND',
      'Selected avatar does not exist.',
      '22000',
      jsonb_build_object('avatar_id', p_avatar_id)
    );
  END IF;

  --------------------------------------------------------------------
  -- 3. Derive current home (if any) and enforce plan + uniqueness
  --------------------------------------------------------------------
  SELECT m.home_id
  INTO v_home_id
  FROM public.memberships m
  WHERE m.user_id = v_user
    AND m.is_current = TRUE
  LIMIT 1;

  IF v_home_id IS NOT NULL THEN
    -- Use shared helper for effective plan (same logic as avatars_list_for_home)
    v_plan := public._home_effective_plan(v_home_id);

    -- Plan gating: free homes can only use 'animal' avatars
    IF v_plan = 'free' AND v_avatar_category <> 'animal' THEN
      PERFORM public.api_error(
        'AVATAR_NOT_ALLOWED_FOR_PLAN',
        'This avatar is not available on the free plan for your home.',
        '22000',
        jsonb_build_object(
          'avatar_id', p_avatar_id,
          'home_id',   v_home_id,
          'plan',      v_plan
        )
      );
    END IF;

    -- Uniqueness within this home: no other current member uses this avatar
    PERFORM 1
    FROM public.memberships m
    JOIN public.profiles  p
      ON p.id = m.user_id
    WHERE m.home_id = v_home_id
      AND m.is_current = TRUE
      AND p.deactivated_at IS NULL
      AND p.avatar_id = p_avatar_id
      AND p.id <> v_user;

    IF FOUND THEN
      PERFORM public.api_error(
        'AVATAR_IN_USE',
        'This avatar is already used by another current member of your home.',
        '22000',
        jsonb_build_object(
          'avatar_id', p_avatar_id,
          'home_id',   v_home_id
        )
      );
    END IF;
  END IF;

  --------------------------------------------------------------------
  -- 4. Perform update, handling "no active profile" + username clash
  --------------------------------------------------------------------
  BEGIN
    UPDATE public.profiles
    SET
      username   = p_username,
      avatar_id  = p_avatar_id,
      updated_at = now()
    WHERE id = v_user
      AND deactivated_at IS NULL;

    IF NOT FOUND THEN
      PERFORM public.api_error(
        'PROFILE_NOT_FOUND',
        'Active profile not found for current user.',
        '22000'
      );
    END IF;

  EXCEPTION
    WHEN unique_violation THEN
      -- assumes a unique index on profiles(username)
      PERFORM public.api_error(
        'USERNAME_TAKEN',
        'This username is already in use.',
        '23505'
      );
  END;

  --------------------------------------------------------------------
  -- 5. Return updated identity
  --------------------------------------------------------------------
  RETURN QUERY
  SELECT
    p.username,
    p.avatar_id,
    a.storage_path
  FROM public.profiles p
  JOIN public.avatars a
    ON a.id = p.avatar_id
  WHERE p.id = v_user
    AND p.deactivated_at IS NULL;
END;
$_$;


ALTER FUNCTION "public"."profile_identity_update"("p_username" "public"."citext", "p_avatar_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."profile_me"() RETURNS TABLE("user_id" "uuid", "username" "public"."citext", "avatar_storage_path" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
  PERFORM public._assert_authenticated();

  RETURN QUERY
  SELECT
    p.id           AS user_id,
    p.username     AS username,
    a.storage_path AS avatar_storage_path
  FROM public.profiles p
  JOIN public.avatars a
    ON a.id = p.avatar_id
  WHERE p.id = auth.uid()
    AND p.deactivated_at IS NULL;
END;
$$;


ALTER FUNCTION "public"."profile_me"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."today_flow_list"("p_home_id" "uuid", "p_state" "public"."chore_state") RETURNS TABLE("id" "uuid", "home_id" "uuid", "name" "text", "start_date" "date", "state" "public"."chore_state")
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
  SELECT
    id,
    home_id,
    name,
    current_due_date AS start_date,
    state
  FROM public._chores_base_for_home(p_home_id)
  WHERE
    state = p_state
    AND current_due_date <= current_date  -- due today or overdue
    AND (
      -- 🟩 ACTIVE: only creator sees it
      (p_state = 'draft'::public.chore_state
       AND created_by_user_id = auth.uid())

      -- 🟦 DRAFT: only assignee sees it
      OR
      (p_state = 'active'::public.chore_state
       AND assignee_user_id = auth.uid())
    )
  ORDER BY
    current_due_date ASC,
    created_at      ASC;
$$;


ALTER FUNCTION "public"."today_flow_list"("p_home_id" "uuid", "p_state" "public"."chore_state") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."user_subscriptions_home_entitlements_trigger"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
  -- INSERT: new subscription row created
  IF TG_OP = 'INSERT' THEN
    IF NEW.home_id IS NOT NULL THEN
      PERFORM public.home_entitlements_refresh(NEW.home_id);
    END IF;

  -- UPDATE: subscription row changed
  ELSIF TG_OP = 'UPDATE' THEN
    -- Case 1: home_id changed (e.g. detach from one home, attach to another)
    IF NEW.home_id IS DISTINCT FROM OLD.home_id THEN
      -- Old home may have lost funding
      IF OLD.home_id IS NOT NULL THEN
        PERFORM public.home_entitlements_refresh(OLD.home_id);
      END IF;

      -- New home may have gained funding
      IF NEW.home_id IS NOT NULL THEN
        PERFORM public.home_entitlements_refresh(NEW.home_id);
      END IF;

    -- Case 2: same home_id, but status/expiry changed
    ELSIF NEW.status IS DISTINCT FROM OLD.status
       OR NEW.current_period_end_at IS DISTINCT FROM OLD.current_period_end_at THEN
      IF NEW.home_id IS NOT NULL THEN
        PERFORM public.home_entitlements_refresh(NEW.home_id);
      END IF;
    END IF;

  -- DELETE: subscription row removed
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.home_id IS NOT NULL THEN
      PERFORM public.home_entitlements_refresh(OLD.home_id);
    END IF;
  END IF;

  -- AFTER trigger: we don't modify the row itself
  RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."user_subscriptions_home_entitlements_trigger"() OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."analytics_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "home_id" "uuid",
    "event_type" "text" NOT NULL,
    "occurred_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "metadata" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL
);


ALTER TABLE "public"."analytics_events" OWNER TO "postgres";


COMMENT ON TABLE "public"."analytics_events" IS 'Append-only log of user/home actions for product analytics; written via RPCs.';



COMMENT ON COLUMN "public"."analytics_events"."user_id" IS 'User responsible for the event (the actor).';



COMMENT ON COLUMN "public"."analytics_events"."home_id" IS 'Home involved in the event, if any; NULL for global/user-only events.';



COMMENT ON COLUMN "public"."analytics_events"."event_type" IS 'Logical event type identifier (e.g., home.created, home.left, legal_consent.accepted).';



COMMENT ON COLUMN "public"."analytics_events"."occurred_at" IS 'Timestamp when the event occurred.';



COMMENT ON COLUMN "public"."analytics_events"."metadata" IS 'Optional JSON payload with additional details for this event.';



CREATE TABLE IF NOT EXISTS "public"."app_version" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "version_number" "text" NOT NULL,
    "min_supported_version" "text" NOT NULL,
    "is_current" boolean DEFAULT false NOT NULL,
    "release_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "notes" "text",
    CONSTRAINT "chk_min_supported" CHECK (("min_supported_version" ~ '^\d+\.\d+\.\d+$'::"text")),
    CONSTRAINT "chk_version_number" CHECK (("version_number" ~ '^\d+\.\d+\.\d+$'::"text"))
);


ALTER TABLE "public"."app_version" OWNER TO "postgres";


COMMENT ON TABLE "public"."app_version" IS 'Manually maintained table of app versions. The app checks this table at startup to know if the client is outdated.';



COMMENT ON COLUMN "public"."app_version"."min_supported_version" IS 'Minimum version allowed to run. Clients below this version will be blocked.';



CREATE TABLE IF NOT EXISTS "public"."avatars" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "storage_path" "text" NOT NULL,
    "category" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" DEFAULT 'Unnamed Avatar'::"text" NOT NULL,
    CONSTRAINT "avatars_category_check" CHECK (("category" = ANY (ARRAY['animal'::"text", 'plant'::"text"])))
);


ALTER TABLE "public"."avatars" OWNER TO "postgres";


COMMENT ON TABLE "public"."avatars" IS 'Avatars: image metadata for user profile pictures.';



COMMENT ON COLUMN "public"."avatars"."storage_path" IS 'Storage bucket/path or object key.';



COMMENT ON COLUMN "public"."avatars"."category" IS 'Logical grouping, e.g., "animal" (starter pack), "plant", etc.';



COMMENT ON COLUMN "public"."avatars"."created_at" IS 'Creation timestamp (UTC).';



COMMENT ON COLUMN "public"."avatars"."name" IS 'Human-readable name describing what this avatar is about.';



COMMENT ON CONSTRAINT "avatars_category_check" ON "public"."avatars" IS 'Restricts category to only "animal" or "plant".';



CREATE TABLE IF NOT EXISTS "public"."chore_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "chore_id" "uuid" NOT NULL,
    "home_id" "uuid" NOT NULL,
    "actor_user_id" "uuid" NOT NULL,
    "event_type" "public"."chore_event_type" NOT NULL,
    "from_state" "public"."chore_state",
    "to_state" "public"."chore_state",
    "payload" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "occurred_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."chore_events" OWNER TO "postgres";


COMMENT ON TABLE "public"."chore_events" IS 'Append-only audit log for chore lifecycle transitions.';



COMMENT ON COLUMN "public"."chore_events"."home_id" IS 'Denormalised home id for easier filtering.';



COMMENT ON COLUMN "public"."chore_events"."actor_user_id" IS 'User who triggered the event.';



COMMENT ON COLUMN "public"."chore_events"."from_state" IS 'Previous state.';



COMMENT ON COLUMN "public"."chore_events"."to_state" IS 'New state.';



COMMENT ON COLUMN "public"."chore_events"."payload" IS 'Structured diff / metadata.';



COMMENT ON COLUMN "public"."chore_events"."occurred_at" IS 'Timestamp of event.';



CREATE TABLE IF NOT EXISTS "public"."gratitude_wall_posts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "home_id" "uuid" NOT NULL,
    "author_user_id" "uuid" NOT NULL,
    "mood" "public"."mood_scale" NOT NULL,
    "message" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_gratitude_wall_posts_message_len" CHECK ((("message" IS NULL) OR ("char_length"("message") <= 500)))
);


ALTER TABLE "public"."gratitude_wall_posts" OWNER TO "postgres";


COMMENT ON TABLE "public"."gratitude_wall_posts" IS 'Immutable gratitude messages shared on the home gratitude wall.';



COMMENT ON COLUMN "public"."gratitude_wall_posts"."id" IS 'Unique identifier for the gratitude wall post.';



COMMENT ON COLUMN "public"."gratitude_wall_posts"."home_id" IS 'ID of the home this gratitude post belongs to.';



COMMENT ON COLUMN "public"."gratitude_wall_posts"."author_user_id" IS 'Profile ID of the user who authored this gratitude post.';



COMMENT ON COLUMN "public"."gratitude_wall_posts"."mood" IS 'Mood selected when the gratitude post was created (from mood_scale).';



COMMENT ON COLUMN "public"."gratitude_wall_posts"."message" IS 'User-supplied gratitude message. May be NULL when no text was provided. Max 500 characters.';



COMMENT ON COLUMN "public"."gratitude_wall_posts"."created_at" IS 'Timestamp when this gratitude post was created.';



CREATE TABLE IF NOT EXISTS "public"."gratitude_wall_reads" (
    "home_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "last_read_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."gratitude_wall_reads" OWNER TO "postgres";


COMMENT ON TABLE "public"."gratitude_wall_reads" IS 'Tracks when each user last read the gratitude wall for a given home.';



COMMENT ON COLUMN "public"."gratitude_wall_reads"."home_id" IS 'ID of the home whose gratitude wall is being tracked.';



COMMENT ON COLUMN "public"."gratitude_wall_reads"."user_id" IS 'Profile ID of the user whose last read time is stored.';



COMMENT ON COLUMN "public"."gratitude_wall_reads"."last_read_at" IS 'Timestamp when the user last marked the gratitude wall as read for this home.';



CREATE TABLE IF NOT EXISTS "public"."home_entitlements" (
    "home_id" "uuid" NOT NULL,
    "plan" "text" DEFAULT 'free'::"text" NOT NULL,
    "expires_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "home_entitlements_plan_check" CHECK (("plan" = ANY (ARRAY['free'::"text", 'premium'::"text"])))
);


ALTER TABLE "public"."home_entitlements" OWNER TO "postgres";


COMMENT ON TABLE "public"."home_entitlements" IS 'Cached subscription status per home (free vs premium) for fast paywall checks.';



COMMENT ON COLUMN "public"."home_entitlements"."plan" IS 'Logical plan for the home: free | premium.';



COMMENT ON COLUMN "public"."home_entitlements"."expires_at" IS 'Optional max expiration among supporting subscriptions; NULL means indefinite or unknown.';



CREATE TABLE IF NOT EXISTS "public"."home_mood_entries" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "home_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "mood" "public"."mood_scale" NOT NULL,
    "comment" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "iso_week_year" integer NOT NULL,
    "iso_week" integer NOT NULL,
    "gratitude_post_id" "uuid",
    CONSTRAINT "chk_home_mood_entries_comment_len" CHECK ((("comment" IS NULL) OR ("char_length"("comment") <= 500)))
);


ALTER TABLE "public"."home_mood_entries" OWNER TO "postgres";


COMMENT ON TABLE "public"."home_mood_entries" IS 'Weekly mood capture per user (one entry per ISO week across all homes; home_id records which home they were in).';



COMMENT ON COLUMN "public"."home_mood_entries"."id" IS 'Unique identifier for the mood entry.';



COMMENT ON COLUMN "public"."home_mood_entries"."home_id" IS 'ID of the home this mood entry is associated with.';



COMMENT ON COLUMN "public"."home_mood_entries"."user_id" IS 'Profile ID of the user whose mood is recorded in this entry.';



COMMENT ON COLUMN "public"."home_mood_entries"."mood" IS 'Mood selected by the user for this ISO week (from mood_scale).';



COMMENT ON COLUMN "public"."home_mood_entries"."comment" IS 'Optional user comment about how the home feels this week. May be NULL. Max 500 characters.';



COMMENT ON COLUMN "public"."home_mood_entries"."created_at" IS 'Timestamp when this mood entry was created.';



COMMENT ON COLUMN "public"."home_mood_entries"."iso_week_year" IS 'ISO year number for this mood entry (e.g. 2025).';



COMMENT ON COLUMN "public"."home_mood_entries"."iso_week" IS 'ISO week number for this mood entry (1–53).';



COMMENT ON COLUMN "public"."home_mood_entries"."gratitude_post_id" IS 'Optional link to a gratitude wall post created from this mood entry (if the user chose to share).';



CREATE TABLE IF NOT EXISTS "public"."home_mood_feedback_counters" (
    "home_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "feedback_count" integer DEFAULT 0 NOT NULL,
    "first_feedback_at" timestamp with time zone,
    "last_feedback_at" timestamp with time zone,
    "last_nps_at" timestamp with time zone,
    "last_nps_score" integer,
    "last_nps_feedback_count" integer DEFAULT 0 NOT NULL,
    "nps_required" boolean DEFAULT false NOT NULL,
    CONSTRAINT "chk_home_mood_feedback_counters_last_nps_score" CHECK ((("last_nps_score" IS NULL) OR (("last_nps_score" >= 0) AND ("last_nps_score" <= 10))))
);


ALTER TABLE "public"."home_mood_feedback_counters" OWNER TO "postgres";


COMMENT ON TABLE "public"."home_mood_feedback_counters" IS 'Per-home per-user counters for Harmony feedback and NPS state.';



COMMENT ON COLUMN "public"."home_mood_feedback_counters"."feedback_count" IS 'Total number of mood feedback entries submitted by this user in this home.';



COMMENT ON COLUMN "public"."home_mood_feedback_counters"."last_nps_feedback_count" IS 'Feedback_count value at which the last NPS was completed (0 = never).';



COMMENT ON COLUMN "public"."home_mood_feedback_counters"."nps_required" IS 'TRUE when an NPS answer is required and must be completed before normal use.';



CREATE TABLE IF NOT EXISTS "public"."home_plan_limits" (
    "plan" "text" NOT NULL,
    "metric" "public"."home_usage_metric" NOT NULL,
    "max_value" integer NOT NULL,
    CONSTRAINT "home_plan_limits_max_value_check" CHECK (("max_value" >= 0)),
    CONSTRAINT "home_plan_limits_plan_not_blank" CHECK (("btrim"("plan") <> ''::"text"))
);


ALTER TABLE "public"."home_plan_limits" OWNER TO "postgres";


COMMENT ON TABLE "public"."home_plan_limits" IS 'Per-plan limits for home usage metrics (e.g. free vs premium).';



COMMENT ON COLUMN "public"."home_plan_limits"."plan" IS 'Logical plan name (e.g. free, premium).';



COMMENT ON COLUMN "public"."home_plan_limits"."metric" IS 'Usage metric being limited (active_chores, chore_photos, active_members).';



COMMENT ON COLUMN "public"."home_plan_limits"."max_value" IS 'Maximum allowed value for this metric on this plan.';



CREATE TABLE IF NOT EXISTS "public"."homes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "deactivated_at" timestamp with time zone,
    CONSTRAINT "chk_homes_active_vs_deactivated_at" CHECK (((("deactivated_at" IS NULL) AND ("is_active" = true)) OR (("deactivated_at" IS NOT NULL) AND ("is_active" = false))))
);


ALTER TABLE "public"."homes" OWNER TO "postgres";


COMMENT ON TABLE "public"."homes" IS 'Top-level container for collaboration within a household.';



COMMENT ON COLUMN "public"."homes"."owner_user_id" IS 'User ID of the home owner (FK to profiles.id).';



COMMENT ON COLUMN "public"."homes"."created_at" IS 'Date when the home was first created.';



COMMENT ON COLUMN "public"."homes"."updated_at" IS 'Date when the home details were last updated.';



COMMENT ON COLUMN "public"."homes"."is_active" IS 'Indicates if the home is currently active.';



COMMENT ON COLUMN "public"."homes"."deactivated_at" IS 'Timestamp when the home was deactivated.';



CREATE TABLE IF NOT EXISTS "public"."memberships" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "home_id" "uuid" NOT NULL,
    "role" "text" NOT NULL,
    "valid_from" timestamp with time zone DEFAULT "now"() NOT NULL,
    "valid_to" timestamp with time zone,
    "is_current" boolean GENERATED ALWAYS AS (("valid_to" IS NULL)) STORED,
    "validity" "tstzrange" GENERATED ALWAYS AS ("tstzrange"("valid_from", COALESCE("valid_to", 'infinity'::timestamp with time zone), '[)'::"text")) STORED,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "memberships_role_check" CHECK (("role" = ANY (ARRAY['owner'::"text", 'member'::"text"])))
);


ALTER TABLE "public"."memberships" OWNER TO "postgres";


COMMENT ON TABLE "public"."memberships" IS 'Each row is one “stint” of a user in a home (with a role) and a start/end window; history preserved.';



COMMENT ON COLUMN "public"."memberships"."id" IS 'Surrogate key for the stint row.';



COMMENT ON COLUMN "public"."memberships"."user_id" IS 'FK to profiles.id; identifies the person holding this membership stint.';



COMMENT ON COLUMN "public"."memberships"."home_id" IS 'FK to homes.id; the home this stint is associated with.';



COMMENT ON COLUMN "public"."memberships"."role" IS 'Role during this stint: only "owner" or "member".';



COMMENT ON COLUMN "public"."memberships"."valid_from" IS 'Inclusive start timestamp for the stint.';



COMMENT ON COLUMN "public"."memberships"."valid_to" IS 'Exclusive end timestamp; NULL means the stint is still current.';



COMMENT ON COLUMN "public"."memberships"."is_current" IS 'Computed: TRUE when valid_to IS NULL. Do not update directly.';



COMMENT ON COLUMN "public"."memberships"."validity" IS 'Generated tstzrange of [valid_from, valid_to) (infinity if open) for overlap checks.';



COMMENT ON COLUMN "public"."memberships"."created_at" IS 'Audit timestamp when the row was created.';



COMMENT ON COLUMN "public"."memberships"."updated_at" IS 'Audit timestamp of the most recent update to the row.';



CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "email" "text",
    "full_name" "text",
    "avatar_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deactivated_at" timestamp with time zone,
    "username" "public"."citext" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_profiles_username_format" CHECK (("username" OPERATOR("public".~) '^[a-z0-9](?:[a-z0-9._]{1,28})[a-z0-9]$'::"public"."citext"))
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


COMMENT ON TABLE "public"."profiles" IS 'App-facing persona mirroring auth.users by id (1:1).';



COMMENT ON COLUMN "public"."profiles"."id" IS 'Primary key = auth.users.id..';



COMMENT ON COLUMN "public"."profiles"."email" IS 'Optional user email address mirrored from auth.users.email. May be NULL for privacy or deleted accounts. Remains UNIQUE when present.';



COMMENT ON COLUMN "public"."profiles"."full_name" IS 'Optional display name.';



COMMENT ON COLUMN "public"."profiles"."avatar_id" IS 'FK to public.avatars.id (required avatar).';



COMMENT ON COLUMN "public"."profiles"."created_at" IS 'Profile creation timestamp (UTC).';



COMMENT ON COLUMN "public"."profiles"."deactivated_at" IS 'Timestamp when the user deactivated or left the app. NULL = currently active. Used for soft-deletion and retention tracking.';



COMMENT ON COLUMN "public"."profiles"."username" IS 'Case-insensitive unique handle for user identification and @mentions. Must be 3–30 chars long, start/end with a letter or number, and may contain dots or underscores in between. Used for tagging (e.g., @username) and public display names.';



COMMENT ON COLUMN "public"."profiles"."updated_at" IS 'Profile updated timestamp (UTC).';



COMMENT ON CONSTRAINT "chk_profiles_username_format" ON "public"."profiles" IS 'Enforces username format: 3–30 chars, lowercase letters, digits, dots, or underscores. Must start and end with a letter or number.';



CREATE TABLE IF NOT EXISTS "public"."reserved_usernames" (
    "name" "public"."citext" NOT NULL
);


ALTER TABLE "public"."reserved_usernames" OWNER TO "postgres";


COMMENT ON TABLE "public"."reserved_usernames" IS 'Case-insensitive blocklist of usernames that users are not allowed to claim (e.g., admin, support).';



COMMENT ON COLUMN "public"."reserved_usernames"."name" IS 'Reserved handle (CITEXT). Comparisons and PK uniqueness are case-insensitive.';



CREATE TABLE IF NOT EXISTS "public"."shared_preferences" (
    "user_id" "uuid" NOT NULL,
    "pref_key" "text" NOT NULL,
    "pref_value" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."shared_preferences" OWNER TO "postgres";


COMMENT ON TABLE "public"."shared_preferences" IS 'Per-user key/value preferences (current state only); accessed via RPCs, not direct client DML.';



COMMENT ON COLUMN "public"."shared_preferences"."user_id" IS 'Owner of the preference; references profiles(id).';



COMMENT ON COLUMN "public"."shared_preferences"."pref_key" IS 'Preference key (namespaced, e.g., legal.consent.v1, tutorial.free_upload_camera.v1).';



COMMENT ON COLUMN "public"."shared_preferences"."pref_value" IS 'Preference value as JSONB (boolean, number, string, or structured object).';



COMMENT ON COLUMN "public"."shared_preferences"."created_at" IS 'Timestamp when this preference row was first created.';



COMMENT ON COLUMN "public"."shared_preferences"."updated_at" IS 'Timestamp when this preference row was last updated.';



CREATE TABLE IF NOT EXISTS "public"."user_subscriptions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "home_id" "uuid",
    "store" "public"."subscription_store" NOT NULL,
    "rc_app_user_id" "text" NOT NULL,
    "rc_entitlement_id" "text" NOT NULL,
    "product_id" "text" NOT NULL,
    "status" "public"."subscription_status" NOT NULL,
    "current_period_end_at" timestamp with time zone,
    "original_purchase_at" timestamp with time zone,
    "last_purchase_at" timestamp with time zone,
    "latest_transaction_id" "text",
    "last_synced_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."user_subscriptions" OWNER TO "postgres";


COMMENT ON TABLE "public"."user_subscriptions" IS 'Per-user subscription entitlement snapshot from RevenueCat, tied to a single home and entitlement.';



COMMENT ON COLUMN "public"."user_subscriptions"."user_id" IS 'Paying user (canonical Supabase profile).';



COMMENT ON COLUMN "public"."user_subscriptions"."home_id" IS 'Home whose premium is funded by this subscription (if home-scoped).';



COMMENT ON COLUMN "public"."user_subscriptions"."store" IS 'Store / source of the subscription (app_store, play_store, stripe, promotional).';



COMMENT ON COLUMN "public"."user_subscriptions"."rc_app_user_id" IS 'Latest RevenueCat app_user_id associated with this user/entitlement.';



COMMENT ON COLUMN "public"."user_subscriptions"."rc_entitlement_id" IS 'RevenueCat entitlement identifier, e.g. home_premium.';



COMMENT ON COLUMN "public"."user_subscriptions"."product_id" IS 'Store product id that most recently granted this entitlement.';



COMMENT ON COLUMN "public"."user_subscriptions"."status" IS 'Subscription state snapshot mapped from RevenueCat.';



COMMENT ON COLUMN "public"."user_subscriptions"."current_period_end_at" IS 'End of the current entitlement period (from RevenueCat).';



COMMENT ON COLUMN "public"."user_subscriptions"."last_synced_at" IS 'Timestamp when this row was last updated from RevenueCat.';



ALTER TABLE ONLY "public"."analytics_events"
    ADD CONSTRAINT "analytics_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."app_version"
    ADD CONSTRAINT "app_version_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."avatars"
    ADD CONSTRAINT "avatars_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chore_events"
    ADD CONSTRAINT "chore_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chores"
    ADD CONSTRAINT "chores_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."expenses"
    ADD CONSTRAINT "expenses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."gratitude_wall_posts"
    ADD CONSTRAINT "gratitude_wall_posts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."home_entitlements"
    ADD CONSTRAINT "home_entitlements_pkey" PRIMARY KEY ("home_id");



ALTER TABLE ONLY "public"."home_mood_entries"
    ADD CONSTRAINT "home_mood_entries_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."home_nps"
    ADD CONSTRAINT "home_nps_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."home_plan_limits"
    ADD CONSTRAINT "home_plan_limits_pkey" PRIMARY KEY ("plan", "metric");



ALTER TABLE ONLY "public"."home_usage_counters"
    ADD CONSTRAINT "home_usage_counters_pkey" PRIMARY KEY ("home_id");



ALTER TABLE ONLY "public"."homes"
    ADD CONSTRAINT "homes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."invites"
    ADD CONSTRAINT "invites_code_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."invites"
    ADD CONSTRAINT "invites_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."memberships"
    ADD CONSTRAINT "memberships_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."memberships"
    ADD CONSTRAINT "no_overlap_per_user_home" EXCLUDE USING "gist" ("user_id" WITH =, "home_id" WITH =, "validity" WITH &&);



COMMENT ON CONSTRAINT "no_overlap_per_user_home" ON "public"."memberships" IS 'Prevents overlapping validity windows for the same user in the same home.';



ALTER TABLE ONLY "public"."expense_splits"
    ADD CONSTRAINT "pk_expense_splits" PRIMARY KEY ("expense_id", "debtor_user_id");



ALTER TABLE ONLY "public"."gratitude_wall_reads"
    ADD CONSTRAINT "pk_gratitude_wall_reads" PRIMARY KEY ("home_id", "user_id");



ALTER TABLE ONLY "public"."home_mood_feedback_counters"
    ADD CONSTRAINT "pk_home_mood_feedback_counters" PRIMARY KEY ("home_id", "user_id");



ALTER TABLE ONLY "public"."shared_preferences"
    ADD CONSTRAINT "pk_shared_preferences" PRIMARY KEY ("user_id", "pref_key");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reserved_usernames"
    ADD CONSTRAINT "reserved_usernames_pkey" PRIMARY KEY ("name");



ALTER TABLE ONLY "public"."app_version"
    ADD CONSTRAINT "uq_app_version" UNIQUE ("version_number");



ALTER TABLE ONLY "public"."home_mood_entries"
    ADD CONSTRAINT "uq_home_mood_entries_user_week" UNIQUE ("user_id", "iso_week_year", "iso_week");



ALTER TABLE ONLY "public"."user_subscriptions"
    ADD CONSTRAINT "user_subscriptions_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_analytics_events_home_event_time" ON "public"."analytics_events" USING "btree" ("home_id", "event_type", "occurred_at");



CREATE INDEX "idx_analytics_events_user_event_time" ON "public"."analytics_events" USING "btree" ("user_id", "event_type", "occurred_at");



CREATE INDEX "idx_chore_events_chore" ON "public"."chore_events" USING "btree" ("chore_id", "occurred_at" DESC);



CREATE INDEX "idx_chore_events_event_type" ON "public"."chore_events" USING "btree" ("event_type", "occurred_at" DESC);



CREATE INDEX "idx_chore_events_home" ON "public"."chore_events" USING "btree" ("home_id", "occurred_at" DESC);



CREATE INDEX "idx_chores_home_next_occurrence" ON "public"."chores" USING "btree" ("home_id", "next_occurrence", "created_at" DESC);



CREATE INDEX "idx_expense_splits_debtor_status" ON "public"."expense_splits" USING "btree" ("debtor_user_id", "status");



CREATE INDEX "idx_expense_splits_expense" ON "public"."expense_splits" USING "btree" ("expense_id");



CREATE INDEX "idx_expenses_creator_created_at" ON "public"."expenses" USING "btree" ("created_by_user_id", "home_id", "created_at" DESC);



CREATE INDEX "idx_expenses_home_status_created_at" ON "public"."expenses" USING "btree" ("home_id", "status", "created_at" DESC);



CREATE INDEX "idx_gratitude_wall_posts_home_created_desc" ON "public"."gratitude_wall_posts" USING "btree" ("home_id", "created_at" DESC, "id" DESC);



CREATE INDEX "idx_home_mood_entries_home_user" ON "public"."home_mood_entries" USING "btree" ("home_id", "user_id");



CREATE INDEX "idx_home_mood_entries_user_week" ON "public"."home_mood_entries" USING "btree" ("user_id", "iso_week_year", "iso_week");



CREATE INDEX "idx_home_nps_home_created_desc" ON "public"."home_nps" USING "btree" ("home_id", "created_at" DESC, "id" DESC);



CREATE INDEX "idx_invites_code_active" ON "public"."invites" USING "btree" ("code") WHERE ("revoked_at" IS NULL);



COMMENT ON INDEX "public"."idx_invites_code_active" IS 'Optimizes lookups for active (non-revoked) invite codes.';



CREATE UNIQUE INDEX "uq_app_version_is_current_true" ON "public"."app_version" USING "btree" ((true)) WHERE "is_current";



CREATE UNIQUE INDEX "uq_invites_active_one_per_home" ON "public"."invites" USING "btree" ("home_id") WHERE ("revoked_at" IS NULL);



CREATE UNIQUE INDEX "uq_memberships_home_one_current_owner" ON "public"."memberships" USING "btree" ("home_id") WHERE ("is_current" AND ("role" = 'owner'::"text"));



COMMENT ON INDEX "public"."uq_memberships_home_one_current_owner" IS 'Guarantees a home has at most one current owner stint.';



CREATE UNIQUE INDEX "uq_memberships_user_one_current" ON "public"."memberships" USING "btree" ("user_id") WHERE "is_current";



COMMENT ON INDEX "public"."uq_memberships_user_one_current" IS 'Guarantees a user has at most one current membership stint across all homes.';



CREATE UNIQUE INDEX "uq_profiles_username" ON "public"."profiles" USING "btree" ("username");



COMMENT ON INDEX "public"."uq_profiles_username" IS 'Ensures each username is globally unique (case-insensitive).';



CREATE INDEX "user_subscriptions_by_home_status" ON "public"."user_subscriptions" USING "btree" ("home_id", "rc_entitlement_id", "status", "current_period_end_at");



CREATE UNIQUE INDEX "user_subscriptions_user_entitlement_uniq" ON "public"."user_subscriptions" USING "btree" ("user_id", "rc_entitlement_id");



CREATE OR REPLACE TRIGGER "chores_events_trigger" AFTER INSERT OR DELETE OR UPDATE ON "public"."chores" FOR EACH ROW EXECUTE FUNCTION "public"."chores_events_trigger"();



CREATE OR REPLACE TRIGGER "trg_home_mood_feedback_counters_inc" AFTER INSERT ON "public"."home_mood_entries" FOR EACH ROW EXECUTE FUNCTION "public"."home_mood_feedback_counters_inc"();



CREATE OR REPLACE TRIGGER "user_subscriptions_home_entitlements_trg" AFTER INSERT OR DELETE OR UPDATE ON "public"."user_subscriptions" FOR EACH ROW EXECUTE FUNCTION "public"."user_subscriptions_home_entitlements_trigger"();



ALTER TABLE ONLY "public"."analytics_events"
    ADD CONSTRAINT "analytics_events_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."analytics_events"
    ADD CONSTRAINT "analytics_events_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chore_events"
    ADD CONSTRAINT "chore_events_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "public"."profiles"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."chore_events"
    ADD CONSTRAINT "chore_events_chore_id_fkey" FOREIGN KEY ("chore_id") REFERENCES "public"."chores"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chore_events"
    ADD CONSTRAINT "chore_events_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chores"
    ADD CONSTRAINT "chores_assignee_user_id_fkey" FOREIGN KEY ("assignee_user_id") REFERENCES "public"."profiles"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."chores"
    ADD CONSTRAINT "chores_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chores"
    ADD CONSTRAINT "chores_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."expense_splits"
    ADD CONSTRAINT "expense_splits_debtor_user_id_fkey" FOREIGN KEY ("debtor_user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."expense_splits"
    ADD CONSTRAINT "expense_splits_expense_id_fkey" FOREIGN KEY ("expense_id") REFERENCES "public"."expenses"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."expenses"
    ADD CONSTRAINT "expenses_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."expenses"
    ADD CONSTRAINT "expenses_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."gratitude_wall_posts"
    ADD CONSTRAINT "gratitude_wall_posts_author_user_id_fkey" FOREIGN KEY ("author_user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."gratitude_wall_posts"
    ADD CONSTRAINT "gratitude_wall_posts_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."gratitude_wall_reads"
    ADD CONSTRAINT "gratitude_wall_reads_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."gratitude_wall_reads"
    ADD CONSTRAINT "gratitude_wall_reads_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_entitlements"
    ADD CONSTRAINT "home_entitlements_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_mood_entries"
    ADD CONSTRAINT "home_mood_entries_gratitude_post_id_fkey" FOREIGN KEY ("gratitude_post_id") REFERENCES "public"."gratitude_wall_posts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."home_mood_entries"
    ADD CONSTRAINT "home_mood_entries_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_mood_entries"
    ADD CONSTRAINT "home_mood_entries_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_mood_feedback_counters"
    ADD CONSTRAINT "home_mood_feedback_counters_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_mood_feedback_counters"
    ADD CONSTRAINT "home_mood_feedback_counters_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_nps"
    ADD CONSTRAINT "home_nps_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_nps"
    ADD CONSTRAINT "home_nps_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."home_usage_counters"
    ADD CONSTRAINT "home_usage_counters_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."homes"
    ADD CONSTRAINT "homes_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."invites"
    ADD CONSTRAINT "invites_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."memberships"
    ADD CONSTRAINT "memberships_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."memberships"
    ADD CONSTRAINT "memberships_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_avatar_id_fkey" FOREIGN KEY ("avatar_id") REFERENCES "public"."avatars"("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."shared_preferences"
    ADD CONSTRAINT "shared_preferences_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_subscriptions"
    ADD CONSTRAINT "user_subscriptions_home_id_fkey" FOREIGN KEY ("home_id") REFERENCES "public"."homes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_subscriptions"
    ADD CONSTRAINT "user_subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



ALTER TABLE "public"."analytics_events" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."app_version" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."avatars" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "avatars_select_authenticated" ON "public"."avatars" FOR SELECT USING ((( SELECT "auth"."uid"() AS "uid") IS NOT NULL));



ALTER TABLE "public"."chore_events" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."chores" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."expense_splits" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."expenses" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gratitude_wall_posts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."gratitude_wall_reads" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."home_entitlements" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."home_mood_entries" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."home_mood_feedback_counters" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."home_nps" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."home_plan_limits" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."home_usage_counters" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."homes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."invites" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."memberships" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "profiles_select_authenticated" ON "public"."profiles" FOR SELECT USING (("id" = ( SELECT "auth"."uid"() AS "uid")));



COMMENT ON POLICY "profiles_select_authenticated" ON "public"."profiles" IS 'Allows SELECT for authenticated users only (RLS enforced).';



ALTER TABLE "public"."reserved_usernames" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."shared_preferences" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_subscriptions" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";








GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."citextin"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."citextin"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."citextin"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citextin"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."citextout"("public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citextout"("public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citextout"("public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citextout"("public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citextrecv"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."citextrecv"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."citextrecv"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citextrecv"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."citextsend"("public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citextsend"("public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citextsend"("public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citextsend"("public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext"(boolean) TO "postgres";
GRANT ALL ON FUNCTION "public"."citext"(boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."citext"(boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext"(boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."citext"(character) TO "postgres";
GRANT ALL ON FUNCTION "public"."citext"(character) TO "anon";
GRANT ALL ON FUNCTION "public"."citext"(character) TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext"(character) TO "service_role";



GRANT ALL ON FUNCTION "public"."citext"("inet") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext"("inet") TO "anon";
GRANT ALL ON FUNCTION "public"."citext"("inet") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext"("inet") TO "service_role";




















































































































































































REVOKE ALL ON FUNCTION "public"."_assert_authenticated"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_assert_authenticated"() TO "service_role";



GRANT ALL ON FUNCTION "public"."_assert_home_active"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."_assert_home_active"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."_assert_home_active"("p_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_assert_home_member"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_assert_home_member"("p_home_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."_chores_base_for_home"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."_chores_base_for_home"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."_chores_base_for_home"("p_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_current_user_id"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_current_user_id"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."_ensure_unique_avatar_for_home"("p_home_id" "uuid", "p_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_ensure_unique_avatar_for_home"("p_home_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."_ensure_unique_avatar_for_home"("p_home_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."_ensure_unique_avatar_for_home"("p_home_id" "uuid", "p_user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_expenses_prepare_split_buffer"("p_home_id" "uuid", "p_creator_id" "uuid", "p_amount_cents" bigint, "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_expenses_prepare_split_buffer"("p_home_id" "uuid", "p_creator_id" "uuid", "p_amount_cents" bigint, "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_gen_invite_code"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_gen_invite_code"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."_gen_unique_username"("p_email" "text", "p_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_gen_unique_username"("p_email" "text", "p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."_gen_unique_username"("p_email" "text", "p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."_gen_unique_username"("p_email" "text", "p_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_home_assert_quota"("p_home_id" "uuid", "p_deltas" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_home_assert_quota"("p_home_id" "uuid", "p_deltas" "jsonb") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_home_attach_subscription_to_home"("_user_id" "uuid", "_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_home_attach_subscription_to_home"("_user_id" "uuid", "_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_home_detach_subscription_to_home"("_home_id" "uuid", "_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_home_detach_subscription_to_home"("_home_id" "uuid", "_user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_home_effective_plan"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_home_effective_plan"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."_home_effective_plan"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."_home_effective_plan"("p_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."_home_is_premium"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_home_is_premium"("p_home_id" "uuid") TO "service_role";



GRANT ALL ON TABLE "public"."home_usage_counters" TO "service_role";



REVOKE ALL ON FUNCTION "public"."_home_usage_apply_delta"("p_home_id" "uuid", "p_deltas" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."_home_usage_apply_delta"("p_home_id" "uuid", "p_deltas" "jsonb") TO "service_role";



REVOKE ALL ON FUNCTION "public"."api_assert"("p_condition" boolean, "p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."api_assert"("p_condition" boolean, "p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."api_assert"("p_condition" boolean, "p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."api_assert"("p_condition" boolean, "p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") TO "service_role";



REVOKE ALL ON FUNCTION "public"."api_error"("p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."api_error"("p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."api_error"("p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."api_error"("p_code" "text", "p_msg" "text", "p_sqlstate" "text", "p_details" "jsonb", "p_hint" "text") TO "service_role";



REVOKE ALL ON FUNCTION "public"."avatars_list_for_home"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."avatars_list_for_home"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."avatars_list_for_home"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."avatars_list_for_home"("p_home_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "postgres";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "anon";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "service_role";



REVOKE ALL ON FUNCTION "public"."check_app_version"("client_version" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."check_app_version"("client_version" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."check_app_version"("client_version" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_app_version"("client_version" "text") TO "service_role";



REVOKE ALL ON FUNCTION "public"."chore_complete"("_chore_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chore_complete"("_chore_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."chore_complete"("_chore_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."chores_cancel"("p_chore_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chores_cancel"("p_chore_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."chores_cancel"("p_chore_id" "uuid") TO "authenticated";



GRANT ALL ON TABLE "public"."chores" TO "service_role";



REVOKE ALL ON FUNCTION "public"."chores_create"("p_home_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_how_to_video_url" "text", "p_notes" "text", "p_expectation_photo_path" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chores_create"("p_home_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_how_to_video_url" "text", "p_notes" "text", "p_expectation_photo_path" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."chores_create"("p_home_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_how_to_video_url" "text", "p_notes" "text", "p_expectation_photo_path" "text") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."chores_events_trigger"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chores_events_trigger"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."chores_get_for_home"("p_home_id" "uuid", "p_chore_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chores_get_for_home"("p_home_id" "uuid", "p_chore_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."chores_get_for_home"("p_home_id" "uuid", "p_chore_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."chores_list_for_home"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chores_list_for_home"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."chores_list_for_home"("p_home_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."chores_reassign_on_member_leave"("v_home_id" "uuid", "v_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chores_reassign_on_member_leave"("v_home_id" "uuid", "v_user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."chores_update"("p_chore_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_expectation_photo_path" "text", "p_how_to_video_url" "text", "p_notes" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."chores_update"("p_chore_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_expectation_photo_path" "text", "p_how_to_video_url" "text", "p_notes" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."chores_update"("p_chore_id" "uuid", "p_name" "text", "p_assignee_user_id" "uuid", "p_start_date" "date", "p_recurrence" "public"."recurrence_interval", "p_expectation_photo_path" "text", "p_how_to_video_url" "text", "p_notes" "text") TO "authenticated";



GRANT ALL ON FUNCTION "public"."citext_cmp"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_cmp"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_cmp"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_cmp"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_eq"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_eq"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_eq"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_eq"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_ge"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_ge"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_ge"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_ge"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_gt"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_gt"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_gt"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_gt"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_hash"("public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_hash"("public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_hash"("public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_hash"("public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_hash_extended"("public"."citext", bigint) TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_hash_extended"("public"."citext", bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."citext_hash_extended"("public"."citext", bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_hash_extended"("public"."citext", bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_larger"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_larger"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_larger"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_larger"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_le"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_le"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_le"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_le"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_lt"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_lt"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_lt"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_lt"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_ne"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_ne"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_ne"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_ne"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_pattern_cmp"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_pattern_cmp"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_pattern_cmp"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_pattern_cmp"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_pattern_ge"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_pattern_ge"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_pattern_ge"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_pattern_ge"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_pattern_gt"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_pattern_gt"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_pattern_gt"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_pattern_gt"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_pattern_le"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_pattern_le"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_pattern_le"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_pattern_le"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_pattern_lt"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_pattern_lt"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_pattern_lt"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_pattern_lt"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."citext_smaller"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."citext_smaller"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."citext_smaller"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."citext_smaller"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "postgres";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "anon";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "service_role";



GRANT ALL ON TABLE "public"."expenses" TO "service_role";



REVOKE ALL ON FUNCTION "public"."expenses_cancel"("p_expense_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."expenses_cancel"("p_expense_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."expenses_cancel"("p_expense_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."expenses_create"("p_home_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."expenses_create"("p_home_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."expenses_create"("p_home_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."expenses_edit"("p_expense_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."expenses_edit"("p_expense_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."expenses_edit"("p_expense_id" "uuid", "p_amount_cents" bigint, "p_description" "text", "p_notes" "text", "p_split_mode" "public"."expense_split_type", "p_member_ids" "uuid"[], "p_splits" "jsonb") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."expenses_get_created_by_me"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."expenses_get_created_by_me"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."expenses_get_created_by_me"("p_home_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."expenses_get_current_owed"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."expenses_get_current_owed"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."expenses_get_current_owed"("p_home_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."expenses_get_for_edit"("p_expense_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."expenses_get_for_edit"("p_expense_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."expenses_get_for_edit"("p_expense_id" "uuid") TO "authenticated";



GRANT ALL ON TABLE "public"."expense_splits" TO "service_role";



REVOKE ALL ON FUNCTION "public"."expenses_mark_share_paid"("p_expense_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."expenses_mark_share_paid"("p_expense_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."expenses_mark_share_paid"("p_expense_id" "uuid") TO "authenticated";



GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "postgres";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "anon";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "authenticated";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "service_role";



GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "postgres";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "anon";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "authenticated";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "service_role";



REVOKE ALL ON FUNCTION "public"."gratitude_wall_list"("p_home_id" "uuid", "p_limit" integer, "p_cursor_created_at" timestamp with time zone, "p_cursor_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."gratitude_wall_list"("p_home_id" "uuid", "p_limit" integer, "p_cursor_created_at" timestamp with time zone, "p_cursor_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."gratitude_wall_list"("p_home_id" "uuid", "p_limit" integer, "p_cursor_created_at" timestamp with time zone, "p_cursor_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."gratitude_wall_mark_read"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."gratitude_wall_mark_read"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."gratitude_wall_mark_read"("p_home_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."gratitude_wall_status"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."gratitude_wall_status"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."gratitude_wall_status"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gratitude_wall_status"("p_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."handle_new_user"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."home_assignees_list"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."home_assignees_list"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."home_assignees_list"("p_home_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."home_entitlements_refresh"("_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."home_entitlements_refresh"("_home_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."home_mood_feedback_counters_inc"() TO "anon";
GRANT ALL ON FUNCTION "public"."home_mood_feedback_counters_inc"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."home_mood_feedback_counters_inc"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."home_nps_get_status"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."home_nps_get_status"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."home_nps_get_status"("p_home_id" "uuid") TO "authenticated";



GRANT ALL ON TABLE "public"."home_nps" TO "service_role";



REVOKE ALL ON FUNCTION "public"."home_nps_submit"("p_home_id" "uuid", "p_score" integer) FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."home_nps_submit"("p_home_id" "uuid", "p_score" integer) TO "service_role";
GRANT ALL ON FUNCTION "public"."home_nps_submit"("p_home_id" "uuid", "p_score" integer) TO "authenticated";



REVOKE ALL ON FUNCTION "public"."homes_create_with_invite"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."homes_create_with_invite"() TO "service_role";
GRANT ALL ON FUNCTION "public"."homes_create_with_invite"() TO "authenticated";



REVOKE ALL ON FUNCTION "public"."homes_join"("p_code" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."homes_join"("p_code" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."homes_join"("p_code" "text") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."homes_leave"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."homes_leave"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."homes_leave"("p_home_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."homes_transfer_owner"("p_home_id" "uuid", "p_new_owner_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."homes_transfer_owner"("p_home_id" "uuid", "p_new_owner_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."homes_transfer_owner"("p_home_id" "uuid", "p_new_owner_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."homes_transfer_owner"("p_home_id" "uuid", "p_new_owner_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "postgres";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "anon";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "service_role";



GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "postgres";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "anon";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "postgres";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "postgres";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "anon";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "authenticated";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "service_role";



GRANT ALL ON TABLE "public"."invites" TO "service_role";



REVOKE ALL ON FUNCTION "public"."invites_get_active"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."invites_get_active"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."invites_get_active"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."invites_get_active"("p_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."invites_revoke"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."invites_revoke"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."invites_revoke"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."invites_revoke"("p_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."invites_rotate"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."invites_rotate"("p_home_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."invites_rotate"("p_home_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."invites_rotate"("p_home_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_home_owner"("p_home_id" "uuid", "p_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_home_owner"("p_home_id" "uuid", "p_user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."members_list_active_by_home"("p_home_id" "uuid", "p_exclude_self" boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."members_list_active_by_home"("p_home_id" "uuid", "p_exclude_self" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."members_list_active_by_home"("p_home_id" "uuid", "p_exclude_self" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."members_list_active_by_home"("p_home_id" "uuid", "p_exclude_self" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."membership_me_current"() TO "anon";
GRANT ALL ON FUNCTION "public"."membership_me_current"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."membership_me_current"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."mood_get_current_weekly"("p_home_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."mood_get_current_weekly"("p_home_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."mood_get_current_weekly"("p_home_id" "uuid") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."mood_submit"("p_home_id" "uuid", "p_mood" "public"."mood_scale", "p_comment" "text", "p_add_to_wall" boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."mood_submit"("p_home_id" "uuid", "p_mood" "public"."mood_scale", "p_comment" "text", "p_add_to_wall" boolean) TO "service_role";
GRANT ALL ON FUNCTION "public"."mood_submit"("p_home_id" "uuid", "p_mood" "public"."mood_scale", "p_comment" "text", "p_add_to_wall" boolean) TO "authenticated";



GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "postgres";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "anon";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."profile_identity_update"("p_username" "public"."citext", "p_avatar_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."profile_identity_update"("p_username" "public"."citext", "p_avatar_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."profile_identity_update"("p_username" "public"."citext", "p_avatar_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."profile_identity_update"("p_username" "public"."citext", "p_avatar_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."profile_me"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."profile_me"() TO "anon";
GRANT ALL ON FUNCTION "public"."profile_me"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."profile_me"() TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_match"("public"."citext", "public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_matches"("public"."citext", "public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_replace"("public"."citext", "public"."citext", "text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_split_to_array"("public"."citext", "public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."regexp_split_to_table"("public"."citext", "public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."replace"("public"."citext", "public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."replace"("public"."citext", "public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."replace"("public"."citext", "public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."replace"("public"."citext", "public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."split_part"("public"."citext", "public"."citext", integer) TO "postgres";
GRANT ALL ON FUNCTION "public"."split_part"("public"."citext", "public"."citext", integer) TO "anon";
GRANT ALL ON FUNCTION "public"."split_part"("public"."citext", "public"."citext", integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."split_part"("public"."citext", "public"."citext", integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."strpos"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."strpos"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."strpos"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strpos"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticlike"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticnlike"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticregexeq"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."texticregexne"("public"."citext", "public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "service_role";



REVOKE ALL ON FUNCTION "public"."today_flow_list"("p_home_id" "uuid", "p_state" "public"."chore_state") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."today_flow_list"("p_home_id" "uuid", "p_state" "public"."chore_state") TO "anon";
GRANT ALL ON FUNCTION "public"."today_flow_list"("p_home_id" "uuid", "p_state" "public"."chore_state") TO "authenticated";
GRANT ALL ON FUNCTION "public"."today_flow_list"("p_home_id" "uuid", "p_state" "public"."chore_state") TO "service_role";



GRANT ALL ON FUNCTION "public"."translate"("public"."citext", "public"."citext", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."translate"("public"."citext", "public"."citext", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."translate"("public"."citext", "public"."citext", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."translate"("public"."citext", "public"."citext", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "service_role";



REVOKE ALL ON FUNCTION "public"."user_subscriptions_home_entitlements_trigger"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."user_subscriptions_home_entitlements_trigger"() TO "service_role";












GRANT ALL ON FUNCTION "public"."max"("public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."max"("public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."max"("public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."max"("public"."citext") TO "service_role";



GRANT ALL ON FUNCTION "public"."min"("public"."citext") TO "postgres";
GRANT ALL ON FUNCTION "public"."min"("public"."citext") TO "anon";
GRANT ALL ON FUNCTION "public"."min"("public"."citext") TO "authenticated";
GRANT ALL ON FUNCTION "public"."min"("public"."citext") TO "service_role";















GRANT ALL ON TABLE "public"."analytics_events" TO "service_role";



GRANT ALL ON TABLE "public"."app_version" TO "service_role";



GRANT ALL ON TABLE "public"."avatars" TO "anon";
GRANT ALL ON TABLE "public"."avatars" TO "authenticated";
GRANT ALL ON TABLE "public"."avatars" TO "service_role";



GRANT ALL ON TABLE "public"."chore_events" TO "service_role";



GRANT ALL ON TABLE "public"."gratitude_wall_posts" TO "service_role";



GRANT ALL ON TABLE "public"."gratitude_wall_reads" TO "service_role";



GRANT ALL ON TABLE "public"."home_entitlements" TO "service_role";



GRANT ALL ON TABLE "public"."home_mood_entries" TO "service_role";



GRANT ALL ON TABLE "public"."home_mood_feedback_counters" TO "service_role";



GRANT ALL ON TABLE "public"."home_plan_limits" TO "service_role";



GRANT ALL ON TABLE "public"."homes" TO "service_role";



GRANT ALL ON TABLE "public"."memberships" TO "service_role";



GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."profiles" TO "anon";
GRANT SELECT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."reserved_usernames" TO "service_role";



GRANT ALL ON TABLE "public"."shared_preferences" TO "service_role";



GRANT ALL ON TABLE "public"."user_subscriptions" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































