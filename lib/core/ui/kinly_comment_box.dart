import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// Reusable Kinly-styled multiline comment box.
///
/// - Adapts to light/dark using ThemeData by default.
/// - Optional [isDarkOverride] lets you force a variant if needed
///   (e.g. dark card on light background).
class KinlyCommentBox extends StatelessWidget {
  const KinlyCommentBox({
    super.key,
    required this.label,
    this.hint,
    this.maxLines = 4,
    this.maxLength = 500,
    required this.onChanged,
    this.enabled = true,
    this.isDarkOverride,
  });

  final String label;
  final String? hint;
  final int maxLines;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final bool enabled;

  /// If provided, overrides ThemeData.brightness.
  /// If null, brightness comes from Theme.of(context).
  final bool? isDarkOverride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colors = theme.colorScheme;
    final isDark = isDarkOverride ?? theme.brightness == Brightness.dark;

    final fillColor =
        isDark ? colors.surfaceContainerHigh : colors.surfaceContainerLowest;

    return TextField(
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsetsDirectional.fromSTEB(
          spacing.md,
          spacing.md,
          spacing.md,
          spacing.md,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}
