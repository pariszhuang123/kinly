import 'package:flutter/material.dart';

/// Control-level tokens derived from KinlyPalette for consistent theming.
@immutable
class KinlyControlColors extends ThemeExtension<KinlyControlColors> {
  const KinlyControlColors({
    // Buttons
    required this.filledBg,
    required this.filledFg,
    required this.filledDestructiveBg,
    required this.filledDestructiveFg,
    required this.outlinedBorder,
    required this.outlinedFg,
    required this.fabBg,
    required this.fabFg,
    required this.addTileBg,
    required this.addTileFg,
    // Toggles / selectors
    required this.checkboxChecked,
    required this.checkboxUnchecked,
    required this.checkboxBorder,
    required this.optionRowBg,
    required this.optionRowFg,
    required this.selectableItemBg,
    required this.selectableItemBorder,
    required this.selectableItemFg,
    required this.selectableItemBgSelected,
    required this.selectableItemBorderSelected,
    required this.selectableItemFgSelected,
    // Misc controls
    required this.loaderColor,
    required this.expandBadgeBg,
    required this.expandBadgeIcon,
    required this.commentBoxBg,
    required this.commentBoxBorder,
    required this.settingsTileBadgeBg,
    required this.settingsTileBadgeFg,
    required this.pickerPrimary,
    required this.pickerOnPrimary,
    required this.avatarBadgeBg,
    required this.avatarBadgeFg,
  });

  final Color filledBg;
  final Color filledFg;
  final Color filledDestructiveBg;
  final Color filledDestructiveFg;
  final Color outlinedBorder;
  final Color outlinedFg;
  final Color fabBg;
  final Color fabFg;
  final Color addTileBg;
  final Color addTileFg;

  final Color checkboxChecked;
  final Color checkboxUnchecked;
  final Color checkboxBorder;
  final Color optionRowBg;
  final Color optionRowFg;
  final Color selectableItemBg;
  final Color selectableItemBorder;
  final Color selectableItemFg;
  final Color selectableItemBgSelected;
  final Color selectableItemBorderSelected;
  final Color selectableItemFgSelected;

  final Color loaderColor;
  final Color expandBadgeBg;
  final Color expandBadgeIcon;
  final Color commentBoxBg;
  final Color commentBoxBorder;
  final Color settingsTileBadgeBg;
  final Color settingsTileBadgeFg;
  final Color pickerPrimary;
  final Color pickerOnPrimary;
  final Color avatarBadgeBg;
  final Color avatarBadgeFg;

  @override
  KinlyControlColors copyWith({
    Color? filledBg,
    Color? filledFg,
    Color? filledDestructiveBg,
    Color? filledDestructiveFg,
    Color? outlinedBorder,
    Color? outlinedFg,
    Color? fabBg,
    Color? fabFg,
    Color? addTileBg,
    Color? addTileFg,
    Color? checkboxChecked,
    Color? checkboxUnchecked,
    Color? checkboxBorder,
    Color? optionRowBg,
    Color? optionRowFg,
    Color? selectableItemBg,
    Color? selectableItemBorder,
    Color? selectableItemFg,
    Color? selectableItemBgSelected,
    Color? selectableItemBorderSelected,
    Color? selectableItemFgSelected,
    Color? loaderColor,
    Color? expandBadgeBg,
    Color? expandBadgeIcon,
    Color? commentBoxBg,
    Color? commentBoxBorder,
    Color? settingsTileBadgeBg,
    Color? settingsTileBadgeFg,
    Color? pickerPrimary,
    Color? pickerOnPrimary,
    Color? avatarBadgeBg,
    Color? avatarBadgeFg,
  }) {
    return KinlyControlColors(
      filledBg: filledBg ?? this.filledBg,
      filledFg: filledFg ?? this.filledFg,
      filledDestructiveBg: filledDestructiveBg ?? this.filledDestructiveBg,
      filledDestructiveFg: filledDestructiveFg ?? this.filledDestructiveFg,
      outlinedBorder: outlinedBorder ?? this.outlinedBorder,
      outlinedFg: outlinedFg ?? this.outlinedFg,
      fabBg: fabBg ?? this.fabBg,
      fabFg: fabFg ?? this.fabFg,
      addTileBg: addTileBg ?? this.addTileBg,
      addTileFg: addTileFg ?? this.addTileFg,
      checkboxChecked: checkboxChecked ?? this.checkboxChecked,
      checkboxUnchecked: checkboxUnchecked ?? this.checkboxUnchecked,
      checkboxBorder: checkboxBorder ?? this.checkboxBorder,
      optionRowBg: optionRowBg ?? this.optionRowBg,
      optionRowFg: optionRowFg ?? this.optionRowFg,
      selectableItemBg: selectableItemBg ?? this.selectableItemBg,
      selectableItemBorder: selectableItemBorder ?? this.selectableItemBorder,
      selectableItemFg: selectableItemFg ?? this.selectableItemFg,
      selectableItemBgSelected:
          selectableItemBgSelected ?? this.selectableItemBgSelected,
      selectableItemBorderSelected:
          selectableItemBorderSelected ?? this.selectableItemBorderSelected,
      selectableItemFgSelected:
          selectableItemFgSelected ?? this.selectableItemFgSelected,
      loaderColor: loaderColor ?? this.loaderColor,
      expandBadgeBg: expandBadgeBg ?? this.expandBadgeBg,
      expandBadgeIcon: expandBadgeIcon ?? this.expandBadgeIcon,
      commentBoxBg: commentBoxBg ?? this.commentBoxBg,
      commentBoxBorder: commentBoxBorder ?? this.commentBoxBorder,
      settingsTileBadgeBg: settingsTileBadgeBg ?? this.settingsTileBadgeBg,
      settingsTileBadgeFg: settingsTileBadgeFg ?? this.settingsTileBadgeFg,
      pickerPrimary: pickerPrimary ?? this.pickerPrimary,
      pickerOnPrimary: pickerOnPrimary ?? this.pickerOnPrimary,
      avatarBadgeBg: avatarBadgeBg ?? this.avatarBadgeBg,
      avatarBadgeFg: avatarBadgeFg ?? this.avatarBadgeFg,
    );
  }

  @override
  KinlyControlColors lerp(ThemeExtension<KinlyControlColors>? other, double t) {
    if (other is! KinlyControlColors) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t) ?? a;

    return KinlyControlColors(
      filledBg: lerpColor(filledBg, other.filledBg),
      filledFg: lerpColor(filledFg, other.filledFg),
      filledDestructiveBg: lerpColor(filledDestructiveBg, other.filledDestructiveBg),
      filledDestructiveFg: lerpColor(filledDestructiveFg, other.filledDestructiveFg),
      outlinedBorder: lerpColor(outlinedBorder, other.outlinedBorder),
      outlinedFg: lerpColor(outlinedFg, other.outlinedFg),
      fabBg: lerpColor(fabBg, other.fabBg),
      fabFg: lerpColor(fabFg, other.fabFg),
      addTileBg: lerpColor(addTileBg, other.addTileBg),
      addTileFg: lerpColor(addTileFg, other.addTileFg),
      checkboxChecked: lerpColor(checkboxChecked, other.checkboxChecked),
      checkboxUnchecked: lerpColor(checkboxUnchecked, other.checkboxUnchecked),
      checkboxBorder: lerpColor(checkboxBorder, other.checkboxBorder),
      optionRowBg: lerpColor(optionRowBg, other.optionRowBg),
      optionRowFg: lerpColor(optionRowFg, other.optionRowFg),
      selectableItemBg: lerpColor(selectableItemBg, other.selectableItemBg),
      selectableItemBorder: lerpColor(selectableItemBorder, other.selectableItemBorder),
      selectableItemFg: lerpColor(selectableItemFg, other.selectableItemFg),
      selectableItemBgSelected:
          lerpColor(selectableItemBgSelected, other.selectableItemBgSelected),
      selectableItemBorderSelected: lerpColor(
        selectableItemBorderSelected,
        other.selectableItemBorderSelected,
      ),
      selectableItemFgSelected:
          lerpColor(selectableItemFgSelected, other.selectableItemFgSelected),
      loaderColor: lerpColor(loaderColor, other.loaderColor),
      expandBadgeBg: lerpColor(expandBadgeBg, other.expandBadgeBg),
      expandBadgeIcon: lerpColor(expandBadgeIcon, other.expandBadgeIcon),
      commentBoxBg: lerpColor(commentBoxBg, other.commentBoxBg),
      commentBoxBorder: lerpColor(commentBoxBorder, other.commentBoxBorder),
      settingsTileBadgeBg: lerpColor(settingsTileBadgeBg, other.settingsTileBadgeBg),
      settingsTileBadgeFg: lerpColor(settingsTileBadgeFg, other.settingsTileBadgeFg),
      pickerPrimary: lerpColor(pickerPrimary, other.pickerPrimary),
      pickerOnPrimary: lerpColor(pickerOnPrimary, other.pickerOnPrimary),
      avatarBadgeBg: lerpColor(avatarBadgeBg, other.avatarBadgeBg),
      avatarBadgeFg: lerpColor(avatarBadgeFg, other.avatarBadgeFg),
    );
  }
}
