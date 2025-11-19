CREATE OR REPLACE FUNCTION public.chores_get_for_home(
  p_home_id  uuid,
  p_chore_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
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

-- ---------------------------------------------------------------------
-- invites.rotate(home_id) -> returns the new active invite
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.invites_rotate(p_home_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
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
     SET revoked_at = now(), 
        updated_at = now()
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
