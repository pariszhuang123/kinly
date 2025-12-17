import 'package:flutter/material.dart';

/// Control-level tokens derived from KinlyPalette for consistent theming.
@immutable
class KinlyControlColors extends ThemeExtension<KinlyControlColors> {
  const KinlyControlColors({
    // Buttons
    required this.filledBg,
    required this.filledFg,
    required this.filledDisabledBg,
    required this.filledDisabledFg,
    required this.filledDestructiveBg,
    required this.filledDestructiveFg,
    required this.filledDestructiveDisabledBg,
    required this.filledDestructiveDisabledFg,
    required this.outlinedBorder,
    required this.outlinedFg,
    required this.outlinedDisabledBorder,
    required this.outlinedDisabledFg,
    required this.textFg,
    required this.textDisabledFg,
    required this.fabBg,
    required this.fabFg,
    required this.addTileBg,
    required this.addTileFg,
    // Toggles / selectors
    required this.checkboxChecked,
    required this.checkboxUnchecked,
    required this.checkboxBorder,
    required this.selectionDisabledBg,
    required this.selectionDisabledBorder,
    required this.selectionDisabledFg,
    required this.optionRowBg,
    required this.optionRowFg,
    required this.optionRowSelectedBg,
    required this.optionRowSelectedFg,
    required this.optionRowBorder,
    required this.selectableItemBg,
    required this.selectableItemBorder,
    required this.selectableItemFg,
    required this.selectableItemBgSelected,
    required this.selectableItemBorderSelected,
    required this.selectableItemFgSelected,
    // Misc controls
    required this.loaderColor,
    required this.badgeBg,
    required this.badgeFg,
    required this.errorBadgeBg,
    required this.errorBadgeFg,
    required this.expandBadgeBg,
    required this.expandBadgeIcon,
    required this.commentBoxBg,
    required this.commentBoxBorder,
    required this.pickerPrimary,
    required this.pickerOnPrimary,
    required this.avatarBadgeBg,
    required this.avatarBadgeFg,
  });

  final Color filledBg;
  final Color filledFg;
  final Color filledDisabledBg;
  final Color filledDisabledFg;
  final Color filledDestructiveBg;
  final Color filledDestructiveFg;
  final Color filledDestructiveDisabledBg;
  final Color filledDestructiveDisabledFg;
  final Color outlinedBorder;
  final Color outlinedFg;
  final Color outlinedDisabledBorder;
  final Color outlinedDisabledFg;
  final Color textFg;
  final Color textDisabledFg;
  final Color fabBg;
  final Color fabFg;
  final Color addTileBg;
  final Color addTileFg;

  final Color checkboxChecked;
  final Color checkboxUnchecked;
  final Color checkboxBorder;
  final Color selectionDisabledBg;
  final Color selectionDisabledBorder;
  final Color selectionDisabledFg;
  final Color optionRowBg;
  final Color optionRowFg;
  final Color optionRowSelectedBg;
  final Color optionRowSelectedFg;
  final Color optionRowBorder;
  final Color selectableItemBg;
  final Color selectableItemBorder;
  final Color selectableItemFg;
  final Color selectableItemBgSelected;
  final Color selectableItemBorderSelected;
  final Color selectableItemFgSelected;

  final Color loaderColor;
  final Color badgeBg;
  final Color badgeFg;
  final Color errorBadgeBg;
  final Color errorBadgeFg;
  final Color expandBadgeBg;
  final Color expandBadgeIcon;
  final Color commentBoxBg;
  final Color commentBoxBorder;
  final Color pickerPrimary;
  final Color pickerOnPrimary;
  final Color avatarBadgeBg;
  final Color avatarBadgeFg;

  @override
  KinlyControlColors copyWith({
    Color? filledBg,
    Color? filledFg,
    Color? filledDisabledBg,
    Color? filledDisabledFg,
    Color? filledDestructiveBg,
    Color? filledDestructiveFg,
    Color? filledDestructiveDisabledBg,
    Color? filledDestructiveDisabledFg,
    Color? outlinedBorder,
    Color? outlinedFg,
    Color? outlinedDisabledBorder,
    Color? outlinedDisabledFg,
    Color? textFg,
    Color? textDisabledFg,
    Color? fabBg,
    Color? fabFg,
    Color? addTileBg,
    Color? addTileFg,
    Color? checkboxChecked,
    Color? checkboxUnchecked,
    Color? checkboxBorder,
    Color? selectionDisabledBg,
    Color? selectionDisabledBorder,
    Color? selectionDisabledFg,
    Color? optionRowBg,
    Color? optionRowFg,
    Color? optionRowSelectedBg,
    Color? optionRowSelectedFg,
    Color? optionRowBorder,
    Color? selectableItemBg,
    Color? selectableItemBorder,
    Color? selectableItemFg,
    Color? selectableItemBgSelected,
    Color? selectableItemBorderSelected,
    Color? selectableItemFgSelected,
    Color? loaderColor,
    Color? badgeBg,
    Color? badgeFg,
    Color? errorBadgeBg,
    Color? errorBadgeFg,
    Color? expandBadgeBg,
    Color? expandBadgeIcon,
    Color? commentBoxBg,
    Color? commentBoxBorder,
    Color? pickerPrimary,
    Color? pickerOnPrimary,
    Color? avatarBadgeBg,
    Color? avatarBadgeFg,
  }) {
    return KinlyControlColors(
      filledBg: filledBg ?? this.filledBg,
      filledFg: filledFg ?? this.filledFg,
      filledDisabledBg: filledDisabledBg ?? this.filledDisabledBg,
      filledDisabledFg: filledDisabledFg ?? this.filledDisabledFg,
      filledDestructiveBg: filledDestructiveBg ?? this.filledDestructiveBg,
      filledDestructiveFg: filledDestructiveFg ?? this.filledDestructiveFg,
      filledDestructiveDisabledBg:
          filledDestructiveDisabledBg ?? this.filledDestructiveDisabledBg,
      filledDestructiveDisabledFg:
          filledDestructiveDisabledFg ?? this.filledDestructiveDisabledFg,
      outlinedBorder: outlinedBorder ?? this.outlinedBorder,
      outlinedFg: outlinedFg ?? this.outlinedFg,
      outlinedDisabledBorder: outlinedDisabledBorder ?? this.outlinedDisabledBorder,
      outlinedDisabledFg: outlinedDisabledFg ?? this.outlinedDisabledFg,
      textFg: textFg ?? this.textFg,
      textDisabledFg: textDisabledFg ?? this.textDisabledFg,
      fabBg: fabBg ?? this.fabBg,
      fabFg: fabFg ?? this.fabFg,
      addTileBg: addTileBg ?? this.addTileBg,
      addTileFg: addTileFg ?? this.addTileFg,
      checkboxChecked: checkboxChecked ?? this.checkboxChecked,
      checkboxUnchecked: checkboxUnchecked ?? this.checkboxUnchecked,
      checkboxBorder: checkboxBorder ?? this.checkboxBorder,
      selectionDisabledBg: selectionDisabledBg ?? this.selectionDisabledBg,
      selectionDisabledBorder:
          selectionDisabledBorder ?? this.selectionDisabledBorder,
      selectionDisabledFg: selectionDisabledFg ?? this.selectionDisabledFg,
      optionRowBg: optionRowBg ?? this.optionRowBg,
      optionRowFg: optionRowFg ?? this.optionRowFg,
      optionRowSelectedBg: optionRowSelectedBg ?? this.optionRowSelectedBg,
      optionRowSelectedFg: optionRowSelectedFg ?? this.optionRowSelectedFg,
      optionRowBorder: optionRowBorder ?? this.optionRowBorder,
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
      badgeBg: badgeBg ?? this.badgeBg,
      badgeFg: badgeFg ?? this.badgeFg,
      errorBadgeBg: errorBadgeBg ?? this.errorBadgeBg,
      errorBadgeFg: errorBadgeFg ?? this.errorBadgeFg,
      expandBadgeBg: expandBadgeBg ?? this.expandBadgeBg,
      expandBadgeIcon: expandBadgeIcon ?? this.expandBadgeIcon,
      commentBoxBg: commentBoxBg ?? this.commentBoxBg,
      commentBoxBorder: commentBoxBorder ?? this.commentBoxBorder,
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
      filledDisabledBg: lerpColor(filledDisabledBg, other.filledDisabledBg),
      filledDisabledFg: lerpColor(filledDisabledFg, other.filledDisabledFg),
      filledDestructiveBg: lerpColor(filledDestructiveBg, other.filledDestructiveBg),
      filledDestructiveFg: lerpColor(filledDestructiveFg, other.filledDestructiveFg),
      filledDestructiveDisabledBg: lerpColor(
        filledDestructiveDisabledBg,
        other.filledDestructiveDisabledBg,
      ),
      filledDestructiveDisabledFg: lerpColor(
        filledDestructiveDisabledFg,
        other.filledDestructiveDisabledFg,
      ),
      outlinedBorder: lerpColor(outlinedBorder, other.outlinedBorder),
      outlinedFg: lerpColor(outlinedFg, other.outlinedFg),
      outlinedDisabledBorder:
          lerpColor(outlinedDisabledBorder, other.outlinedDisabledBorder),
      outlinedDisabledFg: lerpColor(outlinedDisabledFg, other.outlinedDisabledFg),
      textFg: lerpColor(textFg, other.textFg),
      textDisabledFg: lerpColor(textDisabledFg, other.textDisabledFg),
      fabBg: lerpColor(fabBg, other.fabBg),
      fabFg: lerpColor(fabFg, other.fabFg),
      addTileBg: lerpColor(addTileBg, other.addTileBg),
      addTileFg: lerpColor(addTileFg, other.addTileFg),
      checkboxChecked: lerpColor(checkboxChecked, other.checkboxChecked),
      checkboxUnchecked: lerpColor(checkboxUnchecked, other.checkboxUnchecked),
      checkboxBorder: lerpColor(checkboxBorder, other.checkboxBorder),
      selectionDisabledBg:
          lerpColor(selectionDisabledBg, other.selectionDisabledBg),
      selectionDisabledBorder:
          lerpColor(selectionDisabledBorder, other.selectionDisabledBorder),
      selectionDisabledFg:
          lerpColor(selectionDisabledFg, other.selectionDisabledFg),
      optionRowBg: lerpColor(optionRowBg, other.optionRowBg),
      optionRowFg: lerpColor(optionRowFg, other.optionRowFg),
      optionRowSelectedBg: lerpColor(optionRowSelectedBg, other.optionRowSelectedBg),
      optionRowSelectedFg: lerpColor(optionRowSelectedFg, other.optionRowSelectedFg),
      optionRowBorder: lerpColor(optionRowBorder, other.optionRowBorder),
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
      badgeBg: lerpColor(badgeBg, other.badgeBg),
      badgeFg: lerpColor(badgeFg, other.badgeFg),
      errorBadgeBg: lerpColor(errorBadgeBg, other.errorBadgeBg),
      errorBadgeFg: lerpColor(errorBadgeFg, other.errorBadgeFg),
      expandBadgeBg: lerpColor(expandBadgeBg, other.expandBadgeBg),
      expandBadgeIcon: lerpColor(expandBadgeIcon, other.expandBadgeIcon),
      commentBoxBg: lerpColor(commentBoxBg, other.commentBoxBg),
      commentBoxBorder: lerpColor(commentBoxBorder, other.commentBoxBorder),
      pickerPrimary: lerpColor(pickerPrimary, other.pickerPrimary),
      pickerOnPrimary: lerpColor(pickerOnPrimary, other.pickerOnPrimary),
      avatarBadgeBg: lerpColor(avatarBadgeBg, other.avatarBadgeBg),
      avatarBadgeFg: lerpColor(avatarBadgeFg, other.avatarBadgeFg),
    );
  }
}
