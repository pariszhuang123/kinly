import 'package:flutter/material.dart';

/// Reusable Kinly-styled checkbox toggle, e.g. "Share to wall".
///
/// Visibility can be controlled via [visible], so you can keep
/// gating logic (mood/comment conditions) in the feature layer.
class KinlyToggle extends StatelessWidget {
  const KinlyToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.visible = true,
    this.isDarkOverride,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? subtitle;
  final bool visible;

  /// Optional override for dark mode styling;
  /// falls back to Theme.of(context).brightness when null.
  final bool? isDarkOverride;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = isDarkOverride ?? theme.brightness == Brightness.dark;

    final titleStyle = theme.textTheme.bodyLarge?.copyWith(
      color: colors.onSurface,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isDark ? colors.onSurfaceVariant : colors.onSurfaceVariant,
    );

    return CheckboxListTile(
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      title: Text(title, style: titleStyle),
      subtitle: subtitle != null ? Text(subtitle!, style: subtitleStyle) : null,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: colors.primary,
    );
  }
}
