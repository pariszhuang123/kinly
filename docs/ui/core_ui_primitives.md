# Kinly Core UI Primitives

Purpose: Shared widgets under `lib/core/ui/**` to keep spacing, colors, directionality, and i18n consistent.

## Principles
- Directionality-safe APIs only; run `dart run tool/check_directionality.dart`.
- No hard-coded strings; use `S.of(context)`.
- Respect theme tokens (`Spacing`, `KinlySections`), light/dark, and accessibility.
- No `print`/`debugPrint`; use the logger when needed.

## Buttons
- `KinlyFilledButton` (text/icon, destructive, fullWidth, compact)
- `KinlyOutlinedButton` (text/icon, compact/fullWidth)
- `KinlyFab`, `KinlyAddTileButton`
- When to use: primary CTA = filled; secondary = outlined; tertiary/inline = text; destructive variants for irreversible actions.

## Feedback / Loading
- `KinlyLoader` (sizes/patterns).
- Snackbar/toast patterns if standardized.

## Avatars & Media
- `KinlyCircleAvatar` (owner badge, fallback handling).
- Photo pickers/previews if shared.

## Inputs & Pickers
- `KinlyDatePicker` and other shared pickers.
- Common text-field patterns if standardized (directional padding).

## Layout & Spacing
- `Spacing` extension usage; surface/section color guidance from `KinlySections`.

## Adding or Changing a Primitive
1) Propose to Planner + Docs (intent, consumers, theme tokens, tests).
2) Build under `lib/core/ui/...`; keep directionality-safe; use `S.of(context)`.
3) Add widget tests (incl. RTL/golden where appropriate).
4) Update this doc with API and examples.
5) Run `check_directionality` and `check_i18n` before landing.

## Known Gaps / Backlog
- [List planned primitives or refactors here]
