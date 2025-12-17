import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_sections.dart';
import '../../theme/kinly_palette.dart';

/// Kinly-themed expand/collapse badge used for rows with optional details.
class KinlyExpandBadge extends StatelessWidget {
  const KinlyExpandBadge({
    super.key,
    required this.isExpanded,
    required this.colors,
  });

  final bool isExpanded;
  final SectionColors colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;
    final iconColor = controls.expandBadgeIcon;
    final background = controls.expandBadgeBg;

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
