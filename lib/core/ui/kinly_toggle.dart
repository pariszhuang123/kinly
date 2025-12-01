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

    // Align dark / light detection with KinlyFilledButton.
    final isDark = isDarkOverride ?? theme.brightness == Brightness.dark;

    // ---- COLOR LOGIC (aligned with KinlyFilledButton) ----
    // Light: primary / onPrimary
    // Dark:  secondaryContainer / onInverseSurface
    final Color activeColor;
    final Color checkColor;

    if (isDark) {
      activeColor = colors.secondaryContainer;
      checkColor = colors.onInverseSurface;
    } else {
      activeColor = colors.primary;
      checkColor = colors.onPrimary;
    }

    final titleStyle = theme.textTheme.bodyLarge?.copyWith(
      color: colors.onSurface,
    );

    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      // Keep this onSurfaceVariant in both modes so it’s a softer, secondary label.
      color: colors.onSurfaceVariant,
    );

    return CheckboxListTile(
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      title: Text(title, style: titleStyle),
      subtitle: subtitle != null ? Text(subtitle!, style: subtitleStyle) : null,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,

      // 🔽 Make it visually tighter so it doesn’t add a big vertical gap.
      visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
