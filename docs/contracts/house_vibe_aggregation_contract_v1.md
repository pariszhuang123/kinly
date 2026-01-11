# House Vibe Aggregation Contract v1
# Instruction: Do not invent new behavior. If something is ambiguous, ask rather than assume.

Status: Draft (implementation-ready)  
Audience: Engineering, Agents  
Scope: Convert canonical Personal Preferences into aggregated home-level vibe axes.

## Purpose

Aggregate member Personal Preferences into descriptive axes that reflect tendencies, not rules. Outputs are axis results only; presentation is handled elsewhere.

## Inputs

- Home membership: current members for an active home (`homes.is_active = true`).
- Canonical preferences per member: see `house_vibe_canonical_preference_schema_v1.md`.
  - Contribution gate: member counts only if they have a published, complete (all 14 answers) preference payload; partial answers do not contribute.
- Mapping effects: (pref_id, option_index) → axis deltas + weights (versioned, v1).

## Axes (v1 identifiers)

- `energy_level` (calm ↔ lively)
- `structure_level` (structured ↔ flexible)
- `social_level` (private ↔ social)
- `repair_style` (avoidant ↔ balanced ↔ direct; encoded via -1/0/+1)
- `noise_tolerance` (quiet ↔ okay_with_noise)
- `cleanliness_rhythm` (consistent ↔ ad_hoc)

## Mapping Effects Contract (v1)

Each valid selection may contribute to one or more axes:

```json
{
  "pref_id": "noise_late_night",
  "option_index": 2,
  "effects": [
    { "axis": "noise_tolerance", "delta": 1, "weight": 1.0 },
    { "axis": "energy_level", "delta": 1, "weight": 0.5 }
  ]
}
```

- `delta` is -1, 0, or 1. `repair_style` may use all three values; other axes use -1/1 only.
- `weight` is ≥ 0.1, ≤ 3.0. Use mapping defaults; do not invent weights client-side.
- Mapping rows are versioned; v1 is fixed. Changes require a new mapping_version.

## Aggregation Algorithm (deterministic)

For each axis:
1. Per-member assignment: sum that member’s (delta × weight) for the axis. If member_sum > 0 → counts positive; if member_sum < 0 → counts negative; else neutral. A member counts toward only one side. Track `positive_member_count` and `negative_member_count` from these assignments.
2. Compute:
   - `total_weight = positive_weight + negative_weight`
   - `net = positive_weight - negative_weight`
   - `score = (total_weight == 0) ? 0 : net / total_weight` (range [-1, 1], clamp if needed)
3. Derive lean (precedence: mixed > balanced > leans):
   - if `total_weight == 0` AND coverage insufficient: `lean = unknown`
   - else if `positive_member_count >= MIN_SIDE_COUNT` AND `negative_member_count >= MIN_SIDE_COUNT` AND `abs(score) < 0.20`: `lean = mixed`
   - else if `abs(score) < 0.15` OR (total_weight == 0 AND coverage is sufficient): `lean = balanced`
   - else if `score > 0`: `lean = leans_high`
   - else: `lean = leans_low`
4. Confidence (0–1, rounded to 2 decimals):
   - `member_ratio = coverage_answered / coverage_total` (0 if total=0)
   - `strength = abs(score)` (apply `strength = max(strength, 0.15)` when `lean == balanced` and `total_weight > 0`)
   - `confidence = round(min(1, member_ratio * (0.5 + strength/2)), 2)`
   - Do not boost confidence for mixed; mixed confidence uses the same formula.
5. Coverage:
   - `member_count_total`: active members in the home
   - `member_count_contributed`: members with published, complete preferences
   - `coverage_answered`: same as `member_count_contributed`
   - `coverage_total`: same as `member_count_total`
6. Constants:
   - `MIN_SIDE_COUNT` varies with home size:
     - if `coverage_total <= 3`: require ≥1 member per side
     - if `coverage_total >= 4`: require ≥2 members per side

Outputs per axis:
```json
{
  "axis": "energy_level",
  "lean": "leans_low|leans_high|balanced|mixed|unknown",
  "score": -0.33,
  "confidence": 0.58,
  "positive_weight": 2.0,
  "negative_weight": 3.0,
  "positive_member_count": 3,
  "negative_member_count": 2
}
```

## Stability & Recompute Triggers

- Aggregation uses only current members and their latest canonical preferences. Members with partial preferences (fewer than 14 answered) are excluded from coverage and weight.
- Mark House Vibe snapshot `out_of_date = true` when:
  - membership changes (join/leave/transfer owner)
  - preference data updates or taxonomy_version changes
  - mapping_version changes
- `force=true` in compute RPC bypasses change detection.

## Prohibited

- Do not branch on client/platform.
- Do not infer effects outside the mapping table.
- Do not average identities (no per-user scores are exposed).
