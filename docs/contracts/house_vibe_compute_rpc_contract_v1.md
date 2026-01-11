# House Vibe Compute RPC Contract v1
# Instruction: Do not invent new behavior. If something is ambiguous, ask rather than assume.

Status: Draft (implementation-ready)  
Audience: Engineering, Agents  
Scope: Server orchestration to compute, store, and return the latest vibe per home.

## Purpose

Provide an idempotent server function that aggregates member preferences, resolves `label_id`, stores a snapshot per home, and returns a render-ready vibe card.

## Tables

### public.house_vibes (snapshot)

Columns:
- `home_id uuid primary key`
- `mapping_version text not null` (v1)
- `label_id text not null`
- `confidence numeric not null`
- `coverage_answered int not null`
- `coverage_total int not null`
- `axes jsonb not null default '{}'::jsonb` (axis results for future chips)
- `computed_at timestamptz not null default now()`
- `out_of_date boolean not null default false`
- `invalidated_at timestamptz null`

Constraints:
- `label_id` must exist in `house_vibe_labels` for the same mapping_version.
- Confidence and coverage columns are bounded (0 ≤ confidence ≤ 1; answered ≤ total).

RLS:
- Table access is service-role only (RLS enabled + REVOKE). Clients read snapshots via RPC joins, not direct SELECT.

## RPC: house_vibe_compute

Signature:
```
house_vibe_compute(home_id uuid, force boolean default false, include_axes boolean default false)
```

Responsibilities:
1. Acquire advisory lock per (home_id, mapping_version) to avoid concurrent recompute.
2. Validate caller is a current member (unless executed as service role).
3. Determine if recompute is needed:
   - `force = true` OR `out_of_date = true` OR inputs changed since `computed_at`:
     - membership changes
     - published preference data updated
     - taxonomy structure change or mapping_version change
4. Run aggregation + mapping v1.
5. Upsert snapshot:
   - `ON CONFLICT (home_id) DO UPDATE`
   - set `out_of_date = false`, `computed_at = now()`, `invalidated_at = NULL`
6. Join label registry to return render-ready payload.

Return shape:
```json
{
  "home_id": "...",
  "mapping_version": "v1",
  "label_id": "quiet_care_home",
  "confidence": 0.62,
  "coverage": { "answered": 4, "total": 5 },
  "title_key": "...",
  "summary_key": "...",
  "image_key": "...",
  "ui": { },
  "axes": { ... } // included only if include_axes = true
}
```

## Out-of-date Strategy

- Treat `house_vibes` as a derived cache only; canonical inputs remain preference responses and membership state.
- Set `out_of_date = true` and `invalidated_at = now()` when:
  - membership inserts/updates/deactivations (public.memberships triggers; valid_to drives current)
  - published preference updates for any member in the home (insert/update/delete)
  - taxonomy structure change (new schema version) or mapping_version change
- Implement via triggers on membership/preferences tables or via scheduled job.
- Recompute lazily on read if `out_of_date = true` (service role or RPC caller). Do not recompute on write.

## Error Handling

- If coverage gate fails (see mapping contract), return `insufficient_data` label with coverage.
- If canonical payload is invalid for any member, log and skip that member; do not fail the home computation. Include unresolved count in logs/metrics (not in public payload).

## Prohibited

- No client-originated label overrides.
- No partial writes to `house_vibes` without label registry join.
- Do not expose per-member or per-preference data from this RPC.
