import 'package:flutter/material.dart';

import '../../theme/kinly_sections.dart';

/// Kinly-themed expand/collapse badge used for rows with optional details.
class KinlyExpandBadge extends StatelessWidget {
  const KinlyExpandBadge({
    super.key,
    required this.isExpanded,
    required this.colors,
    this.isDarkOverride,
  });

  final bool isExpanded;
  final SectionColors colors;
  final bool? isDarkOverride;

  @override
  Widget build(BuildContext context) {
    final isDark =
        isDarkOverride ?? Theme.of(context).brightness == Brightness.dark;
    final iconColor =
        isDark ? Theme.of(context).colorScheme.onSurface : colors.icon;
    final background = colors.accent.withValues(alpha: isDark ? 0.16 : 0.12);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
        child: Icon(
          isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
          size: 22,
          color: iconColor,
        ),
      ),
    );
  }
}
