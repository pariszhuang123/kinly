-- Ensure the partial unique index exists
CREATE UNIQUE INDEX IF NOT EXISTS uq_invites_active_one_per_home
  ON public.invites (home_id)
  WHERE revoked_at IS NULL;

-- Attach a constraint to that index if it doesn't already exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'uq_invites_active_one_per_home'
      AND conrelid = 'public.invites'::regclass
  ) THEN
    ALTER TABLE public.invites
      ADD CONSTRAINT uq_invites_active_one_per_home
      UNIQUE USING INDEX uq_invites_active_one_per_home;
  END IF;
END;
$$;
