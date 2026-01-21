---
Domain: Engineering System
Capability: Database Migrations
Scope: backend
Artifact-Type: guide
Stability: evolving
Status: Approved
Version: v1.0
---

# Database Migrations & Workflow

This folder contains SQL migrations and RPC definitions for the Home-only MVP.

Deprecation notice
- Source of truth for schema/RLS/migrations now lives under `supabase/`. Do not add new changes here.
- If you need DB history, consult the archived files below or move any missing artifacts into `supabase/` before editing.

Conventions
- Forward-only in Supabase: Production only applies `*.up.sql`. Do not rely on downs; author safe, incremental migrations.
- File naming: `NNNN_name.up.sql` (no `down.sql` required).
- All schema changes include RLS policies and indexes.
- Add comments for tables, columns, policies, indexes, and functions to document intent.
- All writes go through RPCs (SECURITY DEFINER). Deny direct writes to clients.
- RPCs must include `set search_path = ''` and fully schema-qualify objects (e.g., `public.homes`, `auth.uid()`).

Workflow
1) Create a migration (up-only): `supabase migration new <name>` and edit the generated `*.up.sql`.
2) Up: tables + column comments, indexes (+ comments), RLS enable + policies (+ comments), grants, RPCs with `set search_path = ''`.
3) Add tests for RLS allow/deny and RPC happy/error paths.
4) Open PR with Given/When/Then, DoD, and artifacts.

Rollback policy (Prod)
- Never run downs in production. If a migration needs to be undone, ship a new forward migration that reverts the behavior (expand/contract strategy).

Supabase CLI (Dev -> Prod)
- Auth in CI/local: `supabase login --token $SUPABASE_ACCESS_TOKEN`
- Dev deploy: `supabase db push --project-ref $SUPABASE_DEV_REF`
- Prod deploy (gated): `supabase db push --project-ref $SUPABASE_PROD_REF`
- Optional local shadow checks: `supabase db lint` (if enabled) and `supabase db verify`.

Notes
- Use additive, backward-compatible changes when possible.
- Separate `CREATE INDEX CONCURRENTLY` into its own migration (not in a transaction).
- Version RPCs/views when changing contracts (e.g., `homes_v1`, `homes_v2`).
