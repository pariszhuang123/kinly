# Kinly Core UI Primitives

Purpose: Shared widgets under `lib/core/ui/**` to keep spacing, colors, directionality, and i18n consistent.

## Principles
- Design System tokens: spacing (xxs-xxxl), radius (xs-xl), elevation (level0-5), motion (easeStandard/Accelerate/Decelerate/Emotional + fast/medium/slow/snappy), color tokens, typography tokens.
- Use Kinly primitives only: buttons, snackbars, dialogs, bottom sheets, inputs; no raw Material equivalents.
- No hard-coded colors/paddings/text styles; use tokens via Theme extensions (Spacing, Corners, Elevations, Motion, KinlyColorTokens, KinlyTypography).
- Directionality safe padding/alignment; use EdgeInsetsDirectional/AlignmentDirectional.
- RTL/widget tests for new or changed screens when adding primitives.
- Accessibility baseline (v1):
  - Touch targets: ≥48dp for all tappable primitives.
  - Semantics: provide labels/roles on buttons/tiles/rows/avatar taps.
  - Motion: respect reduce-motion; default durations ≤250ms; use motion tokens.
  - Contrast: use Kinly color tokens only; palette is validated by contrast tests.
  - Text: i18n only (`S.of(context)`); ≥14sp styles from typography tokens.
- Avatars: use KinlyCircleAvatar with token sizes (24/40/56 diameters).
- Bottom sheets/dialogs must use KinlyBottomSheet / KinlyAlertDialog (token radius/elevation/motion).
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
- `KinlyTextField` (tokenized text input)
- `KinlyDropdownField` (tokenized dropdown)
- `KinlyChoiceChip` (tokenized choice chip)
- `KinlyFilterChip` (tokenized filter chip)
- `KinlySegmentedControl` (tokenized segmented control)
- `KinlyTabBar` (inline tab bar for active/draft toggles)
- `KinlySearchField` (search variant with clear action)
- `KinlyDatePicker` and other shared pickers.
- `KinlySearchField` (search variant with clear action)

## Feedback / Inline
- `KinlyInfoBanner` (success/info/warning/error inline banner)

## Lists & States
- `KinlyListTile` (tokenized title/subtitle row)
- `KinlyBadge` (small inline label; use `accentColor` for section badges and `destructive` for danger badges)
- `KinlyEmptyState` (icon/title/body + optional CTA)
## Media
- `KinlyPhotoCapture` (photo pick/preview tile)

## Layout & Spacing
- `Spacing` extension usage; surface/section color guidance from `KinlySections`.
- `KinlyScrollFade` (wraps any scrollable to apply top/bottom fade + removes overscroll glow; configurable fade fraction and edges).

## Adding or Changing a Primitive
1) Propose to Planner + Docs (intent, consumers, theme tokens, tests).
2) Build under `lib/core/ui/...`; keep directionality-safe; use `S.of(context)`.
3) Add widget tests (incl. RTL/golden where appropriate). Ensure a11y tests cover 48dp + semantics and reduce-motion where relevant.
4) Update this doc with API and examples.
5) Run `check_directionality` and `check_i18n` before landing.

## Known Gaps / Backlog
- [List planned primitives or refactors here]
