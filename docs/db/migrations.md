# DB Migrations (MVP)

## Naming
- `YYYYMMDDHHMM_description.up.sql`.
- Use provided templates in `db/migrations/_TEMPLATE_up.sql`.

## Content
- Schema changes + constraints + indexes.
- RLS policies for all affected tables.
- Update RPCs if contracts require it.

## Review & Tests
- Reviewers: DB + Planner.
- Update `docs/testing/rls.md` and `docs/testing/rpc.md` cases if needed.

## Apply (local)
- Apply: run `.up.sql` in order.
