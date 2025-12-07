import 'package:flutter/material.dart';
import 'kinly_checkbox.dart';

/// Kinly-styled toggle row: checkbox + title + optional subtitle.
/// Design-system "molecule" built on top of KinlyCheckbox.
///
/// Use for settings, sharing options, mood screens, etc.
class KinlyToggle extends StatelessWidget {
  const KinlyToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.visible = true,
    this.isDarkOverride,
    this.semanticsLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? subtitle;
  final bool visible;

  /// Optional override for dark mode styling.
  final bool? isDarkOverride;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final titleStyle = theme.textTheme.bodyLarge?.copyWith(
      color: colors.onSurface,
    );

    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    final toggleRow = InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KinlyCheckbox(
              value: value,
              onChanged: onChanged,
              isDarkOverride: isDarkOverride,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle),
                  if (subtitle != null) Text(subtitle!, style: subtitleStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      enabled: true,
      toggled: value,
      label: semanticsLabel ?? title,
      child: toggleRow,
    );
  }
}
