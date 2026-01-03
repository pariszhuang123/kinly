import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'opacity.dart';
import 'control_tokens.dart';

/// Internal helpers to build [KinlyControlColors] without bloating kinly_palette.dart CC.
KinlyControlColors buildControlColors(
  Brightness brightness,
  ColorScheme colorScheme,
  KinlyOpacity opacities,
) {
  final isDark = brightness == Brightness.dark;
  final disabled = _disabledTokens(colorScheme);
  final filled = _filledTokens(colorScheme, disabled);
  final destructive = _destructiveTokens(colorScheme, disabled);
  final outlined = _outlinedTokens(colorScheme, disabled, isDark);
  final optionRow = _optionRowTokens(colorScheme, isDark);
  final badge = _badgeTokens(colorScheme, opacities);
  final loaderColor = isDark ? colorScheme.onSurface : colorScheme.primary;
  final expandBadgeBg = colorScheme.primary.withValues(
    alpha: opacities.alphaSM,
  );
  final expandBadgeIcon = isDark ? colorScheme.onSurface : colorScheme.primary;
  final commentBoxBg =
      isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface;
  final commentBoxBorder =
      isDark ? colorScheme.outlineVariant : colorScheme.outline;
  final pickerPrimary = isDark ? colorScheme.secondary : colorScheme.primary;
  final pickerOnPrimary =
      isDark ? colorScheme.onSecondary : colorScheme.onPrimary;
  final avatarBadgeBg =
      isDark ? Colors.white : Colors.black; // per existing logic
  final avatarBadgeFg = isDark ? colorScheme.primary : colorScheme.onPrimary;

  return KinlyControlColors(
    filledBg: filled.background,
    filledFg: filled.foreground,
    filledDisabledBg: filled.disabledBg,
    filledDisabledFg: filled.disabledFg,
    filledDestructiveBg: destructive.background,
    filledDestructiveFg: destructive.foreground,
    filledDestructiveDisabledBg: destructive.disabledBg,
    filledDestructiveDisabledFg: destructive.disabledFg,
    outlinedBorder: outlined.border,
    outlinedFg: outlined.fg,
    outlinedDisabledBorder: outlined.disabledBorder,
    outlinedDisabledFg: outlined.disabledFg,
    textFg: outlined.fg,
    textDisabledFg: outlined.disabledFg,
    fabBg: filled.background,
    fabFg: filled.foreground,
    addTileBg: filled.background,
    addTileFg: filled.foreground,
    checkboxChecked: colorScheme.primaryContainer,
    checkboxUnchecked: colorScheme.surface,
    checkboxBorder: colorScheme.outline,
    selectionDisabledBg: disabled.base,
    selectionDisabledBorder: disabled.base,
    selectionDisabledFg: disabled.fg,
    optionRowBg: optionRow.bg,
    optionRowFg: optionRow.fg,
    optionRowSelectedBg: optionRow.selectedBg,
    optionRowSelectedFg: optionRow.selectedFg,
    optionRowBorder: optionRow.border,
    selectableItemBg: optionRow.bg,
    selectableItemBorder: colorScheme.outline,
    selectableItemFg: colorScheme.onSurface,
    selectableItemBgSelected: colorScheme.primaryContainer,
    selectableItemBorderSelected: colorScheme.primaryContainer,
    selectableItemFgSelected: colorScheme.onPrimaryContainer,
    loaderColor: loaderColor,
    badgeBg: badge.bg,
    badgeFg: badge.fg,
    errorBadgeBg: badge.errorBg,
    errorBadgeFg: badge.errorFg,
    expandBadgeBg: expandBadgeBg,
    expandBadgeIcon: expandBadgeIcon,
    commentBoxBg: commentBoxBg,
    commentBoxBorder: commentBoxBorder,
    pickerPrimary: pickerPrimary,
    pickerOnPrimary: pickerOnPrimary,
    avatarBadgeBg: avatarBadgeBg,
    avatarBadgeFg: avatarBadgeFg,
  );
}

class _DisabledTokens {
  _DisabledTokens({required this.base, required this.fg});

  final Color base;
  final Color fg;
}

class _FilledTokens {
  _FilledTokens({
    required this.background,
    required this.foreground,
    required this.disabledBg,
    required this.disabledFg,
  });

  final Color background;
  final Color foreground;
  final Color disabledBg;
  final Color disabledFg;
}

class _DestructiveTokens {
  _DestructiveTokens({
    required this.background,
    required this.foreground,
    required this.disabledBg,
    required this.disabledFg,
  });

  final Color background;
  final Color foreground;
  final Color disabledBg;
  final Color disabledFg;
}

class _OutlinedTokens {
  _OutlinedTokens({
    required this.fg,
    required this.border,
    required this.disabledFg,
    required this.disabledBorder,
  });

  final Color fg;
  final Color border;
  final Color disabledFg;
  final Color disabledBorder;
}

class _OptionRowTokens {
  _OptionRowTokens({
    required this.bg,
    required this.fg,
    required this.selectedBg,
    required this.selectedFg,
    required this.border,
  });

  final Color bg;
  final Color fg;
  final Color selectedBg;
  final Color selectedFg;
  final Color border;
}

class _BadgeTokens {
  _BadgeTokens({
    required this.bg,
    required this.fg,
    required this.errorBg,
    required this.errorFg,
  });

  final Color bg;
  final Color fg;
  final Color errorBg;
  final Color errorFg;
}

_DisabledTokens _disabledTokens(ColorScheme colorScheme) {
  final base = _mix(colorScheme.surface, colorScheme.outline, 0.5);
  final fg = _pickOnColor(background: base, preferred: colorScheme.onSurface);
  return _DisabledTokens(base: base, fg: fg);
}

_FilledTokens _filledTokens(ColorScheme colorScheme, _DisabledTokens disabled) {
  return _FilledTokens(
    background: colorScheme.primary,
    foreground: colorScheme.onPrimary,
    disabledBg: disabled.base,
    disabledFg: disabled.fg,
  );
}

_DestructiveTokens _destructiveTokens(
  ColorScheme colorScheme,
  _DisabledTokens disabled,
) {
  return _DestructiveTokens(
    background: colorScheme.error,
    foreground: colorScheme.onError,
    disabledBg: disabled.base,
    disabledFg: disabled.fg,
  );
}

_OutlinedTokens _outlinedTokens(
  ColorScheme colorScheme,
  _DisabledTokens disabled,
  bool isDark,
) {
  final fg = _pickOnColor(
    background: colorScheme.surface,
    preferred: colorScheme.primary,
  );
  final border = isDark ? colorScheme.outlineVariant : colorScheme.outline;
  return _OutlinedTokens(
    fg: fg,
    border: border,
    disabledFg: disabled.fg,
    disabledBorder: disabled.base,
  );
}

_OptionRowTokens _optionRowTokens(ColorScheme colorScheme, bool isDark) {
  final bg =
      isDark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainer;
  return _OptionRowTokens(
    bg: bg,
    fg: colorScheme.onSurface,
    selectedBg: colorScheme.primaryContainer,
    selectedFg: colorScheme.onPrimaryContainer,
    border: colorScheme.outlineVariant,
  );
}

_BadgeTokens _badgeTokens(ColorScheme colorScheme, KinlyOpacity opacities) {
  final bg = colorScheme.primary.withValues(alpha: opacities.alphaMD);
  final errorBg = colorScheme.error.withValues(alpha: opacities.alphaMD);
  return _BadgeTokens(
    bg: bg,
    fg: colorScheme.primary,
    errorBg: errorBg,
    errorFg: colorScheme.error,
  );
}

Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;

Color _pickOnColor({
  required Color background,
  required Color preferred,
  double threshold = 4.5,
}) {
  final onBackground =
      background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  final contrast = _contrastRatio(preferred, background);
  return contrast >= threshold ? preferred : onBackground;
}

double _contrastRatio(Color foreground, Color background) {
  final l1 = foreground.computeLuminance();
  final l2 = background.computeLuminance();
  final light = math.max(l1, l2);
  final dark = math.min(l1, l2);
  return (light + 0.05) / (dark + 0.05);
}

